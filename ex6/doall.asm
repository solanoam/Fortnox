.model small
.stack 100h
.data
   stringPtrSeg dw 00h

.code
   Main:
      ;setting PSP segment to es
      mov ax, ds
      mov es, ax
      ;saving PSP seg for later storage
      push ax
      ;saving data segment
      mov ax, @data
      mov ds, ax
      ;restoring PSP segment for storing in data segment
      pop ax
      mov stringPtrSeg, ax
      ;set offset for length of attribute
      mov bx, 080h
      mov al, es:[bx]
      ;check if the attribute is 4 chars length
      xor ah, ah
      cmp al, 05d
      jnz LegalModCondEnd
      LegalModCond:
         ;initial offset for attribute
         mov bx, 082h
         mov al, es:[bx]
         cmp al, 'T'
         jnz TimeModEnd
         TimeMod:
            inc bx
            mov al, es:[bx]
            cmp al, 'I'
            jnz LegalModCondEnd
            TimeMode50Per:
               inc bx
               mov al, es:[bx]
               cmp al, 'M'
               jnz LegalModCondEnd
               TimeMod75Per:
                  inc bx
                  mov al, es:[bx]
                  cmp al, 'E'
                  jnz LegalModCondEnd
                  TimeModComp:
                     mov ah, 02ch
                     int 21h
                     mov al, ch
                     xor ah, ah
                     mov di, 0200h
                     call PrintRegInDec
                     jmp LegalModCondEnd
                  TimeModCompEnd:
               TimeMod75PerEnd:
            TimeMode50PerEnd:
         TimeModEnd:
         mov bx, 082h
         mov al, es:[bx]
         cmp al, 'D'
         jnz DateModEnd
         DateMod:
            inc bx
            mov al, es:[bx]
            cmp al, 'A'
            jnz LegalModCondEnd
            DateMod50Per:
               inc bx
               mov al, es:[bx]
               cmp al, 'T'
               jnz LegalModCondEnd
               DateMod75Per:
                  inc bx
                  mov al, es:[bx]
                  cmp al, 'E'
                  jnz LegalModCondEnd
                  DateModComp:
                     mov ah, 02ah
                     int 21h
                     inc al
                     xor ah, ah
                     mov di, 0200h
                     call PrintRegInDec
                     jmp LegalModCondEnd
                  DateModCompEnd:
               DateMod75PerEnd:
            DateMod50PerEnd:
         DateModEnd:
         mov bx, 082h
         mov al, es:[bx]
         cmp al, 'I'
         jnz LegalModCondEnd
         IntMod:
            inc bx
            mov al, es:[bx]
            cmp al, 'N'
            jnz LegalModCondEnd
            IntMod50Per:
               inc bx
               mov al, es:[bx]
               cmp al, 'T'
               jnz LegalModCondEnd
               IntMod75Per:
                  inc bx
                  mov al, es:[bx]
                  sub al, 030h
                  jb LegalModCondEnd
                  cmp al, 09h
                  ja LegalModCondEnd
                  IntModComp:
                     mov ah, 035h
                     int 021h
                     mov ax, bx
                     mov di, 0200h
                     call PrintRegInDec
                     mov ax, es
                     mov di, 01f4h
                     call PrintRegInDec
                  IntModCompEnd:
               IntMod75PerEnd:
            IntMod50PerEnd:
         IntModEnd:
      LegalModCondEnd:
      mov ah ,04ch
      int 21h

      PrintRegInDec proc near uses ax bx dx cx di
          ;set screen segment
          mov bx, 0b800h
          mov es, bx
          ;divider
          mov bx, 0ah
          SplitDig:
             xor dx, dx
             div bx
             ;takes the last digit of the number and saves the rest of the number to ax
             add dx, 030h
             mov cl, dl
             mov ch, 041h
             mov es:[di], cx
             sub di, 02h
             ;checks if there are more digits left
             cmp ax, 0h
             jnz SplitDig
          SplitDigEnd:
          ret
      PrintRegInDec endp
   end Main
