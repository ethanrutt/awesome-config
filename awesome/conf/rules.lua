local awful = require("awful")
local beautiful = require("beautiful")

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- fixed size to avoid fingerprinting by size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },

            -- Note that the name property shown in xprop might be set slightly
            -- after creation of the client and the name shown there might not
            -- match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- always floating, small, and centered, mainly for audio / bluetooth
    -- config
    {
        rule_any = {
            instance = { "pavucontrol", "blueman", "nmtui" }
        },
        properties = {
            width = screen_width / 2,
            height = screen_height / 2,
            floating = true,
            x = screen_width / 4,
            y = screen_height / 4
        }
    }
}
