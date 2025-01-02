--[[

    Base took from lain awesomewm widgets

--]]

local helpers = require("lain.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string
local type    = type

local function factory(args)
    args                    = args or {}

    local currently_playing = { widget = args.widget or wibox.widget.textbox() }
    local timeout           = args.timeout or 5
    local settings          = args.settings or function() end

    currently_playing.cmd   = "playerctl metadata --format '{{status}} {{playerName}} {{artist}} : {{title}}'"

    function currently_playing.update()
        helpers.async({ shell, "-c", currently_playing.cmd },
            function(s)
                cp_metadata = {}
                local words = {}
                for word in s:gmatch("%S+") do
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
                    cp_metadata.artist_and_track = table.concat(words, " ", 3):gsub("%%", "")
                else
                    cp_metadata.artist_and_track = ""
                end

                widget = currently_playing.widget

                settings()
            end)
    end

    helpers.newtimer("currently_playing", timeout, currently_playing.update)

    return currently_playing
end

return factory
