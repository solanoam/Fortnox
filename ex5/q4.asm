.model small
.stack 0400h
.data
   Old_int_off dw 00h
   Old_int_seg dw 00h
   minCounter dw 00h
   secCounter dw 00h ;seconds counter
   msCounter dw 00h ;mSeconds counter
   msgCounter db 00h ;counter for messege timer
   msgSentence db 'Computers are good at following instructions, but not at reading your mind.' , 0dh , '$' ;the messege to print
   msgBlank db '                                                                           ' , 0dh , '$'
   .code
      Main:
         mov ax, @data ;set data segment
         mov ds, ax
         ;getting address
         mov al, 08h
         mov ah, 035h
         int 021h
         ;moving adress to data segment for storage
         mov Old_int_seg, es
         mov Old_int_off, bx
         mov ah, 025h
         mov dx, CodeToInject
         push ds
         push cs
         pop ds
         cli
         int 021h
         sti
         pop ds
         InfLoop:
            mov ax, 025d
            OneSecLoop:
               push cx
               xor cx,cx
               DeleyLoop:
                  nop
                  loop DeleyLoop
               DeleyLoopEnd:
               pop cx
               dec ax
               jnz OneSecLoop
            OneSecLoopEnd:
            push ax
            push dx
            xor ax, ax
            mov al, msgCounter
            inc ax
            mov msgCounter, al
            mov dl, 010d
            div dl
            cmp ah, 0h
            jz BlinkMsg
            PrintMsg:
               mov ah, 09h
               mov dx, offset msgSentence
               int 21h
               jmp BlinkMsgEnd
            PrintMsgEnd:
            BlinkMsg:
               mov ah, 09h
               mov dx, offset msgBlank
               int 21h
            BlinkMsgEnd:
            pop dx
            pop ax
            jmp InfLoop
         InfLoopEnd:
         mov ah, 04ch
         int 021h

         CodeToInject proc near
            pushf
            call dword ptr [Old_int_off]
            push ax
            push bx
            push cx
            mov ax, msCounter
            mov bx, secCounter
            mov cx, minCounter
            add ax, 055d
            cmp ax, 01000d
            jb UpdateSecEnd
            UpdateSec:
               sub ax, 01000d
               inc bx
               call InitScreenCounter
               cmp bx, 060d
               jnz UpdateMinEnd
               UpdateMin:
                  xor bx, bx
                  inc cx
                  cmp cx, 0ffffh
                  jnz AvoidOverFlowEnd
                  AvoidOverFlow:
                     xor cx, cx
                  AvoidOverFlowEnd:
               UpdateMinEnd:
            UpdateSecEnd:
            call InitScreenCounter
            mov msCounter, ax
            mov secCounter, bx
            mov minCounter, cx
            mov di, 09eh
            call PrintRegInDec
            mov ax, bx
            mov di, 096h
            call PrintRegInDec
            mov ax, cx
            mov di, 090h
            call PrintRegInDec
            pop cx
            pop bx
            pop ax
            iret
         CodeToInject endp

         InitScreenCounter proc near
            push es
            push bx
            push si
            push cx
            mov bx, 0b800h
            mov es, bx
            mov bx, 09eh
            mov ch, 041h
            mov cl, ' '
            mov si, 09h
            PrintChars:
               mov es:[bx], cx
               sub bx, 02h
               dec si
               jnz PrintChars
            PrintCharsEnd:
            add bx, 06h
            mov cl, ':'
            mov es:[bx], cx
            add bx, 06h
            mov cl, ':'
            mov es:[bx], cx
            pop cx
            pop si
            pop bx
            pop es
            ret
         InitScreenCounter endp

         PrintRegInDec proc near
             ;setting data segment
             push ax
             push bx
             push es
             push dx
             push cx
             push di
             ;set screen segment
             mov bx, 0b800h
             mov es, bx
             ;divider
             mov bx, 0ah
             SplitDig:
                xor dx, dx
                div bx
                ;takes the last digit of the number and saves the rest of the number to ax
                add dx, 030h
                mov cl, dl
                mov ch, 041h
                mov es:[di], cx
                sub di, 02h
                ;checks if there are more digits left
                cmp ax, 0h
                jnz SplitDig
             SplitDigEnd:
             pop di
             pop cx
             pop dx
             pop es
             pop bx
             pop ax
             ret
         PrintRegInDec endp
      end Main
