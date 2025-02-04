local awful = require("awful")
local utils = require("utils.widget_utils")

-- access update function by doing
-- `beautiful.<widget>.update()`
local create = function(bg, selected_bg, shape, margin, font)
    local soundbar = require("base_widgets.pulse")({
        settings = function()
            local vlevel = ""
            local number_string = string.gsub(volume_now.left, "%%", "")
            local vol = tonumber(number_string)

            if volume_now.muted == "yes" or vol == nil then
                vlevel = "  "
            elseif vol < 33 then
                vlevel = "  "
            elseif vol < 66 then
                vlevel = "  "
            else
                vlevel = "  "
            end

            widget.text = vlevel
        end
    })
    soundbar.widget.font = font
    soundbar.widget:buttons(awful.util.table.join(
        awful.button(
            {},
            1, -- left click
            function() awful.spawn("pavucontrol") end
        ),
        awful.button(
            {},
            2, -- middle click
            function()
                awful.spawn(string.format("pactl set-sink-volume %s 100%%", soundbar.device))
                soundbar.update()
            end
        ),
        awful.button(
            {},
            3, -- right click
            function()
                awful.spawn(string.format("pactl set-sink-mute %s toggle", soundbar.device))
                soundbar.update()
            end
        ),
        awful.button(
            {},
            4, -- scroll up
            function()
                awful.spawn(string.format("pactl set-sink-volume %s +1%%", soundbar.device))
                soundbar.update()
            end
        ),
        awful.button(
            {},
            5, -- scroll down
            function()
                awful.spawn(string.format("pactl set-sink-volume %s -1%%", soundbar.device))
                soundbar.update()
            end
        )
    ))
    local soundbar_bg = utils.create_bg_widget(
        soundbar,
        bg,
        shape
    )
    soundbar_bg:connect_signal("mouse::enter", function(c) c:set_bg(selected_bg) end)
    soundbar_bg:connect_signal("mouse::leave", function(c) c:set_bg(bg) end)
    local widget = utils.create_margin_widget(soundbar_bg, margin)

    -- easy way to access update function for when we do keybinds
    widget.update = soundbar.update

    return widget
end

return create
