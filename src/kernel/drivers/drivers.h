// drivers header
#ifndef DRIVERS_H
#define DRIVERS_H

// VGA
void print_string(const char* string);
void shift_video(int amount);
void draw_color(int color, int position);
void print_unicode(int value);
void clear_screen();
void move_cursor(int move_amount);
void set_cursor(int new_position);

#endif // DRIVERS_H
