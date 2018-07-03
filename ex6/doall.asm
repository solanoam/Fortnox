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
      ;check if attribute can be time
      LegalModCond:
         ;initial offset for attribute
         mov bx, 082h
         mov al, es:[bx]
         cmp al, 'T'
         jnz TimeModEnd
         TimeMod:
            ;check next char
            inc bx
            mov al, es:[bx]
            cmp al, 'I'
            jnz LegalModCondEnd
            TimeMode50Per:
               ;check next char
               inc bx
               mov al, es:[bx]
               cmp al, 'M'
               jnz LegalModCondEnd
               TimeMod75Per:
                  ;check next char
                  inc bx
                  mov al, es:[bx]
                  cmp al, 'E'
                  jnz LegalModCondEnd
                  TimeModComp:
                     ;get time via interapt
                     mov ah, 02ch
                     int 21h
                     mov al, ch
                     xor ah, ah
                     mov di, 0200h
                     ;print time to screen
                     call PrintRegInDec
                     ;terminate
                     jmp LegalModCondEnd
                  TimeModCompEnd:
               TimeMod75PerEnd:
            TimeMode50PerEnd:
         TimeModEnd:
         ;check if attribute can be date
         mov bx, 082h
         mov al, es:[bx]
         cmp al, 'D'
         jnz DateModEnd
         DateMod:
            ;check next char
            inc bx
            mov al, es:[bx]
            cmp al, 'A'
            jnz LegalModCondEnd
            DateMod50Per:
               ;check next char
               inc bx
               mov al, es:[bx]
               cmp al, 'T'
               jnz LegalModCondEnd
               DateMod75Per:
                  ;check next char
                  inc bx
                  mov al, es:[bx]
                  cmp al, 'E'
                  jnz LegalModCondEnd
                  DateModComp:
                     ;get date via interupt
                     mov ah, 02ah
                     int 21h
                     ;set day to normal counting
                     inc al
                     ;set rest of the register to zero
                     xor ah, ah
                     ;set screen offset
                     mov di, 0200h
                     ;print date to screen
                     call PrintRegInDec
                     ;terminate
                     jmp LegalModCondEnd
                  DateModCompEnd:
               DateMod75PerEnd:
            DateMod50PerEnd:
         DateModEnd:
         ;check if attribute can be intX
         mov bx, 082h
         mov al, es:[bx]
         cmp al, 'I'
         jnz LegalModCondEnd
         IntMod:
            ;check next char
            inc bx
            mov al, es:[bx]
            cmp al, 'N'
            jnz LegalModCondEnd
            IntMod50Per:
               ;check next char
               inc bx
               mov al, es:[bx]
               cmp al, 'T'
               jnz LegalModCondEnd
               IntMod75Per:
                  ;check if the char is a valid number
                  inc bx
                  mov al, es:[bx]
                  ;a valid number is bounded by 30 is ascii - 0
                  sub al, 030h
                  jb LegalModCondEnd
                  ;and bounded by 39 in ascii - 9
                  cmp al, 09h
                  ja LegalModCondEnd
                  IntModComp:
                     ;get intX adress via interupt
                     mov ah, 035h
                     int 021h
                     ;set value of ip for print
                     mov ax, bx
                     ;set offset for print
                     mov di, 0200h
                     ;print offset of intX to screen
                     call PrintRegInDec
                     ;set value of ip for print
                     mov ax, es
                     ;set offset for print
                     mov di, 01f4h
                     ;print cs to screen
                     call PrintRegInDec
                  IntModCompEnd:
               IntMod75PerEnd:
            IntMod50PerEnd:
         IntModEnd:
      LegalModCondEnd:
      ;return to OS
      mov ah ,04ch
      int 21h

      ;print the number in decimal by input
      ;IN:
      ;ax - value to be printed in ascii
      ;di - offset relative to b800h segment
      ;OUT:
      ;null
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
