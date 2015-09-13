/**
 * screen驱动头文件
 * author: qibing
 * date: 2015年 09月 06日 星期日 00:16:11 HKT
 */

#define VIDEO_ADDRESS   0xb8000
#define MAX_ROWS        25
#define MAX_COLS        80
#define WHITE_ON_BLACK  0x0f

// screen device I/O ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5
