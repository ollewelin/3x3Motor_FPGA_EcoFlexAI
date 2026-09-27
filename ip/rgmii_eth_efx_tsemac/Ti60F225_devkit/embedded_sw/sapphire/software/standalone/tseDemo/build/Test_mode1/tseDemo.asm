
build/tseDemo.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00001197          	auipc	gp,0x1
f9000004:	3b818193          	addi	gp,gp,952 # f90013b8 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	00002117          	auipc	sp,0x2
f900000c:	bd810113          	addi	sp,sp,-1064 # f9001be0 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f9000010:	00001517          	auipc	a0,0x1
f9000014:	8bc50513          	addi	a0,a0,-1860 # f90008cc <__init_array_end>
	la a1, _data
f9000018:	00001597          	auipc	a1,0x1
f900001c:	8b458593          	addi	a1,a1,-1868 # f90008cc <__init_array_end>
	la a2, _edata
f9000020:	81c18613          	addi	a2,gp,-2020 # f9000bd4 <__bss_start>
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
f900003c:	81c18513          	addi	a0,gp,-2020 # f9000bd4 <__bss_start>
	la a1, _end
f9000040:	82018593          	addi	a1,gp,-2016 # f9000bd8 <_end>
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
f9000058:	059000ef          	jal	ra,f90008b0 <main>

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
f9000074:	85c40413          	addi	s0,s0,-1956 # f90008cc <__init_array_end>
f9000078:	00001917          	auipc	s2,0x1
f900007c:	85490913          	addi	s2,s2,-1964 # f90008cc <__init_array_end>
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
f90000b0:	82040413          	addi	s0,s0,-2016 # f90008cc <__init_array_end>
f90000b4:	00001917          	auipc	s2,0x1
f90000b8:	81890913          	addi	s2,s2,-2024 # f90008cc <__init_array_end>
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
f90001e4:	8cc78793          	addi	a5,a5,-1844 # f90008cc <__freertos_irq_stack_top+0xffffecec>
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
f90002a4:	0086a783          	lw	a5,8(a3) # f8100008 <__freertos_irq_stack_top+0xff0fe428>
	u32 Value;
	//Set Mac Speed
	Value = read_u32(TSEMAC_CSR+0x008) & ETH_SPEED_MASK;
f90002a8:	fff90737          	lui	a4,0xfff90
f90002ac:	fff70713          	addi	a4,a4,-1 # fff8ffff <__freertos_irq_stack_top+0x6f8e41f>
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
f90002cc:	8e050513          	addi	a0,a0,-1824 # f90008e0 <__freertos_irq_stack_top+0xffffed00>
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
f90002f0:	04a7ae23          	sw	a0,92(a5) # f810005c <__freertos_irq_stack_top+0xff0fe47c>
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac IPG.");
f90002f4:	f9001537          	lui	a0,0xf9001
f90002f8:	8f850513          	addi	a0,a0,-1800 # f90008f8 <__freertos_irq_stack_top+0xffffed18>
f90002fc:	f31ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f9000300:	00c12083          	lw	ra,12(sp)
f9000304:	01010113          	addi	sp,sp,16
f9000308:	00008067          	ret

f900030c <MacAddrSet>:

/************************** Function File ***************************/
static void MacAddrSet(u32 dst_addr_ins, u32 src_addr_ins)
{
f900030c:	ff010113          	addi	sp,sp,-16
f9000310:	00112623          	sw	ra,12(sp)
f9000314:	f81007b7          	lui	a5,0xf8100
f9000318:	00010737          	lui	a4,0x10
f900031c:	fff70713          	addi	a4,a4,-1 # ffff <__stack_size+0xefff>
f9000320:	18e7a423          	sw	a4,392(a5) # f8100188 <__freertos_irq_stack_top+0xff0fe5a8>
f9000324:	fff00713          	li	a4,-1
f9000328:	18e7a223          	sw	a4,388(a5)
f900032c:	18a7a023          	sw	a0,384(a5)
f9000330:	0000f737          	lui	a4,0xf
f9000334:	ae870713          	addi	a4,a4,-1304 # eae8 <__stack_size+0xdae8>
f9000338:	00e7a823          	sw	a4,16(a5)
f900033c:	5e006737          	lui	a4,0x5e006
f9000340:	0c870713          	addi	a4,a4,200 # 5e0060c8 <__stack_size+0x5e0050c8>
f9000344:	00e7a623          	sw	a4,12(a5)
        return *((volatile u32*) address);
f9000348:	0087a703          	lw	a4,8(a5)
    //mac_addr[47:32]
	write_u32(SRC_MAC_H, (TSEMAC_CSR+0x010));
    //mac_addr[31:0]
	write_u32(SRC_MAC_L, (TSEMAC_CSR+0x00c));
	//src mac addr ins set
	Value = read_u32(TSEMAC_CSR+0x008) & TX_ADDR_INS_MASK;
f900034c:	bff77713          	andi	a4,a4,-1025
	Value |= (src_addr_ins&0x1)<<9;
f9000350:	00959593          	slli	a1,a1,0x9
f9000354:	2005f593          	andi	a1,a1,512
f9000358:	00e5e5b3          	or	a1,a1,a4
        *((volatile u32*) address) = data;
f900035c:	00b7a423          	sw	a1,8(a5)
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac Address.");
f9000360:	f9001537          	lui	a0,0xf9001
f9000364:	90c50513          	addi	a0,a0,-1780 # f900090c <__freertos_irq_stack_top+0xffffed2c>
f9000368:	ec5ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f900036c:	00c12083          	lw	ra,12(sp)
f9000370:	01010113          	addi	sp,sp,16
f9000374:	00008067          	ret

f9000378 <MacCntClean>:
	write_u32(Value, (TSEMAC_CSR+0x008));
}

