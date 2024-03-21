;----- Daria Bulavina
;      Variant 3

.model small
.stack 100h

.data

KEYS db 1000 dup (?)
VALUES db 1000 dup (?)
H_VALUES dw 1000 dup (?)
DUMP db 23000 dup (?)

BYTES_READ dw 0;
BYTES_CHECKED dw 0;
NUM_OF_ROWS dw 0;

LAST_INDEX dw 0;
NUM_OF_KEYS dw 0

KEY_SIZE db 16
VALUE_SIZE db 6

.code
start PROC

    mov ax, @data
    mov ds, ax

read_next:

    mov ah, 3Fh       
    mov bx, 0         
    mov cx, 23000       
    mov dx, offset [DUMP] 
    int 21h         
    mov BYTES_READ, ax
    jmp init_arrays   

init_arrays:

    mov bx, 16
    mov ax, NUM_OF_KEYS
    mul bx
    mov cx, ax
    jmp fill_key

    fill_key:

        mov bx, LAST_INDEX

        mov al, [DUMP + bx]
        cmp al, 32
        je setup_value

        mov bx, cx
        mov [KEYS + bx], al

        inc cx
        inc LAST_INDEX
        inc BYTES_CHECKED

        jmp fill_key


    setup_value:

        inc BYTES_CHECKED
        inc LAST_INDEX
        mov ax, NUM_OF_KEYS
        mov bx, 6
        mul bx
        mov cx, ax
        jmp fill_value

        fill_value:

            mov bx, LAST_INDEX
            mov al, [DUMP + bx]

            cmp al, 13
            je prep_for_loop
            cmp al, 10
            je prep_for_loop

            mov bx, cx
            mov [VALUES + bx], al

            inc cx
            inc LAST_INDEX
            inc BYTES_CHECKED

            jmp fill_value
        
        prep_for_loop:

            inc LAST_INDEX
            inc NUM_OF_KEYS
            inc BYTES_CHECKED
            inc LAST_INDEX
            inc BYTES_CHECKED

            mov cx, BYTES_READ
            cmp BYTES_CHECKED, cx
            jae end_program
            jmp init_arrays
    
end_program:

    mov bx, 0
    write:
    mov dl, [VALUES + bx]
    mov ah, 02h
    int 21h
    inc bx
    cmp bx, 7
    jne write

    mov ax, 4C00h   
    int 21h          

start ENDP

END start