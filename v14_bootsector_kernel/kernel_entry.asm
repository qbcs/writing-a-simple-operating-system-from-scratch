; kernel入口，调用main函数
; author: qibing
; date: 2015年 09月 05日 星期六 18:05:35 HKT

[bits 32]           ;我们已经在32-bit保护模式了
[extern main]       ;声明需要引用外部符号"main", 以便链接器可以替换为最终地址
call main           ;调用C程序中的main()函数
jmp $
