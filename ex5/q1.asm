.model small
.stack 100h
.data
out_msg db 'key 1 ','$'
.code
start:

in al, 21h ;change keyboard format
push ax ;save al value to restore keyboard format later
or al, 02h
out 21h, al

mov ax, @data ;set data segment
mov ds, ax

PollKeyboard:
in al, 64h  ;check if a key was pressed
test al, 01h
jz PollKeyboard ;wait until a key will be pressed

in al, 60h ;check key value
cmp al, 10000011b ;if the key is 2@ , escape
jz CON

in al, 60h ;check key value
cmp al,10000010b  ;if the key is 1! , print "key 1"
jnz PollKeyboard ;wait for the next press

mov dx, offset out_msg ;print "key 1" if you should
mov ah,9
int 21h
jmp PollKeyboard

CON:
pop ax ;restore keyboard settings
out 21h, al
mov ah, 4ch
int 21h
end start
