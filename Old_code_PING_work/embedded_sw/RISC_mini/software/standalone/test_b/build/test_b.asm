
build/test_b.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:
f9000000:	00002197          	auipc	gp,0x2
f9000004:	30018193          	addi	gp,gp,768 # f9002300 <__global_pointer$>

f9000008 <init>:
f9000008:	00006117          	auipc	sp,0x6
f900000c:	72810113          	addi	sp,sp,1832 # f9006730 <__freertos_irq_stack_top>
f9000010:	00001517          	auipc	a0,0x1
f9000014:	6b850513          	addi	a0,a0,1720 # f90016c8 <_data>
f9000018:	00001597          	auipc	a1,0x1
f900001c:	6b058593          	addi	a1,a1,1712 # f90016c8 <_data>
f9000020:	82418613          	addi	a2,gp,-2012 # f9001b24 <__bss_start>
f9000024:	00c5fc63          	bgeu	a1,a2,f900003c <init+0x34>
f9000028:	00052283          	lw	t0,0(a0)
f900002c:	0055a023          	sw	t0,0(a1)
f9000030:	00450513          	addi	a0,a0,4
f9000034:	00458593          	addi	a1,a1,4
f9000038:	fec5e8e3          	bltu	a1,a2,f9000028 <init+0x20>
f900003c:	82418513          	addi	a0,gp,-2012 # f9001b24 <__bss_start>
f9000040:	42818593          	addi	a1,gp,1064 # f9002728 <_end>
f9000044:	00b57863          	bgeu	a0,a1,f9000054 <init+0x4c>
f9000048:	00052023          	sw	zero,0(a0)
f900004c:	00450513          	addi	a0,a0,4
f9000050:	feb56ce3          	bltu	a0,a1,f9000048 <init+0x40>
f9000054:	010000ef          	jal	ra,f9000064 <__libc_init_array>
f9000058:	244000ef          	jal	ra,f900029c <main>

f900005c <mainDone>:
f900005c:	0000006f          	j	f900005c <mainDone>

f9000060 <_init>:
f9000060:	00008067          	ret

Disassembly of section .text:

f9000064 <__libc_init_array>:
f9000064:	ff010113          	addi	sp,sp,-16
f9000068:	00812423          	sw	s0,8(sp)
f900006c:	01212023          	sw	s2,0(sp)
f9000070:	00001417          	auipc	s0,0x1
f9000074:	65840413          	addi	s0,s0,1624 # f90016c8 <_data>
f9000078:	00001917          	auipc	s2,0x1
f900007c:	65090913          	addi	s2,s2,1616 # f90016c8 <_data>
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
f90000b0:	61c40413          	addi	s0,s0,1564 # f90016c8 <_data>
f90000b4:	00001917          	auipc	s2,0x1
f90000b8:	61490913          	addi	s2,s2,1556 # f90016c8 <_data>
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

f90000f8 <memcmp>:
f90000f8:	00300793          	li	a5,3
f90000fc:	02c7f863          	bgeu	a5,a2,f900012c <memcmp+0x34>
f9000100:	00b567b3          	or	a5,a0,a1
f9000104:	0037f793          	andi	a5,a5,3
f9000108:	00300693          	li	a3,3
f900010c:	06079263          	bnez	a5,f9000170 <memcmp+0x78>
f9000110:	00052703          	lw	a4,0(a0)
f9000114:	0005a783          	lw	a5,0(a1)
f9000118:	04f71c63          	bne	a4,a5,f9000170 <memcmp+0x78>
f900011c:	ffc60613          	addi	a2,a2,-4
f9000120:	00450513          	addi	a0,a0,4
f9000124:	00458593          	addi	a1,a1,4
f9000128:	fec6e4e3          	bltu	a3,a2,f9000110 <memcmp+0x18>
f900012c:	fff60793          	addi	a5,a2,-1
f9000130:	02060c63          	beqz	a2,f9000168 <memcmp+0x70>
f9000134:	00054703          	lbu	a4,0(a0)
f9000138:	0005c683          	lbu	a3,0(a1)
f900013c:	02d71e63          	bne	a4,a3,f9000178 <memcmp+0x80>
f9000140:	00178713          	addi	a4,a5,1
f9000144:	00150793          	addi	a5,a0,1
f9000148:	00e50533          	add	a0,a0,a4
f900014c:	0140006f          	j	f9000160 <memcmp+0x68>
f9000150:	0007c703          	lbu	a4,0(a5)
f9000154:	0005c683          	lbu	a3,0(a1)
f9000158:	00178793          	addi	a5,a5,1
f900015c:	00d71e63          	bne	a4,a3,f9000178 <memcmp+0x80>
f9000160:	00158593          	addi	a1,a1,1
f9000164:	fea796e3          	bne	a5,a0,f9000150 <memcmp+0x58>
f9000168:	00000513          	li	a0,0
f900016c:	00008067          	ret
f9000170:	fff60793          	addi	a5,a2,-1
f9000174:	fc1ff06f          	j	f9000134 <memcmp+0x3c>
f9000178:	40d70533          	sub	a0,a4,a3
f900017c:	00008067          	ret

f9000180 <memcpy>:
f9000180:	00a5c7b3          	xor	a5,a1,a0
f9000184:	0037f793          	andi	a5,a5,3
f9000188:	00c508b3          	add	a7,a0,a2
f900018c:	06079263          	bnez	a5,f90001f0 <memcpy+0x70>
f9000190:	00300793          	li	a5,3
f9000194:	04c7fe63          	bgeu	a5,a2,f90001f0 <memcpy+0x70>
f9000198:	00357793          	andi	a5,a0,3
f900019c:	00050713          	mv	a4,a0
f90001a0:	06079863          	bnez	a5,f9000210 <memcpy+0x90>
f90001a4:	ffc8f613          	andi	a2,a7,-4
f90001a8:	fe060793          	addi	a5,a2,-32
f90001ac:	08f76c63          	bltu	a4,a5,f9000244 <memcpy+0xc4>
f90001b0:	02c77c63          	bgeu	a4,a2,f90001e8 <memcpy+0x68>
f90001b4:	00058693          	mv	a3,a1
f90001b8:	00070793          	mv	a5,a4
f90001bc:	0006a803          	lw	a6,0(a3)
f90001c0:	00478793          	addi	a5,a5,4
f90001c4:	00468693          	addi	a3,a3,4
f90001c8:	ff07ae23          	sw	a6,-4(a5)
f90001cc:	fec7e8e3          	bltu	a5,a2,f90001bc <memcpy+0x3c>
f90001d0:	fff60793          	addi	a5,a2,-1
f90001d4:	40e787b3          	sub	a5,a5,a4
f90001d8:	ffc7f793          	andi	a5,a5,-4
f90001dc:	00478793          	addi	a5,a5,4
f90001e0:	00f70733          	add	a4,a4,a5
f90001e4:	00f585b3          	add	a1,a1,a5
f90001e8:	01176863          	bltu	a4,a7,f90001f8 <memcpy+0x78>
f90001ec:	00008067          	ret
f90001f0:	00050713          	mv	a4,a0
f90001f4:	ff157ce3          	bgeu	a0,a7,f90001ec <memcpy+0x6c>
f90001f8:	0005c783          	lbu	a5,0(a1)
f90001fc:	00170713          	addi	a4,a4,1
f9000200:	00158593          	addi	a1,a1,1
f9000204:	fef70fa3          	sb	a5,-1(a4)
f9000208:	ff1768e3          	bltu	a4,a7,f90001f8 <memcpy+0x78>
f900020c:	00008067          	ret
f9000210:	0005c683          	lbu	a3,0(a1)
f9000214:	00170713          	addi	a4,a4,1
f9000218:	00377793          	andi	a5,a4,3
f900021c:	fed70fa3          	sb	a3,-1(a4)
f9000220:	00158593          	addi	a1,a1,1
f9000224:	f80780e3          	beqz	a5,f90001a4 <memcpy+0x24>
f9000228:	0005c683          	lbu	a3,0(a1)
f900022c:	00170713          	addi	a4,a4,1
f9000230:	00377793          	andi	a5,a4,3
f9000234:	fed70fa3          	sb	a3,-1(a4)
f9000238:	00158593          	addi	a1,a1,1
f900023c:	fc079ae3          	bnez	a5,f9000210 <memcpy+0x90>
f9000240:	f65ff06f          	j	f90001a4 <memcpy+0x24>
f9000244:	0005a683          	lw	a3,0(a1)
f9000248:	0045a283          	lw	t0,4(a1)
f900024c:	0085af83          	lw	t6,8(a1)
f9000250:	00c5af03          	lw	t5,12(a1)
f9000254:	0105ae83          	lw	t4,16(a1)
f9000258:	0145ae03          	lw	t3,20(a1)
f900025c:	0185a303          	lw	t1,24(a1)
f9000260:	01c5a803          	lw	a6,28(a1)
f9000264:	02458593          	addi	a1,a1,36
f9000268:	00d72023          	sw	a3,0(a4)
f900026c:	ffc5a683          	lw	a3,-4(a1)
f9000270:	00572223          	sw	t0,4(a4)
f9000274:	01f72423          	sw	t6,8(a4)
f9000278:	01e72623          	sw	t5,12(a4)
f900027c:	01d72823          	sw	t4,16(a4)
f9000280:	01c72a23          	sw	t3,20(a4)
f9000284:	00672c23          	sw	t1,24(a4)
f9000288:	01072e23          	sw	a6,28(a4)
f900028c:	02470713          	addi	a4,a4,36
f9000290:	fed72e23          	sw	a3,-4(a4)
f9000294:	faf768e3          	bltu	a4,a5,f9000244 <memcpy+0xc4>
f9000298:	f19ff06f          	j	f90001b0 <memcpy+0x30>

