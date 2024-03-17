;----- Daria Bulavina
;      Variant 3

.model small

;----- block of variables

.data
    keys db 1000 dup (?) 
    values db 1000 dup (?)

    keys_size db 6
    value_size db 16 

    ROW db 23 dup (?) 
    ROWS db 1000 dup (?)
    
    temp_key db 16 dup(?)
    temp_value db 6 dup(?)
    temp_key_length dw 0
    temp_value_length dw 0

    num_of_keys dw 0
    num_of_values dw 0
    
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

        read_key:
        cmp [ROW + bx], 32
        je read_value
        mov dl, [ROW + bx]
        mov [temp_key + bp], dl
        inc bx
        inc bp
        jmp read_key

    ;----- read value to temp storage

        read_value:
        inc bx
        cmp [ROW + bx], 13
        je add_to_array
        mov dl, [ROW + bx]
        mov [temp_value + bp], dl
        inc bp
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
        ;setup
        ;turn ascii into decimal
        ;store it as hex number in array
        ;jump back to get next line from user

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