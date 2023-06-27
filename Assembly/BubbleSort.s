li x1, 256      # RAM addr to store words
li x2, 0        # Swapp indicator
li x3, 63       # First element
li x4, 2        # Second element
li x5, 30       # Third element
li x6, 92       # Forth element
li x7, 82       # Fifth element
li x8, 42       # Sixth element
li x9, 47       # Seventh element
li x10, 98      # Eighth element
li x11, 64      # Nineth element
li x12, 55      # Tenth element
li x14, 9       # Number of elements -1
sw x3, 0(x1)    # Store elements
sw x4, 4(x1)
sw x5, 8(x1)
sw x6, 12(x1) 
sw x7, 16(x1)
sw x8, 20(x1)
sw x9, 24(x1) 
sw x10, 28(x1)
sw x11, 32(x1)
sw x12, 36(x1)
.bucleconfig:
li x13, 0        # Index
add x2, x0, x0   # Reset swap indicator
.bucle:
lw x30, 0(x1)    # Load element n to RF
lw x31, 4(x1)    # Load n+1
blt x31, x30, .swapp  # Swap if n+1 < n
.swappreturn:
addi x1, x1, 4   # Increase mem addr
addi x13, x13, 1 # Index += 1
blt x13, x14, .bucle # Repeat if index < number of elements
li x1, 256       # Reset mem addr
bne x2, x0, .bucleconfig # If swap indicator -> repeat
jal, x0, .end    # end
.swapp:
sw x31, 0(x1)    # Swap n+1
sw x30, 4(x1)    # Swap n
addi x2, x0, 1   # Swap indicator = 1
jal x0, .swappreturn # return from swap
.end:
nop
