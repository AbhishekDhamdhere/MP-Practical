;macro for calling the right system call
global _start

%macro disp 2
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endm

;declaring data section

section .data
msg1 db "Enter 5 numbers of length 64-bit ",10
len1 equ $-msg1
msg2 db "Entered numbers are ",10
len2 equ $-msg2
count db 05   ;as we are going to take 5 variables

;bss section

section .bss
array resb 100  ;declaring 100 bytes of memory to array variable

; code section

section .text
_start:

;logic for reading the numbers from the user

mov rbx,00          ;rbx acts as array index
disp msg1,len1      ;display msg1
 
up: mov rax,00      ;this is read syscall
mov rdi,00          ;parameter 00 we are taking in rax and rdi
mov rsi,array       ;array is takein rsi (source index register)
add rsi,rbx
mov rdx,17          ;first no. lenght is 17 byte
syscall             ;function system call for the read
add rbx,17          ;rbx is array index 
dec byte[count]     ;decrement count
jnz up              ;check count is 0 or zero flag is not set (take jump to up)

;logic to display 5 numbers stored in the array

mov byte[count],05        ;initializing count variable as a byte
mov rbx,00                ;set array index pointing to the 1st no.
disp msg2,len2
up1:mov rax,01
mov rdi,01
mov rsi,array
add rsi,rbx
mov rdx,17
syscall
add rbx,17
dec byte[count]
jnz up1                   ;if it is not 0 go to label up1


;exit system call

mov rax,60
mov rdi,00
syscall
