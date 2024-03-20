;----- Daria Bulavina
;      Variant 3

.model small

;----- block of variables

.data
    keys db 1000 dup (?) 
    values dw 1000 dup (?)

    keys_size db 6
    value_size db 16 

    ROW db 23 dup (?) 
    ROWS db 1000 dup (?)
    
    temp_key db 16 dup(?)
    temp_value db 6 dup(?)
    temp_key_length dw 0
    temp_value_length dw 0

    is_Negative db 0

    num_of_keys dw 0
    num_of_values dw 0

    temp_buffer dw 0
    
.code
main PROC

    ;----- initialization

        mov ax, @data
        mov ds, ax
        mov es, ax
        mov bx, 0
        
    ;----- clear screen

        mov al, 03h
        mov ah, 00h
        int 10h   

    ;----- read row from console

        read_row:
        mov ah,01
        int 21h

        cmp al, 13
        je string_end

        mov [ROW + bx],al
        cmp bx, 23
        inc bx
        jbe read_row
        mov bx, 0
        jmp write_row

        string_end:
        mov bx, 0
        jmp write_row

    ;----- split row to key and value

        split:
        mov bx, 0
        mov bp, 0

    ;----- read key to temp storage

        mov temp_key_length, 0
        read_key:
        cmp [ROW + bx], 32
        je read_value
        mov dl, [ROW + bx]
        mov [temp_key + bp], dl
        inc bx
        inc bp
        inc temp_key_length
        jmp read_key

    ;----- read value to temp storage

        mov temp_value_length, 0
        read_value:
        inc bx
        cmp [ROW + bx], 13
        je add_to_array
        mov dl, [ROW + bx]
        mov [temp_value + bp], dl
        inc bp
        inc temp_value_length
        jmp read_value

    ;----- add key to array with keys

        add_to_array:

        add_key:
        mov ax, num_of_keys
        mov bl, keys_size
        mul bx
        mov bx, ax
        mov bp, 0

        add_key_bytes:
        mov al, [temp_key + bp]
        mov [keys + bx], al
        cmp bp, temp_key_length
        inc bp
        jbe add_key_bytes
        jmp add_value

    ;----- add value to array with values

        add_value:
        mov dx, 0
        jmp check_sign
        
        add_value_to_array:
        mov bx, num_of_keys
        mov ax, temp_key
        mov [values + bx], ax
        inc num_of_keys

        ;jump back to get next line from user

    ;----- check if value is negative

        check_sign:

        mov ax, 0
        cmp [temp_value], '-'
        je negative_number
        jmp positive_number

    ;----- convert from ascii to hex for positive number

        positive_number:

        mov ax, 0
        mov dx, 0
        mov bx, temp_key_length
        mov cl, 1
        positive_loop:
        dec bx
        mov al, [temp_key + bx]
        sub al, 48
        mul cx
        add temp_buffer, ax
        mov dx, temp_buffer

        mov ax, 10
        mul cx
        mov cx, ax

        cmp bx, 0
        ja positive_loop
        mov ax, temp_buffer
        jmp add_value_to_array

    ;----- convert from ascii to hex for negative number

        negative_number:
        mov ax, 0
        mov dx, 0
        mov bx, temp_key_length
        mov cl, 1
        negative_loop:
        dec bx
        mov al, [temp_key + bx]
        sub al, 48
        mul cx
        add temp_buffer, ax
        mov dx, temp_buffer

        mov ax, 10
        mul cx
        mov cx, ax

        cmp bx, 1
        ja negative_loop
        mov ax, temp_buffer
        xor al, 255
        xor ah, 255
        add ax, 1
        mov temp_buffer, ax
        jmp add_value_to_array

    ;----- write row to console

        write_row:
        mov ah, 02h
        mov dx, offset [ROW + bx]
        int 21h

        cmp bx, 23
        inc bx
        jbe write_row

    ;----- termination of a program
        mov ah, 4ch
        int 21h

main ENDP
END main