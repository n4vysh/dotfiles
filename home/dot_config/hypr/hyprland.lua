------------------
---- MONITORS ----
------------------

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "ghostty"
local menu =
    "rofi -show drun -modi drun,calc,run,filebrowser,window, -run-command 'uwsm app -- {cmd}'"
local wobsock = (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/wob.sock"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- hyprpm reload") -- Window manager plugins
    hl.exec_cmd("uwsm app -- fcitx5 --replace -d >/dev/null 2>&1") -- Input Method Framework
    hl.exec_cmd("uwsm app -- brightnessctl set 1") -- Brightness
    hl.exec_cmd("uwsm app -- waybar") -- Status bar
    hl.exec_cmd("uwsm app -- kanshi") -- Dynamic display configuration
    hl.exec_cmd("uwsm app -- swaync") -- Notification daemon
    hl.exec_cmd("uwsm app -- gnome-keyring-daemon --start") -- Keyring
    hl.exec_cmd("uwsm app -- udiskie --automount") -- Mount Helper
    hl.exec_cmd("uwsm app -- tresorit-cli start") -- Cloud Storage

    -- Overlay bar
    -- NOTE: wob systemd integration not working after logout
    -- https://github.com/francma/wob/issues/88
    hl.exec_cmd(
        "rm -f "
            .. wobsock
            .. " && mkfifo "
            .. wobsock
            .. " && tail -f "
            .. wobsock
            .. " | uwsm app -- wob"
    )

    -- Clipboard manager
    --   cliphist:        manage clipboard history
    --   wl-clip-persist: persist copied data before close application
    hl.exec_cmd("uwsm app -- wl-paste --type text --watch cliphist store")
    hl.exec_cmd("uwsm app -- wl-paste --type image --watch cliphist store")
    -- https://github.com/Linus789/wl-clip-persist/issues/3
    -- https://github.com/Linus789/wl-clip-persist/issues/12
    hl.exec_cmd(
        "uwsm app -- wl-clip-persist --reconnect-tries 0 --clipboard regular"
    )

    -- polkit agent
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- NOTE: `systemctl enable` not work, so start user path unit manually
    hl.exec_cmd("systemctl --user start reload-waybar.path")
    hl.exec_cmd("systemctl --user start reload-kanshi.path")
    hl.exec_cmd("systemctl --user start reload-swaync.path")

    hl.exec_cmd("hyprsunset -t 3000") -- Screen shader

    -- NOTE: Set desktop interface for GTK 3
    -- https://wiki.hyprland.org/FAQ/#gtk-settings-no-work--whatever
    hl.exec_cmd(
        [[uwsm app -- gsettings set org.gnome.desktop.interface gtk-theme 'Fluent-Dark']]
    )
    hl.exec_cmd(
        [[uwsm app -- gsettings set org.gnome.desktop.interface icon-theme 'Fluent-dark']]
    )
    hl.exec_cmd(
        [[uwsm app -- gsettings set org.gnome.desktop.interface font-name 'Noto Sans CJK JP 11']]
    )
end)

-----------------------
----- PERMISSIONS -----
-----------------------

hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({
    binary = "/usr/lib/xdg-desktop-portal-hyprland",
    type = "screencopy",
    mode = "allow",
})
hl.permission({
    binary = "/usr/bin/hyprpicker",
    type = "screencopy",
    mode = "allow",
})
hl.permission({ binary = "/usr/bin/hyprpm", type = "plugin", mode = "allow" })
-- for hyprpm update
hl.permission({
    binary = "/usr/bin/hyprpm",
    type = "screencopy",
    mode = "allow",
})
-- NOTE: allow using screenshot for fade-in and fade-out
--       https://github.com/hyprwm/hyprlock/issues/836#issuecomment-3132484838
hl.permission({
    binary = "/usr/bin/hyprlock",
    type = "screencopy",
    mode = "allow",
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    ecosystem = {
        no_update_news = true,
    },

    general = {
        gaps_in = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border = {
                colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing = false,
        layout = "hy3",
    },

    decoration = {
        rounding = 0,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 8,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    misc = {
        focus_on_activate = true,
        force_default_wallpaper = 1,
        disable_hyprland_logo = true,
    },
})

hl.curve("easeOutQuint", {
    type = "bezier",
    points = { { 0.23, 1 }, { 0.32, 1 } },
})
hl.curve("easeInOutCubic", {
    type = "bezier",
    points = { { 0.65, 0.05 }, { 0.36, 1 } },
})
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", {
    type = "bezier",
    points = { { 0.5, 0.5 }, { 0.75, 1 } },
})
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint",
})
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.79,
    bezier = "easeOutQuint",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    bezier = "easeOutQuint",
    style = "popin 87%",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%",
})
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.73,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "almostLinear",
})
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3.81,
    bezier = "easeOutQuint",
})
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade",
})
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.79,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.39,
    bezier = "almostLinear",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})
hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 1.21,
    bezier = "almostLinear",
    style = "fade",
})
hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 7,
    bezier = "quick",
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "caps:none",
        kb_rules = "",

        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

----------------
---- PLUGIN ----
----------------

hl.config({
    plugin = {
        hy3 = hl.plugin.hy3 ~= nil and {
            tabs = {
                height = 2,
                padding = 6,
                render_text = false,
            },
        } or nil,

        hyprbars = hl.plugin.hyprbars ~= nil and {
            bar_color = "rgb(000000)",
            bar_height = 25,
            bar_title_enabled = false,
            bar_precedence_over_border = true,
            bar_padding = 10,
            bar_button_padding = 10,
        } or nil,
    },
})

if hl.plugin.hyprbars ~= nil then
    hl.plugin.hyprbars.add_button({
        fg_color = "rgb(000000)",
        bg_color = "rgb(d9d8d8)",
        size = 11,
        icon = "",
        action = "hyprctl dispatch killactive",
    })

    hl.plugin.hyprbars.add_button({
        fg_color = "rgb(000000)",
        bg_color = "rgb(d9d8d8)",
        size = 11,
        icon = "",
        action = "hyprctl dispatch fullscreen 0",
    })

    hl.plugin.hyprbars.add_button({
        fg_color = "rgb(000000)",
        bg_color = "rgb(d9d8d8)",
        size = 11,
        icon = "",
        action = "scratchpad",
    })
end

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- SwayWM-like keybinds
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + SHIFT + e", hl.dsp.exec_cmd("uwsm app -- wlogout -b 4"))

hl.bind(
    mainMod .. " + SHIFT + c",
    hl.dsp.exec_cmd("uwsm app -- hyprctl reload")
)
hl.bind(mainMod .. " + q", hl.dsp.window.close())
hl.bind(
    mainMod .. " + SHIFT + space",
    hl.dsp.window.float({ action = "toggle" })
)
hl.bind(mainMod .. " + d", hl.dsp.exec_cmd("uwsm app -- " .. menu))
hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen())

if hl.plugin.hy3 ~= nil then
    hl.bind(
        mainMod .. " + W",
        hl.plugin.hy3.make_group("tab", { ephemeral = true })
    )
    hl.bind(
        mainMod .. " + b",
        hl.plugin.hy3.make_group("h", { ephemeral = true })
    )
    hl.bind(
        mainMod .. " + v",
        hl.plugin.hy3.make_group("v", { ephemeral = true })
    )
    hl.bind(
        mainMod .. " + e",
        hl.plugin.hy3.make_group("opposite", { ephemeral = true })
    )
    hl.bind(mainMod .. " + space", hl.plugin.hy3.toggle_focus_layer())

    -- Move focus with mod + arrow keys
    hl.bind(mainMod .. " + h", hl.plugin.hy3.move_focus("l"))
    hl.bind(mainMod .. " + l", hl.plugin.hy3.move_focus("r"))
    hl.bind(mainMod .. " + k", hl.plugin.hy3.move_focus("u"))
    hl.bind(mainMod .. " + j", hl.plugin.hy3.move_focus("d"))

    hl.bind(mainMod .. " + SHIFT + h", hl.plugin.hy3.move_window("l"))
    hl.bind(mainMod .. " + SHIFT + l", hl.plugin.hy3.move_window("r"))
    hl.bind(mainMod .. " + SHIFT + k", hl.plugin.hy3.move_window("u"))
    hl.bind(mainMod .. " + SHIFT + j", hl.plugin.hy3.move_window("d"))
end

hl.bind(mainMod .. " + n", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + p", hl.dsp.focus({ workspace = "e-1" }))

-- Switch workspaces with mod + [0-9]
-- Move active window to a workspace silently with mod + SHIFT + [0-9]
-- (stays on current workspace after moving the window)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i,
            follow = false,
        })
    )
end

