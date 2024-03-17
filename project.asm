;----- Daria Bulavina
;      Variant 3

.model small

;----- block of variables

.data
    ;keys db 10000 * 17 DUP(?)  
    ;value db 10000 * 16 DUP(?) 
    ROW db 23 dup (?) 
    temp_key db 8 dup(?)
    temp_value db 8 dup(?)
    
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

    ;----- read row from console

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