/************************** Function File ***************************/
static void MacCntClean()
{
f9000378:	ff010113          	addi	sp,sp,-16
f900037c:	00112623          	sw	ra,12(sp)
f9000380:	00812423          	sw	s0,8(sp)
f9000384:	00912223          	sw	s1,4(sp)
        return *((volatile u32*) address);
f9000388:	f81004b7          	lui	s1,0xf8100
f900038c:	0084a403          	lw	s0,8(s1) # f8100008 <__freertos_irq_stack_top+0xff0fe428>
	u32 Value;
	//Set cnt_reset 1
	Value = read_u32(TSEMAC_CSR+0x008) & CNT_RST_MASK;
f9000390:	800007b7          	lui	a5,0x80000
f9000394:	fff7c713          	not	a4,a5
f9000398:	00e47433          	and	s0,s0,a4
	Value |= 0x80000000;
f900039c:	00f467b3          	or	a5,s0,a5
        *((volatile u32*) address) = data;
f90003a0:	00f4a423          	sw	a5,8(s1)
	write_u32(Value, (TSEMAC_CSR+0x008));
	bsp_uDelay(1);
f90003a4:	f8b00637          	lui	a2,0xf8b00
f90003a8:	02faf5b7          	lui	a1,0x2faf
f90003ac:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f90003b0:	00100513          	li	a0,1
f90003b4:	dd5ff0ef          	jal	ra,f9000188 <clint_uDelay>
f90003b8:	0084a423          	sw	s0,8(s1)
	//Set cnt_reset 0
	Value &= CNT_RST_MASK;
	Value |= 0x0;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
		bsp_print("Info : Mac Reset Statistics Counters.");
f90003bc:	f9001537          	lui	a0,0xf9001
f90003c0:	92450513          	addi	a0,a0,-1756 # f9000924 <__freertos_irq_stack_top+0xffffed44>
f90003c4:	e69ff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f90003c8:	00c12083          	lw	ra,12(sp)
f90003cc:	00812403          	lw	s0,8(sp)
f90003d0:	00412483          	lw	s1,4(sp)
f90003d4:	01010113          	addi	sp,sp,16
f90003d8:	00008067          	ret

f90003dc <CntMonitor>:

/************************** Function File ***************************/
static void CntMonitor()
{
f90003dc:	ff010113          	addi	sp,sp,-16
f90003e0:	00112623          	sw	ra,12(sp)
f90003e4:	00812423          	sw	s0,8(sp)
f90003e8:	00912223          	sw	s1,4(sp)
	bsp_print("--------------------");
f90003ec:	f90014b7          	lui	s1,0xf9001
f90003f0:	94c48513          	addi	a0,s1,-1716 # f900094c <__freertos_irq_stack_top+0xffffed6c>
f90003f4:	e39ff0ef          	jal	ra,f900022c <bsp_print>
        return *((volatile u32*) address);
f90003f8:	f8100437          	lui	s0,0xf8100
f90003fc:	06842583          	lw	a1,104(s0) # f8100068 <__freertos_irq_stack_top+0xff0fe488>
	bsp_printReg("aFramesTransmittedOK :"       , read_u32(TSEMAC_CSR+0x68));
f9000400:	f9001537          	lui	a0,0xf9001
f9000404:	96450513          	addi	a0,a0,-1692 # f9000964 <__freertos_irq_stack_top+0xffffed84>
f9000408:	e5dff0ef          	jal	ra,f9000264 <bsp_printReg>
f900040c:	06c42583          	lw	a1,108(s0)
	bsp_printReg("aFramesReceivedOK :"          , read_u32(TSEMAC_CSR+0x6c));
f9000410:	f9001537          	lui	a0,0xf9001
f9000414:	97c50513          	addi	a0,a0,-1668 # f900097c <__freertos_irq_stack_top+0xffffed9c>
f9000418:	e4dff0ef          	jal	ra,f9000264 <bsp_printReg>
f900041c:	08842583          	lw	a1,136(s0)
	bsp_printReg("ifInErrors :"                 , read_u32(TSEMAC_CSR+0x88));
f9000420:	f9001537          	lui	a0,0xf9001
f9000424:	99050513          	addi	a0,a0,-1648 # f9000990 <__freertos_irq_stack_top+0xffffedb0>
f9000428:	e3dff0ef          	jal	ra,f9000264 <bsp_printReg>
f900042c:	08c42583          	lw	a1,140(s0)
	bsp_printReg("ifOutErrors :"                , read_u32(TSEMAC_CSR+0x8c));
f9000430:	f9001537          	lui	a0,0xf9001
f9000434:	9a050513          	addi	a0,a0,-1632 # f90009a0 <__freertos_irq_stack_top+0xffffedc0>
f9000438:	e2dff0ef          	jal	ra,f9000264 <bsp_printReg>
f900043c:	0b442583          	lw	a1,180(s0)
	bsp_printReg("etherStatsPkts :"             , read_u32(TSEMAC_CSR+0xb4));
f9000440:	f9001537          	lui	a0,0xf9001
f9000444:	9b050513          	addi	a0,a0,-1616 # f90009b0 <__freertos_irq_stack_top+0xffffedd0>
f9000448:	e1dff0ef          	jal	ra,f9000264 <bsp_printReg>
f900044c:	0b842583          	lw	a1,184(s0)
	bsp_printReg("etherStatsUndersizePkts :"    , read_u32(TSEMAC_CSR+0xb8));
f9000450:	f9001537          	lui	a0,0xf9001
f9000454:	9c450513          	addi	a0,a0,-1596 # f90009c4 <__freertos_irq_stack_top+0xffffede4>
f9000458:	e0dff0ef          	jal	ra,f9000264 <bsp_printReg>
f900045c:	0bc42583          	lw	a1,188(s0)
	bsp_printReg("etherStatsOversizePkts :"     , read_u32(TSEMAC_CSR+0xbc));
f9000460:	f9001537          	lui	a0,0xf9001
f9000464:	9e050513          	addi	a0,a0,-1568 # f90009e0 <__freertos_irq_stack_top+0xffffee00>
f9000468:	dfdff0ef          	jal	ra,f9000264 <bsp_printReg>
f900046c:	09c42583          	lw	a1,156(s0)
	bsp_printReg("aRxFilterFramesErrors :"      , read_u32(TSEMAC_CSR+0x9c));
f9000470:	f9001537          	lui	a0,0xf9001
f9000474:	9fc50513          	addi	a0,a0,-1540 # f90009fc <__freertos_irq_stack_top+0xffffee1c>
f9000478:	dedff0ef          	jal	ra,f9000264 <bsp_printReg>
f900047c:	07042583          	lw	a1,112(s0)
	bsp_printReg("aFrameCheckSequenceErrors :"  , read_u32(TSEMAC_CSR+0x70));
f9000480:	f9001537          	lui	a0,0xf9001
f9000484:	a1450513          	addi	a0,a0,-1516 # f9000a14 <__freertos_irq_stack_top+0xffffee34>
f9000488:	dddff0ef          	jal	ra,f9000264 <bsp_printReg>
f900048c:	08042583          	lw	a1,128(s0)
	bsp_printReg("aTxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x80));
f9000490:	f9001537          	lui	a0,0xf9001
f9000494:	a3050513          	addi	a0,a0,-1488 # f9000a30 <__freertos_irq_stack_top+0xffffee50>
f9000498:	dcdff0ef          	jal	ra,f9000264 <bsp_printReg>
f900049c:	08442583          	lw	a1,132(s0)
	bsp_printReg("aRxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x84));
f90004a0:	f9001537          	lui	a0,0xf9001
f90004a4:	a4850513          	addi	a0,a0,-1464 # f9000a48 <__freertos_irq_stack_top+0xffffee68>
f90004a8:	dbdff0ef          	jal	ra,f9000264 <bsp_printReg>
	//bsp_printReg("MAC Destination Address H:"    , read_u32(TSEMAC_CSR+0x188));
	//bsp_printReg("MAC Destination Address L:"    , read_u32(TSEMAC_CSR+0x184));
	bsp_print("--------------------");
f90004ac:	94c48513          	addi	a0,s1,-1716
f90004b0:	d7dff0ef          	jal	ra,f900022c <bsp_print>
}
f90004b4:	00c12083          	lw	ra,12(sp)
f90004b8:	00812403          	lw	s0,8(sp)
f90004bc:	00412483          	lw	s1,4(sp)
f90004c0:	01010113          	addi	sp,sp,16
f90004c4:	00008067          	ret

f90004c8 <MacNormalInit>:

/************************** Function File ***************************/
static void MacNormalInit(u32 speed)
{
f90004c8:	ff010113          	addi	sp,sp,-16
f90004cc:	00112623          	sw	ra,12(sp)
	MacSpeedSet(speed);
f90004d0:	dc9ff0ef          	jal	ra,f9000298 <MacSpeedSet>
	MacIpgSet(0x0C);
f90004d4:	00c00513          	li	a0,12
f90004d8:	e09ff0ef          	jal	ra,f90002e0 <MacIpgSet>
}
f90004dc:	00c12083          	lw	ra,12(sp)
f90004e0:	01010113          	addi	sp,sp,16
f90004e4:	00008067          	ret

f90004e8 <Phy_Wr>:
#include "tseDemo.h"


/************************** Function File ***************************/
static void Phy_Wr(u32 RegAddr, u32 Data)
{
f90004e8:	ff010113          	addi	sp,sp,-16
f90004ec:	00112623          	sw	ra,12(sp)
f90004f0:	00812423          	sw	s0,8(sp)
f90004f4:	00058413          	mv	s0,a1
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_CSR+0x108));
f90004f8:	01f57713          	andi	a4,a0,31
f90004fc:	70076713          	ori	a4,a4,1792
        *((volatile u32*) address) = data;
f9000500:	f81007b7          	lui	a5,0xf8100
f9000504:	10e7a423          	sw	a4,264(a5) # f8100108 <__freertos_irq_stack_top+0xff0fe528>
f9000508:	10b7a623          	sw	a1,268(a5)
f900050c:	00200713          	li	a4,2
f9000510:	10e7a223          	sw	a4,260(a5)
    write_u32(Data, (TSEMAC_CSR+0x10c));
    write_u32(0x2, (TSEMAC_CSR+0x104));
    if(PRINTF_EN == 1) {
        bsp_printReg("Wr Phy Addr : ", RegAddr);
f9000514:	00050593          	mv	a1,a0
f9000518:	f9001537          	lui	a0,0xf9001
f900051c:	a6050513          	addi	a0,a0,-1440 # f9000a60 <__freertos_irq_stack_top+0xffffee80>
f9000520:	d45ff0ef          	jal	ra,f9000264 <bsp_printReg>
        bsp_printReg("Wr Phy Data : ", Data);
f9000524:	00040593          	mv	a1,s0
f9000528:	f9001537          	lui	a0,0xf9001
f900052c:	a7050513          	addi	a0,a0,-1424 # f9000a70 <__freertos_irq_stack_top+0xffffee90>
f9000530:	d35ff0ef          	jal	ra,f9000264 <bsp_printReg>
    }
}
f9000534:	00c12083          	lw	ra,12(sp)
f9000538:	00812403          	lw	s0,8(sp)
f900053c:	01010113          	addi	sp,sp,16
f9000540:	00008067          	ret

f9000544 <Phy_Rd>:

static u32 Phy_Rd(u32 RegAddr)
{
f9000544:	ff010113          	addi	sp,sp,-16
f9000548:	00112623          	sw	ra,12(sp)
f900054c:	00812423          	sw	s0,8(sp)
f9000550:	00912223          	sw	s1,4(sp)
f9000554:	00050493          	mv	s1,a0
    u32 Value;
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_CSR+0x108));
f9000558:	01f57793          	andi	a5,a0,31
f900055c:	7007e793          	ori	a5,a5,1792
f9000560:	f8100437          	lui	s0,0xf8100
f9000564:	10f42423          	sw	a5,264(s0) # f8100108 <__freertos_irq_stack_top+0xff0fe528>
f9000568:	00100793          	li	a5,1
f900056c:	10f42223          	sw	a5,260(s0)
    write_u32(0x1, (TSEMAC_CSR+0x104));
    bsp_uDelay(1000);
