.model small
.stack 100h
.data
   ;declare data intergers as public
   public txtColors
   public txtExit
   public curColor
   public curShape
   public blankMsg
   public prevMousePosC
   public prevMousePosD
   public newCurC
   public newCurD
   txtColors db 'GREEN*BLUE@WHITE#$'
   txtExit db 'EXIT$'
   curColor db 1111b
   prevMousePosC db 00h
   prevMousePosD db 00h
   curShape db ' '
   blankMsg db ' '
   newCurC db 00h
   newCurD db 00h



.code
   ;declare functions from the other file
   extern textsPrint:near
   extern mouseFollow:near
   extern setToVideo:near
   extern chkMousePos:near
   extern changeCurPos:near
   extern prtAtCursor:near

   ;main
   Main:
      ;set ds as data segment
      mov ax, @data
      mov ds, ax
      ;setting video mode to 256
      call setToVideo
      runTime:
         ;print the line above
         call textsPrint
         ;print the current pos of mouse
         call mouseFollow
         ;check the current pos relative to the buttons
         call chkMousePos
         ;loop
         jmp runTime
      runTimeEnd:
   end Main
