;----- Daria Bulavina
;      Variant 3

.model small

;----- block of variables

.data
    ;keys db 10000 * 17 DUP(?)  
    ;value db 10000 * 16 DUP(?)  
    temp_key db 8 dup(?)
    temp_value db 8 dup(?)
    prompt db 0dh,0ah,"Enter your string(7 Chars Max): $"
    msg1 db  0dh,0ah,"Your input: $"
    sev db 7 dup(?)
    
.code
main PROC

    ;----- initialization

        mov ax, @data
        mov ds, ax
        mov es, ax
        
    ;----- clear screen

        mov al, 03h
        mov ah, 00h
        int 10h   

    ;----- prep

        mov dx, offset prompt
        mov ah,09h
        int 21h
        lea si, temp_key
        mov cx,16

    ;----- read row from console

        read_row:
        mov ah,01
        int 21h
        mov [si],al
        inc si
        loop read_row

    ;----- print input

        mov si+sev,'$'
        mov dx,offset msg1
        mov ah,09h
        int 21h
        lea dx,temp_key
        mov ah,09h
        int 21h

    ;----- termination of a program
        mov ah, 4ch
        int 21h

main ENDP
END main
