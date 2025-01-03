-- access update function by doing
-- `beautiful.<widget>.update()`
local create = function(bg, shape, margin)
    local currently_playing = require("base_widgets.current_audio_widget")({
        settings = function()
            local status = ""
            if cp_metadata.status == "Playing" then
                status = "  "
            else
                status = "  "
            end

            local player = ""
            if cp_metadata.player == "firefox" then
                player = "   "
            elseif cp_metadata.player == "spotify" then
                player = "    "
            elseif cp_metadata.player == "vlc" then
                player = " 󰕼  "
            else
                player = "   "
            end

            widget.text = status .. player .. cp_metadata.artist_and_track
        end
    })

    local widget = require("utils.widget_utils").create_widget(
        currently_playing.widget,
        bg,
        shape,
        margin
    )

    -- easy way to access update function for when we do keybinds
    widget.update = currently_playing.update

    return widget
end

return create
