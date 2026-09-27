
#include <stdint.h>
#include "gpio.h"
#include "soc.h"
#include "bsp.h"
#include "mdio_driver.h"
#include "i2c.h"

/* APB3 UART (uart_mini_apb3) register offsets */
#define APB_UART_BASE        0xF8100000u
#define REG_UART_CTRL        0x00u
#define REG_UART_STATUS      0x04u
#define REG_UART_TX_DATA     0x08u
#define REG_UART_RX_DATA     0x0Cu
#define REG_UART_RX_CTRL     0x10u

static inline void mmio_write32(uint32_t addr, uint32_t val) {
	volatile uint32_t *p = (volatile uint32_t *)addr;
	*p = val;
}

static inline uint32_t mmio_read32(uint32_t addr) {
	volatile uint32_t *p = (volatile uint32_t *)addr;
	return *p;
}

// Wait until TX FIFO is not full
static void uart_wait_not_full(void) {
	while (mmio_read32(APB_UART_BASE + REG_UART_STATUS) & 0x02u) {
		// spin
	}
}

// Wait until TX FIFO is empty (all bytes shifted out)
static void uart_wait_tx_empty(void) {
	while (!(mmio_read32(APB_UART_BASE + REG_UART_STATUS) & 0x01u)) {
		// spin
	}
}

static void uart_putc(char c) {
	uart_wait_not_full();
	mmio_write32(APB_UART_BASE + REG_UART_TX_DATA, (uint32_t)(uint8_t)c);
	// Add 2ms delay per character to prevent buffer underrun (9600 baud = ~1 char per ~1ms)
	bsp_uDelay(2000);
}

static void uart_puts(const char *s) {
	while (*s) uart_putc(*s++);
}

static void uart_puts_ln(const char *s) {
	uart_puts(s);
	uart_putc('\n');
	uart_wait_tx_empty();
}

// ---------------------------------------------------------------------------
// Simple hex printing helpers (nibbles only, no dependencies)
// ---------------------------------------------------------------------------
static void uart_put_hex_nibble(uint8_t nib) {
	char c = (nib < 10) ? ('0' + nib) : ('A' + (nib - 10));
	uart_putc(c);
}

// forward decls needed by logging wrappers below
static void uart_put_hex8(uint8_t v);
static void uart_put_hex16(uint16_t v);


// wrapper that prints every MDIO read
static uint16_t mdio_read_log(uint8_t phy_addr, uint8_t reg_addr)
{
	uint16_t val = mdio_read(phy_addr, reg_addr);
	// print the transaction details
	uart_puts("MDIO R phy="); uart_put_hex8(phy_addr);
	uart_puts(" reg="); uart_put_hex8(reg_addr);
	uart_puts(" => 0x"); uart_put_hex16(val);
	uart_puts_ln("");
	return val;
}

// wrapper that prints every MDIO write (success or timeout)
static int mdio_write_log(uint8_t phy_addr, uint8_t reg_addr, uint16_t data)
{
	int ok = mdio_write(phy_addr, reg_addr, data);
	uart_puts("MDIO W phy="); uart_put_hex8(phy_addr);
	uart_puts(" reg="); uart_put_hex8(reg_addr);
	uart_puts(" val=0x"); uart_put_hex16(data);
	uart_puts(" "); uart_puts(ok ? "OK" : "TIMEOUT");
	uart_puts_ln("");
	return ok;
}

// hex helpers (moved after log wrappers)
static void uart_put_hex8(uint8_t v) {
	uart_put_hex_nibble((v >> 4) & 0xF);
	uart_put_hex_nibble(v & 0xF);
}

static void uart_put_hex16(uint16_t v) {
	uart_put_hex8((uint8_t)(v >> 8));
	uart_put_hex8((uint8_t)(v & 0xFF));
}

// =========================================================================
// I2C Support for Camera Control (Raspberry Pi Camera Module via CSI-2/MIPI)
// Uses single I2C_0 instance with GPIO-controlled external MUX for camera selection
// Uses the VexRiscv i2c.h driver for proper 16-bit register address support
// =========================================================================
#define I2C_0_BASE_ADDR  SYSTEM_I2C_0_IO_CTRL  // 0xF800A000
#define CAM_I2C_ADDR7    0x10                    // IMX219 7-bit I2C address
#define CAM_I2C_ADDR8    (CAM_I2C_ADDR7 << 1)   // 8-bit write address = 0x20
#define GPIO_I2C_MUX_BIT 0                       // GPIO bit 0 controls I2C MUX

