;
; 一个简单的boot sector: BIOS读磁盘扇区, 在boot_sector之后多塞2个扇区的数据，然后通过读
; 磁盘的方式读出来, 然后调用print_hex打印出来
;
; author: qibing
; date: 2015年 8月14日 星期五 00时18分49秒 CST
;
;bits 16

[org 0x7c00]
    mov [BOOT_DRIVE], dl    ;bios将boot drive存放在dl，所以我们将其保存起来

    mov bp, 0x8000
    mov sp, bp

    mov bx, 0x9000      ;读取的数据将存放在es:bx(0000:9000)
    mov dh, 2           ;读2个扇区
    mov dl, [BOOT_DRIVE];dl保存boot dirve号
    call disk_load
    
    mov dx, [0x9000]
    call print_hex
    mov dx, [0x9000+512]
    call print_hex
    
    jmp $

%include "./print_hex.asm"
%include "./disk_load.asm"

BOOT_DRIVE db 0

times 510-($-$$) db 0
dw 0xaa55

;追加2个扇区数据，正常的会打印出0xdada0xface
times 256 dw 0xdada
times 256 dw 0xface
