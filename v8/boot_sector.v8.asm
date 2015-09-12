;
; 一个简单的boot sector: BIOS读磁盘扇区
;
; author: qibing
; date: 2015年 8月13日 星期四 23时21分52秒 CST
;
;       bios读磁盘例程参数：
;       ah    0x02  bios读扇区
;       al    预计读多少个扇区
;       dh    磁头号， 0开始
;       dl    驱动器序号，0开始
;       ch    柱面（磁道）号
;       cl    扇区号，1开始
;       es:bx 存储位置

;bits 16

[org 0x7c00]
mov ah, 0x02            ;BIOS读扇区

mov dl, 0               ;驱动器0
mov dh, 0               ;磁头1 （第2个磁头，从0开始计）
mov ch, 0               ;柱面(磁道)3
mov cl, 1               ;扇区4 （第4个扇区，从1开始计）
mov al, 1               ;读5个扇区

;设置存储到的内存位置ES:BX
mov bx, 0xa000
mov es, bx
mov bx, 0x1234

int 0x13
jc disk_error_carry_flag_set
cmp al, 1
jne disk_error_sector_count_read_error

mov bx, DISK_READ_SUCCESS
call print_string

jmp $
%include "print_string.asm"

; 读扇区错误，CF置位
disk_error_carry_flag_set:
mov bx, DISK_ERROR_CARRY_FLAG_SET
call print_string
jmp $

; 读扇区错误，读到的扇区数不符合预期
disk_error_sector_count_read_error:
mov bx, DISK_ERROR_SECTOR_COUNT_READ_ERROR 
call print_string
jmp $

DISK_ERROR_CARRY_FLAG_SET: db "Disk read error. CF set!", 0
DISK_ERROR_SECTOR_COUNT_READ_ERROR: db "Disk read error. read sector num error!", 0
DISK_READ_SUCCESS: db "Disk read success!", 0

times 510-($-$$) db 0   ;填充程序到512个字节
dw 0xaa55               ;让bios识别此扇区为可启动扇区的魔数
