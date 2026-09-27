
build/test_a.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00001197          	auipc	gp,0x1
f9000004:	92818193          	addi	gp,gp,-1752 # f9000928 <__global_pointer$>

f9000008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
f9000008:	00004117          	auipc	sp,0x4
f900000c:	14810113          	addi	sp,sp,328 # f9004150 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
f9000010:	81018513          	addi	a0,gp,-2032 # f9000138 <_data>
	la a1, _data
f9000014:	81018593          	addi	a1,gp,-2032 # f9000138 <_data>
	la a2, _edata
f9000018:	81c18613          	addi	a2,gp,-2020 # f9000144 <__bss_start>
	bgeu a1, a2, 2f
f900001c:	00c5fc63          	bgeu	a1,a2,f9000034 <init+0x2c>
1:
	lw t0, (a0)
f9000020:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
f9000024:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
f9000028:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
f900002c:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
f9000030:	fec5e8e3          	bltu	a1,a2,f9000020 <init+0x18>
2:

	/* Clear bss section */
	la a0, __bss_start
f9000034:	81c18513          	addi	a0,gp,-2020 # f9000144 <__bss_start>
	la a1, _end
f9000038:	82018593          	addi	a1,gp,-2016 # f9000148 <_end>
	bgeu a0, a1, 2f
f900003c:	00b57863          	bgeu	a0,a1,f900004c <init+0x44>
1:
	sw zero, (a0)
f9000040:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
f9000044:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
f9000048:	feb56ce3          	bltu	a0,a1,f9000040 <init+0x38>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
f900004c:	010000ef          	jal	ra,f900005c <__libc_init_array>
#endif

	call main
f9000050:	0b0000ef          	jal	ra,f9000100 <main>

f9000054 <mainDone>:
mainDone:
    j mainDone
f9000054:	0000006f          	j	f9000054 <mainDone>

f9000058 <_init>:


	.globl _init
_init:
    ret
f9000058:	00008067          	ret

Disassembly of section .text:

f900005c <__libc_init_array>:
f900005c:	ff010113          	addi	sp,sp,-16
f9000060:	00812423          	sw	s0,8(sp)
f9000064:	01212023          	sw	s2,0(sp)
f9000068:	81018413          	addi	s0,gp,-2032 # f9000138 <_data>
f900006c:	81018913          	addi	s2,gp,-2032 # f9000138 <_data>
f9000070:	40890933          	sub	s2,s2,s0
f9000074:	00112623          	sw	ra,12(sp)
f9000078:	00912223          	sw	s1,4(sp)
f900007c:	40295913          	srai	s2,s2,0x2
f9000080:	00090e63          	beqz	s2,f900009c <__libc_init_array+0x40>
f9000084:	00000493          	li	s1,0
f9000088:	00042783          	lw	a5,0(s0)
f900008c:	00148493          	addi	s1,s1,1
f9000090:	00440413          	addi	s0,s0,4
f9000094:	000780e7          	jalr	a5
f9000098:	fe9918e3          	bne	s2,s1,f9000088 <__libc_init_array+0x2c>
f900009c:	81018413          	addi	s0,gp,-2032 # f9000138 <_data>
f90000a0:	81018913          	addi	s2,gp,-2032 # f9000138 <_data>
f90000a4:	40890933          	sub	s2,s2,s0
f90000a8:	40295913          	srai	s2,s2,0x2
f90000ac:	00090e63          	beqz	s2,f90000c8 <__libc_init_array+0x6c>
f90000b0:	00000493          	li	s1,0
f90000b4:	00042783          	lw	a5,0(s0)
f90000b8:	00148493          	addi	s1,s1,1
f90000bc:	00440413          	addi	s0,s0,4
f90000c0:	000780e7          	jalr	a5
f90000c4:	fe9918e3          	bne	s2,s1,f90000b4 <__libc_init_array+0x58>
f90000c8:	00c12083          	lw	ra,12(sp)
f90000cc:	00812403          	lw	s0,8(sp)
f90000d0:	00412483          	lw	s1,4(sp)
f90000d4:	00012903          	lw	s2,0(sp)
f90000d8:	01010113          	addi	sp,sp,16
f90000dc:	00008067          	ret

f90000e0 <delay>:
// Minimal GPIO toggle test - verify CPU boots and executes
#include <stdint.h>

#define SYSTEM_GPIO_0_IO_OUTPUT 0xf8015000

void delay(uint32_t cycles) {
f90000e0:	ff010113          	addi	sp,sp,-16
    volatile uint32_t i = cycles;
f90000e4:	00a12623          	sw	a0,12(sp)
    while (i--);
f90000e8:	00c12783          	lw	a5,12(sp)
f90000ec:	fff78713          	addi	a4,a5,-1
f90000f0:	00e12623          	sw	a4,12(sp)
f90000f4:	fe079ae3          	bnez	a5,f90000e8 <delay+0x8>
}
f90000f8:	01010113          	addi	sp,sp,16
f90000fc:	00008067          	ret

f9000100 <main>:

int main(int argc, char **argv) {
f9000100:	ff010113          	addi	sp,sp,-16
f9000104:	00112623          	sw	ra,12(sp)
f9000108:	00812423          	sw	s0,8(sp)
f900010c:	00912223          	sw	s1,4(sp)
    volatile uint32_t *gpio_out = (volatile uint32_t *)SYSTEM_GPIO_0_IO_OUTPUT;
    
    while (1) {
        *gpio_out = 0x1;        // LED on
f9000110:	f80154b7          	lui	s1,0xf8015
f9000114:	00100793          	li	a5,1
f9000118:	00f4a023          	sw	a5,0(s1) # f8015000 <__freertos_irq_stack_top+0xff010eb0>
        delay(10000000);        // ~1 second
f900011c:	00989437          	lui	s0,0x989
f9000120:	68040513          	addi	a0,s0,1664 # 989680 <__stack_size+0x985680>
f9000124:	fbdff0ef          	jal	ra,f90000e0 <delay>
        
        *gpio_out = 0x0;        // LED off
f9000128:	0004a023          	sw	zero,0(s1)
        delay(10000000);        // ~1 second
f900012c:	68040513          	addi	a0,s0,1664
f9000130:	fb1ff0ef          	jal	ra,f90000e0 <delay>
f9000134:	fddff06f          	j	f9000110 <main+0x10>
