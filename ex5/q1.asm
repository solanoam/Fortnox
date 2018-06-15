.model small
.stack 100h

.data
   out_msg db 'key 1 ','$'
.code
   Start:
      ;change keyboard format
      in al, 21h
      ;save al value to restore keyboard format later
      push ax
      or al, 02h
      out 21h, al
      ;set data segment
      mov ax, @data
      mov ds, ax

      PollKeyboard:
         ;check if a key was pressed
         in al, 64h
         test al, 01h
         ;wait until a key will be pressed
         jz PollKeyboard
         ;check key values
         in al, 60h
         cmp al, 10000011b ;if the key is 2@ , escape
         jz CON

         in al, 60h ;check key value
         cmp al,10000010b  ;if the key is 1! , print "key 1"
         jnz PollKeyboard ;wait for the next press

         mov dx, offset out_msg ;print "key 1" if you should
         mov ah,9
         int 21h
         jmp PollKeyboard

      CON:
         pop ax ;restore keyboard settings
         out 21h, al
         mov ah, 4ch
         int 21h
end Start
