
build/blink_led.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00002197          	auipc	gp,0x2
f9000004:	98018193          	addi	gp,gp,-1664 # f9001980 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	02018113          	addi	sp,gp,32 # f90019a0 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f900000c:	80c18513          	addi	a0,gp,-2036 # f900118c <_data>
	la a1, _data
f9000010:	80c18593          	addi	a1,gp,-2036 # f900118c <_data>
	la a2, _edata
f9000014:	81c18613          	addi	a2,gp,-2020 # f900119c <__bss_start>
	bgeu a1, a2, 2f
f9000018:	00c5fc63          	bgeu	a1,a2,f9000030 <init+0x28>
1:
	lw t0, (a0)
f900001c:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
f9000020:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
f9000024:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
f9000028:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
f900002c:	fec5e8e3          	bltu	a1,a2,f900001c <init+0x14>
2:

	/* Clear bss section */
	la a0, __bss_start
f9000030:	81c18513          	addi	a0,gp,-2020 # f900119c <__bss_start>
	la a1, _end
f9000034:	82018593          	addi	a1,gp,-2016 # f90011a0 <_end>
	bgeu a0, a1, 2f
f9000038:	00b57863          	bgeu	a0,a1,f9000048 <init+0x40>
1:
	sw zero, (a0)
f900003c:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
f9000040:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
f9000044:	feb56ce3          	bltu	a0,a1,f900003c <init+0x34>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
f9000048:	010000ef          	jal	ra,f9000058 <__libc_init_array>
#endif

	call main
f900004c:	7f4000ef          	jal	ra,f9000840 <main>

f9000050 <mainDone>:
mainDone:
    j mainDone
f9000050:	0000006f          	j	f9000050 <mainDone>

f9000054 <_init>:


	.globl _init
_init:
    ret
f9000054:	00008067          	ret

Disassembly of section .text:

f9000058 <__libc_init_array>:
f9000058:	ff010113          	addi	sp,sp,-16
f900005c:	00812423          	sw	s0,8(sp)
f9000060:	01212023          	sw	s2,0(sp)
f9000064:	80c18413          	addi	s0,gp,-2036 # f900118c <_data>
f9000068:	80c18913          	addi	s2,gp,-2036 # f900118c <_data>
f900006c:	40890933          	sub	s2,s2,s0
f9000070:	00112623          	sw	ra,12(sp)
f9000074:	00912223          	sw	s1,4(sp)
f9000078:	40295913          	srai	s2,s2,0x2
f900007c:	00090e63          	beqz	s2,f9000098 <__libc_init_array+0x40>
f9000080:	00000493          	li	s1,0
f9000084:	00042783          	lw	a5,0(s0)
f9000088:	00148493          	addi	s1,s1,1
f900008c:	00440413          	addi	s0,s0,4
f9000090:	000780e7          	jalr	a5
f9000094:	fe9918e3          	bne	s2,s1,f9000084 <__libc_init_array+0x2c>
f9000098:	80c18413          	addi	s0,gp,-2036 # f900118c <_data>
f900009c:	80c18913          	addi	s2,gp,-2036 # f900118c <_data>
f90000a0:	40890933          	sub	s2,s2,s0
f90000a4:	40295913          	srai	s2,s2,0x2
f90000a8:	00090e63          	beqz	s2,f90000c4 <__libc_init_array+0x6c>
f90000ac:	00000493          	li	s1,0
f90000b0:	00042783          	lw	a5,0(s0)
f90000b4:	00148493          	addi	s1,s1,1
f90000b8:	00440413          	addi	s0,s0,4
f90000bc:	000780e7          	jalr	a5
f90000c0:	fe9918e3          	bne	s2,s1,f90000b0 <__libc_init_array+0x58>
f90000c4:	00c12083          	lw	ra,12(sp)
f90000c8:	00812403          	lw	s0,8(sp)
f90000cc:	00412483          	lw	s1,4(sp)
f90000d0:	00012903          	lw	s2,0(sp)
f90000d4:	01010113          	addi	sp,sp,16
f90000d8:	00008067          	ret

f90000dc <clint_uDelay>:
*          continuously checking if the difference between the current time
*          and the time limit is non-negative, indicating that the delay has
*          not yet elapsed.
*
******************************************************************************/
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
f90000dc:	ff010113          	addi	sp,sp,-16
f90000e0:	00112623          	sw	ra,12(sp)
f90000e4:	00812423          	sw	s0,8(sp)
f90000e8:	00912223          	sw	s1,4(sp)
f90000ec:	01212023          	sw	s2,0(sp)
f90000f0:	00050913          	mv	s2,a0
f90000f4:	00058513          	mv	a0,a1
f90000f8:	00060413          	mv	s0,a2
        u32 mTimePerUsec = hz/1000000;
f90000fc:	000f45b7          	lui	a1,0xf4
f9000100:	24058593          	addi	a1,a1,576 # f4240 <__stack_size+0xf3a40>
f9000104:	7dd000ef          	jal	ra,f90010e0 <__udivsi3>
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f9000108:	0000c7b7          	lui	a5,0xc
f900010c:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0xb7f8>
f9000110:	00f40433          	add	s0,s0,a5
#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
f9000114:	00042483          	lw	s1,0(s0)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f9000118:	00090593          	mv	a1,s2
f900011c:	799000ef          	jal	ra,f90010b4 <__mulsi3>
f9000120:	00950533          	add	a0,a0,s1
f9000124:	00042783          	lw	a5,0(s0)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f9000128:	40f507b3          	sub	a5,a0,a5
f900012c:	fe07dce3          	bgez	a5,f9000124 <clint_uDelay+0x48>
f9000130:	00c12083          	lw	ra,12(sp)
f9000134:	00812403          	lw	s0,8(sp)
f9000138:	00412483          	lw	s1,4(sp)
f900013c:	00012903          	lw	s2,0(sp)
f9000140:	01010113          	addi	sp,sp,16
f9000144:	00008067          	ret

f9000148 <i2c_applyConfig>:
*
* @return       None.
*
******************************************************************************/
    static void i2c_applyConfig(u32 reg, I2c_Config *config){
        write_u32(config->samplingClockDivider, reg + I2C_SAMPLING_CLOCK_DIVIDER);
f9000148:	0005a783          	lw	a5,0(a1)
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f900014c:	02f52423          	sw	a5,40(a0)
        write_u32(config->timeout, reg + I2C_TIMEOUT);
f9000150:	0045a783          	lw	a5,4(a1)
f9000154:	02f52623          	sw	a5,44(a0)
        write_u32(config->tsuDat, reg + I2C_TSUDAT);
f9000158:	0085a783          	lw	a5,8(a1)
f900015c:	02f52823          	sw	a5,48(a0)
        write_u32(config->tLow, reg + I2C_TLOW);
f9000160:	00c5a783          	lw	a5,12(a1)
f9000164:	04f52823          	sw	a5,80(a0)
        write_u32(config->tHigh, reg + I2C_THIGH);
f9000168:	0105a783          	lw	a5,16(a1)
f900016c:	04f52a23          	sw	a5,84(a0)
        write_u32(config->tBuf, reg + I2C_TBUF);
f9000170:	0145a783          	lw	a5,20(a1)
f9000174:	04f52c23          	sw	a5,88(a0)
    }
f9000178:	00008067          	ret

f900017c <axi_slave_read32>:
        return *((volatile u32*) address);
f900017c:	00052503          	lw	a0,0(a0)

u32 axi_slave_read32(u32 address) {
   u32 data;
   data = read_u32(address);
   return data;
}
f9000180:	00008067          	ret

