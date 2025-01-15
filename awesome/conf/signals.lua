local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  -- on startup give rounded corners
  c.shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 10)
  end
end)

-- when fullscreen property switches on a client assign proper shape
client.connect_signal("property::fullscreen",
  function(c)
    if c.fullscreen then
      c.shape = function(cr, w, h) gears.shape.rectangle(cr, w, h) end
    else
      c.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 10) end
    end
  end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awesome.connect_signal("exit", function(reason_restart)
  -- playerctl lingers so we have to kill it whenever we restart to not have
  -- dead children processes whenever the next loads currently_playing widget
  -- loads
  -- see base_widgets/current_audio_widget
  awful.spawn("pkill playerctl")
end)
-- }}}
