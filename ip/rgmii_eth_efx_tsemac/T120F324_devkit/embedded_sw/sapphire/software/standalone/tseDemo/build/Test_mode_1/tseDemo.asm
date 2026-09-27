
build/tseDemo.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00001197          	auipc	gp,0x1
f9000004:	1f018193          	addi	gp,gp,496 # f90011f0 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	00002117          	auipc	sp,0x2
f900000c:	a0810113          	addi	sp,sp,-1528 # f9001a10 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f9000010:	00000517          	auipc	a0,0x0
f9000014:	78450513          	addi	a0,a0,1924 # f9000794 <__init_array_end>
	la a1, _data
f9000018:	00000597          	auipc	a1,0x0
f900001c:	77c58593          	addi	a1,a1,1916 # f9000794 <__init_array_end>
	la a2, _edata
f9000020:	81c18613          	addi	a2,gp,-2020 # f9000a0c <__bss_start>
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
f900003c:	81c18513          	addi	a0,gp,-2020 # f9000a0c <__bss_start>
	la a1, _end
f9000040:	82018593          	addi	a1,gp,-2016 # f9000a10 <_end>
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
f9000058:	714000ef          	jal	ra,f900076c <main>

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
f9000070:	00000417          	auipc	s0,0x0
f9000074:	72440413          	addi	s0,s0,1828 # f9000794 <__init_array_end>
f9000078:	00000917          	auipc	s2,0x0
f900007c:	71c90913          	addi	s2,s2,1820 # f9000794 <__init_array_end>
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
f90000ac:	00000417          	auipc	s0,0x0
f90000b0:	6e840413          	addi	s0,s0,1768 # f9000794 <__init_array_end>
f90000b4:	00000917          	auipc	s2,0x0
f90000b8:	6e090913          	addi	s2,s2,1760 # f9000794 <__init_array_end>
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

f90000f8 <uart_writeAvailability>:
#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
f90000f8:	00452503          	lw	a0,4(a0)
        enum UartStop stop;
        u32 clockDivider;
    } Uart_Config;
    
    static u32 uart_writeAvailability(u32 reg){
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
f90000fc:	01055513          	srli	a0,a0,0x10
    }
f9000100:	0ff57513          	andi	a0,a0,255
f9000104:	00008067          	ret

f9000108 <uart_write>:
    static u32 uart_readOccupancy(u32 reg){
        return read_u32(reg + UART_STATUS) >> 24;
    }
    
    static void uart_write(u32 reg, char data){
f9000108:	ff010113          	addi	sp,sp,-16
f900010c:	00112623          	sw	ra,12(sp)
f9000110:	00812423          	sw	s0,8(sp)
f9000114:	00912223          	sw	s1,4(sp)
f9000118:	00050413          	mv	s0,a0
f900011c:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
f9000120:	00040513          	mv	a0,s0
f9000124:	fd5ff0ef          	jal	ra,f90000f8 <uart_writeAvailability>
f9000128:	fe050ce3          	beqz	a0,f9000120 <uart_write+0x18>
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f900012c:	00942023          	sw	s1,0(s0)
        write_u32(data, reg + UART_DATA);
    }
f9000130:	00c12083          	lw	ra,12(sp)
f9000134:	00812403          	lw	s0,8(sp)
f9000138:	00412483          	lw	s1,4(sp)
f900013c:	01010113          	addi	sp,sp,16
f9000140:	00008067          	ret

f9000144 <uart_writeStr>:
    
    static void uart_writeStr(u32 reg, const char* str){
f9000144:	ff010113          	addi	sp,sp,-16
f9000148:	00112623          	sw	ra,12(sp)
f900014c:	00812423          	sw	s0,8(sp)
f9000150:	00912223          	sw	s1,4(sp)
f9000154:	00050493          	mv	s1,a0
f9000158:	00058413          	mv	s0,a1
        while(*str) uart_write(reg, *str++);
f900015c:	00044583          	lbu	a1,0(s0)
f9000160:	00058a63          	beqz	a1,f9000174 <uart_writeStr+0x30>
f9000164:	00140413          	addi	s0,s0,1
f9000168:	00048513          	mv	a0,s1
f900016c:	f9dff0ef          	jal	ra,f9000108 <uart_write>
f9000170:	fedff06f          	j	f900015c <uart_writeStr+0x18>
    }
f9000174:	00c12083          	lw	ra,12(sp)
f9000178:	00812403          	lw	s0,8(sp)
f900017c:	00412483          	lw	s1,4(sp)
f9000180:	01010113          	addi	sp,sp,16
f9000184:	00008067          	ret

