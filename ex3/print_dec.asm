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
    mov ax, 0ffffh      ;input
    mov di, 0b0h        ;initializes screen index
    mov bx, 0ah         ;divider   
    cmp ax, 0h          ;checks if the number is negativ or positive
    jge POSI
    jl NEGA
    
    ;jl NEGA
    
POSI:    
    xor dx, dx
    div bx
    ; takes the last digit of the number and saves the rest of the number to ax
    add dx, 030h
    mov cl, dl
    mov ch, 010h
    mov es:[di], cx    
    sub di, 02h    
    cmp ax, 0h ; checks if there are more digits left    
    jnz POSI
    jmp CON

NEGA: ;if negative
    neg ax
    
NEGLOOP:    ;loop for a negative number
    xor dx, dx  
    div bx      ; takes the last digit of the number and saves the rest of the number to ax
    add dx, 030h    ;change to ascii value
    mov cl, dl     ;print each digit
    mov ch, 010h    
    mov es:[di], cx    
    sub di, 02h    ;move the screen index to the left
    cmp ax, 0h ; checks if there are more digits left    
    jnz NEGLOOP
    mov cl, '-'     ;print "-" if the number is negative
    mov es:[di], cx
    sub di, 02h

CON:      
    ;print "ax="
    mov cl, '='
    mov es:[di], cx
    sub di, 02h
    mov cl, 'x'
    mov es:[di], cx
    sub di, 02h
    mov cl, 'a'
    mov es:[di], cx
    
    
    ;return to OSs
    mov ax, 4c00h
    int 21h 
end START