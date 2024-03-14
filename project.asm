;----- Daria Bulavina
;      Variant 3

.model small

;----- block of variables

.data

    file_name db 'test.in', 0      ; insert file name here before starting the program
    buffer_size equ 256
    buffer db buffer_size dup(0)
    error db 'Error has ocurred while opening the file$', 0
    
.code

main PROC

    ;----- initialization

     mov ax, @data      ; Set ax to data segment
     mov es, ax        


    ;----- attempt to open the file

    mov ah, 3Dh         ; DOS function for open file
    lea dx, file_name   ; pointer to the file name
    mov al, 0           ; access mode read-only
    int 21h             ; syscall (opening the file)


    ;----- termination of a program
    mov ax, 4C00h ; Terminate program
    int 21h

main ENDP
END main
