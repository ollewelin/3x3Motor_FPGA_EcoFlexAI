
build/test_b.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00002197          	auipc	gp,0x2
f9000004:	2f018193          	addi	gp,gp,752 # f90022f0 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	00006117          	auipc	sp,0x6
f900000c:	b0810113          	addi	sp,sp,-1272 # f9005b10 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f9000010:	00002517          	auipc	a0,0x2
f9000014:	96050513          	addi	a0,a0,-1696 # f9001970 <_data>
	la a1, _data
f9000018:	00002597          	auipc	a1,0x2
f900001c:	95858593          	addi	a1,a1,-1704 # f9001970 <_data>
	la a2, _edata
f9000020:	81c18613          	addi	a2,gp,-2020 # f9001b0c <__bss_start>
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
f900003c:	81c18513          	addi	a0,gp,-2020 # f9001b0c <__bss_start>
	la a1, _end
f9000040:	82018593          	addi	a1,gp,-2016 # f9001b10 <_end>
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
f9000058:	098010ef          	jal	ra,f90010f0 <main>

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
f9000074:	90040413          	addi	s0,s0,-1792 # f9001970 <_data>
f9000078:	00002917          	auipc	s2,0x2
f900007c:	8f890913          	addi	s2,s2,-1800 # f9001970 <_data>
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
f90000b0:	8c440413          	addi	s0,s0,-1852 # f9001970 <_data>
f90000b4:	00002917          	auipc	s2,0x2
f90000b8:	8bc90913          	addi	s2,s2,-1860 # f9001970 <_data>
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

f9000194 <uart_mini_print_hex8>:

/**
 * uart_mini_print_hex8() - Print 8-bit value as 2-digit hex
 */
static inline void uart_mini_print_hex8(uint8_t val)
{
f9000194:	fe010113          	addi	sp,sp,-32
    const char hex[] = "0123456789ABCDEF";
f9000198:	f90027b7          	lui	a5,0xf9002
f900019c:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f90001a0:	0007a583          	lw	a1,0(a5)
f90001a4:	0047a603          	lw	a2,4(a5)
f90001a8:	0087a683          	lw	a3,8(a5)
f90001ac:	00c7a703          	lw	a4,12(a5)
f90001b0:	00b12623          	sw	a1,12(sp)
f90001b4:	00c12823          	sw	a2,16(sp)
f90001b8:	00d12a23          	sw	a3,20(sp)
f90001bc:	00e12c23          	sw	a4,24(sp)
f90001c0:	0107c783          	lbu	a5,16(a5)
f90001c4:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f90001c8:	00455793          	srli	a5,a0,0x4
f90001cc:	02010713          	addi	a4,sp,32
f90001d0:	00f707b3          	add	a5,a4,a5
f90001d4:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f90001d8:	f81007b7          	lui	a5,0xf8100
f90001dc:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90001e0:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90001e4:	fe079ae3          	bnez	a5,f90001d8 <uart_mini_print_hex8+0x44>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90001e8:	f81007b7          	lui	a5,0xf8100
f90001ec:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f90001f0:	00f57513          	andi	a0,a0,15
f90001f4:	02010793          	addi	a5,sp,32
f90001f8:	00a78533          	add	a0,a5,a0
f90001fc:	fec54703          	lbu	a4,-20(a0) # f8000fec <__freertos_irq_stack_top+0xfeffb4dc>
    return (uint8_t)(*status_reg & 0xFF);
f9000200:	f81007b7          	lui	a5,0xf8100
f9000204:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000208:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900020c:	fe079ae3          	bnez	a5,f9000200 <uart_mini_print_hex8+0x6c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000210:	f81007b7          	lui	a5,0xf8100
f9000214:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
}
f9000218:	02010113          	addi	sp,sp,32
f900021c:	00008067          	ret

f9000220 <mdio_read>:
// ============================================================================