f9000188 <clint_uDelay>:
    
        return (((u64)hi) << 32) | lo;
    }
    
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f9000188:	000f47b7          	lui	a5,0xf4
f900018c:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf3240>
f9000190:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f9000194:	0000c7b7          	lui	a5,0xc
f9000198:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0xaff8>
f900019c:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f90001a0:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90001a4:	02a58533          	mul	a0,a1,a0
f90001a8:	00f50533          	add	a0,a0,a5
f90001ac:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f90001b0:	40f507b3          	sub	a5,a0,a5
f90001b4:	fe07dce3          	bgez	a5,f90001ac <clint_uDelay+0x24>
    }
f90001b8:	00008067          	ret

f90001bc <bsp_printHex>:
#define configCPU_CLOCK_HZ              ( ( uint32_t ) ( BSP_CLINT_HZ ) )
#define BSP_LED_GPIO                    SYSTEM_GPIO_0_IO_CTRL
#define BSP_LED_MASK                    0xf

    static void bsp_printHex(uint32_t val)
    {
f90001bc:	ff010113          	addi	sp,sp,-16
f90001c0:	00112623          	sw	ra,12(sp)
f90001c4:	00812423          	sw	s0,8(sp)
f90001c8:	00912223          	sw	s1,4(sp)
f90001cc:	00050493          	mv	s1,a0
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
f90001d0:	01c00413          	li	s0,28
f90001d4:	0280006f          	j	f90001fc <bsp_printHex+0x40>
            uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
f90001d8:	0084d7b3          	srl	a5,s1,s0
f90001dc:	00f7f713          	andi	a4,a5,15
f90001e0:	f90007b7          	lui	a5,0xf9000
f90001e4:	79478793          	addi	a5,a5,1940 # f9000794 <__freertos_irq_stack_top+0xffffed84>
f90001e8:	00e787b3          	add	a5,a5,a4
f90001ec:	0007c583          	lbu	a1,0(a5)
f90001f0:	f8010537          	lui	a0,0xf8010
f90001f4:	f15ff0ef          	jal	ra,f9000108 <uart_write>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
f90001f8:	ffc40413          	addi	s0,s0,-4
f90001fc:	fc045ee3          	bgez	s0,f90001d8 <bsp_printHex+0x1c>
        }
        uart_write(BSP_UART_TERMINAL, '\n');
f9000200:	00a00593          	li	a1,10
f9000204:	f8010537          	lui	a0,0xf8010
f9000208:	f01ff0ef          	jal	ra,f9000108 <uart_write>
        uart_write(BSP_UART_TERMINAL, '\r');
f900020c:	00d00593          	li	a1,13
f9000210:	f8010537          	lui	a0,0xf8010
f9000214:	ef5ff0ef          	jal	ra,f9000108 <uart_write>
    }
f9000218:	00c12083          	lw	ra,12(sp)
f900021c:	00812403          	lw	s0,8(sp)
f9000220:	00412483          	lw	s1,4(sp)
f9000224:	01010113          	addi	sp,sp,16
f9000228:	00008067          	ret

f900022c <bsp_print>:
    
    static void bsp_print(uint8_t * data) {
f900022c:	ff010113          	addi	sp,sp,-16
f9000230:	00112623          	sw	ra,12(sp)
        uart_writeStr(BSP_UART_TERMINAL, (const char*)data);
f9000234:	00050593          	mv	a1,a0
f9000238:	f8010537          	lui	a0,0xf8010
f900023c:	f09ff0ef          	jal	ra,f9000144 <uart_writeStr>
        uart_write(BSP_UART_TERMINAL, '\n');
f9000240:	00a00593          	li	a1,10
f9000244:	f8010537          	lui	a0,0xf8010
f9000248:	ec1ff0ef          	jal	ra,f9000108 <uart_write>
        uart_write(BSP_UART_TERMINAL, '\r');
f900024c:	00d00593          	li	a1,13
f9000250:	f8010537          	lui	a0,0xf8010
f9000254:	eb5ff0ef          	jal	ra,f9000108 <uart_write>
    }
f9000258:	00c12083          	lw	ra,12(sp)
f900025c:	01010113          	addi	sp,sp,16
f9000260:	00008067          	ret

f9000264 <bsp_printReg>:
        bsp_printHexDigit(byte >> 4);
        bsp_printHexDigit(byte & 0x0F);
    }

    static void bsp_printReg(char* s, u32 data)
    {
f9000264:	ff010113          	addi	sp,sp,-16
f9000268:	00112623          	sw	ra,12(sp)
f900026c:	00812423          	sw	s0,8(sp)
f9000270:	00058413          	mv	s0,a1
        bsp_putString(s);
f9000274:	00050593          	mv	a1,a0
f9000278:	f8010537          	lui	a0,0xf8010
f900027c:	ec9ff0ef          	jal	ra,f9000144 <uart_writeStr>
        bsp_printHex(data);
f9000280:	00040513          	mv	a0,s0
f9000284:	f39ff0ef          	jal	ra,f90001bc <bsp_printHex>
    }
