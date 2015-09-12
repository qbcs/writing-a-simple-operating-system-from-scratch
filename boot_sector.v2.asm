;
; 一个简单的boot sector 输出Hello程序
; 原理：
;       int 0x10/ah=0x0e -> scrolling teletype BIOS routine
;       al need to be set the character ASCII value.
;       调用0x10中断服务例程(ISR, Interrupt Service Routines)
;       ah设置为0x0e，al设置为需要显示的字符
;       效果：屏幕显示字符，光标后移
;
; author: qibing
; date: 2015年 8月 9日 星期日 23时52分00秒 CST
;
;bits 16

                        
mov ah, 0x0e            ;设置tele-type mode
mov al, 'H'             ;设置待显示字符
int 0x10                ;screen相关的中断
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

jmp $                   ;跳到当前地址，无限循环
times 510-($-$$) db 0   ;填充程序到512个字节
dw 0xaa55               ;让bios识别此扇区为可启动扇区的魔数
