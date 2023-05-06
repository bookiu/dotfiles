local wezterm = require 'wezterm';

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider


local is_linux = wezterm.target_triple == "x86_64-unknown-linux-gnu"
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"
local is_mac = wezterm.target_triple == "x86_64-apple-darwin"

local mouse_bindings = {
    -- 右键粘贴
    {
        event = {Down = {streak = 1, button = "Right"}},
        mods = "NONE",
        action = wezterm.action {PasteFrom = "Clipboard"}
    },
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
        event = {Up = {streak = 1, button = "Left"}},
        mods = "NONE",
        action = wezterm.action {CompleteSelection = "PrimarySelection"}
    },
}

local hotkey_bindings = {
    {
        key = "p",
        mods = "CMD",
        action = wezterm.action.ShowLauncher,
    },
}

local config = {
    -- editor
    --font = wezterm.font_with_fallback({
    --    {family="FiraCode NF", weight="Bold"},
    --    "JetBrains Mono",
    --    "Cascadia Code",
    --    "DejaVu Sans Mono",
    --    "Hack",
    --    "Source Code Pro",
    --    "Monaco",
    --    "Consolas",
    --    "Lucida Console",
    --}),
    font = wezterm.font("FiraCode NF", {weight="Regular", stretch="Normal", style="Normal"}),
    harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
    --font_antialias = "Greyscale",
    font_size = 14,
    check_for_updates = false,
    --color_scheme = "Dracula (Official)",
    color_scheme = "nord",

    -- layout
    tab_bar_at_bottom = false,
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = false,
    -- tab_bar_style = {
    --     active_tab_left = wezterm.format {
    --         { Background = { Color = '#0b0022' } },
    --         { Foreground = { Color = '#2b2042' } },
    --         { Text = SOLID_LEFT_ARROW },
    --     },
    --     active_tab_right = wezterm.format {
    --         { Background = { Color = '#0b0022' } },
    --         { Foreground = { Color = '#2b2042' } },
    --         { Text = SOLID_RIGHT_ARROW },
    --     },
    --     inactive_tab_left = wezterm.format {
    --         { Background = { Color = '#0b0022' } },
    --         { Foreground = { Color = '#1b1032' } },
    --         { Text = SOLID_LEFT_ARROW },
    --     },
    --     inactive_tab_right = wezterm.format {
    --         { Background = { Color = '#0b0022' } },
    --         { Foreground = { Color = '#1b1032' } },
    --         { Text = SOLID_RIGHT_ARROW },
    --     },
    -- },

    -- preferenc
    -- tab
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    colors = colors,

    -- window
    window_background_opacity = 0.9,
    -- window_background_image = wezterm.relative_path("background.jpg"),
    -- window_background_image_hsb =
    -- window_background_gradient = {},
    window_padding = {
        left = '0cell',
        right = '0cell',
        top = '0.5cell',
        bottom = '0.5cell',
    },

    -- hotkey
    keys = hotkey_bindings,
    -- mouse
    mouse_bindings = mouse_bindings,

    launch_menu = {}
}

table.insert(config.launch_menu, { label = "DevCloud.Private", args = {"ssh", "devcloud.private"} })
table.insert(config.launch_menu, { label = "DevCloud.Domain", args = {"ssh", "devcloud.domain"} })
table.insert(config.launch_menu, { label = "DevCloud.Hellerzhang", args = {"ssh", "devcloud.hellerzhang"} })
table.insert(config.launch_menu, { label = "DevCloud.SSL", args = {"ssh", "devcloud.ssl"} })

-- mac specific config
if is_mac then
    config.default_prog = {"zsh", "-l"}
    config.font_size = 17
    config.font = wezterm.font("FiraCode Nerd Font Mono", {weight="Regular", stretch="Normal", style="Normal"})
end

-- windows specific config
if is_windows then
    config.default_domain = "WSL:Debian"
    config.default_prog = {"wsl.exe"}

    local wsl_domains = wezterm.default_wsl_domains()
    for _, dom in ipairs(wsl_domains) do
        dom.default_cwd = "~"
    end
    --config.default_cwd = "\\\\wsl$\\Arch\\home\\yaxin"

    table.insert(config.launch_menu, { label = "Powershell 7", args = {"C:/Program Files/PowerShell/7/pwsh.exe"} })
end

-- linux specific config
if is_linux then
    config.default_prog = {"zsh", "-l"}
end


wezterm.on( "update-right-status", function(window)
    local date = wezterm.strftime("%Y-%m-%d %H:%M:%S ")
    window:set_right_status(
        wezterm.format(
            {
                {Text = date}
            }
        )
    )
end)

return config
