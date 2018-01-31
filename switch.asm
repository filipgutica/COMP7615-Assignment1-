; Assemble as: nasm -f elf -g switch.asm
; Link as: ld -m elf_i386 -o switch switch.o

SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1
MAX_LEN   equ 11
MAX_NUM   equ 65535
MIN_NUM   equ 0


section .data ;Data segment
    InputNum1 db 'Enter num1: '
    InputNum2 db 'Enter num2: '
    InputNum3 db 'Enter num3: '
    StrLen equ $-InputNum3          ; All InputNum same size, can reuse
    InputNvalue dw 'Enter nValue: '
    StrLen2 equ $-InputNvalue
    Case0str db 'Case0: '
    Case1str db 'Case1: '
    Case2str db 'Case2: '
    Case3str db 'Case3: '
    StrLenCase equ $-Case3str
    strDefault db 'Default ', 0x0a
    StrLenDefault equ $-strDefault


section .bss    ;Uninitialized data
    num1    resb MAX_LEN  ;Reserve MAX_LEN bytes
    num2    resb MAX_LEN
    num3    resb MAX_LEN
    nvalue  resb MAX_LEN
    num     resb MAX_LEN


section .text   ;Code Segment
    global _start
_start:

  ;Prompt User for nvalue
  get_nvalue:
        mov eax, SYS_WRITE      ; write flag
        mov ebx, STDOUT         ; write to stdout
        mov ecx, InputNvalue    ; what to write
        mov edx, StrLen2        ; number of bytes to write
        int 80h


        ;Read and store the user input into nvalue
        mov eax, SYS_READ       ; read flag
        mov ebx, STDIN          ; read from stdin
        mov ecx, nvalue         ; read into nvalue
        mov edx, MAX_LEN        ; number bytes to be read
        int 80h

        ; convert nvalue to int
        mov edx, nvalue         ; put value to convert into edx
        call string_to_int      ; eax now contains integer result
        mov [nvalue], eax       ; move back into nvalue
        xor eax, eax            ; clear eax
        int 80h

        ; validate number
        mov eax, [nvalue]
        cmp eax, MAX_NUM
        jg get_nvalue
        cmp eax, MIN_NUM
        jl get_nvalue

  ;Prompt User for num1
  get_num1:
      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, InputNum1        ; write InputNum1 to stdout
      mov edx, StrLen           ; number of bytes to write
      int 80h


      ;Read and store the user input into num1
      mov eax, SYS_READ     ; read
      mov ebx, STDIN     ; descriptor value for stdin (read from stdin)
      mov ecx, num1
      mov edx, MAX_LEN         ;number bytes to be read
      int 80h

      ; convert num1 to int
      mov edx, num1
      call string_to_int      ;eax now contains integer
      mov [num1], eax
      xor eax, eax
      int 80h

      ; validate number
      mov eax, [num1]
      cmp eax, MAX_NUM
      jg get_num1
      cmp eax, MIN_NUM
      jl get_num1


  ;Prompt User for num2
  get_num2:
      mov eax, SYS_WRITE      ; write flag
      mov ebx, STDOUT         ; write to stdout
      mov ecx, InputNum2      ; what to write
      mov edx, StrLen         ; number of bytes to write
      int 80h

      ;Read and store the user input num2
      mov eax, SYS_READ       ; read flag
      mov ebx, STDIN          ; read from stdin
      mov ecx, num2           ; read data into num2
      mov edx, MAX_LEN        ; number bytes to be read
      int 80h

      ; convert num2 to int
      mov edx, num2
      call string_to_int      ; eax now contains integer
      mov [num2], eax
      xor eax, eax
      int 80h

      ; validate number
      mov eax, [num2]
      cmp eax, MAX_NUM
      jg get_num2
      cmp eax, MIN_NUM
      jl get_num2

  ;Prompt User for num3
  get_num3:
      mov eax, SYS_WRITE      ; write flag
      mov ebx, STDOUT         ; write to stdout
      mov ecx, InputNum3
      mov edx, StrLen         ; number bytes to write
      int 80h

      ;Read and store the user input num3
      mov eax, SYS_READ       ; read flag
      mov ebx, STDIN          ; read from stdin
      mov ecx, num3
      mov edx, MAX_LEN        ; number bytes to read
      int 80h

      ; convert num3 to int
      mov edx, num3
      call string_to_int      ; eax now contains integer
      mov [num3], eax
      xor eax, eax
      int 80h

      ; validate number
      mov eax, [num3]
      cmp eax, MAX_NUM        ; check if number is greater than 65535
      jg get_num3
      cmp eax, MIN_NUM        ; check if number is less than 0
      jl get_num3

  .switch:
      mov eax, [nvalue]       ; ++nvalue
      inc eax

      cmp eax, 0              ; case 0
      je case_0
      cmp eax, 1              ; case 1
      je case_1
      cmp eax, 2              ; case 2
      je case_2
      cmp eax, 3              ; case 3
      je case_3
  .default:
      mov eax, SYS_WRITE          ; write flag
      mov ebx, STDOUT             ; write to stdout
      mov ecx, strDefault         ; string to write
      mov edx, StrLenDefault      ; number of bytes to write
      int 80h

      ;Exit code
      mov eax, SYS_EXIT
      xor ebx, ebx
      int 80h


  case_0:
      mov eax, [num1]           ; move value of num1 to eax
      mov ecx, [num2]           ; move value of num2 to ecx
      imul eax, ecx             ; multiply eax and ecx
      mov [num], eax            ; move result into num
      xor eax, eax              ; clear eax
      int 80h

      ; Display Case0
      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, Case0str         ; write InputNum1 to stdout
      mov edx, StrLenCase       ; number of bytes to write
      int 80h


      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h

      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, num              ; write InputNum1 to stdout
      mov edx, StrLen           ; number of bytes to write
      int 80h

      ;Exit code
      mov eax, SYS_EXIT
      xor ebx, ebx
      int 80h

  case_1:
      mov eax, [num2]           ; move value of num1 to eax
      mov ecx, [num3]           ; move value of num2 to ecx
      imul eax, ecx             ; multiply eax and ecx
      mov [num], eax            ; move result into num
      xor eax, eax              ; clear eax
      int 80h

      ; Display Case1
      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, Case1str         ; string to write
      mov edx, StrLenCase       ; number of bytes to write
      int 80h

      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h


      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, num              ; string to write
      mov edx, StrLen           ; number of bytes to write
      int 80h

      ;Exit code
      mov eax, SYS_EXIT
      xor ebx, ebx
      int 80h

  case_2:
      mov eax, [num3]           ; move value of num3 to eax
      mov ecx, [num1]           ; move value of num1 to ecx
      sub eax, ecx              ; subtract eax - ecx
      mov [num], eax            ; move result into num
      xor eax, eax              ; clear eax
      int 80h

      ; Display Case2
      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, Case2str         ; string to write
      mov edx, StrLenCase       ; number of bytes to write
      int 80h

      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h

      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, num              ; string to write
      mov edx, StrLen           ; number of bytes to write
      int 80h

      ;Exit code
      mov eax, SYS_EXIT
      xor ebx, ebx
      int 80h

  case_3:
      mov eax, [num1]           ; move value of num1 to eax
      mov ecx, [num3]           ; move value of num3 to ecx
      sub eax, ecx              ; subtract eax - ecx
      mov [num], eax            ; move result into num
      xor eax, eax              ; clear eax
      int 80h

      ; Display Case3
      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, Case3str         ; string to display
      mov edx, StrLenCase       ; number of bytes to write
      int 80h

      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h

      mov eax, SYS_WRITE        ; write flag
      mov ebx, STDOUT           ; write to stdout
      mov ecx, num              ; string to write
      mov edx, StrLen           ; number of bytes to write
      int 80h

      ;Exit code
      mov eax, SYS_EXIT
      xor ebx, ebx
      int 80h



