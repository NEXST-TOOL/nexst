.section .text
.global _start

_start:
addiw   t0,zero,1
slli    t0,t0,  0x1f
jr      t0
