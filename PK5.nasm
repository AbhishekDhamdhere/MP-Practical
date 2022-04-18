mov rsi,1100h  ;1100 is starting address which is moving to rsi
mov ax,[rsi]   ;
mov bx,[rsi+2] ;1102 is address of 2nd data which is moved into bx
mul b          
mov[rsi+4],ax  
mov[rsi+6],dx  
hlt
;run>view>memory>change starting memory address to 1100
;change memory values to 1A EF 50 and CD
;output is BFC28A20