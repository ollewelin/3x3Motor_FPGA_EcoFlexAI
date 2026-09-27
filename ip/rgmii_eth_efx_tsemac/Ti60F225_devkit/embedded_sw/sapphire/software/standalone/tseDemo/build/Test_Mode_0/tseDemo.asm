
build/tseDemo.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00001197          	auipc	gp,0x1
f9000004:	74018193          	addi	gp,gp,1856 # f9001740 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	00002117          	auipc	sp,0x2
f900000c:	f5810113          	addi	sp,sp,-168 # f9001f60 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f9000010:	00001517          	auipc	a0,0x1
f9000014:	c2450513          	addi	a0,a0,-988 # f9000c34 <__init_array_end>
	la a1, _data
f9000018:	00001597          	auipc	a1,0x1
f900001c:	c1c58593          	addi	a1,a1,-996 # f9000c34 <__init_array_end>
	la a2, _edata
f9000020:	81c18613          	addi	a2,gp,-2020 # f9000f5c <__bss_start>
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
f900003c:	81c18513          	addi	a0,gp,-2020 # f9000f5c <__bss_start>
	la a1, _end
f9000040:	82018593          	addi	a1,gp,-2016 # f9000f60 <_end>
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
f9000058:	530000ef          	jal	ra,f9000588 <main>

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
f9000070:	00001417          	auipc	s0,0x1
f9000074:	bc440413          	addi	s0,s0,-1084 # f9000c34 <__init_array_end>
f9000078:	00001917          	auipc	s2,0x1
f900007c:	bbc90913          	addi	s2,s2,-1092 # f9000c34 <__init_array_end>
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
f90000ac:	00001417          	auipc	s0,0x1
f90000b0:	b8840413          	addi	s0,s0,-1144 # f9000c34 <__init_array_end>
f90000b4:	00001917          	auipc	s2,0x1
f90000b8:	b8090913          	addi	s2,s2,-1152 # f9000c34 <__init_array_end>
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
f90001e0:	f90017b7          	lui	a5,0xf9001
f90001e4:	c3478793          	addi	a5,a5,-972 # f9000c34 <__freertos_irq_stack_top+0xffffecd4>
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

f9000298 <MacSpeedSet>:
	}
}

/************************** Function File ***************************/
static void MacSpeedSet(u32 speed)
{
f9000298:	ff010113          	addi	sp,sp,-16
f900029c:	00112623          	sw	ra,12(sp)
f90002a0:	f81006b7          	lui	a3,0xf8100
f90002a4:	0086a783          	lw	a5,8(a3) # f8100008 <__freertos_irq_stack_top+0xff0fe0a8>
	u32 Value;
	//Set Mac Speed
	Value = read_u32(TSEMAC_CSR+0x008) & ETH_SPEED_MASK;
f90002a8:	fff90737          	lui	a4,0xfff90
f90002ac:	fff70713          	addi	a4,a4,-1 # fff8ffff <__freertos_irq_stack_top+0x6f8e09f>
f90002b0:	00e7f7b3          	and	a5,a5,a4
	Value |= (speed&0x7)<<16;
f90002b4:	01051513          	slli	a0,a0,0x10
f90002b8:	00070737          	lui	a4,0x70
f90002bc:	00e57533          	and	a0,a0,a4
f90002c0:	00f56533          	or	a0,a0,a5
        *((volatile u32*) address) = data;
f90002c4:	00a6a423          	sw	a0,8(a3)
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac Speed.");
f90002c8:	f9001537          	lui	a0,0xf9001
f90002cc:	c4850513          	addi	a0,a0,-952 # f9000c48 <__freertos_irq_stack_top+0xffffece8>
f90002d0:	f5dff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f90002d4:	00c12083          	lw	ra,12(sp)
f90002d8:	01010113          	addi	sp,sp,16
f90002dc:	00008067          	ret

f90002e0 <MacIpgSet>:
	}
}

/************************** Function File ***************************/
static void MacIpgSet(u32 ipg)
{
f90002e0:	ff010113          	addi	sp,sp,-16
f90002e4:	00112623          	sw	ra,12(sp)
	//Set Mac IPG
	write_u32(ipg&0x3f, (TSEMAC_CSR+0x5C));
f90002e8:	03f57513          	andi	a0,a0,63
f90002ec:	f81007b7          	lui	a5,0xf8100
f90002f0:	04a7ae23          	sw	a0,92(a5) # f810005c <__freertos_irq_stack_top+0xff0fe0fc>
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac IPG.");
f90002f4:	f9001537          	lui	a0,0xf9001
f90002f8:	c6050513          	addi	a0,a0,-928 # f9000c60 <__freertos_irq_stack_top+0xffffed00>
f90002fc:	f31ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f9000300:	00c12083          	lw	ra,12(sp)
f9000304:	01010113          	addi	sp,sp,16
f9000308:	00008067          	ret

f900030c <MacCntClean>:
	write_u32(Value, (TSEMAC_CSR+0x008));
}

