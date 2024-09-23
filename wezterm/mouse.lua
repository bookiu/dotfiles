local wezterm = require("wezterm")

local act = wezterm.action
local M = {}

M.mouse_bindings = {
    -- copy-on-select
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = act({ CompleteSelection = "PrimarySelection" }),
    },
    -- right click to paste
    {
        event = { Up = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = act({ CompleteSelection = "Clipboard" }),
    },
    -- click to open link
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = "OpenLinkAtMouseCursor",
    },
}

return M
