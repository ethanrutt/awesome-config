local awful = require("awful")
local beautiful = require("beautiful")


-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
