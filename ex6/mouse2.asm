;http://www.gabrielececchetti.it/Teaching/CalcolatoriElettronici/Docs/i8086_and_DOS_interrupts.pdf
.model tiny
.stack 100h
.code
   org 100h
   extern txtGreen:byte
   extern txtBlue:byte
   extern txtWhite:byte
   extern txtExit:byte
   extern curColor:byte
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
   mouseFollow proc near uses ax
      mov ax, 03h
      int 33h
      shr cx,1
      ;shr dx,1
      mov al, curColor
      mov ah, 0ch
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
          mov curColor, 0010b
          jmp chgToWhiteEnd
      chgToGreenEnd:
      chgToBlue:
          mov curColor, 0001b
          jmp chgToWhiteEnd
       chgToBlueEnd:
       chgToWhite:
          mov curColor, 1111b
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

   textsPrint proc near uses dx
      ;setting init curser
      xor bh, bh
      xor dl, dl
      xor dh, dh
      mov ah, 02h
      int 10h
      ;printing first txt
      mov dx, offset txtGreen
      mov ah, 09h
      int 21h
      ;setting curser for second print
      xor dh, dh
      mov dl, 06d
      mov ah, 02h
      int 10h
      ;printing second text
      mov dx, offset txtBlue
      mov ah, 09h
      int 21h
      ;setting curser for third text
      xor dh, dh
      mov dl, 011d
      mov ah, 02h
      int 10h
      ;printing third text
      mov dx, offset txtWhite
      mov ah, 09h
      int 21h
      ;cursor for right text
      xor dh, dh
      mov dl, 036d
      mov ah, 02h
      int 10h
      ;printing forth text
      mov dx, offset txtExit
      mov ah, 09h
      int 21h
      ret
   textsPrint endp
end
