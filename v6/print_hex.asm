; 函数：print_hex
; 参数：DX 输入的一个字
; 输出：打印16进制表示
; copy from https://github.com/cfenollosa/os-tutorial/blob/master/05-bootsector-functions-strings/boot_sect_print_hex.asm

print_hex:
    pusha
    ; mov dx, 0xab1f
    mov cx, 0
hex_loop:
    cmp cx, 4
    je hex_loop_end
    mov ax, dx
    and ax, 0x000f
    add ax, '0'
    cmp ax, '0'+9
    jle step2
    add ax, 'a'-'0'-0xa
step2:
    mov bx, HEXOUT+5
    sub bx, cx
    mov [bx], al
    ror dx, 4   ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    add cx, 1
    jmp hex_loop

hex_loop_end:
    mov bx, HEXOUT
    call print_string
    popa
    ret

%include "print_string.asm"

HEXOUT:
db  '0x0000', 0
