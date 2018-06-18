.model small

.data
   public txtGreen
   txtGreen db 'GREEN*$'
   txtBlue db 'BLUE@$'
   txtWhite db 'WHITE#$'
   txtExit db 'EXIT$'
.code
Main:
   mov ax, @data
   mov ds, ax
   mov ah,00h
   mov al,13h
   int 10h
   mov dh, 0
   mov dl, 34
   mov bh, 0
   mov ah, 2
   int 10h
   mov ah, 09h
   mov dx, offset txtGreen
   int 21h
   InfLoop:
      ;jmp InfLoop
   InfLoopEnd:
   ;mov ah, 00h
   ;mov al, 03h
   ;int 10h
   mov ah, 04ch
   int 21h
end Main
