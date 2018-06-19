.model small
.stack 100h
.data
   public txtGreen
   public txtBlue
   public txtWhite
   public txtExit
   txtGreen db 'GREEN*$'
   txtBlue db 'BLUE@$'
   txtWhite db 'WHITE#$'
   txtExit db 'EXIT$'

.code
   extern textsPrint:near
   extern mouseFollow:near
   extern setToVideo:near
   extern chkMousePos:near

   Main:
      mov ax, @data
      mov ds, ax
      ;setting video mode to 256
      call setToVideo
      runTime:
         call textsPrint
         call mouseFollow
         call chkMousePos
         jmp runTime
      runTimeEnd:
   end Main
