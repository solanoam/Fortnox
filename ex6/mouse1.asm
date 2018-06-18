.model small
.stack 100h
.data
   public devider equ 8h  ;for mouse position
   public txtGreen db 'GREEN*$'
   public txtBlue db 'BLUE@$'
   public txtWhite db 'WHITE#$'
   public txtExit db 'EXIT$'
.code
   extern textsPrint
   extren mouseFollow
   extren setToVideo
   extren chkMousePos

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
