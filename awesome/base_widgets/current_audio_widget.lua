local awful = require("awful")
local wibox = require("wibox")

-- for some reason the with_line_callback doesn't like whitespace, so we can't
-- have any whitespace before the song title. This is weird though because it
-- still allows it in the song title, this is why the pipes are there between the fields. I'm not
-- sure exactly what's happening but it works like this

local factory = function(args)
    args = args or {}
    local currently_playing = { widget = args.widget or wibox.widget.textbox() }
    local settings = args.settings or function() end

    awful.spawn.with_line_callback(
        "playerctl metadata --follow --format {{status}}|{{playerName}}|{{artist}}:{{title}}|",
        {
            stdout = function(s)
                local words = {}
                cp_metadata = {}
                for word in s:gmatch("([^|]*)|") do
                    table.insert(words, word)
                end

                if words[1] then
                    cp_metadata.status = words[1]:gsub("%%", "")
                else
                    cp_metadata.status = ""
                end

                if words[2] then
                    cp_metadata.player = words[2]:gsub("%%", "")
                else
                    cp_metadata.player = ""
                end

                if words[3] and words[3] ~= ":" then
                    cp_metadata.artist_and_track = table.concat(words, " ", 3):gsub("%%", ""):gsub(":", " : ")
                else
                    cp_metadata.artist_and_track = ""
                end

                widget = currently_playing.widget

                settings()
            end
        }
    )

    return currently_playing
end

return factory