f9000570:	f8b00637          	lui	a2,0xf8b00
f9000574:	02faf5b7          	lui	a1,0x2faf
f9000578:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f900057c:	3e800513          	li	a0,1000
f9000580:	c09ff0ef          	jal	ra,f9000188 <clint_uDelay>
        return *((volatile u32*) address);
f9000584:	11042403          	lw	s0,272(s0)
    Value = read_u32(TSEMAC_CSR+0x110);
    if(PRINTF_EN == 1) {
        bsp_printReg("Rd Phy Addr : ", RegAddr);
f9000588:	00048593          	mv	a1,s1
f900058c:	f9001537          	lui	a0,0xf9001
f9000590:	a8050513          	addi	a0,a0,-1408 # f9000a80 <__freertos_irq_stack_top+0xffffeea0>
f9000594:	cd1ff0ef          	jal	ra,f9000264 <bsp_printReg>
        bsp_printReg("Return Value : ", Value);
f9000598:	00040593          	mv	a1,s0
f900059c:	f9001537          	lui	a0,0xf9001
f90005a0:	a9050513          	addi	a0,a0,-1392 # f9000a90 <__freertos_irq_stack_top+0xffffeeb0>
f90005a4:	cc1ff0ef          	jal	ra,f9000264 <bsp_printReg>
    }
    return Value;
}
f90005a8:	00040513          	mv	a0,s0
f90005ac:	00c12083          	lw	ra,12(sp)
f90005b0:	00812403          	lw	s0,8(sp)
f90005b4:	00412483          	lw	s1,4(sp)
f90005b8:	01010113          	addi	sp,sp,16
f90005bc:	00008067          	ret

