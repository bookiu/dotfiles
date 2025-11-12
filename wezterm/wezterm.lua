local wezterm = require("wezterm")
local utils = require("utils")
local mouse = require("mouse")
local gpus = wezterm.gui.enumerate_gpus()
-- require("on")
local tabbar = require("tabbar")

local act = wezterm.action
local is_linux = wezterm.target_triple == "x86_64-unknown-linux-gnu"
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"
local is_mac = wezterm.target_triple == "x86_64-apple-darwin"

-- /etc/ssh/sshd_config
-- AcceptEnv TERM_PROGRAM_VERSION COLORTERM TERM TERM_PROGRAM WEZTERM_REMOTE_PANE
-- sudo systemctl reload sshd

---------------------------------------------------------------
--- functions
---------------------------------------------------------------
-- selene: allow(unused_variable)
---@diagnostic disable-next-line: unused-function, unused-local
local function enable_wayland()
    local wayland = os.getenv("XDG_SESSION_TYPE")
    if wayland == "wayland" then
        return true
    end
    return false
end

---------------------------------------------------------------
--- Merge the Config
---------------------------------------------------------------
local function create_ssh_domain_from_ssh_config(ssh_domains)
    if ssh_domains == nil then
        ssh_domains = {}
    end
    for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
        table.insert(ssh_domains, {
            name = host,
            remote_address = config.hostname .. ":" .. config.port,
            username = config.user,
            multiplexing = "None",
            assume_shell = "Posix",
        })
    end
    return { ssh_domains = ssh_domains }
end

--- load local_config
-- Write settings you don't want to make public, such as ssh_domains
package.path = os.getenv("HOME") .. "/.local/share/wezterm/?.lua;" .. package.path
local function load_local_config(module)
    local m = package.searchpath(module, package.path)
    if m == nil then
        return {}
    end
    return dofile(m)
    -- local ok, _ = pcall(require, "local")
    -- if not ok then
    -- 	return {}
    -- end
    -- return require("local")
end

local local_config = load_local_config("local")
local hotkey_bindings = {
    {
        key = "p",
        mods = "CMD",
        action = wezterm.action.ShowLauncher,
    },
    -- rename tab name
    {
        key = 'R',
        mods = 'CMD|SHIFT',
        action = act.PromptInputLine {
          description = 'Enter new name for tab',
          action = wezterm.action_callback(function(window, _, line)
            -- line will be `nil` if they hit escape without entering anything
            -- An empty string if they just hit enter
            -- Or the actual line of text they wrote
            if line then
              window:active_tab():set_title(line)
            end
          end),
        },
    },
    -- open config
    {
        key = ',',
        mods = 'CMD',
        action = act.SpawnCommandInNewTab {
          cwd = os.getenv('WEZTERM_CONFIG_DIR'),
          set_environment_variables = {
            TERM = 'screen-256color',
          },
          args = {
            'vim',
            os.getenv('WEZTERM_CONFIG_FILE'),
          },
        },
    },
    { 
        key = '{', 
        mods = 'SHIFT|ALT', 
        action = act.MoveTabRelative(-1),
    },
    {
        key = '}',
        mods = 'SHIFT|ALT',
        action = act.MoveTabRelative(1),
    },
}

local config = {
    check_for_updates = false,

    -- editor
    font = wezterm.font("FiraMono Nerd Font Mono", {
        weight = "Regular",
        stretch = "Normal",
        style = "Normal",
    }),
    font_size = 17,
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
    --color_scheme = "Dracula (Official)",
    color_scheme = "nordfox",
    color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
    selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%（）《》",

    cursor_blink_ease_in = "Linear",
    cursor_blink_ease_out = "Linear",
    cursor_blink_rate = 1000,

    enable_scroll_bar = true,
    -- window_decorations = "RESIZE",

    hyperlink_rules = {
        -- Matches: a URL in parens: (URL)
        {
            regex = '\\((\\w+://\\S+)\\)',
            format = '$1',
            highlight = 1,
        },
        -- Matches: a URL in brackets: [URL]
        {
            regex = '\\[(\\w+://\\S+)\\]',
            format = '$1',
            highlight = 1,
        },
        -- Matches: a URL in curly braces: {URL}
        {
            regex = '\\{(\\w+://\\S+)\\}',
            format = '$1',
            highlight = 1,
        },
        -- Matches: a URL in angle brackets: <URL>
        {
            regex = '<(\\w+://\\S+)>',
            format = '$1',
            highlight = 1,
        },
        -- Then handle URLs not wrapped in brackets
        {
            -- Before
            --regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
            --format = '$0',
            -- After
            regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
            format = '$1',
            highlight = 1,
        },
        -- implicit mailto link
        {
            regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
            format = 'mailto:$0',
        },
    },

    -- window
    window_background_opacity = 0.95,
    macos_window_background_blur = 50,
    -- window_background_image = wezterm.relative_path("background.jpg"),
    -- window_background_image_hsb =
    -- window_background_gradient = {},
    window_padding = {
        left = 0,
        right = 0,
        top = 2,
        bottom = 2,
    },
    exit_behavior = "CloseOnCleanExit",
    window_close_confirmation = "AlwaysPrompt",
    adjust_window_size_when_changing_font_size = false,

    launch_menu = {},

    -- https://github.com/wez/wezterm/issues/2756
    webgpu_preferred_adapter = gpus[1],
    front_end = "WebGpu",

    use_ime = true,
}

-- mouse and key
config.mouse_bindings = mouse.mouse_bindings
config.keys = hotkey_bindings

-- bytedance
table.insert(config.launch_menu, { label = "DevBox.Personal", args = { "ssh", "devbox" } })

-- mac specific config
if is_mac then
    config.default_prog = { "zsh", "-l" }
    config.native_macos_fullscreen_mode = false
    -- config.macos_window_background_blur = 20
end

-- windows specific config
if is_windows then
    config.default_domain = "WSL:Debian"
    config.default_prog = { "wsl.exe" }

    local wsl_domains = wezterm.default_wsl_domains()
    for _, dom in ipairs(wsl_domains) do
        dom.default_cwd = "~"
    end
    --config.default_cwd = "\\\\wsl$\\Arch\\home\\yaxin"

    table.insert(config.launch_menu, { label = "Powershell 7", args = { "C:/Program Files/PowerShell/7/pwsh.exe" } })
end

-- linux specific config
if is_linux then
    config.default_prog = { "zsh", "-l" }
end

-- merge local config
local merged_config = utils.merge_tables(
    tabbar,
    utils.merge_tables(config, local_config)
)

return utils.merge_tables(merged_config, create_ssh_domain_from_ssh_config(merged_config.ssh_domains))
