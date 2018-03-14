FAIL_COLOR = "red"
SUCCESS_COLOR = "lightgreen"
TEXT_COLOR = "white"

LINE_HEIGHT = 12

MARIO_X_REGISTER = 0x0094 -- x coord, absolute (0x007E is screen-relative)
MARIO_LEFT_OFFSET = 238 -- mario x for shell 3 (384); 0x92 = 146
MARIO_RIGHT_OFFSET = MARIO_LEFT_OFFSET - 36

-- sprite slot constants
SPRITE_SLOT = {
    [0] = {
        ["register"] = 0x00E4,
        ["correct_value"] = 0xA9,
        ["mario_direction"] = 1, -- 0 is left, 1 is right
        ["desc"] = "red shell"
    },
    [1] = {
        ["register"] = 0x00E5,
        ["correct_value"] = 0x1C,
        ["mario_direction"] = 0,
        ["desc"] = "red shell"
    },
    [2] = {
        ["register"] = 0x00E6,
        ["correct_value"] = 0x92,
        ["mario_direction"] = 1,
        ["desc"] = "red shell"
    },
    [3] = {
        ["register"] = 0x00E7,
        ["correct_value"] = 0x75,
        ["mario_direction"] = 1,
        ["desc"] = "red shell"
    },
    [4] = {
        ["register"] = 0x00E8,
        ["correct_value"] = 0x4C,
        ["mario_direction"] = 0,
        ["desc"] = "red shell"
    },
    [5] = {
        ["register"] = 0x00E9,
        ["correct_value"] = 0x46,
        ["mario_direction"] = 0,
        ["desc"] = "red shell"
    },
    [6] = {
        ["register"] = 0x00EA,
        ["correct_value"] = 0x0,
        ["mario_direction"] = -1,
        ["desc"] = "? red shell"
    },
    [7] = { -- TODO
        ["register"] = 0x0,
        ["correct_value"] = 0x0,
        ["mario_direction"] = -1,
        ["desc"] = "p switch"
    },
    [9] = { -- TODO
        ["register"] = 0x0,
        ["correct_value"] = 0x0,
        ["mario_direction"] = -1,
        ["desc"] = "glitched berry"
    },
    [10] = { -- TODO
        ["register"] = 0x0,
        ["correct_value"] = 0x0,
        ["mario_direction"] = -1,
        ["desc"] = "glitched berry"
    }
}

while true do
	local mario_x = mainmemory.read_u16_le(MARIO_X_REGISTER) 
	gui.text(0, offset*8, "mario: " .. mario_x, "white")

    for i=0,6 do
        ss = SPRITE_SLOT[i]
        local ss_value = mainmemory.read_u8(ss.register)
        local ss_delta = value - ss.correct_value

        local mario_offset = ss.mario_direction == 0 and MARIO_LEFT_OFFSET or MARIO_RIGHT_OFFSET
        local mario_delta = mario_x - ss.correct_value - mario_offset

        local display_text = "[ss" .. i .. ", " .. ss.desc .. "] " .. ss_value
        if ss_delta == 0 then -- register is correctly set
            gui.text(0, offset * i, display_text, SUCCESS_COLOR)
        else
            local nudge = mario_delta < 0 and (math.abs(mario_delta) .. " -->") or ("<-- " .. math.abs(mario_delta))
            gui.text(0, offset * i, display_text .. " (" .. ss_delta .. ")", FAIL_COLOR)
            gui.text(300, offset * i, nudge, FAIL_COLOR)
        end

    emu.frameadvance()
end
