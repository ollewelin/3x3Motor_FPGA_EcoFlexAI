#include "soc.h"
#include "gpio.h"
#include "bsp.h"

#define LED_MASK 0x1   // GPIO-bit 0

int main(void)
{
    /* gör pinnen till utgång */
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, LED_MASK);

    while (1) {
        gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, LED_MASK);   // LED på
        bsp_uDelay(50000);
        gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0);          // LED av
        bsp_uDelay(50000);//
    }
}

/* enkel trap-stub om inget annat finns */
void trap(void) { while (1) ; }