// IMX219 register addresses (16-bit) - from PiCamDriver.h
#define IMX219_MODEL_ID_H       0x0000  // Should read 0x02
#define IMX219_MODEL_ID_L       0x0001  // Should read 0x19
#define IMX219_MODE_SELECT      0x0100  // 0x00=standby, 0x01=streaming
#define IMX219_SOFTWARE_RESET   0x0103
#define IMX219_CSI_LANE_MODE    0x0114  // 0x01=2-lane
#define IMX219_DPHY_CTRL        0x0128
#define IMX219_EXCK_FREQ_H      0x012A  // 0x18 for 24MHz
#define IMX219_EXCK_FREQ_L      0x012B
#define IMX219_FRM_LENGTH_H     0x0160
#define IMX219_FRM_LENGTH_L     0x0161
#define IMX219_LINE_LENGTH_H    0x0162
#define IMX219_LINE_LENGTH_L    0x0163
#define IMX219_X_ADD_STA_H      0x0164
#define IMX219_X_ADD_STA_L      0x0165
#define IMX219_X_ADD_END_H      0x0166
#define IMX219_X_ADD_END_L      0x0167
#define IMX219_Y_ADD_STA_H      0x0168
#define IMX219_Y_ADD_STA_L      0x0169
#define IMX219_Y_ADD_END_H      0x016A
#define IMX219_Y_ADD_END_L      0x016B
#define IMX219_X_OUTPUT_SIZE_H  0x016C
#define IMX219_X_OUTPUT_SIZE_L  0x016D
#define IMX219_Y_OUTPUT_SIZE_H  0x016E
#define IMX219_Y_OUTPUT_SIZE_L  0x016F
#define IMX219_COARSE_INT_H     0x015A
#define IMX219_COARSE_INT_L     0x015B
#define IMX219_X_ODD_INC        0x0170
#define IMX219_Y_ODD_INC        0x0171
#define IMX219_IMG_ORIENTATION  0x0172
#define IMX219_BINNING_MODE_H   0x0174
#define IMX219_BINNING_MODE_V   0x0175
#define IMX219_CSI_DATA_FMT_H   0x018C  // RAW10 = 0x0A
#define IMX219_CSI_DATA_FMT_L   0x018D  // RAW10 = 0x0A
#define IMX219_VTPXCK_DIV       0x0301
#define IMX219_VTSYCK_DIV       0x0303
#define IMX219_PREPLLCK_VT_DIV  0x0304
#define IMX219_PREPLLCK_OP_DIV  0x0305
#define IMX219_PLL_VT_MPY_H     0x0306
#define IMX219_PLL_VT_MPY_L     0x0307
#define IMX219_OPPXCK_DIV       0x0309
#define IMX219_OPSYCK_DIV       0x030B
#define IMX219_PLL_OP_MPY_H     0x030C
#define IMX219_PLL_OP_MPY_L     0x030D
#define IMX219_ANA_GAIN_GLOBAL  0x0157
#define IMX219_DIG_GAIN_H       0x0158
#define IMX219_DIG_GAIN_L       0x0159
#define IMX219_FRM_CNT          0x0018

// =========================================================================
// I2C Initialization using VexRiscv driver
// =========================================================================
static void i2c_camera_init(void) {
	uart_puts_ln("I2C: Initializing I2C 0 for camera control (GPIO-MUX enabled)...");

	// Configure I2C timing for 100kHz using the VexRiscv i2c.h driver
	// Timing registers: TLOW, THIGH, TBUF (at offsets 0x50, 0x54, 0x58)
	// For 100 kHz with 100MHz system clock: ~500 cycles per half-period
	write_u32(500, I2C_0_BASE_ADDR + I2C_TLOW);
	write_u32(500, I2C_0_BASE_ADDR + I2C_THIGH);
	write_u32(500, I2C_0_BASE_ADDR + I2C_TBUF);
	// Sampling clock divider
	write_u32(3, I2C_0_BASE_ADDR + I2C_SAMPLING_CLOCK_DIVIDER);
	// Timeout
	write_u32(100000, I2C_0_BASE_ADDR + I2C_TIMEOUT);

	uart_puts("I2C: I2C 0 (0x");
	uart_put_hex16((I2C_0_BASE_ADDR >> 16) & 0xFFFF);
	uart_put_hex16(I2C_0_BASE_ADDR & 0xFFFF);
	uart_puts_ln(") initialized for 100kHz with external GPIO MUX");
}

// =========================================================================
// I2C MUX Control via GPIO
// GPIO[0] = 0: Select CAM4 on I2C bus
// GPIO[0] = 1: Select CAM5 on I2C bus
// =========================================================================
static void i2c_select_camera_bus(uint8_t camera_id) {
	uint32_t gpio_val;

	if (camera_id == 4) {
		gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0);  // GPIO[0] = 0 → CAM4
		uart_puts_ln("I2C: MUX → CAM4 (GPIO[0] = 0)");
	} else if (camera_id == 5) {
		gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 1);  // GPIO[0] = 1 → CAM5
		uart_puts_ln("I2C: MUX → CAM5 (GPIO[0] = 1)");
	} else {
		uart_puts("I2C: ERROR - Invalid camera ID: "); uart_put_hex8(camera_id); uart_puts_ln("");
	}

	// Small delay for MUX settling
	bsp_uDelay(1000);
}

