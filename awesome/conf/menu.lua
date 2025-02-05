local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

mymainmenu = awful.menu({
   items = {
      {
         "hotkeys",
         function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
         end
      },
      { "restart", awesome.restart },
      { "quit",    function() awesome.quit() end },
   }
})

menubar.utils.terminal = terminal
