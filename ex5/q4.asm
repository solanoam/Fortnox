.model small
.stack 0400h
.data
   Old_int_off dw 00h
   Old_int_seg dw 00h 
   minCounter dw 00h
   secCounter dw 00h
   msCounter dw 00h
   msgSentence db 'Computers are good at following instructions, but not at reading your mind.' , 0dh , '$'
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
         ;int 21, ah = 25, al = 08, ds = cs, dx = offset CodeToInject
         ;IVTi =
         push ds
         push cs
         pop ds
         cli
         int 021h
         sti
         pop ds
         InfLoop:
            nop
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
               push dx
               push ax
               push bx
               inc bx
               mov ax, bx
               mov dl, 010d
               div dl
               cmp ah, 0h
               jnz Sentence
               Blink:
                  mov dx, offset msgBlank
                  mov ah, 09h
                  int 021h
                  jmp SentenceEnd
               BlinkEnd:
               Sentence:
                  mov dx, offset msgSentence
                  mov ah, 09h
                  int 021h
               SentenceEnd:
               pop bx
               pop ax
               pop dx
               sub ax, 01000d
               inc bx
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