f9000184 <number_pow>:
u32 number_pow(u32 base ,u32 pow)
{
	u32 i=1;
	u32 out=1;

		 if(pow==0)return 1;
f9000184:	04058263          	beqz	a1,f90001c8 <number_pow+0x44>
	else if(pow==1)return base;
f9000188:	00100793          	li	a5,1
f900018c:	04f58e63          	beq	a1,a5,f90001e8 <number_pow+0x64>
{
f9000190:	ff010113          	addi	sp,sp,-16
f9000194:	00112623          	sw	ra,12(sp)
f9000198:	00812423          	sw	s0,8(sp)
f900019c:	00912223          	sw	s1,4(sp)
f90001a0:	01212023          	sw	s2,0(sp)
f90001a4:	00058493          	mv	s1,a1
f90001a8:	00050913          	mv	s2,a0
	u32 out=1;
f90001ac:	00100513          	li	a0,1
	u32 i=1;
f90001b0:	00100413          	li	s0,1
	else
	{
		while(i<=pow){
f90001b4:	0084ee63          	bltu	s1,s0,f90001d0 <number_pow+0x4c>
			out=out*base;
f90001b8:	00090593          	mv	a1,s2
f90001bc:	6f9000ef          	jal	ra,f90010b4 <__mulsi3>
			i++;
f90001c0:	00140413          	addi	s0,s0,1
f90001c4:	ff1ff06f          	j	f90001b4 <number_pow+0x30>
		 if(pow==0)return 1;
f90001c8:	00100513          	li	a0,1
f90001cc:	00008067          	ret
		}
		return out;
	}

	return 0;	//error
}
f90001d0:	00c12083          	lw	ra,12(sp)
f90001d4:	00812403          	lw	s0,8(sp)
f90001d8:	00412483          	lw	s1,4(sp)
f90001dc:	00012903          	lw	s2,0(sp)
f90001e0:	01010113          	addi	sp,sp,16
f90001e4:	00008067          	ret
f90001e8:	00008067          	ret

f90001ec <msDelay>:

void msDelay(u32 ms)
{
f90001ec:	ff010113          	addi	sp,sp,-16
f90001f0:	00112623          	sw	ra,12(sp)
	bsp_uDelay(ms*1000);
f90001f4:	00551713          	slli	a4,a0,0x5
f90001f8:	40a70733          	sub	a4,a4,a0
f90001fc:	00271793          	slli	a5,a4,0x2
f9000200:	00a787b3          	add	a5,a5,a0
f9000204:	00379513          	slli	a0,a5,0x3
f9000208:	f8b00637          	lui	a2,0xf8b00
f900020c:	07a125b7          	lui	a1,0x7a12
f9000210:	ecdff0ef          	jal	ra,f90000dc <clint_uDelay>
}
f9000214:	00c12083          	lw	ra,12(sp)
f9000218:	01010113          	addi	sp,sp,16
f900021c:	00008067          	ret

f9000220 <mipi_i2c_init>:



void mipi_i2c_init(){
f9000220:	fd010113          	addi	sp,sp,-48
f9000224:	02112623          	sw	ra,44(sp)
    //I2C init
    I2c_Config i2c_mipi;
    i2c_mipi.samplingClockDivider = 3;
f9000228:	00300793          	li	a5,3
f900022c:	00f12423          	sw	a5,8(sp)
    i2c_mipi.timeout = I2C_CTRL_HZ/1000;
f9000230:	0001f7b7          	lui	a5,0x1f
f9000234:	40078793          	addi	a5,a5,1024 # 1f400 <__stack_size+0x1ec00>
f9000238:	00f12623          	sw	a5,12(sp)
    i2c_mipi.tsuDat  = I2C_CTRL_HZ/2000000;
f900023c:	04000793          	li	a5,64
f9000240:	00f12823          	sw	a5,16(sp)

    i2c_mipi.tLow  = I2C_CTRL_HZ/800000;
f9000244:	0a000793          	li	a5,160
f9000248:	00f12a23          	sw	a5,20(sp)
    i2c_mipi.tHigh = I2C_CTRL_HZ/800000;
f900024c:	00f12c23          	sw	a5,24(sp)
    i2c_mipi.tBuf  = I2C_CTRL_HZ/400000;
f9000250:	14000793          	li	a5,320
f9000254:	00f12e23          	sw	a5,28(sp)
    i2c_applyConfig(I2C_CTRL_MIPI, &i2c_mipi);
f9000258:	00810593          	addi	a1,sp,8
f900025c:	f8016537          	lui	a0,0xf8016
f9000260:	ee9ff0ef          	jal	ra,f9000148 <i2c_applyConfig>

}
f9000264:	02c12083          	lw	ra,44(sp)
f9000268:	03010113          	addi	sp,sp,48
f900026c:	00008067          	ret

f9000270 <uart_applyConfig>:
*          value using data length, parity, and stop bit settings from the configuration
*          structure, and writes this value to the UART frame configuration register.
*
******************************************************************************/
    static void uart_applyConfig(u32 reg, Uart_Config *config){
        write_u32(config->clockDivider, reg + UART_CLOCK_DIVIDER);
f9000270:	00c5a783          	lw	a5,12(a1) # 7a1200c <__stack_size+0x7a1180c>
        *((volatile u32*) address) = data;
f9000274:	00f52423          	sw	a5,8(a0) # f8016008 <__freertos_irq_stack_top+0xff014668>
        write_u32(((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16), reg + UART_FRAME_CONFIG);
f9000278:	0005a783          	lw	a5,0(a1)
f900027c:	fff78793          	addi	a5,a5,-1
f9000280:	0045a703          	lw	a4,4(a1)
f9000284:	00871713          	slli	a4,a4,0x8
f9000288:	00e7e7b3          	or	a5,a5,a4
f900028c:	0085a703          	lw	a4,8(a1)
f9000290:	01071713          	slli	a4,a4,0x10
f9000294:	00e7e7b3          	or	a5,a5,a4
f9000298:	00f52623          	sw	a5,12(a0)
    }
f900029c:	00008067          	ret

f90002a0 <clint_uDelay>:
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
f90002a0:	ff010113          	addi	sp,sp,-16
f90002a4:	00112623          	sw	ra,12(sp)
f90002a8:	00812423          	sw	s0,8(sp)
f90002ac:	00912223          	sw	s1,4(sp)
f90002b0:	01212023          	sw	s2,0(sp)
f90002b4:	00050913          	mv	s2,a0
f90002b8:	00058513          	mv	a0,a1
f90002bc:	00060413          	mv	s0,a2
        u32 mTimePerUsec = hz/1000000;
f90002c0:	000f45b7          	lui	a1,0xf4
f90002c4:	24058593          	addi	a1,a1,576 # f4240 <__stack_size+0xf3a40>
f90002c8:	619000ef          	jal	ra,f90010e0 <__udivsi3>
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f90002cc:	0000c7b7          	lui	a5,0xc
f90002d0:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0xb7f8>
f90002d4:	00f40433          	add	s0,s0,a5
        return *((volatile u32*) address);
f90002d8:	00042483          	lw	s1,0(s0)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90002dc:	00090593          	mv	a1,s2
f90002e0:	5d5000ef          	jal	ra,f90010b4 <__mulsi3>
f90002e4:	00950533          	add	a0,a0,s1
f90002e8:	00042783          	lw	a5,0(s0)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f90002ec:	40f507b3          	sub	a5,a0,a5
f90002f0:	fe07dce3          	bgez	a5,f90002e8 <clint_uDelay+0x48>
f90002f4:	00c12083          	lw	ra,12(sp)
f90002f8:	00812403          	lw	s0,8(sp)
f90002fc:	00412483          	lw	s1,4(sp)
f9000300:	00012903          	lw	s2,0(sp)
f9000304:	01010113          	addi	sp,sp,16
f9000308:	00008067          	ret

f900030c <bsp_init>:
    *   1. UART baudrate
    *   2. 
    */
////////////////////////////////////////////////////////////////////////////////
    static void bsp_init()
    {
f900030c:	fe010113          	addi	sp,sp,-32
f9000310:	00112e23          	sw	ra,28(sp)
        Uart_Config uartConfig;
        uartConfig.dataLength   = BITS_8;
f9000314:	00800793          	li	a5,8
f9000318:	00f12023          	sw	a5,0(sp)
        uartConfig.parity       = NONE;
f900031c:	00012223          	sw	zero,4(sp)
        uartConfig.stop         = ONE;
f9000320:	00012423          	sw	zero,8(sp)
        uartConfig.clockDivider = BSP_CLINT_HZ/(BSP_UART_BAUDRATE*BSP_UART_DATA_LEN)-1;
f9000324:	08900793          	li	a5,137
f9000328:	00f12623          	sw	a5,12(sp)
        uart_applyConfig(BSP_UART_TERMINAL, &uartConfig);    
f900032c:	00010593          	mv	a1,sp
f9000330:	f8010537          	lui	a0,0xf8010
f9000334:	f3dff0ef          	jal	ra,f9000270 <uart_applyConfig>
    }
f9000338:	01c12083          	lw	ra,28(sp)
f900033c:	02010113          	addi	sp,sp,32
f9000340:	00008067          	ret

f9000344 <i2c_applyConfig>:
        write_u32(config->samplingClockDivider, reg + I2C_SAMPLING_CLOCK_DIVIDER);
f9000344:	0005a783          	lw	a5,0(a1)
        *((volatile u32*) address) = data;
f9000348:	02f52423          	sw	a5,40(a0) # f8010028 <__freertos_irq_stack_top+0xff00e688>
        write_u32(config->timeout, reg + I2C_TIMEOUT);
f900034c:	0045a783          	lw	a5,4(a1)
f9000350:	02f52623          	sw	a5,44(a0)
        write_u32(config->tsuDat, reg + I2C_TSUDAT);
f9000354:	0085a783          	lw	a5,8(a1)
f9000358:	02f52823          	sw	a5,48(a0)
        write_u32(config->tLow, reg + I2C_TLOW);
f900035c:	00c5a783          	lw	a5,12(a1)
f9000360:	04f52823          	sw	a5,80(a0)
        write_u32(config->tHigh, reg + I2C_THIGH);
f9000364:	0105a783          	lw	a5,16(a1)
f9000368:	04f52a23          	sw	a5,84(a0)
        write_u32(config->tBuf, reg + I2C_TBUF);
f900036c:	0145a783          	lw	a5,20(a1)
f9000370:	04f52c23          	sw	a5,88(a0)
    }
f9000374:	00008067          	ret

f9000378 <i2c_masterBusy>:
        return *((volatile u32*) address);
f9000378:	04052503          	lw	a0,64(a0)
* @return      Returns 1 if the I2C master is busy, and 0 otherwise.
*
******************************************************************************/
    static int i2c_masterBusy(u32 reg){
        return (read_u32(reg + I2C_MASTER_STATUS) & I2C_MASTER_BUSY) != 0;
    }
f900037c:	00157513          	andi	a0,a0,1
f9000380:	00008067          	ret

f9000384 <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
f9000384:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
f9000388:	21000793          	li	a5,528
f900038c:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
f9000390:	00072783          	lw	a5,0(a4)
* @return      None.
*
******************************************************************************/
    static void i2c_masterStartBlocking(u32 reg){
        i2c_masterStart(reg);
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
f9000394:	0107f793          	andi	a5,a5,16
f9000398:	fe079ce3          	bnez	a5,f9000390 <i2c_masterStartBlocking+0xc>
    }
f900039c:	00008067          	ret

f90003a0 <i2c_masterStopWait>:
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterStopWait(u32 reg){
f90003a0:	ff010113          	addi	sp,sp,-16
f90003a4:	00112623          	sw	ra,12(sp)
f90003a8:	00812423          	sw	s0,8(sp)
f90003ac:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
f90003b0:	00040513          	mv	a0,s0
f90003b4:	fc5ff0ef          	jal	ra,f9000378 <i2c_masterBusy>
f90003b8:	fe051ce3          	bnez	a0,f90003b0 <i2c_masterStopWait+0x10>
    }
f90003bc:	00c12083          	lw	ra,12(sp)
f90003c0:	00812403          	lw	s0,8(sp)
f90003c4:	01010113          	addi	sp,sp,16
f90003c8:	00008067          	ret

f90003cc <i2c_masterStopBlocking>:
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterStopBlocking(u32 reg){
f90003cc:	ff010113          	addi	sp,sp,-16
f90003d0:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f90003d4:	42000713          	li	a4,1056
f90003d8:	04e52023          	sw	a4,64(a0)
        i2c_masterStop(reg);
        i2c_masterStopWait(reg);
f90003dc:	fc5ff0ef          	jal	ra,f90003a0 <i2c_masterStopWait>
    }
f90003e0:	00c12083          	lw	ra,12(sp)
f90003e4:	01010113          	addi	sp,sp,16
f90003e8:	00008067          	ret

f90003ec <i2c_txAckWait>:
        return *((volatile u32*) address);
f90003ec:	00452783          	lw	a5,4(a0)
*
* @return      None.
*
******************************************************************************/
    static void i2c_txAckWait(u32 reg){
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
f90003f0:	1007f793          	andi	a5,a5,256
f90003f4:	fe079ce3          	bnez	a5,f90003ec <i2c_txAckWait>
    }
f90003f8:	00008067          	ret

f90003fc <i2c_txNackBlocking>:
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_txNackBlocking(u32 reg){
f90003fc:	ff010113          	addi	sp,sp,-16
f9000400:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f9000404:	30100713          	li	a4,769
f9000408:	00e52223          	sw	a4,4(a0)
        i2c_txNack(reg);
        i2c_txAckWait(reg);
f900040c:	fe1ff0ef          	jal	ra,f90003ec <i2c_txAckWait>
    }
f9000410:	00c12083          	lw	ra,12(sp)
f9000414:	01010113          	addi	sp,sp,16
f9000418:	00008067          	ret

f900041c <i2c_rxAck>:
        return *((volatile u32*) address);
f900041c:	00c52503          	lw	a0,12(a0)
*
* @return      1 if ACK signal is detected, otherwise 0.
*
******************************************************************************/
    static int i2c_rxAck(u32 reg){
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
f9000420:	0ff57513          	andi	a0,a0,255
    }
f9000424:	00153513          	seqz	a0,a0
f9000428:	00008067          	ret

f900042c <i2c_writeData_b>:
* Then, it sends the register address byte to access. If the length of the data buffer
* is greater than one, it iterates through the buffer, sending each byte of data to the slave.
* Finally, it sends the stop sequence to complete the transaction.
*
*******************************************************************************/
    static void i2c_writeData_b(u32 reg, u8 slaveAddr, u8 regAddr, u8 *data, u32 length){
f900042c:	fe010113          	addi	sp,sp,-32
f9000430:	00112e23          	sw	ra,28(sp)
f9000434:	00812c23          	sw	s0,24(sp)
f9000438:	00912a23          	sw	s1,20(sp)
f900043c:	01212823          	sw	s2,16(sp)
f9000440:	01312623          	sw	s3,12(sp)
f9000444:	01412423          	sw	s4,8(sp)
f9000448:	01512223          	sw	s5,4(sp)
f900044c:	00050493          	mv	s1,a0
f9000450:	00058a13          	mv	s4,a1
f9000454:	00060a93          	mv	s5,a2
f9000458:	00068993          	mv	s3,a3
f900045c:	00070913          	mv	s2,a4
        i2c_masterStartBlocking(reg);               // Send start sequence
f9000460:	f25ff0ef          	jal	ra,f9000384 <i2c_masterStartBlocking>
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f9000464:	00001437          	lui	s0,0x1
f9000468:	b0040413          	addi	s0,s0,-1280 # b00 <__stack_size+0x300>
f900046c:	008a67b3          	or	a5,s4,s0
        *((volatile u32*) address) = data;
f9000470:	00f4a023          	sw	a5,0(s1)
        i2c_txByte(reg, slaveAddr | I2C_WRITE);     // write device address byte with write bit
        i2c_txNackBlocking(reg);                    // send nack bit
f9000474:	00048513          	mv	a0,s1
f9000478:	f85ff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f900047c:	008ae433          	or	s0,s5,s0
f9000480:	0084a023          	sw	s0,0(s1)
        i2c_txByte(reg, (regAddr & 0xFF));          // write a byte of register address to access
        i2c_txNackBlocking(reg);                    // send nack bit
f9000484:	00048513          	mv	a0,s1
f9000488:	f75ff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
        if(length > 1){
f900048c:	00100793          	li	a5,1
f9000490:	0327fe63          	bgeu	a5,s2,f90004cc <i2c_writeData_b+0xa0>
f9000494:	00048a13          	mv	s4,s1
            for(int i = 0; i < length - 1; i++){
f9000498:	00000413          	li	s0,0
f900049c:	fff90793          	addi	a5,s2,-1
f90004a0:	02f47663          	bgeu	s0,a5,f90004cc <i2c_writeData_b+0xa0>
                    i2c_txByte(reg, data[i]);       // send 8-bit data to slave
f90004a4:	008987b3          	add	a5,s3,s0
f90004a8:	0007c783          	lbu	a5,0(a5)
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f90004ac:	00001737          	lui	a4,0x1
f90004b0:	b0070713          	addi	a4,a4,-1280 # b00 <__stack_size+0x300>
f90004b4:	00e7e7b3          	or	a5,a5,a4
f90004b8:	00fa2023          	sw	a5,0(s4)
                    i2c_txNackBlocking(reg);        // send nack bit
f90004bc:	00048513          	mv	a0,s1
f90004c0:	f3dff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
            for(int i = 0; i < length - 1; i++){
f90004c4:	00140413          	addi	s0,s0,1
f90004c8:	fd5ff06f          	j	f900049c <i2c_writeData_b+0x70>
                }
        }
        i2c_txByte(reg, data[length-1]);            // send last 8-bit data to slave
f90004cc:	fff90913          	addi	s2,s2,-1
f90004d0:	01298933          	add	s2,s3,s2
f90004d4:	00094783          	lbu	a5,0(s2)
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f90004d8:	00001737          	lui	a4,0x1
f90004dc:	b0070713          	addi	a4,a4,-1280 # b00 <__stack_size+0x300>
f90004e0:	00e7e7b3          	or	a5,a5,a4
f90004e4:	00f4a023          	sw	a5,0(s1)
        i2c_txNackBlocking(reg);                    // send nack bit
f90004e8:	00048513          	mv	a0,s1
f90004ec:	f11ff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
        i2c_masterStopBlocking(reg);                // send stop sequence
f90004f0:	00048513          	mv	a0,s1
f90004f4:	ed9ff0ef          	jal	ra,f90003cc <i2c_masterStopBlocking>
    }
f90004f8:	01c12083          	lw	ra,28(sp)
f90004fc:	01812403          	lw	s0,24(sp)
f9000500:	01412483          	lw	s1,20(sp)
f9000504:	01012903          	lw	s2,16(sp)
f9000508:	00c12983          	lw	s3,12(sp)
f900050c:	00812a03          	lw	s4,8(sp)
f9000510:	00412a83          	lw	s5,4(sp)
f9000514:	02010113          	addi	sp,sp,32
f9000518:	00008067          	ret

f900051c <i2c_init_100khz>:
#define CAM_ADDR8     0x20
//  constant CAM_ADDR7       : std_logic_vector(6 downto 0) := "0010000";
#define REG_SW_RESET     0x0103u        /* Example camera reset register */

/* ----------- Configure I2C for ~100 kHz using your I2c_Config ----------- */
static void i2c_init_100khz(void) {
f900051c:	fd010113          	addi	sp,sp,-48
f9000520:	02112623          	sw	ra,44(sp)
    /* Conservative setup/hold/buffer timings */
    const uint32_t tsu_dat_us = 1u;   // SDA setup time
    const uint32_t t_buf_us   = 5u;   // STOP to START

    /* Fill config (all are "cycles - 1") */
    cfg.samplingClockDivider = 3u;                                // modest oversampling
f9000524:	00300793          	li	a5,3
f9000528:	00f12423          	sw	a5,8(sp)
    cfg.timeout              = (1000u * cycles_per_us) - 1u;      // ~1 ms bus timeout
f900052c:	0001f7b7          	lui	a5,0x1f
f9000530:	3ff78793          	addi	a5,a5,1023 # 1f3ff <__stack_size+0x1ebff>
f9000534:	00f12623          	sw	a5,12(sp)
    cfg.tsuDat               = (tsu_dat_us * cycles_per_us) - 1u; // SDA setup
f9000538:	07f00793          	li	a5,127
f900053c:	00f12823          	sw	a5,16(sp)
    cfg.tLow                 = (t_low_us  * cycles_per_us) - 1u;  // SCL low
f9000540:	27f00793          	li	a5,639
f9000544:	00f12a23          	sw	a5,20(sp)
    cfg.tHigh                = (t_high_us * cycles_per_us) - 1u;  // SCL high
f9000548:	00f12c23          	sw	a5,24(sp)
    cfg.tBuf                 = (t_buf_us  * cycles_per_us) - 1u;  // STOP→START
f900054c:	00f12e23          	sw	a5,28(sp)

    i2c_applyConfig(SYSTEM_I2C_0_IO_CTRL, &cfg);
f9000550:	00810593          	addi	a1,sp,8
f9000554:	f8016537          	lui	a0,0xf8016
f9000558:	dedff0ef          	jal	ra,f9000344 <i2c_applyConfig>
}
f900055c:	02c12083          	lw	ra,44(sp)
f9000560:	03010113          	addi	sp,sp,48
f9000564:	00008067          	ret

f9000568 <cam_write_reg8>:
 * ========================= */
#define CAM_I2C_ADDR7     0x10            // IMX219 7-bit I2C address
#define CAM_I2C_ADDR8     (CAM_I2C_ADDR7 << 1)

/* ---------- Low-level IMX219 register write (16-bit reg, 8-bit data) ---------- */
static inline void cam_write_reg8(uint16_t reg, uint8_t data) {
f9000568:	fe010113          	addi	sp,sp,-32
f900056c:	00112e23          	sw	ra,28(sp)
f9000570:	00812c23          	sw	s0,24(sp)
f9000574:	00912a23          	sw	s1,20(sp)
f9000578:	01212823          	sw	s2,16(sp)
f900057c:	01312623          	sw	s3,12(sp)
f9000580:	00050493          	mv	s1,a0
f9000584:	00058993          	mv	s3,a1
    i2c_masterStartBlocking(I2C_CTRL_MIPI);
f9000588:	f8016537          	lui	a0,0xf8016
f900058c:	df9ff0ef          	jal	ra,f9000384 <i2c_masterStartBlocking>
f9000590:	f8016937          	lui	s2,0xf8016
f9000594:	00001437          	lui	s0,0x1
f9000598:	b2040793          	addi	a5,s0,-1248 # b20 <__stack_size+0x320>
f900059c:	00f92023          	sw	a5,0(s2) # f8016000 <__freertos_irq_stack_top+0xff014660>
    i2c_txByte(I2C_CTRL_MIPI, CAM_I2C_ADDR8 | I2C_WRITE);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
f90005a0:	f8016537          	lui	a0,0xf8016
f90005a4:	e59ff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
    (void)i2c_rxAck(I2C_CTRL_MIPI);
f90005a8:	f8016537          	lui	a0,0xf8016
f90005ac:	e71ff0ef          	jal	ra,f900041c <i2c_rxAck>

    i2c_txByte(I2C_CTRL_MIPI, (reg >> 8) & 0xFF);
f90005b0:	0084d793          	srli	a5,s1,0x8
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f90005b4:	b0040413          	addi	s0,s0,-1280
f90005b8:	0087e7b3          	or	a5,a5,s0
f90005bc:	00f92023          	sw	a5,0(s2)
    i2c_txNackBlocking(I2C_CTRL_MIPI);
f90005c0:	f8016537          	lui	a0,0xf8016
f90005c4:	e39ff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
    (void)i2c_rxAck(I2C_CTRL_MIPI);
f90005c8:	f8016537          	lui	a0,0xf8016
f90005cc:	e51ff0ef          	jal	ra,f900041c <i2c_rxAck>

    i2c_txByte(I2C_CTRL_MIPI, reg & 0xFF);
f90005d0:	0ff4f493          	andi	s1,s1,255
f90005d4:	0084e4b3          	or	s1,s1,s0
f90005d8:	00992023          	sw	s1,0(s2)
    i2c_txNackBlocking(I2C_CTRL_MIPI);
f90005dc:	f8016537          	lui	a0,0xf8016
f90005e0:	e1dff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
    (void)i2c_rxAck(I2C_CTRL_MIPI);
f90005e4:	f8016537          	lui	a0,0xf8016
f90005e8:	e35ff0ef          	jal	ra,f900041c <i2c_rxAck>
f90005ec:	0089e433          	or	s0,s3,s0
f90005f0:	00892023          	sw	s0,0(s2)

    i2c_txByte(I2C_CTRL_MIPI, data & 0xFF);
    i2c_txNackBlocking(I2C_CTRL_MIPI);
f90005f4:	f8016537          	lui	a0,0xf8016
f90005f8:	e05ff0ef          	jal	ra,f90003fc <i2c_txNackBlocking>
    (void)i2c_rxAck(I2C_CTRL_MIPI);
f90005fc:	f8016537          	lui	a0,0xf8016
f9000600:	e1dff0ef          	jal	ra,f900041c <i2c_rxAck>

    i2c_masterStopBlocking(I2C_CTRL_MIPI);
f9000604:	f8016537          	lui	a0,0xf8016
f9000608:	dc5ff0ef          	jal	ra,f90003cc <i2c_masterStopBlocking>
}
f900060c:	01c12083          	lw	ra,28(sp)
f9000610:	01812403          	lw	s0,24(sp)
f9000614:	01412483          	lw	s1,20(sp)
f9000618:	01012903          	lw	s2,16(sp)
f900061c:	00c12983          	lw	s3,12(sp)
f9000620:	02010113          	addi	sp,sp,32
f9000624:	00008067          	ret

f9000628 <imx219_access_seq>:

/* Some sequences in the demo expect this “Access Command Sequence” before init */
static void imx219_access_seq(void) {
f9000628:	ff010113          	addi	sp,sp,-16
f900062c:	00112623          	sw	ra,12(sp)
f9000630:	00812423          	sw	s0,8(sp)
    cam_write_reg8(0x30EB, 0x05);
f9000634:	00500593          	li	a1,5
f9000638:	00003437          	lui	s0,0x3
f900063c:	0eb40513          	addi	a0,s0,235 # 30eb <__stack_size+0x28eb>
f9000640:	f29ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(0x30EB, 0x0C);
f9000644:	00c00593          	li	a1,12
f9000648:	0eb40513          	addi	a0,s0,235
f900064c:	f1dff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(0x300A, 0xFF);
f9000650:	0ff00593          	li	a1,255
f9000654:	00a40513          	addi	a0,s0,10
f9000658:	f11ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(0x300B, 0xFF);
f900065c:	0ff00593          	li	a1,255
f9000660:	00b40513          	addi	a0,s0,11
f9000664:	f05ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(0x30EB, 0x05);
f9000668:	00500593          	li	a1,5
f900066c:	0eb40513          	addi	a0,s0,235
f9000670:	ef9ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(0x30EB, 0x09);
f9000674:	00900593          	li	a1,9
f9000678:	0eb40513          	addi	a0,s0,235
f900067c:	eedff0ef          	jal	ra,f9000568 <cam_write_reg8>
}
f9000680:	00c12083          	lw	ra,12(sp)
f9000684:	00812403          	lw	s0,8(sp)
f9000688:	01010113          	addi	sp,sp,16
f900068c:	00008067          	ret

f9000690 <imx219_set_roi_96x96_center>:

/* ----------------------- Configure 96x96 output window -----------------------
   Uses the IMX219 Frame Bank A registers from PiCamDriver.h
   Full active array is 3280 x 2464. We'll take a centered 96x96 crop.
------------------------------------------------------------------------------- */
static void imx219_set_roi_96x96_center(void) {
f9000690:	ff010113          	addi	sp,sp,-16
f9000694:	00112623          	sw	ra,12(sp)
    const uint16_t x_end   = x_start + out_w - 1;         // 1687
    const uint16_t y_start = (full_h/2) - (out_h/2);      // 1184
    const uint16_t y_end   = y_start + out_h - 1;         // 1279

    // Program the sensor ROI (add/sub arrays)
    cam_write_reg8(X_ADD_STA_A_1, (x_start >> 8) & 0x0F);
f9000698:	00600593          	li	a1,6
f900069c:	16400513          	li	a0,356
f90006a0:	ec9ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(X_ADD_STA_A_0, (uint8_t)(x_start & 0xFF));
f90006a4:	03800593          	li	a1,56
f90006a8:	16500513          	li	a0,357
f90006ac:	ebdff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(X_ADD_END_A_1, (x_end   >> 8) & 0x0F);
f90006b0:	00600593          	li	a1,6
f90006b4:	16600513          	li	a0,358
f90006b8:	eb1ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(X_ADD_END_A_0, (uint8_t)(x_end   & 0xFF));
f90006bc:	09700593          	li	a1,151
f90006c0:	16700513          	li	a0,359
f90006c4:	ea5ff0ef          	jal	ra,f9000568 <cam_write_reg8>

    cam_write_reg8(Y_ADD_STA_A_1, (y_start >> 8) & 0x0F);
f90006c8:	00400593          	li	a1,4
f90006cc:	16800513          	li	a0,360
f90006d0:	e99ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(Y_ADD_STA_A_0, (uint8_t)(y_start & 0xFF));
f90006d4:	0a000593          	li	a1,160
f90006d8:	16900513          	li	a0,361
f90006dc:	e8dff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(Y_ADD_END_A_1, (y_end   >> 8) & 0x0F);
f90006e0:	00400593          	li	a1,4
f90006e4:	16a00513          	li	a0,362
f90006e8:	e81ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(Y_ADD_END_A_0, (uint8_t)(y_end   & 0xFF));
f90006ec:	0ff00593          	li	a1,255
f90006f0:	16b00513          	li	a0,363
f90006f4:	e75ff0ef          	jal	ra,f9000568 <cam_write_reg8>

    // Output size registers
    cam_write_reg8(x_output_size_A_1, (out_w  >> 8) & 0x0F);
f90006f8:	00000593          	li	a1,0
f90006fc:	16c00513          	li	a0,364
f9000700:	e69ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(x_output_size_A_0, (uint8_t)(out_w  & 0xFF));
f9000704:	06000593          	li	a1,96
f9000708:	16d00513          	li	a0,365
f900070c:	e5dff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(y_output_size_A_1, (out_h  >> 8) & 0x0F);
f9000710:	00000593          	li	a1,0
f9000714:	16e00513          	li	a0,366
f9000718:	e51ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(y_output_size_A_0, (uint8_t)(out_h  & 0xFF));
f900071c:	06000593          	li	a1,96
f9000720:	16f00513          	li	a0,367
f9000724:	e45ff0ef          	jal	ra,f9000568 <cam_write_reg8>
}
f9000728:	00c12083          	lw	ra,12(sp)
f900072c:	01010113          	addi	sp,sp,16
f9000730:	00008067          	ret

f9000734 <imx219_init_96x96>:

/* ------------------------- Minimal IMX219 initialization -------------------------
   This is distilled from the demo's PiCam init, keeping ONLY I2C/MIPI sensor setup.
   You can extend it with more controls (gain, exposure, binning) as needed.
----------------------------------------------------------------------------------- */
static void imx219_init_96x96(void) {
f9000734:	ff010113          	addi	sp,sp,-16
f9000738:	00112623          	sw	ra,12(sp)
    // Stop streaming
    cam_write_reg8(mode_select, 0x00);
f900073c:	00000593          	li	a1,0
f9000740:	10000513          	li	a0,256
f9000744:	e25ff0ef          	jal	ra,f9000568 <cam_write_reg8>

    // Required access sequence
    imx219_access_seq();
f9000748:	ee1ff0ef          	jal	ra,f9000628 <imx219_access_seq>

    // Basic lane / clocking settings seen in the demo
    cam_write_reg8(CSI_LANE_MODE, 0x01);    // 2-lane (per demo)
f900074c:	00100593          	li	a1,1
f9000750:	11400513          	li	a0,276
f9000754:	e15ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(DPHY_CTRL,     0x00);
f9000758:	00000593          	li	a1,0
f900075c:	12800513          	li	a0,296
f9000760:	e09ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(EXCK_FREQ_1,   0x18);    // 24 MHz
f9000764:	01800593          	li	a1,24
f9000768:	12a00513          	li	a0,298
f900076c:	dfdff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(EXCK_FREQ_0,   0x00);
f9000770:	00000593          	li	a1,0
f9000774:	12b00513          	li	a0,299
f9000778:	df1ff0ef          	jal	ra,f9000568 <cam_write_reg8>

    // Frame/line length (taken from demo baseline)
    cam_write_reg8(FRM_LENGTH_A_1, 0x04);
f900077c:	00400593          	li	a1,4
f9000780:	16000513          	li	a0,352
f9000784:	de5ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(FRM_LENGTH_A_0, 0x59);
f9000788:	05900593          	li	a1,89
f900078c:	16100513          	li	a0,353
f9000790:	dd9ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(LINE_LENGTH_A_1, 0x0D);
f9000794:	00d00593          	li	a1,13
f9000798:	16200513          	li	a0,354
f900079c:	dcdff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(LINE_LENGTH_A_0, 0x78);
f90007a0:	07800593          	li	a1,120
f90007a4:	16300513          	li	a0,355
f90007a8:	dc1ff0ef          	jal	ra,f9000568 <cam_write_reg8>

    // Program centered 96x96 crop/output
    imx219_set_roi_96x96_center();
f90007ac:	ee5ff0ef          	jal	ra,f9000690 <imx219_set_roi_96x96_center>

    // Reasonable exposure defaults (longer exposure per demo comment)
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_1, 0x04);
f90007b0:	00400593          	li	a1,4
f90007b4:	15a00513          	li	a0,346
f90007b8:	db1ff0ef          	jal	ra,f9000568 <cam_write_reg8>
    cam_write_reg8(COARSE_INTEGRATION_TIME_A_0, 0x54);
f90007bc:	05400593          	li	a1,84
f90007c0:	15b00513          	li	a0,347
f90007c4:	da5ff0ef          	jal	ra,f9000568 <cam_write_reg8>

    // Orientation normal
    cam_write_reg8(IMG_ORIENTATION_A, 0x00);
f90007c8:	00000593          	li	a1,0
f90007cc:	17200513          	li	a0,370
f90007d0:	d99ff0ef          	jal	ra,f9000568 <cam_write_reg8>

    // Start streaming
    cam_write_reg8(mode_select, 0x01);
f90007d4:	00100593          	li	a1,1
f90007d8:	10000513          	li	a0,256
f90007dc:	d8dff0ef          	jal	ra,f9000568 <cam_write_reg8>
}
f90007e0:	00c12083          	lw	ra,12(sp)
f90007e4:	01010113          	addi	sp,sp,16
f90007e8:	00008067          	ret

f90007ec <blink_loop>:
    cam_write_reg16(CAM_ADDR8, REG_SW_RESET, &v, 1);
    bsp_uDelay(5000);                    // 5 ms wait after reset
}

