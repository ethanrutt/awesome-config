local wibox = require("wibox")

local utils = {}

function utils.create_bg_widget(_widget, _bg, _shape)
    return wibox.widget({
        _widget,
        widget = wibox.container.background,
        bg = _bg,
        shape = _shape
    })
end

function utils.create_margin_widget(_widget, _margin)
    return wibox.widget({
        _widget,
        widget = wibox.container.margin,
        top = _margin,
        bottom = _margin,
        left = _margin,
        right = _margin,
    })
end

function utils.create_widget(_widget, _bg, _shape, _margin)
    return utils.create_margin_widget(
        utils.create_bg_widget(_widget, _bg, _shape),
        _margin
    )
end

return utils