/************************** Function File ***************************/
static void MacCntClean()
{
f900030c:	ff010113          	addi	sp,sp,-16
f9000310:	00112623          	sw	ra,12(sp)
f9000314:	00812423          	sw	s0,8(sp)
f9000318:	00912223          	sw	s1,4(sp)
        return *((volatile u32*) address);
f900031c:	f81004b7          	lui	s1,0xf8100
f9000320:	0084a403          	lw	s0,8(s1) # f8100008 <__freertos_irq_stack_top+0xff0fe0a8>
	u32 Value;
	//Set cnt_reset 1
	Value = read_u32(TSEMAC_CSR+0x008) & CNT_RST_MASK;
f9000324:	800007b7          	lui	a5,0x80000
f9000328:	fff7c713          	not	a4,a5
f900032c:	00e47433          	and	s0,s0,a4
	Value |= 0x80000000;
f9000330:	00f467b3          	or	a5,s0,a5
        *((volatile u32*) address) = data;
f9000334:	00f4a423          	sw	a5,8(s1)
	write_u32(Value, (TSEMAC_CSR+0x008));
	bsp_uDelay(1);
f9000338:	f8b00637          	lui	a2,0xf8b00
f900033c:	02faf5b7          	lui	a1,0x2faf
f9000340:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000344:	00100513          	li	a0,1
f9000348:	e41ff0ef          	jal	ra,f9000188 <clint_uDelay>
f900034c:	0084a423          	sw	s0,8(s1)
	//Set cnt_reset 0
	Value &= CNT_RST_MASK;
	Value |= 0x0;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
		bsp_print("Info : Mac Reset Statistics Counters.");
f9000350:	f9001537          	lui	a0,0xf9001
f9000354:	c7450513          	addi	a0,a0,-908 # f9000c74 <__freertos_irq_stack_top+0xffffed14>
f9000358:	ed5ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f900035c:	00c12083          	lw	ra,12(sp)
f9000360:	00812403          	lw	s0,8(sp)
f9000364:	00412483          	lw	s1,4(sp)
f9000368:	01010113          	addi	sp,sp,16
f900036c:	00008067          	ret

f9000370 <CntMonitor>:

/************************** Function File ***************************/
static void CntMonitor()
{
f9000370:	ff010113          	addi	sp,sp,-16
f9000374:	00112623          	sw	ra,12(sp)
f9000378:	00812423          	sw	s0,8(sp)
f900037c:	00912223          	sw	s1,4(sp)
	bsp_print("--------------------");
f9000380:	f90014b7          	lui	s1,0xf9001
f9000384:	c9c48513          	addi	a0,s1,-868 # f9000c9c <__freertos_irq_stack_top+0xffffed3c>
f9000388:	ea5ff0ef          	jal	ra,f900022c <bsp_print>
        return *((volatile u32*) address);
f900038c:	f8100437          	lui	s0,0xf8100
f9000390:	06842583          	lw	a1,104(s0) # f8100068 <__freertos_irq_stack_top+0xff0fe108>
	bsp_printReg("aFramesTransmittedOK :"       , read_u32(TSEMAC_CSR+0x68));
f9000394:	f9001537          	lui	a0,0xf9001
f9000398:	cb450513          	addi	a0,a0,-844 # f9000cb4 <__freertos_irq_stack_top+0xffffed54>
f900039c:	ec9ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003a0:	06c42583          	lw	a1,108(s0)
	bsp_printReg("aFramesReceivedOK :"          , read_u32(TSEMAC_CSR+0x6c));
f90003a4:	f9001537          	lui	a0,0xf9001
f90003a8:	ccc50513          	addi	a0,a0,-820 # f9000ccc <__freertos_irq_stack_top+0xffffed6c>
f90003ac:	eb9ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003b0:	08842583          	lw	a1,136(s0)
	bsp_printReg("ifInErrors :"                 , read_u32(TSEMAC_CSR+0x88));
f90003b4:	f9001537          	lui	a0,0xf9001
f90003b8:	ce050513          	addi	a0,a0,-800 # f9000ce0 <__freertos_irq_stack_top+0xffffed80>
f90003bc:	ea9ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003c0:	08c42583          	lw	a1,140(s0)
	bsp_printReg("ifOutErrors :"                , read_u32(TSEMAC_CSR+0x8c));
f90003c4:	f9001537          	lui	a0,0xf9001
f90003c8:	cf050513          	addi	a0,a0,-784 # f9000cf0 <__freertos_irq_stack_top+0xffffed90>
f90003cc:	e99ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003d0:	0b442583          	lw	a1,180(s0)
	bsp_printReg("etherStatsPkts :"             , read_u32(TSEMAC_CSR+0xb4));
f90003d4:	f9001537          	lui	a0,0xf9001
f90003d8:	d0050513          	addi	a0,a0,-768 # f9000d00 <__freertos_irq_stack_top+0xffffeda0>
f90003dc:	e89ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003e0:	0b842583          	lw	a1,184(s0)
	bsp_printReg("etherStatsUndersizePkts :"    , read_u32(TSEMAC_CSR+0xb8));
f90003e4:	f9001537          	lui	a0,0xf9001
f90003e8:	d1450513          	addi	a0,a0,-748 # f9000d14 <__freertos_irq_stack_top+0xffffedb4>
f90003ec:	e79ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003f0:	0bc42583          	lw	a1,188(s0)
	bsp_printReg("etherStatsOversizePkts :"     , read_u32(TSEMAC_CSR+0xbc));
f90003f4:	f9001537          	lui	a0,0xf9001
f90003f8:	d3050513          	addi	a0,a0,-720 # f9000d30 <__freertos_irq_stack_top+0xffffedd0>
f90003fc:	e69ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000400:	09c42583          	lw	a1,156(s0)
	bsp_printReg("aRxFilterFramesErrors :"      , read_u32(TSEMAC_CSR+0x9c));
f9000404:	f9001537          	lui	a0,0xf9001
f9000408:	d4c50513          	addi	a0,a0,-692 # f9000d4c <__freertos_irq_stack_top+0xffffedec>
f900040c:	e59ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000410:	07042583          	lw	a1,112(s0)
	bsp_printReg("aFrameCheckSequenceErrors :"  , read_u32(TSEMAC_CSR+0x70));
f9000414:	f9001537          	lui	a0,0xf9001
f9000418:	d6450513          	addi	a0,a0,-668 # f9000d64 <__freertos_irq_stack_top+0xffffee04>
f900041c:	e49ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000420:	08042583          	lw	a1,128(s0)
	bsp_printReg("aTxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x80));
f9000424:	f9001537          	lui	a0,0xf9001
f9000428:	d8050513          	addi	a0,a0,-640 # f9000d80 <__freertos_irq_stack_top+0xffffee20>
f900042c:	e39ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000430:	08442583          	lw	a1,132(s0)
	bsp_printReg("aRxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x84));
f9000434:	f9001537          	lui	a0,0xf9001
f9000438:	d9850513          	addi	a0,a0,-616 # f9000d98 <__freertos_irq_stack_top+0xffffee38>
f900043c:	e29ff0ef          	jal	ra,f9000264 <bsp_printReg>
	bsp_print("--------------------");
f9000440:	c9c48513          	addi	a0,s1,-868
f9000444:	de9ff0ef          	jal	ra,f900022c <bsp_print>
}
f9000448:	00c12083          	lw	ra,12(sp)
f900044c:	00812403          	lw	s0,8(sp)
f9000450:	00412483          	lw	s1,4(sp)
f9000454:	01010113          	addi	sp,sp,16
f9000458:	00008067          	ret

f900045c <MacNormalInit>:

/************************** Function File ***************************/
static void MacNormalInit(u32 speed)
{
f900045c:	ff010113          	addi	sp,sp,-16
f9000460:	00112623          	sw	ra,12(sp)
	MacSpeedSet(speed);
f9000464:	e35ff0ef          	jal	ra,f9000298 <MacSpeedSet>
	MacIpgSet(0x0C);
f9000468:	00c00513          	li	a0,12
f900046c:	e75ff0ef          	jal	ra,f90002e0 <MacIpgSet>
}
f9000470:	00c12083          	lw	ra,12(sp)
f9000474:	01010113          	addi	sp,sp,16
f9000478:	00008067          	ret

f900047c <PatGen>:
#else
#include "efx_tse_phy.h"
#endif
////////////////////////////////////////////////////////////////////////////////
void PatGen()
{
f900047c:	ff010113          	addi	sp,sp,-16
f9000480:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f9000484:	f81007b7          	lui	a5,0xf8100
f9000488:	00010737          	lui	a4,0x10
f900048c:	fff70713          	addi	a4,a4,-1 # ffff <__stack_size+0xefff>
f9000490:	20e7aa23          	sw	a4,532(a5) # f8100214 <__freertos_irq_stack_top+0xff0fe2b4>
f9000494:	fff00713          	li	a4,-1
f9000498:	20e7a823          	sw	a4,528(a5)
f900049c:	0000f737          	lui	a4,0xf
f90004a0:	ae870713          	addi	a4,a4,-1304 # eae8 <__stack_size+0xdae8>
f90004a4:	20e7ae23          	sw	a4,540(a5)
f90004a8:	5e006737          	lui	a4,0x5e006
f90004ac:	0c870713          	addi	a4,a4,200 # 5e0060c8 <__stack_size+0x5e0050c8>
f90004b0:	20e7ac23          	sw	a4,536(a5)
f90004b4:	c0a80737          	lui	a4,0xc0a80
f90004b8:	16470693          	addi	a3,a4,356 # c0a80164 <__freertos_irq_stack_top+0xc7a7e204>
f90004bc:	22d7a223          	sw	a3,548(a5)
f90004c0:	16570713          	addi	a4,a4,357
f90004c4:	22e7a423          	sw	a4,552(a5)
f90004c8:	27150737          	lui	a4,0x27150
f90004cc:	52170713          	addi	a4,a4,1313 # 27150521 <__stack_size+0x2714f521>
f90004d0:	22e7a623          	sw	a4,556(a5)
f90004d4:	00640737          	lui	a4,0x640
f90004d8:	20e7a623          	sw	a4,524(a5)
f90004dc:	06400713          	li	a4,100
f90004e0:	22e7a023          	sw	a4,544(a5)
f90004e4:	22e7a823          	sw	a4,560(a5)
f90004e8:	2007a423          	sw	zero,520(a5)
f90004ec:	2007a223          	sw	zero,516(a5)
f90004f0:	00100713          	li	a4,1
f90004f4:	20e7a423          	sw	a4,520(a5)
f90004f8:	2007a423          	sw	zero,520(a5)
		write_u32(0x2, (TSEMAC_CSR+0x208));
        //ex_reg mac_pat_gen_en & udp_pat_gen_en
		write_u32(0x0, (TSEMAC_CSR+0x208));
	}
	if(PRINTF_EN == 1) {
        bsp_print("Info : Set Pattern Generator.");
f90004fc:	f9001537          	lui	a0,0xf9001
f9000500:	db050513          	addi	a0,a0,-592 # f9000db0 <__freertos_irq_stack_top+0xffffee50>
f9000504:	d29ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f9000508:	00c12083          	lw	ra,12(sp)
f900050c:	01010113          	addi	sp,sp,16
f9000510:	00008067          	ret

f9000514 <StartRunning>:

void StartRunning()
{
f9000514:	ff010113          	addi	sp,sp,-16
f9000518:	00112623          	sw	ra,12(sp)
f900051c:	00812423          	sw	s0,8(sp)
f9000520:	f8100437          	lui	s0,0xf8100
f9000524:	00100793          	li	a5,1
f9000528:	20f42023          	sw	a5,512(s0) # f8100200 <__freertos_irq_stack_top+0xff0fe2a0>
    //mac_sw_rst
	write_u32(0x1, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Assert mac reset ");
f900052c:	f9001537          	lui	a0,0xf9001
f9000530:	dd050513          	addi	a0,a0,-560 # f9000dd0 <__freertos_irq_stack_top+0xffffee70>
f9000534:	cf9ff0ef          	jal	ra,f900022c <bsp_print>
	}
	bsp_uDelay(1);
f9000538:	f8b00637          	lui	a2,0xf8b00
f900053c:	02faf5b7          	lui	a1,0x2faf
f9000540:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000544:	00100513          	li	a0,1
f9000548:	c41ff0ef          	jal	ra,f9000188 <clint_uDelay>
f900054c:	20042023          	sw	zero,512(s0)
    //mac_sw_rst
	write_u32(0x0, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Deassert mac reset ");
f9000550:	f9001537          	lui	a0,0xf9001
f9000554:	dec50513          	addi	a0,a0,-532 # f9000dec <__freertos_irq_stack_top+0xffffee8c>
f9000558:	cd5ff0ef          	jal	ra,f900022c <bsp_print>
f900055c:	20042223          	sw	zero,516(s0)
    }

	if(TEST_MODE == 0) {
        //ex_reg pat_mux_select & axi4_st_mux_select
		write_u32(0x0, (TSEMAC_CSR+0x204));
		MacCntClean();
f9000560:	dadff0ef          	jal	ra,f900030c <MacCntClean>
		PatGen();
f9000564:	f19ff0ef          	jal	ra,f900047c <PatGen>
		MacCntClean();

	}

	while(1){
		bsp_uDelay(3000000);
f9000568:	f8b00637          	lui	a2,0xf8b00
f900056c:	02faf5b7          	lui	a1,0x2faf
f9000570:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000574:	002dc537          	lui	a0,0x2dc
f9000578:	6c050513          	addi	a0,a0,1728 # 2dc6c0 <__stack_size+0x2db6c0>
f900057c:	c0dff0ef          	jal	ra,f9000188 <clint_uDelay>
		CntMonitor();
f9000580:	df1ff0ef          	jal	ra,f9000370 <CntMonitor>
f9000584:	fe5ff06f          	j	f9000568 <StartRunning+0x54>

f9000588 <main>:
	}
}


////////////////////////////////////////////////////////////////////////////////
void main() {
f9000588:	ff010113          	addi	sp,sp,-16
f900058c:	00112623          	sw	ra,12(sp)
    u32 prompt=0;
    u32 speed;

    bsp_init();
    bsp_print("tse demo !");
f9000590:	f9001537          	lui	a0,0xf9001
f9000594:	e0850513          	addi	a0,a0,-504 # f9000e08 <__freertos_irq_stack_top+0xffffeea8>
f9000598:	c95ff0ef          	jal	ra,f900022c <bsp_print>
	#ifdef PHY8211
    rtl8211_drv_init();
f900059c:	294000ef          	jal	ra,f9000830 <rtl8211_drv_init>
    bsp_print("Waiting Link Up...");
f90005a0:	f9001537          	lui	a0,0xf9001
f90005a4:	e1450513          	addi	a0,a0,-492 # f9000e14 <__freertos_irq_stack_top+0xffffeeb4>
f90005a8:	c85ff0ef          	jal	ra,f900022c <bsp_print>
    speed=rtl8211_drv_linkup();
f90005ac:	168000ef          	jal	ra,f9000714 <rtl8211_drv_linkup>
	    	PhyLoopInit(speed); // 4=1000Mbps, 2=100Mbps, 1=10Mbps, change the number to change speed
			MacAddrSet(1,1);
			MacIpgSet(0x0C);
	    }
	else if (TEST_MODE == 0){
		MacNormalInit(speed);
f90005b0:	eadff0ef          	jal	ra,f900045c <MacNormalInit>
	    	PhyLoopInit(2); // 4=1000Mbps, 2=100Mbps, 1=10Mbps, change the number to change speed
	    }
	#endif
	

    StartRunning();
f90005b4:	f61ff0ef          	jal	ra,f9000514 <StartRunning>

f90005b8 <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
f90005b8:	000f47b7          	lui	a5,0xf4
f90005bc:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf3240>
f90005c0:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f90005c4:	0000c7b7          	lui	a5,0xc
f90005c8:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0xaff8>
f90005cc:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f90005d0:	00062783          	lw	a5,0(a2) # f8b00000 <__freertos_irq_stack_top+0xffafe0a0>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90005d4:	02a58533          	mul	a0,a1,a0
f90005d8:	00f50533          	add	a0,a0,a5
f90005dc:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f90005e0:	40f507b3          	sub	a5,a0,a5
f90005e4:	fe07dce3          	bgez	a5,f90005dc <clint_uDelay+0x24>
    }
f90005e8:	00008067          	ret

f90005ec <Phy_Rd>:
//#include "mac.h"
#include "tseDemo.h"
#include "compatibility.h"

u32 Phy_Rd(u32 RegAddr)
{
f90005ec:	ff010113          	addi	sp,sp,-16
f90005f0:	00112623          	sw	ra,12(sp)
f90005f4:	00812423          	sw	s0,8(sp)
    u32 Value;
    Reg_Out32((TSEMAC_CSR+0x108), ((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f));
f90005f8:	01f57593          	andi	a1,a0,31
f90005fc:	7005e593          	ori	a1,a1,1792
f9000600:	f8100437          	lui	s0,0xf8100
f9000604:	10840513          	addi	a0,s0,264 # f8100108 <__freertos_irq_stack_top+0xff0fe1a8>
f9000608:	320000ef          	jal	ra,f9000928 <Reg_Out32>
    Reg_Out32((TSEMAC_CSR+0x104), 0x1);
f900060c:	00100593          	li	a1,1
f9000610:	10440513          	addi	a0,s0,260
f9000614:	314000ef          	jal	ra,f9000928 <Reg_Out32>
    bsp_uDelay(1000);
f9000618:	f8b00637          	lui	a2,0xf8b00
f900061c:	02faf5b7          	lui	a1,0x2faf
f9000620:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000624:	3e800513          	li	a0,1000
f9000628:	f91ff0ef          	jal	ra,f90005b8 <clint_uDelay>
    Value = Reg_In32(TSEMAC_CSR+0x110);
f900062c:	11040513          	addi	a0,s0,272
f9000630:	300000ef          	jal	ra,f9000930 <Reg_In32>

    return Value;
}
f9000634:	00c12083          	lw	ra,12(sp)
f9000638:	00812403          	lw	s0,8(sp)
f900063c:	01010113          	addi	sp,sp,16
f9000640:	00008067          	ret

f9000644 <Phy_Wr>:
void Phy_Wr(u32 RegAddr,u32 Data)
{
f9000644:	ff010113          	addi	sp,sp,-16
f9000648:	00112623          	sw	ra,12(sp)
f900064c:	00812423          	sw	s0,8(sp)
f9000650:	00912223          	sw	s1,4(sp)
f9000654:	00058493          	mv	s1,a1
    Reg_Out32((TSEMAC_CSR+0x108), ((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f));
f9000658:	01f57593          	andi	a1,a0,31
f900065c:	7005e593          	ori	a1,a1,1792
f9000660:	f8100437          	lui	s0,0xf8100
f9000664:	10840513          	addi	a0,s0,264 # f8100108 <__freertos_irq_stack_top+0xff0fe1a8>
f9000668:	2c0000ef          	jal	ra,f9000928 <Reg_Out32>
    Reg_Out32((TSEMAC_CSR+0x10c), Data);
f900066c:	00048593          	mv	a1,s1
f9000670:	10c40513          	addi	a0,s0,268
f9000674:	2b4000ef          	jal	ra,f9000928 <Reg_Out32>
    Reg_Out32((TSEMAC_CSR+0x104), 0x2);
f9000678:	00200593          	li	a1,2
f900067c:	10440513          	addi	a0,s0,260
f9000680:	2a8000ef          	jal	ra,f9000928 <Reg_Out32>
}
f9000684:	00c12083          	lw	ra,12(sp)
f9000688:	00812403          	lw	s0,8(sp)
f900068c:	00412483          	lw	s1,4(sp)
f9000690:	01010113          	addi	sp,sp,16
f9000694:	00008067          	ret

f9000698 <rtl8211_drv_rddata>:

int rtl8211_drv_rddata(int addr)
{
f9000698:	ff010113          	addi	sp,sp,-16
f900069c:	00112623          	sw	ra,12(sp)
	 return Phy_Rd(addr);
f90006a0:	f4dff0ef          	jal	ra,f90005ec <Phy_Rd>
}
f90006a4:	00c12083          	lw	ra,12(sp)
f90006a8:	01010113          	addi	sp,sp,16
f90006ac:	00008067          	ret

f90006b0 <rtl8211_drv_wrdata>:

void rtl8211_drv_wrdata(int addr ,int data)
{
f90006b0:	ff010113          	addi	sp,sp,-16
f90006b4:	00112623          	sw	ra,12(sp)
	 Phy_Wr(addr,data);
f90006b8:	f8dff0ef          	jal	ra,f9000644 <Phy_Wr>
	 bsp_uDelay(100);
f90006bc:	f8b00637          	lui	a2,0xf8b00
f90006c0:	02faf5b7          	lui	a1,0x2faf
f90006c4:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90006c8:	06400513          	li	a0,100
f90006cc:	eedff0ef          	jal	ra,f90005b8 <clint_uDelay>
}
f90006d0:	00c12083          	lw	ra,12(sp)
f90006d4:	01010113          	addi	sp,sp,16
f90006d8:	00008067          	ret

f90006dc <rtl8211_drv_setpage>:

void rtl8211_drv_setpage(int page)
{
f90006dc:	ff010113          	addi	sp,sp,-16
f90006e0:	00112623          	sw	ra,12(sp)
	 Phy_Wr(31,page & 0xFFFF);
f90006e4:	01051593          	slli	a1,a0,0x10
f90006e8:	0105d593          	srli	a1,a1,0x10
f90006ec:	01f00513          	li	a0,31
f90006f0:	f55ff0ef          	jal	ra,f9000644 <Phy_Wr>
	 bsp_uDelay(100);
f90006f4:	f8b00637          	lui	a2,0xf8b00
f90006f8:	02faf5b7          	lui	a1,0x2faf
f90006fc:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000700:	06400513          	li	a0,100
f9000704:	eb5ff0ef          	jal	ra,f90005b8 <clint_uDelay>
}
f9000708:	00c12083          	lw	ra,12(sp)
f900070c:	01010113          	addi	sp,sp,16
f9000710:	00008067          	ret

f9000714 <rtl8211_drv_linkup>:

int rtl8211_drv_linkup(void)
{
f9000714:	ff010113          	addi	sp,sp,-16
f9000718:	00112623          	sw	ra,12(sp)
f900071c:	00812423          	sw	s0,8(sp)
	int phy_reg=0;
	int speed=Speed_100Mhz;//i change from Speed_1000Mhz

	 while(1)
	{
		phy_reg=rtl8211_drv_rddata(26); //Phy_Rd(addr) addr = 26, this is just to read link status
f9000720:	01a00513          	li	a0,26
f9000724:	f75ff0ef          	jal	ra,f9000698 <rtl8211_drv_rddata>

		if(phy_reg & 0x04)
f9000728:	00457793          	andi	a5,a0,4
f900072c:	02079063          	bnez	a5,f900074c <rtl8211_drv_linkup+0x38>
		{
			bsp_printf("Linked Up");
			break;
		}

		bsp_uDelay(10000);
f9000730:	f8b00637          	lui	a2,0xf8b00
f9000734:	02faf5b7          	lui	a1,0x2faf
f9000738:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f900073c:	00002537          	lui	a0,0x2
f9000740:	71050513          	addi	a0,a0,1808 # 2710 <__stack_size+0x1710>
f9000744:	e75ff0ef          	jal	ra,f90005b8 <clint_uDelay>
		phy_reg=rtl8211_drv_rddata(26); //Phy_Rd(addr) addr = 26, this is just to read link status
f9000748:	fd9ff06f          	j	f9000720 <rtl8211_drv_linkup+0xc>
f900074c:	00050413          	mv	s0,a0
			bsp_printf("Linked Up");
f9000750:	f9001537          	lui	a0,0xf9001
f9000754:	e2850513          	addi	a0,a0,-472 # f9000e28 <__freertos_irq_stack_top+0xffffeec8>
f9000758:	3cc000ef          	jal	ra,f9000b24 <bsp_printf>
	}

	if((phy_reg & 0x30) == 0x20)//check bit 4&5 for speed 1000Mbps, and maybeeeeeeee linked partner mode
f900075c:	03047793          	andi	a5,s0,48
f9000760:	02000713          	li	a4,32
f9000764:	02e78863          	beq	a5,a4,f9000794 <rtl8211_drv_linkup+0x80>
			bsp_printf("Link Partner Full duplex 1000 Mbps Reg26 0x%x",phy_reg);
		else
			bsp_printf("Link Partner half duplex 1000 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_1000Mhz;
	}
	else if((phy_reg & 0x30) == 0x10)
f9000768:	01000713          	li	a4,16
f900076c:	06e78663          	beq	a5,a4,f90007d8 <rtl8211_drv_linkup+0xc4>
			bsp_printf("Link Partner Full duplex 100 Mbps Reg26 0x%x",phy_reg);
		else
			bsp_printf("Link Partner half duplex 100 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_100Mhz;
	}
	else if((phy_reg & 0x30) == 0)
f9000770:	0a079c63          	bnez	a5,f9000828 <rtl8211_drv_linkup+0x114>
	{
		if(phy_reg & 0x08)
f9000774:	00847793          	andi	a5,s0,8
f9000778:	08078c63          	beqz	a5,f9000810 <rtl8211_drv_linkup+0xfc>
			bsp_printf("Link Partner Full duplex 10 Mbps Reg26 0x%x",phy_reg);
f900077c:	00040593          	mv	a1,s0
f9000780:	f9001537          	lui	a0,0xf9001
f9000784:	ef450513          	addi	a0,a0,-268 # f9000ef4 <__freertos_irq_stack_top+0xffffef94>
f9000788:	39c000ef          	jal	ra,f9000b24 <bsp_printf>
		else
			bsp_printf("Link Partner half duplex 10 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_10Mhz;
f900078c:	00100513          	li	a0,1
f9000790:	0200006f          	j	f90007b0 <rtl8211_drv_linkup+0x9c>
		if(phy_reg & 0x08)//check if full duplex
f9000794:	00847793          	andi	a5,s0,8
f9000798:	02078463          	beqz	a5,f90007c0 <rtl8211_drv_linkup+0xac>
			bsp_printf("Link Partner Full duplex 1000 Mbps Reg26 0x%x",phy_reg);
f900079c:	00040593          	mv	a1,s0
f90007a0:	f9001537          	lui	a0,0xf9001
f90007a4:	e3450513          	addi	a0,a0,-460 # f9000e34 <__freertos_irq_stack_top+0xffffeed4>
f90007a8:	37c000ef          	jal	ra,f9000b24 <bsp_printf>
		speed = Speed_1000Mhz;
f90007ac:	00400513          	li	a0,4
	}

	return speed;
}
f90007b0:	00c12083          	lw	ra,12(sp)
f90007b4:	00812403          	lw	s0,8(sp)
f90007b8:	01010113          	addi	sp,sp,16
f90007bc:	00008067          	ret
			bsp_printf("Link Partner half duplex 1000 Mbps Reg26 0x%x",phy_reg);
f90007c0:	00040593          	mv	a1,s0
f90007c4:	f9001537          	lui	a0,0xf9001
f90007c8:	e6450513          	addi	a0,a0,-412 # f9000e64 <__freertos_irq_stack_top+0xffffef04>
f90007cc:	358000ef          	jal	ra,f9000b24 <bsp_printf>
		speed = Speed_1000Mhz;
f90007d0:	00400513          	li	a0,4
f90007d4:	fddff06f          	j	f90007b0 <rtl8211_drv_linkup+0x9c>
		if(phy_reg & 0x08)
f90007d8:	00847793          	andi	a5,s0,8
f90007dc:	00078e63          	beqz	a5,f90007f8 <rtl8211_drv_linkup+0xe4>
			bsp_printf("Link Partner Full duplex 100 Mbps Reg26 0x%x",phy_reg);
f90007e0:	00040593          	mv	a1,s0
f90007e4:	f9001537          	lui	a0,0xf9001
f90007e8:	e9450513          	addi	a0,a0,-364 # f9000e94 <__freertos_irq_stack_top+0xffffef34>
f90007ec:	338000ef          	jal	ra,f9000b24 <bsp_printf>
		speed = Speed_100Mhz;
f90007f0:	00200513          	li	a0,2
f90007f4:	fbdff06f          	j	f90007b0 <rtl8211_drv_linkup+0x9c>
			bsp_printf("Link Partner half duplex 100 Mbps Reg26 0x%x",phy_reg);
f90007f8:	00040593          	mv	a1,s0
f90007fc:	f9001537          	lui	a0,0xf9001
f9000800:	ec450513          	addi	a0,a0,-316 # f9000ec4 <__freertos_irq_stack_top+0xffffef64>
f9000804:	320000ef          	jal	ra,f9000b24 <bsp_printf>
		speed = Speed_100Mhz;
f9000808:	00200513          	li	a0,2
f900080c:	fa5ff06f          	j	f90007b0 <rtl8211_drv_linkup+0x9c>
			bsp_printf("Link Partner half duplex 10 Mbps Reg26 0x%x",phy_reg);
f9000810:	00040593          	mv	a1,s0
f9000814:	f9001537          	lui	a0,0xf9001
f9000818:	f2050513          	addi	a0,a0,-224 # f9000f20 <__freertos_irq_stack_top+0xffffefc0>
f900081c:	308000ef          	jal	ra,f9000b24 <bsp_printf>
		speed = Speed_10Mhz;
f9000820:	00100513          	li	a0,1
f9000824:	f8dff06f          	j	f90007b0 <rtl8211_drv_linkup+0x9c>
	int speed=Speed_100Mhz;//i change from Speed_1000Mhz
f9000828:	00200513          	li	a0,2
	return speed;
f900082c:	f85ff06f          	j	f90007b0 <rtl8211_drv_linkup+0x9c>

f9000830 <rtl8211_drv_init>:

void rtl8211_drv_init(void)
{
f9000830:	ff010113          	addi	sp,sp,-16
f9000834:	00112623          	sw	ra,12(sp)
f9000838:	00812423          	sw	s0,8(sp)
f900083c:	00912223          	sw	s1,4(sp)
	rtl8211_drv_setpage(0);//Phy_Wr(31,page & 0xFFFF);
f9000840:	00000513          	li	a0,0
f9000844:	e99ff0ef          	jal	ra,f90006dc <rtl8211_drv_setpage>
	rtl8211_drv_wrdata(0,0x9000);//Phy_Wr(addr,data); here eneble auto negotiation and make a phyreset
f9000848:	000095b7          	lui	a1,0x9
f900084c:	00000513          	li	a0,0
f9000850:	e61ff0ef          	jal	ra,f90006b0 <rtl8211_drv_wrdata>
	bsp_uDelay(1000*50);
f9000854:	f8b00637          	lui	a2,0xf8b00
f9000858:	02faf4b7          	lui	s1,0x2faf
f900085c:	08048593          	addi	a1,s1,128 # 2faf080 <__stack_size+0x2fae080>
f9000860:	0000c437          	lui	s0,0xc
f9000864:	35040513          	addi	a0,s0,848 # c350 <__stack_size+0xb350>
f9000868:	d51ff0ef          	jal	ra,f90005b8 <clint_uDelay>
	rtl8211_drv_wrdata(0,0x1000);//auto negotiate again just to make sure
f900086c:	000015b7          	lui	a1,0x1
f9000870:	00000513          	li	a0,0
f9000874:	e3dff0ef          	jal	ra,f90006b0 <rtl8211_drv_wrdata>
	bsp_uDelay(1000*50);
f9000878:	f8b00637          	lui	a2,0xf8b00
f900087c:	08048593          	addi	a1,s1,128
f9000880:	35040513          	addi	a0,s0,848
f9000884:	d35ff0ef          	jal	ra,f90005b8 <clint_uDelay>

	rtl8211_drv_setpage(0x0A43);
f9000888:	000014b7          	lui	s1,0x1
f900088c:	a4348513          	addi	a0,s1,-1469 # a43 <CUSTOM1+0xa18>
f9000890:	e4dff0ef          	jal	ra,f90006dc <rtl8211_drv_setpage>
	rtl8211_drv_wrdata(27,0x8011);//reserved register
f9000894:	00008437          	lui	s0,0x8
f9000898:	01140593          	addi	a1,s0,17 # 8011 <__stack_size+0x7011>
f900089c:	01b00513          	li	a0,27
f90008a0:	e11ff0ef          	jal	ra,f90006b0 <rtl8211_drv_wrdata>
	rtl8211_drv_wrdata(28,0xD73F);//reserved register
f90008a4:	0000d5b7          	lui	a1,0xd
f90008a8:	73f58593          	addi	a1,a1,1855 # d73f <__stack_size+0xc73f>
f90008ac:	01c00513          	li	a0,28
f90008b0:	e01ff0ef          	jal	ra,f90006b0 <rtl8211_drv_wrdata>

	rtl8211_drv_setpage(0xD04);
f90008b4:	d0448513          	addi	a0,s1,-764
f90008b8:	e25ff0ef          	jal	ra,f90006dc <rtl8211_drv_setpage>
	rtl8211_drv_wrdata(0x10,0x820B);//reserved register
f90008bc:	20b40593          	addi	a1,s0,523
f90008c0:	01000513          	li	a0,16
f90008c4:	dedff0ef          	jal	ra,f90006b0 <rtl8211_drv_wrdata>
}
f90008c8:	00c12083          	lw	ra,12(sp)
f90008cc:	00812403          	lw	s0,8(sp)
f90008d0:	00412483          	lw	s1,4(sp)
f90008d4:	01010113          	addi	sp,sp,16
f90008d8:	00008067          	ret

f90008dc <uart_writeAvailability>:
f90008dc:	00452503          	lw	a0,4(a0)
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
f90008e0:	01055513          	srli	a0,a0,0x10
    }
f90008e4:	0ff57513          	andi	a0,a0,255
f90008e8:	00008067          	ret

f90008ec <uart_write>:
    static void uart_write(u32 reg, char data){
f90008ec:	ff010113          	addi	sp,sp,-16
f90008f0:	00112623          	sw	ra,12(sp)
f90008f4:	00812423          	sw	s0,8(sp)
f90008f8:	00912223          	sw	s1,4(sp)
f90008fc:	00050413          	mv	s0,a0
f9000900:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
f9000904:	00040513          	mv	a0,s0
f9000908:	fd5ff0ef          	jal	ra,f90008dc <uart_writeAvailability>
f900090c:	fe050ce3          	beqz	a0,f9000904 <uart_write+0x18>
        *((volatile u32*) address) = data;
f9000910:	00942023          	sw	s1,0(s0)
    }
f9000914:	00c12083          	lw	ra,12(sp)
f9000918:	00812403          	lw	s0,8(sp)
f900091c:	00412483          	lw	s1,4(sp)
f9000920:	01010113          	addi	sp,sp,16
f9000924:	00008067          	ret

f9000928 <Reg_Out32>:
f9000928:	00b52023          	sw	a1,0(a0)

/************************** Function File ***************************/
void Reg_Out32(u32 addr,u32 data)
{
    write_u32(data,addr);
}
f900092c:	00008067          	ret

f9000930 <Reg_In32>:
        return *((volatile u32*) address);
f9000930:	00052503          	lw	a0,0(a0)

u32 Reg_In32(u32 addr)
{
    return read_u32(addr);
}
f9000934:	00008067          	ret

f9000938 <putchar>:
  }
  putchar('\n');
  return 0;
}

int putchar(int c){
f9000938:	ff010113          	addi	sp,sp,-16
f900093c:	00112623          	sw	ra,12(sp)
f9000940:	00812423          	sw	s0,8(sp)
f9000944:	00050413          	mv	s0,a0
    bsp_putChar(c);
f9000948:	0ff57593          	andi	a1,a0,255
f900094c:	f8010537          	lui	a0,0xf8010
f9000950:	f9dff0ef          	jal	ra,f90008ec <uart_write>
    return c;
}
f9000954:	00040513          	mv	a0,s0
f9000958:	00c12083          	lw	ra,12(sp)
f900095c:	00812403          	lw	s0,8(sp)
f9000960:	01010113          	addi	sp,sp,16
f9000964:	00008067          	ret

f9000968 <bsp_printf_c>:
{
f9000968:	ff010113          	addi	sp,sp,-16
f900096c:	00112623          	sw	ra,12(sp)
    putchar(c);
f9000970:	fc9ff0ef          	jal	ra,f9000938 <putchar>
}
f9000974:	00c12083          	lw	ra,12(sp)
f9000978:	01010113          	addi	sp,sp,16
f900097c:	00008067          	ret

f9000980 <bsp_printf_d>:
{
f9000980:	fd010113          	addi	sp,sp,-48
f9000984:	02112623          	sw	ra,44(sp)
f9000988:	02812423          	sw	s0,40(sp)
f900098c:	02912223          	sw	s1,36(sp)
f9000990:	00050493          	mv	s1,a0
    if (val < 0) {
f9000994:	00054663          	bltz	a0,f90009a0 <bsp_printf_d+0x20>
{
f9000998:	00010413          	mv	s0,sp
f900099c:	02c0006f          	j	f90009c8 <bsp_printf_d+0x48>
        bsp_printf_c('-');
f90009a0:	02d00513          	li	a0,45
f90009a4:	fc5ff0ef          	jal	ra,f9000968 <bsp_printf_c>
        val = -val;
f90009a8:	409004b3          	neg	s1,s1
f90009ac:	fedff06f          	j	f9000998 <bsp_printf_d+0x18>
        *(p++) = '0' + val % 10;
f90009b0:	00a00713          	li	a4,10
f90009b4:	02e4e7b3          	rem	a5,s1,a4
f90009b8:	03078793          	addi	a5,a5,48
f90009bc:	00f40023          	sb	a5,0(s0)
        val = val / 10;
f90009c0:	02e4c4b3          	div	s1,s1,a4
        *(p++) = '0' + val % 10;
f90009c4:	00140413          	addi	s0,s0,1
    while (val || p == buffer) {
f90009c8:	fe0494e3          	bnez	s1,f90009b0 <bsp_printf_d+0x30>
f90009cc:	00010793          	mv	a5,sp
f90009d0:	fef400e3          	beq	s0,a5,f90009b0 <bsp_printf_d+0x30>
f90009d4:	0100006f          	j	f90009e4 <bsp_printf_d+0x64>
        bsp_printf_c(*(--p));
f90009d8:	fff40413          	addi	s0,s0,-1
f90009dc:	00044503          	lbu	a0,0(s0)
f90009e0:	f89ff0ef          	jal	ra,f9000968 <bsp_printf_c>
    while (p != buffer)
f90009e4:	00010793          	mv	a5,sp
f90009e8:	fef418e3          	bne	s0,a5,f90009d8 <bsp_printf_d+0x58>
}
f90009ec:	02c12083          	lw	ra,44(sp)
f90009f0:	02812403          	lw	s0,40(sp)
f90009f4:	02412483          	lw	s1,36(sp)
f90009f8:	03010113          	addi	sp,sp,48
f90009fc:	00008067          	ret

f9000a00 <bsp_printf_s>:
{
f9000a00:	ff010113          	addi	sp,sp,-16
f9000a04:	00112623          	sw	ra,12(sp)
f9000a08:	00812423          	sw	s0,8(sp)
f9000a0c:	00050413          	mv	s0,a0
    while (*p)
f9000a10:	00044503          	lbu	a0,0(s0)
f9000a14:	00050863          	beqz	a0,f9000a24 <bsp_printf_s+0x24>
        putchar(*(p++));
f9000a18:	00140413          	addi	s0,s0,1
f9000a1c:	f1dff0ef          	jal	ra,f9000938 <putchar>
f9000a20:	ff1ff06f          	j	f9000a10 <bsp_printf_s+0x10>
}
f9000a24:	00c12083          	lw	ra,12(sp)
f9000a28:	00812403          	lw	s0,8(sp)
f9000a2c:	01010113          	addi	sp,sp,16
f9000a30:	00008067          	ret

f9000a34 <bsp_puts>:
int bsp_puts(char *s){
f9000a34:	ff010113          	addi	sp,sp,-16
f9000a38:	00112623          	sw	ra,12(sp)
f9000a3c:	00812423          	sw	s0,8(sp)
f9000a40:	00050413          	mv	s0,a0
  while (*s) {
f9000a44:	00044503          	lbu	a0,0(s0)
f9000a48:	00050863          	beqz	a0,f9000a58 <bsp_puts+0x24>
    putchar(*s);
f9000a4c:	eedff0ef          	jal	ra,f9000938 <putchar>
    s++;
f9000a50:	00140413          	addi	s0,s0,1
f9000a54:	ff1ff06f          	j	f9000a44 <bsp_puts+0x10>
  putchar('\n');
f9000a58:	00a00513          	li	a0,10
f9000a5c:	eddff0ef          	jal	ra,f9000938 <putchar>
}
f9000a60:	00000513          	li	a0,0
f9000a64:	00c12083          	lw	ra,12(sp)
f9000a68:	00812403          	lw	s0,8(sp)
f9000a6c:	01010113          	addi	sp,sp,16
f9000a70:	00008067          	ret

f9000a74 <print_hex>:

void print_hex(uint32_t val, uint32_t digits)
{
f9000a74:	ff010113          	addi	sp,sp,-16
f9000a78:	00112623          	sw	ra,12(sp)
f9000a7c:	00812423          	sw	s0,8(sp)
f9000a80:	00912223          	sw	s1,4(sp)
f9000a84:	00050493          	mv	s1,a0
	for (int i = (4*digits)-4; i >= 0; i -= 4)
f9000a88:	40000437          	lui	s0,0x40000
f9000a8c:	fff40413          	addi	s0,s0,-1 # 3fffffff <__stack_size+0x3fffefff>
f9000a90:	00858433          	add	s0,a1,s0
f9000a94:	00241413          	slli	s0,s0,0x2
f9000a98:	02044663          	bltz	s0,f9000ac4 <print_hex+0x50>
		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
f9000a9c:	0084d7b3          	srl	a5,s1,s0
f9000aa0:	00f7f713          	andi	a4,a5,15
f9000aa4:	f90017b7          	lui	a5,0xf9001
f9000aa8:	c3478793          	addi	a5,a5,-972 # f9000c34 <__freertos_irq_stack_top+0xffffecd4>
f9000aac:	00e787b3          	add	a5,a5,a4
f9000ab0:	0007c583          	lbu	a1,0(a5)
f9000ab4:	f8010537          	lui	a0,0xf8010
f9000ab8:	e35ff0ef          	jal	ra,f90008ec <uart_write>
	for (int i = (4*digits)-4; i >= 0; i -= 4)
f9000abc:	ffc40413          	addi	s0,s0,-4
f9000ac0:	fd9ff06f          	j	f9000a98 <print_hex+0x24>
}
f9000ac4:	00c12083          	lw	ra,12(sp)
f9000ac8:	00812403          	lw	s0,8(sp)
f9000acc:	00412483          	lw	s1,4(sp)
f9000ad0:	01010113          	addi	sp,sp,16
f9000ad4:	00008067          	ret

f9000ad8 <bsp_printf_x>:
{
f9000ad8:	ff010113          	addi	sp,sp,-16
f9000adc:	00112623          	sw	ra,12(sp)
	for(i=0;i<8;i++)
f9000ae0:	00000593          	li	a1,0
f9000ae4:	00700793          	li	a5,7
f9000ae8:	02b7c463          	blt	a5,a1,f9000b10 <bsp_printf_x+0x38>
		if((val & (0xFFFFFFF0 <<(4*i))) == 0)
f9000aec:	00259713          	slli	a4,a1,0x2
f9000af0:	ff000793          	li	a5,-16
f9000af4:	00e797b3          	sll	a5,a5,a4
f9000af8:	00f577b3          	and	a5,a0,a5
f9000afc:	00078663          	beqz	a5,f9000b08 <bsp_printf_x+0x30>
	for(i=0;i<8;i++)
f9000b00:	00158593          	addi	a1,a1,1
f9000b04:	fe1ff06f          	j	f9000ae4 <bsp_printf_x+0xc>
			digi=i+1;
f9000b08:	00158593          	addi	a1,a1,1
			break;
f9000b0c:	0080006f          	j	f9000b14 <bsp_printf_x+0x3c>
	int i,digi=2;
f9000b10:	00200593          	li	a1,2
	print_hex(val,digi);
f9000b14:	f61ff0ef          	jal	ra,f9000a74 <print_hex>
}
f9000b18:	00c12083          	lw	ra,12(sp)
f9000b1c:	01010113          	addi	sp,sp,16
f9000b20:	00008067          	ret

f9000b24 <bsp_printf>:
{
f9000b24:	fc010113          	addi	sp,sp,-64
f9000b28:	00112e23          	sw	ra,28(sp)
f9000b2c:	00812c23          	sw	s0,24(sp)
f9000b30:	00912a23          	sw	s1,20(sp)
f9000b34:	00050493          	mv	s1,a0
f9000b38:	02b12223          	sw	a1,36(sp)
f9000b3c:	02c12423          	sw	a2,40(sp)
f9000b40:	02d12623          	sw	a3,44(sp)
f9000b44:	02e12823          	sw	a4,48(sp)
f9000b48:	02f12a23          	sw	a5,52(sp)
f9000b4c:	03012c23          	sw	a6,56(sp)
f9000b50:	03112e23          	sw	a7,60(sp)
    va_start(ap, format);
f9000b54:	02410793          	addi	a5,sp,36
f9000b58:	00f12623          	sw	a5,12(sp)
    for (i = 0; format[i]; i++)
f9000b5c:	00000413          	li	s0,0
f9000b60:	01c0006f          	j	f9000b7c <bsp_printf+0x58>
                    bsp_printf_c(va_arg(ap,int));
f9000b64:	00c12783          	lw	a5,12(sp)
f9000b68:	00478713          	addi	a4,a5,4
f9000b6c:	00e12623          	sw	a4,12(sp)
f9000b70:	0007a503          	lw	a0,0(a5)
f9000b74:	df5ff0ef          	jal	ra,f9000968 <bsp_printf_c>
    for (i = 0; format[i]; i++)
f9000b78:	00140413          	addi	s0,s0,1
f9000b7c:	008487b3          	add	a5,s1,s0
f9000b80:	0007c503          	lbu	a0,0(a5)
f9000b84:	08050663          	beqz	a0,f9000c10 <bsp_printf+0xec>
        if (format[i] == '%') {
f9000b88:	02500793          	li	a5,37
f9000b8c:	02f50e63          	beq	a0,a5,f9000bc8 <bsp_printf+0xa4>
            bsp_printf_c(format[i]);
f9000b90:	dd9ff0ef          	jal	ra,f9000968 <bsp_printf_c>
f9000b94:	fe5ff06f          	j	f9000b78 <bsp_printf+0x54>
                    bsp_printf_s(va_arg(ap,char*));
f9000b98:	00c12783          	lw	a5,12(sp)
f9000b9c:	00478713          	addi	a4,a5,4
f9000ba0:	00e12623          	sw	a4,12(sp)
f9000ba4:	0007a503          	lw	a0,0(a5)
f9000ba8:	e59ff0ef          	jal	ra,f9000a00 <bsp_printf_s>
                    break;
f9000bac:	fcdff06f          	j	f9000b78 <bsp_printf+0x54>
                    bsp_printf_d(va_arg(ap,int));
f9000bb0:	00c12783          	lw	a5,12(sp)
f9000bb4:	00478713          	addi	a4,a5,4
f9000bb8:	00e12623          	sw	a4,12(sp)
f9000bbc:	0007a503          	lw	a0,0(a5)
f9000bc0:	dc1ff0ef          	jal	ra,f9000980 <bsp_printf_d>
                    break;
f9000bc4:	fb5ff06f          	j	f9000b78 <bsp_printf+0x54>
            while (format[++i]) {
f9000bc8:	00140413          	addi	s0,s0,1
f9000bcc:	008487b3          	add	a5,s1,s0
f9000bd0:	0007c783          	lbu	a5,0(a5)
f9000bd4:	fa0782e3          	beqz	a5,f9000b78 <bsp_printf+0x54>
                if (format[i] == 'c') {
f9000bd8:	06300713          	li	a4,99
f9000bdc:	f8e784e3          	beq	a5,a4,f9000b64 <bsp_printf+0x40>
                if (format[i] == 's') {
f9000be0:	07300713          	li	a4,115
f9000be4:	fae78ae3          	beq	a5,a4,f9000b98 <bsp_printf+0x74>
                if (format[i] == 'd') {
f9000be8:	06400713          	li	a4,100
f9000bec:	fce782e3          	beq	a5,a4,f9000bb0 <bsp_printf+0x8c>
                if (format[i] == 'x') {
f9000bf0:	07800713          	li	a4,120
f9000bf4:	fce79ae3          	bne	a5,a4,f9000bc8 <bsp_printf+0xa4>
					bsp_printf_x(va_arg(ap,int));
f9000bf8:	00c12783          	lw	a5,12(sp)
f9000bfc:	00478713          	addi	a4,a5,4
f9000c00:	00e12623          	sw	a4,12(sp)
f9000c04:	0007a503          	lw	a0,0(a5)
f9000c08:	ed1ff0ef          	jal	ra,f9000ad8 <bsp_printf_x>
					break;
f9000c0c:	f6dff06f          	j	f9000b78 <bsp_printf+0x54>
    putchar('\n');
f9000c10:	00a00513          	li	a0,10
f9000c14:	d25ff0ef          	jal	ra,f9000938 <putchar>
    putchar('\r');
f9000c18:	00d00513          	li	a0,13
f9000c1c:	d1dff0ef          	jal	ra,f9000938 <putchar>
}
f9000c20:	01c12083          	lw	ra,28(sp)
f9000c24:	01812403          	lw	s0,24(sp)
f9000c28:	01412483          	lw	s1,20(sp)
f9000c2c:	04010113          	addi	sp,sp,64
f9000c30:	00008067          	ret