f900029c <main>:
f900029c:	fc010113          	addi	sp,sp,-64
f90002a0:	02112e23          	sw	ra,60(sp)
f90002a4:	02812c23          	sw	s0,56(sp)
f90002a8:	02912a23          	sw	s1,52(sp)
f90002ac:	03212823          	sw	s2,48(sp)
f90002b0:	03312623          	sw	s3,44(sp)
f90002b4:	03412423          	sw	s4,40(sp)
f90002b8:	03512223          	sw	s5,36(sp)
f90002bc:	03612023          	sw	s6,32(sp)
f90002c0:	01712e23          	sw	s7,28(sp)
f90002c4:	01812c23          	sw	s8,24(sp)
f90002c8:	01912a23          	sw	s9,20(sp)
f90002cc:	01a12823          	sw	s10,16(sp)
f90002d0:	01b12623          	sw	s11,12(sp)
f90002d4:	f80017b7          	lui	a5,0xf8001
f90002d8:	03500713          	li	a4,53
f90002dc:	00e7a423          	sw	a4,8(a5) # f8001008 <__freertos_irq_stack_top+0xfeffa8d8>
f90002e0:	00700713          	li	a4,7
f90002e4:	00e7a623          	sw	a4,12(a5)
f90002e8:	f800d7b7          	lui	a5,0xf800d
f90002ec:	00300713          	li	a4,3
f90002f0:	00200493          	li	s1,2
f90002f4:	00e7a423          	sw	a4,8(a5) # f800d008 <__freertos_irq_stack_top+0xff0068d8>
f90002f8:	f9001437          	lui	s0,0xf9001
f90002fc:	0097a223          	sw	s1,4(a5)
f9000300:	70440513          	addi	a0,s0,1796 # f9001704 <__freertos_irq_stack_top+0xffffafd4>
f9000304:	1b1000ef          	jal	ra,f9000cb4 <println_s>
f9000308:	f9001537          	lui	a0,0xf9001
f900030c:	72850513          	addi	a0,a0,1832 # f9001728 <__freertos_irq_stack_top+0xffffaff8>
f9000310:	1a5000ef          	jal	ra,f9000cb4 <println_s>
f9000314:	f9001537          	lui	a0,0xf9001
f9000318:	74c50513          	addi	a0,a0,1868 # f900174c <__freertos_irq_stack_top+0xffffb01c>
f900031c:	199000ef          	jal	ra,f9000cb4 <println_s>
f9000320:	f9001537          	lui	a0,0xf9001
f9000324:	77050513          	addi	a0,a0,1904 # f9001770 <__freertos_irq_stack_top+0xffffb040>
f9000328:	18d000ef          	jal	ra,f9000cb4 <println_s>
f900032c:	70440513          	addi	a0,s0,1796
f9000330:	185000ef          	jal	ra,f9000cb4 <println_s>
f9000334:	005687b7          	lui	a5,0x568
f9000338:	f8102737          	lui	a4,0xf8102
f900033c:	89a78793          	addi	a5,a5,-1894 # 56789a <__stack_size+0x56389a>
f9000340:	00f72823          	sw	a5,16(a4) # f8102010 <__freertos_irq_stack_top+0xff0fb8e0>
f9000344:	000017b7          	lui	a5,0x1
f9000348:	23478793          	addi	a5,a5,564 # 1234 <CUSTOM2+0x11d9>
f900034c:	f9001537          	lui	a0,0xf9001
f9000350:	00f72a23          	sw	a5,20(a4)
f9000354:	79450513          	addi	a0,a0,1940 # f9001794 <__freertos_irq_stack_top+0xffffb064>
f9000358:	15d000ef          	jal	ra,f9000cb4 <println_s>
f900035c:	f9001537          	lui	a0,0xf9001
f9000360:	7a850513          	addi	a0,a0,1960 # f90017a8 <__freertos_irq_stack_top+0xffffb078>
f9000364:	081000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f9000368:	f8101437          	lui	s0,0xf8101
f900036c:	0000c537          	lui	a0,0xc
f9000370:	00042423          	sw	zero,8(s0) # f8101008 <__freertos_irq_stack_top+0xff0fa8d8>
f9000374:	35050513          	addi	a0,a0,848 # c350 <__stack_size+0x8350>
f9000378:	115000ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f900037c:	00100793          	li	a5,1
f9000380:	00049537          	lui	a0,0x49
f9000384:	00f42423          	sw	a5,8(s0)
f9000388:	3e050513          	addi	a0,a0,992 # 493e0 <__stack_size+0x453e0>
f900038c:	101000ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f9000390:	f9002537          	lui	a0,0xf9002
f9000394:	95c50513          	addi	a0,a0,-1700 # f900195c <__freertos_irq_stack_top+0xffffb22c>
f9000398:	11d000ef          	jal	ra,f9000cb4 <println_s>
f900039c:	00200513          	li	a0,2
f90003a0:	77c000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f90003a4:	00050993          	mv	s3,a0
f90003a8:	00300513          	li	a0,3
f90003ac:	770000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f90003b0:	00050913          	mv	s2,a0
f90003b4:	f9001537          	lui	a0,0xf9001
f90003b8:	7b850513          	addi	a0,a0,1976 # f90017b8 <__freertos_irq_stack_top+0xffffb088>
f90003bc:	029000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f90003c0:	00098513          	mv	a0,s3
f90003c4:	055000ef          	jal	ra,f9000c18 <print_hex16_s>
f90003c8:	f9001537          	lui	a0,0xf9001
f90003cc:	7bc50513          	addi	a0,a0,1980 # f90017bc <__freertos_irq_stack_top+0xffffb08c>
f90003d0:	015000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f90003d4:	00090513          	mv	a0,s2
f90003d8:	041000ef          	jal	ra,f9000c18 <print_hex16_s>
f90003dc:	f90029b7          	lui	s3,0xf9002
f90003e0:	aa898513          	addi	a0,s3,-1368 # f9001aa8 <__freertos_irq_stack_top+0xffffb378>
f90003e4:	0d1000ef          	jal	ra,f9000cb4 <println_s>
f90003e8:	f9001537          	lui	a0,0xf9001
f90003ec:	7c050513          	addi	a0,a0,1984 # f90017c0 <__freertos_irq_stack_top+0xffffb090>
f90003f0:	7f4000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f90003f4:	0d0887b7          	lui	a5,0xd088
f90003f8:	c2178793          	addi	a5,a5,-991 # d087c21 <__stack_size+0xd083c21>
f90003fc:	00942223          	sw	s1,4(s0)
f9000400:	00f42023          	sw	a5,0(s0)
f9000404:	64c000ef          	jal	ra,f9000a50 <mdio_wait_done>
f9000408:	3e800513          	li	a0,1000
f900040c:	081000ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f9000410:	01100513          	li	a0,17
f9000414:	708000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f9000418:	10856513          	ori	a0,a0,264
f900041c:	000047b7          	lui	a5,0x4
f9000420:	42178793          	addi	a5,a5,1057 # 4421 <__stack_size+0x421>
f9000424:	01051513          	slli	a0,a0,0x10
f9000428:	00f56533          	or	a0,a0,a5
f900042c:	00942223          	sw	s1,4(s0)
f9000430:	00a42023          	sw	a0,0(s0)
f9000434:	61c000ef          	jal	ra,f9000a50 <mdio_wait_done>
f9000438:	3e800513          	li	a0,1000
f900043c:	051000ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f9000440:	01100513          	li	a0,17
f9000444:	00008937          	lui	s2,0x8
f9000448:	6d4000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f900044c:	c2190913          	addi	s2,s2,-991 # 7c21 <__stack_size+0x3c21>
f9000450:	00942223          	sw	s1,4(s0)
f9000454:	01242023          	sw	s2,0(s0)
f9000458:	00050a13          	mv	s4,a0
f900045c:	5f4000ef          	jal	ra,f9000a50 <mdio_wait_done>
f9000460:	f9001537          	lui	a0,0xf9001
f9000464:	7d050513          	addi	a0,a0,2000 # f90017d0 <__freertos_irq_stack_top+0xffffb0a0>
f9000468:	77c000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f900046c:	000a0513          	mv	a0,s4
f9000470:	7a8000ef          	jal	ra,f9000c18 <print_hex16_s>
f9000474:	aa898513          	addi	a0,s3,-1368
f9000478:	03d000ef          	jal	ra,f9000cb4 <println_s>
f900047c:	0a4387b7          	lui	a5,0xa438
f9000480:	00942223          	sw	s1,4(s0)
f9000484:	c2178793          	addi	a5,a5,-991 # a437c21 <__stack_size+0xa433c21>
f9000488:	00f42023          	sw	a5,0(s0)
f900048c:	5c4000ef          	jal	ra,f9000a50 <mdio_wait_done>
f9000490:	801177b7          	lui	a5,0x80117
f9000494:	00942223          	sw	s1,4(s0)
f9000498:	c2178793          	addi	a5,a5,-991 # 80116c21 <__freertos_irq_stack_top+0x871104f1>
f900049c:	00f42023          	sw	a5,0(s0)
f90004a0:	5b0000ef          	jal	ra,f9000a50 <mdio_wait_done>
f90004a4:	573f77b7          	lui	a5,0x573f7
f90004a8:	02178793          	addi	a5,a5,33 # 573f7021 <__stack_size+0x573f3021>
f90004ac:	00942223          	sw	s1,4(s0)
f90004b0:	00f42023          	sw	a5,0(s0)
f90004b4:	59c000ef          	jal	ra,f9000a50 <mdio_wait_done>
f90004b8:	00942223          	sw	s1,4(s0)
f90004bc:	01242023          	sw	s2,0(s0)
f90004c0:	590000ef          	jal	ra,f9000a50 <mdio_wait_done>
f90004c4:	f9001537          	lui	a0,0xf9001
f90004c8:	7d850513          	addi	a0,a0,2008 # f90017d8 <__freertos_irq_stack_top+0xffffb0a8>
f90004cc:	7e8000ef          	jal	ra,f9000cb4 <println_s>
f90004d0:	000027b7          	lui	a5,0x2
f90004d4:	00942223          	sw	s1,4(s0)
f90004d8:	42178793          	addi	a5,a5,1057 # 2421 <CUSTOM2+0x23c6>
f90004dc:	00f42023          	sw	a5,0(s0)
f90004e0:	570000ef          	jal	ra,f9000a50 <mdio_wait_done>
f90004e4:	01e117b7          	lui	a5,0x1e11
f90004e8:	00942223          	sw	s1,4(s0)
f90004ec:	02178793          	addi	a5,a5,33 # 1e11021 <__stack_size+0x1e0d021>
f90004f0:	00f42023          	sw	a5,0(s0)
f90004f4:	55c000ef          	jal	ra,f9000a50 <mdio_wait_done>
f90004f8:	120007b7          	lui	a5,0x12000
f90004fc:	00942223          	sw	s1,4(s0)
f9000500:	02178793          	addi	a5,a5,33 # 12000021 <__stack_size+0x11ffc021>
f9000504:	00f42023          	sw	a5,0(s0)
f9000508:	00018937          	lui	s2,0x18
f900050c:	00098413          	mv	s0,s3
f9000510:	540000ef          	jal	ra,f9000a50 <mdio_wait_done>
f9000514:	03c00493          	li	s1,60
f9000518:	6a090913          	addi	s2,s2,1696 # 186a0 <__stack_size+0x146a0>
f900051c:	02400993          	li	s3,36
f9000520:	f9002a37          	lui	s4,0xf9002
f9000524:	f8100ab7          	lui	s5,0xf8100
f9000528:	00090513          	mv	a0,s2
f900052c:	760000ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f9000530:	00100513          	li	a0,1
f9000534:	5e8000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f9000538:	00100513          	li	a0,1
f900053c:	5e0000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f9000540:	02457513          	andi	a0,a0,36
f9000544:	2d350463          	beq	a0,s3,f900080c <main+0x570>
f9000548:	a9ca0513          	addi	a0,s4,-1380 # f9001a9c <__freertos_irq_stack_top+0xffffb36c>
f900054c:	698000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f9000550:	004aa783          	lw	a5,4(s5) # f8100004 <__freertos_irq_stack_top+0xff0f98d4>
f9000554:	0017f793          	andi	a5,a5,1
f9000558:	fe078ce3          	beqz	a5,f9000550 <main+0x2b4>
f900055c:	fff48493          	addi	s1,s1,-1
f9000560:	fc0494e3          	bnez	s1,f9000528 <main+0x28c>
f9000564:	00000913          	li	s2,0
f9000568:	aa840513          	addi	a0,s0,-1368
f900056c:	748000ef          	jal	ra,f9000cb4 <println_s>
f9000570:	00100513          	li	a0,1
f9000574:	5a8000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f9000578:	00100513          	li	a0,1
f900057c:	5a0000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f9000580:	f8101a37          	lui	s4,0xf8101
f9000584:	00200a93          	li	s5,2
f9000588:	0a4387b7          	lui	a5,0xa438
f900058c:	c2178793          	addi	a5,a5,-991 # a437c21 <__stack_size+0xa433c21>
f9000590:	015a2223          	sw	s5,4(s4) # f8101004 <__freertos_irq_stack_top+0xff0fa8d4>
f9000594:	00fa2023          	sw	a5,0(s4)
f9000598:	00050493          	mv	s1,a0
f900059c:	4b4000ef          	jal	ra,f9000a50 <mdio_wait_done>
f90005a0:	3e800513          	li	a0,1000
f90005a4:	6e8000ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f90005a8:	01a00513          	li	a0,26
f90005ac:	570000ef          	jal	ra,f9000b1c <mdio_read.constprop.5>
f90005b0:	000087b7          	lui	a5,0x8
f90005b4:	c2178793          	addi	a5,a5,-991 # 7c21 <__stack_size+0x3c21>
f90005b8:	015a2223          	sw	s5,4(s4)
f90005bc:	00fa2023          	sw	a5,0(s4)
f90005c0:	00050993          	mv	s3,a0
f90005c4:	48c000ef          	jal	ra,f9000a50 <mdio_wait_done>
f90005c8:	f9001537          	lui	a0,0xf9001
f90005cc:	7f850513          	addi	a0,a0,2040 # f90017f8 <__freertos_irq_stack_top+0xffffb0c8>
f90005d0:	614000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f90005d4:	00048513          	mv	a0,s1
f90005d8:	640000ef          	jal	ra,f9000c18 <print_hex16_s>
f90005dc:	0044f793          	andi	a5,s1,4
f90005e0:	22079a63          	bnez	a5,f9000814 <main+0x578>
f90005e4:	f9001537          	lui	a0,0xf9001
f90005e8:	6e450513          	addi	a0,a0,1764 # f90016e4 <__freertos_irq_stack_top+0xffffafb4>
f90005ec:	5f8000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f90005f0:	0204f513          	andi	a0,s1,32
f90005f4:	22051663          	bnez	a0,f9000820 <main+0x584>
f90005f8:	f9001537          	lui	a0,0xf9001
f90005fc:	6f450513          	addi	a0,a0,1780 # f90016f4 <__freertos_irq_stack_top+0xffffafc4>
f9000600:	5e4000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f9000604:	aa840513          	addi	a0,s0,-1368
f9000608:	6ac000ef          	jal	ra,f9000cb4 <println_s>
f900060c:	f9002537          	lui	a0,0xf9002
f9000610:	80050513          	addi	a0,a0,-2048 # f9001800 <__freertos_irq_stack_top+0xffffb0d0>
f9000614:	5d0000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f9000618:	00098513          	mv	a0,s3
f900061c:	0049d493          	srli	s1,s3,0x4
f9000620:	5f8000ef          	jal	ra,f9000c18 <print_hex16_s>
f9000624:	0034f493          	andi	s1,s1,3
f9000628:	00200793          	li	a5,2
f900062c:	20f49063          	bne	s1,a5,f900082c <main+0x590>
f9000630:	f9002537          	lui	a0,0xf9002
f9000634:	80850513          	addi	a0,a0,-2040 # f9001808 <__freertos_irq_stack_top+0xffffb0d8>
f9000638:	5ac000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f900063c:	0089f513          	andi	a0,s3,8
f9000640:	20051663          	bnez	a0,f900084c <main+0x5b0>
f9000644:	f9001537          	lui	a0,0xf9001
f9000648:	70050513          	addi	a0,a0,1792 # f9001700 <__freertos_irq_stack_top+0xffffafd0>
f900064c:	598000ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f9000650:	aa840513          	addi	a0,s0,-1368
f9000654:	660000ef          	jal	ra,f9000cb4 <println_s>
f9000658:	20090063          	beqz	s2,f9000858 <main+0x5bc>
f900065c:	00100793          	li	a5,1
f9000660:	1ef49c63          	bne	s1,a5,f9000858 <main+0x5bc>
f9000664:	f9002537          	lui	a0,0xf9002
f9000668:	82050513          	addi	a0,a0,-2016 # f9001820 <__freertos_irq_stack_top+0xffffb0f0>
f900066c:	648000ef          	jal	ra,f9000cb4 <println_s>
f9000670:	f9002537          	lui	a0,0xf9002
f9000674:	87450513          	addi	a0,a0,-1932 # f9001874 <__freertos_irq_stack_top+0xffffb144>
f9000678:	63c000ef          	jal	ra,f9000cb4 <println_s>
f900067c:	8101d783          	lhu	a5,-2032(gp) # f9001b10 <MY_IP>
f9000680:	82818413          	addi	s0,gp,-2008 # f9001b28 <tx_frame>
f9000684:	00078d13          	mv	s10,a5
f9000688:	8101a783          	lw	a5,-2032(gp) # f9001b10 <MY_IP>
f900068c:	00000913          	li	s2,0
f9000690:	60040a13          	addi	s4,s0,1536
f9000694:	00078d93          	mv	s11,a5
f9000698:	f81027b7          	lui	a5,0xf8102
f900069c:	0047a703          	lw	a4,4(a5) # f8102004 <__freertos_irq_stack_top+0xff0fb8d4>
f90006a0:	00277713          	andi	a4,a4,2
f90006a4:	14070263          	beqz	a4,f90007e8 <main+0x54c>
f90006a8:	00c7ac83          	lw	s9,12(a5)
f90006ac:	5dc00693          	li	a3,1500
f90006b0:	010c9b93          	slli	s7,s9,0x10
f90006b4:	010bdb93          	srli	s7,s7,0x10
f90006b8:	ff2b8713          	addi	a4,s7,-14
f90006bc:	01071713          	slli	a4,a4,0x10
f90006c0:	01075713          	srli	a4,a4,0x10
f90006c4:	34e6e663          	bltu	a3,a4,f9000a10 <main+0x774>
f90006c8:	003b8713          	addi	a4,s7,3
f90006cc:	40275713          	srai	a4,a4,0x2
f90006d0:	f81036b7          	lui	a3,0xf8103
f90006d4:	000b8c93          	mv	s9,s7
f90006d8:	00271713          	slli	a4,a4,0x2
f90006dc:	00000793          	li	a5,0
f90006e0:	80068693          	addi	a3,a3,-2048 # f8102800 <__freertos_irq_stack_top+0xff0fc0d0>
f90006e4:	18f71063          	bne	a4,a5,f9000864 <main+0x5c8>
f90006e8:	f81027b7          	lui	a5,0xf8102
f90006ec:	00200713          	li	a4,2
f90006f0:	00e7a023          	sw	a4,0(a5) # f8102000 <__freertos_irq_stack_top+0xff0fb8d0>
f90006f4:	60c44783          	lbu	a5,1548(s0)
f90006f8:	60d44703          	lbu	a4,1549(s0)
f90006fc:	00879793          	slli	a5,a5,0x8
f9000700:	00e7e7b3          	or	a5,a5,a4
f9000704:	00001737          	lui	a4,0x1
f9000708:	80670713          	addi	a4,a4,-2042 # 806 <CUSTOM2+0x7ab>
f900070c:	16e79863          	bne	a5,a4,f900087c <main+0x5e0>
f9000710:	02900793          	li	a5,41
f9000714:	0d77fa63          	bgeu	a5,s7,f90007e8 <main+0x54c>
f9000718:	60f44703          	lbu	a4,1551(s0)
f900071c:	00100793          	li	a5,1
f9000720:	0cf71463          	bne	a4,a5,f90007e8 <main+0x54c>
f9000724:	61044683          	lbu	a3,1552(s0)
f9000728:	00800793          	li	a5,8
f900072c:	0af69e63          	bne	a3,a5,f90007e8 <main+0x54c>
f9000730:	61144683          	lbu	a3,1553(s0)
f9000734:	60e44783          	lbu	a5,1550(s0)
f9000738:	00d7e7b3          	or	a5,a5,a3
f900073c:	61444683          	lbu	a3,1556(s0)
f9000740:	00d7e7b3          	or	a5,a5,a3
f9000744:	0a079263          	bnez	a5,f90007e8 <main+0x54c>
f9000748:	61544783          	lbu	a5,1557(s0)
f900074c:	08e79e63          	bne	a5,a4,f90007e8 <main+0x54c>
f9000750:	00400613          	li	a2,4
f9000754:	81018593          	addi	a1,gp,-2032 # f9001b10 <MY_IP>
f9000758:	62640513          	addi	a0,s0,1574
f900075c:	99dff0ef          	jal	ra,f90000f8 <memcmp>
f9000760:	08051463          	bnez	a0,f90007e8 <main+0x54c>
f9000764:	61640a93          	addi	s5,s0,1558
f9000768:	00600613          	li	a2,6
f900076c:	000a8593          	mv	a1,s5
f9000770:	00040513          	mv	a0,s0
f9000774:	a0dff0ef          	jal	ra,f9000180 <memcpy>
f9000778:	00600613          	li	a2,6
f900077c:	81418593          	addi	a1,gp,-2028 # f9001b14 <MY_MAC>
f9000780:	00640513          	addi	a0,s0,6
f9000784:	9fdff0ef          	jal	ra,f9000180 <memcpy>
f9000788:	010007b7          	lui	a5,0x1000
f900078c:	60878793          	addi	a5,a5,1544 # 1000608 <__stack_size+0xffc608>
f9000790:	00f42623          	sw	a5,12(s0)
f9000794:	040607b7          	lui	a5,0x4060
f9000798:	00878793          	addi	a5,a5,8 # 4060008 <__stack_size+0x405c008>
f900079c:	00f42823          	sw	a5,16(s0)
f90007a0:	20000793          	li	a5,512
f90007a4:	00f41a23          	sh	a5,20(s0)
f90007a8:	00600613          	li	a2,6
f90007ac:	81418593          	addi	a1,gp,-2028 # f9001b14 <MY_MAC>
f90007b0:	01640513          	addi	a0,s0,22
f90007b4:	9cdff0ef          	jal	ra,f9000180 <memcpy>
f90007b8:	00600613          	li	a2,6
f90007bc:	01b42e23          	sw	s11,28(s0)
f90007c0:	000a8593          	mv	a1,s5
f90007c4:	02040513          	addi	a0,s0,32
f90007c8:	9b9ff0ef          	jal	ra,f9000180 <memcpy>
f90007cc:	61c45783          	lhu	a5,1564(s0)
f90007d0:	02a00513          	li	a0,42
f90007d4:	02f41323          	sh	a5,38(s0)
f90007d8:	61e45783          	lhu	a5,1566(s0)
f90007dc:	02f41423          	sh	a5,40(s0)
f90007e0:	2c0000ef          	jal	ra,f9000aa0 <eth_send_frame.constprop.3>
f90007e4:	250000ef          	jal	ra,f9000a34 <led_toggle>
f90007e8:	000317b7          	lui	a5,0x31
f90007ec:	00190913          	addi	s2,s2,1
f90007f0:	d4078793          	addi	a5,a5,-704 # 30d40 <__stack_size+0x2cd40>
f90007f4:	02f977b3          	remu	a5,s2,a5
f90007f8:	22079263          	bnez	a5,f9000a1c <main+0x780>
f90007fc:	f800d7b7          	lui	a5,0xf800d
f9000800:	00300713          	li	a4,3
f9000804:	00e7a223          	sw	a4,4(a5) # f800d004 <__freertos_irq_stack_top+0xff0068d4>
f9000808:	e91ff06f          	j	f9000698 <main+0x3fc>
f900080c:	00100913          	li	s2,1
f9000810:	d59ff06f          	j	f9000568 <main+0x2cc>
f9000814:	f9001537          	lui	a0,0xf9001
f9000818:	6dc50513          	addi	a0,a0,1756 # f90016dc <__freertos_irq_stack_top+0xffffafac>
f900081c:	dd1ff06f          	j	f90005ec <main+0x350>
f9000820:	f9001537          	lui	a0,0xf9001
f9000824:	6ec50513          	addi	a0,a0,1772 # f90016ec <__freertos_irq_stack_top+0xffffafbc>
f9000828:	dd9ff06f          	j	f9000600 <main+0x364>
f900082c:	00100793          	li	a5,1
f9000830:	00f49863          	bne	s1,a5,f9000840 <main+0x5a4>
f9000834:	f9002537          	lui	a0,0xf9002
f9000838:	81050513          	addi	a0,a0,-2032 # f9001810 <__freertos_irq_stack_top+0xffffb0e0>
f900083c:	dfdff06f          	j	f9000638 <main+0x39c>
f9000840:	f9002537          	lui	a0,0xf9002
f9000844:	81850513          	addi	a0,a0,-2024 # f9001818 <__freertos_irq_stack_top+0xffffb0e8>
f9000848:	df1ff06f          	j	f9000638 <main+0x39c>
f900084c:	f9001537          	lui	a0,0xf9001
f9000850:	6fc50513          	addi	a0,a0,1788 # f90016fc <__freertos_irq_stack_top+0xffffafcc>
f9000854:	df9ff06f          	j	f900064c <main+0x3b0>
f9000858:	f9002537          	lui	a0,0xf9002
f900085c:	84050513          	addi	a0,a0,-1984 # f9001840 <__freertos_irq_stack_top+0xffffb110>
f9000860:	e0dff06f          	j	f900066c <main+0x3d0>
f9000864:	00d78633          	add	a2,a5,a3
f9000868:	00062583          	lw	a1,0(a2)
f900086c:	00fa0633          	add	a2,s4,a5
f9000870:	00478793          	addi	a5,a5,4
f9000874:	00b62023          	sw	a1,0(a2)
f9000878:	e6dff06f          	j	f90006e4 <main+0x448>
f900087c:	80078793          	addi	a5,a5,-2048
f9000880:	f60794e3          	bnez	a5,f90007e8 <main+0x54c>
f9000884:	02100793          	li	a5,33
f9000888:	f777f0e3          	bgeu	a5,s7,f90007e8 <main+0x54c>
f900088c:	60e44b03          	lbu	s6,1550(s0)
f9000890:	00400793          	li	a5,4
f9000894:	004b5713          	srli	a4,s6,0x4
f9000898:	f4f718e3          	bne	a4,a5,f90007e8 <main+0x54c>
f900089c:	00fb7b13          	andi	s6,s6,15
f90008a0:	002b1b13          	slli	s6,s6,0x2
f90008a4:	01300793          	li	a5,19
f90008a8:	f567f0e3          	bgeu	a5,s6,f90007e8 <main+0x54c>
f90008ac:	00db0793          	addi	a5,s6,13
f90008b0:	f397dce3          	bge	a5,s9,f90007e8 <main+0x54c>
f90008b4:	00400613          	li	a2,4
f90008b8:	81018593          	addi	a1,gp,-2032 # f9001b10 <MY_IP>
f90008bc:	61e40513          	addi	a0,s0,1566
f90008c0:	839ff0ef          	jal	ra,f90000f8 <memcmp>
f90008c4:	00050c13          	mv	s8,a0
f90008c8:	f20510e3          	bnez	a0,f90007e8 <main+0x54c>
f90008cc:	61744703          	lbu	a4,1559(s0)
f90008d0:	00100793          	li	a5,1
f90008d4:	f0f71ae3          	bne	a4,a5,f90007e8 <main+0x54c>
f90008d8:	00eb0a93          	addi	s5,s6,14
f90008dc:	007a8793          	addi	a5,s5,7
f90008e0:	f197d4e3          	bge	a5,s9,f90007e8 <main+0x54c>
f90008e4:	015407b3          	add	a5,s0,s5
f90008e8:	6007c683          	lbu	a3,1536(a5)
f90008ec:	00800713          	li	a4,8
f90008f0:	eee69ce3          	bne	a3,a4,f90007e8 <main+0x54c>
f90008f4:	6017c783          	lbu	a5,1537(a5)
f90008f8:	ee0798e3          	bnez	a5,f90007e8 <main+0x54c>
f90008fc:	000c8613          	mv	a2,s9
f9000900:	000a0593          	mv	a1,s4
f9000904:	00040513          	mv	a0,s0
f9000908:	879ff0ef          	jal	ra,f9000180 <memcpy>
f900090c:	00600613          	li	a2,6
f9000910:	60640593          	addi	a1,s0,1542
f9000914:	00040513          	mv	a0,s0
f9000918:	869ff0ef          	jal	ra,f9000180 <memcpy>
f900091c:	00600613          	li	a2,6
f9000920:	81418593          	addi	a1,gp,-2028 # f9001b14 <MY_MAC>
f9000924:	00640513          	addi	a0,s0,6
f9000928:	859ff0ef          	jal	ra,f9000180 <memcpy>
f900092c:	81018793          	addi	a5,gp,-2032 # f9001b10 <MY_IP>
f9000930:	0027d783          	lhu	a5,2(a5)
f9000934:	01a41d23          	sh	s10,26(s0)
f9000938:	00041c23          	sh	zero,24(s0)
f900093c:	00f41e23          	sh	a5,28(s0)
f9000940:	61a45783          	lhu	a5,1562(s0)
f9000944:	00040693          	mv	a3,s0
f9000948:	00f41f23          	sh	a5,30(s0)
f900094c:	61c45783          	lhu	a5,1564(s0)
f9000950:	02f41023          	sh	a5,32(s0)
f9000954:	00000793          	li	a5,0
f9000958:	00e6c703          	lbu	a4,14(a3)
f900095c:	00f6c603          	lbu	a2,15(a3)
f9000960:	002c0c13          	addi	s8,s8,2
f9000964:	00871713          	slli	a4,a4,0x8
f9000968:	00c76733          	or	a4,a4,a2
f900096c:	00e787b3          	add	a5,a5,a4
f9000970:	00268693          	addi	a3,a3,2
f9000974:	ff6c42e3          	blt	s8,s6,f9000958 <main+0x6bc>
f9000978:	00010637          	lui	a2,0x10
f900097c:	fff60613          	addi	a2,a2,-1 # ffff <__stack_size+0xbfff>
f9000980:	0107d713          	srli	a4,a5,0x10
f9000984:	08071063          	bnez	a4,f9000a04 <main+0x768>
f9000988:	00c7c7b3          	xor	a5,a5,a2
f900098c:	00879713          	slli	a4,a5,0x8
f9000990:	01079793          	slli	a5,a5,0x10
f9000994:	0107d793          	srli	a5,a5,0x10
f9000998:	0087d793          	srli	a5,a5,0x8
f900099c:	00f767b3          	or	a5,a4,a5
f90009a0:	00f41c23          	sh	a5,24(s0)
f90009a4:	002a8693          	addi	a3,s5,2
f90009a8:	015407b3          	add	a5,s0,s5
f90009ac:	00078023          	sb	zero,0(a5)
f90009b0:	003a8a93          	addi	s5,s5,3
f90009b4:	00d407b3          	add	a5,s0,a3
f90009b8:	0007c703          	lbu	a4,0(a5)
f90009bc:	015407b3          	add	a5,s0,s5
f90009c0:	0007c783          	lbu	a5,0(a5)
f90009c4:	00871713          	slli	a4,a4,0x8
f90009c8:	000105b7          	lui	a1,0x10
f90009cc:	00f76733          	or	a4,a4,a5
f90009d0:	000017b7          	lui	a5,0x1
f90009d4:	80078793          	addi	a5,a5,-2048 # 800 <CUSTOM2+0x7a5>
f90009d8:	00f707b3          	add	a5,a4,a5
f90009dc:	00b7e663          	bltu	a5,a1,f90009e8 <main+0x74c>
f90009e0:	00c7f7b3          	and	a5,a5,a2
f90009e4:	00178793          	addi	a5,a5,1
f90009e8:	00d406b3          	add	a3,s0,a3
f90009ec:	0087d713          	srli	a4,a5,0x8
f90009f0:	00e68023          	sb	a4,0(a3)
f90009f4:	01540ab3          	add	s5,s0,s5
f90009f8:	00fa8023          	sb	a5,0(s5)
f90009fc:	000b8513          	mv	a0,s7
f9000a00:	de1ff06f          	j	f90007e0 <main+0x544>
f9000a04:	00c7f7b3          	and	a5,a5,a2
f9000a08:	00e787b3          	add	a5,a5,a4
f9000a0c:	f75ff06f          	j	f9000980 <main+0x6e4>
f9000a10:	00200713          	li	a4,2
f9000a14:	00e7a023          	sw	a4,0(a5)
f9000a18:	dd1ff06f          	j	f90007e8 <main+0x54c>
f9000a1c:	00018737          	lui	a4,0x18
f9000a20:	6a070713          	addi	a4,a4,1696 # 186a0 <__stack_size+0x146a0>
f9000a24:	c6e79ae3          	bne	a5,a4,f9000698 <main+0x3fc>
f9000a28:	f800d7b7          	lui	a5,0xf800d
f9000a2c:	00200713          	li	a4,2
f9000a30:	dd5ff06f          	j	f9000804 <main+0x568>

