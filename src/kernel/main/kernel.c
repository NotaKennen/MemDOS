#include "../drivers/drivers.h"
#include "../system/interrupts.h"

/* Code commentary
    -
*/

// kernel main function
void kernel_main() {
    // Move cursor to match what it was before Kernel
    move_cursor(187);

    // Print response message to user
    print_string((char[]){"OK\n"});

    // Load the IDT
    print_string((char[]){"Loading IDT... "});
    load_idt_c();
    print_string((char[]){"OK\n"});

    print_unicode(71);
    print_unicode(65);
    print_unicode(89);
    print_string((char[]){"\n"});

    // Shut down since there's nothing to do
    while (1) {
        __asm__("hlt");
    }
}



