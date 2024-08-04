-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local lain = require("lain")

local theme = beautiful.get()

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- 63 char limit for spacing
local quotes = {
    "Accept everything just the way it is",
    "Do not seek pleasure for its own sake",
    "Do not, under any circumstances, depend on a partial feeling",
    "Think lightly of yourself and deeply of the world",
    "Be detached from desire your whole life long",
    "Do not regret what you have done",
    "Never be jealous",
    "Never let yourself be saddened by a separation",
    "Do not let yourself be guided by the feeling of lust or love",
    "In all things have no preferences",
    "Be indifferent to where you live",
    "Do not pursue the taste of good food",
    "Do not hold on to possessions you no longer need",
    "Do not act following customary beliefs",
    "Do not fear death",
    "Do not seek to possess either goods or fiefs for your old age",
    "You may abandon your own body but you must preserve your honour",
    "Never stray from the Way."
}

local function get_random_quote()
    math.randomseed(os.date("*t").sec)
    return quotes[math.random(1, 18)]
end

-- {{{ Wibar
-- Create a textclock widget
textclock = wibox.widget.textclock(" %a %b %d %I:%M %p ")

spacingwidget = wibox.widget {
    spacing        = 10,
    spacing_widget = wibox.widget.separator,
    layout         = wibox.layout.fixed.horizontal
}



screenshotbutton = wibox.widget {
    {
        text = "   ",
        widget = wibox.widget.textbox
    },
    bg = theme.default_bg,
    widget = wibox.container.background,
    shape = gears.shape.rounded_rect
}

screenshotbutton:connect_signal("mouse::enter", function(c) c:set_bg(theme.selected_bg) end)
screenshotbutton:connect_signal("mouse::leave", function(c) c:set_bg(theme.default_bg) end)
screenshotbutton:connect_signal("button::press", function(c, _, _, button)
    awful.spawn.with_shell("shotgun")
end)

archlogo = wibox.widget {
    image  = gears.filesystem.get_configuration_dir() .. "icons/" .. "archlinux-icon.svg",
    widget = wibox.widget.imagebox
}

local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup(" cpu | " .. cpu_now.usage .. "% ")
    end
}

local mem = lain.widget.mem {
    settings = function()
        widget:set_markup(" mem | " .. mem_now.perc .. "% ")
    end
}

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

soundbar.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 2, function() -- middle click
        os.execute(string.format("pactl set-sink-volume %s 100%%", soundbar.device))
        soundbar.update()
    end),
    awful.button({}, 3, function() -- right click
        os.execute(string.format("pactl set-sink-mute %s toggle", soundbar.device))
        soundbar.update()
    end),
    awful.button({}, 4, function() -- scroll up
        os.execute(string.format("pactl set-sink-volume %s +1%%", soundbar.device))
        soundbar.update()
    end),
    awful.button({}, 5, function() -- scroll down
        os.execute(string.format("pactl set-sink-volume %s -1%%", soundbar.device))
        soundbar.update()
    end)
))

soundbar_bg = wibox.widget {
    soundbar,
    widget = wibox.container.background,
    bg = theme.default_bg,
    shape = gears.shape.rounded_rect,
}

soundbar_bg:connect_signal("mouse::enter", function(c) c:set_bg(theme.selected_bg) end)
soundbar_bg:connect_signal("mouse::leave", function(c) c:set_bg(theme.default_bg) end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ " 一 ", " 二 ", " 三 ", " 四 ", " 五 ", " 六 ", " 七 ", " 八 ", " 九 " }, s, awful.layout.layouts[1])

    -- Create a textbox for each screen
    s.mytextbox = wibox.widget {
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        markup = get_random_quote()
    }
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = theme.wibar_bg,
        height = 35,
    })


    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
                archlogo,
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
                left = 6,
                right = 4,
            },
            {
                s.mytaglist,
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
                left = 4,
                right = 4,
            }

        },
        {
            layout = wibox.layout.flex.horizontal,
            spacingwidget,
            {
                {
                    s.mytextbox,
                    bg = theme.large_widget_bg,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
            },
            spacingwidget
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            {
                screenshotbutton,
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
            },
            {
                {
                    cpu.widget,
                    widget = wibox.container.background,
                    bg = theme.default_bg,
                    shape = gears.shape.rounded_rect
                },
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
            },
            {
                {
                    mem.widget,
                    widget = wibox.container.background,
                    bg = theme.default_bg,
                    shape = gears.shape.rounded_rect
                },
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
            },
            {
                soundbar_bg,
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
            },
            {
                {
                    textclock,
                    bg = theme.large_widget_bg,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background
                },
                widget = wibox.container.margin,
                bottom = 4,
                top = 4,
            },
        },
    }
end)
-- }}}