f9000288:	00c12083          	lw	ra,12(sp)
f900028c:	00812403          	lw	s0,8(sp)
f9000290:	01010113          	addi	sp,sp,16
f9000294:	00008067          	ret

f9000298 <MacAddrSet>:
	}
}

/************************** Function File ***************************/
static void MacAddrSet(u32 dst_addr_ins, u32 src_addr_ins)
{
f9000298:	ff010113          	addi	sp,sp,-16
f900029c:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f90002a0:	f81007b7          	lui	a5,0xf8100
f90002a4:	00010737          	lui	a4,0x10
f90002a8:	fff70713          	addi	a4,a4,-1 # ffff <__stack_size+0xefff>
f90002ac:	18e7a423          	sw	a4,392(a5) # f8100188 <__freertos_irq_stack_top+0xff0fe778>
f90002b0:	fff00713          	li	a4,-1
f90002b4:	18e7a223          	sw	a4,388(a5)
f90002b8:	18a7a023          	sw	a0,384(a5)
f90002bc:	0000f737          	lui	a4,0xf
f90002c0:	ae870713          	addi	a4,a4,-1304 # eae8 <__stack_size+0xdae8>
f90002c4:	00e7a823          	sw	a4,16(a5)
f90002c8:	5e006737          	lui	a4,0x5e006
f90002cc:	0c870713          	addi	a4,a4,200 # 5e0060c8 <__stack_size+0x5e0050c8>
f90002d0:	00e7a623          	sw	a4,12(a5)
        return *((volatile u32*) address);
f90002d4:	0087a703          	lw	a4,8(a5)
    //mac_addr[47:32]
	write_u32(SRC_MAC_H, (TSEMAC_CSR+0x010));
    //mac_addr[31:0]
	write_u32(SRC_MAC_L, (TSEMAC_CSR+0x00c));
	//src mac addr ins set
	Value = read_u32(TSEMAC_CSR+0x008) & TX_ADDR_INS_MASK;
f90002d8:	bff77713          	andi	a4,a4,-1025
	Value |= (src_addr_ins&0x1)<<9;
f90002dc:	00959593          	slli	a1,a1,0x9
f90002e0:	2005f593          	andi	a1,a1,512
f90002e4:	00e5e5b3          	or	a1,a1,a4
        *((volatile u32*) address) = data;
f90002e8:	00b7a423          	sw	a1,8(a5)
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac Address.");
f90002ec:	f9000537          	lui	a0,0xf9000
f90002f0:	7a850513          	addi	a0,a0,1960 # f90007a8 <__freertos_irq_stack_top+0xffffed98>
f90002f4:	f39ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f90002f8:	00c12083          	lw	ra,12(sp)
f90002fc:	01010113          	addi	sp,sp,16
f9000300:	00008067          	ret

f9000304 <MacCntClean>:
	write_u32(Value, (TSEMAC_CSR+0x008));
}