// =========================================================================
// IMX219 I2C register access (16-bit register address, 8-bit data)
// Timeout-protected wrappers — will NOT hang if camera doesn't ACK
// =========================================================================

// Timeout helper: returns 0=OK, 1=TIMEOUT
static int i2c_wait_start(uint32_t reg, uint32_t timeout) {
	while (i2c_getMasterStatus(reg) & I2C_MASTER_START) {
		if (--timeout == 0) return 1;
	}
	return 0;
}

static int i2c_wait_tx_ack(uint32_t reg, uint32_t timeout) {
	while (read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID) {
		if (--timeout == 0) return 1;
	}
	return 0;
}

static int i2c_wait_stop(uint32_t reg, uint32_t timeout) {
	while (i2c_masterBusy(reg)) {
		if (--timeout == 0) return 1;
	}
	return 0;
}

#define I2C_TIMEOUT_LOOPS 500000u

// Send one byte + NACK with timeout. Returns 0=OK, 1=TIMEOUT
static int i2c_tx_byte_safe(uint32_t reg, uint8_t byte, const char *step) {
	i2c_txByte(reg, byte);
	i2c_txNack(reg);
	if (i2c_wait_tx_ack(reg, I2C_TIMEOUT_LOOPS)) {
		uart_puts("  I2C TIMEOUT at: "); uart_puts(step); uart_puts_ln("");
		return 1;
	}
	return 0;
}

// Write one byte to a 16-bit register address on the currently selected camera
// Returns 0=OK, 1=FAIL
static int cam_write_reg8(uint16_t reg, uint8_t data) {
	// START
	i2c_masterStart(I2C_0_BASE_ADDR);
	if (i2c_wait_start(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS)) {
		uart_puts("  I2C TIMEOUT: START (wr 0x"); uart_put_hex16(reg); uart_puts_ln(")");
		return 1;
	}
	// Slave addr + W
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, CAM_I2C_ADDR8 | 0x00, "ADDR+W")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		return 1;
	}
	// Reg MSB
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, (reg >> 8) & 0xFF, "REG_H")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		return 1;
	}
	// Reg LSB
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, reg & 0xFF, "REG_L")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		return 1;
	}
	// Data
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, data, "DATA")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		return 1;
	}
	// STOP
	i2c_masterStop(I2C_0_BASE_ADDR);
	i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
	bsp_uDelay(100);
	return 0;
}

// Read one byte from a 16-bit register address on the currently selected camera
// Returns data byte, or 0xFF on failure
static uint8_t cam_read_reg8(uint16_t reg) {
	uint8_t data = 0xFF;

	// START
	i2c_masterStart(I2C_0_BASE_ADDR);
	if (i2c_wait_start(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS)) {
		uart_puts("  I2C TIMEOUT: START (rd 0x"); uart_put_hex16(reg); uart_puts_ln(")");
		return 0xFF;
	}
	// Slave addr + W
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, CAM_I2C_ADDR8 | 0x00, "RD:ADDR+W")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
		return 0xFF;
	}
	// Reg MSB
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, (reg >> 8) & 0xFF, "RD:REG_H")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
		return 0xFF;
	}
	// Reg LSB
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, reg & 0xFF, "RD:REG_L")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
		return 0xFF;
	}
	// RESTART
	i2c_masterStart(I2C_0_BASE_ADDR);
	if (i2c_wait_start(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS)) {
		uart_puts_ln("  I2C TIMEOUT: RESTART");
		i2c_masterStop(I2C_0_BASE_ADDR);
		i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
		return 0xFF;
	}
	// Slave addr + R
	if (i2c_tx_byte_safe(I2C_0_BASE_ADDR, CAM_I2C_ADDR8 | 0x01, "RD:ADDR+R")) {
		i2c_masterStop(I2C_0_BASE_ADDR);
		i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
		return 0xFF;
	}
	// Clock in one byte with NACK (last byte)
	i2c_txByte(I2C_0_BASE_ADDR, 0xFF);
	i2c_txNack(I2C_0_BASE_ADDR);
	if (i2c_wait_tx_ack(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS)) {
		uart_puts_ln("  I2C TIMEOUT: RX byte");
		i2c_masterStop(I2C_0_BASE_ADDR);
		i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
		return 0xFF;
	}
	data = i2c_rxData(I2C_0_BASE_ADDR);

	// STOP
	i2c_masterStop(I2C_0_BASE_ADDR);
	i2c_wait_stop(I2C_0_BASE_ADDR, I2C_TIMEOUT_LOOPS);
	return data;
}

// =========================================================================
// IMX219 Camera Initialization Sequence
// =========================================================================

// Required IMX219 unlock / access command sequence
static void imx219_access_seq(void) {
	cam_write_reg8(0x30EB, 0x05);
	cam_write_reg8(0x30EB, 0x0C);
	cam_write_reg8(0x300A, 0xFF);
	cam_write_reg8(0x300B, 0xFF);
	cam_write_reg8(0x30EB, 0x05);
	cam_write_reg8(0x30EB, 0x09);
}

