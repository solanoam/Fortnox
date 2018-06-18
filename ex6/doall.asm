.model small
.stack 100h
.data
   stringPtrSeg dw 00h

.code
   Main:
      mov bx, ds
      mov stringPtrSeg, bx
      mov es, bx
      xor bx, bx
      mov ax, es:[bx]
      cmp ax, 04d
      jnz LegalModCondEnd
      LegalModCond:
         mov bx, 01h
         mov ax, es:[bx]
         cmp ax, 'T'
         jnz TimeModEnd
         TimeMod:
            inc ax
            mov bx, es[ax]
            cmp bx, 'I'
            jnz LegalModCondEnd
            TimeMode50Per:
               inc ax
               mov bx, es[ax]
               cmp bx, 'M'
               jnz LegalModCondEnd
               TimeMod75Per:
                  inc ax
                  mov bx, es[ax]
                  cmp bx, 'E'
                  jnz LegalModCondEnd
                  TimeModComp:
                     mov ah, 02ch
                     int 21
                     mov al, ch
                     xor ah, ah
                     mov di, 0200h
                     call PrintRegInDec
                     jmp LegalModCondEnd
                  TimeModCompEnd:
               TimeMod75PerEnd:
            TimeMode50PerEnd:
         TimeModEnd:
         mov ax, 01h
         mov bx, es:[ax]
         cmp bx, 'D'
         jnz DateModEnd
         DateMod:
            inc ax
            mov bx, es:[ax]
            cmp bx, 'A'
            jnz LegalModCondEnd
            DateMod50Per:
               inc ax
               mov bx, es:[ax]
               cmp bx, 'T'
               jnz LegalModCondEnd
               DateMod75Per:
                  inc ax
                  mov bx, es:[ax]
                  cmp bx, 'E'
                  jnz LegalModCondEnd
                  DateModComp:
                     mov ah, 02ah
                     int 21
                     xor ah, ah
                     mov di, 0200h
                     call PrintRegInDec
                     jmp LegalModCondEnd
                  DateModCompEnd:
               DateMod75PerEnd:
            DateMod50PerEnd:
         DateModEnd:
         mov ax, 01h
         mov bx, es:[ax]
         cmp bx, 'I'
         jnz LegalModCondEnd
         IntMod:
            inc ax
            mov bx, es:[ax]
            cmp bx, 'N'
            jnz LegalModCondEnd
            IntMod50Per:
               inc ax
               mov bx, es:[ax]
               cmp bx, 'T'
               jnz LegalModCondEnd
               IntMod75Per:
                  inc ax
                  mov bx, es:[ax]
                  cmp bx, 030h
                  jb LegalModCondEnd
                  cmp bx, 039h
                  ja LegalModCondEnd
                  IntModComp:
                     sub bx, 30h
                     mov ax, bx
                     mov ah, 035h
                     int 021h
                     mov ax, bx
                     mov di, 0200h
                     call PrintRegInDec
                     mov ax, es
                     mov di, 0106h
                     call PrintRegInDec
                  IntModCompEnd:
               IntMod75PerEnd:
            IntMod50PerEnd:
         IntModEnd:
      LegalModCondEnd:
      mov ah ,04ch
      int 21

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
