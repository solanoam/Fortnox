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
   extern curShape:byte
   extern prevMousePosC:byte
   extern prevMousePosD:byte
   extern blankMsg:byte
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
      int 033h
      shr cx, 1
      mov al, curColor
      mov ah, 0ch
      int 10h

      push dx
      push cx

      shr dx, 1
      shr dx, 1
      shr dx, 1
      shr cx, 1
      shr cx, 1
      shr cx, 1

      ;cmp prevMousePosC, cl
      ;jz contChkPos

      ;mov prevMousePosC, cx
      ;contChkPos:
      ;cmp prevMousePosD, dx
      ;jz endChk
      ;mov prevMousePosD, dx
      ;endChk:

      ;change cursor position to mouse position

      mov bh, 0h
      mov dh, dl
      mov dl, cl
      mov ah, 02h
      int 010h


      ;print at cursor position
      mov ah, 09h
      mov al, curShape
      mov cx, 01h
      mov bh, 0h
      mov bl, curColor
      int 010h

      mov ah, 09h
      mov al, ' '
      mov cx, 01h
      mov bh, 0h
      mov bl, curColor
      int 010h

      pop cx
      pop dx
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
      jmp chgToWhiteEnd
      exitP:
         call exitProg
      exitPEnd:
      chgToGreen:
          mov curColor, 0010b
          mov curShape, '*'
          jmp chgToWhiteEnd
      chgToGreenEnd:
      chgToBlue:
          mov curColor, 0001b
          mov curShape, '@'
          jmp chgToWhiteEnd
       chgToBlueEnd:
       chgToWhite:
          mov curColor, 1111b
          mov curShape, '#'
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
