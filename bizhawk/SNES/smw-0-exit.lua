FAIL_COLOR = "red"
SUCCESS_COLOR = "lightgreen"
TEXT_COLOR = "white"

LINE_HEIGHT = 12
DESC_COLUMN = 0
VALUE_COLUMN = 175
MARIO_COLUMN = 325

MARIO_X_REGISTER = 0x0094 -- x coord, absolute (0x007E is screen-relative)
MARIO_FACING_RIGHT_OFFSET = 238 -- mario x for shell 3 (384); 0x92 = 146
MARIO_FACING_LEFT_OFFSET = MARIO_FACING_RIGHT_OFFSET + 36
MARIO_RIGHT_OFFSET = MARIO_LEFT_OFFSET + 36

-- sprite slot constants using dots video reference values
SPRITE_SLOTS = {
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
        ["desc"] = "koopa 1"
    },
    [2] = {
        ["register"] = 0x00E6,
        ["correct_value"] = 0x92,
        ["mario_direction"] = 1,
        ["desc"] = "koopa 2"
    },
    [3] = {
        ["register"] = 0x00E7,
        ["correct_value"] = 0x75,
        ["mario_direction"] = 1,
        ["desc"] = "koopa 3"
    },
    [4] = {
        ["register"] = 0x00E8,
        ["correct_value"] = 0x4C,
        ["mario_direction"] = 0,
        ["desc"] = "koopa 4"
    },
    [5] = {
        ["register"] = 0x00E9,
        ["correct_value"] = 0x46,
        ["mario_direction"] = 0,
        ["desc"] = "koopa 5"
    },
    [6] = {
        ["register"] = 0x00EA,
        ["correct_value"] = 0xFF,
        ["mario_direction"] = -1, -- TODO: no direction necessary?
        ["desc"] = "p switch"
    }
}

while true do
    local mario_x = mainmemory.read_u16_le(MARIO_X_REGISTER) 
    gui.text(DESC_COLUMN, 0, "sprite slot", "white")
    gui.text(VALUE_COLUMN, 0, "0xHEX (delta)", "white")
    gui.text(MARIO_COLUMN, 0, "<- mario ->", "white")

    for i=0,table.getn(SPRITE_SLOTS) do
        ss = SPRITE_SLOTS[i]
        local ss_value = mainmemory.read_u8(ss.register)
        local ss_delta = ss_value - ss.correct_value
        local mario_offset = ss.mario_direction == 0 and MARIO_FACING_LEFT_OFFSET or MARIO_FACING_RIGHT_OFFSET
        local mario_delta = mario_x - ss.correct_value - mario_offset
        
        local display_height = LINE_HEIGHT * (i+1)
        gui.text(DESC_COLUMN, display_height, i .. ": " .. ss.desc, "yellow")

        local display_value = "0x" .. string.format("%02X", ss_value)
        if ss_delta == 0 then -- register is correctly set
            gui.text(VALUE_COLUMN, display_height, display_value, SUCCESS_COLOR)
        else
            gui.text(VALUE_COLUMN, display_height, display_value .. "  (" .. ss_delta .. ")", FAIL_COLOR)
            if mario_delta % 256 == 0 then -- mario is in the right spot
                gui.text(MARIO_COLUMN, display_height, "  there!", SUCCESS_COLOR)
            else
                local right_arrow_spaces = string.rep(" ", 4 - math.floor(math.log10(math.abs(mario_delta))))
                local go_right_string = "    " .. math.abs(mario_delta) .. right_arrow_spaces .. "->"
                local go_left_string = "<-  " .. math.abs(mario_delta)
                gui.text(MARIO_COLUMN, display_height, mario_delta < 0 and go_right_string or go_left_string, FAIL_COLOR)
            end
        end
    end

    emu.frameadvance()
end