// Configure 96x96 centered ROI from the 3280x2464 sensor array
static void imx219_set_roi_96x96_center(void) {
	const uint16_t full_w = 3280, full_h = 2464;
	const uint16_t out_w = 96, out_h = 96;

	const uint16_t x_start = (full_w / 2) - (out_w / 2);  // 1592
	const uint16_t x_end   = x_start + out_w - 1;          // 1687
	const uint16_t y_start = (full_h / 2) - (out_h / 2);   // 1184
	const uint16_t y_end   = y_start + out_h - 1;          // 1279

	cam_write_reg8(IMX219_X_ADD_STA_H, (x_start >> 8) & 0x0F);
	cam_write_reg8(IMX219_X_ADD_STA_L, (uint8_t)(x_start & 0xFF));
	cam_write_reg8(IMX219_X_ADD_END_H, (x_end >> 8) & 0x0F);
	cam_write_reg8(IMX219_X_ADD_END_L, (uint8_t)(x_end & 0xFF));

	cam_write_reg8(IMX219_Y_ADD_STA_H, (y_start >> 8) & 0x0F);
	cam_write_reg8(IMX219_Y_ADD_STA_L, (uint8_t)(y_start & 0xFF));
	cam_write_reg8(IMX219_Y_ADD_END_H, (y_end >> 8) & 0x0F);
	cam_write_reg8(IMX219_Y_ADD_END_L, (uint8_t)(y_end & 0xFF));

	cam_write_reg8(IMX219_X_OUTPUT_SIZE_H, (out_w >> 8) & 0x0F);
	cam_write_reg8(IMX219_X_OUTPUT_SIZE_L, (uint8_t)(out_w & 0xFF));
	cam_write_reg8(IMX219_Y_OUTPUT_SIZE_H, (out_h >> 8) & 0x0F);
	cam_write_reg8(IMX219_Y_OUTPUT_SIZE_L, (uint8_t)(out_h & 0xFF));
}

// Full IMX219 init: standby → unlock → configure → start streaming
// Register sequence modeled on working T20 PiCamDriver_init()
static void imx219_init_96x96(void) {
	uart_puts_ln("  IMX219: Standby...");
	cam_write_reg8(IMX219_MODE_SELECT, 0x00);
	bsp_uDelay(10000);

	// Required unlock sequence (from datasheet)
	uart_puts_ln("  IMX219: Access sequence...");
	imx219_access_seq();

	// MIPI lane / clock config
	cam_write_reg8(IMX219_CSI_LANE_MODE, 0x01);  // 2-lane MIPI
	cam_write_reg8(IMX219_DPHY_CTRL, 0x00);      // auto DPHY timing
	cam_write_reg8(IMX219_EXCK_FREQ_H, 0x18);    // 24 MHz external clock
	cam_write_reg8(IMX219_EXCK_FREQ_L, 0x00);

	// Frame/line length
	cam_write_reg8(IMX219_FRM_LENGTH_H, 0x04);
	cam_write_reg8(IMX219_FRM_LENGTH_L, 0x59);
	cam_write_reg8(IMX219_LINE_LENGTH_H, 0x0D);
	cam_write_reg8(IMX219_LINE_LENGTH_L, 0x78);

	// ROI: 96x96 centered on 3280x2464 sensor
	uart_puts_ln("  IMX219: ROI 96x96...");
	imx219_set_roi_96x96_center();

	// Sub-sampling: no binning, no skip
	cam_write_reg8(IMX219_X_ODD_INC, 0x01);
	cam_write_reg8(IMX219_Y_ODD_INC, 0x01);
	cam_write_reg8(IMX219_BINNING_MODE_H, 0x00);
	cam_write_reg8(IMX219_BINNING_MODE_V, 0x00);

	// Data format: RAW8 (0x0808) — simpler 1 byte per pixel
	// (was RAW10 0x0A0A, switched to RAW8 for easier debugging)
	cam_write_reg8(IMX219_CSI_DATA_FMT_H, 0x08);
	cam_write_reg8(IMX219_CSI_DATA_FMT_L, 0x08);

	// PLL clock configuration (from working T20 reference)
	uart_puts_ln("  IMX219: PLL config...");
	cam_write_reg8(IMX219_VTPXCK_DIV, 0x05);
	cam_write_reg8(IMX219_VTSYCK_DIV, 0x01);
	cam_write_reg8(IMX219_PREPLLCK_VT_DIV, 0x03);
	cam_write_reg8(IMX219_PREPLLCK_OP_DIV, 0x03);
	cam_write_reg8(IMX219_PLL_VT_MPY_H, 0x00);
	cam_write_reg8(IMX219_PLL_VT_MPY_L, 0x39);
	cam_write_reg8(IMX219_OPPXCK_DIV, 0x0A);
	cam_write_reg8(IMX219_OPSYCK_DIV, 0x01);
	cam_write_reg8(IMX219_PLL_OP_MPY_H, 0x00);
	cam_write_reg8(IMX219_PLL_OP_MPY_L, 0x72);

	// Start streaming
	uart_puts_ln("  IMX219: Start streaming...");
	cam_write_reg8(IMX219_MODE_SELECT, 0x01);

	// Gain (from working T20 reference)
	cam_write_reg8(IMX219_ANA_GAIN_GLOBAL, 0xB9);
	cam_write_reg8(IMX219_DIG_GAIN_H, 0x02);
	cam_write_reg8(IMX219_DIG_GAIN_L, 0x00);

	// Exposure
	cam_write_reg8(IMX219_FRM_LENGTH_H, 0x06);
	cam_write_reg8(IMX219_FRM_LENGTH_L, 0xE3);
	cam_write_reg8(IMX219_COARSE_INT_H, 0x04);
	cam_write_reg8(IMX219_COARSE_INT_L, 0x54);

	// Orientation: normal
	cam_write_reg8(IMX219_IMG_ORIENTATION, 0x00);

	bsp_uDelay(100000);  // 100ms for first frame to arrive
	uart_puts_ln("  IMX219: Streaming.");
}

