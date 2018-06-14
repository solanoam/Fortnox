.model small
.stack 100h
.data
    ;init arr
    ;init arr
    asciis db 16 dup ('0123456789abcdef')
    asciib db 16 dup ('0'),
        16 dup ('1'),
        16 dup ('2'),
        16 dup ('3'),
        16 dup ('4'),
        16 dup ('5'),
        16 dup ('6'),
        16 dup ('7'),
        16 dup ('8'),
        16 dup ('9'),
        16 dup ('a'),
        16 dup ('b'),
        16 dup ('c'),
        16 dup ('d'),
        16 dup ('e'),
        16 dup ('f')

.code
START:
    ;setting data segment
    mov bx, @data
    mov ds, bx
    ;set screen segment
    mov bx, 0b800h
    mov es, bx

    mov  ax, 0ac56h  ;stack initialization
    push ax
    mov ax, 0ffffh
    push ax
    mov ax, 00006h
    push ax
    mov ax, 0abcdh
    push ax
    mov ax, 02469h
    push ax
    mov ax, 0100h
    push ax

    mov ax, 06d   ;input
    call PRINT
    jmp CON

PRINT PROC
    pop dx
    mov cx, ax  ;move the input number to cx (for the loop)
    mov di, 0200h   ;initializes screen index
AGN:
    pop ax
    push cx   ;save cx's value
    call PRINTHEX
    pop cx    ;get the value of cx back
    add di, 0a0h  ;go to the next line on the screen
    loop AGN
    push dx
    ret
PRINT ENDP

PRINTHEX PROC   ;from ex2
    mov cl, ah
    mov ch, 0
    mov si, cx
    mov bh, asciis[si]
    mov bl, asciib[si]
    mov cl, bl
    mov ch, 46d
    mov es:[di], cx
    mov cl, bh
    mov es:[di+2], cx
    mov cl, al
    mov ch, 0
    mov si, cx
    mov bh, asciis[si]
    mov bl, asciib[si]
    mov cl, bl
    mov ch, 46d
    mov es:[di+4], cx
    mov cl, bh
    mov es:[di+6], cx
    ret
PRINTHEX ENDP

CON:
    ;return to OSs
    mov ax, 4c00h
    int 21h
end START
