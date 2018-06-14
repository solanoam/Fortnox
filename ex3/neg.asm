.model small
.stack 100h
.data
.code
START:
    ;set screen segment
    mov ax, 0b800h 
    mov es, ax
    ;print ax value
    mov ch, 010h 
    xor ax, ax
    ;zero di
    mov di, 014h
    loopIncReg:
        ;save original ax
        push ax
        ;save currnt offest in the screen
        push di
        ;test neg function
        neg ax
        ;print ax if OF is on
        jo printValOfReg
        ;print ax if CF is on
        jc printValOfReg
        ;if all flags are down
        jmp printValOfRegEnd
        printValOfReg:
            ;restore ax value and perform print_dec
            neg ax
            mov cl, 02ch
            mov es:[di], cx
            sub di, 02h    
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
                mov ch, 0fh
                mov es:[di], cx    
                sub di, 02h    
                cmp ax, 0h ; checks if there are more digits left    
                jnz POSI
                jmp printValOfRegEnd

            NEGA: ;if negative
                neg ax
            NEGLOOP:    ;loop for a negative number
                xor dx, dx  
                div bx      ; takes the last digit of the number and saves the rest of the number to ax
                add dx, 030h    ;change to ascii value
                mov cl, dl     ;print each digit
                mov ch, 0fh    
                mov es:[di], cx    
                sub di, 02h    ;move the screen index to the left
                cmp ax, 0h ; checks if there are more digits left    
                jnz NEGLOOP
                mov cl, '-'     ;print "-" if the number is negative
                mov es:[di], cx
                sub di, 02h
        printValOfRegEnd:
        ;restore di
        pop di
        ;add offset to screen
        add di, 014h
        ;check if screen real estate is over
        cmp di, 0b90h
        jg screenEstateOverCond 
        jmp screenEstateOverCondEnd
        screenEstateOverCond:
            ;set offset to start
            mov di, 014h
            clearSCreen:
                ;set cx to black
                mov cl, 00h
                mov ch, 00h
                ;set block to black
                mov es:[di], cx
                ;inc offset
                add di, 02h
                ;loop until real estate is over
                cmp di, 0b90h
                jnz clearScreen
            clearScreenEnd:
            ;set offset to start
            mov di, 014h
        screenEstateOverCondEnd:    
        pop ax
        inc ax
        cmp ax, 0h
        jnz loopIncReg
    loopIncRegEnd:
    ;return to OSs
    mov ax, 4c00h
    int 21h 
end START

