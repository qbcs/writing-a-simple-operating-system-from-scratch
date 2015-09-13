/**
 * screen驱动
 * author: qibing
 * date: 2015年 09月 06日 星期日 00:16:11 HKT
 */
#include "screen.h"
#include "port_io.h"

void print_char(char character, int col, int row, char attribute_byte)
{
    unsigned char *videomem = (unsigned char *)VIDEO_ADDRESS;

    if (!attribute_byte) {
        attribute_byte = WHITE_ON_BLACK;
    }

    int offset;
    if (col >= 0 && row >= 0) {
        offset = get_screen_offset(col, row);
    } else {
        offset = get_cursor();
    }

    if (character == '\n') {
        int rows = offset / (2 * MAX_COLS);
        offset = get_screen_offset(79, rows);
    } else {
        videomem[offset] = character;
        videomem[offset + 1] = attribute_byte;
    }

    // update the offset to the next character cell
    offset += 2;
    // 处理scrolling
    offset = handle_scrolling(offset);
    // 更新cursor位置
    set_cursor(offset);
}

int get_screen_offset(int col, int row)
{
    return (row * MAX_COLS + col) * 2;
}

int get_cursor()
{
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset * 2;
}

int set_cursor(int offset)
{
    offset /= 2;
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

void print_at(char *message, int col, int row)
{
    if (col >= 0 && row >= 0) {
        set_cursor(get_screen_offset(col, row));
    }

    int i = 0;
    while (message[i]) {
        print_char(message[i++], col, row, WHITE_ON_BLACK);
    }
}

void print(char *message)
{
    print_at(message, -1, -1);
}

void clear_screen()
{
    int row = 0;
    int col = 0;

    for (row = 0; row < MAX_ROWS; row++) {
        for (col = 0; col < MAX_COLS; col++) {
            print_char(' ', col, row, WHITE_ON_BLACK);
        }
    }

    set_cursor(get_screen_offset(0, 0));
}

void memory_copy(char *src, char *dst, int bytes)
{
    int i;
    for (i = 0; i < bytes; i++) {
        *(dst + i) = *(src + i);
    }
}

int handle_scrolling(int cursor_offset)
{
    if (cursor_offset < MAX_ROWS * MAX_COLS * 2) {
        return cursor_offset;
    }

    // 往上卷一行
    int i;
    for (i = 1; i < MAX_ROWS; i++) {
        memory_copy((char *)(get_screen_offset(0, i) + VIDEO_ADDRESS),
                    (char *)(get_screen_offset(0, i - 1) + VIDEO_ADDRESS),
                    MAX_COLS * 2);
    }

    // 使最后一行变空白
    char *last_line = (char *)(get_screen_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS);
    for (i = 0; i < MAX_COLS * 2; i++) {
        last_line[i] = 0;
    }

    cursor_offset -= MAX_COLS * 2;
    return cursor_offset;
}