// Probe camera: read chip ID (should be 0x0219 for IMX219)
// Returns 1 if IMX219 detected, 0 otherwise
static int imx219_probe(const char *label) {
	uart_puts(label);
	uart_puts_ln(": Reading Model ID reg 0x0000...");

	uint8_t id_h = cam_read_reg8(IMX219_MODEL_ID_H);
	uart_puts(label); uart_puts(": ID_H(0x0000) = 0x"); uart_put_hex8(id_h); uart_puts_ln("");

	uint8_t id_l = cam_read_reg8(IMX219_MODEL_ID_L);
	uart_puts(label); uart_puts(": ID_L(0x0001) = 0x"); uart_put_hex8(id_l); uart_puts_ln("");

	uint16_t chip_id = ((uint16_t)id_h << 8) | id_l;

	uart_puts(label);
	uart_puts(": Chip ID = 0x");
	uart_put_hex16(chip_id);

	if (chip_id == 0x0219) {
		uart_puts_ln(" [IMX219 OK]");
		return 1;
	} else if (chip_id == 0xFFFF) {
		uart_puts_ln(" [NO RESPONSE - bus timeout, check wiring/power]");
		return 0;
	} else {
		uart_puts_ln(" [UNEXPECTED - not IMX219!]");
		return 0;
	}
}

// Read back and print key registers after init for verification
static void imx219_verify_config(const char *label) {
	uart_puts(label); uart_puts_ln(": Register readback:");

	uint8_t mode = cam_read_reg8(IMX219_MODE_SELECT);
	uart_puts("  mode_select    = 0x"); uart_put_hex8(mode);
	uart_puts(mode == 0x01 ? " [STREAMING]" : " [STANDBY]");
	uart_puts_ln("");

	uint8_t lane = cam_read_reg8(IMX219_CSI_LANE_MODE);
	uart_puts("  CSI_LANE_MODE  = 0x"); uart_put_hex8(lane);
	uart_puts(lane == 0x01 ? " [2-lane OK]" : " [WRONG!]");
	uart_puts_ln("");

	uint8_t xout_h = cam_read_reg8(IMX219_X_OUTPUT_SIZE_H);
	uint8_t xout_l = cam_read_reg8(IMX219_X_OUTPUT_SIZE_L);
	uint8_t yout_h = cam_read_reg8(IMX219_Y_OUTPUT_SIZE_H);
	uint8_t yout_l = cam_read_reg8(IMX219_Y_OUTPUT_SIZE_L);
	uint16_t xout = ((uint16_t)xout_h << 8) | xout_l;
	uint16_t yout = ((uint16_t)yout_h << 8) | yout_l;
	uart_puts("  Output size    = ");
	uart_put_hex16(xout); uart_puts(" x "); uart_put_hex16(yout);
	uart_puts((xout == 96 && yout == 96) ? " [96x96 OK]" : " [WRONG!]");
	uart_puts_ln("");

	uint8_t frm_cnt = cam_read_reg8(IMX219_FRM_CNT);
	uart_puts("  Frame count    = 0x"); uart_put_hex8(frm_cnt);
	uart_puts_ln("");
}

