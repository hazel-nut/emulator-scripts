while true do
    failcolor = "red"
    successcolor = "lightgreen"
   
   
	-- sprite slots
    ss_x = {
		mainmemory.read_u8(0x00E4),
		mainmemory.read_u8(0x00E5),
		mainmemory.read_u8(0x00E6),
		mainmemory.read_u8(0x00E7),
		mainmemory.read_u8(0x00E8),
		mainmemory.read_u8(0x00E9),
		mainmemory.read_u8(0x00EA)
	}
	mario_x = mainmemory.read_u16_le(0x0094) -- 0x007E is x position relative to screen
	gui.text(0, offset*8, "mario: " .. mario_x, "white")
	
	-- shell coords from table from deanyd
	-- shell_coords = {0xFA, 0x68, 0xA9, 0x1C, 0x92, 0x75, 0x60}
	
	-- dots video values
	ss_ref = {0xA9, 0x1C, 0x92, 0x75, 0x4C, 0x46, 0x0}
	
	-- left: shell 4, shell 1, shell 5 (needs offset)
	-- right: shell 2, shell 3, shell 0
	left_offset = 384 - 146 -- mario x for shell 3 (384); 0x92 = 146
	right_offset = left_offset - 36
	mario_x_ref = {
		0xA9 - right_offset,
		0x1C - left_offset,
		0x92 - right_offset,
		0x75 - right_offset,
		0x4C - left_offset,
		0x46 - left_offset,
		0x0
	}

	offset = 12
	for i=1,7 do
		txt_ss = "sprite slot " .. (i-1) .. ": "
		txt_ss_x = "0x" .. string.format("%02X", ss_x[i])
		ss_delta = ss_x[i] - ss_ref[i]
		txt_ss_delta = " (" .. ss_delta .. ")"
		gui.text(
			0, offset*i,
			txt_ss .. txt_ss_x .. txt_ss_delta,
			ss_delta == 0 and successcolor or failcolor
		)
		
		txt_mario_x = "mario: " .. mario_x
		
		mario_delta = mario_x - mario_x_ref[i]
		mario_color = mario_delta == 0 and successcolor or failcolor
		gui.text(300, offset*i, "(mario: " .. mario_delta .. ")", mario_color)
	end
	
    emu.frameadvance()
end
