.model small
.stack 100h
.data
out_msg db '* ','$'

.code
HERE:
mov ax, @data ;set data segment
mov ds, ax
mov bx, 05d
mov cx, 0

PollClock:
mov ax, 0
mov al, 00h
out 70h, al
in al, 71h
div bl
cmp ah, 0
jz PRINT
jmp PollClock

PRINT:
cmp ax, cx
jz PollClock
mov cx, ax
mov dx, offset out_msg ;print "*" if you should
mov ah,9
int 21h
jmp PollClock

mov ah,4ch
int 21h
end HERE