/************************** Function File ***************************/
static void MacCntClean()
{
f9000304:	ff010113          	addi	sp,sp,-16
f9000308:	00112623          	sw	ra,12(sp)
f900030c:	00812423          	sw	s0,8(sp)
f9000310:	00912223          	sw	s1,4(sp)
        return *((volatile u32*) address);
f9000314:	f81004b7          	lui	s1,0xf8100
f9000318:	0084a403          	lw	s0,8(s1) # f8100008 <__freertos_irq_stack_top+0xff0fe5f8>
	u32 Value;
	//Set cnt_reset 1
	Value = read_u32(TSEMAC_CSR+0x008) & CNT_RST_MASK;
f900031c:	800007b7          	lui	a5,0x80000
f9000320:	fff7c713          	not	a4,a5
f9000324:	00e47433          	and	s0,s0,a4
	Value |= 0x80000000;
f9000328:	00f467b3          	or	a5,s0,a5
        *((volatile u32*) address) = data;
f900032c:	00f4a423          	sw	a5,8(s1)
	write_u32(Value, (TSEMAC_CSR+0x008));
	bsp_uDelay(1);
f9000330:	f8b00637          	lui	a2,0xf8b00
f9000334:	02faf5b7          	lui	a1,0x2faf
f9000338:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f900033c:	00100513          	li	a0,1
f9000340:	e49ff0ef          	jal	ra,f9000188 <clint_uDelay>
f9000344:	0084a423          	sw	s0,8(s1)
	//Set cnt_reset 0
	Value &= CNT_RST_MASK;
	Value |= 0x0;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
		bsp_print("Info : Mac Reset Statistics Counters.");
f9000348:	f9000537          	lui	a0,0xf9000
f900034c:	7c050513          	addi	a0,a0,1984 # f90007c0 <__freertos_irq_stack_top+0xffffedb0>
f9000350:	eddff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f9000354:	00c12083          	lw	ra,12(sp)
f9000358:	00812403          	lw	s0,8(sp)
f900035c:	00412483          	lw	s1,4(sp)
f9000360:	01010113          	addi	sp,sp,16
f9000364:	00008067          	ret

f9000368 <CntMonitor>:

/************************** Function File ***************************/
static void CntMonitor()
{
f9000368:	ff010113          	addi	sp,sp,-16
f900036c:	00112623          	sw	ra,12(sp)
f9000370:	00812423          	sw	s0,8(sp)
f9000374:	00912223          	sw	s1,4(sp)
	bsp_print("--------------------");
f9000378:	f90004b7          	lui	s1,0xf9000
f900037c:	7e848513          	addi	a0,s1,2024 # f90007e8 <__freertos_irq_stack_top+0xffffedd8>
f9000380:	eadff0ef          	jal	ra,f900022c <bsp_print>
        return *((volatile u32*) address);
f9000384:	f8100437          	lui	s0,0xf8100
f9000388:	06842583          	lw	a1,104(s0) # f8100068 <__freertos_irq_stack_top+0xff0fe658>
	bsp_printReg("aFramesTransmittedOK :"       , read_u32(TSEMAC_CSR+0x68));
f900038c:	f9001537          	lui	a0,0xf9001
f9000390:	80050513          	addi	a0,a0,-2048 # f9000800 <__freertos_irq_stack_top+0xffffedf0>
f9000394:	ed1ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000398:	06c42583          	lw	a1,108(s0)
	bsp_printReg("aFramesReceivedOK :"          , read_u32(TSEMAC_CSR+0x6c));
f900039c:	f9001537          	lui	a0,0xf9001
f90003a0:	81850513          	addi	a0,a0,-2024 # f9000818 <__freertos_irq_stack_top+0xffffee08>
f90003a4:	ec1ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003a8:	08842583          	lw	a1,136(s0)
	bsp_printReg("ifInErrors :"                 , read_u32(TSEMAC_CSR+0x88));
f90003ac:	f9001537          	lui	a0,0xf9001
f90003b0:	82c50513          	addi	a0,a0,-2004 # f900082c <__freertos_irq_stack_top+0xffffee1c>
f90003b4:	eb1ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003b8:	08c42583          	lw	a1,140(s0)
	bsp_printReg("ifOutErrors :"                , read_u32(TSEMAC_CSR+0x8c));
f90003bc:	f9001537          	lui	a0,0xf9001
f90003c0:	83c50513          	addi	a0,a0,-1988 # f900083c <__freertos_irq_stack_top+0xffffee2c>
f90003c4:	ea1ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003c8:	0b442583          	lw	a1,180(s0)
	bsp_printReg("etherStatsPkts :"             , read_u32(TSEMAC_CSR+0xb4));
f90003cc:	f9001537          	lui	a0,0xf9001
f90003d0:	84c50513          	addi	a0,a0,-1972 # f900084c <__freertos_irq_stack_top+0xffffee3c>
f90003d4:	e91ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003d8:	0b842583          	lw	a1,184(s0)
	bsp_printReg("etherStatsUndersizePkts :"    , read_u32(TSEMAC_CSR+0xb8));
f90003dc:	f9001537          	lui	a0,0xf9001
f90003e0:	86050513          	addi	a0,a0,-1952 # f9000860 <__freertos_irq_stack_top+0xffffee50>
f90003e4:	e81ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003e8:	0bc42583          	lw	a1,188(s0)
	bsp_printReg("etherStatsOversizePkts :"     , read_u32(TSEMAC_CSR+0xbc));
f90003ec:	f9001537          	lui	a0,0xf9001
f90003f0:	87c50513          	addi	a0,a0,-1924 # f900087c <__freertos_irq_stack_top+0xffffee6c>
f90003f4:	e71ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003f8:	09c42583          	lw	a1,156(s0)
	bsp_printReg("aRxFilterFramesErrors :"      , read_u32(TSEMAC_CSR+0x9c));
f90003fc:	f9001537          	lui	a0,0xf9001
f9000400:	89850513          	addi	a0,a0,-1896 # f9000898 <__freertos_irq_stack_top+0xffffee88>
f9000404:	e61ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000408:	07042583          	lw	a1,112(s0)
	bsp_printReg("aFrameCheckSequenceErrors :"  , read_u32(TSEMAC_CSR+0x70));
f900040c:	f9001537          	lui	a0,0xf9001
f9000410:	8b050513          	addi	a0,a0,-1872 # f90008b0 <__freertos_irq_stack_top+0xffffeea0>
f9000414:	e51ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000418:	08042583          	lw	a1,128(s0)
	bsp_printReg("aTxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x80));
f900041c:	f9001537          	lui	a0,0xf9001
f9000420:	8cc50513          	addi	a0,a0,-1844 # f90008cc <__freertos_irq_stack_top+0xffffeebc>
f9000424:	e41ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000428:	08442583          	lw	a1,132(s0)
	bsp_printReg("aRxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x84));
f900042c:	f9001537          	lui	a0,0xf9001
f9000430:	8e450513          	addi	a0,a0,-1820 # f90008e4 <__freertos_irq_stack_top+0xffffeed4>
f9000434:	e31ff0ef          	jal	ra,f9000264 <bsp_printReg>
	bsp_print("--------------------");
f9000438:	7e848513          	addi	a0,s1,2024
f900043c:	df1ff0ef          	jal	ra,f900022c <bsp_print>
}
f9000440:	00c12083          	lw	ra,12(sp)
f9000444:	00812403          	lw	s0,8(sp)
f9000448:	00412483          	lw	s1,4(sp)
f900044c:	01010113          	addi	sp,sp,16
f9000450:	00008067          	ret

f9000454 <Phy_Wr>:
#include "tseDemo.h"


/************************** Function File ***************************/
static void Phy_Wr(u32 RegAddr, u32 Data)
{
f9000454:	ff010113          	addi	sp,sp,-16
f9000458:	00112623          	sw	ra,12(sp)
f900045c:	00812423          	sw	s0,8(sp)
f9000460:	00058413          	mv	s0,a1
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_CSR+0x108));
f9000464:	01f57713          	andi	a4,a0,31
f9000468:	70076713          	ori	a4,a4,1792
        *((volatile u32*) address) = data;
f900046c:	f81007b7          	lui	a5,0xf8100
f9000470:	10e7a423          	sw	a4,264(a5) # f8100108 <__freertos_irq_stack_top+0xff0fe6f8>
f9000474:	10b7a623          	sw	a1,268(a5)
f9000478:	00200713          	li	a4,2
f900047c:	10e7a223          	sw	a4,260(a5)
    write_u32(Data, (TSEMAC_CSR+0x10c));
    write_u32(0x2, (TSEMAC_CSR+0x104));
    if(PRINTF_EN == 1) {
        bsp_printReg("Wr Phy Addr : ", RegAddr);
f9000480:	00050593          	mv	a1,a0
f9000484:	f9001537          	lui	a0,0xf9001
f9000488:	8fc50513          	addi	a0,a0,-1796 # f90008fc <__freertos_irq_stack_top+0xffffeeec>
f900048c:	dd9ff0ef          	jal	ra,f9000264 <bsp_printReg>
        bsp_printReg("Wr Phy Data : ", Data);
f9000490:	00040593          	mv	a1,s0
f9000494:	f9001537          	lui	a0,0xf9001
f9000498:	90c50513          	addi	a0,a0,-1780 # f900090c <__freertos_irq_stack_top+0xffffeefc>
f900049c:	dc9ff0ef          	jal	ra,f9000264 <bsp_printReg>
    }
}
f90004a0:	00c12083          	lw	ra,12(sp)
f90004a4:	00812403          	lw	s0,8(sp)
f90004a8:	01010113          	addi	sp,sp,16
f90004ac:	00008067          	ret

f90004b0 <Phy_Rd>:

static u32 Phy_Rd(u32 RegAddr)
{
f90004b0:	ff010113          	addi	sp,sp,-16
f90004b4:	00112623          	sw	ra,12(sp)
f90004b8:	00812423          	sw	s0,8(sp)
f90004bc:	00912223          	sw	s1,4(sp)
f90004c0:	00050493          	mv	s1,a0
    u32 Value;
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_CSR+0x108));
f90004c4:	01f57793          	andi	a5,a0,31
f90004c8:	7007e793          	ori	a5,a5,1792
f90004cc:	f8100437          	lui	s0,0xf8100
f90004d0:	10f42423          	sw	a5,264(s0) # f8100108 <__freertos_irq_stack_top+0xff0fe6f8>
f90004d4:	00100793          	li	a5,1
f90004d8:	10f42223          	sw	a5,260(s0)
    write_u32(0x1, (TSEMAC_CSR+0x104));
    bsp_uDelay(1000);