void ksz9131_disable_inband_status(uint8_t phy_addr) {
    // Läs nuvarande värde från Register 0x1F (PHY Control Register)
    uint16_t val = mdio_read(phy_addr, 0x1F);

    uart_puts("MDIO: Register 0x1F before: 0x");
    uart_put_hex16(val);

    // Maskera bort bit 0 (In-band Status Enable)
    val &= ~(1 << 0);

    // Skriv tillbaka värdet
    mdio_write(phy_addr, 0x1F, val);

    uart_puts(" -> After: 0x");
    uart_put_hex16(val);
    uart_puts_ln(" [In-band Status Disabled]");
}
uint16_t mdio_read_mmd(uint8_t phy_addr, uint8_t dev_addr, uint16_t reg_addr) {
    // Steg 1: Skriv Device Address till register 0x0D
    mdio_write(phy_addr, 0x0D, dev_addr);
    // Steg 2: Skriv Register Address till register 0x0E
    mdio_write(phy_addr, 0x0E, reg_addr);
    // Steg 3: Sätt mode till "Data" (ingen post-increment) i register 0x0D
    mdio_write(phy_addr, 0x0D, 0x4000 | dev_addr);
    // Steg 4: Läs värdet från register 0x0E
    return mdio_read(phy_addr, 0x0E);
}







// Register adresser IMX219
#define REG_MODE_SELECT          0x0100
#define REG_CSI_LANE_MODE        0x0114
#define REG_DPHY_CTRL            0x0128
#define REG_EXCK_FREQ_H          0x012A
#define REG_EXCK_FREQ_L          0x012B
#define REG_TEST_PATTERN_MODE    0x0600 // 0=Off, 1=Color Bars, 2=Solid, 3=Grey Bars

// --- Dina I2C funktioner (behåll dessa i filen) ---
// cam_write_reg8(...)
// cam_read_reg8(...)
// imx219_access_seq(...)

void start_test_pattern_mode() {
    uart_puts_ln("--- IMX219: Hard Reset & Test Pattern Force ---");

    // 1. SOFTWARE RESET
    // Sätt SW_RESET register 0x0103 till 0x01
    cam_write_reg8(0x0103, 0x01);
    bsp_uDelay(5000); // Vänta 5ms (viktigt!)

    // 2. SÄKERSTÄLL STANDBY
    cam_write_reg8(0x0100, 0x00);
    bsp_uDelay(2000);

    // 3. OBLIGATORISK ACCESS SEKVENST (Från databladet)
    imx219_access_seq();

    // 4. MINIMAL KLOCK-SETTING (Utan PLL fungerar inte MIPI-klockan)
    // Dessa värden sätter en standardklocka för streaming
    cam_write_reg8(0x0128, 0x00); // Auto DPHY
    cam_write_reg8(0x0114, 0x01); // 2 Lanes
    cam_write_reg8(0x012A, 0x18); // 24MHz EXCK freq high
    cam_write_reg8(0x012B, 0x00); // 24MHz EXCK freq low

    // 5. FORCE TEST PATTERN (Innan vi startar streaming)
    // Vi skriver 0x01 till 0x0600 för Color Bars
    cam_write_reg8(0x0600, 0x01);

    // 6. STARTA STREAMING
    cam_write_reg8(0x0100, 0x01);
    bsp_uDelay(1000);

    // 7. VERIFIERING (Läs tillbaka för att se om det faktiskt stannade på 0x01)
    uint8_t test_val = cam_read_reg8(0x0600);
    uart_puts("Final Test Pattern Reg: 0x"); uart_put_hex8(test_val);

    if (test_val == 0x01) {
        uart_puts_ln(" - SUCCESS: Hardware reports Color Bars");
    } else {
        uart_puts_ln(" - FAIL: Sensor rejected or overwrote register!");
    }
}
void force_test_pattern_v3() {
    uart_puts_ln("--- IMX219: Hard override for Test Pattern ---");

    // 1. Standby
    cam_write_reg8(0x0100, 0x00);
    bsp_uDelay(10000);

    // 2. Obligatorisk Access Sequence
    imx219_access_seq();

    // 3. PLL / Klock-inställningar (Viktigt!)
    // Utan en stabil intern klocka kan testmönster-generatorn hänga sig
    cam_write_reg8(0x0301, 0x05); // VTPREPLLCK_DIV
    cam_write_reg8(0x0303, 0x01); // VTSYSCK_DIV
    cam_write_reg8(0x0304, 0x03); // PREPLLCK_VT_DIV
    cam_write_reg8(0x0305, 0x03); // PREPLLCK_OP_DIV
    cam_write_reg8(0x0306, 0x00); // PLL_VT_MPY MSB
    cam_write_reg8(0x0307, 0x39); // PLL_VT_MPY LSB (57)
    cam_write_reg8(0x0309, 0x01); // OPPLLCK_DIV
    cam_write_reg8(0x030B, 0x01); // OPSYSCK_DIV
    cam_write_reg8(0x030C, 0x00); // PLL_OP_MPY MSB
    cam_write_reg8(0x030D, 0x72); // PLL_OP_MPY LSB (114)

    // 4. Bildformat (640x480, RAW10)
    cam_write_reg8(0x0114, 0x01); // 2-lanes
    cam_write_reg8(0x0128, 0x00); // Auto DPHY
    cam_write_reg8(0x0162, 0x02); // x_output_size MSB (640)
    cam_write_reg8(0x0163, 0x80); // x_output_size LSB
    cam_write_reg8(0x0164, 0x01); // y_output_size MSB (480)
    cam_write_reg8(0x0165, 0xE0); // y_output_size LSB

    // 5. Stäng av Digital Noise Reduction och annat skräp
    cam_write_reg8(0x0170, 0x01); // X_ODD_INC (No binning)
    cam_write_reg8(0x0171, 0x01); // Y_ODD_INC (No binning)

    // 6. AKTIVERA COLOR BARS
    cam_write_reg8(0x0600, 0x01);

    // 7. Stream ON
    cam_write_reg8(0x0100, 0x01);

    bsp_uDelay(5000);
    uart_puts("Confirm 0x0600: "); uart_put_hex8(cam_read_reg8(0x0600)); uart_puts_ln("");
}

