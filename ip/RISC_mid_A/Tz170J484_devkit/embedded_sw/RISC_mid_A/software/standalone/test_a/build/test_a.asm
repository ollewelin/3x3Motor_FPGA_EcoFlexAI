
build/test_a.elf:     file format elf32-littleriscv


Disassembly of section .init:

00001000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
    1000:	00001197          	auipc	gp,0x1
    1004:	92818193          	addi	gp,gp,-1752 # 1928 <__global_pointer$>

00001008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
    1008:	00001117          	auipc	sp,0x1
    100c:	14810113          	addi	sp,sp,328 # 2150 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
    1010:	81018513          	addi	a0,gp,-2032 # 1138 <_data>
	la a1, _data
    1014:	81018593          	addi	a1,gp,-2032 # 1138 <_data>
	la a2, _edata
    1018:	81c18613          	addi	a2,gp,-2020 # 1144 <__bss_start>
	bgeu a1, a2, 2f
    101c:	00c5fc63          	bgeu	a1,a2,1034 <init+0x2c>
1:
	lw t0, (a0)
    1020:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
    1024:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
    1028:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
    102c:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
    1030:	fec5e8e3          	bltu	a1,a2,1020 <init+0x18>
2:

	/* Clear bss section */
	la a0, __bss_start
    1034:	81c18513          	addi	a0,gp,-2020 # 1144 <__bss_start>
	la a1, _end
    1038:	82018593          	addi	a1,gp,-2016 # 1148 <_end>
	bgeu a0, a1, 2f
    103c:	00b57863          	bgeu	a0,a1,104c <init+0x44>
1:
	sw zero, (a0)
    1040:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
    1044:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
    1048:	feb56ce3          	bltu	a0,a1,1040 <init+0x38>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
    104c:	010000ef          	jal	ra,105c <__libc_init_array>
#endif

	call main
    1050:	0b0000ef          	jal	ra,1100 <main>

00001054 <mainDone>:
mainDone:
    j mainDone
    1054:	0000006f          	j	1054 <mainDone>

00001058 <_init>:


	.globl _init
_init:
    ret
    1058:	00008067          	ret

Disassembly of section .text:

0000105c <__libc_init_array>:
    105c:	ff010113          	addi	sp,sp,-16
    1060:	00812423          	sw	s0,8(sp)
    1064:	01212023          	sw	s2,0(sp)
    1068:	81018413          	addi	s0,gp,-2032 # 1138 <_data>
    106c:	81018913          	addi	s2,gp,-2032 # 1138 <_data>
    1070:	40890933          	sub	s2,s2,s0
    1074:	00112623          	sw	ra,12(sp)
    1078:	00912223          	sw	s1,4(sp)
    107c:	40295913          	srai	s2,s2,0x2
    1080:	00090e63          	beqz	s2,109c <__libc_init_array+0x40>
    1084:	00000493          	li	s1,0
    1088:	00042783          	lw	a5,0(s0)
    108c:	00148493          	addi	s1,s1,1
    1090:	00440413          	addi	s0,s0,4
    1094:	000780e7          	jalr	a5
    1098:	fe9918e3          	bne	s2,s1,1088 <__libc_init_array+0x2c>
    109c:	81018413          	addi	s0,gp,-2032 # 1138 <_data>
    10a0:	81018913          	addi	s2,gp,-2032 # 1138 <_data>
    10a4:	40890933          	sub	s2,s2,s0
    10a8:	40295913          	srai	s2,s2,0x2
    10ac:	00090e63          	beqz	s2,10c8 <__libc_init_array+0x6c>
    10b0:	00000493          	li	s1,0
    10b4:	00042783          	lw	a5,0(s0)
    10b8:	00148493          	addi	s1,s1,1
    10bc:	00440413          	addi	s0,s0,4
    10c0:	000780e7          	jalr	a5
    10c4:	fe9918e3          	bne	s2,s1,10b4 <__libc_init_array+0x58>
    10c8:	00c12083          	lw	ra,12(sp)
    10cc:	00812403          	lw	s0,8(sp)
    10d0:	00412483          	lw	s1,4(sp)
    10d4:	00012903          	lw	s2,0(sp)
    10d8:	01010113          	addi	sp,sp,16
    10dc:	00008067          	ret

000010e0 <delay>:
// Minimal GPIO toggle test - verify CPU boots and executes
#include <stdint.h>

#define SYSTEM_GPIO_0_IO_OUTPUT 0xf8015000

void delay(uint32_t cycles) {
    10e0:	ff010113          	addi	sp,sp,-16
    volatile uint32_t i = cycles;
    10e4:	00a12623          	sw	a0,12(sp)
    while (i--);
    10e8:	00c12783          	lw	a5,12(sp)
    10ec:	fff78713          	addi	a4,a5,-1
    10f0:	00e12623          	sw	a4,12(sp)
    10f4:	fe079ae3          	bnez	a5,10e8 <delay+0x8>
}
    10f8:	01010113          	addi	sp,sp,16
    10fc:	00008067          	ret

00001100 <main>:

int main(int argc, char **argv) {
    1100:	ff010113          	addi	sp,sp,-16
    1104:	00112623          	sw	ra,12(sp)
    1108:	00812423          	sw	s0,8(sp)
    110c:	00912223          	sw	s1,4(sp)
    volatile uint32_t *gpio_out = (volatile uint32_t *)SYSTEM_GPIO_0_IO_OUTPUT;
    
    while (1) {
        *gpio_out = 0x1;        // LED on
    1110:	f80154b7          	lui	s1,0xf8015
    1114:	00100793          	li	a5,1
    1118:	00f4a023          	sw	a5,0(s1) # f8015000 <__freertos_irq_stack_top+0xf8012eb0>
        delay(10000000);        // ~1 second
    111c:	00989437          	lui	s0,0x989
    1120:	68040513          	addi	a0,s0,1664 # 989680 <__freertos_irq_stack_top+0x987530>
    1124:	fbdff0ef          	jal	ra,10e0 <delay>
        
        *gpio_out = 0x0;        // LED off
    1128:	0004a023          	sw	zero,0(s1)
        delay(10000000);        // ~1 second
    112c:	68040513          	addi	a0,s0,1664
    1130:	fb1ff0ef          	jal	ra,10e0 <delay>
    1134:	fddff06f          	j	1110 <main+0x10>