f90004dc:	f8b00637          	lui	a2,0xf8b00
f90004e0:	02faf5b7          	lui	a1,0x2faf
f90004e4:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90004e8:	3e800513          	li	a0,1000
f90004ec:	c9dff0ef          	jal	ra,f9000188 <clint_uDelay>
        return *((volatile u32*) address);
f90004f0:	11042403          	lw	s0,272(s0)
    Value = read_u32(TSEMAC_CSR+0x110);
    if(PRINTF_EN == 1) {
        bsp_printReg("Rd Phy Addr : ", RegAddr);
f90004f4:	00048593          	mv	a1,s1
f90004f8:	f9001537          	lui	a0,0xf9001
f90004fc:	91c50513          	addi	a0,a0,-1764 # f900091c <__freertos_irq_stack_top+0xffffef0c>
f9000500:	d65ff0ef          	jal	ra,f9000264 <bsp_printReg>
        bsp_printReg("Return Value : ", Value);
f9000504:	00040593          	mv	a1,s0
f9000508:	f9001537          	lui	a0,0xf9001
f900050c:	92c50513          	addi	a0,a0,-1748 # f900092c <__freertos_irq_stack_top+0xffffef1c>
f9000510:	d55ff0ef          	jal	ra,f9000264 <bsp_printReg>
    }
    return Value;
}
f9000514:	00040513          	mv	a0,s0
f9000518:	00c12083          	lw	ra,12(sp)
f900051c:	00812403          	lw	s0,8(sp)
f9000520:	00412483          	lw	s1,4(sp)
f9000524:	01010113          	addi	sp,sp,16
f9000528:	00008067          	ret

