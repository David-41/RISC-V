addi x1, x0, 30    # x1 = 30
addi x2, x0, 15    # x2 = 15
add x3, x1, x2     # x3 = 45
sub x4, x1, x2     # x4 = 15
sub x5, x2, x1     # x5 = -15
addi x6, x0, 2     # x6 = 2
sll x7, x2, x6     # x7 = 60
slt x8, x4, x3     # x8 = 1
slt x9, x3, x4     # x9 = 0
slt x10, x4, x5    # x10 = 0
slt x11, x5, x4    # x11 = 1
sltu x12, x4, x3   # x12 = 1
sltu x13, x3, x4   # x13 = 0
xor x14, x2, x7    # x14 = 51
srl x15, x2, x6    # x15 = 3
sra x16, x2, x6    # x16 = 3
sra x17, x5, x6    # x17 = -4
or x18, x2, x7     # x18 = 63
and x19, x2, x7    # x19 = 12
lui x20, 2         # x20 = 8192
auipc x21, 2       # x21 = 8272
jal x22, .link     # x22 = 88
nop
nop
nop
.link:
addi x23, x0, 1    # x23 = 1
nop