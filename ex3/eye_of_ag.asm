.model small
.stack 100h
.data
    printWidthSmall dw 02h
    printWidthBig dw 06h
    printLine dw 0a0h
.code
    ;set data segment
    mov ax, @data
    mov ds, ax
    ;set screen segment      
    mov ax, 0b800h 
    mov es, ax 
    ;set init offset
    mov di, 7b0h
    mov bx, 7b0h
    ;set cx for printing
    mov ch, 02fh
    mov cl, 041h
    ;flag for inc or dec
    xor si, si
    ;flag for big or small
    xor dx, dx
    ;small loop
    printLoop:
        ;di - top print
        ;bx - bottom print
        mov es:[di], cx
        mov es:[bx], cx 
        ;check if small / big eye. indicated by the number of the loop 
        cmp dx, 1
        jz bigPrint
        ;print small eye
        smallPrint:
            add di, printWidthSmall
            add bx, printWidthSmall
            jmp sizePrintCondEnd
        ;print big eye
        bigPrint:
            add di, printWidthBig
            add bx, printWidthBig
        sizePrintCondEnd:
        ;phase condition
        cmp si, 1
        jz secPhase
        ;check if first phase - top row in incresing, bottom row is decresing 
        firstPhase:
            add di, printLine
            sub bx, printLine
            jmp phaseCondEnd
        ;check if second phase - top row in decresing, bottom row is incresing
        secPhase:
            sub di, printLine
            add bx, printLine
        ;end phase cond check
        phaseCondEnd:
        inc cl
        ;check if got to m and change phase if true
        cmp cl, 04dh
        jz decFlagCond
        jmp decFlagCondEnd
        ;update phase flag
        decFlagCond:
            inc si
        decFlagCondEnd:
        ;loop until Y chars were printed
        cmp cl, 05ah
        jnz printLoop
    loopPrintEnd:
    ;inc flag for big / small loop
    inc dx
    ;zero phase flag
    xor si, si
    ;change style
    mov ch, 01fh
    ;set value to A
    mov cl, 041h
    ;set offset for both offset registers
    mov di, 0780h
    mov bx, 0780h
    ;loop until reached two eyes were printed
    cmp dx, 02h
    jnz printLoop
    ;return to OSs
    mov ax, 4c00h
    int 21h 
end