hl.bind(
    mainMod .. " + SHIFT + n",
    hl.dsp.window.move({
        workspace = "e+1",
        follow = false,
    })
)
hl.bind(
    mainMod .. " + SHIFT + p",
    hl.dsp.window.move({
        workspace = "e-1",
        follow = false,
    })
)

-- scratchpad
hl.bind(
    mainMod .. " + SHIFT + minus",
    hl.dsp.exec_cmd("uwsm app -- scratchpad")
)
hl.bind(
    mainMod .. " + minus",
    hl.dsp.exec_cmd("uwsm app -- scratchpad -g -m 'head -n 1'")
)
hl.bind(
    mainMod .. " + CTRL + minus",
    hl.dsp.workspace.toggle_special("scratchpad")
)

hl.workspace_rule({ workspace = "special:scratchpad", gaps_out = 80 })

-- Scroll through existing workspaces with mod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- TODO: add resize mode after supported in hy3
-- https://github.com/outfoxxed/hy3/issues/14

-- Laptop multimedia keys for volume and LCD brightness
local volumeFile =
    "/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
local volumeUpCmd = "uwsm app -- pamixer -ui 1 && uwsm app -- pamixer --get-volume > "
    .. wobsock
    .. " && uwsm app -- pw-play "
    .. volumeFile
local volumeDownCmd = "uwsm app -- pamixer -ud 1 && uwsm app -- pamixer --get-volume > "
    .. wobsock
    .. " && uwsm app -- pw-play "
    .. volumeFile
local volumeMuteCmd = [[uwsm app -- pamixer --toggle-mute && ( [ "$(uwsm app -- pamixer --get-mute)" = "true" ] && echo "$(uwsm app -- pamixer --get-volume) muted" > ]]
    .. wobsock
    .. [[ ) || uwsm app -- pamixer --get-volume > ]]
    .. wobsock
local micMuteCmd = [[uwsm app -- pamixer --default-source --toggle-mute && ( [ "$(uwsm app -- pamixer --default-source --get-mute)" = "true" ] && echo "$(uwsm app -- pamixer --default-source --get-volume) muted" > ]]
    .. wobsock
    .. [[ ) || uwsm app -- pamixer --default-source --get-volume > ]]
    .. wobsock
local brightnessUpCmd = [[uwsm app -- brightnessctl set 1%+ | sed -En 's/.*\(([0-9]+)%\).*/\1/p' > ]]
    .. wobsock
local brightnessDownCmd = [[uwsm app -- brightnessctl set 1%- | sed -En 's/.*\(([0-9]+)%\).*/\1/p' > ]]
    .. wobsock

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(volumeUpCmd),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(volumeDownCmd),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(volumeMuteCmd),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(micMuteCmd),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(brightnessUpCmd),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(brightnessDownCmd),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("uwsm app -- playerctl next"),
    { locked = true }
)
hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("uwsm app -- playerctl play-pause"),
    { locked = true }
)
hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("uwsm app -- playerctl play-pause"),
    { locked = true }
)
hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("uwsm app -- playerctl previous"),
    { locked = true }
)

-- dynamic menu
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("rofimoji"))
hl.bind(
    mainMod .. " + semicolon",
    hl.dsp.exec_cmd(
        "uwsm app -- rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons && uwsm app -- wtype -M ctrl -k v -m ctrl"
    )
)

-- lock
hl.bind(mainMod .. " + CTRL + l", hl.dsp.exec_cmd("hyprlock")) -- omarchy-like keybind

-- submap
local submaps = {
    app = "󱓞",
    audio = "󰎇",
    brightness = "󰃟",
    screenshot = "󰄀",
    record = "󰻂",
    player = "",
    display = "󰍹",
}

hl.bind(mainMod .. " + O", hl.dsp.submap(submaps.app))

