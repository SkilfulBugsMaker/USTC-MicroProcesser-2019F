.model small

.data
    inbuffer db 100 , ? , 100 dup(?)
    pos dw 0
    len db 00h
    prevop db 00h
    result dw 0
.stack 40960

.code

getline proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    lea dx, inbuffer
    mov ah, 0ah
    int 21h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
getline endp

eval proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov di, word ptr pos
    mov cl, byte ptr len
    mov ch, 00h
    mov ax, 0

    .while di < cx
        mov dl, inbuffer[di+2]
        .if dl >= '0' && dl <= '9'
            sub dl, 30h
            mov dh, 00h
            mov bl, 10
            mul bl
            add ax, dx
        .elseif dl == '+' || dl == '-'
            mov bl, prevop
            .if bl == '+'
                mov bx, word ptr result
                add ax, bx
                mov word ptr result, ax
            .elseif bl == '-'
                mov bx, word ptr result
                sub bx, ax
                mov word ptr result, bx
            .else
                mov word ptr result, ax
            .endif
            mov prevop, dl

            

            mov ax, 0
        .elseif dl == '('
            add di, 1
            mov word ptr pos, di

            mov bl, prevop
            mov bh, 0
            push bx
            mov byte ptr prevop, 0

            mov bx, word ptr result
            push bx
            mov word ptr result, 0

            call eval
            
            mov ax, word ptr result

            pop bx
            mov word ptr result, bx

            pop bx
            mov byte ptr prevop, bl

            mov di, word ptr pos

        .elseif dl == ')'
            mov bl, prevop
            .if bl == '+'
                mov bx, word ptr result
                add ax, bx
                mov word ptr result, ax
            .elseif bl == '-'
                mov bx, word ptr result
                sub bx, ax
                mov word ptr result, bx
            .else
                mov word ptr result, ax
            .endif
            jmp return
        .endif
        add di, 1
        mov word ptr pos, di
    .endw

    .if di == cx
        mov cl, prevop
        .if cl == '+'
            mov bx, word ptr result
            add ax, bx
            mov word ptr result, ax
        .elseif cl == '-'
            mov bx, word ptr result
            sub bx, ax
            mov word ptr result, bx
        .else
            mov word ptr result, ax
        .endif
    .endif


return:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
eval endp

printnumber proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov dl, 10
    call printchar

    .if sword ptr ax < 0
        mov dl, '-'
        call printchar
        neg ax
    .endif

    mov cx, 0
    mov bl, 10
    div bl
    mov dh, 00h
    mov dl, ah
    push dx
    inc cx

    .while al != 0
        mov ah, 00h
        mov bl, 10
        div bl
        mov dh, 00h
        mov dl, ah
        push dx
        inc cx
    .endw

    .while cx > 0 
        pop dx
        add dx, 30h
        call printchar
        dec cx
    .endw

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
printnumber endp

printchar proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov ah, 02h
    int 21h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
printchar endp


.startup

    call getline

    ; cx is count, dx is buffer, ax is value
    mov al, inbuffer[1]
    mov len, al

    call eval


    mov ax, word ptr result
    call printnumber


.exit
end