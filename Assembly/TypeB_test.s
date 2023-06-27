addi x1, x0, 15       # x1 = 15
addi x2, x0, 30       # x2 = 30
addi x3, x0, -15      # x3 = -15
addi x4, x0, -30      # x4 = -30
beq x0, x0, .jump1    # if x0 == x0 then target
nop
.jump1:
beq x1, x2, .jump1
bne x1, x2, .jump2    # if x1 != x2 then target
nop
.jump2:
bne x0, x0, .jump2    # if x0 != x0 then target
blt x1, x2, .jump3    # if x1 < x2 then target
nop
.jump3:
blt x2, x1, .jump3    # if x2 < x1 then target
blt x3, x2, .jump4    # if x3 < x2 then target
nop
.jump4:
blt x2, x3, .jump4    # if x2 < x3 then target
blt x4, x3, .jump5    # if x4 < x3 then target
nop
.jump5:
blt x3, x4, .jump5    # if x3 < x4 then target
bge x2, x1, .jump6    # if x2 >= x1 then target
nop
.jump6:
bge x1, x2, .jump6    # if x1 >= x2 then target
bge x2, x3, .jump7    # if x2 >= x3 then target
nop
.jump7:
bge x3, x2, .jump7    # if x3 >= x2 then target
bge x3, x4, .jump8    # if x3 >= x4 then target
nop
.jump8:
bge x4, x3, .jump8    # if x4 >= x3 then target
.back1:
bge x3, x3, .jump9    # if x3 >= x3 then target
jal x0, .back1
.jump9:
bltu x1, x3, .jump10  # if x1 < x3 unsigned then target
nop
.jump10:
bltu x3, x1, .jump10  # if x3 < x1 unsigned then target
bgeu x3, x2, .jump11  # if x3 >= x2 unsigned then target
nop
.jump11:
bgeu x2, x3, .jump11  # if x2 >= x3 unsigned then target
.back2:
bgeu x1, x1, .jump12  # if x1 >= x1 unsigned then target
jal x0, .back2
.jump12:
nop