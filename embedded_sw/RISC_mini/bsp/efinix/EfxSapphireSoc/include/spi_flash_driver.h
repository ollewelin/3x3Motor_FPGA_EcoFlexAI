/**
 * spi_flash_driver.h - C driver interface for spi_flash_apb3 peripheral
 *
 * Base Address: IO_APB_SLAVE_0_INPUT + 0x3000 = 0xf8103000
 *
 * Connected to Winbond W25Q128JVSIQ (U99, 128M-bit / 16M-byte SPI Flash)
 * Also controls Efinix CONFIG_CTRL0 remote FPGA reconfiguration.
 */

#ifndef SPI_FLASH_DRIVER_H
#define SPI_FLASH_DRIVER_H

#include <stdint.h>
#include "bsp.h"

// Base address for spi_flash_apb3 APB slave (fourth 4KB block in APB slave 0)
#define SPI_FLASH_BASE_ADDR         0xf8103000

// Register offsets
#define SPI_FLASH_REG_DATA          (*(volatile uint32_t*)(SPI_FLASH_BASE_ADDR + 0x00))
#define SPI_FLASH_REG_STATUS        (*(volatile uint32_t*)(SPI_FLASH_BASE_ADDR + 0x04))
#define SPI_FLASH_REG_RECONFIG      (*(volatile uint32_t*)(SPI_FLASH_BASE_ADDR + 0x08))

// Status register bits
#define SPI_FLASH_STATUS_BUSY       (1 << 0)
#define SPI_FLASH_STATUS_CS_N       (1 << 1)
#define SPI_FLASH_STATUS_WP_N       (1 << 2)
#define SPI_FLASH_STATUS_HOLD_N     (1 << 3)
#define SPI_FLASH_STATUS_DIV_SHIFT  8

// Reconfig register bits
#define SPI_FLASH_RECONFIG_TRIG     (1 << 0)
#define SPI_FLASH_RECONFIG_CBSEL_MASK (0x3 << 1)
#define SPI_FLASH_RECONFIG_ERROR    (1 << 3)
#define SPI_FLASH_RECONFIG_USR_STAT (1 << 4)

// Winbond W25Q128 SPI Flash Commands
#define W25Q_CMD_WRITE_ENABLE       0x06
#define W25Q_CMD_WRITE_DISABLE      0x04
#define W25Q_CMD_READ_STATUS_1      0x05
#define W25Q_CMD_READ_STATUS_2      0x35
#define W25Q_CMD_WRITE_STATUS_1     0x01
#define W25Q_CMD_PAGE_PROGRAM       0x02
#define W25Q_CMD_READ_DATA          0x03
#define W25Q_CMD_FAST_READ          0x0B
#define W25Q_CMD_SECTOR_ERASE_4K    0x20
#define W25Q_CMD_BLOCK_ERASE_32K    0x52
#define W25Q_CMD_BLOCK_ERASE_64K    0xD8
#define W25Q_CMD_CHIP_ERASE         0xC7
#define W25Q_CMD_JEDEC_ID           0x9F
#define W25Q_CMD_RELEASE_POWERDOWN  0xAB
#define W25Q_CMD_DEVICE_ID          0x90

// Status Register 1 bits
#define W25Q_STAT1_BUSY             (1 << 0)
#define W25Q_STAT1_WEL              (1 << 1)

/**
 * Initialize SPI master: set default clock divider and assert idle state (CS# high, WP# high, HOLD# high)
 * clk_div = 1 gives SCLK = SysClk / 4 = 50MHz / 4 = 12.5MHz
 */
static inline void spi_flash_init(uint8_t clk_div)
{
    // CS#=1, WP#=1, HOLD#=1
    SPI_FLASH_REG_STATUS = ((uint32_t)clk_div << SPI_FLASH_STATUS_DIV_SHIFT) |
                           SPI_FLASH_STATUS_CS_N |
                           SPI_FLASH_STATUS_WP_N |
                           SPI_FLASH_STATUS_HOLD_N;
}

static inline void spi_flash_cs_low(void)
{
    uint32_t reg = SPI_FLASH_REG_STATUS;
    reg &= ~SPI_FLASH_STATUS_CS_N;
    SPI_FLASH_REG_STATUS = reg;
}

static inline void spi_flash_cs_high(void)
{
    uint32_t reg = SPI_FLASH_REG_STATUS;
    reg |= SPI_FLASH_STATUS_CS_N;
    SPI_FLASH_REG_STATUS = reg;
}