int main(int argc, char **argv) {
    const char *msg = " **** KSZ9131 100Mbit Fixed Mode starting *** ";

    bsp_init();
    // Enable GPIO bits: bit [0] = LED toggle, bit [1] = UDP trigger signal
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x3);

    // Welcome message
    uart_puts_ln(msg);

    // I2C Camera Control Initialization
  //  i2c_camera_init();

    // Dump I2C controller state for debugging
    uart_puts("I2C: MASTER_STATUS = 0x");
    uart_put_hex16(read_u32(I2C_0_BASE_ADDR + I2C_MASTER_STATUS) & 0xFFFF);
    uart_puts(", TLOW=");
    uart_put_hex16(read_u32(I2C_0_BASE_ADDR + I2C_TLOW) & 0xFFFF);
    uart_puts(", THIGH=");
    uart_put_hex16(read_u32(I2C_0_BASE_ADDR + I2C_THIGH) & 0xFFFF);
    uart_puts_ln("");

    // =========================================================================
    // Camera probe: read IMX219 chip ID (expects 0x0219)
    // =========================================================================
    uart_puts_ln("I2C: Probing CAM4 via I2C_0 (direct connection, no MUX)...");
    uart_puts_ln("NOTE: CAM5 I2C skipped — hardware wire bug on PCB");

    i2c_select_camera_bus(4);
  //  int cam4_ok = imx219_probe("CAM4");
    int cam4_ok = 0;

    // CAM5 I2C has hardware wire bug on PCB — skip for now
    // i2c_select_camera_bus(5);
    // int cam5_ok = imx219_probe("CAM5");
    int cam5_ok = 0;  // Force skip

    // PHY Reset
    uart_puts_ln("MDIO: PHY reset...");
    mdio_phy_reset_assert();
    bsp_uDelay(50000);
    mdio_phy_reset_release();
    bsp_uDelay(300000);

    uint8_t phy = 0x00;
    uint16_t id1 = mdio_read(phy, PHY_REG_PHYID1);
    uint16_t id2 = mdio_read(phy, PHY_REG_PHYID2);
    uart_puts("ID="); uart_put_hex16(id1); uart_puts("/"); uart_put_hex16(id2); uart_puts_ln("");

    // =========================================================================
    // Fas 1: Konfigurera för 1000Mbps mode med Auto-negotiation
    // =========================================================================
    uart_puts_ln("MDIO: Enabling 1000Mbps advertisement...");

    // 1. Aktivera 1000Mbps reklam i GBCR (Reg 0x09)
    // Sätt bit 9 (1000Base-T FD) och bit 8 (1000Base-T HD) till 1
    mdio_write(phy, PHY_REG_GBCR, 0x0300);

    // 2. Aktivera Auto-negotiation med 1000Mbps stöd i BMCR (Reg 0x00)
    // Bit 12=1 (Auto-Negotiation Enable), Bit 9=1 (Restart Auto-Neg)
    // Låt PHY förhandla för högsta möjlig hastighet (1000Mbps)
    uint16_t bmcr_1000_auto = 0x1200;
    mdio_write(phy, PHY_REG_BMCR, bmcr_1000_auto);
    bsp_uDelay(100000);  // Vänta på auto-neg att starta

    uart_puts_ln("MDIO: 1000Mbps auto-negotiation enabled.");
    // --- Konfigurera RGMII Delay (2ns) ---
    // MMD 2, Reg 4 = RXC Skew, MMD 2, Reg 5 = TXC Skew
    // Värdet 0x0007 motsvarar ca 2.0ns enligt databladet

    uart_puts_ln("MDIO: Configuring TX RGMII delays... **");

    // Skriv TX Delay
    mdio_write(phy, 0x0D, 0x0002);
    mdio_write(phy, 0x0E, 0x0005);
    mdio_write(phy, 0x0D, 0x4002);
    mdio_write(phy, 0x0E, 0x0007);
    bsp_uDelay(10000);
 //   uart_puts_ln("MDIO: Configuring TX RGMII NOT TXC delays...");


    // Skriv TX Delay
 //   mdio_write(phy, 0x0D, 0x0002);
 //   mdio_write(phy, 0x0E, 0x0005);
 //   mdio_write(phy, 0x0D, 0x4002);
 //   mdio_write(phy, 0x0E, 0x0007);
 //   bsp_uDelay(10000);
    uart_puts_ln("MDIO: Configuring RX RGMII delays...");
    // Skriv RX Delay
    mdio_write(phy, 0x0D, 0x0002);
    mdio_write(phy, 0x0E, 0x0004);
    mdio_write(phy, 0x0D, 0x4002);
    mdio_write(phy, 0x0E, 0x0007);
    bsp_uDelay(10000);

    // MDIO: Stäng av TX RGMII delay
  //  mdio_write(phy, 0x0D, 0x0002); // Sätt DEVADDR till 2 (Digital Internal)
  //  mdio_write(phy, 0x0E, 0x0005); // Peka på register 0x0005 (RGMII Control)
  //  mdio_write(phy, 0x0D, 0x4002); // Aktivera data-skrivning utan post-increment



    // HÄR ÄR ÄNDRINGEN:
    // Om du vill ha både TX och RX delay AV: 0x0000
    // Om du vill ha endast RX delay PÅ men TX delay AV: 0x0001
