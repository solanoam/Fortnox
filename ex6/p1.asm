.model small
.data
    char dw 2E41h ;'A'
    public char
    msg db 'My string$'
    public msg
.code
    mov ax,bx
  L1:
    mov cx,ax
    jmp L2
.code
HERE:
    mov ax, @data
    mov ds, ax
    mov ax, 0B800h
    mov es, ax

    jmp far ptr L1
L2:
    extern CONT:near
    jmp CONT
end HERE
