-- ██████╗ ██╗   ██╗██╗     ███████╗███████╗
-- ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
-- ██████╔╝██║   ██║██║     █████╗  ███████╗
-- ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
-- ██║  ██║╚██████╔╝███████╗███████╗███████║
-- ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}

-- ===================================================================
-- Rules
-- ===================================================================

function rules.create(clientkeys, clientbuttons)
    return {
        -- =========================================================
        -- ==================== GENERAL RULE =======================
        -- =========================================================
        {
            id = "global",
            rule = {},
            properties = {
                switchtotag = true,
                titlebars_enabled = beautiful.titlebars_enabled,
                border_width = beautiful.border_width,
                border_color = beautiful.border_accent,
                focus = awful.client.focus.filter,
                raise = true,
                keys = clientkeys,
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered
            },
        },
        -- =========================================================
        -- ================== floating Clients =====================
        -- =========================================================
        {
            rule_any = {
                type = {},
                class = {
                    "Caffeine",
                    "Veracrypt",
                    "GtkFileChooserDialog"
                },
                name = {
                    "Open File",
                    "Save File",
                    "Preferences"
                },
                role = {
                },
                instance = {
                    "nm-connection-editor",
                    "lxappearance",
                    "Pavucontrol"
                }
            },
            properties = {
                titlebars_enabled = true,
                maximized = false,
                floating = true,
                skip_decoration = true,
                above = true,
                placement = awful.placement.no_offscreen + awful.placement.centered
            }
        },
        -- =========================================================
        -- ======================= Dialogs =========================
        -- =========================================================
        {
            rule_any = {
                type = {
                    "modal",
                    "dialog"
                },
                class = {
                    "Wicd-client.py",
                    "calendar.google.com"
                },
                name = {
                    "Friends List"
                },
                role = {
                    "pop-up"
                },
                instance = {
                    "file_progress",
                    "Popup"
                }
            },
            properties = {
                titlebars_enabled = false,
                focus = true,
                maximized = false,
                floating = true,
                modal = true,
                above = true,
                skip_decoration = true,
                skip_taskbar = true,
                placement = awful.placement.centered
            }
        },
        -- =========================================================
        -- ============ FLOATING WITH TITLES DISABLED ==============
        -- =========================================================
        {
            rule_any = {
                instance = {},
                class = {
                    "File-roller",
                    "feh",
                    "Emote"
                },
                name = {
                    "Steam Guard - Computer Authorization Required",
                    "Steam Guard"
                }
            },
            properties = {
                titlebars_enabled = false,
                maximized = false,
                floating = true,
                skip_decoration = true,
                above = true,
                placement = awful.placement.centered
            },
        },
        -- =========================================================
        -- ============ Titles Disabled Non Floating ===============
        -- =========================================================
        {
            rule_any = {
                instance = {},
                class = {
                    "Nautilus",
                    "code-oss",
                    "gedit",
                    "Eog"
                },
                name = {}
            },
            properties = {
                titlebars_enabled = false,
            },
        },
        -- =========================================================
        -- ====================== BROWSERS =========================
        -- =========================================================
        {
            id = "web_browsers",
            rule_any = {
                class = {
                    "firefox",
                    "Tor Browser",
                    "Chromium",
                    "Google-chrome"
                }
            },
            properties = {
                screen = awful.screen.preferred,
                keys = clientkeys,
                buttons = clientbuttons
            }
        },
        -- =========================================================
        -- ======================== GAMES ==========================
        -- =========================================================
        {
            rule_any = {
                class = {
                    "Wine",
                    "dolphin-emu",
                    "Lutris",
                    "Citra"
                },
                name = {
                    "GOG Galaxy",
                    "Steam"
                }
            },
            except_any = {
                name = {
                    "- Steam",
                    "Steam Guard"
                }
            },
            properties = {
                tag = "game",
                screen = 1,
                ontop = true,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered
            }
        },
        -- =========================================================
        -- ==================== Terminal Tag =======================
        -- =========================================================

        {
            id = "terminals",
            rule_any = {
                class = {
                    "URxvt",
                    "XTerm",
                    "UXTerm",
                    "kitty",
                    "K3rmit",
                    "Terminator",
                    "Alacritty",
                    "Wezterm"
                }
            },
            except_any = {
                instance = {"QuakeTerminal"}
            },
            properties = {
                titlebars_enabled = false,
                size_hints_honor = false
            }
        },
        -- =========================================================
        -- ===================== FIXED SIZE ========================
        -- =========================================================
        {
            rule_any = {
                class = {},
                name = {
                    "Volume Control",
                    "System Monitor"
                }
            },
            properties = {
                maximized = false,
                floating = true,
                above = true,
                skip_decoration = true,
                titlebars_enabled = true,
                placement = awful.placement.centered,
                width = screen_width * 0.4,
                height = screen_height * 0.55
            }
        },
        -- =========================================================
        -- ======================== Conky ==========================
        -- =========================================================
        {
            rule_any = {
                class = {
                    "Conky"
                }
            },
            properties = {
                ontop = false,
                floating = true,
                skip_taskbar = true,
                below = true,
                fullscreen = true,
                focusable = false,
                titlebars_enabled = false,
                screen = 1,
                placement = awful.placement.no_offscreen + awful.placement.centered
            }
        }
    }
end
-- return module table
return rules
