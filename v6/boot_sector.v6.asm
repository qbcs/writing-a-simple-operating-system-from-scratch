;
; 一个简单的boot sector 
;   1.打印数据的16进制字符串表示
;   2.用到了v5程序的包含文件、打印字符串函数特性
;
; author: qibing
; date: 2015年 8月12日 星期三 00时57分54秒 CST
;
;bits 16

[org 0x7c00]

mov dx, 0x1fb6
call print_hex
jmp $

%include "print_hex.asm"

times 510-($-$$) db 0   ;填充程序到512个字节
dw 0xaa55               ;让bios识别此扇区为可启动扇区的魔数
