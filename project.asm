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

    ;----- add key and values to arrays

        add_to_array:

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