f9000a34 <led_toggle>:
f9000a34:	8241a783          	lw	a5,-2012(gp) # f9001b24 <__bss_start>
f9000a38:	0017b793          	seqz	a5,a5
f9000a3c:	82f1a223          	sw	a5,-2012(gp) # f9001b24 <__bss_start>
f9000a40:	00278793          	addi	a5,a5,2 # f800d002 <__freertos_irq_stack_top+0xff0068d2>
f9000a44:	f800d737          	lui	a4,0xf800d
f9000a48:	00f72223          	sw	a5,4(a4) # f800d004 <__freertos_irq_stack_top+0xff0068d4>
f9000a4c:	00008067          	ret

f9000a50 <mdio_wait_done>:
f9000a50:	7d000793          	li	a5,2000
f9000a54:	f81016b7          	lui	a3,0xf8101
f9000a58:	0046a703          	lw	a4,4(a3) # f8101004 <__freertos_irq_stack_top+0xff0fa8d4>
f9000a5c:	00177713          	andi	a4,a4,1
f9000a60:	00071a63          	bnez	a4,f9000a74 <mdio_wait_done+0x24>
f9000a64:	fff78793          	addi	a5,a5,-1
f9000a68:	fe0798e3          	bnez	a5,f9000a58 <mdio_wait_done+0x8>
f9000a6c:	00000513          	li	a0,0
f9000a70:	00008067          	ret
f9000a74:	0007a7b7          	lui	a5,0x7a
f9000a78:	12078793          	addi	a5,a5,288 # 7a120 <__stack_size+0x76120>
f9000a7c:	f81016b7          	lui	a3,0xf8101
f9000a80:	0046a703          	lw	a4,4(a3) # f8101004 <__freertos_irq_stack_top+0xff0fa8d4>
f9000a84:	00277713          	andi	a4,a4,2
f9000a88:	00071863          	bnez	a4,f9000a98 <mdio_wait_done+0x48>
f9000a8c:	fff78793          	addi	a5,a5,-1
f9000a90:	fe0798e3          	bnez	a5,f9000a80 <mdio_wait_done+0x30>
f9000a94:	fd9ff06f          	j	f9000a6c <mdio_wait_done+0x1c>
f9000a98:	00100513          	li	a0,1
f9000a9c:	00008067          	ret

