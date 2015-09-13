; 定义GDT和GDT descriptor
;
; author: qibing
; date: 2015年 8月23日 星期日 02时41分57秒 CST

; GDT
gdt_start:

    gdt_null:
    dd 0x0
    dd 0x0

    gdt_code:
    ; base=0x0, limit=0xfffff,
    ; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
    ; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
    ; 2nd flags: dw 0xffff
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

    gdt_data:
    ; Same as code segment except for the type flags:
    ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG    equ gdt_code - gdt_start
DATA_SEG    equ gdt_data - gdt_start

