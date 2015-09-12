;
; 一个简单的boot sector 
;   1.使用include包含文件
;   2.打印字符串
;   3.函数的用法
;
; author: qibing
; date: 2015年 8月11日 星期二 23时52分22秒 CST
;
;bits 16

[org 0x7c00]

mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

jmp $

%include "print_string.asm"

HELLO_MSG:
db  "Hello, World!", 0x0d, 0x0a, 0  ;0x0d回车：让光标回到行首；0x0a换行：让光标下移一行
GOODBYE_MSG:
db  "Bye, World!", 0x0d, 0x0a, 0

times 510-($-$$) db 0   ;填充程序到512个字节
dw 0xaa55               ;让bios识别此扇区为可启动扇区的魔数