f9000aa0 <eth_send_frame.constprop.3>:
f9000aa0:	5ea00713          	li	a4,1514
f9000aa4:	00050793          	mv	a5,a0
f9000aa8:	00a77463          	bgeu	a4,a0,f9000ab0 <eth_send_frame.constprop.3+0x10>
f9000aac:	5ea00793          	li	a5,1514
f9000ab0:	01079693          	slli	a3,a5,0x10
f9000ab4:	0106d693          	srli	a3,a3,0x10
f9000ab8:	03c00713          	li	a4,60
f9000abc:	00e6f463          	bgeu	a3,a4,f9000ac4 <eth_send_frame.constprop.3+0x24>
f9000ac0:	03c00793          	li	a5,60
f9000ac4:	01079793          	slli	a5,a5,0x10
f9000ac8:	0107d793          	srli	a5,a5,0x10
f9000acc:	f81026b7          	lui	a3,0xf8102
f9000ad0:	0046a703          	lw	a4,4(a3) # f8102004 <__freertos_irq_stack_top+0xff0fb8d4>
f9000ad4:	00177713          	andi	a4,a4,1
f9000ad8:	fe071ce3          	bnez	a4,f9000ad0 <eth_send_frame.constprop.3+0x30>
f9000adc:	00378693          	addi	a3,a5,3
f9000ae0:	4026d693          	srai	a3,a3,0x2
f9000ae4:	f8102637          	lui	a2,0xf8102
f9000ae8:	00269693          	slli	a3,a3,0x2
f9000aec:	08060893          	addi	a7,a2,128 # f8102080 <__freertos_irq_stack_top+0xff0fb950>
f9000af0:	82818593          	addi	a1,gp,-2008 # f9001b28 <tx_frame>
f9000af4:	00e58833          	add	a6,a1,a4
f9000af8:	00082803          	lw	a6,0(a6)
f9000afc:	01170533          	add	a0,a4,a7
f9000b00:	00470713          	addi	a4,a4,4
f9000b04:	01052023          	sw	a6,0(a0)
f9000b08:	fed716e3          	bne	a4,a3,f9000af4 <eth_send_frame.constprop.3+0x54>
f9000b0c:	00f62423          	sw	a5,8(a2)
f9000b10:	00100793          	li	a5,1
f9000b14:	00f62023          	sw	a5,0(a2)
f9000b18:	00008067          	ret

f9000b1c <mdio_read.constprop.5>:
f9000b1c:	ff010113          	addi	sp,sp,-16
f9000b20:	00812423          	sw	s0,8(sp)
f9000b24:	00112623          	sw	ra,12(sp)
f9000b28:	f8101437          	lui	s0,0xf8101
f9000b2c:	00200793          	li	a5,2
f9000b30:	00a51513          	slli	a0,a0,0xa
f9000b34:	00f42223          	sw	a5,4(s0) # f8101004 <__freertos_irq_stack_top+0xff0fa8d4>
f9000b38:	02356513          	ori	a0,a0,35
f9000b3c:	00a42023          	sw	a0,0(s0)
f9000b40:	f11ff0ef          	jal	ra,f9000a50 <mdio_wait_done>
f9000b44:	00050e63          	beqz	a0,f9000b60 <mdio_read.constprop.5+0x44>
f9000b48:	00442503          	lw	a0,4(s0)
f9000b4c:	01055513          	srli	a0,a0,0x10
f9000b50:	00c12083          	lw	ra,12(sp)
f9000b54:	00812403          	lw	s0,8(sp)
f9000b58:	01010113          	addi	sp,sp,16
f9000b5c:	00008067          	ret
f9000b60:	00010537          	lui	a0,0x10
f9000b64:	fff50513          	addi	a0,a0,-1 # ffff <__stack_size+0xbfff>
f9000b68:	fe9ff06f          	j	f9000b50 <mdio_read.constprop.5+0x34>

