;yarin kimhi 308337641
.model small
.stack 100h
.data
Old_int_off dw 0h
Old_int_seg dw 0h 
counter_msec dw 0h
counter_sec dw 0h
counter_min dw 0h

.code
START:
getISR:
	mov bx, @data 
    mov ds, bx

	mov al,08h
	mov ah,35h
	int 21h			           ;save the adress of the old int 08h
	mov Old_int_off,bx
	mov Old_int_seg,es
	mov ah,25h
	mov dx,newISR
	push ds
	push cs
	pop ds
	cli
	int 21h
	sti
	pop ds	
	L1:
	jmp L1
	
newISR proc near
		pushf
		mov bx,Old_int_seg
		mov es,bx
		JMP DWORD PTR [Old_int_off];
		
		
		cmp counter_msec,1000d      ;check if pass a full secound
		jl cont1
		sub counter_msec,1000d
		add counter_sec ,1h
 cont1: mov ax,counter_msec			;adding 55msec to the msec section
		add ax,55d
		mov si,0b0h		;set the screen index
		mov es:[si],ax 
		call print
		
		cmp counter_sec,60d			;checks if pass a full mintue
		jnz cont2
		mov counter_sec,0d
		add counter_min,1h
 cont2: mov ax,counter_sec
		mov si,0b0h		;set the screen index
		add si,8h
		call print
		
		mov ax,counter_min				;adding the time passed to the mintues section
		mov si,0b0h		;set the screen index
		add si,16h
		call print
		
		mov si,0b0h
		mov al ,20h
		out 20h,al
		iret
newISR endp		


print proc	
	mov bx,0ah		;set bx to be 10 in dec	
	mov dx, 0b800h 
	mov es, dx		;set place for es
positive: ;positive section ment for printing positive numbers
	xor dx,dx ;initiliaz dx to zero
	div bx	;divide ax in 10
	add dx,030h ;adding 30 to dx to get the ascii number
	mov cl,dl	
	mov ch,10h
	mov es:[si],cx ;printing to the screen the number 
	sub si,02h ;getting the screen index back 
	cmp ax,0 
	jnz positive 
	ret
print endp	
mov ax, 4c00h
int 21h
end START

