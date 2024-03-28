;----- Daria Bulavina
;      Variant 3

.model small
.stack 100h

.data

NUM_OF_KEYS_REMOVED dw 0
NUM_OF_KEYS_BYTES dw 0

LENGTH_PRINTING_KEY db 0
LAST_INDEX_VALUE dw 0
LAST_INDEX_KEY dw 0

LAST_INDEX_I dw 0
LAST_INDEX_J dw 0

TEMP_SUM_HI dw 0
TEMP_SUM_LO dw 0
TEMP_NUM_OF_REPS dw 1

KEYS db 23000 dup (?)
H_VALUES dw 6000 dup (?)

TEMP_VALUE db 6 dup (0)
TEMP_VALUE_SIZE dw 0
TEMP_VALUE_BUFFER dw 0

DUMP db 29000 dup (?)

BYTES_READ dw 0;
BYTES_CHECKED dw 0;

LAST_BX_INDEX dw 0;
LAST_CX_INDEX dw 0
TEMP_L dw 0

LAST_INDEX dw 0;
NUM_OF_KEYS dw 0

BX_VALUES_INDEX dw 0;

KEY_SIZE db 16
VALUE_SIZE db 6

.code
start PROC

    mov ax, @data
    mov ds, ax

read_file:

    mov ah, 3Fh       
    mov bx, 0        
    mov cx, 23000       
    mov dx, offset [DUMP] 
    int 21h         
    mov BYTES_READ, ax

init_arrays:

    mov bx, 16
    mov ax, NUM_OF_KEYS
    mul bx
    mov cx, ax

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

        fill_value:

            mov bx, LAST_INDEX
            mov al, [DUMP + bx]

            cmp al, 13
            je to_hex
            cmp al, 10
            je to_hex
            cmp al, 0
            je to_hex
            cmp al, 255
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
                mov ax, 0
                mov al, [TEMP_VALUE + bx]

                cmp al, '-'
                je negative_number

                sub ax, 48

                mul cx
                add TEMP_VALUE_BUFFER, ax

                mov ax, 10
                mul cx
                mov cx, ax

                cmp bx, 0
                jg convert
                mov ax, TEMP_VALUE_BUFFER
                jmp end_of_convertion

            negative_number:

                mov ax, TEMP_VALUE_BUFFER
                xor al, 255
                xor ah, 255
                add ax, 1
                mov TEMP_VALUE_BUFFER, ax
                jmp end_of_convertion

            end_of_convertion:

                mov bx, BX_VALUES_INDEX
                mov [H_VALUES + bx], ax
                jmp prep_for_loop

        prep_for_loop:

            add BX_VALUES_INDEX, 2

            inc LAST_INDEX
            inc BYTES_CHECKED
            inc LAST_INDEX
            inc BYTES_CHECKED
            inc NUM_OF_KEYS

            mov TEMP_VALUE_SIZE, 0
            mov TEMP_VALUE_BUFFER, 0

            mov cx, 6
            clear_buffer:
                mov bx, cx
                mov [TEMP_VALUE + bx], 0
                cmp cx, 0
                dec cx
                jne clear_buffer
        
            mov cx, BYTES_READ
            cmp BYTES_CHECKED, cx
            jae setup_remove_dubl ;;тут поставила шнягу для перевірки на дублікати
            jmp init_arrays

    setup_remove_dubl:

        mov bx, 0 ;starting index of a key
        mov dx,  [H_VALUES + bx]
        add TEMP_SUM_LO, dx
        mov cx, 1 ; starting index of a key for the second key
        mov ax, 0

        check_each_key:

            mov LAST_BX_INDEX, bx   ;зберігання індексів перед викликом функцій
            mov LAST_CX_INDEX, cx

            call compareStrings

            cmp al, 49
            je remove_key

            inc LAST_CX_INDEX
            mov cx, LAST_CX_INDEX

            cmp cx, NUM_OF_KEYS
            jge next_key
            jmp check_each_key

        remove_key:   
        ;прибирання дублікатного ключа та додавання його значення до суми, розрахування кількості однакових
        ;ключів 

            mov LAST_BX_INDEX, bx   ;зберігання індексів перед викликом функцій
            mov LAST_CX_INDEX, cx

            mov ax, 2
            mul cx
            mov bx, ax    ;додавання до темп суми...
            mov dx, [H_VALUES + bx]
            add TEMP_SUM_LO, dx 

            inc TEMP_NUM_OF_REPS

            mov bx, LAST_BX_INDEX
            mov cx, LAST_CX_INDEX

            call deleteKeys
            mov bx, LAST_BX_INDEX ;повернення ідексів у bx та сх

            inc LAST_CX_INDEX
            mov cx, LAST_CX_INDEX

            cmp cx, NUM_OF_KEYS
            jge next_key
            jmp check_each_key


        next_key:
        ;перехід bx на наступний індекс, перевірка чи цей ключ пустий
        ;перевірити чи bx досягло кількість заг ключів
        ;якщо досягло, то прибирання однакових ключів завершено, тоді
        ;стрибаємо до сортування

            ;ділення заг суми bx числа на кількість входження

            test TEMP_SUM_LO, 8000h
            je not_negg
            jmp negg

            negg:
                not TEMP_SUM_LO

            not_negg:

            mov dx, 0
            mov ax, TEMP_SUM_LO
            mov bx, TEMP_NUM_OF_REPS

            div bx ; ділення dx:ax / num of reps    - в ах результат
            mov cx, ax

            mov bx, LAST_BX_INDEX
            mov ax, 2
            mul bx
            mov bx, ax

            mov [H_VALUES + bx], cx ;- збереження average

            mov TEMP_NUM_OF_REPS, 1
            mov TEMP_SUM_HI, 0
            mov TEMP_SUM_LO, 0 ; очищення тимчачових сум для average

            inc LAST_BX_INDEX
            mov bx, LAST_BX_INDEX
            
            ; перевірити ключ правильно сортує... але не прибирає чогось дублікати. 
            mov ax, 2
            mul bx
            mov bx, ax

            mov dx, [H_VALUES + bx]
            add TEMP_SUM_LO, dx
            mov bx, LAST_BX_INDEX

            mov LAST_CX_INDEX, bx
            inc LAST_CX_INDEX
            mov cx, LAST_CX_INDEX

            cmp cx, NUM_OF_KEYS
            jge sort_buble_prep ;з богом

            cmp bx, NUM_OF_KEYS
            jge sort_buble_prep  ;з богом

            jmp check_each_key

    
    sort_buble_prep: 
        mov LAST_INDEX_I, 0
        mov LAST_INDEX_J, 0
        mov bx, LAST_INDEX_KEY

        loop_i:
            loop_j:
                mov bx, LAST_INDEX_KEY
                mov ax, [H_VALUES + bx]
                add LAST_INDEX_KEY, 2
                mov bx, LAST_INDEX_KEY
                mov cx, [H_VALUES + bx]
                cmp ax, cx
                jl swap_value
                jmp inc_loop_index

        swap_value:
            call swapKeys

        inc_loop_index:

            inc LAST_INDEX_J
            mov ax, NUM_OF_KEYS
            dec ax
            cmp LAST_INDEX_J, ax
            jne loop_i

            mov LAST_INDEX_KEY, 0
            mov LAST_INDEX_J, 0
            inc LAST_INDEX_I
            inc ax
            cmp LAST_INDEX_I, ax
            jl loop_i
            jmp end_program

    end_program:
        mov LAST_INDEX, 0
        mov ax, 16
        mov bx, NUM_OF_KEYS
        mul bx
        mov NUM_OF_KEYS_BYTES, ax

        print_result_prep:
            mov bx, LAST_INDEX
            cmp bx, 1500
            jg final

            check_key:
                mov dl, [KEYS + bx]
                cmp dl, 0
                je skip
                jmp print_key

            skip:
                add LAST_INDEX, 16
                jmp print_result_prep
            
            print_key:

                mov dl, [KEYS + bx]
                cmp dl, 0
                je print_next

                mov ah, 02h
                int 21h

                inc bx
                jmp print_key

            print_next:

                mov dl, 13
                mov ah, 02h
                int 21h

                mov dl, 10
                int 21h

                add LAST_INDEX, 16
                jmp print_result_prep

        final:
            mov ax, 4C00h   
            int 21h          

