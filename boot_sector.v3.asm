;
; 一个简单的boot sector 'X' Marks the Spot
; 注意跟v7.asm做对比，v7是ds的使用
;
; author: qibing
; date: 2015年 8月10日 星期一 23时55分30秒 CST
;
;bits 16

mov ah, 0x0e            ;设置tele-type mode

mov al, the_secret
int 0x10                ;是否会输出'X'? --No

mov al, [the_secret]
int 0x10                ;是否会输出'X'? --No

mov bx, the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10                ;是否会输出'X'? --Yes

mov al, [0x7c1d]
int 0x10                ;是否会输出'X'? --Yes

jmp $                   ;跳到当前地址，无限循环

the_secret:
db  "X"

times 510-($-$$) db 0   ;填充程序到512个字节
dw 0xaa55               ;让bios识别此扇区为可启动扇区的魔数
