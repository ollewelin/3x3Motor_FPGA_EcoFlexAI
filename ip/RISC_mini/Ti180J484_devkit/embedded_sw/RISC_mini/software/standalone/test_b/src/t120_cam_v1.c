////////////////////////////////////////////////////////////////////////////////
// t120_cam_v1.c - Raw I2C probe loop for IMX219 (CAM2) debug
//
// Strips all timeouts. Endlessly sends START + address byte, reads ACK/NACK,
// sends STOP, prints full I2C register state.  Check on logic analyser.
////////////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include "bsp.h"
#include "gpio.h"
#include "i2c.h"
#include "uart_mini_driver.h"

// IMX219 7-bit address 0x10 -> 8-bit write address 0x20
#define CAM_ADDR_W   (0x10 << 1)          // 0x20

// ============================================================
// Minimal UART helpers
// ============================================================

static void tx_str(const char *s) {
    uart_mini_tx_string(s);
}

static void tx_nl(void) {
    uart_mini_newline();
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) {}
}

static void tx_hex8(uint8_t v) {
    static const char h[] = "0123456789ABCDEF";
    uart_mini_tx_byte(h[(v >> 4) & 0xF]);
    uart_mini_tx_byte(h[v & 0xF]);
}

static void tx_hex32(uint32_t v) {
    tx_hex8((v >> 24) & 0xFF);
    tx_hex8((v >> 16) & 0xFF);
    tx_hex8((v >>  8) & 0xFF);
    tx_hex8(v & 0xFF);
}

static void tx_dec(uint32_t v) {
    if (v == 0) { uart_mini_tx_byte('0'); return; }
    char buf[10]; int i = 0;
    while (v) { buf[i++] = '0' + (v % 10); v /= 10; }
    while (i > 0) uart_mini_tx_byte(buf[--i]);
}

// ============================================================
// I2C primitives - NO timeouts, raw spin
// ============================================================

// Print bus line levels and master status register
static void print_bus_state(void) {
    uint32_t slv = read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_SLAVE_STATUS);
    uint32_t mst = read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS);
    tx_str("  BUS: SCL=");
    uart_mini_tx_byte((slv & I2C_SLAVE_STATUS_SCL) ? '1' : '0');
    tx_str(" SDA=");
    uart_mini_tx_byte((slv & I2C_SLAVE_STATUS_SDA) ? '1' : '0');
    tx_str("  MSTS=0x"); tx_hex32(mst);
    tx_str("  TX_ACK=0x"); tx_hex32(read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_TX_ACK));
    tx_str("  RX_ACK=0x"); tx_hex32(read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_RX_ACK));
    tx_nl();
}

// Blocking START - spins until START bit clears
static void raw_start(void) {
    i2c_masterStart(SYSTEM_I2C_0_IO_CTRL);
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS) & I2C_MASTER_START) {}
}

// Blocking STOP - spins until BUSY clears
static void raw_stop(void) {
    i2c_masterStop(SYSTEM_I2C_0_IO_CTRL);
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS) & I2C_MASTER_BUSY) {}
}

// Send one byte + release SDA for slave ACK slot.
// Returns 0 if slave ACKed, 1 if NACK.
static int raw_tx_byte(uint8_t byte) {
    i2c_txByte(SYSTEM_I2C_0_IO_CTRL, byte);
    i2c_txNack(SYSTEM_I2C_0_IO_CTRL);  // release SDA so slave can pull low for ACK
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_TX_ACK) & I2C_TX_VALID) {}
    // RX_ACK value: 0 = slave ACKed (SDA pulled low), non-zero = NACK
    return (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_RX_ACK) & I2C_RX_VALUE) ? 1 : 0;
}

// ============================================================
// I2C init - 100 kHz
// ============================================================

static void i2c_init_100k(void) {
    I2c_Config cfg;
    const uint32_t fclk     = 50000000;  // 50 MHz SoC clock
    const uint32_t cyc_us   = fclk / 1000000;  // 50 cycles/us

    cfg.samplingClockDivider = 3;
    // Timeout = 500 ms - must be long enough to survive UART printing mid-transaction.
    // At 115200 baud each UART byte takes ~87 us; a full print_bus_state line ~2 ms.
    cfg.timeout              = (500000 * cyc_us) - 1;
    cfg.tsuDat               = (1  * cyc_us) - 1;
    cfg.tLow                 = (5  * cyc_us) - 1;
    cfg.tHigh                = (5  * cyc_us) - 1;
    cfg.tBuf                 = (5  * cyc_us) - 1;

    i2c_applyConfig(SYSTEM_I2C_0_IO_CTRL, &cfg);
    tx_str("I2C 100kHz configured"); tx_nl();
}

// ============================================================
// Main probe loop
// ============================================================

void cam_v1_probe_loop(void) {
    tx_str("==== t120_cam_v1: I2C PROBE LOOP ===="); tx_nl();
    tx_str("Target addr write=0x"); tx_hex8(CAM_ADDR_W);
    tx_str("  (IMX219 7-bit=0x10)"); tx_nl();

    i2c_init_100k();

    tx_str("Initial bus state:"); tx_nl();
    print_bus_state();
    tx_str("Starting loop..."); tx_nl();

    uint32_t iter = 0;
    for (;;) {
        iter++;

        // ---- Print pre-transaction state BEFORE touching I2C ----
        tx_str("--- iter "); tx_dec(iter); tx_str(" ---"); tx_nl();
        tx_str("  pre-START:"); tx_nl();
        print_bus_state();

        // ============================================================
        // I2C transaction: START -> address -> [reg+data] -> STOP
        // NO UART inside this block - timeout would fire
        // ============================================================
        raw_start();

        // Capture post-START MSTS without printing yet
        uint32_t msts_after_start = read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS);

        // Send write address, capture ACK/NACK
        int nack_addr = raw_tx_byte(CAM_ADDR_W);

        int nack_r1 = 1, nack_r2 = 1, nack_rd = 1;
        if (!nack_addr) {
            nack_r1 = raw_tx_byte(0x01);  // reg MSB (0x0100 mode_select)
            nack_r2 = raw_tx_byte(0x00);  // reg LSB
            nack_rd = raw_tx_byte(0x00);  // data: stop streaming
        }

        raw_stop();
        // ============================================================
        // Safe to print again now
        // ============================================================

        tx_str("  post-START MSTS=0x"); tx_hex32(msts_after_start); tx_nl();

        tx_str("  ADDR 0x"); tx_hex8(CAM_ADDR_W);
        tx_str(": "); tx_str(nack_addr ? "NACK (no response)" : "ACK  (camera replied!)");
        tx_nl();

        if (!nack_addr) {
            tx_str("  reg[0x0100]<-0x00: regH="); tx_str(nack_r1 ? "NACK" : "ACK");
            tx_str(" regL="); tx_str(nack_r2 ? "NACK" : "ACK");
            tx_str(" data="); tx_str(nack_rd ? "NACK" : "ACK");
            tx_nl();
        }

        tx_str("  post-STOP:"); tx_nl();
        print_bus_state();

        // ~200 ms pause so logic analyser captures are readable
        bsp_uDelay(200000);
    }
}
