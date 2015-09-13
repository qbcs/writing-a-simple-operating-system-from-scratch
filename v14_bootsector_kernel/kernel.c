/**
 * kernel.c
 * 一个最简单的内核，在屏幕左上角打印出字符X
 *
 * 第一条指令不属main函数，但是我们的kernel_entry模块指定了从main为入口
 * 所以不会引起错乱，kernel运行不依赖函数放置顺序
 *
 * author: qibing
 * date: 2015年 09月 05日 星期六 01:08:28 HKT
 */

void test_function()
{
    return;
}

void main()
{
    // char *video_memory = (char *)0xb8000;
    // *video_memory = 'X';
    //
    char *video_memory = (char *)(0xb8000 + 80 * 2);
    *video_memory = 'X';
    test_function();
}
