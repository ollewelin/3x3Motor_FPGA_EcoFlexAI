
build/test_b.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00002197          	auipc	gp,0x2
f9000004:	76818193          	addi	gp,gp,1896 # f9002768 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	00006117          	auipc	sp,0x6
f900000c:	f8810113          	addi	sp,sp,-120 # f9005f90 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f9000010:	00002517          	auipc	a0,0x2
f9000014:	b6450513          	addi	a0,a0,-1180 # f9001b74 <_data>
	la a1, _data
f9000018:	00002597          	auipc	a1,0x2
f900001c:	b5c58593          	addi	a1,a1,-1188 # f9001b74 <_data>
	la a2, _edata
f9000020:	81c18613          	addi	a2,gp,-2020 # f9001f84 <__bss_start>
	bgeu a1, a2, 2f
f9000024:	00c5fc63          	bgeu	a1,a2,f900003c <init+0x34>
1:
	lw t0, (a0)
f9000028:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
f900002c:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
f9000030:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
f9000034:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
f9000038:	fec5e8e3          	bltu	a1,a2,f9000028 <init+0x20>
2:

	/* Clear bss section */
	la a0, __bss_start
f900003c:	81c18513          	addi	a0,gp,-2020 # f9001f84 <__bss_start>
	la a1, _end
f9000040:	82018593          	addi	a1,gp,-2016 # f9001f88 <_end>
	bgeu a0, a1, 2f
f9000044:	00b57863          	bgeu	a0,a1,f9000054 <init+0x4c>
1:
	sw zero, (a0)
f9000048:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
f900004c:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
f9000050:	feb56ce3          	bltu	a0,a1,f9000048 <init+0x40>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
f9000054:	010000ef          	jal	ra,f9000064 <__libc_init_array>
#endif

	call main
f9000058:	6e1000ef          	jal	ra,f9000f38 <main>

f900005c <mainDone>:
mainDone:
    j mainDone
f900005c:	0000006f          	j	f900005c <mainDone>

f9000060 <_init>:


	.globl _init
_init:
    ret
f9000060:	00008067          	ret

Disassembly of section .text:

f9000064 <__libc_init_array>:
f9000064:	ff010113          	addi	sp,sp,-16
f9000068:	00812423          	sw	s0,8(sp)
f900006c:	01212023          	sw	s2,0(sp)
f9000070:	00002417          	auipc	s0,0x2
f9000074:	b0440413          	addi	s0,s0,-1276 # f9001b74 <_data>
f9000078:	00002917          	auipc	s2,0x2
f900007c:	afc90913          	addi	s2,s2,-1284 # f9001b74 <_data>
f9000080:	40890933          	sub	s2,s2,s0
f9000084:	00112623          	sw	ra,12(sp)
f9000088:	00912223          	sw	s1,4(sp)
f900008c:	40295913          	srai	s2,s2,0x2
f9000090:	00090e63          	beqz	s2,f90000ac <__libc_init_array+0x48>
f9000094:	00000493          	li	s1,0
f9000098:	00042783          	lw	a5,0(s0)
f900009c:	00148493          	addi	s1,s1,1
f90000a0:	00440413          	addi	s0,s0,4
f90000a4:	000780e7          	jalr	a5
f90000a8:	fe9918e3          	bne	s2,s1,f9000098 <__libc_init_array+0x34>
f90000ac:	00002417          	auipc	s0,0x2
f90000b0:	ac840413          	addi	s0,s0,-1336 # f9001b74 <_data>
f90000b4:	00002917          	auipc	s2,0x2
f90000b8:	ac090913          	addi	s2,s2,-1344 # f9001b74 <_data>
f90000bc:	40890933          	sub	s2,s2,s0
f90000c0:	40295913          	srai	s2,s2,0x2
f90000c4:	00090e63          	beqz	s2,f90000e0 <__libc_init_array+0x7c>
f90000c8:	00000493          	li	s1,0
f90000cc:	00042783          	lw	a5,0(s0)
f90000d0:	00148493          	addi	s1,s1,1
f90000d4:	00440413          	addi	s0,s0,4
f90000d8:	000780e7          	jalr	a5
f90000dc:	fe9918e3          	bne	s2,s1,f90000cc <__libc_init_array+0x68>
f90000e0:	00c12083          	lw	ra,12(sp)
f90000e4:	00812403          	lw	s0,8(sp)
f90000e8:	00412483          	lw	s1,4(sp)
f90000ec:	00012903          	lw	s2,0(sp)
f90000f0:	01010113          	addi	sp,sp,16
f90000f4:	00008067          	ret

