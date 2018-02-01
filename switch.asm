; Assemble as: nasm -f elf -g switch.asm
; Link as: ld -m elf_i386 -o switch switch.o

SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1
MAX_LEN     equ 6
MAX_NUM     equ 65535
MIN_NUM     equ 0


section .data ;Data segment
    InputNum1     db 'Enter num1: ', 0
    InputNum2     db 'Enter num2: ', 0
    InputNum3     db 'Enter num3: ', 0
    InputNvalue   db 'Enter nValue: ', 0
    Case0str      db 'Case0: ', 0
    Case1str      db 'Case1: ', 0
    Case2str      db 'Case2: ', 0
    Case3str      db 'Case3: ', 0
    strDefault    db 'Default ', 0x0a, 0


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
        mov ecx, InputNvalue      ; write InputNum1 to stdout
        call print_string
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
      mov ecx, InputNum1        ; write InputNum1 to stdout
      call print_string
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
      mov [num1], eax         ;put back into num1
      xor eax, eax            ;clear eax
      int 80h

      ; validate number
      mov eax, [num1]
      cmp eax, MAX_NUM
      jg get_num1
      cmp eax, MIN_NUM
      jl get_num1


  ;Prompt User for num2
  get_num2:
      mov ecx, InputNum2      ; what to write
      call print_string
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
      mov ecx, InputNum3
      call print_string
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
      mov ecx, strDefault         ; string to write
      call print_string
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
      mov ecx, Case0str         ; write InputNum1 to stdout
      call print_string
      int 80h


      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h

      mov ecx, num              ; string to write
      call print_string
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
      mov ecx, Case1str         ; string to write
      call print_string
      int 80h

      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h

      mov ecx, num              ; string to write
      call print_string
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
      mov ecx, Case2str         ; string to write
      call print_string
      int 80h

      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h

      mov ecx, num              ; string to write
      call print_string
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
      mov ecx, Case3str         ; string to display
      call print_string
      int 80h

      ;Output the number entered
      mov eax, [num]            ; move value of num into eax
      mov edi, num              ; move address of num into edi used for stosb to be used in function
      call int_to_string
      xor eax, eax              ; clear eax
      int 80h

      mov ecx, num              ; string to write
      call print_string
      int 80h

      ;Exit code
      mov eax, SYS_EXIT
      xor ebx, ebx
      int 80h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function string_to_int
; converts the provided ascii string to an integer
;
; Input:
; EDX = pointer to the string to convert
; Output:
; EAX = integer value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
string_to_int:
    push edi              ; save edi, I will use as negative flag
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
    cmp edi, 0            ; edi less than 0?
    jl .done_neg          ; its a negative number jump to done_neg
    pop edi               ; restore edi
    ret
.neg:
    mov edi, -1
    jmp .next_digit
.done_neg:
    neg eax               ; 2's complement result, make negative
    pop edi               ; restore edi
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function int_to_string
; converts provided integer to ascii string
; Example of an in/out parameter function
;
; Input
; EAX = pointer to the int to convert
; EDI = address of the result
; Output:
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
int_to_string:
    xor   ebx, ebx          ; clear the ebx, I will use as counter for stack pushes
.push_chars:
    xor edx, edx            ; clear edx
    cmp eax, 0              ; check less then 0
    jl .handle_negative     ; handle negative number
.continue_push_chars:
    mov ecx, 10             ; ecx is divisor, devide by 10
    div ecx                 ; devide edx by ecx, result in eax remainder in edx
    add edx, '0'            ; add '0' or 0x30 to edx convert int => ascii
    push edx                ; push result to stack
    inc ebx                 ; increment my stack push counter
    cmp eax, 0              ; is eax 0?
    jg .push_chars          ; if eax not 0 repeat
    xor edx, edx

.pop_chars:
    pop eax                 ; pop result from stack into eax

    stosb                   ; store contents of eax in edi, which holds the address of num... From stosb documentation:
                            ; After the byte, word, or doubleword is transferred from the AL, AX, or EAX register to
                            ; the memory location, the (E)DI register is incremented or decremented automatically
                            ; according to the setting of the DF flag in the EFLAGS register. (If the DF flag is 0,
                            ; the (E)DI register is incremented; if the DF flag is 1, the (E)DI register is decremented.)
                            ; The (E)DI register is incremented or decremented by 1 for byte operations,
                            ; by 2 for word operations, or by 4 for ; doubleword operations.
    dec ebx                 ; decrement my stack push counter
    cmp ebx, 0              ; check if stack push counter is 0
    jg .pop_chars           ; not 0 repeat
    mov eax, 0x0a           ; add line feed
    stosb                   ; write line feed to edi => &num
    ret                     ; return to main

.handle_negative:
  neg eax                   ; make eax positive
  mov esi, eax              ; save eax into esi
  xor eax, eax              ; clear eax
  mov eax, '-'              ; put '-' into eax
  stosb                     ; write to edi => num memory location
  mov eax, esi              ; put original eax value back to eax
  xor esi, esi              ; clear esi
  jmp .continue_push_chars  ; continue pushing characters

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function print_string
; writes provided string to stdout
;
; Input
; ECX = string to Display to STDOUT
; Output:
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_string:
  call strlen               ; load length of string into edi
  mov eax, SYS_WRITE        ; write flag
  mov ebx, STDOUT           ; write to stdout
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function strlen
; counts the number of characters in provided string
;
; Input
; ECX = string to asess
; Output
; EDX = length of string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen:
  push eax                  ; save and clear counter
  xor eax, eax              ; clear counter
  push ecx                  ; save contents of ecx
next:
  cmp [ecx], byte 0         ; check for null character
  jz null_char              ; exit if null character
  inc eax                   ; increment counter
  inc ecx                   ; increment string pointer
  jmp next                  ; keep going
null_char:
  mov edx, eax              ; put value of counter into edx (length of string)
  pop ecx                   ; restore ecx (original string)
  pop eax                   ; restore eax
  ret                       ; return
