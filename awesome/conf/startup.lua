local awful = require("awful")

awful.spawn.with_shell("picom -b")
awful.spawn.with_shell("nitrogen --restore")
