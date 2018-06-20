.model small
.stack 100h
.data
    extern char:word
    extern msg:byte

.code
public CONT
CONT:
    mov ax,char
    mov es:[340h], ax
    mov bx, offset msg
    mov dl, msg[5]
    mov dh,ds:[msg+6]
    mov ah,4ch
    int 21h
end
