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
      int 033h ;get mouse position and button status
      shr cx, 1 ;that's how the interrupt works
      ;pixel color change
      mov al, curColor ;update the color of the cursor according to position
      mov ah, 0ch
      int 10h ;;Write graphics pixel at coordinate
      push cx
      push dx
      shr dx, 1 ;divide dx and ax by 8 for the print of the symbol
      shr dx, 1
      shr dx, 1
      shr cx, 1
      shr cx, 1
      shr cx, 1
      cmp prevMousePosC, cl ;check if cursot position changed
      jz contChkPos
      push bx
      mov bl, prevMousePosC ;move cursor to previous position
      mov newCurC, bl
      mov bl, prevMousePosD
      mov newCurD, bl
      mov bl, curShape
      mov curShape, ' ' ;delete the symbol that was printed at previous position
      call changeCurPos ;function for changing position
      call prtAtCursor ;function for printing
      mov curShape, bl
      pop bx
      mov prevMousePosC, cl ;updete previous position
      mov prevMousePosD, dl
      jmp contChkPosEnd
      contChkPos: ;same as before but for dl
        cmp prevMousePosD, dl
        jz contChkPosEnd
        ChangeD:
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
        ChangeDEnd:
      contChkPosEnd:
      mov newCurC, cl
      mov newCurD, dl
      call changeCurPos ;go to current mosue posiotion
      call prtAtCursor ;print symbol at current mouse position
      pop dx
      pop cx
      ret
   mouseFollow endp
   ;check mouse position relative to the buttons and determaine
   ;what the next curser should be, exit if needed
   chkMousePos proc near
      ;check if the mouse is in the upper row
      cmp dx, 07d
      ja chgToWhiteEnd
      cmp cx, 048d   ;check if the mouse is in the "GREEN" range
      jb chgToGreen
      cmp cx, 088d   ;check if the mouse is in the "BLUE" range
      jb chgToBlue
      cmp cx, 0136d   ;check if the mouse is in the "WHITE" range
      jb chgToWhite
      cmp cx, 0287d   ;check if the mouse is in the "EXIT" range
      ja exitP
      jmp chgToWhiteEnd ;don't exit program
      exitP: ;exit program
         call exitProg
      exitPEnd:
      chgToGreen: ;change to green function
          mov curColor, 0010b
          mov curShape, '*'
          jmp chgToWhiteEnd
      chgToGreenEnd:
      chgToBlue: ;change to blue function
          mov curColor, 0001b
          mov curShape, '@'
          jmp chgToWhiteEnd
       chgToBlueEnd:
       chgToWhite: ;change to white function
          mov curColor, 1111b
          mov curShape, '#'
          jmp chgToWhiteEnd
       chgToWhiteEnd:
          ret
   chkMousePos endp

   ;exit the program
   exitProg proc near ;exit program function
      call setToNormal
      mov ah, 04ch
      int 21h
      ret
   exitProg endp

   ;set video mod to graphic
   setToVideo proc near uses ax ;set graphic mode function
      mov ah,00h
      mov al,13h
      int 10h
      ret
   setToVideo endp

   ;set video mod to text§
   setToNormal proc near uses ax ;exit graphic mode function
      mov ah, 00h
      mov al, 03h
      int 10h
      ret
   setToNormal endp

   ;print the text in the buttons
   textsPrint proc near uses dx ;print color labels and 'exit' label
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

   ;change cursor position given posiiton
   changeCurPos proc near uses bx dx ax
      mov bh, 0h
      mov dh, newCurD
      mov dl, newCurC
      mov ah, 02h
      int 010h
      ret
    changeCurPos endp

    ;print given symbol at given position
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
