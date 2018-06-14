.model small


.code

Main:
      mov ax, 010h
      OneMinuteLoop:
         push cx
         xor cx,cx
         DeleyLoop:
            nop
            loop DeleyLoop
         DeleyLoopEnd:
         pop cx
         dec ax
         jnz OneMinuteLoop
      OneMinuteLoopEnd:
      mov ah, 4ch
      int 21h
end Main
