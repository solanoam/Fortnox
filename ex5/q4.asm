.model small
.stack 0400h

.data
   ;name suggestet in the instructions, store to offset for the original 08h interrupt
   Old_int_off dw 00h
   ;name suggestet in the instructions, store to segment for the original 08h interrupt
   Old_int_seg dw 00h
   ;min counter
   minCounter dw 00h
   ;seconds counter
   secCounter dw 00h
   ;mSeconds counter
   msCounter dw 00h
   ;counter for messege timer
   msgCounter db 00h
   ;the messege to print
   msgSentence db 'Computers are good at following instructions, but not at reading your mind.' , 0dh , '$'
   ;blank messege  for blinking
   msgBlank db '                                                                           ' , 0dh , '$'

   .code
      Main:
         ;set data segment
         mov ax, @data
         mov ds, ax
         ;getting address
         mov al, 08h
         mov ah, 035h
         int 021h
         ;moving adress to data segment for storage
         mov Old_int_seg, es
         mov Old_int_off, bx
         ;chnge the interrupt
         mov ah, 025h
         ;save the new iterrupt code to dx
         mov dx, CodeToInject
         ;save registers velues
         push ds
         push cs
         ;get code segment to the interrupt
         pop ds
         ;mask interrupts
         cli
         int 021h
         ;stop masking
         sti
         pop ds
         ;infinite loop
         InfLoop:
            ;delay length
            mov ax, 023d
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
            ;saving values
            push ax
            push dx
            ;zeroing ax
            xor ax, ax
            ;get current delay ms counter
            mov al, msgCounter
            inc ax
            ;update counter
            mov msgCounter, al
            ;check if it is a multiple of 10
            mov dl, 010d
            div dl
            cmp ah, 0h
            ;if yes, blink the messege, else, print it
            jz BlinkMsg
            PrintMsg:
               ;use int 21h service 09h to print
               mov ah, 09h
               mov dx, offset msgSentence
               int 21h
               jmp BlinkMsgEnd
            PrintMsgEnd:
            BlinkMsg:
               ;use int 21h service 09h to print
               mov ah, 09h
               mov dx, offset msgBlank
               int 21h
            BlinkMsgEnd:
            ;restore value
            pop dx
            pop ax
            ;continue infinite loop
            jmp InfLoop
         InfLoopEnd:

         ;injected code funtction - this code is being injected to int 08, and call the original interrupt,
         ;then, uses logic to print out a timer that is updated every 55ms
         ;IN:
         ;null
         ;OUT:
         ;null
         CodeToInject proc near
            ;iret in the end of the original interrupt will pop an extra element in the stack
            pushf
            call dword ptr [Old_int_off]
            ;saving values
            push ax
            push bx
            push cx
            ;loading values
            mov ax, msCounter
            mov bx, secCounter
            mov cx, minCounter
            ;adding 55ms to ms counter
            add ax, 055d
            ;check if there is carry
            cmp ax, 01000d
            jb UpdateSecEnd
            UpdateSec:
               ;update new value
               sub ax, 01000d
               inc bx
               ;cheking if there is carry
               cmp bx, 060d
               jnz UpdateMinEnd
               UpdateMin:
                  ;update new value
                  xor bx, bx
                  inc cx
                  ;checking to avoid overflow
                  cmp cx, 0ffffh
                  jnz AvoidOverFlowEnd
                  AvoidOverFlow:
                     ;zeroing min to avoid overflow
                     xor cx, cx
                  AvoidOverFlowEnd:
               UpdateMinEnd:
            UpdateSecEnd:
            ;saving counters
            mov msCounter, ax
            mov secCounter, bx
            mov minCounter, cx
            ;correct an error when using only two digits of the timer
            call InitScreenCounter
            ;printing each counter to the timer
            mov di, 09eh
            call PrintRegInDec
            mov ax, bx
            mov di, 096h
            call PrintRegInDec
            mov ax, cx
            mov di, 090h
            call PrintRegInDec
            ;restoring value for registers
            pop cx
            pop bx
            pop ax
            ;using iret as this code is uses is uses as an interrupt
            iret
         CodeToInject endp

         ;this function prints the initial state for the timer,
         ;it is usful to fix graphical errors when the timer isn't full yet
         ;IN:
         ;null
         ;OUT:
         ;null
         InitScreenCounter proc near
            ;saving values of registers
            push es
            push bx
            push si
            push cx
            ;setting the screen segment
            mov bx, 0b800h
            mov es, bx
            ;setting timer offset
            mov bx, 09eh
            ;setting color
            mov ch, 041h
            mov cl, ' '
            ;set counter
            mov si, 09h
            PrintChars:
               ;print to each digit in the timer
               mov es:[bx], cx
               sub bx, 02h
               dec si
               jnz PrintChars
            PrintCharsEnd:
            ;print ':'
            add bx, 06h
            mov cl, ':'
            mov es:[bx], cx
            add bx, 06h
            mov cl, ':'
            mov es:[bx], cx
            ;restore values
            pop cx
            pop si
            pop bx
            pop es
            ret
         InitScreenCounter endp

         ;print a register value to the screen in ascii
         ;IN:
         ;ax - register the contains the value that needs to be printed
         ;di - register the contains the desired offset from b800 (screen segment)
         PrintRegInDec proc near
             ;saving values
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
             ;restoring values©©
             pop di
             pop cx
             pop dx
             pop es
             pop bx
             pop ax
             ret
         PrintRegInDec endp
      end Main
