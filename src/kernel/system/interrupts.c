#include <stdint.h>
#include "../drivers/drivers.h"

// Loads the IDT and applies it
void load_idt_c() {
    // Load the IDT
    extern void load_idt();
}

// The general handler for ISR
void isr_general() {
    // Print an error message and crash
    print_string((char[]){"General exception\n"});
    while (1) {
        __asm__("hlt");
    } 
}