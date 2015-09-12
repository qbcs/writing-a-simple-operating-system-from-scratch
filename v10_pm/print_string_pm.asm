; 保护模式下的输出字符串例程
; 参数：EBX 待输出字符串地址，'0'结尾
;
; author: qibing
; date: 2015年 8月23日 星期日 02时41分57秒 CST

[bits 32]       ;声明以下指令都是32位的
; 定义一些常量
VIDEO_MEMORY        equ 0xb8000 ;
WHITE_ON_BLACK      equ 0xf     ;属性：黑色背景，白色前景

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY
    mov ah, WHITE_ON_BLACK

print_string_pm_loop:
    mov al, [ebx]
    cmp al, 0                   ;0表示字符串已结束
    je print_string_pm_loop_done
    mov [edx], ax               ;显示！！！

    add ebx, 1
    add edx, 2

    jmp print_string_pm_loop

print_string_pm_loop_done:
    popa
    ret