//    mdio_write(phy, 0x0E, 0x0000);
    bsp_uDelay(10000);

    // --- VERIFIERING ---
    uint16_t verify_tx = mdio_read_mmd(phy, 2, 5);
    uint16_t verify_rx = mdio_read_mmd(phy, 2, 4);

    uart_puts("VERIFY TX Delay (Reg 2.5): 0x");
    uart_put_hex16(verify_tx);
    if (verify_tx == 0x0007) uart_puts(" [OK]"); else uart_puts(" [FAIL!]");
    uart_puts_ln("");

    uart_puts("VERIFY RX Delay (Reg 2.4): 0x");
    uart_put_hex16(verify_rx);
    if (verify_rx == 0x0007) uart_puts(" [OK]"); else uart_puts(" [FAIL!]");
    uart_puts_ln("");

    uart_puts_ln("UDP debug: Monitor GPIO signals and RGMII TX activity");
    uart_puts_ln("");
    mdio_write(phy, PHY_REG_BMCR, bmcr_1000_auto); // Ta bort bit 14

    // =========================================================================
    // Camera init: configure and start streaming (after PHY is up)
    // =========================================================================
    if (cam4_ok) {


 /*
        uart_puts_ln("CAM4: Initializing IMX219 96x96...");
        i2c_select_camera_bus(4);
        imx219_init_96x96();
        // Läs tillbaka för kontroll
        uint8_t test_pattern_val = 0;
        test_pattern_val = cam_read_reg8(0x0600);
        uart_puts("Readback 0x0600 = 0x");
        uart_put_hex8(test_pattern_val);
        if (test_pattern_val == 0x01) {
            uart_puts_ln(" [OK]");
        } else {
            uart_puts_ln(" [FAILED]");
        }

        imx219_verify_config("CAM4");
        */
    }
    //start_test_pattern_mode();
    force_test_pattern_v3();

    uint32_t stat_counter = 0;
    while (1) {
        uint16_t bmsr = mdio_read(phy, PHY_REG_BMSR);
        // Läs även register 0x1F för att se länkstatus (PHY Specific)
        uint16_t physpec = mdio_read(phy, 0x1F);

        uart_puts("["); uart_put_hex16(stat_counter & 0xFFFF); uart_puts("] STAT 1G: BMSR=0x"); uart_put_hex16(bmsr);

        uint8_t link_up = (bmsr & 0x0004) ? 1 : 0;
        uint8_t autoneg_done = (bmsr & 0x0020) ? 1 : 0;
        if (link_up && autoneg_done) {
            uart_puts(" [LINK UP 1G - AutoNeg Complete]");
        } else if (link_up) {
            uart_puts(" [LINK UP - Negotiating...]");
        } else {
            uart_puts(" [LINK DOWN]");
        }

        uart_puts_ln("");

        // GPIO bit [1] = UDP enable (link_up), bit [0] = I2C MUX (leave at last camera selected)
        // NOTE: bit [0] also acts as I2C MUX select, but cameras are already
        // initialized and streaming via MIPI, so toggling I2C MUX is harmless.
        uint8_t gpio_val = (link_up << 1);  // bit[0] = 0 (CAM4 selected, stable)
        gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, gpio_val);

        // Debug: print GPIO state every 10 iterations
        if ((stat_counter % 10) == 0) {
            uart_puts("  GPIO: [1]=");
            uart_put_hex_nibble(link_up);
            uart_puts(" (UDP enable)");
            uart_puts_ln("");
        }

        stat_counter++;
        bsp_uDelay(1000000);
    }
    return 0;
}
