local wezterm = require("wezterm")

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider


function tab_title(tab_info)
    local index = tab.tab_index + 1
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
      return index .. ": " .. title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return index .. ": " .. tab_info.active_pane.title
end

-- tab style
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    -- inactive
    local tab_bgcolor = "#151515"
    local font_color = "#5b5b5b"

    if tab.is_active then
      background = '#222222'
      foreground = '#c4c4c4'
    elseif hover then
      background = '#2f2f2f'
      foreground = '#c4c4c4'
    end

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
        { Background = { Color = tab_bgcolor } },
        { Foreground = { Color = font_color } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = tab_bgcolor } },
        { Foreground = { Color = font_color } },
        { Text = title },
        { Background = { Color = tab_bgcolor } },
        { Foreground = { Color = font_color } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)


wezterm.on("update-right-status", function(window)
    local date = wezterm.strftime("%Y-%m-%d %H:%M:%S ")
    window:set_right_status(wezterm.format({
        -- { Background = { Color = "" } },
        { Foreground = { Color = "grey" } },
        { Text = date },
    }))
end)


local M = {
    tab_bar_at_bottom = false,
    use_fancy_tab_bar = true,
    tab_max_width = 25,
    hide_tab_bar_if_only_one_tab = false,
    show_new_tab_button_in_tab_bar = true,
    window_frame = {
        font = wezterm.font {
            family = "FiraMono Nerd Font Mono",
            -- weight = "Bold",
        },
        font_size = 17.0,
    },
}

return M
