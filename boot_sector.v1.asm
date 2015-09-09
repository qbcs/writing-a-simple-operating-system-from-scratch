;
; 一个简单的boot sector无限循环程序
; author: qibing
; date: 2015年 8月 9日 星期日 23时51分59秒 CST
;
;bits 16

loop_label:
jmp     loop_label      ;无限循环跳转,也可以不用标号而写作jmp $

times 510-($-$$) db 0   ;填充程序到512个字节

dw 0xaa55               ;让bios识别此扇区为可启动扇区的魔数

