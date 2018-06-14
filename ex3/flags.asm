.model small
.stack 100h
.data
.code
START:

    ;setting data segment      
    mov bx, @data 
    mov ds, bx 
    ;set screen segment
    mov bx, 0b800h 
    mov es, bx
    mov di, 0b0h
    mov dh, 00010010b
    
   mov ax, 0000000010010111b   
    
 CHKPAR:
    add al, 0h      
    jp PAIR         ;check if the number of 1's is a pair number
    jnp CHKLSB      ;goes to the lsb checking
    
PAIR:
    mov dh, 01001111b
    
    
CHKLSB:
    push ax
    and al, 00000001b
    cmp al, 00000001b
    pop ax
    jz PRINT1
    jnz CHKBITS
    
PRINT1:
    add di, 02h
    mov dl, '1'
    mov es:[di], dx
    
CHKBITS:
    push ax
    and al, 00000110b
    cmp al, 00000110b
    pop ax
    jz PRINTX
    push ax
    not al
    and al, 00000110b
    cmp al, 00000110b
    pop ax
    jz PRINTX
    jnz CHKSTR
    
PRINTX:
    add di, 02h
    mov dl, 'X'
    mov es:[di], dx
    
CHKSTR:
    push ax
    and al, 01100000b
    cmp al, 01100000b
    pop ax
    jnz CHKSTR2    
    push ax
    not al
    and al, 10010000b
    cmp al, 10010000b
    pop ax
    jz PRINTY
    jnz CHKSTR2
    
CHKSTR2:
    push ax
    and al, 00110000b
    cmp al, 00110000b
    pop ax
    jnz CHKSTR3     
    push ax
    not al
    and al, 01001000b
    cmp al, 01001000b
    pop ax
    jz PRINTY
    jnz CHKSTR3
    
CHKSTR3:
    push ax
    and al, 00011000b
    cmp al, 00011000b
    pop ax
    jnz CHKSTR4
    push ax
    not al
    and al, 00100100b
    cmp al, 00100100b
    pop ax
    jz PRINTY
    jnz CHKSTR4
    
CHKSTR4:
    push ax
    and al, 00001100b
    cmp al, 00001100b
    pop ax
    jnz CHKSTR5
    push ax
    not al
    and al, 00010010b
    cmp al, 00010010b
    pop ax
    jz PRINTY
    jnz CHKSTR5
    
CHKSTR5:
    push ax
    and al, 00000110b
    cmp al, 00000110b
    pop ax
    jnz CON
    push ax
    not al
    and al, 00001001b
    cmp al, 00001001b
    pop ax
    jz PRINTY
    jnz CON
    
    
PRINTY:
    add di, 02h
    mov dl, 'Y'
    mov es:[di], dx
    


CON: ;return to OSs
    mov ax, 4c00h
    int 21h 
end START