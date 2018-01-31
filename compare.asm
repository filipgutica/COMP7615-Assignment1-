; Assemble as: nasm -f elf -g compare.asm
; Link as: ld -m elf_i386 -o compare compare.o

section .data ;Data segment
	InputNUm db 'Enter a number: ' ;Ask the user to enter a number
	StrLen equ $-InputNUm          ;The length of the message



section .bss    ;Uninitialized data
    num1 resb 5  ;Reserve 5 bytes
    num2 resb 5
    num3 resb 5

    first   resb 5
    second  resb 5
    third   resb 5

section .text   ;Code Segment
    global _start
_start:
    ;Prompt User for num1
    mov eax, 4     ; write to
    mov ebx, 1     ; descriptor value for stdout write to stdout
    mov ecx, InputNUm
    mov edx, StrLen
    int 80h
    

    ;Read and store the user input into num1
    mov eax, 3     ; read
    mov ebx, 0     ; descriptor value for stdin (read from stdin)
    mov ecx, num1
    mov edx, 5     ;5 bytes (numeric, 1 for sign) of that information
    int 80h

    ;Prompt User for num2
    mov eax, 4     ; write to
    mov ebx, 1     ; descriptor value for stdout write to stdout
    mov ecx, InputNUm
    mov edx, StrLen
    int 80h

    ;Read and store the user input num2
    mov eax, 3     ; read
    mov ebx, 0     ; descriptor value for stdin (read from stdin)
    mov ecx, num2
    mov edx, 5     ;5 bytes (numeric, 1 for sign) of that information
    int 80h

    ;Prompt User for num3
    mov eax, 4     ; write to
    mov ebx, 1     ; descriptor value for stdout write to stdout
    mov ecx, InputNUm
    mov edx, StrLen
    int 80h

    ;Read and store the user input num3
    mov eax, 3     ; read
    mov ebx, 0     ; descriptor value for stdin (read from stdin)
    mov ecx, num3
    mov edx, 5     ;5 bytes (numeric, 1 for sign) of that information
    int 80h


    ;Compare num1 and num2
    mov eax, [num1]
    mov ebx, [num2]
    cmp eax, ebx
    jge num1_greater_num2       ;num1 is bigger than num2
    jl num2_greater_num1        ;num2 is bigger than num1
    mov eax, 1
    int 80h



num1_greater_num2:
    mov [first], eax            ;num1 is in eax, move into first
    mov [second], ebx           ;num2 is in ebx. move into second

    ;compare num1 and num3
    mov ebx, [num3]             ;move num3 into ebx
    mov eax, [num1]             ;move num1 into eax
    cmp ebx, eax                ;compare num3 and num1
    jge num3_greater_num1
    jl num1_greater_num3


num3_greater_num1:              ;num3 is bigger than num1
    mov [first], ebx            ;we know num1 is bigger than num2
                                ;since num3 is bigger than num1 move
                                ;num3 into first
    mov [second], eax           ;move num1 which is in eax into "second"
    mov ebx, [num2]             ;move num2 into ebx
    mov [third], ebx            ;move ebx into third
    jmp output                  ;print results

num1_greater_num3:              ;num1 is still largest
    mov [first], eax            ;move num1 which is still in eax
                                ;into first
    mov eax, [num2]             ;num2 into eax
    mov ebx, [num3]             ;num3 into ebx
    cmp eax, ebx                ;compare num2 and num3
    jge num1_num2_num3          ;num2 second num3 third
    jl num1_num3_num2           ;num3 second num2 third

num1_num3_num2:
    mov [second], ebx
    mov [third], eax
    jmp output

num1_num2_num3:
    mov [second], eax
    mov [third], ebx
    jmp output



num2_greater_num1:
    mov [first], ebx        ;num2 which is in ebx into first
    mov [second], eax       ;num1 which is in eax into second

    mov ebx, [num3]
    mov eax, [num2]
    cmp ebx, eax            ;compare num3 with num2
    jge num3_greater_num2
    jl num2_greater_num3


num3_greater_num2:          ;num3 is the biggest, more into first
    mov [first], ebx
    mov [second], eax       ;we know num2 is bigger than num1 so num2 is second
    mov ebx, [num1]
    mov [third], ebx        ;num1 is third
    jmp output              ;print output

num2_greater_num3:          ;num2 is still largest
    mov [first], eax
    mov eax, [num1]
    mov ebx, [num3]
    cmp eax, ebx            ;compare num1 and num3
    jge num2_num1_num3      ;num1 second num3 third
    jl num2_num3_num1       ;num3 second num1 third

num2_num3_num1:
    mov [second], ebx
    mov [third], eax
    jmp output

num2_num1_num3:
    mov [second], eax
    mov [third], ebx
    jmp output



output:
    ;Output the number entered
    mov eax, 4
    mov ebx, 1
    mov ecx, first
    mov edx, 5
    int 80h
    ;Output the number entered
    mov eax, 4
    mov ebx, 1
    mov ecx, second
    mov edx, 5
    int 80h
    ;Output the number entered
    mov eax, 4
    mov ebx, 1
    mov ecx, third
    mov edx, 5
    int 80h


; Exit code
    mov eax, 1
    mov ebx, 0
    int 80h
