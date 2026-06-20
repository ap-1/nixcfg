-- Keyboard-driven mouse pointer control

-- Detect clickable elements, type a label, auto-click
hl.bind("SUPER + semicolon",
    hl.dsp.exec_cmd("pkill wl-kbptr || wl-kbptr -o modes=floating,click -o mode_floating.source=detect"))

-- Grid then split (g/h/b to click, Enter/Space to place cursor)
hl.bind("SUPER + SHIFT + semicolon",
    hl.dsp.exec_cmd("pkill wl-kbptr || wl-kbptr -o modes=tile,split"))

hl.bind("SUPER + G", hl.dsp.submap("cursor"))

-- Velocity movement, hjkl accelerate while held
local DT = 0.016
local BASE = 90.0    -- px/s on first tick
local ACCEL = 700.0  -- px/s^2 while a direction is held
local VMAX = 1600.0  -- px/s ceiling
local DECEL = 2200.0 -- px/s^2 friction after release

local held = { h = false, j = false, k = false, l = false }
local speed, ux, uy, cx, cy = 0.0, 0.0, 0.0, 0.0, 0.0

local function trunc(v)
    if v >= 0 then return math.floor(v) end
    return math.ceil(v)
end

local mover = hl.timer(function()
    local dx = (held.l and 1 or 0) - (held.h and 1 or 0)
    local dy = (held.j and 1 or 0) - (held.k and 1 or 0)
    if dx ~= 0 or dy ~= 0 then
        local norm = math.sqrt(dx * dx + dy * dy)
        ux, uy = dx / norm, dy / norm
        speed = math.min(VMAX, math.max(BASE, speed) + ACCEL * DT)
    else
        speed = math.max(0.0, speed - DECEL * DT) -- coast then stop
    end
    if speed <= 0.0 then return end
    cx = cx + ux * speed * DT
    cy = cy + uy * speed * DT
    local mx, my = trunc(cx), trunc(cy)
    cx, cy = cx - mx, cy - my
    if mx ~= 0 or my ~= 0 then
        local pos = hl.get_cursor_pos()
        if pos then
            hl.dispatch(hl.dsp.cursor.move({ x = pos.x + mx, y = pos.y + my }))
        end
    end
end, { timeout = 16, type = "repeat" })
mover:set_enabled(false)

-- Run the mover only in the cursor submap, repeat boost kept for E/R scroll
hl.on("keybinds.submap", function(submap)
    if submap == "cursor" then
        hl.config({ input = { repeat_rate = 100, repeat_delay = 150 } })
        mover:set_enabled(true)
    else
        hl.config({ input = { repeat_rate = 25, repeat_delay = 600 } })
        held.h, held.j, held.k, held.l = false, false, false, false
        speed = 0.0
        mover:set_enabled(false)
    end
end)

hl.define_submap("cursor", function()
    -- Jump to a detected element and click
    hl.bind("A",
        hl.dsp.exec_cmd("pkill wl-kbptr || wl-kbptr -o modes=floating,click -o mode_floating.source=detect"))

    -- Movement
    hl.bind("H", function() held.h = true end)
    hl.bind("H", function() held.h = false end, { release = true })
    hl.bind("J", function() held.j = true end)
    hl.bind("J", function() held.j = false end, { release = true })
    hl.bind("K", function() held.k = true end)
    hl.bind("K", function() held.k = false end, { release = true })
    hl.bind("L", function() held.l = true end)
    hl.bind("L", function() held.l = false end, { release = true })

    -- Clicks
    hl.bind("S", hl.dsp.exec_cmd("wlrctl pointer click left"))
    hl.bind("D", hl.dsp.exec_cmd("wlrctl pointer click middle"))
    hl.bind("F", hl.dsp.exec_cmd("wlrctl pointer click right"))

    -- Scroll
    hl.bind("E", hl.dsp.exec_cmd("ydotool mousemove --wheel -- 0 -3"), { repeating = true })
    hl.bind("R", hl.dsp.exec_cmd("ydotool mousemove --wheel -- 0 3"), { repeating = true })

    -- Any mouse click exits the submap
    hl.bind("mouse:272", hl.dsp.submap("reset"))
    hl.bind("mouse:273", hl.dsp.submap("reset"))
    hl.bind("mouse:274", hl.dsp.submap("reset"))
    hl.bind("mouse:275", hl.dsp.submap("reset"))
    hl.bind("mouse:276", hl.dsp.submap("reset"))

    hl.bind("escape", hl.dsp.submap("reset"))
end)
