local utils = require("widget_utils")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")

local arch_blue = "#1793d0"
local mint_green = "#daffed"
local purple = "#d88aff"
local black = "#242c2e"
local white = "#dddddd"


local theme = {}

theme.default_bg = white
theme.selected_bg = arch_blue
theme.large_widget_bg = white

theme.font = "AgaveNerdFont 10"

theme.bg_normal = white
theme.bg_focus = arch_blue
theme.bg_subtle = mint_green
theme.bg_urgent = purple
theme.bg_minimize = arch_blue
theme.bg_dark = arch_blue
theme.bg_systray = arch_blue

theme.fg_normal = black
theme.fg_focus = white
theme.fg_urgent = white
theme.fg_minimize = white

theme.useless_gap = 5
theme.border_width = dpi(3)
theme.border_focus = mint_green
theme.border_normal = purple
theme.border_marked = purple

theme.wibar_bg = black

theme.taglist_font = "AgaveNerdFont 10"
theme.taglist_fg_focus = white
theme.taglist_fg_normal = black
theme.taglist_bg_focus = arch_blue
theme.taglist_bg_urgent = purple
theme.taglist_bg_empty = white
theme.taglist_bg_occupied = white
theme.taglist_spacing = 2
theme.taglist_shape = gears.shape.circle

theme.margin_size = 4

theme.menu_height = dpi(16)
theme.menu_width = dpi(130)

theme.widget_spacing = dpi(200)

theme.space = wibox.widget {
    spacing        = theme.widget_spacing,
    spacing_widget = wibox.widget.separator,
    layout         = wibox.layout.fixed.horizontal
}

local tc = wibox.widget.textclock("   %a %b %d   %I:%M %p ")
tc.font = theme.font
tc.valign = "center"
tc.align = "center"
theme.textclock = utils.create_widget(tc, theme.default_bg, gears.shape.rounded_bar, theme.margin_size)

local al = wibox.widget {
    image  = gears.filesystem.get_configuration_dir() .. "icons/" .. "archlinux-icon.svg",
    widget = wibox.widget.imagebox
}
theme.archlogo = utils.create_margin_widget(al, theme.margin_size)

local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup("   | " .. cpu_now.usage .. "% ")
    end
}
cpu.widget.font = theme.font
theme.cpu_usage = utils.create_widget(cpu.widget, theme.default_bg, gears.shape.rectangle, theme.margin_size)

local mem = lain.widget.mem {
    settings = function()
        widget:set_markup("   | " .. mem_now.perc .. "% ")
    end
}
mem.widget.font = theme.font
theme.mem_usage = utils.create_widget(mem.widget, theme.default_bg, gears.shape.rectangle, theme.margin_size)

local soundbar = lain.widget.pulse {
    settings = function()
        local vlevel = ""
        local number_string = string.gsub(volume_now.left, "%%", "")
        local vol = tonumber(number_string)

        if volume_now.muted == "yes" then
            vlevel = "  "
        elseif vol < 50 then
            vlevel = "  "
        else
            vlevel = "  "
        end

        vlevel = vlevel .. " | " .. volume_now.left .. " % "
        widget:set_markup(lain.util.markup(theme.wibar_bg, vlevel))
    end
}
soundbar.widget.font = theme.font
soundbar.widget:buttons(awful.util.table.join(
    awful.button(
        {},
        1, -- left click
        function() awful.spawn("pavucontrol") end
    ),
    awful.button(
        {},
        2, -- middle click
        function()
            os.execute(string.format("pactl set-sink-volume %s 100%%", soundbar.device))
            soundbar.update()
        end
    ),
    awful.button(
        {},
        3, -- right click
        function()
            os.execute(string.format("pactl set-sink-mute %s toggle", soundbar.device))
            soundbar.update()
        end
    ),
    awful.button(
        {},
        4, -- scroll up
        function()
            os.execute(string.format("pactl set-sink-volume %s +1%%", soundbar.device))
            soundbar.update()
        end
    ),
    awful.button(
        {},
        5, -- scroll down
        function()
            os.execute(string.format("pactl set-sink-volume %s -1%%", soundbar.device))
            soundbar.update()
        end
    )
))
local soundbar_bg = wibox.widget({
    soundbar,
    widget = wibox.container.background,
    bg = theme.default_bg,
})
soundbar_bg:connect_signal("mouse::enter", function(c) c:set_bg(theme.selected_bg) end)
soundbar_bg:connect_signal("mouse::leave", function(c) c:set_bg(theme.default_bg) end)
theme.soundbar_widget = utils.create_margin_widget(soundbar_bg, theme.margin_size)

-- systray shape is unable to be changed with the background widget, the
-- background is set in theme.bg_systray
theme.systray = utils.create_margin_widget(wibox.widget.systray(), theme.margin_size)

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end)
)

function theme.at_screen_connect(s)
    -- Each screen has its own tag table.
    awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = theme.wibar_bg,
        height = 35,
    })

    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            theme.archlogo,
            utils.create_margin_widget(s.mytaglist, theme.margin_size)
        },
        {
            layout = wibox.layout.flex.horizontal,
            theme.space,
            theme.textclock,
            theme.space
        },
        {
            layout = wibox.layout.fixed.horizontal,
            theme.cpu_usage,
            theme.mem_usage,
            theme.soundbar_widget,
            theme.systray
        }
    })
end

return theme
