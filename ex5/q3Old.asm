.model small
.stack 400h
.data
   Old_int_off dw 00h
   Old_int_seg dw 00h
   minCounter dw 00h
   secCounter dw 00h
   msCounter dw 00h
.code
   MAIN:
      mov ax, @data ;set data segment
      mov ds, ax
      ;getting address
      mov al, 08h
      ;getting address of former interapt
      call GetIntAddr
      ;moving adress to data segment for storage
      mov Old_int_seg, es
      mov Old_int_off, bx
      mov dx, offset CodeToInject
      call InjectCodeByAddr
      ;revert to old interapt
      mov bx, Old_int_off
      mov dx, Old_int_seg
      mov ds, dx
      mov dx, bx
      mov ah, 025h
      mov al, 08h
      int 021h
      ;terminate progrem
      mov ah, 04ch
      int 021h

      CodeToInject proc far
         ;calling original function
         push ax
         push bx
         push es
         mov bx, Old_int_seg
         mov es, bx
         mov bx, Old_int_off
         pushf
         ;calling old function
         call dword ptr es:[bx]
         call InitScreenCounter
         call IncMs
         cmp si, 01h
         jnz IncSecCallEnd
         IncSecCall:
            call IncSec
         IncSecCallEnd:
         cmp cl, 01h
         jnz IncMinCallEnd
         IncMinCall:
            call IncMin
         IncMinCallEnd:
         push ax
         push di
         mov ax, msCounter
         mov di, 09eh
         call PrintRegInDec
         mov ax, secCounter
         mov di, 096h
         call PrintRegInDec
         mov ax, minCounter
         mov di, 090h
         call PrintRegInDec
         ;debug
         mov di, 0460h
         call PrintRegInDec
         pop di
         pop ax
         pop es
         pop bx
         pop ax
         iret
      CodeToInject endp

      ;get addr for a given interapt.
      ;IN:
      ;al - interapt number
      ;OUT:
      ;es - segment
      ;bx - offset
      GetIntAddr proc near
         push ax
         mov ah, 035h
         int 021h
         pop ax
         ret
      GetIntAddr endp

      ;injecting code to an interapt
      ;IN
      ;dx - injected code address
      ;al - interapt number
      ;OUT
      ;null
      InjectCodeByAddr proc near
         push dx
         push ds
         mov ah, 025h
         push cs
         pop ds
         int 021h
         pop ds
         pop dx
         ret
      InjectCodeByAddr endp

      ;this functuin adds deley by the user input
      ;IN:
      ;ax - number of seconds
      ;OUT:
      ;null
      AddDeley proc near
         OneMinuteLoop:
            push cx
            xor cx,cx
            DeleyLoop:
               nop
               loop DeleyLoop
            DeleyLoopEnd:
            pop cx
            dec ax
            jnz OneMinuteLoop
         OneMinuteLoopEnd:
         pop bx
         ret
      AddDeley endp

      ;the function prints the contents of a register
      ;IN:
      ;di - screen offset (segment is set to b800h)
      ;ax - register to print
      ;OUT:
      ;null
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

      ;the function inc the ms integer
      ;IN:
      ;null
      ;OUT:
      ;si - carry flag
      IncMs proc near
         push ax
         mov ax, msCounter
         add ax, 037h
         cmp ax, 0415h
         jb AddToCarryMsEnd
         AddToCarryMs:
            mov si, 01h
            sub ax, 03e8h
            mov msCounter, ax
            ret
         AddToCarryMsEnd:
         xor si, si
         mov msCounter, ax
         pop ax
         ret
      IncMs endp

      ;the function inc the ms integer
      ;IN:
      ;si - carry from ms
      ;OUT:
      ;cl - carry flag
      IncSec proc near
         push ax
         mov ax, secCounter
         inc ax
         cmp ax, 03ch
         jnz AddToCarrySecEnd
         AddToCarrySec:
            mov cl, 01h
            xor ax, ax
            mov secCounter, ax
            ret
         AddToCarrySecEnd:
         xor cl, cl
         mov secCounter, ax
         pop ax
         ret
      IncSec endp

      ;the function inc the ms integer
      ;IN:
      ;cl - carry from min
      ;OUT:
      ;null
      IncMin proc near
         push ax
         mov ax, minCounter
         inc ax
         cmp ax, 0ffffh
         jnz AvoidOverFlowEnd
         AvoidOverFlow:
            xor ax, ax
            mov minCounter, ax
            ret
         AvoidOverFlowEnd:
         mov minCounter, ax
         pop ax
         ret
      IncMin endp

      ;the function init the counter screen
      ;IN:
      ;null
      ;OUT:
      ;null
      InitScreenCounter proc near
         push es
         push bx
         push si
         push cx
         mov bx, 0b800h
         mov es, bx
         mov bx, 09eh
         mov ch, 041h
         mov cl, '0'
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
   end MAIN