/* Simple LED blink using GPIO0[0] */
static void blink_loop(void) {
f90007ec:	ff010113          	addi	sp,sp,-16
f90007f0:	00112623          	sw	ra,12(sp)
f90007f4:	00812423          	sw	s0,8(sp)
f90007f8:	00912223          	sw	s1,4(sp)
f90007fc:	f80157b7          	lui	a5,0xf8015
f9000800:	00100713          	li	a4,1
f9000804:	00e7a423          	sw	a4,8(a5) # f8015008 <__freertos_irq_stack_top+0xff013668>
f9000808:	f80154b7          	lui	s1,0xf8015
f900080c:	00100793          	li	a5,1
f9000810:	00f4a223          	sw	a5,4(s1) # f8015004 <__freertos_irq_stack_top+0xff013664>
    // Make GPIO0[0] output; other bits remain inputs
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x00000001);

    for(;;) {
        gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x00000001);
        bsp_uDelay(100000); // 100 ms
f9000814:	f8b00637          	lui	a2,0xf8b00
f9000818:	07a125b7          	lui	a1,0x7a12
f900081c:	00018437          	lui	s0,0x18
f9000820:	6a040513          	addi	a0,s0,1696 # 186a0 <__stack_size+0x17ea0>
f9000824:	a7dff0ef          	jal	ra,f90002a0 <clint_uDelay>
f9000828:	0004a223          	sw	zero,4(s1)
        gpio_setOutput(SYSTEM_GPIO_0_IO_CTRL, 0x00000000);
        bsp_uDelay(100000);
