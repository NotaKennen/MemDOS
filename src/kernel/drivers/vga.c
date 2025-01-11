#include "../memory/memory.h"   // memory util functions to write to video memory

#define VIDEO_ADDRESS 0xB8000   // Video memory address
#define VIDEO_WIDTH 80          // VGA Text console width
#define VIDEO_HEIGHT 25         // VGA Text console height
#define VIDEO_SIZE (VIDEO_WIDTH * VIDEO_HEIGHT) * 2 // Total size of video memory in bytes

static int cursor_position; // Global cursor position 
// Note that the cursor position is not tied directly to video address
// The correct way to get the address of the cursor is: VIDEO_ADDRESS + (cursor_position * 2)
// This is automatically calculated by the write_char_to_video function (by adding the property to the end of the writable data)
// So it's instead tied to the exact character on the screen

// Shifts video memory by amount
void shift_video(int amount) {
    for (int i = 0; i < VIDEO_SIZE; i++) {
        // Handle the last byte(s) that go out of bounds
        if (i >= VIDEO_SIZE - 2 * amount) {
            write_memory(VIDEO_ADDRESS + i, 0);
            write_memory(VIDEO_ADDRESS + i + 1, 0); // ensure that the properties byte is also 0
            continue;
        }
        // Shift the entire memory by one
        write_memory(VIDEO_ADDRESS + i, read_memory(VIDEO_ADDRESS + i + 2 * amount));
    }
    return;
}

// Writes a single character into video memory
void write_char_to_video(char character, int address) {
    if (address < VIDEO_ADDRESS || address >= (VIDEO_ADDRESS + VIDEO_SIZE) - 1) {
        return;
    }
    write_memory(address, character);
    write_memory(address + 1, 0x07);
    return;
}

// Writes ("draws") a null character into video memory with special attributes
void write_color_to_video(int color, int address) {
    if (address < VIDEO_ADDRESS || address >= (VIDEO_ADDRESS + VIDEO_SIZE) - 1) {
        return;
    }
    write_memory(address, 0); // Character space
    write_memory(address + 1, color); // Attribute space
    return;
}

// Prints a string, uses global cursor_position to automatically place it in the correct place
void print_string(const char* string) {
    for (int i = 0; string[i] != '\0'; i++) {

        // If the cursor goes beyond the memory limit
        if (cursor_position >= VIDEO_SIZE / 2) {
            cursor_position -= VIDEO_WIDTH - (cursor_position % VIDEO_WIDTH);
            shift_video(VIDEO_WIDTH);
        }

        /*
        \n - Move until next line (forces a move to the next line)
        \t - Add 4 characters (doesn't care about lines)
        */

        // Handle newlines
        if (string[i] == '\n') {
            cursor_position += VIDEO_WIDTH - (cursor_position % VIDEO_WIDTH);
            continue;
        }

        // Tabs
        if (string[i] == '\t') {
            cursor_position += 4;
            continue;
        }

        // Actual printing
        write_char_to_video(string[i], VIDEO_ADDRESS + cursor_position * 2);
        cursor_position += 1;
    }
    return;
}

// Prints an unicode character
void print_unicode(int value) {
    // Get the value from memory and write it
    write_memory((VIDEO_ADDRESS + cursor_position * 2), value);
    write_memory((VIDEO_ADDRESS + cursor_position * 2) + 1, 0x07);
    cursor_position++;

    // If the cursor goes beyond the memory limit
    if (cursor_position >= VIDEO_SIZE / 2) {
        cursor_position -= VIDEO_WIDTH - (cursor_position % VIDEO_WIDTH);
        shift_video(VIDEO_WIDTH);
    }
    return;
}

// Draws a pixel with a specific color using special character properties
void draw_color(int color, int position) {
    //FIXME: also prints a second black character in the next spot, not sure how to fix (it shouldnt do that)
    write_color_to_video(color, VIDEO_ADDRESS+(position*2));
    return;
}

// Clears the screen (replaces everything with black)
void clear_screen() {
    for (int i = 0; i < VIDEO_SIZE; i++) {
        write_color_to_video(0x00, VIDEO_ADDRESS + i * 2);
    }
    return;
}

// Manually move the cursor by a certain amount
void move_cursor(int move_amount) {
    // bounds checking
    if (cursor_position + move_amount * 2 > VIDEO_SIZE) {
        cursor_position = VIDEO_SIZE;
        return;
    }
    if ((cursor_position + move_amount) * 2 < 0) {
        cursor_position = 0;
        return;
    }

    // Add amount
    cursor_position += move_amount;
    return;
}

// Manually set the cursor to a new position
void set_cursor(int new_position) {
    // bounds checking
    if (new_position > VIDEO_SIZE) {
        cursor_position = VIDEO_SIZE;
        return;
    }
    if (new_position < 0) {
        cursor_position = 0;
        return;
    }

    // Set amount
    cursor_position = new_position;
    return;
}