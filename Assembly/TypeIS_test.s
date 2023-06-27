addi x1, x0, 30       # x1 = 30
addi x2, x1, -15      # x2 = 15
slli x3, x2, 4        # x3 = 240
slti x4, x2, 20       # x4 = 1
slti x5, x1, 20       # x5 = 0
addi x6, x2, -30      # x6 = -15
slti x7, x6, -20      # x7 = 0
slti x8, x6, -10      # x8 = 1
slti x9, x2, -20      # x9 = 0
sltiu x10, x2, 20     # x10 = 1
sltiu x11, x1, 20     # x11 = 0
xori x12, x1, 54      # x12 = 40
srli x13, x1, 1       # x13 = 15
slli x14, x4, 31      # x14 = -2.147.483.648
srai x15, x13, 3      # x15 = 1
srai x16, x14, 8      # x16 = -8.388.608
ori x17, x12, 48      # x17 = 56
andi x18, x17, 240    # x18 = 48
sw x18, 64(x0)        # RAM 0x00000004 = 48
lw x19, 64(x0)        # x19 = 48
nop
nop
nop
nop
jalr x20, x12, 16      # x20 = 100 --> PC to srai x15, x13, 3
nop