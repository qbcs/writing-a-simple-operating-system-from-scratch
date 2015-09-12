;
; 一个简单的boot sector: Manipulating the data segment with the ds register
; 注意和v3.asm程序做对比
;
; author: qibing
; date: 2015年 8月13日 星期四 21时27分02秒 CST
;
;bits 16

mov ah, 0x0e            ;设置tele-type mode

mov al, [the_secret]
int 0x10                ; 不会打印出'X'

mov bx, 0x7c0
mov ds, bx              ; 通过bx将0x7c0保存到ds
mov al, [the_secret]    ; 会打印出'X', 基址是0x7c0<<4=0x7c00
int 0x10

mov al, [es:the_secret]
int 0x10                ; 不会打印出'X'

mov bx, 0x7c0
mov es, bx
mov al, [es: the_secret]
int 0x10                ; 会打印出'X', 用es寄存器做基址

jmp $

the_secret:
db 'X'

times 510-($-$$) db 0   ;填充程序到512个字节
dw 0xaa55               ;让bios识别此扇区为可启动扇区的魔数
