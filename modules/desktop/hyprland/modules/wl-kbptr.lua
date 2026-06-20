-- Keyboard-driven mouse pointer control

-- Detect clickable elements, type a label, auto-click
hl.bind("SUPER + semicolon",
    hl.dsp.exec_cmd("wl-kbptr -o modes=floating,click -o mode_floating.source=detect"))

-- Grid then split (g/h/b to click, Enter/Space to place cursor)
hl.bind("SUPER + SHIFT + semicolon",
    hl.dsp.exec_cmd("wl-kbptr -o modes=tile,split"))

hl.bind("SUPER + G", hl.dsp.submap("cursor"))

-- Boost repeat rate while in cursor submap, restore on exit
hl.on("keybinds.submap", function(submap)
    if submap == "cursor" then
        hl.config({ input = { repeat_rate = 100, repeat_delay = 150 } })
    else
        hl.config({ input = { repeat_rate = 25, repeat_delay = 600 } })
    end
end)

hl.define_submap("cursor", function()
    -- Jump to a detected element and click
    hl.bind("A",
        hl.dsp.exec_cmd("wl-kbptr -o modes=floating,click -o mode_floating.source=detect"))

    -- Cardinal nudge (hold to repeat)
    hl.bind("H", hl.dsp.exec_cmd("wlrctl pointer move -5 0"), { repeating = true })
    hl.bind("J", hl.dsp.exec_cmd("wlrctl pointer move 0 5"), { repeating = true })
    hl.bind("K", hl.dsp.exec_cmd("wlrctl pointer move 0 -5"), { repeating = true })
    hl.bind("L", hl.dsp.exec_cmd("wlrctl pointer move 5 0"), { repeating = true })

    -- Clicks
    hl.bind("S", hl.dsp.exec_cmd("wlrctl pointer click left"))
    hl.bind("D", hl.dsp.exec_cmd("wlrctl pointer click middle"))
    hl.bind("F", hl.dsp.exec_cmd("wlrctl pointer click right"))

    -- Scroll
    hl.bind("E", hl.dsp.exec_cmd("ydotool mousemove --wheel -- 0 -3"), { repeating = true })
    hl.bind("R", hl.dsp.exec_cmd("ydotool mousemove --wheel -- 0 3"),  { repeating = true })

    -- Any mouse click exits the submap
    hl.bind("mouse:272", hl.dsp.submap("reset"))
    hl.bind("mouse:273", hl.dsp.submap("reset"))
    hl.bind("mouse:274", hl.dsp.submap("reset"))
    hl.bind("mouse:275", hl.dsp.submap("reset"))
    hl.bind("mouse:276", hl.dsp.submap("reset"))

    -- Leave the mode
    hl.bind("escape", hl.dsp.submap("reset"))
end)