start ENDP

swapKeys PROC

    mov bx, LAST_INDEX_J
    mov ax, 2
    mul bx
    mov bx, ax

    mov ax, [H_VALUES + bx]
    add bx, 2
    mov cx, [H_VALUES + bx]
    sub bx, 2
    mov [H_VALUES + bx], cx
    add bx, 2
    mov [H_VALUES + bx], ax

    mov bx, LAST_INDEX_J
    mov ax, 16
    mul bx
    mov bx, ax

    mov si, bx
    add si, 16 ;коефіцієнти

    mov cx, 0

        swap_chars:
            mov al, [KEYS + bx]
            mov ah, [KEYS + si]
            mov [KEYS + bx], ah
            mov [KEYS + si], al
            inc cx
            inc bx
            inc si
            cmp cx, 16
            jne swap_chars
    ret
swapKeys ENDP

deleteKeys PROC

    ;cx - індекс елемента, який треба видалити

    mov ax, 2   ;видаляє значення дублікатного числа
    mul cx
    mov bx, ax
    mov [H_VALUES + bx], 0

    mov ax, 16
    mul cx
    mov bx, ax ;позиція ключа в загальному масиві
    xor ax, ax

        clear_key_chars:

            mov [KEYS + bx], 0
            inc bx
            inc ax
            cmp ax, 16
            jl clear_key_chars

        ret

deleteKeys ENDP

compareStrings PROC

    mov bx, LAST_BX_INDEX
    mov ax, 16
    mul bx
    mov bx, ax

    mov cx, LAST_CX_INDEX
    mov ax, 16
    mul cx
    mov cx, ax

    mov TEMP_L, bx
    add TEMP_L, 16

    check_characters:

        mov al, [KEYS + bx]
        xchg bx, cx 
        cmp [KEYS + bx], al
        xchg bx, cx 
        jne not_equal

        inc bx
        inc cx
        cmp bx, TEMP_L
        je equal
        jmp check_characters
    
    equal:
        mov al, 49
        mov bx, LAST_BX_INDEX
        mov cx, LAST_CX_INDEX
        jmp ending

    not_equal:
        mov al, 48
        mov bx, LAST_BX_INDEX
        mov cx, LAST_CX_INDEX

        jmp ending

    ending:
        ret

compareStrings ENDP
END start