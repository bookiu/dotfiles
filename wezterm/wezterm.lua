local wezterm = require 'wezterm';

return {
    font = wezterm.font("FiraCode NF", {weight=420, stretch="Normal", style=Normal}),
    font_size = 13,
    color_scheme = "MaterialOcean",
    launch_menu = {
        {
            label = "Powershell",
            args = {"powershell.exe"},
        }
    }
}
