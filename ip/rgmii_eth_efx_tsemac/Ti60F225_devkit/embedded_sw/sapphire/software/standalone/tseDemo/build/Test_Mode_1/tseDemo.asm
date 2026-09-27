
build/tseDemo.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00002197          	auipc	gp,0x2
f9000004:	86818193          	addi	gp,gp,-1944 # f9001868 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	00002117          	auipc	sp,0x2
f900000c:	08810113          	addi	sp,sp,136 # f9002090 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f9000010:	00001517          	auipc	a0,0x1
f9000014:	cd450513          	addi	a0,a0,-812 # f9000ce4 <__init_array_end>
	la a1, _data
f9000018:	00001597          	auipc	a1,0x1
f900001c:	ccc58593          	addi	a1,a1,-820 # f9000ce4 <__init_array_end>
	la a2, _edata
f9000020:	81c18613          	addi	a2,gp,-2020 # f9001084 <__bss_start>
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
f900003c:	81c18513          	addi	a0,gp,-2020 # f9001084 <__bss_start>
	la a1, _end
f9000040:	82018593          	addi	a1,gp,-2016 # f9001088 <_end>
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
f9000058:	5cc000ef          	jal	ra,f9000624 <main>

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
f9000074:	c7440413          	addi	s0,s0,-908 # f9000ce4 <__init_array_end>
f9000078:	00001917          	auipc	s2,0x1
f900007c:	c6c90913          	addi	s2,s2,-916 # f9000ce4 <__init_array_end>
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
f90000b0:	c3840413          	addi	s0,s0,-968 # f9000ce4 <__init_array_end>
f90000b4:	00001917          	auipc	s2,0x1
f90000b8:	c3090913          	addi	s2,s2,-976 # f9000ce4 <__init_array_end>
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
f90001e4:	ce478793          	addi	a5,a5,-796 # f9000ce4 <__freertos_irq_stack_top+0xffffec54>
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

f9000298 <MacIpgSet>:
	}
}

