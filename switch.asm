; Assemble as: nasm -f elf -g switch.asm
; Link as: ld -m elf_i386 -o switch switch.o

SYS_EXIT  equ 60
SYS_READ  equ 0
SYS_WRITE equ 1
STDIN     equ 0
STDOUT    equ 1
MAX_LEN   equ 6
MAX_NUM   equ 65535
MIN_NUM   equ 0


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
        mov rsi, InputNvalue      ; write InputNum1 to stdout
        call print_string
        syscall

        ;Read and store the user input into nvalue
        mov rax, SYS_READ       ; read flag
        mov rdi, STDIN          ; read from stdin
        mov rsi, nvalue         ; read into nvalue
        mov rdx, MAX_LEN        ; number bytes to be read
        syscall

        ; convert nvalue to int
        mov rdx, nvalue         ; put value to convert into rdx
        call string_to_int      ; convert contents of rdx to int, result in rax
        mov [nvalue], rax       ; move the int from rax back to variable
        xor rax, rax            ; clear rax

        ; validate number
        mov rax, [nvalue]
        cmp rax, MAX_NUM
        jg get_nvalue
        cmp rax, MIN_NUM
        jl get_nvalue

  ;Prompt User for num1
  get_num1:
      mov rsi, InputNum1        ; write InputNum1 to stdout
      call print_string
      syscall

      ;Read and store the user input into num1
      mov rax, SYS_READ         ; read flag
      mov rdi, STDIN            ; read from stdin
      mov rsi, num1             ; read into num1
      mov rdx, MAX_LEN          ; number bytes to be read
      syscall

      ; convert num1 to int
      mov rdx, num1
      call string_to_int        ; convert contents of rdx to int, result in rax
      mov [num1], rax           ; move the int from rax back to variable
      xor rax, rax              ; clear rax

      ; validate number
      mov rax, [num1]
      cmp rax, MAX_NUM
      jg get_num1
      cmp rax, MIN_NUM
      jl get_num1


  ;Prompt User for num2
  get_num2:
      mov rsi, InputNum2        ; variable to write to stdout
      call print_string         ; call print string
      syscall

      ;Read and store the user input num2
      mov rax, SYS_READ         ; read flag
      mov rdi, STDIN            ; read from stdin
      mov rsi, num2             ; read data into num2
      mov rdx, MAX_LEN          ; number bytes to be read
      syscall

      ; convert num2 to int
      mov rdx, num2
      call string_to_int        ; convert contents of rdx to an int, result in rax
      mov [num2], rax           ; put result back into variable
      xor rax, rax              ; clear rax

      ; validate number
      mov rax, [num2]
      cmp rax, MAX_NUM
      jg get_num2
      cmp rax, MIN_NUM
      jl get_num2

  ;Prompt User for num3
  get_num3:
      mov rsi, InputNum3
      call print_string
      syscall

      ;Read and store the user input num3
      mov rax, SYS_READ         ; read flag
      mov rdi, STDIN            ; read from stdin
      mov rsi, num3
      mov rdx, MAX_LEN          ; number bytes to read
      syscall

      ; convert num3 to int
      mov rdx, num3
      call string_to_int        ; convert contents of rdx to int, result in rax
      mov [num3], rax           ; put result back into variable
      xor rax, rax

      ; validate number
      mov rax, [num3]
      cmp rax, MAX_NUM        ; check if number is greater than 65535
      jg get_num3
      cmp rax, MIN_NUM        ; check if number is less than 0
      jl get_num3

  .switch:
      mov rax, [nvalue]       ; ++nvalue
      inc rax

      cmp rax, 0              ; case 0
      je case_0
      cmp rax, 1              ; case 1
      je case_1
      cmp rax, 2              ; case 2
      je case_2
      cmp rax, 3              ; case 3
      je case_3
  .default:
      mov rsi, strDefault         ; string to write
      call print_string
      syscall

      ;Exit code
      mov rax, SYS_EXIT
      xor rdi, rdi
      syscall


  case_0:
      mov rax, [num1]           ; move value of num1 to rax
      mov rcx, [num2]           ; move value of num2 to rcx
      imul rax, rcx             ; multiply rax and rcx
      mov [num], rax            ; move result into num
      xor rax, rax              ; clear rax

      ; Display Case0
      mov rsi, Case0str         ; write case 0 to stdout
      call print_string
      syscall


      ;Output the number entered
      mov rax, [num]            ; move value of num into rax
      mov rdi, num              ; move address of num into rdi used for stosb to be used in function
      call int_to_string
      xor rax, rax              ; clear rax

      mov rsi, num              ; string to write
      call print_string
      syscall

      ;Exit code
      mov rax, SYS_EXIT
      xor rdi, rdi
      syscall

  case_1:
      mov rbx, [num2]           ; move value of num1 to rax
      mov rcx, [num3]           ; move value of num2 to rcx
      imul rbx, rcx             ; multiply rax and rcx
      mov [num], rbx            ; move result into num
      xor rax, rax              ; clear rax

      ; Display Case1
      mov rsi, Case1str         ; string to write
      call print_string
      syscall

      ;Output the number entered
      mov rax, [num]            ; move value of num into rax
      mov rdi, num              ; move address of num into rdi used for stosb to be used in function
      call int_to_string
      xor rax, rax              ; clear rax

      mov rsi, num              ; string to write
      call print_string
      syscall

      ;Exit code
      mov rax, SYS_EXIT
      xor rdi, rdi
      syscall

  case_2:
      mov rax, [num3]           ; move value of num3 to rax
      mov rcx, [num1]           ; move value of num1 to rcx
      sub rax, rcx              ; subtract rax - rcx
      mov [num], rax            ; move result into num
      xor rax, rax              ; clear rax

      ; Display Case2
      mov rsi, Case2str         ; string to write
      call print_string
      syscall

      ;Output the number entered
      mov rax, [num]            ; move value of num into rax
      mov rdi, num              ; move address of num into rdi used for stosb to be used in function
      call int_to_string
      xor rax, rax              ; clear rax

      mov rsi, num              ; string to write
      call print_string
      syscall

      ;Exit code
      mov rax, SYS_EXIT
      xor rdi, rdi
      syscall

  case_3:
      mov rax, [num1]           ; move value of num1 to rax
      mov rcx, [num3]           ; move value of num3 to rcx
      sub rax, rcx              ; subtract rax - rcx
      mov [num], rax            ; move result into num
      xor rax, rax              ; clear rax

      ; Display Case3
      mov rsi, Case3str         ; string to display
      call print_string
      syscall

      ;Output the number entered
      mov rax, [num]            ; move value of num into rax
      mov rdi, num              ; move address of num into rdi used for stosb to be used in function
      call int_to_string
      xor rax, rax              ; clear rax

      mov rsi, num              ; string to write
      call print_string
      syscall

      ;Exit code
      mov rax, SYS_EXIT
      xor rdi, rdi
      syscall


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function string_to_int
; converts the provided ascii string to an integer
;
; Input:
; rdx = pointer to the string to convert
; Output:
; rax = integer value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
string_to_int:
    push rdi              ; save rdi, I will use as negative flag
    xor rax,rax           ; clear rax which will hold the result
