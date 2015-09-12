; 函数：打印字符串
; 参数：BX 字符串偏移地址
; 输出：打印字符串
; print_string的实现跟github上这个家伙不谋而合
;   :https://github.com/cfenollosa/os-tutorial/blob/master/05-bootsector-functions-strings/boot_sect_print.asm

print_string:
    pusha
    mov ah, 0x0e
loop_begin:
    mov al, [bx]
    cmp al, 0
    je loop_end
    int 0x10
    add bx, 1
    jmp loop_begin
loop_end:
    popa
    ret
