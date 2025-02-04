local wibox = require("wibox")
local utils = require("utils.widget_utils")

local create = function(bg, shape, margin)
    local widgets = {}

    local wifi_icon = wibox.widget.textbox()
    local eth_icon = wibox.widget.textbox()

    local net = require("base_widgets.net")({
        notify = "off",
        wifi_state = "on",
        eth_state = "on",
        settings = function()
            local eth = net_now.devices.eth0 or net_now.devices.enp8s0 or nil
            if eth then
                if eth.ethernet then
                    eth_icon.text = "   "
                    eth_icon.visible = true
                    wifi_icon.visible = false
                    return
                else
                    eth_icon.visible = false
                end
            end

            local wlan0 = net_now.devices.wlan0
            if wlan0 then
                if wlan0.wifi then
                    local signal = wlan0.signal
                    if signal == nil then
                        wifi_icon.text = " 󰤮  "
                        wifi_icon.visible = true
                    elseif signal < -83 then
                        wifi_icon.text = " 󰤟  "
                        wifi_icon.visible = true
                    elseif signal < -70 then
                        wifi_icon.text = " 󰤢  "
                        wifi_icon.visible = true
                    elseif signal < -53 then
                        wifi_icon.text = " 󰤥  "
                        wifi_icon.visible = true
                    elseif signal >= -53 then
                        wifi_icon.text = " 󰤨  "
                        wifi_icon.visible = true
                    end
                else
                    wifi_icon.visible = false
                end
            end
        end
    })

    widgets.wifi = utils.create_widget(
        wifi_icon,
        bg,
        shape,
        margin
    )

    widgets.eth = utils.create_widget(
        eth_icon,
        bg,
        shape,
        margin
    )

    return widgets
end

return create
