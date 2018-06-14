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
    ;ax is given to us
    mov ax, 0f1c6h
    ;setting data segment      
    mov bx, @data 
    mov ds, bx 
    ;set screen segment
    mov bx, 0b800h 
    mov es, bx
    mov cl, ah
    mov ch, 0
    mov si, cx
    mov bh, asciis[si]
    mov bl, asciib[si]
    mov cl, bl
    mov ch, 46d
    mov es:[07d0h], cx
    mov cl, bh
    mov es:[07d0h+2], cx
    mov cl, al
    mov ch, 0
    mov si, cx
    mov bh, asciis[si]
    mov bl, asciib[si]
    mov cl, bl
    mov ch, 46d
    mov es:[07d0h+4], cx
    mov cl, bh
    mov es:[07d0h+6], cx
    ;return to OSs
    mov ax, 4c00h
    int 21h 
end START