f900052c <PhyDlySetRXTX>:

/************************** Function File ***************************/
static void PhyDlySetRXTX(int RX_delay, int TX_delay)
{
f900052c:	fe010113          	addi	sp,sp,-32
f9000530:	00112e23          	sw	ra,28(sp)
f9000534:	00812c23          	sw	s0,24(sp)
f9000538:	00912a23          	sw	s1,20(sp)
f900053c:	01212823          	sw	s2,16(sp)
f9000540:	01312623          	sw	s3,12(sp)
f9000544:	01412423          	sw	s4,8(sp)
f9000548:	00050413          	mv	s0,a0
f900054c:	00058913          	mv	s2,a1
    u32 Value;
    bsp_print("Start Info : Set Phy Delay.");
f9000550:	f9001537          	lui	a0,0xf9001
f9000554:	93c50513          	addi	a0,a0,-1732 # f900093c <__freertos_irq_stack_top+0xffffef2c>
f9000558:	cd5ff0ef          	jal	ra,f900022c <bsp_print>
    Phy_Wr(0x1F,0x0168);
f900055c:	16800593          	li	a1,360
f9000560:	01f00513          	li	a0,31
f9000564:	ef1ff0ef          	jal	ra,f9000454 <Phy_Wr>
    Phy_Wr(0x1E,0x8040);
f9000568:	00008a37          	lui	s4,0x8
f900056c:	040a0593          	addi	a1,s4,64 # 8040 <__stack_size+0x7040>
f9000570:	01e00513          	li	a0,30
f9000574:	ee1ff0ef          	jal	ra,f9000454 <Phy_Wr>
    Phy_Wr(0x1E,0x401E);
f9000578:	000049b7          	lui	s3,0x4
f900057c:	01e98593          	addi	a1,s3,30 # 401e <__stack_size+0x301e>
f9000580:	01e00513          	li	a0,30
f9000584:	ed1ff0ef          	jal	ra,f9000454 <Phy_Wr>
    Value = Phy_Rd(0x1F) & 0xFFFF;
f9000588:	01f00513          	li	a0,31
f900058c:	f25ff0ef          	jal	ra,f90004b0 <Phy_Rd>

    Value &= 0xFF00;
f9000590:	000105b7          	lui	a1,0x10
f9000594:	f0058593          	addi	a1,a1,-256 # ff00 <__stack_size+0xef00>
f9000598:	00b574b3          	and	s1,a0,a1
    RX_delay &= 0xF;
f900059c:	00f47413          	andi	s0,s0,15
    TX_delay &= 0xF;
f90005a0:	00f97913          	andi	s2,s2,15
    bsp_printReg("Setup New Value = ", RX_delay);
f90005a4:	00040593          	mv	a1,s0
f90005a8:	f9001537          	lui	a0,0xf9001
f90005ac:	95850513          	addi	a0,a0,-1704 # f9000958 <__freertos_irq_stack_top+0xffffef48>
f90005b0:	cb5ff0ef          	jal	ra,f9000264 <bsp_printReg>

    Value = ((Value) | (RX_delay<<4) | (TX_delay));
f90005b4:	00441413          	slli	s0,s0,0x4
f90005b8:	009465b3          	or	a1,s0,s1
    Phy_Wr(0x1F,Value);
f90005bc:	0125e5b3          	or	a1,a1,s2
f90005c0:	01f00513          	li	a0,31
f90005c4:	e91ff0ef          	jal	ra,f9000454 <Phy_Wr>
    Phy_Wr(0x1E,0x801E);
f90005c8:	01ea0593          	addi	a1,s4,30
f90005cc:	01e00513          	li	a0,30
f90005d0:	e85ff0ef          	jal	ra,f9000454 <Phy_Wr>
    Phy_Wr(0x1E,0x401E);
f90005d4:	01e98593          	addi	a1,s3,30
f90005d8:	01e00513          	li	a0,30
f90005dc:	e79ff0ef          	jal	ra,f9000454 <Phy_Wr>
    Value = Phy_Rd(0x1F) & 0xFFFF;
f90005e0:	01f00513          	li	a0,31
f90005e4:	ecdff0ef          	jal	ra,f90004b0 <Phy_Rd>
    bsp_printReg("Read New Value = ", Value);
f90005e8:	01051593          	slli	a1,a0,0x10
f90005ec:	0105d593          	srli	a1,a1,0x10
f90005f0:	f9001537          	lui	a0,0xf9001
f90005f4:	96c50513          	addi	a0,a0,-1684 # f900096c <__freertos_irq_stack_top+0xffffef5c>
f90005f8:	c6dff0ef          	jal	ra,f9000264 <bsp_printReg>
}
f90005fc:	01c12083          	lw	ra,28(sp)
f9000600:	01812403          	lw	s0,24(sp)
f9000604:	01412483          	lw	s1,20(sp)
f9000608:	01012903          	lw	s2,16(sp)
f900060c:	00c12983          	lw	s3,12(sp)
f9000610:	00812a03          	lw	s4,8(sp)
f9000614:	02010113          	addi	sp,sp,32
f9000618:	00008067          	ret