f900082c:	f8b00637          	lui	a2,0xf8b00
f9000830:	07a125b7          	lui	a1,0x7a12
f9000834:	6a040513          	addi	a0,s0,1696
f9000838:	a69ff0ef          	jal	ra,f90002a0 <clint_uDelay>
f900083c:	fcdff06f          	j	f9000808 <blink_loop+0x1c>

f9000840 <main>:
    }
}



int main(void) {
f9000840:	fe010113          	addi	sp,sp,-32
f9000844:	00112e23          	sw	ra,28(sp)
f9000848:	f80157b7          	lui	a5,0xf8015
f900084c:	00100713          	li	a4,1
f9000850:	00e7a423          	sw	a4,8(a5) # f8015008 <__freertos_irq_stack_top+0xff013668>
    gpio_setOutputEnable(SYSTEM_GPIO_0_IO_CTRL, 0x1);
    bsp_init();
f9000854:	ab9ff0ef          	jal	ra,f900030c <bsp_init>
    i2c_init_100khz();
f9000858:	cc5ff0ef          	jal	ra,f900051c <i2c_init_100khz>

    uint8_t ctrl[1] = {0x04};
f900085c:	00400793          	li	a5,4
f9000860:	00f10623          	sb	a5,12(sp)
    i2c_writeData_b(SYSTEM_I2C_0_IO_CTRL, 0xE0, 0x04, ctrl, 1);//Set the PCA9542A I2C switch to CAM0
f9000864:	00100713          	li	a4,1
f9000868:	00c10693          	addi	a3,sp,12
f900086c:	00400613          	li	a2,4
f9000870:	0e000593          	li	a1,224
f9000874:	f8016537          	lui	a0,0xf8016
f9000878:	bb5ff0ef          	jal	ra,f900042c <i2c_writeData_b>




    // Configure I2C controller for the MIPI cam
    mipi_i2c_init();    // uses I2C_CTRL_MIPI from common.h + user/bsp clocks
f900087c:	9a5ff0ef          	jal	ra,f9000220 <mipi_i2c_init>

    // (Optional) switch an upstream I2C mux if present – left out on purpose

    // Bring up the camera with ONLY I2C commands; 96x96 output
    imx219_init_96x96();
f9000880:	eb5ff0ef          	jal	ra,f9000734 <imx219_init_96x96>

    // Heartbeat
    blink_loop();
f9000884:	f69ff0ef          	jal	ra,f90007ec <blink_loop>

f9000888 <trap>:
    return 0;
}

