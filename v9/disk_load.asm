;前提：已设置[org 0x7c00]
;   bios读磁盘例程参数：
;       ah    0x02  bios读扇区
;       al    预计读多少个扇区
;       dh    磁头号， 0开始
;       dl    驱动器序号，0开始
;       ch    柱面（磁道）号
;       cl    扇区号，1开始
;   bios读磁盘例程返回值：
;       es:bx 存储位置
;       al    已读扇区数

;函数: disk_load
;参数
;   dx (dl:BIOS将我们的boot drive存储在dl;  dh:需要读的扇区个数)
;   es:bx 我们存储读取数据的地址
;功能
;   读取dl指定的驱动器的、0磁头、0柱面、从2号扇区开始的由dh指定数量的扇区的数据，存储至es:bx，已读扇区数存至al

disk_load:
    push dx
    mov ah, 0x02    ;BIOS读扇区功能
    mov al, dh      ;读dh个扇区
    mov ch, 0x00    ;选择柱面0
    mov dh, 0x00    ;选择磁头0
    mov cl, 0x02    ;读扇区2（从boot_sector之后的第一个扇区）

    int 0x13        ;BIOS interrupt
    jc disk_error_flag
    pop dx
    cmp dh, al      ;al代表已读扇区数，dh是预期读扇区数
    jne disk_error_count
    ret
disk_error_flag:
    mov bx, DISK_ERROR_FLAG_MSG
    call print_string
    jmp $
disk_error_count:
    mov bx, DISK_ERROR_COUNT_MSG
    call print_string
    jmp $
DISK_ERROR_FLAG_MSG:
    db "Disk read flag error!", 0x0a, 0x0d, 0
DISK_ERROR_COUNT_MSG:
    db "Disk read count error!", 0x0a, 0x0d, 0
