local gears = require("gears")

local celestial_blue = "#1e91d6"
local french_blue = "#0072bb"
local mint_green = "#daffed"
local ice_blue = "#9bf3f0"
local indigo = "#4a0d67"
local black = "#242c2e"
local white = "#dddddd"

local default_gradient = gears.color({
    type = "linear",
    from = { 100, 0 },
    to = { 0, 100 },
    stops = {
        { 0,    white },
        { 0.25, mint_green },
        { 0.5,  celestial_blue },
        { 0.75, indigo },
        { 1,    black },
    },
})


local theme = {}

theme.default_bg = default_gradient
theme.selected_bg = mint_green
theme.large_widget_bg = celestial_blue

theme.font = "Inter 10"
theme.useless_gap = 5
theme.bg_normal = default_gradient
theme.bg_focus = french_blue
theme.bg_subtle = mint_green
theme.bg_urgent = indigo
theme.bg_minimize = french_blue
theme.bg_dark = french_blue
theme.bg_systray = default_gradient

theme.fg_normal = black
theme.fg_focus = black
theme.fg_urgent = black
theme.fg_minimize = black

theme.useless_gap = 5
theme.border_width = 3
theme.border_focus = mint_green
theme.border_normal = ice_blue
theme.border_marked = indigo

theme.wibar_bg = white

theme.taglist_bg_focus = mint_green
theme.taglist_bg_urgent = indigo
theme.taglist_bg_empty = default_gradient
theme.taglist_bg_occupied = default_gradient
theme.taglist_spacing = 2
theme.taglist_shape = gears.shape.rounded_rect

return theme