.next_digit:
    movzx rcx ,byte[rdx]  ; get one character
    inc rdx               ; move pointer to next byte (increment)
    cmp rcx, '-'          ; check for handle_negative
    je .neg
    cmp rcx, '0'          ; check less than '0'
    jl .done
    cmp rcx, '9'          ; check greater than '9'
    jg .done
    sub rcx,  '0'         ; convert to ascii by subtracting '0' or 0x30
    imul rax, 10          ; prepare the result for the next character
    add rax, rcx          ; append current digit
    jmp .next_digit       ; keep going until done
.done:
    cmp rdi, 0            ; rdi less than 0?
    jl .done_neg          ; its a negative number jump to done_neg
    pop rdi               ; restore rdi
    ret
.neg:
    mov rdi, -1
    jmp .next_digit
.done_neg:
    neg rax               ; 2's complement result, make negative
    pop rdi               ; restore rdi
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function int_to_string
; converts provided integer to ascii string
; Example of an in/out parameter function
;
; Input
; rax = pointer to the int to convert
; rdi = address of the result
; Output:
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
int_to_string:
    xor   rbx, rbx          ; clear the rbx, I will use as counter for stack pushes
.push_chars:
    xor rdx, rdx            ; clear rdx
    cmp rax, 0              ; check less then 0
    jl .handle_negative     ; handle negative number
.continue_push_chars:
    mov rcx, 10             ; rcx is divisor, devide by 10
    div rcx                 ; devide rdx by rcx, result in rax remainder in rdx
    add rdx, '0'            ; add '0' or 0x30 to rdx convert int => ascii
    push rdx                ; push result to stack
    inc rbx                 ; increment my stack push counter
    cmp rax, 0              ; is rax 0?
    jg .push_chars          ; if rax not 0 repeat
    xor rdx, rdx

.pop_chars:
    pop rax                 ; pop result from stack into rax

    stosb                   ; store contents of rax in rdi, which holds the address of num... From stosb documentation:
                            ; After the byte, word, or doubleword is transferred from the AL, AX, or rax register to
                            ; the memory location, the (E)DI register is incremented or decremented automatically
                            ; according to the setting of the DF flag in the EFLAGS register. (If the DF flag is 0,
                            ; the (E)DI register is incremented; if the DF flag is 1, the (E)DI register is decremented.)
                            ; The (E)DI register is incremented or decremented by 1 for byte operations,
                            ; by 2 for word operations, or by 4 for ; doubleword operations.
    dec rbx                 ; decrement my stack push counter
    cmp rbx, 0              ; check if stack push counter is 0
    jg .pop_chars           ; not 0 repeat
    mov rax, 0x0a           ; add line feed
    stosb                   ; write line feed to rdi => &num
    ret                     ; return to main

.handle_negative:
  neg rax                   ; make rax positive
  mov rsi, rax              ; save rax into rsi
  xor rax, rax              ; clear rax
  mov rax, '-'              ; put '-' into rax
  stosb                     ; write to rdi => num memory location
  mov rax, rsi              ; put original rax value back to rax
  xor rsi, rsi              ; clear rsi
  jmp .continue_push_chars  ; continue pushing characters

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function print_string
; writes provided string to stdout
;
; Input
; rsi = string to Display to STDOUT
; Output:
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_string:
  call strlen               ; load length of string into rdx
  mov rax, SYS_WRITE        ; write flag
  mov rdi, STDOUT           ; write to stdout
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function strlen
; counts the number of characters in provided string
;
; Input
; rsi = string to asess
; Output
; rdx = length of string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strlen:
  push rax                  ; save and clear counter
  xor rax, rax              ; clear counter
  push rsi                  ; save contents of rsi
next:
  cmp [rsi], byte 0         ; check for null character
  jz null_char              ; exit if null character
  inc rax                   ; increment counter
  inc rsi                   ; increment string pointer
  jmp next                  ; keep going
null_char:
  mov rdx, rax              ; put value of counter into rdx (length of string)
  pop rsi                   ; restore rsi (original string)
  pop rax                   ; restore rax
  ret                       ; return
