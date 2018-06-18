;http://www.gabrielececchetti.it/Teaching/CalcolatoriElettronici/Docs/i8086_and_DOS_interrupts.pdf
.model tiny
.stack 100h
.code
   org 100h
   extern txtGreen:byte
   extern txtBlue:byte
   extern txtWhite:byte
   extern txtExit:byte
   public textsPrint
   public mouseFollow
   public setToVideo
   public chkMousePos

   ;follow curser, print di color to screen, and output the current position
   ;IN:
   ;di - color of printed pixel
   ;OUT:
   ;cx - colum pos of curser
   ;dx - row pos of curser
   mouseFollow proc near uses ax di
      mov ax, 03h
      int 33h
      shr cx,1
      shr dx,1
      mov ax, di
      mov ah, 00h
      int 10h
      ret
   mouseFollow endp

   chkMousePos proc near
      ;check if the mouse is in the upper row
      cmp dx, 07d
      ja chgToWhiteEnd
      ;check if the mouse is in the "GREEN*" range
      cmp cx, 048d
      jb chgToGreen
      cmp cx, 088d
      jb chgToBlue
      cmp cx, 0136d
      jb chgToWhite
      cmp cx, 0287d
      ja exitP
      exitP:
         call exitProg
      exitPEnd:
      chgToGreen:
          mov di, 0010b
          jmp chgToWhiteEnd
      chgToGreenEnd:
      chgToBlue:
          mov di, 0001b
          jmp chgToWhiteEnd
       chgToBlueEnd:
       chgToWhite:
          mov di, 1111b
          jmp chgToWhiteEnd
       chgToWhiteEnd:
          ret
   chkMousePos endp

   exitProg proc near
      call setToNormal
      mov ah, 04ch
      int 21h
      ret
   exitProg endp

   setToVideo proc near uses ax
      mov ah,00h
      mov al,13h
      int 10h
      ret
   setToVideo endp

   setToNormal proc near uses ax
      mov ah, 00h
      mov al, 03h
      int 10h
      ret
   setToNormal endp

   textsPrint proc near
      ;setting init curser
      xor dl, dl
      call setCursorTop
      ;printing first txt
      mov dx, offset txtGreen
      call printToScreen
      ;setting curser for second print
      mov dl, 06d
      call setCursorTop
      ;printing second text
      mov dx, offset txtBlue
      call printToScreen
      ;setting curser for third text
      mov dl, 011d
      call setCursorTop
      ;printing third text
      mov dx, offset txtWhite
      call printToScreen
      ;cursor for right text
      mov dl, 036d
      call setCursorTop
      ;printing forth text
      mov dx, offset txtExit
      ret
   textsPrint endp

   setCursorTop proc near using dx, ax, bx
      xor dh, dh
      xor bh, bh
      mov ah, 09h
      int 10h
      ret
   setCursorTop endp

   printToScreen using ax
      mov ah, 09
      int 21
      ret
   printToScreen endp
