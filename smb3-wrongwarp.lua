-- ARGB/word-order colors
red, green, black = 0xFF0000, 0x00FF00, 0x000000

-- pixel coordinates for display
xDisplay, yDisplay, textHeight = 170, 197, 9

-- helper for JSR $8FE3 instruction setup
function wrongWarpRegisters()
  local reg0093, reg0094, reg0095 =
    emu.read(0x0093, emu.memType.cpuDebug),
    emu.read(0x0094, emu.memType.cpuDebug),
    emu.read(0x0095, emu.memType.cpuDebug)

  emu.drawString(xDisplay, yDisplay,
    "0x093: " .. reg0093,
    reg0093 == 0x20 and green or red)
  emu.drawString(xDisplay, yDisplay + textHeight,
    "0x094: " .. reg0094,
    reg0094 == 0xE3 and green or red)
  emu.drawString(xDisplay, yDisplay + textHeight * 2,
    "0x095: " .. reg0095,
    reg0095 == 0x8F and green or red)
end

emu.addEventCallback(wrongWarpRegisters, emu.eventType.endFrame);
emu.displayMessage("wrong warp", "displaying registers")