f90005c0 <PhyDlySetRXTX>:

/************************** Function File ***************************/
static void PhyDlySetRXTX(int RX_delay, int TX_delay)
{
f90005c0:	fe010113          	addi	sp,sp,-32
f90005c4:	00112e23          	sw	ra,28(sp)
f90005c8:	00812c23          	sw	s0,24(sp)
f90005cc:	00912a23          	sw	s1,20(sp)
f90005d0:	01212823          	sw	s2,16(sp)
f90005d4:	01312623          	sw	s3,12(sp)
f90005d8:	01412423          	sw	s4,8(sp)
f90005dc:	00050413          	mv	s0,a0
f90005e0:	00058913          	mv	s2,a1
    u32 Value;
    bsp_print("Start Info : Set Phy Delay.");
f90005e4:	f9001537          	lui	a0,0xf9001
f90005e8:	aa050513          	addi	a0,a0,-1376 # f9000aa0 <__freertos_irq_stack_top+0xffffeec0>
f90005ec:	c41ff0ef          	jal	ra,f900022c <bsp_print>
    Phy_Wr(0x1F,0x0168);
f90005f0:	16800593          	li	a1,360
f90005f4:	01f00513          	li	a0,31
f90005f8:	ef1ff0ef          	jal	ra,f90004e8 <Phy_Wr>
    Phy_Wr(0x1E,0x8040);
f90005fc:	00008a37          	lui	s4,0x8
f9000600:	040a0593          	addi	a1,s4,64 # 8040 <__stack_size+0x7040>
f9000604:	01e00513          	li	a0,30
f9000608:	ee1ff0ef          	jal	ra,f90004e8 <Phy_Wr>
    Phy_Wr(0x1E,0x401E);
f900060c:	000049b7          	lui	s3,0x4
f9000610:	01e98593          	addi	a1,s3,30 # 401e <__stack_size+0x301e>
f9000614:	01e00513          	li	a0,30
f9000618:	ed1ff0ef          	jal	ra,f90004e8 <Phy_Wr>
    Value = Phy_Rd(0x1F) & 0xFFFF;
f900061c:	01f00513          	li	a0,31
f9000620:	f25ff0ef          	jal	ra,f9000544 <Phy_Rd>

    Value &= 0xFF00;
f9000624:	000105b7          	lui	a1,0x10
f9000628:	f0058593          	addi	a1,a1,-256 # ff00 <__stack_size+0xef00>
f900062c:	00b574b3          	and	s1,a0,a1
    RX_delay &= 0xF;
f9000630:	00f47413          	andi	s0,s0,15
    TX_delay &= 0xF;
f9000634:	00f97913          	andi	s2,s2,15
    bsp_printReg("Setup New Value = ", RX_delay);
f9000638:	00040593          	mv	a1,s0
f900063c:	f9001537          	lui	a0,0xf9001
f9000640:	abc50513          	addi	a0,a0,-1348 # f9000abc <__freertos_irq_stack_top+0xffffeedc>
f9000644:	c21ff0ef          	jal	ra,f9000264 <bsp_printReg>

    Value = ((Value) | (RX_delay<<4) | (TX_delay));
f9000648:	00441413          	slli	s0,s0,0x4
f900064c:	009465b3          	or	a1,s0,s1
    Phy_Wr(0x1F,Value);
f9000650:	0125e5b3          	or	a1,a1,s2
f9000654:	01f00513          	li	a0,31
f9000658:	e91ff0ef          	jal	ra,f90004e8 <Phy_Wr>
    Phy_Wr(0x1E,0x801E);
f900065c:	01ea0593          	addi	a1,s4,30
f9000660:	01e00513          	li	a0,30
f9000664:	e85ff0ef          	jal	ra,f90004e8 <Phy_Wr>
    Phy_Wr(0x1E,0x401E);
f9000668:	01e98593          	addi	a1,s3,30
f900066c:	01e00513          	li	a0,30
f9000670:	e79ff0ef          	jal	ra,f90004e8 <Phy_Wr>
    Value = Phy_Rd(0x1F) & 0xFFFF;
f9000674:	01f00513          	li	a0,31
f9000678:	ecdff0ef          	jal	ra,f9000544 <Phy_Rd>
    bsp_printReg("Read New Value = ", Value);
f900067c:	01051593          	slli	a1,a0,0x10
f9000680:	0105d593          	srli	a1,a1,0x10
f9000684:	f9001537          	lui	a0,0xf9001
f9000688:	ad050513          	addi	a0,a0,-1328 # f9000ad0 <__freertos_irq_stack_top+0xffffeef0>
f900068c:	bd9ff0ef          	jal	ra,f9000264 <bsp_printReg>
}
f9000690:	01c12083          	lw	ra,28(sp)
f9000694:	01812403          	lw	s0,24(sp)
f9000698:	01412483          	lw	s1,20(sp)
f900069c:	01012903          	lw	s2,16(sp)
f90006a0:	00c12983          	lw	s3,12(sp)
f90006a4:	00812a03          	lw	s4,8(sp)
f90006a8:	02010113          	addi	sp,sp,32
f90006ac:	00008067          	ret

