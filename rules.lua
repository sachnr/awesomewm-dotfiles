local ruled = require("ruled")
local awful = require("awful")

-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule({
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    })

    -- Floating clients.
    ruled.client.append_rule({
        id = "floating",
        rule_any = {
            instance = {
                "copyq",
                "pinentry",
                "update_installer",
            },
            class = {
                "Blueman-manager",
                "Gpick",
                "Sxiv",
                "Wpa_gui",
                "org.kde.ark",
                "veracrypt",
                "gnome-calculator",
                "pavucontrol",
                "gnome-calendar",
                "gnome-power-statistics",
                "nm-connection-editor",
                "Lxappearance",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
                "Steam Guard",
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
                "GtkFileChooserDialog",
                "dialog",
                "menu",
                "task_dialog",
                "bubble",
                "Preferences",
            },
        },
        properties = { floating = true },
    })

    -- Set Firefox to always map on the tag named "2" on screen 1.
    ruled.client.append_rule({
        rule = { class = "firefox" },
        properties = { tag = " ", switch_to_tags = true },
    })

    ruled.client.append_rule({
        rule = { class = { "krita", "xournalpp" } },
        properties = { tag = " ", switch_to_tags = true },
    })

    ruled.client.append_rule({
        rule = { class = "dolphin" },
        properties = { tag = " ", switch_to_tags = true },
    })

    ruled.client.append_rule({
        rule = { class = "veracrypt" },
        properties = { tag = " ", switch_to_tags = true },
    })
end)