/************************** Function File ***************************/
static void MacIpgSet(u32 ipg)
{
f9000298:	ff010113          	addi	sp,sp,-16
f900029c:	00112623          	sw	ra,12(sp)
	//Set Mac IPG
	write_u32(ipg&0x3f, (TSEMAC_CSR+0x5C));
f90002a0:	03f57513          	andi	a0,a0,63
        *((volatile u32*) address) = data;
f90002a4:	f81007b7          	lui	a5,0xf8100
f90002a8:	04a7ae23          	sw	a0,92(a5) # f810005c <__freertos_irq_stack_top+0xff0fdfcc>
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac IPG.");
f90002ac:	f9001537          	lui	a0,0xf9001
f90002b0:	cf850513          	addi	a0,a0,-776 # f9000cf8 <__freertos_irq_stack_top+0xffffec68>
f90002b4:	f79ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f90002b8:	00c12083          	lw	ra,12(sp)
f90002bc:	01010113          	addi	sp,sp,16
f90002c0:	00008067          	ret

f90002c4 <MacAddrSet>:

/************************** Function File ***************************/
static void MacAddrSet(u32 dst_addr_ins, u32 src_addr_ins)
{
f90002c4:	ff010113          	addi	sp,sp,-16
f90002c8:	00112623          	sw	ra,12(sp)
f90002cc:	f81007b7          	lui	a5,0xf8100
f90002d0:	00010737          	lui	a4,0x10
f90002d4:	fff70713          	addi	a4,a4,-1 # ffff <__stack_size+0xefff>
f90002d8:	18e7a423          	sw	a4,392(a5) # f8100188 <__freertos_irq_stack_top+0xff0fe0f8>
f90002dc:	fff00713          	li	a4,-1
f90002e0:	18e7a223          	sw	a4,388(a5)
f90002e4:	18a7a023          	sw	a0,384(a5)
f90002e8:	0000f737          	lui	a4,0xf
f90002ec:	ae870713          	addi	a4,a4,-1304 # eae8 <__stack_size+0xdae8>
f90002f0:	00e7a823          	sw	a4,16(a5)
f90002f4:	5e006737          	lui	a4,0x5e006
f90002f8:	0c870713          	addi	a4,a4,200 # 5e0060c8 <__stack_size+0x5e0050c8>
f90002fc:	00e7a623          	sw	a4,12(a5)
        return *((volatile u32*) address);
f9000300:	0087a703          	lw	a4,8(a5)
    //mac_addr[47:32]
	write_u32(SRC_MAC_H, (TSEMAC_CSR+0x010));
    //mac_addr[31:0]
	write_u32(SRC_MAC_L, (TSEMAC_CSR+0x00c));
	//src mac addr ins set
	Value = read_u32(TSEMAC_CSR+0x008) & TX_ADDR_INS_MASK;
f9000304:	bff77713          	andi	a4,a4,-1025
	Value |= (src_addr_ins&0x1)<<9;
f9000308:	00959593          	slli	a1,a1,0x9
f900030c:	2005f593          	andi	a1,a1,512
f9000310:	00e5e5b3          	or	a1,a1,a4
        *((volatile u32*) address) = data;
f9000314:	00b7a423          	sw	a1,8(a5)
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac Address.");
f9000318:	f9001537          	lui	a0,0xf9001
f900031c:	d0c50513          	addi	a0,a0,-756 # f9000d0c <__freertos_irq_stack_top+0xffffec7c>
f9000320:	f0dff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f9000324:	00c12083          	lw	ra,12(sp)
f9000328:	01010113          	addi	sp,sp,16
f900032c:	00008067          	ret

f9000330 <MacCntClean>:
	write_u32(Value, (TSEMAC_CSR+0x008));
}

/************************** Function File ***************************/
static void MacCntClean()
{
f9000330:	ff010113          	addi	sp,sp,-16
f9000334:	00112623          	sw	ra,12(sp)
f9000338:	00812423          	sw	s0,8(sp)
f900033c:	00912223          	sw	s1,4(sp)
        return *((volatile u32*) address);
f9000340:	f81004b7          	lui	s1,0xf8100
f9000344:	0084a403          	lw	s0,8(s1) # f8100008 <__freertos_irq_stack_top+0xff0fdf78>
	u32 Value;
	//Set cnt_reset 1
	Value = read_u32(TSEMAC_CSR+0x008) & CNT_RST_MASK;
f9000348:	800007b7          	lui	a5,0x80000
f900034c:	fff7c713          	not	a4,a5
f9000350:	00e47433          	and	s0,s0,a4
	Value |= 0x80000000;
f9000354:	00f467b3          	or	a5,s0,a5
        *((volatile u32*) address) = data;
f9000358:	00f4a423          	sw	a5,8(s1)
	write_u32(Value, (TSEMAC_CSR+0x008));
	bsp_uDelay(1);
f900035c:	f8b00637          	lui	a2,0xf8b00
f9000360:	02faf5b7          	lui	a1,0x2faf
f9000364:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000368:	00100513          	li	a0,1
f900036c:	e1dff0ef          	jal	ra,f9000188 <clint_uDelay>
f9000370:	0084a423          	sw	s0,8(s1)
	//Set cnt_reset 0
	Value &= CNT_RST_MASK;
	Value |= 0x0;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
		bsp_print("Info : Mac Reset Statistics Counters.");
f9000374:	f9001537          	lui	a0,0xf9001
f9000378:	d2450513          	addi	a0,a0,-732 # f9000d24 <__freertos_irq_stack_top+0xffffec94>
f900037c:	eb1ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f9000380:	00c12083          	lw	ra,12(sp)
f9000384:	00812403          	lw	s0,8(sp)
f9000388:	00412483          	lw	s1,4(sp)
f900038c:	01010113          	addi	sp,sp,16
f9000390:	00008067          	ret

f9000394 <CntMonitor>:

/************************** Function File ***************************/
static void CntMonitor()
{
f9000394:	ff010113          	addi	sp,sp,-16
f9000398:	00112623          	sw	ra,12(sp)
f900039c:	00812423          	sw	s0,8(sp)
f90003a0:	00912223          	sw	s1,4(sp)
	bsp_print("--------------------");
f90003a4:	f90014b7          	lui	s1,0xf9001
f90003a8:	d4c48513          	addi	a0,s1,-692 # f9000d4c <__freertos_irq_stack_top+0xffffecbc>
f90003ac:	e81ff0ef          	jal	ra,f900022c <bsp_print>
        return *((volatile u32*) address);
f90003b0:	f8100437          	lui	s0,0xf8100
f90003b4:	06842583          	lw	a1,104(s0) # f8100068 <__freertos_irq_stack_top+0xff0fdfd8>
	bsp_printReg("aFramesTransmittedOK :"       , read_u32(TSEMAC_CSR+0x68));
f90003b8:	f9001537          	lui	a0,0xf9001
f90003bc:	d6450513          	addi	a0,a0,-668 # f9000d64 <__freertos_irq_stack_top+0xffffecd4>
f90003c0:	ea5ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003c4:	06c42583          	lw	a1,108(s0)
	bsp_printReg("aFramesReceivedOK :"          , read_u32(TSEMAC_CSR+0x6c));
f90003c8:	f9001537          	lui	a0,0xf9001
f90003cc:	d7c50513          	addi	a0,a0,-644 # f9000d7c <__freertos_irq_stack_top+0xffffecec>
f90003d0:	e95ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003d4:	08842583          	lw	a1,136(s0)
	bsp_printReg("ifInErrors :"                 , read_u32(TSEMAC_CSR+0x88));
f90003d8:	f9001537          	lui	a0,0xf9001
f90003dc:	d9050513          	addi	a0,a0,-624 # f9000d90 <__freertos_irq_stack_top+0xffffed00>
f90003e0:	e85ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003e4:	08c42583          	lw	a1,140(s0)
	bsp_printReg("ifOutErrors :"                , read_u32(TSEMAC_CSR+0x8c));
f90003e8:	f9001537          	lui	a0,0xf9001
f90003ec:	da050513          	addi	a0,a0,-608 # f9000da0 <__freertos_irq_stack_top+0xffffed10>
f90003f0:	e75ff0ef          	jal	ra,f9000264 <bsp_printReg>
f90003f4:	0b442583          	lw	a1,180(s0)
	bsp_printReg("etherStatsPkts :"             , read_u32(TSEMAC_CSR+0xb4));
f90003f8:	f9001537          	lui	a0,0xf9001
f90003fc:	db050513          	addi	a0,a0,-592 # f9000db0 <__freertos_irq_stack_top+0xffffed20>
f9000400:	e65ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000404:	0b842583          	lw	a1,184(s0)
	bsp_printReg("etherStatsUndersizePkts :"    , read_u32(TSEMAC_CSR+0xb8));
f9000408:	f9001537          	lui	a0,0xf9001
f900040c:	dc450513          	addi	a0,a0,-572 # f9000dc4 <__freertos_irq_stack_top+0xffffed34>
f9000410:	e55ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000414:	0bc42583          	lw	a1,188(s0)
	bsp_printReg("etherStatsOversizePkts :"     , read_u32(TSEMAC_CSR+0xbc));
f9000418:	f9001537          	lui	a0,0xf9001
f900041c:	de050513          	addi	a0,a0,-544 # f9000de0 <__freertos_irq_stack_top+0xffffed50>
f9000420:	e45ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000424:	09c42583          	lw	a1,156(s0)
	bsp_printReg("aRxFilterFramesErrors :"      , read_u32(TSEMAC_CSR+0x9c));
f9000428:	f9001537          	lui	a0,0xf9001
f900042c:	dfc50513          	addi	a0,a0,-516 # f9000dfc <__freertos_irq_stack_top+0xffffed6c>
f9000430:	e35ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000434:	07042583          	lw	a1,112(s0)
	bsp_printReg("aFrameCheckSequenceErrors :"  , read_u32(TSEMAC_CSR+0x70));
f9000438:	f9001537          	lui	a0,0xf9001
f900043c:	e1450513          	addi	a0,a0,-492 # f9000e14 <__freertos_irq_stack_top+0xffffed84>
f9000440:	e25ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000444:	08042583          	lw	a1,128(s0)
	bsp_printReg("aTxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x80));
f9000448:	f9001537          	lui	a0,0xf9001
f900044c:	e3050513          	addi	a0,a0,-464 # f9000e30 <__freertos_irq_stack_top+0xffffeda0>
f9000450:	e15ff0ef          	jal	ra,f9000264 <bsp_printReg>
f9000454:	08442583          	lw	a1,132(s0)
	bsp_printReg("aRxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x84));
f9000458:	f9001537          	lui	a0,0xf9001
f900045c:	e4850513          	addi	a0,a0,-440 # f9000e48 <__freertos_irq_stack_top+0xffffedb8>
f9000460:	e05ff0ef          	jal	ra,f9000264 <bsp_printReg>
	bsp_print("--------------------");
f9000464:	d4c48513          	addi	a0,s1,-692
f9000468:	dc5ff0ef          	jal	ra,f900022c <bsp_print>
}
f900046c:	00c12083          	lw	ra,12(sp)
f9000470:	00812403          	lw	s0,8(sp)
f9000474:	00412483          	lw	s1,4(sp)
f9000478:	01010113          	addi	sp,sp,16
f900047c:	00008067          	ret

f9000480 <PhyLoopInit>:
		CntMonitor();
	}
}

static void PhyLoopInit(u32 speed)
{
f9000480:	ff010113          	addi	sp,sp,-16
f9000484:	00112623          	sw	ra,12(sp)
	//PhyDlySetRXTX(15, 15); //change the delay here for Test_mode_0 (Normal mode)
	u32 Value;
	if(speed == 0x4) {
f9000488:	00400793          	li	a5,4
f900048c:	02f50063          	beq	a0,a5,f90004ac <PhyLoopInit+0x2c>
		Phy_Wr(0x0, 0x4140);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 1000Mbps Loopback Mode.");
		}
	} else if(speed == 0x2) {
f9000490:	00200793          	li	a5,2
f9000494:	02f50c63          	beq	a0,a5,f90004cc <PhyLoopInit+0x4c>
		Phy_Wr(0x0, 0x6100);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 100Mbps Loopback Mode.");
		}
	} else if(speed == 0x1) {
f9000498:	00100793          	li	a5,1
f900049c:	04f50863          	beq	a0,a5,f90004ec <PhyLoopInit+0x6c>
		Phy_Wr(0x0, 0x4100);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 10Mbps Loopback Mode.");
		}
	}
}
f90004a0:	00c12083          	lw	ra,12(sp)
f90004a4:	01010113          	addi	sp,sp,16
f90004a8:	00008067          	ret
		Phy_Wr(0x0, 0x4140);
f90004ac:	000045b7          	lui	a1,0x4
f90004b0:	14058593          	addi	a1,a1,320 # 4140 <__stack_size+0x3140>
f90004b4:	00000513          	li	a0,0
f90004b8:	23c000ef          	jal	ra,f90006f4 <Phy_Wr>
			bsp_print("Info : Set Phy 1000Mbps Loopback Mode.");
