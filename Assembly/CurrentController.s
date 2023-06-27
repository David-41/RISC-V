li x1, 0xC0000000   # PID 1 base address
li x2, 0xC0000080   # Timer base address
li x3, 0xC00000AC	# PID-Timer link base address
li x7, 0xC00000A8   # 7-Segment base address
li x5, 1

# PID 1 Config
li x4, 1433
sw x4, 0x00(x1)		# Set reference to 5 A
li x4, 1024
sw x4, 0x04(x1)		# Set K1 to 1024
li x4, -1004
sw x4, 0x08(x1)		# Set K2 to -1004
li x4, 50001		
sw x4, 0x14(x1)		# Set PID clk to 1kHz
sw x5, 0x20(x1)     # Activate bypass
li x4, 1179648
sw x4, 0x28(x1)		# Upper saturation
li x4, -1179648
sw x4, 0x2C(x1)     # Lower saturation

# Timer Config
li x4, 4096
sw x4, 0x04(x2)		# Set ARR
li x4, 10
sw x4, 0x14(x2)		# Set Dead time
li x4, 0xF
sw x4, 0x20(x2)		# Output enable
sw x5, 0x24(x2)		# Activate bypass

# PID-Timer link Config
li x4, 10
sw x4, 0x00(x3)		# Set link value

# Start peripherals
sw x5, 0x18(x1)		# Start PID 1
sw x5, 0x08(x2)		# Start Timer

.loop:
lw x6, 0x78(x1)
sw x6, 0x00(x7)		# Display ADC value
j .loop