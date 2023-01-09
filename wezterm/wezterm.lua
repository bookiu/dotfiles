local wezterm = require 'wezterm';

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

colors = {
    foreground = "#f8f8f2",
    background = "#282a36",
    cursor_bg = "#f8f8f2",
    cursor_fg = "#282a36",
    cursor_border = "#f8f8f2",
    selection_fg = "#282a36",
    selection_bg = "#44475a",
    scrollbar_thumb = "#44475a",
    split = "#bd93f9",
    ansi = {"#21222C", "#FF5555", "#50FA7B", "#F1FA8C", "#BD93F9", "#FF79C6", "#8BE9FD", "#F8F8F2"},
    brights = {"#6272A4", "#FF6E6E", "#69FF94", "#FFFFA5", "#D6ACFF", "#FF92DF", "#A4FFFF", "#FFFFFF"},
    indexed = {
        [136] = "#44475A"
    },
    compose_cursor = "#FFB86C",
    tab_bar = {
        background = "#282a36",
        active_tab = {
            bg_color = "#bd93f9",
            fg_color = "#282a36",
            intensity = "Normal",
            underline = "None",
            italic = false,
            strikethrough = false
        },
        inactive_tab = {
            bg_color = "#282a36",
            fg_color = "#f8f8f2"
        },
        inactive_tab_hover = {
            bg_color = "#6272a4",
            fg_color = "#f8f8f2",
            italic = true
        },
        new_tab = {
            bg_color = "#282a36",
            fg_color = "#f8f8f2"
        },
        new_tab_hover = {
            bg_color = "#ff79c6",
            fg_color = "#f8f8f2",
            italic = true
        }
    }
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
    font_antialias = "Greyscale",
    font_size = 13,
    check_for_updates = false,
    color_scheme = "Dracula",

    -- layout
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = false,

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

    -- mouse
    mouse_bindings = mouse_bindings,

    launch_menu = {}
}

local is_linux = wezterm.target_triple == "x86_64-unknown-linux-gnu"
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"
local is_mac = wezterm.target_triple == "x86_64-apple-darwin"

-- mac specific config
if is_mac then
    config.default_prog = {"zsh", "-l"}
    config.font_size = 16
end

-- windows specific config
if is_windows then
    config.default_domain = "WSL:Arch"
    config.default_prog = {"wsl.exe"}

    local wsl_domains = wezterm.default_wsl_domains()
    for _, dom in ipairs(wsl_domains) do
        dom.default_cwd = "~"
    end
    --config.default_cwd = "\\\\wsl$\\Arch\\home\\yaxin"

    table.insert(config.launch_menu, { label = "Powershell 7", args = {"C:/Program Files/PowerShell/7/pwsh.exe"} })
end

-- linux specific config
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
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