f90006b0 <PhyNormalInit>:

/************************** Function File ***************************/
static u32 PhyNormalInit()
{
f90006b0:	ff010113          	addi	sp,sp,-16
f90006b4:	00112623          	sw	ra,12(sp)
	PhyDlySetRXTX(15, 8); //change here when trying Linked partner mode
f90006b8:	00800593          	li	a1,8
f90006bc:	00f00513          	li	a0,15
f90006c0:	f01ff0ef          	jal	ra,f90005c0 <PhyDlySetRXTX>

	u32 Value;
	if(PRINTF_EN == 1) {
		bsp_print("Wait Ethernet Link up...");
f90006c4:	f9001537          	lui	a0,0xf9001
f90006c8:	ae450513          	addi	a0,a0,-1308 # f9000ae4 <__freertos_irq_stack_top+0xffffef04>
f90006cc:	b61ff0ef          	jal	ra,f900022c <bsp_print>
	}
    // to read Basic control
	Phy_Rd(0x0); 
f90006d0:	00000513          	li	a0,0
f90006d4:	e71ff0ef          	jal	ra,f9000544 <Phy_Rd>
    // to read phy ID
	Phy_Rd(0x2); 
f90006d8:	00200513          	li	a0,2
f90006dc:	e69ff0ef          	jal	ra,f9000544 <Phy_Rd>
    // to read phy ID
	Phy_Rd(0x3); 
f90006e0:	00300513          	li	a0,3
f90006e4:	e61ff0ef          	jal	ra,f9000544 <Phy_Rd>

	//Unlock Extended registers
	Phy_Wr(0x1f, 0x0168);
f90006e8:	16800593          	li	a1,360
f90006ec:	01f00513          	li	a0,31
f90006f0:	df9ff0ef          	jal	ra,f90004e8 <Phy_Wr>
	Phy_Wr(0x1e, 0x8040);
f90006f4:	000085b7          	lui	a1,0x8
f90006f8:	04058593          	addi	a1,a1,64 # 8040 <__stack_size+0x7040>
f90006fc:	01e00513          	li	a0,30
f9000700:	de9ff0ef          	jal	ra,f90004e8 <Phy_Wr>
f9000704:	04c0006f          	j	f9000750 <PhyNormalInit+0xa0>
		Value = Phy_Rd(0x11);
        //Link up and DUPLEX mode
		if((Value&0x2400) == 0x2400) {
			if((Value&0xc000) == 0x8000) {          //1000Mbps
				if(PRINTF_EN == 1) {
					bsp_print("Info : Phy Link up on 1000Mbps.");
f9000708:	f9001537          	lui	a0,0xf9001
f900070c:	b0050513          	addi	a0,a0,-1280 # f9000b00 <__freertos_irq_stack_top+0xffffef20>
f9000710:	b1dff0ef          	jal	ra,f900022c <bsp_print>
				}
				return 0x4;
f9000714:	00400513          	li	a0,4
				return 0x1;
			}
		}
		bsp_uDelay(100000);
	}
}
f9000718:	00c12083          	lw	ra,12(sp)
f900071c:	01010113          	addi	sp,sp,16
f9000720:	00008067          	ret
					bsp_print("Info : Phy Link up on 100Mbps.");