/* RISC-V trap fallback (keep minimal) */
void trap(void) { while (1) { } }
f9000888:	0000006f          	j	f9000888 <trap>

f900088c <i2c_masterBusy>:
        return *((volatile u32*) address);
f900088c:	04052503          	lw	a0,64(a0) # f8016040 <__freertos_irq_stack_top+0xff0146a0>
    }
f9000890:	00157513          	andi	a0,a0,1
f9000894:	00008067          	ret

f9000898 <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
f9000898:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
f900089c:	21000793          	li	a5,528
f90008a0:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
f90008a4:	00072783          	lw	a5,0(a4)
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
f90008a8:	0107f793          	andi	a5,a5,16
f90008ac:	fe079ce3          	bnez	a5,f90008a4 <i2c_masterStartBlocking+0xc>
    }
f90008b0:	00008067          	ret

f90008b4 <i2c_masterStopWait>:
    static void i2c_masterStopWait(u32 reg){
f90008b4:	ff010113          	addi	sp,sp,-16
f90008b8:	00112623          	sw	ra,12(sp)
f90008bc:	00812423          	sw	s0,8(sp)
f90008c0:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
f90008c4:	00040513          	mv	a0,s0
f90008c8:	fc5ff0ef          	jal	ra,f900088c <i2c_masterBusy>
f90008cc:	fe051ce3          	bnez	a0,f90008c4 <i2c_masterStopWait+0x10>
    }
f90008d0:	00c12083          	lw	ra,12(sp)
f90008d4:	00812403          	lw	s0,8(sp)
f90008d8:	01010113          	addi	sp,sp,16
f90008dc:	00008067          	ret

f90008e0 <i2c_masterStopBlocking>:
    static void i2c_masterStopBlocking(u32 reg){
f90008e0:	ff010113          	addi	sp,sp,-16
f90008e4:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f90008e8:	42000713          	li	a4,1056
f90008ec:	04e52023          	sw	a4,64(a0)
        i2c_masterStopWait(reg);
f90008f0:	fc5ff0ef          	jal	ra,f90008b4 <i2c_masterStopWait>
    }
f90008f4:	00c12083          	lw	ra,12(sp)
f90008f8:	01010113          	addi	sp,sp,16
f90008fc:	00008067          	ret

f9000900 <i2c_txAckWait>:
        return *((volatile u32*) address);
f9000900:	00452783          	lw	a5,4(a0)
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
f9000904:	1007f793          	andi	a5,a5,256
f9000908:	fe079ce3          	bnez	a5,f9000900 <i2c_txAckWait>
    }
f900090c:	00008067          	ret

f9000910 <i2c_txNackBlocking>:
    static void i2c_txNackBlocking(u32 reg){
f9000910:	ff010113          	addi	sp,sp,-16
f9000914:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f9000918:	30100713          	li	a4,769
f900091c:	00e52223          	sw	a4,4(a0)
        i2c_txAckWait(reg);
f9000920:	fe1ff0ef          	jal	ra,f9000900 <i2c_txAckWait>
    }
f9000924:	00c12083          	lw	ra,12(sp)
f9000928:	01010113          	addi	sp,sp,16
f900092c:	00008067          	ret

f9000930 <i2c_rxData>:
        return *((volatile u32*) address);
f9000930:	00852503          	lw	a0,8(a0)
    }
f9000934:	0ff57513          	andi	a0,a0,255
f9000938:	00008067          	ret

f900093c <PiCam_WriteRegData>:
#include "riscv.h"
#include "PiCamDriver.h"
#include "common.h"

