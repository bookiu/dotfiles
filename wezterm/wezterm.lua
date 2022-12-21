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


local config = {
    -- editor
    -- font = wezterm.wezterm.font_with_fallback({
    --     "FiraCode NF",
    --     "JetBrains Mono",
    --     "Cascadia Code",
    --     "DejaVu Sans Mono",
    --     "Hack",
    --     "Source Code Pro",
    --     "Monaco",
    --     "Consolas",
    --     "Lucida Console",
    -- }),
    font = wezterm.font("FiraCode NF", {weight=420, stretch="Normal", style=Normal}),
    font_size = 13,
    check_for_updates = false,
    color_scheme = "Dracula",

    -- layout
    tab_bar_at_bottom = false,

    -- preferenc
    -- tab
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    colors = {
        tab_bar = {
            inactive_tab_edge = "#575757"
        }
    },

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

-- mac specific config
if wezterm.target_triple == "x86_64-apple-darwin" then
    config.default_prog = {"zsh", "-l"}
end

-- windows specific config
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = {"wsl.exe", "-d", "Arch", "-u", "yaxin"}

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
