-- Screenshots, recording, instant replay

-- Run a capture action, then leave the submap
local function act(args)
    return function()
        hl.dispatch(hl.dsp.exec_cmd("capture " .. args))
        hl.dispatch(hl.dsp.submap("reset"))
    end
end

-- rofi chooser
hl.bind("Print", hl.dsp.exec_cmd("capture menu"))

-- capture submap
hl.bind("SUPER + R", hl.dsp.submap("capture"))

hl.define_submap("capture", function()
    -- screen / region / window
    hl.bind("S", act("screenshot screen"))
    hl.bind("D", act("screenshot region"))
    hl.bind("F", act("screenshot window"))

    -- recording toggle
    hl.bind("SHIFT + S", act("record screen"))
    hl.bind("SHIFT + D", act("record region"))
    hl.bind("SHIFT + F", act("record window"))

    -- save the last 30s from the replay buffer
    hl.bind("R", act("replay-save"))

    hl.bind("escape", hl.dsp.submap("reset"))
end)