void PiCam_WriteRegData(u16 reg,u8 data)
{
f900093c:	fe010113          	addi	sp,sp,-32
f9000940:	00112e23          	sw	ra,28(sp)
f9000944:	00812c23          	sw	s0,24(sp)
f9000948:	00912a23          	sw	s1,20(sp)
f900094c:	01212823          	sw	s2,16(sp)
f9000950:	01312623          	sw	s3,12(sp)
f9000954:	00050493          	mv	s1,a0
f9000958:	00058993          	mv	s3,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
f900095c:	f8016537          	lui	a0,0xf8016
f9000960:	f39ff0ef          	jal	ra,f9000898 <i2c_masterStartBlocking>
        *((volatile u32*) address) = data;
f9000964:	f8016937          	lui	s2,0xf8016
f9000968:	00001437          	lui	s0,0x1
f900096c:	b2040793          	addi	a5,s0,-1248 # b20 <__stack_size+0x320>
f9000970:	00f92023          	sw	a5,0(s2) # f8016000 <__freertos_irq_stack_top+0xff014660>

    i2c_txByte(I2C_CTRL_MIPI, 0x10<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f9000974:	f8016537          	lui	a0,0xf8016
f9000978:	f99ff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
f900097c:	0084d793          	srli	a5,s1,0x8
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f9000980:	b0040413          	addi	s0,s0,-1280
f9000984:	0087e7b3          	or	a5,a5,s0
f9000988:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f900098c:	f8016537          	lui	a0,0xf8016
f9000990:	f81ff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
f9000994:	0ff4f493          	andi	s1,s1,255
f9000998:	0084e4b3          	or	s1,s1,s0
f900099c:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f90009a0:	f8016537          	lui	a0,0xf8016
f90009a4:	f6dff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
f90009a8:	0089e433          	or	s0,s3,s0
f90009ac:	00892023          	sw	s0,0(s2)
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, data & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f90009b0:	f8016537          	lui	a0,0xf8016
f90009b4:	f5dff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
f90009b8:	f8016537          	lui	a0,0xf8016
f90009bc:	f25ff0ef          	jal	ra,f90008e0 <i2c_masterStopBlocking>
}
f90009c0:	01c12083          	lw	ra,28(sp)
f90009c4:	01812403          	lw	s0,24(sp)
f90009c8:	01412483          	lw	s1,20(sp)
f90009cc:	01012903          	lw	s2,16(sp)
f90009d0:	00c12983          	lw	s3,12(sp)
f90009d4:	02010113          	addi	sp,sp,32
f90009d8:	00008067          	ret

f90009dc <PiCam_ReadRegData>:

u8 PiCam_ReadRegData(u16 reg)
{
f90009dc:	fe010113          	addi	sp,sp,-32
f90009e0:	00112e23          	sw	ra,28(sp)
f90009e4:	00812c23          	sw	s0,24(sp)
f90009e8:	00912a23          	sw	s1,20(sp)
f90009ec:	01212823          	sw	s2,16(sp)
f90009f0:	01312623          	sw	s3,12(sp)
f90009f4:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
f90009f8:	f8016537          	lui	a0,0xf8016
f90009fc:	e9dff0ef          	jal	ra,f9000898 <i2c_masterStartBlocking>
f9000a00:	f8016937          	lui	s2,0xf8016
f9000a04:	00001437          	lui	s0,0x1
f9000a08:	b2040793          	addi	a5,s0,-1248 # b20 <__stack_size+0x320>
f9000a0c:	00f92023          	sw	a5,0(s2) # f8016000 <__freertos_irq_stack_top+0xff014660>

    i2c_txByte(I2C_CTRL_MIPI, 0x10<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f9000a10:	f8016537          	lui	a0,0xf8016
f9000a14:	efdff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
f9000a18:	0084d793          	srli	a5,s1,0x8
f9000a1c:	b0040993          	addi	s3,s0,-1280
f9000a20:	0137e7b3          	or	a5,a5,s3
f9000a24:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f9000a28:	f8016537          	lui	a0,0xf8016
f9000a2c:	ee5ff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
f9000a30:	0ff4f493          	andi	s1,s1,255
f9000a34:	0134e4b3          	or	s1,s1,s3
f9000a38:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f9000a3c:	f8016537          	lui	a0,0xf8016
f9000a40:	ed1ff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
f9000a44:	f8016537          	lui	a0,0xf8016
f9000a48:	e99ff0ef          	jal	ra,f90008e0 <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
f9000a4c:	f8016537          	lui	a0,0xf8016
f9000a50:	e49ff0ef          	jal	ra,f9000898 <i2c_masterStartBlocking>
f9000a54:	b2140793          	addi	a5,s0,-1247
f9000a58:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (0x10<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f9000a5c:	f8016537          	lui	a0,0xf8016
f9000a60:	eb1ff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
f9000a64:	bff40413          	addi	s0,s0,-1025
f9000a68:	00892023          	sw	s0,0(s2)
	//assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
f9000a6c:	f8016537          	lui	a0,0xf8016
f9000a70:	ea1ff0ef          	jal	ra,f9000910 <i2c_txNackBlocking>
	//assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
	outdata = i2c_rxData(I2C_CTRL_MIPI);
f9000a74:	f8016537          	lui	a0,0xf8016
f9000a78:	eb9ff0ef          	jal	ra,f9000930 <i2c_rxData>
f9000a7c:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
f9000a80:	f8016537          	lui	a0,0xf8016
f9000a84:	e5dff0ef          	jal	ra,f90008e0 <i2c_masterStopBlocking>

	return outdata;
}
f9000a88:	00040513          	mv	a0,s0
f9000a8c:	01c12083          	lw	ra,28(sp)
f9000a90:	01812403          	lw	s0,24(sp)
f9000a94:	01412483          	lw	s1,20(sp)
f9000a98:	01012903          	lw	s2,16(sp)
f9000a9c:	00c12983          	lw	s3,12(sp)
f9000aa0:	02010113          	addi	sp,sp,32
f9000aa4:	00008067          	ret

f9000aa8 <AccessCommSeq>:
void AccessCommSeq(void)
{
f9000aa8:	ff010113          	addi	sp,sp,-16
f9000aac:	00112623          	sw	ra,12(sp)
f9000ab0:	00812423          	sw	s0,8(sp)
	PiCam_WriteRegData(0x30EB, 0x05);
f9000ab4:	00500593          	li	a1,5
f9000ab8:	00003437          	lui	s0,0x3
f9000abc:	0eb40513          	addi	a0,s0,235 # 30eb <__stack_size+0x28eb>
f9000ac0:	e7dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(0x30EB, 0x0C);
f9000ac4:	00c00593          	li	a1,12
f9000ac8:	0eb40513          	addi	a0,s0,235
f9000acc:	e71ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(0x300A, 0xFF);
f9000ad0:	0ff00593          	li	a1,255
f9000ad4:	00a40513          	addi	a0,s0,10
f9000ad8:	e65ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(0x300B, 0xFF);
f9000adc:	0ff00593          	li	a1,255
f9000ae0:	00b40513          	addi	a0,s0,11
f9000ae4:	e59ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(0x30EB, 0x05);
f9000ae8:	00500593          	li	a1,5
f9000aec:	0eb40513          	addi	a0,s0,235
f9000af0:	e4dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(0x30EB, 0x09);
f9000af4:	00900593          	li	a1,9
f9000af8:	0eb40513          	addi	a0,s0,235
f9000afc:	e41ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000b00:	00c12083          	lw	ra,12(sp)
f9000b04:	00812403          	lw	s0,8(sp)
f9000b08:	01010113          	addi	sp,sp,16
f9000b0c:	00008067          	ret

f9000b10 <PiCam_Output_Size>:

void PiCam_Output_Size(u16 X,u16 Y)
{
f9000b10:	ff010113          	addi	sp,sp,-16
f9000b14:	00112623          	sw	ra,12(sp)
f9000b18:	00812423          	sw	s0,8(sp)
f9000b1c:	00912223          	sw	s1,4(sp)
f9000b20:	00050493          	mv	s1,a0
f9000b24:	00058413          	mv	s0,a1
	PiCam_WriteRegData(x_output_size_A_1	, X>>8);
f9000b28:	00855593          	srli	a1,a0,0x8
f9000b2c:	16c00513          	li	a0,364
f9000b30:	e0dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(x_output_size_A_0	, X & 0xFF);
f9000b34:	0ff4f593          	andi	a1,s1,255
f9000b38:	16d00513          	li	a0,365
f9000b3c:	e01ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(y_output_size_A_1	, Y>>8);
f9000b40:	00845593          	srli	a1,s0,0x8
f9000b44:	16e00513          	li	a0,366
f9000b48:	df5ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(y_output_size_A_0	, Y & 0xFF);
f9000b4c:	0ff47593          	andi	a1,s0,255
f9000b50:	16f00513          	li	a0,367
f9000b54:	de9ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000b58:	00c12083          	lw	ra,12(sp)
f9000b5c:	00812403          	lw	s0,8(sp)
f9000b60:	00412483          	lw	s1,4(sp)
f9000b64:	01010113          	addi	sp,sp,16
f9000b68:	00008067          	ret

f9000b6c <PiCam_Output_activePixel>:

void PiCam_Output_activePixel(u16 XStart,u16 XEnd, u16 YStart, u16 YEnd)
{
f9000b6c:	fe010113          	addi	sp,sp,-32
f9000b70:	00112e23          	sw	ra,28(sp)
f9000b74:	00812c23          	sw	s0,24(sp)
f9000b78:	00912a23          	sw	s1,20(sp)
f9000b7c:	01212823          	sw	s2,16(sp)
f9000b80:	01312623          	sw	s3,12(sp)
f9000b84:	00050993          	mv	s3,a0
f9000b88:	00058913          	mv	s2,a1
f9000b8c:	00060493          	mv	s1,a2
f9000b90:	00068413          	mv	s0,a3

	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
f9000b94:	00855593          	srli	a1,a0,0x8
f9000b98:	16400513          	li	a0,356
f9000b9c:	da1ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
f9000ba0:	0ff9f593          	andi	a1,s3,255
f9000ba4:	16500513          	li	a0,357
f9000ba8:	d95ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
f9000bac:	00895593          	srli	a1,s2,0x8
f9000bb0:	16600513          	li	a0,358
f9000bb4:	d89ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);
f9000bb8:	0ff97593          	andi	a1,s2,255
f9000bbc:	16700513          	li	a0,359
f9000bc0:	d7dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
f9000bc4:	0084d593          	srli	a1,s1,0x8
f9000bc8:	16800513          	li	a0,360
f9000bcc:	d71ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
f9000bd0:	0ff4f593          	andi	a1,s1,255
f9000bd4:	16900513          	li	a0,361
f9000bd8:	d65ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
f9000bdc:	00845593          	srli	a1,s0,0x8
f9000be0:	16a00513          	li	a0,362
f9000be4:	d59ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
f9000be8:	0ff47593          	andi	a1,s0,255
f9000bec:	16b00513          	li	a0,363
f9000bf0:	d4dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000bf4:	01c12083          	lw	ra,28(sp)
f9000bf8:	01812403          	lw	s0,24(sp)
f9000bfc:	01412483          	lw	s1,20(sp)
f9000c00:	01012903          	lw	s2,16(sp)
f9000c04:	00c12983          	lw	s3,12(sp)
f9000c08:	02010113          	addi	sp,sp,32
f9000c0c:	00008067          	ret

f9000c10 <PiCam_Output_activePixelX>:

void PiCam_Output_activePixelX(u16 XStart,u16 XEnd)
{
f9000c10:	ff010113          	addi	sp,sp,-16
f9000c14:	00112623          	sw	ra,12(sp)
f9000c18:	00812423          	sw	s0,8(sp)
f9000c1c:	00912223          	sw	s1,4(sp)
f9000c20:	00050493          	mv	s1,a0
f9000c24:	00058413          	mv	s0,a1
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
f9000c28:	00855593          	srli	a1,a0,0x8
f9000c2c:	16400513          	li	a0,356
f9000c30:	d0dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
f9000c34:	0ff4f593          	andi	a1,s1,255
f9000c38:	16500513          	li	a0,357
f9000c3c:	d01ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
f9000c40:	00845593          	srli	a1,s0,0x8
f9000c44:	16600513          	li	a0,358
f9000c48:	cf5ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);
f9000c4c:	0ff47593          	andi	a1,s0,255
f9000c50:	16700513          	li	a0,359
f9000c54:	ce9ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000c58:	00c12083          	lw	ra,12(sp)
f9000c5c:	00812403          	lw	s0,8(sp)
f9000c60:	00412483          	lw	s1,4(sp)
f9000c64:	01010113          	addi	sp,sp,16
f9000c68:	00008067          	ret

f9000c6c <PiCam_Output_activePixelY>:

void PiCam_Output_activePixelY(u16 YStart,u16 YEnd)
{
f9000c6c:	ff010113          	addi	sp,sp,-16
f9000c70:	00112623          	sw	ra,12(sp)
f9000c74:	00812423          	sw	s0,8(sp)
f9000c78:	00912223          	sw	s1,4(sp)
f9000c7c:	00050493          	mv	s1,a0
f9000c80:	00058413          	mv	s0,a1
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
f9000c84:	00855593          	srli	a1,a0,0x8
f9000c88:	16800513          	li	a0,360
f9000c8c:	cb1ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
f9000c90:	0ff4f593          	andi	a1,s1,255
f9000c94:	16900513          	li	a0,361
f9000c98:	ca5ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
f9000c9c:	00845593          	srli	a1,s0,0x8
f9000ca0:	16a00513          	li	a0,362
f9000ca4:	c99ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
f9000ca8:	0ff47593          	andi	a1,s0,255
f9000cac:	16b00513          	li	a0,363
f9000cb0:	c8dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000cb4:	00c12083          	lw	ra,12(sp)
f9000cb8:	00812403          	lw	s0,8(sp)
f9000cbc:	00412483          	lw	s1,4(sp)
f9000cc0:	01010113          	addi	sp,sp,16
f9000cc4:	00008067          	ret

f9000cc8 <PiCam_SetBinningMode>:

void PiCam_SetBinningMode(u8 Xmode, u8 Ymode)
{
f9000cc8:	ff010113          	addi	sp,sp,-16
f9000ccc:	00112623          	sw	ra,12(sp)
f9000cd0:	00812423          	sw	s0,8(sp)
f9000cd4:	00058413          	mv	s0,a1
	//0:no-binning
	//1:x2-binning
	//2:x4-binning
	//3:x2 analog (special)

	if(Xmode>=3)	Xmode=3;
f9000cd8:	00200793          	li	a5,2
f9000cdc:	00a7f463          	bgeu	a5,a0,f9000ce4 <PiCam_SetBinningMode+0x1c>
f9000ce0:	00300513          	li	a0,3
	if(Ymode>=3)	Ymode=3;
f9000ce4:	00200793          	li	a5,2
f9000ce8:	0087f463          	bgeu	a5,s0,f9000cf0 <PiCam_SetBinningMode+0x28>
f9000cec:	00300413          	li	s0,3

	PiCam_WriteRegData(BINNING_MODE_H_A, Xmode);
f9000cf0:	00050593          	mv	a1,a0
f9000cf4:	17400513          	li	a0,372
f9000cf8:	c45ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(BINNING_MODE_V_A, Ymode);
f9000cfc:	00040593          	mv	a1,s0
f9000d00:	17500513          	li	a0,373
f9000d04:	c39ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000d08:	00c12083          	lw	ra,12(sp)
f9000d0c:	00812403          	lw	s0,8(sp)
f9000d10:	01010113          	addi	sp,sp,16
f9000d14:	00008067          	ret

f9000d18 <PiCam_Output_ColorBarSize>:

void PiCam_Output_ColorBarSize(u16 X,u16 Y)
{
f9000d18:	ff010113          	addi	sp,sp,-16
f9000d1c:	00112623          	sw	ra,12(sp)
f9000d20:	00812423          	sw	s0,8(sp)
f9000d24:	00912223          	sw	s1,4(sp)
f9000d28:	00050493          	mv	s1,a0
f9000d2c:	00058413          	mv	s0,a1
	PiCam_WriteRegData(TP_WINDOW_WIDTH_1	, X>>8);
f9000d30:	00855593          	srli	a1,a0,0x8
f9000d34:	62400513          	li	a0,1572
f9000d38:	c05ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(TP_WINDOW_WIDTH_0	, X & 0xFF);
f9000d3c:	0ff4f593          	andi	a1,s1,255
f9000d40:	62500513          	li	a0,1573
f9000d44:	bf9ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_1	, Y>>8);
f9000d48:	00845593          	srli	a1,s0,0x8
f9000d4c:	62600513          	li	a0,1574
f9000d50:	bedff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_0	, Y & 0xFF);
f9000d54:	0ff47593          	andi	a1,s0,255
f9000d58:	62700513          	li	a0,1575
f9000d5c:	be1ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000d60:	00c12083          	lw	ra,12(sp)
f9000d64:	00812403          	lw	s0,8(sp)
f9000d68:	00412483          	lw	s1,4(sp)
f9000d6c:	01010113          	addi	sp,sp,16
f9000d70:	00008067          	ret

f9000d74 <PiCam_TestPattern>:

void PiCam_TestPattern(u8 Enable,u8 mode,u16 X,u16 Y)
{
f9000d74:	fe010113          	addi	sp,sp,-32
f9000d78:	00112e23          	sw	ra,28(sp)
f9000d7c:	00812c23          	sw	s0,24(sp)
f9000d80:	00912a23          	sw	s1,20(sp)
f9000d84:	01212823          	sw	s2,16(sp)
f9000d88:	01312623          	sw	s3,12(sp)
f9000d8c:	00050413          	mv	s0,a0
f9000d90:	00058993          	mv	s3,a1
f9000d94:	00060493          	mv	s1,a2
f9000d98:	00068913          	mv	s2,a3
	//0006h - 16 split inverted color bar
	//0007h - column counter
	//0008h - inverted column counter
	//0009h - PN31

	PiCam_WriteRegData(test_pattern_Ena, 0x00);
f9000d9c:	00000593          	li	a1,0
f9000da0:	60000513          	li	a0,1536
f9000da4:	b99ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

	if(Enable==0)	mode=0;
f9000da8:	00040463          	beqz	s0,f9000db0 <PiCam_TestPattern+0x3c>
f9000dac:	00098413          	mv	s0,s3

	PiCam_WriteRegData(test_pattern_mode, mode);
f9000db0:	00040593          	mv	a1,s0
f9000db4:	60100513          	li	a0,1537
f9000db8:	b85ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

	PiCam_Output_ColorBarSize(X,Y);
f9000dbc:	00090593          	mv	a1,s2
f9000dc0:	00048513          	mv	a0,s1
f9000dc4:	f55ff0ef          	jal	ra,f9000d18 <PiCam_Output_ColorBarSize>
}
f9000dc8:	01c12083          	lw	ra,28(sp)
f9000dcc:	01812403          	lw	s0,24(sp)
f9000dd0:	01412483          	lw	s1,20(sp)
f9000dd4:	01012903          	lw	s2,16(sp)
f9000dd8:	00c12983          	lw	s3,12(sp)
f9000ddc:	02010113          	addi	sp,sp,32
f9000de0:	00008067          	ret

f9000de4 <PiCam_Gainfilter>:

void PiCam_Gainfilter(u8 AGain, u16 DGain)
{
f9000de4:	ff010113          	addi	sp,sp,-16
f9000de8:	00112623          	sw	ra,12(sp)
f9000dec:	00812423          	sw	s0,8(sp)
f9000df0:	00058413          	mv	s0,a1
	PiCam_WriteRegData(ANA_GAIN_GLOBAL_A, AGain&0xFF);
f9000df4:	00050593          	mv	a1,a0
f9000df8:	15700513          	li	a0,343
f9000dfc:	b41ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_1, (DGain>>8)&0x0F);
f9000e00:	00845593          	srli	a1,s0,0x8
f9000e04:	00f5f593          	andi	a1,a1,15
f9000e08:	15800513          	li	a0,344
f9000e0c:	b31ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_0, DGain&0xFF);
f9000e10:	0ff47593          	andi	a1,s0,255
f9000e14:	15900513          	li	a0,345
f9000e18:	b25ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9000e1c:	00c12083          	lw	ra,12(sp)
f9000e20:	00812403          	lw	s0,8(sp)
f9000e24:	01010113          	addi	sp,sp,16
f9000e28:	00008067          	ret

f9000e2c <PiCam_init>:



void PiCam_init(void)
{
f9000e2c:	ff010113          	addi	sp,sp,-16
f9000e30:	00112623          	sw	ra,12(sp)
   PiCam_WriteRegData(mode_select, 0x00);
f9000e34:	00000593          	li	a1,0
f9000e38:	10000513          	li	a0,256
f9000e3c:	b01ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   AccessCommSeq();
f9000e40:	c69ff0ef          	jal	ra,f9000aa8 <AccessCommSeq>
   PiCam_WriteRegData(CSI_LANE_MODE, 0x01);
f9000e44:	00100593          	li	a1,1
f9000e48:	11400513          	li	a0,276
f9000e4c:	af1ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(DPHY_CTRL, 0x00);
f9000e50:	00000593          	li	a1,0
f9000e54:	12800513          	li	a0,296
f9000e58:	ae5ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(EXCK_FREQ_1, 0x18);
f9000e5c:	01800593          	li	a1,24
f9000e60:	12a00513          	li	a0,298
f9000e64:	ad9ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(EXCK_FREQ_0, 0x00);
f9000e68:	00000593          	li	a1,0
f9000e6c:	12b00513          	li	a0,299
f9000e70:	acdff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x04);
f9000e74:	00400593          	li	a1,4
f9000e78:	16000513          	li	a0,352
f9000e7c:	ac1ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0x59);
f9000e80:	05900593          	li	a1,89
f9000e84:	16100513          	li	a0,353
f9000e88:	ab5ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
f9000e8c:	00d00593          	li	a1,13
f9000e90:	16200513          	li	a0,354
f9000e94:	aa9ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);
f9000e98:	07800593          	li	a1,120
f9000e9c:	16300513          	li	a0,355
f9000ea0:	a9dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

//   PiCam_Output_activePixel(0, 3279, 0, 2463);

 PiCam_Output_activePixel(680, 3279, 0, 2463); //Use offset to have central view for 1920 frame width
f9000ea4:	000015b7          	lui	a1,0x1
f9000ea8:	99f58693          	addi	a3,a1,-1633 # 99f <__stack_size+0x19f>
f9000eac:	00000613          	li	a2,0
f9000eb0:	ccf58593          	addi	a1,a1,-817
f9000eb4:	2a800513          	li	a0,680
f9000eb8:	cb5ff0ef          	jal	ra,f9000b6c <PiCam_Output_activePixel>
//   PiCam_Output_activePixel(1500, 1596, 1200, 1296); //Use offset to have central view for 1920 frame width

 PiCam_Output_Size(1920, 1080);
f9000ebc:	43800593          	li	a1,1080
f9000ec0:	78000513          	li	a0,1920
f9000ec4:	c4dff0ef          	jal	ra,f9000b10 <PiCam_Output_Size>
	//PiCam_Output_Size(96, 96);
   //PiCam_Output_Size(1280, 720);
//   PiCam_Output_Size(640, 480);

   PiCam_WriteRegData(X_ODD_INC_A, 0x01);
f9000ec8:	00100593          	li	a1,1
f9000ecc:	17000513          	li	a0,368
f9000ed0:	a6dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(Y_ODD_INC_A, 0x01);
f9000ed4:	00100593          	li	a1,1
f9000ed8:	17100513          	li	a0,369
f9000edc:	a61ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

   //0: No binning; 1: x2 binning; 2: x4 binning; 3: x2 binning (analog special)
   PiCam_SetBinningMode(0, 0);
f9000ee0:	00000593          	li	a1,0
f9000ee4:	00000513          	li	a0,0
f9000ee8:	de1ff0ef          	jal	ra,f9000cc8 <PiCam_SetBinningMode>

   PiCam_WriteRegData(CSI_DATA_FORMAT_A_1, 0x0A);
f9000eec:	00a00593          	li	a1,10
f9000ef0:	18c00513          	li	a0,396
f9000ef4:	a49ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(CSI_DATA_FORMAT_A_0, 0x0A);
f9000ef8:	00a00593          	li	a1,10
f9000efc:	18d00513          	li	a0,397
f9000f00:	a3dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

   PiCam_WriteRegData(VTPXCK_DIV, 0x05);
f9000f04:	00500593          	li	a1,5
f9000f08:	30100513          	li	a0,769
f9000f0c:	a31ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(VTSYCK_DIV, 0x01);
f9000f10:	00100593          	li	a1,1
f9000f14:	30300513          	li	a0,771
f9000f18:	a25ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PREPLLCK_VT_DIV, 0x03);
f9000f1c:	00300593          	li	a1,3
f9000f20:	30400513          	li	a0,772
f9000f24:	a19ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PREPLLCK_OP_DIV, 0x03);
f9000f28:	00300593          	li	a1,3
f9000f2c:	30500513          	li	a0,773
f9000f30:	a0dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_VT_MPY_1, 0x00);
f9000f34:	00000593          	li	a1,0
f9000f38:	30600513          	li	a0,774
f9000f3c:	a01ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_VT_MPY_0, 0x39);
f9000f40:	03900593          	li	a1,57
f9000f44:	30700513          	li	a0,775
f9000f48:	9f5ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
f9000f4c:	00a00593          	li	a1,10
f9000f50:	30900513          	li	a0,777
f9000f54:	9e9ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
f9000f58:	00100593          	li	a1,1
f9000f5c:	30b00513          	li	a0,779
f9000f60:	9ddff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
f9000f64:	00000593          	li	a1,0
f9000f68:	30c00513          	li	a0,780
f9000f6c:	9d1ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);
f9000f70:	07200593          	li	a1,114
f9000f74:	30d00513          	li	a0,781
f9000f78:	9c5ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
f9000f7c:	00a00593          	li	a1,10
f9000f80:	30900513          	li	a0,777
f9000f84:	9b9ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
f9000f88:	00100593          	li	a1,1
f9000f8c:	30b00513          	li	a0,779
f9000f90:	9adff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
f9000f94:	00000593          	li	a1,0
f9000f98:	30c00513          	li	a0,780
f9000f9c:	9a1ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);
f9000fa0:	07200593          	li	a1,114
f9000fa4:	30d00513          	li	a0,781
f9000fa8:	995ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

   PiCam_WriteRegData(mode_select, 0x01);