hl.define_submap(submaps.app, function()
    hl.bind("a", hl.dsp.submap(submaps.audio), { repeating = true })
    hl.bind(
        "CTRL + a",
        hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e wiremix"),
        { repeating = true }
    )
    hl.bind("CTRL + a", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("b", hl.dsp.exec_cmd("uwsm app -- firefox"), { repeating = true })
    hl.bind("b", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "ALT + b",
        hl.dsp.exec_cmd("uwsm app -- torbrowser-launcher"),
        { repeating = true }
    )
    hl.bind("ALT + b", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("CTRL + b", hl.dsp.submap(submaps.brightness), { repeating = true })
    hl.bind(
        "c",
        hl.dsp.exec_cmd("uwsm app -- quickshell -c calendar"),
        { repeating = true }
    )
    hl.bind("c", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + c",
        hl.dsp.exec_cmd("uwsm app -- hyprpicker -a"),
        { repeating = true }
    )
    hl.bind("CTRL + c", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("d", hl.dsp.exec_cmd("uwsm app -- obsidian"), { repeating = true })
    hl.bind("d", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "e",
        hl.dsp.exec_cmd("uwsm app -- proton-mail"),
        { repeating = true }
    )
    hl.bind("e", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "f",
        hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e yazi"),
        { repeating = true }
    )
    hl.bind("f", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("i", hl.dsp.exec_cmd("uwsm app -- slack"), { repeating = true })
    hl.bind("i", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + i",
        hl.dsp.exec_cmd("uwsm app -- discord"),
        { repeating = true }
    )
    hl.bind("CTRL + i", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "ALT + i",
        hl.dsp.exec_cmd("uwsm app -- signal-desktop"),
        { repeating = true }
    )
    hl.bind("ALT + i", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "n",
        hl.dsp.exec_cmd("uwsm app -- swaync-client -t -sw"),
        { repeating = true }
    )
    hl.bind("n", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "m",
        hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e btop"),
        { repeating = true }
    )
    hl.bind("m", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("p", hl.dsp.exec_cmd("uwsm app -- 1password"), { repeating = true })
    hl.bind("p", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + p",
        hl.dsp.exec_cmd("uwsm app -- flatpak run io.ente.auth"),
        { repeating = true }
    )
    hl.bind("CTRL + p", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("t", hl.dsp.exec_cmd("uwsm app -- burpsuite"), { repeating = true })
    hl.bind("t", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("r", hl.dsp.exec_cmd("uwsm app -- remmina"), { repeating = true })
    hl.bind("r", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "w",
        hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e impala"),
        { repeating = true }
    )
    hl.bind("w", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + w",
        hl.dsp.exec_cmd("uwsm app -- " .. terminal .. " -e bluetui"),
        { repeating = true }
    )
    hl.bind("CTRL + w", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "ALT + w",
        hl.dsp.exec_cmd("uwsm app -- wireshark"),
        { repeating = true }
    )
    hl.bind("ALT + w", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

local audioUpCmd = "uwsm app -- pamixer -ui 1 && uwsm app -- pamixer --get-volume > "
    .. wobsock
    .. " && pw-play "
    .. volumeFile
local audioDownCmd = "uwsm app -- pamixer -ud 1 && uwsm app -- pamixer --get-volume > "
    .. wobsock
    .. " && pw-play "
    .. volumeFile

hl.define_submap(submaps.audio, function()
    hl.bind("k", hl.dsp.exec_cmd(audioUpCmd), { repeating = true })
    hl.bind("j", hl.dsp.exec_cmd(audioDownCmd), { repeating = true })
    hl.bind("space", hl.dsp.exec_cmd(volumeMuteCmd), { repeating = true })
    hl.bind("space", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("SHIFT + space", hl.dsp.exec_cmd(micMuteCmd), { repeating = true })
    hl.bind("SHIFT + space", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.define_submap(submaps.brightness, function()
    hl.bind("k", hl.dsp.exec_cmd(brightnessUpCmd), { repeating = true })
    hl.bind("j", hl.dsp.exec_cmd(brightnessDownCmd), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + CTRL + s", hl.dsp.submap(submaps.screenshot))

local screenshotFile =
    [[${HOME}/Pictures/screenshots/$(date +'%Y%m%d_%H%M%S').png]]

hl.define_submap(submaps.screenshot, function()
    hl.bind(
        "w",
        hl.dsp.exec_cmd(
            [[uwsm app -- grimblast --notify copysave output "]]
                .. screenshotFile
                .. [["]]
        ),
        { repeating = true }
    )
    hl.bind("w", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "c",
        hl.dsp.exec_cmd(
            [[uwsm app -- grimblast --notify copysave active "]]
                .. screenshotFile
                .. [["]]
        ),
        { repeating = true }
    )
    hl.bind("c", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "p",
        hl.dsp.exec_cmd(
            [[uwsm app -- grimblast --notify --freeze copysave area "]]
                .. screenshotFile
                .. [["]]
        ),
        { repeating = true }
    )
    hl.bind("p", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + w",
        hl.dsp.exec_cmd("uwsm app -- grimblast --notify edit output"),
        { repeating = true }
    )
    hl.bind("CTRL + w", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + c",
        hl.dsp.exec_cmd("uwsm app -- grimblast --notify edit active"),
        { repeating = true }
    )
    hl.bind("CTRL + c", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + p",
        hl.dsp.exec_cmd("uwsm app -- grimblast --notify --freeze edit area"),
        { repeating = true }
    )
    hl.bind("CTRL + p", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + CTRL + r", hl.dsp.submap(submaps.record))
hl.bind(
    mainMod .. " + CTRL + c",
    hl.dsp.exec_cmd(
        "killall -SIGINT wf-recorder; uwsm app -- notify-send screenrecord 'Stopped wf-recorder'"
    )
)
hl.bind(mainMod .. " + CTRL + c", hl.dsp.submap("reset"))

local recordFile = [[${HOME}/Videos/screenrecords/$(date +'%Y%m%d_%H%M%S').mp4]]

hl.define_submap(submaps.record, function()
    hl.bind(
        "w",
        hl.dsp.exec_cmd([[uwsm app -- wf-recorder -f "]] .. recordFile .. [["]]),
        { repeating = true }
    )
    hl.bind("w", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "p",
        hl.dsp.exec_cmd(
            [[uwsm app -- wf-recorder -g "$(slurp)" -f "]]
                .. recordFile
                .. [["]]
        ),
        { repeating = true }
    )
    hl.bind("p", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + m", hl.dsp.submap(submaps.player))

hl.define_submap(submaps.player, function()
    hl.bind(
        "k",
        hl.dsp.exec_cmd("uwsm app -- playerctl play-pause"),
        { repeating = true }
    )
    hl.bind("k", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "j",
        hl.dsp.exec_cmd("uwsm app -- playerctl position 10-"),
        { repeating = true }
    )
    hl.bind("j", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "l",
        hl.dsp.exec_cmd("uwsm app -- playerctl position 10+"),
        { repeating = true }
    )
    hl.bind("l", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + p",
        hl.dsp.exec_cmd("uwsm app -- playerctl previous"),
        { repeating = true }
    )
    hl.bind("CTRL + p", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "CTRL + n",
        hl.dsp.exec_cmd("uwsm app -- playerctl next"),
        { repeating = true }
    )
    hl.bind("CTRL + n", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + SHIFT + m", hl.dsp.submap(submaps.display))

hl.define_submap(submaps.display, function()
    hl.bind(
        "d",
        hl.dsp.exec_cmd("uwsm app -- nwg-displays"),
        { repeating = true }
    )
    hl.bind("d", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "m",
        hl.dsp.exec_cmd("uwsm app -- kanshictl switch mirror-dp-3"),
        { repeating = true }
    )
    hl.bind("m", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "e",
        hl.dsp.exec_cmd("uwsm app -- kanshictl switch extend-dp-3"),
        { repeating = true }
    )
    hl.bind("e", hl.dsp.submap("reset"), { repeating = true })
    hl.bind(
        "p",
        hl.dsp.exec_cmd("uwsm app -- wl-present mirror"),
        { repeating = true }
    )
    hl.bind("p", hl.dsp.submap("reset"), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- NOTE: ignore maximize requests from apps
--       and inhibit idle when fullscreen
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
    idle_inhibit = "fullscreen",
})

-- NOTE: fix some dragging issues with XWayland
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "enable-float-when-picker",
    match = { class = "^(hyprland-share-picker)$" },

    float = true,
})

-- Firefox PinP
hl.window_rule({
    name = "firefox-pinp",
    match = {
        class = "^(firefox)$",
        title = "^(Picture-in-Picture)$",
    },

    float = true,
    pin = true,
    move = { "monitor_w*0.745", "monitor_h*0.82" },
    size = { "monitor_w*0.25", "monitor_h*0.175" },
})

-- Blur
hl.layer_rule({
    name = "rofi",
    match = { namespace = "rofi" },

    blur = true,
})

hl.layer_rule({
    name = "wlogout",
    match = { namespace = "logout_dialog" },

    blur = true,
})

hl.layer_rule({
    name = "swaync-control-center",
    match = { namespace = "swaync-control-center" },

    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "swaync-notification-window",
    match = { namespace = "swaync-notification-window" },

    blur = true,
    ignore_alpha = 0,
})
