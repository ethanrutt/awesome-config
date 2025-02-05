local awful = require("awful")
require("awful.autofocus")

terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

awful.layout.layouts = { awful.layout.suit.tile.right, awful.layout.suit.tile.bottom, }
