.model small
.stack 100h
.data
    ;init arr
    array db 5, 1, 26, -74, 5, -3, 98,-74
    array_len equ ($-array)
.code
START:
    ;setting data segment
    mov ax, @data
    mov ds, ax
    ;getting arr len
    mov cx, array_len
    ;calibrating to arr indexing
    dec cx
    ;zeroing dx
    xor dx, dx
    sortLoop:
        ;first setting rightmost elemnt to min 
        mov si, cx
        mov al, array[si]
        mov di, si
        innerSortLoop:
            ;move to next element
            dec si
            mov ah, array[si]
            ;cmp current element to min
            cmp al, ah
            jl updateMinEnd
            ;update current min if needed
            updateMin:
                ;update value
                mov al, ah
                ;update location
                mov di, si
            updateMinEnd:
            ;loop until you reached the end of the arr
            cmp si, dx
            jnz innerSortLoop
        innerSortLoopEnd:
        ;mov min to first location
        mov bh, array[si]
        mov array[di], bh
        mov array[si], al
        ;decrese the arr size from the left side
        inc dx
        ;loop until the arr size is 1
        cmp dx, cx
        jnz sortLoop
    sortLoopEnd:
    ;return to OSs
    mov ax, 4c00h
    int 21h
end START