f900061c <PatGen>:
#include "efx_tse_mac.h"
#include "efx_tse_phy.h"

////////////////////////////////////////////////////////////////////////////////
void PatGen()
{
f900061c:	ff010113          	addi	sp,sp,-16
f9000620:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f9000624:	f81007b7          	lui	a5,0xf8100
f9000628:	00010737          	lui	a4,0x10
f900062c:	fff70713          	addi	a4,a4,-1 # ffff <__stack_size+0xefff>
f9000630:	20e7aa23          	sw	a4,532(a5) # f8100214 <__freertos_irq_stack_top+0xff0fe804>
f9000634:	fff00713          	li	a4,-1
f9000638:	20e7a823          	sw	a4,528(a5)
f900063c:	0000f737          	lui	a4,0xf
f9000640:	ae870713          	addi	a4,a4,-1304 # eae8 <__stack_size+0xdae8>
f9000644:	20e7ae23          	sw	a4,540(a5)
f9000648:	5e006737          	lui	a4,0x5e006
f900064c:	0c870713          	addi	a4,a4,200 # 5e0060c8 <__stack_size+0x5e0050c8>
f9000650:	20e7ac23          	sw	a4,536(a5)
f9000654:	c0a80737          	lui	a4,0xc0a80
f9000658:	16470693          	addi	a3,a4,356 # c0a80164 <__freertos_irq_stack_top+0xc7a7e754>
f900065c:	22d7a223          	sw	a3,548(a5)
f9000660:	16570713          	addi	a4,a4,357
f9000664:	22e7a423          	sw	a4,552(a5)
f9000668:	27150737          	lui	a4,0x27150
f900066c:	52170713          	addi	a4,a4,1313 # 27150521 <__stack_size+0x2714f521>
f9000670:	22e7a623          	sw	a4,556(a5)
f9000674:	00640737          	lui	a4,0x640
f9000678:	20e7a623          	sw	a4,524(a5)
f900067c:	06400713          	li	a4,100
f9000680:	22e7a023          	sw	a4,544(a5)
f9000684:	22e7a823          	sw	a4,560(a5)
f9000688:	2007a423          	sw	zero,520(a5)
f900068c:	2007a223          	sw	zero,516(a5)
f9000690:	00100713          	li	a4,1
f9000694:	20e7a423          	sw	a4,520(a5)
f9000698:	2007a423          	sw	zero,520(a5)
		write_u32(0x2, (TSEMAC_CSR+0x208));
        //ex_reg mac_pat_gen_en & udp_pat_gen_en
		write_u32(0x0, (TSEMAC_CSR+0x208));
	}
	if(PRINTF_EN == 1) {
        bsp_print("Info : Set Pattern Generator.");
f900069c:	f9001537          	lui	a0,0xf9001
f90006a0:	98050513          	addi	a0,a0,-1664 # f9000980 <__freertos_irq_stack_top+0xffffef70>
f90006a4:	b89ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f90006a8:	00c12083          	lw	ra,12(sp)
f90006ac:	01010113          	addi	sp,sp,16
f90006b0:	00008067          	ret

f90006b4 <StartRunning>:

void StartRunning()
{
f90006b4:	ff010113          	addi	sp,sp,-16
f90006b8:	00112623          	sw	ra,12(sp)
f90006bc:	00812423          	sw	s0,8(sp)
f90006c0:	00912223          	sw	s1,4(sp)
f90006c4:	f8100437          	lui	s0,0xf8100
f90006c8:	00100493          	li	s1,1
f90006cc:	20942023          	sw	s1,512(s0) # f8100200 <__freertos_irq_stack_top+0xff0fe7f0>
    //mac_sw_rst
	write_u32(0x1, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Assert mac reset ");
f90006d0:	f9001537          	lui	a0,0xf9001
f90006d4:	9a050513          	addi	a0,a0,-1632 # f90009a0 <__freertos_irq_stack_top+0xffffef90>
f90006d8:	b55ff0ef          	jal	ra,f900022c <bsp_print>
	}
	bsp_uDelay(1);
f90006dc:	f8b00637          	lui	a2,0xf8b00
f90006e0:	02faf5b7          	lui	a1,0x2faf
f90006e4:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90006e8:	00100513          	li	a0,1
f90006ec:	a9dff0ef          	jal	ra,f9000188 <clint_uDelay>
f90006f0:	20042023          	sw	zero,512(s0)
    //mac_sw_rst
	write_u32(0x0, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Deassert mac reset ");
f90006f4:	f9001537          	lui	a0,0xf9001
f90006f8:	9bc50513          	addi	a0,a0,-1604 # f90009bc <__freertos_irq_stack_top+0xffffefac>
f90006fc:	b31ff0ef          	jal	ra,f900022c <bsp_print>
f9000700:	20942223          	sw	s1,516(s0)
		MacCntClean();
		PatGen();
	} else if(TEST_MODE == 1) {
        //ex_reg pat_mux_select & axi4_st_mux_select
		write_u32(0x1, (TSEMAC_CSR+0x204));
		MacAddrSet(0, 1);
f9000704:	00100593          	li	a1,1
f9000708:	00000513          	li	a0,0
f900070c:	b8dff0ef          	jal	ra,f9000298 <MacAddrSet>
		MacCntClean();
f9000710:	bf5ff0ef          	jal	ra,f9000304 <MacCntClean>
	}

	while(1){
		bsp_uDelay(3000000);
f9000714:	f8b00637          	lui	a2,0xf8b00
f9000718:	02faf5b7          	lui	a1,0x2faf
f900071c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000720:	002dc537          	lui	a0,0x2dc
f9000724:	6c050513          	addi	a0,a0,1728 # 2dc6c0 <__stack_size+0x2db6c0>
f9000728:	a61ff0ef          	jal	ra,f9000188 <clint_uDelay>
		CntMonitor();
f900072c:	c3dff0ef          	jal	ra,f9000368 <CntMonitor>
f9000730:	fe5ff06f          	j	f9000714 <StartRunning+0x60>

f9000734 <PhyNego>:
	}
}

void PhyNego(int nego) {
f9000734:	ff010113          	addi	sp,sp,-16
f9000738:	00112623          	sw	ra,12(sp)
	if (nego = 1) {
	Phy_Wr(0x0, 0x9000); //reset
f900073c:	000095b7          	lui	a1,0x9
f9000740:	00000513          	li	a0,0
f9000744:	d11ff0ef          	jal	ra,f9000454 <Phy_Wr>
	Phy_Wr(0x0, 0x1000); //auto nego
f9000748:	000015b7          	lui	a1,0x1
f900074c:	00000513          	li	a0,0
f9000750:	d05ff0ef          	jal	ra,f9000454 <Phy_Wr>
	bsp_print("Phy Auto Negotiated !");
f9000754:	f9001537          	lui	a0,0xf9001
f9000758:	9d850513          	addi	a0,a0,-1576 # f90009d8 <__freertos_irq_stack_top+0xffffefc8>
f900075c:	ad1ff0ef          	jal	ra,f900022c <bsp_print>
	}
	else {
		bsp_print("Phy Not Auto Negotiated !");
	}
}
f9000760:	00c12083          	lw	ra,12(sp)
f9000764:	01010113          	addi	sp,sp,16
f9000768:	00008067          	ret

f900076c <main>:

////////////////////////////////////////////////////////////////////////////////
void main() {
f900076c:	ff010113          	addi	sp,sp,-16
f9000770:	00112623          	sw	ra,12(sp)
    u32 prompt=0;
    u32 speed;

    PhyNego(1);
f9000774:	00100513          	li	a0,1
f9000778:	fbdff0ef          	jal	ra,f9000734 <PhyNego>
	bsp_init();
    bsp_print("tse demo !");
f900077c:	80018513          	addi	a0,gp,-2048 # f90009f0 <__init_array_end+0x25c>
f9000780:	aadff0ef          	jal	ra,f900022c <bsp_print>
	PhyDlySetRXTX(15, 15); //change PHY delay settings here
f9000784:	00f00593          	li	a1,15
f9000788:	00f00513          	li	a0,15
f900078c:	da1ff0ef          	jal	ra,f900052c <PhyDlySetRXTX>
	if(TEST_MODE == 0){	
		speed = PhyNormalInit();
		MacNormalInit(speed);//MAC speed set, MAC IPG set
	}
    
    StartRunning();
f9000790:	f25ff0ef          	jal	ra,f90006b4 <StartRunning>