f9000fac:	00100593          	li	a1,1
f9000fb0:	10000513          	li	a0,256
f9000fb4:	989ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

   PiCam_Gainfilter(0xB9, 0x200);
f9000fb8:	20000593          	li	a1,512
f9000fbc:	0b900513          	li	a0,185
f9000fc0:	e25ff0ef          	jal	ra,f9000de4 <PiCam_Gainfilter>

   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
f9000fc4:	00d00593          	li	a1,13
f9000fc8:	16200513          	li	a0,354
f9000fcc:	971ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);
f9000fd0:	07800593          	li	a1,120
f9000fd4:	16300513          	li	a0,355
f9000fd8:	965ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x04);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);
*/

   //Longer camera exposure time. Trade-off with lower frame rate.   
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x06);
f9000fdc:	00600593          	li	a1,6
f9000fe0:	16000513          	li	a0,352
f9000fe4:	959ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0xE3);
f9000fe8:	0e300593          	li	a1,227
f9000fec:	16100513          	li	a0,353
f9000ff0:	94dff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x04);
f9000ff4:	00400593          	li	a1,4
f9000ff8:	15a00513          	li	a0,346
f9000ffc:	941ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);
f9001000:	05400593          	li	a1,84
f9001004:	15b00513          	li	a0,347
f9001008:	935ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>

   PiCam_WriteRegData(IMG_ORIENTATION_A, 0x00);