f9000b6c <uart_mini_tx_byte>:
f9000b6c:	f8100737          	lui	a4,0xf8100
f9000b70:	00472783          	lw	a5,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0f98d4>
f9000b74:	0027f793          	andi	a5,a5,2
f9000b78:	02079c63          	bnez	a5,f9000bb0 <uart_mini_tx_byte+0x44>
f9000b7c:	000067b7          	lui	a5,0x6
f9000b80:	ff010113          	addi	sp,sp,-16
f9000b84:	00a72423          	sw	a0,8(a4)
f9000b88:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9000b8c:	00f12623          	sw	a5,12(sp)
f9000b90:	00c12783          	lw	a5,12(sp)
f9000b94:	fff78713          	addi	a4,a5,-1
f9000b98:	00e12623          	sw	a4,12(sp)
f9000b9c:	00079863          	bnez	a5,f9000bac <uart_mini_tx_byte+0x40>
f9000ba0:	00100513          	li	a0,1
f9000ba4:	01010113          	addi	sp,sp,16
f9000ba8:	00008067          	ret
f9000bac:	fe5ff06f          	j	f9000b90 <uart_mini_tx_byte+0x24>
f9000bb0:	00000513          	li	a0,0
f9000bb4:	00008067          	ret

f9000bb8 <uart_mini_tx_byte_blocking>:
f9000bb8:	ff010113          	addi	sp,sp,-16
f9000bbc:	00812423          	sw	s0,8(sp)
f9000bc0:	00112623          	sw	ra,12(sp)
f9000bc4:	00050413          	mv	s0,a0
f9000bc8:	00040513          	mv	a0,s0
f9000bcc:	fa1ff0ef          	jal	ra,f9000b6c <uart_mini_tx_byte>
f9000bd0:	fe050ce3          	beqz	a0,f9000bc8 <uart_mini_tx_byte_blocking+0x10>
f9000bd4:	00c12083          	lw	ra,12(sp)
f9000bd8:	00812403          	lw	s0,8(sp)
f9000bdc:	01010113          	addi	sp,sp,16
f9000be0:	00008067          	ret

f9000be4 <uart_mini_tx_string>:
f9000be4:	ff010113          	addi	sp,sp,-16
f9000be8:	00812423          	sw	s0,8(sp)
f9000bec:	00112623          	sw	ra,12(sp)
f9000bf0:	00050413          	mv	s0,a0
f9000bf4:	00044503          	lbu	a0,0(s0)
f9000bf8:	00051a63          	bnez	a0,f9000c0c <uart_mini_tx_string+0x28>
f9000bfc:	00c12083          	lw	ra,12(sp)
f9000c00:	00812403          	lw	s0,8(sp)
f9000c04:	01010113          	addi	sp,sp,16
f9000c08:	00008067          	ret
f9000c0c:	fadff0ef          	jal	ra,f9000bb8 <uart_mini_tx_byte_blocking>
f9000c10:	00140413          	addi	s0,s0,1
f9000c14:	fe1ff06f          	j	f9000bf4 <uart_mini_tx_string+0x10>

f9000c18 <print_hex16_s>:
f9000c18:	ff010113          	addi	sp,sp,-16
f9000c1c:	00812423          	sw	s0,8(sp)
f9000c20:	f9001437          	lui	s0,0xf9001
f9000c24:	6c840413          	addi	s0,s0,1736 # f90016c8 <__freertos_irq_stack_top+0xffffaf98>
f9000c28:	00c55793          	srli	a5,a0,0xc
f9000c2c:	00f407b3          	add	a5,s0,a5
f9000c30:	00912223          	sw	s1,4(sp)
f9000c34:	00050493          	mv	s1,a0
f9000c38:	0007c503          	lbu	a0,0(a5)
f9000c3c:	00112623          	sw	ra,12(sp)
f9000c40:	f2dff0ef          	jal	ra,f9000b6c <uart_mini_tx_byte>
f9000c44:	0084d793          	srli	a5,s1,0x8
f9000c48:	00f7f793          	andi	a5,a5,15
f9000c4c:	00f407b3          	add	a5,s0,a5
f9000c50:	0007c503          	lbu	a0,0(a5)
f9000c54:	f19ff0ef          	jal	ra,f9000b6c <uart_mini_tx_byte>
f9000c58:	0044d793          	srli	a5,s1,0x4
f9000c5c:	00f7f793          	andi	a5,a5,15
f9000c60:	00f407b3          	add	a5,s0,a5
f9000c64:	0007c503          	lbu	a0,0(a5)
f9000c68:	00f4f493          	andi	s1,s1,15
f9000c6c:	00940433          	add	s0,s0,s1
f9000c70:	efdff0ef          	jal	ra,f9000b6c <uart_mini_tx_byte>
f9000c74:	00044503          	lbu	a0,0(s0)
f9000c78:	00812403          	lw	s0,8(sp)
f9000c7c:	00c12083          	lw	ra,12(sp)
f9000c80:	00412483          	lw	s1,4(sp)
f9000c84:	01010113          	addi	sp,sp,16
f9000c88:	ee5ff06f          	j	f9000b6c <uart_mini_tx_byte>

f9000c8c <clint_uDelay.constprop.7>:
f9000c8c:	f8b0c7b7          	lui	a5,0xf8b0c
f9000c90:	ff87a703          	lw	a4,-8(a5) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9000c94:	03200793          	li	a5,50
f9000c98:	02f50533          	mul	a0,a0,a5
f9000c9c:	00e50533          	add	a0,a0,a4
f9000ca0:	f8b0c737          	lui	a4,0xf8b0c
f9000ca4:	ff872783          	lw	a5,-8(a4) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9000ca8:	40f507b3          	sub	a5,a0,a5
f9000cac:	fe07dce3          	bgez	a5,f9000ca4 <clint_uDelay.constprop.7+0x18>
f9000cb0:	00008067          	ret

f9000cb4 <println_s>:
f9000cb4:	ff010113          	addi	sp,sp,-16
f9000cb8:	00112623          	sw	ra,12(sp)
f9000cbc:	f29ff0ef          	jal	ra,f9000be4 <uart_mini_tx_string>
f9000cc0:	00d00513          	li	a0,13
f9000cc4:	ef5ff0ef          	jal	ra,f9000bb8 <uart_mini_tx_byte_blocking>
f9000cc8:	00a00513          	li	a0,10
f9000ccc:	eedff0ef          	jal	ra,f9000bb8 <uart_mini_tx_byte_blocking>
f9000cd0:	f8100737          	lui	a4,0xf8100
f9000cd4:	00472783          	lw	a5,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0f98d4>
f9000cd8:	0017f793          	andi	a5,a5,1
f9000cdc:	fe078ce3          	beqz	a5,f9000cd4 <println_s+0x20>
f9000ce0:	00c12083          	lw	ra,12(sp)
f9000ce4:	01010113          	addi	sp,sp,16
f9000ce8:	00008067          	ret

f9000cec <trap>:
f9000cec:	fe010113          	addi	sp,sp,-32
f9000cf0:	00812c23          	sw	s0,24(sp)
f9000cf4:	00912a23          	sw	s1,20(sp)
f9000cf8:	00018437          	lui	s0,0x18
f9000cfc:	f800d4b7          	lui	s1,0xf800d
f9000d00:	01212823          	sw	s2,16(sp)
f9000d04:	01312623          	sw	s3,12(sp)
f9000d08:	00112e23          	sw	ra,28(sp)
f9000d0c:	00448493          	addi	s1,s1,4 # f800d004 <__freertos_irq_stack_top+0xff0068d4>
f9000d10:	00300993          	li	s3,3
f9000d14:	6a040413          	addi	s0,s0,1696 # 186a0 <__stack_size+0x146a0>
f9000d18:	00200913          	li	s2,2
f9000d1c:	00040513          	mv	a0,s0
f9000d20:	0134a023          	sw	s3,0(s1)
f9000d24:	f69ff0ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f9000d28:	00040513          	mv	a0,s0
f9000d2c:	0124a023          	sw	s2,0(s1)
f9000d30:	f5dff0ef          	jal	ra,f9000c8c <clint_uDelay.constprop.7>
f9000d34:	fe9ff06f          	j	f9000d1c <trap+0x30>

f9000d38 <uart_mini_tx_byte>:
f9000d38:	f8100737          	lui	a4,0xf8100
f9000d3c:	00472783          	lw	a5,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0f98d4>
f9000d40:	0027f793          	andi	a5,a5,2
f9000d44:	02079c63          	bnez	a5,f9000d7c <uart_mini_tx_byte+0x44>
f9000d48:	000067b7          	lui	a5,0x6
f9000d4c:	ff010113          	addi	sp,sp,-16
f9000d50:	00a72423          	sw	a0,8(a4)
f9000d54:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9000d58:	00f12623          	sw	a5,12(sp)
f9000d5c:	00c12783          	lw	a5,12(sp)
f9000d60:	fff78713          	addi	a4,a5,-1
f9000d64:	00e12623          	sw	a4,12(sp)
f9000d68:	00079863          	bnez	a5,f9000d78 <uart_mini_tx_byte+0x40>
f9000d6c:	00100513          	li	a0,1
f9000d70:	01010113          	addi	sp,sp,16
f9000d74:	00008067          	ret
f9000d78:	fe5ff06f          	j	f9000d5c <uart_mini_tx_byte+0x24>
f9000d7c:	00000513          	li	a0,0
f9000d80:	00008067          	ret

f9000d84 <uart_mini_tx_byte_blocking>:
f9000d84:	ff010113          	addi	sp,sp,-16
f9000d88:	00812423          	sw	s0,8(sp)
f9000d8c:	00112623          	sw	ra,12(sp)
f9000d90:	00050413          	mv	s0,a0
f9000d94:	00040513          	mv	a0,s0
f9000d98:	fa1ff0ef          	jal	ra,f9000d38 <uart_mini_tx_byte>
f9000d9c:	fe050ce3          	beqz	a0,f9000d94 <uart_mini_tx_byte_blocking+0x10>
f9000da0:	00c12083          	lw	ra,12(sp)
f9000da4:	00812403          	lw	s0,8(sp)
f9000da8:	01010113          	addi	sp,sp,16
f9000dac:	00008067          	ret

f9000db0 <uart_mini_tx_string>:
f9000db0:	ff010113          	addi	sp,sp,-16
f9000db4:	00812423          	sw	s0,8(sp)
f9000db8:	00112623          	sw	ra,12(sp)
f9000dbc:	00050413          	mv	s0,a0
f9000dc0:	00044503          	lbu	a0,0(s0)
f9000dc4:	00051a63          	bnez	a0,f9000dd8 <uart_mini_tx_string+0x28>
f9000dc8:	00c12083          	lw	ra,12(sp)
f9000dcc:	00812403          	lw	s0,8(sp)
f9000dd0:	01010113          	addi	sp,sp,16
f9000dd4:	00008067          	ret
f9000dd8:	fadff0ef          	jal	ra,f9000d84 <uart_mini_tx_byte_blocking>
f9000ddc:	00140413          	addi	s0,s0,1
f9000de0:	fe1ff06f          	j	f9000dc0 <uart_mini_tx_string+0x10>

