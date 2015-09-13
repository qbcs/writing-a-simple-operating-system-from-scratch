; 切换到保护模式
;
; author: qibing
; date: 2015年 8月23日 星期日 02时41分57秒 CST

[bits 16]
switch_to_pm:
    cli         ; We must switch of interrupts until we have 
                ; set-up the protected mode interrupt vector
                ; otherwise interrupts will run riot.
    lgdt [gdt_descriptor]   ; Load our global descriptor table, which defines
                            ; the protected mode segments (e.g. for code and data)
                            ; 祁冰注：我想应该必须先声明[org 0x7c00]才行, 实际上这个声明[org 0x7c00]在主程序里面做的

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax            ; 切换！！！
                            ; To make the switch to protected mode, we set 
                            ; the first bit of CR0, a control register
                            ; 祁冰注：在bits 16模式下也可以使用32位指令或寄存器，pdf里面有专门讲到

    jmp CODE_SEG:init_pm    ; Make a far jump (i.e. to a new segment) to our 32-bit
                            ; code. This also forces the CPU to flush its cache of
                            ; pre-fetched and real-mode decoded instructions, which can 
                            ; cause problems.
                            ; 祁冰注： far jump会让cpu自动将cs寄存器更新为我们的目标段地址; CODE_SEG的值是0x08, 这个时候
                            ;          已经是保护模式了，按照保护模式寻址方式，0x08代表gdt里面第二个入口的descriptor,这个
                            ;          descriptor定义的段的base address为0, 所以0 * 4K + init_pm 才会定位到紧接着的下面
                            ;          这条指令！

    [bits 32]
init_pm:                    ;初始化一些寄存器和栈
    mov ax, DATA_SEG
    mov ds, ax              ; 将所有的段寄存器都执行我们在GDT里面定义的数据段
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x9000
    mov esp, ebp            ; Update our stack position so it is right
                            ; at the top of the free space.

    call BEGIN_PM           ; Finally, call some well-known label
