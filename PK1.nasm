section .data
pmsg1 db "Count of +ve numbers::",0ah,0dh
pmsg_len1 equ $-pmsg1

nmsg2 db "Count of -ve numbers::",0ah,0dh
nmsg_len2 equ $-nmsg2

nwline db "",0ah

array dw-10h-12h,-20h,15h, 18h, 22h,-30h,-40h, 55h
arrcnt equ 09h    ;array has total 9 no.s

pcnt db 0         ;no of positive no.s in array
ncnt db 0         ;no of negative no.s in array

section .bss
dispbuff resb 2    ;2 bytes are reserved for the variable buff(it is used to count the +ve and -ve no.s)

%macro disp 2    
mov rax, 01
mov rdi, 01
mov rsi, %1    ;this is first argument for taking the source
mov rdx, %2    ;this is second argument for the length of that source
syscall
%endmacro

;CODE SECTION

section .text
global _start
_start:
mov rsi,array  ;pointing rsi variable to array
mov rcx,arrcnt ;taking array count in count register

up1:
bt word[rsi],15    ;initialise the no as word && 15 is the MSB bit of the rsi to check whether no is +/-
jnc pnxt           ;jump not carry if carry flag is not set then jump to pnext level
inc byte[ncnt]     ;increment ncnt by 1
jmp pskip           ;

pnxt:
inc byte[pcnt]   ;increment pcnt by 1

pskip:
inc rsi
inc rsi   ;by incrementing rsi 2 times rsi is pointing to 2nd no.
dec rcx   ;decrement the count of no. in array
jnz up1   ;jump if not 0

disp pmsg1,pmsg_len1  ;calling disp macro
mov bl,[pcnt]         
call disp8num         ;this is the procedure to display the +ve no.s on output screen
disp nwline,1

disp nmsg2,nmsg_len2    
mov bl,[ncnt]
call disp8num         ;this is the procedure to display the -ve no.s on output screen
disp nwline,1

disp8num:         
mov cl,04        ;cl is for the rotation purpose
mov ch,02        ;ch is for how many digits you want to display  
mov rsi,dispbuff ;temp buffer declared in bss section

dup1:
rol bl,cl    ;rotating to left to get MS digit to LS digit
mov al,bl    ;move rotated no from bl to al
and al,0fh   ;and that no. with 0f
cmp al,09    ;compare the no after anding with 09
jbe dskip    ;if no is less than 09, then add that no. with ASCII 30h

30h:
add al,07h     ;

dskip:
add al,30h    ;add 30h
mov [rsi],al  ;store the ASCII code in dispbuff(temp buffer)
inc rsi       ;to increment rsi to next byte of dispbuff
dec ch        ;decrement ch
jnz dup1      ;if not 0 then jump to dup1

disp dispbuff,02  ;display the value from temp buffer
ret               ;return to the calling program

;calling the exit system call
exit:
mov rax,3ch
mov rdi,00
syscall