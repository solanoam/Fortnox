;http://www.gabrielececchetti.it/Teaching/CalcolatoriElettronici/Docs/i8086_and_DOS_interrupts.pdf
.model tiny
.stack 100h
.code
   org 100h
   extern txtColors:byte
   extern txtExit:byte
   extern curColor:byte
   extern curShape:byte
   extern prevMousePosC:byte
   extern prevMousePosD:byte
   extern blankMsg:byte
   extern newCurC:byte
   extern newCurD:byte
   public textsPrint
   public mouseFollow
   public setToVideo
   public chkMousePos
   public changeCurPos
   public prtAtCursor
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
      ;pixel color change
      mov al, curColor
      mov ah, 0ch
      int 10h
      push cx
      push dx
      shr dx, 1
      shr dx, 1
      shr dx, 1
      shr cx, 1
      shr cx, 1
      shr cx, 1
      cmp prevMousePosC, cl
      jz contChkPos
      push bx
      mov bl, prevMousePosC
      mov newCurC, bl
      mov bl, prevMousePosD
      mov newCurD, bl
      mov bl, curShape
      mov curShape, ' '
      call changeCurPos
      call prtAtCursor
      mov curShape, bl
      pop bx
      mov prevMousePosC, cl
      mov prevMousePosD, dl
      jmp contChkPosEnd
      contChkPos:
        cmp prevMousePosD, dl
        jz contChkPosEnd
        ChangeD:
          push bx
          mov bl, prevMousePosC
          mov newCurC, bl
          mov bl, prevMousePosD
          mov newCurD, bl
          pop bx
          mov curShape, ' '
          call changeCurPos
          call prtAtCursor
          mov prevMousePosC, cl
          mov prevMousePosD, dl
        ChangeDEnd:
      contChkPosEnd:
      mov newCurC, cl
      mov newCurD, dl
      call changeCurPos
      call prtAtCursor
      pop dx
      pop cx
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
      xor dx, dx
      mov ah, 02h
      int 10h
      ;printing first txt
      mov dx, offset txtColors
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

   ;change cursor position to mouse position
   changeCurPos proc near uses bx dx ax
      mov bh, 0h
      mov dh, newCurD
      mov dl, newCurC
      mov ah, 02h
      int 010h
      ret
    changeCurPos endp

    ;print at cursor position
    prtAtCursor proc near uses ax cx bx
      mov ah, 09h
      mov al, curShape
      mov cx, 01h
      mov bh, 0h
      mov bl, curColor
      int 010h
      ret
    prtAtCursor endp

end
