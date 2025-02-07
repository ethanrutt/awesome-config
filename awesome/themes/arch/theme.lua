local utils = require("utils.widget_utils")
local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local markup = require("utils.markup")

local arch_blue = "#1793d0"
local mint_green = "#daffed"
local purple = "#d88aff"
local black = "#242c2e"
local white = "#dddddd"


local theme = {}

theme.default_bg = black
theme.selected_bg = arch_blue
theme.large_widget_bg = white

theme.font = "HackGen 10"

theme.bg_normal = black
theme.bg_focus = arch_blue
theme.bg_subtle = mint_green
theme.bg_urgent = purple
theme.bg_minimize = arch_blue
theme.bg_dark = arch_blue
theme.bg_systray = black

theme.fg_normal = white
theme.fg_focus = white
theme.fg_urgent = white
theme.fg_minimize = white

theme.useless_gap = 7
theme.border_width = dpi(2)
theme.border_focus = mint_green
theme.border_normal = purple
theme.border_marked = purple

theme.wibar_bg = black

theme.taglist_font = "HackGen 10"
theme.taglist_fg_focus = white
theme.taglist_fg_empty = white
theme.taglist_fg_occupied = white
theme.taglist_bg_focus = arch_blue
theme.taglist_bg_urgent = purple
theme.taglist_bg_empty = black
theme.taglist_bg_occupied = white
theme.taglist_spacing = 2
theme.taglist_shape = gears.shape.arc

theme.margin_size = 4

theme.menu_height = dpi(16)
theme.menu_width = dpi(130)

theme.widget_spacing = dpi(200)

theme.notification_max_height = 100
theme.notification_icon_size = 50

theme.space = wibox.widget({
    widget = wibox.widget.textbox,
    font = theme.font,
})
theme.space:set_markup(markup.color(arch_blue, black, "󱋱"))

local tc = wibox.widget.textclock(" %a %b %d %I:%M %p ")
tc.font = theme.font
theme.textclock = utils.create_widget(
    tc,
    theme.default_bg,
    gears.shape.rectangle,
    theme.margin_size
)

local al = wibox.widget {
    image  = gears.filesystem.get_configuration_dir() .. "icons/" .. "archlinux-icon.svg",
    widget = wibox.widget.imagebox
}
theme.archlogo = utils.create_margin_widget(al, theme.margin_size)

theme.soundbar_widget = require("widgets.soundbar")(
    theme.default_bg,
    theme.selected_bg,
    gears.shape.rectangle,
    theme.margin_size,
    theme.font
)

theme.network = require("widgets.net")(
    theme.default_bg,
    theme.selected_bg,
    gears.shape.rectangle,
    theme.margin_size
)

-- systray shape is unable to be changed with the background widget, the
-- background is set in theme.bg_systray
theme.systray = utils.create_margin_widget(wibox.widget.systray(), theme.margin_size)

theme.currently_playing = require("widgets.currently_playing")(
    theme.default_bg,
    gears.shape.rectangle,
    theme.margin_size,
    theme.font
)

-- local popup = awful.popup {
--     widget = {
--         {
--             {
--                 text   = 'foobar',
--                 widget = wibox.widget.textbox
--             },
--             layout = wibox.layout.fixed.vertical,
--         },
--         margins = 10,
--         widget  = wibox.container.margin
--     },
--     ontop = true,
--     placement    = awful.placement.centered,
--     shape        = gears.shape.rounded_rect,
--     visible      = false,
-- }
--
-- local power = wibox.widget.textbox("power button")
-- power:connect_signal("button::press", function()
--     popup.visible = true
-- end)

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end)
)

function theme.at_screen_connect(s)
    -- Each screen has its own tag table.
    awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

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
            utils.create_margin_widget(s.mytaglist, theme.margin_size),
        },
        {
            layout = wibox.layout.flex.horizontal,
        },
        {
            layout = wibox.layout.fixed.horizontal,
            theme.soundbar_widget,
            theme.space,
            theme.currently_playing,
            theme.space,
            theme.systray,
            theme.space,
            theme.network,
            theme.space,
            theme.textclock,
            -- power
        }
    })
end

return theme
