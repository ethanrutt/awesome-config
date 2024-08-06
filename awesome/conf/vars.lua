local awful = require("awful")
require("awful.autofocus")

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.spiral,
    awful.layout.suit.max.fullscreen,
}


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- }}}
--
