li x1, 0xC00000A8
li x2, 0x00654321

sw x2, 0(x1)
.loop:
j .loop