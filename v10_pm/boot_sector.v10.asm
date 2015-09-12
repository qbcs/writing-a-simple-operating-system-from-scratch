; 展示16位实模式->32位保护模式的切换过程
;
; author: qibing
; date: 2015年 8月23日 星期日 02时41分57秒 CST 

[org 0x7c00]

mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm
jmp $

%include "print_string.asm"     ; 16位实模式 打印字符串
%include "gdt.asm"
%include "print_string_pm.asm"  ; 32位保护模式 打印字符串
%include "switch_to_pm.asm"

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    jmp $                       ; HANG

; 全局变量
MSG_REAL_MODE   db "Started in 16-bit Real Mode.", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protect Mode!", 0

; Bootsector填充
times 510-($-$$) db 0
dw 0xaa55