static inline void mdio_write_reg(uint32_t offset, uint32_t val)
{
    volatile uint32_t *reg = (volatile uint32_t *)(MDIO_BASE_ADDR + offset);
    *reg = val;
f9000220:	f8101737          	lui	a4,0xf8101
f9000224:	00200793          	li	a5,2
f9000228:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
    mdio_write_reg(MDIO_STATUS_REG, MDIO_STATUS_DONE);
    
    // Build CTRL word: start=1, RW=1(read), phy_addr, reg_addr, wdata=0
    uint32_t ctrl = (1 << 0)                      // start
                  | (1 << 1)                       // RW = read
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f900022c:	00551513          	slli	a0,a0,0x5
f9000230:	3e057513          	andi	a0,a0,992
f9000234:	00356513          	ori	a0,a0,3
                  | ((reg_addr & 0x1F) << 10);     // Register address
f9000238:	00a59593          	slli	a1,a1,0xa
f900023c:	000087b7          	lui	a5,0x8
f9000240:	c0078793          	addi	a5,a5,-1024 # 7c00 <__stack_size+0x3c00>
f9000244:	00f5f5b3          	and	a1,a1,a5
f9000248:	00b56533          	or	a0,a0,a1
    *reg = val;
f900024c:	00a72023          	sw	a0,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000250:	00000713          	li	a4,0
f9000254:	7cf00793          	li	a5,1999
f9000258:	00e7ce63          	blt	a5,a4,f9000274 <mdio_read+0x54>
    return *reg;
f900025c:	f81017b7          	lui	a5,0xf8101
f9000260:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000264:	0017f793          	andi	a5,a5,1
f9000268:	00079a63          	bnez	a5,f900027c <mdio_read+0x5c>
    for (int i = 0; i < 2000; i++) {
f900026c:	00170713          	addi	a4,a4,1
f9000270:	fe5ff06f          	j	f9000254 <mdio_read+0x34>
    int busy_seen = 0;
f9000274:	00000693          	li	a3,0
f9000278:	0080006f          	j	f9000280 <mdio_read+0x60>
            busy_seen = 1;
f900027c:	00100693          	li	a3,1
    if (!busy_seen)
f9000280:	04068263          	beqz	a3,f90002c4 <mdio_read+0xa4>
    for (int i = 0; i < 500000; i++) {
f9000284:	00000713          	li	a4,0
f9000288:	0007a7b7          	lui	a5,0x7a
f900028c:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000290:	00e7ce63          	blt	a5,a4,f90002ac <mdio_read+0x8c>
    return *reg;
f9000294:	f81017b7          	lui	a5,0xf8101
f9000298:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f900029c:	0027f793          	andi	a5,a5,2
f90002a0:	00079863          	bnez	a5,f90002b0 <mdio_read+0x90>
    for (int i = 0; i < 500000; i++) {
f90002a4:	00170713          	addi	a4,a4,1
f90002a8:	fe1ff06f          	j	f9000288 <mdio_read+0x68>
    return 0;  // Timeout
f90002ac:	00000693          	li	a3,0
    
    mdio_write_reg(MDIO_CTRL_REG, ctrl);
    
    // Wait for completion
    if (!mdio_wait_done())
f90002b0:	02068063          	beqz	a3,f90002d0 <mdio_read+0xb0>
    return *reg;
f90002b4:	f81017b7          	lui	a5,0xf8101
f90002b8:	0047a503          	lw	a0,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        return 0xFFFF;
    
    // Read data from STATUS[31:16]
    uint32_t status = mdio_read_reg(MDIO_STATUS_REG);
    return (uint16_t)(status >> 16);
f90002bc:	01055513          	srli	a0,a0,0x10
f90002c0:	00008067          	ret
        return 0xFFFF;
f90002c4:	00010537          	lui	a0,0x10
f90002c8:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
f90002cc:	00008067          	ret
f90002d0:	00010537          	lui	a0,0x10
f90002d4:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
}
f90002d8:	00008067          	ret

f90002dc <mdio_write>:
    *reg = val;
f90002dc:	f8101737          	lui	a4,0xf8101
f90002e0:	00200793          	li	a5,2
f90002e4:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
    mdio_write_reg(MDIO_STATUS_REG, MDIO_STATUS_DONE);
    
    // Build CTRL word: start=1, RW=0(write), phy_addr, reg_addr, wdata
    uint32_t ctrl = (1 << 0)                      // start
                  | (0 << 1)                       // RW = write
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f90002e8:	00551513          	slli	a0,a0,0x5
f90002ec:	3e057513          	andi	a0,a0,992
f90002f0:	00156513          	ori	a0,a0,1
                  | ((reg_addr & 0x1F) << 10)      // Register address
f90002f4:	00a59593          	slli	a1,a1,0xa
f90002f8:	000087b7          	lui	a5,0x8
f90002fc:	c0078793          	addi	a5,a5,-1024 # 7c00 <__stack_size+0x3c00>
f9000300:	00f5f5b3          	and	a1,a1,a5
f9000304:	00b56533          	or	a0,a0,a1
                  | ((uint32_t)data << 16);         // Write data
f9000308:	01061613          	slli	a2,a2,0x10
    uint32_t ctrl = (1 << 0)                      // start
f900030c:	00c56533          	or	a0,a0,a2
    *reg = val;
f9000310:	00a72023          	sw	a0,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000314:	00000713          	li	a4,0
f9000318:	7cf00793          	li	a5,1999
f900031c:	00e7ce63          	blt	a5,a4,f9000338 <mdio_write+0x5c>
    return *reg;
f9000320:	f81017b7          	lui	a5,0xf8101
f9000324:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000328:	0017f793          	andi	a5,a5,1
f900032c:	00079a63          	bnez	a5,f9000340 <mdio_write+0x64>
    for (int i = 0; i < 2000; i++) {
f9000330:	00170713          	addi	a4,a4,1
f9000334:	fe5ff06f          	j	f9000318 <mdio_write+0x3c>
    int busy_seen = 0;
f9000338:	00000513          	li	a0,0
f900033c:	0080006f          	j	f9000344 <mdio_write+0x68>
            busy_seen = 1;
f9000340:	00100513          	li	a0,1
    if (!busy_seen)
f9000344:	02050863          	beqz	a0,f9000374 <mdio_write+0x98>
    for (int i = 0; i < 500000; i++) {
f9000348:	00000713          	li	a4,0
f900034c:	0007a7b7          	lui	a5,0x7a
f9000350:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000354:	00e7ce63          	blt	a5,a4,f9000370 <mdio_write+0x94>
    return *reg;
f9000358:	f81017b7          	lui	a5,0xf8101
f900035c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000360:	0027f793          	andi	a5,a5,2
f9000364:	00079863          	bnez	a5,f9000374 <mdio_write+0x98>
    for (int i = 0; i < 500000; i++) {
f9000368:	00170713          	addi	a4,a4,1
f900036c:	fe1ff06f          	j	f900034c <mdio_write+0x70>
    return 0;  // Timeout
f9000370:	00000513          	li	a0,0
    
    mdio_write_reg(MDIO_CTRL_REG, ctrl);
    
    return mdio_wait_done();
}
f9000374:	00008067          	ret

f9000378 <led_on>:
        *((volatile u32*) address) = data;
f9000378:	f800d7b7          	lui	a5,0xf800d
f900037c:	00100713          	li	a4,1
f9000380:	00e7a223          	sw	a4,4(a5) # f800d004 <__freertos_irq_stack_top+0xff0074f4>
#define STAT_SPEED_1G       (1 << 7)

// =============================================================================
// Helper Functions
// =============================================================================
void led_on(void)  { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x1); }
f9000384:	00008067          	ret

f9000388 <led_off>:
f9000388:	f800d7b7          	lui	a5,0xf800d
f900038c:	0007a223          	sw	zero,4(a5) # f800d004 <__freertos_irq_stack_top+0xff0074f4>
void led_off(void) { gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x0); }
f9000390:	00008067          	ret

f9000394 <led_pulse>:
void led_pulse(int ms) {
f9000394:	ff010113          	addi	sp,sp,-16
f9000398:	00112623          	sw	ra,12(sp)
f900039c:	00812423          	sw	s0,8(sp)
f90003a0:	00912223          	sw	s1,4(sp)
f90003a4:	00050413          	mv	s0,a0
    led_on();
f90003a8:	fd1ff0ef          	jal	ra,f9000378 <led_on>
    bsp_uDelay(ms * 1000);
f90003ac:	3e800793          	li	a5,1000
f90003b0:	02f40433          	mul	s0,s0,a5
f90003b4:	f8b00637          	lui	a2,0xf8b00
f90003b8:	02faf4b7          	lui	s1,0x2faf
f90003bc:	08048593          	addi	a1,s1,128 # 2faf080 <__stack_size+0x2fab080>
f90003c0:	00040513          	mv	a0,s0
f90003c4:	d65ff0ef          	jal	ra,f9000128 <clint_uDelay>
    led_off();
f90003c8:	fc1ff0ef          	jal	ra,f9000388 <led_off>
    bsp_uDelay(ms * 1000);
f90003cc:	f8b00637          	lui	a2,0xf8b00
f90003d0:	08048593          	addi	a1,s1,128
f90003d4:	00040513          	mv	a0,s0
f90003d8:	d51ff0ef          	jal	ra,f9000128 <clint_uDelay>
}
f90003dc:	00c12083          	lw	ra,12(sp)
f90003e0:	00812403          	lw	s0,8(sp)
f90003e4:	00412483          	lw	s1,4(sp)
f90003e8:	01010113          	addi	sp,sp,16
f90003ec:	00008067          	ret

f90003f0 <uart_drain>:

void uart_drain(void) {
f90003f0:	ff010113          	addi	sp,sp,-16
f90003f4:	00112623          	sw	ra,12(sp)
    return (uint8_t)(*status_reg & 0xFF);
f90003f8:	f81007b7          	lui	a5,0xf8100
f90003fc:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    while (!(uart_mini_get_status() & UART_STATUS_TX_EMPTY)) { }
f9000400:	0017f793          	andi	a5,a5,1
f9000404:	fe078ae3          	beqz	a5,f90003f8 <uart_drain+0x8>
    bsp_uDelay(2000);
f9000408:	f8b00637          	lui	a2,0xf8b00
f900040c:	02faf5b7          	lui	a1,0x2faf
f9000410:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9000414:	7d000513          	li	a0,2000
f9000418:	d11ff0ef          	jal	ra,f9000128 <clint_uDelay>
}
f900041c:	00c12083          	lw	ra,12(sp)
f9000420:	01010113          	addi	sp,sp,16
f9000424:	00008067          	ret

f9000428 <print>:
    while (*str) {
f9000428:	0100006f          	j	f9000438 <print+0x10>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f900042c:	f81007b7          	lui	a5,0xf8100
f9000430:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
        str++;
f9000434:	00150513          	addi	a0,a0,1
    while (*str) {
f9000438:	00054703          	lbu	a4,0(a0)
f900043c:	00070c63          	beqz	a4,f9000454 <print+0x2c>
    return (uint8_t)(*status_reg & 0xFF);
f9000440:	f81007b7          	lui	a5,0xf8100
f9000444:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000448:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900044c:	fe0780e3          	beqz	a5,f900042c <print+0x4>
f9000450:	ff1ff06f          	j	f9000440 <print+0x18>

void print(const char *s)       { uart_mini_tx_string(s); }
f9000454:	00008067          	ret

f9000458 <println>:
void println(const char *s)     { print(s); uart_mini_newline(); uart_drain(); }
f9000458:	ff010113          	addi	sp,sp,-16
f900045c:	00112623          	sw	ra,12(sp)
f9000460:	fc9ff0ef          	jal	ra,f9000428 <print>
    return (uint8_t)(*status_reg & 0xFF);
f9000464:	f81007b7          	lui	a5,0xf8100
f9000468:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f900046c:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9000470:	fe079ae3          	bnez	a5,f9000464 <println+0xc>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000474:	f81007b7          	lui	a5,0xf8100
f9000478:	00d00713          	li	a4,13
f900047c:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    return (uint8_t)(*status_reg & 0xFF);
f9000480:	f81007b7          	lui	a5,0xf8100
f9000484:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000488:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900048c:	fe079ae3          	bnez	a5,f9000480 <println+0x28>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000490:	f81007b7          	lui	a5,0xf8100
f9000494:	00a00713          	li	a4,10
f9000498:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
f900049c:	f55ff0ef          	jal	ra,f90003f0 <uart_drain>
f90004a0:	00c12083          	lw	ra,12(sp)
f90004a4:	01010113          	addi	sp,sp,16
f90004a8:	00008067          	ret

f90004ac <print_hex16>:
void print_hex16(uint16_t val)  { uart_mini_tx_string("0x"); uart_mini_print_hex16(val); }
f90004ac:	fe010113          	addi	sp,sp,-32
f90004b0:	f9002737          	lui	a4,0xf9002
f90004b4:	98470713          	addi	a4,a4,-1660 # f9001984 <__freertos_irq_stack_top+0xffffbe74>
f90004b8:	0100006f          	j	f90004c8 <print_hex16+0x1c>
f90004bc:	f81007b7          	lui	a5,0xf8100
f90004c0:	00d7a423          	sw	a3,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
        str++;
f90004c4:	00170713          	addi	a4,a4,1
    while (*str) {
f90004c8:	00074683          	lbu	a3,0(a4)
f90004cc:	00068c63          	beqz	a3,f90004e4 <print_hex16+0x38>
    return (uint8_t)(*status_reg & 0xFF);
f90004d0:	f81007b7          	lui	a5,0xf8100
f90004d4:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90004d8:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90004dc:	fe0780e3          	beqz	a5,f90004bc <print_hex16+0x10>
f90004e0:	ff1ff06f          	j	f90004d0 <print_hex16+0x24>
/**
 * uart_mini_print_hex16() - Print 16-bit value as 4-digit hex
 */
static inline void uart_mini_print_hex16(uint16_t val)
{
    uart_mini_print_hex8((val >> 8) & 0xFF);
f90004e4:	00855713          	srli	a4,a0,0x8
    const char hex[] = "0123456789ABCDEF";
f90004e8:	f90027b7          	lui	a5,0xf9002
f90004ec:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f90004f0:	0007a803          	lw	a6,0(a5)
f90004f4:	0047a583          	lw	a1,4(a5)
f90004f8:	0087a603          	lw	a2,8(a5)
f90004fc:	00c7a683          	lw	a3,12(a5)
f9000500:	01012623          	sw	a6,12(sp)
f9000504:	00b12823          	sw	a1,16(sp)
f9000508:	00c12a23          	sw	a2,20(sp)
f900050c:	00d12c23          	sw	a3,24(sp)
f9000510:	0107c783          	lbu	a5,16(a5)
f9000514:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f9000518:	00475793          	srli	a5,a4,0x4
f900051c:	02010693          	addi	a3,sp,32
f9000520:	00f687b3          	add	a5,a3,a5
f9000524:	fec7c683          	lbu	a3,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9000528:	f81007b7          	lui	a5,0xf8100
f900052c:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000530:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9000534:	fe079ae3          	bnez	a5,f9000528 <print_hex16+0x7c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000538:	f81007b7          	lui	a5,0xf8100
f900053c:	00d7a423          	sw	a3,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f9000540:	00f77713          	andi	a4,a4,15
f9000544:	02010793          	addi	a5,sp,32
f9000548:	00e78733          	add	a4,a5,a4
f900054c:	fec74703          	lbu	a4,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f9000550:	f81007b7          	lui	a5,0xf8100
f9000554:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000558:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900055c:	fe079ae3          	bnez	a5,f9000550 <print_hex16+0xa4>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000560:	f81007b7          	lui	a5,0xf8100
f9000564:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_print_hex8(val & 0xFF);
f9000568:	0ff57513          	andi	a0,a0,255
    const char hex[] = "0123456789ABCDEF";
f900056c:	f90027b7          	lui	a5,0xf9002
f9000570:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f9000574:	0007a583          	lw	a1,0(a5)
f9000578:	0047a603          	lw	a2,4(a5)
f900057c:	0087a683          	lw	a3,8(a5)
f9000580:	00c7a703          	lw	a4,12(a5)
f9000584:	00b12623          	sw	a1,12(sp)
f9000588:	00c12823          	sw	a2,16(sp)
f900058c:	00d12a23          	sw	a3,20(sp)
f9000590:	00e12c23          	sw	a4,24(sp)
f9000594:	0107c783          	lbu	a5,16(a5)
f9000598:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f900059c:	00455793          	srli	a5,a0,0x4
f90005a0:	02010713          	addi	a4,sp,32
f90005a4:	00f707b3          	add	a5,a4,a5
f90005a8:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f90005ac:	f81007b7          	lui	a5,0xf8100
f90005b0:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90005b4:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90005b8:	fe079ae3          	bnez	a5,f90005ac <print_hex16+0x100>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90005bc:	f81007b7          	lui	a5,0xf8100
f90005c0:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f90005c4:	00f57513          	andi	a0,a0,15
f90005c8:	02010793          	addi	a5,sp,32
f90005cc:	00a78533          	add	a0,a5,a0
f90005d0:	fec54703          	lbu	a4,-20(a0)
    return (uint8_t)(*status_reg & 0xFF);
f90005d4:	f81007b7          	lui	a5,0xf8100
f90005d8:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90005dc:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90005e0:	fe079ae3          	bnez	a5,f90005d4 <print_hex16+0x128>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90005e4:	f81007b7          	lui	a5,0xf8100
f90005e8:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
f90005ec:	02010113          	addi	sp,sp,32
f90005f0:	00008067          	ret

f90005f4 <print_hex32>:
void print_hex32(uint32_t val)  {
f90005f4:	fe010113          	addi	sp,sp,-32
f90005f8:	f9002737          	lui	a4,0xf9002
f90005fc:	98470713          	addi	a4,a4,-1660 # f9001984 <__freertos_irq_stack_top+0xffffbe74>
f9000600:	0100006f          	j	f9000610 <print_hex32+0x1c>
f9000604:	f81007b7          	lui	a5,0xf8100
f9000608:	00d7a423          	sw	a3,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
        str++;
f900060c:	00170713          	addi	a4,a4,1
    while (*str) {
f9000610:	00074683          	lbu	a3,0(a4)
f9000614:	00068c63          	beqz	a3,f900062c <print_hex32+0x38>
    return (uint8_t)(*status_reg & 0xFF);
f9000618:	f81007b7          	lui	a5,0xf8100
f900061c:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000620:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9000624:	fe0780e3          	beqz	a5,f9000604 <print_hex32+0x10>
f9000628:	ff1ff06f          	j	f9000618 <print_hex32+0x24>
    uart_mini_tx_string("0x");
    uart_mini_print_hex16(val >> 16);
f900062c:	01055793          	srli	a5,a0,0x10
    uart_mini_print_hex8((val >> 8) & 0xFF);
f9000630:	0087d693          	srli	a3,a5,0x8
    const char hex[] = "0123456789ABCDEF";
f9000634:	f9002737          	lui	a4,0xf9002
f9000638:	97070713          	addi	a4,a4,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f900063c:	00072883          	lw	a7,0(a4)
f9000640:	00472803          	lw	a6,4(a4)
f9000644:	00872583          	lw	a1,8(a4)
f9000648:	00c72603          	lw	a2,12(a4)
f900064c:	01112623          	sw	a7,12(sp)
f9000650:	01012823          	sw	a6,16(sp)
f9000654:	00b12a23          	sw	a1,20(sp)
f9000658:	00c12c23          	sw	a2,24(sp)
f900065c:	01074703          	lbu	a4,16(a4)
f9000660:	00e10e23          	sb	a4,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f9000664:	0046d713          	srli	a4,a3,0x4
f9000668:	02010613          	addi	a2,sp,32
f900066c:	00e60733          	add	a4,a2,a4
f9000670:	fec74603          	lbu	a2,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f9000674:	f8100737          	lui	a4,0xf8100
f9000678:	00472703          	lw	a4,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f900067c:	00277713          	andi	a4,a4,2
    if (!uart_mini_tx_ready())
f9000680:	fe071ae3          	bnez	a4,f9000674 <print_hex32+0x80>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000684:	f8100737          	lui	a4,0xf8100
f9000688:	00c72423          	sw	a2,8(a4) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f900068c:	00f6f693          	andi	a3,a3,15
f9000690:	02010713          	addi	a4,sp,32
f9000694:	00d706b3          	add	a3,a4,a3
f9000698:	fec6c683          	lbu	a3,-20(a3)
    return (uint8_t)(*status_reg & 0xFF);
f900069c:	f8100737          	lui	a4,0xf8100
f90006a0:	00472703          	lw	a4,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90006a4:	00277713          	andi	a4,a4,2
    if (!uart_mini_tx_ready())
f90006a8:	fe071ae3          	bnez	a4,f900069c <print_hex32+0xa8>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90006ac:	f8100737          	lui	a4,0xf8100
f90006b0:	00d72423          	sw	a3,8(a4) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_print_hex8(val & 0xFF);
f90006b4:	0ff7f793          	andi	a5,a5,255
    const char hex[] = "0123456789ABCDEF";
f90006b8:	f9002737          	lui	a4,0xf9002
f90006bc:	97070713          	addi	a4,a4,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f90006c0:	00072803          	lw	a6,0(a4)
f90006c4:	00472583          	lw	a1,4(a4)
f90006c8:	00872603          	lw	a2,8(a4)
f90006cc:	00c72683          	lw	a3,12(a4)
f90006d0:	01012623          	sw	a6,12(sp)
f90006d4:	00b12823          	sw	a1,16(sp)
f90006d8:	00c12a23          	sw	a2,20(sp)
f90006dc:	00d12c23          	sw	a3,24(sp)
f90006e0:	01074703          	lbu	a4,16(a4)
f90006e4:	00e10e23          	sb	a4,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f90006e8:	0047d713          	srli	a4,a5,0x4
f90006ec:	02010693          	addi	a3,sp,32
f90006f0:	00e68733          	add	a4,a3,a4
f90006f4:	fec74683          	lbu	a3,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f90006f8:	f8100737          	lui	a4,0xf8100
f90006fc:	00472703          	lw	a4,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000700:	00277713          	andi	a4,a4,2
    if (!uart_mini_tx_ready())
f9000704:	fe071ae3          	bnez	a4,f90006f8 <print_hex32+0x104>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000708:	f8100737          	lui	a4,0xf8100
f900070c:	00d72423          	sw	a3,8(a4) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f9000710:	00f7f793          	andi	a5,a5,15
f9000714:	02010713          	addi	a4,sp,32
f9000718:	00f707b3          	add	a5,a4,a5
f900071c:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9000720:	f81007b7          	lui	a5,0xf8100
f9000724:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000728:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900072c:	fe079ae3          	bnez	a5,f9000720 <print_hex32+0x12c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000730:	f81007b7          	lui	a5,0xf8100
f9000734:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_print_hex16(val & 0xFFFF);
f9000738:	01051793          	slli	a5,a0,0x10
f900073c:	0107d793          	srli	a5,a5,0x10
    uart_mini_print_hex8((val >> 8) & 0xFF);
f9000740:	0087d793          	srli	a5,a5,0x8
    const char hex[] = "0123456789ABCDEF";
f9000744:	f9002737          	lui	a4,0xf9002
f9000748:	97070713          	addi	a4,a4,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f900074c:	00072803          	lw	a6,0(a4)
f9000750:	00472583          	lw	a1,4(a4)
f9000754:	00872603          	lw	a2,8(a4)
f9000758:	00c72683          	lw	a3,12(a4)
f900075c:	01012623          	sw	a6,12(sp)
f9000760:	00b12823          	sw	a1,16(sp)
f9000764:	00c12a23          	sw	a2,20(sp)
f9000768:	00d12c23          	sw	a3,24(sp)
f900076c:	01074703          	lbu	a4,16(a4)
f9000770:	00e10e23          	sb	a4,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f9000774:	0047d713          	srli	a4,a5,0x4
f9000778:	02010693          	addi	a3,sp,32
f900077c:	00e68733          	add	a4,a3,a4
f9000780:	fec74683          	lbu	a3,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f9000784:	f8100737          	lui	a4,0xf8100
f9000788:	00472703          	lw	a4,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f900078c:	00277713          	andi	a4,a4,2
    if (!uart_mini_tx_ready())
f9000790:	fe071ae3          	bnez	a4,f9000784 <print_hex32+0x190>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000794:	f8100737          	lui	a4,0xf8100
f9000798:	00d72423          	sw	a3,8(a4) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f900079c:	00f7f793          	andi	a5,a5,15
f90007a0:	02010713          	addi	a4,sp,32
f90007a4:	00f707b3          	add	a5,a4,a5
f90007a8:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f90007ac:	f81007b7          	lui	a5,0xf8100
f90007b0:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90007b4:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90007b8:	fe079ae3          	bnez	a5,f90007ac <print_hex32+0x1b8>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90007bc:	f81007b7          	lui	a5,0xf8100
f90007c0:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_print_hex8(val & 0xFF);
f90007c4:	0ff57513          	andi	a0,a0,255
    const char hex[] = "0123456789ABCDEF";
f90007c8:	f90027b7          	lui	a5,0xf9002
f90007cc:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f90007d0:	0007a583          	lw	a1,0(a5)
f90007d4:	0047a603          	lw	a2,4(a5)
f90007d8:	0087a683          	lw	a3,8(a5)
f90007dc:	00c7a703          	lw	a4,12(a5)
f90007e0:	00b12623          	sw	a1,12(sp)
f90007e4:	00c12823          	sw	a2,16(sp)
f90007e8:	00d12a23          	sw	a3,20(sp)
f90007ec:	00e12c23          	sw	a4,24(sp)
f90007f0:	0107c783          	lbu	a5,16(a5)
f90007f4:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f90007f8:	00455793          	srli	a5,a0,0x4
f90007fc:	02010713          	addi	a4,sp,32
f9000800:	00f707b3          	add	a5,a4,a5
f9000804:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9000808:	f81007b7          	lui	a5,0xf8100
f900080c:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000810:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9000814:	fe079ae3          	bnez	a5,f9000808 <print_hex32+0x214>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000818:	f81007b7          	lui	a5,0xf8100
f900081c:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f9000820:	00f57513          	andi	a0,a0,15
f9000824:	02010793          	addi	a5,sp,32
f9000828:	00a78533          	add	a0,a5,a0
f900082c:	fec54703          	lbu	a4,-20(a0)
    return (uint8_t)(*status_reg & 0xFF);
f9000830:	f81007b7          	lui	a5,0xf8100
f9000834:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9000838:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900083c:	fe079ae3          	bnez	a5,f9000830 <print_hex32+0x23c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9000840:	f81007b7          	lui	a5,0xf8100
f9000844:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
}
f9000848:	02010113          	addi	sp,sp,32
f900084c:	00008067          	ret

f9000850 <bmsr_read>:
    *reg = val;
f9000850:	f8101737          	lui	a4,0xf8101
f9000854:	00200793          	li	a5,2
f9000858:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f900085c:	00551793          	slli	a5,a0,0x5
f9000860:	3e07f793          	andi	a5,a5,992
                  | ((reg_addr & 0x1F) << 10);     // Register address
f9000864:	4037e793          	ori	a5,a5,1027
    *reg = val;
f9000868:	00f72023          	sw	a5,0(a4)
    for (int i = 0; i < 2000; i++) {
f900086c:	00000793          	li	a5,0
f9000870:	7cf00713          	li	a4,1999
f9000874:	00f74e63          	blt	a4,a5,f9000890 <bmsr_read+0x40>
    return *reg;
f9000878:	f8101737          	lui	a4,0xf8101
f900087c:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000880:	00177713          	andi	a4,a4,1
f9000884:	00071a63          	bnez	a4,f9000898 <bmsr_read+0x48>
    for (int i = 0; i < 2000; i++) {
f9000888:	00178793          	addi	a5,a5,1
f900088c:	fe5ff06f          	j	f9000870 <bmsr_read+0x20>
    int busy_seen = 0;
f9000890:	00000693          	li	a3,0
f9000894:	0080006f          	j	f900089c <bmsr_read+0x4c>
            busy_seen = 1;
f9000898:	00100693          	li	a3,1
    if (!busy_seen)
f900089c:	02068e63          	beqz	a3,f90008d8 <bmsr_read+0x88>
    for (int i = 0; i < 500000; i++) {
f90008a0:	00000713          	li	a4,0
f90008a4:	0007a7b7          	lui	a5,0x7a
f90008a8:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f90008ac:	00e7ce63          	blt	a5,a4,f90008c8 <bmsr_read+0x78>
    return *reg;
f90008b0:	f81017b7          	lui	a5,0xf8101
f90008b4:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f90008b8:	0027f793          	andi	a5,a5,2
f90008bc:	00079863          	bnez	a5,f90008cc <bmsr_read+0x7c>
    for (int i = 0; i < 500000; i++) {
f90008c0:	00170713          	addi	a4,a4,1
f90008c4:	fe1ff06f          	j	f90008a4 <bmsr_read+0x54>
    return 0;  // Timeout
f90008c8:	00000693          	li	a3,0
    if (!mdio_wait_done())
f90008cc:	00068663          	beqz	a3,f90008d8 <bmsr_read+0x88>
    return *reg;
f90008d0:	f81017b7          	lui	a5,0xf8101
f90008d4:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
    *reg = val;
f90008d8:	f81017b7          	lui	a5,0xf8101
f90008dc:	00200713          	li	a4,2
f90008e0:	00e7a223          	sw	a4,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f90008e4:	00551513          	slli	a0,a0,0x5
f90008e8:	3e057513          	andi	a0,a0,992
                  | ((reg_addr & 0x1F) << 10);     // Register address
f90008ec:	40356513          	ori	a0,a0,1027
    *reg = val;
f90008f0:	00a7a023          	sw	a0,0(a5)
    for (int i = 0; i < 2000; i++) {
f90008f4:	00000793          	li	a5,0
f90008f8:	0080006f          	j	f9000900 <bmsr_read+0xb0>
f90008fc:	00178793          	addi	a5,a5,1
f9000900:	7cf00713          	li	a4,1999
f9000904:	04f74263          	blt	a4,a5,f9000948 <bmsr_read+0xf8>
    return *reg;
f9000908:	f8101737          	lui	a4,0xf8101
f900090c:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000910:	00177713          	andi	a4,a4,1
f9000914:	fe0704e3          	beqz	a4,f90008fc <bmsr_read+0xac>
            busy_seen = 1;
f9000918:	00100693          	li	a3,1
    if (!busy_seen)
f900091c:	04068c63          	beqz	a3,f9000974 <bmsr_read+0x124>
    for (int i = 0; i < 500000; i++) {
f9000920:	00000713          	li	a4,0
f9000924:	0007a7b7          	lui	a5,0x7a
f9000928:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f900092c:	02e7c263          	blt	a5,a4,f9000950 <bmsr_read+0x100>
    return *reg;
f9000930:	f81017b7          	lui	a5,0xf8101
f9000934:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000938:	0027f793          	andi	a5,a5,2
f900093c:	00079c63          	bnez	a5,f9000954 <bmsr_read+0x104>
    for (int i = 0; i < 500000; i++) {
f9000940:	00170713          	addi	a4,a4,1
f9000944:	fe1ff06f          	j	f9000924 <bmsr_read+0xd4>
    int busy_seen = 0;
f9000948:	00000693          	li	a3,0
f900094c:	fd1ff06f          	j	f900091c <bmsr_read+0xcc>
    return 0;  // Timeout
f9000950:	00000693          	li	a3,0
    if (!mdio_wait_done())
f9000954:	02068663          	beqz	a3,f9000980 <bmsr_read+0x130>
    return *reg;
f9000958:	f81017b7          	lui	a5,0xf8101
f900095c:	0047a503          	lw	a0,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
    return (uint16_t)(status >> 16);
f9000960:	01055513          	srli	a0,a0,0x10

uint16_t bmsr_read(uint8_t phy) {
    uint16_t v;
    mdio_read(phy, PHY_REG_BMSR);
    v = mdio_read(phy, PHY_REG_BMSR);
    if (v == 0xFFFF) return 0;
f9000964:	000107b7          	lui	a5,0x10
f9000968:	fff78793          	addi	a5,a5,-1 # ffff <__stack_size+0xbfff>
f900096c:	02f50063          	beq	a0,a5,f900098c <bmsr_read+0x13c>
    return v;
}
f9000970:	00008067          	ret
        return 0xFFFF;
f9000974:	00010537          	lui	a0,0x10
f9000978:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
f900097c:	fe9ff06f          	j	f9000964 <bmsr_read+0x114>
f9000980:	00010537          	lui	a0,0x10
f9000984:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
f9000988:	fddff06f          	j	f9000964 <bmsr_read+0x114>
    if (v == 0xFFFF) return 0;
f900098c:	00000513          	li	a0,0
f9000990:	fe1ff06f          	j	f9000970 <bmsr_read+0x120>

f9000994 <rtl_physr>:

uint16_t rtl_physr(uint8_t phy) {
f9000994:	ff010113          	addi	sp,sp,-16
f9000998:	00112623          	sw	ra,12(sp)
f900099c:	00812423          	sw	s0,8(sp)
f90009a0:	00050413          	mv	s0,a0
    *reg = val;
f90009a4:	f81016b7          	lui	a3,0xf8101
f90009a8:	00200793          	li	a5,2
f90009ac:	00f6a223          	sw	a5,4(a3) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f90009b0:	00551793          	slli	a5,a0,0x5
f90009b4:	3e07f793          	andi	a5,a5,992
                  | ((reg_addr & 0x1F) << 10)      // Register address
f90009b8:	00008737          	lui	a4,0x8
f90009bc:	c0170713          	addi	a4,a4,-1023 # 7c01 <__stack_size+0x3c01>
f90009c0:	00e7e7b3          	or	a5,a5,a4
    uint32_t ctrl = (1 << 0)                      // start
f90009c4:	0a430737          	lui	a4,0xa430
f90009c8:	00e7e7b3          	or	a5,a5,a4
    *reg = val;
f90009cc:	00f6a023          	sw	a5,0(a3)
    for (int i = 0; i < 2000; i++) {
f90009d0:	00000793          	li	a5,0
f90009d4:	7cf00713          	li	a4,1999
f90009d8:	00f74e63          	blt	a4,a5,f90009f4 <rtl_physr+0x60>
    return *reg;
f90009dc:	f8101737          	lui	a4,0xf8101
f90009e0:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f90009e4:	00177713          	andi	a4,a4,1
f90009e8:	00071a63          	bnez	a4,f90009fc <rtl_physr+0x68>
    for (int i = 0; i < 2000; i++) {
f90009ec:	00178793          	addi	a5,a5,1
f90009f0:	fe5ff06f          	j	f90009d4 <rtl_physr+0x40>
    int busy_seen = 0;
f90009f4:	00000793          	li	a5,0
f90009f8:	0080006f          	j	f9000a00 <rtl_physr+0x6c>
            busy_seen = 1;
f90009fc:	00100793          	li	a5,1
    if (!busy_seen)
f9000a00:	02078663          	beqz	a5,f9000a2c <rtl_physr+0x98>
    for (int i = 0; i < 500000; i++) {
f9000a04:	00000713          	li	a4,0
f9000a08:	0007a7b7          	lui	a5,0x7a
f9000a0c:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000a10:	00e7ce63          	blt	a5,a4,f9000a2c <rtl_physr+0x98>
    return *reg;
f9000a14:	f81017b7          	lui	a5,0xf8101
f9000a18:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000a1c:	0027f793          	andi	a5,a5,2
f9000a20:	00079663          	bnez	a5,f9000a2c <rtl_physr+0x98>
    for (int i = 0; i < 500000; i++) {
f9000a24:	00170713          	addi	a4,a4,1
f9000a28:	fe1ff06f          	j	f9000a08 <rtl_physr+0x74>
    mdio_write(phy, 0x1F, 0x0a43);
    bsp_uDelay(1000);
f9000a2c:	f8b00637          	lui	a2,0xf8b00
f9000a30:	02faf5b7          	lui	a1,0x2faf
f9000a34:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9000a38:	3e800513          	li	a0,1000
f9000a3c:	eecff0ef          	jal	ra,f9000128 <clint_uDelay>
    *reg = val;
f9000a40:	f81016b7          	lui	a3,0xf8101
f9000a44:	00200793          	li	a5,2
f9000a48:	00f6a223          	sw	a5,4(a3) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f9000a4c:	00541793          	slli	a5,s0,0x5
f9000a50:	3e07f793          	andi	a5,a5,992
                  | ((reg_addr & 0x1F) << 10);     // Register address
f9000a54:	00007737          	lui	a4,0x7
f9000a58:	80370713          	addi	a4,a4,-2045 # 6803 <__stack_size+0x2803>
f9000a5c:	00e7e7b3          	or	a5,a5,a4
    *reg = val;
f9000a60:	00f6a023          	sw	a5,0(a3)
    for (int i = 0; i < 2000; i++) {
f9000a64:	00000793          	li	a5,0
f9000a68:	0080006f          	j	f9000a70 <rtl_physr+0xdc>
f9000a6c:	00178793          	addi	a5,a5,1
f9000a70:	7cf00713          	li	a4,1999
f9000a74:	04f74263          	blt	a4,a5,f9000ab8 <rtl_physr+0x124>
    return *reg;
f9000a78:	f8101737          	lui	a4,0xf8101
f9000a7c:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000a80:	00177713          	andi	a4,a4,1
f9000a84:	fe0704e3          	beqz	a4,f9000a6c <rtl_physr+0xd8>
            busy_seen = 1;
f9000a88:	00100693          	li	a3,1
    if (!busy_seen)
f9000a8c:	08068863          	beqz	a3,f9000b1c <rtl_physr+0x188>
    for (int i = 0; i < 500000; i++) {
f9000a90:	00000713          	li	a4,0
f9000a94:	0007a7b7          	lui	a5,0x7a
f9000a98:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000a9c:	02e7c263          	blt	a5,a4,f9000ac0 <rtl_physr+0x12c>
    return *reg;
f9000aa0:	f81017b7          	lui	a5,0xf8101
f9000aa4:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000aa8:	0027f793          	andi	a5,a5,2
f9000aac:	00079c63          	bnez	a5,f9000ac4 <rtl_physr+0x130>
    for (int i = 0; i < 500000; i++) {
f9000ab0:	00170713          	addi	a4,a4,1
f9000ab4:	fe1ff06f          	j	f9000a94 <rtl_physr+0x100>
    int busy_seen = 0;
f9000ab8:	00000693          	li	a3,0
f9000abc:	fd1ff06f          	j	f9000a8c <rtl_physr+0xf8>
    return 0;  // Timeout
f9000ac0:	00000693          	li	a3,0
    if (!mdio_wait_done())
f9000ac4:	06068263          	beqz	a3,f9000b28 <rtl_physr+0x194>
    return *reg;
f9000ac8:	f81017b7          	lui	a5,0xf8101
f9000acc:	0047a503          	lw	a0,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
    return (uint16_t)(status >> 16);
f9000ad0:	01055513          	srli	a0,a0,0x10
    *reg = val;
f9000ad4:	f8101737          	lui	a4,0xf8101
f9000ad8:	00200793          	li	a5,2
f9000adc:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f9000ae0:	00541413          	slli	s0,s0,0x5
f9000ae4:	3e047413          	andi	s0,s0,992
                  | ((reg_addr & 0x1F) << 10)      // Register address
f9000ae8:	000087b7          	lui	a5,0x8
f9000aec:	c0178793          	addi	a5,a5,-1023 # 7c01 <__stack_size+0x3c01>
f9000af0:	00f46433          	or	s0,s0,a5
    *reg = val;
f9000af4:	00872023          	sw	s0,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000af8:	00000793          	li	a5,0
f9000afc:	7cf00713          	li	a4,1999
f9000b00:	02f74a63          	blt	a4,a5,f9000b34 <rtl_physr+0x1a0>
    return *reg;
f9000b04:	f8101737          	lui	a4,0xf8101
f9000b08:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000b0c:	00177713          	andi	a4,a4,1
f9000b10:	02071663          	bnez	a4,f9000b3c <rtl_physr+0x1a8>
    for (int i = 0; i < 2000; i++) {
f9000b14:	00178793          	addi	a5,a5,1
f9000b18:	fe5ff06f          	j	f9000afc <rtl_physr+0x168>
        return 0xFFFF;
f9000b1c:	00010537          	lui	a0,0x10
f9000b20:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
f9000b24:	fb1ff06f          	j	f9000ad4 <rtl_physr+0x140>
f9000b28:	00010537          	lui	a0,0x10
f9000b2c:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
f9000b30:	fa5ff06f          	j	f9000ad4 <rtl_physr+0x140>
    int busy_seen = 0;
f9000b34:	00000793          	li	a5,0
f9000b38:	0080006f          	j	f9000b40 <rtl_physr+0x1ac>
            busy_seen = 1;
f9000b3c:	00100793          	li	a5,1
    if (!busy_seen)
f9000b40:	02078663          	beqz	a5,f9000b6c <rtl_physr+0x1d8>
    for (int i = 0; i < 500000; i++) {
f9000b44:	00000713          	li	a4,0
f9000b48:	0007a7b7          	lui	a5,0x7a
f9000b4c:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000b50:	00e7ce63          	blt	a5,a4,f9000b6c <rtl_physr+0x1d8>
    return *reg;
f9000b54:	f81017b7          	lui	a5,0xf8101
f9000b58:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000b5c:	0027f793          	andi	a5,a5,2
f9000b60:	00079663          	bnez	a5,f9000b6c <rtl_physr+0x1d8>
    for (int i = 0; i < 500000; i++) {
f9000b64:	00170713          	addi	a4,a4,1
f9000b68:	fe1ff06f          	j	f9000b48 <rtl_physr+0x1b4>
    uint16_t v = mdio_read(phy, 0x1A);
    mdio_write(phy, 0x1F, 0x0000);
    return v;
}
f9000b6c:	00c12083          	lw	ra,12(sp)
f9000b70:	00812403          	lw	s0,8(sp)
f9000b74:	01010113          	addi	sp,sp,16
f9000b78:	00008067          	ret

f9000b7c <rtl_set_rgmii_delay>:
// RTL8211F RGMII delays: Page 0xd08, Register 0x11
//   Bit 8: TXDLY (adds 2ns to TXC output, for the receiver to sample our data)
//   Bit 3: RXDLY (adds 2ns to RXC input, for us to sample incoming data)
// Both are in the SAME register (0x11). There is no separate 0x15 register.
// Reference: Linux kernel drivers/net/phy/realtek/realtek_main.c + mdio_driver.h
void rtl_set_rgmii_delay(uint8_t phy, int tx_delay_en, int rx_delay_en) {
f9000b7c:	ff010113          	addi	sp,sp,-16
f9000b80:	00112623          	sw	ra,12(sp)
f9000b84:	00812423          	sw	s0,8(sp)
f9000b88:	00912223          	sw	s1,4(sp)
f9000b8c:	01212023          	sw	s2,0(sp)
f9000b90:	00050413          	mv	s0,a0
f9000b94:	00058913          	mv	s2,a1
f9000b98:	00060493          	mv	s1,a2
    *reg = val;
f9000b9c:	f81016b7          	lui	a3,0xf8101
f9000ba0:	00200793          	li	a5,2
f9000ba4:	00f6a223          	sw	a5,4(a3) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f9000ba8:	00551793          	slli	a5,a0,0x5
f9000bac:	3e07f793          	andi	a5,a5,992
                  | ((reg_addr & 0x1F) << 10)      // Register address
f9000bb0:	00008737          	lui	a4,0x8
f9000bb4:	c0170713          	addi	a4,a4,-1023 # 7c01 <__stack_size+0x3c01>
f9000bb8:	00e7e7b3          	or	a5,a5,a4
    uint32_t ctrl = (1 << 0)                      // start
f9000bbc:	0d080737          	lui	a4,0xd080
f9000bc0:	00e7e7b3          	or	a5,a5,a4
    *reg = val;
f9000bc4:	00f6a023          	sw	a5,0(a3)
    for (int i = 0; i < 2000; i++) {
f9000bc8:	00000793          	li	a5,0
f9000bcc:	7cf00713          	li	a4,1999
f9000bd0:	00f74e63          	blt	a4,a5,f9000bec <rtl_set_rgmii_delay+0x70>
    return *reg;
f9000bd4:	f8101737          	lui	a4,0xf8101
f9000bd8:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000bdc:	00177713          	andi	a4,a4,1
f9000be0:	00071a63          	bnez	a4,f9000bf4 <rtl_set_rgmii_delay+0x78>
    for (int i = 0; i < 2000; i++) {
f9000be4:	00178793          	addi	a5,a5,1
f9000be8:	fe5ff06f          	j	f9000bcc <rtl_set_rgmii_delay+0x50>
    int busy_seen = 0;
f9000bec:	00000793          	li	a5,0
f9000bf0:	0080006f          	j	f9000bf8 <rtl_set_rgmii_delay+0x7c>
            busy_seen = 1;
f9000bf4:	00100793          	li	a5,1
    if (!busy_seen)
f9000bf8:	02078663          	beqz	a5,f9000c24 <rtl_set_rgmii_delay+0xa8>
    for (int i = 0; i < 500000; i++) {
f9000bfc:	00000713          	li	a4,0
f9000c00:	0007a7b7          	lui	a5,0x7a
f9000c04:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000c08:	00e7ce63          	blt	a5,a4,f9000c24 <rtl_set_rgmii_delay+0xa8>
    return *reg;
f9000c0c:	f81017b7          	lui	a5,0xf8101
f9000c10:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000c14:	0027f793          	andi	a5,a5,2
f9000c18:	00079663          	bnez	a5,f9000c24 <rtl_set_rgmii_delay+0xa8>
    for (int i = 0; i < 500000; i++) {
f9000c1c:	00170713          	addi	a4,a4,1
f9000c20:	fe1ff06f          	j	f9000c00 <rtl_set_rgmii_delay+0x84>
    // Switch to page 0xd08
    mdio_write(phy, 0x1F, 0x0d08);
    bsp_uDelay(1000);
f9000c24:	f8b00637          	lui	a2,0xf8b00
f9000c28:	02faf5b7          	lui	a1,0x2faf
f9000c2c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9000c30:	3e800513          	li	a0,1000
f9000c34:	cf4ff0ef          	jal	ra,f9000128 <clint_uDelay>
    *reg = val;
f9000c38:	f81016b7          	lui	a3,0xf8101
f9000c3c:	00200793          	li	a5,2
f9000c40:	00f6a223          	sw	a5,4(a3) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f9000c44:	00541793          	slli	a5,s0,0x5
f9000c48:	3e07f793          	andi	a5,a5,992
                  | ((reg_addr & 0x1F) << 10);     // Register address
f9000c4c:	00004737          	lui	a4,0x4
f9000c50:	40370713          	addi	a4,a4,1027 # 4403 <__stack_size+0x403>
f9000c54:	00e7e7b3          	or	a5,a5,a4
    *reg = val;
f9000c58:	00f6a023          	sw	a5,0(a3)
    for (int i = 0; i < 2000; i++) {
f9000c5c:	00000793          	li	a5,0
f9000c60:	0080006f          	j	f9000c68 <rtl_set_rgmii_delay+0xec>
f9000c64:	00178793          	addi	a5,a5,1
f9000c68:	7cf00713          	li	a4,1999
f9000c6c:	04f74263          	blt	a4,a5,f9000cb0 <rtl_set_rgmii_delay+0x134>
    return *reg;
f9000c70:	f8101737          	lui	a4,0xf8101
f9000c74:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000c78:	00177713          	andi	a4,a4,1
f9000c7c:	fe0704e3          	beqz	a4,f9000c64 <rtl_set_rgmii_delay+0xe8>
            busy_seen = 1;
f9000c80:	00100693          	li	a3,1
    if (!busy_seen)
f9000c84:	0a068463          	beqz	a3,f9000d2c <rtl_set_rgmii_delay+0x1b0>
    for (int i = 0; i < 500000; i++) {
f9000c88:	00000713          	li	a4,0
f9000c8c:	0007a7b7          	lui	a5,0x7a
f9000c90:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000c94:	02e7c263          	blt	a5,a4,f9000cb8 <rtl_set_rgmii_delay+0x13c>
    return *reg;
f9000c98:	f81017b7          	lui	a5,0xf8101
f9000c9c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000ca0:	0027f793          	andi	a5,a5,2
f9000ca4:	00079c63          	bnez	a5,f9000cbc <rtl_set_rgmii_delay+0x140>
    for (int i = 0; i < 500000; i++) {
f9000ca8:	00170713          	addi	a4,a4,1
f9000cac:	fe1ff06f          	j	f9000c8c <rtl_set_rgmii_delay+0x110>
    int busy_seen = 0;
f9000cb0:	00000693          	li	a3,0
f9000cb4:	fd1ff06f          	j	f9000c84 <rtl_set_rgmii_delay+0x108>
    return 0;  // Timeout
f9000cb8:	00000693          	li	a3,0
    if (!mdio_wait_done())
f9000cbc:	06068e63          	beqz	a3,f9000d38 <rtl_set_rgmii_delay+0x1bc>
    return *reg;
f9000cc0:	f81017b7          	lui	a5,0xf8101
f9000cc4:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
    return (uint16_t)(status >> 16);
f9000cc8:	0107d793          	srli	a5,a5,0x10
    
    // Read-modify-write register 0x11
    uint16_t reg11 = mdio_read(phy, 0x11);
    
    if (tx_delay_en)
f9000ccc:	06090c63          	beqz	s2,f9000d44 <rtl_set_rgmii_delay+0x1c8>
        reg11 |= (1 << 8);    // Enable 2ns TX delay
f9000cd0:	1007e793          	ori	a5,a5,256
    else
        reg11 &= ~(1 << 8);   // Disable TX delay
        
    if (rx_delay_en)
f9000cd4:	08048063          	beqz	s1,f9000d54 <rtl_set_rgmii_delay+0x1d8>
        reg11 |= (1 << 3);    // Enable 2ns RX delay
f9000cd8:	0087e793          	ori	a5,a5,8
    *reg = val;
f9000cdc:	f8101637          	lui	a2,0xf8101
f9000ce0:	00200713          	li	a4,2
f9000ce4:	00e62223          	sw	a4,4(a2) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f9000ce8:	00541713          	slli	a4,s0,0x5
f9000cec:	3e077713          	andi	a4,a4,992
                  | ((reg_addr & 0x1F) << 10)      // Register address
f9000cf0:	000046b7          	lui	a3,0x4
f9000cf4:	40168693          	addi	a3,a3,1025 # 4401 <__stack_size+0x401>
f9000cf8:	00d76733          	or	a4,a4,a3
                  | ((uint32_t)data << 16);         // Write data
f9000cfc:	01079793          	slli	a5,a5,0x10
    uint32_t ctrl = (1 << 0)                      // start
f9000d00:	00f767b3          	or	a5,a4,a5
    *reg = val;
f9000d04:	00f62023          	sw	a5,0(a2)
    for (int i = 0; i < 2000; i++) {
f9000d08:	00000793          	li	a5,0
f9000d0c:	7cf00713          	li	a4,1999
f9000d10:	04f74a63          	blt	a4,a5,f9000d64 <rtl_set_rgmii_delay+0x1e8>
    return *reg;
f9000d14:	f8101737          	lui	a4,0xf8101
f9000d18:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000d1c:	00177713          	andi	a4,a4,1
f9000d20:	04071663          	bnez	a4,f9000d6c <rtl_set_rgmii_delay+0x1f0>
    for (int i = 0; i < 2000; i++) {
f9000d24:	00178793          	addi	a5,a5,1
f9000d28:	fe5ff06f          	j	f9000d0c <rtl_set_rgmii_delay+0x190>
        return 0xFFFF;
f9000d2c:	000107b7          	lui	a5,0x10
f9000d30:	fff78793          	addi	a5,a5,-1 # ffff <__stack_size+0xbfff>
f9000d34:	f99ff06f          	j	f9000ccc <rtl_set_rgmii_delay+0x150>
f9000d38:	000107b7          	lui	a5,0x10
f9000d3c:	fff78793          	addi	a5,a5,-1 # ffff <__stack_size+0xbfff>
f9000d40:	f8dff06f          	j	f9000ccc <rtl_set_rgmii_delay+0x150>
        reg11 &= ~(1 << 8);   // Disable TX delay
f9000d44:	eff7f793          	andi	a5,a5,-257
f9000d48:	01079793          	slli	a5,a5,0x10
f9000d4c:	0107d793          	srli	a5,a5,0x10
f9000d50:	f85ff06f          	j	f9000cd4 <rtl_set_rgmii_delay+0x158>
    else
        reg11 &= ~(1 << 3);   // Disable RX delay
f9000d54:	ff77f793          	andi	a5,a5,-9
f9000d58:	01079793          	slli	a5,a5,0x10
f9000d5c:	0107d793          	srli	a5,a5,0x10
f9000d60:	f7dff06f          	j	f9000cdc <rtl_set_rgmii_delay+0x160>
    int busy_seen = 0;
f9000d64:	00000793          	li	a5,0
f9000d68:	0080006f          	j	f9000d70 <rtl_set_rgmii_delay+0x1f4>
            busy_seen = 1;
f9000d6c:	00100793          	li	a5,1
    if (!busy_seen)
f9000d70:	02078663          	beqz	a5,f9000d9c <rtl_set_rgmii_delay+0x220>
    for (int i = 0; i < 500000; i++) {
f9000d74:	00000713          	li	a4,0
f9000d78:	0007a7b7          	lui	a5,0x7a
f9000d7c:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000d80:	00e7ce63          	blt	a5,a4,f9000d9c <rtl_set_rgmii_delay+0x220>
    return *reg;
f9000d84:	f81017b7          	lui	a5,0xf8101
f9000d88:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000d8c:	0027f793          	andi	a5,a5,2
f9000d90:	00079663          	bnez	a5,f9000d9c <rtl_set_rgmii_delay+0x220>
    for (int i = 0; i < 500000; i++) {
f9000d94:	00170713          	addi	a4,a4,1
f9000d98:	fe1ff06f          	j	f9000d78 <rtl_set_rgmii_delay+0x1fc>
    
    mdio_write(phy, 0x11, reg11);
    bsp_uDelay(1000);
f9000d9c:	f8b00637          	lui	a2,0xf8b00
f9000da0:	02faf5b7          	lui	a1,0x2faf
f9000da4:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9000da8:	3e800513          	li	a0,1000
f9000dac:	b7cff0ef          	jal	ra,f9000128 <clint_uDelay>
    *reg = val;
f9000db0:	f81016b7          	lui	a3,0xf8101
f9000db4:	00200793          	li	a5,2
f9000db8:	00f6a223          	sw	a5,4(a3) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f9000dbc:	00541793          	slli	a5,s0,0x5
f9000dc0:	3e07f793          	andi	a5,a5,992
                  | ((reg_addr & 0x1F) << 10);     // Register address
f9000dc4:	00004737          	lui	a4,0x4
f9000dc8:	40370713          	addi	a4,a4,1027 # 4403 <__stack_size+0x403>
f9000dcc:	00e7e7b3          	or	a5,a5,a4
    *reg = val;
f9000dd0:	00f6a023          	sw	a5,0(a3)
    for (int i = 0; i < 2000; i++) {
f9000dd4:	00000793          	li	a5,0
f9000dd8:	7cf00713          	li	a4,1999
f9000ddc:	00f74e63          	blt	a4,a5,f9000df8 <rtl_set_rgmii_delay+0x27c>
    return *reg;
f9000de0:	f8101737          	lui	a4,0xf8101
f9000de4:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000de8:	00177713          	andi	a4,a4,1
f9000dec:	00071a63          	bnez	a4,f9000e00 <rtl_set_rgmii_delay+0x284>
    for (int i = 0; i < 2000; i++) {
f9000df0:	00178793          	addi	a5,a5,1
f9000df4:	fe5ff06f          	j	f9000dd8 <rtl_set_rgmii_delay+0x25c>
    int busy_seen = 0;
f9000df8:	00000693          	li	a3,0
f9000dfc:	0080006f          	j	f9000e04 <rtl_set_rgmii_delay+0x288>
            busy_seen = 1;
f9000e00:	00100693          	li	a3,1
    if (!busy_seen)
f9000e04:	08068463          	beqz	a3,f9000e8c <rtl_set_rgmii_delay+0x310>
    for (int i = 0; i < 500000; i++) {
f9000e08:	00000713          	li	a4,0
f9000e0c:	0007a7b7          	lui	a5,0x7a
f9000e10:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000e14:	00e7ce63          	blt	a5,a4,f9000e30 <rtl_set_rgmii_delay+0x2b4>
    return *reg;
f9000e18:	f81017b7          	lui	a5,0xf8101
f9000e1c:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000e20:	0027f793          	andi	a5,a5,2
f9000e24:	00079863          	bnez	a5,f9000e34 <rtl_set_rgmii_delay+0x2b8>
    for (int i = 0; i < 500000; i++) {
f9000e28:	00170713          	addi	a4,a4,1
f9000e2c:	fe1ff06f          	j	f9000e0c <rtl_set_rgmii_delay+0x290>
    return 0;  // Timeout
f9000e30:	00000693          	li	a3,0
    if (!mdio_wait_done())
f9000e34:	06068263          	beqz	a3,f9000e98 <rtl_set_rgmii_delay+0x31c>
    return *reg;
f9000e38:	f81017b7          	lui	a5,0xf8101
f9000e3c:	0047a483          	lw	s1,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
    return (uint16_t)(status >> 16);
f9000e40:	0104d493          	srli	s1,s1,0x10
    *reg = val;
f9000e44:	f8101737          	lui	a4,0xf8101
f9000e48:	00200793          	li	a5,2
f9000e4c:	00f72223          	sw	a5,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
                  | ((phy_addr & 0x1F) << 5)       // PHY address
f9000e50:	00541413          	slli	s0,s0,0x5
f9000e54:	3e047413          	andi	s0,s0,992
                  | ((reg_addr & 0x1F) << 10)      // Register address
f9000e58:	000087b7          	lui	a5,0x8
f9000e5c:	c0178793          	addi	a5,a5,-1023 # 7c01 <__stack_size+0x3c01>
f9000e60:	00f46433          	or	s0,s0,a5
    *reg = val;
f9000e64:	00872023          	sw	s0,0(a4)
    for (int i = 0; i < 2000; i++) {
f9000e68:	00000793          	li	a5,0
f9000e6c:	7cf00713          	li	a4,1999
f9000e70:	02f74a63          	blt	a4,a5,f9000ea4 <rtl_set_rgmii_delay+0x328>
    return *reg;
f9000e74:	f8101737          	lui	a4,0xf8101
f9000e78:	00472703          	lw	a4,4(a4) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (mdio_read_reg(MDIO_STATUS_REG) & MDIO_STATUS_BUSY) {
f9000e7c:	00177713          	andi	a4,a4,1
f9000e80:	02071663          	bnez	a4,f9000eac <rtl_set_rgmii_delay+0x330>
    for (int i = 0; i < 2000; i++) {
f9000e84:	00178793          	addi	a5,a5,1
f9000e88:	fe5ff06f          	j	f9000e6c <rtl_set_rgmii_delay+0x2f0>
        return 0xFFFF;
f9000e8c:	000104b7          	lui	s1,0x10
f9000e90:	fff48493          	addi	s1,s1,-1 # ffff <__stack_size+0xbfff>
f9000e94:	fb1ff06f          	j	f9000e44 <rtl_set_rgmii_delay+0x2c8>
f9000e98:	000104b7          	lui	s1,0x10
f9000e9c:	fff48493          	addi	s1,s1,-1 # ffff <__stack_size+0xbfff>
f9000ea0:	fa5ff06f          	j	f9000e44 <rtl_set_rgmii_delay+0x2c8>
    int busy_seen = 0;
f9000ea4:	00000793          	li	a5,0
f9000ea8:	0080006f          	j	f9000eb0 <rtl_set_rgmii_delay+0x334>
            busy_seen = 1;
f9000eac:	00100793          	li	a5,1
    if (!busy_seen)
f9000eb0:	02078663          	beqz	a5,f9000edc <rtl_set_rgmii_delay+0x360>
    for (int i = 0; i < 500000; i++) {
f9000eb4:	00000713          	li	a4,0
f9000eb8:	0007a7b7          	lui	a5,0x7a
f9000ebc:	11f78793          	addi	a5,a5,287 # 7a11f <__stack_size+0x7611f>
f9000ec0:	00e7ce63          	blt	a5,a4,f9000edc <rtl_set_rgmii_delay+0x360>
    return *reg;
f9000ec4:	f81017b7          	lui	a5,0xf8101
f9000ec8:	0047a783          	lw	a5,4(a5) # f8101004 <__freertos_irq_stack_top+0xff0fb4f4>
        if (status & MDIO_STATUS_DONE)
f9000ecc:	0027f793          	andi	a5,a5,2
f9000ed0:	00079663          	bnez	a5,f9000edc <rtl_set_rgmii_delay+0x360>
    for (int i = 0; i < 500000; i++) {
f9000ed4:	00170713          	addi	a4,a4,1
f9000ed8:	fe1ff06f          	j	f9000eb8 <rtl_set_rgmii_delay+0x33c>
    uint16_t rb = mdio_read(phy, 0x11);
    
    // Return to page 0
    mdio_write(phy, 0x1F, 0x0000);
    
    print("DLY_REG="); print_hex16(rb);
f9000edc:	f9002537          	lui	a0,0xf9002
f9000ee0:	9a850513          	addi	a0,a0,-1624 # f90019a8 <__freertos_irq_stack_top+0xffffbe98>
f9000ee4:	d44ff0ef          	jal	ra,f9000428 <print>
f9000ee8:	00048513          	mv	a0,s1
f9000eec:	dc0ff0ef          	jal	ra,f90004ac <print_hex16>
    print(rb & (1<<8) ? " TX=ON" : " TX=OFF");
f9000ef0:	1004f793          	andi	a5,s1,256
f9000ef4:	04078463          	beqz	a5,f9000f3c <rtl_set_rgmii_delay+0x3c0>
f9000ef8:	f9002537          	lui	a0,0xf9002
f9000efc:	99050513          	addi	a0,a0,-1648 # f9001990 <__freertos_irq_stack_top+0xffffbe80>
f9000f00:	d28ff0ef          	jal	ra,f9000428 <print>
    print(rb & (1<<3) ? " RX=ON" : " RX=OFF");
f9000f04:	0084f493          	andi	s1,s1,8
f9000f08:	04048063          	beqz	s1,f9000f48 <rtl_set_rgmii_delay+0x3cc>
f9000f0c:	f9002537          	lui	a0,0xf9002
f9000f10:	9a050513          	addi	a0,a0,-1632 # f90019a0 <__freertos_irq_stack_top+0xffffbe90>
f9000f14:	d14ff0ef          	jal	ra,f9000428 <print>
    println("");
f9000f18:	f9002537          	lui	a0,0xf9002
f9000f1c:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f9000f20:	d38ff0ef          	jal	ra,f9000458 <println>
}
f9000f24:	00c12083          	lw	ra,12(sp)
f9000f28:	00812403          	lw	s0,8(sp)
f9000f2c:	00412483          	lw	s1,4(sp)
f9000f30:	00012903          	lw	s2,0(sp)
f9000f34:	01010113          	addi	sp,sp,16
f9000f38:	00008067          	ret
    print(rb & (1<<8) ? " TX=ON" : " TX=OFF");
f9000f3c:	f9002537          	lui	a0,0xf9002
f9000f40:	98850513          	addi	a0,a0,-1656 # f9001988 <__freertos_irq_stack_top+0xffffbe78>
f9000f44:	fbdff06f          	j	f9000f00 <rtl_set_rgmii_delay+0x384>
    print(rb & (1<<3) ? " RX=ON" : " RX=OFF");
f9000f48:	f9002537          	lui	a0,0xf9002
f9000f4c:	99850513          	addi	a0,a0,-1640 # f9001998 <__freertos_irq_stack_top+0xffffbe88>
f9000f50:	fc5ff06f          	j	f9000f14 <rtl_set_rgmii_delay+0x398>

f9000f54 <eth_configure>:

// =============================================================================
// Configure Ethernet Bridge
// =============================================================================
void eth_configure(void) {
f9000f54:	ff010113          	addi	sp,sp,-16
f9000f58:	00112623          	sw	ra,12(sp)
    // Set source MAC address: 02:00:00:00:00:01 (locally administered)
    ETH_REG_MAC_ADDR_LO = 0x00000001;    // MAC[31:0]
f9000f5c:	f81027b7          	lui	a5,0xf8102
f9000f60:	00100713          	li	a4,1
f9000f64:	00e7ae23          	sw	a4,28(a5) # f810201c <__freertos_irq_stack_top+0xff0fc50c>
    ETH_REG_MAC_ADDR_HI = 0x00000200;    // MAC[47:32]
f9000f68:	20000713          	li	a4,512
f9000f6c:	02e7a023          	sw	a4,32(a5)
    
    // Set source IP: 192.168.1.2
    ETH_REG_IP_ADDR = 0xC0A80102;
f9000f70:	c0a80737          	lui	a4,0xc0a80
f9000f74:	10270693          	addi	a3,a4,258 # c0a80102 <__freertos_irq_stack_top+0xc7a7a5f2>
f9000f78:	02d7a223          	sw	a3,36(a5)
    
    // Set destination MAC: broadcast (FF:FF:FF:FF:FF:FF)
    // Or set to your PC's MAC for direct delivery
    ETH_REG_DEST_MAC_LO = 0xFFFFFFFF;
f9000f7c:	fff00693          	li	a3,-1
f9000f80:	02d7a423          	sw	a3,40(a5)
    ETH_REG_DEST_MAC_HI = 0x0000FFFF;
f9000f84:	000106b7          	lui	a3,0x10
f9000f88:	fff68693          	addi	a3,a3,-1 # ffff <__stack_size+0xbfff>
f9000f8c:	02d7a623          	sw	a3,44(a5)
    
    // Set destination IP: 192.168.1.1 (typical PC/gateway)
    ETH_REG_DEST_IP = 0xC0A80101;
f9000f90:	10170713          	addi	a4,a4,257
f9000f94:	02e7a823          	sw	a4,48(a5)
    
    // Set ports: src=5000, dest=5001
    ETH_REG_PORTS = (5001 << 16) | 5000;
f9000f98:	13891737          	lui	a4,0x13891
f9000f9c:	38870713          	addi	a4,a4,904 # 13891388 <__stack_size+0x1388d388>
f9000fa0:	02e7aa23          	sw	a4,52(a5)
    
    // Enable bridge and RX
    ETH_REG_CONTROL = CTRL_ENABLE | CTRL_RX_ENABLE;
f9000fa4:	00900713          	li	a4,9
f9000fa8:	00e7a023          	sw	a4,0(a5)
    
    println("ETH CFG OK");
f9000fac:	f9002537          	lui	a0,0xf9002
f9000fb0:	9b450513          	addi	a0,a0,-1612 # f90019b4 <__freertos_irq_stack_top+0xffffbea4>
f9000fb4:	ca4ff0ef          	jal	ra,f9000458 <println>
}
f9000fb8:	00c12083          	lw	ra,12(sp)
f9000fbc:	01010113          	addi	sp,sp,16
f9000fc0:	00008067          	ret

f9000fc4 <eth_send_udp_test>:

// =============================================================================
// Send UDP Test Packet
// =============================================================================
void eth_send_udp_test(uint16_t payload_len, uint32_t seq_num) {
f9000fc4:	ff010113          	addi	sp,sp,-16
f9000fc8:	00112623          	sw	ra,12(sp)
f9000fcc:	00812423          	sw	s0,8(sp)
f9000fd0:	00912223          	sw	s1,4(sp)
f9000fd4:	01212023          	sw	s2,0(sp)
f9000fd8:	00050493          	mv	s1,a0
f9000fdc:	00058913          	mv	s2,a1
    // Wait for TX ready
    int timeout = 1000;
f9000fe0:	3e800413          	li	s0,1000
    while ((ETH_REG_STATUS & STAT_TX_FIFO_FULL) && --timeout > 0) {
f9000fe4:	f81027b7          	lui	a5,0xf8102
f9000fe8:	0047a783          	lw	a5,4(a5) # f8102004 <__freertos_irq_stack_top+0xff0fc4f4>
f9000fec:	0107f793          	andi	a5,a5,16
f9000ff0:	02078263          	beqz	a5,f9001014 <eth_send_udp_test+0x50>
f9000ff4:	fff40413          	addi	s0,s0,-1
f9000ff8:	00805e63          	blez	s0,f9001014 <eth_send_udp_test+0x50>
        bsp_uDelay(10);
f9000ffc:	f8b00637          	lui	a2,0xf8b00
f9001000:	02faf5b7          	lui	a1,0x2faf
f9001004:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9001008:	00a00513          	li	a0,10
f900100c:	91cff0ef          	jal	ra,f9000128 <clint_uDelay>
f9001010:	fd5ff06f          	j	f9000fe4 <eth_send_udp_test+0x20>
    }
    
    if (timeout <= 0) {
f9001014:	04805863          	blez	s0,f9001064 <eth_send_udp_test+0xa0>
        return;
    }
    
    // Setting TX_UDP_LEN triggers header generation
    // The bridge will auto-build Ethernet+IP+UDP headers (42 bytes)
    ETH_REG_TX_UDP_LEN = payload_len;
f9001018:	f8102437          	lui	s0,0xf8102
f900101c:	00942c23          	sw	s1,24(s0) # f8102018 <__freertos_irq_stack_top+0xff0fc508>
    
    // Wait a bit for header generation
    bsp_uDelay(100);
f9001020:	f8b00637          	lui	a2,0xf8b00
f9001024:	02faf5b7          	lui	a1,0x2faf
f9001028:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f900102c:	06400513          	li	a0,100
f9001030:	8f8ff0ef          	jal	ra,f9000128 <clint_uDelay>
    
    // Write payload data to TX FIFO
    // First 4 bytes: sequence number (for packet loss detection)
    ETH_REG_TX_DATA = (seq_num >> 24) & 0xFF;
f9001034:	01895793          	srli	a5,s2,0x18
f9001038:	00f42423          	sw	a5,8(s0)
    ETH_REG_TX_DATA = (seq_num >> 16) & 0xFF;
f900103c:	01095793          	srli	a5,s2,0x10
f9001040:	0ff7f793          	andi	a5,a5,255
f9001044:	00f42423          	sw	a5,8(s0)
    ETH_REG_TX_DATA = (seq_num >> 8) & 0xFF;
f9001048:	00895793          	srli	a5,s2,0x8
f900104c:	0ff7f793          	andi	a5,a5,255
f9001050:	00f42423          	sw	a5,8(s0)
    ETH_REG_TX_DATA = seq_num & 0xFF;
f9001054:	0ff97913          	andi	s2,s2,255
f9001058:	01242423          	sw	s2,8(s0)
    
    // Fill rest with test pattern
    for (int i = 4; i < payload_len; i++) {
f900105c:	00400793          	li	a5,4
f9001060:	0240006f          	j	f9001084 <eth_send_udp_test+0xc0>
        println("TX FULL!");
f9001064:	f9002537          	lui	a0,0xf9002
f9001068:	9c050513          	addi	a0,a0,-1600 # f90019c0 <__freertos_irq_stack_top+0xffffbeb0>
f900106c:	becff0ef          	jal	ra,f9000458 <println>
        return;
f9001070:	0680006f          	j	f90010d8 <eth_send_udp_test+0x114>
        ETH_REG_TX_DATA = (i & 0xFF);
f9001074:	0ff7f693          	andi	a3,a5,255
f9001078:	f8102737          	lui	a4,0xf8102
f900107c:	00d72423          	sw	a3,8(a4) # f8102008 <__freertos_irq_stack_top+0xff0fc4f8>
    for (int i = 4; i < payload_len; i++) {
f9001080:	00178793          	addi	a5,a5,1
f9001084:	fe97c8e3          	blt	a5,s1,f9001074 <eth_send_udp_test+0xb0>
    }
    
    // Start transmission
    ETH_REG_CONTROL = CTRL_ENABLE | CTRL_RX_ENABLE | CTRL_TX_START;
f9001088:	f81027b7          	lui	a5,0xf8102
f900108c:	00b00713          	li	a4,11
f9001090:	00e7a023          	sw	a4,0(a5) # f8102000 <__freertos_irq_stack_top+0xff0fc4f0>
    
    // Wait for TX done
    timeout = 10000;
f9001094:	00002437          	lui	s0,0x2
f9001098:	71040413          	addi	s0,s0,1808 # 2710 <CUSTOM2+0x26b5>
    while (!(ETH_REG_STATUS & STAT_TX_DONE) && --timeout > 0) {
f900109c:	f81027b7          	lui	a5,0xf8102
f90010a0:	0047a783          	lw	a5,4(a5) # f8102004 <__freertos_irq_stack_top+0xff0fc4f4>
f90010a4:	0027f793          	andi	a5,a5,2
f90010a8:	02079263          	bnez	a5,f90010cc <eth_send_udp_test+0x108>
f90010ac:	fff40413          	addi	s0,s0,-1
f90010b0:	00805e63          	blez	s0,f90010cc <eth_send_udp_test+0x108>
        bsp_uDelay(1);
f90010b4:	f8b00637          	lui	a2,0xf8b00
f90010b8:	02faf5b7          	lui	a1,0x2faf
f90010bc:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f90010c0:	00100513          	li	a0,1
f90010c4:	864ff0ef          	jal	ra,f9000128 <clint_uDelay>
f90010c8:	fd5ff06f          	j	f900109c <eth_send_udp_test+0xd8>
    }
    
    // Clear TX_DONE sticky bit
    ETH_REG_STATUS = STAT_TX_DONE;
f90010cc:	f81027b7          	lui	a5,0xf8102
f90010d0:	00200713          	li	a4,2
f90010d4:	00e7a223          	sw	a4,4(a5) # f8102004 <__freertos_irq_stack_top+0xff0fc4f4>
}
f90010d8:	00c12083          	lw	ra,12(sp)
f90010dc:	00812403          	lw	s0,8(sp)
f90010e0:	00412483          	lw	s1,4(sp)
f90010e4:	00012903          	lw	s2,0(sp)
f90010e8:	01010113          	addi	sp,sp,16
f90010ec:	00008067          	ret

f90010f0 <main>:

// =============================================================================
// Main Entry Point
// =============================================================================
void main(void)
{
f90010f0:	fc010113          	addi	sp,sp,-64
f90010f4:	02112e23          	sw	ra,60(sp)
f90010f8:	02812c23          	sw	s0,56(sp)
f90010fc:	02912a23          	sw	s1,52(sp)
f9001100:	03212823          	sw	s2,48(sp)
f9001104:	03312623          	sw	s3,44(sp)
    bsp_init();
f9001108:	854ff0ef          	jal	ra,f900015c <bsp_init>
f900110c:	f800d7b7          	lui	a5,0xf800d
f9001110:	00100713          	li	a4,1
f9001114:	00e7a423          	sw	a4,8(a5) # f800d008 <__freertos_irq_stack_top+0xff0074f8>
f9001118:	0007a223          	sw	zero,4(a5)
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x1);
    gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x0);

    // Phase 1: LED blink (3x fast)
    for (int i = 0; i < 3; i++) {
f900111c:	00000413          	li	s0,0
f9001120:	00200793          	li	a5,2
f9001124:	0087ca63          	blt	a5,s0,f9001138 <main+0x48>
        led_pulse(200);
f9001128:	0c800513          	li	a0,200
f900112c:	a68ff0ef          	jal	ra,f9000394 <led_pulse>
    for (int i = 0; i < 3; i++) {
f9001130:	00140413          	addi	s0,s0,1
f9001134:	fedff06f          	j	f9001120 <main+0x30>
    }

    println("==1G UDP Test==");
f9001138:	f9002537          	lui	a0,0xf9002
f900113c:	9e850513          	addi	a0,a0,-1560 # f90019e8 <__freertos_irq_stack_top+0xffffbed8>
f9001140:	b18ff0ef          	jal	ra,f9000458 <println>

    // Phase 2: HW reset PHY
    print("HW RST...");
f9001144:	f9002537          	lui	a0,0xf9002
f9001148:	9f850513          	addi	a0,a0,-1544 # f90019f8 <__freertos_irq_stack_top+0xffffbee8>
f900114c:	adcff0ef          	jal	ra,f9000428 <print>
    uart_drain();
f9001150:	aa0ff0ef          	jal	ra,f90003f0 <uart_drain>
    *reg = val;
f9001154:	f81014b7          	lui	s1,0xf8101
f9001158:	0004a423          	sw	zero,8(s1) # f8101008 <__freertos_irq_stack_top+0xff0fb4f8>
    mdio_phy_reset_assert();
    bsp_uDelay(50000);
f900115c:	f8b00637          	lui	a2,0xf8b00
f9001160:	02faf437          	lui	s0,0x2faf
f9001164:	08040593          	addi	a1,s0,128 # 2faf080 <__stack_size+0x2fab080>
f9001168:	0000c537          	lui	a0,0xc
f900116c:	35050513          	addi	a0,a0,848 # c350 <__stack_size+0x8350>
f9001170:	fb9fe0ef          	jal	ra,f9000128 <clint_uDelay>
f9001174:	00100793          	li	a5,1
f9001178:	00f4a423          	sw	a5,8(s1)
    mdio_phy_reset_release();
    bsp_uDelay(300000);
f900117c:	f8b00637          	lui	a2,0xf8b00
f9001180:	08040593          	addi	a1,s0,128
f9001184:	00049537          	lui	a0,0x49
f9001188:	3e050513          	addi	a0,a0,992 # 493e0 <__stack_size+0x453e0>
f900118c:	f9dfe0ef          	jal	ra,f9000128 <clint_uDelay>
    println(" OK");
f9001190:	f9002537          	lui	a0,0xf9002
f9001194:	a0450513          	addi	a0,a0,-1532 # f9001a04 <__freertos_irq_stack_top+0xffffbef4>
f9001198:	ac0ff0ef          	jal	ra,f9000458 <println>

    // Phase 3: Quick ID check
    uint16_t id1 = mdio_read(0x01, PHY_REG_PHYID1);
f900119c:	00200593          	li	a1,2
f90011a0:	00100513          	li	a0,1
f90011a4:	87cff0ef          	jal	ra,f9000220 <mdio_read>
f90011a8:	00050493          	mv	s1,a0
    uint16_t id2 = mdio_read(0x01, PHY_REG_PHYID2);
f90011ac:	00300593          	li	a1,3
f90011b0:	00100513          	li	a0,1
f90011b4:	86cff0ef          	jal	ra,f9000220 <mdio_read>
f90011b8:	00050413          	mv	s0,a0
    print("ID="); print_hex16(id1); print("/"); print_hex16(id2); println("");
f90011bc:	f9002537          	lui	a0,0xf9002
f90011c0:	a0850513          	addi	a0,a0,-1528 # f9001a08 <__freertos_irq_stack_top+0xffffbef8>
f90011c4:	a64ff0ef          	jal	ra,f9000428 <print>
f90011c8:	00048513          	mv	a0,s1
f90011cc:	ae0ff0ef          	jal	ra,f90004ac <print_hex16>
f90011d0:	f9002537          	lui	a0,0xf9002
f90011d4:	a0c50513          	addi	a0,a0,-1524 # f9001a0c <__freertos_irq_stack_top+0xffffbefc>
f90011d8:	a50ff0ef          	jal	ra,f9000428 <print>
f90011dc:	00040513          	mv	a0,s0
f90011e0:	accff0ef          	jal	ra,f90004ac <print_hex16>
f90011e4:	f90024b7          	lui	s1,0xf9002
f90011e8:	9c848513          	addi	a0,s1,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f90011ec:	a6cff0ef          	jal	ra,f9000458 <println>
    uint16_t bmsr, physr;
    
    // =========================================================================
    // Phase 4: Configure RGMII delay for 1Gbit
    // =========================================================================
    println("=RGMII DLY=");
f90011f0:	f9002537          	lui	a0,0xf9002
f90011f4:	a1050513          	addi	a0,a0,-1520 # f9001a10 <__freertos_irq_stack_top+0xffffbf00>
f90011f8:	a60ff0ef          	jal	ra,f9000458 <println>
    // Enable both TX and RX 2ns internal delays in the PHY
    // With equal-length PCB traces, both delays are needed for proper RGMII timing
    rtl_set_rgmii_delay(phy, 1, 1);  // TX delay=ON, RX delay=ON
f90011fc:	00100613          	li	a2,1
f9001200:	00100593          	li	a1,1
f9001204:	00100513          	li	a0,1
f9001208:	975ff0ef          	jal	ra,f9000b7c <rtl_set_rgmii_delay>
    
    // =========================================================================
    // Phase 5: Disable Green Ethernet (can interfere with 1Gbit)
    // =========================================================================
    println("=DIS GREEN=");
f900120c:	f9002537          	lui	a0,0xf9002
f9001210:	a1c50513          	addi	a0,a0,-1508 # f9001a1c <__freertos_irq_stack_top+0xffffbf0c>
f9001214:	a44ff0ef          	jal	ra,f9000458 <println>
    mdio_write(phy, 0x1F, 0x0a43);
f9001218:	00001437          	lui	s0,0x1
f900121c:	a4340613          	addi	a2,s0,-1469 # a43 <CUSTOM2+0x9e8>
f9001220:	01f00593          	li	a1,31
f9001224:	00100513          	li	a0,1
f9001228:	8b4ff0ef          	jal	ra,f90002dc <mdio_write>
    mdio_write(phy, 0x1B, 0x8011);
f900122c:	00008637          	lui	a2,0x8
f9001230:	01160613          	addi	a2,a2,17 # 8011 <__stack_size+0x4011>
f9001234:	01b00593          	li	a1,27
f9001238:	00100513          	li	a0,1
f900123c:	8a0ff0ef          	jal	ra,f90002dc <mdio_write>
    uint16_t r27 = mdio_read(phy, 0x1B);
f9001240:	01b00593          	li	a1,27
f9001244:	00100513          	li	a0,1
f9001248:	fd9fe0ef          	jal	ra,f9000220 <mdio_read>
f900124c:	00050993          	mv	s3,a0
    mdio_write(phy, 0x1C, 0x573F);
f9001250:	00005637          	lui	a2,0x5
f9001254:	73f60613          	addi	a2,a2,1855 # 573f <__stack_size+0x173f>
f9001258:	01c00593          	li	a1,28
f900125c:	00100513          	li	a0,1
f9001260:	87cff0ef          	jal	ra,f90002dc <mdio_write>
    uint16_t r28 = mdio_read(phy, 0x1C);
f9001264:	01c00593          	li	a1,28
f9001268:	00100513          	li	a0,1
f900126c:	fb5fe0ef          	jal	ra,f9000220 <mdio_read>
f9001270:	00050913          	mv	s2,a0
    mdio_write(phy, 0x1F, 0x0000);
f9001274:	00000613          	li	a2,0
f9001278:	01f00593          	li	a1,31
f900127c:	00100513          	li	a0,1
f9001280:	85cff0ef          	jal	ra,f90002dc <mdio_write>
    print("R27="); print_hex16(r27); print(" R28="); print_hex16(r28); println("");
f9001284:	f9002537          	lui	a0,0xf9002
f9001288:	a2850513          	addi	a0,a0,-1496 # f9001a28 <__freertos_irq_stack_top+0xffffbf18>
f900128c:	99cff0ef          	jal	ra,f9000428 <print>
f9001290:	00098513          	mv	a0,s3
f9001294:	a18ff0ef          	jal	ra,f90004ac <print_hex16>
f9001298:	f9002537          	lui	a0,0xf9002
f900129c:	a3050513          	addi	a0,a0,-1488 # f9001a30 <__freertos_irq_stack_top+0xffffbf20>
f90012a0:	988ff0ef          	jal	ra,f9000428 <print>
f90012a4:	00090513          	mv	a0,s2
f90012a8:	a04ff0ef          	jal	ra,f90004ac <print_hex16>
f90012ac:	9c848513          	addi	a0,s1,-1592
f90012b0:	9a8ff0ef          	jal	ra,f9000458 <println>
    
    // =========================================================================
    // Phase 6: Force 1Gbit Full Duplex Auto-Negotiation
    // =========================================================================
    println("=1G AN=");
f90012b4:	f9002537          	lui	a0,0xf9002
f90012b8:	a3850513          	addi	a0,a0,-1480 # f9001a38 <__freertos_irq_stack_top+0xffffbf28>
f90012bc:	99cff0ef          	jal	ra,f9000458 <println>
    
    // Enable 1000BASE-T Full Duplex advertisement
    mdio_write(phy, PHY_REG_GBCR, 0x0200);   // Advertise 1000M FD only
f90012c0:	20000613          	li	a2,512
f90012c4:	00900593          	li	a1,9
f90012c8:	00100513          	li	a0,1
f90012cc:	810ff0ef          	jal	ra,f90002dc <mdio_write>
    mdio_write(phy, PHY_REG_ANAR, 0x0001);   // Don't advertise 10/100
f90012d0:	00100613          	li	a2,1
f90012d4:	00400593          	li	a1,4
f90012d8:	00100513          	li	a0,1
f90012dc:	800ff0ef          	jal	ra,f90002dc <mdio_write>
    
    // Restart auto-negotiation
    mdio_write(phy, PHY_REG_BMCR, 0x1200);   // AN enable + restart
f90012e0:	20040613          	addi	a2,s0,512
f90012e4:	00000593          	li	a1,0
f90012e8:	00100513          	li	a0,1
f90012ec:	ff1fe0ef          	jal	ra,f90002dc <mdio_write>
    
    print("Wait");
f90012f0:	f9002537          	lui	a0,0xf9002
f90012f4:	a4050513          	addi	a0,a0,-1472 # f9001a40 <__freertos_irq_stack_top+0xffffbf30>
f90012f8:	930ff0ef          	jal	ra,f9000428 <print>
    uart_drain();
f90012fc:	8f4ff0ef          	jal	ra,f90003f0 <uart_drain>
    
    int linked = 0;
    for (int i = 0; i < 15; i++) {
f9001300:	00000413          	li	s0,0
f9001304:	0180006f          	j	f900131c <main+0x22c>
        bmsr = bmsr_read(phy);
        if ((bmsr & BMSR_LINK_STATUS) && (bmsr & BMSR_AN_COMPLETE)) {
            linked = 1;
            break;
        }
        print("."); uart_drain();
f9001308:	f9002537          	lui	a0,0xf9002
f900130c:	a0050513          	addi	a0,a0,-1536 # f9001a00 <__freertos_irq_stack_top+0xffffbef0>
f9001310:	918ff0ef          	jal	ra,f9000428 <print>
f9001314:	8dcff0ef          	jal	ra,f90003f0 <uart_drain>
    for (int i = 0; i < 15; i++) {
f9001318:	00140413          	addi	s0,s0,1
f900131c:	00e00793          	li	a5,14
f9001320:	0287cc63          	blt	a5,s0,f9001358 <main+0x268>
        bsp_uDelay(1000000);  // 1 second
f9001324:	f8b00637          	lui	a2,0xf8b00
f9001328:	02faf5b7          	lui	a1,0x2faf
f900132c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9001330:	000f4537          	lui	a0,0xf4
f9001334:	24050513          	addi	a0,a0,576 # f4240 <__stack_size+0xf0240>
f9001338:	df1fe0ef          	jal	ra,f9000128 <clint_uDelay>
        bmsr = bmsr_read(phy);
f900133c:	00100513          	li	a0,1
f9001340:	d10ff0ef          	jal	ra,f9000850 <bmsr_read>
        if ((bmsr & BMSR_LINK_STATUS) && (bmsr & BMSR_AN_COMPLETE)) {
f9001344:	02457513          	andi	a0,a0,36
f9001348:	02400793          	li	a5,36
f900134c:	faf51ee3          	bne	a0,a5,f9001308 <main+0x218>
            linked = 1;
f9001350:	00100493          	li	s1,1
f9001354:	0080006f          	j	f900135c <main+0x26c>
    int linked = 0;
f9001358:	00000493          	li	s1,0
    }
    println("");
f900135c:	f9002537          	lui	a0,0xf9002
f9001360:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f9001364:	8f4ff0ef          	jal	ra,f9000458 <println>
    
    bmsr = bmsr_read(phy);
f9001368:	00100513          	li	a0,1
f900136c:	ce4ff0ef          	jal	ra,f9000850 <bmsr_read>
f9001370:	00050993          	mv	s3,a0
    physr = rtl_physr(phy);
f9001374:	00100513          	li	a0,1
f9001378:	e1cff0ef          	jal	ra,f9000994 <rtl_physr>
f900137c:	00050913          	mv	s2,a0
    
    print("BMSR="); print_hex16(bmsr);
f9001380:	f9002537          	lui	a0,0xf9002
f9001384:	a4850513          	addi	a0,a0,-1464 # f9001a48 <__freertos_irq_stack_top+0xffffbf38>
f9001388:	8a0ff0ef          	jal	ra,f9000428 <print>
f900138c:	00098513          	mv	a0,s3
f9001390:	91cff0ef          	jal	ra,f90004ac <print_hex16>
    print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DN");
f9001394:	0049f793          	andi	a5,s3,4
f9001398:	10078e63          	beqz	a5,f90014b4 <main+0x3c4>
f900139c:	f9002537          	lui	a0,0xf9002
f90013a0:	9d050513          	addi	a0,a0,-1584 # f90019d0 <__freertos_irq_stack_top+0xffffbec0>
f90013a4:	884ff0ef          	jal	ra,f9000428 <print>
    print((bmsr & BMSR_AN_COMPLETE) ? " AN" : " noAN");
f90013a8:	0209f793          	andi	a5,s3,32
f90013ac:	10078a63          	beqz	a5,f90014c0 <main+0x3d0>
f90013b0:	f9002537          	lui	a0,0xf9002
f90013b4:	9dc50513          	addi	a0,a0,-1572 # f90019dc <__freertos_irq_stack_top+0xffffbecc>
f90013b8:	870ff0ef          	jal	ra,f9000428 <print>
    println("");
f90013bc:	f9002537          	lui	a0,0xf9002
f90013c0:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f90013c4:	894ff0ef          	jal	ra,f9000458 <println>
    
    print("PHSR="); print_hex16(physr);
f90013c8:	f9002537          	lui	a0,0xf9002
f90013cc:	a5050513          	addi	a0,a0,-1456 # f9001a50 <__freertos_irq_stack_top+0xffffbf40>
f90013d0:	858ff0ef          	jal	ra,f9000428 <print>
f90013d4:	00090513          	mv	a0,s2
f90013d8:	8d4ff0ef          	jal	ra,f90004ac <print_hex16>
    uint16_t spd = (physr >> 4) & 0x3;
f90013dc:	00495413          	srli	s0,s2,0x4
f90013e0:	00347413          	andi	s0,s0,3
    if (spd == 0) print(" 10M");
f90013e4:	0e040463          	beqz	s0,f90014cc <main+0x3dc>
    else if (spd == 1) print(" 100M");
f90013e8:	00100793          	li	a5,1
f90013ec:	0ef40863          	beq	s0,a5,f90014dc <main+0x3ec>
    else if (spd == 2) print(" 1000M");
f90013f0:	00200793          	li	a5,2
f90013f4:	0ef40c63          	beq	s0,a5,f90014ec <main+0x3fc>
    print((physr & 0x08) ? " FD" : " HD");
f90013f8:	00897913          	andi	s2,s2,8
f90013fc:	10090063          	beqz	s2,f90014fc <main+0x40c>
f9001400:	f9002537          	lui	a0,0xf9002
f9001404:	9e450513          	addi	a0,a0,-1564 # f90019e4 <__freertos_irq_stack_top+0xffffbed4>
f9001408:	820ff0ef          	jal	ra,f9000428 <print>
    println("");
f900140c:	f9002537          	lui	a0,0xf9002
f9001410:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f9001414:	844ff0ef          	jal	ra,f9000458 <println>
    
    if (!linked || spd != 2) {
f9001418:	00048663          	beqz	s1,f9001424 <main+0x334>
f900141c:	00200793          	li	a5,2
f9001420:	0ef40463          	beq	s0,a5,f9001508 <main+0x418>
        println("NOT 1G!");
f9001424:	f9002537          	lui	a0,0xf9002
f9001428:	a7050513          	addi	a0,a0,-1424 # f9001a70 <__freertos_irq_stack_top+0xffffbf60>
f900142c:	82cff0ef          	jal	ra,f9000458 <println>
        println("Check CLKOUT (R47)");
f9001430:	f9002537          	lui	a0,0xf9002
f9001434:	a7850513          	addi	a0,a0,-1416 # f9001a78 <__freertos_irq_stack_top+0xffffbf68>
f9001438:	820ff0ef          	jal	ra,f9000458 <println>
    }
    
    // =========================================================================
    // Phase 7: Configure Ethernet Bridge
    // =========================================================================
    println("=ETH CFG=");
f900143c:	f9002537          	lui	a0,0xf9002
f9001440:	aa050513          	addi	a0,a0,-1376 # f9001aa0 <__freertos_irq_stack_top+0xffffbf90>
f9001444:	814ff0ef          	jal	ra,f9000458 <println>
    eth_configure();
f9001448:	b0dff0ef          	jal	ra,f9000f54 <eth_configure>
    
    uint32_t status = ETH_REG_STATUS;
f900144c:	f81027b7          	lui	a5,0xf8102
f9001450:	0047a403          	lw	s0,4(a5) # f8102004 <__freertos_irq_stack_top+0xff0fc4f4>
    print("STS="); print_hex32(status); println("");
f9001454:	f9002537          	lui	a0,0xf9002
f9001458:	aac50513          	addi	a0,a0,-1364 # f9001aac <__freertos_irq_stack_top+0xffffbf9c>
f900145c:	fcdfe0ef          	jal	ra,f9000428 <print>
f9001460:	00040513          	mv	a0,s0
f9001464:	990ff0ef          	jal	ra,f90005f4 <print_hex32>
f9001468:	f9002537          	lui	a0,0xf9002
f900146c:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f9001470:	fe9fe0ef          	jal	ra,f9000458 <println>
    
    // =========================================================================
    // Phase 8: Send UDP Test Packets
    // =========================================================================
    println("=UDP TX=");
f9001474:	f9002537          	lui	a0,0xf9002
f9001478:	ab450513          	addi	a0,a0,-1356 # f9001ab4 <__freertos_irq_stack_top+0xffffbfa4>
f900147c:	fddfe0ef          	jal	ra,f9000458 <println>
    uint32_t seq = 0;
    int burst_size = 10;  // Send 10 packets per burst
    uint16_t payload_size = 100;  // 100 bytes per packet
    
    // Send initial burst
    for (int i = 0; i < burst_size; i++) {
f9001480:	00000413          	li	s0,0
    uint32_t seq = 0;
f9001484:	00000913          	li	s2,0
    for (int i = 0; i < burst_size; i++) {
f9001488:	00900793          	li	a5,9
f900148c:	0887c663          	blt	a5,s0,f9001518 <main+0x428>
        eth_send_udp_test(payload_size, seq++);
f9001490:	00190493          	addi	s1,s2,1
f9001494:	00090593          	mv	a1,s2
f9001498:	06400513          	li	a0,100
f900149c:	b29ff0ef          	jal	ra,f9000fc4 <eth_send_udp_test>
        led_pulse(10);
f90014a0:	00a00513          	li	a0,10
f90014a4:	ef1fe0ef          	jal	ra,f9000394 <led_pulse>
    for (int i = 0; i < burst_size; i++) {
f90014a8:	00140413          	addi	s0,s0,1
        eth_send_udp_test(payload_size, seq++);
f90014ac:	00048913          	mv	s2,s1
f90014b0:	fd9ff06f          	j	f9001488 <main+0x398>
    print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DN");
f90014b4:	f9002537          	lui	a0,0xf9002
f90014b8:	9cc50513          	addi	a0,a0,-1588 # f90019cc <__freertos_irq_stack_top+0xffffbebc>
f90014bc:	ee9ff06f          	j	f90013a4 <main+0x2b4>
    print((bmsr & BMSR_AN_COMPLETE) ? " AN" : " noAN");
f90014c0:	f9002537          	lui	a0,0xf9002
f90014c4:	9d450513          	addi	a0,a0,-1580 # f90019d4 <__freertos_irq_stack_top+0xffffbec4>
f90014c8:	ef1ff06f          	j	f90013b8 <main+0x2c8>
    if (spd == 0) print(" 10M");
f90014cc:	f9002537          	lui	a0,0xf9002
f90014d0:	a5850513          	addi	a0,a0,-1448 # f9001a58 <__freertos_irq_stack_top+0xffffbf48>
f90014d4:	f55fe0ef          	jal	ra,f9000428 <print>
f90014d8:	f21ff06f          	j	f90013f8 <main+0x308>
    else if (spd == 1) print(" 100M");
f90014dc:	f9002537          	lui	a0,0xf9002
f90014e0:	a6050513          	addi	a0,a0,-1440 # f9001a60 <__freertos_irq_stack_top+0xffffbf50>
f90014e4:	f45fe0ef          	jal	ra,f9000428 <print>
f90014e8:	f11ff06f          	j	f90013f8 <main+0x308>
    else if (spd == 2) print(" 1000M");
f90014ec:	f9002537          	lui	a0,0xf9002
f90014f0:	a6850513          	addi	a0,a0,-1432 # f9001a68 <__freertos_irq_stack_top+0xffffbf58>
f90014f4:	f35fe0ef          	jal	ra,f9000428 <print>
f90014f8:	f01ff06f          	j	f90013f8 <main+0x308>
    print((physr & 0x08) ? " FD" : " HD");
f90014fc:	f9002537          	lui	a0,0xf9002
f9001500:	9e050513          	addi	a0,a0,-1568 # f90019e0 <__freertos_irq_stack_top+0xffffbed0>
f9001504:	f05ff06f          	j	f9001408 <main+0x318>
        println("** 1G LINK OK **");
f9001508:	f9002537          	lui	a0,0xf9002
f900150c:	a8c50513          	addi	a0,a0,-1396 # f9001a8c <__freertos_irq_stack_top+0xffffbf7c>
f9001510:	f49fe0ef          	jal	ra,f9000458 <println>
f9001514:	f29ff06f          	j	f900143c <main+0x34c>
    }
    
    print("Sent "); uart_mini_print_hex16(burst_size); println(" pkts");
f9001518:	f9002537          	lui	a0,0xf9002
f900151c:	ac050513          	addi	a0,a0,-1344 # f9001ac0 <__freertos_irq_stack_top+0xffffbfb0>
f9001520:	f09fe0ef          	jal	ra,f9000428 <print>
    uart_mini_print_hex8((val >> 8) & 0xFF);
f9001524:	00000513          	li	a0,0
f9001528:	c6dfe0ef          	jal	ra,f9000194 <uart_mini_print_hex8>
    uart_mini_print_hex8(val & 0xFF);
f900152c:	00a00513          	li	a0,10
f9001530:	c65fe0ef          	jal	ra,f9000194 <uart_mini_print_hex8>
f9001534:	f9002537          	lui	a0,0xf9002
f9001538:	ac850513          	addi	a0,a0,-1336 # f9001ac8 <__freertos_irq_stack_top+0xffffbfb8>
f900153c:	f1dfe0ef          	jal	ra,f9000458 <println>
    
    // =========================================================================
    // Phase 9: Continuous TX/Monitor Loop
    // =========================================================================
    println("=MONITOR=");
f9001540:	f9002537          	lui	a0,0xf9002
f9001544:	ad050513          	addi	a0,a0,-1328 # f9001ad0 <__freertos_irq_stack_top+0xffffbfc0>
f9001548:	f11fe0ef          	jal	ra,f9000458 <println>
    println("PC: nc -ul 5001");
f900154c:	f9002537          	lui	a0,0xf9002
f9001550:	adc50513          	addi	a0,a0,-1316 # f9001adc <__freertos_irq_stack_top+0xffffbfcc>
f9001554:	f05fe0ef          	jal	ra,f9000458 <println>
    
    int loop = 0;
f9001558:	00000493          	li	s1,0
f900155c:	3dc0006f          	j	f9001938 <main+0x848>
    
    while (1) {
        // Check link status
        bmsr = bmsr_read(phy);
        if (bmsr != last_bmsr) {
            print("BMSR="); print_hex16(bmsr);
f9001560:	f9002537          	lui	a0,0xf9002
f9001564:	a4850513          	addi	a0,a0,-1464 # f9001a48 <__freertos_irq_stack_top+0xffffbf38>
f9001568:	ec1fe0ef          	jal	ra,f9000428 <print>
f900156c:	00040513          	mv	a0,s0
f9001570:	f3dfe0ef          	jal	ra,f90004ac <print_hex16>
            print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DN");
f9001574:	00447793          	andi	a5,s0,4
f9001578:	02078263          	beqz	a5,f900159c <main+0x4ac>
f900157c:	f9002537          	lui	a0,0xf9002
f9001580:	9d050513          	addi	a0,a0,-1584 # f90019d0 <__freertos_irq_stack_top+0xffffbec0>
f9001584:	ea5fe0ef          	jal	ra,f9000428 <print>
            println("");
f9001588:	f9002537          	lui	a0,0xf9002
f900158c:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f9001590:	ec9fe0ef          	jal	ra,f9000458 <println>
            last_bmsr = bmsr;
f9001594:	00040993          	mv	s3,s0
f9001598:	3b00006f          	j	f9001948 <main+0x858>
            print((bmsr & BMSR_LINK_STATUS) ? " UP" : " DN");
f900159c:	f9002537          	lui	a0,0xf9002
f90015a0:	9cc50513          	addi	a0,a0,-1588 # f90019cc <__freertos_irq_stack_top+0xffffbebc>
f90015a4:	fe1ff06f          	j	f9001584 <main+0x494>
        // Send a packet every second when link is up
        if (bmsr & BMSR_LINK_STATUS) {
            eth_send_udp_test(payload_size, seq++);
            led_on();
        } else {
            led_off();
f90015a8:	de1fe0ef          	jal	ra,f9000388 <led_off>
        }
        
        // Print stats every 10 seconds
        if ((loop % 10) == 0) {
f90015ac:	00a00793          	li	a5,10
f90015b0:	02f4e7b3          	rem	a5,s1,a5
f90015b4:	36079263          	bnez	a5,f9001918 <main+0x828>
            uint32_t cnt = ETH_REG_FRAME_CNT;
f90015b8:	f81027b7          	lui	a5,0xf8102
f90015bc:	0387a403          	lw	s0,56(a5) # f8102038 <__freertos_irq_stack_top+0xff0fc528>
            print("["); uart_mini_print_hex16(loop);
f90015c0:	f9002537          	lui	a0,0xf9002
f90015c4:	aec50513          	addi	a0,a0,-1300 # f9001aec <__freertos_irq_stack_top+0xffffbfdc>
f90015c8:	e61fe0ef          	jal	ra,f9000428 <print>
f90015cc:	01049793          	slli	a5,s1,0x10
f90015d0:	0107d793          	srli	a5,a5,0x10
    uart_mini_print_hex8((val >> 8) & 0xFF);
f90015d4:	0087d793          	srli	a5,a5,0x8
    const char hex[] = "0123456789ABCDEF";
f90015d8:	f9002737          	lui	a4,0xf9002
f90015dc:	97070713          	addi	a4,a4,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f90015e0:	00072503          	lw	a0,0(a4)
f90015e4:	00472583          	lw	a1,4(a4)
f90015e8:	00872603          	lw	a2,8(a4)
f90015ec:	00c72683          	lw	a3,12(a4)
f90015f0:	00a12623          	sw	a0,12(sp)
f90015f4:	00b12823          	sw	a1,16(sp)
f90015f8:	00c12a23          	sw	a2,20(sp)
f90015fc:	00d12c23          	sw	a3,24(sp)
f9001600:	01074703          	lbu	a4,16(a4)
f9001604:	00e10e23          	sb	a4,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f9001608:	0047d713          	srli	a4,a5,0x4
f900160c:	02010693          	addi	a3,sp,32
f9001610:	00e68733          	add	a4,a3,a4
f9001614:	fec74683          	lbu	a3,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f9001618:	f8100737          	lui	a4,0xf8100
f900161c:	00472703          	lw	a4,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001620:	00277713          	andi	a4,a4,2
    if (!uart_mini_tx_ready())
f9001624:	fe071ae3          	bnez	a4,f9001618 <main+0x528>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001628:	f8100737          	lui	a4,0xf8100
f900162c:	00d72423          	sw	a3,8(a4) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f9001630:	00f7f793          	andi	a5,a5,15
f9001634:	02010713          	addi	a4,sp,32
f9001638:	00f707b3          	add	a5,a4,a5
f900163c:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9001640:	f81007b7          	lui	a5,0xf8100
f9001644:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001648:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900164c:	fe079ae3          	bnez	a5,f9001640 <main+0x550>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001650:	f81007b7          	lui	a5,0xf8100
f9001654:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_print_hex8(val & 0xFF);
f9001658:	0ff4f713          	andi	a4,s1,255
    const char hex[] = "0123456789ABCDEF";
f900165c:	f90027b7          	lui	a5,0xf9002
f9001660:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f9001664:	0007a503          	lw	a0,0(a5)
f9001668:	0047a583          	lw	a1,4(a5)
f900166c:	0087a603          	lw	a2,8(a5)
f9001670:	00c7a683          	lw	a3,12(a5)
f9001674:	00a12623          	sw	a0,12(sp)
f9001678:	00b12823          	sw	a1,16(sp)
f900167c:	00c12a23          	sw	a2,20(sp)
f9001680:	00d12c23          	sw	a3,24(sp)
f9001684:	0107c783          	lbu	a5,16(a5)
f9001688:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f900168c:	00475793          	srli	a5,a4,0x4
f9001690:	02010693          	addi	a3,sp,32
f9001694:	00f687b3          	add	a5,a3,a5
f9001698:	fec7c683          	lbu	a3,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f900169c:	f81007b7          	lui	a5,0xf8100
f90016a0:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90016a4:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90016a8:	fe079ae3          	bnez	a5,f900169c <main+0x5ac>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90016ac:	f81007b7          	lui	a5,0xf8100
f90016b0:	00d7a423          	sw	a3,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f90016b4:	00f77713          	andi	a4,a4,15
f90016b8:	02010793          	addi	a5,sp,32
f90016bc:	00e78733          	add	a4,a5,a4
f90016c0:	fec74703          	lbu	a4,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f90016c4:	f81007b7          	lui	a5,0xf8100
f90016c8:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90016cc:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90016d0:	fe079ae3          	bnez	a5,f90016c4 <main+0x5d4>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90016d4:	f81007b7          	lui	a5,0xf8100
f90016d8:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
            print("] TX="); uart_mini_print_hex16(cnt & 0xFFFF);
f90016dc:	f9002537          	lui	a0,0xf9002
f90016e0:	af050513          	addi	a0,a0,-1296 # f9001af0 <__freertos_irq_stack_top+0xffffbfe0>
f90016e4:	d45fe0ef          	jal	ra,f9000428 <print>
f90016e8:	01041793          	slli	a5,s0,0x10
f90016ec:	0107d793          	srli	a5,a5,0x10
    uart_mini_print_hex8((val >> 8) & 0xFF);
f90016f0:	0087d793          	srli	a5,a5,0x8
    const char hex[] = "0123456789ABCDEF";
f90016f4:	f9002737          	lui	a4,0xf9002
f90016f8:	97070713          	addi	a4,a4,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f90016fc:	00072503          	lw	a0,0(a4)
f9001700:	00472583          	lw	a1,4(a4)
f9001704:	00872603          	lw	a2,8(a4)
f9001708:	00c72683          	lw	a3,12(a4)
f900170c:	00a12623          	sw	a0,12(sp)
f9001710:	00b12823          	sw	a1,16(sp)
f9001714:	00c12a23          	sw	a2,20(sp)
f9001718:	00d12c23          	sw	a3,24(sp)
f900171c:	01074703          	lbu	a4,16(a4)
f9001720:	00e10e23          	sb	a4,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f9001724:	0047d713          	srli	a4,a5,0x4
f9001728:	02010693          	addi	a3,sp,32
f900172c:	00e68733          	add	a4,a3,a4
f9001730:	fec74683          	lbu	a3,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f9001734:	f8100737          	lui	a4,0xf8100
f9001738:	00472703          	lw	a4,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f900173c:	00277713          	andi	a4,a4,2
    if (!uart_mini_tx_ready())
f9001740:	fe071ae3          	bnez	a4,f9001734 <main+0x644>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001744:	f8100737          	lui	a4,0xf8100
f9001748:	00d72423          	sw	a3,8(a4) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f900174c:	00f7f793          	andi	a5,a5,15
f9001750:	02010713          	addi	a4,sp,32
f9001754:	00f707b3          	add	a5,a4,a5
f9001758:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f900175c:	f81007b7          	lui	a5,0xf8100
f9001760:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001764:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9001768:	fe079ae3          	bnez	a5,f900175c <main+0x66c>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f900176c:	f81007b7          	lui	a5,0xf8100
f9001770:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_print_hex8(val & 0xFF);
f9001774:	0ff47713          	andi	a4,s0,255
    const char hex[] = "0123456789ABCDEF";
f9001778:	f90027b7          	lui	a5,0xf9002
f900177c:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f9001780:	0007a503          	lw	a0,0(a5)
f9001784:	0047a583          	lw	a1,4(a5)
f9001788:	0087a603          	lw	a2,8(a5)
f900178c:	00c7a683          	lw	a3,12(a5)
f9001790:	00a12623          	sw	a0,12(sp)
f9001794:	00b12823          	sw	a1,16(sp)
f9001798:	00c12a23          	sw	a2,20(sp)
f900179c:	00d12c23          	sw	a3,24(sp)
f90017a0:	0107c783          	lbu	a5,16(a5)
f90017a4:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f90017a8:	00475793          	srli	a5,a4,0x4
f90017ac:	02010693          	addi	a3,sp,32
f90017b0:	00f687b3          	add	a5,a3,a5
f90017b4:	fec7c683          	lbu	a3,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f90017b8:	f81007b7          	lui	a5,0xf8100
f90017bc:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90017c0:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90017c4:	fe079ae3          	bnez	a5,f90017b8 <main+0x6c8>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90017c8:	f81007b7          	lui	a5,0xf8100
f90017cc:	00d7a423          	sw	a3,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f90017d0:	00f77713          	andi	a4,a4,15
f90017d4:	02010793          	addi	a5,sp,32
f90017d8:	00e78733          	add	a4,a5,a4
f90017dc:	fec74703          	lbu	a4,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f90017e0:	f81007b7          	lui	a5,0xf8100
f90017e4:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90017e8:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90017ec:	fe079ae3          	bnez	a5,f90017e0 <main+0x6f0>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90017f0:	f81007b7          	lui	a5,0xf8100
f90017f4:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
            print(" RX="); uart_mini_print_hex16(cnt >> 16);
f90017f8:	80818513          	addi	a0,gp,-2040 # f9001af8 <_data+0x188>
f90017fc:	c2dfe0ef          	jal	ra,f9000428 <print>
f9001800:	01045413          	srli	s0,s0,0x10
    uart_mini_print_hex8((val >> 8) & 0xFF);
f9001804:	00845713          	srli	a4,s0,0x8
    const char hex[] = "0123456789ABCDEF";
f9001808:	f90027b7          	lui	a5,0xf9002
f900180c:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f9001810:	0007a503          	lw	a0,0(a5)
f9001814:	0047a583          	lw	a1,4(a5)
f9001818:	0087a603          	lw	a2,8(a5)
f900181c:	00c7a683          	lw	a3,12(a5)
f9001820:	00a12623          	sw	a0,12(sp)
f9001824:	00b12823          	sw	a1,16(sp)
f9001828:	00c12a23          	sw	a2,20(sp)
f900182c:	00d12c23          	sw	a3,24(sp)
f9001830:	0107c783          	lbu	a5,16(a5)
f9001834:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f9001838:	00475793          	srli	a5,a4,0x4
f900183c:	02010693          	addi	a3,sp,32
f9001840:	00f687b3          	add	a5,a3,a5
f9001844:	fec7c683          	lbu	a3,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f9001848:	f81007b7          	lui	a5,0xf8100
f900184c:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001850:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9001854:	fe079ae3          	bnez	a5,f9001848 <main+0x758>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001858:	f81007b7          	lui	a5,0xf8100
f900185c:	00d7a423          	sw	a3,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f9001860:	00f77713          	andi	a4,a4,15
f9001864:	02010793          	addi	a5,sp,32
f9001868:	00e78733          	add	a4,a5,a4
f900186c:	fec74703          	lbu	a4,-20(a4)
    return (uint8_t)(*status_reg & 0xFF);
f9001870:	f81007b7          	lui	a5,0xf8100
f9001874:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f9001878:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f900187c:	fe079ae3          	bnez	a5,f9001870 <main+0x780>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001880:	f81007b7          	lui	a5,0xf8100
f9001884:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_print_hex8(val & 0xFF);
f9001888:	0ff47413          	andi	s0,s0,255
    const char hex[] = "0123456789ABCDEF";
f900188c:	f90027b7          	lui	a5,0xf9002
f9001890:	97078793          	addi	a5,a5,-1680 # f9001970 <__freertos_irq_stack_top+0xffffbe60>
f9001894:	0007a583          	lw	a1,0(a5)
f9001898:	0047a603          	lw	a2,4(a5)
f900189c:	0087a683          	lw	a3,8(a5)
f90018a0:	00c7a703          	lw	a4,12(a5)
f90018a4:	00b12623          	sw	a1,12(sp)
f90018a8:	00c12823          	sw	a2,16(sp)
f90018ac:	00d12a23          	sw	a3,20(sp)
f90018b0:	00e12c23          	sw	a4,24(sp)
f90018b4:	0107c783          	lbu	a5,16(a5)
f90018b8:	00f10e23          	sb	a5,28(sp)
    uart_mini_tx_byte_blocking(hex[(val >> 4) & 0xF]);
f90018bc:	00445793          	srli	a5,s0,0x4
f90018c0:	02010713          	addi	a4,sp,32
f90018c4:	00f707b3          	add	a5,a4,a5
f90018c8:	fec7c703          	lbu	a4,-20(a5)
    return (uint8_t)(*status_reg & 0xFF);
f90018cc:	f81007b7          	lui	a5,0xf8100
f90018d0:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90018d4:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f90018d8:	fe079ae3          	bnez	a5,f90018cc <main+0x7dc>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f90018dc:	f81007b7          	lui	a5,0xf8100
f90018e0:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
    uart_mini_tx_byte_blocking(hex[val & 0xF]);
f90018e4:	00f47413          	andi	s0,s0,15
f90018e8:	02010793          	addi	a5,sp,32
f90018ec:	00878433          	add	s0,a5,s0
f90018f0:	fec44703          	lbu	a4,-20(s0)
    return (uint8_t)(*status_reg & 0xFF);
f90018f4:	f81007b7          	lui	a5,0xf8100
f90018f8:	0047a783          	lw	a5,4(a5) # f8100004 <__freertos_irq_stack_top+0xff0fa4f4>
    return !(uart_mini_get_status() & UART_STATUS_TX_FULL);
f90018fc:	0027f793          	andi	a5,a5,2
    if (!uart_mini_tx_ready())
f9001900:	fe079ae3          	bnez	a5,f90018f4 <main+0x804>
    *tx_data_reg = (uint32_t)data;  // Write triggers tx_write strobe
f9001904:	f81007b7          	lui	a5,0xf8100
f9001908:	00e7a423          	sw	a4,8(a5) # f8100008 <__freertos_irq_stack_top+0xff0fa4f8>
            println("");
f900190c:	f9002537          	lui	a0,0xf9002
f9001910:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffbeb8>
f9001914:	b45fe0ef          	jal	ra,f9000458 <println>
        }
        
        bsp_uDelay(1000000);  // 1 second
f9001918:	f8b00637          	lui	a2,0xf8b00
f900191c:	02faf5b7          	lui	a1,0x2faf
f9001920:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fab080>
f9001924:	000f4537          	lui	a0,0xf4
f9001928:	24050513          	addi	a0,a0,576 # f4240 <__stack_size+0xf0240>
f900192c:	ffcfe0ef          	jal	ra,f9000128 <clint_uDelay>
        loop++;
f9001930:	00148493          	addi	s1,s1,1
        led_off();
f9001934:	a55fe0ef          	jal	ra,f9000388 <led_off>
        bmsr = bmsr_read(phy);
f9001938:	00100513          	li	a0,1
f900193c:	f15fe0ef          	jal	ra,f9000850 <bmsr_read>
f9001940:	00050413          	mv	s0,a0
        if (bmsr != last_bmsr) {
f9001944:	c0a99ee3          	bne	s3,a0,f9001560 <main+0x470>
        if (bmsr & BMSR_LINK_STATUS) {
f9001948:	00447413          	andi	s0,s0,4
f900194c:	c4040ee3          	beqz	s0,f90015a8 <main+0x4b8>
            eth_send_udp_test(payload_size, seq++);
f9001950:	00190413          	addi	s0,s2,1
f9001954:	00090593          	mv	a1,s2
f9001958:	06400513          	li	a0,100
f900195c:	e68ff0ef          	jal	ra,f9000fc4 <eth_send_udp_test>
            led_on();
f9001960:	a19fe0ef          	jal	ra,f9000378 <led_on>
            eth_send_udp_test(payload_size, seq++);
f9001964:	00040913          	mv	s2,s0
f9001968:	c45ff06f          	j	f90015ac <main+0x4bc>

f900196c <trap>:
    }
}

void trap(void) { while(1); }
f900196c:	0000006f          	j	f900196c <trap>
