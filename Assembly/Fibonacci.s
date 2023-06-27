addi x1, x0, 15 # i (number of cycles)
addi x2, x0, 0 # a variable
addi x3, x0, 1 # b variable
.loop:
bgeu x0, x1, .end # while i > 0
add x4, x2, x3 # temporary (a+b)
add x2, x3, x0 # a = b
add x3, x4, x0 # b = c
addi x1, x1, -1 # i - 1
jal x0, .loop
.end:
nop