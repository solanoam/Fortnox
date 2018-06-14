.model small
.stack 100h
.data
    ;init arr
    arr DB '1', '2', '3', '4', '5'
.code
    ;setting data segment      
    mov ax, @data 
    mov ds, ax 
    ;set screen segment
    mov ax, 0b800h 
    mov es, ax
    mov ah, 48d
    mov si, 4
    mov bx, 0f96h
    mov dx, 5
L1: mov al, arr[si]
    mov cl, al
    mov ch, ah
    mov es:[bx], cx
    add ah, 17
    add bx, 02h
    dec si
    dec dx
    jnz L1
    ;return to OSs
    mov ax, 4c00h
    int 21h 
end