f9000724:	f9001537          	lui	a0,0xf9001
f9000728:	b2050513          	addi	a0,a0,-1248 # f9000b20 <__freertos_irq_stack_top+0xffffef40>
f900072c:	b01ff0ef          	jal	ra,f900022c <bsp_print>
				return 0x2;
f9000730:	00200513          	li	a0,2
f9000734:	fe5ff06f          	j	f9000718 <PhyNormalInit+0x68>
		bsp_uDelay(100000);
f9000738:	f8b00637          	lui	a2,0xf8b00
f900073c:	02faf5b7          	lui	a1,0x2faf
f9000740:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000744:	00018537          	lui	a0,0x18
f9000748:	6a050513          	addi	a0,a0,1696 # 186a0 <__stack_size+0x176a0>
f900074c:	a3dff0ef          	jal	ra,f9000188 <clint_uDelay>
		Value = Phy_Rd(0x11);
f9000750:	01100513          	li	a0,17
f9000754:	df1ff0ef          	jal	ra,f9000544 <Phy_Rd>
		if((Value&0x2400) == 0x2400) {
f9000758:	000027b7          	lui	a5,0x2
f900075c:	40078793          	addi	a5,a5,1024 # 2400 <__stack_size+0x1400>
f9000760:	00f57733          	and	a4,a0,a5
f9000764:	fcf71ae3          	bne	a4,a5,f9000738 <PhyNormalInit+0x88>
			if((Value&0xc000) == 0x8000) {          //1000Mbps
f9000768:	0000c7b7          	lui	a5,0xc
f900076c:	00f57533          	and	a0,a0,a5
f9000770:	000087b7          	lui	a5,0x8
f9000774:	f8f50ae3          	beq	a0,a5,f9000708 <PhyNormalInit+0x58>
			} else if((Value&0xc000) == 0x4000) {   //100Mbps
f9000778:	000047b7          	lui	a5,0x4
f900077c:	faf504e3          	beq	a0,a5,f9000724 <PhyNormalInit+0x74>
			} else if((Value&0xc000) == 0x0) {      //10Mbps
f9000780:	fa051ce3          	bnez	a0,f9000738 <PhyNormalInit+0x88>
					bsp_print("Info : Phy Link up on 10Mbps.");
f9000784:	f9001537          	lui	a0,0xf9001
f9000788:	b4050513          	addi	a0,a0,-1216 # f9000b40 <__freertos_irq_stack_top+0xffffef60>
f900078c:	aa1ff0ef          	jal	ra,f900022c <bsp_print>
				return 0x1;
f9000790:	00100513          	li	a0,1
f9000794:	f85ff06f          	j	f9000718 <PhyNormalInit+0x68>

f9000798 <PatGen>:
#include "efx_tse_mac.h"
#include "efx_tse_phy.h"

////////////////////////////////////////////////////////////////////////////////
void PatGen()
{
f9000798:	ff010113          	addi	sp,sp,-16
f900079c:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f90007a0:	f81007b7          	lui	a5,0xf8100
f90007a4:	00010737          	lui	a4,0x10
f90007a8:	fff70713          	addi	a4,a4,-1 # ffff <__stack_size+0xefff>
f90007ac:	20e7aa23          	sw	a4,532(a5) # f8100214 <__freertos_irq_stack_top+0xff0fe634>
f90007b0:	fff00713          	li	a4,-1
f90007b4:	20e7a823          	sw	a4,528(a5)
f90007b8:	0000f737          	lui	a4,0xf
f90007bc:	ae870713          	addi	a4,a4,-1304 # eae8 <__stack_size+0xdae8>
f90007c0:	20e7ae23          	sw	a4,540(a5)
f90007c4:	5e006737          	lui	a4,0x5e006
f90007c8:	0c870713          	addi	a4,a4,200 # 5e0060c8 <__stack_size+0x5e0050c8>
f90007cc:	20e7ac23          	sw	a4,536(a5)
f90007d0:	c0a80737          	lui	a4,0xc0a80
f90007d4:	16470693          	addi	a3,a4,356 # c0a80164 <__freertos_irq_stack_top+0xc7a7e584>
f90007d8:	22d7a223          	sw	a3,548(a5)
f90007dc:	16570713          	addi	a4,a4,357
f90007e0:	22e7a423          	sw	a4,552(a5)
f90007e4:	27150737          	lui	a4,0x27150
f90007e8:	52170713          	addi	a4,a4,1313 # 27150521 <__stack_size+0x2714f521>
f90007ec:	22e7a623          	sw	a4,556(a5)
f90007f0:	00640737          	lui	a4,0x640
f90007f4:	20e7a623          	sw	a4,524(a5)
f90007f8:	06400713          	li	a4,100
f90007fc:	22e7a023          	sw	a4,544(a5)
f9000800:	22e7a823          	sw	a4,560(a5)
f9000804:	2007a423          	sw	zero,520(a5)
f9000808:	2007a223          	sw	zero,516(a5)
f900080c:	00100713          	li	a4,1
f9000810:	20e7a423          	sw	a4,520(a5)
f9000814:	2007a423          	sw	zero,520(a5)
		write_u32(0x2, (TSEMAC_CSR+0x208));
        //ex_reg mac_pat_gen_en & udp_pat_gen_en
		write_u32(0x0, (TSEMAC_CSR+0x208));
	}
	if(PRINTF_EN == 1) {
        bsp_print("Info : Set Pattern Generator.");
f9000818:	f9001537          	lui	a0,0xf9001
f900081c:	b6050513          	addi	a0,a0,-1184 # f9000b60 <__freertos_irq_stack_top+0xffffef80>
f9000820:	a0dff0ef          	jal	ra,f900022c <bsp_print>
	}
}
f9000824:	00c12083          	lw	ra,12(sp)
f9000828:	01010113          	addi	sp,sp,16
f900082c:	00008067          	ret

f9000830 <StartRunning>:

void StartRunning()
{
f9000830:	ff010113          	addi	sp,sp,-16
f9000834:	00112623          	sw	ra,12(sp)
f9000838:	00812423          	sw	s0,8(sp)
f900083c:	00912223          	sw	s1,4(sp)
f9000840:	f8100437          	lui	s0,0xf8100
f9000844:	00100493          	li	s1,1
f9000848:	20942023          	sw	s1,512(s0) # f8100200 <__freertos_irq_stack_top+0xff0fe620>
    //mac_sw_rst
	write_u32(0x1, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Assert mac reset ");
f900084c:	f9001537          	lui	a0,0xf9001
f9000850:	b8050513          	addi	a0,a0,-1152 # f9000b80 <__freertos_irq_stack_top+0xffffefa0>
f9000854:	9d9ff0ef          	jal	ra,f900022c <bsp_print>
	}
	bsp_uDelay(1);
f9000858:	f8b00637          	lui	a2,0xf8b00
f900085c:	02faf5b7          	lui	a1,0x2faf
f9000860:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f9000864:	00100513          	li	a0,1
f9000868:	921ff0ef          	jal	ra,f9000188 <clint_uDelay>
f900086c:	20042023          	sw	zero,512(s0)
    //mac_sw_rst
	write_u32(0x0, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Deassert mac reset ");
f9000870:	f9001537          	lui	a0,0xf9001
f9000874:	b9c50513          	addi	a0,a0,-1124 # f9000b9c <__freertos_irq_stack_top+0xffffefbc>
f9000878:	9b5ff0ef          	jal	ra,f900022c <bsp_print>
f900087c:	20942223          	sw	s1,516(s0)
		MacCntClean();
		PatGen();
	} else if(TEST_MODE == 1) {
        //ex_reg pat_mux_select & axi4_st_mux_select
		write_u32(0x1, (TSEMAC_CSR+0x204));
		MacAddrSet(1, 1);//originally is (0, 1)
f9000880:	00100593          	li	a1,1
f9000884:	00100513          	li	a0,1
f9000888:	a85ff0ef          	jal	ra,f900030c <MacAddrSet>
		MacCntClean();
f900088c:	aedff0ef          	jal	ra,f9000378 <MacCntClean>
	}

	while(1){
		bsp_uDelay(3000000);
f9000890:	f8b00637          	lui	a2,0xf8b00
f9000894:	02faf5b7          	lui	a1,0x2faf
f9000898:	08058593          	addi	a1,a1,128 # 2faf080 <__stack_size+0x2fae080>
f900089c:	002dc537          	lui	a0,0x2dc
f90008a0:	6c050513          	addi	a0,a0,1728 # 2dc6c0 <__stack_size+0x2db6c0>
f90008a4:	8e5ff0ef          	jal	ra,f9000188 <clint_uDelay>
		CntMonitor();
f90008a8:	b35ff0ef          	jal	ra,f90003dc <CntMonitor>
f90008ac:	fe5ff06f          	j	f9000890 <StartRunning+0x60>

f90008b0 <main>:
	}
}

////////////////////////////////////////////////////////////////////////////////
void main() {
f90008b0:	ff010113          	addi	sp,sp,-16
f90008b4:	00112623          	sw	ra,12(sp)
    u32 prompt=0;
    u32 speed;

    bsp_init();
    bsp_print("tse demo !");
f90008b8:	80018513          	addi	a0,gp,-2048 # f9000bb8 <__init_array_end+0x2ec>
f90008bc:	971ff0ef          	jal	ra,f900022c <bsp_print>
    speed = PhyNormalInit();
f90008c0:	df1ff0ef          	jal	ra,f90006b0 <PhyNormalInit>
	if (TEST_MODE == 0) {
		PhyLoopInit(4);// 4=1000, 2=100, 1=10Mbps
	}
	MacNormalInit(speed);
f90008c4:	c05ff0ef          	jal	ra,f90004c8 <MacNormalInit>
	StartRunning();
f90008c8:	f69ff0ef          	jal	ra,f9000830 <StartRunning>