/**
 * Transfer single 8-bit byte over SPI
 */
static inline uint8_t spi_flash_transfer(uint8_t byte_out)
{
    // Wait until SPI transmitter is not busy
    while (SPI_FLASH_REG_STATUS & SPI_FLASH_STATUS_BUSY) {}

    // Start transfer
    SPI_FLASH_REG_DATA = (uint32_t)byte_out;

    // Wait until transfer completes
    while (SPI_FLASH_REG_STATUS & SPI_FLASH_STATUS_BUSY) {}

    // Return received byte
    return (uint8_t)(SPI_FLASH_REG_DATA & 0xFF);
}

/**
 * Read 3-byte JEDEC ID from SPI Flash
 * Expected for Winbond W25Q128JV: 0xEF, 0x40, 0x18
 */
static inline uint32_t spi_flash_read_jedec_id(void)
{
    uint32_t id = 0;
    spi_flash_cs_low();
    spi_flash_transfer(W25Q_CMD_JEDEC_ID);
    id |= ((uint32_t)spi_flash_transfer(0x00)) << 16;  // Manufacturer ID (0xEF)
    id |= ((uint32_t)spi_flash_transfer(0x00)) << 8;   // Memory Type (0x40)
    id |= ((uint32_t)spi_flash_transfer(0x00));        // Capacity (0x18 = 128Mbit)
    spi_flash_cs_high();
    return id;
}

/**
 * Wait until SPI flash completes internal write/erase cycle
 */
static inline void spi_flash_wait_busy(void)
{
    while (1) {
        spi_flash_cs_low();
        spi_flash_transfer(W25Q_CMD_READ_STATUS_1);
        uint8_t s = spi_flash_transfer(0x00);
        spi_flash_cs_high();
        if (!(s & W25Q_STAT1_BUSY)) break;
    }
}

/**
 * Enable write latch in flash
 */
static inline void spi_flash_write_enable(void)
{
    spi_flash_cs_low();
    spi_flash_transfer(W25Q_CMD_WRITE_ENABLE);
    spi_flash_cs_high();
}

/**
 * Read bytes from SPI flash memory into buffer
 */
static inline void spi_flash_read(uint32_t addr, uint8_t *buf, uint32_t len)
{
    spi_flash_cs_low();
    spi_flash_transfer(W25Q_CMD_READ_DATA);
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    for (uint32_t i = 0; i < len; i++) {
        buf[i] = spi_flash_transfer(0x00);
    }
    spi_flash_cs_high();
}

/**
 * Erase 64KB block at addr
 */
static inline void spi_flash_erase_block64k(uint32_t addr)
{
    spi_flash_write_enable();
    spi_flash_cs_low();
    spi_flash_transfer(W25Q_CMD_BLOCK_ERASE_64K);
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    spi_flash_cs_high();
    spi_flash_wait_busy();
}

/**
 * Erase 4KB sector at addr
 */
static inline void spi_flash_erase_sector4k(uint32_t addr)
{
    spi_flash_write_enable();
    spi_flash_cs_low();
    spi_flash_transfer(W25Q_CMD_SECTOR_ERASE_4K);
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    spi_flash_cs_high();
    spi_flash_wait_busy();
}

/**
 * Program a page (up to 256 bytes, must not cross 256-byte page boundary)
 */
static inline void spi_flash_page_program(uint32_t addr, const uint8_t *buf, uint16_t len)
{
    spi_flash_write_enable();
    spi_flash_cs_low();
    spi_flash_transfer(W25Q_CMD_PAGE_PROGRAM);
    spi_flash_transfer((addr >> 16) & 0xFF);
    spi_flash_transfer((addr >> 8) & 0xFF);
    spi_flash_transfer(addr & 0xFF);
    for (uint16_t i = 0; i < len; i++) {
        spi_flash_transfer(buf[i]);
    }
    spi_flash_cs_high();
    spi_flash_wait_busy();
}

/**
 * Trigger remote FPGA reconfiguration from flash via CONFIG_CTRL0
 * cbsel: 2-bit configuration image selection (00 = default image)
 */
static inline void spi_flash_reconfigure_fpga(uint8_t cbsel)
{
    SPI_FLASH_REG_RECONFIG = ((uint32_t)(cbsel & 0x3) << 1) | SPI_FLASH_RECONFIG_TRIG;
}

#endif // SPI_FLASH_DRIVER_H
