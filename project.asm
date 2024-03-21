;----- Daria Bulavina
;      Variant 3

.model small
.stack 100h

.data

KEYS db 1000 dup (?)
VALUES db 1000 dup (?)

TEMP_VALUE db 6 dup (?)
TEMP_VALUE_SIZE dw 0
TEMP_VALUE_BUFFER dw 0

H_VALUES dw 1000 dup (?)

DUMP db 23000 dup (?)

BYTES_READ dw 0;
BYTES_CHECKED dw 0;

LAST_INDEX dw 0;
NUM_OF_KEYS dw 0

KEY_SIZE db 16
VALUE_SIZE db 6

.code
start PROC

    mov ax, @data
    mov ds, ax

read_file:

    mov ah, 3Fh       ; Function to read from file
    mov bx, 0         ; File handle for stdin
    mov cx, 23000       ; Number of bytes to read
    mov dx, offset [DUMP] ; Read to ds:dx
    int 21h           ; Number of bytes read returned in AX
    mov BYTES_READ, ax
    jmp end_reading_file    


end_reading_file:

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
        mov cx, 0
        jmp fill_value

        fill_value:

            mov bx, LAST_INDEX
            mov al, [DUMP + bx]

            cmp al, 13
            je to_hex
            cmp al, 10
            je to_hex

            mov bx, cx
            mov [TEMP_VALUE + bx], al

            inc cx
            inc LAST_INDEX
            inc BYTES_CHECKED
            inc TEMP_VALUE_SIZE

            jmp fill_value

        to_hex:

            mov ax, 0
            mov dx, 0
            mov bx, TEMP_VALUE_SIZE
            mov cx, 1
            jmp convert

            convert:

                dec bx
                mov al, [TEMP_VALUE + bx]

                cmp al, '-'
                je negative_number

                sub al, 48

                mul cx
                add TEMP_VALUE_BUFFER, ax

                mov ax, 10
                mul cx
                mov cx, ax

                cmp bx, 0
                ja convert
                mov ax, TEMP_VALUE_BUFFER
                jmp end_of_convertion

            negative_number:

                mov ax, TEMP_VALUE_BUFFER
                xor al, 255
                xor ah, 255
                add ax, 1
                jmp end_of_convertion

            end_of_convertion:

                mov bx, NUM_OF_KEYS
                mov [H_VALUES + bx], ax
                jmp prep_for_loop

        prep_for_loop:


            inc LAST_INDEX
            inc BYTES_CHECKED
            inc LAST_INDEX
            inc BYTES_CHECKED
            inc NUM_OF_KEYS

            mov TEMP_VALUE_SIZE, 0
            mov TEMP_VALUE_BUFFER, 0
        
            mov cx, BYTES_READ
            cmp BYTES_CHECKED, cx
            jae end_program
            jmp init_arrays

    setup_remove_dubl:


    
    end_program:

        mov bx, 0

        write:
            mov dx, NUM_OF_KEYS
            ; mov dl, [TEMP_VALUE + bx]
            mov ah, 02h
            int 21h
            inc bx
            cmp bx, 17
            jne write

            mov ax, 4C00h   
            int 21h          

start ENDP

END start