// Minimal GPIO toggle test - verify CPU boots and executes
#include <stdint.h>

#define SYSTEM_GPIO_0_IO_OUTPUT 0xf8015000

void delay(uint32_t cycles) {
    volatile uint32_t i = cycles;
    while (i--);
}

int main(int argc, char **argv) {
    volatile uint32_t *gpio_out = (volatile uint32_t *)SYSTEM_GPIO_0_IO_OUTPUT;
    
    while (1) {
        *gpio_out = 0x1;        // LED on
        delay(10000000);        // ~1 second
        
        *gpio_out = 0x0;        // LED off
        delay(10000000);        // ~1 second
    }
    
    return 0;
}