f900100c:	00000593          	li	a1,0
f9001010:	17200513          	li	a0,370
f9001014:	929ff0ef          	jal	ra,f900093c <PiCam_WriteRegData>
}
f9001018:	00c12083          	lw	ra,12(sp)
f900101c:	01010113          	addi	sp,sp,16
f9001020:	00008067          	ret

f9001024 <trap_entry>:
.global  trap_entry
.align(2) //mtvec require 32 bits allignement
trap_entry:
  addi sp,sp, -16*4
f9001024:	fc010113          	addi	sp,sp,-64
  sw x1,   0*4(sp)
f9001028:	00112023          	sw	ra,0(sp)
  sw x5,   1*4(sp)
f900102c:	00512223          	sw	t0,4(sp)
  sw x6,   2*4(sp)
f9001030:	00612423          	sw	t1,8(sp)
  sw x7,   3*4(sp)
f9001034:	00712623          	sw	t2,12(sp)
  sw x10,  4*4(sp)
f9001038:	00a12823          	sw	a0,16(sp)
  sw x11,  5*4(sp)
f900103c:	00b12a23          	sw	a1,20(sp)
  sw x12,  6*4(sp)
f9001040:	00c12c23          	sw	a2,24(sp)
  sw x13,  7*4(sp)
f9001044:	00d12e23          	sw	a3,28(sp)
  sw x14,  8*4(sp)
f9001048:	02e12023          	sw	a4,32(sp)
  sw x15,  9*4(sp)
f900104c:	02f12223          	sw	a5,36(sp)
  sw x16, 10*4(sp)
f9001050:	03012423          	sw	a6,40(sp)
  sw x17, 11*4(sp)
f9001054:	03112623          	sw	a7,44(sp)
  sw x28, 12*4(sp)
f9001058:	03c12823          	sw	t3,48(sp)
  sw x29, 13*4(sp)
f900105c:	03d12a23          	sw	t4,52(sp)
  sw x30, 14*4(sp)
f9001060:	03e12c23          	sw	t5,56(sp)
  sw x31, 15*4(sp)
f9001064:	03f12e23          	sw	t6,60(sp)
  call trap
f9001068:	821ff0ef          	jal	ra,f9000888 <trap>
  lw x1 ,  0*4(sp)
f900106c:	00012083          	lw	ra,0(sp)
  lw x5,   1*4(sp)
f9001070:	00412283          	lw	t0,4(sp)
  lw x6,   2*4(sp)
f9001074:	00812303          	lw	t1,8(sp)
  lw x7,   3*4(sp)
f9001078:	00c12383          	lw	t2,12(sp)
  lw x10,  4*4(sp)
f900107c:	01012503          	lw	a0,16(sp)
  lw x11,  5*4(sp)
f9001080:	01412583          	lw	a1,20(sp)
  lw x12,  6*4(sp)
f9001084:	01812603          	lw	a2,24(sp)
  lw x13,  7*4(sp)
f9001088:	01c12683          	lw	a3,28(sp)
  lw x14,  8*4(sp)
f900108c:	02012703          	lw	a4,32(sp)
  lw x15,  9*4(sp)
f9001090:	02412783          	lw	a5,36(sp)
  lw x16, 10*4(sp)
f9001094:	02812803          	lw	a6,40(sp)
  lw x17, 11*4(sp)
f9001098:	02c12883          	lw	a7,44(sp)
  lw x28, 12*4(sp)
f900109c:	03012e03          	lw	t3,48(sp)
  lw x29, 13*4(sp)
f90010a0:	03412e83          	lw	t4,52(sp)
  lw x30, 14*4(sp)
f90010a4:	03812f03          	lw	t5,56(sp)
  lw x31, 15*4(sp)
f90010a8:	03c12f83          	lw	t6,60(sp)
  addi sp,sp, 16*4
f90010ac:	04010113          	addi	sp,sp,64
  mret
f90010b0:	30200073          	mret

f90010b4 <__mulsi3>:
f90010b4:	00050613          	mv	a2,a0
f90010b8:	00000513          	li	a0,0
f90010bc:	0015f693          	andi	a3,a1,1
f90010c0:	00068463          	beqz	a3,f90010c8 <__mulsi3+0x14>
f90010c4:	00c50533          	add	a0,a0,a2
f90010c8:	0015d593          	srli	a1,a1,0x1
f90010cc:	00161613          	slli	a2,a2,0x1
f90010d0:	fe0596e3          	bnez	a1,f90010bc <__mulsi3+0x8>
f90010d4:	00008067          	ret

f90010d8 <__divsi3>:
f90010d8:	06054063          	bltz	a0,f9001138 <__umodsi3+0x10>
f90010dc:	0605c663          	bltz	a1,f9001148 <__umodsi3+0x20>

f90010e0 <__udivsi3>:
f90010e0:	00058613          	mv	a2,a1
f90010e4:	00050593          	mv	a1,a0
f90010e8:	fff00513          	li	a0,-1
f90010ec:	02060c63          	beqz	a2,f9001124 <__udivsi3+0x44>
f90010f0:	00100693          	li	a3,1
f90010f4:	00b67a63          	bgeu	a2,a1,f9001108 <__udivsi3+0x28>
f90010f8:	00c05863          	blez	a2,f9001108 <__udivsi3+0x28>
f90010fc:	00161613          	slli	a2,a2,0x1
f9001100:	00169693          	slli	a3,a3,0x1
f9001104:	feb66ae3          	bltu	a2,a1,f90010f8 <__udivsi3+0x18>
f9001108:	00000513          	li	a0,0
f900110c:	00c5e663          	bltu	a1,a2,f9001118 <__udivsi3+0x38>
f9001110:	40c585b3          	sub	a1,a1,a2
f9001114:	00d56533          	or	a0,a0,a3
f9001118:	0016d693          	srli	a3,a3,0x1
f900111c:	00165613          	srli	a2,a2,0x1
f9001120:	fe0696e3          	bnez	a3,f900110c <__udivsi3+0x2c>
f9001124:	00008067          	ret

f9001128 <__umodsi3>:
f9001128:	00008293          	mv	t0,ra
f900112c:	fb5ff0ef          	jal	ra,f90010e0 <__udivsi3>
f9001130:	00058513          	mv	a0,a1
f9001134:	00028067          	jr	t0
f9001138:	40a00533          	neg	a0,a0
f900113c:	0005d863          	bgez	a1,f900114c <__umodsi3+0x24>
f9001140:	40b005b3          	neg	a1,a1
f9001144:	f9dff06f          	j	f90010e0 <__udivsi3>
f9001148:	40b005b3          	neg	a1,a1
f900114c:	00008293          	mv	t0,ra
f9001150:	f91ff0ef          	jal	ra,f90010e0 <__udivsi3>
f9001154:	40a00533          	neg	a0,a0
f9001158:	00028067          	jr	t0

f900115c <__modsi3>:
f900115c:	00008293          	mv	t0,ra
f9001160:	0005ca63          	bltz	a1,f9001174 <__modsi3+0x18>
f9001164:	00054c63          	bltz	a0,f900117c <__modsi3+0x20>
f9001168:	f79ff0ef          	jal	ra,f90010e0 <__udivsi3>
f900116c:	00058513          	mv	a0,a1
f9001170:	00028067          	jr	t0
f9001174:	40b005b3          	neg	a1,a1
f9001178:	fe0558e3          	bgez	a0,f9001168 <__modsi3+0xc>
f900117c:	40a00533          	neg	a0,a0
f9001180:	f61ff0ef          	jal	ra,f90010e0 <__udivsi3>
f9001184:	40b00533          	neg	a0,a1
f9001188:	00028067          	jr	t0