f9000de4 <uart_drain>:
f9000de4:	f8100737          	lui	a4,0xf8100
f9000de8:	00472783          	lw	a5,4(a4) # f8100004 <__freertos_irq_stack_top+0xff0f98d4>
f9000dec:	0017f793          	andi	a5,a5,1
f9000df0:	fe078ce3          	beqz	a5,f9000de8 <uart_drain+0x4>
f9000df4:	f8b0c7b7          	lui	a5,0xf8b0c
f9000df8:	ff87a703          	lw	a4,-8(a5) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9000dfc:	000187b7          	lui	a5,0x18
f9000e00:	6a078793          	addi	a5,a5,1696 # 186a0 <__stack_size+0x146a0>
f9000e04:	00f70733          	add	a4,a4,a5
f9000e08:	f8b0c6b7          	lui	a3,0xf8b0c
f9000e0c:	ff86a783          	lw	a5,-8(a3) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9000e10:	40f707b3          	sub	a5,a4,a5
f9000e14:	fe07dce3          	bgez	a5,f9000e0c <uart_drain+0x28>
f9000e18:	00008067          	ret

f9000e1c <cam_i2c_txbyte_ack>:
f9000e1c:	000017b7          	lui	a5,0x1
f9000e20:	fe010113          	addi	sp,sp,-32
f9000e24:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
f9000e28:	00112e23          	sw	ra,28(sp)
f9000e2c:	00f56533          	or	a0,a0,a5
f9000e30:	f800a7b7          	lui	a5,0xf800a
f9000e34:	00a7a023          	sw	a0,0(a5) # f800a000 <__freertos_irq_stack_top+0xff0038d0>
f9000e38:	30100713          	li	a4,769
f9000e3c:	00e7a223          	sw	a4,4(a5)
f9000e40:	000f47b7          	lui	a5,0xf4
f9000e44:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf0240>
f9000e48:	00f12623          	sw	a5,12(sp)
f9000e4c:	f800a737          	lui	a4,0xf800a
f9000e50:	00472783          	lw	a5,4(a4) # f800a004 <__freertos_irq_stack_top+0xff0038d4>
f9000e54:	1007f793          	andi	a5,a5,256
f9000e58:	00079c63          	bnez	a5,f9000e70 <cam_i2c_txbyte_ack+0x54>
f9000e5c:	00c72503          	lw	a0,12(a4)
f9000e60:	0ff57513          	andi	a0,a0,255
f9000e64:	00a03533          	snez	a0,a0
f9000e68:	40a00533          	neg	a0,a0
f9000e6c:	0280006f          	j	f9000e94 <cam_i2c_txbyte_ack+0x78>
f9000e70:	00c12783          	lw	a5,12(sp)
f9000e74:	fff78793          	addi	a5,a5,-1
f9000e78:	00f12623          	sw	a5,12(sp)
f9000e7c:	fc079ae3          	bnez	a5,f9000e50 <cam_i2c_txbyte_ack+0x34>
f9000e80:	f9002537          	lui	a0,0xf9002
f9000e84:	8b450513          	addi	a0,a0,-1868 # f90018b4 <__freertos_irq_stack_top+0xffffb184>
f9000e88:	f29ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9000e8c:	f59ff0ef          	jal	ra,f9000de4 <uart_drain>
f9000e90:	fff00513          	li	a0,-1
f9000e94:	01c12083          	lw	ra,28(sp)
f9000e98:	02010113          	addi	sp,sp,32
f9000e9c:	00008067          	ret

f9000ea0 <cam_i2c_stop>:
f9000ea0:	fe010113          	addi	sp,sp,-32
f9000ea4:	f800a7b7          	lui	a5,0xf800a
f9000ea8:	42000713          	li	a4,1056
f9000eac:	00112e23          	sw	ra,28(sp)
f9000eb0:	04e7a023          	sw	a4,64(a5) # f800a040 <__freertos_irq_stack_top+0xff003910>
f9000eb4:	001e87b7          	lui	a5,0x1e8
f9000eb8:	48078793          	addi	a5,a5,1152 # 1e8480 <__stack_size+0x1e4480>
f9000ebc:	00f12623          	sw	a5,12(sp)
f9000ec0:	f800a737          	lui	a4,0xf800a
f9000ec4:	04072783          	lw	a5,64(a4) # f800a040 <__freertos_irq_stack_top+0xff003910>
f9000ec8:	0017f793          	andi	a5,a5,1
f9000ecc:	00079863          	bnez	a5,f9000edc <cam_i2c_stop+0x3c>
f9000ed0:	01c12083          	lw	ra,28(sp)
f9000ed4:	02010113          	addi	sp,sp,32
f9000ed8:	00008067          	ret
f9000edc:	00c12783          	lw	a5,12(sp)
f9000ee0:	fff78793          	addi	a5,a5,-1
f9000ee4:	00f12623          	sw	a5,12(sp)
f9000ee8:	fc079ee3          	bnez	a5,f9000ec4 <cam_i2c_stop+0x24>
f9000eec:	f9002537          	lui	a0,0xf9002
f9000ef0:	8c050513          	addi	a0,a0,-1856 # f90018c0 <__freertos_irq_stack_top+0xffffb190>
f9000ef4:	ebdff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9000ef8:	01c12083          	lw	ra,28(sp)
f9000efc:	02010113          	addi	sp,sp,32
f9000f00:	ee5ff06f          	j	f9000de4 <uart_drain>

f9000f04 <print>:
f9000f04:	eadff06f          	j	f9000db0 <uart_mini_tx_string>

f9000f08 <println>:
f9000f08:	ff010113          	addi	sp,sp,-16
f9000f0c:	00112623          	sw	ra,12(sp)
f9000f10:	ea1ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9000f14:	00d00513          	li	a0,13
f9000f18:	e6dff0ef          	jal	ra,f9000d84 <uart_mini_tx_byte_blocking>
f9000f1c:	00a00513          	li	a0,10
f9000f20:	e65ff0ef          	jal	ra,f9000d84 <uart_mini_tx_byte_blocking>
f9000f24:	00c12083          	lw	ra,12(sp)
f9000f28:	01010113          	addi	sp,sp,16
f9000f2c:	eb9ff06f          	j	f9000de4 <uart_drain>

f9000f30 <print_hex8>:
f9000f30:	ff010113          	addi	sp,sp,-16
f9000f34:	00812423          	sw	s0,8(sp)
f9000f38:	f9002437          	lui	s0,0xf9002
f9000f3c:	8a040413          	addi	s0,s0,-1888 # f90018a0 <__freertos_irq_stack_top+0xffffb170>
f9000f40:	00455793          	srli	a5,a0,0x4
f9000f44:	00f407b3          	add	a5,s0,a5
f9000f48:	00912223          	sw	s1,4(sp)
f9000f4c:	00050493          	mv	s1,a0
f9000f50:	0007c503          	lbu	a0,0(a5)
f9000f54:	00f4f493          	andi	s1,s1,15
f9000f58:	00112623          	sw	ra,12(sp)
f9000f5c:	00940433          	add	s0,s0,s1
f9000f60:	dd9ff0ef          	jal	ra,f9000d38 <uart_mini_tx_byte>
f9000f64:	00044503          	lbu	a0,0(s0)
f9000f68:	00812403          	lw	s0,8(sp)
f9000f6c:	00c12083          	lw	ra,12(sp)
f9000f70:	00412483          	lw	s1,4(sp)
f9000f74:	01010113          	addi	sp,sp,16
f9000f78:	dc1ff06f          	j	f9000d38 <uart_mini_tx_byte>

f9000f7c <print_hex16>:
f9000f7c:	ff010113          	addi	sp,sp,-16
f9000f80:	00812423          	sw	s0,8(sp)
f9000f84:	00050413          	mv	s0,a0
f9000f88:	00855513          	srli	a0,a0,0x8
f9000f8c:	00112623          	sw	ra,12(sp)
f9000f90:	fa1ff0ef          	jal	ra,f9000f30 <print_hex8>
f9000f94:	0ff47513          	andi	a0,s0,255
f9000f98:	00812403          	lw	s0,8(sp)
f9000f9c:	00c12083          	lw	ra,12(sp)
f9000fa0:	01010113          	addi	sp,sp,16
f9000fa4:	f8dff06f          	j	f9000f30 <print_hex8>

f9000fa8 <print_hex32>:
f9000fa8:	ff010113          	addi	sp,sp,-16
f9000fac:	00812423          	sw	s0,8(sp)
f9000fb0:	00050413          	mv	s0,a0
f9000fb4:	01055513          	srli	a0,a0,0x10
f9000fb8:	00112623          	sw	ra,12(sp)
f9000fbc:	fc1ff0ef          	jal	ra,f9000f7c <print_hex16>
f9000fc0:	01041513          	slli	a0,s0,0x10
f9000fc4:	00812403          	lw	s0,8(sp)
f9000fc8:	00c12083          	lw	ra,12(sp)
f9000fcc:	01055513          	srli	a0,a0,0x10
f9000fd0:	01010113          	addi	sp,sp,16
f9000fd4:	fa9ff06f          	j	f9000f7c <print_hex16>

f9000fd8 <dbg_i2c_status>:
f9000fd8:	ff010113          	addi	sp,sp,-16
f9000fdc:	f800a7b7          	lui	a5,0xf800a
f9000fe0:	00812423          	sw	s0,8(sp)
f9000fe4:	f9002537          	lui	a0,0xf9002
f9000fe8:	0407a403          	lw	s0,64(a5) # f800a040 <__freertos_irq_stack_top+0xff003910>
f9000fec:	8cc50513          	addi	a0,a0,-1844 # f90018cc <__freertos_irq_stack_top+0xffffb19c>
f9000ff0:	00112623          	sw	ra,12(sp)
f9000ff4:	dbdff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9000ff8:	00040513          	mv	a0,s0
f9000ffc:	fadff0ef          	jal	ra,f9000fa8 <print_hex32>
f9001000:	f9002537          	lui	a0,0xf9002
f9001004:	8d850513          	addi	a0,a0,-1832 # f90018d8 <__freertos_irq_stack_top+0xffffb1a8>
f9001008:	da9ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f900100c:	00812403          	lw	s0,8(sp)
f9001010:	00c12083          	lw	ra,12(sp)
f9001014:	01010113          	addi	sp,sp,16
f9001018:	dcdff06f          	j	f9000de4 <uart_drain>

