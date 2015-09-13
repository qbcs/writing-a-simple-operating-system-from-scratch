; 功能参见README
; author: qibing
; date: 2015年 09月 05日 星期六 17:31:36 CST

[org 0x7c00]

KERNEL_OFFSET equ 0x1000    ;这是我们将要加载kernel到的偏移位置
mov [BOOT_DRIVE], dl        ;bios将boot驱动器号存储在dl，先保存起来

mov bp, 0x9000
mov sp, bp                  ;设置好栈参数

mov bx, MSG_REAL_MODE
call print_string           ;打印出我们在16-bit实模式的字符串

call load_kernel            ;加载kernel
call switch_to_pm           ;切换到保护模式，此例程不会return

jmp $

; Include
%include "boot/print/print_string.asm"      ;跟v14唯一的区别，此处是从工程根目录开始汇编的，所以相对地址从boot目录开始
%include "boot/disk/disk_load.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/print_string_pm.asm"
%include "boot/pm/switch_to_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL     ;打印出我们将要切换到32-bit保护模式的字符串
    call print_string

    mov bx, KERNEL_OFFSET       ;为load_disk例程设置参数, 加载kernel到地址KERNEL_OFFSET
    mov dh, 15                  ;加载前15个扇区（不包括boot sector）
    mov dl, [BOOT_DRIVE]        ;启动磁盘
    call disk_load              ;

    ret

[bits 32]
; 这将是我们切换到32-bit保护模式并初始化后执行的地方
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm        ;调用32-bit的打印字符串例程，宣布我们已经进入保护模式了

    call KERNEL_OFFSET          ;跳转到我们加载内核的地方，执行内核

    jmp $                       ;Hang.
    
;全局变量
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0x0a, 0x0d, 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protect Mode", 0x0a, 0x0d, 0
MSG_LOAD_KERNEL db "Loading kernel into memory...", 0x0a, 0x0d, 0

;Bootsector填充
times 510-($-$$) db 0
dw 0xaa55
