local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

modkey = "Mod1"
altmod = "Mod4"

-- menu
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end)
))

globalkeys = gears.table.join(
    awful.key(
        { modkey, },
        "s",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    awful.key(
        { modkey, },
        "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),
    awful.key(
        { modkey, },
        "j",
        function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key(
        { modkey, },
        "l",
        function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key(
        { modkey, },
        "k",
        function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key(
        { modkey, },
        "h",
        function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key(
        { modkey, },
        "w",
        function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }
    ),

    -- Layout manipulation
    awful.key(
        { modkey, "Shift" },
        "j",
        function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "layout" }
    ),
    awful.key(
        { modkey, "Shift" },
        "k",
        function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "layout" }
    ),
    awful.key(
        { modkey, "Shift" },
        "l",
        function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "layout" }
    ),
    awful.key(
        { modkey, "Shift" },
        "h",
        function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "layout" }
    ),
    awful.key(
        { modkey, },
        "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),
    awful.key(
        { modkey, },
        "=",
        function()
            awful.tag.incmwfact(0.01)
        end,
        { description = "grow window in tiling direction", group = "layout" }
    ),
    awful.key(
        { modkey, },
        "-",
        function()
            awful.tag.incmwfact(-0.01)
        end,
        { description = "shrink window in tiling direction", group = "layout" }
    ),
    awful.key(
        { altmod, },
        "=",
        function()
            awful.client.incwfact(0.05)
        end,
        { description = "grow window perpendicular to tiling direction", group = "layout" }
    ),
    awful.key(
        { altmod, },
        "-",
        function()
            awful.client.incwfact(-0.05)
        end,
        { description = "shrink window perpendicular to tiling direction", group = "layout" }
    ),

    -- Standard program
    awful.key(
        { modkey, "Shift" },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key(
        { modkey, "Shift" },
        "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),
    awful.key({ modkey, },
        "space",
        function() awful.layout.inc(1) end,
        { description = "select next layout", group = "layout" }
    ),

    -- Prompt
    awful.key({ modkey, },
        "r",
        function() awful.spawn("rofi -show run") end,
        { description = "run prompt for shell commands", group = "launcher" }
    ),
    awful.key({ altmod, },
        "r",
        function() awful.spawn("rofi -show drun") end,
        { description = "run prompt for desktop apps", group = "launcher" }
    ),
    awful.key({ altmod, },
        "space",
        function() awful.spawn("rofi -show drun") end,
        { description = "run prompt for desktop apps", group = "launcher" }
    ),
    awful.key(
        { modkey, },
        "Tab",
        function() awful.spawn("rofi -show window") end,
        { description = "show windows", group = "rofi" }
    ),
    awful.key(
        { altmod, "Shift" },
        "s",
        function()
            require("naughty").notify({ title = "Shotgun", text = "Taking Screenshot" })
            awful.spawn("shotgun")
        end,
        { description = "take a screen shot with shotgun", group = "launcher" }
    ),
    awful.key(
        { altmod, },
        "1",
        function() awful.spawn("brave --profile-directory=Default") end,
        { description = "launch brave personal", group = "launcher" }
    ),
    awful.key(
        { altmod, },
        "2",
        function() awful.spawn("brave --profile-directory=TAMU") end,
        { description = "launch brave school", group = "launcher" }
    ),
    awful.key(
        { altmod, },
        "3",
        function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),
    awful.key(
        { altmod, },
        "4",
        function() awful.spawn("obsidian") end,
        { description = "start obsidian", group = "launcher" }
    ),
    awful.key(
        { altmod, },
        "5",
        function() awful.spawn("discord") end,
        { description = "start discord", group = "launcher" }
    ),
    awful.key(
        { altmod, },
        "6",
        function() awful.spawn("spotify-launcher") end,
        { description = "start spotify", group = "launcher" }
    ),
    awful.key(
        { altmod, },
        "e",
        function() awful.spawn("thunar") end,
        { description = "start thunar", group = "launcher" }
    ),

    -- media
    awful.key(
        {},
        "XF86AudioRaiseVolume",
        function()
            awful.spawn.easy_async_with_shell("pacmd list-sinks | grep '*' | awk '{print $3}'", function(s)
                local sink = s:gsub("%s+", "")
                awful.spawn(string.format("pactl set-sink-volume %s +5%%", sink))
                beautiful.soundbar_widget.update()
            end)
        end,
        { description = "raise volume", group = "media" }
    ),
    awful.key(
        {},
        "XF86AudioLowerVolume",
        function()
            awful.spawn.easy_async_with_shell("pacmd list-sinks | grep '*' | awk '{print $3}'", function(s)
                local sink = s:gsub("%s+", "")
                awful.spawn(string.format("pactl set-sink-volume %s -5%%", sink))
                beautiful.soundbar_widget.update()
            end)
        end,
        { description = "lower volume", group = "media" }
    ),
    awful.key(
        {},
        "XF86AudioMute",
        function()
            awful.spawn.easy_async_with_shell("pacmd list-sinks | grep '*' | awk '{print $3}'", function(s)
                local sink = s:gsub("%s+", "")
                awful.spawn(string.format("pactl set-sink-mute %s toggle", sink))
                beautiful.soundbar_widget.update()
            end)
        end,
        { description = "mute volume", group = "media" }
    ),
    awful.key(
        {},
        "XF86AudioPlay",
        function()
            awful.spawn("playerctl play-pause")
        end,
        { description = "toggle play/pause", group = "media" }
    ),
    awful.key(
        {},
        "XF86AudioNext",
        function()
            awful.spawn("playerctl next")
        end,
        { description = "skip to next media", group = "media" }
    ),
    awful.key(
        {},
        "XF86AudioPrev",
        function()
            awful.spawn("playerctl previous")
        end,
        { description = "rewind to previous media", group = "media" }
    )
)

clientkeys = gears.table.join(
    awful.key(
        { modkey, "Shift", },
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key(
        { modkey, "Shift", },
        "c",
        function(c) c:kill() end,
        { description = "close", group = "client" }
    ),
    awful.key(
        { modkey, "Shift", },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey, },
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }
    ),
    awful.key(
        { modkey, },
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key(
            { modkey },
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),
        -- Move client to tag.
        awful.key(
            { modkey, "Shift" },
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        tag:view_only()
                    end
                end
            end,
            { description = "move focused client to tag # and view" .. i, group = "tag" }
        )
    )
end

clientbuttons = gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end
    ),
    awful.button(
        { modkey },
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        { modkey },
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)