f90004bc:	f9001537          	lui	a0,0xf9001
f90004c0:	e6050513          	addi	a0,a0,-416 # f9000e60 <__freertos_irq_stack_top+0xffffedd0>
f90004c4:	d69ff0ef          	jal	ra,f900022c <bsp_print>
f90004c8:	fd9ff06f          	j	f90004a0 <PhyLoopInit+0x20>
		Phy_Wr(0x0, 0x6100);
f90004cc:	000065b7          	lui	a1,0x6
f90004d0:	10058593          	addi	a1,a1,256 # 6100 <__stack_size+0x5100>
f90004d4:	00000513          	li	a0,0
f90004d8:	21c000ef          	jal	ra,f90006f4 <Phy_Wr>
			bsp_print("Info : Set Phy 100Mbps Loopback Mode.");
f90004dc:	f9001537          	lui	a0,0xf9001
f90004e0:	e8850513          	addi	a0,a0,-376 # f9000e88 <__freertos_irq_stack_top+0xffffedf8>
f90004e4:	d49ff0ef          	jal	ra,f900022c <bsp_print>
f90004e8:	fb9ff06f          	j	f90004a0 <PhyLoopInit+0x20>
		Phy_Wr(0x0, 0x4100);
f90004ec:	000045b7          	lui	a1,0x4
f90004f0:	10058593          	addi	a1,a1,256 # 4100 <__stack_size+0x3100>
f90004f4:	00000513          	li	a0,0
f90004f8:	1fc000ef          	jal	ra,f90006f4 <Phy_Wr>
			bsp_print("Info : Set Phy 10Mbps Loopback Mode.");
f90004fc:	f9001537          	lui	a0,0xf9001
f9000500:	eb050513          	addi	a0,a0,-336 # f9000eb0 <__freertos_irq_stack_top+0xffffee20>
f9000504:	d29ff0ef          	jal	ra,f900022c <bsp_print>
}
f9000508:	f99ff06f          	j	f90004a0 <PhyLoopInit+0x20>

f900050c <PatGen>:
{
f900050c:	ff010113          	addi	sp,sp,-16
f9000510:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f9000514:	f81007b7          	lui	a5,0xf8100
f9000518:	00010737          	lui	a4,0x10
f900051c:	fff70713          	addi	a4,a4,-1 # ffff <__stack_size+0xefff>
f9000520:	20e7aa23          	sw	a4,532(a5) # f8100214 <__freertos_irq_stack_top+0xff0fe184>
f9000524:	fff00713          	li	a4,-1
f9000528:	20e7a823          	sw	a4,528(a5)
f900052c:	0000f737          	lui	a4,0xf
f9000530:	ae870713          	addi	a4,a4,-1304 # eae8 <__stack_size+0xdae8>
f9000534:	20e7ae23          	sw	a4,540(a5)
f9000538:	5e006737          	lui	a4,0x5e006
f900053c:	0c870713          	addi	a4,a4,200 # 5e0060c8 <__stack_size+0x5e0050c8>
f9000540:	20e7ac23          	sw	a4,536(a5)
f9000544:	c0a80737          	lui	a4,0xc0a80
f9000548:	16470693          	addi	a3,a4,356 # c0a80164 <__freertos_irq_stack_top+0xc7a7e0d4>
f900054c:	22d7a223          	sw	a3,548(a5)
f9000550:	16570713          	addi	a4,a4,357
f9000554:	22e7a423          	sw	a4,552(a5)
f9000558:	27150737          	lui	a4,0x27150
f900055c:	52170713          	addi	a4,a4,1313 # 27150521 <__stack_size+0x2714f521>
f9000560:	22e7a623          	sw	a4,556(a5)
f9000564:	00640737          	lui	a4,0x640
f9000568:	20e7a623          	sw	a4,524(a5)
f900056c:	06400713          	li	a4,100
f9000570:	22e7a023          	sw	a4,544(a5)
f9000574:	22e7a823          	sw	a4,560(a5)
f9000578:	2007a423          	sw	zero,520(a5)
f900057c:	2007a223          	sw	zero,516(a5)
f9000580:	00100713          	li	a4,1
f9000584:	20e7a423          	sw	a4,520(a5)
f9000588:	2007a423          	sw	zero,520(a5)
        bsp_print("Info : Set Pattern Generator.");
f900058c:	f9001537          	lui	a0,0xf9001
f9000590:	ed850513          	addi	a0,a0,-296 # f9000ed8 <__freertos_irq_stack_top+0xffffee48>
f9000594:	c99ff0ef          	jal	ra,f900022c <bsp_print>
}
f9000598:	00c12083          	lw	ra,12(sp)
f900059c:	01010113          	addi	sp,sp,16
f90005a0:	00008067          	ret