f90000f8 <uart_applyConfig>:
*          value using data length, parity, and stop bit settings from the configuration
*          structure, and writes this value to the UART frame configuration register.
*
******************************************************************************/
    static void uart_applyConfig(u32 reg, Uart_Config *config){
        write_u32(config->clockDivider, reg + UART_CLOCK_DIVIDER);
f90000f8:	00c5a783          	lw	a5,12(a1)
    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f90000fc:	00f52423          	sw	a5,8(a0)
        write_u32(((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16), reg + UART_FRAME_CONFIG);
f9000100:	0005a783          	lw	a5,0(a1)
f9000104:	fff78793          	addi	a5,a5,-1
f9000108:	0045a703          	lw	a4,4(a1)
f900010c:	00871713          	slli	a4,a4,0x8
f9000110:	00e7e7b3          	or	a5,a5,a4
f9000114:	0085a703          	lw	a4,8(a1)
f9000118:	01071713          	slli	a4,a4,0x10
f900011c:	00e7e7b3          	or	a5,a5,a4
f9000120:	00f52623          	sw	a5,12(a0)
    }
f9000124:	00008067          	ret

f9000128 <clint_uDelay>:
*          and the time limit is non-negative, indicating that the delay has
*          not yet elapsed.
*
******************************************************************************/
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f9000128:	000f47b7          	lui	a5,0xf4
f900012c:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf0240>
f9000130:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f9000134:	0000c7b7          	lui	a5,0xc
f9000138:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0x7ff8>
f900013c:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f9000140:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f9000144:	02a58533          	mul	a0,a1,a0
f9000148:	00f50533          	add	a0,a0,a5
f900014c:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f9000150:	40f507b3          	sub	a5,a0,a5
f9000154:	fe07dce3          	bgez	a5,f900014c <clint_uDelay+0x24>
f9000158:	00008067          	ret

f900015c <bsp_init>:
    *   1. UART baudrate
    *   2. 
    */
////////////////////////////////////////////////////////////////////////////////
    static void bsp_init()
    {
f900015c:	fe010113          	addi	sp,sp,-32
f9000160:	00112e23          	sw	ra,28(sp)
        Uart_Config uartConfig;
        uartConfig.dataLength   = BITS_8;
f9000164:	00800793          	li	a5,8
f9000168:	00f12023          	sw	a5,0(sp)
        uartConfig.parity       = NONE;
f900016c:	00012223          	sw	zero,4(sp)
        uartConfig.stop         = ONE;
f9000170:	00012423          	sw	zero,8(sp)
        uartConfig.clockDivider = BSP_CLINT_HZ/(BSP_UART_BAUDRATE*BSP_UART_DATA_LEN)-1;
f9000174:	03500793          	li	a5,53
f9000178:	00f12623          	sw	a5,12(sp)
        uart_applyConfig(BSP_UART_TERMINAL, &uartConfig);    
f900017c:	00010593          	mv	a1,sp
f9000180:	f8001537          	lui	a0,0xf8001
f9000184:	f75ff0ef          	jal	ra,f90000f8 <uart_applyConfig>
    }
f9000188:	01c12083          	lw	ra,28(sp)
f900018c:	02010113          	addi	sp,sp,32
f9000190:	00008067          	ret

f9000194 <mdio_read>:
// ============================================================================

static inline void mdio_write_reg(uint32_t offset, uint32_t val)
{
    volatile uint32_t *reg = (volatile uint32_t *)(MDIO_BASE_ADDR + offset);
    *reg = val;
f9000194:	f8101737          	lui	a4,0xf8101
f9000198:	00200793          	li	a5,2
f900019c:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
    mdio_write_reg(MDIO_STATUS_REG, MDIO_STATUS_DONE);
    
    // Build CTRL word: start=1, RW=1(read), phy_addr, reg_addr, wdata=0
    uint32_t ctrl = (1 << 0)                      // start
                  | (1 << 1)                       // RW = read
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f90001a0:	00551513          	slli	a0,a0,0x5
f90001a4:	3e057513          	andi	a0,a0,992
f90001a8:	00356513          	ori	a0,a0,3
                  | ((reg_addr & 0x1F) << 10);     // Register address
f90001ac:	00a59593          	slli	a1,a1,0xa
f90001b0:	000087b7          	lui	a5,0x8
f90001b4:	c0078793          	addi	a5,a5,-1024 # 7c00 <__stack_size+0x3c00>
f90001b8:	00f5f5b3          	and	a1,a1,a5
f90001bc:	00b56533          	or	a0,a0,a1
    *reg = val;
f90001c0:	00a72023          	sw	a0,0(a4)
    for (int i = 0; i < 2000; i++) {
f90001c4:	00000713          	li	a4,0
f90001c8:	7cf00793          	li	a5,1999
f90001cc:	00e7ce63          	blt	a5,a4,f90001e8 <mdio_read+0x54>
    return *reg;
f90001d0:	f81017b7          	lui	a5,0xf8101
f90001d4:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f90001d8:	0017f793          	andi	a5,a5,1
f90001dc:	00079a63          	bnez	a5,f90001f0 <mdio_read+0x5c>
    for (int i = 0; i < 2000; i++) {
f90001e0:	00170713          	addi	a4,a4,1
f90001e4:	fe5ff06f          	j	f90001c8 <mdio_read+0x34>
    int busy_seen = 0;
f90001e8:	00000693          	li	a3,0
f90001ec:	0080006f          	j	f90001f4 <mdio_read+0x60>
            busy_seen = 1;
f90001f0:	00100693          	li	a3,1
    if (!busy_seen)
f90001f4:	04068263          	beqz	a3,f9000238 <mdio_read+0xa4>
    for (int i = 0; i < 500000; i++) {
f90001f8:	00000713          	li	a4,0
f90001fc:	0007a7b7          	lui	a5,0x7a
f9000200:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000204:	00e7ce63          	blt	a5,a4,f9000220 <mdio_read+0x8c>
    return *reg;
f9000208:	f81017b7          	lui	a5,0xf8101
f900020c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000210:	0027f793          	andi	a5,a5,2
f9000214:	00079863          	bnez	a5,f9000224 <mdio_read+0x90>
    for (int i = 0; i < 500000; i++) {
f9000218:	00170713          	addi	a4,a4,1
f900021c:	fe1ff06f          	j	f90001fc <mdio_read+0x68>
    return 0;  // Timeout
f9000220:	00000693          	li	a3,0
    
    mdio_write_reg(MDIO_CTRL_REG, ctrl);
    
    // Wait for completion
    if (!mdio_wait_done())
f9000224:	02068063          	beqz	a3,f9000244 <mdio_read+0xb0>
    return *reg;
f9000228:	f81017b7          	lui	a5,0xf8101
f900022c:	0047a503          	lw	a0,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        return 0xFFFF;
    
    // Read data from STATUS[31:16]
    uint32_t status = mdio_read_reg(MDIO_STATUS_REG);
    return (uint16_t)(status >> 16);
f9000230:	01055513          	srli	a0,a0,0x10
f9000234:	00008067          	ret
        return 0xFFFF;
f9000238:	00010537          	lui	a0,0x10
f900023c:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
f9000240:	00008067          	ret
f9000244:	00010537          	lui	a0,0x10
f9000248:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
}
f900024c:	00008067          	ret

f9000250 <led_on>:
        *((volatile u32*) address) = data;
f9000250:	f800d7b7          	lui	a5,0xf800d
f9000254:	00300713          	li	a4,3
f9000258:	00e7a223          	sw	a4,4(a5) # f800d004 <__freertos_irq_stack_top+0xff007074>
extern void camera_init(void);

// =============================================================================
// Local helpers (all static to avoid duplicate-symbol link errors)
// =============================================================================
static void led_on(void)  { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x3); }
f900025c:	00008067          	ret

f9000260 <led_off>:
f9000260:	f800d7b7          	lui	a5,0xf800d
f9000264:	00200713          	li	a4,2
f9000268:	00e7a223          	sw	a4,4(a5) # f800d004 <__freertos_irq_stack_top+0xff007074>
static void led_off(void) { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2); }
f900026c:	00008067          	ret

f9000270 <led_pulse>:

static void led_pulse(int ms) {
f9000270:	ff010113          	addi	sp,sp,-16
f9000274:	00112623          	sw	ra,12(sp)
f9000278:	00812423          	sw	s0,8(sp)
f900027c:	00912223          	sw	s1,4(sp)
f9000280:	00050413          	mv	s0,a0
    led_on();  bsp_uDelay(ms * 1000);
f9000284:	fcdff0ef          	jal	ra,f9000250 <led_on>
f9000288:	3e800793          	li	a5,1000
f900028c:	02f40433          	mul	s0,s0,a5
f9000290:	f8b00637          	lui	a2,0xf8b00
f9000294:	02faf4b7          	lui	s1,0x2faf
f9000298:	08048593          	addi	a1,s1,128 # 2faf080 <__stack_size+0x2fab080>
f900029c:	00040513          	mv	a0,s0
f90002a0:	e89ff0ef          	jal	ra,f9000128 <clint_uDelay>
    led_off(); bsp_uDelay(ms * 1000);
f90002a4:	fbdff0ef          	jal	ra,f9000260 <led_off>
f90002a8:	f8b00637          	lui	a2,0xf8b00
f90002ac:	08048593          	addi	a1,s1,128
f90002b0:	00040513          	mv	a0,s0
f90002b4:	e75ff0ef          	jal	ra,f9000128 <clint_uDelay>
}
f90002b8:	00c12083          	lw	ra,12(sp)
f90002bc:	00812403          	lw	s0,8(sp)
f90002c0:	00412483          	lw	s1,4(sp)
f90002c4:	01010113          	addi	sp,sp,16
f90002c8:	00008067          	ret

f90002cc <uart_drain>:

static void uart_drain(void) {
f90002cc:	ff010113          	addi	sp,sp,-16
f90002d0:	00112623          	sw	ra,12(sp)
 *   [3] rx_full  - RX FIFO is full
 */
static inline uint8_t uart_mini_get_status(void)
{
    volatile uint32_t *status_reg = (volatile uint32_t *)(UART_MINI_BASE_ADDR + UART_STATUS_REG);
    return (uint8_t)(*status_reg & 0xFF);
f90002d4:	f81007b7          	lui	a5,0xf8100
f90002d8:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) {}
f90002dc:	0017f793          	andi	a5,a5,1
f90002e0:	fe078ae3          	beqz	a5,f90002d4 <uart_drain+0x8>
    bsp_uDelay(2000);
f90002e4:	f8b00637          	lui	a2,0xf8b00
f90002e8:	02faf5b7          	lui	a1,0x2faf
f90002ec:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f90002f0:	7d000513          	li	a0,2000
f90002f4:	e35ff0ef          	jal	ra,f9000128 <clint_uDelay>
}
f90002f8:	00c12083          	lw	ra,12(sp)
f90002fc:	01010113          	addi	sp,sp,16
f9000300:	00008067          	ret

f9000304 <print_s>:
 * 
 * @str: Pointer to string to transmit
 */
static inline void uart_mini_tx_string(const char *str)
{
    while (*str) {
f9000304:	00054703          	lbu	a4,0(a0)
f9000308:	04070c63          	beqz	a4,f9000360 <print_s+0x5c>

static void print_s(const char *s) { uart_mini_tx_string(s); }
f900030c:	ff010113          	addi	sp,sp,-16
f9000310:	0100006f          	j	f9000320 <print_s+0x1c>
        uart_mini_tx_byte_blocking((uint8_t)*str);
        str++;
f9000314:	00150513          	addi	a0,a0,1
    while (*str) {
f9000318:	00054703          	lbu	a4,0(a0)
f900031c:	02070e63          	beqz	a4,f9000358 <print_s+0x54>
    return (uint8_t)(*status_reg & 0xFF);
f9000320:	f81007b7          	lui	a5,0xf8100
f9000324:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000328:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900032c:	fe079ae3          	bnez	a5,f9000320 <print_s+0x1c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000330:	f81007b7          	lui	a5,0xf8100
f9000334:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f9000338:	000067b7          	lui	a5,0x6
f900033c:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9000340:	00f12623          	sw	a5,12(sp)
    while (count--) {
f9000344:	00c12783          	lw	a5,12(sp)
f9000348:	fff78713          	addi	a4,a5,-1
f900034c:	00e12623          	sw	a4,12(sp)
f9000350:	fc0782e3          	beqz	a5,f9000314 <print_s+0x10>
        asm volatile("");
f9000354:	ff1ff06f          	j	f9000344 <print_s+0x40>
f9000358:	01010113          	addi	sp,sp,16
f900035c:	00008067          	ret
f9000360:	00008067          	ret

f9000364 <println_s>:
static void println_s(const char *s) { print_s(s); uart_mini_newline(); uart_drain(); }
f9000364:	fe010113          	addi	sp,sp,-32
f9000368:	00112e23          	sw	ra,28(sp)
f900036c:	f99ff0ef          	jal	ra,f9000304 <print_s>
    return (uint8_t)(*status_reg & 0xFF);
f9000370:	f81007b7          	lui	a5,0xf8100
f9000374:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000378:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900037c:	fe079ae3          	bnez	a5,f9000370 <println_s+0xc>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000380:	f81007b7          	lui	a5,0xf8100
f9000384:	00d00713          	li	a4,13
f9000388:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f900038c:	000067b7          	lui	a5,0x6
f9000390:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9000394:	00f12423          	sw	a5,8(sp)
    while (count--) {
f9000398:	00812783          	lw	a5,8(sp)
f900039c:	fff78713          	addi	a4,a5,-1
f90003a0:	00e12423          	sw	a4,8(sp)
f90003a4:	00078463          	beqz	a5,f90003ac <println_s+0x48>
        asm volatile("");
f90003a8:	ff1ff06f          	j	f9000398 <println_s+0x34>
    return (uint8_t)(*status_reg & 0xFF);
f90003ac:	f81007b7          	lui	a5,0xf8100
f90003b0:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90003b4:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90003b8:	fe079ae3          	bnez	a5,f90003ac <println_s+0x48>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90003bc:	f81007b7          	lui	a5,0xf8100
f90003c0:	00a00713          	li	a4,10
f90003c4:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f90003c8:	000067b7          	lui	a5,0x6
f90003cc:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f90003d0:	00f12623          	sw	a5,12(sp)
    while (count--) {
f90003d4:	00c12783          	lw	a5,12(sp)
f90003d8:	fff78713          	addi	a4,a5,-1
f90003dc:	00e12623          	sw	a4,12(sp)
f90003e0:	00078463          	beqz	a5,f90003e8 <println_s+0x84>
        asm volatile("");
f90003e4:	ff1ff06f          	j	f90003d4 <println_s+0x70>
f90003e8:	ee5ff0ef          	jal	ra,f90002cc <uart_drain>
f90003ec:	01c12083          	lw	ra,28(sp)
f90003f0:	02010113          	addi	sp,sp,32
f90003f4:	00008067          	ret

f90003f8 <print_hex16_s>:

static void print_hex16_s(uint16_t v) {
f90003f8:	ff010113          	addi	sp,sp,-16
    static const char h[] = "0123456789ABCDEF";
    uart_mini_tx_byte(h[(v >> 12) & 0xF]);
f90003fc:	00c55713          	srli	a4,a0,0xc
f9000400:	f90027b7          	lui	a5,0xf9002
f9000404:	b7478793          	addi	a5,a5,-1164 # f9001b74 <__freertos_irq_stack_top+0xffffbbe4>
f9000408:	00e787b3          	add	a5,a5,a4
f900040c:	0007c703          	lbu	a4,0(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9000410:	f81007b7          	lui	a5,0xf8100
f9000414:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000418:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900041c:	02079663          	bnez	a5,f9000448 <print_hex16_s+0x50>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000420:	f81007b7          	lui	a5,0xf8100
f9000424:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f9000428:	000067b7          	lui	a5,0x6
f900042c:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9000430:	00f12623          	sw	a5,12(sp)
    while (count--) {
f9000434:	00c12783          	lw	a5,12(sp)
f9000438:	fff78713          	addi	a4,a5,-1
f900043c:	00e12623          	sw	a4,12(sp)
f9000440:	00078463          	beqz	a5,f9000448 <print_hex16_s+0x50>
        asm volatile("");
f9000444:	ff1ff06f          	j	f9000434 <print_hex16_s+0x3c>
    uart_mini_tx_byte(h[(v >>  8) & 0xF]);
f9000448:	00855793          	srli	a5,a0,0x8
f900044c:	00f7f713          	andi	a4,a5,15
f9000450:	f90027b7          	lui	a5,0xf9002
f9000454:	b7478793          	addi	a5,a5,-1164 # f9001b74 <__freertos_irq_stack_top+0xffffbbe4>
f9000458:	00e787b3          	add	a5,a5,a4
f900045c:	0007c703          	lbu	a4,0(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9000460:	f81007b7          	lui	a5,0xf8100
f9000464:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000468:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900046c:	02079663          	bnez	a5,f9000498 <print_hex16_s+0xa0>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000470:	f81007b7          	lui	a5,0xf8100
f9000474:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f9000478:	000067b7          	lui	a5,0x6
f900047c:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9000480:	00f12423          	sw	a5,8(sp)
    while (count--) {
f9000484:	0040006f          	j	f9000488 <print_hex16_s+0x90>
f9000488:	00812783          	lw	a5,8(sp)
f900048c:	fff78713          	addi	a4,a5,-1
f9000490:	00e12423          	sw	a4,8(sp)
f9000494:	fe079ae3          	bnez	a5,f9000488 <print_hex16_s+0x90>
    uart_mini_tx_byte(h[(v >>  4) & 0xF]);
f9000498:	00455793          	srli	a5,a0,0x4
f900049c:	00f7f713          	andi	a4,a5,15
f90004a0:	f90027b7          	lui	a5,0xf9002
f90004a4:	b7478793          	addi	a5,a5,-1164 # f9001b74 <__freertos_irq_stack_top+0xffffbbe4>
f90004a8:	00e787b3          	add	a5,a5,a4
f90004ac:	0007c703          	lbu	a4,0(a5)
    return (uint8_t)(*status_reg & 0xFF);
f90004b0:	f81007b7          	lui	a5,0xf8100
f90004b4:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90004b8:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90004bc:	02079663          	bnez	a5,f90004e8 <print_hex16_s+0xf0>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90004c0:	f81007b7          	lui	a5,0xf8100
f90004c4:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f90004c8:	000067b7          	lui	a5,0x6
f90004cc:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f90004d0:	00f12223          	sw	a5,4(sp)
    while (count--) {
f90004d4:	00412783          	lw	a5,4(sp)
f90004d8:	fff78713          	addi	a4,a5,-1
f90004dc:	00e12223          	sw	a4,4(sp)
f90004e0:	00078463          	beqz	a5,f90004e8 <print_hex16_s+0xf0>
        asm volatile("");
f90004e4:	ff1ff06f          	j	f90004d4 <print_hex16_s+0xdc>
    uart_mini_tx_byte(h[ v        & 0xF]);
f90004e8:	00f57513          	andi	a0,a0,15
f90004ec:	f90027b7          	lui	a5,0xf9002
f90004f0:	b7478793          	addi	a5,a5,-1164 # f9001b74 <__freertos_irq_stack_top+0xffffbbe4>
f90004f4:	00a78533          	add	a0,a5,a0
f90004f8:	00054703          	lbu	a4,0(a0)
    return (uint8_t)(*status_reg & 0xFF);
f90004fc:	f81007b7          	lui	a5,0xf8100
f9000500:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000504:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9000508:	02079663          	bnez	a5,f9000534 <print_hex16_s+0x13c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f900050c:	f81007b7          	lui	a5,0xf8100
f9000510:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f9000514:	000067b7          	lui	a5,0x6
f9000518:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f900051c:	00f12023          	sw	a5,0(sp)
    while (count--) {
f9000520:	00012783          	lw	a5,0(sp)
f9000524:	fff78713          	addi	a4,a5,-1
f9000528:	00e12023          	sw	a4,0(sp)
f900052c:	00078463          	beqz	a5,f9000534 <print_hex16_s+0x13c>
        asm volatile("");
f9000530:	ff1ff06f          	j	f9000520 <print_hex16_s+0x128>
}
f9000534:	01010113          	addi	sp,sp,16
f9000538:	00008067          	ret

f900053c <phy_init>:
// =============================================================================
// RTL8211F-CG PHY Initialisation via MDIO
// Sets RGMII internal TX/RX delays and configures 1Gbit auto-negotiation.
// PHY MDIO address: 0x01 (default for RTL8211F-CG)
// =============================================================================
static void phy_init(void) {
f900053c:	ff010113          	addi	sp,sp,-16
f9000540:	00112623          	sw	ra,12(sp)
f9000544:	00812423          	sw	s0,8(sp)
f9000548:	00912223          	sw	s1,4(sp)
f900054c:	01212023          	sw	s2,0(sp)
    const uint8_t phy = 0x01;

    println_s("=PHY INIT=");
f9000550:	f9002537          	lui	a0,0xf9002
f9000554:	bd050513          	addi	a0,a0,-1072 # f9001bd0 <__freertos_irq_stack_top+0xffffbc40>
f9000558:	e0dff0ef          	jal	ra,f9000364 <println_s>

    // Hardware reset: assert for 50 ms, release, wait 300 ms for PHY ready
    print_s("PHY HW RST...");
f900055c:	f9002537          	lui	a0,0xf9002
f9000560:	bdc50513          	addi	a0,a0,-1060 # f9001bdc <__freertos_irq_stack_top+0xffffbc4c>
f9000564:	da1ff0ef          	jal	ra,f9000304 <print_s>
    *reg = val;
f9000568:	f81014b7          	lui	s1,0xf8101
f900056c:	0004a423          	sw	zero,8(s1) # f8101008 <__freertos_irq_stack_top+0xff0fb078>
    mdio_phy_reset_assert();
    bsp_uDelay(50000);
f9000570:	f8b00637          	lui	a2,0xf8b00
f9000574:	02faf437          	lui	s0,0x2faf
f9000578:	08040593          	addi	a1,s0,128 # 2faf080 <__stack_size+0x2fab080>
f900057c:	0000c537          	lui	a0,0xc
f9000580:	35050513          	addi	a0,a0,848 # c350 <__stack_size+0x8350>
f9000584:	ba5ff0ef          	jal	ra,f9000128 <clint_uDelay>
f9000588:	00100793          	li	a5,1
f900058c:	00f4a423          	sw	a5,8(s1)
    mdio_phy_reset_release();
    bsp_uDelay(300000);
f9000590:	f8b00637          	lui	a2,0xf8b00
f9000594:	08040593          	addi	a1,s0,128
f9000598:	00049537          	lui	a0,0x49
f900059c:	3e050513          	addi	a0,a0,992 # 493e0 <__stack_size+0x453e0>
f90005a0:	b89ff0ef          	jal	ra,f9000128 <clint_uDelay>
    println_s("OK");
f90005a4:	f9002537          	lui	a0,0xf9002
f90005a8:	cd050513          	addi	a0,a0,-816 # f9001cd0 <__freertos_irq_stack_top+0xffffbd40>
f90005ac:	db9ff0ef          	jal	ra,f9000364 <println_s>

    // Read and print PHY ID for sanity check
    uint16_t id1 = mdio_read(phy, PHY_REG_PHYID1);
f90005b0:	00200593          	li	a1,2
f90005b4:	00100513          	li	a0,1
f90005b8:	bddff0ef          	jal	ra,f9000194 <mdio_read>
f90005bc:	00050913          	mv	s2,a0
    uint16_t id2 = mdio_read(phy, PHY_REG_PHYID2);
f90005c0:	00300593          	li	a1,3
f90005c4:	00100513          	li	a0,1
f90005c8:	bcdff0ef          	jal	ra,f9000194 <mdio_read>
f90005cc:	00050413          	mv	s0,a0
    print_s("ID="); print_hex16_s(id1); print_s("/"); print_hex16_s(id2); println_s("");
f90005d0:	f9002537          	lui	a0,0xf9002
f90005d4:	bec50513          	addi	a0,a0,-1044 # f9001bec <__freertos_irq_stack_top+0xffffbc5c>
f90005d8:	d2dff0ef          	jal	ra,f9000304 <print_s>
f90005dc:	00090513          	mv	a0,s2
f90005e0:	e19ff0ef          	jal	ra,f90003f8 <print_hex16_s>
f90005e4:	f9002537          	lui	a0,0xf9002
f90005e8:	bf050513          	addi	a0,a0,-1040 # f9001bf0 <__freertos_irq_stack_top+0xffffbc60>
f90005ec:	d19ff0ef          	jal	ra,f9000304 <print_s>
f90005f0:	00040513          	mv	a0,s0
f90005f4:	e05ff0ef          	jal	ra,f90003f8 <print_hex16_s>
f90005f8:	f9002537          	lui	a0,0xf9002
f90005fc:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9000600:	d65ff0ef          	jal	ra,f9000364 <println_s>
    // RGMII internal delay: page 0xd08, register 0x11
    //   bit 8 = TXDLY (2 ns TX delay in PHY, for far-end to sample our data)
    //   bit 3 = RXDLY (2 ns RX delay in PHY, for us to sample incoming data)
    // Enable both for standard RGMII with equal PCB trace lengths.
    // -----------------------------------------------------------------
    print_s("RGMII DLY...");
f9000604:	f9002537          	lui	a0,0xf9002
f9000608:	bf450513          	addi	a0,a0,-1036 # f9001bf4 <__freertos_irq_stack_top+0xffffbc64>
f900060c:	cf9ff0ef          	jal	ra,f9000304 <print_s>
f9000610:	00200793          	li	a5,2
f9000614:	00f4a223          	sw	a5,4(s1)
f9000618:	0d0887b7          	lui	a5,0xd088
f900061c:	c2178793          	addi	a5,a5,-991 # d087c21 <__stack_size+0xd083c21>
f9000620:	00f4a023          	sw	a5,0(s1)
    for (int i = 0; i < 2000; i++) {
f9000624:	00000713          	li	a4,0
f9000628:	7cf00793          	li	a5,1999
f900062c:	00e7ce63          	blt	a5,a4,f9000648 <phy_init+0x10c>
    return *reg;
f9000630:	f81017b7          	lui	a5,0xf8101
f9000634:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000638:	0017f793          	andi	a5,a5,1
f900063c:	00079a63          	bnez	a5,f9000650 <phy_init+0x114>
    for (int i = 0; i < 2000; i++) {
f9000640:	00170713          	addi	a4,a4,1
f9000644:	fe5ff06f          	j	f9000628 <phy_init+0xec>
    int busy_seen = 0;
f9000648:	00000793          	li	a5,0
f900064c:	0080006f          	j	f9000654 <phy_init+0x118>
            busy_seen = 1;
f9000650:	00100793          	li	a5,1
    if (!busy_seen)
f9000654:	02078663          	beqz	a5,f9000680 <phy_init+0x144>
    for (int i = 0; i < 500000; i++) {
f9000658:	00000713          	li	a4,0
f900065c:	0007a7b7          	lui	a5,0x7a
f9000660:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000664:	00e7ce63          	blt	a5,a4,f9000680 <phy_init+0x144>
    return *reg;
f9000668:	f81017b7          	lui	a5,0xf8101
f900066c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000670:	0027f793          	andi	a5,a5,2
f9000674:	00079663          	bnez	a5,f9000680 <phy_init+0x144>
    for (int i = 0; i < 500000; i++) {
f9000678:	00170713          	addi	a4,a4,1
f900067c:	fe1ff06f          	j	f900065c <phy_init+0x120>
    mdio_write(phy, 0x1F, 0x0d08);
    bsp_uDelay(1000);
f9000680:	f8b00637          	lui	a2,0xf8b00
f9000684:	02faf5b7          	lui	a1,0x2faf
f9000688:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f900068c:	3e800513          	li	a0,1000
f9000690:	a99ff0ef          	jal	ra,f9000128 <clint_uDelay>
    uint16_t reg11 = mdio_read(phy, 0x11);
f9000694:	01100593          	li	a1,17
f9000698:	00100513          	li	a0,1
f900069c:	af9ff0ef          	jal	ra,f9000194 <mdio_read>
    reg11 |= (1 << 8) | (1 << 3);   // TX and RX delay ON
f90006a0:	10856513          	ori	a0,a0,264
    *reg = val;
f90006a4:	f8101737          	lui	a4,0xf8101
f90006a8:	00200793          	li	a5,2
f90006ac:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
    // Build CTRL word: start=1, RW=0(write), phy_addr, reg_addr, wdata
    uint32_t ctrl = (1 << 0)                      // start
                  | (0 << 1)                       // RW = write
                  | ((phy_addr & 0x1F) << 5)       // PHY address
                  | ((reg_addr & 0x1F) << 10)      // Register address
                  | ((uint32_t)data << 16);         // Write data
f90006b0:	01051513          	slli	a0,a0,0x10
    uint32_t ctrl = (1 << 0)                      // start
f90006b4:	000047b7          	lui	a5,0x4
f90006b8:	42178793          	addi	a5,a5,1057 # 4421 <__stack_size+0x421>
f90006bc:	00f56533          	or	a0,a0,a5
    *reg = val;
f90006c0:	00a72023          	sw	a0,0(a4)
    for (int i = 0; i < 2000; i++) {
f90006c4:	00000713          	li	a4,0
f90006c8:	7cf00793          	li	a5,1999
f90006cc:	00e7ce63          	blt	a5,a4,f90006e8 <phy_init+0x1ac>
    return *reg;
f90006d0:	f81017b7          	lui	a5,0xf8101
f90006d4:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f90006d8:	0017f793          	andi	a5,a5,1
f90006dc:	00079a63          	bnez	a5,f90006f0 <phy_init+0x1b4>
    for (int i = 0; i < 2000; i++) {
f90006e0:	00170713          	addi	a4,a4,1
f90006e4:	fe5ff06f          	j	f90006c8 <phy_init+0x18c>
    int busy_seen = 0;
f90006e8:	00000793          	li	a5,0
f90006ec:	0080006f          	j	f90006f4 <phy_init+0x1b8>
            busy_seen = 1;
f90006f0:	00100793          	li	a5,1
    if (!busy_seen)
f90006f4:	02078663          	beqz	a5,f9000720 <phy_init+0x1e4>
    for (int i = 0; i < 500000; i++) {
f90006f8:	00000713          	li	a4,0
f90006fc:	0080006f          	j	f9000704 <phy_init+0x1c8>
f9000700:	00170713          	addi	a4,a4,1
f9000704:	0007a7b7          	lui	a5,0x7a
f9000708:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f900070c:	00e7ca63          	blt	a5,a4,f9000720 <phy_init+0x1e4>
    return *reg;
f9000710:	f81017b7          	lui	a5,0xf8101
f9000714:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000718:	0027f793          	andi	a5,a5,2
f900071c:	fe0782e3          	beqz	a5,f9000700 <phy_init+0x1c4>
    mdio_write(phy, 0x11, reg11);
    bsp_uDelay(1000);
f9000720:	f8b00637          	lui	a2,0xf8b00
f9000724:	02faf5b7          	lui	a1,0x2faf
f9000728:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f900072c:	3e800513          	li	a0,1000
f9000730:	9f9ff0ef          	jal	ra,f9000128 <clint_uDelay>
    uint16_t rb = mdio_read(phy, 0x11);
f9000734:	01100593          	li	a1,17
f9000738:	00100513          	li	a0,1
f900073c:	a59ff0ef          	jal	ra,f9000194 <mdio_read>
f9000740:	00050413          	mv	s0,a0
    *reg = val;
f9000744:	f8101737          	lui	a4,0xf8101
f9000748:	00200793          	li	a5,2
f900074c:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000750:	000087b7          	lui	a5,0x8
f9000754:	c2178793          	addi	a5,a5,-991 # 7c21 <__stack_size+0x3c21>
f9000758:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f900075c:	00000713          	li	a4,0
f9000760:	7cf00793          	li	a5,1999
f9000764:	00e7ce63          	blt	a5,a4,f9000780 <phy_init+0x244>
    return *reg;
f9000768:	f81017b7          	lui	a5,0xf8101
f900076c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000770:	0017f793          	andi	a5,a5,1
f9000774:	00079a63          	bnez	a5,f9000788 <phy_init+0x24c>
    for (int i = 0; i < 2000; i++) {
f9000778:	00170713          	addi	a4,a4,1
f900077c:	fe5ff06f          	j	f9000760 <phy_init+0x224>
    int busy_seen = 0;
f9000780:	00000793          	li	a5,0
f9000784:	0080006f          	j	f900078c <phy_init+0x250>
            busy_seen = 1;
f9000788:	00100793          	li	a5,1
    if (!busy_seen)
f900078c:	02078663          	beqz	a5,f90007b8 <phy_init+0x27c>
    for (int i = 0; i < 500000; i++) {
f9000790:	00000713          	li	a4,0
f9000794:	0080006f          	j	f900079c <phy_init+0x260>
f9000798:	00170713          	addi	a4,a4,1
f900079c:	0007a7b7          	lui	a5,0x7a
f90007a0:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f90007a4:	00e7ca63          	blt	a5,a4,f90007b8 <phy_init+0x27c>
    return *reg;
f90007a8:	f81017b7          	lui	a5,0xf8101
f90007ac:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f90007b0:	0027f793          	andi	a5,a5,2
f90007b4:	fe0782e3          	beqz	a5,f9000798 <phy_init+0x25c>
    mdio_write(phy, 0x1F, 0x0000);
    print_s("REG="); print_hex16_s(rb);
f90007b8:	f9002537          	lui	a0,0xf9002
f90007bc:	c0450513          	addi	a0,a0,-1020 # f9001c04 <__freertos_irq_stack_top+0xffffbc74>
f90007c0:	b45ff0ef          	jal	ra,f9000304 <print_s>
f90007c4:	00040513          	mv	a0,s0
f90007c8:	c31ff0ef          	jal	ra,f90003f8 <print_hex16_s>
    print_s(rb & (1 << 8) ? " TX=ON" : " TX=OFF");
f90007cc:	10047793          	andi	a5,s0,256
f90007d0:	06078c63          	beqz	a5,f9000848 <phy_init+0x30c>
f90007d4:	f9002537          	lui	a0,0xf9002
f90007d8:	b9050513          	addi	a0,a0,-1136 # f9001b90 <__freertos_irq_stack_top+0xffffbc00>
f90007dc:	b29ff0ef          	jal	ra,f9000304 <print_s>
    print_s(rb & (1 << 3) ? " RX=ON" : " RX=OFF");
f90007e0:	00847413          	andi	s0,s0,8
f90007e4:	06040863          	beqz	s0,f9000854 <phy_init+0x318>
f90007e8:	f9002537          	lui	a0,0xf9002
f90007ec:	ba050513          	addi	a0,a0,-1120 # f9001ba0 <__freertos_irq_stack_top+0xffffbc10>
f90007f0:	b15ff0ef          	jal	ra,f9000304 <print_s>
    println_s("");
f90007f4:	f9002537          	lui	a0,0xf9002
f90007f8:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f90007fc:	b69ff0ef          	jal	ra,f9000364 <println_s>

    // -----------------------------------------------------------------
    // Disable Green Ethernet (can interfere with 1Gbit link stability)
    // -----------------------------------------------------------------
    print_s("Dis GreenEth...");
f9000800:	f9002537          	lui	a0,0xf9002
f9000804:	c0c50513          	addi	a0,a0,-1012 # f9001c0c <__freertos_irq_stack_top+0xffffbc7c>
f9000808:	afdff0ef          	jal	ra,f9000304 <print_s>
    *reg = val;
f900080c:	f8101737          	lui	a4,0xf8101
f9000810:	00200793          	li	a5,2
f9000814:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000818:	0a4387b7          	lui	a5,0xa438
f900081c:	c2178793          	addi	a5,a5,-991 # a437c21 <__stack_size+0xa433c21>
f9000820:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000824:	00000713          	li	a4,0
f9000828:	7cf00793          	li	a5,1999
f900082c:	02e7ca63          	blt	a5,a4,f9000860 <phy_init+0x324>
    return *reg;
f9000830:	f81017b7          	lui	a5,0xf8101
f9000834:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000838:	0017f793          	andi	a5,a5,1
f900083c:	02079663          	bnez	a5,f9000868 <phy_init+0x32c>
    for (int i = 0; i < 2000; i++) {
f9000840:	00170713          	addi	a4,a4,1
f9000844:	fe5ff06f          	j	f9000828 <phy_init+0x2ec>
    print_s(rb & (1 << 8) ? " TX=ON" : " TX=OFF");
f9000848:	f9002537          	lui	a0,0xf9002
f900084c:	b8850513          	addi	a0,a0,-1144 # f9001b88 <__freertos_irq_stack_top+0xffffbbf8>
f9000850:	f8dff06f          	j	f90007dc <phy_init+0x2a0>
    print_s(rb & (1 << 3) ? " RX=ON" : " RX=OFF");
f9000854:	f9002537          	lui	a0,0xf9002
f9000858:	b9850513          	addi	a0,a0,-1128 # f9001b98 <__freertos_irq_stack_top+0xffffbc08>
f900085c:	f95ff06f          	j	f90007f0 <phy_init+0x2b4>
    int busy_seen = 0;
f9000860:	00000793          	li	a5,0
f9000864:	0080006f          	j	f900086c <phy_init+0x330>
            busy_seen = 1;
f9000868:	00100793          	li	a5,1
    if (!busy_seen)
f900086c:	02078663          	beqz	a5,f9000898 <phy_init+0x35c>
    for (int i = 0; i < 500000; i++) {
f9000870:	00000713          	li	a4,0
f9000874:	0007a7b7          	lui	a5,0x7a
f9000878:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f900087c:	00e7ce63          	blt	a5,a4,f9000898 <phy_init+0x35c>
    return *reg;
f9000880:	f81017b7          	lui	a5,0xf8101
f9000884:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000888:	0027f793          	andi	a5,a5,2
f900088c:	00079663          	bnez	a5,f9000898 <phy_init+0x35c>
    for (int i = 0; i < 500000; i++) {
f9000890:	00170713          	addi	a4,a4,1
f9000894:	fe1ff06f          	j	f9000874 <phy_init+0x338>
    *reg = val;
f9000898:	f8101737          	lui	a4,0xf8101
f900089c:	00200793          	li	a5,2
f90008a0:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f90008a4:	801177b7          	lui	a5,0x80117
f90008a8:	c2178793          	addi	a5,a5,-991 # 80116c21 <__freertos_irq_stack_top+0x87110c91>
f90008ac:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f90008b0:	00000713          	li	a4,0
f90008b4:	7cf00793          	li	a5,1999
f90008b8:	00e7ce63          	blt	a5,a4,f90008d4 <phy_init+0x398>
    return *reg;
f90008bc:	f81017b7          	lui	a5,0xf8101
f90008c0:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f90008c4:	0017f793          	andi	a5,a5,1
f90008c8:	00079a63          	bnez	a5,f90008dc <phy_init+0x3a0>
    for (int i = 0; i < 2000; i++) {
f90008cc:	00170713          	addi	a4,a4,1
f90008d0:	fe5ff06f          	j	f90008b4 <phy_init+0x378>
    int busy_seen = 0;
f90008d4:	00000793          	li	a5,0
f90008d8:	0080006f          	j	f90008e0 <phy_init+0x3a4>
            busy_seen = 1;
f90008dc:	00100793          	li	a5,1
    if (!busy_seen)
f90008e0:	02078663          	beqz	a5,f900090c <phy_init+0x3d0>
    for (int i = 0; i < 500000; i++) {
f90008e4:	00000713          	li	a4,0
f90008e8:	0007a7b7          	lui	a5,0x7a
f90008ec:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f90008f0:	00e7ce63          	blt	a5,a4,f900090c <phy_init+0x3d0>
    return *reg;
f90008f4:	f81017b7          	lui	a5,0xf8101
f90008f8:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f90008fc:	0027f793          	andi	a5,a5,2
f9000900:	00079663          	bnez	a5,f900090c <phy_init+0x3d0>
    for (int i = 0; i < 500000; i++) {
f9000904:	00170713          	addi	a4,a4,1
f9000908:	fe1ff06f          	j	f90008e8 <phy_init+0x3ac>
    *reg = val;
f900090c:	f8101737          	lui	a4,0xf8101
f9000910:	00200793          	li	a5,2
f9000914:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000918:	573f77b7          	lui	a5,0x573f7
f900091c:	02178793          	addi	a5,a5,33 # 573f7021 <__stack_size+0x573f3021>
f9000920:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000924:	00000713          	li	a4,0
f9000928:	0080006f          	j	f9000930 <phy_init+0x3f4>
f900092c:	00170713          	addi	a4,a4,1
f9000930:	7cf00793          	li	a5,1999
f9000934:	04e7c263          	blt	a5,a4,f9000978 <phy_init+0x43c>
    return *reg;
f9000938:	f81017b7          	lui	a5,0xf8101
f900093c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000940:	0017f793          	andi	a5,a5,1
f9000944:	fe0784e3          	beqz	a5,f900092c <phy_init+0x3f0>
            busy_seen = 1;
f9000948:	00100793          	li	a5,1
    if (!busy_seen)
f900094c:	02078a63          	beqz	a5,f9000980 <phy_init+0x444>
    for (int i = 0; i < 500000; i++) {
f9000950:	00000713          	li	a4,0
f9000954:	0007a7b7          	lui	a5,0x7a
f9000958:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f900095c:	02e7c263          	blt	a5,a4,f9000980 <phy_init+0x444>
    return *reg;
f9000960:	f81017b7          	lui	a5,0xf8101
f9000964:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000968:	0027f793          	andi	a5,a5,2
f900096c:	00079a63          	bnez	a5,f9000980 <phy_init+0x444>
    for (int i = 0; i < 500000; i++) {
f9000970:	00170713          	addi	a4,a4,1
f9000974:	fe1ff06f          	j	f9000954 <phy_init+0x418>
    int busy_seen = 0;
f9000978:	00000793          	li	a5,0
f900097c:	fd1ff06f          	j	f900094c <phy_init+0x410>
    *reg = val;
f9000980:	f8101737          	lui	a4,0xf8101
f9000984:	00200793          	li	a5,2
f9000988:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f900098c:	000087b7          	lui	a5,0x8
f9000990:	c2178793          	addi	a5,a5,-991 # 7c21 <__stack_size+0x3c21>
f9000994:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000998:	00000713          	li	a4,0
f900099c:	0080006f          	j	f90009a4 <phy_init+0x468>
f90009a0:	00170713          	addi	a4,a4,1
f90009a4:	7cf00793          	li	a5,1999
f90009a8:	04e7c263          	blt	a5,a4,f90009ec <phy_init+0x4b0>
    return *reg;
f90009ac:	f81017b7          	lui	a5,0xf8101
f90009b0:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f90009b4:	0017f793          	andi	a5,a5,1
f90009b8:	fe0784e3          	beqz	a5,f90009a0 <phy_init+0x464>
            busy_seen = 1;
f90009bc:	00100793          	li	a5,1
    if (!busy_seen)
f90009c0:	02078a63          	beqz	a5,f90009f4 <phy_init+0x4b8>
    for (int i = 0; i < 500000; i++) {
f90009c4:	00000713          	li	a4,0
f90009c8:	0007a7b7          	lui	a5,0x7a
f90009cc:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f90009d0:	02e7c263          	blt	a5,a4,f90009f4 <phy_init+0x4b8>
    return *reg;
f90009d4:	f81017b7          	lui	a5,0xf8101
f90009d8:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f90009dc:	0027f793          	andi	a5,a5,2
f90009e0:	00079a63          	bnez	a5,f90009f4 <phy_init+0x4b8>
    for (int i = 0; i < 500000; i++) {
f90009e4:	00170713          	addi	a4,a4,1
f90009e8:	fe1ff06f          	j	f90009c8 <phy_init+0x48c>
    int busy_seen = 0;
f90009ec:	00000793          	li	a5,0
f90009f0:	fd1ff06f          	j	f90009c0 <phy_init+0x484>
    mdio_write(phy, 0x1F, 0x0a43);
    mdio_write(phy, 0x1B, 0x8011);
    mdio_write(phy, 0x1C, 0x573F);
    mdio_write(phy, 0x1F, 0x0000);
    println_s("OK");
f90009f4:	f9002537          	lui	a0,0xf9002
f90009f8:	cd050513          	addi	a0,a0,-816 # f9001cd0 <__freertos_irq_stack_top+0xffffbd40>
f90009fc:	969ff0ef          	jal	ra,f9000364 <println_s>

    // -----------------------------------------------------------------
    // Force 1Gbit full-duplex auto-negotiation
    // -----------------------------------------------------------------
    println_s("1G AN start...");
f9000a00:	f9002537          	lui	a0,0xf9002
f9000a04:	c1c50513          	addi	a0,a0,-996 # f9001c1c <__freertos_irq_stack_top+0xffffbc8c>
f9000a08:	95dff0ef          	jal	ra,f9000364 <println_s>
    *reg = val;
f9000a0c:	f8101737          	lui	a4,0xf8101
f9000a10:	00200793          	li	a5,2
f9000a14:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000a18:	020027b7          	lui	a5,0x2002
f9000a1c:	42178793          	addi	a5,a5,1057 # 2002421 <__stack_size+0x1ffe421>
f9000a20:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000a24:	00000713          	li	a4,0
f9000a28:	0080006f          	j	f9000a30 <phy_init+0x4f4>
f9000a2c:	00170713          	addi	a4,a4,1
f9000a30:	7cf00793          	li	a5,1999
f9000a34:	02e7c263          	blt	a5,a4,f9000a58 <phy_init+0x51c>
    return *reg;
f9000a38:	f81017b7          	lui	a5,0xf8101
f9000a3c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000a40:	0017f793          	andi	a5,a5,1
f9000a44:	fe0784e3          	beqz	a5,f9000a2c <phy_init+0x4f0>
            busy_seen = 1;
f9000a48:	00100793          	li	a5,1
    if (!busy_seen)
f9000a4c:	02078a63          	beqz	a5,f9000a80 <phy_init+0x544>
    for (int i = 0; i < 500000; i++) {
f9000a50:	00000713          	li	a4,0
f9000a54:	0100006f          	j	f9000a64 <phy_init+0x528>
    int busy_seen = 0;
f9000a58:	00000793          	li	a5,0
f9000a5c:	ff1ff06f          	j	f9000a4c <phy_init+0x510>
    for (int i = 0; i < 500000; i++) {
f9000a60:	00170713          	addi	a4,a4,1
f9000a64:	0007a7b7          	lui	a5,0x7a
f9000a68:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000a6c:	00e7ca63          	blt	a5,a4,f9000a80 <phy_init+0x544>
    return *reg;
f9000a70:	f81017b7          	lui	a5,0xf8101
f9000a74:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000a78:	0027f793          	andi	a5,a5,2
f9000a7c:	fe0782e3          	beqz	a5,f9000a60 <phy_init+0x524>
    *reg = val;
f9000a80:	f8101737          	lui	a4,0xf8101
f9000a84:	00200793          	li	a5,2
f9000a88:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000a8c:	000117b7          	lui	a5,0x11
f9000a90:	02178793          	addi	a5,a5,33 # 11021 <__stack_size+0xd021>
f9000a94:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000a98:	00000713          	li	a4,0
f9000a9c:	7cf00793          	li	a5,1999
f9000aa0:	00e7ce63          	blt	a5,a4,f9000abc <phy_init+0x580>
    return *reg;
f9000aa4:	f81017b7          	lui	a5,0xf8101
f9000aa8:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000aac:	0017f793          	andi	a5,a5,1
f9000ab0:	00079a63          	bnez	a5,f9000ac4 <phy_init+0x588>
    for (int i = 0; i < 2000; i++) {
f9000ab4:	00170713          	addi	a4,a4,1
f9000ab8:	fe5ff06f          	j	f9000a9c <phy_init+0x560>
    int busy_seen = 0;
f9000abc:	00000793          	li	a5,0
f9000ac0:	0080006f          	j	f9000ac8 <phy_init+0x58c>
            busy_seen = 1;
f9000ac4:	00100793          	li	a5,1
    if (!busy_seen)
f9000ac8:	02078663          	beqz	a5,f9000af4 <phy_init+0x5b8>
    for (int i = 0; i < 500000; i++) {
f9000acc:	00000713          	li	a4,0
f9000ad0:	0007a7b7          	lui	a5,0x7a
f9000ad4:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000ad8:	00e7ce63          	blt	a5,a4,f9000af4 <phy_init+0x5b8>
    return *reg;
f9000adc:	f81017b7          	lui	a5,0xf8101
f9000ae0:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000ae4:	0027f793          	andi	a5,a5,2
f9000ae8:	00079663          	bnez	a5,f9000af4 <phy_init+0x5b8>
    for (int i = 0; i < 500000; i++) {
f9000aec:	00170713          	addi	a4,a4,1
f9000af0:	fe1ff06f          	j	f9000ad0 <phy_init+0x594>
    *reg = val;
f9000af4:	f8101737          	lui	a4,0xf8101
f9000af8:	00200793          	li	a5,2
f9000afc:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000b00:	120007b7          	lui	a5,0x12000
f9000b04:	02178793          	addi	a5,a5,33 # 12000021 <__stack_size+0x11ffc021>
f9000b08:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000b0c:	00000713          	li	a4,0
f9000b10:	7cf00793          	li	a5,1999
f9000b14:	00e7ce63          	blt	a5,a4,f9000b30 <phy_init+0x5f4>
    return *reg;
f9000b18:	f81017b7          	lui	a5,0xf8101
f9000b1c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000b20:	0017f793          	andi	a5,a5,1
f9000b24:	00079a63          	bnez	a5,f9000b38 <phy_init+0x5fc>
    for (int i = 0; i < 2000; i++) {
f9000b28:	00170713          	addi	a4,a4,1
f9000b2c:	fe5ff06f          	j	f9000b10 <phy_init+0x5d4>
    int busy_seen = 0;
f9000b30:	00000413          	li	s0,0
f9000b34:	0080006f          	j	f9000b3c <phy_init+0x600>
            busy_seen = 1;
f9000b38:	00100413          	li	s0,1
    if (!busy_seen)
f9000b3c:	12040063          	beqz	s0,f9000c5c <phy_init+0x720>
    for (int i = 0; i < 500000; i++) {
f9000b40:	00000713          	li	a4,0
f9000b44:	0007a7b7          	lui	a5,0x7a
f9000b48:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000b4c:	00e7ce63          	blt	a5,a4,f9000b68 <phy_init+0x62c>
    return *reg;
f9000b50:	f81017b7          	lui	a5,0xf8101
f9000b54:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000b58:	0027f793          	andi	a5,a5,2
f9000b5c:	16079863          	bnez	a5,f9000ccc <phy_init+0x790>
    for (int i = 0; i < 500000; i++) {
f9000b60:	00170713          	addi	a4,a4,1
f9000b64:	fe1ff06f          	j	f9000b44 <phy_init+0x608>
f9000b68:	00000413          	li	s0,0
f9000b6c:	0f00006f          	j	f9000c5c <phy_init+0x720>
    int busy_seen = 0;
f9000b70:	00000693          	li	a3,0
f9000b74:	0080006f          	j	f9000b7c <phy_init+0x640>
            busy_seen = 1;
f9000b78:	00100693          	li	a3,1
    if (!busy_seen)
f9000b7c:	02068e63          	beqz	a3,f9000bb8 <phy_init+0x67c>
    for (int i = 0; i < 500000; i++) {
f9000b80:	00000713          	li	a4,0
f9000b84:	0007a7b7          	lui	a5,0x7a
f9000b88:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000b8c:	00e7ce63          	blt	a5,a4,f9000ba8 <phy_init+0x66c>
    return *reg;
f9000b90:	f81017b7          	lui	a5,0xf8101
f9000b94:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000b98:	0027f793          	andi	a5,a5,2
f9000b9c:	00079863          	bnez	a5,f9000bac <phy_init+0x670>
    for (int i = 0; i < 500000; i++) {
f9000ba0:	00170713          	addi	a4,a4,1
f9000ba4:	fe1ff06f          	j	f9000b84 <phy_init+0x648>
    return 0;  // Timeout
f9000ba8:	00000693          	li	a3,0
    if (!mdio_wait_done())
f9000bac:	00068663          	beqz	a3,f9000bb8 <phy_init+0x67c>
    return *reg;
f9000bb0:	f81017b7          	lui	a5,0xf8101
f9000bb4:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
    *reg = val;
f9000bb8:	f81017b7          	lui	a5,0xf8101
f9000bbc:	00200713          	li	a4,2
f9000bc0:	00e7a223          	sw	a4,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000bc4:	42300713          	li	a4,1059
f9000bc8:	00e7a023          	sw	a4,0(a5)
    for (int i = 0; i < 2000; i++) {
f9000bcc:	00000713          	li	a4,0
f9000bd0:	7cf00793          	li	a5,1999
f9000bd4:	00e7ce63          	blt	a5,a4,f9000bf0 <phy_init+0x6b4>
    return *reg;
f9000bd8:	f81017b7          	lui	a5,0xf8101
f9000bdc:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000be0:	0017f793          	andi	a5,a5,1
f9000be4:	00079a63          	bnez	a5,f9000bf8 <phy_init+0x6bc>
    for (int i = 0; i < 2000; i++) {
f9000be8:	00170713          	addi	a4,a4,1
f9000bec:	fe5ff06f          	j	f9000bd0 <phy_init+0x694>
    int busy_seen = 0;
f9000bf0:	00000693          	li	a3,0
f9000bf4:	0080006f          	j	f9000bfc <phy_init+0x6c0>
            busy_seen = 1;
f9000bf8:	00100693          	li	a3,1
    if (!busy_seen)
f9000bfc:	0a068c63          	beqz	a3,f9000cb4 <phy_init+0x778>
    for (int i = 0; i < 500000; i++) {
f9000c00:	00000713          	li	a4,0
f9000c04:	0007a7b7          	lui	a5,0x7a
f9000c08:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000c0c:	00e7ce63          	blt	a5,a4,f9000c28 <phy_init+0x6ec>
    return *reg;
f9000c10:	f81017b7          	lui	a5,0xf8101
f9000c14:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000c18:	0027f793          	andi	a5,a5,2
f9000c1c:	00079863          	bnez	a5,f9000c2c <phy_init+0x6f0>
    for (int i = 0; i < 500000; i++) {
f9000c20:	00170713          	addi	a4,a4,1
f9000c24:	fe1ff06f          	j	f9000c04 <phy_init+0x6c8>
    return 0;  // Timeout
f9000c28:	00000693          	li	a3,0
    if (!mdio_wait_done())
f9000c2c:	08068a63          	beqz	a3,f9000cc0 <phy_init+0x784>
    return *reg;
f9000c30:	f81017b7          	lui	a5,0xf8101
f9000c34:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
    return (uint16_t)(status >> 16);
f9000c38:	0107d793          	srli	a5,a5,0x10
    for (int i = 0; i < 10; i++) {
        bsp_uDelay(1000000);
        // Read BMSR twice (first read may return stale latched state)
        mdio_read(phy, PHY_REG_BMSR);
        uint16_t bmsr = mdio_read(phy, PHY_REG_BMSR);
        if ((bmsr & 0x0004) && (bmsr & 0x0020)) { linked = 1; break; }
f9000c3c:	0247f793          	andi	a5,a5,36
f9000c40:	02400713          	li	a4,36
f9000c44:	0ee78c63          	beq	a5,a4,f9000d3c <phy_init+0x800>
        print_s("."); uart_drain();
f9000c48:	f9002537          	lui	a0,0xf9002
f9000c4c:	eec50513          	addi	a0,a0,-276 # f9001eec <__freertos_irq_stack_top+0xffffbf5c>
f9000c50:	eb4ff0ef          	jal	ra,f9000304 <print_s>
f9000c54:	e78ff0ef          	jal	ra,f90002cc <uart_drain>
    for (int i = 0; i < 10; i++) {
f9000c58:	00140413          	addi	s0,s0,1
f9000c5c:	00900793          	li	a5,9
f9000c60:	0687ca63          	blt	a5,s0,f9000cd4 <phy_init+0x798>
        bsp_uDelay(1000000);
f9000c64:	f8b00637          	lui	a2,0xf8b00
f9000c68:	02faf5b7          	lui	a1,0x2faf
f9000c6c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9000c70:	000f4537          	lui	a0,0xf4
f9000c74:	24050513          	addi	a0,a0,576 # f4240 <__stack_size+0xf0240>
f9000c78:	cb0ff0ef          	jal	ra,f9000128 <clint_uDelay>
    *reg = val;
f9000c7c:	f81017b7          	lui	a5,0xf8101
f9000c80:	00200713          	li	a4,2
f9000c84:	00e7a223          	sw	a4,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000c88:	42300713          	li	a4,1059
f9000c8c:	00e7a023          	sw	a4,0(a5)
    for (int i = 0; i < 2000; i++) {
f9000c90:	00000713          	li	a4,0
f9000c94:	7cf00793          	li	a5,1999
f9000c98:	ece7cce3          	blt	a5,a4,f9000b70 <phy_init+0x634>
    return *reg;
f9000c9c:	f81017b7          	lui	a5,0xf8101
f9000ca0:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000ca4:	0017f793          	andi	a5,a5,1
f9000ca8:	ec0798e3          	bnez	a5,f9000b78 <phy_init+0x63c>
    for (int i = 0; i < 2000; i++) {
f9000cac:	00170713          	addi	a4,a4,1
f9000cb0:	fe5ff06f          	j	f9000c94 <phy_init+0x758>
        return 0xFFFF;
f9000cb4:	000107b7          	lui	a5,0x10
f9000cb8:	fff78793          	addi	a5,a5,-1 # ffff <__stack_size+0xbfff>
f9000cbc:	f81ff06f          	j	f9000c3c <phy_init+0x700>
f9000cc0:	000107b7          	lui	a5,0x10
f9000cc4:	fff78793          	addi	a5,a5,-1 # ffff <__stack_size+0xbfff>
f9000cc8:	f75ff06f          	j	f9000c3c <phy_init+0x700>
        if (status & MDIO_STATUS_DONE)
f9000ccc:	00000413          	li	s0,0
f9000cd0:	f8dff06f          	j	f9000c5c <phy_init+0x720>
    int linked = 0;
f9000cd4:	00000493          	li	s1,0
    }
    println_s("");
f9000cd8:	f9002537          	lui	a0,0xf9002
f9000cdc:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9000ce0:	e84ff0ef          	jal	ra,f9000364 <println_s>

    // Report result
    mdio_read(phy, PHY_REG_BMSR);
f9000ce4:	00100593          	li	a1,1
f9000ce8:	00100513          	li	a0,1
f9000cec:	ca8ff0ef          	jal	ra,f9000194 <mdio_read>
    uint16_t bmsr  = mdio_read(phy, PHY_REG_BMSR);
f9000cf0:	00100593          	li	a1,1
f9000cf4:	00100513          	li	a0,1
f9000cf8:	c9cff0ef          	jal	ra,f9000194 <mdio_read>
f9000cfc:	00050413          	mv	s0,a0
    *reg = val;
f9000d00:	f8101737          	lui	a4,0xf8101
f9000d04:	00200793          	li	a5,2
f9000d08:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000d0c:	0a4387b7          	lui	a5,0xa438
f9000d10:	c2178793          	addi	a5,a5,-991 # a437c21 <__stack_size+0xa433c21>
f9000d14:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000d18:	00000713          	li	a4,0
f9000d1c:	7cf00793          	li	a5,1999
f9000d20:	02e7c263          	blt	a5,a4,f9000d44 <phy_init+0x808>
    return *reg;
f9000d24:	f81017b7          	lui	a5,0xf8101
f9000d28:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000d2c:	0017f793          	andi	a5,a5,1
f9000d30:	00079e63          	bnez	a5,f9000d4c <phy_init+0x810>
    for (int i = 0; i < 2000; i++) {
f9000d34:	00170713          	addi	a4,a4,1
f9000d38:	fe5ff06f          	j	f9000d1c <phy_init+0x7e0>
        if ((bmsr & 0x0004) && (bmsr & 0x0020)) { linked = 1; break; }
f9000d3c:	00100493          	li	s1,1
f9000d40:	f99ff06f          	j	f9000cd8 <phy_init+0x79c>
    int busy_seen = 0;
f9000d44:	00000793          	li	a5,0
f9000d48:	0080006f          	j	f9000d50 <phy_init+0x814>
            busy_seen = 1;
f9000d4c:	00100793          	li	a5,1
    if (!busy_seen)
f9000d50:	02078663          	beqz	a5,f9000d7c <phy_init+0x840>
    for (int i = 0; i < 500000; i++) {
f9000d54:	00000713          	li	a4,0
f9000d58:	0007a7b7          	lui	a5,0x7a
f9000d5c:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000d60:	00e7ce63          	blt	a5,a4,f9000d7c <phy_init+0x840>
    return *reg;
f9000d64:	f81017b7          	lui	a5,0xf8101
f9000d68:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000d6c:	0027f793          	andi	a5,a5,2
f9000d70:	00079663          	bnez	a5,f9000d7c <phy_init+0x840>
    for (int i = 0; i < 500000; i++) {
f9000d74:	00170713          	addi	a4,a4,1
f9000d78:	fe1ff06f          	j	f9000d58 <phy_init+0x81c>
    // PHY specific status: switch to page 0xa43, read reg 0x1A
    mdio_write(phy, 0x1F, 0x0a43);
    bsp_uDelay(1000);
f9000d7c:	f8b00637          	lui	a2,0xf8b00
f9000d80:	02faf5b7          	lui	a1,0x2faf
f9000d84:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9000d88:	3e800513          	li	a0,1000
f9000d8c:	b9cff0ef          	jal	ra,f9000128 <clint_uDelay>
    uint16_t physr = mdio_read(phy, 0x1A);
f9000d90:	01a00593          	li	a1,26
f9000d94:	00100513          	li	a0,1
f9000d98:	bfcff0ef          	jal	ra,f9000194 <mdio_read>
f9000d9c:	00050913          	mv	s2,a0
    *reg = val;
f9000da0:	f8101737          	lui	a4,0xf8101
f9000da4:	00200793          	li	a5,2
f9000da8:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
f9000dac:	000087b7          	lui	a5,0x8
f9000db0:	c2178793          	addi	a5,a5,-991 # 7c21 <__stack_size+0x3c21>
f9000db4:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000db8:	00000713          	li	a4,0
f9000dbc:	0080006f          	j	f9000dc4 <phy_init+0x888>
f9000dc0:	00170713          	addi	a4,a4,1
f9000dc4:	7cf00793          	li	a5,1999
f9000dc8:	02e7c263          	blt	a5,a4,f9000dec <phy_init+0x8b0>
    return *reg;
f9000dcc:	f81017b7          	lui	a5,0xf8101
f9000dd0:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000dd4:	0017f793          	andi	a5,a5,1
f9000dd8:	fe0784e3          	beqz	a5,f9000dc0 <phy_init+0x884>
            busy_seen = 1;
f9000ddc:	00100793          	li	a5,1
    if (!busy_seen)
f9000de0:	02078a63          	beqz	a5,f9000e14 <phy_init+0x8d8>
    for (int i = 0; i < 500000; i++) {
f9000de4:	00000713          	li	a4,0
f9000de8:	0100006f          	j	f9000df8 <phy_init+0x8bc>
    int busy_seen = 0;
f9000dec:	00000793          	li	a5,0
f9000df0:	ff1ff06f          	j	f9000de0 <phy_init+0x8a4>
    for (int i = 0; i < 500000; i++) {
f9000df4:	00170713          	addi	a4,a4,1
f9000df8:	0007a7b7          	lui	a5,0x7a
f9000dfc:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000e00:	00e7ca63          	blt	a5,a4,f9000e14 <phy_init+0x8d8>
    return *reg;
f9000e04:	f81017b7          	lui	a5,0xf8101
f9000e08:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb074>
        if (status & MDIO_STATUS_DONE)
f9000e0c:	0027f793          	andi	a5,a5,2
f9000e10:	fe0782e3          	beqz	a5,f9000df4 <phy_init+0x8b8>
    mdio_write(phy, 0x1F, 0x0000);

    print_s("BMSR="); print_hex16_s(bmsr);
f9000e14:	f9002537          	lui	a0,0xf9002
f9000e18:	c2c50513          	addi	a0,a0,-980 # f9001c2c <__freertos_irq_stack_top+0xffffbc9c>
f9000e1c:	ce8ff0ef          	jal	ra,f9000304 <print_s>
f9000e20:	00040513          	mv	a0,s0
f9000e24:	dd4ff0ef          	jal	ra,f90003f8 <print_hex16_s>
    print_s((bmsr & 0x0004) ? " LINK" : " noLINK");
f9000e28:	00447793          	andi	a5,s0,4
f9000e2c:	0a078c63          	beqz	a5,f9000ee4 <phy_init+0x9a8>
f9000e30:	f9002537          	lui	a0,0xf9002
f9000e34:	bb050513          	addi	a0,a0,-1104 # f9001bb0 <__freertos_irq_stack_top+0xffffbc20>
f9000e38:	cccff0ef          	jal	ra,f9000304 <print_s>
    print_s((bmsr & 0x0020) ? " AN_OK" : " no_AN");
f9000e3c:	02047413          	andi	s0,s0,32
f9000e40:	0a040863          	beqz	s0,f9000ef0 <phy_init+0x9b4>
f9000e44:	f9002537          	lui	a0,0xf9002
f9000e48:	bc050513          	addi	a0,a0,-1088 # f9001bc0 <__freertos_irq_stack_top+0xffffbc30>
f9000e4c:	cb8ff0ef          	jal	ra,f9000304 <print_s>
    println_s("");
f9000e50:	f9002537          	lui	a0,0xf9002
f9000e54:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9000e58:	d0cff0ef          	jal	ra,f9000364 <println_s>

    uint16_t spd = (physr >> 4) & 0x3;
f9000e5c:	00495413          	srli	s0,s2,0x4
f9000e60:	00347413          	andi	s0,s0,3
    print_s("PHYSR="); print_hex16_s(physr);
f9000e64:	f9002537          	lui	a0,0xf9002
f9000e68:	c3450513          	addi	a0,a0,-972 # f9001c34 <__freertos_irq_stack_top+0xffffbca4>
f9000e6c:	c98ff0ef          	jal	ra,f9000304 <print_s>
f9000e70:	00090513          	mv	a0,s2
f9000e74:	d84ff0ef          	jal	ra,f90003f8 <print_hex16_s>
    if      (spd == 2) print_s(" 1000M");
f9000e78:	00200793          	li	a5,2
f9000e7c:	08f40063          	beq	s0,a5,f9000efc <phy_init+0x9c0>
    else if (spd == 1) print_s(" 100M");
f9000e80:	00100793          	li	a5,1
f9000e84:	08f40463          	beq	s0,a5,f9000f0c <phy_init+0x9d0>
    else               print_s(" 10M");
f9000e88:	f9002537          	lui	a0,0xf9002
f9000e8c:	c4c50513          	addi	a0,a0,-948 # f9001c4c <__freertos_irq_stack_top+0xffffbcbc>
f9000e90:	c74ff0ef          	jal	ra,f9000304 <print_s>
    print_s((physr & 0x08) ? " FD" : " HD");
f9000e94:	00897913          	andi	s2,s2,8
f9000e98:	08090263          	beqz	s2,f9000f1c <phy_init+0x9e0>
f9000e9c:	f9002537          	lui	a0,0xf9002
f9000ea0:	bcc50513          	addi	a0,a0,-1076 # f9001bcc <__freertos_irq_stack_top+0xffffbc3c>
f9000ea4:	c60ff0ef          	jal	ra,f9000304 <print_s>
    println_s("");
f9000ea8:	f9002537          	lui	a0,0xf9002
f9000eac:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9000eb0:	cb4ff0ef          	jal	ra,f9000364 <println_s>

    if (linked && spd == 2)
f9000eb4:	00048663          	beqz	s1,f9000ec0 <phy_init+0x984>
f9000eb8:	00200793          	li	a5,2
f9000ebc:	06f40663          	beq	s0,a5,f9000f28 <phy_init+0x9ec>
        println_s("** 1G LINK OK **");
    else
        println_s("WARN: not 1G — check PHY CLKOUT (R47)");
f9000ec0:	f9002537          	lui	a0,0xf9002
f9000ec4:	c6850513          	addi	a0,a0,-920 # f9001c68 <__freertos_irq_stack_top+0xffffbcd8>
f9000ec8:	c9cff0ef          	jal	ra,f9000364 <println_s>
}
f9000ecc:	00c12083          	lw	ra,12(sp)
f9000ed0:	00812403          	lw	s0,8(sp)
f9000ed4:	00412483          	lw	s1,4(sp)
f9000ed8:	00012903          	lw	s2,0(sp)
f9000edc:	01010113          	addi	sp,sp,16
f9000ee0:	00008067          	ret
    print_s((bmsr & 0x0004) ? " LINK" : " noLINK");
f9000ee4:	f9002537          	lui	a0,0xf9002
f9000ee8:	ba850513          	addi	a0,a0,-1112 # f9001ba8 <__freertos_irq_stack_top+0xffffbc18>
f9000eec:	f4dff06f          	j	f9000e38 <phy_init+0x8fc>
    print_s((bmsr & 0x0020) ? " AN_OK" : " no_AN");
f9000ef0:	f9002537          	lui	a0,0xf9002
f9000ef4:	bb850513          	addi	a0,a0,-1096 # f9001bb8 <__freertos_irq_stack_top+0xffffbc28>
f9000ef8:	f55ff06f          	j	f9000e4c <phy_init+0x910>
    if      (spd == 2) print_s(" 1000M");
f9000efc:	f9002537          	lui	a0,0xf9002
f9000f00:	c3c50513          	addi	a0,a0,-964 # f9001c3c <__freertos_irq_stack_top+0xffffbcac>
f9000f04:	c00ff0ef          	jal	ra,f9000304 <print_s>
f9000f08:	f8dff06f          	j	f9000e94 <phy_init+0x958>
    else if (spd == 1) print_s(" 100M");
f9000f0c:	f9002537          	lui	a0,0xf9002
f9000f10:	c4450513          	addi	a0,a0,-956 # f9001c44 <__freertos_irq_stack_top+0xffffbcb4>
f9000f14:	bf0ff0ef          	jal	ra,f9000304 <print_s>
f9000f18:	f7dff06f          	j	f9000e94 <phy_init+0x958>
    print_s((physr & 0x08) ? " FD" : " HD");
f9000f1c:	f9002537          	lui	a0,0xf9002
f9000f20:	bc850513          	addi	a0,a0,-1080 # f9001bc8 <__freertos_irq_stack_top+0xffffbc38>
f9000f24:	f81ff06f          	j	f9000ea4 <phy_init+0x968>
        println_s("** 1G LINK OK **");
f9000f28:	f9002537          	lui	a0,0xf9002
f9000f2c:	c5450513          	addi	a0,a0,-940 # f9001c54 <__freertos_irq_stack_top+0xffffbcc4>
f9000f30:	c34ff0ef          	jal	ra,f9000364 <println_s>
f9000f34:	f99ff06f          	j	f9000ecc <phy_init+0x990>

f9000f38 <main>:

// =============================================================================
// Main
// =============================================================================
void main(void) {
f9000f38:	ff010113          	addi	sp,sp,-16
f9000f3c:	00112623          	sw	ra,12(sp)
f9000f40:	00812423          	sw	s0,8(sp)
f9000f44:	00912223          	sw	s1,4(sp)
f9000f48:	01212023          	sw	s2,0(sp)
    bsp_init();
f9000f4c:	a10ff0ef          	jal	ra,f900015c <bsp_init>
f9000f50:	f800d7b7          	lui	a5,0xf800d
f9000f54:	00300713          	li	a4,3
f9000f58:	00e7a423          	sw	a4,8(a5) # f800d008 <__freertos_irq_stack_top+0xff007078>
f9000f5c:	00200713          	li	a4,2
f9000f60:	00e7a223          	sw	a4,4(a5)

    // bit 0 = LED, bit 1 = CAM2_EN
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x3);
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);  // LED off, CAM2_EN HIGH

    for (int i = 0; i < 3; i++) led_pulse(200);
f9000f64:	00000413          	li	s0,0
f9000f68:	0100006f          	j	f9000f78 <main+0x40>
f9000f6c:	0c800513          	li	a0,200
f9000f70:	b00ff0ef          	jal	ra,f9000270 <led_pulse>
f9000f74:	00140413          	addi	s0,s0,1
f9000f78:	00200793          	li	a5,2
f9000f7c:	fe87d8e3          	bge	a5,s0,f9000f6c <main+0x34>

    println_s("=V=T120 INIT=V=");
f9000f80:	f9002537          	lui	a0,0xf9002
f9000f84:	c9050513          	addi	a0,a0,-880 # f9001c90 <__freertos_irq_stack_top+0xffffbd00>
f9000f88:	bdcff0ef          	jal	ra,f9000364 <println_s>

    // Camera power-on + init
    println_s("CAM2 power on...");
f9000f8c:	f9002537          	lui	a0,0xf9002
f9000f90:	ca050513          	addi	a0,a0,-864 # f9001ca0 <__freertos_irq_stack_top+0xffffbd10>
f9000f94:	bd0ff0ef          	jal	ra,f9000364 <println_s>
f9000f98:	f800d7b7          	lui	a5,0xf800d
f9000f9c:	00200713          	li	a4,2
f9000fa0:	00e7a223          	sw	a4,4(a5) # f800d004 <__freertos_irq_stack_top+0xff007074>
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x2);
    bsp_uDelay(100000);
f9000fa4:	f8b00637          	lui	a2,0xf8b00
f9000fa8:	02faf5b7          	lui	a1,0x2faf
f9000fac:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9000fb0:	00018537          	lui	a0,0x18
f9000fb4:	6a050513          	addi	a0,a0,1696 # 186a0 <__stack_size+0x146a0>
f9000fb8:	970ff0ef          	jal	ra,f9000128 <clint_uDelay>
    println_s("Camera init...");
f9000fbc:	f9002537          	lui	a0,0xf9002
f9000fc0:	cb450513          	addi	a0,a0,-844 # f9001cb4 <__freertos_irq_stack_top+0xffffbd24>
f9000fc4:	ba0ff0ef          	jal	ra,f9000364 <println_s>
    camera_init();
f9000fc8:	341000ef          	jal	ra,f9001b08 <camera_init>
    println_s("Camera init OK");
f9000fcc:	f9002537          	lui	a0,0xf9002
f9000fd0:	cc450513          	addi	a0,a0,-828 # f9001cc4 <__freertos_irq_stack_top+0xffffbd34>
f9000fd4:	b90ff0ef          	jal	ra,f9000364 <println_s>

    // PHY setup via MDIO
    phy_init();
f9000fd8:	d64ff0ef          	jal	ra,f900053c <phy_init>

    // Idle — video streams via blue_wire_video_bus (vid_clk / vid_d[7:0])
    println_s("Streaming via blue_wire_video_bus...");
f9000fdc:	f9002537          	lui	a0,0xf9002
f9000fe0:	cd450513          	addi	a0,a0,-812 # f9001cd4 <__freertos_irq_stack_top+0xffffbd44>
f9000fe4:	b80ff0ef          	jal	ra,f9000364 <println_s>

    int n = 0;
f9000fe8:	00000413          	li	s0,0
f9000fec:	0100006f          	j	f9000ffc <main+0xc4>
    while (1) {
        led_on();  bsp_uDelay(500000);
        led_off(); bsp_uDelay(500000);
        if ((++n % 20) == 0) println_s("Running...");
f9000ff0:	f9002537          	lui	a0,0xf9002
f9000ff4:	cfc50513          	addi	a0,a0,-772 # f9001cfc <__freertos_irq_stack_top+0xffffbd6c>
f9000ff8:	b6cff0ef          	jal	ra,f9000364 <println_s>
        led_on();  bsp_uDelay(500000);
f9000ffc:	a54ff0ef          	jal	ra,f9000250 <led_on>
f9001000:	f8b00637          	lui	a2,0xf8b00
f9001004:	02faf937          	lui	s2,0x2faf
f9001008:	08090593          	addi	a1,s2,128 # 2faf080 <__stack_size+0x2fab080>
f900100c:	0007a4b7          	lui	s1,0x7a
f9001010:	12048513          	addi	a0,s1,288 # 7a120 <__stack_size+0x76120>
f9001014:	914ff0ef          	jal	ra,f9000128 <clint_uDelay>
        led_off(); bsp_uDelay(500000);
f9001018:	a48ff0ef          	jal	ra,f9000260 <led_off>
f900101c:	f8b00637          	lui	a2,0xf8b00
f9001020:	08090593          	addi	a1,s2,128
f9001024:	12048513          	addi	a0,s1,288
f9001028:	900ff0ef          	jal	ra,f9000128 <clint_uDelay>
        if ((++n % 20) == 0) println_s("Running...");
f900102c:	00140413          	addi	s0,s0,1
f9001030:	01400793          	li	a5,20
f9001034:	02f467b3          	rem	a5,s0,a5
f9001038:	fc0792e3          	bnez	a5,f9000ffc <main+0xc4>
f900103c:	fb5ff06f          	j	f9000ff0 <main+0xb8>

f9001040 <trap>:
    }
}

void trap(void) {
f9001040:	ff010113          	addi	sp,sp,-16
f9001044:	00112623          	sw	ra,12(sp)
f9001048:	00812423          	sw	s0,8(sp)
f900104c:	00912223          	sw	s1,4(sp)
    while (1) { led_on(); bsp_uDelay(100000); led_off(); bsp_uDelay(100000); }
f9001050:	a00ff0ef          	jal	ra,f9000250 <led_on>
f9001054:	f8b00637          	lui	a2,0xf8b00
f9001058:	02faf4b7          	lui	s1,0x2faf
f900105c:	08048593          	addi	a1,s1,128 # 2faf080 <__stack_size+0x2fab080>
f9001060:	00018437          	lui	s0,0x18
f9001064:	6a040513          	addi	a0,s0,1696 # 186a0 <__stack_size+0x146a0>
f9001068:	8c0ff0ef          	jal	ra,f9000128 <clint_uDelay>
f900106c:	9f4ff0ef          	jal	ra,f9000260 <led_off>
f9001070:	f8b00637          	lui	a2,0xf8b00
f9001074:	08048593          	addi	a1,s1,128
f9001078:	6a040513          	addi	a0,s0,1696
f900107c:	8acff0ef          	jal	ra,f9000128 <clint_uDelay>
f9001080:	fd1ff06f          	j	f9001050 <trap+0x10>

f9001084 <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
f9001084:	000f47b7          	lui	a5,0xf4
f9001088:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf0240>
f900108c:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f9001090:	0000c7b7          	lui	a5,0xc
f9001094:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0x7ff8>
f9001098:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f900109c:	00062783          	lw	a5,0(a2) # f8b00000 <__freertos_irq_stack_top+0xffafa070>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90010a0:	02a58533          	mul	a0,a1,a0
f90010a4:	00f50533          	add	a0,a0,a5
f90010a8:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f90010ac:	40f507b3          	sub	a5,a0,a5
f90010b0:	fe07dce3          	bgez	a5,f90010a8 <clint_uDelay+0x24>
f90010b4:	00008067          	ret

f90010b8 <i2c_applyConfig>:
*
* @return       None.
*
******************************************************************************/
    static void i2c_applyConfig(u32 reg, I2c_Config *config){
        write_u32(config->samplingClockDivider, reg + I2C_SAMPLING_CLOCK_DIVIDER);
f90010b8:	0005a783          	lw	a5,0(a1)
        *((volatile u32*) address) = data;
f90010bc:	02f52423          	sw	a5,40(a0)
        write_u32(config->timeout, reg + I2C_TIMEOUT);
f90010c0:	0045a783          	lw	a5,4(a1)
f90010c4:	02f52623          	sw	a5,44(a0)
        write_u32(config->tsuDat, reg + I2C_TSUDAT);
f90010c8:	0085a783          	lw	a5,8(a1)
f90010cc:	02f52823          	sw	a5,48(a0)
        write_u32(config->tLow, reg + I2C_TLOW);
f90010d0:	00c5a783          	lw	a5,12(a1)
f90010d4:	04f52823          	sw	a5,80(a0)
        write_u32(config->tHigh, reg + I2C_THIGH);
f90010d8:	0105a783          	lw	a5,16(a1)
f90010dc:	04f52a23          	sw	a5,84(a0)
        write_u32(config->tBuf, reg + I2C_TBUF);
f90010e0:	0145a783          	lw	a5,20(a1)
f90010e4:	04f52c23          	sw	a5,88(a0)
    }
f90010e8:	00008067          	ret

f90010ec <uart_drain>:
#define PLL_OP_MPY_0            0x030D    // [7:0]

// =============================================================================
// UART Helper Functions (from test_1g_udp.c)
// =============================================================================
void uart_drain(void) {
f90010ec:	ff010113          	addi	sp,sp,-16
f90010f0:	00112623          	sw	ra,12(sp)
    return (uint8_t)(*status_reg & 0xFF);
f90010f4:	f81007b7          	lui	a5,0xf8100
f90010f8:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) { }
f90010fc:	0017f793          	andi	a5,a5,1
f9001100:	fe078ae3          	beqz	a5,f90010f4 <uart_drain+0x8>
    bsp_uDelay(2000);
f9001104:	f8b00637          	lui	a2,0xf8b00
f9001108:	02faf5b7          	lui	a1,0x2faf
f900110c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9001110:	7d000513          	li	a0,2000
f9001114:	f71ff0ef          	jal	ra,f9001084 <clint_uDelay>
}
f9001118:	00c12083          	lw	ra,12(sp)
f900111c:	01010113          	addi	sp,sp,16
f9001120:	00008067          	ret

f9001124 <print>:
    while (*str) {
f9001124:	00054703          	lbu	a4,0(a0)
f9001128:	04070c63          	beqz	a4,f9001180 <print+0x5c>

void print(const char *s) {
f900112c:	ff010113          	addi	sp,sp,-16
f9001130:	0100006f          	j	f9001140 <print+0x1c>
        str++;
f9001134:	00150513          	addi	a0,a0,1
    while (*str) {
f9001138:	00054703          	lbu	a4,0(a0)
f900113c:	02070e63          	beqz	a4,f9001178 <print+0x54>
    return (uint8_t)(*status_reg & 0xFF);
f9001140:	f81007b7          	lui	a5,0xf8100
f9001144:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001148:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900114c:	fe079ae3          	bnez	a5,f9001140 <print+0x1c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001150:	f81007b7          	lui	a5,0xf8100
f9001154:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f9001158:	000067b7          	lui	a5,0x6
f900115c:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9001160:	00f12623          	sw	a5,12(sp)
    while (count--) {
f9001164:	00c12783          	lw	a5,12(sp)
f9001168:	fff78713          	addi	a4,a5,-1
f900116c:	00e12623          	sw	a4,12(sp)
f9001170:	fc0782e3          	beqz	a5,f9001134 <print+0x10>
        asm volatile("");
f9001174:	ff1ff06f          	j	f9001164 <print+0x40>
    uart_mini_tx_string(s);
}
f9001178:	01010113          	addi	sp,sp,16
f900117c:	00008067          	ret
f9001180:	00008067          	ret

f9001184 <cam_i2c_txbyte_ack>:
}

/* cam_i2c_txbyte_ack - TX byte + listen for ACK, timeout-protected.
 * Mirrors TX_AND_CHECK macro: write byte, write NACK-slot to TX_ACK,
 * wait for TX_ACK VALID to clear (= 9-bit frame done), then read RX_ACK. */
static int cam_i2c_txbyte_ack(uint8_t byte) {
f9001184:	fe010113          	addi	sp,sp,-32
f9001188:	00112e23          	sw	ra,28(sp)
*
* @return      None.
*
******************************************************************************/
    static inline void i2c_txByte(u32 reg,u8 byte){
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f900118c:	000017b7          	lui	a5,0x1
f9001190:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
f9001194:	00f56533          	or	a0,a0,a5
f9001198:	f800a7b7          	lui	a5,0xf800a
f900119c:	00a7a023          	sw	a0,0(a5) # f800a000 <__freertos_irq_stack_top+0xff004070>
f90011a0:	30100713          	li	a4,769
f90011a4:	00e7a223          	sw	a4,4(a5)
    i2c_txByte(SYSTEM_I2C_0_IO_CTRL, byte);
    /* Write NACK to TX_ACK - this releases SDA for the ACK bit clock cycle */
    i2c_txNack(SYSTEM_I2C_0_IO_CTRL);
    /* Wait for TX_ACK VALID to clear = 9-bit slot (8 data + 1 ACK) complete */
    volatile uint32_t t = 1000000;
f90011a8:	000f47b7          	lui	a5,0xf4
f90011ac:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf0240>
f90011b0:	00f12623          	sw	a5,12(sp)
        return *((volatile u32*) address);
f90011b4:	f800a7b7          	lui	a5,0xf800a
f90011b8:	0047a783          	lw	a5,4(a5) # f800a004 <__freertos_irq_stack_top+0xff004074>
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_TX_ACK) & I2C_TX_VALID) {
f90011bc:	1007f793          	andi	a5,a5,256
f90011c0:	02078663          	beqz	a5,f90011ec <cam_i2c_txbyte_ack+0x68>
        if (--t == 0) { print("[TXACK_TO]"); uart_drain(); return -1; }
f90011c4:	00c12783          	lw	a5,12(sp)
f90011c8:	fff78793          	addi	a5,a5,-1
f90011cc:	00f12623          	sw	a5,12(sp)
f90011d0:	fe0792e3          	bnez	a5,f90011b4 <cam_i2c_txbyte_ack+0x30>
f90011d4:	f9002537          	lui	a0,0xf9002
f90011d8:	d1c50513          	addi	a0,a0,-740 # f9001d1c <__freertos_irq_stack_top+0xffffbd8c>
f90011dc:	f49ff0ef          	jal	ra,f9001124 <print>
f90011e0:	f0dff0ef          	jal	ra,f90010ec <uart_drain>
f90011e4:	fff00513          	li	a0,-1
f90011e8:	0180006f          	j	f9001200 <cam_i2c_txbyte_ack+0x7c>
f90011ec:	f800a7b7          	lui	a5,0xf800a
f90011f0:	00c7a783          	lw	a5,12(a5) # f800a00c <__freertos_irq_stack_top+0xff00407c>
    }
    /* RX_ACK bit: 0 = slave ACKed, 1 = slave NACKed */
    if (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_RX_ACK) & I2C_RX_VALUE) {
f90011f4:	0ff7f793          	andi	a5,a5,255
f90011f8:	00079a63          	bnez	a5,f900120c <cam_i2c_txbyte_ack+0x88>
        return -1;
    }
    return 0;
f90011fc:	00000513          	li	a0,0
}
f9001200:	01c12083          	lw	ra,28(sp)
f9001204:	02010113          	addi	sp,sp,32
f9001208:	00008067          	ret
        return -1;
f900120c:	fff00513          	li	a0,-1
f9001210:	ff1ff06f          	j	f9001200 <cam_i2c_txbyte_ack+0x7c>

f9001214 <cam_i2c_stop>:
static void cam_i2c_stop(void) {
f9001214:	fe010113          	addi	sp,sp,-32
f9001218:	00112e23          	sw	ra,28(sp)
        *((volatile u32*) address) = data;
f900121c:	f800a7b7          	lui	a5,0xf800a
f9001220:	42000713          	li	a4,1056
f9001224:	04e7a023          	sw	a4,64(a5) # f800a040 <__freertos_irq_stack_top+0xff0040b0>
    volatile uint32_t t = 2000000;
f9001228:	001e87b7          	lui	a5,0x1e8
f900122c:	48078793          	addi	a5,a5,1152 # 1e8480 <__stack_size+0x1e4480>
f9001230:	00f12623          	sw	a5,12(sp)
        return *((volatile u32*) address);
f9001234:	f800a7b7          	lui	a5,0xf800a
f9001238:	0407a783          	lw	a5,64(a5) # f800a040 <__freertos_irq_stack_top+0xff0040b0>
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS) & I2C_MASTER_BUSY) {
f900123c:	0017f793          	andi	a5,a5,1
f9001240:	02078263          	beqz	a5,f9001264 <cam_i2c_stop+0x50>
        if (--t == 0) { print("[STOP_TO]"); uart_drain(); return; }
f9001244:	00c12783          	lw	a5,12(sp)
f9001248:	fff78793          	addi	a5,a5,-1
f900124c:	00f12623          	sw	a5,12(sp)
f9001250:	fe0792e3          	bnez	a5,f9001234 <cam_i2c_stop+0x20>
f9001254:	f9002537          	lui	a0,0xf9002
f9001258:	d2850513          	addi	a0,a0,-728 # f9001d28 <__freertos_irq_stack_top+0xffffbd98>
f900125c:	ec9ff0ef          	jal	ra,f9001124 <print>
f9001260:	e8dff0ef          	jal	ra,f90010ec <uart_drain>
}
f9001264:	01c12083          	lw	ra,28(sp)
f9001268:	02010113          	addi	sp,sp,32
f900126c:	00008067          	ret

f9001270 <println>:
void println(const char *s) {
f9001270:	fe010113          	addi	sp,sp,-32
f9001274:	00112e23          	sw	ra,28(sp)
    print(s);
f9001278:	eadff0ef          	jal	ra,f9001124 <print>
    return (uint8_t)(*status_reg & 0xFF);
f900127c:	f81007b7          	lui	a5,0xf8100
f9001280:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001284:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9001288:	fe079ae3          	bnez	a5,f900127c <println+0xc>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f900128c:	f81007b7          	lui	a5,0xf8100
f9001290:	00d00713          	li	a4,13
f9001294:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f9001298:	000067b7          	lui	a5,0x6
f900129c:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f90012a0:	00f12423          	sw	a5,8(sp)
    while (count--) {
f90012a4:	00812783          	lw	a5,8(sp)
f90012a8:	fff78713          	addi	a4,a5,-1
f90012ac:	00e12423          	sw	a4,8(sp)
f90012b0:	00078463          	beqz	a5,f90012b8 <println+0x48>
        asm volatile("");
f90012b4:	ff1ff06f          	j	f90012a4 <println+0x34>
    return (uint8_t)(*status_reg & 0xFF);
f90012b8:	f81007b7          	lui	a5,0xf8100
f90012bc:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90012c0:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90012c4:	fe079ae3          	bnez	a5,f90012b8 <println+0x48>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90012c8:	f81007b7          	lui	a5,0xf8100
f90012cc:	00a00713          	li	a4,10
f90012d0:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f90012d4:	000067b7          	lui	a5,0x6
f90012d8:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f90012dc:	00f12623          	sw	a5,12(sp)
    while (count--) {
f90012e0:	00c12783          	lw	a5,12(sp)
f90012e4:	fff78713          	addi	a4,a5,-1
f90012e8:	00e12623          	sw	a4,12(sp)
f90012ec:	00078463          	beqz	a5,f90012f4 <println+0x84>
        asm volatile("");
f90012f0:	ff1ff06f          	j	f90012e0 <println+0x70>
    uart_drain();
f90012f4:	df9ff0ef          	jal	ra,f90010ec <uart_drain>
}
f90012f8:	01c12083          	lw	ra,28(sp)
f90012fc:	02010113          	addi	sp,sp,32
f9001300:	00008067          	ret

f9001304 <i2c_init_100khz>:
static void i2c_init_100khz(void) {
f9001304:	fd010113          	addi	sp,sp,-48
f9001308:	02112623          	sw	ra,44(sp)
    cfg.samplingClockDivider = 3;                                    // modest oversampling
f900130c:	00300793          	li	a5,3
f9001310:	00f12423          	sw	a5,8(sp)
    cfg.timeout              = (1000 * cycles_per_us) - 1;          // ~1 ms bus timeout
f9001314:	0000c7b7          	lui	a5,0xc
f9001318:	34f78793          	addi	a5,a5,847 # c34f <__stack_size+0x834f>
f900131c:	00f12623          	sw	a5,12(sp)
    cfg.tsuDat               = (tsu_dat_us * cycles_per_us) - 1;    // SDA setup
f9001320:	03100793          	li	a5,49
f9001324:	00f12823          	sw	a5,16(sp)
    cfg.tLow                 = (t_low_us  * cycles_per_us) - 1;     // SCL low
f9001328:	0f900793          	li	a5,249
f900132c:	00f12a23          	sw	a5,20(sp)
    cfg.tHigh                = (t_high_us * cycles_per_us) - 1;     // SCL high
f9001330:	00f12c23          	sw	a5,24(sp)
    cfg.tBuf                 = (t_buf_us  * cycles_per_us) - 1;     // STOP→START
f9001334:	00f12e23          	sw	a5,28(sp)
    i2c_applyConfig(SYSTEM_I2C_0_IO_CTRL, &cfg);
f9001338:	00810593          	addi	a1,sp,8
f900133c:	f800a537          	lui	a0,0xf800a
f9001340:	d79ff0ef          	jal	ra,f90010b8 <i2c_applyConfig>
    print("I2C 100kHz init OK"); println("");
f9001344:	f9002537          	lui	a0,0xf9002
f9001348:	d3450513          	addi	a0,a0,-716 # f9001d34 <__freertos_irq_stack_top+0xffffbda4>
f900134c:	dd9ff0ef          	jal	ra,f9001124 <print>
f9001350:	f9002537          	lui	a0,0xf9002
f9001354:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9001358:	f19ff0ef          	jal	ra,f9001270 <println>
}
f900135c:	02c12083          	lw	ra,44(sp)
f9001360:	03010113          	addi	sp,sp,48
f9001364:	00008067          	ret

f9001368 <print_hex8>:
void print_hex8(uint8_t val) {
f9001368:	ff010113          	addi	sp,sp,-16
    uart_mini_tx_byte(hex[(val >> 4) & 0xF]);
f900136c:	00455713          	srli	a4,a0,0x4
f9001370:	f90027b7          	lui	a5,0xf9002
f9001374:	d0878793          	addi	a5,a5,-760 # f9001d08 <__freertos_irq_stack_top+0xffffbd78>
f9001378:	00e787b3          	add	a5,a5,a4
f900137c:	0007c703          	lbu	a4,0(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9001380:	f81007b7          	lui	a5,0xf8100
f9001384:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001388:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900138c:	02079663          	bnez	a5,f90013b8 <print_hex8+0x50>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001390:	f81007b7          	lui	a5,0xf8100
f9001394:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f9001398:	000067b7          	lui	a5,0x6
f900139c:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f90013a0:	00f12623          	sw	a5,12(sp)
    while (count--) {
f90013a4:	00c12783          	lw	a5,12(sp)
f90013a8:	fff78713          	addi	a4,a5,-1
f90013ac:	00e12623          	sw	a4,12(sp)
f90013b0:	00078463          	beqz	a5,f90013b8 <print_hex8+0x50>
        asm volatile("");
f90013b4:	ff1ff06f          	j	f90013a4 <print_hex8+0x3c>
    uart_mini_tx_byte(hex[val & 0xF]);
f90013b8:	00f57793          	andi	a5,a0,15
f90013bc:	f9002537          	lui	a0,0xf9002
f90013c0:	d0850513          	addi	a0,a0,-760 # f9001d08 <__freertos_irq_stack_top+0xffffbd78>
f90013c4:	00f50533          	add	a0,a0,a5
f90013c8:	00054703          	lbu	a4,0(a0)
    return (uint8_t)(*status_reg & 0xFF);
f90013cc:	f81007b7          	lui	a5,0xf8100
f90013d0:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa074>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90013d4:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90013d8:	02079663          	bnez	a5,f9001404 <print_hex8+0x9c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90013dc:	f81007b7          	lui	a5,0xf8100
f90013e0:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa078>
    volatile uint32_t count = ms * 12500;
f90013e4:	000067b7          	lui	a5,0x6
f90013e8:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f90013ec:	00f12423          	sw	a5,8(sp)
    while (count--) {
f90013f0:	0040006f          	j	f90013f4 <print_hex8+0x8c>
f90013f4:	00812783          	lw	a5,8(sp)
f90013f8:	fff78713          	addi	a4,a5,-1
f90013fc:	00e12423          	sw	a4,8(sp)
f9001400:	fe079ae3          	bnez	a5,f90013f4 <print_hex8+0x8c>
}
f9001404:	01010113          	addi	sp,sp,16
f9001408:	00008067          	ret

f900140c <print_hex16>:
void print_hex16(uint16_t val) {
f900140c:	ff010113          	addi	sp,sp,-16
f9001410:	00112623          	sw	ra,12(sp)
f9001414:	00812423          	sw	s0,8(sp)
f9001418:	00050413          	mv	s0,a0
    print_hex8((val >> 8) & 0xFF);
f900141c:	00855513          	srli	a0,a0,0x8
f9001420:	f49ff0ef          	jal	ra,f9001368 <print_hex8>
    print_hex8(val & 0xFF);
f9001424:	0ff47513          	andi	a0,s0,255
f9001428:	f41ff0ef          	jal	ra,f9001368 <print_hex8>
}
f900142c:	00c12083          	lw	ra,12(sp)
f9001430:	00812403          	lw	s0,8(sp)
f9001434:	01010113          	addi	sp,sp,16
f9001438:	00008067          	ret

f900143c <print_hex32>:
void print_hex32(uint32_t val) {
f900143c:	ff010113          	addi	sp,sp,-16
f9001440:	00112623          	sw	ra,12(sp)
f9001444:	00812423          	sw	s0,8(sp)
f9001448:	00050413          	mv	s0,a0
    print_hex16((val >> 16) & 0xFFFF);
f900144c:	01055513          	srli	a0,a0,0x10
f9001450:	fbdff0ef          	jal	ra,f900140c <print_hex16>
    print_hex16(val & 0xFFFF);
f9001454:	01041513          	slli	a0,s0,0x10
f9001458:	01055513          	srli	a0,a0,0x10
f900145c:	fb1ff0ef          	jal	ra,f900140c <print_hex16>
}
f9001460:	00c12083          	lw	ra,12(sp)
f9001464:	00812403          	lw	s0,8(sp)
f9001468:	01010113          	addi	sp,sp,16
f900146c:	00008067          	ret

f9001470 <dbg_i2c_status>:
static void dbg_i2c_status(void) {
f9001470:	ff010113          	addi	sp,sp,-16
f9001474:	00112623          	sw	ra,12(sp)
f9001478:	00812423          	sw	s0,8(sp)
f900147c:	f800a7b7          	lui	a5,0xf800a
f9001480:	0407a403          	lw	s0,64(a5) # f800a040 <__freertos_irq_stack_top+0xff0040b0>
    print(" [MSTS=0x"); print_hex32(s); print("] ");
f9001484:	f9002537          	lui	a0,0xf9002
f9001488:	d4850513          	addi	a0,a0,-696 # f9001d48 <__freertos_irq_stack_top+0xffffbdb8>
f900148c:	c99ff0ef          	jal	ra,f9001124 <print>
f9001490:	00040513          	mv	a0,s0
f9001494:	fa9ff0ef          	jal	ra,f900143c <print_hex32>
f9001498:	f9002537          	lui	a0,0xf9002
f900149c:	d5450513          	addi	a0,a0,-684 # f9001d54 <__freertos_irq_stack_top+0xffffbdc4>
f90014a0:	c85ff0ef          	jal	ra,f9001124 <print>
    uart_drain();
f90014a4:	c49ff0ef          	jal	ra,f90010ec <uart_drain>
}
f90014a8:	00c12083          	lw	ra,12(sp)
f90014ac:	00812403          	lw	s0,8(sp)
f90014b0:	01010113          	addi	sp,sp,16
f90014b4:	00008067          	ret

f90014b8 <cam_i2c_start>:
static int cam_i2c_start(void) {
f90014b8:	fe010113          	addi	sp,sp,-32
f90014bc:	00112e23          	sw	ra,28(sp)
        *((volatile u32*) address) = data;
f90014c0:	f800a7b7          	lui	a5,0xf800a
f90014c4:	21000713          	li	a4,528
f90014c8:	04e7a023          	sw	a4,64(a5) # f800a040 <__freertos_irq_stack_top+0xff0040b0>
    volatile uint32_t t = 2000000;
f90014cc:	001e87b7          	lui	a5,0x1e8
f90014d0:	48078793          	addi	a5,a5,1152 # 1e8480 <__stack_size+0x1e4480>
f90014d4:	00f12623          	sw	a5,12(sp)
        return *((volatile u32*) address);
f90014d8:	f800a7b7          	lui	a5,0xf800a
f90014dc:	0407a783          	lw	a5,64(a5) # f800a040 <__freertos_irq_stack_top+0xff0040b0>
    while (read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_MASTER_STATUS) & I2C_MASTER_START) {
f90014e0:	0107f793          	andi	a5,a5,16
f90014e4:	02078663          	beqz	a5,f9001510 <cam_i2c_start+0x58>
        if (--t == 0) { print("[START_TO]"); dbg_i2c_status(); return -1; }
f90014e8:	00c12783          	lw	a5,12(sp)
f90014ec:	fff78793          	addi	a5,a5,-1
f90014f0:	00f12623          	sw	a5,12(sp)
f90014f4:	fe0792e3          	bnez	a5,f90014d8 <cam_i2c_start+0x20>
f90014f8:	f9002537          	lui	a0,0xf9002
f90014fc:	d5850513          	addi	a0,a0,-680 # f9001d58 <__freertos_irq_stack_top+0xffffbdc8>
f9001500:	c25ff0ef          	jal	ra,f9001124 <print>
f9001504:	f6dff0ef          	jal	ra,f9001470 <dbg_i2c_status>
f9001508:	fff00513          	li	a0,-1
f900150c:	0080006f          	j	f9001514 <cam_i2c_start+0x5c>
    return 0;
f9001510:	00000513          	li	a0,0
}
f9001514:	01c12083          	lw	ra,28(sp)
f9001518:	02010113          	addi	sp,sp,32
f900151c:	00008067          	ret

f9001520 <cam_write_reg8>:

/* cam_write_reg8 - Write 8-bit value to 16-bit IMX219 register.
 * Verbose: prints which step fails so you can correlate with analyzer. */
static int cam_write_reg8(uint16_t reg, uint8_t data) {
f9001520:	ff010113          	addi	sp,sp,-16
f9001524:	00112623          	sw	ra,12(sp)
f9001528:	00812423          	sw	s0,8(sp)
f900152c:	00912223          	sw	s1,4(sp)
f9001530:	00050413          	mv	s0,a0
f9001534:	00058493          	mv	s1,a1
    if (cam_i2c_start()) { print("[WR:START_FAIL]"); uart_drain(); return -1; }
f9001538:	f81ff0ef          	jal	ra,f90014b8 <cam_i2c_start>
f900153c:	06051463          	bnez	a0,f90015a4 <cam_write_reg8+0x84>
    if (cam_i2c_txbyte_ack(CAM_I2C_ADDR8 | I2C_WRITE)) {
f9001540:	02000513          	li	a0,32
f9001544:	c41ff0ef          	jal	ra,f9001184 <cam_i2c_txbyte_ack>
f9001548:	06051a63          	bnez	a0,f90015bc <cam_write_reg8+0x9c>
        print("[WR:ADDR_NACK addr=0x"); print_hex8(CAM_I2C_ADDR8); print("]");
        uart_drain(); goto fail;
    }
    if (cam_i2c_txbyte_ack((reg >> 8) & 0xFF)) {
f900154c:	00845513          	srli	a0,s0,0x8
f9001550:	c35ff0ef          	jal	ra,f9001184 <cam_i2c_txbyte_ack>
f9001554:	0a051663          	bnez	a0,f9001600 <cam_write_reg8+0xe0>
        print("[WR:REG_H_NACK]"); uart_drain(); goto fail;
    }
    if (cam_i2c_txbyte_ack(reg & 0xFF)) {
f9001558:	0ff47513          	andi	a0,s0,255
f900155c:	c29ff0ef          	jal	ra,f9001184 <cam_i2c_txbyte_ack>
f9001560:	0a051a63          	bnez	a0,f9001614 <cam_write_reg8+0xf4>
        print("[WR:REG_L_NACK]"); uart_drain(); goto fail;
    }
    if (cam_i2c_txbyte_ack(data)) {
f9001564:	00048513          	mv	a0,s1
f9001568:	c1dff0ef          	jal	ra,f9001184 <cam_i2c_txbyte_ack>
f900156c:	00050413          	mv	s0,a0
f9001570:	0a051c63          	bnez	a0,f9001628 <cam_write_reg8+0x108>
        print("[WR:DATA_NACK]"); uart_drain(); goto fail;
    }
    cam_i2c_stop();
f9001574:	ca1ff0ef          	jal	ra,f9001214 <cam_i2c_stop>
    bsp_uDelay(500);
f9001578:	f8b00637          	lui	a2,0xf8b00
f900157c:	02faf5b7          	lui	a1,0x2faf
f9001580:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9001584:	1f400513          	li	a0,500
f9001588:	afdff0ef          	jal	ra,f9001084 <clint_uDelay>
    return 0;
fail:
    cam_i2c_stop();
    bsp_uDelay(500);
    return -1;
}
f900158c:	00040513          	mv	a0,s0
f9001590:	00c12083          	lw	ra,12(sp)
f9001594:	00812403          	lw	s0,8(sp)
f9001598:	00412483          	lw	s1,4(sp)
f900159c:	01010113          	addi	sp,sp,16
f90015a0:	00008067          	ret
    if (cam_i2c_start()) { print("[WR:START_FAIL]"); uart_drain(); return -1; }
f90015a4:	f9002537          	lui	a0,0xf9002
f90015a8:	d6450513          	addi	a0,a0,-668 # f9001d64 <__freertos_irq_stack_top+0xffffbdd4>
f90015ac:	b79ff0ef          	jal	ra,f9001124 <print>
f90015b0:	b3dff0ef          	jal	ra,f90010ec <uart_drain>
f90015b4:	fff00413          	li	s0,-1
f90015b8:	fd5ff06f          	j	f900158c <cam_write_reg8+0x6c>
        print("[WR:ADDR_NACK addr=0x"); print_hex8(CAM_I2C_ADDR8); print("]");
f90015bc:	f9002537          	lui	a0,0xf9002
f90015c0:	d7450513          	addi	a0,a0,-652 # f9001d74 <__freertos_irq_stack_top+0xffffbde4>
f90015c4:	b61ff0ef          	jal	ra,f9001124 <print>
f90015c8:	02000513          	li	a0,32
f90015cc:	d9dff0ef          	jal	ra,f9001368 <print_hex8>
f90015d0:	f9002537          	lui	a0,0xf9002
f90015d4:	d3050513          	addi	a0,a0,-720 # f9001d30 <__freertos_irq_stack_top+0xffffbda0>
f90015d8:	b4dff0ef          	jal	ra,f9001124 <print>
        uart_drain(); goto fail;
f90015dc:	b11ff0ef          	jal	ra,f90010ec <uart_drain>
    cam_i2c_stop();
f90015e0:	c35ff0ef          	jal	ra,f9001214 <cam_i2c_stop>
    bsp_uDelay(500);
f90015e4:	f8b00637          	lui	a2,0xf8b00
f90015e8:	02faf5b7          	lui	a1,0x2faf
f90015ec:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f90015f0:	1f400513          	li	a0,500
f90015f4:	a91ff0ef          	jal	ra,f9001084 <clint_uDelay>
    return -1;
f90015f8:	fff00413          	li	s0,-1
f90015fc:	f91ff06f          	j	f900158c <cam_write_reg8+0x6c>
        print("[WR:REG_H_NACK]"); uart_drain(); goto fail;
f9001600:	f9002537          	lui	a0,0xf9002
f9001604:	d8c50513          	addi	a0,a0,-628 # f9001d8c <__freertos_irq_stack_top+0xffffbdfc>
f9001608:	b1dff0ef          	jal	ra,f9001124 <print>
f900160c:	ae1ff0ef          	jal	ra,f90010ec <uart_drain>
f9001610:	fd1ff06f          	j	f90015e0 <cam_write_reg8+0xc0>
        print("[WR:REG_L_NACK]"); uart_drain(); goto fail;
f9001614:	f9002537          	lui	a0,0xf9002
f9001618:	d9c50513          	addi	a0,a0,-612 # f9001d9c <__freertos_irq_stack_top+0xffffbe0c>
f900161c:	b09ff0ef          	jal	ra,f9001124 <print>
f9001620:	acdff0ef          	jal	ra,f90010ec <uart_drain>
f9001624:	fbdff06f          	j	f90015e0 <cam_write_reg8+0xc0>
        print("[WR:DATA_NACK]"); uart_drain(); goto fail;
f9001628:	f9002537          	lui	a0,0xf9002
f900162c:	dac50513          	addi	a0,a0,-596 # f9001dac <__freertos_irq_stack_top+0xffffbe1c>
f9001630:	af5ff0ef          	jal	ra,f9001124 <print>
f9001634:	ab9ff0ef          	jal	ra,f90010ec <uart_drain>
f9001638:	fa9ff06f          	j	f90015e0 <cam_write_reg8+0xc0>

f900163c <imx219_access_seq>:
/**
 * imx219_access_seq - Required access sequence before register writes
 * 
 * Some IMX219 internal states require this specific sequence
 */
static void imx219_access_seq(void) {
f900163c:	ff010113          	addi	sp,sp,-16
f9001640:	00112623          	sw	ra,12(sp)
f9001644:	00812423          	sw	s0,8(sp)
f9001648:	00912223          	sw	s1,4(sp)
    print("  Access seq..."); uart_drain();
f900164c:	f9002537          	lui	a0,0xf9002
f9001650:	dbc50513          	addi	a0,a0,-580 # f9001dbc <__freertos_irq_stack_top+0xffffbe2c>
f9001654:	ad1ff0ef          	jal	ra,f9001124 <print>
f9001658:	a95ff0ef          	jal	ra,f90010ec <uart_drain>
    
    int e = 0;
    e |= cam_write_reg8(0x30EB, 0x05);
f900165c:	00500593          	li	a1,5
f9001660:	000034b7          	lui	s1,0x3
f9001664:	0eb48513          	addi	a0,s1,235 # 30eb <CUSTOM2+0x3090>
f9001668:	eb9ff0ef          	jal	ra,f9001520 <cam_write_reg8>
f900166c:	00050413          	mv	s0,a0
    e |= cam_write_reg8(0x30EB, 0x0C);
f9001670:	00c00593          	li	a1,12
f9001674:	0eb48513          	addi	a0,s1,235
f9001678:	ea9ff0ef          	jal	ra,f9001520 <cam_write_reg8>
f900167c:	00a46433          	or	s0,s0,a0
    e |= cam_write_reg8(0x300A, 0xFF);
f9001680:	0ff00593          	li	a1,255
f9001684:	00a48513          	addi	a0,s1,10
f9001688:	e99ff0ef          	jal	ra,f9001520 <cam_write_reg8>
f900168c:	00a46433          	or	s0,s0,a0
    e |= cam_write_reg8(0x300B, 0xFF);
f9001690:	0ff00593          	li	a1,255
f9001694:	00b48513          	addi	a0,s1,11
f9001698:	e89ff0ef          	jal	ra,f9001520 <cam_write_reg8>
f900169c:	00a46433          	or	s0,s0,a0
    e |= cam_write_reg8(0x30EB, 0x05);
f90016a0:	00500593          	li	a1,5
f90016a4:	0eb48513          	addi	a0,s1,235
f90016a8:	e79ff0ef          	jal	ra,f9001520 <cam_write_reg8>
f90016ac:	00a46433          	or	s0,s0,a0
    e |= cam_write_reg8(0x30EB, 0x09);
f90016b0:	00900593          	li	a1,9
f90016b4:	0eb48513          	addi	a0,s1,235
f90016b8:	e69ff0ef          	jal	ra,f9001520 <cam_write_reg8>
f90016bc:	00a46533          	or	a0,s0,a0
    
    if (e) println("NACK!");
f90016c0:	02050263          	beqz	a0,f90016e4 <imx219_access_seq+0xa8>
f90016c4:	f9002537          	lui	a0,0xf9002
f90016c8:	dcc50513          	addi	a0,a0,-564 # f9001dcc <__freertos_irq_stack_top+0xffffbe3c>
f90016cc:	ba5ff0ef          	jal	ra,f9001270 <println>
    else   println("OK");
}
f90016d0:	00c12083          	lw	ra,12(sp)
f90016d4:	00812403          	lw	s0,8(sp)
f90016d8:	00412483          	lw	s1,4(sp)
f90016dc:	01010113          	addi	sp,sp,16
f90016e0:	00008067          	ret
    else   println("OK");
f90016e4:	f9002537          	lui	a0,0xf9002
f90016e8:	cd050513          	addi	a0,a0,-816 # f9001cd0 <__freertos_irq_stack_top+0xffffbd40>
f90016ec:	b85ff0ef          	jal	ra,f9001270 <println>
}
f90016f0:	fe1ff06f          	j	f90016d0 <imx219_access_seq+0x94>

f90016f4 <imx219_init_96x96_raw8>:
 *   - PLL registers now programmed (required for MIPI clock generation)
 *   - CSI_DATA_FORMAT_A set to RAW8 (0x08/0x08)
 *   - Binning, X/Y ODD INC, gain registers added
 *   - mode_select=0x01 remains last command
 */
static void imx219_init_96x96_raw8(void) {
f90016f4:	ff010113          	addi	sp,sp,-16
f90016f8:	00112623          	sw	ra,12(sp)
f90016fc:	00812423          	sw	s0,8(sp)
    println("=**= CAM2 IMX219 INIT =**=");
f9001700:	f9002537          	lui	a0,0xf9002
f9001704:	dd450513          	addi	a0,a0,-556 # f9001dd4 <__freertos_irq_stack_top+0xffffbe44>
f9001708:	b69ff0ef          	jal	ra,f9001270 <println>

    // Dump raw I2C peripheral state before first transaction
    print("  I2C raw status:"); dbg_i2c_status();
f900170c:	f9002537          	lui	a0,0xf9002
f9001710:	df050513          	addi	a0,a0,-528 # f9001df0 <__freertos_irq_stack_top+0xffffbe60>
f9001714:	a11ff0ef          	jal	ra,f9001124 <print>
f9001718:	d59ff0ef          	jal	ra,f9001470 <dbg_i2c_status>
    print("  SCL_read="); print_hex8(read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_SLAVE_STATUS) & 0x4 ? 1 : 0);
f900171c:	f9002537          	lui	a0,0xf9002
f9001720:	e0450513          	addi	a0,a0,-508 # f9001e04 <__freertos_irq_stack_top+0xffffbe74>
f9001724:	a01ff0ef          	jal	ra,f9001124 <print>
f9001728:	f800a437          	lui	s0,0xf800a
f900172c:	04442503          	lw	a0,68(s0) # f800a044 <__freertos_irq_stack_top+0xff0040b4>
f9001730:	00457513          	andi	a0,a0,4
f9001734:	00a03533          	snez	a0,a0
f9001738:	c31ff0ef          	jal	ra,f9001368 <print_hex8>
    print("  SDA_read="); print_hex8(read_u32(SYSTEM_I2C_0_IO_CTRL + I2C_SLAVE_STATUS) & 0x2 ? 1 : 0);
f900173c:	f9002537          	lui	a0,0xf9002
f9001740:	e1050513          	addi	a0,a0,-496 # f9001e10 <__freertos_irq_stack_top+0xffffbe80>
f9001744:	9e1ff0ef          	jal	ra,f9001124 <print>
f9001748:	04442503          	lw	a0,68(s0)
f900174c:	00257513          	andi	a0,a0,2
f9001750:	00a03533          	snez	a0,a0
f9001754:	c15ff0ef          	jal	ra,f9001368 <print_hex8>
    println("");
f9001758:	f9002537          	lui	a0,0xf9002
f900175c:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9001760:	b11ff0ef          	jal	ra,f9001270 <println>

    // Stop streaming (standby mode) - must be first
    print("  Stop stream..."); uart_drain();
f9001764:	f9002537          	lui	a0,0xf9002
f9001768:	e1c50513          	addi	a0,a0,-484 # f9001e1c <__freertos_irq_stack_top+0xffffbe8c>
f900176c:	9b9ff0ef          	jal	ra,f9001124 <print>
f9001770:	97dff0ef          	jal	ra,f90010ec <uart_drain>
    if (cam_write_reg8(mode_select, 0x00)) {
f9001774:	00000593          	li	a1,0
f9001778:	10000513          	li	a0,256
f900177c:	da5ff0ef          	jal	ra,f9001520 <cam_write_reg8>
f9001780:	34051863          	bnez	a0,f9001ad0 <imx219_init_96x96_raw8+0x3dc>
        println(" FAIL");
        print("  Final I2C status:"); dbg_i2c_status(); println("");
        println("  Camera not responding - check power/XCLK/pullups");
        return;
    }
    println(" OK");
f9001784:	f9002537          	lui	a0,0xf9002
f9001788:	e8050513          	addi	a0,a0,-384 # f9001e80 <__freertos_irq_stack_top+0xffffbef0>
f900178c:	ae5ff0ef          	jal	ra,f9001270 <println>

    // Required access sequence (manufacturer unlock)
    imx219_access_seq();
f9001790:	eadff0ef          	jal	ra,f900163c <imx219_access_seq>

    // MIPI CSI-2: 2 lanes, DPHY auto, 24 MHz input clock
    // Disable embedded data lines (metadata before pixel data) - prevents INVALID_DATA_TYPE (bit 13)
    print("  MIPI config..."); uart_drain();
f9001794:	f9002537          	lui	a0,0xf9002
f9001798:	e8450513          	addi	a0,a0,-380 # f9001e84 <__freertos_irq_stack_top+0xffffbef4>
f900179c:	989ff0ef          	jal	ra,f9001124 <print>
f90017a0:	94dff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(CSI_LANE_MODE,    0x01);
f90017a4:	00100593          	li	a1,1
f90017a8:	11400513          	li	a0,276
f90017ac:	d75ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(DPHY_CTRL,        0x00);
f90017b0:	00000593          	li	a1,0
f90017b4:	12800513          	li	a0,296
f90017b8:	d69ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(EMBEDDED_DATA_EN, 0x00);  // 0x00=disable metadata lines => clears bit-13 error
f90017bc:	00000593          	li	a1,0
f90017c0:	12e00513          	li	a0,302
f90017c4:	d5dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(EXCK_FREQ_1,      0x18);  // 24 MHz
f90017c8:	01800593          	li	a1,24
f90017cc:	12a00513          	li	a0,298
f90017d0:	d51ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(EXCK_FREQ_0,      0x00);
f90017d4:	00000593          	li	a1,0
f90017d8:	12b00513          	li	a0,299
f90017dc:	d45ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f90017e0:	f9002437          	lui	s0,0xf9002
f90017e4:	cd040513          	addi	a0,s0,-816 # f9001cd0 <__freertos_irq_stack_top+0xffffbd40>
f90017e8:	a89ff0ef          	jal	ra,f9001270 <println>

    // Frame and line timing
    print("  Frame timing..."); uart_drain();
f90017ec:	f9002537          	lui	a0,0xf9002
f90017f0:	e9850513          	addi	a0,a0,-360 # f9001e98 <__freertos_irq_stack_top+0xffffbf08>
f90017f4:	931ff0ef          	jal	ra,f9001124 <print>
f90017f8:	8f5ff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(FRM_LENGTH_A_1,  0x06);
f90017fc:	00600593          	li	a1,6
f9001800:	16000513          	li	a0,352
f9001804:	d1dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(FRM_LENGTH_A_0,  0xE3);
f9001808:	0e300593          	li	a1,227
f900180c:	16100513          	li	a0,353
f9001810:	d11ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(LINE_LENGTH_A_1, 0x0D);
f9001814:	00d00593          	li	a1,13
f9001818:	16200513          	li	a0,354
f900181c:	d05ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(LINE_LENGTH_A_0, 0x78);
f9001820:	07800593          	li	a1,120
f9001824:	16300513          	li	a0,355
f9001828:	cf9ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f900182c:	cd040513          	addi	a0,s0,-816
f9001830:	a41ff0ef          	jal	ra,f9001270 <println>
    //   X: centre=1640, start=1640-112=1528 (0x05F8), end=1528+223=1751 (0x06D7)
    //   Y: centre=1232, start=1232-112=1120 (0x0460), end=1120+223=1343 (0x053F)
    // NOTE: X_ADD_END must equal X_ADD_START + output_width - 1 (no decimation).
    //       Old config had X_ADD_END=3279 (whole sensor) which caused word-count
    //       mismatch and the repeated-pixel glitch at column 86-90.
    print("  ROI 224x224 centered..."); uart_drain();
f9001834:	f9002537          	lui	a0,0xf9002
f9001838:	eac50513          	addi	a0,a0,-340 # f9001eac <__freertos_irq_stack_top+0xffffbf1c>
f900183c:	8e9ff0ef          	jal	ra,f9001124 <print>
f9001840:	8adff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(X_ADD_STA_A_1, 0x05);    // XStart=1528 = 0x05F8
f9001844:	00500593          	li	a1,5
f9001848:	16400513          	li	a0,356
f900184c:	cd5ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(X_ADD_STA_A_0, 0xF8);
f9001850:	0f800593          	li	a1,248
f9001854:	16500513          	li	a0,357
f9001858:	cc9ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(X_ADD_END_A_1, 0x06);    // XEnd=1751  = 0x06D7
f900185c:	00600593          	li	a1,6
f9001860:	16600513          	li	a0,358
f9001864:	cbdff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(X_ADD_END_A_0, 0xD7);
f9001868:	0d700593          	li	a1,215
f900186c:	16700513          	li	a0,359
f9001870:	cb1ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(Y_ADD_STA_A_1, 0x04);    // YStart=1120 = 0x0460
f9001874:	00400593          	li	a1,4
f9001878:	16800513          	li	a0,360
f900187c:	ca5ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(Y_ADD_STA_A_0, 0x60);
f9001880:	06000593          	li	a1,96
f9001884:	16900513          	li	a0,361
f9001888:	c99ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(Y_ADD_END_A_1, 0x05);    // YEnd=1343  = 0x053F
f900188c:	00500593          	li	a1,5
f9001890:	16a00513          	li	a0,362
f9001894:	c8dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(Y_ADD_END_A_0, 0x3F);
f9001898:	03f00593          	li	a1,63
f900189c:	16b00513          	li	a0,363
f90018a0:	c81ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    // Output size: 224 x 224 = 0x00E0
    cam_write_reg8(x_output_size_A_1, 0x00);
f90018a4:	00000593          	li	a1,0
f90018a8:	16c00513          	li	a0,364
f90018ac:	c75ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(x_output_size_A_0, 0xE0);   // 224 = 0x00E0
f90018b0:	0e000593          	li	a1,224
f90018b4:	16d00513          	li	a0,365
f90018b8:	c69ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(y_output_size_A_1, 0x00);
f90018bc:	00000593          	li	a1,0
f90018c0:	16e00513          	li	a0,366
f90018c4:	c5dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(y_output_size_A_0, 0xE0);   // 224 = 0x00E0
f90018c8:	0e000593          	li	a1,224
f90018cc:	16f00513          	li	a0,367
f90018d0:	c51ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f90018d4:	cd040513          	addi	a0,s0,-816
f90018d8:	999ff0ef          	jal	ra,f9001270 <println>

    // Pixel increment and binning (no binning = 1:1)
    print("  Binning/inc..."); uart_drain();
f90018dc:	f9002537          	lui	a0,0xf9002
f90018e0:	ec850513          	addi	a0,a0,-312 # f9001ec8 <__freertos_irq_stack_top+0xffffbf38>
f90018e4:	841ff0ef          	jal	ra,f9001124 <print>
f90018e8:	805ff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(X_ODD_INC_A,      0x01);
f90018ec:	00100593          	li	a1,1
f90018f0:	17000513          	li	a0,368
f90018f4:	c2dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(Y_ODD_INC_A,      0x01);
f90018f8:	00100593          	li	a1,1
f90018fc:	17100513          	li	a0,369
f9001900:	c21ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(BINNING_MODE_H_A, 0x00);    // no binning
f9001904:	00000593          	li	a1,0
f9001908:	17400513          	li	a0,372
f900190c:	c15ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(BINNING_MODE_V_A, 0x00);
f9001910:	00000593          	li	a1,0
f9001914:	17500513          	li	a0,373
f9001918:	c09ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f900191c:	cd040513          	addi	a0,s0,-816
f9001920:	951ff0ef          	jal	ra,f9001270 <println>

    // CSI data format: RAW8 (0x08 / 0x08)
    print("  CSI fmt RAW8..."); uart_drain();
f9001924:	f9002537          	lui	a0,0xf9002
f9001928:	edc50513          	addi	a0,a0,-292 # f9001edc <__freertos_irq_stack_top+0xffffbf4c>
f900192c:	ff8ff0ef          	jal	ra,f9001124 <print>
f9001930:	fbcff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(CSI_DATA_FORMAT_A_1, 0x08);
f9001934:	00800593          	li	a1,8
f9001938:	18c00513          	li	a0,396
f900193c:	be5ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(CSI_DATA_FORMAT_A_0, 0x08);
f9001940:	00800593          	li	a1,8
f9001944:	18d00513          	li	a0,397
f9001948:	bd9ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f900194c:	cd040513          	addi	a0,s0,-816
f9001950:	921ff0ef          	jal	ra,f9001270 <println>
  //  cam_write_reg8(CSI_DATA_FORMAT_A_1, 0x0A);
  //  cam_write_reg8(CSI_DATA_FORMAT_A_0, 0x0A);
  //  println("OK");

    // PLL configuration (from working Ti60 reference, 24 MHz XCLK -> MIPI clock)
    print("  PLL..."); uart_drain();
f9001954:	f9002537          	lui	a0,0xf9002
f9001958:	ef050513          	addi	a0,a0,-272 # f9001ef0 <__freertos_irq_stack_top+0xffffbf60>
f900195c:	fc8ff0ef          	jal	ra,f9001124 <print>
f9001960:	f8cff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(VTPXCK_DIV,      0x04);//original 0x05
f9001964:	00400593          	li	a1,4
f9001968:	30100513          	li	a0,769
f900196c:	bb5ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(VTSYCK_DIV,      0x01);//0x01 origally
f9001970:	00100593          	li	a1,1
f9001974:	30300513          	li	a0,771
f9001978:	ba9ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(PREPLLCK_VT_DIV, 0x03);
f900197c:	00300593          	li	a1,3
f9001980:	30400513          	li	a0,772
f9001984:	b9dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(PREPLLCK_OP_DIV, 0x03);
f9001988:	00300593          	li	a1,3
f900198c:	30500513          	li	a0,773
f9001990:	b91ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(PLL_VT_MPY_1,    0x00);
f9001994:	00000593          	li	a1,0
f9001998:	30600513          	li	a0,774
f900199c:	b85ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(PLL_VT_MPY_0,    0x39);//Original 0x39
f90019a0:	03900593          	li	a1,57
f90019a4:	30700513          	li	a0,775
f90019a8:	b79ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(OPPXCK_DIV,      0x0A);
f90019ac:	00a00593          	li	a1,10
f90019b0:	30900513          	li	a0,777
f90019b4:	b6dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(OPSYCK_DIV,      0x01);
f90019b8:	00100593          	li	a1,1
f90019bc:	30b00513          	li	a0,779
f90019c0:	b61ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(PLL_OP_MPY_1,    0x00);
f90019c4:	00000593          	li	a1,0
f90019c8:	30c00513          	li	a0,780
f90019cc:	b55ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(PLL_OP_MPY_0,    0x72);//Original 0x72 (0x73,0x72, 0x62 tested OK)
f90019d0:	07200593          	li	a1,114
f90019d4:	30d00513          	li	a0,781
f90019d8:	b49ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f90019dc:	cd040513          	addi	a0,s0,-816
f90019e0:	891ff0ef          	jal	ra,f9001270 <println>

    // Exposure and gain
    print("  Exposure/gain..."); uart_drain();
f90019e4:	f9002537          	lui	a0,0xf9002
f90019e8:	efc50513          	addi	a0,a0,-260 # f9001efc <__freertos_irq_stack_top+0xffffbf6c>
f90019ec:	f38ff0ef          	jal	ra,f9001124 <print>
f90019f0:	efcff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_1, 0x04);
f90019f4:	00400593          	li	a1,4
f90019f8:	15a00513          	li	a0,346
f90019fc:	b25ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_0, 0x54);
f9001a00:	05400593          	li	a1,84
f9001a04:	15b00513          	li	a0,347
f9001a08:	b19ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(ANA_GAIN_GLOBAL_A,           0xB9);
f9001a0c:	0b900593          	li	a1,185
f9001a10:	15700513          	li	a0,343
f9001a14:	b0dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(DIG_GAIN_GLOBAL_A_1,         0x02);
f9001a18:	00200593          	li	a1,2
f9001a1c:	15800513          	li	a0,344
f9001a20:	b01ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(DIG_GAIN_GLOBAL_A_0,         0x00);
f9001a24:	00000593          	li	a1,0
f9001a28:	15900513          	li	a0,345
f9001a2c:	af5ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f9001a30:	cd040513          	addi	a0,s0,-816
f9001a34:	83dff0ef          	jal	ra,f9001270 <println>

    // Image orientation (normal)
    cam_write_reg8(IMG_ORIENTATION_A, 0x00);
f9001a38:	00000593          	li	a1,0
f9001a3c:	17200513          	li	a0,370
f9001a40:	ae1ff0ef          	jal	ra,f9001520 <cam_write_reg8>

    // Start streaming - MUST happen before test pattern config per datasheet
    // "The prescribed output is obtained by setting the necessary registers while the sensor is operating"
    print("  Start stream..."); uart_drain();
f9001a44:	f9002537          	lui	a0,0xf9002
f9001a48:	f1050513          	addi	a0,a0,-240 # f9001f10 <__freertos_irq_stack_top+0xffffbf80>
f9001a4c:	ed8ff0ef          	jal	ra,f9001124 <print>
f9001a50:	e9cff0ef          	jal	ra,f90010ec <uart_drain>
    bsp_uDelay(10000);  // 10 ms settle before streaming
f9001a54:	f8b00637          	lui	a2,0xf8b00
f9001a58:	02faf5b7          	lui	a1,0x2faf
f9001a5c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9001a60:	00002537          	lui	a0,0x2
f9001a64:	71050513          	addi	a0,a0,1808 # 2710 <CUSTOM2+0x26b5>
f9001a68:	e1cff0ef          	jal	ra,f9001084 <clint_uDelay>
    cam_write_reg8(mode_select, 0x01);
f9001a6c:	00100593          	li	a1,1
f9001a70:	10000513          	li	a0,256
f9001a74:	aadff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("OK");
f9001a78:	cd040513          	addi	a0,s0,-816
f9001a7c:	ff4ff0ef          	jal	ra,f9001270 <println>
    uint8_t tp_mode_0_read = cam_read_reg8(TP_MODE_0);
    print("TP_MODE=0x"); print_hex8(tp_mode_1_read); print_hex8(tp_mode_0_read);
    println(" (expect 0x0002)");
#else
    // No test pattern (live sensor image)
    print("  Test pattern OFF"); uart_drain();
f9001a80:	f9002537          	lui	a0,0xf9002
f9001a84:	f2450513          	addi	a0,a0,-220 # f9001f24 <__freertos_irq_stack_top+0xffffbf94>
f9001a88:	e9cff0ef          	jal	ra,f9001124 <print>
f9001a8c:	e60ff0ef          	jal	ra,f90010ec <uart_drain>
    cam_write_reg8(TP_MODE_1, 0x00);
f9001a90:	00000593          	li	a1,0
f9001a94:	60000513          	li	a0,1536
f9001a98:	a89ff0ef          	jal	ra,f9001520 <cam_write_reg8>
    cam_write_reg8(TP_MODE_0, 0x00);    // 0x0000 = off
f9001a9c:	00000593          	li	a1,0
f9001aa0:	60100513          	li	a0,1537
f9001aa4:	a7dff0ef          	jal	ra,f9001520 <cam_write_reg8>
    println("");
f9001aa8:	f9002537          	lui	a0,0xf9002
f9001aac:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9001ab0:	fc0ff0ef          	jal	ra,f9001270 <println>
#endif

    println("=CAM2 READY=");
f9001ab4:	f9002537          	lui	a0,0xf9002
f9001ab8:	f3850513          	addi	a0,a0,-200 # f9001f38 <__freertos_irq_stack_top+0xffffbfa8>
f9001abc:	fb4ff0ef          	jal	ra,f9001270 <println>
}
f9001ac0:	00c12083          	lw	ra,12(sp)
f9001ac4:	00812403          	lw	s0,8(sp)
f9001ac8:	01010113          	addi	sp,sp,16
f9001acc:	00008067          	ret
        println(" FAIL");
f9001ad0:	f9002537          	lui	a0,0xf9002
f9001ad4:	e3050513          	addi	a0,a0,-464 # f9001e30 <__freertos_irq_stack_top+0xffffbea0>
f9001ad8:	f98ff0ef          	jal	ra,f9001270 <println>
        print("  Final I2C status:"); dbg_i2c_status(); println("");
f9001adc:	f9002537          	lui	a0,0xf9002
f9001ae0:	e3850513          	addi	a0,a0,-456 # f9001e38 <__freertos_irq_stack_top+0xffffbea8>
f9001ae4:	e40ff0ef          	jal	ra,f9001124 <print>
f9001ae8:	989ff0ef          	jal	ra,f9001470 <dbg_i2c_status>
f9001aec:	f9002537          	lui	a0,0xf9002
f9001af0:	c6450513          	addi	a0,a0,-924 # f9001c64 <__freertos_irq_stack_top+0xffffbcd4>
f9001af4:	f7cff0ef          	jal	ra,f9001270 <println>
        println("  Camera not responding - check power/XCLK/pullups");
f9001af8:	f9002537          	lui	a0,0xf9002
f9001afc:	e4c50513          	addi	a0,a0,-436 # f9001e4c <__freertos_irq_stack_top+0xffffbebc>
f9001b00:	f70ff0ef          	jal	ra,f9001270 <println>
        return;
f9001b04:	fbdff06f          	j	f9001ac0 <imx219_init_96x96_raw8+0x3cc>

f9001b08 <camera_init>:

// =============================================================================
// Main Entry Point
// =============================================================================

void camera_init(void) {
f9001b08:	ff010113          	addi	sp,sp,-16
f9001b0c:	00112623          	sw	ra,12(sp)
    // Initialize I2C interface
    print("Init I2C.."); uart_drain();
f9001b10:	f9002537          	lui	a0,0xf9002
f9001b14:	f4850513          	addi	a0,a0,-184 # f9001f48 <__freertos_irq_stack_top+0xffffbfb8>
f9001b18:	e0cff0ef          	jal	ra,f9001124 <print>
f9001b1c:	dd0ff0ef          	jal	ra,f90010ec <uart_drain>
    i2c_init_100khz();
f9001b20:	fe4ff0ef          	jal	ra,f9001304 <i2c_init_100khz>

    // Wait for camera to be fully powered up before first I2C access
    print("Settling..."); uart_drain();
f9001b24:	f9002537          	lui	a0,0xf9002
f9001b28:	f5450513          	addi	a0,a0,-172 # f9001f54 <__freertos_irq_stack_top+0xffffbfc4>
f9001b2c:	df8ff0ef          	jal	ra,f9001124 <print>
f9001b30:	dbcff0ef          	jal	ra,f90010ec <uart_drain>
    bsp_uDelay(50000);  // 50 ms power-on settlement
f9001b34:	f8b00637          	lui	a2,0xf8b00
f9001b38:	02faf5b7          	lui	a1,0x2faf
f9001b3c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9001b40:	0000c537          	lui	a0,0xc
f9001b44:	35050513          	addi	a0,a0,848 # c350 <__stack_size+0x8350>
f9001b48:	d3cff0ef          	jal	ra,f9001084 <clint_uDelay>
    println("OK");
f9001b4c:	f9002537          	lui	a0,0xf9002
f9001b50:	cd050513          	addi	a0,a0,-816 # f9001cd0 <__freertos_irq_stack_top+0xffffbd40>
f9001b54:	f1cff0ef          	jal	ra,f9001270 <println>

    // Initialize CAM2
    imx219_init_96x96_raw8();
f9001b58:	b9dff0ef          	jal	ra,f90016f4 <imx219_init_96x96_raw8>

    println("=CAM SETUP COMPLETE=");
f9001b5c:	f9002537          	lui	a0,0xf9002
f9001b60:	f6050513          	addi	a0,a0,-160 # f9001f60 <__freertos_irq_stack_top+0xffffbfd0>
f9001b64:	f0cff0ef          	jal	ra,f9001270 <println>
}
f9001b68:	00c12083          	lw	ra,12(sp)
f9001b6c:	01010113          	addi	sp,sp,16
f9001b70:	00008067          	ret