; Input:
; EDX = pointer to the string to convert
; Output:
; EAX = integer value
string_to_int:
    xor eax,eax           ; clear eax which will hold the result
.next_digit:
    movzx ecx ,byte[edx]  ; get one character
    inc edx               ; move pointer to next byte (increment)
    cmp ecx, '-'          ; check for handle_negative
    je .neg
    cmp ecx, '0'          ; check less than '0'
    jl .done
    cmp ecx, '9'          ; check greater than '9'
    jg .done
    sub ecx,  '0'         ; convert to ascii by subtracting '0' or 0x30
    imul eax, 10          ; prepare the result for the next character
    add eax, ecx          ; append current digit
    jmp .next_digit       ; keep going until done
.done:
    ret
.neg:
    mov eax, -1
    ret


; Input
; EAX = pointer to the int to convert
; EDI = address of the result
; Output:
; None
; Example of an in/out parameter function
int_to_string:
    xor   ebx, ebx        ; clear the ebx, I will use as counter for stack pushes
.push_chars:
    xor edx, edx          ; clear edx
    cmp eax, 0            ; check less then 0
    jl .handle_negative   ; handle negative number
.continue_push_chars:
    mov ecx, 10           ; ecx is divisor, devide by 10
    div ecx               ; devide edx by ecx, result in eax remainder in edx
    add edx, '0'          ; add '0' or 0x30 to edx convert int => ascii
    push edx              ; push result to stack
    inc ebx               ; increment my stack push counter
    cmp eax, 0            ; is eax 0?
    jg .push_chars        ; if eax not 0 repeat
    xor edx, edx

.pop_chars:
    pop eax               ; pop result from stack into eax

    stosb                 ; store contents of eax in edi, which holds the address of num... From stosb documentation:
                          ; After the byte, word, or doubleword is transferred from the AL, AX, or EAX register to
                          ; the memory location, the (E)DI register is incremented or decremented automatically
                          ; according to the setting of the DF flag in the EFLAGS register. (If the DF flag is 0,
                          ; the (E)DI register is incremented; if the DF flag is 1, the (E)DI register is decremented.)
                          ; The (E)DI register is incremented or decremented by 1 for byte operations,
                          ; by 2 for word operations, or by 4 for ; doubleword operations.
    dec ebx               ; decrement my stack push counter
    cmp ebx, 0            ; check if stack push counter is 0
    jg .pop_chars         ; not 0 repeat
    mov eax, 0x0a         ; add line feed
    stosb                 ; write line feed to edi => &num
    ret                   ; return to main

.handle_negative:
  neg eax                   ; make eax positive
  mov esi, eax              ; save eax into esi
  xor eax, eax              ; clear eax
  mov eax, '-'              ; put '-' into eax
  stosb                     ; write to edi => num memory location
  mov eax, esi              ; put original eax value back to eax
  xor esi, esi              ; clear esi
  jmp .continue_push_chars  ; continue pushing characters