f90005a4 <StartRunning>:
{
f90005a4:	ff010113          	addi	sp,sp,-16
f90005a8:	00112623          	sw	ra,12(sp)
f90005ac:	00812423          	sw	s0,8(sp)
f90005b0:	00912223          	sw	s1,4(sp)
f90005b4:	f8100437          	lui	s0,0xf8100
f90005b8:	00100493          	li	s1,1
f90005bc:	20942023          	sw	s1,512(s0) # f8100200 <__freertos_irq_stack_top+0xff0fe170>
	    bsp_print("Info : Assert mac reset ");
f90005c0:	f9001537          	lui	a0,0xf9001
f90005c4:	ef850513          	addi	a0,a0,-264 # f9000ef8 <__freertos_irq_stack_top+0xffffee68>
f90005c8:	c65ff0ef          	jal	ra,f900022c <bsp_print>
	bsp_uDelay(1);
f90005cc:	f8b00637          	lui	a2,0xf8b00
f90005d0:	02faf5b7          	lui	a1,0x2faf
f90005d4:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90005d8:	00100513          	li	a0,1
f90005dc:	badff0ef          	jal	ra,f9000188 <clint_uDelay>
f90005e0:	20042023          	sw	zero,512(s0)
	    bsp_print("Info : Deassert mac reset ");
f90005e4:	f9001537          	lui	a0,0xf9001
f90005e8:	f1450513          	addi	a0,a0,-236 # f9000f14 <__freertos_irq_stack_top+0xffffee84>
f90005ec:	c41ff0ef          	jal	ra,f900022c <bsp_print>
f90005f0:	20942223          	sw	s1,516(s0)
		MacAddrSet(0, 1);
f90005f4:	00100593          	li	a1,1
f90005f8:	00000513          	li	a0,0
f90005fc:	cc9ff0ef          	jal	ra,f90002c4 <MacAddrSet>
		MacCntClean();
f9000600:	d31ff0ef          	jal	ra,f9000330 <MacCntClean>
		bsp_uDelay(3000000);
f9000604:	f8b00637          	lui	a2,0xf8b00
f9000608:	02faf5b7          	lui	a1,0x2faf
f900060c:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000610:	002dc537          	lui	a0,0x2dc
f9000614:	6c050513          	addi	a0,a0,1728 # 2dc6c0 <__stack_size+0x2db6c0>
f9000618:	b71ff0ef          	jal	ra,f9000188 <clint_uDelay>
		CntMonitor();
f900061c:	d79ff0ef          	jal	ra,f9000394 <CntMonitor>
f9000620:	fe5ff06f          	j	f9000604 <StartRunning+0x60>

f9000624 <main>:


////////////////////////////////////////////////////////////////////////////////
void main() {
f9000624:	ff010113          	addi	sp,sp,-16
f9000628:	00112623          	sw	ra,12(sp)
    u32 prompt=0;
    u32 speed;

    bsp_init();
    bsp_print("tse demo !");
f900062c:	f9001537          	lui	a0,0xf9001
f9000630:	f3050513          	addi	a0,a0,-208 # f9000f30 <__freertos_irq_stack_top+0xffffeea0>
f9000634:	bf9ff0ef          	jal	ra,f900022c <bsp_print>
	#ifdef PHY8211
    rtl8211_drv_init();
f9000638:	2a8000ef          	jal	ra,f90008e0 <rtl8211_drv_init>
    bsp_print("Waiting Link Up...");
f900063c:	f9001537          	lui	a0,0xf9001
f9000640:	f3c50513          	addi	a0,a0,-196 # f9000f3c <__freertos_irq_stack_top+0xffffeeac>
f9000644:	be9ff0ef          	jal	ra,f900022c <bsp_print>
    speed=rtl8211_drv_linkup();
f9000648:	17c000ef          	jal	ra,f90007c4 <rtl8211_drv_linkup>
	if(TEST_MODE == 1){
	    	PhyLoopInit(speed); // 4=1000Mbps, 2=100Mbps, 1=10Mbps, change the number to change speed
f900064c:	e35ff0ef          	jal	ra,f9000480 <PhyLoopInit>
			MacAddrSet(1,1);
f9000650:	00100593          	li	a1,1
f9000654:	00100513          	li	a0,1
f9000658:	c6dff0ef          	jal	ra,f90002c4 <MacAddrSet>
			MacIpgSet(0x0C);
f900065c:	00c00513          	li	a0,12
f9000660:	c39ff0ef          	jal	ra,f9000298 <MacIpgSet>
	    	PhyLoopInit(2); // 4=1000Mbps, 2=100Mbps, 1=10Mbps, change the number to change speed
	    }
	#endif
	

    StartRunning();
f9000664:	f41ff0ef          	jal	ra,f90005a4 <StartRunning>

f9000668 <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
f9000668:	000f47b7          	lui	a5,0xf4
f900066c:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf3240>
f9000670:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f9000674:	0000c7b7          	lui	a5,0xc
f9000678:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0xaff8>
f900067c:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f9000680:	00062783          	lw	a5,0(a2) # f8b00000 <__freertos_irq_stack_top+0xffafdf70>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f9000684:	02a58533          	mul	a0,a1,a0
f9000688:	00f50533          	add	a0,a0,a5
f900068c:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f9000690:	40f507b3          	sub	a5,a0,a5
f9000694:	fe07dce3          	bgez	a5,f900068c <clint_uDelay+0x24>
    }
f9000698:	00008067          	ret

f900069c <Phy_Rd>:
//#include "mac.h"
#include "tseDemo.h"
#include "compatibility.h"

u32 Phy_Rd(u32 RegAddr)
{
f900069c:	ff010113          	addi	sp,sp,-16
f90006a0:	00112623          	sw	ra,12(sp)
f90006a4:	00812423          	sw	s0,8(sp)
    u32 Value;
    Reg_Out32((TSEMAC_CSR+0x108), ((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f));
f90006a8:	01f57593          	andi	a1,a0,31
f90006ac:	7005e593          	ori	a1,a1,1792
f90006b0:	f8100437          	lui	s0,0xf8100
f90006b4:	10840513          	addi	a0,s0,264 # f8100108 <__freertos_irq_stack_top+0xff0fe078>
f90006b8:	320000ef          	jal	ra,f90009d8 <Reg_Out32>
    Reg_Out32((TSEMAC_CSR+0x104), 0x1);
f90006bc:	00100593          	li	a1,1
f90006c0:	10440513          	addi	a0,s0,260
f90006c4:	314000ef          	jal	ra,f90009d8 <Reg_Out32>
    bsp_uDelay(1000);
f90006c8:	f8b00637          	lui	a2,0xf8b00
f90006cc:	02faf5b7          	lui	a1,0x2faf
f90006d0:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90006d4:	3e800513          	li	a0,1000
f90006d8:	f91ff0ef          	jal	ra,f9000668 <clint_uDelay>
    Value = Reg_In32(TSEMAC_CSR+0x110);
f90006dc:	11040513          	addi	a0,s0,272
f90006e0:	300000ef          	jal	ra,f90009e0 <Reg_In32>

    return Value;
}
f90006e4:	00c12083          	lw	ra,12(sp)
f90006e8:	00812403          	lw	s0,8(sp)
f90006ec:	01010113          	addi	sp,sp,16
f90006f0:	00008067          	ret

f90006f4 <Phy_Wr>:
void Phy_Wr(u32 RegAddr,u32 Data)
{
f90006f4:	ff010113          	addi	sp,sp,-16
f90006f8:	00112623          	sw	ra,12(sp)
f90006fc:	00812423          	sw	s0,8(sp)
f9000700:	00912223          	sw	s1,4(sp)
f9000704:	00058493          	mv	s1,a1
    Reg_Out32((TSEMAC_CSR+0x108), ((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f));
f9000708:	01f57593          	andi	a1,a0,31
f900070c:	7005e593          	ori	a1,a1,1792
f9000710:	f8100437          	lui	s0,0xf8100
f9000714:	10840513          	addi	a0,s0,264 # f8100108 <__freertos_irq_stack_top+0xff0fe078>
f9000718:	2c0000ef          	jal	ra,f90009d8 <Reg_Out32>
    Reg_Out32((TSEMAC_CSR+0x10c), Data);
f900071c:	00048593          	mv	a1,s1
f9000720:	10c40513          	addi	a0,s0,268
f9000724:	2b4000ef          	jal	ra,f90009d8 <Reg_Out32>
    Reg_Out32((TSEMAC_CSR+0x104), 0x2);
f9000728:	00200593          	li	a1,2
f900072c:	10440513          	addi	a0,s0,260
f9000730:	2a8000ef          	jal	ra,f90009d8 <Reg_Out32>
}
f9000734:	00c12083          	lw	ra,12(sp)
f9000738:	00812403          	lw	s0,8(sp)
f900073c:	00412483          	lw	s1,4(sp)
f9000740:	01010113          	addi	sp,sp,16
f9000744:	00008067          	ret

f9000748 <rtl8211_drv_rddata>:

int rtl8211_drv_rddata(int addr)
{
f9000748:	ff010113          	addi	sp,sp,-16
f900074c:	00112623          	sw	ra,12(sp)
	 return Phy_Rd(addr);
f9000750:	f4dff0ef          	jal	ra,f900069c <Phy_Rd>
}
f9000754:	00c12083          	lw	ra,12(sp)
f9000758:	01010113          	addi	sp,sp,16
f900075c:	00008067          	ret

f9000760 <rtl8211_drv_wrdata>:

void rtl8211_drv_wrdata(int addr ,int data)
{
f9000760:	ff010113          	addi	sp,sp,-16
f9000764:	00112623          	sw	ra,12(sp)
	 Phy_Wr(addr,data);
f9000768:	f8dff0ef          	jal	ra,f90006f4 <Phy_Wr>
	 bsp_uDelay(100);
f900076c:	f8b00637          	lui	a2,0xf8b00
f9000770:	02faf5b7          	lui	a1,0x2faf
f9000774:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000778:	06400513          	li	a0,100
f900077c:	eedff0ef          	jal	ra,f9000668 <clint_uDelay>
}
f9000780:	00c12083          	lw	ra,12(sp)
f9000784:	01010113          	addi	sp,sp,16
f9000788:	00008067          	ret

f900078c <rtl8211_drv_setpage>:

void rtl8211_drv_setpage(int page)
{
f900078c:	ff010113          	addi	sp,sp,-16
f9000790:	00112623          	sw	ra,12(sp)
	 Phy_Wr(31,page & 0xFFFF);
f9000794:	01051593          	slli	a1,a0,0x10
f9000798:	0105d593          	srli	a1,a1,0x10
f900079c:	01f00513          	li	a0,31
f90007a0:	f55ff0ef          	jal	ra,f90006f4 <Phy_Wr>
	 bsp_uDelay(100);
f90007a4:	f8b00637          	lui	a2,0xf8b00
f90007a8:	02faf5b7          	lui	a1,0x2faf
f90007ac:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90007b0:	06400513          	li	a0,100
f90007b4:	eb5ff0ef          	jal	ra,f9000668 <clint_uDelay>
}
f90007b8:	00c12083          	lw	ra,12(sp)
f90007bc:	01010113          	addi	sp,sp,16
f90007c0:	00008067          	ret

f90007c4 <rtl8211_drv_linkup>:

int rtl8211_drv_linkup(void)
{
f90007c4:	ff010113          	addi	sp,sp,-16
f90007c8:	00112623          	sw	ra,12(sp)
f90007cc:	00812423          	sw	s0,8(sp)
	int phy_reg=0;
	int speed=Speed_100Mhz;//i change from Speed_1000Mhz

	 while(1)
	{
		phy_reg=rtl8211_drv_rddata(26); //Phy_Rd(addr) addr = 26, this is just to read link status
f90007d0:	01a00513          	li	a0,26
f90007d4:	f75ff0ef          	jal	ra,f9000748 <rtl8211_drv_rddata>

		if(phy_reg & 0x04)
f90007d8:	00457793          	andi	a5,a0,4
f90007dc:	02079063          	bnez	a5,f90007fc <rtl8211_drv_linkup+0x38>
		{
			bsp_printf("Linked Up");
			break;
		}

		bsp_uDelay(10000);
f90007e0:	f8b00637          	lui	a2,0xf8b00
f90007e4:	02faf5b7          	lui	a1,0x2faf
f90007e8:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90007ec:	00002537          	lui	a0,0x2
f90007f0:	71050513          	addi	a0,a0,1808 # 2710 <__stack_size+0x1710>
f90007f4:	e75ff0ef          	jal	ra,f9000668 <clint_uDelay>
		phy_reg=rtl8211_drv_rddata(26); //Phy_Rd(addr) addr = 26, this is just to read link status
f90007f8:	fd9ff06f          	j	f90007d0 <rtl8211_drv_linkup+0xc>
f90007fc:	00050413          	mv	s0,a0
			bsp_printf("Linked Up");
f9000800:	f9001537          	lui	a0,0xf9001
f9000804:	f5050513          	addi	a0,a0,-176 # f9000f50 <__freertos_irq_stack_top+0xffffeec0>
f9000808:	3cc000ef          	jal	ra,f9000bd4 <bsp_printf>
	}

	if((phy_reg & 0x30) == 0x20)//check bit 4&5 for speed 1000Mbps, and maybeeeeeeee linked partner mode
f900080c:	03047793          	andi	a5,s0,48
f9000810:	02000713          	li	a4,32
f9000814:	02e78863          	beq	a5,a4,f9000844 <rtl8211_drv_linkup+0x80>
			bsp_printf("Link Partner Full duplex 1000 Mbps Reg26 0x%x",phy_reg);
		else
			bsp_printf("Link Partner half duplex 1000 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_1000Mhz;
	}
	else if((phy_reg & 0x30) == 0x10)
f9000818:	01000713          	li	a4,16
f900081c:	06e78663          	beq	a5,a4,f9000888 <rtl8211_drv_linkup+0xc4>
			bsp_printf("Link Partner Full duplex 100 Mbps Reg26 0x%x",phy_reg);
		else
			bsp_printf("Link Partner half duplex 100 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_100Mhz;
	}
	else if((phy_reg & 0x30) == 0)
f9000820:	0a079c63          	bnez	a5,f90008d8 <rtl8211_drv_linkup+0x114>
	{
		if(phy_reg & 0x08)
f9000824:	00847793          	andi	a5,s0,8
f9000828:	08078c63          	beqz	a5,f90008c0 <rtl8211_drv_linkup+0xfc>
			bsp_printf("Link Partner Full duplex 10 Mbps Reg26 0x%x",phy_reg);
f900082c:	00040593          	mv	a1,s0
f9000830:	f9001537          	lui	a0,0xf9001
f9000834:	01c50513          	addi	a0,a0,28 # f900101c <__freertos_irq_stack_top+0xffffef8c>
f9000838:	39c000ef          	jal	ra,f9000bd4 <bsp_printf>
		else
			bsp_printf("Link Partner half duplex 10 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_10Mhz;
f900083c:	00100513          	li	a0,1
f9000840:	0200006f          	j	f9000860 <rtl8211_drv_linkup+0x9c>
		if(phy_reg & 0x08)//check if full duplex
f9000844:	00847793          	andi	a5,s0,8
f9000848:	02078463          	beqz	a5,f9000870 <rtl8211_drv_linkup+0xac>
			bsp_printf("Link Partner Full duplex 1000 Mbps Reg26 0x%x",phy_reg);
f900084c:	00040593          	mv	a1,s0
f9000850:	f9001537          	lui	a0,0xf9001
f9000854:	f5c50513          	addi	a0,a0,-164 # f9000f5c <__freertos_irq_stack_top+0xffffeecc>
f9000858:	37c000ef          	jal	ra,f9000bd4 <bsp_printf>
		speed = Speed_1000Mhz;
f900085c:	00400513          	li	a0,4
	}

	return speed;
}
f9000860:	00c12083          	lw	ra,12(sp)
f9000864:	00812403          	lw	s0,8(sp)
f9000868:	01010113          	addi	sp,sp,16
f900086c:	00008067          	ret
			bsp_printf("Link Partner half duplex 1000 Mbps Reg26 0x%x",phy_reg);
f9000870:	00040593          	mv	a1,s0
f9000874:	f9001537          	lui	a0,0xf9001
f9000878:	f8c50513          	addi	a0,a0,-116 # f9000f8c <__freertos_irq_stack_top+0xffffeefc>
f900087c:	358000ef          	jal	ra,f9000bd4 <bsp_printf>
		speed = Speed_1000Mhz;
f9000880:	00400513          	li	a0,4
f9000884:	fddff06f          	j	f9000860 <rtl8211_drv_linkup+0x9c>
		if(phy_reg & 0x08)
f9000888:	00847793          	andi	a5,s0,8
f900088c:	00078e63          	beqz	a5,f90008a8 <rtl8211_drv_linkup+0xe4>
			bsp_printf("Link Partner Full duplex 100 Mbps Reg26 0x%x",phy_reg);
f9000890:	00040593          	mv	a1,s0
f9000894:	f9001537          	lui	a0,0xf9001
f9000898:	fbc50513          	addi	a0,a0,-68 # f9000fbc <__freertos_irq_stack_top+0xffffef2c>
f900089c:	338000ef          	jal	ra,f9000bd4 <bsp_printf>
		speed = Speed_100Mhz;
f90008a0:	00200513          	li	a0,2
f90008a4:	fbdff06f          	j	f9000860 <rtl8211_drv_linkup+0x9c>
			bsp_printf("Link Partner half duplex 100 Mbps Reg26 0x%x",phy_reg);
f90008a8:	00040593          	mv	a1,s0
f90008ac:	f9001537          	lui	a0,0xf9001
f90008b0:	fec50513          	addi	a0,a0,-20 # f9000fec <__freertos_irq_stack_top+0xffffef5c>
f90008b4:	320000ef          	jal	ra,f9000bd4 <bsp_printf>
		speed = Speed_100Mhz;
f90008b8:	00200513          	li	a0,2
f90008bc:	fa5ff06f          	j	f9000860 <rtl8211_drv_linkup+0x9c>
			bsp_printf("Link Partner half duplex 10 Mbps Reg26 0x%x",phy_reg);
f90008c0:	00040593          	mv	a1,s0
f90008c4:	f9001537          	lui	a0,0xf9001
f90008c8:	04850513          	addi	a0,a0,72 # f9001048 <__freertos_irq_stack_top+0xffffefb8>
f90008cc:	308000ef          	jal	ra,f9000bd4 <bsp_printf>
		speed = Speed_10Mhz;
f90008d0:	00100513          	li	a0,1
f90008d4:	f8dff06f          	j	f9000860 <rtl8211_drv_linkup+0x9c>
	int speed=Speed_100Mhz;//i change from Speed_1000Mhz
f90008d8:	00200513          	li	a0,2
	return speed;
f90008dc:	f85ff06f          	j	f9000860 <rtl8211_drv_linkup+0x9c>

f90008e0 <rtl8211_drv_init>:

void rtl8211_drv_init(void)
{
f90008e0:	ff010113          	addi	sp,sp,-16
f90008e4:	00112623          	sw	ra,12(sp)
f90008e8:	00812423          	sw	s0,8(sp)
f90008ec:	00912223          	sw	s1,4(sp)
	rtl8211_drv_setpage(0);//Phy_Wr(31,page & 0xFFFF);
f90008f0:	00000513          	li	a0,0
f90008f4:	e99ff0ef          	jal	ra,f900078c <rtl8211_drv_setpage>
	rtl8211_drv_wrdata(0,0x9000);//Phy_Wr(addr,data); here eneble auto negotiation and make a phyreset
f90008f8:	000095b7          	lui	a1,0x9
f90008fc:	00000513          	li	a0,0
f9000900:	e61ff0ef          	jal	ra,f9000760 <rtl8211_drv_wrdata>
	bsp_uDelay(1000*50);
f9000904:	f8b00637          	lui	a2,0xf8b00
f9000908:	02faf4b7          	lui	s1,0x2faf
f900090c:	08048593          	addi	a1,s1,128 # 2faf080 <__stack_size+0x2fae080>
f9000910:	0000c437          	lui	s0,0xc
f9000914:	35040513          	addi	a0,s0,848 # c350 <__stack_size+0xb350>
f9000918:	d51ff0ef          	jal	ra,f9000668 <clint_uDelay>
	rtl8211_drv_wrdata(0,0x1000);//auto negotiate again just to make sure
f900091c:	000015b7          	lui	a1,0x1
f9000920:	00000513          	li	a0,0
f9000924:	e3dff0ef          	jal	ra,f9000760 <rtl8211_drv_wrdata>
	bsp_uDelay(1000*50);
f9000928:	f8b00637          	lui	a2,0xf8b00
f900092c:	08048593          	addi	a1,s1,128
f9000930:	35040513          	addi	a0,s0,848
f9000934:	d35ff0ef          	jal	ra,f9000668 <clint_uDelay>

	rtl8211_drv_setpage(0x0A43);
f9000938:	000014b7          	lui	s1,0x1
f900093c:	a4348513          	addi	a0,s1,-1469 # a43 <CUSTOM1+0xa18>
f9000940:	e4dff0ef          	jal	ra,f900078c <rtl8211_drv_setpage>
	rtl8211_drv_wrdata(27,0x8011);//reserved register
f9000944:	00008437          	lui	s0,0x8
f9000948:	01140593          	addi	a1,s0,17 # 8011 <__stack_size+0x7011>
f900094c:	01b00513          	li	a0,27
f9000950:	e11ff0ef          	jal	ra,f9000760 <rtl8211_drv_wrdata>
	rtl8211_drv_wrdata(28,0xD73F);//reserved register
f9000954:	0000d5b7          	lui	a1,0xd
f9000958:	73f58593          	addi	a1,a1,1855 # d73f <__stack_size+0xc73f>
f900095c:	01c00513          	li	a0,28
f9000960:	e01ff0ef          	jal	ra,f9000760 <rtl8211_drv_wrdata>

	rtl8211_drv_setpage(0xD04);
f9000964:	d0448513          	addi	a0,s1,-764
f9000968:	e25ff0ef          	jal	ra,f900078c <rtl8211_drv_setpage>
	rtl8211_drv_wrdata(0x10,0x820B);//reserved register
f900096c:	20b40593          	addi	a1,s0,523
f9000970:	01000513          	li	a0,16
f9000974:	dedff0ef          	jal	ra,f9000760 <rtl8211_drv_wrdata>
}
f9000978:	00c12083          	lw	ra,12(sp)
f900097c:	00812403          	lw	s0,8(sp)
f9000980:	00412483          	lw	s1,4(sp)
f9000984:	01010113          	addi	sp,sp,16
f9000988:	00008067          	ret

f900098c <uart_writeAvailability>:
f900098c:	00452503          	lw	a0,4(a0)
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
f9000990:	01055513          	srli	a0,a0,0x10
    }
f9000994:	0ff57513          	andi	a0,a0,255
f9000998:	00008067          	ret

f900099c <uart_write>:
    static void uart_write(u32 reg, char data){
f900099c:	ff010113          	addi	sp,sp,-16
f90009a0:	00112623          	sw	ra,12(sp)
f90009a4:	00812423          	sw	s0,8(sp)
f90009a8:	00912223          	sw	s1,4(sp)
f90009ac:	00050413          	mv	s0,a0
f90009b0:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
f90009b4:	00040513          	mv	a0,s0
f90009b8:	fd5ff0ef          	jal	ra,f900098c <uart_writeAvailability>
f90009bc:	fe050ce3          	beqz	a0,f90009b4 <uart_write+0x18>
        *((volatile u32*) address) = data;
f90009c0:	00942023          	sw	s1,0(s0)
    }
f90009c4:	00c12083          	lw	ra,12(sp)
f90009c8:	00812403          	lw	s0,8(sp)
f90009cc:	00412483          	lw	s1,4(sp)
f90009d0:	01010113          	addi	sp,sp,16
f90009d4:	00008067          	ret

f90009d8 <Reg_Out32>:
f90009d8:	00b52023          	sw	a1,0(a0)

/************************** Function File ***************************/
void Reg_Out32(u32 addr,u32 data)
{
    write_u32(data,addr);
}
f90009dc:	00008067          	ret

f90009e0 <Reg_In32>:
        return *((volatile u32*) address);
f90009e0:	00052503          	lw	a0,0(a0)

u32 Reg_In32(u32 addr)
{
    return read_u32(addr);
}
f90009e4:	00008067          	ret

f90009e8 <putchar>:
  }
  putchar('\n');
  return 0;
}

int putchar(int c){
f90009e8:	ff010113          	addi	sp,sp,-16
f90009ec:	00112623          	sw	ra,12(sp)
f90009f0:	00812423          	sw	s0,8(sp)
f90009f4:	00050413          	mv	s0,a0
    bsp_putChar(c);
f90009f8:	0ff57593          	andi	a1,a0,255
f90009fc:	f8010537          	lui	a0,0xf8010
f9000a00:	f9dff0ef          	jal	ra,f900099c <uart_write>
    return c;
}
f9000a04:	00040513          	mv	a0,s0
f9000a08:	00c12083          	lw	ra,12(sp)
f9000a0c:	00812403          	lw	s0,8(sp)
f9000a10:	01010113          	addi	sp,sp,16
f9000a14:	00008067          	ret

f9000a18 <bsp_printf_c>:
{
f9000a18:	ff010113          	addi	sp,sp,-16
f9000a1c:	00112623          	sw	ra,12(sp)
    putchar(c);
f9000a20:	fc9ff0ef          	jal	ra,f90009e8 <putchar>
}
f9000a24:	00c12083          	lw	ra,12(sp)
f9000a28:	01010113          	addi	sp,sp,16
f9000a2c:	00008067          	ret

f9000a30 <bsp_printf_d>:
{
f9000a30:	fd010113          	addi	sp,sp,-48
f9000a34:	02112623          	sw	ra,44(sp)
f9000a38:	02812423          	sw	s0,40(sp)
f9000a3c:	02912223          	sw	s1,36(sp)
f9000a40:	00050493          	mv	s1,a0
    if (val < 0) {
f9000a44:	00054663          	bltz	a0,f9000a50 <bsp_printf_d+0x20>
{
f9000a48:	00010413          	mv	s0,sp
f9000a4c:	02c0006f          	j	f9000a78 <bsp_printf_d+0x48>
        bsp_printf_c('-');
f9000a50:	02d00513          	li	a0,45
f9000a54:	fc5ff0ef          	jal	ra,f9000a18 <bsp_printf_c>
        val = -val;
f9000a58:	409004b3          	neg	s1,s1
f9000a5c:	fedff06f          	j	f9000a48 <bsp_printf_d+0x18>
        *(p++) = '0' + val % 10;
f9000a60:	00a00713          	li	a4,10
f9000a64:	02e4e7b3          	rem	a5,s1,a4
f9000a68:	03078793          	addi	a5,a5,48
f9000a6c:	00f40023          	sb	a5,0(s0)
        val = val / 10;
f9000a70:	02e4c4b3          	div	s1,s1,a4
        *(p++) = '0' + val % 10;
f9000a74:	00140413          	addi	s0,s0,1
    while (val || p == buffer) {
f9000a78:	fe0494e3          	bnez	s1,f9000a60 <bsp_printf_d+0x30>
f9000a7c:	00010793          	mv	a5,sp
f9000a80:	fef400e3          	beq	s0,a5,f9000a60 <bsp_printf_d+0x30>
f9000a84:	0100006f          	j	f9000a94 <bsp_printf_d+0x64>
        bsp_printf_c(*(--p));
f9000a88:	fff40413          	addi	s0,s0,-1
f9000a8c:	00044503          	lbu	a0,0(s0)
f9000a90:	f89ff0ef          	jal	ra,f9000a18 <bsp_printf_c>
    while (p != buffer)
f9000a94:	00010793          	mv	a5,sp
f9000a98:	fef418e3          	bne	s0,a5,f9000a88 <bsp_printf_d+0x58>
}
f9000a9c:	02c12083          	lw	ra,44(sp)
f9000aa0:	02812403          	lw	s0,40(sp)
f9000aa4:	02412483          	lw	s1,36(sp)
f9000aa8:	03010113          	addi	sp,sp,48
f9000aac:	00008067          	ret

f9000ab0 <bsp_printf_s>:
{
f9000ab0:	ff010113          	addi	sp,sp,-16
f9000ab4:	00112623          	sw	ra,12(sp)
f9000ab8:	00812423          	sw	s0,8(sp)
f9000abc:	00050413          	mv	s0,a0
    while (*p)
f9000ac0:	00044503          	lbu	a0,0(s0)
f9000ac4:	00050863          	beqz	a0,f9000ad4 <bsp_printf_s+0x24>
        putchar(*(p++));
f9000ac8:	00140413          	addi	s0,s0,1
f9000acc:	f1dff0ef          	jal	ra,f90009e8 <putchar>
f9000ad0:	ff1ff06f          	j	f9000ac0 <bsp_printf_s+0x10>
}
f9000ad4:	00c12083          	lw	ra,12(sp)
f9000ad8:	00812403          	lw	s0,8(sp)
f9000adc:	01010113          	addi	sp,sp,16
f9000ae0:	00008067          	ret

f9000ae4 <bsp_puts>:
int bsp_puts(char *s){
f9000ae4:	ff010113          	addi	sp,sp,-16
f9000ae8:	00112623          	sw	ra,12(sp)
f9000aec:	00812423          	sw	s0,8(sp)
f9000af0:	00050413          	mv	s0,a0
  while (*s) {
f9000af4:	00044503          	lbu	a0,0(s0)
f9000af8:	00050863          	beqz	a0,f9000b08 <bsp_puts+0x24>
    putchar(*s);
f9000afc:	eedff0ef          	jal	ra,f90009e8 <putchar>
    s++;
f9000b00:	00140413          	addi	s0,s0,1
f9000b04:	ff1ff06f          	j	f9000af4 <bsp_puts+0x10>
  putchar('\n');
f9000b08:	00a00513          	li	a0,10
f9000b0c:	eddff0ef          	jal	ra,f90009e8 <putchar>
}
f9000b10:	00000513          	li	a0,0
f9000b14:	00c12083          	lw	ra,12(sp)
f9000b18:	00812403          	lw	s0,8(sp)
f9000b1c:	01010113          	addi	sp,sp,16
f9000b20:	00008067          	ret

f9000b24 <print_hex>:

void print_hex(uint32_t val, uint32_t digits)
{
f9000b24:	ff010113          	addi	sp,sp,-16
f9000b28:	00112623          	sw	ra,12(sp)
f9000b2c:	00812423          	sw	s0,8(sp)
f9000b30:	00912223          	sw	s1,4(sp)
f9000b34:	00050493          	mv	s1,a0
	for (int i = (4*digits)-4; i >= 0; i -= 4)
f9000b38:	40000437          	lui	s0,0x40000
f9000b3c:	fff40413          	addi	s0,s0,-1 # 3fffffff <__stack_size+0x3fffefff>
f9000b40:	00858433          	add	s0,a1,s0
f9000b44:	00241413          	slli	s0,s0,0x2
f9000b48:	02044663          	bltz	s0,f9000b74 <print_hex+0x50>
		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
f9000b4c:	0084d7b3          	srl	a5,s1,s0
f9000b50:	00f7f713          	andi	a4,a5,15
f9000b54:	f90017b7          	lui	a5,0xf9001
f9000b58:	ce478793          	addi	a5,a5,-796 # f9000ce4 <__freertos_irq_stack_top+0xffffec54>
f9000b5c:	00e787b3          	add	a5,a5,a4
f9000b60:	0007c583          	lbu	a1,0(a5)
f9000b64:	f8010537          	lui	a0,0xf8010
f9000b68:	e35ff0ef          	jal	ra,f900099c <uart_write>
	for (int i = (4*digits)-4; i >= 0; i -= 4)
f9000b6c:	ffc40413          	addi	s0,s0,-4
f9000b70:	fd9ff06f          	j	f9000b48 <print_hex+0x24>
}
f9000b74:	00c12083          	lw	ra,12(sp)
f9000b78:	00812403          	lw	s0,8(sp)
f9000b7c:	00412483          	lw	s1,4(sp)
f9000b80:	01010113          	addi	sp,sp,16
f9000b84:	00008067          	ret

f9000b88 <bsp_printf_x>:
{
f9000b88:	ff010113          	addi	sp,sp,-16
f9000b8c:	00112623          	sw	ra,12(sp)
	for(i=0;i<8;i++)
f9000b90:	00000593          	li	a1,0
f9000b94:	00700793          	li	a5,7
f9000b98:	02b7c463          	blt	a5,a1,f9000bc0 <bsp_printf_x+0x38>
		if((val & (0xFFFFFFF0 <<(4*i))) == 0)
f9000b9c:	00259713          	slli	a4,a1,0x2
f9000ba0:	ff000793          	li	a5,-16
f9000ba4:	00e797b3          	sll	a5,a5,a4
f9000ba8:	00f577b3          	and	a5,a0,a5
f9000bac:	00078663          	beqz	a5,f9000bb8 <bsp_printf_x+0x30>
	for(i=0;i<8;i++)
f9000bb0:	00158593          	addi	a1,a1,1
f9000bb4:	fe1ff06f          	j	f9000b94 <bsp_printf_x+0xc>
			digi=i+1;
f9000bb8:	00158593          	addi	a1,a1,1
			break;
f9000bbc:	0080006f          	j	f9000bc4 <bsp_printf_x+0x3c>
	int i,digi=2;
f9000bc0:	00200593          	li	a1,2
	print_hex(val,digi);
f9000bc4:	f61ff0ef          	jal	ra,f9000b24 <print_hex>
}
f9000bc8:	00c12083          	lw	ra,12(sp)
f9000bcc:	01010113          	addi	sp,sp,16
f9000bd0:	00008067          	ret

f9000bd4 <bsp_printf>:
{
f9000bd4:	fc010113          	addi	sp,sp,-64
f9000bd8:	00112e23          	sw	ra,28(sp)
f9000bdc:	00812c23          	sw	s0,24(sp)
f9000be0:	00912a23          	sw	s1,20(sp)
f9000be4:	00050493          	mv	s1,a0
f9000be8:	02b12223          	sw	a1,36(sp)
f9000bec:	02c12423          	sw	a2,40(sp)
f9000bf0:	02d12623          	sw	a3,44(sp)
f9000bf4:	02e12823          	sw	a4,48(sp)
f9000bf8:	02f12a23          	sw	a5,52(sp)
f9000bfc:	03012c23          	sw	a6,56(sp)
f9000c00:	03112e23          	sw	a7,60(sp)
    va_start(ap, format);
f9000c04:	02410793          	addi	a5,sp,36
f9000c08:	00f12623          	sw	a5,12(sp)
    for (i = 0; format[i]; i++)
f9000c0c:	00000413          	li	s0,0
f9000c10:	01c0006f          	j	f9000c2c <bsp_printf+0x58>
                    bsp_printf_c(va_arg(ap,int));
f9000c14:	00c12783          	lw	a5,12(sp)
f9000c18:	00478713          	addi	a4,a5,4
f9000c1c:	00e12623          	sw	a4,12(sp)
f9000c20:	0007a503          	lw	a0,0(a5)
f9000c24:	df5ff0ef          	jal	ra,f9000a18 <bsp_printf_c>
    for (i = 0; format[i]; i++)
f9000c28:	00140413          	addi	s0,s0,1
f9000c2c:	008487b3          	add	a5,s1,s0
f9000c30:	0007c503          	lbu	a0,0(a5)
f9000c34:	08050663          	beqz	a0,f9000cc0 <bsp_printf+0xec>
        if (format[i] == '%') {
f9000c38:	02500793          	li	a5,37
f9000c3c:	02f50e63          	beq	a0,a5,f9000c78 <bsp_printf+0xa4>
            bsp_printf_c(format[i]);
f9000c40:	dd9ff0ef          	jal	ra,f9000a18 <bsp_printf_c>
f9000c44:	fe5ff06f          	j	f9000c28 <bsp_printf+0x54>
                    bsp_printf_s(va_arg(ap,char*));
f9000c48:	00c12783          	lw	a5,12(sp)
f9000c4c:	00478713          	addi	a4,a5,4
f9000c50:	00e12623          	sw	a4,12(sp)
f9000c54:	0007a503          	lw	a0,0(a5)
f9000c58:	e59ff0ef          	jal	ra,f9000ab0 <bsp_printf_s>
                    break;
f9000c5c:	fcdff06f          	j	f9000c28 <bsp_printf+0x54>
                    bsp_printf_d(va_arg(ap,int));
f9000c60:	00c12783          	lw	a5,12(sp)
f9000c64:	00478713          	addi	a4,a5,4
f9000c68:	00e12623          	sw	a4,12(sp)
f9000c6c:	0007a503          	lw	a0,0(a5)
f9000c70:	dc1ff0ef          	jal	ra,f9000a30 <bsp_printf_d>
                    break;
f9000c74:	fb5ff06f          	j	f9000c28 <bsp_printf+0x54>
            while (format[++i]) {
f9000c78:	00140413          	addi	s0,s0,1
f9000c7c:	008487b3          	add	a5,s1,s0
f9000c80:	0007c783          	lbu	a5,0(a5)
f9000c84:	fa0782e3          	beqz	a5,f9000c28 <bsp_printf+0x54>
                if (format[i] == 'c') {
f9000c88:	06300713          	li	a4,99
f9000c8c:	f8e784e3          	beq	a5,a4,f9000c14 <bsp_printf+0x40>
                if (format[i] == 's') {
f9000c90:	07300713          	li	a4,115
f9000c94:	fae78ae3          	beq	a5,a4,f9000c48 <bsp_printf+0x74>
                if (format[i] == 'd') {
f9000c98:	06400713          	li	a4,100
f9000c9c:	fce782e3          	beq	a5,a4,f9000c60 <bsp_printf+0x8c>
                if (format[i] == 'x') {
f9000ca0:	07800713          	li	a4,120
f9000ca4:	fce79ae3          	bne	a5,a4,f9000c78 <bsp_printf+0xa4>
					bsp_printf_x(va_arg(ap,int));
f9000ca8:	00c12783          	lw	a5,12(sp)
f9000cac:	00478713          	addi	a4,a5,4
f9000cb0:	00e12623          	sw	a4,12(sp)
f9000cb4:	0007a503          	lw	a0,0(a5)
f9000cb8:	ed1ff0ef          	jal	ra,f9000b88 <bsp_printf_x>
					break;
f9000cbc:	f6dff06f          	j	f9000c28 <bsp_printf+0x54>
    putchar('\n');
f9000cc0:	00a00513          	li	a0,10
f9000cc4:	d25ff0ef          	jal	ra,f90009e8 <putchar>
    putchar('\r');
f9000cc8:	00d00513          	li	a0,13
f9000ccc:	d1dff0ef          	jal	ra,f90009e8 <putchar>
}
f9000cd0:	01c12083          	lw	ra,28(sp)
f9000cd4:	01812403          	lw	s0,24(sp)
f9000cd8:	01412483          	lw	s1,20(sp)
f9000cdc:	04010113          	addi	sp,sp,64
f9000ce0:	00008067          	ret