f900101c <cam_write_reg8>:
f900101c:	fd010113          	addi	sp,sp,-48
f9001020:	02812423          	sw	s0,40(sp)
f9001024:	02912223          	sw	s1,36(sp)
f9001028:	f800a7b7          	lui	a5,0xf800a
f900102c:	21000713          	li	a4,528
f9001030:	02112623          	sw	ra,44(sp)
f9001034:	04e7a023          	sw	a4,64(a5) # f800a040 <__freertos_irq_stack_top+0xff003910>
f9001038:	001e87b7          	lui	a5,0x1e8
f900103c:	48078793          	addi	a5,a5,1152 # 1e8480 <__stack_size+0x1e4480>
f9001040:	00050413          	mv	s0,a0
f9001044:	00058493          	mv	s1,a1
f9001048:	00f12e23          	sw	a5,28(sp)
f900104c:	f800a737          	lui	a4,0xf800a
f9001050:	04072783          	lw	a5,64(a4) # f800a040 <__freertos_irq_stack_top+0xff003910>
f9001054:	0107f793          	andi	a5,a5,16
f9001058:	06079063          	bnez	a5,f90010b8 <cam_write_reg8+0x9c>
f900105c:	02000513          	li	a0,32
f9001060:	dbdff0ef          	jal	ra,f9000e1c <cam_i2c_txbyte_ack>
f9001064:	08050663          	beqz	a0,f90010f0 <cam_write_reg8+0xd4>
f9001068:	f9002537          	lui	a0,0xf9002
f900106c:	8f850513          	addi	a0,a0,-1800 # f90018f8 <__freertos_irq_stack_top+0xffffb1c8>
f9001070:	d41ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001074:	02000513          	li	a0,32
f9001078:	eb9ff0ef          	jal	ra,f9000f30 <print_hex8>
f900107c:	f9002537          	lui	a0,0xf9002
f9001080:	8c850513          	addi	a0,a0,-1848 # f90018c8 <__freertos_irq_stack_top+0xffffb198>
f9001084:	d2dff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001088:	d5dff0ef          	jal	ra,f9000de4 <uart_drain>
f900108c:	e15ff0ef          	jal	ra,f9000ea0 <cam_i2c_stop>
f9001090:	f8b0c7b7          	lui	a5,0xf8b0c
f9001094:	ff87a703          	lw	a4,-8(a5) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9001098:	000067b7          	lui	a5,0x6
f900109c:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f90010a0:	00f70733          	add	a4,a4,a5
f90010a4:	f8b0c6b7          	lui	a3,0xf8b0c
f90010a8:	ff86a783          	lw	a5,-8(a3) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f90010ac:	40f707b3          	sub	a5,a4,a5
f90010b0:	fe07dce3          	bgez	a5,f90010a8 <cam_write_reg8+0x8c>
f90010b4:	0340006f          	j	f90010e8 <cam_write_reg8+0xcc>
f90010b8:	01c12783          	lw	a5,28(sp)
f90010bc:	fff78793          	addi	a5,a5,-1
f90010c0:	00f12e23          	sw	a5,28(sp)
f90010c4:	f80796e3          	bnez	a5,f9001050 <cam_write_reg8+0x34>
f90010c8:	f9002537          	lui	a0,0xf9002
f90010cc:	8dc50513          	addi	a0,a0,-1828 # f90018dc <__freertos_irq_stack_top+0xffffb1ac>
f90010d0:	ce1ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90010d4:	f05ff0ef          	jal	ra,f9000fd8 <dbg_i2c_status>
f90010d8:	f9002537          	lui	a0,0xf9002
f90010dc:	8e850513          	addi	a0,a0,-1816 # f90018e8 <__freertos_irq_stack_top+0xffffb1b8>
f90010e0:	cd1ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90010e4:	d01ff0ef          	jal	ra,f9000de4 <uart_drain>
f90010e8:	fff00513          	li	a0,-1
f90010ec:	07c0006f          	j	f9001168 <cam_write_reg8+0x14c>
f90010f0:	00845513          	srli	a0,s0,0x8
f90010f4:	d29ff0ef          	jal	ra,f9000e1c <cam_i2c_txbyte_ack>
f90010f8:	00050863          	beqz	a0,f9001108 <cam_write_reg8+0xec>
f90010fc:	f9002537          	lui	a0,0xf9002
f9001100:	91050513          	addi	a0,a0,-1776 # f9001910 <__freertos_irq_stack_top+0xffffb1e0>
f9001104:	f81ff06f          	j	f9001084 <cam_write_reg8+0x68>
f9001108:	0ff47513          	andi	a0,s0,255
f900110c:	d11ff0ef          	jal	ra,f9000e1c <cam_i2c_txbyte_ack>
f9001110:	00050863          	beqz	a0,f9001120 <cam_write_reg8+0x104>
f9001114:	f9002537          	lui	a0,0xf9002
f9001118:	92050513          	addi	a0,a0,-1760 # f9001920 <__freertos_irq_stack_top+0xffffb1f0>
f900111c:	f69ff06f          	j	f9001084 <cam_write_reg8+0x68>
f9001120:	00048513          	mv	a0,s1
f9001124:	cf9ff0ef          	jal	ra,f9000e1c <cam_i2c_txbyte_ack>
f9001128:	00050863          	beqz	a0,f9001138 <cam_write_reg8+0x11c>
f900112c:	f9002537          	lui	a0,0xf9002
f9001130:	93050513          	addi	a0,a0,-1744 # f9001930 <__freertos_irq_stack_top+0xffffb200>
f9001134:	f51ff06f          	j	f9001084 <cam_write_reg8+0x68>
f9001138:	00a12623          	sw	a0,12(sp)
f900113c:	d65ff0ef          	jal	ra,f9000ea0 <cam_i2c_stop>
f9001140:	f8b0c7b7          	lui	a5,0xf8b0c
f9001144:	ff87a703          	lw	a4,-8(a5) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9001148:	00c12503          	lw	a0,12(sp)
f900114c:	000067b7          	lui	a5,0x6
f9001150:	1a878793          	addi	a5,a5,424 # 61a8 <__stack_size+0x21a8>
f9001154:	00f70733          	add	a4,a4,a5
f9001158:	f8b0c6b7          	lui	a3,0xf8b0c
f900115c:	ff86a783          	lw	a5,-8(a3) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9001160:	40f707b3          	sub	a5,a4,a5
f9001164:	fe07dce3          	bgez	a5,f900115c <cam_write_reg8+0x140>
f9001168:	02c12083          	lw	ra,44(sp)
f900116c:	02812403          	lw	s0,40(sp)
f9001170:	02412483          	lw	s1,36(sp)
f9001174:	03010113          	addi	sp,sp,48
f9001178:	00008067          	ret

