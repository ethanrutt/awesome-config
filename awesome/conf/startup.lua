local awful = require("awful")

awful.spawn("picom -b")
awful.spawn("nitrogen --restore")
awful.spawn("fcitx -d")
awful.spawn("playerctld daemon")
