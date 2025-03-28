local create = function(bg, shape, margin, font)
    local currently_playing = require("base_widgets.current_audio_widget")({
        settings = function()
            local status = ""
            if cp_metadata.status == "Playing" then
                status = " "
            else
                status = " "
            end

            local player = ""
            if cp_metadata.player == "firefox" then
                player = " "
            elseif cp_metadata.player == "spotify" then
                player = " "
            elseif cp_metadata.player == "vlc" then
                player = "󰕼 "
            else
                player = " "
            end

            local media = "no media playing"
            if cp_metadata.artist_and_track ~= "" then
                media = cp_metadata.artist_and_track
            end

            widget.text = " " .. status .. " " .. player .. " " .. media .. " "
        end
    })

    currently_playing.widget.font = font

    local widget = require("utils.widget_utils").create_widget(
        currently_playing.widget,
        bg,
        shape,
        margin
    )

    return widget
end

return create
