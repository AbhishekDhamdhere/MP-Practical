;WITHOUT
;STRING
;INSTRUCTIONS

%macro print 2
mov rax,1
mov rdi,1
mov rsi, %1
mov rdx,%2
syscall
%endmacro

section .data
msg1 db 10,"source block",10,13
msg1len equ $-msg1
msg2 db 10,"destination block after transfer",10,13
msg2len equ $-msg2
space db ""
spacelen equ $-space
srcblk db 10h,20h,30h,40h,50h    ;source block decleared Name given to array is db
count equ 05h    ;we have to transfer 5 elements

section .bss
ans resb 4       ;array which is used for displaying purpose
dstblk resb 5    ;for destination block 5bytes are reserved 

section .text
global_start
_start:

print msg1,msg1len
mov rsi,srcblk     ;pointer to point to the starting address of the source block
call disp_block    ;displaying the nos one by one
mov rsi,scrblk     
mov rdi,dstblk
mov rcx,05   

cld    ;clear direction flag

rep movsb   ;movsb is instruction for moving source block to destionation block
print msg2,msg2len
mov rsi,dstblk
call disp_block       

;exit system call
mov rax,60
mov rdi,0
syscall

disp_block:
mov rbp,count  ;count value is loaded into rbp

back:
mov al,[rsi]  ;taken first element of the source block and put in al
push rsi      ;to push the contents of rsi into the stack
call disp_8   ;for displaying each element of the array
print space,1 
pop rsi       ;popping the rsi after displaying 
inc rsi       
dec rbp
jnz back

ret

disp_8:
mov rsi,ans  ;in ans array we are converting each digit we want to print into its ASCII value

mov bl,al    
mov dl,bl    
rol dl,04    
and dl,0fh
cmp dl,09h
jbe add30
add dl,07h

add30: add dl,30h
mov [rsi],dl
inc rsi

mov dl,bl
and dl,0fh
cmp dl,09h
jbe add31
add dl,07h

add31:
add dl,30h
mov [rsi],dl

print ans,2
ret