
.model small
.stack 0f000h
.data
	array db 5, 1, 26, -74, 5, -3, 98,-74
	array_len equ ($-array);
.code
START:
   ;init data segment
   mov bx, @data
   mov ds, bx
   ;store array location
   mov bx, offset array
	mov ax, 0b800h
   mov es,ax
   ;store num of elements in arr
   mov cx, array_len
   ;storing registers
   push cx
	push bx
	push si
   ;setting screen offset for print function
   mov bx, 09ach
   call printArr
   pop si
   pop bx
	pop cx
   ;sort array
	call mergeSortSplit
   push cx
	push bx
	push si
   ;setting screen offset for print function
   mov bx, 0a4ch
   call printArr
   ;not needed, but important if this code is used twice
   pop si
   pop bx
	pop cx
   ;return to OS
   mov ax, 4c00h
   int 21h
   ;recursive merge sort function function for spliting the arrey in each iteration.
   ;when reaching arr of size of 1, start marging the small array and sort them by calling mergeSortMerge, eventually reaching a sorted array.
   mergeSortSplit PROC NEAR
   	push bx
   	push cx
      ;checking if arr is a 1 element array
      cmp cx, 01h
   	jnz condOneElementEnd
      condOneElement:
   		pop cx
   		pop bx
   		ret
      condOneElementEnd:
      ;mov to ax because of div
      mov ax, cx
      ;needed? not sure %$%$%$%$%%$%$$%$%$% - get out if not needed after debug
      xor dx, dx
      ;divide by 2
      mov cx, 02h
   	div cx
      ;num of elements
      mov cx, ax
      ;add to remainder the number of values
      add ax, dx
      ;empty ax for later, save num of second elements
      mov dx, ax
   	push dx
   	push bx
      ;store registers as the recursive call will currept the data
      push cx
      ;do continue split on first half
      call mergeSortSplit
      ;get saved values, recursive call ended
      pop cx
   	pop bx
   	pop dx
      ;bx point is the first element in the first splitted array. add half of the elemmets, to get the correct position of the second half
      add bx, cx
      ;save data to the same regs for compatability with the same function
      mov ax, cx
   	mov cx, dx
      ;store registers as the recursive call will currept the data
      push ax
   	push bx
   	push cx
   	push dx
      ;do merge sort on the second half of the array
   	call mergeSortSplit
      ;restore data form registers
      pop dx
   	pop cx
   	pop bx
   	pop ax
      ;save num of half the element, another div instruction is less efficient
      mov dx,cx
      ;get original num of element in the array
      pop cx
      ;get origianl position
      pop bx                    ;starting point
      ;save value as merge function will currept the data
      push bx
   	push cx
      ;merge and sort the arrays
      call mergeSortMerge
      ;get original num of element in the array
      pop cx
      ;get origianl position
      pop bx
   	ret
   mergeSortSplit endp

   ;the function compare elements from the two halves and inserting the smaller to the array
   mergeSortMerge PROC NEAR
         ;init as index for first array
         mov si,00h
         ;ax contain the num of elements in one array, therfore, it will start in the second array
         mov di,ax
         ;set dx as stop cond for the second array, as ax is the stopping cond for the first array
         add dx,ax
   		sortElement:
            mov ch,[bx+di]
      		mov cl,[bx+si]
            ;cmp each element
            cmp cl, ch
      		jl condLeftArrEleBigElse
            condLeftArrEleBig:
               ;set ch in cl, in order to keep the value
               mov cl, ch
               ;zero ch
               xor ch, ch
               ;push value to stack
               push cx
               ;increse index
               inc di
               ;check if the end of stack
               cmp di, dx
               ;loop if false
               jnz sortElement
               ;break if true
               jmp sortElementEnd
      		condLeftArrEleBigElse:
               ;zero ch
               xor ch, ch
               ;push value to stack
               push cx
               ;increase index
               inc si
               ;loop if false
               cmp si,ax
               ;break if true
      			jnz sortElement
         sortElementEnd:
         ;check if there are spare elements in the second arrey
         cmp di,dx
         jz secondArrNotDoneEnd
         ;loop until all elements in the second arrey are in the stack
         secondArrNotDone:
            ;pad cx with zero
            xor ch, ch
            ;get current element
            mov cl, [bx+di]
            push cx
            ;next element
            inc di
            ;check if done
            cmp di,dx
            ;loop if false
            jnz secondArrNotDone
         secondArrNotDoneEnd:
         ;check if there are spare elements in the second arrey
         cmp si, ax
         jz firstArrNotDoneEnd
         ;loop until all elements in the second arrey are in the stack
         firstArrNotDone:
            ;pad cx with 0
            xor ch, ch
            ;get current element
            mov cl, [bx+si]
            push cx
            ;next element
            inc si
            ;check if done
            cmp si,ax
            ;loop if flase
            jnz firstArrNotDone
         firstArrNotDoneEnd:
   		emptyStack:
            ;smaller element
            dec di
            ;pop to ax
            pop ax
            ;insert only relevent part
            mov [bx+di], al
            ;check if all elements are emptied
            cmp di, 00h
            ;loop if false
   			jnz emptyStack
         emptyStackEnd:
   		ret
   mergeSortMerge endp

   ;printing array function. althogh not priting in ascii, its easier to debug then using cv.
   printArr PROC NEAR
      ;zero si
      xor si, si
      printLoop:
         ;value form array
         mov al, array[si]
         ;color
         mov ah, 12h
         ;print to screen
         mov es:[bx], ax
         ;increase offset, as it's known that each element in the array is of size 1 byte
         add bx, 02h
         ;next element
         inc si
         ;condition for looping
         cmp si, cx
         jnz printLoop
      printLoopEnd:
      ret
   printArr endp
   end START
