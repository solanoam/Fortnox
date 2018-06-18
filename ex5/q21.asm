.model small
.stack 100h
.data
out_msg db '* ','$'

.code
   Start:
      mov ax, @data ;set data segment
      mov ds, ax
      mov bx, 05d ;for the 5 seconds check
      mov cx, 0 ;set start point to 0

   PollClock:
      mov ax, 0 ;reset ax in each itaration
      out 70h, al ;RTC      
      in al, 71h
      div bl 
      cmp ah, 0 ;check if 5 seconds past since 
      jz PRINT ;go to print function if needed
      jmp PollClock ; else, continue the infinite loop

   PRINT:
      cmp ax, cx ;check if a star was already printed at the current second
      jz PollClock ;if it did, don't print and go back to the loop
      mov cx, ax ;if it didn't save the new second it was printed at
      mov dx, offset out_msg ;print "*" if you should
      mov ah,9
      int 21h
      jmp PollClock ;go back to the infinite loop

mov ah,4ch ;return to OS
int 21h
end Start
