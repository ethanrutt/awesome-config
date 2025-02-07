local wibox = require("wibox")
local awful = require("awful")
local utils = require("utils.widget_utils")

local create = function(bg, selected_bg, shape, margin)
    local network_icon = wibox.widget.textbox()

    local net = require("base_widgets.net")({
        notify = "off",
        wifi_state = "on",
        eth_state = "on",
        settings = function()
            local eth = net_now.devices.eth0 or net_now.devices.enp8s0 or nil
            if eth then
                if eth.ethernet then
                    network_icon.text = " 󰛳  "
                    return
                end
            end

            local wlan0 = net_now.devices.wlan0
            if wlan0 == nil or wlan0.wifi == nil then
                network_icon.text = " 󰤮  "
            else
                local signal = wlan0.signal
                if signal == nil then
                    network_icon.text = " 󰤮  "
                elseif signal < -83 then
                    network_icon.text = " 󰤟  "
                elseif signal < -70 then
                    network_icon.text = " 󰤢  "
                elseif signal < -53 then
                    network_icon.text = " 󰤥  "
                elseif signal >= -53 then
                    network_icon.text = " 󰤨  "
                end
            end
        end
    })

    network_icon:buttons(awful.util.table.join(
        awful.button(
            {},
            1,
            function() awful.spawn(terminal .. " -e nmtui") end
        )
    ))

    local net_bg = utils.create_bg_widget(
        network_icon,
        bg,
        shape
    )
    net_bg:connect_signal("mouse::enter", function(c) c:set_bg(selected_bg) end)
    net_bg:connect_signal("mouse::leave", function(c) c:set_bg(bg) end)

    return utils.create_widget(net_bg, margin)
end

return create