f900117c <camera_init>:
f900117c:	f9002537          	lui	a0,0xf9002
f9001180:	fe010113          	addi	sp,sp,-32
f9001184:	94050513          	addi	a0,a0,-1728 # f9001940 <__freertos_irq_stack_top+0xffffb210>
f9001188:	00112e23          	sw	ra,28(sp)
f900118c:	01212823          	sw	s2,16(sp)
f9001190:	00812c23          	sw	s0,24(sp)
f9001194:	00912a23          	sw	s1,20(sp)
f9001198:	01312623          	sw	s3,12(sp)
f900119c:	c15ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90011a0:	c45ff0ef          	jal	ra,f9000de4 <uart_drain>
f90011a4:	f800a7b7          	lui	a5,0xf800a
f90011a8:	00300713          	li	a4,3
f90011ac:	02e7a423          	sw	a4,40(a5) # f800a028 <__freertos_irq_stack_top+0xff0038f8>
f90011b0:	0000c737          	lui	a4,0xc
f90011b4:	34f70713          	addi	a4,a4,847 # c34f <__stack_size+0x834f>
f90011b8:	02e7a623          	sw	a4,44(a5)
f90011bc:	03100713          	li	a4,49
f90011c0:	02e7a823          	sw	a4,48(a5)
f90011c4:	0f900713          	li	a4,249
f90011c8:	04e7a823          	sw	a4,80(a5)
f90011cc:	04e7aa23          	sw	a4,84(a5)
f90011d0:	f9002537          	lui	a0,0xf9002
f90011d4:	04e7ac23          	sw	a4,88(a5)
f90011d8:	94c50513          	addi	a0,a0,-1716 # f900194c <__freertos_irq_stack_top+0xffffb21c>
f90011dc:	bd5ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90011e0:	f9002937          	lui	s2,0xf9002
f90011e4:	aa890513          	addi	a0,s2,-1368 # f9001aa8 <__freertos_irq_stack_top+0xffffb378>
f90011e8:	d21ff0ef          	jal	ra,f9000f08 <println>
f90011ec:	f9002537          	lui	a0,0xf9002
f90011f0:	96050513          	addi	a0,a0,-1696 # f9001960 <__freertos_irq_stack_top+0xffffb230>
f90011f4:	bbdff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90011f8:	bedff0ef          	jal	ra,f9000de4 <uart_drain>
f90011fc:	f8b0c7b7          	lui	a5,0xf8b0c
f9001200:	ff87a703          	lw	a4,-8(a5) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9001204:	002627b7          	lui	a5,0x262
f9001208:	5a078793          	addi	a5,a5,1440 # 2625a0 <__stack_size+0x25e5a0>
f900120c:	00f70733          	add	a4,a4,a5
f9001210:	f8b0c6b7          	lui	a3,0xf8b0c
f9001214:	ff86a783          	lw	a5,-8(a3) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9001218:	40f707b3          	sub	a5,a4,a5
f900121c:	fe07dce3          	bgez	a5,f9001214 <camera_init+0x98>
f9001220:	f9002437          	lui	s0,0xf9002
f9001224:	95c40513          	addi	a0,s0,-1700 # f900195c <__freertos_irq_stack_top+0xffffb22c>
f9001228:	ce1ff0ef          	jal	ra,f9000f08 <println>
f900122c:	f9002537          	lui	a0,0xf9002
f9001230:	96c50513          	addi	a0,a0,-1684 # f900196c <__freertos_irq_stack_top+0xffffb23c>
f9001234:	cd5ff0ef          	jal	ra,f9000f08 <println>
f9001238:	f9002537          	lui	a0,0xf9002
f900123c:	98850513          	addi	a0,a0,-1656 # f9001988 <__freertos_irq_stack_top+0xffffb258>
f9001240:	b71ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001244:	d95ff0ef          	jal	ra,f9000fd8 <dbg_i2c_status>
f9001248:	f9002537          	lui	a0,0xf9002
f900124c:	99c50513          	addi	a0,a0,-1636 # f900199c <__freertos_irq_stack_top+0xffffb26c>
f9001250:	b61ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001254:	f800a4b7          	lui	s1,0xf800a
f9001258:	0444a503          	lw	a0,68(s1) # f800a044 <__freertos_irq_stack_top+0xff003914>
f900125c:	00255513          	srli	a0,a0,0x2
f9001260:	00157513          	andi	a0,a0,1
f9001264:	ccdff0ef          	jal	ra,f9000f30 <print_hex8>
f9001268:	f9002537          	lui	a0,0xf9002
f900126c:	9a850513          	addi	a0,a0,-1624 # f90019a8 <__freertos_irq_stack_top+0xffffb278>
f9001270:	b41ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001274:	0444a503          	lw	a0,68(s1)
f9001278:	00155513          	srli	a0,a0,0x1
f900127c:	00157513          	andi	a0,a0,1
f9001280:	cb1ff0ef          	jal	ra,f9000f30 <print_hex8>
f9001284:	aa890513          	addi	a0,s2,-1368
f9001288:	c81ff0ef          	jal	ra,f9000f08 <println>
f900128c:	f9002537          	lui	a0,0xf9002
f9001290:	9b450513          	addi	a0,a0,-1612 # f90019b4 <__freertos_irq_stack_top+0xffffb284>
f9001294:	b1dff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001298:	b4dff0ef          	jal	ra,f9000de4 <uart_drain>
f900129c:	00000593          	li	a1,0
f90012a0:	10000513          	li	a0,256
f90012a4:	d79ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90012a8:	04050c63          	beqz	a0,f9001300 <camera_init+0x184>
f90012ac:	f9002537          	lui	a0,0xf9002
f90012b0:	9c850513          	addi	a0,a0,-1592 # f90019c8 <__freertos_irq_stack_top+0xffffb298>
f90012b4:	c55ff0ef          	jal	ra,f9000f08 <println>
f90012b8:	f9002537          	lui	a0,0xf9002
f90012bc:	9d050513          	addi	a0,a0,-1584 # f90019d0 <__freertos_irq_stack_top+0xffffb2a0>
f90012c0:	af1ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90012c4:	d15ff0ef          	jal	ra,f9000fd8 <dbg_i2c_status>
f90012c8:	aa890513          	addi	a0,s2,-1368
f90012cc:	c3dff0ef          	jal	ra,f9000f08 <println>
f90012d0:	f9002537          	lui	a0,0xf9002
f90012d4:	9e450513          	addi	a0,a0,-1564 # f90019e4 <__freertos_irq_stack_top+0xffffb2b4>
f90012d8:	c31ff0ef          	jal	ra,f9000f08 <println>
f90012dc:	01812403          	lw	s0,24(sp)
f90012e0:	01c12083          	lw	ra,28(sp)
f90012e4:	01412483          	lw	s1,20(sp)
f90012e8:	01012903          	lw	s2,16(sp)
f90012ec:	00c12983          	lw	s3,12(sp)
f90012f0:	f9002537          	lui	a0,0xf9002
f90012f4:	af850513          	addi	a0,a0,-1288 # f9001af8 <__freertos_irq_stack_top+0xffffb3c8>
f90012f8:	02010113          	addi	sp,sp,32
f90012fc:	c0dff06f          	j	f9000f08 <println>
f9001300:	f9002537          	lui	a0,0xf9002
f9001304:	a1850513          	addi	a0,a0,-1512 # f9001a18 <__freertos_irq_stack_top+0xffffb2e8>
f9001308:	c01ff0ef          	jal	ra,f9000f08 <println>
f900130c:	f9002537          	lui	a0,0xf9002
f9001310:	a1c50513          	addi	a0,a0,-1508 # f9001a1c <__freertos_irq_stack_top+0xffffb2ec>
f9001314:	000039b7          	lui	s3,0x3
f9001318:	a99ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f900131c:	ac9ff0ef          	jal	ra,f9000de4 <uart_drain>
f9001320:	00500593          	li	a1,5
f9001324:	0eb98513          	addi	a0,s3,235 # 30eb <CUSTOM2+0x3090>
f9001328:	cf5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900132c:	00050493          	mv	s1,a0
f9001330:	00c00593          	li	a1,12
f9001334:	0eb98513          	addi	a0,s3,235
f9001338:	ce5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900133c:	00a4e4b3          	or	s1,s1,a0
f9001340:	0ff00593          	li	a1,255
f9001344:	00a98513          	addi	a0,s3,10
f9001348:	cd5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900134c:	00a4e4b3          	or	s1,s1,a0
f9001350:	0ff00593          	li	a1,255
f9001354:	00b98513          	addi	a0,s3,11
f9001358:	cc5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900135c:	00a4e4b3          	or	s1,s1,a0
f9001360:	00500593          	li	a1,5
f9001364:	0eb98513          	addi	a0,s3,235
f9001368:	cb5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900136c:	00a4e4b3          	or	s1,s1,a0
f9001370:	00900593          	li	a1,9
f9001374:	0eb98513          	addi	a0,s3,235
f9001378:	ca5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900137c:	00a4e533          	or	a0,s1,a0
f9001380:	34050063          	beqz	a0,f90016c0 <camera_init+0x544>
f9001384:	f9002537          	lui	a0,0xf9002
f9001388:	a2c50513          	addi	a0,a0,-1492 # f9001a2c <__freertos_irq_stack_top+0xffffb2fc>
f900138c:	b7dff0ef          	jal	ra,f9000f08 <println>
f9001390:	f9002537          	lui	a0,0xf9002
f9001394:	a3450513          	addi	a0,a0,-1484 # f9001a34 <__freertos_irq_stack_top+0xffffb304>
f9001398:	a19ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f900139c:	a49ff0ef          	jal	ra,f9000de4 <uart_drain>
f90013a0:	00100593          	li	a1,1
f90013a4:	11400513          	li	a0,276
f90013a8:	c75ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90013ac:	00000593          	li	a1,0
f90013b0:	12800513          	li	a0,296
f90013b4:	c69ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90013b8:	00000593          	li	a1,0
f90013bc:	12e00513          	li	a0,302
f90013c0:	c5dff0ef          	jal	ra,f900101c <cam_write_reg8>
f90013c4:	01800593          	li	a1,24
f90013c8:	12a00513          	li	a0,298
f90013cc:	c51ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90013d0:	00000593          	li	a1,0
f90013d4:	12b00513          	li	a0,299
f90013d8:	c45ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90013dc:	95c40513          	addi	a0,s0,-1700
f90013e0:	b29ff0ef          	jal	ra,f9000f08 <println>
f90013e4:	f9002537          	lui	a0,0xf9002
f90013e8:	a4850513          	addi	a0,a0,-1464 # f9001a48 <__freertos_irq_stack_top+0xffffb318>
f90013ec:	9c5ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90013f0:	9f5ff0ef          	jal	ra,f9000de4 <uart_drain>
f90013f4:	00600593          	li	a1,6
f90013f8:	16000513          	li	a0,352
f90013fc:	c21ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001400:	0e300593          	li	a1,227
f9001404:	16100513          	li	a0,353
f9001408:	c15ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900140c:	00d00593          	li	a1,13
f9001410:	16200513          	li	a0,354
f9001414:	c09ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001418:	07800593          	li	a1,120
f900141c:	16300513          	li	a0,355
f9001420:	bfdff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001424:	95c40513          	addi	a0,s0,-1700
f9001428:	ae1ff0ef          	jal	ra,f9000f08 <println>
f900142c:	f9002537          	lui	a0,0xf9002
f9001430:	a5c50513          	addi	a0,a0,-1444 # f9001a5c <__freertos_irq_stack_top+0xffffb32c>
f9001434:	97dff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001438:	9adff0ef          	jal	ra,f9000de4 <uart_drain>
f900143c:	00500593          	li	a1,5
f9001440:	16400513          	li	a0,356
f9001444:	bd9ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001448:	0f800593          	li	a1,248
f900144c:	16500513          	li	a0,357
f9001450:	bcdff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001454:	00600593          	li	a1,6
f9001458:	16600513          	li	a0,358
f900145c:	bc1ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001460:	0d700593          	li	a1,215
f9001464:	16700513          	li	a0,359
f9001468:	bb5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900146c:	00400593          	li	a1,4
f9001470:	16800513          	li	a0,360
f9001474:	ba9ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001478:	06000593          	li	a1,96
f900147c:	16900513          	li	a0,361
f9001480:	b9dff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001484:	00500593          	li	a1,5
f9001488:	16a00513          	li	a0,362
f900148c:	b91ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001490:	03f00593          	li	a1,63
f9001494:	16b00513          	li	a0,363
f9001498:	b85ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900149c:	00000593          	li	a1,0
f90014a0:	16c00513          	li	a0,364
f90014a4:	b79ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90014a8:	0e000593          	li	a1,224
f90014ac:	16d00513          	li	a0,365
f90014b0:	b6dff0ef          	jal	ra,f900101c <cam_write_reg8>
f90014b4:	00000593          	li	a1,0
f90014b8:	16e00513          	li	a0,366
f90014bc:	b61ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90014c0:	0e000593          	li	a1,224
f90014c4:	16f00513          	li	a0,367
f90014c8:	b55ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90014cc:	95c40513          	addi	a0,s0,-1700
f90014d0:	a39ff0ef          	jal	ra,f9000f08 <println>
f90014d4:	f9002537          	lui	a0,0xf9002
f90014d8:	a7850513          	addi	a0,a0,-1416 # f9001a78 <__freertos_irq_stack_top+0xffffb348>
f90014dc:	8d5ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90014e0:	905ff0ef          	jal	ra,f9000de4 <uart_drain>
f90014e4:	00100593          	li	a1,1
f90014e8:	17000513          	li	a0,368
f90014ec:	b31ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90014f0:	00100593          	li	a1,1
f90014f4:	17100513          	li	a0,369
f90014f8:	b25ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90014fc:	00000593          	li	a1,0
f9001500:	17400513          	li	a0,372
f9001504:	b19ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001508:	00000593          	li	a1,0
f900150c:	17500513          	li	a0,373
f9001510:	b0dff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001514:	95c40513          	addi	a0,s0,-1700
f9001518:	9f1ff0ef          	jal	ra,f9000f08 <println>
f900151c:	f9002537          	lui	a0,0xf9002
f9001520:	a8c50513          	addi	a0,a0,-1396 # f9001a8c <__freertos_irq_stack_top+0xffffb35c>
f9001524:	88dff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001528:	8bdff0ef          	jal	ra,f9000de4 <uart_drain>
f900152c:	00800593          	li	a1,8
f9001530:	18c00513          	li	a0,396
f9001534:	ae9ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001538:	00800593          	li	a1,8
f900153c:	18d00513          	li	a0,397
f9001540:	addff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001544:	95c40513          	addi	a0,s0,-1700
f9001548:	9c1ff0ef          	jal	ra,f9000f08 <println>
f900154c:	f9002537          	lui	a0,0xf9002
f9001550:	aa050513          	addi	a0,a0,-1376 # f9001aa0 <__freertos_irq_stack_top+0xffffb370>
f9001554:	85dff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001558:	88dff0ef          	jal	ra,f9000de4 <uart_drain>
f900155c:	00400593          	li	a1,4
f9001560:	30100513          	li	a0,769
f9001564:	ab9ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001568:	00100593          	li	a1,1
f900156c:	30300513          	li	a0,771
f9001570:	aadff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001574:	00300593          	li	a1,3
f9001578:	30400513          	li	a0,772
f900157c:	aa1ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001580:	00300593          	li	a1,3
f9001584:	30500513          	li	a0,773
f9001588:	a95ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900158c:	00000593          	li	a1,0
f9001590:	30600513          	li	a0,774
f9001594:	a89ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001598:	03900593          	li	a1,57
f900159c:	30700513          	li	a0,775
f90015a0:	a7dff0ef          	jal	ra,f900101c <cam_write_reg8>
f90015a4:	00a00593          	li	a1,10
f90015a8:	30900513          	li	a0,777
f90015ac:	a71ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90015b0:	00100593          	li	a1,1
f90015b4:	30b00513          	li	a0,779
f90015b8:	a65ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90015bc:	00000593          	li	a1,0
f90015c0:	30c00513          	li	a0,780
f90015c4:	a59ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90015c8:	07200593          	li	a1,114
f90015cc:	30d00513          	li	a0,781
f90015d0:	a4dff0ef          	jal	ra,f900101c <cam_write_reg8>
f90015d4:	95c40513          	addi	a0,s0,-1700
f90015d8:	931ff0ef          	jal	ra,f9000f08 <println>
f90015dc:	f9002537          	lui	a0,0xf9002
f90015e0:	aac50513          	addi	a0,a0,-1364 # f9001aac <__freertos_irq_stack_top+0xffffb37c>
f90015e4:	fccff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f90015e8:	ffcff0ef          	jal	ra,f9000de4 <uart_drain>
f90015ec:	00400593          	li	a1,4
f90015f0:	15a00513          	li	a0,346
f90015f4:	a29ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90015f8:	05400593          	li	a1,84
f90015fc:	15b00513          	li	a0,347
f9001600:	a1dff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001604:	0b900593          	li	a1,185
f9001608:	15700513          	li	a0,343
f900160c:	a11ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001610:	00200593          	li	a1,2
f9001614:	15800513          	li	a0,344
f9001618:	a05ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900161c:	00000593          	li	a1,0
f9001620:	15900513          	li	a0,345
f9001624:	9f9ff0ef          	jal	ra,f900101c <cam_write_reg8>
f9001628:	95c40513          	addi	a0,s0,-1700
f900162c:	8ddff0ef          	jal	ra,f9000f08 <println>
f9001630:	00000593          	li	a1,0
f9001634:	17200513          	li	a0,370
f9001638:	9e5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900163c:	f9002537          	lui	a0,0xf9002
f9001640:	ac050513          	addi	a0,a0,-1344 # f9001ac0 <__freertos_irq_stack_top+0xffffb390>
f9001644:	f6cff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001648:	f9cff0ef          	jal	ra,f9000de4 <uart_drain>
f900164c:	f8b0c7b7          	lui	a5,0xf8b0c
f9001650:	ff87a703          	lw	a4,-8(a5) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9001654:	0007a7b7          	lui	a5,0x7a
f9001658:	12078793          	addi	a5,a5,288 # 7a120 <__stack_size+0x76120>
f900165c:	00f70733          	add	a4,a4,a5
f9001660:	f8b0c6b7          	lui	a3,0xf8b0c
f9001664:	ff86a783          	lw	a5,-8(a3) # f8b0bff8 <__freertos_irq_stack_top+0xffb058c8>
f9001668:	40f707b3          	sub	a5,a4,a5
f900166c:	fe07dce3          	bgez	a5,f9001664 <camera_init+0x4e8>
f9001670:	00100593          	li	a1,1
f9001674:	10000513          	li	a0,256
f9001678:	9a5ff0ef          	jal	ra,f900101c <cam_write_reg8>
f900167c:	95c40513          	addi	a0,s0,-1700
f9001680:	889ff0ef          	jal	ra,f9000f08 <println>
f9001684:	f9002537          	lui	a0,0xf9002
f9001688:	ad450513          	addi	a0,a0,-1324 # f9001ad4 <__freertos_irq_stack_top+0xffffb3a4>
f900168c:	f24ff0ef          	jal	ra,f9000db0 <uart_mini_tx_string>
f9001690:	f54ff0ef          	jal	ra,f9000de4 <uart_drain>
f9001694:	00000593          	li	a1,0
f9001698:	60000513          	li	a0,1536
f900169c:	981ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90016a0:	00000593          	li	a1,0
f90016a4:	60100513          	li	a0,1537
f90016a8:	975ff0ef          	jal	ra,f900101c <cam_write_reg8>
f90016ac:	aa890513          	addi	a0,s2,-1368
f90016b0:	859ff0ef          	jal	ra,f9000f08 <println>
f90016b4:	f9002537          	lui	a0,0xf9002
f90016b8:	ae850513          	addi	a0,a0,-1304 # f9001ae8 <__freertos_irq_stack_top+0xffffb3b8>
f90016bc:	c1dff06f          	j	f90012d8 <camera_init+0x15c>
f90016c0:	95c40513          	addi	a0,s0,-1700
f90016c4:	cc9ff06f          	j	f900138c <camera_init+0x210>
