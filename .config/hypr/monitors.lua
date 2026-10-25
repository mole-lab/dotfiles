-- monitors.lua
-- https://wiki.hypr.land/Configuring/Monitors/
-- Find your monitor names with:
--   hyprctl monitors

-- 1. First monitor
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", disabled = true })

-- 2. Second monitor
-- hl.monitor({ output = "eDP-1", disabled = true })
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })

-- 3. Extend / Auto
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 }) 
hl.monitor({ output = "eDP-1", mode = "preferred", position = "2304x216", scale = 1 })
hl.monitor({ output = "DP-2", mode = "3840x2160@120", position = "0x0", scale = 1.666667 })

-- 4. Duplicate
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1 })

-- 5. Second vertical monitor
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1 })
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "1920x0", scale = 1, transform = 1 })

pcall(function()
    local path = os.getenv("HOME") .. "/.config/quickshell/state/display.lua"
    local f = io.open(path, "r")
    if f then
        f:close()
        dofile(path)
    end
end)

-- EXTERNAL MONITOR
-- First connected non-eDP connector (e.g. "DP-2"), or nil. Name depends on the port.
local external = nil
pcall(function()
    local p = io.popen("for f in /sys/class/drm/card*-*/status; do case $f in *eDP*) ;; *) [ \"$(cat \"$f\")\" = connected ] && basename \"${f%/status}\" | sed 's/^card[0-9]*-//' ;; esac; done")
    if p then
        external = p:read("*l")
        p:close()
    end
end)

-- CLAMSHELL
-- Lid closed + external monitor connected -> turn off eDP-1.
-- Runs on every config load; the lid binds in keybinds.lua call `hyprctl reload`.
pcall(function()
    if not external then return end
    local lid = io.open("/proc/acpi/button/lid/LID/state", "r")
    if not lid then return end
    local closed = lid:read("*a"):find("closed") ~= nil
    lid:close()
    if closed then
        hl.monitor({ output = "eDP-1", disabled = true })
    end
end)

-- Main monitor for workspaces 1-4 (was never defined upstream).
MONITOR1 = external or "eDP-1"

-- WORKSPACE RULES
-- https://wiki.hypr.land/Configuring/Workspace-Rules/

-- hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = true })

hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = MONITOR1, default = true, persistent = true })

-- hl.workspace_rule({ workspace = "5", monitor = MONITOR2, default = true, persistent = true })
-- hl.workspace_rule({ workspace = "6", monitor = MONITOR2, default = true, persistent = true })

