
build/mdio_test.elf:     file format elf32-littleriscv


Disassembly of section .init:

00001000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
    1000:	00016197          	auipc	gp,0x16
    1004:	4b018193          	addi	gp,gp,1200 # 174b0 <__global_pointer$>

00001008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
    1008:	00017117          	auipc	sp,0x17
    100c:	d1810113          	addi	sp,sp,-744 # 17d20 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
    1010:	00014517          	auipc	a0,0x14
    1014:	30850513          	addi	a0,a0,776 # 15318 <_data>
	la a1, _data
    1018:	00014597          	auipc	a1,0x14
    101c:	30058593          	addi	a1,a1,768 # 15318 <_data>
	la a2, _edata
    1020:	82c18613          	addi	a2,gp,-2004 # 16cdc <_PathLocale>
	bgeu a1, a2, 2f
    1024:	00c5fc63          	bgeu	a1,a2,103c <init+0x34>
1:
	lw t0, (a0)
    1028:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
    102c:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
    1030:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
    1034:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
    1038:	fec5e8e3          	bltu	a1,a2,1028 <init+0x20>
2:

	/* Clear bss section */
	la a0, __bss_start
    103c:	82c18513          	addi	a0,gp,-2004 # 16cdc <_PathLocale>
	la a1, _end
    1040:	87018593          	addi	a1,gp,-1936 # 16d20 <_end>
	bgeu a0, a1, 2f
    1044:	00b57863          	bgeu	a0,a1,1054 <init+0x4c>
1:
	sw zero, (a0)
    1048:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
    104c:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
    1050:	feb56ce3          	bltu	a0,a1,1048 <init+0x40>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
    1054:	0c0000ef          	jal	ra,1114 <__libc_init_array>
#endif

	call main
    1058:	5b40f0ef          	jal	ra,1060c <main>

0000105c <mainDone>:
mainDone:
    j mainDone
    105c:	0000006f          	j	105c <mainDone>

00001060 <_init>:


	.globl _init
_init:
    ret
    1060:	00008067          	ret

Disassembly of section .text:

00001064 <strcpy>:
    1064:	00b567b3          	or	a5,a0,a1
    1068:	0037f793          	andi	a5,a5,3
    106c:	08079263          	bnez	a5,10f0 <strcpy+0x8c>
    1070:	0005a703          	lw	a4,0(a1)
    1074:	7f7f86b7          	lui	a3,0x7f7f8
    1078:	f7f68693          	addi	a3,a3,-129 # 7f7f7f7f <__freertos_irq_stack_top+0x7f7e025f>
    107c:	00d777b3          	and	a5,a4,a3
    1080:	00d787b3          	add	a5,a5,a3
    1084:	00e7e7b3          	or	a5,a5,a4
    1088:	00d7e7b3          	or	a5,a5,a3
    108c:	fff00613          	li	a2,-1
    1090:	06c79e63          	bne	a5,a2,110c <strcpy+0xa8>
    1094:	00050613          	mv	a2,a0
    1098:	fff00813          	li	a6,-1
    109c:	00460613          	addi	a2,a2,4
    10a0:	00458593          	addi	a1,a1,4
    10a4:	fee62e23          	sw	a4,-4(a2)
    10a8:	0005a703          	lw	a4,0(a1)
    10ac:	00d777b3          	and	a5,a4,a3
    10b0:	00d787b3          	add	a5,a5,a3
    10b4:	00e7e7b3          	or	a5,a5,a4
    10b8:	00d7e7b3          	or	a5,a5,a3
    10bc:	ff0780e3          	beq	a5,a6,109c <strcpy+0x38>
    10c0:	0005c783          	lbu	a5,0(a1)
    10c4:	0015c703          	lbu	a4,1(a1)
    10c8:	0025c683          	lbu	a3,2(a1)
    10cc:	00f60023          	sb	a5,0(a2)
    10d0:	00078a63          	beqz	a5,10e4 <strcpy+0x80>
    10d4:	00e600a3          	sb	a4,1(a2)
    10d8:	00070663          	beqz	a4,10e4 <strcpy+0x80>
    10dc:	00d60123          	sb	a3,2(a2)
    10e0:	00069463          	bnez	a3,10e8 <strcpy+0x84>
    10e4:	00008067          	ret
    10e8:	000601a3          	sb	zero,3(a2)
    10ec:	00008067          	ret
    10f0:	00050793          	mv	a5,a0
    10f4:	0005c703          	lbu	a4,0(a1)
    10f8:	00178793          	addi	a5,a5,1
    10fc:	00158593          	addi	a1,a1,1
    1100:	fee78fa3          	sb	a4,-1(a5)
    1104:	fe0718e3          	bnez	a4,10f4 <strcpy+0x90>
    1108:	00008067          	ret
    110c:	00050613          	mv	a2,a0
    1110:	fb1ff06f          	j	10c0 <strcpy+0x5c>

00001114 <__libc_init_array>:
    1114:	ff010113          	addi	sp,sp,-16
    1118:	00812423          	sw	s0,8(sp)
    111c:	01212023          	sw	s2,0(sp)
    1120:	00014417          	auipc	s0,0x14
    1124:	1f840413          	addi	s0,s0,504 # 15318 <_data>
    1128:	00014917          	auipc	s2,0x14
    112c:	1f090913          	addi	s2,s2,496 # 15318 <_data>
    1130:	40890933          	sub	s2,s2,s0
    1134:	00112623          	sw	ra,12(sp)
    1138:	00912223          	sw	s1,4(sp)
    113c:	40295913          	srai	s2,s2,0x2
    1140:	00090e63          	beqz	s2,115c <__libc_init_array+0x48>
    1144:	00000493          	li	s1,0
    1148:	00042783          	lw	a5,0(s0)
    114c:	00148493          	addi	s1,s1,1
    1150:	00440413          	addi	s0,s0,4
    1154:	000780e7          	jalr	a5
    1158:	fe9918e3          	bne	s2,s1,1148 <__libc_init_array+0x34>
    115c:	00014417          	auipc	s0,0x14
    1160:	1bc40413          	addi	s0,s0,444 # 15318 <_data>
    1164:	00014917          	auipc	s2,0x14
    1168:	1b490913          	addi	s2,s2,436 # 15318 <_data>
    116c:	40890933          	sub	s2,s2,s0
    1170:	40295913          	srai	s2,s2,0x2
    1174:	00090e63          	beqz	s2,1190 <__libc_init_array+0x7c>
    1178:	00000493          	li	s1,0
    117c:	00042783          	lw	a5,0(s0)
    1180:	00148493          	addi	s1,s1,1
    1184:	00440413          	addi	s0,s0,4
    1188:	000780e7          	jalr	a5
    118c:	fe9918e3          	bne	s2,s1,117c <__libc_init_array+0x68>
    1190:	00c12083          	lw	ra,12(sp)
    1194:	00812403          	lw	s0,8(sp)
    1198:	00412483          	lw	s1,4(sp)
    119c:	00012903          	lw	s2,0(sp)
    11a0:	01010113          	addi	sp,sp,16
    11a4:	00008067          	ret

000011a8 <_printf_r>:
    11a8:	fc010113          	addi	sp,sp,-64
    11ac:	02c12423          	sw	a2,40(sp)
    11b0:	02d12623          	sw	a3,44(sp)
    11b4:	02f12a23          	sw	a5,52(sp)
    11b8:	02e12823          	sw	a4,48(sp)
    11bc:	03012c23          	sw	a6,56(sp)
    11c0:	03112e23          	sw	a7,60(sp)
    11c4:	00058613          	mv	a2,a1
    11c8:	00852583          	lw	a1,8(a0)
    11cc:	02810793          	addi	a5,sp,40
    11d0:	00078693          	mv	a3,a5
    11d4:	00112e23          	sw	ra,28(sp)
    11d8:	00f12623          	sw	a5,12(sp)
    11dc:	328000ef          	jal	ra,1504 <_vfprintf_r>
    11e0:	01c12083          	lw	ra,28(sp)
    11e4:	04010113          	addi	sp,sp,64
    11e8:	00008067          	ret

000011ec <printf>:
    11ec:	81018313          	addi	t1,gp,-2032 # 16cc0 <_impure_ptr>
    11f0:	00032303          	lw	t1,0(t1)
    11f4:	fc010113          	addi	sp,sp,-64
    11f8:	02c12423          	sw	a2,40(sp)
    11fc:	02d12623          	sw	a3,44(sp)
    1200:	02f12a23          	sw	a5,52(sp)
    1204:	02b12223          	sw	a1,36(sp)
    1208:	02e12823          	sw	a4,48(sp)
    120c:	03012c23          	sw	a6,56(sp)
    1210:	03112e23          	sw	a7,60(sp)
    1214:	00832583          	lw	a1,8(t1)
    1218:	02410793          	addi	a5,sp,36
    121c:	00050613          	mv	a2,a0
    1220:	00078693          	mv	a3,a5
    1224:	00030513          	mv	a0,t1
    1228:	00112e23          	sw	ra,28(sp)
    122c:	00f12623          	sw	a5,12(sp)
    1230:	2d4000ef          	jal	ra,1504 <_vfprintf_r>
    1234:	01c12083          	lw	ra,28(sp)
    1238:	04010113          	addi	sp,sp,64
    123c:	00008067          	ret

00001240 <_putchar_r>:
    1240:	00852603          	lw	a2,8(a0)
    1244:	01c0006f          	j	1260 <_putc_r>

00001248 <putchar>:
    1248:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    124c:	0007a783          	lw	a5,0(a5)
    1250:	00050593          	mv	a1,a0
    1254:	0087a603          	lw	a2,8(a5)
    1258:	00078513          	mv	a0,a5
    125c:	0040006f          	j	1260 <_putc_r>

00001260 <_putc_r>:
    1260:	fe010113          	addi	sp,sp,-32
    1264:	00812c23          	sw	s0,24(sp)
    1268:	00112e23          	sw	ra,28(sp)
    126c:	00050413          	mv	s0,a0
    1270:	00050663          	beqz	a0,127c <_putc_r+0x1c>
    1274:	03852783          	lw	a5,56(a0)
    1278:	04078663          	beqz	a5,12c4 <_putc_r+0x64>
    127c:	00862783          	lw	a5,8(a2)
    1280:	fff78793          	addi	a5,a5,-1
    1284:	00f62423          	sw	a5,8(a2)
    1288:	0007dc63          	bgez	a5,12a0 <_putc_r+0x40>
    128c:	01862703          	lw	a4,24(a2)
    1290:	04e7c663          	blt	a5,a4,12dc <_putc_r+0x7c>
    1294:	0ff5f793          	andi	a5,a1,255
    1298:	00a00713          	li	a4,10
    129c:	04e78063          	beq	a5,a4,12dc <_putc_r+0x7c>
    12a0:	00062783          	lw	a5,0(a2)
    12a4:	0ff5f513          	andi	a0,a1,255
    12a8:	00178713          	addi	a4,a5,1
    12ac:	00e62023          	sw	a4,0(a2)
    12b0:	00b78023          	sb	a1,0(a5)
    12b4:	01c12083          	lw	ra,28(sp)
    12b8:	01812403          	lw	s0,24(sp)
    12bc:	02010113          	addi	sp,sp,32
    12c0:	00008067          	ret
    12c4:	00c12623          	sw	a2,12(sp)
    12c8:	00b12423          	sw	a1,8(sp)
    12cc:	744030ef          	jal	ra,4a10 <__sinit>
    12d0:	00c12603          	lw	a2,12(sp)
    12d4:	00812583          	lw	a1,8(sp)
    12d8:	fa5ff06f          	j	127c <_putc_r+0x1c>
    12dc:	00040513          	mv	a0,s0
    12e0:	01812403          	lw	s0,24(sp)
    12e4:	01c12083          	lw	ra,28(sp)
    12e8:	02010113          	addi	sp,sp,32
    12ec:	6110206f          	j	40fc <__swbuf_r>

000012f0 <putc>:
    12f0:	fe010113          	addi	sp,sp,-32
    12f4:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    12f8:	00812c23          	sw	s0,24(sp)
    12fc:	0007a403          	lw	s0,0(a5)
    1300:	00912a23          	sw	s1,20(sp)
    1304:	00112e23          	sw	ra,28(sp)
    1308:	00050493          	mv	s1,a0
    130c:	00040663          	beqz	s0,1318 <putc+0x28>
    1310:	03842783          	lw	a5,56(s0)
    1314:	04078863          	beqz	a5,1364 <putc+0x74>
    1318:	0085a783          	lw	a5,8(a1)
    131c:	fff78793          	addi	a5,a5,-1
    1320:	00f5a423          	sw	a5,8(a1)
    1324:	0007dc63          	bgez	a5,133c <putc+0x4c>
    1328:	0185a703          	lw	a4,24(a1)
    132c:	04e7c663          	blt	a5,a4,1378 <putc+0x88>
    1330:	0ff4f793          	andi	a5,s1,255
    1334:	00a00713          	li	a4,10
    1338:	04e78063          	beq	a5,a4,1378 <putc+0x88>
    133c:	0005a783          	lw	a5,0(a1)
    1340:	0ff4f513          	andi	a0,s1,255
    1344:	00178713          	addi	a4,a5,1
    1348:	00e5a023          	sw	a4,0(a1)
    134c:	00978023          	sb	s1,0(a5)
    1350:	01c12083          	lw	ra,28(sp)
    1354:	01812403          	lw	s0,24(sp)
    1358:	01412483          	lw	s1,20(sp)
    135c:	02010113          	addi	sp,sp,32
    1360:	00008067          	ret
    1364:	00040513          	mv	a0,s0
    1368:	00b12623          	sw	a1,12(sp)
    136c:	6a4030ef          	jal	ra,4a10 <__sinit>
    1370:	00c12583          	lw	a1,12(sp)
    1374:	fa5ff06f          	j	1318 <putc+0x28>
    1378:	00040513          	mv	a0,s0
    137c:	01812403          	lw	s0,24(sp)
    1380:	01c12083          	lw	ra,28(sp)
    1384:	00058613          	mv	a2,a1
    1388:	00048593          	mv	a1,s1
    138c:	01412483          	lw	s1,20(sp)
    1390:	02010113          	addi	sp,sp,32
    1394:	5690206f          	j	40fc <__swbuf_r>

00001398 <_puts_r>:
    1398:	fc010113          	addi	sp,sp,-64
    139c:	02812c23          	sw	s0,56(sp)
    13a0:	00050413          	mv	s0,a0
    13a4:	00058513          	mv	a0,a1
    13a8:	02912a23          	sw	s1,52(sp)
    13ac:	02112e23          	sw	ra,60(sp)
    13b0:	00058493          	mv	s1,a1
    13b4:	0c4000ef          	jal	ra,1478 <strlen>
    13b8:	00150713          	addi	a4,a0,1
    13bc:	00014697          	auipc	a3,0x14
    13c0:	25c68693          	addi	a3,a3,604 # 15618 <_data+0x300>
    13c4:	00e12e23          	sw	a4,28(sp)
    13c8:	03842783          	lw	a5,56(s0)
    13cc:	02010713          	addi	a4,sp,32
    13d0:	02d12423          	sw	a3,40(sp)
    13d4:	00e12a23          	sw	a4,20(sp)
    13d8:	00100693          	li	a3,1
    13dc:	00200713          	li	a4,2
    13e0:	02912023          	sw	s1,32(sp)
    13e4:	02a12223          	sw	a0,36(sp)
    13e8:	02d12623          	sw	a3,44(sp)
    13ec:	00e12c23          	sw	a4,24(sp)
    13f0:	00842583          	lw	a1,8(s0)
    13f4:	06078063          	beqz	a5,1454 <_puts_r+0xbc>
    13f8:	00c59783          	lh	a5,12(a1)
    13fc:	01279713          	slli	a4,a5,0x12
    1400:	02074263          	bltz	a4,1424 <_puts_r+0x8c>
    1404:	0645a703          	lw	a4,100(a1)
    1408:	000026b7          	lui	a3,0x2
    140c:	00d7e7b3          	or	a5,a5,a3
    1410:	ffffe6b7          	lui	a3,0xffffe
    1414:	fff68693          	addi	a3,a3,-1 # ffffdfff <__freertos_irq_stack_top+0xfffe62df>
    1418:	00d77733          	and	a4,a4,a3
    141c:	00f59623          	sh	a5,12(a1)
    1420:	06e5a223          	sw	a4,100(a1)
    1424:	01410613          	addi	a2,sp,20
    1428:	00040513          	mv	a0,s0
    142c:	271030ef          	jal	ra,4e9c <__sfvwrite_r>
    1430:	03c12083          	lw	ra,60(sp)
    1434:	03812403          	lw	s0,56(sp)
    1438:	00a03533          	snez	a0,a0
    143c:	40a00533          	neg	a0,a0
    1440:	ff557513          	andi	a0,a0,-11
    1444:	03412483          	lw	s1,52(sp)
    1448:	00a50513          	addi	a0,a0,10
    144c:	04010113          	addi	sp,sp,64
    1450:	00008067          	ret
    1454:	00040513          	mv	a0,s0
    1458:	00b12623          	sw	a1,12(sp)
    145c:	5b4030ef          	jal	ra,4a10 <__sinit>
    1460:	00c12583          	lw	a1,12(sp)
    1464:	f95ff06f          	j	13f8 <_puts_r+0x60>

00001468 <puts>:
    1468:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    146c:	00050593          	mv	a1,a0
    1470:	0007a503          	lw	a0,0(a5)
    1474:	f25ff06f          	j	1398 <_puts_r>

00001478 <strlen>:
    1478:	00357793          	andi	a5,a0,3
    147c:	00050713          	mv	a4,a0
    1480:	04079c63          	bnez	a5,14d8 <strlen+0x60>
    1484:	7f7f86b7          	lui	a3,0x7f7f8
    1488:	f7f68693          	addi	a3,a3,-129 # 7f7f7f7f <__freertos_irq_stack_top+0x7f7e025f>
    148c:	fff00593          	li	a1,-1
    1490:	00470713          	addi	a4,a4,4
    1494:	ffc72603          	lw	a2,-4(a4)
    1498:	00d677b3          	and	a5,a2,a3
    149c:	00d787b3          	add	a5,a5,a3
    14a0:	00c7e7b3          	or	a5,a5,a2
    14a4:	00d7e7b3          	or	a5,a5,a3
    14a8:	feb784e3          	beq	a5,a1,1490 <strlen+0x18>
    14ac:	ffc74683          	lbu	a3,-4(a4)
    14b0:	40a707b3          	sub	a5,a4,a0
    14b4:	ffd74603          	lbu	a2,-3(a4)
    14b8:	ffe74503          	lbu	a0,-2(a4)
    14bc:	04068063          	beqz	a3,14fc <strlen+0x84>
    14c0:	02060a63          	beqz	a2,14f4 <strlen+0x7c>
    14c4:	00a03533          	snez	a0,a0
    14c8:	00f50533          	add	a0,a0,a5
    14cc:	ffe50513          	addi	a0,a0,-2
    14d0:	00008067          	ret
    14d4:	fa0688e3          	beqz	a3,1484 <strlen+0xc>
    14d8:	00074783          	lbu	a5,0(a4)
    14dc:	00170713          	addi	a4,a4,1
    14e0:	00377693          	andi	a3,a4,3
    14e4:	fe0798e3          	bnez	a5,14d4 <strlen+0x5c>
    14e8:	40a70733          	sub	a4,a4,a0
    14ec:	fff70513          	addi	a0,a4,-1
    14f0:	00008067          	ret
    14f4:	ffd78513          	addi	a0,a5,-3
    14f8:	00008067          	ret
    14fc:	ffc78513          	addi	a0,a5,-4
    1500:	00008067          	ret

00001504 <_vfprintf_r>:
    1504:	e1010113          	addi	sp,sp,-496
    1508:	1e112623          	sw	ra,492(sp)
    150c:	1e812423          	sw	s0,488(sp)
    1510:	1d812423          	sw	s8,456(sp)
    1514:	00b12223          	sw	a1,4(sp)
    1518:	00060c13          	mv	s8,a2
    151c:	00d12623          	sw	a3,12(sp)
    1520:	1e912223          	sw	s1,484(sp)
    1524:	1f212023          	sw	s2,480(sp)
    1528:	1d312e23          	sw	s3,476(sp)
    152c:	1d412c23          	sw	s4,472(sp)
    1530:	1d512a23          	sw	s5,468(sp)
    1534:	1d612823          	sw	s6,464(sp)
    1538:	1d712623          	sw	s7,460(sp)
    153c:	1d912223          	sw	s9,452(sp)
    1540:	1da12023          	sw	s10,448(sp)
    1544:	1bb12e23          	sw	s11,444(sp)
    1548:	00050413          	mv	s0,a0
    154c:	00a12e23          	sw	a0,28(sp)
    1550:	29d060ef          	jal	ra,7fec <_localeconv_r>
    1554:	00052783          	lw	a5,0(a0)
    1558:	00078513          	mv	a0,a5
    155c:	02f12823          	sw	a5,48(sp)
    1560:	f19ff0ef          	jal	ra,1478 <strlen>
    1564:	02a12423          	sw	a0,40(sp)
    1568:	0e012823          	sw	zero,240(sp)
    156c:	0e012a23          	sw	zero,244(sp)
    1570:	0e012c23          	sw	zero,248(sp)
    1574:	0e012e23          	sw	zero,252(sp)
    1578:	00040663          	beqz	s0,1584 <_vfprintf_r+0x80>
    157c:	03842783          	lw	a5,56(s0)
    1580:	540784e3          	beqz	a5,22c8 <_vfprintf_r+0xdc4>
    1584:	00412603          	lw	a2,4(sp)
    1588:	00c61703          	lh	a4,12(a2)
    158c:	01071793          	slli	a5,a4,0x10
    1590:	0107d793          	srli	a5,a5,0x10
    1594:	01279693          	slli	a3,a5,0x12
    1598:	0206c663          	bltz	a3,15c4 <_vfprintf_r+0xc0>
    159c:	06462683          	lw	a3,100(a2)
    15a0:	000027b7          	lui	a5,0x2
    15a4:	00f767b3          	or	a5,a4,a5
    15a8:	ffffe737          	lui	a4,0xffffe
    15ac:	fff70713          	addi	a4,a4,-1 # ffffdfff <__freertos_irq_stack_top+0xfffe62df>
    15b0:	00e6f733          	and	a4,a3,a4
    15b4:	00f61623          	sh	a5,12(a2)
    15b8:	01079793          	slli	a5,a5,0x10
    15bc:	06e62223          	sw	a4,100(a2)
    15c0:	0107d793          	srli	a5,a5,0x10
    15c4:	0087f713          	andi	a4,a5,8
    15c8:	16070863          	beqz	a4,1738 <_vfprintf_r+0x234>
    15cc:	00412703          	lw	a4,4(sp)
    15d0:	01072703          	lw	a4,16(a4)
    15d4:	16070263          	beqz	a4,1738 <_vfprintf_r+0x234>
    15d8:	01a7f793          	andi	a5,a5,26
    15dc:	00a00713          	li	a4,10
    15e0:	18e78063          	beq	a5,a4,1760 <_vfprintf_r+0x25c>
    15e4:	000c0c93          	mv	s9,s8
    15e8:	000cc703          	lbu	a4,0(s9)
    15ec:	10c10793          	addi	a5,sp,268
    15f0:	0ef12223          	sw	a5,228(sp)
    15f4:	0e012623          	sw	zero,236(sp)
    15f8:	0e012423          	sw	zero,232(sp)
    15fc:	00012c23          	sw	zero,24(sp)
    1600:	02012623          	sw	zero,44(sp)
    1604:	02012c23          	sw	zero,56(sp)
    1608:	02012e23          	sw	zero,60(sp)
    160c:	04012023          	sw	zero,64(sp)
    1610:	04012223          	sw	zero,68(sp)
    1614:	00012423          	sw	zero,8(sp)
    1618:	01000b93          	li	s7,16
    161c:	00078d13          	mv	s10,a5
    1620:	01c12a03          	lw	s4,28(sp)
    1624:	3e070e63          	beqz	a4,1a20 <_vfprintf_r+0x51c>
    1628:	02500693          	li	a3,37
    162c:	00d71463          	bne	a4,a3,1634 <_vfprintf_r+0x130>
    1630:	77c0106f          	j	2dac <_vfprintf_r+0x18a8>
    1634:	000c8413          	mv	s0,s9
    1638:	00c0006f          	j	1644 <_vfprintf_r+0x140>
    163c:	14d78663          	beq	a5,a3,1788 <_vfprintf_r+0x284>
    1640:	00090413          	mv	s0,s2
    1644:	00144783          	lbu	a5,1(s0)
    1648:	00140913          	addi	s2,s0,1
    164c:	fe0798e3          	bnez	a5,163c <_vfprintf_r+0x138>
    1650:	419904b3          	sub	s1,s2,s9
    1654:	3c048663          	beqz	s1,1a20 <_vfprintf_r+0x51c>
    1658:	0ec12683          	lw	a3,236(sp)
    165c:	0e812703          	lw	a4,232(sp)
    1660:	019d2023          	sw	s9,0(s10)
    1664:	009686b3          	add	a3,a3,s1
    1668:	00170713          	addi	a4,a4,1
    166c:	009d2223          	sw	s1,4(s10)
    1670:	0ed12623          	sw	a3,236(sp)
    1674:	0ee12423          	sw	a4,232(sp)
    1678:	00700693          	li	a3,7
    167c:	008d0d13          	addi	s10,s10,8
    1680:	10e6ca63          	blt	a3,a4,1794 <_vfprintf_r+0x290>
    1684:	00812783          	lw	a5,8(sp)
    1688:	00144703          	lbu	a4,1(s0)
    168c:	009787b3          	add	a5,a5,s1
    1690:	00f12423          	sw	a5,8(sp)
    1694:	38070663          	beqz	a4,1a20 <_vfprintf_r+0x51c>
    1698:	fff00313          	li	t1,-1
    169c:	00190493          	addi	s1,s2,1
    16a0:	00194e03          	lbu	t3,1(s2)
    16a4:	0c0103a3          	sb	zero,199(sp)
    16a8:	00000413          	li	s0,0
    16ac:	00000913          	li	s2,0
    16b0:	00900993          	li	s3,9
    16b4:	02a00b13          	li	s6,42
    16b8:	00030c13          	mv	s8,t1
    16bc:	00148493          	addi	s1,s1,1
    16c0:	000e0a93          	mv	s5,t3
    16c4:	05a00713          	li	a4,90
    16c8:	fe0a8793          	addi	a5,s5,-32
    16cc:	24f76063          	bltu	a4,a5,190c <_vfprintf_r+0x408>
    16d0:	00014697          	auipc	a3,0x14
    16d4:	f4c68693          	addi	a3,a3,-180 # 1561c <_data+0x304>
    16d8:	00279793          	slli	a5,a5,0x2
    16dc:	00d787b3          	add	a5,a5,a3
    16e0:	0007a783          	lw	a5,0(a5) # 2000 <_vfprintf_r+0xafc>
    16e4:	00d787b3          	add	a5,a5,a3
    16e8:	00078067          	jr	a5
    16ec:	000a0513          	mv	a0,s4
    16f0:	0fd060ef          	jal	ra,7fec <_localeconv_r>
    16f4:	00452783          	lw	a5,4(a0)
    16f8:	00078513          	mv	a0,a5
    16fc:	04f12223          	sw	a5,68(sp)
    1700:	d79ff0ef          	jal	ra,1478 <strlen>
    1704:	04a12023          	sw	a0,64(sp)
    1708:	00050a93          	mv	s5,a0
    170c:	000a0513          	mv	a0,s4
    1710:	0dd060ef          	jal	ra,7fec <_localeconv_r>
    1714:	00852783          	lw	a5,8(a0)
    1718:	02f12e23          	sw	a5,60(sp)
    171c:	000a8463          	beqz	s5,1724 <_vfprintf_r+0x220>
    1720:	52c0106f          	j	2c4c <_vfprintf_r+0x1748>
    1724:	0004ce03          	lbu	t3,0(s1)
    1728:	f95ff06f          	j	16bc <_vfprintf_r+0x1b8>
    172c:	02096913          	ori	s2,s2,32
    1730:	0004ce03          	lbu	t3,0(s1)
    1734:	f89ff06f          	j	16bc <_vfprintf_r+0x1b8>
    1738:	00412583          	lw	a1,4(sp)
    173c:	01c12503          	lw	a0,28(sp)
    1740:	355020ef          	jal	ra,4294 <__swsetup_r>
    1744:	00050463          	beqz	a0,174c <_vfprintf_r+0x248>
    1748:	4640206f          	j	3bac <_vfprintf_r+0x26a8>
    174c:	00412783          	lw	a5,4(sp)
    1750:	00a00713          	li	a4,10
    1754:	00c7d783          	lhu	a5,12(a5)
    1758:	01a7f793          	andi	a5,a5,26
    175c:	e8e794e3          	bne	a5,a4,15e4 <_vfprintf_r+0xe0>
    1760:	00412783          	lw	a5,4(sp)
    1764:	00e79783          	lh	a5,14(a5)
    1768:	e607cee3          	bltz	a5,15e4 <_vfprintf_r+0xe0>
    176c:	00c12683          	lw	a3,12(sp)
    1770:	00412583          	lw	a1,4(sp)
    1774:	01c12503          	lw	a0,28(sp)
    1778:	000c0613          	mv	a2,s8
    177c:	0c1020ef          	jal	ra,403c <__sbprintf>
    1780:	00a12423          	sw	a0,8(sp)
    1784:	0680006f          	j	17ec <_vfprintf_r+0x2e8>
    1788:	419904b3          	sub	s1,s2,s9
    178c:	f00486e3          	beqz	s1,1698 <_vfprintf_r+0x194>
    1790:	ec9ff06f          	j	1658 <_vfprintf_r+0x154>
    1794:	00412583          	lw	a1,4(sp)
    1798:	0e410613          	addi	a2,sp,228
    179c:	000a0513          	mv	a0,s4
    17a0:	69d0b0ef          	jal	ra,d63c <__sprint_r>
    17a4:	02051a63          	bnez	a0,17d8 <_vfprintf_r+0x2d4>
    17a8:	10c10d13          	addi	s10,sp,268
    17ac:	ed9ff06f          	j	1684 <_vfprintf_r+0x180>
    17b0:	00412583          	lw	a1,4(sp)
    17b4:	0e410613          	addi	a2,sp,228
    17b8:	000a0513          	mv	a0,s4
    17bc:	6810b0ef          	jal	ra,d63c <__sprint_r>
    17c0:	54050263          	beqz	a0,1d04 <_vfprintf_r+0x800>
    17c4:	01012783          	lw	a5,16(sp)
    17c8:	00078863          	beqz	a5,17d8 <_vfprintf_r+0x2d4>
    17cc:	01c12503          	lw	a0,28(sp)
    17d0:	00078593          	mv	a1,a5
    17d4:	3b0030ef          	jal	ra,4b84 <_free_r>
    17d8:	00412783          	lw	a5,4(sp)
    17dc:	00c7d783          	lhu	a5,12(a5)
    17e0:	0407f793          	andi	a5,a5,64
    17e4:	00078463          	beqz	a5,17ec <_vfprintf_r+0x2e8>
    17e8:	3c40206f          	j	3bac <_vfprintf_r+0x26a8>
    17ec:	1ec12083          	lw	ra,492(sp)
    17f0:	1e812403          	lw	s0,488(sp)
    17f4:	00812503          	lw	a0,8(sp)
    17f8:	1e412483          	lw	s1,484(sp)
    17fc:	1e012903          	lw	s2,480(sp)
    1800:	1dc12983          	lw	s3,476(sp)
    1804:	1d812a03          	lw	s4,472(sp)
    1808:	1d412a83          	lw	s5,468(sp)
    180c:	1d012b03          	lw	s6,464(sp)
    1810:	1cc12b83          	lw	s7,460(sp)
    1814:	1c812c03          	lw	s8,456(sp)
    1818:	1c412c83          	lw	s9,452(sp)
    181c:	1c012d03          	lw	s10,448(sp)
    1820:	1bc12d83          	lw	s11,444(sp)
    1824:	1f010113          	addi	sp,sp,496
    1828:	00008067          	ret
    182c:	00014797          	auipc	a5,0x14
    1830:	f6c78793          	addi	a5,a5,-148 # 15798 <_data+0x480>
    1834:	02f12623          	sw	a5,44(sp)
    1838:	02097793          	andi	a5,s2,32
    183c:	000c0313          	mv	t1,s8
    1840:	10078063          	beqz	a5,1940 <_vfprintf_r+0x43c>
    1844:	00c12783          	lw	a5,12(sp)
    1848:	00778793          	addi	a5,a5,7
    184c:	ff87f793          	andi	a5,a5,-8
    1850:	0007ac03          	lw	s8,0(a5)
    1854:	0047ad83          	lw	s11,4(a5)
    1858:	00878713          	addi	a4,a5,8
    185c:	00e12623          	sw	a4,12(sp)
    1860:	00197793          	andi	a5,s2,1
    1864:	00078863          	beqz	a5,1874 <_vfprintf_r+0x370>
    1868:	01bc67b3          	or	a5,s8,s11
    186c:	00078463          	beqz	a5,1874 <_vfprintf_r+0x370>
    1870:	3a00106f          	j	2c10 <_vfprintf_r+0x170c>
    1874:	bff97993          	andi	s3,s2,-1025
    1878:	00200793          	li	a5,2
    187c:	0c0103a3          	sb	zero,199(sp)
    1880:	fff00713          	li	a4,-1
    1884:	0ae30ce3          	beq	t1,a4,213c <_vfprintf_r+0xc38>
    1888:	01bc6733          	or	a4,s8,s11
    188c:	f7f9f913          	andi	s2,s3,-129
    1890:	00070463          	beqz	a4,1898 <_vfprintf_r+0x394>
    1894:	7d90006f          	j	286c <_vfprintf_r+0x1368>
    1898:	2c031ee3          	bnez	t1,2374 <_vfprintf_r+0xe70>
    189c:	22079a63          	bnez	a5,1ad0 <_vfprintf_r+0x5cc>
    18a0:	0019fb13          	andi	s6,s3,1
    18a4:	1b010c93          	addi	s9,sp,432
    18a8:	000b0463          	beqz	s6,18b0 <_vfprintf_r+0x3ac>
    18ac:	3100106f          	j	2bbc <_vfprintf_r+0x16b8>
    18b0:	000b0993          	mv	s3,s6
    18b4:	006b5463          	bge	s6,t1,18bc <_vfprintf_r+0x3b8>
    18b8:	00030993          	mv	s3,t1
    18bc:	0c714703          	lbu	a4,199(sp)
    18c0:	00012823          	sw	zero,16(sp)
    18c4:	02012223          	sw	zero,36(sp)
    18c8:	02012023          	sw	zero,32(sp)
    18cc:	00012a23          	sw	zero,20(sp)
    18d0:	34070063          	beqz	a4,1c10 <_vfprintf_r+0x70c>
    18d4:	00198993          	addi	s3,s3,1
    18d8:	3380006f          	j	1c10 <_vfprintf_r+0x70c>
    18dc:	00000413          	li	s0,0
    18e0:	fd0a8693          	addi	a3,s5,-48
    18e4:	00148493          	addi	s1,s1,1
    18e8:	00241793          	slli	a5,s0,0x2
    18ec:	fff4ca83          	lbu	s5,-1(s1)
    18f0:	008787b3          	add	a5,a5,s0
    18f4:	00179793          	slli	a5,a5,0x1
    18f8:	00f68433          	add	s0,a3,a5
    18fc:	fd0a8693          	addi	a3,s5,-48
    1900:	fed9f2e3          	bgeu	s3,a3,18e4 <_vfprintf_r+0x3e0>
    1904:	fe0a8793          	addi	a5,s5,-32
    1908:	dcf774e3          	bgeu	a4,a5,16d0 <_vfprintf_r+0x1cc>
    190c:	100a8a63          	beqz	s5,1a20 <_vfprintf_r+0x51c>
    1910:	15510623          	sb	s5,332(sp)
    1914:	0c0103a3          	sb	zero,199(sp)
    1918:	00100993          	li	s3,1
    191c:	00100b13          	li	s6,1
    1920:	14c10c93          	addi	s9,sp,332
    1924:	2d80006f          	j	1bfc <_vfprintf_r+0x6f8>
    1928:	00014797          	auipc	a5,0x14
    192c:	e8478793          	addi	a5,a5,-380 # 157ac <_data+0x494>
    1930:	02f12623          	sw	a5,44(sp)
    1934:	02097793          	andi	a5,s2,32
    1938:	000c0313          	mv	t1,s8
    193c:	f00794e3          	bnez	a5,1844 <_vfprintf_r+0x340>
    1940:	00c12703          	lw	a4,12(sp)
    1944:	01097793          	andi	a5,s2,16
    1948:	00072c03          	lw	s8,0(a4)
    194c:	00470713          	addi	a4,a4,4
    1950:	00e12623          	sw	a4,12(sp)
    1954:	00078463          	beqz	a5,195c <_vfprintf_r+0x458>
    1958:	27c0106f          	j	2bd4 <_vfprintf_r+0x16d0>
    195c:	04097793          	andi	a5,s2,64
    1960:	00079463          	bnez	a5,1968 <_vfprintf_r+0x464>
    1964:	2680106f          	j	2bcc <_vfprintf_r+0x16c8>
    1968:	010c1c13          	slli	s8,s8,0x10
    196c:	010c5c13          	srli	s8,s8,0x10
    1970:	00000d93          	li	s11,0
    1974:	eedff06f          	j	1860 <_vfprintf_r+0x35c>
    1978:	0004ce03          	lbu	t3,0(s1)
    197c:	00496913          	ori	s2,s2,4
    1980:	d3dff06f          	j	16bc <_vfprintf_r+0x1b8>
    1984:	0004ca83          	lbu	s5,0(s1)
    1988:	00148793          	addi	a5,s1,1
    198c:	016a9463          	bne	s5,s6,1994 <_vfprintf_r+0x490>
    1990:	6380206f          	j	3fc8 <_vfprintf_r+0x2ac4>
    1994:	fd0a8693          	addi	a3,s5,-48
    1998:	00078493          	mv	s1,a5
    199c:	00000c13          	li	s8,0
    19a0:	d2d9e4e3          	bltu	s3,a3,16c8 <_vfprintf_r+0x1c4>
    19a4:	00148493          	addi	s1,s1,1
    19a8:	002c1793          	slli	a5,s8,0x2
    19ac:	fff4ca83          	lbu	s5,-1(s1)
    19b0:	018787b3          	add	a5,a5,s8
    19b4:	00179793          	slli	a5,a5,0x1
    19b8:	00d78c33          	add	s8,a5,a3
    19bc:	fd0a8693          	addi	a3,s5,-48
    19c0:	fed9f2e3          	bgeu	s3,a3,19a4 <_vfprintf_r+0x4a0>
    19c4:	d05ff06f          	j	16c8 <_vfprintf_r+0x1c4>
    19c8:	00c12683          	lw	a3,12(sp)
    19cc:	02097793          	andi	a5,s2,32
    19d0:	00468713          	addi	a4,a3,4
    19d4:	00078463          	beqz	a5,19dc <_vfprintf_r+0x4d8>
    19d8:	2540106f          	j	2c2c <_vfprintf_r+0x1728>
    19dc:	01097793          	andi	a5,s2,16
    19e0:	00078463          	beqz	a5,19e8 <_vfprintf_r+0x4e4>
    19e4:	6540106f          	j	3038 <_vfprintf_r+0x1b34>
    19e8:	04097793          	andi	a5,s2,64
    19ec:	00078463          	beqz	a5,19f4 <_vfprintf_r+0x4f0>
    19f0:	2410106f          	j	3430 <_vfprintf_r+0x1f2c>
    19f4:	20097913          	andi	s2,s2,512
    19f8:	00091463          	bnez	s2,1a00 <_vfprintf_r+0x4fc>
    19fc:	63c0106f          	j	3038 <_vfprintf_r+0x1b34>
    1a00:	00c12783          	lw	a5,12(sp)
    1a04:	00e12623          	sw	a4,12(sp)
    1a08:	00812703          	lw	a4,8(sp)
    1a0c:	0007a783          	lw	a5,0(a5)
    1a10:	00048c93          	mv	s9,s1
    1a14:	00e78023          	sb	a4,0(a5)
    1a18:	000cc703          	lbu	a4,0(s9)
    1a1c:	c00716e3          	bnez	a4,1628 <_vfprintf_r+0x124>
    1a20:	0ec12783          	lw	a5,236(sp)
    1a24:	da078ae3          	beqz	a5,17d8 <_vfprintf_r+0x2d4>
    1a28:	00412583          	lw	a1,4(sp)
    1a2c:	01c12503          	lw	a0,28(sp)
    1a30:	0e410613          	addi	a2,sp,228
    1a34:	4090b0ef          	jal	ra,d63c <__sprint_r>
    1a38:	da1ff06f          	j	17d8 <_vfprintf_r+0x2d4>
    1a3c:	0004ce03          	lbu	t3,0(s1)
    1a40:	06c00793          	li	a5,108
    1a44:	00fe1463          	bne	t3,a5,1a4c <_vfprintf_r+0x548>
    1a48:	2c80106f          	j	2d10 <_vfprintf_r+0x180c>
    1a4c:	01096913          	ori	s2,s2,16
    1a50:	c6dff06f          	j	16bc <_vfprintf_r+0x1b8>
    1a54:	0004ce03          	lbu	t3,0(s1)
    1a58:	06800793          	li	a5,104
    1a5c:	00fe1463          	bne	t3,a5,1a64 <_vfprintf_r+0x560>
    1a60:	2a00106f          	j	2d00 <_vfprintf_r+0x17fc>
    1a64:	04096913          	ori	s2,s2,64
    1a68:	c55ff06f          	j	16bc <_vfprintf_r+0x1b8>
    1a6c:	02097793          	andi	a5,s2,32
    1a70:	000c0313          	mv	t1,s8
    1a74:	060790e3          	bnez	a5,22d4 <_vfprintf_r+0xdd0>
    1a78:	00c12783          	lw	a5,12(sp)
    1a7c:	01097713          	andi	a4,s2,16
    1a80:	00478793          	addi	a5,a5,4
    1a84:	00070463          	beqz	a4,1a8c <_vfprintf_r+0x588>
    1a88:	58c0206f          	j	4014 <_vfprintf_r+0x2b10>
    1a8c:	04097713          	andi	a4,s2,64
    1a90:	00071463          	bnez	a4,1a98 <_vfprintf_r+0x594>
    1a94:	6740106f          	j	3108 <_vfprintf_r+0x1c04>
    1a98:	00c12703          	lw	a4,12(sp)
    1a9c:	00090993          	mv	s3,s2
    1aa0:	00f12623          	sw	a5,12(sp)
    1aa4:	00071c03          	lh	s8,0(a4)
    1aa8:	41fc5d93          	srai	s11,s8,0x1f
    1aac:	000d8713          	mv	a4,s11
    1ab0:	66074463          	bltz	a4,2118 <_vfprintf_r+0xc14>
    1ab4:	fff00793          	li	a5,-1
    1ab8:	08f30ce3          	beq	t1,a5,2350 <_vfprintf_r+0xe4c>
    1abc:	01bc67b3          	or	a5,s8,s11
    1ac0:	f7f9f913          	andi	s2,s3,-129
    1ac4:	080794e3          	bnez	a5,234c <_vfprintf_r+0xe48>
    1ac8:	00030463          	beqz	t1,1ad0 <_vfprintf_r+0x5cc>
    1acc:	5c90106f          	j	3894 <_vfprintf_r+0x2390>
    1ad0:	00000313          	li	t1,0
    1ad4:	00000b13          	li	s6,0
    1ad8:	1b010c93          	addi	s9,sp,432
    1adc:	dd5ff06f          	j	18b0 <_vfprintf_r+0x3ac>
    1ae0:	08096913          	ori	s2,s2,128
    1ae4:	0004ce03          	lbu	t3,0(s1)
    1ae8:	bd5ff06f          	j	16bc <_vfprintf_r+0x1b8>
    1aec:	02097793          	andi	a5,s2,32
    1af0:	000c0313          	mv	t1,s8
    1af4:	01096993          	ori	s3,s2,16
    1af8:	000794e3          	bnez	a5,2300 <_vfprintf_r+0xdfc>
    1afc:	00c12783          	lw	a5,12(sp)
    1b00:	00478793          	addi	a5,a5,4
    1b04:	00c12703          	lw	a4,12(sp)
    1b08:	00000d93          	li	s11,0
    1b0c:	00f12623          	sw	a5,12(sp)
    1b10:	00072c03          	lw	s8,0(a4)
    1b14:	00100793          	li	a5,1
    1b18:	d65ff06f          	j	187c <_vfprintf_r+0x378>
    1b1c:	00c12783          	lw	a5,12(sp)
    1b20:	0c0103a3          	sb	zero,199(sp)
    1b24:	000c0313          	mv	t1,s8
    1b28:	0007ac83          	lw	s9,0(a5)
    1b2c:	00478c13          	addi	s8,a5,4
    1b30:	000c9463          	bnez	s9,1b38 <_vfprintf_r+0x634>
    1b34:	1ec0106f          	j	2d20 <_vfprintf_r+0x181c>
    1b38:	fff00713          	li	a4,-1
    1b3c:	00e31463          	bne	t1,a4,1b44 <_vfprintf_r+0x640>
    1b40:	5b80106f          	j	30f8 <_vfprintf_r+0x1bf4>
    1b44:	00030613          	mv	a2,t1
    1b48:	00000593          	li	a1,0
    1b4c:	000c8513          	mv	a0,s9
    1b50:	00612623          	sw	t1,12(sp)
    1b54:	7bd060ef          	jal	ra,8b10 <memchr>
    1b58:	00a12823          	sw	a0,16(sp)
    1b5c:	00c12303          	lw	t1,12(sp)
    1b60:	00051463          	bnez	a0,1b68 <_vfprintf_r+0x664>
    1b64:	7950106f          	j	3af8 <_vfprintf_r+0x25f4>
    1b68:	01012783          	lw	a5,16(sp)
    1b6c:	41978b33          	sub	s6,a5,s9
    1b70:	0c714703          	lbu	a4,199(sp)
    1b74:	fffb4993          	not	s3,s6
    1b78:	41f9d993          	srai	s3,s3,0x1f
    1b7c:	01812623          	sw	s8,12(sp)
    1b80:	00012823          	sw	zero,16(sp)
    1b84:	02012223          	sw	zero,36(sp)
    1b88:	02012023          	sw	zero,32(sp)
    1b8c:	00012a23          	sw	zero,20(sp)
    1b90:	013b79b3          	and	s3,s6,s3
    1b94:	00000313          	li	t1,0
    1b98:	d2071ee3          	bnez	a4,18d4 <_vfprintf_r+0x3d0>
    1b9c:	0740006f          	j	1c10 <_vfprintf_r+0x70c>
    1ba0:	02097793          	andi	a5,s2,32
    1ba4:	000c0313          	mv	t1,s8
    1ba8:	01096913          	ori	s2,s2,16
    1bac:	76079c63          	bnez	a5,2324 <_vfprintf_r+0xe20>
    1bb0:	00c12783          	lw	a5,12(sp)
    1bb4:	00478793          	addi	a5,a5,4
    1bb8:	00c12703          	lw	a4,12(sp)
    1bbc:	00000d93          	li	s11,0
    1bc0:	00f12623          	sw	a5,12(sp)
    1bc4:	00072c03          	lw	s8,0(a4)
    1bc8:	7780006f          	j	2340 <_vfprintf_r+0xe3c>
    1bcc:	00896913          	ori	s2,s2,8
    1bd0:	0004ce03          	lbu	t3,0(s1)
    1bd4:	ae9ff06f          	j	16bc <_vfprintf_r+0x1b8>
    1bd8:	00c12703          	lw	a4,12(sp)
    1bdc:	0c0103a3          	sb	zero,199(sp)
    1be0:	00100993          	li	s3,1
    1be4:	00072783          	lw	a5,0(a4)
    1be8:	00470713          	addi	a4,a4,4
    1bec:	00e12623          	sw	a4,12(sp)
    1bf0:	14f10623          	sb	a5,332(sp)
    1bf4:	00100b13          	li	s6,1
    1bf8:	14c10c93          	addi	s9,sp,332
    1bfc:	00012823          	sw	zero,16(sp)
    1c00:	00000313          	li	t1,0
    1c04:	02012223          	sw	zero,36(sp)
    1c08:	02012023          	sw	zero,32(sp)
    1c0c:	00012a23          	sw	zero,20(sp)
    1c10:	00297f93          	andi	t6,s2,2
    1c14:	000f8463          	beqz	t6,1c1c <_vfprintf_r+0x718>
    1c18:	00298993          	addi	s3,s3,2
    1c1c:	08497d93          	andi	s11,s2,132
    1c20:	0ec12703          	lw	a4,236(sp)
    1c24:	000d9663          	bnez	s11,1c30 <_vfprintf_r+0x72c>
    1c28:	41340833          	sub	a6,s0,s3
    1c2c:	450044e3          	bgtz	a6,2874 <_vfprintf_r+0x1370>
    1c30:	0c714683          	lbu	a3,199(sp)
    1c34:	02068a63          	beqz	a3,1c68 <_vfprintf_r+0x764>
    1c38:	0e812683          	lw	a3,232(sp)
    1c3c:	0c710613          	addi	a2,sp,199
    1c40:	00cd2023          	sw	a2,0(s10)
    1c44:	00170713          	addi	a4,a4,1
    1c48:	00100613          	li	a2,1
    1c4c:	00168693          	addi	a3,a3,1
    1c50:	00cd2223          	sw	a2,4(s10)
    1c54:	0ee12623          	sw	a4,236(sp)
    1c58:	0ed12423          	sw	a3,232(sp)
    1c5c:	00700613          	li	a2,7
    1c60:	008d0d13          	addi	s10,s10,8
    1c64:	0cd64263          	blt	a2,a3,1d28 <_vfprintf_r+0x824>
    1c68:	020f8a63          	beqz	t6,1c9c <_vfprintf_r+0x798>
    1c6c:	0e812683          	lw	a3,232(sp)
    1c70:	0c810613          	addi	a2,sp,200
    1c74:	00cd2023          	sw	a2,0(s10)
    1c78:	00270713          	addi	a4,a4,2
    1c7c:	00200613          	li	a2,2
    1c80:	00168693          	addi	a3,a3,1
    1c84:	00cd2223          	sw	a2,4(s10)
    1c88:	0ee12623          	sw	a4,236(sp)
    1c8c:	0ed12423          	sw	a3,232(sp)
    1c90:	00700613          	li	a2,7
    1c94:	008d0d13          	addi	s10,s10,8
    1c98:	50d640e3          	blt	a2,a3,2998 <_vfprintf_r+0x1494>
    1c9c:	08000693          	li	a3,128
    1ca0:	06dd8ce3          	beq	s11,a3,2518 <_vfprintf_r+0x1014>
    1ca4:	41630c33          	sub	s8,t1,s6
    1ca8:	17804ce3          	bgtz	s8,2620 <_vfprintf_r+0x111c>
    1cac:	10097693          	andi	a3,s2,256
    1cb0:	72069063          	bnez	a3,23d0 <_vfprintf_r+0xecc>
    1cb4:	0e812783          	lw	a5,232(sp)
    1cb8:	01670733          	add	a4,a4,s6
    1cbc:	019d2023          	sw	s9,0(s10)
    1cc0:	00178793          	addi	a5,a5,1
    1cc4:	016d2223          	sw	s6,4(s10)
    1cc8:	0ee12623          	sw	a4,236(sp)
    1ccc:	0ef12423          	sw	a5,232(sp)
    1cd0:	00700693          	li	a3,7
    1cd4:	008d0d13          	addi	s10,s10,8
    1cd8:	26f6c8e3          	blt	a3,a5,2748 <_vfprintf_r+0x1244>
    1cdc:	00497913          	andi	s2,s2,4
    1ce0:	00090663          	beqz	s2,1cec <_vfprintf_r+0x7e8>
    1ce4:	41340933          	sub	s2,s0,s3
    1ce8:	07204863          	bgtz	s2,1d58 <_vfprintf_r+0x854>
    1cec:	01345463          	bge	s0,s3,1cf4 <_vfprintf_r+0x7f0>
    1cf0:	00098413          	mv	s0,s3
    1cf4:	00812783          	lw	a5,8(sp)
    1cf8:	008787b3          	add	a5,a5,s0
    1cfc:	00f12423          	sw	a5,8(sp)
    1d00:	aa0718e3          	bnez	a4,17b0 <_vfprintf_r+0x2ac>
    1d04:	01012783          	lw	a5,16(sp)
    1d08:	0e012423          	sw	zero,232(sp)
    1d0c:	00078863          	beqz	a5,1d1c <_vfprintf_r+0x818>
    1d10:	01012583          	lw	a1,16(sp)
    1d14:	000a0513          	mv	a0,s4
    1d18:	66d020ef          	jal	ra,4b84 <_free_r>
    1d1c:	10c10d13          	addi	s10,sp,268
    1d20:	00048c93          	mv	s9,s1
    1d24:	cf5ff06f          	j	1a18 <_vfprintf_r+0x514>
    1d28:	00412583          	lw	a1,4(sp)
    1d2c:	0e410613          	addi	a2,sp,228
    1d30:	000a0513          	mv	a0,s4
    1d34:	04612423          	sw	t1,72(sp)
    1d38:	03f12a23          	sw	t6,52(sp)
    1d3c:	1010b0ef          	jal	ra,d63c <__sprint_r>
    1d40:	a80512e3          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    1d44:	0ec12703          	lw	a4,236(sp)
    1d48:	10c10d13          	addi	s10,sp,268
    1d4c:	04812303          	lw	t1,72(sp)
    1d50:	03412f83          	lw	t6,52(sp)
    1d54:	f15ff06f          	j	1c68 <_vfprintf_r+0x764>
    1d58:	0e812783          	lw	a5,232(sp)
    1d5c:	00014c17          	auipc	s8,0x14
    1d60:	a70c0c13          	addi	s8,s8,-1424 # 157cc <blanks.4504>
    1d64:	072bd063          	bge	s7,s2,1dc4 <_vfprintf_r+0x8c0>
    1d68:	00700b13          	li	s6,7
    1d6c:	00412a83          	lw	s5,4(sp)
    1d70:	00c0006f          	j	1d7c <_vfprintf_r+0x878>
    1d74:	ff090913          	addi	s2,s2,-16
    1d78:	052bd663          	bge	s7,s2,1dc4 <_vfprintf_r+0x8c0>
    1d7c:	01070713          	addi	a4,a4,16
    1d80:	00178793          	addi	a5,a5,1
    1d84:	018d2023          	sw	s8,0(s10)
    1d88:	017d2223          	sw	s7,4(s10)
    1d8c:	0ee12623          	sw	a4,236(sp)
    1d90:	0ef12423          	sw	a5,232(sp)
    1d94:	008d0d13          	addi	s10,s10,8
    1d98:	fcfb5ee3          	bge	s6,a5,1d74 <_vfprintf_r+0x870>
    1d9c:	0e410613          	addi	a2,sp,228
    1da0:	000a8593          	mv	a1,s5
    1da4:	000a0513          	mv	a0,s4
    1da8:	0950b0ef          	jal	ra,d63c <__sprint_r>
    1dac:	a0051ce3          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    1db0:	ff090913          	addi	s2,s2,-16
    1db4:	0ec12703          	lw	a4,236(sp)
    1db8:	0e812783          	lw	a5,232(sp)
    1dbc:	10c10d13          	addi	s10,sp,268
    1dc0:	fb2bcee3          	blt	s7,s2,1d7c <_vfprintf_r+0x878>
    1dc4:	01270733          	add	a4,a4,s2
    1dc8:	00178793          	addi	a5,a5,1
    1dcc:	018d2023          	sw	s8,0(s10)
    1dd0:	012d2223          	sw	s2,4(s10)
    1dd4:	0ee12623          	sw	a4,236(sp)
    1dd8:	0ef12423          	sw	a5,232(sp)
    1ddc:	00700693          	li	a3,7
    1de0:	f0f6d6e3          	bge	a3,a5,1cec <_vfprintf_r+0x7e8>
    1de4:	00412583          	lw	a1,4(sp)
    1de8:	0e410613          	addi	a2,sp,228
    1dec:	000a0513          	mv	a0,s4
    1df0:	04d0b0ef          	jal	ra,d63c <__sprint_r>
    1df4:	9c0518e3          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    1df8:	0ec12703          	lw	a4,236(sp)
    1dfc:	ef1ff06f          	j	1cec <_vfprintf_r+0x7e8>
    1e00:	00897713          	andi	a4,s2,8
    1e04:	000c0313          	mv	t1,s8
    1e08:	5c071ae3          	bnez	a4,2bdc <_vfprintf_r+0x16d8>
    1e0c:	00c12783          	lw	a5,12(sp)
    1e10:	0b010513          	addi	a0,sp,176
    1e14:	01812823          	sw	s8,16(sp)
    1e18:	00778793          	addi	a5,a5,7
    1e1c:	ff87f793          	andi	a5,a5,-8
    1e20:	0007a583          	lw	a1,0(a5)
    1e24:	0047a603          	lw	a2,4(a5)
    1e28:	00878793          	addi	a5,a5,8
    1e2c:	00f12623          	sw	a5,12(sp)
    1e30:	629120ef          	jal	ra,14c58 <__extenddftf2>
    1e34:	0b012703          	lw	a4,176(sp)
    1e38:	01012303          	lw	t1,16(sp)
    1e3c:	0ee12823          	sw	a4,240(sp)
    1e40:	0b412703          	lw	a4,180(sp)
    1e44:	0ee12a23          	sw	a4,244(sp)
    1e48:	0b812703          	lw	a4,184(sp)
    1e4c:	0ee12c23          	sw	a4,248(sp)
    1e50:	0bc12703          	lw	a4,188(sp)
    1e54:	0ee12e23          	sw	a4,252(sp)
    1e58:	0f010513          	addi	a0,sp,240
    1e5c:	00612823          	sw	t1,16(sp)
    1e60:	120060ef          	jal	ra,7f80 <_ldcheck>
    1e64:	0ca12623          	sw	a0,204(sp)
    1e68:	00200713          	li	a4,2
    1e6c:	01012303          	lw	t1,16(sp)
    1e70:	00e51463          	bne	a0,a4,1e78 <_vfprintf_r+0x974>
    1e74:	1440106f          	j	2fb8 <_vfprintf_r+0x1ab4>
    1e78:	00100713          	li	a4,1
    1e7c:	00e51463          	bne	a0,a4,1e84 <_vfprintf_r+0x980>
    1e80:	2e40106f          	j	3164 <_vfprintf_r+0x1c60>
    1e84:	06100713          	li	a4,97
    1e88:	00ea9463          	bne	s5,a4,1e90 <_vfprintf_r+0x98c>
    1e8c:	5f50106f          	j	3c80 <_vfprintf_r+0x277c>
    1e90:	04100713          	li	a4,65
    1e94:	00ea9463          	bne	s5,a4,1e9c <_vfprintf_r+0x998>
    1e98:	6340106f          	j	34cc <_vfprintf_r+0x1fc8>
    1e9c:	fdfaf793          	andi	a5,s5,-33
    1ea0:	fff00713          	li	a4,-1
    1ea4:	04f12423          	sw	a5,72(sp)
    1ea8:	00e31463          	bne	t1,a4,1eb0 <_vfprintf_r+0x9ac>
    1eac:	6790106f          	j	3d24 <_vfprintf_r+0x2820>
    1eb0:	04700713          	li	a4,71
    1eb4:	00e79463          	bne	a5,a4,1ebc <_vfprintf_r+0x9b8>
    1eb8:	65d0106f          	j	3d14 <_vfprintf_r+0x2810>
    1ebc:	0fc12b03          	lw	s6,252(sp)
    1ec0:	05212a23          	sw	s2,84(sp)
    1ec4:	10096713          	ori	a4,s2,256
    1ec8:	0f012f03          	lw	t5,240(sp)
    1ecc:	0f412d83          	lw	s11,244(sp)
    1ed0:	0f812e83          	lw	t4,248(sp)
    1ed4:	000b5463          	bgez	s6,1edc <_vfprintf_r+0x9d8>
    1ed8:	27d0106f          	j	3954 <_vfprintf_r+0x2450>
    1edc:	04012e23          	sw	zero,92(sp)
    1ee0:	00070913          	mv	s2,a4
    1ee4:	00012823          	sw	zero,16(sp)
    1ee8:	04812703          	lw	a4,72(sp)
    1eec:	04600793          	li	a5,70
    1ef0:	00f71463          	bne	a4,a5,1ef8 <_vfprintf_r+0x9f4>
    1ef4:	2f50106f          	j	39e8 <_vfprintf_r+0x24e4>
    1ef8:	04500793          	li	a5,69
    1efc:	00f71463          	bne	a4,a5,1f04 <_vfprintf_r+0xa00>
    1f00:	51d0106f          	j	3c1c <_vfprintf_r+0x2718>
    1f04:	0b010c13          	addi	s8,sp,176
    1f08:	0d010793          	addi	a5,sp,208
    1f0c:	0cc10713          	addi	a4,sp,204
    1f10:	00030693          	mv	a3,t1
    1f14:	0dc10813          	addi	a6,sp,220
    1f18:	00200613          	li	a2,2
    1f1c:	000c0593          	mv	a1,s8
    1f20:	000a0513          	mv	a0,s4
    1f24:	02612023          	sw	t1,32(sp)
    1f28:	0be12823          	sw	t5,176(sp)
    1f2c:	01e12c23          	sw	t5,24(sp)
    1f30:	0bd12c23          	sw	t4,184(sp)
    1f34:	01d12a23          	sw	t4,20(sp)
    1f38:	0bb12a23          	sw	s11,180(sp)
    1f3c:	0b612e23          	sw	s6,188(sp)
    1f40:	54d040ef          	jal	ra,6c8c <_ldtoa_r>
    1f44:	04812783          	lw	a5,72(sp)
    1f48:	04700713          	li	a4,71
    1f4c:	00050c93          	mv	s9,a0
    1f50:	01412e83          	lw	t4,20(sp)
    1f54:	01812f03          	lw	t5,24(sp)
    1f58:	02012303          	lw	t1,32(sp)
    1f5c:	00e78463          	beq	a5,a4,1f64 <_vfprintf_r+0xa60>
    1f60:	0bc0206f          	j	401c <_vfprintf_r+0x2b18>
    1f64:	05412783          	lw	a5,84(sp)
    1f68:	0017f713          	andi	a4,a5,1
    1f6c:	00070463          	beqz	a4,1f74 <_vfprintf_r+0xa70>
    1f70:	49d0106f          	j	3c0c <_vfprintf_r+0x2708>
    1f74:	0dc12703          	lw	a4,220(sp)
    1f78:	419707b3          	sub	a5,a4,s9
    1f7c:	00f12c23          	sw	a5,24(sp)
    1f80:	0cc12783          	lw	a5,204(sp)
    1f84:	04700713          	li	a4,71
    1f88:	00f12a23          	sw	a5,20(sp)
    1f8c:	04812783          	lw	a5,72(sp)
    1f90:	00e79463          	bne	a5,a4,1f98 <_vfprintf_r+0xa94>
    1f94:	1390106f          	j	38cc <_vfprintf_r+0x23c8>
    1f98:	04812783          	lw	a5,72(sp)
    1f9c:	04600713          	li	a4,70
    1fa0:	00e79463          	bne	a5,a4,1fa8 <_vfprintf_r+0xaa4>
    1fa4:	3e50106f          	j	3b88 <_vfprintf_r+0x2684>
    1fa8:	01412783          	lw	a5,20(sp)
    1fac:	04100593          	li	a1,65
    1fb0:	0ffaf693          	andi	a3,s5,255
    1fb4:	fff78713          	addi	a4,a5,-1
    1fb8:	04812783          	lw	a5,72(sp)
    1fbc:	0ce12623          	sw	a4,204(sp)
    1fc0:	00000613          	li	a2,0
    1fc4:	00b79863          	bne	a5,a1,1fd4 <_vfprintf_r+0xad0>
    1fc8:	00f68693          	addi	a3,a3,15
    1fcc:	0ff6f693          	andi	a3,a3,255
    1fd0:	00100613          	li	a2,1
    1fd4:	0cd10a23          	sb	a3,212(sp)
    1fd8:	02b00693          	li	a3,43
    1fdc:	00075a63          	bgez	a4,1ff0 <_vfprintf_r+0xaec>
    1fe0:	01412783          	lw	a5,20(sp)
    1fe4:	00100713          	li	a4,1
    1fe8:	02d00693          	li	a3,45
    1fec:	40f70733          	sub	a4,a4,a5
    1ff0:	0cd10aa3          	sb	a3,213(sp)
    1ff4:	00900693          	li	a3,9
    1ff8:	00e6c463          	blt	a3,a4,2000 <_vfprintf_r+0xafc>
    1ffc:	5b90106f          	j	3db4 <_vfprintf_r+0x28b0>
    2000:	0e310813          	addi	a6,sp,227
    2004:	00080613          	mv	a2,a6
    2008:	00a00513          	li	a0,10
    200c:	06300313          	li	t1,99
    2010:	00c0006f          	j	201c <_vfprintf_r+0xb18>
    2014:	00058613          	mv	a2,a1
    2018:	00068713          	mv	a4,a3
    201c:	02a767b3          	rem	a5,a4,a0
    2020:	fff60593          	addi	a1,a2,-1
    2024:	03078793          	addi	a5,a5,48
    2028:	fef60fa3          	sb	a5,-1(a2)
    202c:	02a746b3          	div	a3,a4,a0
    2030:	fee342e3          	blt	t1,a4,2014 <_vfprintf_r+0xb10>
    2034:	03068713          	addi	a4,a3,48
    2038:	0ff77713          	andi	a4,a4,255
    203c:	ffe60693          	addi	a3,a2,-2
    2040:	fee58fa3          	sb	a4,-1(a1)
    2044:	0106e463          	bltu	a3,a6,204c <_vfprintf_r+0xb48>
    2048:	7ad0106f          	j	3ff4 <_vfprintf_r+0x2af0>
    204c:	0d610593          	addi	a1,sp,214
    2050:	0080006f          	j	2058 <_vfprintf_r+0xb54>
    2054:	0006c703          	lbu	a4,0(a3)
    2058:	00158593          	addi	a1,a1,1
    205c:	00168693          	addi	a3,a3,1
    2060:	fee58fa3          	sb	a4,-1(a1)
    2064:	ff0698e3          	bne	a3,a6,2054 <_vfprintf_r+0xb50>
    2068:	0e510713          	addi	a4,sp,229
    206c:	0d610793          	addi	a5,sp,214
    2070:	40c70733          	sub	a4,a4,a2
    2074:	00e78733          	add	a4,a5,a4
    2078:	0d410693          	addi	a3,sp,212
    207c:	40d707b3          	sub	a5,a4,a3
    2080:	02f12c23          	sw	a5,56(sp)
    2084:	01812783          	lw	a5,24(sp)
    2088:	03812683          	lw	a3,56(sp)
    208c:	00100713          	li	a4,1
    2090:	00d78b33          	add	s6,a5,a3
    2094:	00f74463          	blt	a4,a5,209c <_vfprintf_r+0xb98>
    2098:	66d0106f          	j	3f04 <_vfprintf_r+0x2a00>
    209c:	02812783          	lw	a5,40(sp)
    20a0:	00fb0b33          	add	s6,s6,a5
    20a4:	05412783          	lw	a5,84(sp)
    20a8:	fffb4993          	not	s3,s6
    20ac:	41f9d993          	srai	s3,s3,0x1f
    20b0:	bff7f913          	andi	s2,a5,-1025
    20b4:	10096913          	ori	s2,s2,256
    20b8:	013b79b3          	and	s3,s6,s3
    20bc:	02012223          	sw	zero,36(sp)
    20c0:	02012023          	sw	zero,32(sp)
    20c4:	00012a23          	sw	zero,20(sp)
    20c8:	05c12783          	lw	a5,92(sp)
    20cc:	00079463          	bnez	a5,20d4 <_vfprintf_r+0xbd0>
    20d0:	0710106f          	j	3940 <_vfprintf_r+0x243c>
    20d4:	02d00713          	li	a4,45
    20d8:	0ce103a3          	sb	a4,199(sp)
    20dc:	00000313          	li	t1,0
    20e0:	00198993          	addi	s3,s3,1
    20e4:	b2dff06f          	j	1c10 <_vfprintf_r+0x70c>
    20e8:	02097793          	andi	a5,s2,32
    20ec:	000c0313          	mv	t1,s8
    20f0:	01096993          	ori	s3,s2,16
    20f4:	1e079263          	bnez	a5,22d8 <_vfprintf_r+0xdd4>
    20f8:	00c12783          	lw	a5,12(sp)
    20fc:	00478793          	addi	a5,a5,4
    2100:	00c12703          	lw	a4,12(sp)
    2104:	00f12623          	sw	a5,12(sp)
    2108:	00072c03          	lw	s8,0(a4)
    210c:	41fc5d93          	srai	s11,s8,0x1f
    2110:	000d8713          	mv	a4,s11
    2114:	9a0750e3          	bgez	a4,1ab4 <_vfprintf_r+0x5b0>
    2118:	41800c33          	neg	s8,s8
    211c:	018037b3          	snez	a5,s8
    2120:	41b00db3          	neg	s11,s11
    2124:	40fd8db3          	sub	s11,s11,a5
    2128:	02d00793          	li	a5,45
    212c:	0cf103a3          	sb	a5,199(sp)
    2130:	fff00713          	li	a4,-1
    2134:	00100793          	li	a5,1
    2138:	f4e31863          	bne	t1,a4,1888 <_vfprintf_r+0x384>
    213c:	00100713          	li	a4,1
    2140:	20e78863          	beq	a5,a4,2350 <_vfprintf_r+0xe4c>
    2144:	00200713          	li	a4,2
    2148:	24e78263          	beq	a5,a4,238c <_vfprintf_r+0xe88>
    214c:	1b010693          	addi	a3,sp,432
    2150:	0080006f          	j	2158 <_vfprintf_r+0xc54>
    2154:	000c8693          	mv	a3,s9
    2158:	01dd9793          	slli	a5,s11,0x1d
    215c:	007c7713          	andi	a4,s8,7
    2160:	003c5c13          	srli	s8,s8,0x3
    2164:	03070713          	addi	a4,a4,48
    2168:	0187ec33          	or	s8,a5,s8
    216c:	003ddd93          	srli	s11,s11,0x3
    2170:	fee68fa3          	sb	a4,-1(a3)
    2174:	01bc67b3          	or	a5,s8,s11
    2178:	fff68c93          	addi	s9,a3,-1
    217c:	fc079ce3          	bnez	a5,2154 <_vfprintf_r+0xc50>
    2180:	0019f613          	andi	a2,s3,1
    2184:	22060e63          	beqz	a2,23c0 <_vfprintf_r+0xebc>
    2188:	03000613          	li	a2,48
    218c:	22c70a63          	beq	a4,a2,23c0 <_vfprintf_r+0xebc>
    2190:	ffe68693          	addi	a3,a3,-2
    2194:	1b010793          	addi	a5,sp,432
    2198:	fecc8fa3          	sb	a2,-1(s9)
    219c:	40d78b33          	sub	s6,a5,a3
    21a0:	00098913          	mv	s2,s3
    21a4:	00068c93          	mv	s9,a3
    21a8:	f08ff06f          	j	18b0 <_vfprintf_r+0x3ac>
    21ac:	00c12703          	lw	a4,12(sp)
    21b0:	ffff87b7          	lui	a5,0xffff8
    21b4:	8307c793          	xori	a5,a5,-2000
    21b8:	0cf11423          	sh	a5,200(sp)
    21bc:	00470793          	addi	a5,a4,4
    21c0:	00f12623          	sw	a5,12(sp)
    21c4:	00013797          	auipc	a5,0x13
    21c8:	5d478793          	addi	a5,a5,1492 # 15798 <_data+0x480>
    21cc:	000c0313          	mv	t1,s8
    21d0:	02f12623          	sw	a5,44(sp)
    21d4:	00072c03          	lw	s8,0(a4)
    21d8:	00000d93          	li	s11,0
    21dc:	00296993          	ori	s3,s2,2
    21e0:	00200793          	li	a5,2
    21e4:	07800a93          	li	s5,120
    21e8:	e94ff06f          	j	187c <_vfprintf_r+0x378>
    21ec:	0c714783          	lbu	a5,199(sp)
    21f0:	0004ce03          	lbu	t3,0(s1)
    21f4:	cc079463          	bnez	a5,16bc <_vfprintf_r+0x1b8>
    21f8:	02000793          	li	a5,32
    21fc:	0cf103a3          	sb	a5,199(sp)
    2200:	cbcff06f          	j	16bc <_vfprintf_r+0x1b8>
    2204:	02b00793          	li	a5,43
    2208:	0cf103a3          	sb	a5,199(sp)
    220c:	0004ce03          	lbu	t3,0(s1)
    2210:	cacff06f          	j	16bc <_vfprintf_r+0x1b8>
    2214:	00c12783          	lw	a5,12(sp)
    2218:	0004ce03          	lbu	t3,0(s1)
    221c:	0007a403          	lw	s0,0(a5)
    2220:	00478793          	addi	a5,a5,4
    2224:	00f12623          	sw	a5,12(sp)
    2228:	c8045a63          	bgez	s0,16bc <_vfprintf_r+0x1b8>
    222c:	40800433          	neg	s0,s0
    2230:	00496913          	ori	s2,s2,4
    2234:	c88ff06f          	j	16bc <_vfprintf_r+0x1b8>
    2238:	00196913          	ori	s2,s2,1
    223c:	0004ce03          	lbu	t3,0(s1)
    2240:	c7cff06f          	j	16bc <_vfprintf_r+0x1b8>
    2244:	02097793          	andi	a5,s2,32
    2248:	000c0313          	mv	t1,s8
    224c:	0c079c63          	bnez	a5,2324 <_vfprintf_r+0xe20>
    2250:	00c12683          	lw	a3,12(sp)
    2254:	01097713          	andi	a4,s2,16
    2258:	00468793          	addi	a5,a3,4
    225c:	0006ac03          	lw	s8,0(a3)
    2260:	94071ce3          	bnez	a4,1bb8 <_vfprintf_r+0x6b4>
    2264:	04097713          	andi	a4,s2,64
    2268:	6c0702e3          	beqz	a4,312c <_vfprintf_r+0x1c28>
    226c:	010c1c13          	slli	s8,s8,0x10
    2270:	010c5c13          	srli	s8,s8,0x10
    2274:	00000d93          	li	s11,0
    2278:	00f12623          	sw	a5,12(sp)
    227c:	0c40006f          	j	2340 <_vfprintf_r+0xe3c>
    2280:	02097793          	andi	a5,s2,32
    2284:	000c0313          	mv	t1,s8
    2288:	06079a63          	bnez	a5,22fc <_vfprintf_r+0xdf8>
    228c:	00c12683          	lw	a3,12(sp)
    2290:	01097713          	andi	a4,s2,16
    2294:	00468793          	addi	a5,a3,4
    2298:	0006ac03          	lw	s8,0(a3)
    229c:	00070463          	beqz	a4,22a4 <_vfprintf_r+0xda0>
    22a0:	54d0106f          	j	3fec <_vfprintf_r+0x2ae8>
    22a4:	04097713          	andi	a4,s2,64
    22a8:	68070ee3          	beqz	a4,3144 <_vfprintf_r+0x1c40>
    22ac:	010c1c13          	slli	s8,s8,0x10
    22b0:	00f12623          	sw	a5,12(sp)
    22b4:	010c5c13          	srli	s8,s8,0x10
    22b8:	00000d93          	li	s11,0
    22bc:	00090993          	mv	s3,s2
    22c0:	00100793          	li	a5,1
    22c4:	db8ff06f          	j	187c <_vfprintf_r+0x378>
    22c8:	01c12503          	lw	a0,28(sp)
    22cc:	744020ef          	jal	ra,4a10 <__sinit>
    22d0:	ab4ff06f          	j	1584 <_vfprintf_r+0x80>
    22d4:	00090993          	mv	s3,s2
    22d8:	00c12783          	lw	a5,12(sp)
    22dc:	00778793          	addi	a5,a5,7
    22e0:	ff87f793          	andi	a5,a5,-8
    22e4:	0047a703          	lw	a4,4(a5)
    22e8:	00878693          	addi	a3,a5,8
    22ec:	00d12623          	sw	a3,12(sp)
    22f0:	0007ac03          	lw	s8,0(a5)
    22f4:	00070d93          	mv	s11,a4
    22f8:	fb8ff06f          	j	1ab0 <_vfprintf_r+0x5ac>
    22fc:	00090993          	mv	s3,s2
    2300:	00c12783          	lw	a5,12(sp)
    2304:	00778793          	addi	a5,a5,7
    2308:	ff87f793          	andi	a5,a5,-8
    230c:	00878713          	addi	a4,a5,8
    2310:	0007ac03          	lw	s8,0(a5)
    2314:	0047ad83          	lw	s11,4(a5)
    2318:	00e12623          	sw	a4,12(sp)
    231c:	00100793          	li	a5,1
    2320:	d5cff06f          	j	187c <_vfprintf_r+0x378>
    2324:	00c12783          	lw	a5,12(sp)
    2328:	00778793          	addi	a5,a5,7
    232c:	ff87f793          	andi	a5,a5,-8
    2330:	0007ac03          	lw	s8,0(a5)
    2334:	0047ad83          	lw	s11,4(a5)
    2338:	00878713          	addi	a4,a5,8
    233c:	00e12623          	sw	a4,12(sp)
    2340:	bff97993          	andi	s3,s2,-1025
    2344:	00000793          	li	a5,0
    2348:	d34ff06f          	j	187c <_vfprintf_r+0x378>
    234c:	00090993          	mv	s3,s2
    2350:	360d90e3          	bnez	s11,2eb0 <_vfprintf_r+0x19ac>
    2354:	00900793          	li	a5,9
    2358:	3587ece3          	bltu	a5,s8,2eb0 <_vfprintf_r+0x19ac>
    235c:	030c0c13          	addi	s8,s8,48
    2360:	1b8107a3          	sb	s8,431(sp)
    2364:	00098913          	mv	s2,s3
    2368:	00100b13          	li	s6,1
    236c:	1af10c93          	addi	s9,sp,431
    2370:	d40ff06f          	j	18b0 <_vfprintf_r+0x3ac>
    2374:	00100713          	li	a4,1
    2378:	00e79463          	bne	a5,a4,2380 <_vfprintf_r+0xe7c>
    237c:	5180106f          	j	3894 <_vfprintf_r+0x2390>
    2380:	00200713          	li	a4,2
    2384:	00090993          	mv	s3,s2
    2388:	dce792e3          	bne	a5,a4,214c <_vfprintf_r+0xc48>
    238c:	02c12683          	lw	a3,44(sp)
    2390:	1b010c93          	addi	s9,sp,432
    2394:	00fc7793          	andi	a5,s8,15
    2398:	00f687b3          	add	a5,a3,a5
    239c:	0007c783          	lbu	a5,0(a5)
    23a0:	01cd9713          	slli	a4,s11,0x1c
    23a4:	004c5c13          	srli	s8,s8,0x4
    23a8:	fffc8c93          	addi	s9,s9,-1
    23ac:	01876c33          	or	s8,a4,s8
    23b0:	004ddd93          	srli	s11,s11,0x4
    23b4:	00fc8023          	sb	a5,0(s9)
    23b8:	01bc67b3          	or	a5,s8,s11
    23bc:	fc079ce3          	bnez	a5,2394 <_vfprintf_r+0xe90>
    23c0:	1b010793          	addi	a5,sp,432
    23c4:	41978b33          	sub	s6,a5,s9
    23c8:	00098913          	mv	s2,s3
    23cc:	ce4ff06f          	j	18b0 <_vfprintf_r+0x3ac>
    23d0:	06500693          	li	a3,101
    23d4:	3956da63          	bge	a3,s5,2768 <_vfprintf_r+0x1264>
    23d8:	0f012683          	lw	a3,240(sp)
    23dc:	0a010593          	addi	a1,sp,160
    23e0:	0b010513          	addi	a0,sp,176
    23e4:	0ad12823          	sw	a3,176(sp)
    23e8:	0f412683          	lw	a3,244(sp)
    23ec:	02e12a23          	sw	a4,52(sp)
    23f0:	0a012023          	sw	zero,160(sp)
    23f4:	0ad12a23          	sw	a3,180(sp)
    23f8:	0f812683          	lw	a3,248(sp)
    23fc:	0a012223          	sw	zero,164(sp)
    2400:	0a012423          	sw	zero,168(sp)
    2404:	0ad12c23          	sw	a3,184(sp)
    2408:	0fc12683          	lw	a3,252(sp)
    240c:	0a012623          	sw	zero,172(sp)
    2410:	0ad12e23          	sw	a3,188(sp)
    2414:	2c90f0ef          	jal	ra,11edc <__eqtf2>
    2418:	03412703          	lw	a4,52(sp)
    241c:	5a051463          	bnez	a0,29c4 <_vfprintf_r+0x14c0>
    2420:	0e812783          	lw	a5,232(sp)
    2424:	00013697          	auipc	a3,0x13
    2428:	3a468693          	addi	a3,a3,932 # 157c8 <_data+0x4b0>
    242c:	00170713          	addi	a4,a4,1
    2430:	00dd2023          	sw	a3,0(s10)
    2434:	00178793          	addi	a5,a5,1
    2438:	00100693          	li	a3,1
    243c:	00dd2223          	sw	a3,4(s10)
    2440:	0ee12623          	sw	a4,236(sp)
    2444:	0ef12423          	sw	a5,232(sp)
    2448:	00700713          	li	a4,7
    244c:	008d0d13          	addi	s10,s10,8
    2450:	32f748e3          	blt	a4,a5,2f80 <_vfprintf_r+0x1a7c>
    2454:	0cc12783          	lw	a5,204(sp)
    2458:	01812703          	lw	a4,24(sp)
    245c:	00e7ca63          	blt	a5,a4,2470 <_vfprintf_r+0xf6c>
    2460:	00197793          	andi	a5,s2,1
    2464:	00079663          	bnez	a5,2470 <_vfprintf_r+0xf6c>
    2468:	0ec12703          	lw	a4,236(sp)
    246c:	871ff06f          	j	1cdc <_vfprintf_r+0x7d8>
    2470:	03012783          	lw	a5,48(sp)
    2474:	02812683          	lw	a3,40(sp)
    2478:	0ec12703          	lw	a4,236(sp)
    247c:	00fd2023          	sw	a5,0(s10)
    2480:	0e812783          	lw	a5,232(sp)
    2484:	00e68733          	add	a4,a3,a4
    2488:	00dd2223          	sw	a3,4(s10)
    248c:	00178793          	addi	a5,a5,1
    2490:	0ee12623          	sw	a4,236(sp)
    2494:	0ef12423          	sw	a5,232(sp)
    2498:	00700693          	li	a3,7
    249c:	008d0d13          	addi	s10,s10,8
    24a0:	02f6cee3          	blt	a3,a5,2cdc <_vfprintf_r+0x17d8>
    24a4:	01812783          	lw	a5,24(sp)
    24a8:	fff78b13          	addi	s6,a5,-1
    24ac:	836058e3          	blez	s6,1cdc <_vfprintf_r+0x7d8>
    24b0:	0e812783          	lw	a5,232(sp)
    24b4:	2f6bd6e3          	bge	s7,s6,2fa0 <_vfprintf_r+0x1a9c>
    24b8:	00700c13          	li	s8,7
    24bc:	00412a83          	lw	s5,4(sp)
    24c0:	00c0006f          	j	24cc <_vfprintf_r+0xfc8>
    24c4:	ff0b0b13          	addi	s6,s6,-16
    24c8:	2d6bdce3          	bge	s7,s6,2fa0 <_vfprintf_r+0x1a9c>
    24cc:	01070713          	addi	a4,a4,16
    24d0:	00178793          	addi	a5,a5,1
    24d4:	00013697          	auipc	a3,0x13
    24d8:	30868693          	addi	a3,a3,776 # 157dc <zeroes.4505>
    24dc:	00dd2023          	sw	a3,0(s10)
    24e0:	017d2223          	sw	s7,4(s10)
    24e4:	0ee12623          	sw	a4,236(sp)
    24e8:	0ef12423          	sw	a5,232(sp)
    24ec:	008d0d13          	addi	s10,s10,8
    24f0:	fcfc5ae3          	bge	s8,a5,24c4 <_vfprintf_r+0xfc0>
    24f4:	0e410613          	addi	a2,sp,228
    24f8:	000a8593          	mv	a1,s5
    24fc:	000a0513          	mv	a0,s4
    2500:	13c0b0ef          	jal	ra,d63c <__sprint_r>
    2504:	ac051063          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    2508:	0ec12703          	lw	a4,236(sp)
    250c:	0e812783          	lw	a5,232(sp)
    2510:	10c10d13          	addi	s10,sp,268
    2514:	fb1ff06f          	j	24c4 <_vfprintf_r+0xfc0>
    2518:	41340c33          	sub	s8,s0,s3
    251c:	f9805463          	blez	s8,1ca4 <_vfprintf_r+0x7a0>
    2520:	0e812683          	lw	a3,232(sp)
    2524:	0b8bd463          	bge	s7,s8,25cc <_vfprintf_r+0x10c8>
    2528:	02912a23          	sw	s1,52(sp)
    252c:	000d0793          	mv	a5,s10
    2530:	000c0493          	mv	s1,s8
    2534:	000c8d13          	mv	s10,s9
    2538:	00098c13          	mv	s8,s3
    253c:	000b0c93          	mv	s9,s6
    2540:	00040993          	mv	s3,s0
    2544:	00700d93          	li	s11,7
    2548:	00412403          	lw	s0,4(sp)
    254c:	00030b13          	mv	s6,t1
    2550:	00c0006f          	j	255c <_vfprintf_r+0x1058>
    2554:	ff048493          	addi	s1,s1,-16
    2558:	049bda63          	bge	s7,s1,25ac <_vfprintf_r+0x10a8>
    255c:	01070713          	addi	a4,a4,16
    2560:	00168693          	addi	a3,a3,1
    2564:	00013617          	auipc	a2,0x13
    2568:	27860613          	addi	a2,a2,632 # 157dc <zeroes.4505>
    256c:	00c7a023          	sw	a2,0(a5)
    2570:	0177a223          	sw	s7,4(a5)
    2574:	0ee12623          	sw	a4,236(sp)
    2578:	0ed12423          	sw	a3,232(sp)
    257c:	00878793          	addi	a5,a5,8
    2580:	fcdddae3          	bge	s11,a3,2554 <_vfprintf_r+0x1050>
    2584:	0e410613          	addi	a2,sp,228
    2588:	00040593          	mv	a1,s0
    258c:	000a0513          	mv	a0,s4
    2590:	0ac0b0ef          	jal	ra,d63c <__sprint_r>
    2594:	a2051863          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    2598:	ff048493          	addi	s1,s1,-16
    259c:	0ec12703          	lw	a4,236(sp)
    25a0:	0e812683          	lw	a3,232(sp)
    25a4:	10c10793          	addi	a5,sp,268
    25a8:	fa9bcae3          	blt	s7,s1,255c <_vfprintf_r+0x1058>
    25ac:	00098413          	mv	s0,s3
    25b0:	000c0993          	mv	s3,s8
    25b4:	00048c13          	mv	s8,s1
    25b8:	03412483          	lw	s1,52(sp)
    25bc:	000b0313          	mv	t1,s6
    25c0:	000c8b13          	mv	s6,s9
    25c4:	000d0c93          	mv	s9,s10
    25c8:	00078d13          	mv	s10,a5
    25cc:	01870733          	add	a4,a4,s8
    25d0:	00168693          	addi	a3,a3,1
    25d4:	00013797          	auipc	a5,0x13
    25d8:	20878793          	addi	a5,a5,520 # 157dc <zeroes.4505>
    25dc:	00fd2023          	sw	a5,0(s10)
    25e0:	018d2223          	sw	s8,4(s10)
    25e4:	0ee12623          	sw	a4,236(sp)
    25e8:	0ed12423          	sw	a3,232(sp)
    25ec:	00700613          	li	a2,7
    25f0:	008d0d13          	addi	s10,s10,8
    25f4:	ead65863          	bge	a2,a3,1ca4 <_vfprintf_r+0x7a0>
    25f8:	00412583          	lw	a1,4(sp)
    25fc:	0e410613          	addi	a2,sp,228
    2600:	000a0513          	mv	a0,s4
    2604:	02612a23          	sw	t1,52(sp)
    2608:	0340b0ef          	jal	ra,d63c <__sprint_r>
    260c:	9a051c63          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    2610:	0ec12703          	lw	a4,236(sp)
    2614:	10c10d13          	addi	s10,sp,268
    2618:	03412303          	lw	t1,52(sp)
    261c:	e88ff06f          	j	1ca4 <_vfprintf_r+0x7a0>
    2620:	0e812683          	lw	a3,232(sp)
    2624:	098bd863          	bge	s7,s8,26b4 <_vfprintf_r+0x11b0>
    2628:	02912a23          	sw	s1,52(sp)
    262c:	00700d93          	li	s11,7
    2630:	000c0493          	mv	s1,s8
    2634:	000b0c13          	mv	s8,s6
    2638:	00098b13          	mv	s6,s3
    263c:	00040993          	mv	s3,s0
    2640:	00412403          	lw	s0,4(sp)
    2644:	00c0006f          	j	2650 <_vfprintf_r+0x114c>
    2648:	ff048493          	addi	s1,s1,-16
    264c:	049bda63          	bge	s7,s1,26a0 <_vfprintf_r+0x119c>
    2650:	01070713          	addi	a4,a4,16
    2654:	00168693          	addi	a3,a3,1
    2658:	00013797          	auipc	a5,0x13
    265c:	18478793          	addi	a5,a5,388 # 157dc <zeroes.4505>
    2660:	00fd2023          	sw	a5,0(s10)
    2664:	017d2223          	sw	s7,4(s10)
    2668:	0ee12623          	sw	a4,236(sp)
    266c:	0ed12423          	sw	a3,232(sp)
    2670:	008d0d13          	addi	s10,s10,8
    2674:	fcdddae3          	bge	s11,a3,2648 <_vfprintf_r+0x1144>
    2678:	0e410613          	addi	a2,sp,228
    267c:	00040593          	mv	a1,s0
    2680:	000a0513          	mv	a0,s4
    2684:	7b90a0ef          	jal	ra,d63c <__sprint_r>
    2688:	92051e63          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    268c:	ff048493          	addi	s1,s1,-16
    2690:	0ec12703          	lw	a4,236(sp)
    2694:	0e812683          	lw	a3,232(sp)
    2698:	10c10d13          	addi	s10,sp,268
    269c:	fa9bcae3          	blt	s7,s1,2650 <_vfprintf_r+0x114c>
    26a0:	00098413          	mv	s0,s3
    26a4:	000b0993          	mv	s3,s6
    26a8:	000c0b13          	mv	s6,s8
    26ac:	00048c13          	mv	s8,s1
    26b0:	03412483          	lw	s1,52(sp)
    26b4:	01870733          	add	a4,a4,s8
    26b8:	00168693          	addi	a3,a3,1
    26bc:	00013797          	auipc	a5,0x13
    26c0:	12078793          	addi	a5,a5,288 # 157dc <zeroes.4505>
    26c4:	00fd2023          	sw	a5,0(s10)
    26c8:	018d2223          	sw	s8,4(s10)
    26cc:	0ee12623          	sw	a4,236(sp)
    26d0:	0ed12423          	sw	a3,232(sp)
    26d4:	00700613          	li	a2,7
    26d8:	008d0d13          	addi	s10,s10,8
    26dc:	dcd65863          	bge	a2,a3,1cac <_vfprintf_r+0x7a8>
    26e0:	00412583          	lw	a1,4(sp)
    26e4:	0e410613          	addi	a2,sp,228
    26e8:	000a0513          	mv	a0,s4
    26ec:	7510a0ef          	jal	ra,d63c <__sprint_r>
    26f0:	8c051a63          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    26f4:	0ec12703          	lw	a4,236(sp)
    26f8:	10c10d13          	addi	s10,sp,268
    26fc:	db0ff06f          	j	1cac <_vfprintf_r+0x7a8>
    2700:	00197593          	andi	a1,s2,1
    2704:	08059263          	bnez	a1,2788 <_vfprintf_r+0x1284>
    2708:	00dd2223          	sw	a3,4(s10)
    270c:	0ee12623          	sw	a4,236(sp)
    2710:	0f612423          	sw	s6,232(sp)
    2714:	00700793          	li	a5,7
    2718:	5967ca63          	blt	a5,s6,2cac <_vfprintf_r+0x17a8>
    271c:	00260a93          	addi	s5,a2,2
    2720:	010d0d13          	addi	s10,s10,16
    2724:	03812683          	lw	a3,56(sp)
    2728:	0d410793          	addi	a5,sp,212
    272c:	00fc2023          	sw	a5,0(s8)
    2730:	00e68733          	add	a4,a3,a4
    2734:	00dc2223          	sw	a3,4(s8)
    2738:	0ee12623          	sw	a4,236(sp)
    273c:	0f512423          	sw	s5,232(sp)
    2740:	00700793          	li	a5,7
    2744:	d957dc63          	bge	a5,s5,1cdc <_vfprintf_r+0x7d8>
    2748:	00412583          	lw	a1,4(sp)
    274c:	0e410613          	addi	a2,sp,228
    2750:	000a0513          	mv	a0,s4
    2754:	6e90a0ef          	jal	ra,d63c <__sprint_r>
    2758:	86051663          	bnez	a0,17c4 <_vfprintf_r+0x2c0>
    275c:	0ec12703          	lw	a4,236(sp)
    2760:	10c10d13          	addi	s10,sp,268
    2764:	d78ff06f          	j	1cdc <_vfprintf_r+0x7d8>
    2768:	0e812603          	lw	a2,232(sp)
    276c:	01812783          	lw	a5,24(sp)
    2770:	00100693          	li	a3,1
    2774:	019d2023          	sw	s9,0(s10)
    2778:	00170713          	addi	a4,a4,1
    277c:	00160b13          	addi	s6,a2,1
    2780:	008d0c13          	addi	s8,s10,8
    2784:	f6f6dee3          	bge	a3,a5,2700 <_vfprintf_r+0x11fc>
    2788:	00100693          	li	a3,1
    278c:	00dd2223          	sw	a3,4(s10)
    2790:	0ee12623          	sw	a4,236(sp)
    2794:	0f612423          	sw	s6,232(sp)
    2798:	00700693          	li	a3,7
    279c:	6166cc63          	blt	a3,s6,2db4 <_vfprintf_r+0x18b0>
    27a0:	02812783          	lw	a5,40(sp)
    27a4:	03012683          	lw	a3,48(sp)
    27a8:	001b0b13          	addi	s6,s6,1
    27ac:	00f70733          	add	a4,a4,a5
    27b0:	00dc2023          	sw	a3,0(s8)
    27b4:	00fc2223          	sw	a5,4(s8)
    27b8:	0ee12623          	sw	a4,236(sp)
    27bc:	0f612423          	sw	s6,232(sp)
    27c0:	00700693          	li	a3,7
    27c4:	008c0c13          	addi	s8,s8,8
    27c8:	6166ca63          	blt	a3,s6,2ddc <_vfprintf_r+0x18d8>
    27cc:	0f012683          	lw	a3,240(sp)
    27d0:	01812783          	lw	a5,24(sp)
    27d4:	001b0813          	addi	a6,s6,1
    27d8:	0ad12823          	sw	a3,176(sp)
    27dc:	0f412683          	lw	a3,244(sp)
    27e0:	0a010593          	addi	a1,sp,160
    27e4:	0b010513          	addi	a0,sp,176
    27e8:	0ad12a23          	sw	a3,180(sp)
    27ec:	0f812683          	lw	a3,248(sp)
    27f0:	02e12223          	sw	a4,36(sp)
    27f4:	00080a93          	mv	s5,a6
    27f8:	0ad12c23          	sw	a3,184(sp)
    27fc:	0fc12683          	lw	a3,252(sp)
    2800:	03012023          	sw	a6,32(sp)
    2804:	0a012023          	sw	zero,160(sp)
    2808:	0ad12e23          	sw	a3,188(sp)
    280c:	fff78693          	addi	a3,a5,-1
    2810:	00d12a23          	sw	a3,20(sp)
    2814:	0a012223          	sw	zero,164(sp)
    2818:	0a012423          	sw	zero,168(sp)
    281c:	0a012623          	sw	zero,172(sp)
    2820:	6bc0f0ef          	jal	ra,11edc <__eqtf2>
    2824:	008c0d13          	addi	s10,s8,8
    2828:	01412683          	lw	a3,20(sp)
    282c:	02012803          	lw	a6,32(sp)
    2830:	02412703          	lw	a4,36(sp)
    2834:	30050863          	beqz	a0,2b44 <_vfprintf_r+0x1640>
    2838:	001c8793          	addi	a5,s9,1
    283c:	00d70733          	add	a4,a4,a3
    2840:	00fc2023          	sw	a5,0(s8)
    2844:	00dc2223          	sw	a3,4(s8)
    2848:	0ee12623          	sw	a4,236(sp)
    284c:	0f512423          	sw	s5,232(sp)
    2850:	00700793          	li	a5,7
    2854:	4557cc63          	blt	a5,s5,2cac <_vfprintf_r+0x17a8>
    2858:	010c0793          	addi	a5,s8,16
    285c:	002b0a93          	addi	s5,s6,2
    2860:	000d0c13          	mv	s8,s10
    2864:	00078d13          	mv	s10,a5
    2868:	ebdff06f          	j	2724 <_vfprintf_r+0x1220>
    286c:	00090993          	mv	s3,s2
    2870:	8cdff06f          	j	213c <_vfprintf_r+0xc38>
    2874:	0e812683          	lw	a3,232(sp)
    2878:	00013c17          	auipc	s8,0x13
    287c:	f54c0c13          	addi	s8,s8,-172 # 157cc <blanks.4504>
    2880:	0d0bd063          	bge	s7,a6,2940 <_vfprintf_r+0x143c>
    2884:	04912423          	sw	s1,72(sp)
    2888:	05212623          	sw	s2,76(sp)
    288c:	000d0793          	mv	a5,s10
    2890:	000c0913          	mv	s2,s8
    2894:	000c8d13          	mv	s10,s9
    2898:	00098c13          	mv	s8,s3
    289c:	000b0c93          	mv	s9,s6
    28a0:	00040993          	mv	s3,s0
    28a4:	00700293          	li	t0,7
    28a8:	03f12a23          	sw	t6,52(sp)
    28ac:	00412483          	lw	s1,4(sp)
    28b0:	00030b13          	mv	s6,t1
    28b4:	00080413          	mv	s0,a6
    28b8:	00c0006f          	j	28c4 <_vfprintf_r+0x13c0>
    28bc:	ff040413          	addi	s0,s0,-16
    28c0:	048bda63          	bge	s7,s0,2914 <_vfprintf_r+0x1410>
    28c4:	01070713          	addi	a4,a4,16
    28c8:	00168693          	addi	a3,a3,1
    28cc:	0127a023          	sw	s2,0(a5)
    28d0:	0177a223          	sw	s7,4(a5)
    28d4:	0ee12623          	sw	a4,236(sp)
    28d8:	0ed12423          	sw	a3,232(sp)
    28dc:	00878793          	addi	a5,a5,8
    28e0:	fcd2dee3          	bge	t0,a3,28bc <_vfprintf_r+0x13b8>
    28e4:	0e410613          	addi	a2,sp,228
    28e8:	00048593          	mv	a1,s1
    28ec:	000a0513          	mv	a0,s4
    28f0:	54d0a0ef          	jal	ra,d63c <__sprint_r>
    28f4:	00050463          	beqz	a0,28fc <_vfprintf_r+0x13f8>
    28f8:	ecdfe06f          	j	17c4 <_vfprintf_r+0x2c0>
    28fc:	ff040413          	addi	s0,s0,-16
    2900:	0ec12703          	lw	a4,236(sp)
    2904:	0e812683          	lw	a3,232(sp)
    2908:	10c10793          	addi	a5,sp,268
    290c:	00700293          	li	t0,7
    2910:	fa8bcae3          	blt	s7,s0,28c4 <_vfprintf_r+0x13c0>
    2914:	00040813          	mv	a6,s0
    2918:	03412f83          	lw	t6,52(sp)
    291c:	00098413          	mv	s0,s3
    2920:	04812483          	lw	s1,72(sp)
    2924:	000c0993          	mv	s3,s8
    2928:	00090c13          	mv	s8,s2
    292c:	04c12903          	lw	s2,76(sp)
    2930:	000b0313          	mv	t1,s6
    2934:	000c8b13          	mv	s6,s9
    2938:	000d0c93          	mv	s9,s10
    293c:	00078d13          	mv	s10,a5
    2940:	01070733          	add	a4,a4,a6
    2944:	00168693          	addi	a3,a3,1
    2948:	018d2023          	sw	s8,0(s10)
    294c:	010d2223          	sw	a6,4(s10)
    2950:	0ee12623          	sw	a4,236(sp)
    2954:	0ed12423          	sw	a3,232(sp)
    2958:	00700613          	li	a2,7
    295c:	008d0d13          	addi	s10,s10,8
    2960:	acd65863          	bge	a2,a3,1c30 <_vfprintf_r+0x72c>
    2964:	00412583          	lw	a1,4(sp)
    2968:	0e410613          	addi	a2,sp,228
    296c:	000a0513          	mv	a0,s4
    2970:	04612423          	sw	t1,72(sp)
    2974:	03f12a23          	sw	t6,52(sp)
    2978:	4c50a0ef          	jal	ra,d63c <__sprint_r>
    297c:	00050463          	beqz	a0,2984 <_vfprintf_r+0x1480>
    2980:	e45fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2984:	0ec12703          	lw	a4,236(sp)
    2988:	10c10d13          	addi	s10,sp,268
    298c:	04812303          	lw	t1,72(sp)
    2990:	03412f83          	lw	t6,52(sp)
    2994:	a9cff06f          	j	1c30 <_vfprintf_r+0x72c>
    2998:	00412583          	lw	a1,4(sp)
    299c:	0e410613          	addi	a2,sp,228
    29a0:	000a0513          	mv	a0,s4
    29a4:	02612a23          	sw	t1,52(sp)
    29a8:	4950a0ef          	jal	ra,d63c <__sprint_r>
    29ac:	00050463          	beqz	a0,29b4 <_vfprintf_r+0x14b0>
    29b0:	e15fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    29b4:	0ec12703          	lw	a4,236(sp)
    29b8:	10c10d13          	addi	s10,sp,268
    29bc:	03412303          	lw	t1,52(sp)
    29c0:	adcff06f          	j	1c9c <_vfprintf_r+0x798>
    29c4:	0cc12603          	lw	a2,204(sp)
    29c8:	42c05e63          	blez	a2,2e04 <_vfprintf_r+0x1900>
    29cc:	01812783          	lw	a5,24(sp)
    29d0:	01412683          	lw	a3,20(sp)
    29d4:	00078b13          	mv	s6,a5
    29d8:	28f6cc63          	blt	a3,a5,2c70 <_vfprintf_r+0x176c>
    29dc:	03605663          	blez	s6,2a08 <_vfprintf_r+0x1504>
    29e0:	0e812683          	lw	a3,232(sp)
    29e4:	01670733          	add	a4,a4,s6
    29e8:	019d2023          	sw	s9,0(s10)
    29ec:	00168693          	addi	a3,a3,1
    29f0:	016d2223          	sw	s6,4(s10)
    29f4:	0ee12623          	sw	a4,236(sp)
    29f8:	0ed12423          	sw	a3,232(sp)
    29fc:	00700613          	li	a2,7
    2a00:	008d0d13          	addi	s10,s10,8
    2a04:	1ed642e3          	blt	a2,a3,33e8 <_vfprintf_r+0x1ee4>
    2a08:	fffb4693          	not	a3,s6
    2a0c:	01412783          	lw	a5,20(sp)
    2a10:	41f6d693          	srai	a3,a3,0x1f
    2a14:	00db7b33          	and	s6,s6,a3
    2a18:	41678b33          	sub	s6,a5,s6
    2a1c:	33604263          	bgtz	s6,2d40 <_vfprintf_r+0x183c>
    2a20:	01412783          	lw	a5,20(sp)
    2a24:	40097693          	andi	a3,s2,1024
    2a28:	00fc8ab3          	add	s5,s9,a5
    2a2c:	7a069c63          	bnez	a3,31e4 <_vfprintf_r+0x1ce0>
    2a30:	0cc12b03          	lw	s6,204(sp)
    2a34:	01812783          	lw	a5,24(sp)
    2a38:	00fb4663          	blt	s6,a5,2a44 <_vfprintf_r+0x1540>
    2a3c:	00197693          	andi	a3,s2,1
    2a40:	1c068ae3          	beqz	a3,3414 <_vfprintf_r+0x1f10>
    2a44:	03012683          	lw	a3,48(sp)
    2a48:	02812783          	lw	a5,40(sp)
    2a4c:	00700613          	li	a2,7
    2a50:	00dd2023          	sw	a3,0(s10)
    2a54:	0e812683          	lw	a3,232(sp)
    2a58:	00f70733          	add	a4,a4,a5
    2a5c:	00fd2223          	sw	a5,4(s10)
    2a60:	00168693          	addi	a3,a3,1
    2a64:	0ee12623          	sw	a4,236(sp)
    2a68:	0ed12423          	sw	a3,232(sp)
    2a6c:	008d0d13          	addi	s10,s10,8
    2a70:	00d65463          	bge	a2,a3,2a78 <_vfprintf_r+0x1574>
    2a74:	05c0106f          	j	3ad0 <_vfprintf_r+0x25cc>
    2a78:	01812683          	lw	a3,24(sp)
    2a7c:	00dc87b3          	add	a5,s9,a3
    2a80:	41668b33          	sub	s6,a3,s6
    2a84:	415787b3          	sub	a5,a5,s5
    2a88:	000b0c13          	mv	s8,s6
    2a8c:	0167d463          	bge	a5,s6,2a94 <_vfprintf_r+0x1590>
    2a90:	00078c13          	mv	s8,a5
    2a94:	03805863          	blez	s8,2ac4 <_vfprintf_r+0x15c0>
    2a98:	0e812783          	lw	a5,232(sp)
    2a9c:	01870733          	add	a4,a4,s8
    2aa0:	015d2023          	sw	s5,0(s10)
    2aa4:	00178793          	addi	a5,a5,1
    2aa8:	018d2223          	sw	s8,4(s10)
    2aac:	0ee12623          	sw	a4,236(sp)
    2ab0:	0ef12423          	sw	a5,232(sp)
    2ab4:	00700693          	li	a3,7
    2ab8:	008d0d13          	addi	s10,s10,8
    2abc:	00f6d463          	bge	a3,a5,2ac4 <_vfprintf_r+0x15c0>
    2ac0:	0980106f          	j	3b58 <_vfprintf_r+0x2654>
    2ac4:	fffc4793          	not	a5,s8
    2ac8:	41f7d793          	srai	a5,a5,0x1f
    2acc:	00fc7c33          	and	s8,s8,a5
    2ad0:	418b0b33          	sub	s6,s6,s8
    2ad4:	a1605463          	blez	s6,1cdc <_vfprintf_r+0x7d8>
    2ad8:	0e812783          	lw	a5,232(sp)
    2adc:	4d6bd263          	bge	s7,s6,2fa0 <_vfprintf_r+0x1a9c>
    2ae0:	00700c13          	li	s8,7
    2ae4:	00412a83          	lw	s5,4(sp)
    2ae8:	00c0006f          	j	2af4 <_vfprintf_r+0x15f0>
    2aec:	ff0b0b13          	addi	s6,s6,-16
    2af0:	4b6bd863          	bge	s7,s6,2fa0 <_vfprintf_r+0x1a9c>
    2af4:	01070713          	addi	a4,a4,16
    2af8:	00178793          	addi	a5,a5,1
    2afc:	00013697          	auipc	a3,0x13
    2b00:	ce068693          	addi	a3,a3,-800 # 157dc <zeroes.4505>
    2b04:	00dd2023          	sw	a3,0(s10)
    2b08:	017d2223          	sw	s7,4(s10)
    2b0c:	0ee12623          	sw	a4,236(sp)
    2b10:	0ef12423          	sw	a5,232(sp)
    2b14:	008d0d13          	addi	s10,s10,8
    2b18:	fcfc5ae3          	bge	s8,a5,2aec <_vfprintf_r+0x15e8>
    2b1c:	0e410613          	addi	a2,sp,228
    2b20:	000a8593          	mv	a1,s5
    2b24:	000a0513          	mv	a0,s4
    2b28:	3150a0ef          	jal	ra,d63c <__sprint_r>
    2b2c:	00050463          	beqz	a0,2b34 <_vfprintf_r+0x1630>
    2b30:	c95fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2b34:	0ec12703          	lw	a4,236(sp)
    2b38:	0e812783          	lw	a5,232(sp)
    2b3c:	10c10d13          	addi	s10,sp,268
    2b40:	fadff06f          	j	2aec <_vfprintf_r+0x15e8>
    2b44:	bed050e3          	blez	a3,2724 <_vfprintf_r+0x1220>
    2b48:	00dbc463          	blt	s7,a3,2b50 <_vfprintf_r+0x164c>
    2b4c:	4740106f          	j	3fc0 <_vfprintf_r+0x2abc>
    2b50:	00700a93          	li	s5,7
    2b54:	00068d13          	mv	s10,a3
    2b58:	00412c83          	lw	s9,4(sp)
    2b5c:	00080b13          	mv	s6,a6
    2b60:	0100006f          	j	2b70 <_vfprintf_r+0x166c>
    2b64:	ff0d0d13          	addi	s10,s10,-16
    2b68:	11abda63          	bge	s7,s10,2c7c <_vfprintf_r+0x1778>
    2b6c:	001b0b13          	addi	s6,s6,1
    2b70:	01070713          	addi	a4,a4,16
    2b74:	00013797          	auipc	a5,0x13
    2b78:	c6878793          	addi	a5,a5,-920 # 157dc <zeroes.4505>
    2b7c:	00fc2023          	sw	a5,0(s8)
    2b80:	017c2223          	sw	s7,4(s8)
    2b84:	0ee12623          	sw	a4,236(sp)
    2b88:	0f612423          	sw	s6,232(sp)
    2b8c:	008c0c13          	addi	s8,s8,8
    2b90:	fd6adae3          	bge	s5,s6,2b64 <_vfprintf_r+0x1660>
    2b94:	0e410613          	addi	a2,sp,228
    2b98:	000c8593          	mv	a1,s9
    2b9c:	000a0513          	mv	a0,s4
    2ba0:	29d0a0ef          	jal	ra,d63c <__sprint_r>
    2ba4:	00050463          	beqz	a0,2bac <_vfprintf_r+0x16a8>
    2ba8:	c1dfe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2bac:	0ec12703          	lw	a4,236(sp)
    2bb0:	0e812b03          	lw	s6,232(sp)
    2bb4:	10c10c13          	addi	s8,sp,268
    2bb8:	fadff06f          	j	2b64 <_vfprintf_r+0x1660>
    2bbc:	03000793          	li	a5,48
    2bc0:	1af107a3          	sb	a5,431(sp)
    2bc4:	1af10c93          	addi	s9,sp,431
    2bc8:	ce9fe06f          	j	18b0 <_vfprintf_r+0x3ac>
    2bcc:	20097793          	andi	a5,s2,512
    2bd0:	0a079ce3          	bnez	a5,3488 <_vfprintf_r+0x1f84>
    2bd4:	00000d93          	li	s11,0
    2bd8:	c89fe06f          	j	1860 <_vfprintf_r+0x35c>
    2bdc:	00c12783          	lw	a5,12(sp)
    2be0:	0007a703          	lw	a4,0(a5)
    2be4:	00478793          	addi	a5,a5,4
    2be8:	00f12623          	sw	a5,12(sp)
    2bec:	00072583          	lw	a1,0(a4)
    2bf0:	00472603          	lw	a2,4(a4)
    2bf4:	00872683          	lw	a3,8(a4)
    2bf8:	00c72703          	lw	a4,12(a4)
    2bfc:	0eb12823          	sw	a1,240(sp)
    2c00:	0ec12a23          	sw	a2,244(sp)
    2c04:	0ed12c23          	sw	a3,248(sp)
    2c08:	0ee12e23          	sw	a4,252(sp)
    2c0c:	a4cff06f          	j	1e58 <_vfprintf_r+0x954>
    2c10:	03000793          	li	a5,48
    2c14:	00296913          	ori	s2,s2,2
    2c18:	0cf10423          	sb	a5,200(sp)
    2c1c:	0d5104a3          	sb	s5,201(sp)
    2c20:	bff97993          	andi	s3,s2,-1025
    2c24:	00200793          	li	a5,2
    2c28:	c55fe06f          	j	187c <_vfprintf_r+0x378>
    2c2c:	00812603          	lw	a2,8(sp)
    2c30:	0006a783          	lw	a5,0(a3)
    2c34:	00e12623          	sw	a4,12(sp)
    2c38:	41f65693          	srai	a3,a2,0x1f
    2c3c:	00c7a023          	sw	a2,0(a5)
    2c40:	00d7a223          	sw	a3,4(a5)
    2c44:	00048c93          	mv	s9,s1
    2c48:	dd1fe06f          	j	1a18 <_vfprintf_r+0x514>
    2c4c:	03c12783          	lw	a5,60(sp)
    2c50:	0004ce03          	lbu	t3,0(s1)
    2c54:	00079463          	bnez	a5,2c5c <_vfprintf_r+0x1758>
    2c58:	a65fe06f          	j	16bc <_vfprintf_r+0x1b8>
    2c5c:	0007c783          	lbu	a5,0(a5)
    2c60:	00079463          	bnez	a5,2c68 <_vfprintf_r+0x1764>
    2c64:	a59fe06f          	j	16bc <_vfprintf_r+0x1b8>
    2c68:	40096913          	ori	s2,s2,1024
    2c6c:	a51fe06f          	j	16bc <_vfprintf_r+0x1b8>
    2c70:	00068b13          	mv	s6,a3
    2c74:	d76046e3          	bgtz	s6,29e0 <_vfprintf_r+0x14dc>
    2c78:	d91ff06f          	j	2a08 <_vfprintf_r+0x1504>
    2c7c:	000d0693          	mv	a3,s10
    2c80:	001b0a93          	addi	s5,s6,1
    2c84:	008c0793          	addi	a5,s8,8
    2c88:	00d70733          	add	a4,a4,a3
    2c8c:	00013617          	auipc	a2,0x13
    2c90:	b5060613          	addi	a2,a2,-1200 # 157dc <zeroes.4505>
    2c94:	00dc2223          	sw	a3,4(s8)
    2c98:	00cc2023          	sw	a2,0(s8)
    2c9c:	0ee12623          	sw	a4,236(sp)
    2ca0:	0f512423          	sw	s5,232(sp)
    2ca4:	00700693          	li	a3,7
    2ca8:	6f56de63          	bge	a3,s5,33a4 <_vfprintf_r+0x1ea0>
    2cac:	00412583          	lw	a1,4(sp)
    2cb0:	0e410613          	addi	a2,sp,228
    2cb4:	000a0513          	mv	a0,s4
    2cb8:	1850a0ef          	jal	ra,d63c <__sprint_r>
    2cbc:	00050463          	beqz	a0,2cc4 <_vfprintf_r+0x17c0>
    2cc0:	b05fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2cc4:	0e812603          	lw	a2,232(sp)
    2cc8:	0ec12703          	lw	a4,236(sp)
    2ccc:	11410d13          	addi	s10,sp,276
    2cd0:	00160a93          	addi	s5,a2,1
    2cd4:	10c10c13          	addi	s8,sp,268
    2cd8:	a4dff06f          	j	2724 <_vfprintf_r+0x1220>
    2cdc:	00412583          	lw	a1,4(sp)
    2ce0:	0e410613          	addi	a2,sp,228
    2ce4:	000a0513          	mv	a0,s4
    2ce8:	1550a0ef          	jal	ra,d63c <__sprint_r>
    2cec:	00050463          	beqz	a0,2cf4 <_vfprintf_r+0x17f0>
    2cf0:	ad5fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2cf4:	0ec12703          	lw	a4,236(sp)
    2cf8:	10c10d13          	addi	s10,sp,268
    2cfc:	fa8ff06f          	j	24a4 <_vfprintf_r+0xfa0>
    2d00:	0014ce03          	lbu	t3,1(s1)
    2d04:	20096913          	ori	s2,s2,512
    2d08:	00148493          	addi	s1,s1,1
    2d0c:	9b1fe06f          	j	16bc <_vfprintf_r+0x1b8>
    2d10:	0014ce03          	lbu	t3,1(s1)
    2d14:	02096913          	ori	s2,s2,32
    2d18:	00148493          	addi	s1,s1,1
    2d1c:	9a1fe06f          	j	16bc <_vfprintf_r+0x1b8>
    2d20:	00600793          	li	a5,6
    2d24:	00030b13          	mv	s6,t1
    2d28:	6e67e263          	bltu	a5,t1,340c <_vfprintf_r+0x1f08>
    2d2c:	000b0993          	mv	s3,s6
    2d30:	01812623          	sw	s8,12(sp)
    2d34:	00013c97          	auipc	s9,0x13
    2d38:	a8cc8c93          	addi	s9,s9,-1396 # 157c0 <_data+0x4a8>
    2d3c:	ec1fe06f          	j	1bfc <_vfprintf_r+0x6f8>
    2d40:	0e812683          	lw	a3,232(sp)
    2d44:	456bd863          	bge	s7,s6,3194 <_vfprintf_r+0x1c90>
    2d48:	00700a93          	li	s5,7
    2d4c:	00412c03          	lw	s8,4(sp)
    2d50:	00c0006f          	j	2d5c <_vfprintf_r+0x1858>
    2d54:	ff0b0b13          	addi	s6,s6,-16
    2d58:	436bde63          	bge	s7,s6,3194 <_vfprintf_r+0x1c90>
    2d5c:	01070713          	addi	a4,a4,16
    2d60:	00168693          	addi	a3,a3,1
    2d64:	00013797          	auipc	a5,0x13
    2d68:	a7878793          	addi	a5,a5,-1416 # 157dc <zeroes.4505>
    2d6c:	00fd2023          	sw	a5,0(s10)
    2d70:	017d2223          	sw	s7,4(s10)
    2d74:	0ee12623          	sw	a4,236(sp)
    2d78:	0ed12423          	sw	a3,232(sp)
    2d7c:	008d0d13          	addi	s10,s10,8
    2d80:	fcdadae3          	bge	s5,a3,2d54 <_vfprintf_r+0x1850>
    2d84:	0e410613          	addi	a2,sp,228
    2d88:	000c0593          	mv	a1,s8
    2d8c:	000a0513          	mv	a0,s4
    2d90:	0ad0a0ef          	jal	ra,d63c <__sprint_r>
    2d94:	00050463          	beqz	a0,2d9c <_vfprintf_r+0x1898>
    2d98:	a2dfe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2d9c:	0ec12703          	lw	a4,236(sp)
    2da0:	0e812683          	lw	a3,232(sp)
    2da4:	10c10d13          	addi	s10,sp,268
    2da8:	fadff06f          	j	2d54 <_vfprintf_r+0x1850>
    2dac:	000c8913          	mv	s2,s9
    2db0:	8e9fe06f          	j	1698 <_vfprintf_r+0x194>
    2db4:	00412583          	lw	a1,4(sp)
    2db8:	0e410613          	addi	a2,sp,228
    2dbc:	000a0513          	mv	a0,s4
    2dc0:	07d0a0ef          	jal	ra,d63c <__sprint_r>
    2dc4:	00050463          	beqz	a0,2dcc <_vfprintf_r+0x18c8>
    2dc8:	9fdfe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2dcc:	0ec12703          	lw	a4,236(sp)
    2dd0:	0e812b03          	lw	s6,232(sp)
    2dd4:	10c10c13          	addi	s8,sp,268
    2dd8:	9c9ff06f          	j	27a0 <_vfprintf_r+0x129c>
    2ddc:	00412583          	lw	a1,4(sp)
    2de0:	0e410613          	addi	a2,sp,228
    2de4:	000a0513          	mv	a0,s4
    2de8:	0550a0ef          	jal	ra,d63c <__sprint_r>
    2dec:	00050463          	beqz	a0,2df4 <_vfprintf_r+0x18f0>
    2df0:	9d5fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2df4:	0ec12703          	lw	a4,236(sp)
    2df8:	0e812b03          	lw	s6,232(sp)
    2dfc:	10c10c13          	addi	s8,sp,268
    2e00:	9cdff06f          	j	27cc <_vfprintf_r+0x12c8>
    2e04:	0e812683          	lw	a3,232(sp)
    2e08:	00013597          	auipc	a1,0x13
    2e0c:	9c058593          	addi	a1,a1,-1600 # 157c8 <_data+0x4b0>
    2e10:	00bd2023          	sw	a1,0(s10)
    2e14:	00170713          	addi	a4,a4,1
    2e18:	00100593          	li	a1,1
    2e1c:	00168693          	addi	a3,a3,1
    2e20:	00bd2223          	sw	a1,4(s10)
    2e24:	0ee12623          	sw	a4,236(sp)
    2e28:	0ed12423          	sw	a3,232(sp)
    2e2c:	00700593          	li	a1,7
    2e30:	008d0d13          	addi	s10,s10,8
    2e34:	58d5c063          	blt	a1,a3,33b4 <_vfprintf_r+0x1eb0>
    2e38:	20061e63          	bnez	a2,3054 <_vfprintf_r+0x1b50>
    2e3c:	01812783          	lw	a5,24(sp)
    2e40:	00197693          	andi	a3,s2,1
    2e44:	00f6e6b3          	or	a3,a3,a5
    2e48:	00069463          	bnez	a3,2e50 <_vfprintf_r+0x194c>
    2e4c:	e91fe06f          	j	1cdc <_vfprintf_r+0x7d8>
    2e50:	03012683          	lw	a3,48(sp)
    2e54:	02812783          	lw	a5,40(sp)
    2e58:	00700613          	li	a2,7
    2e5c:	00dd2023          	sw	a3,0(s10)
    2e60:	0e812683          	lw	a3,232(sp)
    2e64:	00e78733          	add	a4,a5,a4
    2e68:	00fd2223          	sw	a5,4(s10)
    2e6c:	00168693          	addi	a3,a3,1
    2e70:	0ee12623          	sw	a4,236(sp)
    2e74:	0ed12423          	sw	a3,232(sp)
    2e78:	008d0893          	addi	a7,s10,8
    2e7c:	62d64063          	blt	a2,a3,349c <_vfprintf_r+0x1f98>
    2e80:	01812783          	lw	a5,24(sp)
    2e84:	00168693          	addi	a3,a3,1
    2e88:	0198a023          	sw	s9,0(a7)
    2e8c:	00e78733          	add	a4,a5,a4
    2e90:	00f8a223          	sw	a5,4(a7)
    2e94:	0ee12623          	sw	a4,236(sp)
    2e98:	0ed12423          	sw	a3,232(sp)
    2e9c:	00700793          	li	a5,7
    2ea0:	00888d13          	addi	s10,a7,8
    2ea4:	00d7c463          	blt	a5,a3,2eac <_vfprintf_r+0x19a8>
    2ea8:	e35fe06f          	j	1cdc <_vfprintf_r+0x7d8>
    2eac:	89dff06f          	j	2748 <_vfprintf_r+0x1244>
    2eb0:	1b010c93          	addi	s9,sp,432
    2eb4:	00000793          	li	a5,0
    2eb8:	4009f913          	andi	s2,s3,1024
    2ebc:	00912823          	sw	s1,16(sp)
    2ec0:	01312a23          	sw	s3,20(sp)
    2ec4:	0ff00b13          	li	s6,255
    2ec8:	000c8993          	mv	s3,s9
    2ecc:	02612023          	sw	t1,32(sp)
    2ed0:	000a0c93          	mv	s9,s4
    2ed4:	03c12483          	lw	s1,60(sp)
    2ed8:	000d8a13          	mv	s4,s11
    2edc:	000d0d93          	mv	s11,s10
    2ee0:	00040d13          	mv	s10,s0
    2ee4:	00078413          	mv	s0,a5
    2ee8:	0240006f          	j	2f0c <_vfprintf_r+0x1a08>
    2eec:	00a00613          	li	a2,10
    2ef0:	00000693          	li	a3,0
    2ef4:	000c0513          	mv	a0,s8
    2ef8:	000a0593          	mv	a1,s4
    2efc:	1110d0ef          	jal	ra,1080c <__udivdi3>
    2f00:	2c0a0ee3          	beqz	s4,39dc <_vfprintf_r+0x24d8>
    2f04:	00050c13          	mv	s8,a0
    2f08:	00058a13          	mv	s4,a1
    2f0c:	00a00613          	li	a2,10
    2f10:	00000693          	li	a3,0
    2f14:	000c0513          	mv	a0,s8
    2f18:	000a0593          	mv	a1,s4
    2f1c:	5910d0ef          	jal	ra,10cac <__umoddi3>
    2f20:	03050513          	addi	a0,a0,48
    2f24:	fea98fa3          	sb	a0,-1(s3)
    2f28:	00140413          	addi	s0,s0,1
    2f2c:	fff98993          	addi	s3,s3,-1
    2f30:	fa090ee3          	beqz	s2,2eec <_vfprintf_r+0x19e8>
    2f34:	0004c683          	lbu	a3,0(s1)
    2f38:	fad41ae3          	bne	s0,a3,2eec <_vfprintf_r+0x19e8>
    2f3c:	fb6408e3          	beq	s0,s6,2eec <_vfprintf_r+0x19e8>
    2f40:	240a1ee3          	bnez	s4,399c <_vfprintf_r+0x2498>
    2f44:	00900793          	li	a5,9
    2f48:	2587eae3          	bltu	a5,s8,399c <_vfprintf_r+0x2498>
    2f4c:	000c8a13          	mv	s4,s9
    2f50:	00098c93          	mv	s9,s3
    2f54:	01412983          	lw	s3,20(sp)
    2f58:	1b010793          	addi	a5,sp,432
    2f5c:	00812c23          	sw	s0,24(sp)
    2f60:	02912e23          	sw	s1,60(sp)
    2f64:	000d0413          	mv	s0,s10
    2f68:	02012303          	lw	t1,32(sp)
    2f6c:	01012483          	lw	s1,16(sp)
    2f70:	000d8d13          	mv	s10,s11
    2f74:	41978b33          	sub	s6,a5,s9
    2f78:	00098913          	mv	s2,s3
    2f7c:	935fe06f          	j	18b0 <_vfprintf_r+0x3ac>
    2f80:	00412583          	lw	a1,4(sp)
    2f84:	0e410613          	addi	a2,sp,228
    2f88:	000a0513          	mv	a0,s4
    2f8c:	6b00a0ef          	jal	ra,d63c <__sprint_r>
    2f90:	00050463          	beqz	a0,2f98 <_vfprintf_r+0x1a94>
    2f94:	831fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    2f98:	10c10d13          	addi	s10,sp,268
    2f9c:	cb8ff06f          	j	2454 <_vfprintf_r+0xf50>
    2fa0:	00013697          	auipc	a3,0x13
    2fa4:	83c68693          	addi	a3,a3,-1988 # 157dc <zeroes.4505>
    2fa8:	01670733          	add	a4,a4,s6
    2fac:	00178793          	addi	a5,a5,1
    2fb0:	00dd2023          	sw	a3,0(s10)
    2fb4:	d11fe06f          	j	1cc4 <_vfprintf_r+0x7c0>
    2fb8:	0f012783          	lw	a5,240(sp)
    2fbc:	0a010593          	addi	a1,sp,160
    2fc0:	0b010513          	addi	a0,sp,176
    2fc4:	0af12823          	sw	a5,176(sp)
    2fc8:	0f412783          	lw	a5,244(sp)
    2fcc:	0a012023          	sw	zero,160(sp)
    2fd0:	0a012223          	sw	zero,164(sp)
    2fd4:	0af12a23          	sw	a5,180(sp)
    2fd8:	0f812783          	lw	a5,248(sp)
    2fdc:	0a012423          	sw	zero,168(sp)
    2fe0:	0a012623          	sw	zero,172(sp)
    2fe4:	0af12c23          	sw	a5,184(sp)
    2fe8:	0fc12783          	lw	a5,252(sp)
    2fec:	0af12e23          	sw	a5,188(sp)
    2ff0:	12c0f0ef          	jal	ra,1211c <__letf2>
    2ff4:	2c0546e3          	bltz	a0,3ac0 <_vfprintf_r+0x25bc>
    2ff8:	0c714703          	lbu	a4,199(sp)
    2ffc:	04700693          	li	a3,71
    3000:	00012c97          	auipc	s9,0x12
    3004:	788c8c93          	addi	s9,s9,1928 # 15788 <_data+0x470>
    3008:	3d56ca63          	blt	a3,s5,33dc <_vfprintf_r+0x1ed8>
    300c:	00012823          	sw	zero,16(sp)
    3010:	02012223          	sw	zero,36(sp)
    3014:	02012023          	sw	zero,32(sp)
    3018:	00012a23          	sw	zero,20(sp)
    301c:	f7f97913          	andi	s2,s2,-129
    3020:	00300993          	li	s3,3
    3024:	00300b13          	li	s6,3
    3028:	00000313          	li	t1,0
    302c:	00070463          	beqz	a4,3034 <_vfprintf_r+0x1b30>
    3030:	8a5fe06f          	j	18d4 <_vfprintf_r+0x3d0>
    3034:	bddfe06f          	j	1c10 <_vfprintf_r+0x70c>
    3038:	00c12783          	lw	a5,12(sp)
    303c:	00048c93          	mv	s9,s1
    3040:	0007a783          	lw	a5,0(a5)
    3044:	00e12623          	sw	a4,12(sp)
    3048:	00812703          	lw	a4,8(sp)
    304c:	00e7a023          	sw	a4,0(a5)
    3050:	9c9fe06f          	j	1a18 <_vfprintf_r+0x514>
    3054:	03012683          	lw	a3,48(sp)
    3058:	02812783          	lw	a5,40(sp)
    305c:	00700593          	li	a1,7
    3060:	00dd2023          	sw	a3,0(s10)
    3064:	0e812683          	lw	a3,232(sp)
    3068:	00e78733          	add	a4,a5,a4
    306c:	00fd2223          	sw	a5,4(s10)
    3070:	00168693          	addi	a3,a3,1
    3074:	0ee12623          	sw	a4,236(sp)
    3078:	0ed12423          	sw	a3,232(sp)
    307c:	008d0893          	addi	a7,s10,8
    3080:	40d5ce63          	blt	a1,a3,349c <_vfprintf_r+0x1f98>
    3084:	de065ee3          	bgez	a2,2e80 <_vfprintf_r+0x197c>
    3088:	ff000593          	li	a1,-16
    308c:	40c00b33          	neg	s6,a2
    3090:	32b654e3          	bge	a2,a1,3bb8 <_vfprintf_r+0x26b4>
    3094:	00700c13          	li	s8,7
    3098:	00412a83          	lw	s5,4(sp)
    309c:	00c0006f          	j	30a8 <_vfprintf_r+0x1ba4>
    30a0:	ff0b0b13          	addi	s6,s6,-16
    30a4:	316bdae3          	bge	s7,s6,3bb8 <_vfprintf_r+0x26b4>
    30a8:	01070713          	addi	a4,a4,16
    30ac:	00168693          	addi	a3,a3,1
    30b0:	00012797          	auipc	a5,0x12
    30b4:	72c78793          	addi	a5,a5,1836 # 157dc <zeroes.4505>
    30b8:	00f8a023          	sw	a5,0(a7)
    30bc:	0178a223          	sw	s7,4(a7)
    30c0:	0ee12623          	sw	a4,236(sp)
    30c4:	0ed12423          	sw	a3,232(sp)
    30c8:	00888893          	addi	a7,a7,8
    30cc:	fcdc5ae3          	bge	s8,a3,30a0 <_vfprintf_r+0x1b9c>
    30d0:	0e410613          	addi	a2,sp,228
    30d4:	000a8593          	mv	a1,s5
    30d8:	000a0513          	mv	a0,s4
    30dc:	5600a0ef          	jal	ra,d63c <__sprint_r>
    30e0:	00050463          	beqz	a0,30e8 <_vfprintf_r+0x1be4>
    30e4:	ee0fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    30e8:	0ec12703          	lw	a4,236(sp)
    30ec:	0e812683          	lw	a3,232(sp)
    30f0:	10c10893          	addi	a7,sp,268
    30f4:	fadff06f          	j	30a0 <_vfprintf_r+0x1b9c>
    30f8:	000c8513          	mv	a0,s9
    30fc:	b7cfe0ef          	jal	ra,1478 <strlen>
    3100:	00050b13          	mv	s6,a0
    3104:	a6dfe06f          	j	1b70 <_vfprintf_r+0x66c>
    3108:	20097713          	andi	a4,s2,512
    310c:	36070063          	beqz	a4,346c <_vfprintf_r+0x1f68>
    3110:	00c12703          	lw	a4,12(sp)
    3114:	00090993          	mv	s3,s2
    3118:	00f12623          	sw	a5,12(sp)
    311c:	00070c03          	lb	s8,0(a4)
    3120:	41fc5d93          	srai	s11,s8,0x1f
    3124:	000d8713          	mv	a4,s11
    3128:	989fe06f          	j	1ab0 <_vfprintf_r+0x5ac>
    312c:	20097713          	andi	a4,s2,512
    3130:	32070863          	beqz	a4,3460 <_vfprintf_r+0x1f5c>
    3134:	0ffc7c13          	andi	s8,s8,255
    3138:	00000d93          	li	s11,0
    313c:	00f12623          	sw	a5,12(sp)
    3140:	a00ff06f          	j	2340 <_vfprintf_r+0xe3c>
    3144:	20097713          	andi	a4,s2,512
    3148:	30070263          	beqz	a4,344c <_vfprintf_r+0x1f48>
    314c:	00f12623          	sw	a5,12(sp)
    3150:	0ffc7c13          	andi	s8,s8,255
    3154:	00000d93          	li	s11,0
    3158:	00090993          	mv	s3,s2
    315c:	00100793          	li	a5,1
    3160:	f1cfe06f          	j	187c <_vfprintf_r+0x378>
    3164:	0fc12783          	lw	a5,252(sp)
    3168:	3207d663          	bgez	a5,3494 <_vfprintf_r+0x1f90>
    316c:	02d00793          	li	a5,45
    3170:	0cf103a3          	sb	a5,199(sp)
    3174:	02d00713          	li	a4,45
    3178:	04700693          	li	a3,71
    317c:	00012c97          	auipc	s9,0x12
    3180:	614c8c93          	addi	s9,s9,1556 # 15790 <_data+0x478>
    3184:	e956d4e3          	bge	a3,s5,300c <_vfprintf_r+0x1b08>
    3188:	00012c97          	auipc	s9,0x12
    318c:	60cc8c93          	addi	s9,s9,1548 # 15794 <_data+0x47c>
    3190:	e7dff06f          	j	300c <_vfprintf_r+0x1b08>
    3194:	01670733          	add	a4,a4,s6
    3198:	00168693          	addi	a3,a3,1
    319c:	00012797          	auipc	a5,0x12
    31a0:	64078793          	addi	a5,a5,1600 # 157dc <zeroes.4505>
    31a4:	00fd2023          	sw	a5,0(s10)
    31a8:	016d2223          	sw	s6,4(s10)
    31ac:	0ee12623          	sw	a4,236(sp)
    31b0:	0ed12423          	sw	a3,232(sp)
    31b4:	00700613          	li	a2,7
    31b8:	008d0d13          	addi	s10,s10,8
    31bc:	86d652e3          	bge	a2,a3,2a20 <_vfprintf_r+0x151c>
    31c0:	00412583          	lw	a1,4(sp)
    31c4:	0e410613          	addi	a2,sp,228
    31c8:	000a0513          	mv	a0,s4
    31cc:	4700a0ef          	jal	ra,d63c <__sprint_r>
    31d0:	00050463          	beqz	a0,31d8 <_vfprintf_r+0x1cd4>
    31d4:	df0fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    31d8:	0ec12703          	lw	a4,236(sp)
    31dc:	10c10d13          	addi	s10,sp,268
    31e0:	841ff06f          	j	2a20 <_vfprintf_r+0x151c>
    31e4:	01812783          	lw	a5,24(sp)
    31e8:	02012c03          	lw	s8,32(sp)
    31ec:	00912a23          	sw	s1,20(sp)
    31f0:	03212a23          	sw	s2,52(sp)
    31f4:	04812423          	sw	s0,72(sp)
    31f8:	02412483          	lw	s1,36(sp)
    31fc:	03312023          	sw	s3,32(sp)
    3200:	03912223          	sw	s9,36(sp)
    3204:	00fc8db3          	add	s11,s9,a5
    3208:	00700b13          	li	s6,7
    320c:	04012903          	lw	s2,64(sp)
    3210:	03c12403          	lw	s0,60(sp)
    3214:	000d0693          	mv	a3,s10
    3218:	00412983          	lw	s3,4(sp)
    321c:	04412c83          	lw	s9,68(sp)
    3220:	080c0863          	beqz	s8,32b0 <_vfprintf_r+0x1dac>
    3224:	08049863          	bnez	s1,32b4 <_vfprintf_r+0x1db0>
    3228:	fff40413          	addi	s0,s0,-1
    322c:	fffc0c13          	addi	s8,s8,-1
    3230:	0e812783          	lw	a5,232(sp)
    3234:	01270733          	add	a4,a4,s2
    3238:	0196a023          	sw	s9,0(a3)
    323c:	00178793          	addi	a5,a5,1
    3240:	0126a223          	sw	s2,4(a3)
    3244:	0ee12623          	sw	a4,236(sp)
    3248:	0ef12423          	sw	a5,232(sp)
    324c:	00868693          	addi	a3,a3,8
    3250:	10fb4463          	blt	s6,a5,3358 <_vfprintf_r+0x1e54>
    3254:	00044603          	lbu	a2,0(s0)
    3258:	415d85b3          	sub	a1,s11,s5
    325c:	00060d13          	mv	s10,a2
    3260:	00c5d463          	bge	a1,a2,3268 <_vfprintf_r+0x1d64>
    3264:	00058d13          	mv	s10,a1
    3268:	03a05663          	blez	s10,3294 <_vfprintf_r+0x1d90>
    326c:	0e812603          	lw	a2,232(sp)
    3270:	01a70733          	add	a4,a4,s10
    3274:	0156a023          	sw	s5,0(a3)
    3278:	00160613          	addi	a2,a2,1
    327c:	01a6a223          	sw	s10,4(a3)
    3280:	0ee12623          	sw	a4,236(sp)
    3284:	0ec12423          	sw	a2,232(sp)
    3288:	0ecb4a63          	blt	s6,a2,337c <_vfprintf_r+0x1e78>
    328c:	00044603          	lbu	a2,0(s0)
    3290:	00868693          	addi	a3,a3,8
    3294:	fffd4593          	not	a1,s10
    3298:	41f5d593          	srai	a1,a1,0x1f
    329c:	00bd77b3          	and	a5,s10,a1
    32a0:	40f60d33          	sub	s10,a2,a5
    32a4:	01a04c63          	bgtz	s10,32bc <_vfprintf_r+0x1db8>
    32a8:	00ca8ab3          	add	s5,s5,a2
    32ac:	f60c1ce3          	bnez	s8,3224 <_vfprintf_r+0x1d20>
    32b0:	5e048663          	beqz	s1,389c <_vfprintf_r+0x2398>
    32b4:	fff48493          	addi	s1,s1,-1
    32b8:	f79ff06f          	j	3230 <_vfprintf_r+0x1d2c>
    32bc:	0e812603          	lw	a2,232(sp)
    32c0:	01abc863          	blt	s7,s10,32d0 <_vfprintf_r+0x1dcc>
    32c4:	0600006f          	j	3324 <_vfprintf_r+0x1e20>
    32c8:	ff0d0d13          	addi	s10,s10,-16
    32cc:	05abdc63          	bge	s7,s10,3324 <_vfprintf_r+0x1e20>
    32d0:	01070713          	addi	a4,a4,16
    32d4:	00160613          	addi	a2,a2,1
    32d8:	00012797          	auipc	a5,0x12
    32dc:	50478793          	addi	a5,a5,1284 # 157dc <zeroes.4505>
    32e0:	00f6a023          	sw	a5,0(a3)
    32e4:	0176a223          	sw	s7,4(a3)
    32e8:	0ee12623          	sw	a4,236(sp)
    32ec:	0ec12423          	sw	a2,232(sp)
    32f0:	00868693          	addi	a3,a3,8
    32f4:	fccb5ae3          	bge	s6,a2,32c8 <_vfprintf_r+0x1dc4>
    32f8:	0e410613          	addi	a2,sp,228
    32fc:	00098593          	mv	a1,s3
    3300:	000a0513          	mv	a0,s4
    3304:	3380a0ef          	jal	ra,d63c <__sprint_r>
    3308:	00050463          	beqz	a0,3310 <_vfprintf_r+0x1e0c>
    330c:	cb8fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    3310:	ff0d0d13          	addi	s10,s10,-16
    3314:	0ec12703          	lw	a4,236(sp)
    3318:	0e812603          	lw	a2,232(sp)
    331c:	10c10693          	addi	a3,sp,268
    3320:	fbabc8e3          	blt	s7,s10,32d0 <_vfprintf_r+0x1dcc>
    3324:	01a70733          	add	a4,a4,s10
    3328:	00160613          	addi	a2,a2,1
    332c:	00012797          	auipc	a5,0x12
    3330:	4b078793          	addi	a5,a5,1200 # 157dc <zeroes.4505>
    3334:	00f6a023          	sw	a5,0(a3)
    3338:	01a6a223          	sw	s10,4(a3)
    333c:	0ee12623          	sw	a4,236(sp)
    3340:	0ec12423          	sw	a2,232(sp)
    3344:	62cb4663          	blt	s6,a2,3970 <_vfprintf_r+0x246c>
    3348:	00044603          	lbu	a2,0(s0)
    334c:	00868693          	addi	a3,a3,8
    3350:	00ca8ab3          	add	s5,s5,a2
    3354:	f59ff06f          	j	32ac <_vfprintf_r+0x1da8>
    3358:	0e410613          	addi	a2,sp,228
    335c:	00098593          	mv	a1,s3
    3360:	000a0513          	mv	a0,s4
    3364:	2d80a0ef          	jal	ra,d63c <__sprint_r>
    3368:	00050463          	beqz	a0,3370 <_vfprintf_r+0x1e6c>
    336c:	c58fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    3370:	0ec12703          	lw	a4,236(sp)
    3374:	10c10693          	addi	a3,sp,268
    3378:	eddff06f          	j	3254 <_vfprintf_r+0x1d50>
    337c:	0e410613          	addi	a2,sp,228
    3380:	00098593          	mv	a1,s3
    3384:	000a0513          	mv	a0,s4
    3388:	2b40a0ef          	jal	ra,d63c <__sprint_r>
    338c:	00050463          	beqz	a0,3394 <_vfprintf_r+0x1e90>
    3390:	c34fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    3394:	00044603          	lbu	a2,0(s0)
    3398:	0ec12703          	lw	a4,236(sp)
    339c:	10c10693          	addi	a3,sp,268
    33a0:	ef5ff06f          	j	3294 <_vfprintf_r+0x1d90>
    33a4:	001a8a93          	addi	s5,s5,1
    33a8:	00878d13          	addi	s10,a5,8
    33ac:	00078c13          	mv	s8,a5
    33b0:	b74ff06f          	j	2724 <_vfprintf_r+0x1220>
    33b4:	00412583          	lw	a1,4(sp)
    33b8:	0e410613          	addi	a2,sp,228
    33bc:	000a0513          	mv	a0,s4
    33c0:	27c0a0ef          	jal	ra,d63c <__sprint_r>
    33c4:	00050463          	beqz	a0,33cc <_vfprintf_r+0x1ec8>
    33c8:	bfcfe06f          	j	17c4 <_vfprintf_r+0x2c0>
    33cc:	0cc12603          	lw	a2,204(sp)
    33d0:	0ec12703          	lw	a4,236(sp)
    33d4:	10c10d13          	addi	s10,sp,268
    33d8:	a61ff06f          	j	2e38 <_vfprintf_r+0x1934>
    33dc:	00012c97          	auipc	s9,0x12
    33e0:	3b0c8c93          	addi	s9,s9,944 # 1578c <_data+0x474>
    33e4:	c29ff06f          	j	300c <_vfprintf_r+0x1b08>
    33e8:	00412583          	lw	a1,4(sp)
    33ec:	0e410613          	addi	a2,sp,228
    33f0:	000a0513          	mv	a0,s4
    33f4:	2480a0ef          	jal	ra,d63c <__sprint_r>
    33f8:	00050463          	beqz	a0,3400 <_vfprintf_r+0x1efc>
    33fc:	bc8fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    3400:	0ec12703          	lw	a4,236(sp)
    3404:	10c10d13          	addi	s10,sp,268
    3408:	e00ff06f          	j	2a08 <_vfprintf_r+0x1504>
    340c:	00600b13          	li	s6,6
    3410:	91dff06f          	j	2d2c <_vfprintf_r+0x1828>
    3414:	01812683          	lw	a3,24(sp)
    3418:	00dc87b3          	add	a5,s9,a3
    341c:	41668b33          	sub	s6,a3,s6
    3420:	41578c33          	sub	s8,a5,s5
    3424:	eb8b5063          	bge	s6,s8,2ac4 <_vfprintf_r+0x15c0>
    3428:	000b0c13          	mv	s8,s6
    342c:	e98ff06f          	j	2ac4 <_vfprintf_r+0x15c0>
    3430:	00c12783          	lw	a5,12(sp)
    3434:	00e12623          	sw	a4,12(sp)
    3438:	00812703          	lw	a4,8(sp)
    343c:	0007a783          	lw	a5,0(a5)
    3440:	00048c93          	mv	s9,s1
    3444:	00e79023          	sh	a4,0(a5)
    3448:	dd0fe06f          	j	1a18 <_vfprintf_r+0x514>
    344c:	00f12623          	sw	a5,12(sp)
    3450:	00000d93          	li	s11,0
    3454:	00090993          	mv	s3,s2
    3458:	00100793          	li	a5,1
    345c:	c20fe06f          	j	187c <_vfprintf_r+0x378>
    3460:	00000d93          	li	s11,0
    3464:	00f12623          	sw	a5,12(sp)
    3468:	ed9fe06f          	j	2340 <_vfprintf_r+0xe3c>
    346c:	00c12703          	lw	a4,12(sp)
    3470:	00090993          	mv	s3,s2
    3474:	00f12623          	sw	a5,12(sp)
    3478:	00072c03          	lw	s8,0(a4)
    347c:	41fc5d93          	srai	s11,s8,0x1f
    3480:	000d8713          	mv	a4,s11
    3484:	e2cfe06f          	j	1ab0 <_vfprintf_r+0x5ac>
    3488:	0ffc7c13          	andi	s8,s8,255
    348c:	00000d93          	li	s11,0
    3490:	bd0fe06f          	j	1860 <_vfprintf_r+0x35c>
    3494:	0c714703          	lbu	a4,199(sp)
    3498:	ce1ff06f          	j	3178 <_vfprintf_r+0x1c74>
    349c:	00412583          	lw	a1,4(sp)
    34a0:	0e410613          	addi	a2,sp,228
    34a4:	000a0513          	mv	a0,s4
    34a8:	1940a0ef          	jal	ra,d63c <__sprint_r>
    34ac:	00050463          	beqz	a0,34b4 <_vfprintf_r+0x1fb0>
    34b0:	b14fe06f          	j	17c4 <_vfprintf_r+0x2c0>
    34b4:	0cc12603          	lw	a2,204(sp)
    34b8:	0ec12703          	lw	a4,236(sp)
    34bc:	0e812683          	lw	a3,232(sp)
    34c0:	10c10893          	addi	a7,sp,268
    34c4:	9a065ee3          	bgez	a2,2e80 <_vfprintf_r+0x197c>
    34c8:	bc1ff06f          	j	3088 <_vfprintf_r+0x1b84>
    34cc:	03000793          	li	a5,48
    34d0:	0cf10423          	sb	a5,200(sp)
    34d4:	05800793          	li	a5,88
    34d8:	0cf104a3          	sb	a5,201(sp)
    34dc:	00296793          	ori	a5,s2,2
    34e0:	06300713          	li	a4,99
    34e4:	04f12a23          	sw	a5,84(sp)
    34e8:	00012823          	sw	zero,16(sp)
    34ec:	14c10c93          	addi	s9,sp,332
    34f0:	7a674063          	blt	a4,t1,3c90 <_vfprintf_r+0x278c>
    34f4:	0fc12b03          	lw	s6,252(sp)
    34f8:	fdfaf793          	andi	a5,s5,-33
    34fc:	04f12423          	sw	a5,72(sp)
    3500:	04012e23          	sw	zero,92(sp)
    3504:	10296913          	ori	s2,s2,258
    3508:	0f012f03          	lw	t5,240(sp)
    350c:	0f412d83          	lw	s11,244(sp)
    3510:	0f812e83          	lw	t4,248(sp)
    3514:	440b4463          	bltz	s6,395c <_vfprintf_r+0x2458>
    3518:	06100713          	li	a4,97
    351c:	0cea8ee3          	beq	s5,a4,3df8 <_vfprintf_r+0x28f4>
    3520:	04100713          	li	a4,65
    3524:	00ea8463          	beq	s5,a4,352c <_vfprintf_r+0x2028>
    3528:	9c1fe06f          	j	1ee8 <_vfprintf_r+0x9e4>
    352c:	0b010c13          	addi	s8,sp,176
    3530:	000c0513          	mv	a0,s8
    3534:	02612a23          	sw	t1,52(sp)
    3538:	0be12823          	sw	t5,176(sp)
    353c:	0bd12c23          	sw	t4,184(sp)
    3540:	0b612e23          	sw	s6,188(sp)
    3544:	0bb12a23          	sw	s11,180(sp)
    3548:	17d110ef          	jal	ra,14ec4 <__trunctfdf2>
    354c:	0cc10613          	addi	a2,sp,204
    3550:	7f5060ef          	jal	ra,a544 <frexp>
    3554:	00058613          	mv	a2,a1
    3558:	00050593          	mv	a1,a0
    355c:	000c0513          	mv	a0,s8
    3560:	6f8110ef          	jal	ra,14c58 <__extenddftf2>
    3564:	0b012703          	lw	a4,176(sp)
    3568:	09010793          	addi	a5,sp,144
    356c:	0a010993          	addi	s3,sp,160
    3570:	08e12823          	sw	a4,144(sp)
    3574:	0b412703          	lw	a4,180(sp)
    3578:	08010613          	addi	a2,sp,128
    357c:	00078593          	mv	a1,a5
    3580:	08e12a23          	sw	a4,148(sp)
    3584:	0b812703          	lw	a4,184(sp)
    3588:	00098513          	mv	a0,s3
    358c:	00078b13          	mv	s6,a5
    3590:	08e12c23          	sw	a4,152(sp)
    3594:	0bc12703          	lw	a4,188(sp)
    3598:	04c12623          	sw	a2,76(sp)
    359c:	05312c23          	sw	s3,88(sp)
    35a0:	08e12e23          	sw	a4,156(sp)
    35a4:	3ffc0737          	lui	a4,0x3ffc0
    35a8:	08e12623          	sw	a4,140(sp)
    35ac:	08012023          	sw	zero,128(sp)
    35b0:	08012223          	sw	zero,132(sp)
    35b4:	08012423          	sw	zero,136(sp)
    35b8:	4d90e0ef          	jal	ra,12290 <__multf3>
    35bc:	0a012703          	lw	a4,160(sp)
    35c0:	0a412683          	lw	a3,164(sp)
    35c4:	0a812803          	lw	a6,168(sp)
    35c8:	0ac12e83          	lw	t4,172(sp)
    35cc:	00098593          	mv	a1,s3
    35d0:	000c0513          	mv	a0,s8
    35d4:	0ae12823          	sw	a4,176(sp)
    35d8:	02e12223          	sw	a4,36(sp)
    35dc:	0ad12a23          	sw	a3,180(sp)
    35e0:	02d12023          	sw	a3,32(sp)
    35e4:	0b012c23          	sw	a6,184(sp)
    35e8:	01012c23          	sw	a6,24(sp)
    35ec:	0bd12e23          	sw	t4,188(sp)
    35f0:	01d12a23          	sw	t4,20(sp)
    35f4:	0a012023          	sw	zero,160(sp)
    35f8:	0a012223          	sw	zero,164(sp)
    35fc:	0a012423          	sw	zero,168(sp)
    3600:	0a012623          	sw	zero,172(sp)
    3604:	0d90e0ef          	jal	ra,11edc <__eqtf2>
    3608:	01412e83          	lw	t4,20(sp)
    360c:	01812803          	lw	a6,24(sp)
    3610:	02012683          	lw	a3,32(sp)
    3614:	02412703          	lw	a4,36(sp)
    3618:	03412303          	lw	t1,52(sp)
    361c:	00051663          	bnez	a0,3628 <_vfprintf_r+0x2124>
    3620:	00100613          	li	a2,1
    3624:	0cc12623          	sw	a2,204(sp)
    3628:	00012797          	auipc	a5,0x12
    362c:	18478793          	addi	a5,a5,388 # 157ac <_data+0x494>
    3630:	02f12a23          	sw	a5,52(sp)
    3634:	fff30d93          	addi	s11,t1,-1
    3638:	01912a23          	sw	s9,20(sp)
    363c:	06912023          	sw	s1,96(sp)
    3640:	07512223          	sw	s5,100(sp)
    3644:	06812623          	sw	s0,108(sp)
    3648:	07a12a23          	sw	s10,116(sp)
    364c:	07412c23          	sw	s4,120(sp)
    3650:	07912e23          	sw	s9,124(sp)
    3654:	07212423          	sw	s2,104(sp)
    3658:	000d8c93          	mv	s9,s11
    365c:	06612823          	sw	t1,112(sp)
    3660:	00070d13          	mv	s10,a4
    3664:	00068d93          	mv	s11,a3
    3668:	00080a13          	mv	s4,a6
    366c:	000e8a93          	mv	s5,t4
    3670:	000b0493          	mv	s1,s6
    3674:	05812403          	lw	s0,88(sp)
    3678:	0540006f          	j	36cc <_vfprintf_r+0x21c8>
    367c:	00040593          	mv	a1,s0
    3680:	000c0513          	mv	a0,s8
    3684:	02c12223          	sw	a2,36(sp)
    3688:	03e12023          	sw	t5,32(sp)
    368c:	01f12c23          	sw	t6,24(sp)
    3690:	0bf12a23          	sw	t6,180(sp)
    3694:	0be12c23          	sw	t5,184(sp)
    3698:	0ac12e23          	sw	a2,188(sp)
    369c:	0b212823          	sw	s2,176(sp)
    36a0:	0a012023          	sw	zero,160(sp)
    36a4:	0a012223          	sw	zero,164(sp)
    36a8:	0a012423          	sw	zero,168(sp)
    36ac:	0a012623          	sw	zero,172(sp)
    36b0:	02d0e0ef          	jal	ra,11edc <__eqtf2>
    36b4:	fffc8c93          	addi	s9,s9,-1
    36b8:	01812f83          	lw	t6,24(sp)
    36bc:	02012f03          	lw	t5,32(sp)
    36c0:	02412603          	lw	a2,36(sp)
    36c4:	0e050463          	beqz	a0,37ac <_vfprintf_r+0x22a8>
    36c8:	01612a23          	sw	s6,20(sp)
    36cc:	400307b7          	lui	a5,0x40030
    36d0:	00048613          	mv	a2,s1
    36d4:	00040593          	mv	a1,s0
    36d8:	000c0513          	mv	a0,s8
    36dc:	08f12e23          	sw	a5,156(sp)
    36e0:	0ba12023          	sw	s10,160(sp)
    36e4:	0bb12223          	sw	s11,164(sp)
    36e8:	0b412423          	sw	s4,168(sp)
    36ec:	0b512623          	sw	s5,172(sp)
    36f0:	08012823          	sw	zero,144(sp)
    36f4:	08012a23          	sw	zero,148(sp)
    36f8:	08012c23          	sw	zero,152(sp)
    36fc:	3950e0ef          	jal	ra,12290 <__multf3>
    3700:	000c0513          	mv	a0,s8
    3704:	25c110ef          	jal	ra,14960 <__fixtfsi>
    3708:	00050593          	mv	a1,a0
    370c:	00050993          	mv	s3,a0
    3710:	000c0513          	mv	a0,s8
    3714:	0bc12b03          	lw	s6,188(sp)
    3718:	0b012a83          	lw	s5,176(sp)
    371c:	0b412a03          	lw	s4,180(sp)
    3720:	0b812903          	lw	s2,184(sp)
    3724:	388110ef          	jal	ra,14aac <__floatsitf>
    3728:	0b012703          	lw	a4,176(sp)
    372c:	04c12603          	lw	a2,76(sp)
    3730:	00048593          	mv	a1,s1
    3734:	08e12023          	sw	a4,128(sp)
    3738:	0b412703          	lw	a4,180(sp)
    373c:	00040513          	mv	a0,s0
    3740:	09612e23          	sw	s6,156(sp)
    3744:	08e12223          	sw	a4,132(sp)
    3748:	0b812703          	lw	a4,184(sp)
    374c:	09512823          	sw	s5,144(sp)
    3750:	09412a23          	sw	s4,148(sp)
    3754:	08e12423          	sw	a4,136(sp)
    3758:	0bc12703          	lw	a4,188(sp)
    375c:	09212c23          	sw	s2,152(sp)
    3760:	08e12623          	sw	a4,140(sp)
    3764:	4850f0ef          	jal	ra,133e8 <__subtf3>
    3768:	03412783          	lw	a5,52(sp)
    376c:	0a012903          	lw	s2,160(sp)
    3770:	0a412f83          	lw	t6,164(sp)
    3774:	01378733          	add	a4,a5,s3
    3778:	01412783          	lw	a5,20(sp)
    377c:	00074703          	lbu	a4,0(a4) # 3ffc0000 <__freertos_irq_stack_top+0x3ffa82e0>
    3780:	0a812f03          	lw	t5,168(sp)
    3784:	0ac12603          	lw	a2,172(sp)
    3788:	00178b13          	addi	s6,a5,1 # 40030001 <__freertos_irq_stack_top+0x400182e1>
    378c:	feeb0fa3          	sb	a4,-1(s6)
    3790:	05912823          	sw	s9,80(sp)
    3794:	fff00793          	li	a5,-1
    3798:	00090d13          	mv	s10,s2
    379c:	000f8d93          	mv	s11,t6
    37a0:	000f0a13          	mv	s4,t5
    37a4:	00060a93          	mv	s5,a2
    37a8:	ecfc9ae3          	bne	s9,a5,367c <_vfprintf_r+0x2178>
    37ac:	07012303          	lw	t1,112(sp)
    37b0:	05812583          	lw	a1,88(sp)
    37b4:	00090293          	mv	t0,s2
    37b8:	3ffe0db7          	lui	s11,0x3ffe0
    37bc:	000c0513          	mv	a0,s8
    37c0:	00612c23          	sw	t1,24(sp)
    37c4:	06012483          	lw	s1,96(sp)
    37c8:	0a512823          	sw	t0,176(sp)
    37cc:	06512023          	sw	t0,96(sp)
    37d0:	0bf12a23          	sw	t6,180(sp)
    37d4:	05f12623          	sw	t6,76(sp)
    37d8:	0be12c23          	sw	t5,184(sp)
    37dc:	03e12223          	sw	t5,36(sp)
    37e0:	0ac12e23          	sw	a2,188(sp)
    37e4:	02c12023          	sw	a2,32(sp)
    37e8:	0a012023          	sw	zero,160(sp)
    37ec:	0a012223          	sw	zero,164(sp)
    37f0:	0a012423          	sw	zero,168(sp)
    37f4:	0bb12623          	sw	s11,172(sp)
    37f8:	7b40e0ef          	jal	ra,11fac <__getf2>
    37fc:	06412a83          	lw	s5,100(sp)
    3800:	06c12403          	lw	s0,108(sp)
    3804:	07412d03          	lw	s10,116(sp)
    3808:	07812a03          	lw	s4,120(sp)
    380c:	07c12c83          	lw	s9,124(sp)
    3810:	06812903          	lw	s2,104(sp)
    3814:	01812303          	lw	t1,24(sp)
    3818:	48a04e63          	bgtz	a0,3cb4 <_vfprintf_r+0x27b0>
    381c:	06012283          	lw	t0,96(sp)
    3820:	04c12f83          	lw	t6,76(sp)
    3824:	02412f03          	lw	t5,36(sp)
    3828:	02012603          	lw	a2,32(sp)
    382c:	05812583          	lw	a1,88(sp)
    3830:	000c0513          	mv	a0,s8
    3834:	0a512823          	sw	t0,176(sp)
    3838:	0bf12a23          	sw	t6,180(sp)
    383c:	0be12c23          	sw	t5,184(sp)
    3840:	0ac12e23          	sw	a2,188(sp)
    3844:	0a012023          	sw	zero,160(sp)
    3848:	0a012223          	sw	zero,164(sp)
    384c:	0a012423          	sw	zero,168(sp)
    3850:	0bb12623          	sw	s11,172(sp)
    3854:	6880e0ef          	jal	ra,11edc <__eqtf2>
    3858:	01812303          	lw	t1,24(sp)
    385c:	00051663          	bnez	a0,3868 <_vfprintf_r+0x2364>
    3860:	0019f993          	andi	s3,s3,1
    3864:	44099863          	bnez	s3,3cb4 <_vfprintf_r+0x27b0>
    3868:	05012783          	lw	a5,80(sp)
    386c:	03000693          	li	a3,48
    3870:	00178713          	addi	a4,a5,1
    3874:	00eb0733          	add	a4,s6,a4
    3878:	0007c863          	bltz	a5,3888 <_vfprintf_r+0x2384>
    387c:	001b0b13          	addi	s6,s6,1
    3880:	fedb0fa3          	sb	a3,-1(s6)
    3884:	ff671ce3          	bne	a4,s6,387c <_vfprintf_r+0x2378>
    3888:	419b07b3          	sub	a5,s6,s9
    388c:	00f12c23          	sw	a5,24(sp)
    3890:	ef0fe06f          	j	1f80 <_vfprintf_r+0xa7c>
    3894:	00090993          	mv	s3,s2
    3898:	ac5fe06f          	j	235c <_vfprintf_r+0xe58>
    389c:	02412c83          	lw	s9,36(sp)
    38a0:	01812783          	lw	a5,24(sp)
    38a4:	02812e23          	sw	s0,60(sp)
    38a8:	00068d13          	mv	s10,a3
    38ac:	00fc86b3          	add	a3,s9,a5
    38b0:	01412483          	lw	s1,20(sp)
    38b4:	03412903          	lw	s2,52(sp)
    38b8:	04812403          	lw	s0,72(sp)
    38bc:	02012983          	lw	s3,32(sp)
    38c0:	9756f863          	bgeu	a3,s5,2a30 <_vfprintf_r+0x152c>
    38c4:	00068a93          	mv	s5,a3
    38c8:	968ff06f          	j	2a30 <_vfprintf_r+0x152c>
    38cc:	01412783          	lw	a5,20(sp)
    38d0:	ffd00713          	li	a4,-3
    38d4:	00e7c463          	blt	a5,a4,38dc <_vfprintf_r+0x23d8>
    38d8:	00f35a63          	bge	t1,a5,38ec <_vfprintf_r+0x23e8>
    38dc:	ffea8a93          	addi	s5,s5,-2
    38e0:	fdfaf793          	andi	a5,s5,-33
    38e4:	04f12423          	sw	a5,72(sp)
    38e8:	ec0fe06f          	j	1fa8 <_vfprintf_r+0xaa4>
    38ec:	01812703          	lw	a4,24(sp)
    38f0:	01412783          	lw	a5,20(sp)
    38f4:	22e7c863          	blt	a5,a4,3b24 <_vfprintf_r+0x2620>
    38f8:	05412703          	lw	a4,84(sp)
    38fc:	00078b13          	mv	s6,a5
    3900:	00177713          	andi	a4,a4,1
    3904:	00070663          	beqz	a4,3910 <_vfprintf_r+0x240c>
    3908:	02812703          	lw	a4,40(sp)
    390c:	00e78b33          	add	s6,a5,a4
    3910:	05412783          	lw	a5,84(sp)
    3914:	4007f713          	andi	a4,a5,1024
    3918:	00070663          	beqz	a4,3924 <_vfprintf_r+0x2420>
    391c:	01412783          	lw	a5,20(sp)
    3920:	40f04663          	bgtz	a5,3d2c <_vfprintf_r+0x2828>
    3924:	fffb4993          	not	s3,s6
    3928:	41f9d993          	srai	s3,s3,0x1f
    392c:	013b79b3          	and	s3,s6,s3
    3930:	06700a93          	li	s5,103
    3934:	02012223          	sw	zero,36(sp)
    3938:	02012023          	sw	zero,32(sp)
    393c:	f8cfe06f          	j	20c8 <_vfprintf_r+0xbc4>
    3940:	0c714703          	lbu	a4,199(sp)
    3944:	00000313          	li	t1,0
    3948:	00070463          	beqz	a4,3950 <_vfprintf_r+0x244c>
    394c:	f89fd06f          	j	18d4 <_vfprintf_r+0x3d0>
    3950:	ac0fe06f          	j	1c10 <_vfprintf_r+0x70c>
    3954:	00012823          	sw	zero,16(sp)
    3958:	00070913          	mv	s2,a4
    395c:	80000737          	lui	a4,0x80000
    3960:	02d00793          	li	a5,45
    3964:	01674b33          	xor	s6,a4,s6
    3968:	04f12e23          	sw	a5,92(sp)
    396c:	badff06f          	j	3518 <_vfprintf_r+0x2014>
    3970:	0e410613          	addi	a2,sp,228
    3974:	00098593          	mv	a1,s3
    3978:	000a0513          	mv	a0,s4
    397c:	4c1090ef          	jal	ra,d63c <__sprint_r>
    3980:	00050463          	beqz	a0,3988 <_vfprintf_r+0x2484>
    3984:	e41fd06f          	j	17c4 <_vfprintf_r+0x2c0>
    3988:	00044603          	lbu	a2,0(s0)
    398c:	0ec12703          	lw	a4,236(sp)
    3990:	10c10693          	addi	a3,sp,268
    3994:	00ca8ab3          	add	s5,s5,a2
    3998:	915ff06f          	j	32ac <_vfprintf_r+0x1da8>
    399c:	04012783          	lw	a5,64(sp)
    39a0:	04412583          	lw	a1,68(sp)
    39a4:	00000413          	li	s0,0
    39a8:	40f989b3          	sub	s3,s3,a5
    39ac:	00078613          	mv	a2,a5
    39b0:	00098513          	mv	a0,s3
    39b4:	000070ef          	jal	ra,a9b4 <strncpy>
    39b8:	0014c803          	lbu	a6,1(s1)
    39bc:	00a00613          	li	a2,10
    39c0:	00000693          	li	a3,0
    39c4:	01003833          	snez	a6,a6
    39c8:	000c0513          	mv	a0,s8
    39cc:	000a0593          	mv	a1,s4
    39d0:	010484b3          	add	s1,s1,a6
    39d4:	6390c0ef          	jal	ra,1080c <__udivdi3>
    39d8:	d2cff06f          	j	2f04 <_vfprintf_r+0x1a00>
    39dc:	00900793          	li	a5,9
    39e0:	d387e263          	bltu	a5,s8,2f04 <_vfprintf_r+0x1a00>
    39e4:	d68ff06f          	j	2f4c <_vfprintf_r+0x1a48>
    39e8:	0b010c13          	addi	s8,sp,176
    39ec:	00030693          	mv	a3,t1
    39f0:	0cc10713          	addi	a4,sp,204
    39f4:	0dc10813          	addi	a6,sp,220
    39f8:	0d010793          	addi	a5,sp,208
    39fc:	00300613          	li	a2,3
    3a00:	000c0593          	mv	a1,s8
    3a04:	000a0513          	mv	a0,s4
    3a08:	02612023          	sw	t1,32(sp)
    3a0c:	0be12823          	sw	t5,176(sp)
    3a10:	01e12c23          	sw	t5,24(sp)
    3a14:	0bd12c23          	sw	t4,184(sp)
    3a18:	01d12a23          	sw	t4,20(sp)
    3a1c:	0bb12a23          	sw	s11,180(sp)
    3a20:	0b612e23          	sw	s6,188(sp)
    3a24:	268030ef          	jal	ra,6c8c <_ldtoa_r>
    3a28:	00054683          	lbu	a3,0(a0)
    3a2c:	03000713          	li	a4,48
    3a30:	00050c93          	mv	s9,a0
    3a34:	01412e83          	lw	t4,20(sp)
    3a38:	01812f03          	lw	t5,24(sp)
    3a3c:	02012303          	lw	t1,32(sp)
    3a40:	4ce68c63          	beq	a3,a4,3f18 <_vfprintf_r+0x2a14>
    3a44:	0a010793          	addi	a5,sp,160
    3a48:	04f12c23          	sw	a5,88(sp)
    3a4c:	0cc12703          	lw	a4,204(sp)
    3a50:	006709b3          	add	s3,a4,t1
    3a54:	013c89b3          	add	s3,s9,s3
    3a58:	05812583          	lw	a1,88(sp)
    3a5c:	000c0513          	mv	a0,s8
    3a60:	00612a23          	sw	t1,20(sp)
    3a64:	0be12823          	sw	t5,176(sp)
    3a68:	0bb12a23          	sw	s11,180(sp)
    3a6c:	0bd12c23          	sw	t4,184(sp)
    3a70:	0b612e23          	sw	s6,188(sp)
    3a74:	0a012023          	sw	zero,160(sp)
    3a78:	0a012223          	sw	zero,164(sp)
    3a7c:	0a012423          	sw	zero,168(sp)
    3a80:	0a012623          	sw	zero,172(sp)
    3a84:	4580e0ef          	jal	ra,11edc <__eqtf2>
    3a88:	00098713          	mv	a4,s3
    3a8c:	01412303          	lw	t1,20(sp)
    3a90:	00051463          	bnez	a0,3a98 <_vfprintf_r+0x2594>
    3a94:	ce4fe06f          	j	1f78 <_vfprintf_r+0xa74>
    3a98:	0dc12703          	lw	a4,220(sp)
    3a9c:	03000613          	li	a2,48
    3aa0:	01376463          	bltu	a4,s3,3aa8 <_vfprintf_r+0x25a4>
    3aa4:	cd4fe06f          	j	1f78 <_vfprintf_r+0xa74>
    3aa8:	00170793          	addi	a5,a4,1 # 80000001 <__freertos_irq_stack_top+0x7ffe82e1>
    3aac:	0cf12e23          	sw	a5,220(sp)
    3ab0:	00c70023          	sb	a2,0(a4)
    3ab4:	0dc12703          	lw	a4,220(sp)
    3ab8:	ff3768e3          	bltu	a4,s3,3aa8 <_vfprintf_r+0x25a4>
    3abc:	cbcfe06f          	j	1f78 <_vfprintf_r+0xa74>
    3ac0:	02d00793          	li	a5,45
    3ac4:	0cf103a3          	sb	a5,199(sp)
    3ac8:	02d00713          	li	a4,45
    3acc:	d30ff06f          	j	2ffc <_vfprintf_r+0x1af8>
    3ad0:	00412583          	lw	a1,4(sp)
    3ad4:	0e410613          	addi	a2,sp,228
    3ad8:	000a0513          	mv	a0,s4
    3adc:	361090ef          	jal	ra,d63c <__sprint_r>
    3ae0:	00050463          	beqz	a0,3ae8 <_vfprintf_r+0x25e4>
    3ae4:	ce1fd06f          	j	17c4 <_vfprintf_r+0x2c0>
    3ae8:	0cc12b03          	lw	s6,204(sp)
    3aec:	0ec12703          	lw	a4,236(sp)
    3af0:	10c10d13          	addi	s10,sp,268
    3af4:	f85fe06f          	j	2a78 <_vfprintf_r+0x1574>
    3af8:	0c714703          	lbu	a4,199(sp)
    3afc:	01812623          	sw	s8,12(sp)
    3b00:	02012223          	sw	zero,36(sp)
    3b04:	02012023          	sw	zero,32(sp)
    3b08:	00012a23          	sw	zero,20(sp)
    3b0c:	00030993          	mv	s3,t1
    3b10:	00030b13          	mv	s6,t1
    3b14:	00000313          	li	t1,0
    3b18:	00070463          	beqz	a4,3b20 <_vfprintf_r+0x261c>
    3b1c:	db9fd06f          	j	18d4 <_vfprintf_r+0x3d0>
    3b20:	8f0fe06f          	j	1c10 <_vfprintf_r+0x70c>
    3b24:	01812783          	lw	a5,24(sp)
    3b28:	02812703          	lw	a4,40(sp)
    3b2c:	06700a93          	li	s5,103
    3b30:	00e78b33          	add	s6,a5,a4
    3b34:	01412783          	lw	a5,20(sp)
    3b38:	42f05e63          	blez	a5,3f74 <_vfprintf_r+0x2a70>
    3b3c:	05412783          	lw	a5,84(sp)
    3b40:	4007f713          	andi	a4,a5,1024
    3b44:	1e071663          	bnez	a4,3d30 <_vfprintf_r+0x282c>
    3b48:	fffb4993          	not	s3,s6
    3b4c:	41f9d993          	srai	s3,s3,0x1f
    3b50:	013b79b3          	and	s3,s6,s3
    3b54:	de1ff06f          	j	3934 <_vfprintf_r+0x2430>
    3b58:	00412583          	lw	a1,4(sp)
    3b5c:	0e410613          	addi	a2,sp,228
    3b60:	000a0513          	mv	a0,s4
    3b64:	2d9090ef          	jal	ra,d63c <__sprint_r>
    3b68:	00050463          	beqz	a0,3b70 <_vfprintf_r+0x266c>
    3b6c:	c59fd06f          	j	17c4 <_vfprintf_r+0x2c0>
    3b70:	0cc12b03          	lw	s6,204(sp)
    3b74:	01812783          	lw	a5,24(sp)
    3b78:	0ec12703          	lw	a4,236(sp)
    3b7c:	10c10d13          	addi	s10,sp,268
    3b80:	41678b33          	sub	s6,a5,s6
    3b84:	f41fe06f          	j	2ac4 <_vfprintf_r+0x15c0>
    3b88:	05412783          	lw	a5,84(sp)
    3b8c:	0017f713          	andi	a4,a5,1
    3b90:	01412783          	lw	a5,20(sp)
    3b94:	00676733          	or	a4,a4,t1
    3b98:	3ef05a63          	blez	a5,3f8c <_vfprintf_r+0x2a88>
    3b9c:	24071463          	bnez	a4,3de4 <_vfprintf_r+0x28e0>
    3ba0:	01412b03          	lw	s6,20(sp)
    3ba4:	06600a93          	li	s5,102
    3ba8:	f95ff06f          	j	3b3c <_vfprintf_r+0x2638>
    3bac:	fff00793          	li	a5,-1
    3bb0:	00f12423          	sw	a5,8(sp)
    3bb4:	c39fd06f          	j	17ec <_vfprintf_r+0x2e8>
    3bb8:	01670733          	add	a4,a4,s6
    3bbc:	00168693          	addi	a3,a3,1
    3bc0:	00012797          	auipc	a5,0x12
    3bc4:	c1c78793          	addi	a5,a5,-996 # 157dc <zeroes.4505>
    3bc8:	00f8a023          	sw	a5,0(a7)
    3bcc:	0168a223          	sw	s6,4(a7)
    3bd0:	0ee12623          	sw	a4,236(sp)
    3bd4:	0ed12423          	sw	a3,232(sp)
    3bd8:	00700613          	li	a2,7
    3bdc:	00888893          	addi	a7,a7,8
    3be0:	aad65063          	bge	a2,a3,2e80 <_vfprintf_r+0x197c>
    3be4:	00412583          	lw	a1,4(sp)
    3be8:	0e410613          	addi	a2,sp,228
    3bec:	000a0513          	mv	a0,s4
    3bf0:	24d090ef          	jal	ra,d63c <__sprint_r>
    3bf4:	00050463          	beqz	a0,3bfc <_vfprintf_r+0x26f8>
    3bf8:	bcdfd06f          	j	17c4 <_vfprintf_r+0x2c0>
    3bfc:	0ec12703          	lw	a4,236(sp)
    3c00:	0e812683          	lw	a3,232(sp)
    3c04:	10c10893          	addi	a7,sp,268
    3c08:	a78ff06f          	j	2e80 <_vfprintf_r+0x197c>
    3c0c:	0a010793          	addi	a5,sp,160
    3c10:	006c89b3          	add	s3,s9,t1
    3c14:	04f12c23          	sw	a5,88(sp)
    3c18:	e41ff06f          	j	3a58 <_vfprintf_r+0x2554>
    3c1c:	00130993          	addi	s3,t1,1
    3c20:	0b010c13          	addi	s8,sp,176
    3c24:	0dc10813          	addi	a6,sp,220
    3c28:	0d010793          	addi	a5,sp,208
    3c2c:	0cc10713          	addi	a4,sp,204
    3c30:	00098693          	mv	a3,s3
    3c34:	00200613          	li	a2,2
    3c38:	000c0593          	mv	a1,s8
    3c3c:	000a0513          	mv	a0,s4
    3c40:	02612023          	sw	t1,32(sp)
    3c44:	0be12823          	sw	t5,176(sp)
    3c48:	01e12c23          	sw	t5,24(sp)
    3c4c:	0bd12c23          	sw	t4,184(sp)
    3c50:	01d12a23          	sw	t4,20(sp)
    3c54:	0bb12a23          	sw	s11,180(sp)
    3c58:	0b612e23          	sw	s6,188(sp)
    3c5c:	030030ef          	jal	ra,6c8c <_ldtoa_r>
    3c60:	01412e83          	lw	t4,20(sp)
    3c64:	01812f03          	lw	t5,24(sp)
    3c68:	02012303          	lw	t1,32(sp)
    3c6c:	00050c93          	mv	s9,a0
    3c70:	0a010793          	addi	a5,sp,160
    3c74:	013c89b3          	add	s3,s9,s3
    3c78:	04f12c23          	sw	a5,88(sp)
    3c7c:	dddff06f          	j	3a58 <_vfprintf_r+0x2554>
    3c80:	03000793          	li	a5,48
    3c84:	0cf10423          	sb	a5,200(sp)
    3c88:	07800793          	li	a5,120
    3c8c:	84dff06f          	j	34d8 <_vfprintf_r+0x1fd4>
    3c90:	00130593          	addi	a1,t1,1
    3c94:	000a0513          	mv	a0,s4
    3c98:	00612823          	sw	t1,16(sp)
    3c9c:	5f4040ef          	jal	ra,8290 <_malloc_r>
    3ca0:	00050c93          	mv	s9,a0
    3ca4:	01012303          	lw	t1,16(sp)
    3ca8:	34050c63          	beqz	a0,4000 <_vfprintf_r+0x2afc>
    3cac:	00a12823          	sw	a0,16(sp)
    3cb0:	845ff06f          	j	34f4 <_vfprintf_r+0x1ff0>
    3cb4:	01412783          	lw	a5,20(sp)
    3cb8:	000b0713          	mv	a4,s6
    3cbc:	0cf12e23          	sw	a5,220(sp)
    3cc0:	03412783          	lw	a5,52(sp)
    3cc4:	fffb4683          	lbu	a3,-1(s6)
    3cc8:	00f7c603          	lbu	a2,15(a5)
    3ccc:	02d61063          	bne	a2,a3,3cec <_vfprintf_r+0x27e8>
    3cd0:	03000593          	li	a1,48
    3cd4:	feb70fa3          	sb	a1,-1(a4)
    3cd8:	0dc12703          	lw	a4,220(sp)
    3cdc:	fff70793          	addi	a5,a4,-1
    3ce0:	0cf12e23          	sw	a5,220(sp)
    3ce4:	fff74683          	lbu	a3,-1(a4)
    3ce8:	fed606e3          	beq	a2,a3,3cd4 <_vfprintf_r+0x27d0>
    3cec:	00168613          	addi	a2,a3,1
    3cf0:	03900593          	li	a1,57
    3cf4:	0ff67613          	andi	a2,a2,255
    3cf8:	00b68663          	beq	a3,a1,3d04 <_vfprintf_r+0x2800>
    3cfc:	fec70fa3          	sb	a2,-1(a4)
    3d00:	b89ff06f          	j	3888 <_vfprintf_r+0x2384>
    3d04:	03412783          	lw	a5,52(sp)
    3d08:	00a7c603          	lbu	a2,10(a5)
    3d0c:	fec70fa3          	sb	a2,-1(a4)
    3d10:	b79ff06f          	j	3888 <_vfprintf_r+0x2384>
    3d14:	00030463          	beqz	t1,3d1c <_vfprintf_r+0x2818>
    3d18:	9a4fe06f          	j	1ebc <_vfprintf_r+0x9b8>
    3d1c:	00100313          	li	t1,1
    3d20:	99cfe06f          	j	1ebc <_vfprintf_r+0x9b8>
    3d24:	00600313          	li	t1,6
    3d28:	994fe06f          	j	1ebc <_vfprintf_r+0x9b8>
    3d2c:	06700a93          	li	s5,103
    3d30:	03c12583          	lw	a1,60(sp)
    3d34:	01412783          	lw	a5,20(sp)
    3d38:	02012223          	sw	zero,36(sp)
    3d3c:	0005c703          	lbu	a4,0(a1)
    3d40:	02012023          	sw	zero,32(sp)
    3d44:	0ff00613          	li	a2,255
    3d48:	02c70e63          	beq	a4,a2,3d84 <_vfprintf_r+0x2880>
    3d4c:	02f75c63          	bge	a4,a5,3d84 <_vfprintf_r+0x2880>
    3d50:	0015c683          	lbu	a3,1(a1)
    3d54:	40e787b3          	sub	a5,a5,a4
    3d58:	00068e63          	beqz	a3,3d74 <_vfprintf_r+0x2870>
    3d5c:	02012703          	lw	a4,32(sp)
    3d60:	00158593          	addi	a1,a1,1
    3d64:	00170713          	addi	a4,a4,1
    3d68:	02e12023          	sw	a4,32(sp)
    3d6c:	00068713          	mv	a4,a3
    3d70:	fd9ff06f          	j	3d48 <_vfprintf_r+0x2844>
    3d74:	02412683          	lw	a3,36(sp)
    3d78:	00168693          	addi	a3,a3,1
    3d7c:	02d12223          	sw	a3,36(sp)
    3d80:	fc9ff06f          	j	3d48 <_vfprintf_r+0x2844>
    3d84:	00f12a23          	sw	a5,20(sp)
    3d88:	02412703          	lw	a4,36(sp)
    3d8c:	02012783          	lw	a5,32(sp)
    3d90:	02b12e23          	sw	a1,60(sp)
    3d94:	00e78733          	add	a4,a5,a4
    3d98:	04012783          	lw	a5,64(sp)
    3d9c:	02f70733          	mul	a4,a4,a5
    3da0:	01670b33          	add	s6,a4,s6
    3da4:	fffb4993          	not	s3,s6
    3da8:	41f9d993          	srai	s3,s3,0x1f
    3dac:	013b79b3          	and	s3,s6,s3
    3db0:	b18fe06f          	j	20c8 <_vfprintf_r+0xbc4>
    3db4:	0d610693          	addi	a3,sp,214
    3db8:	00061863          	bnez	a2,3dc8 <_vfprintf_r+0x28c4>
    3dbc:	03000693          	li	a3,48
    3dc0:	0cd10b23          	sb	a3,214(sp)
    3dc4:	0d710693          	addi	a3,sp,215
    3dc8:	1b010793          	addi	a5,sp,432
    3dcc:	40f68633          	sub	a2,a3,a5
    3dd0:	03070713          	addi	a4,a4,48
    3dd4:	0dd60793          	addi	a5,a2,221
    3dd8:	00e68023          	sb	a4,0(a3)
    3ddc:	02f12c23          	sw	a5,56(sp)
    3de0:	aa4fe06f          	j	2084 <_vfprintf_r+0xb80>
    3de4:	02812703          	lw	a4,40(sp)
    3de8:	06600a93          	li	s5,102
    3dec:	00e78b33          	add	s6,a5,a4
    3df0:	006b0b33          	add	s6,s6,t1
    3df4:	d49ff06f          	j	3b3c <_vfprintf_r+0x2638>
    3df8:	0b010c13          	addi	s8,sp,176
    3dfc:	000c0513          	mv	a0,s8
    3e00:	02612a23          	sw	t1,52(sp)
    3e04:	0be12823          	sw	t5,176(sp)
    3e08:	0bd12c23          	sw	t4,184(sp)
    3e0c:	0b612e23          	sw	s6,188(sp)
    3e10:	0bb12a23          	sw	s11,180(sp)
    3e14:	0b0110ef          	jal	ra,14ec4 <__trunctfdf2>
    3e18:	0cc10613          	addi	a2,sp,204
    3e1c:	728060ef          	jal	ra,a544 <frexp>
    3e20:	00058613          	mv	a2,a1
    3e24:	00050593          	mv	a1,a0
    3e28:	000c0513          	mv	a0,s8
    3e2c:	62d100ef          	jal	ra,14c58 <__extenddftf2>
    3e30:	0b012703          	lw	a4,176(sp)
    3e34:	09010793          	addi	a5,sp,144
    3e38:	0a010993          	addi	s3,sp,160
    3e3c:	08e12823          	sw	a4,144(sp)
    3e40:	0b412703          	lw	a4,180(sp)
    3e44:	08010613          	addi	a2,sp,128
    3e48:	00078593          	mv	a1,a5
    3e4c:	08e12a23          	sw	a4,148(sp)
    3e50:	0b812703          	lw	a4,184(sp)
    3e54:	00098513          	mv	a0,s3
    3e58:	00078b13          	mv	s6,a5
    3e5c:	08e12c23          	sw	a4,152(sp)
    3e60:	0bc12703          	lw	a4,188(sp)
    3e64:	04c12623          	sw	a2,76(sp)
    3e68:	05312c23          	sw	s3,88(sp)
    3e6c:	08e12e23          	sw	a4,156(sp)
    3e70:	3ffc0737          	lui	a4,0x3ffc0
    3e74:	08e12623          	sw	a4,140(sp)
    3e78:	08012023          	sw	zero,128(sp)
    3e7c:	08012223          	sw	zero,132(sp)
    3e80:	08012423          	sw	zero,136(sp)
    3e84:	40c0e0ef          	jal	ra,12290 <__multf3>
    3e88:	0a012703          	lw	a4,160(sp)
    3e8c:	0a412683          	lw	a3,164(sp)
    3e90:	0a812803          	lw	a6,168(sp)
    3e94:	0ac12e83          	lw	t4,172(sp)
    3e98:	00098593          	mv	a1,s3
    3e9c:	000c0513          	mv	a0,s8
    3ea0:	0ae12823          	sw	a4,176(sp)
    3ea4:	02e12223          	sw	a4,36(sp)
    3ea8:	0ad12a23          	sw	a3,180(sp)
    3eac:	02d12023          	sw	a3,32(sp)
    3eb0:	0b012c23          	sw	a6,184(sp)
    3eb4:	01012c23          	sw	a6,24(sp)
    3eb8:	0bd12e23          	sw	t4,188(sp)
    3ebc:	01d12a23          	sw	t4,20(sp)
    3ec0:	0a012023          	sw	zero,160(sp)
    3ec4:	0a012223          	sw	zero,164(sp)
    3ec8:	0a012423          	sw	zero,168(sp)
    3ecc:	0a012623          	sw	zero,172(sp)
    3ed0:	00c0e0ef          	jal	ra,11edc <__eqtf2>
    3ed4:	01412e83          	lw	t4,20(sp)
    3ed8:	01812803          	lw	a6,24(sp)
    3edc:	02012683          	lw	a3,32(sp)
    3ee0:	02412703          	lw	a4,36(sp)
    3ee4:	03412303          	lw	t1,52(sp)
    3ee8:	00051663          	bnez	a0,3ef4 <_vfprintf_r+0x29f0>
    3eec:	00100613          	li	a2,1
    3ef0:	0cc12623          	sw	a2,204(sp)
    3ef4:	00012797          	auipc	a5,0x12
    3ef8:	8a478793          	addi	a5,a5,-1884 # 15798 <_data+0x480>
    3efc:	02f12a23          	sw	a5,52(sp)
    3f00:	f34ff06f          	j	3634 <_vfprintf_r+0x2130>
    3f04:	05412783          	lw	a5,84(sp)
    3f08:	0017f713          	andi	a4,a5,1
    3f0c:	00071463          	bnez	a4,3f14 <_vfprintf_r+0x2a10>
    3f10:	994fe06f          	j	20a4 <_vfprintf_r+0xba0>
    3f14:	988fe06f          	j	209c <_vfprintf_r+0xb98>
    3f18:	0a010593          	addi	a1,sp,160
    3f1c:	000c0513          	mv	a0,s8
    3f20:	02612023          	sw	t1,32(sp)
    3f24:	0be12823          	sw	t5,176(sp)
    3f28:	01e12c23          	sw	t5,24(sp)
    3f2c:	0bd12c23          	sw	t4,184(sp)
    3f30:	01d12a23          	sw	t4,20(sp)
    3f34:	04b12c23          	sw	a1,88(sp)
    3f38:	0bb12a23          	sw	s11,180(sp)
    3f3c:	0b612e23          	sw	s6,188(sp)
    3f40:	0a012023          	sw	zero,160(sp)
    3f44:	0a012223          	sw	zero,164(sp)
    3f48:	0a012423          	sw	zero,168(sp)
    3f4c:	0a012623          	sw	zero,172(sp)
    3f50:	78d0d0ef          	jal	ra,11edc <__eqtf2>
    3f54:	01412e83          	lw	t4,20(sp)
    3f58:	01812f03          	lw	t5,24(sp)
    3f5c:	02012303          	lw	t1,32(sp)
    3f60:	ae0506e3          	beqz	a0,3a4c <_vfprintf_r+0x2548>
    3f64:	00100713          	li	a4,1
    3f68:	40670733          	sub	a4,a4,t1
    3f6c:	0ce12623          	sw	a4,204(sp)
    3f70:	ae1ff06f          	j	3a50 <_vfprintf_r+0x254c>
    3f74:	40fb0b33          	sub	s6,s6,a5
    3f78:	001b0b13          	addi	s6,s6,1
    3f7c:	fffb4993          	not	s3,s6
    3f80:	41f9d993          	srai	s3,s3,0x1f
    3f84:	013b79b3          	and	s3,s6,s3
    3f88:	9adff06f          	j	3934 <_vfprintf_r+0x2430>
    3f8c:	00071a63          	bnez	a4,3fa0 <_vfprintf_r+0x2a9c>
    3f90:	00100993          	li	s3,1
    3f94:	06600a93          	li	s5,102
    3f98:	00100b13          	li	s6,1
    3f9c:	999ff06f          	j	3934 <_vfprintf_r+0x2430>
    3fa0:	02812783          	lw	a5,40(sp)
    3fa4:	06600a93          	li	s5,102
    3fa8:	00178b13          	addi	s6,a5,1
    3fac:	006b0b33          	add	s6,s6,t1
    3fb0:	fffb4993          	not	s3,s6
    3fb4:	41f9d993          	srai	s3,s3,0x1f
    3fb8:	013b79b3          	and	s3,s6,s3
    3fbc:	979ff06f          	j	3934 <_vfprintf_r+0x2430>
    3fc0:	000d0793          	mv	a5,s10
    3fc4:	cc5fe06f          	j	2c88 <_vfprintf_r+0x1784>
    3fc8:	00c12703          	lw	a4,12(sp)
    3fcc:	00072c03          	lw	s8,0(a4) # 3ffc0000 <__freertos_irq_stack_top+0x3ffa82e0>
    3fd0:	00470713          	addi	a4,a4,4
    3fd4:	000c5463          	bgez	s8,3fdc <_vfprintf_r+0x2ad8>
    3fd8:	fff00c13          	li	s8,-1
    3fdc:	0014ce03          	lbu	t3,1(s1)
    3fe0:	00e12623          	sw	a4,12(sp)
    3fe4:	00078493          	mv	s1,a5
    3fe8:	ed4fd06f          	j	16bc <_vfprintf_r+0x1b8>
    3fec:	00090993          	mv	s3,s2
    3ff0:	b15fd06f          	j	1b04 <_vfprintf_r+0x600>
    3ff4:	00200793          	li	a5,2
    3ff8:	02f12c23          	sw	a5,56(sp)
    3ffc:	888fe06f          	j	2084 <_vfprintf_r+0xb80>
    4000:	00412703          	lw	a4,4(sp)
    4004:	00c75783          	lhu	a5,12(a4)
    4008:	0407e793          	ori	a5,a5,64
    400c:	00f71623          	sh	a5,12(a4)
    4010:	fc8fd06f          	j	17d8 <_vfprintf_r+0x2d4>
    4014:	00090993          	mv	s3,s2
    4018:	8e8fe06f          	j	2100 <_vfprintf_r+0xbfc>
    401c:	00030993          	mv	s3,t1
    4020:	c51ff06f          	j	3c70 <_vfprintf_r+0x276c>

00004024 <vfprintf>:
    4024:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    4028:	00060693          	mv	a3,a2
    402c:	00058613          	mv	a2,a1
    4030:	00050593          	mv	a1,a0
    4034:	0007a503          	lw	a0,0(a5)
    4038:	cccfd06f          	j	1504 <_vfprintf_r>

0000403c <__sbprintf>:
    403c:	00c5d783          	lhu	a5,12(a1)
    4040:	0645ae03          	lw	t3,100(a1)
    4044:	00e5d303          	lhu	t1,14(a1)
    4048:	01c5a883          	lw	a7,28(a1)
    404c:	0245a803          	lw	a6,36(a1)
    4050:	b8010113          	addi	sp,sp,-1152
    4054:	ffd7f793          	andi	a5,a5,-3
    4058:	40000713          	li	a4,1024
    405c:	46812c23          	sw	s0,1144(sp)
    4060:	00f11a23          	sh	a5,20(sp)
    4064:	00058413          	mv	s0,a1
    4068:	07010793          	addi	a5,sp,112
    406c:	00810593          	addi	a1,sp,8
    4070:	46912a23          	sw	s1,1140(sp)
    4074:	47212823          	sw	s2,1136(sp)
    4078:	46112e23          	sw	ra,1148(sp)
    407c:	00050913          	mv	s2,a0
    4080:	07c12623          	sw	t3,108(sp)
    4084:	00611b23          	sh	t1,22(sp)
    4088:	03112223          	sw	a7,36(sp)
    408c:	03012623          	sw	a6,44(sp)
    4090:	00f12423          	sw	a5,8(sp)
    4094:	00f12c23          	sw	a5,24(sp)
    4098:	00e12823          	sw	a4,16(sp)
    409c:	00e12e23          	sw	a4,28(sp)
    40a0:	02012023          	sw	zero,32(sp)
    40a4:	c60fd0ef          	jal	ra,1504 <_vfprintf_r>
    40a8:	00050493          	mv	s1,a0
    40ac:	02055c63          	bgez	a0,40e4 <__sbprintf+0xa8>
    40b0:	01415783          	lhu	a5,20(sp)
    40b4:	0407f793          	andi	a5,a5,64
    40b8:	00078863          	beqz	a5,40c8 <__sbprintf+0x8c>
    40bc:	00c45783          	lhu	a5,12(s0)
    40c0:	0407e793          	ori	a5,a5,64
    40c4:	00f41623          	sh	a5,12(s0)
    40c8:	47c12083          	lw	ra,1148(sp)
    40cc:	47812403          	lw	s0,1144(sp)
    40d0:	00048513          	mv	a0,s1
    40d4:	47012903          	lw	s2,1136(sp)
    40d8:	47412483          	lw	s1,1140(sp)
    40dc:	48010113          	addi	sp,sp,1152
    40e0:	00008067          	ret
    40e4:	00810593          	addi	a1,sp,8
    40e8:	00090513          	mv	a0,s2
    40ec:	56c000ef          	jal	ra,4658 <_fflush_r>
    40f0:	fc0500e3          	beqz	a0,40b0 <__sbprintf+0x74>
    40f4:	fff00493          	li	s1,-1
    40f8:	fb9ff06f          	j	40b0 <__sbprintf+0x74>

000040fc <__swbuf_r>:
    40fc:	fe010113          	addi	sp,sp,-32
    4100:	00812c23          	sw	s0,24(sp)
    4104:	00912a23          	sw	s1,20(sp)
    4108:	01212823          	sw	s2,16(sp)
    410c:	00112e23          	sw	ra,28(sp)
    4110:	01312623          	sw	s3,12(sp)
    4114:	00050913          	mv	s2,a0
    4118:	00058493          	mv	s1,a1
    411c:	00060413          	mv	s0,a2
    4120:	00050663          	beqz	a0,412c <__swbuf_r+0x30>
    4124:	03852783          	lw	a5,56(a0)
    4128:	14078863          	beqz	a5,4278 <__swbuf_r+0x17c>
    412c:	00c41703          	lh	a4,12(s0)
    4130:	01842783          	lw	a5,24(s0)
    4134:	01071693          	slli	a3,a4,0x10
    4138:	0106d693          	srli	a3,a3,0x10
    413c:	00f42423          	sw	a5,8(s0)
    4140:	0086f793          	andi	a5,a3,8
    4144:	08078263          	beqz	a5,41c8 <__swbuf_r+0xcc>
    4148:	01042783          	lw	a5,16(s0)
    414c:	06078e63          	beqz	a5,41c8 <__swbuf_r+0xcc>
    4150:	01269613          	slli	a2,a3,0x12
    4154:	0ff4f993          	andi	s3,s1,255
    4158:	0ff4f493          	andi	s1,s1,255
    415c:	08065e63          	bgez	a2,41f8 <__swbuf_r+0xfc>
    4160:	00042703          	lw	a4,0(s0)
    4164:	01442683          	lw	a3,20(s0)
    4168:	40f707b3          	sub	a5,a4,a5
    416c:	0ad7de63          	bge	a5,a3,4228 <__swbuf_r+0x12c>
    4170:	00842683          	lw	a3,8(s0)
    4174:	00170613          	addi	a2,a4,1
    4178:	00c42023          	sw	a2,0(s0)
    417c:	fff68693          	addi	a3,a3,-1
    4180:	00d42423          	sw	a3,8(s0)
    4184:	01370023          	sb	s3,0(a4)
    4188:	01442703          	lw	a4,20(s0)
    418c:	00178793          	addi	a5,a5,1
    4190:	0cf70863          	beq	a4,a5,4260 <__swbuf_r+0x164>
    4194:	00c45783          	lhu	a5,12(s0)
    4198:	0017f793          	andi	a5,a5,1
    419c:	00078663          	beqz	a5,41a8 <__swbuf_r+0xac>
    41a0:	00a00793          	li	a5,10
    41a4:	0af48e63          	beq	s1,a5,4260 <__swbuf_r+0x164>
    41a8:	01c12083          	lw	ra,28(sp)
    41ac:	01812403          	lw	s0,24(sp)
    41b0:	00048513          	mv	a0,s1
    41b4:	01012903          	lw	s2,16(sp)
    41b8:	01412483          	lw	s1,20(sp)
    41bc:	00c12983          	lw	s3,12(sp)
    41c0:	02010113          	addi	sp,sp,32
    41c4:	00008067          	ret
    41c8:	00040593          	mv	a1,s0
    41cc:	00090513          	mv	a0,s2
    41d0:	0c4000ef          	jal	ra,4294 <__swsetup_r>
    41d4:	08051e63          	bnez	a0,4270 <__swbuf_r+0x174>
    41d8:	00c41703          	lh	a4,12(s0)
    41dc:	0ff4f993          	andi	s3,s1,255
    41e0:	01042783          	lw	a5,16(s0)
    41e4:	01071693          	slli	a3,a4,0x10
    41e8:	0106d693          	srli	a3,a3,0x10
    41ec:	01269613          	slli	a2,a3,0x12
    41f0:	0ff4f493          	andi	s1,s1,255
    41f4:	f60646e3          	bltz	a2,4160 <__swbuf_r+0x64>
    41f8:	06442683          	lw	a3,100(s0)
    41fc:	00002637          	lui	a2,0x2
    4200:	00c76733          	or	a4,a4,a2
    4204:	ffffe637          	lui	a2,0xffffe
    4208:	fff60613          	addi	a2,a2,-1 # ffffdfff <__freertos_irq_stack_top+0xfffe62df>
    420c:	00c6f6b3          	and	a3,a3,a2
    4210:	00e41623          	sh	a4,12(s0)
    4214:	00042703          	lw	a4,0(s0)
    4218:	06d42223          	sw	a3,100(s0)
    421c:	01442683          	lw	a3,20(s0)
    4220:	40f707b3          	sub	a5,a4,a5
    4224:	f4d7c6e3          	blt	a5,a3,4170 <__swbuf_r+0x74>
    4228:	00040593          	mv	a1,s0
    422c:	00090513          	mv	a0,s2
    4230:	428000ef          	jal	ra,4658 <_fflush_r>
    4234:	02051e63          	bnez	a0,4270 <__swbuf_r+0x174>
    4238:	00042703          	lw	a4,0(s0)
    423c:	00842683          	lw	a3,8(s0)
    4240:	00100793          	li	a5,1
    4244:	00170613          	addi	a2,a4,1
    4248:	fff68693          	addi	a3,a3,-1
    424c:	00c42023          	sw	a2,0(s0)
    4250:	00d42423          	sw	a3,8(s0)
    4254:	01370023          	sb	s3,0(a4)
    4258:	01442703          	lw	a4,20(s0)
    425c:	f2f71ce3          	bne	a4,a5,4194 <__swbuf_r+0x98>
    4260:	00040593          	mv	a1,s0
    4264:	00090513          	mv	a0,s2
    4268:	3f0000ef          	jal	ra,4658 <_fflush_r>
    426c:	f2050ee3          	beqz	a0,41a8 <__swbuf_r+0xac>
    4270:	fff00493          	li	s1,-1
    4274:	f35ff06f          	j	41a8 <__swbuf_r+0xac>
    4278:	798000ef          	jal	ra,4a10 <__sinit>
    427c:	eb1ff06f          	j	412c <__swbuf_r+0x30>

00004280 <__swbuf>:
    4280:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    4284:	00058613          	mv	a2,a1
    4288:	00050593          	mv	a1,a0
    428c:	0007a503          	lw	a0,0(a5)
    4290:	e6dff06f          	j	40fc <__swbuf_r>

00004294 <__swsetup_r>:
    4294:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    4298:	0007a783          	lw	a5,0(a5)
    429c:	ff010113          	addi	sp,sp,-16
    42a0:	00812423          	sw	s0,8(sp)
    42a4:	00912223          	sw	s1,4(sp)
    42a8:	00112623          	sw	ra,12(sp)
    42ac:	00050493          	mv	s1,a0
    42b0:	00058413          	mv	s0,a1
    42b4:	00078663          	beqz	a5,42c0 <__swsetup_r+0x2c>
    42b8:	0387a703          	lw	a4,56(a5)
    42bc:	08070663          	beqz	a4,4348 <__swsetup_r+0xb4>
    42c0:	00c41703          	lh	a4,12(s0)
    42c4:	01071793          	slli	a5,a4,0x10
    42c8:	0107d793          	srli	a5,a5,0x10
    42cc:	0087f693          	andi	a3,a5,8
    42d0:	08068a63          	beqz	a3,4364 <__swsetup_r+0xd0>
    42d4:	01042683          	lw	a3,16(s0)
    42d8:	0a068a63          	beqz	a3,438c <__swsetup_r+0xf8>
    42dc:	0017f713          	andi	a4,a5,1
    42e0:	02070863          	beqz	a4,4310 <__swsetup_r+0x7c>
    42e4:	01442783          	lw	a5,20(s0)
    42e8:	00042423          	sw	zero,8(s0)
    42ec:	00000513          	li	a0,0
    42f0:	40f007b3          	neg	a5,a5
    42f4:	00f42c23          	sw	a5,24(s0)
    42f8:	02068a63          	beqz	a3,432c <__swsetup_r+0x98>
    42fc:	00c12083          	lw	ra,12(sp)
    4300:	00812403          	lw	s0,8(sp)
    4304:	00412483          	lw	s1,4(sp)
    4308:	01010113          	addi	sp,sp,16
    430c:	00008067          	ret
    4310:	0027f793          	andi	a5,a5,2
    4314:	00000713          	li	a4,0
    4318:	00079463          	bnez	a5,4320 <__swsetup_r+0x8c>
    431c:	01442703          	lw	a4,20(s0)
    4320:	00e42423          	sw	a4,8(s0)
    4324:	00000513          	li	a0,0
    4328:	fc069ae3          	bnez	a3,42fc <__swsetup_r+0x68>
    432c:	00c41783          	lh	a5,12(s0)
    4330:	0807f713          	andi	a4,a5,128
    4334:	fc0704e3          	beqz	a4,42fc <__swsetup_r+0x68>
    4338:	0407e793          	ori	a5,a5,64
    433c:	00f41623          	sh	a5,12(s0)
    4340:	fff00513          	li	a0,-1
    4344:	fb9ff06f          	j	42fc <__swsetup_r+0x68>
    4348:	00078513          	mv	a0,a5
    434c:	6c4000ef          	jal	ra,4a10 <__sinit>
    4350:	00c41703          	lh	a4,12(s0)
    4354:	01071793          	slli	a5,a4,0x10
    4358:	0107d793          	srli	a5,a5,0x10
    435c:	0087f693          	andi	a3,a5,8
    4360:	f6069ae3          	bnez	a3,42d4 <__swsetup_r+0x40>
    4364:	0107f693          	andi	a3,a5,16
    4368:	06068e63          	beqz	a3,43e4 <__swsetup_r+0x150>
    436c:	0047f793          	andi	a5,a5,4
    4370:	04079063          	bnez	a5,43b0 <__swsetup_r+0x11c>
    4374:	01042683          	lw	a3,16(s0)
    4378:	00876793          	ori	a5,a4,8
    437c:	00f41623          	sh	a5,12(s0)
    4380:	01079793          	slli	a5,a5,0x10
    4384:	0107d793          	srli	a5,a5,0x10
    4388:	f4069ae3          	bnez	a3,42dc <__swsetup_r+0x48>
    438c:	2807f713          	andi	a4,a5,640
    4390:	20000613          	li	a2,512
    4394:	f4c704e3          	beq	a4,a2,42dc <__swsetup_r+0x48>
    4398:	00040593          	mv	a1,s0
    439c:	00048513          	mv	a0,s1
    43a0:	5d1030ef          	jal	ra,8170 <__smakebuf_r>
    43a4:	00c45783          	lhu	a5,12(s0)
    43a8:	01042683          	lw	a3,16(s0)
    43ac:	f31ff06f          	j	42dc <__swsetup_r+0x48>
    43b0:	03042583          	lw	a1,48(s0)
    43b4:	00058e63          	beqz	a1,43d0 <__swsetup_r+0x13c>
    43b8:	04040793          	addi	a5,s0,64
    43bc:	00f58863          	beq	a1,a5,43cc <__swsetup_r+0x138>
    43c0:	00048513          	mv	a0,s1
    43c4:	7c0000ef          	jal	ra,4b84 <_free_r>
    43c8:	00c41703          	lh	a4,12(s0)
    43cc:	02042823          	sw	zero,48(s0)
    43d0:	01042683          	lw	a3,16(s0)
    43d4:	fdb77713          	andi	a4,a4,-37
    43d8:	00042223          	sw	zero,4(s0)
    43dc:	00d42023          	sw	a3,0(s0)
    43e0:	f99ff06f          	j	4378 <__swsetup_r+0xe4>
    43e4:	00900793          	li	a5,9
    43e8:	00f4a023          	sw	a5,0(s1)
    43ec:	04076713          	ori	a4,a4,64
    43f0:	00e41623          	sh	a4,12(s0)
    43f4:	fff00513          	li	a0,-1
    43f8:	f05ff06f          	j	42fc <__swsetup_r+0x68>

000043fc <__sflush_r>:
    43fc:	00c59783          	lh	a5,12(a1)
    4400:	fe010113          	addi	sp,sp,-32
    4404:	00812c23          	sw	s0,24(sp)
    4408:	01079713          	slli	a4,a5,0x10
    440c:	01075713          	srli	a4,a4,0x10
    4410:	01312623          	sw	s3,12(sp)
    4414:	00112e23          	sw	ra,28(sp)
    4418:	00912a23          	sw	s1,20(sp)
    441c:	01212823          	sw	s2,16(sp)
    4420:	00877693          	andi	a3,a4,8
    4424:	00058413          	mv	s0,a1
    4428:	00050993          	mv	s3,a0
    442c:	10069a63          	bnez	a3,4540 <__sflush_r+0x144>
    4430:	00001737          	lui	a4,0x1
    4434:	80070713          	addi	a4,a4,-2048 # 800 <__stack_size-0x800>
    4438:	0045a683          	lw	a3,4(a1)
    443c:	00e7e7b3          	or	a5,a5,a4
    4440:	00f59623          	sh	a5,12(a1)
    4444:	18d05063          	blez	a3,45c4 <__sflush_r+0x1c8>
    4448:	02842703          	lw	a4,40(s0)
    444c:	0c070a63          	beqz	a4,4520 <__sflush_r+0x124>
    4450:	01079793          	slli	a5,a5,0x10
    4454:	0107d793          	srli	a5,a5,0x10
    4458:	0009a483          	lw	s1,0(s3)
    445c:	01379693          	slli	a3,a5,0x13
    4460:	0009a023          	sw	zero,0(s3)
    4464:	01c42583          	lw	a1,28(s0)
    4468:	1606c463          	bltz	a3,45d0 <__sflush_r+0x1d4>
    446c:	00100693          	li	a3,1
    4470:	00000613          	li	a2,0
    4474:	00098513          	mv	a0,s3
    4478:	000700e7          	jalr	a4
    447c:	fff00793          	li	a5,-1
    4480:	18f50863          	beq	a0,a5,4610 <__sflush_r+0x214>
    4484:	00c45783          	lhu	a5,12(s0)
    4488:	02842703          	lw	a4,40(s0)
    448c:	01c42583          	lw	a1,28(s0)
    4490:	0047f793          	andi	a5,a5,4
    4494:	00078e63          	beqz	a5,44b0 <__sflush_r+0xb4>
    4498:	00442683          	lw	a3,4(s0)
    449c:	03042783          	lw	a5,48(s0)
    44a0:	40d50533          	sub	a0,a0,a3
    44a4:	00078663          	beqz	a5,44b0 <__sflush_r+0xb4>
    44a8:	03c42783          	lw	a5,60(s0)
    44ac:	40f50533          	sub	a0,a0,a5
    44b0:	00050613          	mv	a2,a0
    44b4:	00000693          	li	a3,0
    44b8:	00098513          	mv	a0,s3
    44bc:	000700e7          	jalr	a4
    44c0:	fff00793          	li	a5,-1
    44c4:	10f51a63          	bne	a0,a5,45d8 <__sflush_r+0x1dc>
    44c8:	0009a703          	lw	a4,0(s3)
    44cc:	00c41783          	lh	a5,12(s0)
    44d0:	16070463          	beqz	a4,4638 <__sflush_r+0x23c>
    44d4:	01d00693          	li	a3,29
    44d8:	00d70663          	beq	a4,a3,44e4 <__sflush_r+0xe8>
    44dc:	01600693          	li	a3,22
    44e0:	0cd71063          	bne	a4,a3,45a0 <__sflush_r+0x1a4>
    44e4:	01042683          	lw	a3,16(s0)
    44e8:	fffff737          	lui	a4,0xfffff
    44ec:	7ff70713          	addi	a4,a4,2047 # fffff7ff <__freertos_irq_stack_top+0xfffe7adf>
    44f0:	00e7f7b3          	and	a5,a5,a4
    44f4:	00f41623          	sh	a5,12(s0)
    44f8:	00042223          	sw	zero,4(s0)
    44fc:	00d42023          	sw	a3,0(s0)
    4500:	03042583          	lw	a1,48(s0)
    4504:	0099a023          	sw	s1,0(s3)
    4508:	00058c63          	beqz	a1,4520 <__sflush_r+0x124>
    450c:	04040793          	addi	a5,s0,64
    4510:	00f58663          	beq	a1,a5,451c <__sflush_r+0x120>
    4514:	00098513          	mv	a0,s3
    4518:	66c000ef          	jal	ra,4b84 <_free_r>
    451c:	02042823          	sw	zero,48(s0)
    4520:	00000513          	li	a0,0
    4524:	01c12083          	lw	ra,28(sp)
    4528:	01812403          	lw	s0,24(sp)
    452c:	01412483          	lw	s1,20(sp)
    4530:	01012903          	lw	s2,16(sp)
    4534:	00c12983          	lw	s3,12(sp)
    4538:	02010113          	addi	sp,sp,32
    453c:	00008067          	ret
    4540:	0105a903          	lw	s2,16(a1)
    4544:	fc090ee3          	beqz	s2,4520 <__sflush_r+0x124>
    4548:	0005a483          	lw	s1,0(a1)
    454c:	00377713          	andi	a4,a4,3
    4550:	0125a023          	sw	s2,0(a1)
    4554:	412484b3          	sub	s1,s1,s2
    4558:	00000793          	li	a5,0
    455c:	00071463          	bnez	a4,4564 <__sflush_r+0x168>
    4560:	0145a783          	lw	a5,20(a1)
    4564:	00f42423          	sw	a5,8(s0)
    4568:	00904863          	bgtz	s1,4578 <__sflush_r+0x17c>
    456c:	fb5ff06f          	j	4520 <__sflush_r+0x124>
    4570:	00a90933          	add	s2,s2,a0
    4574:	fa9056e3          	blez	s1,4520 <__sflush_r+0x124>
    4578:	02442783          	lw	a5,36(s0)
    457c:	01c42583          	lw	a1,28(s0)
    4580:	00048693          	mv	a3,s1
    4584:	00090613          	mv	a2,s2
    4588:	00098513          	mv	a0,s3
    458c:	000780e7          	jalr	a5
    4590:	40a484b3          	sub	s1,s1,a0
    4594:	fca04ee3          	bgtz	a0,4570 <__sflush_r+0x174>
    4598:	00c45783          	lhu	a5,12(s0)
    459c:	fff00513          	li	a0,-1
    45a0:	0407e793          	ori	a5,a5,64
    45a4:	00f41623          	sh	a5,12(s0)
    45a8:	01c12083          	lw	ra,28(sp)
    45ac:	01812403          	lw	s0,24(sp)
    45b0:	01412483          	lw	s1,20(sp)
    45b4:	01012903          	lw	s2,16(sp)
    45b8:	00c12983          	lw	s3,12(sp)
    45bc:	02010113          	addi	sp,sp,32
    45c0:	00008067          	ret
    45c4:	03c5a703          	lw	a4,60(a1)
    45c8:	e8e040e3          	bgtz	a4,4448 <__sflush_r+0x4c>
    45cc:	f55ff06f          	j	4520 <__sflush_r+0x124>
    45d0:	05042503          	lw	a0,80(s0)
    45d4:	ebdff06f          	j	4490 <__sflush_r+0x94>
    45d8:	00c45783          	lhu	a5,12(s0)
    45dc:	fffff737          	lui	a4,0xfffff
    45e0:	7ff70713          	addi	a4,a4,2047 # fffff7ff <__freertos_irq_stack_top+0xfffe7adf>
    45e4:	00e7f7b3          	and	a5,a5,a4
    45e8:	01042683          	lw	a3,16(s0)
    45ec:	01079793          	slli	a5,a5,0x10
    45f0:	4107d793          	srai	a5,a5,0x10
    45f4:	00f41623          	sh	a5,12(s0)
    45f8:	00042223          	sw	zero,4(s0)
    45fc:	00d42023          	sw	a3,0(s0)
    4600:	01379713          	slli	a4,a5,0x13
    4604:	ee075ee3          	bgez	a4,4500 <__sflush_r+0x104>
    4608:	04a42823          	sw	a0,80(s0)
    460c:	ef5ff06f          	j	4500 <__sflush_r+0x104>
    4610:	0009a783          	lw	a5,0(s3)
    4614:	e60788e3          	beqz	a5,4484 <__sflush_r+0x88>
    4618:	01d00713          	li	a4,29
    461c:	02e78863          	beq	a5,a4,464c <__sflush_r+0x250>
    4620:	01600713          	li	a4,22
    4624:	02e78463          	beq	a5,a4,464c <__sflush_r+0x250>
    4628:	00c45783          	lhu	a5,12(s0)
    462c:	0407e793          	ori	a5,a5,64
    4630:	00f41623          	sh	a5,12(s0)
    4634:	ef1ff06f          	j	4524 <__sflush_r+0x128>
    4638:	fffff737          	lui	a4,0xfffff
    463c:	7ff70713          	addi	a4,a4,2047 # fffff7ff <__freertos_irq_stack_top+0xfffe7adf>
    4640:	01042683          	lw	a3,16(s0)
    4644:	00e7f7b3          	and	a5,a5,a4
    4648:	fadff06f          	j	45f4 <__sflush_r+0x1f8>
    464c:	0099a023          	sw	s1,0(s3)
    4650:	00000513          	li	a0,0
    4654:	ed1ff06f          	j	4524 <__sflush_r+0x128>

00004658 <_fflush_r>:
    4658:	fe010113          	addi	sp,sp,-32
    465c:	00812c23          	sw	s0,24(sp)
    4660:	00112e23          	sw	ra,28(sp)
    4664:	00050413          	mv	s0,a0
    4668:	00050663          	beqz	a0,4674 <_fflush_r+0x1c>
    466c:	03852783          	lw	a5,56(a0)
    4670:	02078063          	beqz	a5,4690 <_fflush_r+0x38>
    4674:	00c59783          	lh	a5,12(a1)
    4678:	02079663          	bnez	a5,46a4 <_fflush_r+0x4c>
    467c:	01c12083          	lw	ra,28(sp)
    4680:	01812403          	lw	s0,24(sp)
    4684:	00000513          	li	a0,0
    4688:	02010113          	addi	sp,sp,32
    468c:	00008067          	ret
    4690:	00b12623          	sw	a1,12(sp)
    4694:	37c000ef          	jal	ra,4a10 <__sinit>
    4698:	00c12583          	lw	a1,12(sp)
    469c:	00c59783          	lh	a5,12(a1)
    46a0:	fc078ee3          	beqz	a5,467c <_fflush_r+0x24>
    46a4:	00040513          	mv	a0,s0
    46a8:	01812403          	lw	s0,24(sp)
    46ac:	01c12083          	lw	ra,28(sp)
    46b0:	02010113          	addi	sp,sp,32
    46b4:	d49ff06f          	j	43fc <__sflush_r>

000046b8 <fflush>:
    46b8:	00050593          	mv	a1,a0
    46bc:	00050863          	beqz	a0,46cc <fflush+0x14>
    46c0:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    46c4:	0007a503          	lw	a0,0(a5)
    46c8:	f91ff06f          	j	4658 <_fflush_r>
    46cc:	00011797          	auipc	a5,0x11
    46d0:	c0c78793          	addi	a5,a5,-1012 # 152d8 <_global_impure_ptr>
    46d4:	0007a503          	lw	a0,0(a5)
    46d8:	00000597          	auipc	a1,0x0
    46dc:	f8058593          	addi	a1,a1,-128 # 4658 <_fflush_r>
    46e0:	51d0006f          	j	53fc <_fwalk_reent>

000046e4 <__fp_lock>:
    46e4:	00000513          	li	a0,0
    46e8:	00008067          	ret

000046ec <_cleanup_r>:
    46ec:	0000a597          	auipc	a1,0xa
    46f0:	4b458593          	addi	a1,a1,1204 # eba0 <_fclose_r>
    46f4:	5090006f          	j	53fc <_fwalk_reent>

000046f8 <__sinit.part.0>:
    46f8:	fe010113          	addi	sp,sp,-32
    46fc:	00112e23          	sw	ra,28(sp)
    4700:	00812c23          	sw	s0,24(sp)
    4704:	00912a23          	sw	s1,20(sp)
    4708:	01212823          	sw	s2,16(sp)
    470c:	01312623          	sw	s3,12(sp)
    4710:	01412423          	sw	s4,8(sp)
    4714:	01512223          	sw	s5,4(sp)
    4718:	01612023          	sw	s6,0(sp)
    471c:	00452403          	lw	s0,4(a0)
    4720:	00000717          	auipc	a4,0x0
    4724:	fcc70713          	addi	a4,a4,-52 # 46ec <_cleanup_r>
    4728:	02e52e23          	sw	a4,60(a0)
    472c:	2ec50793          	addi	a5,a0,748
    4730:	00300713          	li	a4,3
    4734:	2ee52223          	sw	a4,740(a0)
    4738:	2ef52423          	sw	a5,744(a0)
    473c:	2e052023          	sw	zero,736(a0)
    4740:	00400793          	li	a5,4
    4744:	00050913          	mv	s2,a0
    4748:	00f42623          	sw	a5,12(s0)
    474c:	00800613          	li	a2,8
    4750:	00000593          	li	a1,0
    4754:	06042223          	sw	zero,100(s0)
    4758:	00042023          	sw	zero,0(s0)
    475c:	00042223          	sw	zero,4(s0)
    4760:	00042423          	sw	zero,8(s0)
    4764:	00042823          	sw	zero,16(s0)
    4768:	00042a23          	sw	zero,20(s0)
    476c:	00042c23          	sw	zero,24(s0)
    4770:	05c40513          	addi	a0,s0,92
    4774:	6b4040ef          	jal	ra,8e28 <memset>
    4778:	00892483          	lw	s1,8(s2)
    477c:	00006b17          	auipc	s6,0x6
    4780:	f60b0b13          	addi	s6,s6,-160 # a6dc <__sread>
    4784:	00006a97          	auipc	s5,0x6
    4788:	fbca8a93          	addi	s5,s5,-68 # a740 <__swrite>
    478c:	00006a17          	auipc	s4,0x6
    4790:	03ca0a13          	addi	s4,s4,60 # a7c8 <__sseek>
    4794:	00006997          	auipc	s3,0x6
    4798:	09c98993          	addi	s3,s3,156 # a830 <__sclose>
    479c:	000107b7          	lui	a5,0x10
    47a0:	03642023          	sw	s6,32(s0)
    47a4:	03542223          	sw	s5,36(s0)
    47a8:	03442423          	sw	s4,40(s0)
    47ac:	03342623          	sw	s3,44(s0)
    47b0:	00842e23          	sw	s0,28(s0)
    47b4:	00978793          	addi	a5,a5,9 # 10009 <_svfiprintf_r+0xcf1>
    47b8:	00f4a623          	sw	a5,12(s1)
    47bc:	00800613          	li	a2,8
    47c0:	00000593          	li	a1,0
    47c4:	0604a223          	sw	zero,100(s1)
    47c8:	0004a023          	sw	zero,0(s1)
    47cc:	0004a223          	sw	zero,4(s1)
    47d0:	0004a423          	sw	zero,8(s1)
    47d4:	0004a823          	sw	zero,16(s1)
    47d8:	0004aa23          	sw	zero,20(s1)
    47dc:	0004ac23          	sw	zero,24(s1)
    47e0:	05c48513          	addi	a0,s1,92
    47e4:	644040ef          	jal	ra,8e28 <memset>
    47e8:	00c92403          	lw	s0,12(s2)
    47ec:	000207b7          	lui	a5,0x20
    47f0:	0364a023          	sw	s6,32(s1)
    47f4:	0354a223          	sw	s5,36(s1)
    47f8:	0344a423          	sw	s4,40(s1)
    47fc:	0334a623          	sw	s3,44(s1)
    4800:	0094ae23          	sw	s1,28(s1)
    4804:	01278793          	addi	a5,a5,18 # 20012 <__freertos_irq_stack_top+0x82f2>
    4808:	00f42623          	sw	a5,12(s0)
    480c:	06042223          	sw	zero,100(s0)
    4810:	00042023          	sw	zero,0(s0)
    4814:	00042223          	sw	zero,4(s0)
    4818:	00042423          	sw	zero,8(s0)
    481c:	00042823          	sw	zero,16(s0)
    4820:	00042a23          	sw	zero,20(s0)
    4824:	00042c23          	sw	zero,24(s0)
    4828:	05c40513          	addi	a0,s0,92
    482c:	00800613          	li	a2,8
    4830:	00000593          	li	a1,0
    4834:	5f4040ef          	jal	ra,8e28 <memset>
    4838:	01c12083          	lw	ra,28(sp)
    483c:	03642023          	sw	s6,32(s0)
    4840:	03542223          	sw	s5,36(s0)
    4844:	03442423          	sw	s4,40(s0)
    4848:	03342623          	sw	s3,44(s0)
    484c:	00842e23          	sw	s0,28(s0)
    4850:	01812403          	lw	s0,24(sp)
    4854:	00100793          	li	a5,1
    4858:	02f92c23          	sw	a5,56(s2)
    485c:	01412483          	lw	s1,20(sp)
    4860:	01012903          	lw	s2,16(sp)
    4864:	00c12983          	lw	s3,12(sp)
    4868:	00812a03          	lw	s4,8(sp)
    486c:	00412a83          	lw	s5,4(sp)
    4870:	00012b03          	lw	s6,0(sp)
    4874:	02010113          	addi	sp,sp,32
    4878:	00008067          	ret

0000487c <__fp_unlock>:
    487c:	00000513          	li	a0,0
    4880:	00008067          	ret

00004884 <__sfmoreglue>:
    4884:	ff010113          	addi	sp,sp,-16
    4888:	00912223          	sw	s1,4(sp)
    488c:	06800613          	li	a2,104
    4890:	fff58493          	addi	s1,a1,-1
    4894:	02c484b3          	mul	s1,s1,a2
    4898:	01212023          	sw	s2,0(sp)
    489c:	00058913          	mv	s2,a1
    48a0:	00812423          	sw	s0,8(sp)
    48a4:	00112623          	sw	ra,12(sp)
    48a8:	07448593          	addi	a1,s1,116
    48ac:	1e5030ef          	jal	ra,8290 <_malloc_r>
    48b0:	00050413          	mv	s0,a0
    48b4:	02050063          	beqz	a0,48d4 <__sfmoreglue+0x50>
    48b8:	00c50513          	addi	a0,a0,12
    48bc:	00042023          	sw	zero,0(s0)
    48c0:	01242223          	sw	s2,4(s0)
    48c4:	00a42423          	sw	a0,8(s0)
    48c8:	06848613          	addi	a2,s1,104
    48cc:	00000593          	li	a1,0
    48d0:	558040ef          	jal	ra,8e28 <memset>
    48d4:	00040513          	mv	a0,s0
    48d8:	00c12083          	lw	ra,12(sp)
    48dc:	00812403          	lw	s0,8(sp)
    48e0:	00412483          	lw	s1,4(sp)
    48e4:	00012903          	lw	s2,0(sp)
    48e8:	01010113          	addi	sp,sp,16
    48ec:	00008067          	ret

000048f0 <__sfp>:
    48f0:	fe010113          	addi	sp,sp,-32
    48f4:	00011797          	auipc	a5,0x11
    48f8:	9e478793          	addi	a5,a5,-1564 # 152d8 <_global_impure_ptr>
    48fc:	01212823          	sw	s2,16(sp)
    4900:	0007a903          	lw	s2,0(a5)
    4904:	01312623          	sw	s3,12(sp)
    4908:	00112e23          	sw	ra,28(sp)
    490c:	03892783          	lw	a5,56(s2)
    4910:	00812c23          	sw	s0,24(sp)
    4914:	00912a23          	sw	s1,20(sp)
    4918:	00050993          	mv	s3,a0
    491c:	0a078663          	beqz	a5,49c8 <__sfp+0xd8>
    4920:	2e090913          	addi	s2,s2,736
    4924:	fff00493          	li	s1,-1
    4928:	00492783          	lw	a5,4(s2)
    492c:	00892403          	lw	s0,8(s2)
    4930:	fff78793          	addi	a5,a5,-1
    4934:	0007da63          	bgez	a5,4948 <__sfp+0x58>
    4938:	0800006f          	j	49b8 <__sfp+0xc8>
    493c:	fff78793          	addi	a5,a5,-1
    4940:	06840413          	addi	s0,s0,104
    4944:	06978a63          	beq	a5,s1,49b8 <__sfp+0xc8>
    4948:	00c41703          	lh	a4,12(s0)
    494c:	fe0718e3          	bnez	a4,493c <__sfp+0x4c>
    4950:	ffff07b7          	lui	a5,0xffff0
    4954:	00178793          	addi	a5,a5,1 # ffff0001 <__freertos_irq_stack_top+0xfffd82e1>
    4958:	06042223          	sw	zero,100(s0)
    495c:	00042023          	sw	zero,0(s0)
    4960:	00042223          	sw	zero,4(s0)
    4964:	00042423          	sw	zero,8(s0)
    4968:	00f42623          	sw	a5,12(s0)
    496c:	00042823          	sw	zero,16(s0)
    4970:	00042a23          	sw	zero,20(s0)
    4974:	00042c23          	sw	zero,24(s0)
    4978:	00800613          	li	a2,8
    497c:	00000593          	li	a1,0
    4980:	05c40513          	addi	a0,s0,92
    4984:	4a4040ef          	jal	ra,8e28 <memset>
    4988:	02042823          	sw	zero,48(s0)
    498c:	02042a23          	sw	zero,52(s0)
    4990:	04042223          	sw	zero,68(s0)
    4994:	04042423          	sw	zero,72(s0)
    4998:	00040513          	mv	a0,s0
    499c:	01c12083          	lw	ra,28(sp)
    49a0:	01812403          	lw	s0,24(sp)
    49a4:	01412483          	lw	s1,20(sp)
    49a8:	01012903          	lw	s2,16(sp)
    49ac:	00c12983          	lw	s3,12(sp)
    49b0:	02010113          	addi	sp,sp,32
    49b4:	00008067          	ret
    49b8:	00092403          	lw	s0,0(s2)
    49bc:	00040c63          	beqz	s0,49d4 <__sfp+0xe4>
    49c0:	00040913          	mv	s2,s0
    49c4:	f65ff06f          	j	4928 <__sfp+0x38>
    49c8:	00090513          	mv	a0,s2
    49cc:	d2dff0ef          	jal	ra,46f8 <__sinit.part.0>
    49d0:	f51ff06f          	j	4920 <__sfp+0x30>
    49d4:	00400593          	li	a1,4
    49d8:	00098513          	mv	a0,s3
    49dc:	ea9ff0ef          	jal	ra,4884 <__sfmoreglue>
    49e0:	00a92023          	sw	a0,0(s2)
    49e4:	00050413          	mv	s0,a0
    49e8:	fc051ce3          	bnez	a0,49c0 <__sfp+0xd0>
    49ec:	00c00793          	li	a5,12
    49f0:	00f9a023          	sw	a5,0(s3)
    49f4:	fa5ff06f          	j	4998 <__sfp+0xa8>

000049f8 <_cleanup>:
    49f8:	00011797          	auipc	a5,0x11
    49fc:	8e078793          	addi	a5,a5,-1824 # 152d8 <_global_impure_ptr>
    4a00:	0007a503          	lw	a0,0(a5)
    4a04:	0000a597          	auipc	a1,0xa
    4a08:	19c58593          	addi	a1,a1,412 # eba0 <_fclose_r>
    4a0c:	1f10006f          	j	53fc <_fwalk_reent>

00004a10 <__sinit>:
    4a10:	03852783          	lw	a5,56(a0)
    4a14:	00078463          	beqz	a5,4a1c <__sinit+0xc>
    4a18:	00008067          	ret
    4a1c:	cddff06f          	j	46f8 <__sinit.part.0>

00004a20 <__sfp_lock_acquire>:
    4a20:	00008067          	ret

00004a24 <__sfp_lock_release>:
    4a24:	00008067          	ret

00004a28 <__sinit_lock_acquire>:
    4a28:	00008067          	ret

00004a2c <__sinit_lock_release>:
    4a2c:	00008067          	ret

00004a30 <__fp_lock_all>:
    4a30:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    4a34:	0007a503          	lw	a0,0(a5)
    4a38:	00000597          	auipc	a1,0x0
    4a3c:	cac58593          	addi	a1,a1,-852 # 46e4 <__fp_lock>
    4a40:	10d0006f          	j	534c <_fwalk>

00004a44 <__fp_unlock_all>:
    4a44:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    4a48:	0007a503          	lw	a0,0(a5)
    4a4c:	00000597          	auipc	a1,0x0
    4a50:	e3058593          	addi	a1,a1,-464 # 487c <__fp_unlock>
    4a54:	0f90006f          	j	534c <_fwalk>

00004a58 <_malloc_trim_r>:
    4a58:	fe010113          	addi	sp,sp,-32
    4a5c:	00812c23          	sw	s0,24(sp)
    4a60:	00912a23          	sw	s1,20(sp)
    4a64:	01212823          	sw	s2,16(sp)
    4a68:	01312623          	sw	s3,12(sp)
    4a6c:	00058413          	mv	s0,a1
    4a70:	00112e23          	sw	ra,28(sp)
    4a74:	00012997          	auipc	s3,0x12
    4a78:	e4098993          	addi	s3,s3,-448 # 168b4 <__malloc_av_>
    4a7c:	00050913          	mv	s2,a0
    4a80:	484040ef          	jal	ra,8f04 <__malloc_lock>
    4a84:	0089a683          	lw	a3,8(s3)
    4a88:	00001737          	lui	a4,0x1
    4a8c:	fef70793          	addi	a5,a4,-17 # fef <__stack_size-0x11>
    4a90:	0046a483          	lw	s1,4(a3)
    4a94:	40878433          	sub	s0,a5,s0
    4a98:	ffc4f493          	andi	s1,s1,-4
    4a9c:	00940433          	add	s0,s0,s1
    4aa0:	00c45413          	srli	s0,s0,0xc
    4aa4:	fff40413          	addi	s0,s0,-1
    4aa8:	00c41413          	slli	s0,s0,0xc
    4aac:	00e44e63          	blt	s0,a4,4ac8 <_malloc_trim_r+0x70>
    4ab0:	00000593          	li	a1,0
    4ab4:	00090513          	mv	a0,s2
    4ab8:	239050ef          	jal	ra,a4f0 <_sbrk_r>
    4abc:	0089a783          	lw	a5,8(s3)
    4ac0:	009787b3          	add	a5,a5,s1
    4ac4:	02f50663          	beq	a0,a5,4af0 <_malloc_trim_r+0x98>
    4ac8:	00090513          	mv	a0,s2
    4acc:	43c040ef          	jal	ra,8f08 <__malloc_unlock>
    4ad0:	01c12083          	lw	ra,28(sp)
    4ad4:	01812403          	lw	s0,24(sp)
    4ad8:	01412483          	lw	s1,20(sp)
    4adc:	01012903          	lw	s2,16(sp)
    4ae0:	00c12983          	lw	s3,12(sp)
    4ae4:	00000513          	li	a0,0
    4ae8:	02010113          	addi	sp,sp,32
    4aec:	00008067          	ret
    4af0:	408005b3          	neg	a1,s0
    4af4:	00090513          	mv	a0,s2
    4af8:	1f9050ef          	jal	ra,a4f0 <_sbrk_r>
    4afc:	fff00793          	li	a5,-1
    4b00:	04f50663          	beq	a0,a5,4b4c <_malloc_trim_r+0xf4>
    4b04:	84018793          	addi	a5,gp,-1984 # 16cf0 <__malloc_current_mallinfo>
    4b08:	0007a783          	lw	a5,0(a5)
    4b0c:	0089a703          	lw	a4,8(s3)
    4b10:	408484b3          	sub	s1,s1,s0
    4b14:	0014e493          	ori	s1,s1,1
    4b18:	40878433          	sub	s0,a5,s0
    4b1c:	00090513          	mv	a0,s2
    4b20:	00972223          	sw	s1,4(a4)
    4b24:	8481a023          	sw	s0,-1984(gp) # 16cf0 <__malloc_current_mallinfo>
    4b28:	3e0040ef          	jal	ra,8f08 <__malloc_unlock>
    4b2c:	01c12083          	lw	ra,28(sp)
    4b30:	01812403          	lw	s0,24(sp)
    4b34:	01412483          	lw	s1,20(sp)
    4b38:	01012903          	lw	s2,16(sp)
    4b3c:	00c12983          	lw	s3,12(sp)
    4b40:	00100513          	li	a0,1
    4b44:	02010113          	addi	sp,sp,32
    4b48:	00008067          	ret
    4b4c:	00000593          	li	a1,0
    4b50:	00090513          	mv	a0,s2
    4b54:	19d050ef          	jal	ra,a4f0 <_sbrk_r>
    4b58:	0089a703          	lw	a4,8(s3)
    4b5c:	00f00693          	li	a3,15
    4b60:	40e507b3          	sub	a5,a0,a4
    4b64:	f6f6d2e3          	bge	a3,a5,4ac8 <_malloc_trim_r+0x70>
    4b68:	81418693          	addi	a3,gp,-2028 # 16cc4 <__malloc_sbrk_base>
    4b6c:	0006a683          	lw	a3,0(a3)
    4b70:	0017e793          	ori	a5,a5,1
    4b74:	00f72223          	sw	a5,4(a4)
    4b78:	40d50533          	sub	a0,a0,a3
    4b7c:	84a1a023          	sw	a0,-1984(gp) # 16cf0 <__malloc_current_mallinfo>
    4b80:	f49ff06f          	j	4ac8 <_malloc_trim_r+0x70>

00004b84 <_free_r>:
    4b84:	12058e63          	beqz	a1,4cc0 <_free_r+0x13c>
    4b88:	ff010113          	addi	sp,sp,-16
    4b8c:	00812423          	sw	s0,8(sp)
    4b90:	00912223          	sw	s1,4(sp)
    4b94:	00058413          	mv	s0,a1
    4b98:	00050493          	mv	s1,a0
    4b9c:	00112623          	sw	ra,12(sp)
    4ba0:	364040ef          	jal	ra,8f04 <__malloc_lock>
    4ba4:	ffc42583          	lw	a1,-4(s0)
    4ba8:	ff840713          	addi	a4,s0,-8
    4bac:	00012517          	auipc	a0,0x12
    4bb0:	d0850513          	addi	a0,a0,-760 # 168b4 <__malloc_av_>
    4bb4:	ffe5f793          	andi	a5,a1,-2
    4bb8:	00f70633          	add	a2,a4,a5
    4bbc:	00462683          	lw	a3,4(a2)
    4bc0:	00852803          	lw	a6,8(a0)
    4bc4:	ffc6f693          	andi	a3,a3,-4
    4bc8:	1ac80463          	beq	a6,a2,4d70 <_free_r+0x1ec>
    4bcc:	00d62223          	sw	a3,4(a2)
    4bd0:	0015f593          	andi	a1,a1,1
    4bd4:	00d60833          	add	a6,a2,a3
    4bd8:	0a059463          	bnez	a1,4c80 <_free_r+0xfc>
    4bdc:	ff842303          	lw	t1,-8(s0)
    4be0:	00482583          	lw	a1,4(a6)
    4be4:	00012897          	auipc	a7,0x12
    4be8:	cd888893          	addi	a7,a7,-808 # 168bc <__malloc_av_+0x8>
    4bec:	40670733          	sub	a4,a4,t1
    4bf0:	00872803          	lw	a6,8(a4)
    4bf4:	006787b3          	add	a5,a5,t1
    4bf8:	0015f593          	andi	a1,a1,1
    4bfc:	15180463          	beq	a6,a7,4d44 <_free_r+0x1c0>
    4c00:	00c72303          	lw	t1,12(a4)
    4c04:	00682623          	sw	t1,12(a6)
    4c08:	01032423          	sw	a6,8(t1)
    4c0c:	1e058063          	beqz	a1,4dec <_free_r+0x268>
    4c10:	0017e693          	ori	a3,a5,1
    4c14:	00d72223          	sw	a3,4(a4)
    4c18:	00f62023          	sw	a5,0(a2)
    4c1c:	1ff00693          	li	a3,511
    4c20:	0af6ec63          	bltu	a3,a5,4cd8 <_free_r+0x154>
    4c24:	0037d793          	srli	a5,a5,0x3
    4c28:	00178693          	addi	a3,a5,1
    4c2c:	00369693          	slli	a3,a3,0x3
    4c30:	00452583          	lw	a1,4(a0)
    4c34:	00d50533          	add	a0,a0,a3
    4c38:	00052603          	lw	a2,0(a0)
    4c3c:	4027d693          	srai	a3,a5,0x2
    4c40:	00100793          	li	a5,1
    4c44:	00d797b3          	sll	a5,a5,a3
    4c48:	00b7e7b3          	or	a5,a5,a1
    4c4c:	ff850693          	addi	a3,a0,-8
    4c50:	00d72623          	sw	a3,12(a4)
    4c54:	00c72423          	sw	a2,8(a4)
    4c58:	00012697          	auipc	a3,0x12
    4c5c:	c6f6a023          	sw	a5,-928(a3) # 168b8 <__malloc_av_+0x4>
    4c60:	00e52023          	sw	a4,0(a0)
    4c64:	00e62623          	sw	a4,12(a2)
    4c68:	00812403          	lw	s0,8(sp)
    4c6c:	00c12083          	lw	ra,12(sp)
    4c70:	00048513          	mv	a0,s1
    4c74:	00412483          	lw	s1,4(sp)
    4c78:	01010113          	addi	sp,sp,16
    4c7c:	28c0406f          	j	8f08 <__malloc_unlock>
    4c80:	00482583          	lw	a1,4(a6)
    4c84:	0015f593          	andi	a1,a1,1
    4c88:	02059e63          	bnez	a1,4cc4 <_free_r+0x140>
    4c8c:	00d787b3          	add	a5,a5,a3
    4c90:	00012897          	auipc	a7,0x12
    4c94:	c2c88893          	addi	a7,a7,-980 # 168bc <__malloc_av_+0x8>
    4c98:	00862683          	lw	a3,8(a2)
    4c9c:	0017e813          	ori	a6,a5,1
    4ca0:	00f705b3          	add	a1,a4,a5
    4ca4:	17168063          	beq	a3,a7,4e04 <_free_r+0x280>
    4ca8:	00c62603          	lw	a2,12(a2)
    4cac:	00c6a623          	sw	a2,12(a3)
    4cb0:	00d62423          	sw	a3,8(a2)
    4cb4:	01072223          	sw	a6,4(a4)
    4cb8:	00f5a023          	sw	a5,0(a1)
    4cbc:	f61ff06f          	j	4c1c <_free_r+0x98>
    4cc0:	00008067          	ret
    4cc4:	0017e693          	ori	a3,a5,1
    4cc8:	fed42e23          	sw	a3,-4(s0)
    4ccc:	00f62023          	sw	a5,0(a2)
    4cd0:	1ff00693          	li	a3,511
    4cd4:	f4f6f8e3          	bgeu	a3,a5,4c24 <_free_r+0xa0>
    4cd8:	0097d693          	srli	a3,a5,0x9
    4cdc:	00400613          	li	a2,4
    4ce0:	0ed66463          	bltu	a2,a3,4dc8 <_free_r+0x244>
    4ce4:	0067d693          	srli	a3,a5,0x6
    4ce8:	03968593          	addi	a1,a3,57
    4cec:	03868613          	addi	a2,a3,56
    4cf0:	00359593          	slli	a1,a1,0x3
    4cf4:	00b505b3          	add	a1,a0,a1
    4cf8:	0005a683          	lw	a3,0(a1)
    4cfc:	ff858593          	addi	a1,a1,-8
    4d00:	12d58463          	beq	a1,a3,4e28 <_free_r+0x2a4>
    4d04:	0046a603          	lw	a2,4(a3)
    4d08:	ffc67613          	andi	a2,a2,-4
    4d0c:	00c7f663          	bgeu	a5,a2,4d18 <_free_r+0x194>
    4d10:	0086a683          	lw	a3,8(a3)
    4d14:	fed598e3          	bne	a1,a3,4d04 <_free_r+0x180>
    4d18:	00c6a583          	lw	a1,12(a3)
    4d1c:	00b72623          	sw	a1,12(a4)
    4d20:	00d72423          	sw	a3,8(a4)
    4d24:	00812403          	lw	s0,8(sp)
    4d28:	00e5a423          	sw	a4,8(a1)
    4d2c:	00c12083          	lw	ra,12(sp)
    4d30:	00048513          	mv	a0,s1
    4d34:	00412483          	lw	s1,4(sp)
    4d38:	00e6a623          	sw	a4,12(a3)
    4d3c:	01010113          	addi	sp,sp,16
    4d40:	1c80406f          	j	8f08 <__malloc_unlock>
    4d44:	14059463          	bnez	a1,4e8c <_free_r+0x308>
    4d48:	00862583          	lw	a1,8(a2)
    4d4c:	00c62603          	lw	a2,12(a2)
    4d50:	00f687b3          	add	a5,a3,a5
    4d54:	0017e693          	ori	a3,a5,1
    4d58:	00c5a623          	sw	a2,12(a1)
    4d5c:	00b62423          	sw	a1,8(a2)
    4d60:	00d72223          	sw	a3,4(a4)
    4d64:	00f70733          	add	a4,a4,a5
    4d68:	00f72023          	sw	a5,0(a4)
    4d6c:	efdff06f          	j	4c68 <_free_r+0xe4>
    4d70:	0015f593          	andi	a1,a1,1
    4d74:	00d787b3          	add	a5,a5,a3
    4d78:	02059063          	bnez	a1,4d98 <_free_r+0x214>
    4d7c:	ff842583          	lw	a1,-8(s0)
    4d80:	40b70733          	sub	a4,a4,a1
    4d84:	00c72683          	lw	a3,12(a4)
    4d88:	00872603          	lw	a2,8(a4)
    4d8c:	00b787b3          	add	a5,a5,a1
    4d90:	00d62623          	sw	a3,12(a2)
    4d94:	00c6a423          	sw	a2,8(a3)
    4d98:	81818693          	addi	a3,gp,-2024 # 16cc8 <__malloc_trim_threshold>
    4d9c:	0017e613          	ori	a2,a5,1
    4da0:	0006a683          	lw	a3,0(a3)
    4da4:	00c72223          	sw	a2,4(a4)
    4da8:	00012617          	auipc	a2,0x12
    4dac:	b0e62a23          	sw	a4,-1260(a2) # 168bc <__malloc_av_+0x8>
    4db0:	ead7ece3          	bltu	a5,a3,4c68 <_free_r+0xe4>
    4db4:	83818793          	addi	a5,gp,-1992 # 16ce8 <__malloc_top_pad>
    4db8:	0007a583          	lw	a1,0(a5)
    4dbc:	00048513          	mv	a0,s1
    4dc0:	c99ff0ef          	jal	ra,4a58 <_malloc_trim_r>
    4dc4:	ea5ff06f          	j	4c68 <_free_r+0xe4>
    4dc8:	01400613          	li	a2,20
    4dcc:	02d67463          	bgeu	a2,a3,4df4 <_free_r+0x270>
    4dd0:	05400613          	li	a2,84
    4dd4:	06d66a63          	bltu	a2,a3,4e48 <_free_r+0x2c4>
    4dd8:	00c7d693          	srli	a3,a5,0xc
    4ddc:	06f68593          	addi	a1,a3,111
    4de0:	06e68613          	addi	a2,a3,110
    4de4:	00359593          	slli	a1,a1,0x3
    4de8:	f0dff06f          	j	4cf4 <_free_r+0x170>
    4dec:	00d787b3          	add	a5,a5,a3
    4df0:	ea9ff06f          	j	4c98 <_free_r+0x114>
    4df4:	05c68593          	addi	a1,a3,92
    4df8:	05b68613          	addi	a2,a3,91
    4dfc:	00359593          	slli	a1,a1,0x3
    4e00:	ef5ff06f          	j	4cf4 <_free_r+0x170>
    4e04:	00012697          	auipc	a3,0x12
    4e08:	ace6a223          	sw	a4,-1340(a3) # 168c8 <__malloc_av_+0x14>
    4e0c:	00012697          	auipc	a3,0x12
    4e10:	aae6ac23          	sw	a4,-1352(a3) # 168c4 <__malloc_av_+0x10>
    4e14:	01172623          	sw	a7,12(a4)
    4e18:	01172423          	sw	a7,8(a4)
    4e1c:	01072223          	sw	a6,4(a4)
    4e20:	00f5a023          	sw	a5,0(a1)
    4e24:	e45ff06f          	j	4c68 <_free_r+0xe4>
    4e28:	00452503          	lw	a0,4(a0)
    4e2c:	00100793          	li	a5,1
    4e30:	40265613          	srai	a2,a2,0x2
    4e34:	00c79633          	sll	a2,a5,a2
    4e38:	00a66633          	or	a2,a2,a0
    4e3c:	00012797          	auipc	a5,0x12
    4e40:	a6c7ae23          	sw	a2,-1412(a5) # 168b8 <__malloc_av_+0x4>
    4e44:	ed9ff06f          	j	4d1c <_free_r+0x198>
    4e48:	15400613          	li	a2,340
    4e4c:	00d66c63          	bltu	a2,a3,4e64 <_free_r+0x2e0>
    4e50:	00f7d693          	srli	a3,a5,0xf
    4e54:	07868593          	addi	a1,a3,120
    4e58:	07768613          	addi	a2,a3,119
    4e5c:	00359593          	slli	a1,a1,0x3
    4e60:	e95ff06f          	j	4cf4 <_free_r+0x170>
    4e64:	55400613          	li	a2,1364
    4e68:	00d66c63          	bltu	a2,a3,4e80 <_free_r+0x2fc>
    4e6c:	0127d693          	srli	a3,a5,0x12
    4e70:	07d68593          	addi	a1,a3,125
    4e74:	07c68613          	addi	a2,a3,124
    4e78:	00359593          	slli	a1,a1,0x3
    4e7c:	e79ff06f          	j	4cf4 <_free_r+0x170>
    4e80:	3f800593          	li	a1,1016
    4e84:	07e00613          	li	a2,126
    4e88:	e6dff06f          	j	4cf4 <_free_r+0x170>
    4e8c:	0017e693          	ori	a3,a5,1
    4e90:	00d72223          	sw	a3,4(a4)
    4e94:	00f62023          	sw	a5,0(a2)
    4e98:	dd1ff06f          	j	4c68 <_free_r+0xe4>

00004e9c <__sfvwrite_r>:
    4e9c:	00862783          	lw	a5,8(a2)
    4ea0:	34078263          	beqz	a5,51e4 <__sfvwrite_r+0x348>
    4ea4:	00c5d783          	lhu	a5,12(a1)
    4ea8:	fd010113          	addi	sp,sp,-48
    4eac:	02812423          	sw	s0,40(sp)
    4eb0:	01412c23          	sw	s4,24(sp)
    4eb4:	01512a23          	sw	s5,20(sp)
    4eb8:	02112623          	sw	ra,44(sp)
    4ebc:	02912223          	sw	s1,36(sp)
    4ec0:	03212023          	sw	s2,32(sp)
    4ec4:	01312e23          	sw	s3,28(sp)
    4ec8:	01612823          	sw	s6,16(sp)
    4ecc:	01712623          	sw	s7,12(sp)
    4ed0:	01812423          	sw	s8,8(sp)
    4ed4:	01912223          	sw	s9,4(sp)
    4ed8:	01a12023          	sw	s10,0(sp)
    4edc:	0087f713          	andi	a4,a5,8
    4ee0:	00058413          	mv	s0,a1
    4ee4:	00050a93          	mv	s5,a0
    4ee8:	00060a13          	mv	s4,a2
    4eec:	08070a63          	beqz	a4,4f80 <__sfvwrite_r+0xe4>
    4ef0:	0105a703          	lw	a4,16(a1)
    4ef4:	08070663          	beqz	a4,4f80 <__sfvwrite_r+0xe4>
    4ef8:	0027f713          	andi	a4,a5,2
    4efc:	000a2483          	lw	s1,0(s4)
    4f00:	0a070063          	beqz	a4,4fa0 <__sfvwrite_r+0x104>
    4f04:	02442703          	lw	a4,36(s0)
    4f08:	01c42783          	lw	a5,28(s0)
    4f0c:	80000b37          	lui	s6,0x80000
    4f10:	00000993          	li	s3,0
    4f14:	00000913          	li	s2,0
    4f18:	c00b4b13          	xori	s6,s6,-1024
    4f1c:	00098613          	mv	a2,s3
    4f20:	00078593          	mv	a1,a5
    4f24:	000a8513          	mv	a0,s5
    4f28:	04090463          	beqz	s2,4f70 <__sfvwrite_r+0xd4>
    4f2c:	00090693          	mv	a3,s2
    4f30:	012b7463          	bgeu	s6,s2,4f38 <__sfvwrite_r+0x9c>
    4f34:	000b0693          	mv	a3,s6
    4f38:	000700e7          	jalr	a4
    4f3c:	28a05a63          	blez	a0,51d0 <__sfvwrite_r+0x334>
    4f40:	008a2783          	lw	a5,8(s4)
    4f44:	00a989b3          	add	s3,s3,a0
    4f48:	40a90933          	sub	s2,s2,a0
    4f4c:	40a78533          	sub	a0,a5,a0
    4f50:	00aa2423          	sw	a0,8(s4)
    4f54:	20050c63          	beqz	a0,516c <__sfvwrite_r+0x2d0>
    4f58:	01c42783          	lw	a5,28(s0)
    4f5c:	02442703          	lw	a4,36(s0)
    4f60:	00098613          	mv	a2,s3
    4f64:	00078593          	mv	a1,a5
    4f68:	000a8513          	mv	a0,s5
    4f6c:	fc0910e3          	bnez	s2,4f2c <__sfvwrite_r+0x90>
    4f70:	0004a983          	lw	s3,0(s1)
    4f74:	0044a903          	lw	s2,4(s1)
    4f78:	00848493          	addi	s1,s1,8
    4f7c:	fa1ff06f          	j	4f1c <__sfvwrite_r+0x80>
    4f80:	00040593          	mv	a1,s0
    4f84:	000a8513          	mv	a0,s5
    4f88:	b0cff0ef          	jal	ra,4294 <__swsetup_r>
    4f8c:	3a051c63          	bnez	a0,5344 <__sfvwrite_r+0x4a8>
    4f90:	00c45783          	lhu	a5,12(s0)
    4f94:	000a2483          	lw	s1,0(s4)
    4f98:	0027f713          	andi	a4,a5,2
    4f9c:	f60714e3          	bnez	a4,4f04 <__sfvwrite_r+0x68>
    4fa0:	0017f713          	andi	a4,a5,1
    4fa4:	24071463          	bnez	a4,51ec <__sfvwrite_r+0x350>
    4fa8:	00842c83          	lw	s9,8(s0)
    4fac:	00042503          	lw	a0,0(s0)
    4fb0:	80000bb7          	lui	s7,0x80000
    4fb4:	ffebcc13          	xori	s8,s7,-2
    4fb8:	00000b13          	li	s6,0
    4fbc:	00000913          	li	s2,0
    4fc0:	fffbcb93          	not	s7,s7
    4fc4:	0e090e63          	beqz	s2,50c0 <__sfvwrite_r+0x224>
    4fc8:	2007f713          	andi	a4,a5,512
    4fcc:	24070c63          	beqz	a4,5224 <__sfvwrite_r+0x388>
    4fd0:	000c8d13          	mv	s10,s9
    4fd4:	2f996263          	bltu	s2,s9,52b8 <__sfvwrite_r+0x41c>
    4fd8:	4807f713          	andi	a4,a5,1152
    4fdc:	08070a63          	beqz	a4,5070 <__sfvwrite_r+0x1d4>
    4fe0:	01442683          	lw	a3,20(s0)
    4fe4:	01042583          	lw	a1,16(s0)
    4fe8:	00190713          	addi	a4,s2,1
    4fec:	00169993          	slli	s3,a3,0x1
    4ff0:	00d986b3          	add	a3,s3,a3
    4ff4:	01f6d993          	srli	s3,a3,0x1f
    4ff8:	40b50cb3          	sub	s9,a0,a1
    4ffc:	00d989b3          	add	s3,s3,a3
    5000:	4019d993          	srai	s3,s3,0x1
    5004:	01970733          	add	a4,a4,s9
    5008:	00098613          	mv	a2,s3
    500c:	00e9f663          	bgeu	s3,a4,5018 <__sfvwrite_r+0x17c>
    5010:	00070993          	mv	s3,a4
    5014:	00070613          	mv	a2,a4
    5018:	4007f793          	andi	a5,a5,1024
    501c:	2e078463          	beqz	a5,5304 <__sfvwrite_r+0x468>
    5020:	00060593          	mv	a1,a2
    5024:	000a8513          	mv	a0,s5
    5028:	268030ef          	jal	ra,8290 <_malloc_r>
    502c:	00050d13          	mv	s10,a0
    5030:	30050263          	beqz	a0,5334 <__sfvwrite_r+0x498>
    5034:	01042583          	lw	a1,16(s0)
    5038:	000c8613          	mv	a2,s9
    503c:	3b1030ef          	jal	ra,8bec <memcpy>
    5040:	00c45783          	lhu	a5,12(s0)
    5044:	b7f7f793          	andi	a5,a5,-1153
    5048:	0807e793          	ori	a5,a5,128
    504c:	00f41623          	sh	a5,12(s0)
    5050:	019d0533          	add	a0,s10,s9
    5054:	419987b3          	sub	a5,s3,s9
    5058:	01a42823          	sw	s10,16(s0)
    505c:	00a42023          	sw	a0,0(s0)
    5060:	01342a23          	sw	s3,20(s0)
    5064:	00090c93          	mv	s9,s2
    5068:	00f42423          	sw	a5,8(s0)
    506c:	00090d13          	mv	s10,s2
    5070:	000d0613          	mv	a2,s10
    5074:	000b0593          	mv	a1,s6
    5078:	491030ef          	jal	ra,8d08 <memmove>
    507c:	00842783          	lw	a5,8(s0)
    5080:	00042603          	lw	a2,0(s0)
    5084:	00090993          	mv	s3,s2
    5088:	41978cb3          	sub	s9,a5,s9
    508c:	01a60633          	add	a2,a2,s10
    5090:	01942423          	sw	s9,8(s0)
    5094:	00c42023          	sw	a2,0(s0)
    5098:	00000913          	li	s2,0
    509c:	008a2783          	lw	a5,8(s4)
    50a0:	013b0b33          	add	s6,s6,s3
    50a4:	413789b3          	sub	s3,a5,s3
    50a8:	013a2423          	sw	s3,8(s4)
    50ac:	0c098063          	beqz	s3,516c <__sfvwrite_r+0x2d0>
    50b0:	00842c83          	lw	s9,8(s0)
    50b4:	00042503          	lw	a0,0(s0)
    50b8:	00c45783          	lhu	a5,12(s0)
    50bc:	f00916e3          	bnez	s2,4fc8 <__sfvwrite_r+0x12c>
    50c0:	0004ab03          	lw	s6,0(s1)
    50c4:	0044a903          	lw	s2,4(s1)
    50c8:	00848493          	addi	s1,s1,8
    50cc:	ef9ff06f          	j	4fc4 <__sfvwrite_r+0x128>
    50d0:	0044a983          	lw	s3,4(s1)
    50d4:	0004ab83          	lw	s7,0(s1)
    50d8:	00848493          	addi	s1,s1,8
    50dc:	fe098ae3          	beqz	s3,50d0 <__sfvwrite_r+0x234>
    50e0:	00098613          	mv	a2,s3
    50e4:	00a00593          	li	a1,10
    50e8:	000b8513          	mv	a0,s7
    50ec:	225030ef          	jal	ra,8b10 <memchr>
    50f0:	12050463          	beqz	a0,5218 <__sfvwrite_r+0x37c>
    50f4:	00150513          	addi	a0,a0,1
    50f8:	41750b33          	sub	s6,a0,s7
    50fc:	000b0793          	mv	a5,s6
    5100:	00098c13          	mv	s8,s3
    5104:	0137f463          	bgeu	a5,s3,510c <__sfvwrite_r+0x270>
    5108:	00078c13          	mv	s8,a5
    510c:	00042503          	lw	a0,0(s0)
    5110:	01042783          	lw	a5,16(s0)
    5114:	01442683          	lw	a3,20(s0)
    5118:	00a7f863          	bgeu	a5,a0,5128 <__sfvwrite_r+0x28c>
    511c:	00842903          	lw	s2,8(s0)
    5120:	01268933          	add	s2,a3,s2
    5124:	09894263          	blt	s2,s8,51a8 <__sfvwrite_r+0x30c>
    5128:	1adc4863          	blt	s8,a3,52d8 <__sfvwrite_r+0x43c>
    512c:	02442783          	lw	a5,36(s0)
    5130:	01c42583          	lw	a1,28(s0)
    5134:	000b8613          	mv	a2,s7
    5138:	000a8513          	mv	a0,s5
    513c:	000780e7          	jalr	a5
    5140:	00050913          	mv	s2,a0
    5144:	08a05663          	blez	a0,51d0 <__sfvwrite_r+0x334>
    5148:	412b0b33          	sub	s6,s6,s2
    514c:	00100513          	li	a0,1
    5150:	160b0a63          	beqz	s6,52c4 <__sfvwrite_r+0x428>
    5154:	008a2783          	lw	a5,8(s4)
    5158:	012b8bb3          	add	s7,s7,s2
    515c:	412989b3          	sub	s3,s3,s2
    5160:	41278933          	sub	s2,a5,s2
    5164:	012a2423          	sw	s2,8(s4)
    5168:	08091a63          	bnez	s2,51fc <__sfvwrite_r+0x360>
    516c:	00000513          	li	a0,0
    5170:	02c12083          	lw	ra,44(sp)
    5174:	02812403          	lw	s0,40(sp)
    5178:	02412483          	lw	s1,36(sp)
    517c:	02012903          	lw	s2,32(sp)
    5180:	01c12983          	lw	s3,28(sp)
    5184:	01812a03          	lw	s4,24(sp)
    5188:	01412a83          	lw	s5,20(sp)
    518c:	01012b03          	lw	s6,16(sp)
    5190:	00c12b83          	lw	s7,12(sp)
    5194:	00812c03          	lw	s8,8(sp)
    5198:	00412c83          	lw	s9,4(sp)
    519c:	00012d03          	lw	s10,0(sp)
    51a0:	03010113          	addi	sp,sp,48
    51a4:	00008067          	ret
    51a8:	000b8593          	mv	a1,s7
    51ac:	00090613          	mv	a2,s2
    51b0:	359030ef          	jal	ra,8d08 <memmove>
    51b4:	00042783          	lw	a5,0(s0)
    51b8:	00040593          	mv	a1,s0
    51bc:	000a8513          	mv	a0,s5
    51c0:	012787b3          	add	a5,a5,s2
    51c4:	00f42023          	sw	a5,0(s0)
    51c8:	c90ff0ef          	jal	ra,4658 <_fflush_r>
    51cc:	f6050ee3          	beqz	a0,5148 <__sfvwrite_r+0x2ac>
    51d0:	00c41783          	lh	a5,12(s0)
    51d4:	0407e793          	ori	a5,a5,64
    51d8:	00f41623          	sh	a5,12(s0)
    51dc:	fff00513          	li	a0,-1
    51e0:	f91ff06f          	j	5170 <__sfvwrite_r+0x2d4>
    51e4:	00000513          	li	a0,0
    51e8:	00008067          	ret
    51ec:	00000b13          	li	s6,0
    51f0:	00000513          	li	a0,0
    51f4:	00000b93          	li	s7,0
    51f8:	00000993          	li	s3,0
    51fc:	ec098ae3          	beqz	s3,50d0 <__sfvwrite_r+0x234>
    5200:	ee051ee3          	bnez	a0,50fc <__sfvwrite_r+0x260>
    5204:	00098613          	mv	a2,s3
    5208:	00a00593          	li	a1,10
    520c:	000b8513          	mv	a0,s7
    5210:	101030ef          	jal	ra,8b10 <memchr>
    5214:	ee0510e3          	bnez	a0,50f4 <__sfvwrite_r+0x258>
    5218:	00198793          	addi	a5,s3,1
    521c:	00078b13          	mv	s6,a5
    5220:	ee1ff06f          	j	5100 <__sfvwrite_r+0x264>
    5224:	01042783          	lw	a5,16(s0)
    5228:	04a7e263          	bltu	a5,a0,526c <__sfvwrite_r+0x3d0>
    522c:	01442783          	lw	a5,20(s0)
    5230:	02f96e63          	bltu	s2,a5,526c <__sfvwrite_r+0x3d0>
    5234:	00090693          	mv	a3,s2
    5238:	012c7463          	bgeu	s8,s2,5240 <__sfvwrite_r+0x3a4>
    523c:	000b8693          	mv	a3,s7
    5240:	02f6c6b3          	div	a3,a3,a5
    5244:	02442703          	lw	a4,36(s0)
    5248:	01c42583          	lw	a1,28(s0)
    524c:	000b0613          	mv	a2,s6
    5250:	000a8513          	mv	a0,s5
    5254:	02f686b3          	mul	a3,a3,a5
    5258:	000700e7          	jalr	a4
    525c:	f6a05ae3          	blez	a0,51d0 <__sfvwrite_r+0x334>
    5260:	00050993          	mv	s3,a0
    5264:	41390933          	sub	s2,s2,s3
    5268:	e35ff06f          	j	509c <__sfvwrite_r+0x200>
    526c:	000c8993          	mv	s3,s9
    5270:	01997463          	bgeu	s2,s9,5278 <__sfvwrite_r+0x3dc>
    5274:	00090993          	mv	s3,s2
    5278:	00098613          	mv	a2,s3
    527c:	000b0593          	mv	a1,s6
    5280:	289030ef          	jal	ra,8d08 <memmove>
    5284:	00842783          	lw	a5,8(s0)
    5288:	00042703          	lw	a4,0(s0)
    528c:	413787b3          	sub	a5,a5,s3
    5290:	01370733          	add	a4,a4,s3
    5294:	00f42423          	sw	a5,8(s0)
    5298:	00e42023          	sw	a4,0(s0)
    529c:	fc0794e3          	bnez	a5,5264 <__sfvwrite_r+0x3c8>
    52a0:	00040593          	mv	a1,s0
    52a4:	000a8513          	mv	a0,s5
    52a8:	bb0ff0ef          	jal	ra,4658 <_fflush_r>
    52ac:	f20512e3          	bnez	a0,51d0 <__sfvwrite_r+0x334>
    52b0:	41390933          	sub	s2,s2,s3
    52b4:	de9ff06f          	j	509c <__sfvwrite_r+0x200>
    52b8:	00090c93          	mv	s9,s2
    52bc:	00090d13          	mv	s10,s2
    52c0:	db1ff06f          	j	5070 <__sfvwrite_r+0x1d4>
    52c4:	00040593          	mv	a1,s0
    52c8:	000a8513          	mv	a0,s5
    52cc:	b8cff0ef          	jal	ra,4658 <_fflush_r>
    52d0:	e80502e3          	beqz	a0,5154 <__sfvwrite_r+0x2b8>
    52d4:	efdff06f          	j	51d0 <__sfvwrite_r+0x334>
    52d8:	000c0613          	mv	a2,s8
    52dc:	000b8593          	mv	a1,s7
    52e0:	229030ef          	jal	ra,8d08 <memmove>
    52e4:	00842703          	lw	a4,8(s0)
    52e8:	00042783          	lw	a5,0(s0)
    52ec:	000c0913          	mv	s2,s8
    52f0:	41870733          	sub	a4,a4,s8
    52f4:	01878c33          	add	s8,a5,s8
    52f8:	00e42423          	sw	a4,8(s0)
    52fc:	01842023          	sw	s8,0(s0)
    5300:	e49ff06f          	j	5148 <__sfvwrite_r+0x2ac>
    5304:	000a8513          	mv	a0,s5
    5308:	40d040ef          	jal	ra,9f14 <_realloc_r>
    530c:	00050d13          	mv	s10,a0
    5310:	d40510e3          	bnez	a0,5050 <__sfvwrite_r+0x1b4>
    5314:	01042583          	lw	a1,16(s0)
    5318:	000a8513          	mv	a0,s5
    531c:	869ff0ef          	jal	ra,4b84 <_free_r>
    5320:	00c41783          	lh	a5,12(s0)
    5324:	00c00713          	li	a4,12
    5328:	00eaa023          	sw	a4,0(s5)
    532c:	f7f7f793          	andi	a5,a5,-129
    5330:	ea5ff06f          	j	51d4 <__sfvwrite_r+0x338>
    5334:	00c00793          	li	a5,12
    5338:	00faa023          	sw	a5,0(s5)
    533c:	00c41783          	lh	a5,12(s0)
    5340:	e95ff06f          	j	51d4 <__sfvwrite_r+0x338>
    5344:	fff00513          	li	a0,-1
    5348:	e29ff06f          	j	5170 <__sfvwrite_r+0x2d4>

0000534c <_fwalk>:
    534c:	fe010113          	addi	sp,sp,-32
    5350:	01512223          	sw	s5,4(sp)
    5354:	00112e23          	sw	ra,28(sp)
    5358:	00812c23          	sw	s0,24(sp)
    535c:	00912a23          	sw	s1,20(sp)
    5360:	01212823          	sw	s2,16(sp)
    5364:	01312623          	sw	s3,12(sp)
    5368:	01412423          	sw	s4,8(sp)
    536c:	01612023          	sw	s6,0(sp)
    5370:	2e050a93          	addi	s5,a0,736
    5374:	080a8063          	beqz	s5,53f4 <_fwalk+0xa8>
    5378:	00058b13          	mv	s6,a1
    537c:	00000a13          	li	s4,0
    5380:	00100993          	li	s3,1
    5384:	fff00913          	li	s2,-1
    5388:	004aa483          	lw	s1,4(s5)
    538c:	008aa403          	lw	s0,8(s5)
    5390:	fff48493          	addi	s1,s1,-1
    5394:	0204c663          	bltz	s1,53c0 <_fwalk+0x74>
    5398:	00c45783          	lhu	a5,12(s0)
    539c:	fff48493          	addi	s1,s1,-1
    53a0:	00f9fc63          	bgeu	s3,a5,53b8 <_fwalk+0x6c>
    53a4:	00e41783          	lh	a5,14(s0)
    53a8:	00040513          	mv	a0,s0
    53ac:	01278663          	beq	a5,s2,53b8 <_fwalk+0x6c>
    53b0:	000b00e7          	jalr	s6 # 80000000 <__freertos_irq_stack_top+0x7ffe82e0>
    53b4:	00aa6a33          	or	s4,s4,a0
    53b8:	06840413          	addi	s0,s0,104
    53bc:	fd249ee3          	bne	s1,s2,5398 <_fwalk+0x4c>
    53c0:	000aaa83          	lw	s5,0(s5)
    53c4:	fc0a92e3          	bnez	s5,5388 <_fwalk+0x3c>
    53c8:	01c12083          	lw	ra,28(sp)
    53cc:	01812403          	lw	s0,24(sp)
    53d0:	000a0513          	mv	a0,s4
    53d4:	01412483          	lw	s1,20(sp)
    53d8:	01012903          	lw	s2,16(sp)
    53dc:	00c12983          	lw	s3,12(sp)
    53e0:	00812a03          	lw	s4,8(sp)
    53e4:	00412a83          	lw	s5,4(sp)
    53e8:	00012b03          	lw	s6,0(sp)
    53ec:	02010113          	addi	sp,sp,32
    53f0:	00008067          	ret
    53f4:	00000a13          	li	s4,0
    53f8:	fd1ff06f          	j	53c8 <_fwalk+0x7c>

000053fc <_fwalk_reent>:
    53fc:	fd010113          	addi	sp,sp,-48
    5400:	01512a23          	sw	s5,20(sp)
    5404:	02112623          	sw	ra,44(sp)
    5408:	02812423          	sw	s0,40(sp)
    540c:	02912223          	sw	s1,36(sp)
    5410:	03212023          	sw	s2,32(sp)
    5414:	01312e23          	sw	s3,28(sp)
    5418:	01412c23          	sw	s4,24(sp)
    541c:	01612823          	sw	s6,16(sp)
    5420:	01712623          	sw	s7,12(sp)
    5424:	2e050a93          	addi	s5,a0,736
    5428:	080a8663          	beqz	s5,54b4 <_fwalk_reent+0xb8>
    542c:	00058b93          	mv	s7,a1
    5430:	00050b13          	mv	s6,a0
    5434:	00000a13          	li	s4,0
    5438:	00100993          	li	s3,1
    543c:	fff00913          	li	s2,-1
    5440:	004aa483          	lw	s1,4(s5)
    5444:	008aa403          	lw	s0,8(s5)
    5448:	fff48493          	addi	s1,s1,-1
    544c:	0204c863          	bltz	s1,547c <_fwalk_reent+0x80>
    5450:	00c45783          	lhu	a5,12(s0)
    5454:	fff48493          	addi	s1,s1,-1
    5458:	00f9fe63          	bgeu	s3,a5,5474 <_fwalk_reent+0x78>
    545c:	00e41783          	lh	a5,14(s0)
    5460:	00040593          	mv	a1,s0
    5464:	000b0513          	mv	a0,s6
    5468:	01278663          	beq	a5,s2,5474 <_fwalk_reent+0x78>
    546c:	000b80e7          	jalr	s7 # 80000000 <__freertos_irq_stack_top+0x7ffe82e0>
    5470:	00aa6a33          	or	s4,s4,a0
    5474:	06840413          	addi	s0,s0,104
    5478:	fd249ce3          	bne	s1,s2,5450 <_fwalk_reent+0x54>
    547c:	000aaa83          	lw	s5,0(s5)
    5480:	fc0a90e3          	bnez	s5,5440 <_fwalk_reent+0x44>
    5484:	02c12083          	lw	ra,44(sp)
    5488:	02812403          	lw	s0,40(sp)
    548c:	000a0513          	mv	a0,s4
    5490:	02412483          	lw	s1,36(sp)
    5494:	02012903          	lw	s2,32(sp)
    5498:	01c12983          	lw	s3,28(sp)
    549c:	01812a03          	lw	s4,24(sp)
    54a0:	01412a83          	lw	s5,20(sp)
    54a4:	01012b03          	lw	s6,16(sp)
    54a8:	00c12b83          	lw	s7,12(sp)
    54ac:	03010113          	addi	sp,sp,48
    54b0:	00008067          	ret
    54b4:	00000a13          	li	s4,0
    54b8:	fcdff06f          	j	5484 <_fwalk_reent+0x88>

000054bc <eshdn1>:
    54bc:	00450693          	addi	a3,a0,4
    54c0:	00000793          	li	a5,0
    54c4:	01a50513          	addi	a0,a0,26
    54c8:	ffff8837          	lui	a6,0xffff8
    54cc:	01c0006f          	j	54e8 <eshdn1+0x2c>
    54d0:	00179793          	slli	a5,a5,0x1
    54d4:	00e69023          	sh	a4,0(a3)
    54d8:	01079793          	slli	a5,a5,0x10
    54dc:	00268693          	addi	a3,a3,2
    54e0:	0107d793          	srli	a5,a5,0x10
    54e4:	02d50e63          	beq	a0,a3,5520 <eshdn1+0x64>
    54e8:	0006d703          	lhu	a4,0(a3)
    54ec:	00177613          	andi	a2,a4,1
    54f0:	00060463          	beqz	a2,54f8 <eshdn1+0x3c>
    54f4:	0017e793          	ori	a5,a5,1
    54f8:	00175713          	srli	a4,a4,0x1
    54fc:	0027f613          	andi	a2,a5,2
    5500:	010765b3          	or	a1,a4,a6
    5504:	fc0606e3          	beqz	a2,54d0 <eshdn1+0x14>
    5508:	00179793          	slli	a5,a5,0x1
    550c:	00b69023          	sh	a1,0(a3)
    5510:	01079793          	slli	a5,a5,0x10
    5514:	00268693          	addi	a3,a3,2
    5518:	0107d793          	srli	a5,a5,0x10
    551c:	fcd516e3          	bne	a0,a3,54e8 <eshdn1+0x2c>
    5520:	00008067          	ret

00005524 <eshup1>:
    5524:	01850693          	addi	a3,a0,24
    5528:	00000713          	li	a4,0
    552c:	00250513          	addi	a0,a0,2
    5530:	01c0006f          	j	554c <eshup1+0x28>
    5534:	00171713          	slli	a4,a4,0x1
    5538:	00f69023          	sh	a5,0(a3)
    553c:	01071713          	slli	a4,a4,0x10
    5540:	ffe68693          	addi	a3,a3,-2
    5544:	01075713          	srli	a4,a4,0x10
    5548:	04d50463          	beq	a0,a3,5590 <eshup1+0x6c>
    554c:	0006d783          	lhu	a5,0(a3)
    5550:	01079613          	slli	a2,a5,0x10
    5554:	41065613          	srai	a2,a2,0x10
    5558:	00179793          	slli	a5,a5,0x1
    555c:	00065463          	bgez	a2,5564 <eshup1+0x40>
    5560:	00176713          	ori	a4,a4,1
    5564:	01079793          	slli	a5,a5,0x10
    5568:	0107d793          	srli	a5,a5,0x10
    556c:	00277613          	andi	a2,a4,2
    5570:	0017e593          	ori	a1,a5,1
    5574:	fc0600e3          	beqz	a2,5534 <eshup1+0x10>
    5578:	00171713          	slli	a4,a4,0x1
    557c:	00b69023          	sh	a1,0(a3)
    5580:	01071713          	slli	a4,a4,0x10
    5584:	ffe68693          	addi	a3,a3,-2
    5588:	01075713          	srli	a4,a4,0x10
    558c:	fcd510e3          	bne	a0,a3,554c <eshup1+0x28>
    5590:	00008067          	ret

00005594 <m16m>:
    5594:	fe010113          	addi	sp,sp,-32
    5598:	00010e37          	lui	t3,0x10
    559c:	00011d23          	sh	zero,26(sp)
    55a0:	00011e23          	sh	zero,28(sp)
    55a4:	01858593          	addi	a1,a1,24
    55a8:	01c10793          	addi	a5,sp,28
    55ac:	00810813          	addi	a6,sp,8
    55b0:	fffe0e13          	addi	t3,t3,-1 # ffff <_svfiprintf_r+0xce7>
    55b4:	0005d703          	lhu	a4,0(a1)
    55b8:	ffe78793          	addi	a5,a5,-2
    55bc:	ffe58593          	addi	a1,a1,-2
    55c0:	02071863          	bnez	a4,55f0 <m16m+0x5c>
    55c4:	fe079f23          	sh	zero,-2(a5)
    55c8:	ff0796e3          	bne	a5,a6,55b4 <m16m+0x20>
    55cc:	00460613          	addi	a2,a2,4
    55d0:	01e10693          	addi	a3,sp,30
    55d4:	0007d703          	lhu	a4,0(a5)
    55d8:	00260613          	addi	a2,a2,2
    55dc:	00278793          	addi	a5,a5,2
    55e0:	fee61f23          	sh	a4,-2(a2)
    55e4:	fed798e3          	bne	a5,a3,55d4 <m16m+0x40>
    55e8:	02010113          	addi	sp,sp,32
    55ec:	00008067          	ret
    55f0:	02a70733          	mul	a4,a4,a0
    55f4:	0027d883          	lhu	a7,2(a5)
    55f8:	0007d303          	lhu	t1,0(a5)
    55fc:	01c776b3          	and	a3,a4,t3
    5600:	011686b3          	add	a3,a3,a7
    5604:	01075713          	srli	a4,a4,0x10
    5608:	0106d893          	srli	a7,a3,0x10
    560c:	00670733          	add	a4,a4,t1
    5610:	01170733          	add	a4,a4,a7
    5614:	01075893          	srli	a7,a4,0x10
    5618:	00d79123          	sh	a3,2(a5)
    561c:	00e79023          	sh	a4,0(a5)
    5620:	ff179f23          	sh	a7,-2(a5)
    5624:	f90798e3          	bne	a5,a6,55b4 <m16m+0x20>
    5628:	fa5ff06f          	j	55cc <m16m+0x38>

0000562c <eisnan.part.0>:
    562c:	01250713          	addi	a4,a0,18
    5630:	00250513          	addi	a0,a0,2
    5634:	ffe55783          	lhu	a5,-2(a0)
    5638:	00079863          	bnez	a5,5648 <eisnan.part.0+0x1c>
    563c:	fea71ae3          	bne	a4,a0,5630 <eisnan.part.0+0x4>
    5640:	00000513          	li	a0,0
    5644:	00008067          	ret
    5648:	00100513          	li	a0,1
    564c:	00008067          	ret

00005650 <eneg>:
    5650:	ff010113          	addi	sp,sp,-16
    5654:	00812423          	sw	s0,8(sp)
    5658:	01255403          	lhu	s0,18(a0)
    565c:	00912223          	sw	s1,4(sp)
    5660:	00112623          	sw	ra,12(sp)
    5664:	fff44793          	not	a5,s0
    5668:	01179713          	slli	a4,a5,0x11
    566c:	00050493          	mv	s1,a0
    5670:	00071663          	bnez	a4,567c <eneg+0x2c>
    5674:	fb9ff0ef          	jal	ra,562c <eisnan.part.0>
    5678:	00051863          	bnez	a0,5688 <eneg+0x38>
    567c:	ffff87b7          	lui	a5,0xffff8
    5680:	00f44433          	xor	s0,s0,a5
    5684:	00849923          	sh	s0,18(s1)
    5688:	00c12083          	lw	ra,12(sp)
    568c:	00812403          	lw	s0,8(sp)
    5690:	00412483          	lw	s1,4(sp)
    5694:	01010113          	addi	sp,sp,16
    5698:	00008067          	ret

0000569c <eisneg>:
    569c:	ff010113          	addi	sp,sp,-16
    56a0:	00812423          	sw	s0,8(sp)
    56a4:	01255403          	lhu	s0,18(a0)
    56a8:	00112623          	sw	ra,12(sp)
    56ac:	fff44793          	not	a5,s0
    56b0:	01179713          	slli	a4,a5,0x11
    56b4:	00071863          	bnez	a4,56c4 <eisneg+0x28>
    56b8:	f75ff0ef          	jal	ra,562c <eisnan.part.0>
    56bc:	00000793          	li	a5,0
    56c0:	00051463          	bnez	a0,56c8 <eisneg+0x2c>
    56c4:	00f45793          	srli	a5,s0,0xf
    56c8:	00c12083          	lw	ra,12(sp)
    56cc:	00812403          	lw	s0,8(sp)
    56d0:	00078513          	mv	a0,a5
    56d4:	01010113          	addi	sp,sp,16
    56d8:	00008067          	ret

000056dc <emovi>:
    56dc:	01255783          	lhu	a5,18(a0)
    56e0:	ff010113          	addi	sp,sp,-16
    56e4:	00812423          	sw	s0,8(sp)
    56e8:	00f7d793          	srli	a5,a5,0xf
    56ec:	00912223          	sw	s1,4(sp)
    56f0:	00112623          	sw	ra,12(sp)
    56f4:	01212023          	sw	s2,0(sp)
    56f8:	40f007b3          	neg	a5,a5
    56fc:	00f59023          	sh	a5,0(a1)
    5700:	01255783          	lhu	a5,18(a0)
    5704:	000086b7          	lui	a3,0x8
    5708:	fff68693          	addi	a3,a3,-1 # 7fff <localeconv+0x7>
    570c:	00f6f7b3          	and	a5,a3,a5
    5710:	00f59123          	sh	a5,2(a1)
    5714:	00050493          	mv	s1,a0
    5718:	01050413          	addi	s0,a0,16
    571c:	04d78063          	beq	a5,a3,575c <emovi+0x80>
    5720:	00658793          	addi	a5,a1,6
    5724:	00059223          	sh	zero,4(a1)
    5728:	ffe50513          	addi	a0,a0,-2
    572c:	ffe40413          	addi	s0,s0,-2
    5730:	00245703          	lhu	a4,2(s0)
    5734:	00278793          	addi	a5,a5,2 # ffff8002 <__freertos_irq_stack_top+0xfffe02e2>
    5738:	fee79f23          	sh	a4,-2(a5)
    573c:	fea418e3          	bne	s0,a0,572c <emovi+0x50>
    5740:	00059c23          	sh	zero,24(a1)
    5744:	00c12083          	lw	ra,12(sp)
    5748:	00812403          	lw	s0,8(sp)
    574c:	00412483          	lw	s1,4(sp)
    5750:	00012903          	lw	s2,0(sp)
    5754:	01010113          	addi	sp,sp,16
    5758:	00008067          	ret
    575c:	01255703          	lhu	a4,18(a0)
    5760:	00058913          	mv	s2,a1
    5764:	00e7f733          	and	a4,a5,a4
    5768:	02f71863          	bne	a4,a5,5798 <emovi+0xbc>
    576c:	ec1ff0ef          	jal	ra,562c <eisnan.part.0>
    5770:	02050463          	beqz	a0,5798 <emovi+0xbc>
    5774:	00690713          	addi	a4,s2,6
    5778:	00091223          	sh	zero,4(s2)
    577c:	ffc48793          	addi	a5,s1,-4
    5780:	ffe40413          	addi	s0,s0,-2
    5784:	00245683          	lhu	a3,2(s0)
    5788:	00270713          	addi	a4,a4,2
    578c:	fed71f23          	sh	a3,-2(a4)
    5790:	fe8798e3          	bne	a5,s0,5780 <emovi+0xa4>
    5794:	fb1ff06f          	j	5744 <emovi+0x68>
    5798:	00490793          	addi	a5,s2,4
    579c:	01a90593          	addi	a1,s2,26
    57a0:	00278793          	addi	a5,a5,2
    57a4:	fe079f23          	sh	zero,-2(a5)
    57a8:	fef59ce3          	bne	a1,a5,57a0 <emovi+0xc4>
    57ac:	00c12083          	lw	ra,12(sp)
    57b0:	00812403          	lw	s0,8(sp)
    57b4:	00412483          	lw	s1,4(sp)
    57b8:	00012903          	lw	s2,0(sp)
    57bc:	01010113          	addi	sp,sp,16
    57c0:	00008067          	ret

000057c4 <ecmp>:
    57c4:	01255783          	lhu	a5,18(a0)
    57c8:	fb010113          	addi	sp,sp,-80
    57cc:	04812423          	sw	s0,72(sp)
    57d0:	fff7c793          	not	a5,a5
    57d4:	04912223          	sw	s1,68(sp)
    57d8:	04112623          	sw	ra,76(sp)
    57dc:	01179713          	slli	a4,a5,0x11
    57e0:	00050493          	mv	s1,a0
    57e4:	00058413          	mv	s0,a1
    57e8:	00071663          	bnez	a4,57f4 <ecmp+0x30>
    57ec:	e41ff0ef          	jal	ra,562c <eisnan.part.0>
    57f0:	08051263          	bnez	a0,5874 <ecmp+0xb0>
    57f4:	01245783          	lhu	a5,18(s0)
    57f8:	fff7c793          	not	a5,a5
    57fc:	01179713          	slli	a4,a5,0x11
    5800:	06070463          	beqz	a4,5868 <ecmp+0xa4>
    5804:	00810593          	addi	a1,sp,8
    5808:	00048513          	mv	a0,s1
    580c:	ed1ff0ef          	jal	ra,56dc <emovi>
    5810:	02410593          	addi	a1,sp,36
    5814:	00040513          	mv	a0,s0
    5818:	ec5ff0ef          	jal	ra,56dc <emovi>
    581c:	00815583          	lhu	a1,8(sp)
    5820:	02415503          	lhu	a0,36(sp)
    5824:	04b50c63          	beq	a0,a1,587c <ecmp+0xb8>
    5828:	00a10793          	addi	a5,sp,10
    582c:	02610713          	addi	a4,sp,38
    5830:	02010613          	addi	a2,sp,32
    5834:	0007d683          	lhu	a3,0(a5)
    5838:	00278793          	addi	a5,a5,2
    583c:	08069a63          	bnez	a3,58d0 <ecmp+0x10c>
    5840:	00075683          	lhu	a3,0(a4)
    5844:	00270713          	addi	a4,a4,2
    5848:	08069463          	bnez	a3,58d0 <ecmp+0x10c>
    584c:	fec794e3          	bne	a5,a2,5834 <ecmp+0x70>
    5850:	00000513          	li	a0,0
    5854:	04c12083          	lw	ra,76(sp)
    5858:	04812403          	lw	s0,72(sp)
    585c:	04412483          	lw	s1,68(sp)
    5860:	05010113          	addi	sp,sp,80
    5864:	00008067          	ret
    5868:	00040513          	mv	a0,s0
    586c:	dc1ff0ef          	jal	ra,562c <eisnan.part.0>
    5870:	f8050ae3          	beqz	a0,5804 <ecmp+0x40>
    5874:	ffe00513          	li	a0,-2
    5878:	fddff06f          	j	5854 <ecmp+0x90>
    587c:	00a10713          	addi	a4,sp,10
    5880:	02610793          	addi	a5,sp,38
    5884:	00278793          	addi	a5,a5,2
    5888:	00270713          	addi	a4,a4,2
    588c:	00153513          	seqz	a0,a0
    5890:	ffe75603          	lhu	a2,-2(a4)
    5894:	ffe7d683          	lhu	a3,-2(a5)
    5898:	40a00533          	neg	a0,a0
    589c:	00257513          	andi	a0,a0,2
    58a0:	fff50513          	addi	a0,a0,-1
    58a4:	03c10593          	addi	a1,sp,60
    58a8:	00d61e63          	bne	a2,a3,58c4 <ecmp+0x100>
    58ac:	fab782e3          	beq	a5,a1,5850 <ecmp+0x8c>
    58b0:	00278793          	addi	a5,a5,2
    58b4:	00270713          	addi	a4,a4,2
    58b8:	ffe75603          	lhu	a2,-2(a4)
    58bc:	ffe7d683          	lhu	a3,-2(a5)
    58c0:	fed606e3          	beq	a2,a3,58ac <ecmp+0xe8>
    58c4:	f8c6e8e3          	bltu	a3,a2,5854 <ecmp+0x90>
    58c8:	40a00533          	neg	a0,a0
    58cc:	f89ff06f          	j	5854 <ecmp+0x90>
    58d0:	00100513          	li	a0,1
    58d4:	f80580e3          	beqz	a1,5854 <ecmp+0x90>
    58d8:	fff00513          	li	a0,-1
    58dc:	f79ff06f          	j	5854 <ecmp+0x90>

000058e0 <eisinf.part.1>:
    58e0:	ff010113          	addi	sp,sp,-16
    58e4:	00112623          	sw	ra,12(sp)
    58e8:	d45ff0ef          	jal	ra,562c <eisnan.part.0>
    58ec:	00c12083          	lw	ra,12(sp)
    58f0:	00153513          	seqz	a0,a0
    58f4:	01010113          	addi	sp,sp,16
    58f8:	00008067          	ret

000058fc <eshift.part.3>:
    58fc:	ff010113          	addi	sp,sp,-16
    5900:	00812423          	sw	s0,8(sp)
    5904:	01212023          	sw	s2,0(sp)
    5908:	00112623          	sw	ra,12(sp)
    590c:	00912223          	sw	s1,4(sp)
    5910:	00058913          	mv	s2,a1
    5914:	00050413          	mv	s0,a0
    5918:	0a05c263          	bltz	a1,59bc <eshift.part.3+0xc0>
    591c:	00f00793          	li	a5,15
    5920:	00058613          	mv	a2,a1
    5924:	00450513          	addi	a0,a0,4
    5928:	01840693          	addi	a3,s0,24
    592c:	00f00593          	li	a1,15
    5930:	0327d463          	bge	a5,s2,5958 <eshift.part.3+0x5c>
    5934:	00050793          	mv	a5,a0
    5938:	00278793          	addi	a5,a5,2
    593c:	0007d703          	lhu	a4,0(a5)
    5940:	fee79f23          	sh	a4,-2(a5)
    5944:	fed79ae3          	bne	a5,a3,5938 <eshift.part.3+0x3c>
    5948:	00041c23          	sh	zero,24(s0)
    594c:	ff060613          	addi	a2,a2,-16
    5950:	fec5c2e3          	blt	a1,a2,5934 <eshift.part.3+0x38>
    5954:	00f97913          	andi	s2,s2,15
    5958:	00700793          	li	a5,7
    595c:	0327d863          	bge	a5,s2,598c <eshift.part.3+0x90>
    5960:	01840793          	addi	a5,s0,24
    5964:	00240593          	addi	a1,s0,2
    5968:	00000713          	li	a4,0
    596c:	0007d683          	lhu	a3,0(a5)
    5970:	ffe78793          	addi	a5,a5,-2
    5974:	00869613          	slli	a2,a3,0x8
    5978:	00c76733          	or	a4,a4,a2
    597c:	00e79123          	sh	a4,2(a5)
    5980:	0086d713          	srli	a4,a3,0x8
    5984:	feb794e3          	bne	a5,a1,596c <eshift.part.3+0x70>
    5988:	ff890913          	addi	s2,s2,-8
    598c:	00090a63          	beqz	s2,59a0 <eshift.part.3+0xa4>
    5990:	fff90913          	addi	s2,s2,-1
    5994:	00040513          	mv	a0,s0
    5998:	b8dff0ef          	jal	ra,5524 <eshup1>
    599c:	fe091ae3          	bnez	s2,5990 <eshift.part.3+0x94>
    59a0:	00c12083          	lw	ra,12(sp)
    59a4:	00812403          	lw	s0,8(sp)
    59a8:	00412483          	lw	s1,4(sp)
    59ac:	00012903          	lw	s2,0(sp)
    59b0:	00000513          	li	a0,0
    59b4:	01010113          	addi	sp,sp,16
    59b8:	00008067          	ret
    59bc:	ff100793          	li	a5,-15
    59c0:	40b004b3          	neg	s1,a1
    59c4:	0cf5d463          	bge	a1,a5,5a8c <eshift.part.3+0x190>
    59c8:	01850593          	addi	a1,a0,24
    59cc:	00000913          	li	s2,0
    59d0:	00450693          	addi	a3,a0,4
    59d4:	00f00613          	li	a2,15
    59d8:	01845703          	lhu	a4,24(s0)
    59dc:	00058793          	mv	a5,a1
    59e0:	00e96933          	or	s2,s2,a4
    59e4:	ffe78793          	addi	a5,a5,-2
    59e8:	0007d703          	lhu	a4,0(a5)
    59ec:	00e79123          	sh	a4,2(a5)
    59f0:	fed79ae3          	bne	a5,a3,59e4 <eshift.part.3+0xe8>
    59f4:	00041223          	sh	zero,4(s0)
    59f8:	ff048493          	addi	s1,s1,-16
    59fc:	fc964ee3          	blt	a2,s1,59d8 <eshift.part.3+0xdc>
    5a00:	00700793          	li	a5,7
    5a04:	0497d663          	bge	a5,s1,5a50 <eshift.part.3+0x154>
    5a08:	01091913          	slli	s2,s2,0x10
    5a0c:	41095913          	srai	s2,s2,0x10
    5a10:	01844783          	lbu	a5,24(s0)
    5a14:	01a40593          	addi	a1,s0,26
    5a18:	00000713          	li	a4,0
    5a1c:	00f96933          	or	s2,s2,a5
    5a20:	01091913          	slli	s2,s2,0x10
    5a24:	01095913          	srli	s2,s2,0x10
    5a28:	0006d783          	lhu	a5,0(a3)
    5a2c:	00268693          	addi	a3,a3,2
    5a30:	0087d613          	srli	a2,a5,0x8
    5a34:	00c76733          	or	a4,a4,a2
    5a38:	00879793          	slli	a5,a5,0x8
    5a3c:	fee69f23          	sh	a4,-2(a3)
    5a40:	01079713          	slli	a4,a5,0x10
    5a44:	01075713          	srli	a4,a4,0x10
    5a48:	feb690e3          	bne	a3,a1,5a28 <eshift.part.3+0x12c>
    5a4c:	ff848493          	addi	s1,s1,-8
    5a50:	02048063          	beqz	s1,5a70 <eshift.part.3+0x174>
    5a54:	01845783          	lhu	a5,24(s0)
    5a58:	fff48493          	addi	s1,s1,-1
    5a5c:	00040513          	mv	a0,s0
    5a60:	0017f793          	andi	a5,a5,1
    5a64:	0127e933          	or	s2,a5,s2
    5a68:	a55ff0ef          	jal	ra,54bc <eshdn1>
    5a6c:	fe0494e3          	bnez	s1,5a54 <eshift.part.3+0x158>
    5a70:	00c12083          	lw	ra,12(sp)
    5a74:	00812403          	lw	s0,8(sp)
    5a78:	01203533          	snez	a0,s2
    5a7c:	00412483          	lw	s1,4(sp)
    5a80:	00012903          	lw	s2,0(sp)
    5a84:	01010113          	addi	sp,sp,16
    5a88:	00008067          	ret
    5a8c:	ff900793          	li	a5,-7
    5a90:	00f5c663          	blt	a1,a5,5a9c <eshift.part.3+0x1a0>
    5a94:	00000913          	li	s2,0
    5a98:	fbdff06f          	j	5a54 <eshift.part.3+0x158>
    5a9c:	00000913          	li	s2,0
    5aa0:	00440693          	addi	a3,s0,4
    5aa4:	f6dff06f          	j	5a10 <eshift.part.3+0x114>

00005aa8 <enormlz>:
    5aa8:	00455783          	lhu	a5,4(a0)
    5aac:	ff010113          	addi	sp,sp,-16
    5ab0:	00912223          	sw	s1,4(sp)
    5ab4:	00112623          	sw	ra,12(sp)
    5ab8:	00812423          	sw	s0,8(sp)
    5abc:	01212023          	sw	s2,0(sp)
    5ac0:	00050493          	mv	s1,a0
    5ac4:	0c079c63          	bnez	a5,5b9c <enormlz+0xf4>
    5ac8:	00655703          	lhu	a4,6(a0)
    5acc:	00000413          	li	s0,0
    5ad0:	01071793          	slli	a5,a4,0x10
    5ad4:	4107d793          	srai	a5,a5,0x10
    5ad8:	0a07c463          	bltz	a5,5b80 <enormlz+0xd8>
    5adc:	01a50693          	addi	a3,a0,26
    5ae0:	0a000613          	li	a2,160
    5ae4:	02071863          	bnez	a4,5b14 <enormlz+0x6c>
    5ae8:	00648793          	addi	a5,s1,6
    5aec:	0080006f          	j	5af4 <enormlz+0x4c>
    5af0:	0007d703          	lhu	a4,0(a5)
    5af4:	00278793          	addi	a5,a5,2
    5af8:	fee79e23          	sh	a4,-4(a5)
    5afc:	fef69ae3          	bne	a3,a5,5af0 <enormlz+0x48>
    5b00:	00049c23          	sh	zero,24(s1)
    5b04:	01040413          	addi	s0,s0,16
    5b08:	06c40c63          	beq	s0,a2,5b80 <enormlz+0xd8>
    5b0c:	0064d703          	lhu	a4,6(s1)
    5b10:	fc070ce3          	beqz	a4,5ae8 <enormlz+0x40>
    5b14:	f0077793          	andi	a5,a4,-256
    5b18:	04079063          	bnez	a5,5b58 <enormlz+0xb0>
    5b1c:	01848513          	addi	a0,s1,24
    5b20:	00248593          	addi	a1,s1,2
    5b24:	00000713          	li	a4,0
    5b28:	00050793          	mv	a5,a0
    5b2c:	0007d683          	lhu	a3,0(a5)
    5b30:	ffe78793          	addi	a5,a5,-2
    5b34:	00869613          	slli	a2,a3,0x8
    5b38:	00c76733          	or	a4,a4,a2
    5b3c:	00e79123          	sh	a4,2(a5)
    5b40:	0086d713          	srli	a4,a3,0x8
    5b44:	fef594e3          	bne	a1,a5,5b2c <enormlz+0x84>
    5b48:	0064d703          	lhu	a4,6(s1)
    5b4c:	00840413          	addi	s0,s0,8
    5b50:	f0077793          	andi	a5,a4,-256
    5b54:	fc0788e3          	beqz	a5,5b24 <enormlz+0x7c>
    5b58:	0a000913          	li	s2,160
    5b5c:	0140006f          	j	5b70 <enormlz+0xc8>
    5b60:	00140413          	addi	s0,s0,1
    5b64:	9c1ff0ef          	jal	ra,5524 <eshup1>
    5b68:	00894c63          	blt	s2,s0,5b80 <enormlz+0xd8>
    5b6c:	0064d703          	lhu	a4,6(s1)
    5b70:	01071713          	slli	a4,a4,0x10
    5b74:	41075713          	srai	a4,a4,0x10
    5b78:	00048513          	mv	a0,s1
    5b7c:	fe0752e3          	bgez	a4,5b60 <enormlz+0xb8>
    5b80:	00040513          	mv	a0,s0
    5b84:	00c12083          	lw	ra,12(sp)
    5b88:	00812403          	lw	s0,8(sp)
    5b8c:	00412483          	lw	s1,4(sp)
    5b90:	00012903          	lw	s2,0(sp)
    5b94:	01010113          	addi	sp,sp,16
    5b98:	00008067          	ret
    5b9c:	f007f713          	andi	a4,a5,-256
    5ba0:	00000413          	li	s0,0
    5ba4:	04071063          	bnez	a4,5be4 <enormlz+0x13c>
    5ba8:	f6f00913          	li	s2,-145
    5bac:	0140006f          	j	5bc0 <enormlz+0x118>
    5bb0:	fff40413          	addi	s0,s0,-1
    5bb4:	909ff0ef          	jal	ra,54bc <eshdn1>
    5bb8:	fd2404e3          	beq	s0,s2,5b80 <enormlz+0xd8>
    5bbc:	0044d783          	lhu	a5,4(s1)
    5bc0:	00048513          	mv	a0,s1
    5bc4:	fe0796e3          	bnez	a5,5bb0 <enormlz+0x108>
    5bc8:	00040513          	mv	a0,s0
    5bcc:	00c12083          	lw	ra,12(sp)
    5bd0:	00812403          	lw	s0,8(sp)
    5bd4:	00412483          	lw	s1,4(sp)
    5bd8:	00012903          	lw	s2,0(sp)
    5bdc:	01010113          	addi	sp,sp,16
    5be0:	00008067          	ret
    5be4:	00450693          	addi	a3,a0,4
    5be8:	01a50593          	addi	a1,a0,26
    5bec:	00000713          	li	a4,0
    5bf0:	0080006f          	j	5bf8 <enormlz+0x150>
    5bf4:	0006d783          	lhu	a5,0(a3)
    5bf8:	0087d613          	srli	a2,a5,0x8
    5bfc:	00c76733          	or	a4,a4,a2
    5c00:	00879793          	slli	a5,a5,0x8
    5c04:	00e69023          	sh	a4,0(a3)
    5c08:	01079713          	slli	a4,a5,0x10
    5c0c:	00268693          	addi	a3,a3,2
    5c10:	01075713          	srli	a4,a4,0x10
    5c14:	feb690e3          	bne	a3,a1,5bf4 <enormlz+0x14c>
    5c18:	0044d783          	lhu	a5,4(s1)
    5c1c:	ff800413          	li	s0,-8
    5c20:	f89ff06f          	j	5ba8 <enormlz+0x100>

00005c24 <emdnorm>:
    5c24:	fe010113          	addi	sp,sp,-32
    5c28:	00812c23          	sw	s0,24(sp)
    5c2c:	00912a23          	sw	s1,20(sp)
    5c30:	01212823          	sw	s2,16(sp)
    5c34:	01312623          	sw	s3,12(sp)
    5c38:	01412423          	sw	s4,8(sp)
    5c3c:	01512223          	sw	s5,4(sp)
    5c40:	00068913          	mv	s2,a3
    5c44:	00078493          	mv	s1,a5
    5c48:	00112e23          	sw	ra,28(sp)
    5c4c:	00050413          	mv	s0,a0
    5c50:	00058993          	mv	s3,a1
    5c54:	00060a13          	mv	s4,a2
    5c58:	00070a93          	mv	s5,a4
    5c5c:	e4dff0ef          	jal	ra,5aa8 <enormlz>
    5c60:	09000793          	li	a5,144
    5c64:	40a90933          	sub	s2,s2,a0
    5c68:	06a7de63          	bge	a5,a0,5ce4 <emdnorm+0xc0>
    5c6c:	000087b7          	lui	a5,0x8
    5c70:	ffe78793          	addi	a5,a5,-2 # 7ffe <localeconv+0x6>
    5c74:	2127da63          	bge	a5,s2,5e88 <emdnorm+0x264>
    5c78:	1e0a8463          	beqz	s5,5e60 <emdnorm+0x23c>
    5c7c:	0044a503          	lw	a0,4(s1)
    5c80:	0004a783          	lw	a5,0(s1)
    5c84:	0ea78a63          	beq	a5,a0,5d78 <emdnorm+0x154>
    5c88:	01a48713          	addi	a4,s1,26
    5c8c:	03448793          	addi	a5,s1,52
    5c90:	00270713          	addi	a4,a4,2
    5c94:	fe071f23          	sh	zero,-2(a4)
    5c98:	fef71ce3          	bne	a4,a5,5c90 <emdnorm+0x6c>
    5c9c:	03800793          	li	a5,56
    5ca0:	36f50063          	beq	a0,a5,6000 <emdnorm+0x3dc>
    5ca4:	06a7d263          	bge	a5,a0,5d08 <emdnorm+0xe4>
    5ca8:	04000793          	li	a5,64
    5cac:	2ef50a63          	beq	a0,a5,5fa0 <emdnorm+0x37c>
    5cb0:	07100793          	li	a5,113
    5cb4:	30f51c63          	bne	a0,a5,5fcc <emdnorm+0x3a8>
    5cb8:	400087b7          	lui	a5,0x40008
    5cbc:	fff78793          	addi	a5,a5,-1 # 40007fff <__freertos_irq_stack_top+0x3fff02df>
    5cc0:	00a00713          	li	a4,10
    5cc4:	00f4aa23          	sw	a5,20(s1)
    5cc8:	ffff87b7          	lui	a5,0xffff8
    5ccc:	00e4a423          	sw	a4,8(s1)
    5cd0:	00f49c23          	sh	a5,24(s1)
    5cd4:	00e4a623          	sw	a4,12(s1)
    5cd8:	00a00793          	li	a5,10
    5cdc:	00008737          	lui	a4,0x8
    5ce0:	0600006f          	j	5d40 <emdnorm+0x11c>
    5ce4:	1e095263          	bgez	s2,5ec8 <emdnorm+0x2a4>
    5ce8:	f7000793          	li	a5,-144
    5cec:	1af95a63          	bge	s2,a5,5ea0 <emdnorm+0x27c>
    5cf0:	00240793          	addi	a5,s0,2
    5cf4:	01a40413          	addi	s0,s0,26
    5cf8:	00278793          	addi	a5,a5,2 # ffff8002 <__freertos_irq_stack_top+0xfffe02e2>
    5cfc:	fe079f23          	sh	zero,-2(a5)
    5d00:	fe879ce3          	bne	a5,s0,5cf8 <emdnorm+0xd4>
    5d04:	1380006f          	j	5e3c <emdnorm+0x218>
    5d08:	01800793          	li	a5,24
    5d0c:	26f50463          	beq	a0,a5,5f74 <emdnorm+0x350>
    5d10:	03500793          	li	a5,53
    5d14:	2af51c63          	bne	a0,a5,5fcc <emdnorm+0x3a8>
    5d18:	00001737          	lui	a4,0x1
    5d1c:	040007b7          	lui	a5,0x4000
    5d20:	00600693          	li	a3,6
    5d24:	7ff78793          	addi	a5,a5,2047 # 40007ff <__freertos_irq_stack_top+0x3fe8adf>
    5d28:	80070713          	addi	a4,a4,-2048 # 800 <__stack_size-0x800>
    5d2c:	00f4aa23          	sw	a5,20(s1)
    5d30:	00d4a423          	sw	a3,8(s1)
    5d34:	00e49c23          	sh	a4,24(s1)
    5d38:	00d4a623          	sw	a3,12(s1)
    5d3c:	00600793          	li	a5,6
    5d40:	00878793          	addi	a5,a5,8
    5d44:	00179793          	slli	a5,a5,0x1
    5d48:	00f487b3          	add	a5,s1,a5
    5d4c:	00e79523          	sh	a4,10(a5)
    5d50:	00a4a023          	sw	a0,0(s1)
    5d54:	03204263          	bgtz	s2,5d78 <emdnorm+0x154>
    5d58:	09000793          	li	a5,144
    5d5c:	1ef50863          	beq	a0,a5,5f4c <emdnorm+0x328>
    5d60:	01845783          	lhu	a5,24(s0)
    5d64:	00040513          	mv	a0,s0
    5d68:	0017f793          	andi	a5,a5,1
    5d6c:	00f9e9b3          	or	s3,s3,a5
    5d70:	f4cff0ef          	jal	ra,54bc <eshdn1>
    5d74:	0044a503          	lw	a0,4(s1)
    5d78:	0084a583          	lw	a1,8(s1)
    5d7c:	0144d783          	lhu	a5,20(s1)
    5d80:	08f00813          	li	a6,143
    5d84:	00159613          	slli	a2,a1,0x1
    5d88:	00c40633          	add	a2,s0,a2
    5d8c:	00065703          	lhu	a4,0(a2)
    5d90:	00f776b3          	and	a3,a4,a5
    5d94:	02a84a63          	blt	a6,a0,5dc8 <emdnorm+0x1a4>
    5d98:	00b00813          	li	a6,11
    5d9c:	02b84663          	blt	a6,a1,5dc8 <emdnorm+0x1a4>
    5da0:	00060713          	mv	a4,a2
    5da4:	01840593          	addi	a1,s0,24
    5da8:	00275783          	lhu	a5,2(a4)
    5dac:	00078463          	beqz	a5,5db4 <emdnorm+0x190>
    5db0:	0016e693          	ori	a3,a3,1
    5db4:	00071123          	sh	zero,2(a4)
    5db8:	00270713          	addi	a4,a4,2
    5dbc:	fee596e3          	bne	a1,a4,5da8 <emdnorm+0x184>
    5dc0:	00065703          	lhu	a4,0(a2)
    5dc4:	0144d783          	lhu	a5,20(s1)
    5dc8:	fff7c793          	not	a5,a5
    5dcc:	00e7f7b3          	and	a5,a5,a4
    5dd0:	00f61023          	sh	a5,0(a2)
    5dd4:	0164d783          	lhu	a5,22(s1)
    5dd8:	00d7f733          	and	a4,a5,a3
    5ddc:	04070063          	beqz	a4,5e1c <emdnorm+0x1f8>
    5de0:	12d78263          	beq	a5,a3,5f04 <emdnorm+0x2e0>
    5de4:	03248613          	addi	a2,s1,50
    5de8:	01840713          	addi	a4,s0,24
    5dec:	01c48493          	addi	s1,s1,28
    5df0:	00000693          	li	a3,0
    5df4:	00065783          	lhu	a5,0(a2)
    5df8:	00075583          	lhu	a1,0(a4)
    5dfc:	ffe70713          	addi	a4,a4,-2
    5e00:	ffe60613          	addi	a2,a2,-2
    5e04:	00b787b3          	add	a5,a5,a1
    5e08:	00d787b3          	add	a5,a5,a3
    5e0c:	00f71123          	sh	a5,2(a4)
    5e10:	0107d793          	srli	a5,a5,0x10
    5e14:	0017f693          	andi	a3,a5,1
    5e18:	fc961ee3          	bne	a2,s1,5df4 <emdnorm+0x1d0>
    5e1c:	11205663          	blez	s2,5f28 <emdnorm+0x304>
    5e20:	00445783          	lhu	a5,4(s0)
    5e24:	0a079c63          	bnez	a5,5edc <emdnorm+0x2b8>
    5e28:	000087b7          	lui	a5,0x8
    5e2c:	00041c23          	sh	zero,24(s0)
    5e30:	ffe78793          	addi	a5,a5,-2 # 7ffe <localeconv+0x6>
    5e34:	0327c863          	blt	a5,s2,5e64 <emdnorm+0x240>
    5e38:	01241123          	sh	s2,2(s0)
    5e3c:	01c12083          	lw	ra,28(sp)
    5e40:	01812403          	lw	s0,24(sp)
    5e44:	01412483          	lw	s1,20(sp)
    5e48:	01012903          	lw	s2,16(sp)
    5e4c:	00c12983          	lw	s3,12(sp)
    5e50:	00812a03          	lw	s4,8(sp)
    5e54:	00412a83          	lw	s5,4(sp)
    5e58:	02010113          	addi	sp,sp,32
    5e5c:	00008067          	ret
    5e60:	00041c23          	sh	zero,24(s0)
    5e64:	ffff87b7          	lui	a5,0xffff8
    5e68:	fff7c793          	not	a5,a5
    5e6c:	00f41123          	sh	a5,2(s0)
    5e70:	00440793          	addi	a5,s0,4
    5e74:	01840413          	addi	s0,s0,24
    5e78:	00079023          	sh	zero,0(a5) # ffff8000 <__freertos_irq_stack_top+0xfffe02e0>
    5e7c:	00278793          	addi	a5,a5,2
    5e80:	fef41ce3          	bne	s0,a5,5e78 <emdnorm+0x254>
    5e84:	fb9ff06f          	j	5e3c <emdnorm+0x218>
    5e88:	00240793          	addi	a5,s0,2
    5e8c:	01a40413          	addi	s0,s0,26
    5e90:	00278793          	addi	a5,a5,2
    5e94:	fe079f23          	sh	zero,-2(a5)
    5e98:	fe879ce3          	bne	a5,s0,5e90 <emdnorm+0x26c>
    5e9c:	fa1ff06f          	j	5e3c <emdnorm+0x218>
    5ea0:	00090593          	mv	a1,s2
    5ea4:	00040513          	mv	a0,s0
    5ea8:	a55ff0ef          	jal	ra,58fc <eshift.part.3>
    5eac:	00050463          	beqz	a0,5eb4 <emdnorm+0x290>
    5eb0:	00100993          	li	s3,1
    5eb4:	0a0a8a63          	beqz	s5,5f68 <emdnorm+0x344>
    5eb8:	0044a503          	lw	a0,4(s1)
    5ebc:	0004a783          	lw	a5,0(s1)
    5ec0:	dca794e3          	bne	a5,a0,5c88 <emdnorm+0x64>
    5ec4:	e95ff06f          	j	5d58 <emdnorm+0x134>
    5ec8:	f60a80e3          	beqz	s5,5e28 <emdnorm+0x204>
    5ecc:	0044a503          	lw	a0,4(s1)
    5ed0:	0004a783          	lw	a5,0(s1)
    5ed4:	daf51ae3          	bne	a0,a5,5c88 <emdnorm+0x64>
    5ed8:	e7dff06f          	j	5d54 <emdnorm+0x130>
    5edc:	00040513          	mv	a0,s0
    5ee0:	ddcff0ef          	jal	ra,54bc <eshdn1>
    5ee4:	000087b7          	lui	a5,0x8
    5ee8:	00190913          	addi	s2,s2,1
    5eec:	00041c23          	sh	zero,24(s0)
    5ef0:	ffe78793          	addi	a5,a5,-2 # 7ffe <localeconv+0x6>
    5ef4:	f727c8e3          	blt	a5,s2,5e64 <emdnorm+0x240>
    5ef8:	f40950e3          	bgez	s2,5e38 <emdnorm+0x214>
    5efc:	00041123          	sh	zero,2(s0)
    5f00:	f3dff06f          	j	5e3c <emdnorm+0x218>
    5f04:	0e099a63          	bnez	s3,5ff8 <emdnorm+0x3d4>
    5f08:	00c4a783          	lw	a5,12(s1)
    5f0c:	0184d703          	lhu	a4,24(s1)
    5f10:	00179793          	slli	a5,a5,0x1
    5f14:	00f407b3          	add	a5,s0,a5
    5f18:	0007d783          	lhu	a5,0(a5)
    5f1c:	00e7f7b3          	and	a5,a5,a4
    5f20:	ec0792e3          	bnez	a5,5de4 <emdnorm+0x1c0>
    5f24:	ef204ee3          	bgtz	s2,5e20 <emdnorm+0x1fc>
    5f28:	09000793          	li	a5,144
    5f2c:	00f50663          	beq	a0,a5,5f38 <emdnorm+0x314>
    5f30:	00040513          	mv	a0,s0
    5f34:	df0ff0ef          	jal	ra,5524 <eshup1>
    5f38:	00445783          	lhu	a5,4(s0)
    5f3c:	fa0790e3          	bnez	a5,5edc <emdnorm+0x2b8>
    5f40:	00041c23          	sh	zero,24(s0)
    5f44:	fa094ce3          	bltz	s2,5efc <emdnorm+0x2d8>
    5f48:	ef1ff06f          	j	5e38 <emdnorm+0x214>
    5f4c:	0084a603          	lw	a2,8(s1)
    5f50:	0144d783          	lhu	a5,20(s1)
    5f54:	00161613          	slli	a2,a2,0x1
    5f58:	00c40633          	add	a2,s0,a2
    5f5c:	00065703          	lhu	a4,0(a2)
    5f60:	00e7f6b3          	and	a3,a5,a4
    5f64:	e65ff06f          	j	5dc8 <emdnorm+0x1a4>
    5f68:	00041c23          	sh	zero,24(s0)
    5f6c:	00041123          	sh	zero,2(s0)
    5f70:	ecdff06f          	j	5e3c <emdnorm+0x218>
    5f74:	008007b7          	lui	a5,0x800
    5f78:	0ff78793          	addi	a5,a5,255 # 8000ff <__freertos_irq_stack_top+0x7e83df>
    5f7c:	00400713          	li	a4,4
    5f80:	00f4aa23          	sw	a5,20(s1)
    5f84:	10000793          	li	a5,256
    5f88:	00e4a423          	sw	a4,8(s1)
    5f8c:	00f49c23          	sh	a5,24(s1)
    5f90:	00e4a623          	sw	a4,12(s1)
    5f94:	00400793          	li	a5,4
    5f98:	10000713          	li	a4,256
    5f9c:	da5ff06f          	j	5d40 <emdnorm+0x11c>
    5fa0:	00700793          	li	a5,7
    5fa4:	00f4a423          	sw	a5,8(s1)
    5fa8:	800107b7          	lui	a5,0x80010
    5fac:	fff78793          	addi	a5,a5,-1 # 8000ffff <__freertos_irq_stack_top+0x7fff82df>
    5fb0:	00f4aa23          	sw	a5,20(s1)
    5fb4:	00100793          	li	a5,1
    5fb8:	00f49c23          	sh	a5,24(s1)
    5fbc:	00600793          	li	a5,6
    5fc0:	00f4a623          	sw	a5,12(s1)
    5fc4:	00100713          	li	a4,1
    5fc8:	d79ff06f          	j	5d40 <emdnorm+0x11c>
    5fcc:	00c00793          	li	a5,12
    5fd0:	00f4a423          	sw	a5,8(s1)
    5fd4:	800107b7          	lui	a5,0x80010
    5fd8:	fff78793          	addi	a5,a5,-1 # 8000ffff <__freertos_irq_stack_top+0x7fff82df>
    5fdc:	00f4aa23          	sw	a5,20(s1)
    5fe0:	00100793          	li	a5,1
    5fe4:	00f49c23          	sh	a5,24(s1)
    5fe8:	00b00793          	li	a5,11
    5fec:	00f4a623          	sw	a5,12(s1)
    5ff0:	00100713          	li	a4,1
    5ff4:	d4dff06f          	j	5d40 <emdnorm+0x11c>
    5ff8:	de0a06e3          	beqz	s4,5de4 <emdnorm+0x1c0>
    5ffc:	e21ff06f          	j	5e1c <emdnorm+0x1f8>
    6000:	008007b7          	lui	a5,0x800
    6004:	0ff78793          	addi	a5,a5,255 # 8000ff <__freertos_irq_stack_top+0x7e83df>
    6008:	00600713          	li	a4,6
    600c:	00f4aa23          	sw	a5,20(s1)
    6010:	10000793          	li	a5,256
    6014:	00e4a423          	sw	a4,8(s1)
    6018:	00f49c23          	sh	a5,24(s1)
    601c:	00e4a623          	sw	a4,12(s1)
    6020:	00600793          	li	a5,6
    6024:	10000713          	li	a4,256
    6028:	d19ff06f          	j	5d40 <emdnorm+0x11c>

0000602c <eiremain>:
    602c:	fd010113          	addi	sp,sp,-48
    6030:	01312e23          	sw	s3,28(sp)
    6034:	00255983          	lhu	s3,2(a0)
    6038:	02912223          	sw	s1,36(sp)
    603c:	00058493          	mv	s1,a1
    6040:	02112623          	sw	ra,44(sp)
    6044:	02812423          	sw	s0,40(sp)
    6048:	03212023          	sw	s2,32(sp)
    604c:	01412c23          	sw	s4,24(sp)
    6050:	00060913          	mv	s2,a2
    6054:	01512a23          	sw	s5,20(sp)
    6058:	01612823          	sw	s6,16(sp)
    605c:	01712623          	sw	s7,12(sp)
    6060:	01812423          	sw	s8,8(sp)
    6064:	01912223          	sw	s9,4(sp)
    6068:	01a12023          	sw	s10,0(sp)
    606c:	00050a13          	mv	s4,a0
    6070:	a39ff0ef          	jal	ra,5aa8 <enormlz>
    6074:	0024d403          	lhu	s0,2(s1)
    6078:	40a989b3          	sub	s3,s3,a0
    607c:	00048513          	mv	a0,s1
    6080:	a29ff0ef          	jal	ra,5aa8 <enormlz>
    6084:	03490a93          	addi	s5,s2,52
    6088:	40a40433          	sub	s0,s0,a0
    608c:	04e90713          	addi	a4,s2,78
    6090:	000a8793          	mv	a5,s5
    6094:	00278793          	addi	a5,a5,2
    6098:	fe079f23          	sh	zero,-2(a5)
    609c:	fee79ce3          	bne	a5,a4,6094 <eiremain+0x68>
    60a0:	09344a63          	blt	s0,s3,6134 <eiremain+0x108>
    60a4:	004a0b93          	addi	s7,s4,4
    60a8:	00448b13          	addi	s6,s1,4
    60ac:	fff98993          	addi	s3,s3,-1
    60b0:	01aa0c93          	addi	s9,s4,26
    60b4:	00248c13          	addi	s8,s1,2
    60b8:	000b0713          	mv	a4,s6
    60bc:	000b8793          	mv	a5,s7
    60c0:	00278793          	addi	a5,a5,2
    60c4:	00270713          	addi	a4,a4,2
    60c8:	ffe7d603          	lhu	a2,-2(a5)
    60cc:	ffe75683          	lhu	a3,-2(a4)
    60d0:	0ad61a63          	bne	a2,a3,6184 <eiremain+0x158>
    60d4:	ff9796e3          	bne	a5,s9,60c0 <eiremain+0x94>
    60d8:	018a0693          	addi	a3,s4,24
    60dc:	01848713          	addi	a4,s1,24
    60e0:	00000613          	li	a2,0
    60e4:	00075783          	lhu	a5,0(a4)
    60e8:	0006d583          	lhu	a1,0(a3)
    60ec:	ffe70713          	addi	a4,a4,-2
    60f0:	40c787b3          	sub	a5,a5,a2
    60f4:	40b787b3          	sub	a5,a5,a1
    60f8:	00f71123          	sh	a5,2(a4)
    60fc:	0107d793          	srli	a5,a5,0x10
    6100:	ffe68693          	addi	a3,a3,-2
    6104:	0017f613          	andi	a2,a5,1
    6108:	fcec1ee3          	bne	s8,a4,60e4 <eiremain+0xb8>
    610c:	00100d13          	li	s10,1
    6110:	000a8513          	mv	a0,s5
    6114:	c10ff0ef          	jal	ra,5524 <eshup1>
    6118:	04c95783          	lhu	a5,76(s2)
    611c:	fff40413          	addi	s0,s0,-1
    6120:	00048513          	mv	a0,s1
    6124:	00fd6d33          	or	s10,s10,a5
    6128:	05a91623          	sh	s10,76(s2)
    612c:	bf8ff0ef          	jal	ra,5524 <eshup1>
    6130:	f93414e3          	bne	s0,s3,60b8 <eiremain+0x8c>
    6134:	00040693          	mv	a3,s0
    6138:	02812403          	lw	s0,40(sp)
    613c:	02c12083          	lw	ra,44(sp)
    6140:	01c12983          	lw	s3,28(sp)
    6144:	01812a03          	lw	s4,24(sp)
    6148:	01412a83          	lw	s5,20(sp)
    614c:	01012b03          	lw	s6,16(sp)
    6150:	00c12b83          	lw	s7,12(sp)
    6154:	00812c03          	lw	s8,8(sp)
    6158:	00412c83          	lw	s9,4(sp)
    615c:	00012d03          	lw	s10,0(sp)
    6160:	00090793          	mv	a5,s2
    6164:	00048513          	mv	a0,s1
    6168:	02012903          	lw	s2,32(sp)
    616c:	02412483          	lw	s1,36(sp)
    6170:	00000713          	li	a4,0
    6174:	00000613          	li	a2,0
    6178:	00000593          	li	a1,0
    617c:	03010113          	addi	sp,sp,48
    6180:	aa5ff06f          	j	5c24 <emdnorm>
    6184:	00000d13          	li	s10,0
    6188:	f8c6e4e3          	bltu	a3,a2,6110 <eiremain+0xe4>
    618c:	f4dff06f          	j	60d8 <eiremain+0xac>

00006190 <emovo.isra.6>:
    6190:	00055703          	lhu	a4,0(a0)
    6194:	00255783          	lhu	a5,2(a0)
    6198:	00070663          	beqz	a4,61a4 <emovo.isra.6+0x14>
    619c:	00008737          	lui	a4,0x8
    61a0:	00e7e7b3          	or	a5,a5,a4
    61a4:	00f59923          	sh	a5,18(a1)
    61a8:	00255703          	lhu	a4,2(a0)
    61ac:	000087b7          	lui	a5,0x8
    61b0:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    61b4:	02f70463          	beq	a4,a5,61dc <emovo.isra.6+0x4c>
    61b8:	00650793          	addi	a5,a0,6
    61bc:	01058593          	addi	a1,a1,16
    61c0:	01850513          	addi	a0,a0,24
    61c4:	00278793          	addi	a5,a5,2
    61c8:	ffe7d703          	lhu	a4,-2(a5)
    61cc:	ffe58593          	addi	a1,a1,-2
    61d0:	00e59123          	sh	a4,2(a1)
    61d4:	fea798e3          	bne	a5,a0,61c4 <emovo.isra.6+0x34>
    61d8:	00008067          	ret
    61dc:	00650793          	addi	a5,a0,6
    61e0:	01a50513          	addi	a0,a0,26
    61e4:	0007d703          	lhu	a4,0(a5)
    61e8:	00278793          	addi	a5,a5,2
    61ec:	02071a63          	bnez	a4,6220 <emovo.isra.6+0x90>
    61f0:	fea79ae3          	bne	a5,a0,61e4 <emovo.isra.6+0x54>
    61f4:	01258713          	addi	a4,a1,18
    61f8:	00058793          	mv	a5,a1
    61fc:	00278793          	addi	a5,a5,2
    6200:	fe079f23          	sh	zero,-2(a5)
    6204:	fef71ce3          	bne	a4,a5,61fc <emovo.isra.6+0x6c>
    6208:	0125d783          	lhu	a5,18(a1)
    620c:	00008737          	lui	a4,0x8
    6210:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
    6214:	00e7e7b3          	or	a5,a5,a4
    6218:	00f59923          	sh	a5,18(a1)
    621c:	00008067          	ret
    6220:	01058713          	addi	a4,a1,16
    6224:	00058793          	mv	a5,a1
    6228:	00278793          	addi	a5,a5,2
    622c:	fe079f23          	sh	zero,-2(a5)
    6230:	fef71ce3          	bne	a4,a5,6228 <emovo.isra.6+0x98>
    6234:	7fffc7b7          	lui	a5,0x7fffc
    6238:	00f5a823          	sw	a5,16(a1)
    623c:	00008067          	ret

00006240 <emul>:
    6240:	f7010113          	addi	sp,sp,-144
    6244:	07512a23          	sw	s5,116(sp)
    6248:	01255a83          	lhu	s5,18(a0)
    624c:	000087b7          	lui	a5,0x8
    6250:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    6254:	08812423          	sw	s0,136(sp)
    6258:	08912223          	sw	s1,132(sp)
    625c:	09212023          	sw	s2,128(sp)
    6260:	07312e23          	sw	s3,124(sp)
    6264:	07612823          	sw	s6,112(sp)
    6268:	08112623          	sw	ra,140(sp)
    626c:	07412c23          	sw	s4,120(sp)
    6270:	07712623          	sw	s7,108(sp)
    6274:	07812423          	sw	s8,104(sp)
    6278:	07912223          	sw	s9,100(sp)
    627c:	0157fb33          	and	s6,a5,s5
    6280:	00050493          	mv	s1,a0
    6284:	00058913          	mv	s2,a1
    6288:	00060413          	mv	s0,a2
    628c:	00068993          	mv	s3,a3
    6290:	0afb1863          	bne	s6,a5,6340 <emul+0x100>
    6294:	b98ff0ef          	jal	ra,562c <eisnan.part.0>
    6298:	20051c63          	bnez	a0,64b0 <emul+0x270>
    629c:	01295a03          	lhu	s4,18(s2)
    62a0:	014b77b3          	and	a5,s6,s4
    62a4:	23679463          	bne	a5,s6,64cc <emul+0x28c>
    62a8:	00090513          	mv	a0,s2
    62ac:	b80ff0ef          	jal	ra,562c <eisnan.part.0>
    62b0:	0a051463          	bnez	a0,6358 <emul+0x118>
    62b4:	00048513          	mv	a0,s1
    62b8:	e28ff0ef          	jal	ra,58e0 <eisinf.part.1>
    62bc:	20051e63          	bnez	a0,64d8 <emul+0x298>
    62c0:	000087b7          	lui	a5,0x8
    62c4:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    62c8:	0147fa33          	and	s4,a5,s4
    62cc:	010a1a13          	slli	s4,s4,0x10
    62d0:	010a5a13          	srli	s4,s4,0x10
    62d4:	2cfa1663          	bne	s4,a5,65a0 <emul+0x360>
    62d8:	00090513          	mv	a0,s2
    62dc:	e04ff0ef          	jal	ra,58e0 <eisinf.part.1>
    62e0:	32051263          	bnez	a0,6604 <emul+0x3c4>
    62e4:	0124d783          	lhu	a5,18(s1)
    62e8:	00fa77b3          	and	a5,s4,a5
    62ec:	21478463          	beq	a5,s4,64f4 <emul+0x2b4>
    62f0:	00048513          	mv	a0,s1
    62f4:	00c10593          	addi	a1,sp,12
    62f8:	be4ff0ef          	jal	ra,56dc <emovi>
    62fc:	00090513          	mv	a0,s2
    6300:	02810593          	addi	a1,sp,40
    6304:	bd8ff0ef          	jal	ra,56dc <emovi>
    6308:	00e15483          	lhu	s1,14(sp)
    630c:	02a15903          	lhu	s2,42(sp)
    6310:	08049a63          	bnez	s1,63a4 <emul+0x164>
    6314:	01010793          	addi	a5,sp,16
    6318:	02410693          	addi	a3,sp,36
    631c:	2cd78063          	beq	a5,a3,65dc <emul+0x39c>
    6320:	00278793          	addi	a5,a5,2
    6324:	ffe7d703          	lhu	a4,-2(a5)
    6328:	fe070ae3          	beqz	a4,631c <emul+0xdc>
    632c:	00c10513          	addi	a0,sp,12
    6330:	f78ff0ef          	jal	ra,5aa8 <enormlz>
    6334:	40a004b3          	neg	s1,a0
    6338:	02a15703          	lhu	a4,42(sp)
    633c:	06c0006f          	j	63a8 <emul+0x168>
    6340:	0125da03          	lhu	s4,18(a1)
    6344:	0147f733          	and	a4,a5,s4
    6348:	faf714e3          	bne	a4,a5,62f0 <emul+0xb0>
    634c:	00058513          	mv	a0,a1
    6350:	adcff0ef          	jal	ra,562c <eisnan.part.0>
    6354:	f60506e3          	beqz	a0,62c0 <emul+0x80>
    6358:	01490713          	addi	a4,s2,20
    635c:	00290913          	addi	s2,s2,2
    6360:	ffe95783          	lhu	a5,-2(s2)
    6364:	00240413          	addi	s0,s0,2
    6368:	fef41f23          	sh	a5,-2(s0)
    636c:	fee918e3          	bne	s2,a4,635c <emul+0x11c>
    6370:	08c12083          	lw	ra,140(sp)
    6374:	08812403          	lw	s0,136(sp)
    6378:	08412483          	lw	s1,132(sp)
    637c:	08012903          	lw	s2,128(sp)
    6380:	07c12983          	lw	s3,124(sp)
    6384:	07812a03          	lw	s4,120(sp)
    6388:	07412a83          	lw	s5,116(sp)
    638c:	07012b03          	lw	s6,112(sp)
    6390:	06c12b83          	lw	s7,108(sp)
    6394:	06812c03          	lw	s8,104(sp)
    6398:	06412c83          	lw	s9,100(sp)
    639c:	09010113          	addi	sp,sp,144
    63a0:	00008067          	ret
    63a4:	00090713          	mv	a4,s2
    63a8:	00090b13          	mv	s6,s2
    63ac:	02c10793          	addi	a5,sp,44
    63b0:	04010693          	addi	a3,sp,64
    63b4:	02071263          	bnez	a4,63d8 <emul+0x198>
    63b8:	22f68c63          	beq	a3,a5,65f0 <emul+0x3b0>
    63bc:	00278793          	addi	a5,a5,2
    63c0:	ffe7d703          	lhu	a4,-2(a5)
    63c4:	fe070ae3          	beqz	a4,63b8 <emul+0x178>
    63c8:	02810513          	addi	a0,sp,40
    63cc:	edcff0ef          	jal	ra,5aa8 <enormlz>
    63d0:	02a15703          	lhu	a4,42(sp)
    63d4:	40a90b33          	sub	s6,s2,a0
    63d8:	02815783          	lhu	a5,40(sp)
    63dc:	03898a93          	addi	s5,s3,56
    63e0:	02e99b23          	sh	a4,54(s3)
    63e4:	02f99a23          	sh	a5,52(s3)
    63e8:	04e98713          	addi	a4,s3,78
    63ec:	000a8793          	mv	a5,s5
    63f0:	00079023          	sh	zero,0(a5)
    63f4:	00278793          	addi	a5,a5,2
    63f8:	fef71ce3          	bne	a4,a5,63f0 <emul+0x1b0>
    63fc:	04c98b93          	addi	s7,s3,76
    6400:	00000a13          	li	s4,0
    6404:	02410913          	addi	s2,sp,36
    6408:	01010c93          	addi	s9,sp,16
    640c:	04610c13          	addi	s8,sp,70
    6410:	00095503          	lhu	a0,0(s2)
    6414:	ffe90913          	addi	s2,s2,-2
    6418:	14051263          	bnez	a0,655c <emul+0x31c>
    641c:	04c9d703          	lhu	a4,76(s3)
    6420:	000b8793          	mv	a5,s7
    6424:	00ea6a33          	or	s4,s4,a4
    6428:	ffe78793          	addi	a5,a5,-2
    642c:	0007d703          	lhu	a4,0(a5)
    6430:	00e79123          	sh	a4,2(a5)
    6434:	ff579ae3          	bne	a5,s5,6428 <emul+0x1e8>
    6438:	02099c23          	sh	zero,56(s3)
    643c:	fd991ae3          	bne	s2,s9,6410 <emul+0x1d0>
    6440:	03498713          	addi	a4,s3,52
    6444:	02810793          	addi	a5,sp,40
    6448:	04210693          	addi	a3,sp,66
    644c:	00075603          	lhu	a2,0(a4)
    6450:	00278793          	addi	a5,a5,2
    6454:	00270713          	addi	a4,a4,2
    6458:	fec79f23          	sh	a2,-2(a5)
    645c:	fef698e3          	bne	a3,a5,644c <emul+0x20c>
    6460:	ffffc6b7          	lui	a3,0xffffc
    6464:	016484b3          	add	s1,s1,s6
    6468:	00268693          	addi	a3,a3,2 # ffffc002 <__freertos_irq_stack_top+0xfffe42e2>
    646c:	000a0593          	mv	a1,s4
    6470:	02810513          	addi	a0,sp,40
    6474:	00098793          	mv	a5,s3
    6478:	04000713          	li	a4,64
    647c:	00d486b3          	add	a3,s1,a3
    6480:	00000613          	li	a2,0
    6484:	fa0ff0ef          	jal	ra,5c24 <emdnorm>
    6488:	02815703          	lhu	a4,40(sp)
    648c:	00c15783          	lhu	a5,12(sp)
    6490:	00040593          	mv	a1,s0
    6494:	02810513          	addi	a0,sp,40
    6498:	40e787b3          	sub	a5,a5,a4
    649c:	00f037b3          	snez	a5,a5
    64a0:	40f007b3          	neg	a5,a5
    64a4:	02f11423          	sh	a5,40(sp)
    64a8:	ce9ff0ef          	jal	ra,6190 <emovo.isra.6>
    64ac:	ec5ff06f          	j	6370 <emul+0x130>
    64b0:	01448713          	addi	a4,s1,20
    64b4:	00248493          	addi	s1,s1,2
    64b8:	ffe4d783          	lhu	a5,-2(s1)
    64bc:	00240413          	addi	s0,s0,2
    64c0:	fef41f23          	sh	a5,-2(s0)
    64c4:	fee498e3          	bne	s1,a4,64b4 <emul+0x274>
    64c8:	ea9ff06f          	j	6370 <emul+0x130>
    64cc:	00048513          	mv	a0,s1
    64d0:	c10ff0ef          	jal	ra,58e0 <eisinf.part.1>
    64d4:	0c050863          	beqz	a0,65a4 <emul+0x364>
    64d8:	0000f597          	auipc	a1,0xf
    64dc:	57c58593          	addi	a1,a1,1404 # 15a54 <ezero>
    64e0:	00090513          	mv	a0,s2
    64e4:	ae0ff0ef          	jal	ra,57c4 <ecmp>
    64e8:	14050063          	beqz	a0,6628 <emul+0x3e8>
    64ec:	01295a03          	lhu	s4,18(s2)
    64f0:	dd1ff06f          	j	62c0 <emul+0x80>
    64f4:	00048513          	mv	a0,s1
    64f8:	be8ff0ef          	jal	ra,58e0 <eisinf.part.1>
    64fc:	00051863          	bnez	a0,650c <emul+0x2cc>
    6500:	00090513          	mv	a0,s2
    6504:	bdcff0ef          	jal	ra,58e0 <eisinf.part.1>
    6508:	de0504e3          	beqz	a0,62f0 <emul+0xb0>
    650c:	00048513          	mv	a0,s1
    6510:	98cff0ef          	jal	ra,569c <eisneg>
    6514:	00050493          	mv	s1,a0
    6518:	00090513          	mv	a0,s2
    651c:	980ff0ef          	jal	ra,569c <eisneg>
    6520:	40a48533          	sub	a0,s1,a0
    6524:	00a03533          	snez	a0,a0
    6528:	00f51513          	slli	a0,a0,0xf
    652c:	00a41923          	sh	a0,18(s0)
    6530:	01240713          	addi	a4,s0,18
    6534:	00040793          	mv	a5,s0
    6538:	00278793          	addi	a5,a5,2
    653c:	fe079f23          	sh	zero,-2(a5)
    6540:	fee79ce3          	bne	a5,a4,6538 <emul+0x2f8>
    6544:	01245783          	lhu	a5,18(s0)
    6548:	00008737          	lui	a4,0x8
    654c:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
    6550:	00e7e7b3          	or	a5,a5,a4
    6554:	00f41923          	sh	a5,18(s0)
    6558:	e19ff06f          	j	6370 <emul+0x130>
    655c:	04410613          	addi	a2,sp,68
    6560:	02810593          	addi	a1,sp,40
    6564:	830ff0ef          	jal	ra,5594 <m16m>
    6568:	000b8613          	mv	a2,s7
    656c:	00000593          	li	a1,0
    6570:	05c10713          	addi	a4,sp,92
    6574:	00065503          	lhu	a0,0(a2)
    6578:	00075783          	lhu	a5,0(a4)
    657c:	ffe60613          	addi	a2,a2,-2
    6580:	ffe70713          	addi	a4,a4,-2
    6584:	00a787b3          	add	a5,a5,a0
    6588:	00b787b3          	add	a5,a5,a1
    658c:	00f61123          	sh	a5,2(a2)
    6590:	0107d793          	srli	a5,a5,0x10
    6594:	0017f593          	andi	a1,a5,1
    6598:	fd871ee3          	bne	a4,s8,6574 <emul+0x334>
    659c:	e81ff06f          	j	641c <emul+0x1dc>
    65a0:	0124da83          	lhu	s5,18(s1)
    65a4:	000087b7          	lui	a5,0x8
    65a8:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    65ac:	0157fab3          	and	s5,a5,s5
    65b0:	010a9a93          	slli	s5,s5,0x10
    65b4:	010ada93          	srli	s5,s5,0x10
    65b8:	d2fa9ce3          	bne	s5,a5,62f0 <emul+0xb0>
    65bc:	00048513          	mv	a0,s1
    65c0:	b20ff0ef          	jal	ra,58e0 <eisinf.part.1>
    65c4:	f40514e3          	bnez	a0,650c <emul+0x2cc>
    65c8:	01295783          	lhu	a5,18(s2)
    65cc:	fff7c793          	not	a5,a5
    65d0:	01179713          	slli	a4,a5,0x11
    65d4:	d0071ee3          	bnez	a4,62f0 <emul+0xb0>
    65d8:	f29ff06f          	j	6500 <emul+0x2c0>
    65dc:	01440793          	addi	a5,s0,20
    65e0:	00240413          	addi	s0,s0,2
    65e4:	fe041f23          	sh	zero,-2(s0)
    65e8:	fe879ce3          	bne	a5,s0,65e0 <emul+0x3a0>
    65ec:	d85ff06f          	j	6370 <emul+0x130>
    65f0:	01440793          	addi	a5,s0,20
    65f4:	00240413          	addi	s0,s0,2
    65f8:	fe041f23          	sh	zero,-2(s0)
    65fc:	fef41ce3          	bne	s0,a5,65f4 <emul+0x3b4>
    6600:	d71ff06f          	j	6370 <emul+0x130>
    6604:	0000f597          	auipc	a1,0xf
    6608:	45058593          	addi	a1,a1,1104 # 15a54 <ezero>
    660c:	00048513          	mv	a0,s1
    6610:	9b4ff0ef          	jal	ra,57c4 <ecmp>
    6614:	00050a63          	beqz	a0,6628 <emul+0x3e8>
    6618:	0124d783          	lhu	a5,18(s1)
    661c:	00fa77b3          	and	a5,s4,a5
    6620:	f9478ee3          	beq	a5,s4,65bc <emul+0x37c>
    6624:	fa5ff06f          	j	65c8 <emul+0x388>
    6628:	01040713          	addi	a4,s0,16
    662c:	00040793          	mv	a5,s0
    6630:	00278793          	addi	a5,a5,2
    6634:	fe079f23          	sh	zero,-2(a5)
    6638:	fee79ce3          	bne	a5,a4,6630 <emul+0x3f0>
    663c:	7fffc7b7          	lui	a5,0x7fffc
    6640:	00f42823          	sw	a5,16(s0)
    6644:	d2dff06f          	j	6370 <emul+0x130>

00006648 <ediv>:
    6648:	01255783          	lhu	a5,18(a0)
    664c:	f5010113          	addi	sp,sp,-176
    6650:	0a812423          	sw	s0,168(sp)
    6654:	fff7c793          	not	a5,a5
    6658:	0a912223          	sw	s1,164(sp)
    665c:	0b212023          	sw	s2,160(sp)
    6660:	09612823          	sw	s6,144(sp)
    6664:	0a112623          	sw	ra,172(sp)
    6668:	09312e23          	sw	s3,156(sp)
    666c:	09412c23          	sw	s4,152(sp)
    6670:	09512a23          	sw	s5,148(sp)
    6674:	09712623          	sw	s7,140(sp)
    6678:	09812423          	sw	s8,136(sp)
    667c:	09912223          	sw	s9,132(sp)
    6680:	09a12023          	sw	s10,128(sp)
    6684:	07b12e23          	sw	s11,124(sp)
    6688:	01179713          	slli	a4,a5,0x11
    668c:	00050493          	mv	s1,a0
    6690:	00058913          	mv	s2,a1
    6694:	00060413          	mv	s0,a2
    6698:	00068b13          	mv	s6,a3
    669c:	00071663          	bnez	a4,66a8 <ediv+0x60>
    66a0:	f8dfe0ef          	jal	ra,562c <eisnan.part.0>
    66a4:	38051063          	bnez	a0,6a24 <ediv+0x3dc>
    66a8:	01295783          	lhu	a5,18(s2)
    66ac:	fff7c793          	not	a5,a5
    66b0:	01179713          	slli	a4,a5,0x11
    66b4:	08070e63          	beqz	a4,6750 <ediv+0x108>
    66b8:	0000f597          	auipc	a1,0xf
    66bc:	39c58593          	addi	a1,a1,924 # 15a54 <ezero>
    66c0:	00048513          	mv	a0,s1
    66c4:	900ff0ef          	jal	ra,57c4 <ecmp>
    66c8:	10050463          	beqz	a0,67d0 <ediv+0x188>
    66cc:	0124d983          	lhu	s3,18(s1)
    66d0:	01295703          	lhu	a4,18(s2)
    66d4:	000087b7          	lui	a5,0x8
    66d8:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    66dc:	0137f9b3          	and	s3,a5,s3
    66e0:	00e7fa33          	and	s4,a5,a4
    66e4:	08f99a63          	bne	s3,a5,6778 <ediv+0x130>
    66e8:	00048513          	mv	a0,s1
    66ec:	9f4ff0ef          	jal	ra,58e0 <eisinf.part.1>
    66f0:	10050a63          	beqz	a0,6804 <ediv+0x1bc>
    66f4:	013a1863          	bne	s4,s3,6704 <ediv+0xbc>
    66f8:	00090513          	mv	a0,s2
    66fc:	9e4ff0ef          	jal	ra,58e0 <eisinf.part.1>
    6700:	0e051263          	bnez	a0,67e4 <ediv+0x19c>
    6704:	01440793          	addi	a5,s0,20
    6708:	00240413          	addi	s0,s0,2
    670c:	fe041f23          	sh	zero,-2(s0)
    6710:	fef41ce3          	bne	s0,a5,6708 <ediv+0xc0>
    6714:	0ac12083          	lw	ra,172(sp)
    6718:	0a812403          	lw	s0,168(sp)
    671c:	0a412483          	lw	s1,164(sp)
    6720:	0a012903          	lw	s2,160(sp)
    6724:	09c12983          	lw	s3,156(sp)
    6728:	09812a03          	lw	s4,152(sp)
    672c:	09412a83          	lw	s5,148(sp)
    6730:	09012b03          	lw	s6,144(sp)
    6734:	08c12b83          	lw	s7,140(sp)
    6738:	08812c03          	lw	s8,136(sp)
    673c:	08412c83          	lw	s9,132(sp)
    6740:	08012d03          	lw	s10,128(sp)
    6744:	07c12d83          	lw	s11,124(sp)
    6748:	0b010113          	addi	sp,sp,176
    674c:	00008067          	ret
    6750:	00090513          	mv	a0,s2
    6754:	ed9fe0ef          	jal	ra,562c <eisnan.part.0>
    6758:	f60500e3          	beqz	a0,66b8 <ediv+0x70>
    675c:	01490713          	addi	a4,s2,20
    6760:	00290913          	addi	s2,s2,2
    6764:	ffe95783          	lhu	a5,-2(s2)
    6768:	00240413          	addi	s0,s0,2
    676c:	fef41f23          	sh	a5,-2(s0)
    6770:	fee918e3          	bne	s2,a4,6760 <ediv+0x118>
    6774:	fa1ff06f          	j	6714 <ediv+0xcc>
    6778:	08fa0863          	beq	s4,a5,6808 <ediv+0x1c0>
    677c:	00048513          	mv	a0,s1
    6780:	01c10593          	addi	a1,sp,28
    6784:	f59fe0ef          	jal	ra,56dc <emovi>
    6788:	03810593          	addi	a1,sp,56
    678c:	00090513          	mv	a0,s2
    6790:	f4dfe0ef          	jal	ra,56dc <emovi>
    6794:	03a15b83          	lhu	s7,58(sp)
    6798:	01e15483          	lhu	s1,30(sp)
    679c:	0c0b9463          	bnez	s7,6864 <ediv+0x21c>
    67a0:	03c10793          	addi	a5,sp,60
    67a4:	05010b93          	addi	s7,sp,80
    67a8:	34fb8663          	beq	s7,a5,6af4 <ediv+0x4ac>
    67ac:	00278793          	addi	a5,a5,2
    67b0:	ffe7d683          	lhu	a3,-2(a5)
    67b4:	fe068ae3          	beqz	a3,67a8 <ediv+0x160>
    67b8:	03810513          	addi	a0,sp,56
    67bc:	aecff0ef          	jal	ra,5aa8 <enormlz>
    67c0:	40a007b3          	neg	a5,a0
    67c4:	00f12623          	sw	a5,12(sp)
    67c8:	01e15603          	lhu	a2,30(sp)
    67cc:	0a00006f          	j	686c <ediv+0x224>
    67d0:	0000f597          	auipc	a1,0xf
    67d4:	28458593          	addi	a1,a1,644 # 15a54 <ezero>
    67d8:	00090513          	mv	a0,s2
    67dc:	fe9fe0ef          	jal	ra,57c4 <ecmp>
    67e0:	ee0516e3          	bnez	a0,66cc <ediv+0x84>
    67e4:	01040713          	addi	a4,s0,16
    67e8:	00040793          	mv	a5,s0
    67ec:	00278793          	addi	a5,a5,2
    67f0:	fe079f23          	sh	zero,-2(a5)
    67f4:	fee79ce3          	bne	a5,a4,67ec <ediv+0x1a4>
    67f8:	7fffc7b7          	lui	a5,0x7fffc
    67fc:	00f42823          	sw	a5,16(s0)
    6800:	f15ff06f          	j	6714 <ediv+0xcc>
    6804:	f73a1ce3          	bne	s4,s3,677c <ediv+0x134>
    6808:	00090513          	mv	a0,s2
    680c:	8d4ff0ef          	jal	ra,58e0 <eisinf.part.1>
    6810:	f60506e3          	beqz	a0,677c <ediv+0x134>
    6814:	00048513          	mv	a0,s1
    6818:	e85fe0ef          	jal	ra,569c <eisneg>
    681c:	00050493          	mv	s1,a0
    6820:	00090513          	mv	a0,s2
    6824:	e79fe0ef          	jal	ra,569c <eisneg>
    6828:	40a487b3          	sub	a5,s1,a0
    682c:	00f037b3          	snez	a5,a5
    6830:	00f79793          	slli	a5,a5,0xf
    6834:	00f41923          	sh	a5,18(s0)
    6838:	01240713          	addi	a4,s0,18
    683c:	00040793          	mv	a5,s0
    6840:	00278793          	addi	a5,a5,2 # 7fffc002 <__freertos_irq_stack_top+0x7ffe42e2>
    6844:	fe079f23          	sh	zero,-2(a5)
    6848:	fee79ce3          	bne	a5,a4,6840 <ediv+0x1f8>
    684c:	01245783          	lhu	a5,18(s0)
    6850:	00008737          	lui	a4,0x8
    6854:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
    6858:	00e7e7b3          	or	a5,a5,a4
    685c:	00f41923          	sh	a5,18(s0)
    6860:	eb5ff06f          	j	6714 <ediv+0xcc>
    6864:	01712623          	sw	s7,12(sp)
    6868:	00048613          	mv	a2,s1
    686c:	00912423          	sw	s1,8(sp)
    6870:	02010793          	addi	a5,sp,32
    6874:	03410693          	addi	a3,sp,52
    6878:	02061263          	bnez	a2,689c <ediv+0x254>
    687c:	28f68663          	beq	a3,a5,6b08 <ediv+0x4c0>
    6880:	00278793          	addi	a5,a5,2
    6884:	ffe7d703          	lhu	a4,-2(a5)
    6888:	fe070ae3          	beqz	a4,687c <ediv+0x234>
    688c:	01c10513          	addi	a0,sp,28
    6890:	a18ff0ef          	jal	ra,5aa8 <enormlz>
    6894:	40a487b3          	sub	a5,s1,a0
    6898:	00f12423          	sw	a5,8(sp)
    689c:	03812703          	lw	a4,56(sp)
    68a0:	038b0d13          	addi	s10,s6,56
    68a4:	000d0793          	mv	a5,s10
    68a8:	02eb2a23          	sw	a4,52(s6)
    68ac:	04eb0493          	addi	s1,s6,78
    68b0:	00278793          	addi	a5,a5,2
    68b4:	fe079f23          	sh	zero,-2(a5)
    68b8:	fef49ce3          	bne	s1,a5,68b0 <ediv+0x268>
    68bc:	03810513          	addi	a0,sp,56
    68c0:	bfdfe0ef          	jal	ra,54bc <eshdn1>
    68c4:	02215c03          	lhu	s8,34(sp)
    68c8:	000109b7          	lui	s3,0x10
    68cc:	05010b93          	addi	s7,sp,80
    68d0:	010c1a13          	slli	s4,s8,0x10
    68d4:	418a0a33          	sub	s4,s4,s8
    68d8:	03a10a93          	addi	s5,sp,58
    68dc:	fff98993          	addi	s3,s3,-1 # ffff <_svfiprintf_r+0xce7>
    68e0:	06e10c93          	addi	s9,sp,110
    68e4:	05610913          	addi	s2,sp,86
    68e8:	03c15503          	lhu	a0,60(sp)
    68ec:	03e15783          	lhu	a5,62(sp)
    68f0:	00098d93          	mv	s11,s3
    68f4:	01051513          	slli	a0,a0,0x10
    68f8:	00f50533          	add	a0,a0,a5
    68fc:	00aa6863          	bltu	s4,a0,690c <ediv+0x2c4>
    6900:	03855533          	divu	a0,a0,s8
    6904:	01051d93          	slli	s11,a0,0x10
    6908:	010ddd93          	srli	s11,s11,0x10
    690c:	05410613          	addi	a2,sp,84
    6910:	01c10593          	addi	a1,sp,28
    6914:	000d8513          	mv	a0,s11
    6918:	c7dfe0ef          	jal	ra,5594 <m16m>
    691c:	03c10613          	addi	a2,sp,60
    6920:	05810793          	addi	a5,sp,88
    6924:	00278793          	addi	a5,a5,2
    6928:	00260613          	addi	a2,a2,2
    692c:	ffe7d503          	lhu	a0,-2(a5)
    6930:	ffe65583          	lhu	a1,-2(a2)
    6934:	10b51663          	bne	a0,a1,6a40 <ediv+0x3f8>
    6938:	ff9796e3          	bne	a5,s9,6924 <ediv+0x2dc>
    693c:	00000513          	li	a0,0
    6940:	06c10593          	addi	a1,sp,108
    6944:	000b8613          	mv	a2,s7
    6948:	00065783          	lhu	a5,0(a2)
    694c:	0005d803          	lhu	a6,0(a1)
    6950:	ffe60613          	addi	a2,a2,-2
    6954:	40a787b3          	sub	a5,a5,a0
    6958:	410787b3          	sub	a5,a5,a6
    695c:	00f61123          	sh	a5,2(a2)
    6960:	0107d793          	srli	a5,a5,0x10
    6964:	ffe58593          	addi	a1,a1,-2
    6968:	0017f513          	andi	a0,a5,1
    696c:	fd561ee3          	bne	a2,s5,6948 <ediv+0x300>
    6970:	01bd1023          	sh	s11,0(s10)
    6974:	03c10793          	addi	a5,sp,60
    6978:	00278793          	addi	a5,a5,2
    697c:	0007d603          	lhu	a2,0(a5)
    6980:	fec79f23          	sh	a2,-2(a5)
    6984:	ff779ae3          	bne	a5,s7,6978 <ediv+0x330>
    6988:	04011823          	sh	zero,80(sp)
    698c:	002d0d13          	addi	s10,s10,2
    6990:	f5a49ce3          	bne	s1,s10,68e8 <ediv+0x2a0>
    6994:	00000593          	li	a1,0
    6998:	03c10793          	addi	a5,sp,60
    699c:	05210693          	addi	a3,sp,82
    69a0:	00278793          	addi	a5,a5,2
    69a4:	ffe7d703          	lhu	a4,-2(a5)
    69a8:	00e5e5b3          	or	a1,a1,a4
    69ac:	fed79ae3          	bne	a5,a3,69a0 <ediv+0x358>
    69b0:	00b035b3          	snez	a1,a1
    69b4:	034b0713          	addi	a4,s6,52
    69b8:	03810793          	addi	a5,sp,56
    69bc:	00075603          	lhu	a2,0(a4)
    69c0:	00278793          	addi	a5,a5,2
    69c4:	00270713          	addi	a4,a4,2
    69c8:	fec79f23          	sh	a2,-2(a5)
    69cc:	fef698e3          	bne	a3,a5,69bc <ediv+0x374>
    69d0:	00c12783          	lw	a5,12(sp)
    69d4:	00812703          	lw	a4,8(sp)
    69d8:	000046b7          	lui	a3,0x4
    69dc:	fff68693          	addi	a3,a3,-1 # 3fff <_vfprintf_r+0x2afb>
    69e0:	40e78bb3          	sub	s7,a5,a4
    69e4:	03810513          	addi	a0,sp,56
    69e8:	000b0793          	mv	a5,s6
    69ec:	04000713          	li	a4,64
    69f0:	00db86b3          	add	a3,s7,a3
    69f4:	00000613          	li	a2,0
    69f8:	a2cff0ef          	jal	ra,5c24 <emdnorm>
    69fc:	03815703          	lhu	a4,56(sp)
    6a00:	01c15783          	lhu	a5,28(sp)
    6a04:	00040593          	mv	a1,s0
    6a08:	03810513          	addi	a0,sp,56
    6a0c:	40e787b3          	sub	a5,a5,a4
    6a10:	00f037b3          	snez	a5,a5
    6a14:	40f007b3          	neg	a5,a5
    6a18:	02f11c23          	sh	a5,56(sp)
    6a1c:	f74ff0ef          	jal	ra,6190 <emovo.isra.6>
    6a20:	cf5ff06f          	j	6714 <ediv+0xcc>
    6a24:	01448713          	addi	a4,s1,20
    6a28:	00248493          	addi	s1,s1,2
    6a2c:	ffe4d783          	lhu	a5,-2(s1)
    6a30:	00240413          	addi	s0,s0,2
    6a34:	fef41f23          	sh	a5,-2(s0)
    6a38:	fee498e3          	bne	s1,a4,6a28 <ediv+0x3e0>
    6a3c:	cd9ff06f          	j	6714 <ediv+0xcc>
    6a40:	eea5fee3          	bgeu	a1,a0,693c <ediv+0x2f4>
    6a44:	fffd8793          	addi	a5,s11,-1 # 3ffdffff <__freertos_irq_stack_top+0x3ffc82df>
    6a48:	01079893          	slli	a7,a5,0x10
    6a4c:	0108d893          	srli	a7,a7,0x10
    6a50:	00000513          	li	a0,0
    6a54:	03410593          	addi	a1,sp,52
    6a58:	06c10613          	addi	a2,sp,108
    6a5c:	00065783          	lhu	a5,0(a2)
    6a60:	0005d803          	lhu	a6,0(a1)
    6a64:	ffe60613          	addi	a2,a2,-2
    6a68:	40a787b3          	sub	a5,a5,a0
    6a6c:	410787b3          	sub	a5,a5,a6
    6a70:	00f61123          	sh	a5,2(a2)
    6a74:	0107d793          	srli	a5,a5,0x10
    6a78:	ffe58593          	addi	a1,a1,-2
    6a7c:	0017f513          	andi	a0,a5,1
    6a80:	fd261ee3          	bne	a2,s2,6a5c <ediv+0x414>
    6a84:	03c10613          	addi	a2,sp,60
    6a88:	05810793          	addi	a5,sp,88
    6a8c:	00278793          	addi	a5,a5,2
    6a90:	00260613          	addi	a2,a2,2
    6a94:	ffe7d503          	lhu	a0,-2(a5)
    6a98:	ffe65583          	lhu	a1,-2(a2)
    6a9c:	00b51863          	bne	a0,a1,6aac <ediv+0x464>
    6aa0:	ff9796e3          	bne	a5,s9,6a8c <ediv+0x444>
    6aa4:	00088d93          	mv	s11,a7
    6aa8:	e95ff06f          	j	693c <ediv+0x2f4>
    6aac:	fea5fce3          	bgeu	a1,a0,6aa4 <ediv+0x45c>
    6ab0:	ffed8d93          	addi	s11,s11,-2
    6ab4:	010d9d93          	slli	s11,s11,0x10
    6ab8:	010ddd93          	srli	s11,s11,0x10
    6abc:	00000513          	li	a0,0
    6ac0:	03410593          	addi	a1,sp,52
    6ac4:	06c10613          	addi	a2,sp,108
    6ac8:	00065783          	lhu	a5,0(a2)
    6acc:	0005d803          	lhu	a6,0(a1)
    6ad0:	ffe60613          	addi	a2,a2,-2
    6ad4:	40a787b3          	sub	a5,a5,a0
    6ad8:	410787b3          	sub	a5,a5,a6
    6adc:	00f61123          	sh	a5,2(a2)
    6ae0:	0107d793          	srli	a5,a5,0x10
    6ae4:	ffe58593          	addi	a1,a1,-2
    6ae8:	0017f513          	andi	a0,a5,1
    6aec:	fd261ee3          	bne	a2,s2,6ac8 <ediv+0x480>
    6af0:	e4dff06f          	j	693c <ediv+0x2f4>
    6af4:	01440793          	addi	a5,s0,20
    6af8:	00240413          	addi	s0,s0,2
    6afc:	fe041f23          	sh	zero,-2(s0)
    6b00:	fe879ce3          	bne	a5,s0,6af8 <ediv+0x4b0>
    6b04:	c11ff06f          	j	6714 <ediv+0xcc>
    6b08:	01c15703          	lhu	a4,28(sp)
    6b0c:	03815783          	lhu	a5,56(sp)
    6b10:	00f70463          	beq	a4,a5,6b18 <ediv+0x4d0>
    6b14:	00008637          	lui	a2,0x8
    6b18:	00c41923          	sh	a2,18(s0)
    6b1c:	01240713          	addi	a4,s0,18
    6b20:	00040793          	mv	a5,s0
    6b24:	00278793          	addi	a5,a5,2
    6b28:	fe079f23          	sh	zero,-2(a5)
    6b2c:	fef71ce3          	bne	a4,a5,6b24 <ediv+0x4dc>
    6b30:	01245783          	lhu	a5,18(s0)
    6b34:	00008737          	lui	a4,0x8
    6b38:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
    6b3c:	00e7e7b3          	or	a5,a5,a4
    6b40:	00f41923          	sh	a5,18(s0)
    6b44:	bd1ff06f          	j	6714 <ediv+0xcc>

00006b48 <e113toe.isra.8>:
    6b48:	fd010113          	addi	sp,sp,-48
    6b4c:	02812423          	sw	s0,40(sp)
    6b50:	02112623          	sw	ra,44(sp)
    6b54:	00058413          	mv	s0,a1
    6b58:	00410793          	addi	a5,sp,4
    6b5c:	01e10713          	addi	a4,sp,30
    6b60:	00278793          	addi	a5,a5,2
    6b64:	fe079f23          	sh	zero,-2(a5)
    6b68:	fee79ce3          	bne	a5,a4,6b60 <e113toe.isra.8+0x18>
    6b6c:	00e55603          	lhu	a2,14(a0)
    6b70:	01061793          	slli	a5,a2,0x10
    6b74:	4107d793          	srai	a5,a5,0x10
    6b78:	0607ca63          	bltz	a5,6bec <e113toe.isra.8+0xa4>
    6b7c:	000087b7          	lui	a5,0x8
    6b80:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    6b84:	00011223          	sh	zero,4(sp)
    6b88:	00f67633          	and	a2,a2,a5
    6b8c:	06f60c63          	beq	a2,a5,6c04 <e113toe.isra.8+0xbc>
    6b90:	00e50793          	addi	a5,a0,14
    6b94:	00c11323          	sh	a2,6(sp)
    6b98:	00a10713          	addi	a4,sp,10
    6b9c:	ffe78793          	addi	a5,a5,-2
    6ba0:	0007d683          	lhu	a3,0(a5)
    6ba4:	00270713          	addi	a4,a4,2
    6ba8:	fed71f23          	sh	a3,-2(a4)
    6bac:	fef518e3          	bne	a0,a5,6b9c <e113toe.isra.8+0x54>
    6bb0:	02061263          	bnez	a2,6bd4 <e113toe.isra.8+0x8c>
    6bb4:	00011423          	sh	zero,8(sp)
    6bb8:	00040593          	mv	a1,s0
    6bbc:	00410513          	addi	a0,sp,4
    6bc0:	dd0ff0ef          	jal	ra,6190 <emovo.isra.6>
    6bc4:	02c12083          	lw	ra,44(sp)
    6bc8:	02812403          	lw	s0,40(sp)
    6bcc:	03010113          	addi	sp,sp,48
    6bd0:	00008067          	ret
    6bd4:	00100793          	li	a5,1
    6bd8:	fff00593          	li	a1,-1
    6bdc:	00410513          	addi	a0,sp,4
    6be0:	00f11423          	sh	a5,8(sp)
    6be4:	d19fe0ef          	jal	ra,58fc <eshift.part.3>
    6be8:	fd1ff06f          	j	6bb8 <e113toe.isra.8+0x70>
    6bec:	fff00793          	li	a5,-1
    6bf0:	00f11223          	sh	a5,4(sp)
    6bf4:	000087b7          	lui	a5,0x8
    6bf8:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    6bfc:	00f67633          	and	a2,a2,a5
    6c00:	f8f618e3          	bne	a2,a5,6b90 <e113toe.isra.8+0x48>
    6c04:	00050793          	mv	a5,a0
    6c08:	00e50693          	addi	a3,a0,14
    6c0c:	0007d703          	lhu	a4,0(a5)
    6c10:	00278793          	addi	a5,a5,2
    6c14:	04071c63          	bnez	a4,6c6c <e113toe.isra.8+0x124>
    6c18:	fef69ae3          	bne	a3,a5,6c0c <e113toe.isra.8+0xc4>
    6c1c:	01440713          	addi	a4,s0,20
    6c20:	00040793          	mv	a5,s0
    6c24:	00278793          	addi	a5,a5,2
    6c28:	fe079f23          	sh	zero,-2(a5)
    6c2c:	fee79ce3          	bne	a5,a4,6c24 <e113toe.isra.8+0xdc>
    6c30:	01240713          	addi	a4,s0,18
    6c34:	00040793          	mv	a5,s0
    6c38:	00278793          	addi	a5,a5,2
    6c3c:	fe079f23          	sh	zero,-2(a5)
    6c40:	fee79ce3          	bne	a5,a4,6c38 <e113toe.isra.8+0xf0>
    6c44:	01245783          	lhu	a5,18(s0)
    6c48:	00008737          	lui	a4,0x8
    6c4c:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
    6c50:	00e7e7b3          	or	a5,a5,a4
    6c54:	00f41923          	sh	a5,18(s0)
    6c58:	00e51783          	lh	a5,14(a0)
    6c5c:	f607d4e3          	bgez	a5,6bc4 <e113toe.isra.8+0x7c>
    6c60:	00040513          	mv	a0,s0
    6c64:	9edfe0ef          	jal	ra,5650 <eneg>
    6c68:	f5dff06f          	j	6bc4 <e113toe.isra.8+0x7c>
    6c6c:	01040713          	addi	a4,s0,16
    6c70:	00040793          	mv	a5,s0
    6c74:	00278793          	addi	a5,a5,2
    6c78:	fe079f23          	sh	zero,-2(a5)
    6c7c:	fee79ce3          	bne	a5,a4,6c74 <e113toe.isra.8+0x12c>
    6c80:	7fffc7b7          	lui	a5,0x7fffc
    6c84:	00f42823          	sw	a5,16(s0)
    6c88:	f3dff06f          	j	6bc4 <e113toe.isra.8+0x7c>

00006c8c <_ldtoa_r>:
    6c8c:	0005ae83          	lw	t4,0(a1)
    6c90:	0045ae03          	lw	t3,4(a1)
    6c94:	0085a303          	lw	t1,8(a1)
    6c98:	00c5a583          	lw	a1,12(a1)
    6c9c:	e1010113          	addi	sp,sp,-496
    6ca0:	04052883          	lw	a7,64(a0)
    6ca4:	02b12e23          	sw	a1,60(sp)
    6ca8:	fff00593          	li	a1,-1
    6cac:	16b12023          	sw	a1,352(sp)
    6cb0:	09000593          	li	a1,144
    6cb4:	1e812423          	sw	s0,488(sp)
    6cb8:	1d612823          	sw	s6,464(sp)
    6cbc:	1e112623          	sw	ra,492(sp)
    6cc0:	1e912223          	sw	s1,484(sp)
    6cc4:	1f212023          	sw	s2,480(sp)
    6cc8:	1d312e23          	sw	s3,476(sp)
    6ccc:	1d412c23          	sw	s4,472(sp)
    6cd0:	1d512a23          	sw	s5,468(sp)
    6cd4:	1d712623          	sw	s7,460(sp)
    6cd8:	1d812423          	sw	s8,456(sp)
    6cdc:	1d912223          	sw	s9,452(sp)
    6ce0:	1da12023          	sw	s10,448(sp)
    6ce4:	1bb12e23          	sw	s11,444(sp)
    6ce8:	03d12823          	sw	t4,48(sp)
    6cec:	03c12a23          	sw	t3,52(sp)
    6cf0:	02612c23          	sw	t1,56(sp)
    6cf4:	16b12223          	sw	a1,356(sp)
    6cf8:	00c12423          	sw	a2,8(sp)
    6cfc:	00d12823          	sw	a3,16(sp)
    6d00:	00e12a23          	sw	a4,20(sp)
    6d04:	03012023          	sw	a6,32(sp)
    6d08:	00050b13          	mv	s6,a0
    6d0c:	00078413          	mv	s0,a5
    6d10:	02088263          	beqz	a7,6d34 <_ldtoa_r+0xa8>
    6d14:	04452703          	lw	a4,68(a0)
    6d18:	00100793          	li	a5,1
    6d1c:	00088593          	mv	a1,a7
    6d20:	00e797b3          	sll	a5,a5,a4
    6d24:	00e8a223          	sw	a4,4(a7)
    6d28:	00f8a423          	sw	a5,8(a7)
    6d2c:	288020ef          	jal	ra,8fb4 <_Bfree>
    6d30:	040b2023          	sw	zero,64(s6)
    6d34:	06010a13          	addi	s4,sp,96
    6d38:	000a0593          	mv	a1,s4
    6d3c:	03010513          	addi	a0,sp,48
    6d40:	e09ff0ef          	jal	ra,6b48 <e113toe.isra.8>
    6d44:	000a0513          	mv	a0,s4
    6d48:	955fe0ef          	jal	ra,569c <eisneg>
    6d4c:	00812703          	lw	a4,8(sp)
    6d50:	00a03533          	snez	a0,a0
    6d54:	00a42023          	sw	a0,0(s0)
    6d58:	00300793          	li	a5,3
    6d5c:	1af704e3          	beq	a4,a5,7704 <_ldtoa_r+0xa78>
    6d60:	01400793          	li	a5,20
    6d64:	00f12623          	sw	a5,12(sp)
    6d68:	600710e3          	bnez	a4,7b68 <_ldtoa_r+0xedc>
    6d6c:	07215783          	lhu	a5,114(sp)
    6d70:	16412703          	lw	a4,356(sp)
    6d74:	fff7c793          	not	a5,a5
    6d78:	00e12e23          	sw	a4,28(sp)
    6d7c:	01179713          	slli	a4,a5,0x11
    6d80:	00071863          	bnez	a4,6d90 <_ldtoa_r+0x104>
    6d84:	000a0513          	mv	a0,s4
    6d88:	8a5fe0ef          	jal	ra,562c <eisnan.part.0>
    6d8c:	420514e3          	bnez	a0,79b4 <_ldtoa_r+0xd28>
    6d90:	09000793          	li	a5,144
    6d94:	16f12223          	sw	a5,356(sp)
    6d98:	07c10713          	addi	a4,sp,124
    6d9c:	000a0793          	mv	a5,s4
    6da0:	07410613          	addi	a2,sp,116
    6da4:	00278793          	addi	a5,a5,2 # 7fffc002 <__freertos_irq_stack_top+0x7ffe42e2>
    6da8:	ffe7d683          	lhu	a3,-2(a5)
    6dac:	00270713          	addi	a4,a4,2
    6db0:	fed71f23          	sh	a3,-2(a4)
    6db4:	fec798e3          	bne	a5,a2,6da4 <_ldtoa_r+0x118>
    6db8:	08e15603          	lhu	a2,142(sp)
    6dbc:	00012c23          	sw	zero,24(sp)
    6dc0:	01061793          	slli	a5,a2,0x10
    6dc4:	4107d793          	srai	a5,a5,0x10
    6dc8:	0007de63          	bgez	a5,6de4 <_ldtoa_r+0x158>
    6dcc:	01161613          	slli	a2,a2,0x11
    6dd0:	000107b7          	lui	a5,0x10
    6dd4:	01165613          	srli	a2,a2,0x11
    6dd8:	fff78793          	addi	a5,a5,-1 # ffff <_svfiprintf_r+0xce7>
    6ddc:	08c11723          	sh	a2,142(sp)
    6de0:	00f12c23          	sw	a5,24(sp)
    6de4:	00000693          	li	a3,0
    6de8:	09810793          	addi	a5,sp,152
    6dec:	0000f717          	auipc	a4,0xf
    6df0:	b5070713          	addi	a4,a4,-1200 # 1593c <eone>
    6df4:	0ac10d93          	addi	s11,sp,172
    6df8:	0080006f          	j	6e00 <_ldtoa_r+0x174>
    6dfc:	00075683          	lhu	a3,0(a4)
    6e00:	00278793          	addi	a5,a5,2
    6e04:	fed79f23          	sh	a3,-2(a5)
    6e08:	00270713          	addi	a4,a4,2
    6e0c:	ffb798e3          	bne	a5,s11,6dfc <_ldtoa_r+0x170>
    6e10:	16060663          	beqz	a2,6f7c <_ldtoa_r+0x2f0>
    6e14:	000087b7          	lui	a5,0x8
    6e18:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    6e1c:	58f602e3          	beq	a2,a5,7ba0 <_ldtoa_r+0xf14>
    6e20:	08c11783          	lh	a5,140(sp)
    6e24:	6007d4e3          	bgez	a5,7c2c <_ldtoa_r+0xfa0>
    6e28:	07c10593          	addi	a1,sp,124
    6e2c:	0000f517          	auipc	a0,0xf
    6e30:	b1050513          	addi	a0,a0,-1264 # 1593c <eone>
    6e34:	991fe0ef          	jal	ra,57c4 <ecmp>
    6e38:	14050e63          	beqz	a0,6f94 <_ldtoa_r+0x308>
    6e3c:	0e054ae3          	bltz	a0,7730 <_ldtoa_r+0xaa4>
    6e40:	08e15783          	lhu	a5,142(sp)
    6e44:	680790e3          	bnez	a5,7cc4 <_ldtoa_r+0x1038>
    6e48:	08c11783          	lh	a5,140(sp)
    6e4c:	00000493          	li	s1,0
    6e50:	16010993          	addi	s3,sp,352
    6e54:	0207c663          	bltz	a5,6e80 <_ldtoa_r+0x1f4>
    6e58:	0000f417          	auipc	s0,0xf
    6e5c:	be840413          	addi	s0,s0,-1048 # 15a40 <etens+0xf0>
    6e60:	07c10613          	addi	a2,sp,124
    6e64:	00098693          	mv	a3,s3
    6e68:	00060593          	mv	a1,a2
    6e6c:	00040513          	mv	a0,s0
    6e70:	bd0ff0ef          	jal	ra,6240 <emul>
    6e74:	08c11783          	lh	a5,140(sp)
    6e78:	fff48493          	addi	s1,s1,-1
    6e7c:	fe07d2e3          	bgez	a5,6e60 <_ldtoa_r+0x1d4>
    6e80:	0d010413          	addi	s0,sp,208
    6e84:	0e810b93          	addi	s7,sp,232
    6e88:	00040713          	mv	a4,s0
    6e8c:	07c10793          	addi	a5,sp,124
    6e90:	09010613          	addi	a2,sp,144
    6e94:	00278793          	addi	a5,a5,2
    6e98:	ffe7d683          	lhu	a3,-2(a5)
    6e9c:	00270713          	addi	a4,a4,2
    6ea0:	fed71f23          	sh	a3,-2(a4)
    6ea4:	fec798e3          	bne	a5,a2,6e94 <_ldtoa_r+0x208>
    6ea8:	00000693          	li	a3,0
    6eac:	09810793          	addi	a5,sp,152
    6eb0:	0000f717          	auipc	a4,0xf
    6eb4:	a8c70713          	addi	a4,a4,-1396 # 1593c <eone>
    6eb8:	0080006f          	j	6ec0 <_ldtoa_r+0x234>
    6ebc:	00075683          	lhu	a3,0(a4)
    6ec0:	00278793          	addi	a5,a5,2
    6ec4:	fed79f23          	sh	a3,-2(a5)
    6ec8:	00270713          	addi	a4,a4,2
    6ecc:	ffb798e3          	bne	a5,s11,6ebc <_ldtoa_r+0x230>
    6ed0:	fffff937          	lui	s2,0xfffff
    6ed4:	0000fa97          	auipc	s5,0xf
    6ed8:	a7ca8a93          	addi	s5,s5,-1412 # 15950 <etens>
    6edc:	0000fc97          	auipc	s9,0xf
    6ee0:	95cc8c93          	addi	s9,s9,-1700 # 15838 <emtens>
    6ee4:	0000fd17          	auipc	s10,0xf
    6ee8:	a58d0d13          	addi	s10,s10,-1448 # 1593c <eone>
    6eec:	0000fd97          	auipc	s11,0xf
    6ef0:	b54d8d93          	addi	s11,s11,-1196 # 15a40 <etens+0xf0>
    6ef4:	00c0006f          	j	6f00 <_ldtoa_r+0x274>
    6ef8:	014c8c93          	addi	s9,s9,20
    6efc:	014a8a93          	addi	s5,s5,20
    6f00:	00040593          	mv	a1,s0
    6f04:	000d0513          	mv	a0,s10
    6f08:	8bdfe0ef          	jal	ra,57c4 <ecmp>
    6f0c:	00040593          	mv	a1,s0
    6f10:	04a05663          	blez	a0,6f5c <_ldtoa_r+0x2d0>
    6f14:	000c8513          	mv	a0,s9
    6f18:	8adfe0ef          	jal	ra,57c4 <ecmp>
    6f1c:	00098693          	mv	a3,s3
    6f20:	00040613          	mv	a2,s0
    6f24:	00040593          	mv	a1,s0
    6f28:	02054263          	bltz	a0,6f4c <_ldtoa_r+0x2c0>
    6f2c:	000a8513          	mv	a0,s5
    6f30:	b10ff0ef          	jal	ra,6240 <emul>
    6f34:	09810613          	addi	a2,sp,152
    6f38:	00098693          	mv	a3,s3
    6f3c:	00060593          	mv	a1,a2
    6f40:	000a8513          	mv	a0,s5
    6f44:	afcff0ef          	jal	ra,6240 <emul>
    6f48:	012484b3          	add	s1,s1,s2
    6f4c:	01f95793          	srli	a5,s2,0x1f
    6f50:	01278933          	add	s2,a5,s2
    6f54:	40195913          	srai	s2,s2,0x1
    6f58:	fbba90e3          	bne	s5,s11,6ef8 <_ldtoa_r+0x26c>
    6f5c:	09810613          	addi	a2,sp,152
    6f60:	00098693          	mv	a3,s3
    6f64:	0000f597          	auipc	a1,0xf
    6f68:	9d858593          	addi	a1,a1,-1576 # 1593c <eone>
    6f6c:	00060513          	mv	a0,a2
    6f70:	ed8ff0ef          	jal	ra,6648 <ediv>
    6f74:	12410913          	addi	s2,sp,292
    6f78:	0300006f          	j	6fa8 <_ldtoa_r+0x31c>
    6f7c:	07c10793          	addi	a5,sp,124
    6f80:	08e10693          	addi	a3,sp,142
    6f84:	0007d703          	lhu	a4,0(a5)
    6f88:	00278793          	addi	a5,a5,2
    6f8c:	e8071ee3          	bnez	a4,6e28 <_ldtoa_r+0x19c>
    6f90:	fef69ae3          	bne	a3,a5,6f84 <_ldtoa_r+0x2f8>
    6f94:	00000493          	li	s1,0
    6f98:	12410913          	addi	s2,sp,292
    6f9c:	16010993          	addi	s3,sp,352
    6fa0:	0d010413          	addi	s0,sp,208
    6fa4:	0e810b93          	addi	s7,sp,232
    6fa8:	00040593          	mv	a1,s0
    6fac:	09810513          	addi	a0,sp,152
    6fb0:	f2cfe0ef          	jal	ra,56dc <emovi>
    6fb4:	09810713          	addi	a4,sp,152
    6fb8:	00040793          	mv	a5,s0
    6fbc:	00278793          	addi	a5,a5,2
    6fc0:	ffe7d683          	lhu	a3,-2(a5)
    6fc4:	00270713          	addi	a4,a4,2
    6fc8:	fed71f23          	sh	a3,-2(a4)
    6fcc:	ff7798e3          	bne	a5,s7,6fbc <_ldtoa_r+0x330>
    6fd0:	00040593          	mv	a1,s0
    6fd4:	07c10513          	addi	a0,sp,124
    6fd8:	0a011823          	sh	zero,176(sp)
    6fdc:	f00fe0ef          	jal	ra,56dc <emovi>
    6fe0:	07c10793          	addi	a5,sp,124
    6fe4:	00240413          	addi	s0,s0,2
    6fe8:	ffe45703          	lhu	a4,-2(s0)
    6fec:	00278793          	addi	a5,a5,2
    6ff0:	fee79f23          	sh	a4,-2(a5)
    6ff4:	ff7418e3          	bne	s0,s7,6fe4 <_ldtoa_r+0x358>
    6ff8:	09810513          	addi	a0,sp,152
    6ffc:	00098613          	mv	a2,s3
    7000:	07c10593          	addi	a1,sp,124
    7004:	08011a23          	sh	zero,148(sp)
    7008:	824ff0ef          	jal	ra,602c <eiremain>
    700c:	1ac15503          	lhu	a0,428(sp)
    7010:	1c051863          	bnez	a0,71e0 <_ldtoa_r+0x554>
    7014:	0000fa97          	auipc	s5,0xf
    7018:	a40a8a93          	addi	s5,s5,-1472 # 15a54 <ezero>
    701c:	09410d13          	addi	s10,sp,148
    7020:	07e10413          	addi	s0,sp,126
    7024:	0b610c93          	addi	s9,sp,182
    7028:	000a8593          	mv	a1,s5
    702c:	07c10513          	addi	a0,sp,124
    7030:	f94fe0ef          	jal	ra,57c4 <ecmp>
    7034:	1a050663          	beqz	a0,71e0 <_ldtoa_r+0x554>
    7038:	00000713          	li	a4,0
    703c:	000d0693          	mv	a3,s10
    7040:	01c0006f          	j	705c <_ldtoa_r+0x3d0>
    7044:	00171713          	slli	a4,a4,0x1
    7048:	00f69023          	sh	a5,0(a3)
    704c:	01071713          	slli	a4,a4,0x10
    7050:	ffe68693          	addi	a3,a3,-2
    7054:	01075713          	srli	a4,a4,0x10
    7058:	04868463          	beq	a3,s0,70a0 <_ldtoa_r+0x414>
    705c:	0006d783          	lhu	a5,0(a3)
    7060:	01079613          	slli	a2,a5,0x10
    7064:	41065613          	srai	a2,a2,0x10
    7068:	00179793          	slli	a5,a5,0x1
    706c:	00065463          	bgez	a2,7074 <_ldtoa_r+0x3e8>
    7070:	00176713          	ori	a4,a4,1
    7074:	01079793          	slli	a5,a5,0x10
    7078:	0107d793          	srli	a5,a5,0x10
    707c:	00277613          	andi	a2,a4,2
    7080:	0017e593          	ori	a1,a5,1
    7084:	fc0600e3          	beqz	a2,7044 <_ldtoa_r+0x3b8>
    7088:	00171713          	slli	a4,a4,0x1
    708c:	00b69023          	sh	a1,0(a3)
    7090:	01071713          	slli	a4,a4,0x10
    7094:	ffe68693          	addi	a3,a3,-2
    7098:	01075713          	srli	a4,a4,0x10
    709c:	fc8690e3          	bne	a3,s0,705c <_ldtoa_r+0x3d0>
    70a0:	0b410713          	addi	a4,sp,180
    70a4:	07c10793          	addi	a5,sp,124
    70a8:	00278793          	addi	a5,a5,2
    70ac:	ffe7d683          	lhu	a3,-2(a5)
    70b0:	00270713          	addi	a4,a4,2
    70b4:	fed71f23          	sh	a3,-2(a4)
    70b8:	ffa798e3          	bne	a5,s10,70a8 <_ldtoa_r+0x41c>
    70bc:	0c011623          	sh	zero,204(sp)
    70c0:	00000713          	li	a4,0
    70c4:	0cc10693          	addi	a3,sp,204
    70c8:	01c0006f          	j	70e4 <_ldtoa_r+0x458>
    70cc:	00171713          	slli	a4,a4,0x1
    70d0:	00f69023          	sh	a5,0(a3)
    70d4:	01071713          	slli	a4,a4,0x10
    70d8:	ffe68693          	addi	a3,a3,-2
    70dc:	01075713          	srli	a4,a4,0x10
    70e0:	05968463          	beq	a3,s9,7128 <_ldtoa_r+0x49c>
    70e4:	0006d783          	lhu	a5,0(a3)
    70e8:	01079613          	slli	a2,a5,0x10
    70ec:	41065613          	srai	a2,a2,0x10
    70f0:	00179793          	slli	a5,a5,0x1
    70f4:	00065463          	bgez	a2,70fc <_ldtoa_r+0x470>
    70f8:	00176713          	ori	a4,a4,1
    70fc:	01079793          	slli	a5,a5,0x10
    7100:	0107d793          	srli	a5,a5,0x10
    7104:	00277613          	andi	a2,a4,2
    7108:	0017e593          	ori	a1,a5,1
    710c:	fc0600e3          	beqz	a2,70cc <_ldtoa_r+0x440>
    7110:	00171713          	slli	a4,a4,0x1
    7114:	00b69023          	sh	a1,0(a3)
    7118:	01071713          	slli	a4,a4,0x10
    711c:	ffe68693          	addi	a3,a3,-2
    7120:	01075713          	srli	a4,a4,0x10
    7124:	fd9690e3          	bne	a3,s9,70e4 <_ldtoa_r+0x458>
    7128:	00000713          	li	a4,0
    712c:	0cc10693          	addi	a3,sp,204
    7130:	01c0006f          	j	714c <_ldtoa_r+0x4c0>
    7134:	00171713          	slli	a4,a4,0x1
    7138:	00f69023          	sh	a5,0(a3)
    713c:	01071713          	slli	a4,a4,0x10
    7140:	ffe68693          	addi	a3,a3,-2
    7144:	01075713          	srli	a4,a4,0x10
    7148:	05968463          	beq	a3,s9,7190 <_ldtoa_r+0x504>
    714c:	0006d783          	lhu	a5,0(a3)
    7150:	01079613          	slli	a2,a5,0x10
    7154:	41065613          	srai	a2,a2,0x10
    7158:	00179793          	slli	a5,a5,0x1
    715c:	00065463          	bgez	a2,7164 <_ldtoa_r+0x4d8>
    7160:	00176713          	ori	a4,a4,1
    7164:	01079793          	slli	a5,a5,0x10
    7168:	0107d793          	srli	a5,a5,0x10
    716c:	00277613          	andi	a2,a4,2
    7170:	0017e593          	ori	a1,a5,1
    7174:	fc0600e3          	beqz	a2,7134 <_ldtoa_r+0x4a8>
    7178:	00171713          	slli	a4,a4,0x1
    717c:	00b69023          	sh	a1,0(a3)
    7180:	01071713          	slli	a4,a4,0x10
    7184:	ffe68693          	addi	a3,a3,-2
    7188:	01075713          	srli	a4,a4,0x10
    718c:	fd9690e3          	bne	a3,s9,714c <_ldtoa_r+0x4c0>
    7190:	00000613          	li	a2,0
    7194:	000d0693          	mv	a3,s10
    7198:	0cc10713          	addi	a4,sp,204
    719c:	0006d583          	lhu	a1,0(a3)
    71a0:	00075783          	lhu	a5,0(a4)
    71a4:	ffe68693          	addi	a3,a3,-2
    71a8:	ffe70713          	addi	a4,a4,-2
    71ac:	00b787b3          	add	a5,a5,a1
    71b0:	00c787b3          	add	a5,a5,a2
    71b4:	00f69123          	sh	a5,2(a3)
    71b8:	0107d793          	srli	a5,a5,0x10
    71bc:	0017f613          	andi	a2,a5,1
    71c0:	fd971ee3          	bne	a4,s9,719c <_ldtoa_r+0x510>
    71c4:	09810513          	addi	a0,sp,152
    71c8:	00098613          	mv	a2,s3
    71cc:	07c10593          	addi	a1,sp,124
    71d0:	e5dfe0ef          	jal	ra,602c <eiremain>
    71d4:	1ac15503          	lhu	a0,428(sp)
    71d8:	fff48493          	addi	s1,s1,-1
    71dc:	e40506e3          	beqz	a0,7028 <_ldtoa_r+0x39c>
    71e0:	01812783          	lw	a5,24(sp)
    71e4:	00812703          	lw	a4,8(sp)
    71e8:	00c12403          	lw	s0,12(sp)
    71ec:	00f037b3          	snez	a5,a5
    71f0:	40f007b3          	neg	a5,a5
    71f4:	00d7f793          	andi	a5,a5,13
    71f8:	02078793          	addi	a5,a5,32
    71fc:	12f10223          	sb	a5,292(sp)
    7200:	00300793          	li	a5,3
    7204:	02f70463          	beq	a4,a5,722c <_ldtoa_r+0x5a0>
    7208:	00a00793          	li	a5,10
    720c:	1ef502e3          	beq	a0,a5,7bf0 <_ldtoa_r+0xf64>
    7210:	03050513          	addi	a0,a0,48
    7214:	02e00793          	li	a5,46
    7218:	12a102a3          	sb	a0,293(sp)
    721c:	12f10323          	sb	a5,294(sp)
    7220:	78044263          	bltz	s0,79a4 <_ldtoa_r+0xd18>
    7224:	12710c93          	addi	s9,sp,295
    7228:	0300006f          	j	7258 <_ldtoa_r+0x5cc>
    722c:	00940433          	add	s0,s0,s1
    7230:	02a00793          	li	a5,42
    7234:	fc87dae3          	bge	a5,s0,7208 <_ldtoa_r+0x57c>
    7238:	00a00793          	li	a5,10
    723c:	18f506e3          	beq	a0,a5,7bc8 <_ldtoa_r+0xf3c>
    7240:	03050513          	addi	a0,a0,48
    7244:	02e00793          	li	a5,46
    7248:	12a102a3          	sb	a0,293(sp)
    724c:	12f10323          	sb	a5,294(sp)
    7250:	02a00413          	li	s0,42
    7254:	12710c93          	addi	s9,sp,295
    7258:	00000c13          	li	s8,0
    725c:	0b410a93          	addi	s5,sp,180
    7260:	09410d93          	addi	s11,sp,148
    7264:	07e10b93          	addi	s7,sp,126
    7268:	0b610d13          	addi	s10,sp,182
    726c:	00000713          	li	a4,0
    7270:	000d8693          	mv	a3,s11
    7274:	01c0006f          	j	7290 <_ldtoa_r+0x604>
    7278:	00171713          	slli	a4,a4,0x1
    727c:	00f69023          	sh	a5,0(a3)
    7280:	01071713          	slli	a4,a4,0x10
    7284:	ffe68693          	addi	a3,a3,-2
    7288:	01075713          	srli	a4,a4,0x10
    728c:	05768463          	beq	a3,s7,72d4 <_ldtoa_r+0x648>
    7290:	0006d783          	lhu	a5,0(a3)
    7294:	01079613          	slli	a2,a5,0x10
    7298:	41065613          	srai	a2,a2,0x10
    729c:	00179793          	slli	a5,a5,0x1
    72a0:	00065463          	bgez	a2,72a8 <_ldtoa_r+0x61c>
    72a4:	00176713          	ori	a4,a4,1
    72a8:	01079793          	slli	a5,a5,0x10
    72ac:	0107d793          	srli	a5,a5,0x10
    72b0:	00277613          	andi	a2,a4,2
    72b4:	0017e593          	ori	a1,a5,1
    72b8:	fc0600e3          	beqz	a2,7278 <_ldtoa_r+0x5ec>
    72bc:	00171713          	slli	a4,a4,0x1
    72c0:	00b69023          	sh	a1,0(a3)
    72c4:	01071713          	slli	a4,a4,0x10
    72c8:	ffe68693          	addi	a3,a3,-2
    72cc:	01075713          	srli	a4,a4,0x10
    72d0:	fd7690e3          	bne	a3,s7,7290 <_ldtoa_r+0x604>
    72d4:	000a8713          	mv	a4,s5
    72d8:	07c10793          	addi	a5,sp,124
    72dc:	00278793          	addi	a5,a5,2
    72e0:	ffe7d683          	lhu	a3,-2(a5)
    72e4:	00270713          	addi	a4,a4,2
    72e8:	fed71f23          	sh	a3,-2(a4)
    72ec:	ffb798e3          	bne	a5,s11,72dc <_ldtoa_r+0x650>
    72f0:	0c011623          	sh	zero,204(sp)
    72f4:	00000713          	li	a4,0
    72f8:	0cc10693          	addi	a3,sp,204
    72fc:	01c0006f          	j	7318 <_ldtoa_r+0x68c>
    7300:	00171713          	slli	a4,a4,0x1
    7304:	00f69023          	sh	a5,0(a3)
    7308:	01071713          	slli	a4,a4,0x10
    730c:	ffe68693          	addi	a3,a3,-2
    7310:	01075713          	srli	a4,a4,0x10
    7314:	05a68463          	beq	a3,s10,735c <_ldtoa_r+0x6d0>
    7318:	0006d783          	lhu	a5,0(a3)
    731c:	01079613          	slli	a2,a5,0x10
    7320:	41065613          	srai	a2,a2,0x10
    7324:	00179793          	slli	a5,a5,0x1
    7328:	00065463          	bgez	a2,7330 <_ldtoa_r+0x6a4>
    732c:	00176713          	ori	a4,a4,1
    7330:	01079793          	slli	a5,a5,0x10
    7334:	0107d793          	srli	a5,a5,0x10
    7338:	00277613          	andi	a2,a4,2
    733c:	0017e593          	ori	a1,a5,1
    7340:	fc0600e3          	beqz	a2,7300 <_ldtoa_r+0x674>
    7344:	00171713          	slli	a4,a4,0x1
    7348:	00b69023          	sh	a1,0(a3)
    734c:	01071713          	slli	a4,a4,0x10
    7350:	ffe68693          	addi	a3,a3,-2
    7354:	01075713          	srli	a4,a4,0x10
    7358:	fda690e3          	bne	a3,s10,7318 <_ldtoa_r+0x68c>
    735c:	00000713          	li	a4,0
    7360:	0cc10693          	addi	a3,sp,204
    7364:	01c0006f          	j	7380 <_ldtoa_r+0x6f4>
    7368:	00171713          	slli	a4,a4,0x1
    736c:	00f69023          	sh	a5,0(a3)
    7370:	01071713          	slli	a4,a4,0x10
    7374:	ffe68693          	addi	a3,a3,-2
    7378:	01075713          	srli	a4,a4,0x10
    737c:	05a68463          	beq	a3,s10,73c4 <_ldtoa_r+0x738>
    7380:	0006d783          	lhu	a5,0(a3)
    7384:	01079613          	slli	a2,a5,0x10
    7388:	41065613          	srai	a2,a2,0x10
    738c:	00179793          	slli	a5,a5,0x1
    7390:	00065463          	bgez	a2,7398 <_ldtoa_r+0x70c>
    7394:	00176713          	ori	a4,a4,1
    7398:	01079793          	slli	a5,a5,0x10
    739c:	0107d793          	srli	a5,a5,0x10
    73a0:	00277613          	andi	a2,a4,2
    73a4:	0017e593          	ori	a1,a5,1
    73a8:	fc0600e3          	beqz	a2,7368 <_ldtoa_r+0x6dc>
    73ac:	00171713          	slli	a4,a4,0x1
    73b0:	00b69023          	sh	a1,0(a3)
    73b4:	01071713          	slli	a4,a4,0x10
    73b8:	ffe68693          	addi	a3,a3,-2
    73bc:	01075713          	srli	a4,a4,0x10
    73c0:	fda690e3          	bne	a3,s10,7380 <_ldtoa_r+0x6f4>
    73c4:	00000613          	li	a2,0
    73c8:	000d8693          	mv	a3,s11
    73cc:	0cc10713          	addi	a4,sp,204
    73d0:	0006d583          	lhu	a1,0(a3)
    73d4:	00075783          	lhu	a5,0(a4)
    73d8:	ffe68693          	addi	a3,a3,-2
    73dc:	ffe70713          	addi	a4,a4,-2
    73e0:	00b787b3          	add	a5,a5,a1
    73e4:	00c787b3          	add	a5,a5,a2
    73e8:	00f69123          	sh	a5,2(a3)
    73ec:	0107d793          	srli	a5,a5,0x10
    73f0:	0017f613          	andi	a2,a5,1
    73f4:	fda71ee3          	bne	a4,s10,73d0 <_ldtoa_r+0x744>
    73f8:	00098613          	mv	a2,s3
    73fc:	07c10593          	addi	a1,sp,124
    7400:	09810513          	addi	a0,sp,152
    7404:	c29fe0ef          	jal	ra,602c <eiremain>
    7408:	1ac15783          	lhu	a5,428(sp)
    740c:	018c8733          	add	a4,s9,s8
    7410:	001c0c13          	addi	s8,s8,1
    7414:	03078693          	addi	a3,a5,48
    7418:	00d70023          	sb	a3,0(a4)
    741c:	e58458e3          	bge	s0,s8,726c <_ldtoa_r+0x5e0>
    7420:	00140993          	addi	s3,s0,1
    7424:	013c89b3          	add	s3,s9,s3
    7428:	008c8cb3          	add	s9,s9,s0
    742c:	00400713          	li	a4,4
    7430:	06f75e63          	bge	a4,a5,74ac <_ldtoa_r+0x820>
    7434:	00500713          	li	a4,5
    7438:	00e78ae3          	beq	a5,a4,7c4c <_ldtoa_r+0xfc0>
    743c:	ffe9c783          	lbu	a5,-2(s3)
    7440:	ffe98713          	addi	a4,s3,-2
    7444:	07f7f793          	andi	a5,a5,127
    7448:	7c044a63          	bltz	s0,7c1c <_ldtoa_r+0xf90>
    744c:	02e00693          	li	a3,46
    7450:	04d78263          	beq	a5,a3,7494 <_ldtoa_r+0x808>
    7454:	00178693          	addi	a3,a5,1
    7458:	00d70023          	sb	a3,0(a4)
    745c:	03800693          	li	a3,56
    7460:	03000593          	li	a1,48
    7464:	02e00613          	li	a2,46
    7468:	03800513          	li	a0,56
    746c:	00f6c863          	blt	a3,a5,747c <_ldtoa_r+0x7f0>
    7470:	03c0006f          	j	74ac <_ldtoa_r+0x820>
    7474:	00d70023          	sb	a3,0(a4)
    7478:	02f57a63          	bgeu	a0,a5,74ac <_ldtoa_r+0x820>
    747c:	00b70023          	sb	a1,0(a4)
    7480:	fff70713          	addi	a4,a4,-1
    7484:	00074783          	lbu	a5,0(a4)
    7488:	07f7f793          	andi	a5,a5,127
    748c:	00178693          	addi	a3,a5,1
    7490:	fec792e3          	bne	a5,a2,7474 <_ldtoa_r+0x7e8>
    7494:	fff74783          	lbu	a5,-1(a4)
    7498:	03800693          	li	a3,56
    749c:	00f6fee3          	bgeu	a3,a5,7cb8 <_ldtoa_r+0x102c>
    74a0:	03100793          	li	a5,49
    74a4:	00148493          	addi	s1,s1,1
    74a8:	fef70fa3          	sb	a5,-1(a4)
    74ac:	00048613          	mv	a2,s1
    74b0:	0000e597          	auipc	a1,0xe
    74b4:	36058593          	addi	a1,a1,864 # 15810 <zeroes.4505+0x34>
    74b8:	000c8513          	mv	a0,s9
    74bc:	1a4030ef          	jal	ra,a660 <sprintf>
    74c0:	07215783          	lhu	a5,114(sp)
    74c4:	01c12703          	lw	a4,28(sp)
    74c8:	16912823          	sw	s1,368(sp)
    74cc:	fff7c793          	not	a5,a5
    74d0:	16e12223          	sw	a4,356(sp)
    74d4:	01179713          	slli	a4,a5,0x11
    74d8:	00071e63          	bnez	a4,74f4 <_ldtoa_r+0x868>
    74dc:	000a0513          	mv	a0,s4
    74e0:	c00fe0ef          	jal	ra,58e0 <eisinf.part.1>
    74e4:	22051c63          	bnez	a0,771c <_ldtoa_r+0xa90>
    74e8:	000a0513          	mv	a0,s4
    74ec:	940fe0ef          	jal	ra,562c <eisnan.part.0>
    74f0:	22051663          	bnez	a0,771c <_ldtoa_r+0xa90>
    74f4:	01412683          	lw	a3,20(sp)
    74f8:	12414783          	lbu	a5,292(sp)
    74fc:	00148713          	addi	a4,s1,1
    7500:	00e6a023          	sw	a4,0(a3)
    7504:	0c078ce3          	beqz	a5,7ddc <_ldtoa_r+0x1150>
    7508:	02e00713          	li	a4,46
    750c:	06e78063          	beq	a5,a4,756c <_ldtoa_r+0x8e0>
    7510:	00090793          	mv	a5,s2
    7514:	02e00693          	li	a3,46
    7518:	0080006f          	j	7520 <_ldtoa_r+0x894>
    751c:	04d70a63          	beq	a4,a3,7570 <_ldtoa_r+0x8e4>
    7520:	00178793          	addi	a5,a5,1
    7524:	0007c703          	lbu	a4,0(a5)
    7528:	fe071ae3          	bnez	a4,751c <_ldtoa_r+0x890>
    752c:	04500693          	li	a3,69
    7530:	00f96663          	bltu	s2,a5,753c <_ldtoa_r+0x8b0>
    7534:	0140006f          	j	7548 <_ldtoa_r+0x8bc>
    7538:	01278863          	beq	a5,s2,7548 <_ldtoa_r+0x8bc>
    753c:	fff78793          	addi	a5,a5,-1
    7540:	0007c703          	lbu	a4,0(a5)
    7544:	fed71ae3          	bne	a4,a3,7538 <_ldtoa_r+0x8ac>
    7548:	00078023          	sb	zero,0(a5)
    754c:	00090793          	mv	a5,s2
    7550:	02000693          	li	a3,32
    7554:	02d00613          	li	a2,45
    7558:	0007c703          	lbu	a4,0(a5)
    755c:	00d70463          	beq	a4,a3,7564 <_ldtoa_r+0x8d8>
    7560:	02c71a63          	bne	a4,a2,7594 <_ldtoa_r+0x908>
    7564:	00178793          	addi	a5,a5,1
    7568:	ff1ff06f          	j	7558 <_ldtoa_r+0x8cc>
    756c:	00090793          	mv	a5,s2
    7570:	0017c703          	lbu	a4,1(a5)
    7574:	00178793          	addi	a5,a5,1
    7578:	fee78fa3          	sb	a4,-1(a5)
    757c:	fa0708e3          	beqz	a4,752c <_ldtoa_r+0x8a0>
    7580:	0017c703          	lbu	a4,1(a5)
    7584:	00178793          	addi	a5,a5,1
    7588:	fee78fa3          	sb	a4,-1(a5)
    758c:	fe0712e3          	bnez	a4,7570 <_ldtoa_r+0x8e4>
    7590:	f9dff06f          	j	752c <_ldtoa_r+0x8a0>
    7594:	00090413          	mv	s0,s2
    7598:	00c0006f          	j	75a4 <_ldtoa_r+0x918>
    759c:	0007c703          	lbu	a4,0(a5)
    75a0:	00068413          	mv	s0,a3
    75a4:	00e40023          	sb	a4,0(s0)
    75a8:	00140693          	addi	a3,s0,1
    75ac:	00178793          	addi	a5,a5,1
    75b0:	fe0716e3          	bnez	a4,759c <_ldtoa_r+0x910>
    75b4:	00812683          	lw	a3,8(sp)
    75b8:	00200793          	li	a5,2
    75bc:	fff44703          	lbu	a4,-1(s0)
    75c0:	12f68663          	beq	a3,a5,76ec <_ldtoa_r+0xa60>
    75c4:	00c12783          	lw	a5,12(sp)
    75c8:	00078693          	mv	a3,a5
    75cc:	0097d463          	bge	a5,s1,75d4 <_ldtoa_r+0x948>
    75d0:	00048693          	mv	a3,s1
    75d4:	03000793          	li	a5,48
    75d8:	02f71663          	bne	a4,a5,7604 <_ldtoa_r+0x978>
    75dc:	412407b3          	sub	a5,s0,s2
    75e0:	02f6d263          	bge	a3,a5,7604 <_ldtoa_r+0x978>
    75e4:	03000613          	li	a2,48
    75e8:	0080006f          	j	75f0 <_ldtoa_r+0x964>
    75ec:	00e6dc63          	bge	a3,a4,7604 <_ldtoa_r+0x978>
    75f0:	fff40413          	addi	s0,s0,-1
    75f4:	fff44783          	lbu	a5,-1(s0)
    75f8:	00040023          	sb	zero,0(s0)
    75fc:	41240733          	sub	a4,s0,s2
    7600:	fec786e3          	beq	a5,a2,75ec <_ldtoa_r+0x960>
    7604:	00812703          	lw	a4,8(sp)
    7608:	00300793          	li	a5,3
    760c:	0af70263          	beq	a4,a5,76b0 <_ldtoa_r+0xa24>
    7610:	01012783          	lw	a5,16(sp)
    7614:	040b2223          	sw	zero,68(s6)
    7618:	00978613          	addi	a2,a5,9
    761c:	01700793          	li	a5,23
    7620:	0cc7f263          	bgeu	a5,a2,76e4 <_ldtoa_r+0xa58>
    7624:	00100713          	li	a4,1
    7628:	00400793          	li	a5,4
    762c:	00179793          	slli	a5,a5,0x1
    7630:	01478693          	addi	a3,a5,20
    7634:	00070593          	mv	a1,a4
    7638:	00170713          	addi	a4,a4,1
    763c:	fed678e3          	bgeu	a2,a3,762c <_ldtoa_r+0x9a0>
    7640:	04bb2223          	sw	a1,68(s6)
    7644:	000b0513          	mv	a0,s6
    7648:	0c5010ef          	jal	ra,8f0c <_Balloc>
    764c:	04ab2023          	sw	a0,64(s6)
    7650:	00090593          	mv	a1,s2
    7654:	00050493          	mv	s1,a0
    7658:	a0df90ef          	jal	ra,1064 <strcpy>
    765c:	02012783          	lw	a5,32(sp)
    7660:	00078863          	beqz	a5,7670 <_ldtoa_r+0x9e4>
    7664:	41240433          	sub	s0,s0,s2
    7668:	00848433          	add	s0,s1,s0
    766c:	0087a023          	sw	s0,0(a5)
    7670:	1ec12083          	lw	ra,492(sp)
    7674:	1e812403          	lw	s0,488(sp)
    7678:	00048513          	mv	a0,s1
    767c:	1e012903          	lw	s2,480(sp)
    7680:	1e412483          	lw	s1,484(sp)
    7684:	1dc12983          	lw	s3,476(sp)
    7688:	1d812a03          	lw	s4,472(sp)
    768c:	1d412a83          	lw	s5,468(sp)
    7690:	1d012b03          	lw	s6,464(sp)
    7694:	1cc12b83          	lw	s7,460(sp)
    7698:	1c812c03          	lw	s8,456(sp)
    769c:	1c412c83          	lw	s9,452(sp)
    76a0:	1c012d03          	lw	s10,448(sp)
    76a4:	1bc12d83          	lw	s11,444(sp)
    76a8:	1f010113          	addi	sp,sp,496
    76ac:	00008067          	ret
    76b0:	00c12783          	lw	a5,12(sp)
    76b4:	009784b3          	add	s1,a5,s1
    76b8:	4a04ce63          	bltz	s1,7b74 <_ldtoa_r+0xee8>
    76bc:	01412783          	lw	a5,20(sp)
    76c0:	01012703          	lw	a4,16(sp)
    76c4:	0007a783          	lw	a5,0(a5)
    76c8:	00f707b3          	add	a5,a4,a5
    76cc:	00f12823          	sw	a5,16(sp)
    76d0:	01012783          	lw	a5,16(sp)
    76d4:	040b2223          	sw	zero,68(s6)
    76d8:	00378613          	addi	a2,a5,3
    76dc:	01700793          	li	a5,23
    76e0:	f4c7e2e3          	bltu	a5,a2,7624 <_ldtoa_r+0x998>
    76e4:	00000593          	li	a1,0
    76e8:	f5dff06f          	j	7644 <_ldtoa_r+0x9b8>
    76ec:	03000793          	li	a5,48
    76f0:	f2f710e3          	bne	a4,a5,7610 <_ldtoa_r+0x984>
    76f4:	412407b3          	sub	a5,s0,s2
    76f8:	00100693          	li	a3,1
    76fc:	eef6c4e3          	blt	a3,a5,75e4 <_ldtoa_r+0x958>
    7700:	f11ff06f          	j	7610 <_ldtoa_r+0x984>
    7704:	01012b83          	lw	s7,16(sp)
    7708:	01712623          	sw	s7,12(sp)
    770c:	02a00793          	li	a5,42
    7710:	e577de63          	bge	a5,s7,6d6c <_ldtoa_r+0xe0>
    7714:	00f12623          	sw	a5,12(sp)
    7718:	e54ff06f          	j	6d6c <_ldtoa_r+0xe0>
    771c:	01412703          	lw	a4,20(sp)
    7720:	000027b7          	lui	a5,0x2
    7724:	70f78793          	addi	a5,a5,1807 # 270f <_vfprintf_r+0x120b>
    7728:	00f72023          	sw	a5,0(a4)
    772c:	e21ff06f          	j	754c <_ldtoa_r+0x8c0>
    7730:	0b410a93          	addi	s5,sp,180
    7734:	000a8713          	mv	a4,s5
    7738:	07c10793          	addi	a5,sp,124
    773c:	09010613          	addi	a2,sp,144
    7740:	00278793          	addi	a5,a5,2
    7744:	ffe7d683          	lhu	a3,-2(a5)
    7748:	00270713          	addi	a4,a4,2
    774c:	fed71f23          	sh	a3,-2(a4)
    7750:	fec798e3          	bne	a5,a2,7740 <_ldtoa_r+0xab4>
    7754:	000047b7          	lui	a5,0x4
    7758:	08e78793          	addi	a5,a5,142 # 408e <__sbprintf+0x52>
    775c:	0cf11323          	sh	a5,198(sp)
    7760:	000087b7          	lui	a5,0x8
    7764:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
    7768:	02f12223          	sw	a5,36(sp)
    776c:	ffffc7b7          	lui	a5,0xffffc
    7770:	00278793          	addi	a5,a5,2 # ffffc002 <__freertos_irq_stack_top+0xfffe42e2>
    7774:	01000d13          	li	s10,16
    7778:	00000493          	li	s1,0
    777c:	0000ec17          	auipc	s8,0xe
    7780:	274c0c13          	addi	s8,s8,628 # 159f0 <etens+0xa0>
    7784:	12410913          	addi	s2,sp,292
    7788:	16010993          	addi	s3,sp,352
    778c:	0d010413          	addi	s0,sp,208
    7790:	0aa10b93          	addi	s7,sp,170
    7794:	02f12423          	sw	a5,40(sp)
    7798:	05e10c93          	addi	s9,sp,94
    779c:	00098693          	mv	a3,s3
    77a0:	09810613          	addi	a2,sp,152
    77a4:	000a8593          	mv	a1,s5
    77a8:	000c0513          	mv	a0,s8
    77ac:	e9dfe0ef          	jal	ra,6648 <ediv>
    77b0:	04c10713          	addi	a4,sp,76
    77b4:	09810793          	addi	a5,sp,152
    77b8:	00278793          	addi	a5,a5,2
    77bc:	ffe7d683          	lhu	a3,-2(a5)
    77c0:	00270713          	addi	a4,a4,2
    77c4:	fed71f23          	sh	a3,-2(a4)
    77c8:	ffb798e3          	bne	a5,s11,77b8 <_ldtoa_r+0xb2c>
    77cc:	02412783          	lw	a5,36(sp)
    77d0:	05e15503          	lhu	a0,94(sp)
    77d4:	00f57633          	and	a2,a0,a5
    77d8:	02812783          	lw	a5,40(sp)
    77dc:	00f605b3          	add	a1,a2,a5
    77e0:	3ab05463          	blez	a1,7b88 <_ldtoa_r+0xefc>
    77e4:	09000613          	li	a2,144
    77e8:	40b60633          	sub	a2,a2,a1
    77ec:	00040713          	mv	a4,s0
    77f0:	04c10793          	addi	a5,sp,76
    77f4:	00278793          	addi	a5,a5,2
    77f8:	ffe7d683          	lhu	a3,-2(a5)
    77fc:	00270713          	addi	a4,a4,2
    7800:	fed71f23          	sh	a3,-2(a4)
    7804:	ff4798e3          	bne	a5,s4,77f4 <_ldtoa_r+0xb68>
    7808:	06c05863          	blez	a2,7878 <_ldtoa_r+0xbec>
    780c:	00f00793          	li	a5,15
    7810:	00040713          	mv	a4,s0
    7814:	02c7dc63          	bge	a5,a2,784c <_ldtoa_r+0xbc0>
    7818:	ff060613          	addi	a2,a2,-16 # 7ff0 <_localeconv_r+0x4>
    781c:	00465693          	srli	a3,a2,0x4
    7820:	00168713          	addi	a4,a3,1
    7824:	00171713          	slli	a4,a4,0x1
    7828:	00e40733          	add	a4,s0,a4
    782c:	00040793          	mv	a5,s0
    7830:	00278793          	addi	a5,a5,2
    7834:	fe079f23          	sh	zero,-2(a5)
    7838:	fee79ce3          	bne	a5,a4,7830 <_ldtoa_r+0xba4>
    783c:	08000613          	li	a2,128
    7840:	40b60633          	sub	a2,a2,a1
    7844:	00469693          	slli	a3,a3,0x4
    7848:	40d60633          	sub	a2,a2,a3
    784c:	0000e797          	auipc	a5,0xe
    7850:	fc878793          	addi	a5,a5,-56 # 15814 <bmask>
    7854:	00161613          	slli	a2,a2,0x1
    7858:	00c78633          	add	a2,a5,a2
    785c:	00065683          	lhu	a3,0(a2)
    7860:	00075783          	lhu	a5,0(a4)
    7864:	00d7f7b3          	and	a5,a5,a3
    7868:	00f71023          	sh	a5,0(a4)
    786c:	01051513          	slli	a0,a0,0x10
    7870:	41055513          	srai	a0,a0,0x10
    7874:	16054063          	bltz	a0,79d4 <_ldtoa_r+0xd48>
    7878:	09810793          	addi	a5,sp,152
    787c:	00040713          	mv	a4,s0
    7880:	0007d603          	lhu	a2,0(a5)
    7884:	00075683          	lhu	a3,0(a4)
    7888:	00278793          	addi	a5,a5,2
    788c:	00270713          	addi	a4,a4,2
    7890:	02d61463          	bne	a2,a3,78b8 <_ldtoa_r+0xc2c>
    7894:	fefb96e3          	bne	s7,a5,7880 <_ldtoa_r+0xbf4>
    7898:	000a8713          	mv	a4,s5
    789c:	09810793          	addi	a5,sp,152
    78a0:	00278793          	addi	a5,a5,2
    78a4:	ffe7d683          	lhu	a3,-2(a5)
    78a8:	00270713          	addi	a4,a4,2
    78ac:	fed71f23          	sh	a3,-2(a4)
    78b0:	ffb798e3          	bne	a5,s11,78a0 <_ldtoa_r+0xc14>
    78b4:	01a484b3          	add	s1,s1,s10
    78b8:	014c0c13          	addi	s8,s8,20
    78bc:	0000e797          	auipc	a5,0xe
    78c0:	19878793          	addi	a5,a5,408 # 15a54 <ezero>
    78c4:	001d5d13          	srli	s10,s10,0x1
    78c8:	ecfc1ae3          	bne	s8,a5,779c <_ldtoa_r+0xb10>
    78cc:	0c615783          	lhu	a5,198(sp)
    78d0:	08e15703          	lhu	a4,142(sp)
    78d4:	0c810613          	addi	a2,sp,200
    78d8:	00e787b3          	add	a5,a5,a4
    78dc:	ffffc737          	lui	a4,0xffffc
    78e0:	f7270713          	addi	a4,a4,-142 # ffffbf72 <__freertos_irq_stack_top+0xfffe4252>
    78e4:	00e787b3          	add	a5,a5,a4
    78e8:	0cf11323          	sh	a5,198(sp)
    78ec:	07c10713          	addi	a4,sp,124
    78f0:	000a8793          	mv	a5,s5
    78f4:	00278793          	addi	a5,a5,2
    78f8:	ffe7d683          	lhu	a3,-2(a5)
    78fc:	00270713          	addi	a4,a4,2
    7900:	fed71f23          	sh	a3,-2(a4)
    7904:	fec798e3          	bne	a5,a2,78f4 <_ldtoa_r+0xc68>
    7908:	00000693          	li	a3,0
    790c:	09810793          	addi	a5,sp,152
    7910:	0000e717          	auipc	a4,0xe
    7914:	02c70713          	addi	a4,a4,44 # 1593c <eone>
    7918:	0080006f          	j	7920 <_ldtoa_r+0xc94>
    791c:	00075683          	lhu	a3,0(a4)
    7920:	00278793          	addi	a5,a5,2
    7924:	fed79f23          	sh	a3,-2(a5)
    7928:	00270713          	addi	a4,a4,2
    792c:	ffb798e3          	bne	a5,s11,791c <_ldtoa_r+0xc90>
    7930:	00001d37          	lui	s10,0x1
    7934:	0000ec97          	auipc	s9,0xe
    7938:	01cc8c93          	addi	s9,s9,28 # 15950 <etens>
    793c:	0000ed97          	auipc	s11,0xe
    7940:	104d8d93          	addi	s11,s11,260 # 15a40 <etens+0xf0>
    7944:	0100006f          	j	7954 <_ldtoa_r+0xcc8>
    7948:	001d5d13          	srli	s10,s10,0x1
    794c:	2dbc8463          	beq	s9,s11,7c14 <_ldtoa_r+0xf88>
    7950:	014c8c93          	addi	s9,s9,20
    7954:	000a8593          	mv	a1,s5
    7958:	000d8513          	mv	a0,s11
    795c:	e69fd0ef          	jal	ra,57c4 <ecmp>
    7960:	000a8593          	mv	a1,s5
    7964:	2aa04863          	bgtz	a0,7c14 <_ldtoa_r+0xf88>
    7968:	000c8513          	mv	a0,s9
    796c:	e59fd0ef          	jal	ra,57c4 <ecmp>
    7970:	fca04ce3          	bgtz	a0,7948 <_ldtoa_r+0xcbc>
    7974:	00098693          	mv	a3,s3
    7978:	000a8613          	mv	a2,s5
    797c:	000a8593          	mv	a1,s5
    7980:	000c8513          	mv	a0,s9
    7984:	cc5fe0ef          	jal	ra,6648 <ediv>
    7988:	09810613          	addi	a2,sp,152
    798c:	00098693          	mv	a3,s3
    7990:	00060593          	mv	a1,a2
    7994:	000c8513          	mv	a0,s9
    7998:	8a9fe0ef          	jal	ra,6240 <emul>
    799c:	01a484b3          	add	s1,s1,s10
    79a0:	fa9ff06f          	j	7948 <_ldtoa_r+0xcbc>
    79a4:	1ac15783          	lhu	a5,428(sp)
    79a8:	12610c93          	addi	s9,sp,294
    79ac:	12710993          	addi	s3,sp,295
    79b0:	a7dff06f          	j	742c <_ldtoa_r+0x7a0>
    79b4:	12410913          	addi	s2,sp,292
    79b8:	0000e597          	auipc	a1,0xe
    79bc:	e3458593          	addi	a1,a1,-460 # 157ec <zeroes.4505+0x10>
    79c0:	00090513          	mv	a0,s2
    79c4:	000024b7          	lui	s1,0x2
    79c8:	499020ef          	jal	ra,a660 <sprintf>
    79cc:	70f48493          	addi	s1,s1,1807 # 270f <_vfprintf_r+0x120b>
    79d0:	af1ff06f          	j	74c0 <_ldtoa_r+0x834>
    79d4:	04c10793          	addi	a5,sp,76
    79d8:	00040713          	mv	a4,s0
    79dc:	0080006f          	j	79e4 <_ldtoa_r+0xd58>
    79e0:	e8fc8ce3          	beq	s9,a5,7878 <_ldtoa_r+0xbec>
    79e4:	0007d603          	lhu	a2,0(a5)
    79e8:	00075683          	lhu	a3,0(a4)
    79ec:	00278793          	addi	a5,a5,2
    79f0:	00270713          	addi	a4,a4,2
    79f4:	fed606e3          	beq	a2,a3,79e0 <_ldtoa_r+0xd54>
    79f8:	0e215783          	lhu	a5,226(sp)
    79fc:	02412703          	lw	a4,36(sp)
    7a00:	00f777b3          	and	a5,a4,a5
    7a04:	00e79e63          	bne	a5,a4,7a20 <_ldtoa_r+0xd94>
    7a08:	00040513          	mv	a0,s0
    7a0c:	c21fd0ef          	jal	ra,562c <eisnan.part.0>
    7a10:	e60514e3          	bnez	a0,7878 <_ldtoa_r+0xbec>
    7a14:	00040513          	mv	a0,s0
    7a18:	ec9fd0ef          	jal	ra,58e0 <eisinf.part.1>
    7a1c:	e4051ee3          	bnez	a0,7878 <_ldtoa_r+0xbec>
    7a20:	0ec10593          	addi	a1,sp,236
    7a24:	0000e517          	auipc	a0,0xe
    7a28:	f1850513          	addi	a0,a0,-232 # 1593c <eone>
    7a2c:	cb1fd0ef          	jal	ra,56dc <emovi>
    7a30:	10810593          	addi	a1,sp,264
    7a34:	00040513          	mv	a0,s0
    7a38:	ca5fd0ef          	jal	ra,56dc <emovi>
    7a3c:	0ec15603          	lhu	a2,236(sp)
    7a40:	10a15503          	lhu	a0,266(sp)
    7a44:	0ee15803          	lhu	a6,238(sp)
    7a48:	fff64613          	not	a2,a2
    7a4c:	01061613          	slli	a2,a2,0x10
    7a50:	01065613          	srli	a2,a2,0x10
    7a54:	0ec11623          	sh	a2,236(sp)
    7a58:	40a805b3          	sub	a1,a6,a0
    7a5c:	00050693          	mv	a3,a0
    7a60:	06b05e63          	blez	a1,7adc <_ldtoa_r+0xe50>
    7a64:	00090693          	mv	a3,s2
    7a68:	10810713          	addi	a4,sp,264
    7a6c:	12010793          	addi	a5,sp,288
    7a70:	00270713          	addi	a4,a4,2
    7a74:	ffe75583          	lhu	a1,-2(a4)
    7a78:	00268693          	addi	a3,a3,2
    7a7c:	feb69f23          	sh	a1,-2(a3)
    7a80:	fef718e3          	bne	a4,a5,7a70 <_ldtoa_r+0xde4>
    7a84:	12011e23          	sh	zero,316(sp)
    7a88:	10810713          	addi	a4,sp,264
    7a8c:	0ec10693          	addi	a3,sp,236
    7a90:	0080006f          	j	7a98 <_ldtoa_r+0xe0c>
    7a94:	0006d603          	lhu	a2,0(a3)
    7a98:	00270713          	addi	a4,a4,2
    7a9c:	fec71f23          	sh	a2,-2(a4)
    7aa0:	00268693          	addi	a3,a3,2
    7aa4:	fef718e3          	bne	a4,a5,7a94 <_ldtoa_r+0xe08>
    7aa8:	12011023          	sh	zero,288(sp)
    7aac:	0ec10713          	addi	a4,sp,236
    7ab0:	00090793          	mv	a5,s2
    7ab4:	13c10613          	addi	a2,sp,316
    7ab8:	00278793          	addi	a5,a5,2
    7abc:	ffe7d683          	lhu	a3,-2(a5)
    7ac0:	00270713          	addi	a4,a4,2
    7ac4:	fed71f23          	sh	a3,-2(a4)
    7ac8:	fec798e3          	bne	a5,a2,7ab8 <_ldtoa_r+0xe2c>
    7acc:	10a15683          	lhu	a3,266(sp)
    7ad0:	410505b3          	sub	a1,a0,a6
    7ad4:	10011223          	sh	zero,260(sp)
    7ad8:	00068513          	mv	a0,a3
    7adc:	30058863          	beqz	a1,7dec <_ldtoa_r+0x1160>
    7ae0:	02d12623          	sw	a3,44(sp)
    7ae4:	f6f00793          	li	a5,-145
    7ae8:	06f5c863          	blt	a1,a5,7b58 <_ldtoa_r+0xecc>
    7aec:	0ec10513          	addi	a0,sp,236
    7af0:	e0dfd0ef          	jal	ra,58fc <eshift.part.3>
    7af4:	02c12683          	lw	a3,44(sp)
    7af8:	00050593          	mv	a1,a0
    7afc:	12010793          	addi	a5,sp,288
    7b00:	10410813          	addi	a6,sp,260
    7b04:	0ec15603          	lhu	a2,236(sp)
    7b08:	10815703          	lhu	a4,264(sp)
    7b0c:	32e60c63          	beq	a2,a4,7e44 <_ldtoa_r+0x11b8>
    7b10:	00000713          	li	a4,0
    7b14:	00070613          	mv	a2,a4
    7b18:	0007d703          	lhu	a4,0(a5)
    7b1c:	00085503          	lhu	a0,0(a6) # ffff8000 <__freertos_irq_stack_top+0xfffe02e0>
    7b20:	ffe78793          	addi	a5,a5,-2
    7b24:	40c70733          	sub	a4,a4,a2
    7b28:	40a70733          	sub	a4,a4,a0
    7b2c:	00e79123          	sh	a4,2(a5)
    7b30:	01075713          	srli	a4,a4,0x10
    7b34:	00177613          	andi	a2,a4,1
    7b38:	10a10713          	addi	a4,sp,266
    7b3c:	ffe80813          	addi	a6,a6,-2
    7b40:	fce79ce3          	bne	a5,a4,7b18 <_ldtoa_r+0xe8c>
    7b44:	00100613          	li	a2,1
    7b48:	00098793          	mv	a5,s3
    7b4c:	04000713          	li	a4,64
    7b50:	10810513          	addi	a0,sp,264
    7b54:	8d0fe0ef          	jal	ra,5c24 <emdnorm>
    7b58:	00040593          	mv	a1,s0
    7b5c:	10810513          	addi	a0,sp,264
    7b60:	e30fe0ef          	jal	ra,6190 <emovo.isra.6>
    7b64:	d15ff06f          	j	7878 <_ldtoa_r+0xbec>
    7b68:	01012783          	lw	a5,16(sp)
    7b6c:	fff78b93          	addi	s7,a5,-1
    7b70:	b99ff06f          	j	7708 <_ldtoa_r+0xa7c>
    7b74:	01412783          	lw	a5,20(sp)
    7b78:	12010223          	sb	zero,292(sp)
    7b7c:	00090413          	mv	s0,s2
    7b80:	0007a023          	sw	zero,0(a5)
    7b84:	b4dff06f          	j	76d0 <_ldtoa_r+0xa44>
    7b88:	00040793          	mv	a5,s0
    7b8c:	0e410713          	addi	a4,sp,228
    7b90:	00278793          	addi	a5,a5,2
    7b94:	fe079f23          	sh	zero,-2(a5)
    7b98:	fee79ce3          	bne	a5,a4,7b90 <_ldtoa_r+0xf04>
    7b9c:	cd1ff06f          	j	786c <_ldtoa_r+0xbe0>
    7ba0:	01812783          	lw	a5,24(sp)
    7ba4:	12410913          	addi	s2,sp,292
    7ba8:	0e078a63          	beqz	a5,7c9c <_ldtoa_r+0x1010>
    7bac:	0000e597          	auipc	a1,0xe
    7bb0:	c4858593          	addi	a1,a1,-952 # 157f4 <zeroes.4505+0x18>
    7bb4:	00090513          	mv	a0,s2
    7bb8:	000024b7          	lui	s1,0x2
    7bbc:	2a5020ef          	jal	ra,a660 <sprintf>
    7bc0:	70f48493          	addi	s1,s1,1807 # 270f <_vfprintf_r+0x120b>
    7bc4:	8fdff06f          	j	74c0 <_ldtoa_r+0x834>
    7bc8:	03100793          	li	a5,49
    7bcc:	12f102a3          	sb	a5,293(sp)
    7bd0:	02e00793          	li	a5,46
    7bd4:	12f10323          	sb	a5,294(sp)
    7bd8:	00148493          	addi	s1,s1,1
    7bdc:	02900413          	li	s0,41
    7be0:	03000793          	li	a5,48
    7be4:	12f103a3          	sb	a5,295(sp)
    7be8:	12810c93          	addi	s9,sp,296
    7bec:	e6cff06f          	j	7258 <_ldtoa_r+0x5cc>
    7bf0:	03100793          	li	a5,49
    7bf4:	12f102a3          	sb	a5,293(sp)
    7bf8:	02e00793          	li	a5,46
    7bfc:	12f10323          	sb	a5,294(sp)
    7c00:	00148493          	addi	s1,s1,1
    7c04:	1e804063          	bgtz	s0,7de4 <_ldtoa_r+0x1158>
    7c08:	12710c93          	addi	s9,sp,295
    7c0c:	8a0410e3          	bnez	s0,74ac <_ldtoa_r+0x820>
    7c10:	e48ff06f          	j	7258 <_ldtoa_r+0x5cc>
    7c14:	0e810b93          	addi	s7,sp,232
    7c18:	b90ff06f          	j	6fa8 <_ldtoa_r+0x31c>
    7c1c:	03100793          	li	a5,49
    7c20:	fef98f23          	sb	a5,-2(s3)
    7c24:	00148493          	addi	s1,s1,1
    7c28:	885ff06f          	j	74ac <_ldtoa_r+0x820>
    7c2c:	12410913          	addi	s2,sp,292
    7c30:	0000e597          	auipc	a1,0xe
    7c34:	bdc58593          	addi	a1,a1,-1060 # 1580c <zeroes.4505+0x30>
    7c38:	00090513          	mv	a0,s2
    7c3c:	000024b7          	lui	s1,0x2
    7c40:	221020ef          	jal	ra,a660 <sprintf>
    7c44:	70f48493          	addi	s1,s1,1807 # 270f <_vfprintf_r+0x120b>
    7c48:	879ff06f          	j	74c0 <_ldtoa_r+0x834>
    7c4c:	09810593          	addi	a1,sp,152
    7c50:	07c10513          	addi	a0,sp,124
    7c54:	d3cfe0ef          	jal	ra,6190 <emovo.isra.6>
    7c58:	0000e597          	auipc	a1,0xe
    7c5c:	dfc58593          	addi	a1,a1,-516 # 15a54 <ezero>
    7c60:	09810513          	addi	a0,sp,152
    7c64:	b61fd0ef          	jal	ra,57c4 <ecmp>
    7c68:	fc051a63          	bnez	a0,743c <_ldtoa_r+0x7b0>
    7c6c:	840440e3          	bltz	s0,74ac <_ldtoa_r+0x820>
    7c70:	ffe9c783          	lbu	a5,-2(s3)
    7c74:	fd278713          	addi	a4,a5,-46
    7c78:	00173713          	seqz	a4,a4
    7c7c:	fff74713          	not	a4,a4
    7c80:	00ec8733          	add	a4,s9,a4
    7c84:	00074703          	lbu	a4,0(a4)
    7c88:	00177713          	andi	a4,a4,1
    7c8c:	820700e3          	beqz	a4,74ac <_ldtoa_r+0x820>
    7c90:	ffe98713          	addi	a4,s3,-2
    7c94:	07f7f793          	andi	a5,a5,127
    7c98:	fb4ff06f          	j	744c <_ldtoa_r+0x7c0>
    7c9c:	0000e597          	auipc	a1,0xe
    7ca0:	b6458593          	addi	a1,a1,-1180 # 15800 <zeroes.4505+0x24>
    7ca4:	00090513          	mv	a0,s2
    7ca8:	000024b7          	lui	s1,0x2
    7cac:	1b5020ef          	jal	ra,a660 <sprintf>
    7cb0:	70f48493          	addi	s1,s1,1807 # 270f <_vfprintf_r+0x120b>
    7cb4:	80dff06f          	j	74c0 <_ldtoa_r+0x834>
    7cb8:	00178793          	addi	a5,a5,1
    7cbc:	fef70fa3          	sb	a5,-1(a4)
    7cc0:	fecff06f          	j	74ac <_ldtoa_r+0x820>
    7cc4:	0d010413          	addi	s0,sp,208
    7cc8:	00040593          	mv	a1,s0
    7ccc:	07c10513          	addi	a0,sp,124
    7cd0:	00004ab7          	lui	s5,0x4
    7cd4:	a09fd0ef          	jal	ra,56dc <emovi>
    7cd8:	00000493          	li	s1,0
    7cdc:	0e810b93          	addi	s7,sp,232
    7ce0:	0cc10913          	addi	s2,sp,204
    7ce4:	0d210993          	addi	s3,sp,210
    7ce8:	ffea8a93          	addi	s5,s5,-2 # 3ffe <_vfprintf_r+0x2afa>
    7cec:	fd500c93          	li	s9,-43
    7cf0:	0e815783          	lhu	a5,232(sp)
    7cf4:	0077f793          	andi	a5,a5,7
    7cf8:	0c079863          	bnez	a5,7dc8 <_ldtoa_r+0x113c>
    7cfc:	0b410713          	addi	a4,sp,180
    7d00:	00040793          	mv	a5,s0
    7d04:	00278793          	addi	a5,a5,2
    7d08:	ffe7d683          	lhu	a3,-2(a5)
    7d0c:	00270713          	addi	a4,a4,2
    7d10:	fed71f23          	sh	a3,-2(a4)
    7d14:	ff7798e3          	bne	a5,s7,7d04 <_ldtoa_r+0x1078>
    7d18:	0b410513          	addi	a0,sp,180
    7d1c:	0c011623          	sh	zero,204(sp)
    7d20:	f9cfd0ef          	jal	ra,54bc <eshdn1>
    7d24:	0b410513          	addi	a0,sp,180
    7d28:	f94fd0ef          	jal	ra,54bc <eshdn1>
    7d2c:	00000613          	li	a2,0
    7d30:	00090693          	mv	a3,s2
    7d34:	000b8713          	mv	a4,s7
    7d38:	0006d583          	lhu	a1,0(a3)
    7d3c:	00075783          	lhu	a5,0(a4)
    7d40:	ffe68693          	addi	a3,a3,-2
    7d44:	ffe70713          	addi	a4,a4,-2
    7d48:	00b787b3          	add	a5,a5,a1
    7d4c:	00c787b3          	add	a5,a5,a2
    7d50:	00f69123          	sh	a5,2(a3)
    7d54:	0107d793          	srli	a5,a5,0x10
    7d58:	0017f613          	andi	a2,a5,1
    7d5c:	fd371ee3          	bne	a4,s3,7d38 <_ldtoa_r+0x10ac>
    7d60:	0b615783          	lhu	a5,182(sp)
    7d64:	0b815703          	lhu	a4,184(sp)
    7d68:	00378793          	addi	a5,a5,3
    7d6c:	0af11b23          	sh	a5,182(sp)
    7d70:	02070063          	beqz	a4,7d90 <_ldtoa_r+0x1104>
    7d74:	0b410513          	addi	a0,sp,180
    7d78:	f44fd0ef          	jal	ra,54bc <eshdn1>
    7d7c:	0b615783          	lhu	a5,182(sp)
    7d80:	0b815703          	lhu	a4,184(sp)
    7d84:	00178793          	addi	a5,a5,1
    7d88:	0af11b23          	sh	a5,182(sp)
    7d8c:	fe0714e3          	bnez	a4,7d74 <_ldtoa_r+0x10e8>
    7d90:	0cc15783          	lhu	a5,204(sp)
    7d94:	02079a63          	bnez	a5,7dc8 <_ldtoa_r+0x113c>
    7d98:	0b615783          	lhu	a5,182(sp)
    7d9c:	02fae663          	bltu	s5,a5,7dc8 <_ldtoa_r+0x113c>
    7da0:	00040713          	mv	a4,s0
    7da4:	0b410793          	addi	a5,sp,180
    7da8:	00278793          	addi	a5,a5,2
    7dac:	ffe7d683          	lhu	a3,-2(a5)
    7db0:	00270713          	addi	a4,a4,2
    7db4:	fed71f23          	sh	a3,-2(a4)
    7db8:	ff2798e3          	bne	a5,s2,7da8 <_ldtoa_r+0x111c>
    7dbc:	0e011423          	sh	zero,232(sp)
    7dc0:	fff48493          	addi	s1,s1,-1
    7dc4:	f39496e3          	bne	s1,s9,7cf0 <_ldtoa_r+0x1064>
    7dc8:	07c10593          	addi	a1,sp,124
    7dcc:	00040513          	mv	a0,s0
    7dd0:	bc0fe0ef          	jal	ra,6190 <emovo.isra.6>
    7dd4:	16010993          	addi	s3,sp,352
    7dd8:	8b0ff06f          	j	6e88 <_ldtoa_r+0x1fc>
    7ddc:	00090793          	mv	a5,s2
    7de0:	f68ff06f          	j	7548 <_ldtoa_r+0x8bc>
    7de4:	fff40413          	addi	s0,s0,-1
    7de8:	df9ff06f          	j	7be0 <_ldtoa_r+0xf54>
    7dec:	10c10713          	addi	a4,sp,268
    7df0:	0f010793          	addi	a5,sp,240
    7df4:	00278793          	addi	a5,a5,2
    7df8:	00270713          	addi	a4,a4,2
    7dfc:	ffe7d803          	lhu	a6,-2(a5)
    7e00:	ffe75603          	lhu	a2,-2(a4)
    7e04:	02c81863          	bne	a6,a2,7e34 <_ldtoa_r+0x11a8>
    7e08:	10610613          	addi	a2,sp,262
    7e0c:	fec794e3          	bne	a5,a2,7df4 <_ldtoa_r+0x1168>
    7e10:	0ec15703          	lhu	a4,236(sp)
    7e14:	10815783          	lhu	a5,264(sp)
    7e18:	06f70463          	beq	a4,a5,7e80 <_ldtoa_r+0x11f4>
    7e1c:	00040793          	mv	a5,s0
    7e20:	0e410713          	addi	a4,sp,228
    7e24:	00278793          	addi	a5,a5,2
    7e28:	fe079f23          	sh	zero,-2(a5)
    7e2c:	fee79ce3          	bne	a5,a4,7e24 <_ldtoa_r+0x1198>
    7e30:	a49ff06f          	j	7878 <_ldtoa_r+0xbec>
    7e34:	0d066863          	bltu	a2,a6,7f04 <_ldtoa_r+0x1278>
    7e38:	12010793          	addi	a5,sp,288
    7e3c:	10410813          	addi	a6,sp,260
    7e40:	cc5ff06f          	j	7b04 <_ldtoa_r+0xe78>
    7e44:	00000613          	li	a2,0
    7e48:	00080713          	mv	a4,a6
    7e4c:	0ee10893          	addi	a7,sp,238
    7e50:	0007d803          	lhu	a6,0(a5)
    7e54:	00075503          	lhu	a0,0(a4)
    7e58:	ffe78793          	addi	a5,a5,-2
    7e5c:	ffe70713          	addi	a4,a4,-2
    7e60:	01050533          	add	a0,a0,a6
    7e64:	00c50633          	add	a2,a0,a2
    7e68:	00c79123          	sh	a2,2(a5)
    7e6c:	01065613          	srli	a2,a2,0x10
    7e70:	00167613          	andi	a2,a2,1
    7e74:	fd171ee3          	bne	a4,a7,7e50 <_ldtoa_r+0x11c4>
    7e78:	00000613          	li	a2,0
    7e7c:	ccdff06f          	j	7b48 <_ldtoa_r+0xebc>
    7e80:	00068713          	mv	a4,a3
    7e84:	06069263          	bnez	a3,7ee8 <_ldtoa_r+0x125c>
    7e88:	10e11783          	lh	a5,270(sp)
    7e8c:	0407ce63          	bltz	a5,7ee8 <_ldtoa_r+0x125c>
    7e90:	12010693          	addi	a3,sp,288
    7e94:	0200006f          	j	7eb4 <_ldtoa_r+0x1228>
    7e98:	00f69023          	sh	a5,0(a3)
    7e9c:	00171713          	slli	a4,a4,0x1
    7ea0:	01071713          	slli	a4,a4,0x10
    7ea4:	ffe68693          	addi	a3,a3,-2
    7ea8:	10a10793          	addi	a5,sp,266
    7eac:	01075713          	srli	a4,a4,0x10
    7eb0:	caf684e3          	beq	a3,a5,7b58 <_ldtoa_r+0xecc>
    7eb4:	0006d783          	lhu	a5,0(a3)
    7eb8:	01079613          	slli	a2,a5,0x10
    7ebc:	41065613          	srai	a2,a2,0x10
    7ec0:	00179793          	slli	a5,a5,0x1
    7ec4:	00065463          	bgez	a2,7ecc <_ldtoa_r+0x1240>
    7ec8:	00176713          	ori	a4,a4,1
    7ecc:	01079793          	slli	a5,a5,0x10
    7ed0:	0107d793          	srli	a5,a5,0x10
    7ed4:	00277613          	andi	a2,a4,2
    7ed8:	0017e593          	ori	a1,a5,1
    7edc:	fa060ee3          	beqz	a2,7e98 <_ldtoa_r+0x120c>
    7ee0:	00b69023          	sh	a1,0(a3)
    7ee4:	fb9ff06f          	j	7e9c <_ldtoa_r+0x1210>
    7ee8:	10c10613          	addi	a2,sp,268
    7eec:	12010793          	addi	a5,sp,288
    7ef0:	08071263          	bnez	a4,7f74 <_ldtoa_r+0x12e8>
    7ef4:	08c78263          	beq	a5,a2,7f78 <_ldtoa_r+0x12ec>
    7ef8:	00065703          	lhu	a4,0(a2)
    7efc:	00260613          	addi	a2,a2,2
    7f00:	ff1ff06f          	j	7ef0 <_ldtoa_r+0x1264>
    7f04:	00090613          	mv	a2,s2
    7f08:	10810713          	addi	a4,sp,264
    7f0c:	12010793          	addi	a5,sp,288
    7f10:	00270713          	addi	a4,a4,2
    7f14:	ffe75503          	lhu	a0,-2(a4)
    7f18:	00260613          	addi	a2,a2,2
    7f1c:	fea61f23          	sh	a0,-2(a2)
    7f20:	fef718e3          	bne	a4,a5,7f10 <_ldtoa_r+0x1284>
    7f24:	12011e23          	sh	zero,316(sp)
    7f28:	10810613          	addi	a2,sp,264
    7f2c:	0ec10713          	addi	a4,sp,236
    7f30:	10410813          	addi	a6,sp,260
    7f34:	00270713          	addi	a4,a4,2
    7f38:	ffe75503          	lhu	a0,-2(a4)
    7f3c:	00260613          	addi	a2,a2,2
    7f40:	fea61f23          	sh	a0,-2(a2)
    7f44:	ff0718e3          	bne	a4,a6,7f34 <_ldtoa_r+0x12a8>
    7f48:	12011023          	sh	zero,288(sp)
    7f4c:	0ec10513          	addi	a0,sp,236
    7f50:	00090713          	mv	a4,s2
    7f54:	13c10613          	addi	a2,sp,316
    7f58:	00270713          	addi	a4,a4,2
    7f5c:	ffe75883          	lhu	a7,-2(a4)
    7f60:	00250513          	addi	a0,a0,2
    7f64:	ff151f23          	sh	a7,-2(a0)
    7f68:	fec718e3          	bne	a4,a2,7f58 <_ldtoa_r+0x12cc>
    7f6c:	10011223          	sh	zero,260(sp)
    7f70:	b95ff06f          	j	7b04 <_ldtoa_r+0xe78>
    7f74:	00168513          	addi	a0,a3,1
    7f78:	10a11523          	sh	a0,266(sp)
    7f7c:	bddff06f          	j	7b58 <_ldtoa_r+0xecc>

00007f80 <_ldcheck>:
    7f80:	00852703          	lw	a4,8(a0)
    7f84:	00c52783          	lw	a5,12(a0)
    7f88:	00052603          	lw	a2,0(a0)
    7f8c:	00452683          	lw	a3,4(a0)
    7f90:	fc010113          	addi	sp,sp,-64
    7f94:	00010513          	mv	a0,sp
    7f98:	01410593          	addi	a1,sp,20
    7f9c:	00e12423          	sw	a4,8(sp)
    7fa0:	00f12623          	sw	a5,12(sp)
    7fa4:	02112e23          	sw	ra,60(sp)
    7fa8:	00c12023          	sw	a2,0(sp)
    7fac:	00d12223          	sw	a3,4(sp)
    7fb0:	b99fe0ef          	jal	ra,6b48 <e113toe.isra.8>
    7fb4:	02615783          	lhu	a5,38(sp)
    7fb8:	00000513          	li	a0,0
    7fbc:	fff7c793          	not	a5,a5
    7fc0:	01179713          	slli	a4,a5,0x11
    7fc4:	00071a63          	bnez	a4,7fd8 <_ldcheck+0x58>
    7fc8:	01410513          	addi	a0,sp,20
    7fcc:	e60fd0ef          	jal	ra,562c <eisnan.part.0>
    7fd0:	00153513          	seqz	a0,a0
    7fd4:	00150513          	addi	a0,a0,1
    7fd8:	03c12083          	lw	ra,60(sp)
    7fdc:	04010113          	addi	sp,sp,64
    7fe0:	00008067          	ret

00007fe4 <__localeconv_l>:
    7fe4:	0f050513          	addi	a0,a0,240
    7fe8:	00008067          	ret

00007fec <_localeconv_r>:
    7fec:	0000f517          	auipc	a0,0xf
    7ff0:	84c50513          	addi	a0,a0,-1972 # 16838 <__global_locale+0xf0>
    7ff4:	00008067          	ret

00007ff8 <localeconv>:
    7ff8:	0000f517          	auipc	a0,0xf
    7ffc:	84050513          	addi	a0,a0,-1984 # 16838 <__global_locale+0xf0>
    8000:	00008067          	ret

00008004 <_setlocale_r>:
    8004:	04060063          	beqz	a2,8044 <_setlocale_r+0x40>
    8008:	ff010113          	addi	sp,sp,-16
    800c:	0000e597          	auipc	a1,0xe
    8010:	a6058593          	addi	a1,a1,-1440 # 15a6c <ezero+0x18>
    8014:	00060513          	mv	a0,a2
    8018:	00812423          	sw	s0,8(sp)
    801c:	00112623          	sw	ra,12(sp)
    8020:	00060413          	mv	s0,a2
    8024:	015020ef          	jal	ra,a838 <strcmp>
    8028:	02051463          	bnez	a0,8050 <_setlocale_r+0x4c>
    802c:	0000e517          	auipc	a0,0xe
    8030:	a3c50513          	addi	a0,a0,-1476 # 15a68 <ezero+0x14>
    8034:	00c12083          	lw	ra,12(sp)
    8038:	00812403          	lw	s0,8(sp)
    803c:	01010113          	addi	sp,sp,16
    8040:	00008067          	ret
    8044:	0000e517          	auipc	a0,0xe
    8048:	a2450513          	addi	a0,a0,-1500 # 15a68 <ezero+0x14>
    804c:	00008067          	ret
    8050:	0000e597          	auipc	a1,0xe
    8054:	a1858593          	addi	a1,a1,-1512 # 15a68 <ezero+0x14>
    8058:	00040513          	mv	a0,s0
    805c:	7dc020ef          	jal	ra,a838 <strcmp>
    8060:	fc0506e3          	beqz	a0,802c <_setlocale_r+0x28>
    8064:	0000d597          	auipc	a1,0xd
    8068:	2f058593          	addi	a1,a1,752 # 15354 <_data+0x3c>
    806c:	00040513          	mv	a0,s0
    8070:	7c8020ef          	jal	ra,a838 <strcmp>
    8074:	fa050ce3          	beqz	a0,802c <_setlocale_r+0x28>
    8078:	00000513          	li	a0,0
    807c:	fb9ff06f          	j	8034 <_setlocale_r+0x30>

00008080 <__locale_mb_cur_max>:
    8080:	0000e517          	auipc	a0,0xe
    8084:	7f054503          	lbu	a0,2032(a0) # 16870 <__global_locale+0x128>
    8088:	00008067          	ret

0000808c <setlocale>:
    808c:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    8090:	00058613          	mv	a2,a1
    8094:	00050593          	mv	a1,a0
    8098:	0007a503          	lw	a0,0(a5)
    809c:	f69ff06f          	j	8004 <_setlocale_r>

000080a0 <__swhatbuf_r>:
    80a0:	f9010113          	addi	sp,sp,-112
    80a4:	06812423          	sw	s0,104(sp)
    80a8:	00058413          	mv	s0,a1
    80ac:	00e59583          	lh	a1,14(a1)
    80b0:	06912223          	sw	s1,100(sp)
    80b4:	07212023          	sw	s2,96(sp)
    80b8:	06112623          	sw	ra,108(sp)
    80bc:	00060493          	mv	s1,a2
    80c0:	00068913          	mv	s2,a3
    80c4:	0405ca63          	bltz	a1,8118 <__swhatbuf_r+0x78>
    80c8:	00810613          	addi	a2,sp,8
    80cc:	5d1060ef          	jal	ra,ee9c <_fstat_r>
    80d0:	04054463          	bltz	a0,8118 <__swhatbuf_r+0x78>
    80d4:	00c12703          	lw	a4,12(sp)
    80d8:	0000f7b7          	lui	a5,0xf
    80dc:	06c12083          	lw	ra,108(sp)
    80e0:	00e7f7b3          	and	a5,a5,a4
    80e4:	ffffe737          	lui	a4,0xffffe
    80e8:	00e787b3          	add	a5,a5,a4
    80ec:	0017b793          	seqz	a5,a5
    80f0:	06812403          	lw	s0,104(sp)
    80f4:	00f92023          	sw	a5,0(s2) # fffff000 <__freertos_irq_stack_top+0xfffe72e0>
    80f8:	40000793          	li	a5,1024
    80fc:	00f4a023          	sw	a5,0(s1)
    8100:	00001537          	lui	a0,0x1
    8104:	06412483          	lw	s1,100(sp)
    8108:	06012903          	lw	s2,96(sp)
    810c:	80050513          	addi	a0,a0,-2048 # 800 <__stack_size-0x800>
    8110:	07010113          	addi	sp,sp,112
    8114:	00008067          	ret
    8118:	00c45783          	lhu	a5,12(s0)
    811c:	00092023          	sw	zero,0(s2)
    8120:	0807f793          	andi	a5,a5,128
    8124:	02078463          	beqz	a5,814c <__swhatbuf_r+0xac>
    8128:	06c12083          	lw	ra,108(sp)
    812c:	06812403          	lw	s0,104(sp)
    8130:	04000793          	li	a5,64
    8134:	00f4a023          	sw	a5,0(s1)
    8138:	06012903          	lw	s2,96(sp)
    813c:	06412483          	lw	s1,100(sp)
    8140:	00000513          	li	a0,0
    8144:	07010113          	addi	sp,sp,112
    8148:	00008067          	ret
    814c:	06c12083          	lw	ra,108(sp)
    8150:	06812403          	lw	s0,104(sp)
    8154:	40000793          	li	a5,1024
    8158:	00f4a023          	sw	a5,0(s1)
    815c:	06012903          	lw	s2,96(sp)
    8160:	06412483          	lw	s1,100(sp)
    8164:	00000513          	li	a0,0
    8168:	07010113          	addi	sp,sp,112
    816c:	00008067          	ret

00008170 <__smakebuf_r>:
    8170:	00c5d703          	lhu	a4,12(a1)
    8174:	fe010113          	addi	sp,sp,-32
    8178:	00812c23          	sw	s0,24(sp)
    817c:	00112e23          	sw	ra,28(sp)
    8180:	00912a23          	sw	s1,20(sp)
    8184:	01212823          	sw	s2,16(sp)
    8188:	00277713          	andi	a4,a4,2
    818c:	00058413          	mv	s0,a1
    8190:	02070863          	beqz	a4,81c0 <__smakebuf_r+0x50>
    8194:	04358713          	addi	a4,a1,67
    8198:	00e5a023          	sw	a4,0(a1)
    819c:	00e5a823          	sw	a4,16(a1)
    81a0:	00100713          	li	a4,1
    81a4:	00e5aa23          	sw	a4,20(a1)
    81a8:	01c12083          	lw	ra,28(sp)
    81ac:	01812403          	lw	s0,24(sp)
    81b0:	01412483          	lw	s1,20(sp)
    81b4:	01012903          	lw	s2,16(sp)
    81b8:	02010113          	addi	sp,sp,32
    81bc:	00008067          	ret
    81c0:	00c10693          	addi	a3,sp,12
    81c4:	00810613          	addi	a2,sp,8
    81c8:	00050493          	mv	s1,a0
    81cc:	ed5ff0ef          	jal	ra,80a0 <__swhatbuf_r>
    81d0:	00812583          	lw	a1,8(sp)
    81d4:	00050913          	mv	s2,a0
    81d8:	00048513          	mv	a0,s1
    81dc:	0b4000ef          	jal	ra,8290 <_malloc_r>
    81e0:	00c41783          	lh	a5,12(s0)
    81e4:	04050863          	beqz	a0,8234 <__smakebuf_r+0xc4>
    81e8:	ffffc697          	auipc	a3,0xffffc
    81ec:	50468693          	addi	a3,a3,1284 # 46ec <_cleanup_r>
    81f0:	02d4ae23          	sw	a3,60(s1)
    81f4:	00812683          	lw	a3,8(sp)
    81f8:	00c12703          	lw	a4,12(sp)
    81fc:	0807e793          	ori	a5,a5,128
    8200:	00f41623          	sh	a5,12(s0)
    8204:	00a42023          	sw	a0,0(s0)
    8208:	00a42823          	sw	a0,16(s0)
    820c:	00d42a23          	sw	a3,20(s0)
    8210:	04071863          	bnez	a4,8260 <__smakebuf_r+0xf0>
    8214:	0127e7b3          	or	a5,a5,s2
    8218:	00f41623          	sh	a5,12(s0)
    821c:	01c12083          	lw	ra,28(sp)
    8220:	01812403          	lw	s0,24(sp)
    8224:	01412483          	lw	s1,20(sp)
    8228:	01012903          	lw	s2,16(sp)
    822c:	02010113          	addi	sp,sp,32
    8230:	00008067          	ret
    8234:	2007f713          	andi	a4,a5,512
    8238:	f60718e3          	bnez	a4,81a8 <__smakebuf_r+0x38>
    823c:	ffc7f793          	andi	a5,a5,-4
    8240:	0027e793          	ori	a5,a5,2
    8244:	04340713          	addi	a4,s0,67
    8248:	00f41623          	sh	a5,12(s0)
    824c:	00100793          	li	a5,1
    8250:	00e42023          	sw	a4,0(s0)
    8254:	00e42823          	sw	a4,16(s0)
    8258:	00f42a23          	sw	a5,20(s0)
    825c:	f4dff06f          	j	81a8 <__smakebuf_r+0x38>
    8260:	00e41583          	lh	a1,14(s0)
    8264:	00048513          	mv	a0,s1
    8268:	491060ef          	jal	ra,eef8 <_isatty_r>
    826c:	00051663          	bnez	a0,8278 <__smakebuf_r+0x108>
    8270:	00c41783          	lh	a5,12(s0)
    8274:	fa1ff06f          	j	8214 <__smakebuf_r+0xa4>
    8278:	00c45783          	lhu	a5,12(s0)
    827c:	ffc7f793          	andi	a5,a5,-4
    8280:	0017e793          	ori	a5,a5,1
    8284:	01079793          	slli	a5,a5,0x10
    8288:	4107d793          	srai	a5,a5,0x10
    828c:	f89ff06f          	j	8214 <__smakebuf_r+0xa4>

00008290 <_malloc_r>:
    8290:	fd010113          	addi	sp,sp,-48
    8294:	02912223          	sw	s1,36(sp)
    8298:	03212023          	sw	s2,32(sp)
    829c:	02112623          	sw	ra,44(sp)
    82a0:	02812423          	sw	s0,40(sp)
    82a4:	01312e23          	sw	s3,28(sp)
    82a8:	01412c23          	sw	s4,24(sp)
    82ac:	01512a23          	sw	s5,20(sp)
    82b0:	01612823          	sw	s6,16(sp)
    82b4:	01712623          	sw	s7,12(sp)
    82b8:	01812423          	sw	s8,8(sp)
    82bc:	01912223          	sw	s9,4(sp)
    82c0:	00b58493          	addi	s1,a1,11
    82c4:	01600793          	li	a5,22
    82c8:	00050913          	mv	s2,a0
    82cc:	0697e663          	bltu	a5,s1,8338 <_malloc_r+0xa8>
    82d0:	01000793          	li	a5,16
    82d4:	22b7ec63          	bltu	a5,a1,850c <_malloc_r+0x27c>
    82d8:	42d000ef          	jal	ra,8f04 <__malloc_lock>
    82dc:	01000493          	li	s1,16
    82e0:	01800793          	li	a5,24
    82e4:	00200613          	li	a2,2
    82e8:	0000e997          	auipc	s3,0xe
    82ec:	5cc98993          	addi	s3,s3,1484 # 168b4 <__malloc_av_>
    82f0:	00f987b3          	add	a5,s3,a5
    82f4:	0047a403          	lw	s0,4(a5) # f004 <_read_r+0x58>
    82f8:	ff878713          	addi	a4,a5,-8
    82fc:	26e40063          	beq	s0,a4,855c <_malloc_r+0x2cc>
    8300:	00442783          	lw	a5,4(s0)
    8304:	00c42683          	lw	a3,12(s0)
    8308:	00842603          	lw	a2,8(s0)
    830c:	ffc7f793          	andi	a5,a5,-4
    8310:	00f407b3          	add	a5,s0,a5
    8314:	0047a703          	lw	a4,4(a5)
    8318:	00d62623          	sw	a3,12(a2)
    831c:	00c6a423          	sw	a2,8(a3)
    8320:	00176713          	ori	a4,a4,1
    8324:	00090513          	mv	a0,s2
    8328:	00e7a223          	sw	a4,4(a5)
    832c:	3dd000ef          	jal	ra,8f08 <__malloc_unlock>
    8330:	00840513          	addi	a0,s0,8
    8334:	1e40006f          	j	8518 <_malloc_r+0x288>
    8338:	ff84f493          	andi	s1,s1,-8
    833c:	1c04c863          	bltz	s1,850c <_malloc_r+0x27c>
    8340:	1cb4e663          	bltu	s1,a1,850c <_malloc_r+0x27c>
    8344:	3c1000ef          	jal	ra,8f04 <__malloc_lock>
    8348:	1f700793          	li	a5,503
    834c:	4a97f463          	bgeu	a5,s1,87f4 <_malloc_r+0x564>
    8350:	0094d793          	srli	a5,s1,0x9
    8354:	1e078c63          	beqz	a5,854c <_malloc_r+0x2bc>
    8358:	00400713          	li	a4,4
    835c:	42f76863          	bltu	a4,a5,878c <_malloc_r+0x4fc>
    8360:	0064d793          	srli	a5,s1,0x6
    8364:	03978613          	addi	a2,a5,57
    8368:	03878513          	addi	a0,a5,56
    836c:	00361693          	slli	a3,a2,0x3
    8370:	0000e997          	auipc	s3,0xe
    8374:	54498993          	addi	s3,s3,1348 # 168b4 <__malloc_av_>
    8378:	00d986b3          	add	a3,s3,a3
    837c:	0046a403          	lw	s0,4(a3)
    8380:	ff868693          	addi	a3,a3,-8
    8384:	02868c63          	beq	a3,s0,83bc <_malloc_r+0x12c>
    8388:	00442783          	lw	a5,4(s0)
    838c:	00f00593          	li	a1,15
    8390:	ffc7f793          	andi	a5,a5,-4
    8394:	40978733          	sub	a4,a5,s1
    8398:	02e5c063          	blt	a1,a4,83b8 <_malloc_r+0x128>
    839c:	38075263          	bgez	a4,8720 <_malloc_r+0x490>
    83a0:	00c42403          	lw	s0,12(s0)
    83a4:	00868c63          	beq	a3,s0,83bc <_malloc_r+0x12c>
    83a8:	00442783          	lw	a5,4(s0)
    83ac:	ffc7f793          	andi	a5,a5,-4
    83b0:	40978733          	sub	a4,a5,s1
    83b4:	fee5d4e3          	bge	a1,a4,839c <_malloc_r+0x10c>
    83b8:	00050613          	mv	a2,a0
    83bc:	0109a403          	lw	s0,16(s3)
    83c0:	0000e817          	auipc	a6,0xe
    83c4:	4fc80813          	addi	a6,a6,1276 # 168bc <__malloc_av_+0x8>
    83c8:	1b040863          	beq	s0,a6,8578 <_malloc_r+0x2e8>
    83cc:	00442583          	lw	a1,4(s0)
    83d0:	00f00713          	li	a4,15
    83d4:	ffc5f593          	andi	a1,a1,-4
    83d8:	409587b3          	sub	a5,a1,s1
    83dc:	44f74263          	blt	a4,a5,8820 <_malloc_r+0x590>
    83e0:	0000e717          	auipc	a4,0xe
    83e4:	4f072423          	sw	a6,1256(a4) # 168c8 <__malloc_av_+0x14>
    83e8:	0000e717          	auipc	a4,0xe
    83ec:	4d072e23          	sw	a6,1244(a4) # 168c4 <__malloc_av_+0x10>
    83f0:	4007d863          	bgez	a5,8800 <_malloc_r+0x570>
    83f4:	1ff00793          	li	a5,511
    83f8:	32b7ea63          	bltu	a5,a1,872c <_malloc_r+0x49c>
    83fc:	0035d593          	srli	a1,a1,0x3
    8400:	00158793          	addi	a5,a1,1
    8404:	00379793          	slli	a5,a5,0x3
    8408:	0049a503          	lw	a0,4(s3)
    840c:	00f987b3          	add	a5,s3,a5
    8410:	0007a683          	lw	a3,0(a5)
    8414:	4025d593          	srai	a1,a1,0x2
    8418:	00100713          	li	a4,1
    841c:	00b71733          	sll	a4,a4,a1
    8420:	00a76733          	or	a4,a4,a0
    8424:	ff878593          	addi	a1,a5,-8
    8428:	00b42623          	sw	a1,12(s0)
    842c:	00d42423          	sw	a3,8(s0)
    8430:	0000e597          	auipc	a1,0xe
    8434:	48e5a423          	sw	a4,1160(a1) # 168b8 <__malloc_av_+0x4>
    8438:	0087a023          	sw	s0,0(a5)
    843c:	0086a623          	sw	s0,12(a3)
    8440:	40265793          	srai	a5,a2,0x2
    8444:	00100693          	li	a3,1
    8448:	00f696b3          	sll	a3,a3,a5
    844c:	14d76063          	bltu	a4,a3,858c <_malloc_r+0x2fc>
    8450:	00e6f7b3          	and	a5,a3,a4
    8454:	02079463          	bnez	a5,847c <_malloc_r+0x1ec>
    8458:	00169693          	slli	a3,a3,0x1
    845c:	ffc67613          	andi	a2,a2,-4
    8460:	00e6f7b3          	and	a5,a3,a4
    8464:	00460613          	addi	a2,a2,4
    8468:	00079a63          	bnez	a5,847c <_malloc_r+0x1ec>
    846c:	00169693          	slli	a3,a3,0x1
    8470:	00e6f7b3          	and	a5,a3,a4
    8474:	00460613          	addi	a2,a2,4
    8478:	fe078ae3          	beqz	a5,846c <_malloc_r+0x1dc>
    847c:	00f00513          	li	a0,15
    8480:	00361893          	slli	a7,a2,0x3
    8484:	011988b3          	add	a7,s3,a7
    8488:	00088593          	mv	a1,a7
    848c:	00060313          	mv	t1,a2
    8490:	00c5a403          	lw	s0,12(a1)
    8494:	00859a63          	bne	a1,s0,84a8 <_malloc_r+0x218>
    8498:	3180006f          	j	87b0 <_malloc_r+0x520>
    849c:	32075463          	bgez	a4,87c4 <_malloc_r+0x534>
    84a0:	00c42403          	lw	s0,12(s0)
    84a4:	30858663          	beq	a1,s0,87b0 <_malloc_r+0x520>
    84a8:	00442783          	lw	a5,4(s0)
    84ac:	ffc7f793          	andi	a5,a5,-4
    84b0:	40978733          	sub	a4,a5,s1
    84b4:	fee554e3          	bge	a0,a4,849c <_malloc_r+0x20c>
    84b8:	00c42683          	lw	a3,12(s0)
    84bc:	00842603          	lw	a2,8(s0)
    84c0:	0014e593          	ori	a1,s1,1
    84c4:	00b42223          	sw	a1,4(s0)
    84c8:	00d62623          	sw	a3,12(a2)
    84cc:	00c6a423          	sw	a2,8(a3)
    84d0:	009404b3          	add	s1,s0,s1
    84d4:	0000e697          	auipc	a3,0xe
    84d8:	3e96aa23          	sw	s1,1012(a3) # 168c8 <__malloc_av_+0x14>
    84dc:	0000e697          	auipc	a3,0xe
    84e0:	3e96a423          	sw	s1,1000(a3) # 168c4 <__malloc_av_+0x10>
    84e4:	00176693          	ori	a3,a4,1
    84e8:	0104a623          	sw	a6,12(s1)
    84ec:	0104a423          	sw	a6,8(s1)
    84f0:	00d4a223          	sw	a3,4(s1)
    84f4:	00f407b3          	add	a5,s0,a5
    84f8:	00090513          	mv	a0,s2
    84fc:	00e7a023          	sw	a4,0(a5)
    8500:	209000ef          	jal	ra,8f08 <__malloc_unlock>
    8504:	00840513          	addi	a0,s0,8
    8508:	0100006f          	j	8518 <_malloc_r+0x288>
    850c:	00c00793          	li	a5,12
    8510:	00f92023          	sw	a5,0(s2)
    8514:	00000513          	li	a0,0
    8518:	02c12083          	lw	ra,44(sp)
    851c:	02812403          	lw	s0,40(sp)
    8520:	02412483          	lw	s1,36(sp)
    8524:	02012903          	lw	s2,32(sp)
    8528:	01c12983          	lw	s3,28(sp)
    852c:	01812a03          	lw	s4,24(sp)
    8530:	01412a83          	lw	s5,20(sp)
    8534:	01012b03          	lw	s6,16(sp)
    8538:	00c12b83          	lw	s7,12(sp)
    853c:	00812c03          	lw	s8,8(sp)
    8540:	00412c83          	lw	s9,4(sp)
    8544:	03010113          	addi	sp,sp,48
    8548:	00008067          	ret
    854c:	20000693          	li	a3,512
    8550:	04000613          	li	a2,64
    8554:	03f00513          	li	a0,63
    8558:	e19ff06f          	j	8370 <_malloc_r+0xe0>
    855c:	00c7a403          	lw	s0,12(a5)
    8560:	00260613          	addi	a2,a2,2
    8564:	d8879ee3          	bne	a5,s0,8300 <_malloc_r+0x70>
    8568:	0109a403          	lw	s0,16(s3)
    856c:	0000e817          	auipc	a6,0xe
    8570:	35080813          	addi	a6,a6,848 # 168bc <__malloc_av_+0x8>
    8574:	e5041ce3          	bne	s0,a6,83cc <_malloc_r+0x13c>
    8578:	0049a703          	lw	a4,4(s3)
    857c:	40265793          	srai	a5,a2,0x2
    8580:	00100693          	li	a3,1
    8584:	00f696b3          	sll	a3,a3,a5
    8588:	ecd774e3          	bgeu	a4,a3,8450 <_malloc_r+0x1c0>
    858c:	0089a403          	lw	s0,8(s3)
    8590:	00442a83          	lw	s5,4(s0)
    8594:	ffcafb93          	andi	s7,s5,-4
    8598:	009be863          	bltu	s7,s1,85a8 <_malloc_r+0x318>
    859c:	409b87b3          	sub	a5,s7,s1
    85a0:	00f00713          	li	a4,15
    85a4:	14f74863          	blt	a4,a5,86f4 <_malloc_r+0x464>
    85a8:	83818793          	addi	a5,gp,-1992 # 16ce8 <__malloc_top_pad>
    85ac:	81418c13          	addi	s8,gp,-2028 # 16cc4 <__malloc_sbrk_base>
    85b0:	0007aa83          	lw	s5,0(a5)
    85b4:	000c2703          	lw	a4,0(s8)
    85b8:	fff00793          	li	a5,-1
    85bc:	01740a33          	add	s4,s0,s7
    85c0:	01548ab3          	add	s5,s1,s5
    85c4:	34f70663          	beq	a4,a5,8910 <_malloc_r+0x680>
    85c8:	000017b7          	lui	a5,0x1
    85cc:	00f78793          	addi	a5,a5,15 # 100f <init+0x7>
    85d0:	00fa8ab3          	add	s5,s5,a5
    85d4:	fffff7b7          	lui	a5,0xfffff
    85d8:	00fafab3          	and	s5,s5,a5
    85dc:	000a8593          	mv	a1,s5
    85e0:	00090513          	mv	a0,s2
    85e4:	70d010ef          	jal	ra,a4f0 <_sbrk_r>
    85e8:	fff00793          	li	a5,-1
    85ec:	00050b13          	mv	s6,a0
    85f0:	28f50663          	beq	a0,a5,887c <_malloc_r+0x5ec>
    85f4:	29456263          	bltu	a0,s4,8878 <_malloc_r+0x5e8>
    85f8:	84018c93          	addi	s9,gp,-1984 # 16cf0 <__malloc_current_mallinfo>
    85fc:	000ca783          	lw	a5,0(s9)
    8600:	00fa87b3          	add	a5,s5,a5
    8604:	84f1a023          	sw	a5,-1984(gp) # 16cf0 <__malloc_current_mallinfo>
    8608:	00078713          	mv	a4,a5
    860c:	3aaa0663          	beq	s4,a0,89b8 <_malloc_r+0x728>
    8610:	000c2683          	lw	a3,0(s8)
    8614:	fff00793          	li	a5,-1
    8618:	3af68e63          	beq	a3,a5,89d4 <_malloc_r+0x744>
    861c:	414b07b3          	sub	a5,s6,s4
    8620:	00e787b3          	add	a5,a5,a4
    8624:	84f1a023          	sw	a5,-1984(gp) # 16cf0 <__malloc_current_mallinfo>
    8628:	007b7c13          	andi	s8,s6,7
    862c:	300c0663          	beqz	s8,8938 <_malloc_r+0x6a8>
    8630:	418b0b33          	sub	s6,s6,s8
    8634:	000017b7          	lui	a5,0x1
    8638:	008b0b13          	addi	s6,s6,8
    863c:	fff78a13          	addi	s4,a5,-1 # fff <__stack_size-0x1>
    8640:	015b0ab3          	add	s5,s6,s5
    8644:	00878793          	addi	a5,a5,8
    8648:	014af733          	and	a4,s5,s4
    864c:	418787b3          	sub	a5,a5,s8
    8650:	40e787b3          	sub	a5,a5,a4
    8654:	0147fa33          	and	s4,a5,s4
    8658:	000a0593          	mv	a1,s4
    865c:	00090513          	mv	a0,s2
    8660:	691010ef          	jal	ra,a4f0 <_sbrk_r>
    8664:	fff00793          	li	a5,-1
    8668:	3cf50063          	beq	a0,a5,8a28 <_malloc_r+0x798>
    866c:	41650533          	sub	a0,a0,s6
    8670:	01450ab3          	add	s5,a0,s4
    8674:	000ca783          	lw	a5,0(s9)
    8678:	0000e717          	auipc	a4,0xe
    867c:	25672223          	sw	s6,580(a4) # 168bc <__malloc_av_+0x8>
    8680:	001aea93          	ori	s5,s5,1
    8684:	00fa07b3          	add	a5,s4,a5
    8688:	84f1a023          	sw	a5,-1984(gp) # 16cf0 <__malloc_current_mallinfo>
    868c:	015b2223          	sw	s5,4(s6)
    8690:	35340663          	beq	s0,s3,89dc <_malloc_r+0x74c>
    8694:	00f00613          	li	a2,15
    8698:	35767663          	bgeu	a2,s7,89e4 <_malloc_r+0x754>
    869c:	00442683          	lw	a3,4(s0)
    86a0:	ff4b8713          	addi	a4,s7,-12
    86a4:	ff877713          	andi	a4,a4,-8
    86a8:	0016f693          	andi	a3,a3,1
    86ac:	00e6e6b3          	or	a3,a3,a4
    86b0:	00d42223          	sw	a3,4(s0)
    86b4:	00500593          	li	a1,5
    86b8:	00e406b3          	add	a3,s0,a4
    86bc:	00b6a223          	sw	a1,4(a3)
    86c0:	00b6a423          	sw	a1,8(a3)
    86c4:	36e66c63          	bltu	a2,a4,8a3c <_malloc_r+0x7ac>
    86c8:	004b2a83          	lw	s5,4(s6)
    86cc:	000b0413          	mv	s0,s6
    86d0:	83018713          	addi	a4,gp,-2000 # 16ce0 <__malloc_max_sbrked_mem>
    86d4:	00072703          	lw	a4,0(a4)
    86d8:	00f77463          	bgeu	a4,a5,86e0 <_malloc_r+0x450>
    86dc:	82f1a823          	sw	a5,-2000(gp) # 16ce0 <__malloc_max_sbrked_mem>
    86e0:	83418713          	addi	a4,gp,-1996 # 16ce4 <__malloc_max_total_mem>
    86e4:	00072703          	lw	a4,0(a4)
    86e8:	18f77e63          	bgeu	a4,a5,8884 <_malloc_r+0x5f4>
    86ec:	82f1aa23          	sw	a5,-1996(gp) # 16ce4 <__malloc_max_total_mem>
    86f0:	1940006f          	j	8884 <_malloc_r+0x5f4>
    86f4:	0014e713          	ori	a4,s1,1
    86f8:	00e42223          	sw	a4,4(s0)
    86fc:	009404b3          	add	s1,s0,s1
    8700:	0000e717          	auipc	a4,0xe
    8704:	1a972e23          	sw	s1,444(a4) # 168bc <__malloc_av_+0x8>
    8708:	0017e793          	ori	a5,a5,1
    870c:	00090513          	mv	a0,s2
    8710:	00f4a223          	sw	a5,4(s1)
    8714:	7f4000ef          	jal	ra,8f08 <__malloc_unlock>
    8718:	00840513          	addi	a0,s0,8
    871c:	dfdff06f          	j	8518 <_malloc_r+0x288>
    8720:	00c42683          	lw	a3,12(s0)
    8724:	00842603          	lw	a2,8(s0)
    8728:	be9ff06f          	j	8310 <_malloc_r+0x80>
    872c:	0095d793          	srli	a5,a1,0x9
    8730:	00400713          	li	a4,4
    8734:	12f77863          	bgeu	a4,a5,8864 <_malloc_r+0x5d4>
    8738:	01400713          	li	a4,20
    873c:	22f76863          	bltu	a4,a5,896c <_malloc_r+0x6dc>
    8740:	05c78693          	addi	a3,a5,92
    8744:	05b78713          	addi	a4,a5,91
    8748:	00369693          	slli	a3,a3,0x3
    874c:	00d986b3          	add	a3,s3,a3
    8750:	0006a783          	lw	a5,0(a3)
    8754:	ff868693          	addi	a3,a3,-8
    8758:	1cf68063          	beq	a3,a5,8918 <_malloc_r+0x688>
    875c:	0047a703          	lw	a4,4(a5)
    8760:	ffc77713          	andi	a4,a4,-4
    8764:	00e5f663          	bgeu	a1,a4,8770 <_malloc_r+0x4e0>
    8768:	0087a783          	lw	a5,8(a5)
    876c:	fef698e3          	bne	a3,a5,875c <_malloc_r+0x4cc>
    8770:	00c7a683          	lw	a3,12(a5)
    8774:	0049a703          	lw	a4,4(s3)
    8778:	00d42623          	sw	a3,12(s0)
    877c:	00f42423          	sw	a5,8(s0)
    8780:	0086a423          	sw	s0,8(a3)
    8784:	0087a623          	sw	s0,12(a5)
    8788:	cb9ff06f          	j	8440 <_malloc_r+0x1b0>
    878c:	01400713          	li	a4,20
    8790:	10f77c63          	bgeu	a4,a5,88a8 <_malloc_r+0x618>
    8794:	05400713          	li	a4,84
    8798:	1ef76863          	bltu	a4,a5,8988 <_malloc_r+0x6f8>
    879c:	00c4d793          	srli	a5,s1,0xc
    87a0:	06f78613          	addi	a2,a5,111
    87a4:	06e78513          	addi	a0,a5,110
    87a8:	00361693          	slli	a3,a2,0x3
    87ac:	bc5ff06f          	j	8370 <_malloc_r+0xe0>
    87b0:	00130313          	addi	t1,t1,1
    87b4:	00337793          	andi	a5,t1,3
    87b8:	00858593          	addi	a1,a1,8
    87bc:	cc079ae3          	bnez	a5,8490 <_malloc_r+0x200>
    87c0:	1040006f          	j	88c4 <_malloc_r+0x634>
    87c4:	00f407b3          	add	a5,s0,a5
    87c8:	0047a703          	lw	a4,4(a5)
    87cc:	00c42683          	lw	a3,12(s0)
    87d0:	00842603          	lw	a2,8(s0)
    87d4:	00176713          	ori	a4,a4,1
    87d8:	00e7a223          	sw	a4,4(a5)
    87dc:	00d62623          	sw	a3,12(a2)
    87e0:	00090513          	mv	a0,s2
    87e4:	00c6a423          	sw	a2,8(a3)
    87e8:	720000ef          	jal	ra,8f08 <__malloc_unlock>
    87ec:	00840513          	addi	a0,s0,8
    87f0:	d29ff06f          	j	8518 <_malloc_r+0x288>
    87f4:	0034d613          	srli	a2,s1,0x3
    87f8:	00848793          	addi	a5,s1,8
    87fc:	aedff06f          	j	82e8 <_malloc_r+0x58>
    8800:	00b405b3          	add	a1,s0,a1
    8804:	0045a783          	lw	a5,4(a1)
    8808:	00090513          	mv	a0,s2
    880c:	0017e793          	ori	a5,a5,1
    8810:	00f5a223          	sw	a5,4(a1)
    8814:	6f4000ef          	jal	ra,8f08 <__malloc_unlock>
    8818:	00840513          	addi	a0,s0,8
    881c:	cfdff06f          	j	8518 <_malloc_r+0x288>
    8820:	0014e713          	ori	a4,s1,1
    8824:	00e42223          	sw	a4,4(s0)
    8828:	009404b3          	add	s1,s0,s1
    882c:	0000e717          	auipc	a4,0xe
    8830:	08972e23          	sw	s1,156(a4) # 168c8 <__malloc_av_+0x14>
    8834:	0000e717          	auipc	a4,0xe
    8838:	08972823          	sw	s1,144(a4) # 168c4 <__malloc_av_+0x10>
    883c:	0017e713          	ori	a4,a5,1
    8840:	0104a623          	sw	a6,12(s1)
    8844:	0104a423          	sw	a6,8(s1)
    8848:	00e4a223          	sw	a4,4(s1)
    884c:	00b405b3          	add	a1,s0,a1
    8850:	00090513          	mv	a0,s2
    8854:	00f5a023          	sw	a5,0(a1)
    8858:	6b0000ef          	jal	ra,8f08 <__malloc_unlock>
    885c:	00840513          	addi	a0,s0,8
    8860:	cb9ff06f          	j	8518 <_malloc_r+0x288>
    8864:	0065d793          	srli	a5,a1,0x6
    8868:	03978693          	addi	a3,a5,57
    886c:	03878713          	addi	a4,a5,56
    8870:	00369693          	slli	a3,a3,0x3
    8874:	ed9ff06f          	j	874c <_malloc_r+0x4bc>
    8878:	13340663          	beq	s0,s3,89a4 <_malloc_r+0x714>
    887c:	0089a403          	lw	s0,8(s3)
    8880:	00442a83          	lw	s5,4(s0)
    8884:	ffcafa93          	andi	s5,s5,-4
    8888:	409a87b3          	sub	a5,s5,s1
    888c:	009ae663          	bltu	s5,s1,8898 <_malloc_r+0x608>
    8890:	00f00713          	li	a4,15
    8894:	e6f740e3          	blt	a4,a5,86f4 <_malloc_r+0x464>
    8898:	00090513          	mv	a0,s2
    889c:	66c000ef          	jal	ra,8f08 <__malloc_unlock>
    88a0:	00000513          	li	a0,0
    88a4:	c75ff06f          	j	8518 <_malloc_r+0x288>
    88a8:	05c78613          	addi	a2,a5,92
    88ac:	05b78513          	addi	a0,a5,91
    88b0:	00361693          	slli	a3,a2,0x3
    88b4:	abdff06f          	j	8370 <_malloc_r+0xe0>
    88b8:	0088a783          	lw	a5,8(a7)
    88bc:	fff60613          	addi	a2,a2,-1
    88c0:	1d179863          	bne	a5,a7,8a90 <_malloc_r+0x800>
    88c4:	00367793          	andi	a5,a2,3
    88c8:	ff888893          	addi	a7,a7,-8
    88cc:	fe0796e3          	bnez	a5,88b8 <_malloc_r+0x628>
    88d0:	0049a703          	lw	a4,4(s3)
    88d4:	fff6c793          	not	a5,a3
    88d8:	00e7f7b3          	and	a5,a5,a4
    88dc:	0000e717          	auipc	a4,0xe
    88e0:	fcf72e23          	sw	a5,-36(a4) # 168b8 <__malloc_av_+0x4>
    88e4:	00169693          	slli	a3,a3,0x1
    88e8:	cad7e2e3          	bltu	a5,a3,858c <_malloc_r+0x2fc>
    88ec:	ca0680e3          	beqz	a3,858c <_malloc_r+0x2fc>
    88f0:	00f6f733          	and	a4,a3,a5
    88f4:	00071a63          	bnez	a4,8908 <_malloc_r+0x678>
    88f8:	00169693          	slli	a3,a3,0x1
    88fc:	00f6f733          	and	a4,a3,a5
    8900:	00430313          	addi	t1,t1,4
    8904:	fe070ae3          	beqz	a4,88f8 <_malloc_r+0x668>
    8908:	00030613          	mv	a2,t1
    890c:	b75ff06f          	j	8480 <_malloc_r+0x1f0>
    8910:	010a8a93          	addi	s5,s5,16
    8914:	cc9ff06f          	j	85dc <_malloc_r+0x34c>
    8918:	0049a503          	lw	a0,4(s3)
    891c:	40275593          	srai	a1,a4,0x2
    8920:	00100713          	li	a4,1
    8924:	00b71733          	sll	a4,a4,a1
    8928:	00a76733          	or	a4,a4,a0
    892c:	0000e597          	auipc	a1,0xe
    8930:	f8e5a623          	sw	a4,-116(a1) # 168b8 <__malloc_av_+0x4>
    8934:	e45ff06f          	j	8778 <_malloc_r+0x4e8>
    8938:	000017b7          	lui	a5,0x1
    893c:	fff78713          	addi	a4,a5,-1 # fff <__stack_size-0x1>
    8940:	015b0a33          	add	s4,s6,s5
    8944:	00ea7a33          	and	s4,s4,a4
    8948:	414787b3          	sub	a5,a5,s4
    894c:	00e7fa33          	and	s4,a5,a4
    8950:	000a0593          	mv	a1,s4
    8954:	00090513          	mv	a0,s2
    8958:	399010ef          	jal	ra,a4f0 <_sbrk_r>
    895c:	fff00793          	li	a5,-1
    8960:	d0f516e3          	bne	a0,a5,866c <_malloc_r+0x3dc>
    8964:	00000a13          	li	s4,0
    8968:	d0dff06f          	j	8674 <_malloc_r+0x3e4>
    896c:	05400713          	li	a4,84
    8970:	08f76063          	bltu	a4,a5,89f0 <_malloc_r+0x760>
    8974:	00c5d793          	srli	a5,a1,0xc
    8978:	06f78693          	addi	a3,a5,111
    897c:	06e78713          	addi	a4,a5,110
    8980:	00369693          	slli	a3,a3,0x3
    8984:	dc9ff06f          	j	874c <_malloc_r+0x4bc>
    8988:	15400713          	li	a4,340
    898c:	08f76063          	bltu	a4,a5,8a0c <_malloc_r+0x77c>
    8990:	00f4d793          	srli	a5,s1,0xf
    8994:	07878613          	addi	a2,a5,120
    8998:	07778513          	addi	a0,a5,119
    899c:	00361693          	slli	a3,a2,0x3
    89a0:	9d1ff06f          	j	8370 <_malloc_r+0xe0>
    89a4:	84018c93          	addi	s9,gp,-1984 # 16cf0 <__malloc_current_mallinfo>
    89a8:	000ca783          	lw	a5,0(s9)
    89ac:	00fa8733          	add	a4,s5,a5
    89b0:	84e1a023          	sw	a4,-1984(gp) # 16cf0 <__malloc_current_mallinfo>
    89b4:	c5dff06f          	j	8610 <_malloc_r+0x380>
    89b8:	014a1693          	slli	a3,s4,0x14
    89bc:	c4069ae3          	bnez	a3,8610 <_malloc_r+0x380>
    89c0:	0089a403          	lw	s0,8(s3)
    89c4:	015b8ab3          	add	s5,s7,s5
    89c8:	001aea93          	ori	s5,s5,1
    89cc:	01542223          	sw	s5,4(s0)
    89d0:	d01ff06f          	j	86d0 <_malloc_r+0x440>
    89d4:	8161aa23          	sw	s6,-2028(gp) # 16cc4 <__malloc_sbrk_base>
    89d8:	c51ff06f          	j	8628 <_malloc_r+0x398>
    89dc:	000b0413          	mv	s0,s6
    89e0:	cf1ff06f          	j	86d0 <_malloc_r+0x440>
    89e4:	00100793          	li	a5,1
    89e8:	00fb2223          	sw	a5,4(s6)
    89ec:	eadff06f          	j	8898 <_malloc_r+0x608>
    89f0:	15400713          	li	a4,340
    89f4:	06f76263          	bltu	a4,a5,8a58 <_malloc_r+0x7c8>
    89f8:	00f5d793          	srli	a5,a1,0xf
    89fc:	07878693          	addi	a3,a5,120
    8a00:	07778713          	addi	a4,a5,119
    8a04:	00369693          	slli	a3,a3,0x3
    8a08:	d45ff06f          	j	874c <_malloc_r+0x4bc>
    8a0c:	55400713          	li	a4,1364
    8a10:	06f76263          	bltu	a4,a5,8a74 <_malloc_r+0x7e4>
    8a14:	0124d793          	srli	a5,s1,0x12
    8a18:	07d78613          	addi	a2,a5,125
    8a1c:	07c78513          	addi	a0,a5,124
    8a20:	00361693          	slli	a3,a2,0x3
    8a24:	94dff06f          	j	8370 <_malloc_r+0xe0>
    8a28:	ff8c0c13          	addi	s8,s8,-8
    8a2c:	018a8ab3          	add	s5,s5,s8
    8a30:	416a8ab3          	sub	s5,s5,s6
    8a34:	00000a13          	li	s4,0
    8a38:	c3dff06f          	j	8674 <_malloc_r+0x3e4>
    8a3c:	00840593          	addi	a1,s0,8
    8a40:	00090513          	mv	a0,s2
    8a44:	940fc0ef          	jal	ra,4b84 <_free_r>
    8a48:	0089a403          	lw	s0,8(s3)
    8a4c:	000ca783          	lw	a5,0(s9)
    8a50:	00442a83          	lw	s5,4(s0)
    8a54:	c7dff06f          	j	86d0 <_malloc_r+0x440>
    8a58:	55400713          	li	a4,1364
    8a5c:	02f76463          	bltu	a4,a5,8a84 <_malloc_r+0x7f4>
    8a60:	0125d793          	srli	a5,a1,0x12
    8a64:	07d78693          	addi	a3,a5,125
    8a68:	07c78713          	addi	a4,a5,124
    8a6c:	00369693          	slli	a3,a3,0x3
    8a70:	cddff06f          	j	874c <_malloc_r+0x4bc>
    8a74:	3f800693          	li	a3,1016
    8a78:	07f00613          	li	a2,127
    8a7c:	07e00513          	li	a0,126
    8a80:	8f1ff06f          	j	8370 <_malloc_r+0xe0>
    8a84:	3f800693          	li	a3,1016
    8a88:	07e00713          	li	a4,126
    8a8c:	cc1ff06f          	j	874c <_malloc_r+0x4bc>
    8a90:	0049a783          	lw	a5,4(s3)
    8a94:	e51ff06f          	j	88e4 <_malloc_r+0x654>

00008a98 <_mbtowc_r>:
    8a98:	0000e797          	auipc	a5,0xe
    8a9c:	cb078793          	addi	a5,a5,-848 # 16748 <__global_locale>
    8aa0:	0e47a303          	lw	t1,228(a5)
    8aa4:	00030067          	jr	t1

00008aa8 <__ascii_mbtowc>:
    8aa8:	02058063          	beqz	a1,8ac8 <__ascii_mbtowc+0x20>
    8aac:	04060263          	beqz	a2,8af0 <__ascii_mbtowc+0x48>
    8ab0:	04068863          	beqz	a3,8b00 <__ascii_mbtowc+0x58>
    8ab4:	00064783          	lbu	a5,0(a2)
    8ab8:	00f5a023          	sw	a5,0(a1)
    8abc:	00064503          	lbu	a0,0(a2)
    8ac0:	00a03533          	snez	a0,a0
    8ac4:	00008067          	ret
    8ac8:	ff010113          	addi	sp,sp,-16
    8acc:	00c10593          	addi	a1,sp,12
    8ad0:	02060463          	beqz	a2,8af8 <__ascii_mbtowc+0x50>
    8ad4:	02068a63          	beqz	a3,8b08 <__ascii_mbtowc+0x60>
    8ad8:	00064783          	lbu	a5,0(a2)
    8adc:	00f5a023          	sw	a5,0(a1)
    8ae0:	00064503          	lbu	a0,0(a2)
    8ae4:	00a03533          	snez	a0,a0
    8ae8:	01010113          	addi	sp,sp,16
    8aec:	00008067          	ret
    8af0:	00000513          	li	a0,0
    8af4:	00008067          	ret
    8af8:	00000513          	li	a0,0
    8afc:	fedff06f          	j	8ae8 <__ascii_mbtowc+0x40>
    8b00:	ffe00513          	li	a0,-2
    8b04:	00008067          	ret
    8b08:	ffe00513          	li	a0,-2
    8b0c:	fddff06f          	j	8ae8 <__ascii_mbtowc+0x40>

00008b10 <memchr>:
    8b10:	00357793          	andi	a5,a0,3
    8b14:	0ff5f813          	andi	a6,a1,255
    8b18:	0c078663          	beqz	a5,8be4 <memchr+0xd4>
    8b1c:	fff60793          	addi	a5,a2,-1
    8b20:	04060e63          	beqz	a2,8b7c <memchr+0x6c>
    8b24:	00054703          	lbu	a4,0(a0)
    8b28:	05070c63          	beq	a4,a6,8b80 <memchr+0x70>
    8b2c:	fff00693          	li	a3,-1
    8b30:	0140006f          	j	8b44 <memchr+0x34>
    8b34:	fff78793          	addi	a5,a5,-1
    8b38:	04d78263          	beq	a5,a3,8b7c <memchr+0x6c>
    8b3c:	00054703          	lbu	a4,0(a0)
    8b40:	05070063          	beq	a4,a6,8b80 <memchr+0x70>
    8b44:	00150513          	addi	a0,a0,1
    8b48:	00357713          	andi	a4,a0,3
    8b4c:	fe0714e3          	bnez	a4,8b34 <memchr+0x24>
    8b50:	00300713          	li	a4,3
    8b54:	02f76863          	bltu	a4,a5,8b84 <memchr+0x74>
    8b58:	02078263          	beqz	a5,8b7c <memchr+0x6c>
    8b5c:	00054703          	lbu	a4,0(a0)
    8b60:	03070063          	beq	a4,a6,8b80 <memchr+0x70>
    8b64:	00f507b3          	add	a5,a0,a5
    8b68:	00c0006f          	j	8b74 <memchr+0x64>
    8b6c:	00054703          	lbu	a4,0(a0)
    8b70:	01070863          	beq	a4,a6,8b80 <memchr+0x70>
    8b74:	00150513          	addi	a0,a0,1
    8b78:	fea79ae3          	bne	a5,a0,8b6c <memchr+0x5c>
    8b7c:	00000513          	li	a0,0
    8b80:	00008067          	ret
    8b84:	00010737          	lui	a4,0x10
    8b88:	00859893          	slli	a7,a1,0x8
    8b8c:	fff70713          	addi	a4,a4,-1 # ffff <_svfiprintf_r+0xce7>
    8b90:	00e8f8b3          	and	a7,a7,a4
    8b94:	0ff5f593          	andi	a1,a1,255
    8b98:	00b8e5b3          	or	a1,a7,a1
    8b9c:	01059893          	slli	a7,a1,0x10
    8ba0:	00b8e8b3          	or	a7,a7,a1
    8ba4:	80808637          	lui	a2,0x80808
    8ba8:	feff05b7          	lui	a1,0xfeff0
    8bac:	eff58593          	addi	a1,a1,-257 # fefefeff <__freertos_irq_stack_top+0xfefd81df>
    8bb0:	08060613          	addi	a2,a2,128 # 80808080 <__freertos_irq_stack_top+0x807f0360>
    8bb4:	00300313          	li	t1,3
    8bb8:	00052703          	lw	a4,0(a0)
    8bbc:	00e8c733          	xor	a4,a7,a4
    8bc0:	00b706b3          	add	a3,a4,a1
    8bc4:	fff74713          	not	a4,a4
    8bc8:	00e6f733          	and	a4,a3,a4
    8bcc:	00c77733          	and	a4,a4,a2
    8bd0:	f80716e3          	bnez	a4,8b5c <memchr+0x4c>
    8bd4:	ffc78793          	addi	a5,a5,-4
    8bd8:	00450513          	addi	a0,a0,4
    8bdc:	fcf36ee3          	bltu	t1,a5,8bb8 <memchr+0xa8>
    8be0:	f79ff06f          	j	8b58 <memchr+0x48>
    8be4:	00060793          	mv	a5,a2
    8be8:	f69ff06f          	j	8b50 <memchr+0x40>

00008bec <memcpy>:
    8bec:	00a5c7b3          	xor	a5,a1,a0
    8bf0:	0037f793          	andi	a5,a5,3
    8bf4:	00c508b3          	add	a7,a0,a2
    8bf8:	06079263          	bnez	a5,8c5c <memcpy+0x70>
    8bfc:	00300793          	li	a5,3
    8c00:	04c7fe63          	bgeu	a5,a2,8c5c <memcpy+0x70>
    8c04:	00357793          	andi	a5,a0,3
    8c08:	00050713          	mv	a4,a0
    8c0c:	06079863          	bnez	a5,8c7c <memcpy+0x90>
    8c10:	ffc8f613          	andi	a2,a7,-4
    8c14:	fe060793          	addi	a5,a2,-32
    8c18:	08f76c63          	bltu	a4,a5,8cb0 <memcpy+0xc4>
    8c1c:	02c77c63          	bgeu	a4,a2,8c54 <memcpy+0x68>
    8c20:	00058693          	mv	a3,a1
    8c24:	00070793          	mv	a5,a4
    8c28:	0006a803          	lw	a6,0(a3)
    8c2c:	00478793          	addi	a5,a5,4
    8c30:	00468693          	addi	a3,a3,4
    8c34:	ff07ae23          	sw	a6,-4(a5)
    8c38:	fec7e8e3          	bltu	a5,a2,8c28 <memcpy+0x3c>
    8c3c:	fff60793          	addi	a5,a2,-1
    8c40:	40e787b3          	sub	a5,a5,a4
    8c44:	ffc7f793          	andi	a5,a5,-4
    8c48:	00478793          	addi	a5,a5,4
    8c4c:	00f70733          	add	a4,a4,a5
    8c50:	00f585b3          	add	a1,a1,a5
    8c54:	01176863          	bltu	a4,a7,8c64 <memcpy+0x78>
    8c58:	00008067          	ret
    8c5c:	00050713          	mv	a4,a0
    8c60:	ff157ce3          	bgeu	a0,a7,8c58 <memcpy+0x6c>
    8c64:	0005c783          	lbu	a5,0(a1)
    8c68:	00170713          	addi	a4,a4,1
    8c6c:	00158593          	addi	a1,a1,1
    8c70:	fef70fa3          	sb	a5,-1(a4)
    8c74:	ff1768e3          	bltu	a4,a7,8c64 <memcpy+0x78>
    8c78:	00008067          	ret
    8c7c:	0005c683          	lbu	a3,0(a1)
    8c80:	00170713          	addi	a4,a4,1
    8c84:	00377793          	andi	a5,a4,3
    8c88:	fed70fa3          	sb	a3,-1(a4)
    8c8c:	00158593          	addi	a1,a1,1
    8c90:	f80780e3          	beqz	a5,8c10 <memcpy+0x24>
    8c94:	0005c683          	lbu	a3,0(a1)
    8c98:	00170713          	addi	a4,a4,1
    8c9c:	00377793          	andi	a5,a4,3
    8ca0:	fed70fa3          	sb	a3,-1(a4)
    8ca4:	00158593          	addi	a1,a1,1
    8ca8:	fc079ae3          	bnez	a5,8c7c <memcpy+0x90>
    8cac:	f65ff06f          	j	8c10 <memcpy+0x24>
    8cb0:	0005a683          	lw	a3,0(a1)
    8cb4:	0045a283          	lw	t0,4(a1)
    8cb8:	0085af83          	lw	t6,8(a1)
    8cbc:	00c5af03          	lw	t5,12(a1)
    8cc0:	0105ae83          	lw	t4,16(a1)
    8cc4:	0145ae03          	lw	t3,20(a1)
    8cc8:	0185a303          	lw	t1,24(a1)
    8ccc:	01c5a803          	lw	a6,28(a1)
    8cd0:	02458593          	addi	a1,a1,36
    8cd4:	00d72023          	sw	a3,0(a4)
    8cd8:	ffc5a683          	lw	a3,-4(a1)
    8cdc:	00572223          	sw	t0,4(a4)
    8ce0:	01f72423          	sw	t6,8(a4)
    8ce4:	01e72623          	sw	t5,12(a4)
    8ce8:	01d72823          	sw	t4,16(a4)
    8cec:	01c72a23          	sw	t3,20(a4)
    8cf0:	00672c23          	sw	t1,24(a4)
    8cf4:	01072e23          	sw	a6,28(a4)
    8cf8:	02470713          	addi	a4,a4,36
    8cfc:	fed72e23          	sw	a3,-4(a4)
    8d00:	faf768e3          	bltu	a4,a5,8cb0 <memcpy+0xc4>
    8d04:	f19ff06f          	j	8c1c <memcpy+0x30>

00008d08 <memmove>:
    8d08:	02a5f663          	bgeu	a1,a0,8d34 <memmove+0x2c>
    8d0c:	00c587b3          	add	a5,a1,a2
    8d10:	02f57263          	bgeu	a0,a5,8d34 <memmove+0x2c>
    8d14:	00c50733          	add	a4,a0,a2
    8d18:	0e060a63          	beqz	a2,8e0c <memmove+0x104>
    8d1c:	fff78793          	addi	a5,a5,-1
    8d20:	0007c683          	lbu	a3,0(a5)
    8d24:	fff70713          	addi	a4,a4,-1
    8d28:	00d70023          	sb	a3,0(a4)
    8d2c:	fef598e3          	bne	a1,a5,8d1c <memmove+0x14>
    8d30:	00008067          	ret
    8d34:	00f00793          	li	a5,15
    8d38:	02c7e863          	bltu	a5,a2,8d68 <memmove+0x60>
    8d3c:	00050793          	mv	a5,a0
    8d40:	fff60693          	addi	a3,a2,-1
    8d44:	0c060c63          	beqz	a2,8e1c <memmove+0x114>
    8d48:	00168693          	addi	a3,a3,1
    8d4c:	00d786b3          	add	a3,a5,a3
    8d50:	00158593          	addi	a1,a1,1
    8d54:	fff5c703          	lbu	a4,-1(a1)
    8d58:	00178793          	addi	a5,a5,1
    8d5c:	fee78fa3          	sb	a4,-1(a5)
    8d60:	fed798e3          	bne	a5,a3,8d50 <memmove+0x48>
    8d64:	00008067          	ret
    8d68:	00a5e7b3          	or	a5,a1,a0
    8d6c:	0037f793          	andi	a5,a5,3
    8d70:	0a079063          	bnez	a5,8e10 <memmove+0x108>
    8d74:	ff060893          	addi	a7,a2,-16
    8d78:	ff08f893          	andi	a7,a7,-16
    8d7c:	01088893          	addi	a7,a7,16
    8d80:	01150833          	add	a6,a0,a7
    8d84:	00058713          	mv	a4,a1
    8d88:	00050793          	mv	a5,a0
    8d8c:	00072683          	lw	a3,0(a4)
    8d90:	01078793          	addi	a5,a5,16
    8d94:	01070713          	addi	a4,a4,16
    8d98:	fed7a823          	sw	a3,-16(a5)
    8d9c:	ff472683          	lw	a3,-12(a4)
    8da0:	fed7aa23          	sw	a3,-12(a5)
    8da4:	ff872683          	lw	a3,-8(a4)
    8da8:	fed7ac23          	sw	a3,-8(a5)
    8dac:	ffc72683          	lw	a3,-4(a4)
    8db0:	fed7ae23          	sw	a3,-4(a5)
    8db4:	fcf81ce3          	bne	a6,a5,8d8c <memmove+0x84>
    8db8:	00c67713          	andi	a4,a2,12
    8dbc:	011585b3          	add	a1,a1,a7
    8dc0:	00f67813          	andi	a6,a2,15
    8dc4:	04070e63          	beqz	a4,8e20 <memmove+0x118>
    8dc8:	00058713          	mv	a4,a1
    8dcc:	00078893          	mv	a7,a5
    8dd0:	00300e13          	li	t3,3
    8dd4:	00470713          	addi	a4,a4,4
    8dd8:	ffc72303          	lw	t1,-4(a4)
    8ddc:	00488893          	addi	a7,a7,4
    8de0:	40e806b3          	sub	a3,a6,a4
    8de4:	fe68ae23          	sw	t1,-4(a7)
    8de8:	00d586b3          	add	a3,a1,a3
    8dec:	fede64e3          	bltu	t3,a3,8dd4 <memmove+0xcc>
    8df0:	ffc80713          	addi	a4,a6,-4
    8df4:	ffc77713          	andi	a4,a4,-4
    8df8:	00470713          	addi	a4,a4,4
    8dfc:	00367613          	andi	a2,a2,3
    8e00:	00e787b3          	add	a5,a5,a4
    8e04:	00e585b3          	add	a1,a1,a4
    8e08:	f39ff06f          	j	8d40 <memmove+0x38>
    8e0c:	00008067          	ret
    8e10:	fff60693          	addi	a3,a2,-1
    8e14:	00050793          	mv	a5,a0
    8e18:	f31ff06f          	j	8d48 <memmove+0x40>
    8e1c:	00008067          	ret
    8e20:	00080613          	mv	a2,a6
    8e24:	f1dff06f          	j	8d40 <memmove+0x38>

00008e28 <memset>:
    8e28:	00f00313          	li	t1,15
    8e2c:	00050713          	mv	a4,a0
    8e30:	02c37e63          	bgeu	t1,a2,8e6c <memset+0x44>
    8e34:	00f77793          	andi	a5,a4,15
    8e38:	0a079063          	bnez	a5,8ed8 <memset+0xb0>
    8e3c:	08059263          	bnez	a1,8ec0 <memset+0x98>
    8e40:	ff067693          	andi	a3,a2,-16
    8e44:	00f67613          	andi	a2,a2,15
    8e48:	00e686b3          	add	a3,a3,a4
    8e4c:	00b72023          	sw	a1,0(a4)
    8e50:	00b72223          	sw	a1,4(a4)
    8e54:	00b72423          	sw	a1,8(a4)
    8e58:	00b72623          	sw	a1,12(a4)
    8e5c:	01070713          	addi	a4,a4,16
    8e60:	fed766e3          	bltu	a4,a3,8e4c <memset+0x24>
    8e64:	00061463          	bnez	a2,8e6c <memset+0x44>
    8e68:	00008067          	ret
    8e6c:	40c306b3          	sub	a3,t1,a2
    8e70:	00269693          	slli	a3,a3,0x2
    8e74:	00000297          	auipc	t0,0x0
    8e78:	005686b3          	add	a3,a3,t0
    8e7c:	00c68067          	jr	12(a3)
    8e80:	00b70723          	sb	a1,14(a4)
    8e84:	00b706a3          	sb	a1,13(a4)
    8e88:	00b70623          	sb	a1,12(a4)
    8e8c:	00b705a3          	sb	a1,11(a4)
    8e90:	00b70523          	sb	a1,10(a4)
    8e94:	00b704a3          	sb	a1,9(a4)
    8e98:	00b70423          	sb	a1,8(a4)
    8e9c:	00b703a3          	sb	a1,7(a4)
    8ea0:	00b70323          	sb	a1,6(a4)
    8ea4:	00b702a3          	sb	a1,5(a4)
    8ea8:	00b70223          	sb	a1,4(a4)
    8eac:	00b701a3          	sb	a1,3(a4)
    8eb0:	00b70123          	sb	a1,2(a4)
    8eb4:	00b700a3          	sb	a1,1(a4)
    8eb8:	00b70023          	sb	a1,0(a4)
    8ebc:	00008067          	ret
    8ec0:	0ff5f593          	andi	a1,a1,255
    8ec4:	00859693          	slli	a3,a1,0x8
    8ec8:	00d5e5b3          	or	a1,a1,a3
    8ecc:	01059693          	slli	a3,a1,0x10
    8ed0:	00d5e5b3          	or	a1,a1,a3
    8ed4:	f6dff06f          	j	8e40 <memset+0x18>
    8ed8:	00279693          	slli	a3,a5,0x2
    8edc:	00000297          	auipc	t0,0x0
    8ee0:	005686b3          	add	a3,a3,t0
    8ee4:	00008293          	mv	t0,ra
    8ee8:	fa0680e7          	jalr	-96(a3)
    8eec:	00028093          	mv	ra,t0
    8ef0:	ff078793          	addi	a5,a5,-16
    8ef4:	40f70733          	sub	a4,a4,a5
    8ef8:	00f60633          	add	a2,a2,a5
    8efc:	f6c378e3          	bgeu	t1,a2,8e6c <memset+0x44>
    8f00:	f3dff06f          	j	8e3c <memset+0x14>

00008f04 <__malloc_lock>:
    8f04:	00008067          	ret

00008f08 <__malloc_unlock>:
    8f08:	00008067          	ret

00008f0c <_Balloc>:
    8f0c:	04c52783          	lw	a5,76(a0)
    8f10:	ff010113          	addi	sp,sp,-16
    8f14:	00812423          	sw	s0,8(sp)
    8f18:	00912223          	sw	s1,4(sp)
    8f1c:	00112623          	sw	ra,12(sp)
    8f20:	01212023          	sw	s2,0(sp)
    8f24:	00050413          	mv	s0,a0
    8f28:	00058493          	mv	s1,a1
    8f2c:	02078e63          	beqz	a5,8f68 <_Balloc+0x5c>
    8f30:	00249713          	slli	a4,s1,0x2
    8f34:	00e787b3          	add	a5,a5,a4
    8f38:	0007a503          	lw	a0,0(a5)
    8f3c:	04050663          	beqz	a0,8f88 <_Balloc+0x7c>
    8f40:	00052703          	lw	a4,0(a0)
    8f44:	00e7a023          	sw	a4,0(a5)
    8f48:	00052823          	sw	zero,16(a0)
    8f4c:	00052623          	sw	zero,12(a0)
    8f50:	00c12083          	lw	ra,12(sp)
    8f54:	00812403          	lw	s0,8(sp)
    8f58:	00412483          	lw	s1,4(sp)
    8f5c:	00012903          	lw	s2,0(sp)
    8f60:	01010113          	addi	sp,sp,16
    8f64:	00008067          	ret
    8f68:	02100613          	li	a2,33
    8f6c:	00400593          	li	a1,4
    8f70:	32d050ef          	jal	ra,ea9c <_calloc_r>
    8f74:	04a42623          	sw	a0,76(s0)
    8f78:	00050793          	mv	a5,a0
    8f7c:	fa051ae3          	bnez	a0,8f30 <_Balloc+0x24>
    8f80:	00000513          	li	a0,0
    8f84:	fcdff06f          	j	8f50 <_Balloc+0x44>
    8f88:	00100913          	li	s2,1
    8f8c:	00991933          	sll	s2,s2,s1
    8f90:	00590613          	addi	a2,s2,5
    8f94:	00261613          	slli	a2,a2,0x2
    8f98:	00100593          	li	a1,1
    8f9c:	00040513          	mv	a0,s0
    8fa0:	2fd050ef          	jal	ra,ea9c <_calloc_r>
    8fa4:	fc050ee3          	beqz	a0,8f80 <_Balloc+0x74>
    8fa8:	00952223          	sw	s1,4(a0)
    8fac:	01252423          	sw	s2,8(a0)
    8fb0:	f99ff06f          	j	8f48 <_Balloc+0x3c>

00008fb4 <_Bfree>:
    8fb4:	02058063          	beqz	a1,8fd4 <_Bfree+0x20>
    8fb8:	0045a703          	lw	a4,4(a1)
    8fbc:	04c52783          	lw	a5,76(a0)
    8fc0:	00271713          	slli	a4,a4,0x2
    8fc4:	00e787b3          	add	a5,a5,a4
    8fc8:	0007a703          	lw	a4,0(a5)
    8fcc:	00e5a023          	sw	a4,0(a1)
    8fd0:	00b7a023          	sw	a1,0(a5)
    8fd4:	00008067          	ret

00008fd8 <__multadd>:
    8fd8:	fd010113          	addi	sp,sp,-48
    8fdc:	00010837          	lui	a6,0x10
    8fe0:	02812423          	sw	s0,40(sp)
    8fe4:	02912223          	sw	s1,36(sp)
    8fe8:	03212023          	sw	s2,32(sp)
    8fec:	00058493          	mv	s1,a1
    8ff0:	0105a403          	lw	s0,16(a1)
    8ff4:	00050913          	mv	s2,a0
    8ff8:	02112623          	sw	ra,44(sp)
    8ffc:	01312e23          	sw	s3,28(sp)
    9000:	01458593          	addi	a1,a1,20
    9004:	00000513          	li	a0,0
    9008:	fff80813          	addi	a6,a6,-1 # ffff <_svfiprintf_r+0xce7>
    900c:	0005a783          	lw	a5,0(a1)
    9010:	00458593          	addi	a1,a1,4
    9014:	00150513          	addi	a0,a0,1
    9018:	0107f733          	and	a4,a5,a6
    901c:	02c70733          	mul	a4,a4,a2
    9020:	0107d793          	srli	a5,a5,0x10
    9024:	02c787b3          	mul	a5,a5,a2
    9028:	00d706b3          	add	a3,a4,a3
    902c:	0106d893          	srli	a7,a3,0x10
    9030:	0106f733          	and	a4,a3,a6
    9034:	011786b3          	add	a3,a5,a7
    9038:	01069793          	slli	a5,a3,0x10
    903c:	00e78733          	add	a4,a5,a4
    9040:	fee5ae23          	sw	a4,-4(a1)
    9044:	0106d693          	srli	a3,a3,0x10
    9048:	fc8542e3          	blt	a0,s0,900c <__multadd+0x34>
    904c:	02068263          	beqz	a3,9070 <__multadd+0x98>
    9050:	0084a783          	lw	a5,8(s1)
    9054:	02f45e63          	bge	s0,a5,9090 <__multadd+0xb8>
    9058:	00440793          	addi	a5,s0,4
    905c:	00279793          	slli	a5,a5,0x2
    9060:	00f487b3          	add	a5,s1,a5
    9064:	00d7a223          	sw	a3,4(a5)
    9068:	00140413          	addi	s0,s0,1
    906c:	0084a823          	sw	s0,16(s1)
    9070:	02c12083          	lw	ra,44(sp)
    9074:	02812403          	lw	s0,40(sp)
    9078:	00048513          	mv	a0,s1
    907c:	02012903          	lw	s2,32(sp)
    9080:	02412483          	lw	s1,36(sp)
    9084:	01c12983          	lw	s3,28(sp)
    9088:	03010113          	addi	sp,sp,48
    908c:	00008067          	ret
    9090:	0044a583          	lw	a1,4(s1)
    9094:	00090513          	mv	a0,s2
    9098:	00d12623          	sw	a3,12(sp)
    909c:	00158593          	addi	a1,a1,1
    90a0:	e6dff0ef          	jal	ra,8f0c <_Balloc>
    90a4:	0104a603          	lw	a2,16(s1)
    90a8:	00050993          	mv	s3,a0
    90ac:	00c48593          	addi	a1,s1,12
    90b0:	00260613          	addi	a2,a2,2
    90b4:	00c50513          	addi	a0,a0,12
    90b8:	00261613          	slli	a2,a2,0x2
    90bc:	b31ff0ef          	jal	ra,8bec <memcpy>
    90c0:	0044a703          	lw	a4,4(s1)
    90c4:	04c92783          	lw	a5,76(s2)
    90c8:	00c12683          	lw	a3,12(sp)
    90cc:	00271713          	slli	a4,a4,0x2
    90d0:	00e787b3          	add	a5,a5,a4
    90d4:	0007a703          	lw	a4,0(a5)
    90d8:	00e4a023          	sw	a4,0(s1)
    90dc:	0097a023          	sw	s1,0(a5)
    90e0:	00440793          	addi	a5,s0,4
    90e4:	00098493          	mv	s1,s3
    90e8:	00279793          	slli	a5,a5,0x2
    90ec:	00f487b3          	add	a5,s1,a5
    90f0:	00d7a223          	sw	a3,4(a5)
    90f4:	00140413          	addi	s0,s0,1
    90f8:	0084a823          	sw	s0,16(s1)
    90fc:	f75ff06f          	j	9070 <__multadd+0x98>

00009100 <__s2b>:
    9100:	fe010113          	addi	sp,sp,-32
    9104:	00812c23          	sw	s0,24(sp)
    9108:	00912a23          	sw	s1,20(sp)
    910c:	01212823          	sw	s2,16(sp)
    9110:	01312623          	sw	s3,12(sp)
    9114:	01412423          	sw	s4,8(sp)
    9118:	00068913          	mv	s2,a3
    911c:	00900793          	li	a5,9
    9120:	00868693          	addi	a3,a3,8
    9124:	00112e23          	sw	ra,28(sp)
    9128:	01512223          	sw	s5,4(sp)
    912c:	00050993          	mv	s3,a0
    9130:	00058413          	mv	s0,a1
    9134:	00060a13          	mv	s4,a2
    9138:	00070493          	mv	s1,a4
    913c:	02f6c6b3          	div	a3,a3,a5
    9140:	0d27d263          	bge	a5,s2,9204 <__s2b+0x104>
    9144:	00100793          	li	a5,1
    9148:	00000593          	li	a1,0
    914c:	00179793          	slli	a5,a5,0x1
    9150:	00158593          	addi	a1,a1,1
    9154:	fed7cce3          	blt	a5,a3,914c <__s2b+0x4c>
    9158:	00098513          	mv	a0,s3
    915c:	db1ff0ef          	jal	ra,8f0c <_Balloc>
    9160:	00100793          	li	a5,1
    9164:	00f52823          	sw	a5,16(a0)
    9168:	00952a23          	sw	s1,20(a0)
    916c:	00900793          	li	a5,9
    9170:	0947d463          	bge	a5,s4,91f8 <__s2b+0xf8>
    9174:	00940a93          	addi	s5,s0,9
    9178:	000a8493          	mv	s1,s5
    917c:	01440433          	add	s0,s0,s4
    9180:	00148493          	addi	s1,s1,1
    9184:	fff4c683          	lbu	a3,-1(s1)
    9188:	00050593          	mv	a1,a0
    918c:	00a00613          	li	a2,10
    9190:	fd068693          	addi	a3,a3,-48
    9194:	00098513          	mv	a0,s3
    9198:	e41ff0ef          	jal	ra,8fd8 <__multadd>
    919c:	fe9412e3          	bne	s0,s1,9180 <__s2b+0x80>
    91a0:	ff8a0413          	addi	s0,s4,-8
    91a4:	008a8433          	add	s0,s5,s0
    91a8:	032a5663          	bge	s4,s2,91d4 <__s2b+0xd4>
    91ac:	414904b3          	sub	s1,s2,s4
    91b0:	009404b3          	add	s1,s0,s1
    91b4:	00140413          	addi	s0,s0,1
    91b8:	fff44683          	lbu	a3,-1(s0)
    91bc:	00050593          	mv	a1,a0
    91c0:	00a00613          	li	a2,10
    91c4:	fd068693          	addi	a3,a3,-48
    91c8:	00098513          	mv	a0,s3
    91cc:	e0dff0ef          	jal	ra,8fd8 <__multadd>
    91d0:	fe8492e3          	bne	s1,s0,91b4 <__s2b+0xb4>
    91d4:	01c12083          	lw	ra,28(sp)
    91d8:	01812403          	lw	s0,24(sp)
    91dc:	01412483          	lw	s1,20(sp)
    91e0:	01012903          	lw	s2,16(sp)
    91e4:	00c12983          	lw	s3,12(sp)
    91e8:	00812a03          	lw	s4,8(sp)
    91ec:	00412a83          	lw	s5,4(sp)
    91f0:	02010113          	addi	sp,sp,32
    91f4:	00008067          	ret
    91f8:	00a40413          	addi	s0,s0,10
    91fc:	00900a13          	li	s4,9
    9200:	fa9ff06f          	j	91a8 <__s2b+0xa8>
    9204:	00000593          	li	a1,0
    9208:	f51ff06f          	j	9158 <__s2b+0x58>

0000920c <__hi0bits>:
    920c:	ffff0737          	lui	a4,0xffff0
    9210:	00e57733          	and	a4,a0,a4
    9214:	00050793          	mv	a5,a0
    9218:	00000513          	li	a0,0
    921c:	00071663          	bnez	a4,9228 <__hi0bits+0x1c>
    9220:	01079793          	slli	a5,a5,0x10
    9224:	01000513          	li	a0,16
    9228:	ff000737          	lui	a4,0xff000
    922c:	00e7f733          	and	a4,a5,a4
    9230:	00071663          	bnez	a4,923c <__hi0bits+0x30>
    9234:	00850513          	addi	a0,a0,8
    9238:	00879793          	slli	a5,a5,0x8
    923c:	f0000737          	lui	a4,0xf0000
    9240:	00e7f733          	and	a4,a5,a4
    9244:	00071663          	bnez	a4,9250 <__hi0bits+0x44>
    9248:	00450513          	addi	a0,a0,4
    924c:	00479793          	slli	a5,a5,0x4
    9250:	c0000737          	lui	a4,0xc0000
    9254:	00e7f733          	and	a4,a5,a4
    9258:	00071663          	bnez	a4,9264 <__hi0bits+0x58>
    925c:	00250513          	addi	a0,a0,2
    9260:	00279793          	slli	a5,a5,0x2
    9264:	0007c863          	bltz	a5,9274 <__hi0bits+0x68>
    9268:	00179713          	slli	a4,a5,0x1
    926c:	00150513          	addi	a0,a0,1
    9270:	00075463          	bgez	a4,9278 <__hi0bits+0x6c>
    9274:	00008067          	ret
    9278:	02000513          	li	a0,32
    927c:	00008067          	ret

00009280 <__lo0bits>:
    9280:	00052783          	lw	a5,0(a0)
    9284:	0077f713          	andi	a4,a5,7
    9288:	02070663          	beqz	a4,92b4 <__lo0bits+0x34>
    928c:	0017f693          	andi	a3,a5,1
    9290:	00000713          	li	a4,0
    9294:	00069c63          	bnez	a3,92ac <__lo0bits+0x2c>
    9298:	0027f713          	andi	a4,a5,2
    929c:	08070463          	beqz	a4,9324 <__lo0bits+0xa4>
    92a0:	0017d793          	srli	a5,a5,0x1
    92a4:	00f52023          	sw	a5,0(a0)
    92a8:	00100713          	li	a4,1
    92ac:	00070513          	mv	a0,a4
    92b0:	00008067          	ret
    92b4:	01079693          	slli	a3,a5,0x10
    92b8:	0106d693          	srli	a3,a3,0x10
    92bc:	00000713          	li	a4,0
    92c0:	00069663          	bnez	a3,92cc <__lo0bits+0x4c>
    92c4:	0107d793          	srli	a5,a5,0x10
    92c8:	01000713          	li	a4,16
    92cc:	0ff7f693          	andi	a3,a5,255
    92d0:	00069663          	bnez	a3,92dc <__lo0bits+0x5c>
    92d4:	00870713          	addi	a4,a4,8 # c0000008 <__freertos_irq_stack_top+0xbffe82e8>
    92d8:	0087d793          	srli	a5,a5,0x8
    92dc:	00f7f693          	andi	a3,a5,15
    92e0:	00069663          	bnez	a3,92ec <__lo0bits+0x6c>
    92e4:	00470713          	addi	a4,a4,4
    92e8:	0047d793          	srli	a5,a5,0x4
    92ec:	0037f693          	andi	a3,a5,3
    92f0:	00069663          	bnez	a3,92fc <__lo0bits+0x7c>
    92f4:	00270713          	addi	a4,a4,2
    92f8:	0027d793          	srli	a5,a5,0x2
    92fc:	0017f693          	andi	a3,a5,1
    9300:	00069863          	bnez	a3,9310 <__lo0bits+0x90>
    9304:	0017d793          	srli	a5,a5,0x1
    9308:	00170713          	addi	a4,a4,1
    930c:	00078863          	beqz	a5,931c <__lo0bits+0x9c>
    9310:	00f52023          	sw	a5,0(a0)
    9314:	00070513          	mv	a0,a4
    9318:	00008067          	ret
    931c:	02000713          	li	a4,32
    9320:	f8dff06f          	j	92ac <__lo0bits+0x2c>
    9324:	0027d793          	srli	a5,a5,0x2
    9328:	00200713          	li	a4,2
    932c:	00f52023          	sw	a5,0(a0)
    9330:	00070513          	mv	a0,a4
    9334:	00008067          	ret

00009338 <__i2b>:
    9338:	ff010113          	addi	sp,sp,-16
    933c:	00812423          	sw	s0,8(sp)
    9340:	00058413          	mv	s0,a1
    9344:	00100593          	li	a1,1
    9348:	00112623          	sw	ra,12(sp)
    934c:	bc1ff0ef          	jal	ra,8f0c <_Balloc>
    9350:	00852a23          	sw	s0,20(a0)
    9354:	00c12083          	lw	ra,12(sp)
    9358:	00812403          	lw	s0,8(sp)
    935c:	00100713          	li	a4,1
    9360:	00e52823          	sw	a4,16(a0)
    9364:	01010113          	addi	sp,sp,16
    9368:	00008067          	ret

0000936c <__multiply>:
    936c:	fe010113          	addi	sp,sp,-32
    9370:	01312623          	sw	s3,12(sp)
    9374:	01412423          	sw	s4,8(sp)
    9378:	0105a983          	lw	s3,16(a1)
    937c:	01062a03          	lw	s4,16(a2)
    9380:	00912a23          	sw	s1,20(sp)
    9384:	01212823          	sw	s2,16(sp)
    9388:	00112e23          	sw	ra,28(sp)
    938c:	00812c23          	sw	s0,24(sp)
    9390:	00058493          	mv	s1,a1
    9394:	00060913          	mv	s2,a2
    9398:	0149cc63          	blt	s3,s4,93b0 <__multiply+0x44>
    939c:	000a0713          	mv	a4,s4
    93a0:	00058913          	mv	s2,a1
    93a4:	00098a13          	mv	s4,s3
    93a8:	00060493          	mv	s1,a2
    93ac:	00070993          	mv	s3,a4
    93b0:	00892783          	lw	a5,8(s2)
    93b4:	00492583          	lw	a1,4(s2)
    93b8:	013a0433          	add	s0,s4,s3
    93bc:	0087a7b3          	slt	a5,a5,s0
    93c0:	00f585b3          	add	a1,a1,a5
    93c4:	b49ff0ef          	jal	ra,8f0c <_Balloc>
    93c8:	01450e13          	addi	t3,a0,20
    93cc:	00241313          	slli	t1,s0,0x2
    93d0:	006e0333          	add	t1,t3,t1
    93d4:	000e0793          	mv	a5,t3
    93d8:	006e7863          	bgeu	t3,t1,93e8 <__multiply+0x7c>
    93dc:	0007a023          	sw	zero,0(a5)
    93e0:	00478793          	addi	a5,a5,4
    93e4:	fe67ece3          	bltu	a5,t1,93dc <__multiply+0x70>
    93e8:	01448593          	addi	a1,s1,20
    93ec:	00299e93          	slli	t4,s3,0x2
    93f0:	01490613          	addi	a2,s2,20
    93f4:	002a1893          	slli	a7,s4,0x2
    93f8:	00010837          	lui	a6,0x10
    93fc:	01d58eb3          	add	t4,a1,t4
    9400:	011608b3          	add	a7,a2,a7
    9404:	fff80813          	addi	a6,a6,-1 # ffff <_svfiprintf_r+0xce7>
    9408:	01d5ee63          	bltu	a1,t4,9424 <__multiply+0xb8>
    940c:	10c0006f          	j	9518 <__multiply+0x1ac>
    9410:	010fdf93          	srli	t6,t6,0x10
    9414:	080f9663          	bnez	t6,94a0 <__multiply+0x134>
    9418:	00458593          	addi	a1,a1,4
    941c:	004e0e13          	addi	t3,t3,4
    9420:	0fd5fc63          	bgeu	a1,t4,9518 <__multiply+0x1ac>
    9424:	0005af83          	lw	t6,0(a1)
    9428:	010ff3b3          	and	t2,t6,a6
    942c:	fe0382e3          	beqz	t2,9410 <__multiply+0xa4>
    9430:	000e0f93          	mv	t6,t3
    9434:	00060293          	mv	t0,a2
    9438:	00000493          	li	s1,0
    943c:	0002a703          	lw	a4,0(t0) # 8edc <memset+0xb4>
    9440:	000faf03          	lw	t5,0(t6)
    9444:	004f8f93          	addi	t6,t6,4
    9448:	010776b3          	and	a3,a4,a6
    944c:	027686b3          	mul	a3,a3,t2
    9450:	01075793          	srli	a5,a4,0x10
    9454:	010f7733          	and	a4,t5,a6
    9458:	010f5f13          	srli	t5,t5,0x10
    945c:	00428293          	addi	t0,t0,4
    9460:	027787b3          	mul	a5,a5,t2
    9464:	00e686b3          	add	a3,a3,a4
    9468:	009686b3          	add	a3,a3,s1
    946c:	0106d713          	srli	a4,a3,0x10
    9470:	0106f6b3          	and	a3,a3,a6
    9474:	01e787b3          	add	a5,a5,t5
    9478:	00e787b3          	add	a5,a5,a4
    947c:	01079713          	slli	a4,a5,0x10
    9480:	00d766b3          	or	a3,a4,a3
    9484:	fedfae23          	sw	a3,-4(t6)
    9488:	0107d493          	srli	s1,a5,0x10
    948c:	fb12e8e3          	bltu	t0,a7,943c <__multiply+0xd0>
    9490:	009fa023          	sw	s1,0(t6)
    9494:	0005af83          	lw	t6,0(a1)
    9498:	010fdf93          	srli	t6,t6,0x10
    949c:	f60f8ee3          	beqz	t6,9418 <__multiply+0xac>
    94a0:	000e2703          	lw	a4,0(t3)
    94a4:	000e0f13          	mv	t5,t3
    94a8:	00060693          	mv	a3,a2
    94ac:	00070393          	mv	t2,a4
    94b0:	00000293          	li	t0,0
    94b4:	0006a783          	lw	a5,0(a3)
    94b8:	0103d913          	srli	s2,t2,0x10
    94bc:	01077733          	and	a4,a4,a6
    94c0:	0107f7b3          	and	a5,a5,a6
    94c4:	03f787b3          	mul	a5,a5,t6
    94c8:	004f0f13          	addi	t5,t5,4
    94cc:	00468693          	addi	a3,a3,4
    94d0:	000f2383          	lw	t2,0(t5)
    94d4:	0103f4b3          	and	s1,t2,a6
    94d8:	012787b3          	add	a5,a5,s2
    94dc:	005787b3          	add	a5,a5,t0
    94e0:	01079293          	slli	t0,a5,0x10
    94e4:	00e2e733          	or	a4,t0,a4
    94e8:	feef2e23          	sw	a4,-4(t5)
    94ec:	ffe6d703          	lhu	a4,-2(a3)
    94f0:	0107d793          	srli	a5,a5,0x10
    94f4:	03f70733          	mul	a4,a4,t6
    94f8:	00970733          	add	a4,a4,s1
    94fc:	00f70733          	add	a4,a4,a5
    9500:	01075293          	srli	t0,a4,0x10
    9504:	fb16e8e3          	bltu	a3,a7,94b4 <__multiply+0x148>
    9508:	00ef2023          	sw	a4,0(t5)
    950c:	00458593          	addi	a1,a1,4
    9510:	004e0e13          	addi	t3,t3,4
    9514:	f1d5e8e3          	bltu	a1,t4,9424 <__multiply+0xb8>
    9518:	02805463          	blez	s0,9540 <__multiply+0x1d4>
    951c:	ffc32783          	lw	a5,-4(t1)
    9520:	ffc30313          	addi	t1,t1,-4
    9524:	00078863          	beqz	a5,9534 <__multiply+0x1c8>
    9528:	0180006f          	j	9540 <__multiply+0x1d4>
    952c:	00032783          	lw	a5,0(t1)
    9530:	00079863          	bnez	a5,9540 <__multiply+0x1d4>
    9534:	fff40413          	addi	s0,s0,-1
    9538:	ffc30313          	addi	t1,t1,-4
    953c:	fe0418e3          	bnez	s0,952c <__multiply+0x1c0>
    9540:	00852823          	sw	s0,16(a0)
    9544:	01c12083          	lw	ra,28(sp)
    9548:	01812403          	lw	s0,24(sp)
    954c:	01412483          	lw	s1,20(sp)
    9550:	01012903          	lw	s2,16(sp)
    9554:	00c12983          	lw	s3,12(sp)
    9558:	00812a03          	lw	s4,8(sp)
    955c:	02010113          	addi	sp,sp,32
    9560:	00008067          	ret

00009564 <__pow5mult>:
    9564:	fe010113          	addi	sp,sp,-32
    9568:	00812c23          	sw	s0,24(sp)
    956c:	01312623          	sw	s3,12(sp)
    9570:	01412423          	sw	s4,8(sp)
    9574:	00112e23          	sw	ra,28(sp)
    9578:	00912a23          	sw	s1,20(sp)
    957c:	01212823          	sw	s2,16(sp)
    9580:	00367793          	andi	a5,a2,3
    9584:	00060413          	mv	s0,a2
    9588:	00050993          	mv	s3,a0
    958c:	00058a13          	mv	s4,a1
    9590:	0c079463          	bnez	a5,9658 <__pow5mult+0xf4>
    9594:	40245413          	srai	s0,s0,0x2
    9598:	000a0913          	mv	s2,s4
    959c:	06040863          	beqz	s0,960c <__pow5mult+0xa8>
    95a0:	0489a483          	lw	s1,72(s3)
    95a4:	0c048e63          	beqz	s1,9680 <__pow5mult+0x11c>
    95a8:	00147793          	andi	a5,s0,1
    95ac:	000a0913          	mv	s2,s4
    95b0:	02079063          	bnez	a5,95d0 <__pow5mult+0x6c>
    95b4:	40145413          	srai	s0,s0,0x1
    95b8:	04040a63          	beqz	s0,960c <__pow5mult+0xa8>
    95bc:	0004a503          	lw	a0,0(s1)
    95c0:	06050863          	beqz	a0,9630 <__pow5mult+0xcc>
    95c4:	00050493          	mv	s1,a0
    95c8:	00147793          	andi	a5,s0,1
    95cc:	fe0784e3          	beqz	a5,95b4 <__pow5mult+0x50>
    95d0:	00048613          	mv	a2,s1
    95d4:	00090593          	mv	a1,s2
    95d8:	00098513          	mv	a0,s3
    95dc:	d91ff0ef          	jal	ra,936c <__multiply>
    95e0:	06090863          	beqz	s2,9650 <__pow5mult+0xec>
    95e4:	00492703          	lw	a4,4(s2)
    95e8:	04c9a783          	lw	a5,76(s3)
    95ec:	40145413          	srai	s0,s0,0x1
    95f0:	00271713          	slli	a4,a4,0x2
    95f4:	00e787b3          	add	a5,a5,a4
    95f8:	0007a703          	lw	a4,0(a5)
    95fc:	00e92023          	sw	a4,0(s2)
    9600:	0127a023          	sw	s2,0(a5)
    9604:	00050913          	mv	s2,a0
    9608:	fa041ae3          	bnez	s0,95bc <__pow5mult+0x58>
    960c:	01c12083          	lw	ra,28(sp)
    9610:	01812403          	lw	s0,24(sp)
    9614:	00090513          	mv	a0,s2
    9618:	01412483          	lw	s1,20(sp)
    961c:	01012903          	lw	s2,16(sp)
    9620:	00c12983          	lw	s3,12(sp)
    9624:	00812a03          	lw	s4,8(sp)
    9628:	02010113          	addi	sp,sp,32
    962c:	00008067          	ret
    9630:	00048613          	mv	a2,s1
    9634:	00048593          	mv	a1,s1
    9638:	00098513          	mv	a0,s3
    963c:	d31ff0ef          	jal	ra,936c <__multiply>
    9640:	00a4a023          	sw	a0,0(s1)
    9644:	00052023          	sw	zero,0(a0)
    9648:	00050493          	mv	s1,a0
    964c:	f7dff06f          	j	95c8 <__pow5mult+0x64>
    9650:	00050913          	mv	s2,a0
    9654:	f61ff06f          	j	95b4 <__pow5mult+0x50>
    9658:	fff78793          	addi	a5,a5,-1
    965c:	0000c717          	auipc	a4,0xc
    9660:	54470713          	addi	a4,a4,1348 # 15ba0 <p05.3298>
    9664:	00279793          	slli	a5,a5,0x2
    9668:	00f707b3          	add	a5,a4,a5
    966c:	0007a603          	lw	a2,0(a5)
    9670:	00000693          	li	a3,0
    9674:	965ff0ef          	jal	ra,8fd8 <__multadd>
    9678:	00050a13          	mv	s4,a0
    967c:	f19ff06f          	j	9594 <__pow5mult+0x30>
    9680:	00100593          	li	a1,1
    9684:	00098513          	mv	a0,s3
    9688:	885ff0ef          	jal	ra,8f0c <_Balloc>
    968c:	27100793          	li	a5,625
    9690:	00f52a23          	sw	a5,20(a0)
    9694:	00100793          	li	a5,1
    9698:	00f52823          	sw	a5,16(a0)
    969c:	04a9a423          	sw	a0,72(s3)
    96a0:	00050493          	mv	s1,a0
    96a4:	00052023          	sw	zero,0(a0)
    96a8:	f01ff06f          	j	95a8 <__pow5mult+0x44>

000096ac <__lshift>:
    96ac:	fe010113          	addi	sp,sp,-32
    96b0:	01412423          	sw	s4,8(sp)
    96b4:	0105aa03          	lw	s4,16(a1)
    96b8:	00912a23          	sw	s1,20(sp)
    96bc:	0085a783          	lw	a5,8(a1)
    96c0:	40565493          	srai	s1,a2,0x5
    96c4:	01448a33          	add	s4,s1,s4
    96c8:	00812c23          	sw	s0,24(sp)
    96cc:	01212823          	sw	s2,16(sp)
    96d0:	01312623          	sw	s3,12(sp)
    96d4:	01512223          	sw	s5,4(sp)
    96d8:	00112e23          	sw	ra,28(sp)
    96dc:	001a0413          	addi	s0,s4,1
    96e0:	00058993          	mv	s3,a1
    96e4:	00060913          	mv	s2,a2
    96e8:	00050a93          	mv	s5,a0
    96ec:	0045a583          	lw	a1,4(a1)
    96f0:	0087d863          	bge	a5,s0,9700 <__lshift+0x54>
    96f4:	00179793          	slli	a5,a5,0x1
    96f8:	00158593          	addi	a1,a1,1
    96fc:	fe87cce3          	blt	a5,s0,96f4 <__lshift+0x48>
    9700:	000a8513          	mv	a0,s5
    9704:	809ff0ef          	jal	ra,8f0c <_Balloc>
    9708:	01450713          	addi	a4,a0,20
    970c:	02905463          	blez	s1,9734 <__lshift+0x88>
    9710:	00548493          	addi	s1,s1,5
    9714:	00249493          	slli	s1,s1,0x2
    9718:	009506b3          	add	a3,a0,s1
    971c:	00070793          	mv	a5,a4
    9720:	00478793          	addi	a5,a5,4
    9724:	fe07ae23          	sw	zero,-4(a5)
    9728:	fef69ce3          	bne	a3,a5,9720 <__lshift+0x74>
    972c:	fec48493          	addi	s1,s1,-20
    9730:	00970733          	add	a4,a4,s1
    9734:	0109a803          	lw	a6,16(s3)
    9738:	01498793          	addi	a5,s3,20
    973c:	01f97613          	andi	a2,s2,31
    9740:	00281813          	slli	a6,a6,0x2
    9744:	01078833          	add	a6,a5,a6
    9748:	08060263          	beqz	a2,97cc <__lshift+0x120>
    974c:	02000893          	li	a7,32
    9750:	40c888b3          	sub	a7,a7,a2
    9754:	00000593          	li	a1,0
    9758:	0007a683          	lw	a3,0(a5)
    975c:	00470713          	addi	a4,a4,4
    9760:	00478793          	addi	a5,a5,4
    9764:	00c696b3          	sll	a3,a3,a2
    9768:	00b6e6b3          	or	a3,a3,a1
    976c:	fed72e23          	sw	a3,-4(a4)
    9770:	ffc7a683          	lw	a3,-4(a5)
    9774:	0116d5b3          	srl	a1,a3,a7
    9778:	ff07e0e3          	bltu	a5,a6,9758 <__lshift+0xac>
    977c:	00b72023          	sw	a1,0(a4)
    9780:	00058463          	beqz	a1,9788 <__lshift+0xdc>
    9784:	00040a13          	mv	s4,s0
    9788:	0049a703          	lw	a4,4(s3)
    978c:	04caa783          	lw	a5,76(s5)
    9790:	01c12083          	lw	ra,28(sp)
    9794:	00271713          	slli	a4,a4,0x2
    9798:	00e787b3          	add	a5,a5,a4
    979c:	0007a703          	lw	a4,0(a5)
    97a0:	01452823          	sw	s4,16(a0)
    97a4:	01812403          	lw	s0,24(sp)
    97a8:	00e9a023          	sw	a4,0(s3)
    97ac:	0137a023          	sw	s3,0(a5)
    97b0:	01412483          	lw	s1,20(sp)
    97b4:	01012903          	lw	s2,16(sp)
    97b8:	00c12983          	lw	s3,12(sp)
    97bc:	00812a03          	lw	s4,8(sp)
    97c0:	00412a83          	lw	s5,4(sp)
    97c4:	02010113          	addi	sp,sp,32
    97c8:	00008067          	ret
    97cc:	00478793          	addi	a5,a5,4
    97d0:	ffc7a683          	lw	a3,-4(a5)
    97d4:	00470713          	addi	a4,a4,4
    97d8:	fed72e23          	sw	a3,-4(a4)
    97dc:	fb07f6e3          	bgeu	a5,a6,9788 <__lshift+0xdc>
    97e0:	00478793          	addi	a5,a5,4
    97e4:	ffc7a683          	lw	a3,-4(a5)
    97e8:	00470713          	addi	a4,a4,4
    97ec:	fed72e23          	sw	a3,-4(a4)
    97f0:	fd07eee3          	bltu	a5,a6,97cc <__lshift+0x120>
    97f4:	f95ff06f          	j	9788 <__lshift+0xdc>

000097f8 <__mcmp>:
    97f8:	00050613          	mv	a2,a0
    97fc:	0105a783          	lw	a5,16(a1)
    9800:	01052503          	lw	a0,16(a0)
    9804:	40f50533          	sub	a0,a0,a5
    9808:	04051463          	bnez	a0,9850 <__mcmp+0x58>
    980c:	00279713          	slli	a4,a5,0x2
    9810:	01460613          	addi	a2,a2,20
    9814:	01458593          	addi	a1,a1,20
    9818:	00e607b3          	add	a5,a2,a4
    981c:	00e585b3          	add	a1,a1,a4
    9820:	0080006f          	j	9828 <__mcmp+0x30>
    9824:	02f67663          	bgeu	a2,a5,9850 <__mcmp+0x58>
    9828:	ffc78793          	addi	a5,a5,-4
    982c:	ffc58593          	addi	a1,a1,-4
    9830:	0007a703          	lw	a4,0(a5)
    9834:	0005a683          	lw	a3,0(a1)
    9838:	fed706e3          	beq	a4,a3,9824 <__mcmp+0x2c>
    983c:	00d73733          	sltu	a4,a4,a3
    9840:	40e00533          	neg	a0,a4
    9844:	ffe57513          	andi	a0,a0,-2
    9848:	00150513          	addi	a0,a0,1
    984c:	00008067          	ret
    9850:	00008067          	ret

00009854 <__mdiff>:
    9854:	fe010113          	addi	sp,sp,-32
    9858:	01212823          	sw	s2,16(sp)
    985c:	01062703          	lw	a4,16(a2)
    9860:	0105a903          	lw	s2,16(a1)
    9864:	00812c23          	sw	s0,24(sp)
    9868:	00912a23          	sw	s1,20(sp)
    986c:	01312623          	sw	s3,12(sp)
    9870:	01412423          	sw	s4,8(sp)
    9874:	00112e23          	sw	ra,28(sp)
    9878:	40e90933          	sub	s2,s2,a4
    987c:	00058993          	mv	s3,a1
    9880:	00060a13          	mv	s4,a2
    9884:	01458413          	addi	s0,a1,20
    9888:	01460493          	addi	s1,a2,20
    988c:	04091863          	bnez	s2,98dc <__mdiff+0x88>
    9890:	00271713          	slli	a4,a4,0x2
    9894:	00e407b3          	add	a5,s0,a4
    9898:	00e48733          	add	a4,s1,a4
    989c:	0080006f          	j	98a4 <__mdiff+0x50>
    98a0:	16f47263          	bgeu	s0,a5,9a04 <__mdiff+0x1b0>
    98a4:	ffc78793          	addi	a5,a5,-4
    98a8:	ffc70713          	addi	a4,a4,-4
    98ac:	0007a583          	lw	a1,0(a5)
    98b0:	00072683          	lw	a3,0(a4)
    98b4:	fed586e3          	beq	a1,a3,98a0 <__mdiff+0x4c>
    98b8:	02d5f663          	bgeu	a1,a3,98e4 <__mdiff+0x90>
    98bc:	00040713          	mv	a4,s0
    98c0:	00098793          	mv	a5,s3
    98c4:	00048413          	mv	s0,s1
    98c8:	000a0993          	mv	s3,s4
    98cc:	00070493          	mv	s1,a4
    98d0:	00078a13          	mv	s4,a5
    98d4:	00100913          	li	s2,1
    98d8:	00c0006f          	j	98e4 <__mdiff+0x90>
    98dc:	fe0940e3          	bltz	s2,98bc <__mdiff+0x68>
    98e0:	00000913          	li	s2,0
    98e4:	0049a583          	lw	a1,4(s3)
    98e8:	e24ff0ef          	jal	ra,8f0c <_Balloc>
    98ec:	0109a303          	lw	t1,16(s3)
    98f0:	010a2e83          	lw	t4,16(s4)
    98f4:	00010637          	lui	a2,0x10
    98f8:	00231e13          	slli	t3,t1,0x2
    98fc:	002e9e93          	slli	t4,t4,0x2
    9900:	01252623          	sw	s2,12(a0)
    9904:	01c40e33          	add	t3,s0,t3
    9908:	01d48eb3          	add	t4,s1,t4
    990c:	01450813          	addi	a6,a0,20
    9910:	00000793          	li	a5,0
    9914:	fff60613          	addi	a2,a2,-1 # ffff <_svfiprintf_r+0xce7>
    9918:	0080006f          	j	9920 <__mdiff+0xcc>
    991c:	00088813          	mv	a6,a7
    9920:	00042703          	lw	a4,0(s0)
    9924:	0004a583          	lw	a1,0(s1)
    9928:	00480893          	addi	a7,a6,4
    992c:	00c776b3          	and	a3,a4,a2
    9930:	00f686b3          	add	a3,a3,a5
    9934:	00c5f7b3          	and	a5,a1,a2
    9938:	40f686b3          	sub	a3,a3,a5
    993c:	0105d593          	srli	a1,a1,0x10
    9940:	01075793          	srli	a5,a4,0x10
    9944:	40b787b3          	sub	a5,a5,a1
    9948:	4106d713          	srai	a4,a3,0x10
    994c:	00e787b3          	add	a5,a5,a4
    9950:	01079713          	slli	a4,a5,0x10
    9954:	00c6f6b3          	and	a3,a3,a2
    9958:	00d766b3          	or	a3,a4,a3
    995c:	00448493          	addi	s1,s1,4
    9960:	fed8ae23          	sw	a3,-4(a7)
    9964:	00440413          	addi	s0,s0,4
    9968:	4107d793          	srai	a5,a5,0x10
    996c:	fbd4e8e3          	bltu	s1,t4,991c <__mdiff+0xc8>
    9970:	05c47e63          	bgeu	s0,t3,99cc <__mdiff+0x178>
    9974:	00010eb7          	lui	t4,0x10
    9978:	00088813          	mv	a6,a7
    997c:	00040593          	mv	a1,s0
    9980:	fffe8e93          	addi	t4,t4,-1 # ffff <_svfiprintf_r+0xce7>
    9984:	0005a703          	lw	a4,0(a1)
    9988:	00480813          	addi	a6,a6,4
    998c:	00458593          	addi	a1,a1,4
    9990:	01d77633          	and	a2,a4,t4
    9994:	00f60633          	add	a2,a2,a5
    9998:	41065693          	srai	a3,a2,0x10
    999c:	01075793          	srli	a5,a4,0x10
    99a0:	00d787b3          	add	a5,a5,a3
    99a4:	01079693          	slli	a3,a5,0x10
    99a8:	01d67633          	and	a2,a2,t4
    99ac:	00c6e6b3          	or	a3,a3,a2
    99b0:	fed82e23          	sw	a3,-4(a6)
    99b4:	4107d793          	srai	a5,a5,0x10
    99b8:	fdc5e6e3          	bltu	a1,t3,9984 <__mdiff+0x130>
    99bc:	fffe0813          	addi	a6,t3,-1
    99c0:	40880833          	sub	a6,a6,s0
    99c4:	ffc87813          	andi	a6,a6,-4
    99c8:	01088833          	add	a6,a7,a6
    99cc:	00069a63          	bnez	a3,99e0 <__mdiff+0x18c>
    99d0:	ffc80813          	addi	a6,a6,-4
    99d4:	00082783          	lw	a5,0(a6)
    99d8:	fff30313          	addi	t1,t1,-1
    99dc:	fe078ae3          	beqz	a5,99d0 <__mdiff+0x17c>
    99e0:	01c12083          	lw	ra,28(sp)
    99e4:	01812403          	lw	s0,24(sp)
    99e8:	00652823          	sw	t1,16(a0)
    99ec:	01412483          	lw	s1,20(sp)
    99f0:	01012903          	lw	s2,16(sp)
    99f4:	00c12983          	lw	s3,12(sp)
    99f8:	00812a03          	lw	s4,8(sp)
    99fc:	02010113          	addi	sp,sp,32
    9a00:	00008067          	ret
    9a04:	00000593          	li	a1,0
    9a08:	d04ff0ef          	jal	ra,8f0c <_Balloc>
    9a0c:	01c12083          	lw	ra,28(sp)
    9a10:	01812403          	lw	s0,24(sp)
    9a14:	00100793          	li	a5,1
    9a18:	00f52823          	sw	a5,16(a0)
    9a1c:	00052a23          	sw	zero,20(a0)
    9a20:	01412483          	lw	s1,20(sp)
    9a24:	01012903          	lw	s2,16(sp)
    9a28:	00c12983          	lw	s3,12(sp)
    9a2c:	00812a03          	lw	s4,8(sp)
    9a30:	02010113          	addi	sp,sp,32
    9a34:	00008067          	ret

00009a38 <__ulp>:
    9a38:	7ff007b7          	lui	a5,0x7ff00
    9a3c:	00b7f5b3          	and	a1,a5,a1
    9a40:	fcc007b7          	lui	a5,0xfcc00
    9a44:	00f585b3          	add	a1,a1,a5
    9a48:	00b05863          	blez	a1,9a58 <__ulp+0x20>
    9a4c:	00000793          	li	a5,0
    9a50:	00078513          	mv	a0,a5
    9a54:	00008067          	ret
    9a58:	40b005b3          	neg	a1,a1
    9a5c:	4145d593          	srai	a1,a1,0x14
    9a60:	01300793          	li	a5,19
    9a64:	00b7c863          	blt	a5,a1,9a74 <__ulp+0x3c>
    9a68:	000807b7          	lui	a5,0x80
    9a6c:	40b7d5b3          	sra	a1,a5,a1
    9a70:	fddff06f          	j	9a4c <__ulp+0x14>
    9a74:	fec58713          	addi	a4,a1,-20
    9a78:	01e00693          	li	a3,30
    9a7c:	00000593          	li	a1,0
    9a80:	00100793          	li	a5,1
    9a84:	fce6c6e3          	blt	a3,a4,9a50 <__ulp+0x18>
    9a88:	800007b7          	lui	a5,0x80000
    9a8c:	00e7d7b3          	srl	a5,a5,a4
    9a90:	00078513          	mv	a0,a5
    9a94:	00008067          	ret

00009a98 <__b2d>:
    9a98:	fe010113          	addi	sp,sp,-32
    9a9c:	00812c23          	sw	s0,24(sp)
    9aa0:	01052403          	lw	s0,16(a0)
    9aa4:	00912a23          	sw	s1,20(sp)
    9aa8:	01450493          	addi	s1,a0,20
    9aac:	00241413          	slli	s0,s0,0x2
    9ab0:	00848433          	add	s0,s1,s0
    9ab4:	01212823          	sw	s2,16(sp)
    9ab8:	ffc42903          	lw	s2,-4(s0)
    9abc:	01312623          	sw	s3,12(sp)
    9ac0:	01412423          	sw	s4,8(sp)
    9ac4:	00090513          	mv	a0,s2
    9ac8:	00058a13          	mv	s4,a1
    9acc:	00112e23          	sw	ra,28(sp)
    9ad0:	f3cff0ef          	jal	ra,920c <__hi0bits>
    9ad4:	02000713          	li	a4,32
    9ad8:	40a707b3          	sub	a5,a4,a0
    9adc:	00fa2023          	sw	a5,0(s4)
    9ae0:	00a00793          	li	a5,10
    9ae4:	ffc40993          	addi	s3,s0,-4
    9ae8:	08a7d063          	bge	a5,a0,9b68 <__b2d+0xd0>
    9aec:	ff550513          	addi	a0,a0,-11
    9af0:	0534f063          	bgeu	s1,s3,9b30 <__b2d+0x98>
    9af4:	ff842783          	lw	a5,-8(s0)
    9af8:	04050063          	beqz	a0,9b38 <__b2d+0xa0>
    9afc:	40a70633          	sub	a2,a4,a0
    9b00:	00c7d733          	srl	a4,a5,a2
    9b04:	00a916b3          	sll	a3,s2,a0
    9b08:	00e6e6b3          	or	a3,a3,a4
    9b0c:	ff840593          	addi	a1,s0,-8
    9b10:	3ff00737          	lui	a4,0x3ff00
    9b14:	00e6e6b3          	or	a3,a3,a4
    9b18:	00a797b3          	sll	a5,a5,a0
    9b1c:	02b4f263          	bgeu	s1,a1,9b40 <__b2d+0xa8>
    9b20:	ff442703          	lw	a4,-12(s0)
    9b24:	00c75733          	srl	a4,a4,a2
    9b28:	00e7e7b3          	or	a5,a5,a4
    9b2c:	0140006f          	j	9b40 <__b2d+0xa8>
    9b30:	00000793          	li	a5,0
    9b34:	06051463          	bnez	a0,9b9c <__b2d+0x104>
    9b38:	3ff00737          	lui	a4,0x3ff00
    9b3c:	00e966b3          	or	a3,s2,a4
    9b40:	01c12083          	lw	ra,28(sp)
    9b44:	01812403          	lw	s0,24(sp)
    9b48:	01412483          	lw	s1,20(sp)
    9b4c:	01012903          	lw	s2,16(sp)
    9b50:	00c12983          	lw	s3,12(sp)
    9b54:	00812a03          	lw	s4,8(sp)
    9b58:	00078513          	mv	a0,a5
    9b5c:	00068593          	mv	a1,a3
    9b60:	02010113          	addi	sp,sp,32
    9b64:	00008067          	ret
    9b68:	00b00613          	li	a2,11
    9b6c:	40a60633          	sub	a2,a2,a0
    9b70:	00c95733          	srl	a4,s2,a2
    9b74:	3ff006b7          	lui	a3,0x3ff00
    9b78:	00d766b3          	or	a3,a4,a3
    9b7c:	00000713          	li	a4,0
    9b80:	0134f663          	bgeu	s1,s3,9b8c <__b2d+0xf4>
    9b84:	ff842703          	lw	a4,-8(s0)
    9b88:	00c75733          	srl	a4,a4,a2
    9b8c:	01550513          	addi	a0,a0,21
    9b90:	00a91533          	sll	a0,s2,a0
    9b94:	00e567b3          	or	a5,a0,a4
    9b98:	fa9ff06f          	j	9b40 <__b2d+0xa8>
    9b9c:	00a91533          	sll	a0,s2,a0
    9ba0:	3ff00737          	lui	a4,0x3ff00
    9ba4:	00e566b3          	or	a3,a0,a4
    9ba8:	00000793          	li	a5,0
    9bac:	f95ff06f          	j	9b40 <__b2d+0xa8>

00009bb0 <__d2b>:
    9bb0:	fd010113          	addi	sp,sp,-48
    9bb4:	01512a23          	sw	s5,20(sp)
    9bb8:	00058a93          	mv	s5,a1
    9bbc:	00100593          	li	a1,1
    9bc0:	02812423          	sw	s0,40(sp)
    9bc4:	02912223          	sw	s1,36(sp)
    9bc8:	03212023          	sw	s2,32(sp)
    9bcc:	00060493          	mv	s1,a2
    9bd0:	01312e23          	sw	s3,28(sp)
    9bd4:	01412c23          	sw	s4,24(sp)
    9bd8:	02112623          	sw	ra,44(sp)
    9bdc:	00068a13          	mv	s4,a3
    9be0:	00070993          	mv	s3,a4
    9be4:	b28ff0ef          	jal	ra,8f0c <_Balloc>
    9be8:	00100637          	lui	a2,0x100
    9bec:	0144d413          	srli	s0,s1,0x14
    9bf0:	fff60793          	addi	a5,a2,-1 # fffff <__freertos_irq_stack_top+0xe82df>
    9bf4:	7ff47413          	andi	s0,s0,2047
    9bf8:	00050913          	mv	s2,a0
    9bfc:	0097f7b3          	and	a5,a5,s1
    9c00:	00040463          	beqz	s0,9c08 <__d2b+0x58>
    9c04:	00c7e7b3          	or	a5,a5,a2
    9c08:	00f12623          	sw	a5,12(sp)
    9c0c:	080a8e63          	beqz	s5,9ca8 <__d2b+0xf8>
    9c10:	00810513          	addi	a0,sp,8
    9c14:	01512423          	sw	s5,8(sp)
    9c18:	e68ff0ef          	jal	ra,9280 <__lo0bits>
    9c1c:	00050793          	mv	a5,a0
    9c20:	00c12703          	lw	a4,12(sp)
    9c24:	06051063          	bnez	a0,9c84 <__d2b+0xd4>
    9c28:	00812683          	lw	a3,8(sp)
    9c2c:	00d92a23          	sw	a3,20(s2)
    9c30:	00e034b3          	snez	s1,a4
    9c34:	00148493          	addi	s1,s1,1
    9c38:	00e92c23          	sw	a4,24(s2)
    9c3c:	00992823          	sw	s1,16(s2)
    9c40:	08040663          	beqz	s0,9ccc <__d2b+0x11c>
    9c44:	bcd40413          	addi	s0,s0,-1075
    9c48:	00f40433          	add	s0,s0,a5
    9c4c:	03500713          	li	a4,53
    9c50:	008a2023          	sw	s0,0(s4)
    9c54:	40f707b3          	sub	a5,a4,a5
    9c58:	00f9a023          	sw	a5,0(s3)
    9c5c:	02c12083          	lw	ra,44(sp)
    9c60:	02812403          	lw	s0,40(sp)
    9c64:	00090513          	mv	a0,s2
    9c68:	02412483          	lw	s1,36(sp)
    9c6c:	02012903          	lw	s2,32(sp)
    9c70:	01c12983          	lw	s3,28(sp)
    9c74:	01812a03          	lw	s4,24(sp)
    9c78:	01412a83          	lw	s5,20(sp)
    9c7c:	03010113          	addi	sp,sp,48
    9c80:	00008067          	ret
    9c84:	02000693          	li	a3,32
    9c88:	00812603          	lw	a2,8(sp)
    9c8c:	40a686b3          	sub	a3,a3,a0
    9c90:	00d716b3          	sll	a3,a4,a3
    9c94:	00c6e6b3          	or	a3,a3,a2
    9c98:	00a75733          	srl	a4,a4,a0
    9c9c:	00d92a23          	sw	a3,20(s2)
    9ca0:	00e12623          	sw	a4,12(sp)
    9ca4:	f8dff06f          	j	9c30 <__d2b+0x80>
    9ca8:	00c10513          	addi	a0,sp,12
    9cac:	dd4ff0ef          	jal	ra,9280 <__lo0bits>
    9cb0:	00100793          	li	a5,1
    9cb4:	00f92823          	sw	a5,16(s2)
    9cb8:	00c12783          	lw	a5,12(sp)
    9cbc:	00100493          	li	s1,1
    9cc0:	00f92a23          	sw	a5,20(s2)
    9cc4:	02050793          	addi	a5,a0,32
    9cc8:	f6041ee3          	bnez	s0,9c44 <__d2b+0x94>
    9ccc:	00249713          	slli	a4,s1,0x2
    9cd0:	00e90733          	add	a4,s2,a4
    9cd4:	01072503          	lw	a0,16(a4) # 3ff00010 <__freertos_irq_stack_top+0x3fee82f0>
    9cd8:	bce78793          	addi	a5,a5,-1074 # 7ffffbce <__freertos_irq_stack_top+0x7ffe7eae>
    9cdc:	00fa2023          	sw	a5,0(s4)
    9ce0:	d2cff0ef          	jal	ra,920c <__hi0bits>
    9ce4:	00549493          	slli	s1,s1,0x5
    9ce8:	40a484b3          	sub	s1,s1,a0
    9cec:	0099a023          	sw	s1,0(s3)
    9cf0:	f6dff06f          	j	9c5c <__d2b+0xac>

00009cf4 <__ratio>:
    9cf4:	fd010113          	addi	sp,sp,-48
    9cf8:	03212023          	sw	s2,32(sp)
    9cfc:	00058913          	mv	s2,a1
    9d00:	00810593          	addi	a1,sp,8
    9d04:	02112623          	sw	ra,44(sp)
    9d08:	02812423          	sw	s0,40(sp)
    9d0c:	02912223          	sw	s1,36(sp)
    9d10:	01312e23          	sw	s3,28(sp)
    9d14:	00050993          	mv	s3,a0
    9d18:	d81ff0ef          	jal	ra,9a98 <__b2d>
    9d1c:	00050493          	mv	s1,a0
    9d20:	00058413          	mv	s0,a1
    9d24:	00090513          	mv	a0,s2
    9d28:	00c10593          	addi	a1,sp,12
    9d2c:	d6dff0ef          	jal	ra,9a98 <__b2d>
    9d30:	01092783          	lw	a5,16(s2)
    9d34:	0109a703          	lw	a4,16(s3)
    9d38:	00812683          	lw	a3,8(sp)
    9d3c:	40f70733          	sub	a4,a4,a5
    9d40:	00c12783          	lw	a5,12(sp)
    9d44:	00571713          	slli	a4,a4,0x5
    9d48:	40f686b3          	sub	a3,a3,a5
    9d4c:	00d707b3          	add	a5,a4,a3
    9d50:	02f05e63          	blez	a5,9d8c <__ratio+0x98>
    9d54:	01479793          	slli	a5,a5,0x14
    9d58:	00878433          	add	s0,a5,s0
    9d5c:	00050613          	mv	a2,a0
    9d60:	00058693          	mv	a3,a1
    9d64:	00048513          	mv	a0,s1
    9d68:	00040593          	mv	a1,s0
    9d6c:	3a0070ef          	jal	ra,1110c <__divdf3>
    9d70:	02c12083          	lw	ra,44(sp)
    9d74:	02812403          	lw	s0,40(sp)
    9d78:	02412483          	lw	s1,36(sp)
    9d7c:	02012903          	lw	s2,32(sp)
    9d80:	01c12983          	lw	s3,28(sp)
    9d84:	03010113          	addi	sp,sp,48
    9d88:	00008067          	ret
    9d8c:	01479713          	slli	a4,a5,0x14
    9d90:	40e585b3          	sub	a1,a1,a4
    9d94:	fc9ff06f          	j	9d5c <__ratio+0x68>

00009d98 <_mprec_log10>:
    9d98:	ff010113          	addi	sp,sp,-16
    9d9c:	00812423          	sw	s0,8(sp)
    9da0:	00112623          	sw	ra,12(sp)
    9da4:	01212223          	sw	s2,4(sp)
    9da8:	01312023          	sw	s3,0(sp)
    9dac:	01700793          	li	a5,23
    9db0:	00050413          	mv	s0,a0
    9db4:	04a7d863          	bge	a5,a0,9e04 <_mprec_log10+0x6c>
    9db8:	0000c797          	auipc	a5,0xc
    9dbc:	dd878793          	addi	a5,a5,-552 # 15b90 <__mprec_tinytens+0x28>
    9dc0:	0007a503          	lw	a0,0(a5)
    9dc4:	0047a583          	lw	a1,4(a5)
    9dc8:	0000c797          	auipc	a5,0xc
    9dcc:	dd078793          	addi	a5,a5,-560 # 15b98 <__mprec_tinytens+0x30>
    9dd0:	0007a903          	lw	s2,0(a5)
    9dd4:	0047a983          	lw	s3,4(a5)
    9dd8:	fff40413          	addi	s0,s0,-1
    9ddc:	00090613          	mv	a2,s2
    9de0:	00098693          	mv	a3,s3
    9de4:	2a5070ef          	jal	ra,11888 <__muldf3>
    9de8:	fe0418e3          	bnez	s0,9dd8 <_mprec_log10+0x40>
    9dec:	00c12083          	lw	ra,12(sp)
    9df0:	00812403          	lw	s0,8(sp)
    9df4:	00412903          	lw	s2,4(sp)
    9df8:	00012983          	lw	s3,0(sp)
    9dfc:	01010113          	addi	sp,sp,16
    9e00:	00008067          	ret
    9e04:	00351413          	slli	s0,a0,0x3
    9e08:	0000c797          	auipc	a5,0xc
    9e0c:	c9878793          	addi	a5,a5,-872 # 15aa0 <__mprec_tens>
    9e10:	00878433          	add	s0,a5,s0
    9e14:	00042503          	lw	a0,0(s0)
    9e18:	00442583          	lw	a1,4(s0)
    9e1c:	00c12083          	lw	ra,12(sp)
    9e20:	00812403          	lw	s0,8(sp)
    9e24:	00412903          	lw	s2,4(sp)
    9e28:	00012983          	lw	s3,0(sp)
    9e2c:	01010113          	addi	sp,sp,16
    9e30:	00008067          	ret

00009e34 <__copybits>:
    9e34:	01062683          	lw	a3,16(a2)
    9e38:	fff58593          	addi	a1,a1,-1
    9e3c:	4055d593          	srai	a1,a1,0x5
    9e40:	00158593          	addi	a1,a1,1
    9e44:	01460793          	addi	a5,a2,20
    9e48:	00269693          	slli	a3,a3,0x2
    9e4c:	00259593          	slli	a1,a1,0x2
    9e50:	00d786b3          	add	a3,a5,a3
    9e54:	00b505b3          	add	a1,a0,a1
    9e58:	02d7f863          	bgeu	a5,a3,9e88 <__copybits+0x54>
    9e5c:	00050713          	mv	a4,a0
    9e60:	00478793          	addi	a5,a5,4
    9e64:	ffc7a803          	lw	a6,-4(a5)
    9e68:	00470713          	addi	a4,a4,4
    9e6c:	ff072e23          	sw	a6,-4(a4)
    9e70:	fed7e8e3          	bltu	a5,a3,9e60 <__copybits+0x2c>
    9e74:	40c687b3          	sub	a5,a3,a2
    9e78:	feb78793          	addi	a5,a5,-21
    9e7c:	ffc7f793          	andi	a5,a5,-4
    9e80:	00478793          	addi	a5,a5,4
    9e84:	00f50533          	add	a0,a0,a5
    9e88:	00b57863          	bgeu	a0,a1,9e98 <__copybits+0x64>
    9e8c:	00450513          	addi	a0,a0,4
    9e90:	fe052e23          	sw	zero,-4(a0)
    9e94:	feb56ce3          	bltu	a0,a1,9e8c <__copybits+0x58>
    9e98:	00008067          	ret

00009e9c <__any_on>:
    9e9c:	01052703          	lw	a4,16(a0)
    9ea0:	4055d613          	srai	a2,a1,0x5
    9ea4:	01450693          	addi	a3,a0,20
    9ea8:	02c75a63          	bge	a4,a2,9edc <__any_on+0x40>
    9eac:	00271793          	slli	a5,a4,0x2
    9eb0:	00f687b3          	add	a5,a3,a5
    9eb4:	04f6fc63          	bgeu	a3,a5,9f0c <__any_on+0x70>
    9eb8:	ffc7a503          	lw	a0,-4(a5)
    9ebc:	ffc78793          	addi	a5,a5,-4
    9ec0:	00051a63          	bnez	a0,9ed4 <__any_on+0x38>
    9ec4:	04f6f263          	bgeu	a3,a5,9f08 <__any_on+0x6c>
    9ec8:	ffc78793          	addi	a5,a5,-4
    9ecc:	0007a703          	lw	a4,0(a5)
    9ed0:	fe070ae3          	beqz	a4,9ec4 <__any_on+0x28>
    9ed4:	00100513          	li	a0,1
    9ed8:	00008067          	ret
    9edc:	00261793          	slli	a5,a2,0x2
    9ee0:	00f687b3          	add	a5,a3,a5
    9ee4:	fce658e3          	bge	a2,a4,9eb4 <__any_on+0x18>
    9ee8:	01f5f593          	andi	a1,a1,31
    9eec:	fc0584e3          	beqz	a1,9eb4 <__any_on+0x18>
    9ef0:	0007a603          	lw	a2,0(a5)
    9ef4:	00100513          	li	a0,1
    9ef8:	00b65733          	srl	a4,a2,a1
    9efc:	00b715b3          	sll	a1,a4,a1
    9f00:	fab60ae3          	beq	a2,a1,9eb4 <__any_on+0x18>
    9f04:	00008067          	ret
    9f08:	00008067          	ret
    9f0c:	00000513          	li	a0,0
    9f10:	00008067          	ret

00009f14 <_realloc_r>:
    9f14:	fd010113          	addi	sp,sp,-48
    9f18:	01312e23          	sw	s3,28(sp)
    9f1c:	02112623          	sw	ra,44(sp)
    9f20:	02812423          	sw	s0,40(sp)
    9f24:	02912223          	sw	s1,36(sp)
    9f28:	03212023          	sw	s2,32(sp)
    9f2c:	01412c23          	sw	s4,24(sp)
    9f30:	01512a23          	sw	s5,20(sp)
    9f34:	01612823          	sw	s6,16(sp)
    9f38:	01712623          	sw	s7,12(sp)
    9f3c:	01812423          	sw	s8,8(sp)
    9f40:	00060993          	mv	s3,a2
    9f44:	22058c63          	beqz	a1,a17c <_realloc_r+0x268>
    9f48:	00058b13          	mv	s6,a1
    9f4c:	00050a93          	mv	s5,a0
    9f50:	fb5fe0ef          	jal	ra,8f04 <__malloc_lock>
    9f54:	00b98413          	addi	s0,s3,11
    9f58:	01600793          	li	a5,22
    9f5c:	0e87fe63          	bgeu	a5,s0,a058 <_realloc_r+0x144>
    9f60:	ff847413          	andi	s0,s0,-8
    9f64:	00040713          	mv	a4,s0
    9f68:	0e044e63          	bltz	s0,a064 <_realloc_r+0x150>
    9f6c:	0f346c63          	bltu	s0,s3,a064 <_realloc_r+0x150>
    9f70:	ffcb2783          	lw	a5,-4(s6)
    9f74:	ff8b0913          	addi	s2,s6,-8
    9f78:	ffc7f493          	andi	s1,a5,-4
    9f7c:	00990a33          	add	s4,s2,s1
    9f80:	1ae4d463          	bge	s1,a4,a128 <_realloc_r+0x214>
    9f84:	0000d697          	auipc	a3,0xd
    9f88:	93068693          	addi	a3,a3,-1744 # 168b4 <__malloc_av_>
    9f8c:	0086a603          	lw	a2,8(a3)
    9f90:	004a2683          	lw	a3,4(s4)
    9f94:	25460663          	beq	a2,s4,a1e0 <_realloc_r+0x2cc>
    9f98:	ffe6f613          	andi	a2,a3,-2
    9f9c:	00ca0633          	add	a2,s4,a2
    9fa0:	00462603          	lw	a2,4(a2)
    9fa4:	00167613          	andi	a2,a2,1
    9fa8:	1a061c63          	bnez	a2,a160 <_realloc_r+0x24c>
    9fac:	ffc6f693          	andi	a3,a3,-4
    9fb0:	00d48633          	add	a2,s1,a3
    9fb4:	34e65a63          	bge	a2,a4,a308 <_realloc_r+0x3f4>
    9fb8:	0017f793          	andi	a5,a5,1
    9fbc:	02079463          	bnez	a5,9fe4 <_realloc_r+0xd0>
    9fc0:	ff8b2c03          	lw	s8,-8(s6)
    9fc4:	41890c33          	sub	s8,s2,s8
    9fc8:	004c2783          	lw	a5,4(s8)
    9fcc:	ffc7f793          	andi	a5,a5,-4
    9fd0:	00d786b3          	add	a3,a5,a3
    9fd4:	00968bb3          	add	s7,a3,s1
    9fd8:	0cebd663          	bge	s7,a4,a0a4 <_realloc_r+0x190>
    9fdc:	00f48bb3          	add	s7,s1,a5
    9fe0:	34ebdc63          	bge	s7,a4,a338 <_realloc_r+0x424>
    9fe4:	00098593          	mv	a1,s3
    9fe8:	000a8513          	mv	a0,s5
    9fec:	aa4fe0ef          	jal	ra,8290 <_malloc_r>
    9ff0:	00050993          	mv	s3,a0
    9ff4:	04050c63          	beqz	a0,a04c <_realloc_r+0x138>
    9ff8:	ffcb2783          	lw	a5,-4(s6)
    9ffc:	ff850713          	addi	a4,a0,-8
    a000:	ffe7f793          	andi	a5,a5,-2
    a004:	00f907b3          	add	a5,s2,a5
    a008:	30e78e63          	beq	a5,a4,a324 <_realloc_r+0x410>
    a00c:	ffc48613          	addi	a2,s1,-4
    a010:	02400793          	li	a5,36
    a014:	38c7ee63          	bltu	a5,a2,a3b0 <_realloc_r+0x49c>
    a018:	01300713          	li	a4,19
    a01c:	000b2683          	lw	a3,0(s6)
    a020:	28c76663          	bltu	a4,a2,a2ac <_realloc_r+0x398>
    a024:	00050793          	mv	a5,a0
    a028:	000b0713          	mv	a4,s6
    a02c:	00d7a023          	sw	a3,0(a5)
    a030:	00472683          	lw	a3,4(a4)
    a034:	00d7a223          	sw	a3,4(a5)
    a038:	00872703          	lw	a4,8(a4)
    a03c:	00e7a423          	sw	a4,8(a5)
    a040:	000b0593          	mv	a1,s6
    a044:	000a8513          	mv	a0,s5
    a048:	b3dfa0ef          	jal	ra,4b84 <_free_r>
    a04c:	000a8513          	mv	a0,s5
    a050:	eb9fe0ef          	jal	ra,8f08 <__malloc_unlock>
    a054:	01c0006f          	j	a070 <_realloc_r+0x15c>
    a058:	01000413          	li	s0,16
    a05c:	01000713          	li	a4,16
    a060:	f13478e3          	bgeu	s0,s3,9f70 <_realloc_r+0x5c>
    a064:	00c00793          	li	a5,12
    a068:	00faa023          	sw	a5,0(s5)
    a06c:	00000993          	li	s3,0
    a070:	02c12083          	lw	ra,44(sp)
    a074:	02812403          	lw	s0,40(sp)
    a078:	00098513          	mv	a0,s3
    a07c:	02412483          	lw	s1,36(sp)
    a080:	02012903          	lw	s2,32(sp)
    a084:	01c12983          	lw	s3,28(sp)
    a088:	01812a03          	lw	s4,24(sp)
    a08c:	01412a83          	lw	s5,20(sp)
    a090:	01012b03          	lw	s6,16(sp)
    a094:	00c12b83          	lw	s7,12(sp)
    a098:	00812c03          	lw	s8,8(sp)
    a09c:	03010113          	addi	sp,sp,48
    a0a0:	00008067          	ret
    a0a4:	00ca2783          	lw	a5,12(s4)
    a0a8:	008a2703          	lw	a4,8(s4)
    a0ac:	ffc48613          	addi	a2,s1,-4
    a0b0:	02400693          	li	a3,36
    a0b4:	00f72623          	sw	a5,12(a4)
    a0b8:	00e7a423          	sw	a4,8(a5)
    a0bc:	008c2703          	lw	a4,8(s8)
    a0c0:	00cc2783          	lw	a5,12(s8)
    a0c4:	008c0993          	addi	s3,s8,8
    a0c8:	017c0a33          	add	s4,s8,s7
    a0cc:	00f72623          	sw	a5,12(a4)
    a0d0:	00e7a423          	sw	a4,8(a5)
    a0d4:	2ec6e463          	bltu	a3,a2,a3bc <_realloc_r+0x4a8>
    a0d8:	01300693          	li	a3,19
    a0dc:	000b2703          	lw	a4,0(s6)
    a0e0:	00098793          	mv	a5,s3
    a0e4:	02c6f263          	bgeu	a3,a2,a108 <_realloc_r+0x1f4>
    a0e8:	00ec2423          	sw	a4,8(s8)
    a0ec:	004b2703          	lw	a4,4(s6)
    a0f0:	01b00793          	li	a5,27
    a0f4:	00ec2623          	sw	a4,12(s8)
    a0f8:	008b2703          	lw	a4,8(s6)
    a0fc:	34c7e263          	bltu	a5,a2,a440 <_realloc_r+0x52c>
    a100:	010c0793          	addi	a5,s8,16
    a104:	008b0b13          	addi	s6,s6,8
    a108:	00e7a023          	sw	a4,0(a5)
    a10c:	004b2703          	lw	a4,4(s6)
    a110:	000b8493          	mv	s1,s7
    a114:	000c0913          	mv	s2,s8
    a118:	00e7a223          	sw	a4,4(a5)
    a11c:	008b2703          	lw	a4,8(s6)
    a120:	00098b13          	mv	s6,s3
    a124:	00e7a423          	sw	a4,8(a5)
    a128:	00492603          	lw	a2,4(s2)
    a12c:	408487b3          	sub	a5,s1,s0
    a130:	00f00713          	li	a4,15
    a134:	00167613          	andi	a2,a2,1
    a138:	06f76c63          	bltu	a4,a5,a1b0 <_realloc_r+0x29c>
    a13c:	00c4e633          	or	a2,s1,a2
    a140:	00c92223          	sw	a2,4(s2)
    a144:	004a2783          	lw	a5,4(s4)
    a148:	0017e793          	ori	a5,a5,1
    a14c:	00fa2223          	sw	a5,4(s4)
    a150:	000a8513          	mv	a0,s5
    a154:	db5fe0ef          	jal	ra,8f08 <__malloc_unlock>
    a158:	000b0993          	mv	s3,s6
    a15c:	f15ff06f          	j	a070 <_realloc_r+0x15c>
    a160:	0017f793          	andi	a5,a5,1
    a164:	e80790e3          	bnez	a5,9fe4 <_realloc_r+0xd0>
    a168:	ff8b2c03          	lw	s8,-8(s6)
    a16c:	41890c33          	sub	s8,s2,s8
    a170:	004c2783          	lw	a5,4(s8)
    a174:	ffc7f793          	andi	a5,a5,-4
    a178:	e65ff06f          	j	9fdc <_realloc_r+0xc8>
    a17c:	02812403          	lw	s0,40(sp)
    a180:	02c12083          	lw	ra,44(sp)
    a184:	02412483          	lw	s1,36(sp)
    a188:	02012903          	lw	s2,32(sp)
    a18c:	01c12983          	lw	s3,28(sp)
    a190:	01812a03          	lw	s4,24(sp)
    a194:	01412a83          	lw	s5,20(sp)
    a198:	01012b03          	lw	s6,16(sp)
    a19c:	00c12b83          	lw	s7,12(sp)
    a1a0:	00812c03          	lw	s8,8(sp)
    a1a4:	00060593          	mv	a1,a2
    a1a8:	03010113          	addi	sp,sp,48
    a1ac:	8e4fe06f          	j	8290 <_malloc_r>
    a1b0:	00866633          	or	a2,a2,s0
    a1b4:	00c92223          	sw	a2,4(s2)
    a1b8:	008905b3          	add	a1,s2,s0
    a1bc:	0017e793          	ori	a5,a5,1
    a1c0:	00f5a223          	sw	a5,4(a1)
    a1c4:	004a2783          	lw	a5,4(s4)
    a1c8:	00858593          	addi	a1,a1,8
    a1cc:	000a8513          	mv	a0,s5
    a1d0:	0017e793          	ori	a5,a5,1
    a1d4:	00fa2223          	sw	a5,4(s4)
    a1d8:	9adfa0ef          	jal	ra,4b84 <_free_r>
    a1dc:	f75ff06f          	j	a150 <_realloc_r+0x23c>
    a1e0:	ffc6f693          	andi	a3,a3,-4
    a1e4:	00d48633          	add	a2,s1,a3
    a1e8:	01040593          	addi	a1,s0,16
    a1ec:	0eb65263          	bge	a2,a1,a2d0 <_realloc_r+0x3bc>
    a1f0:	0017f793          	andi	a5,a5,1
    a1f4:	de0798e3          	bnez	a5,9fe4 <_realloc_r+0xd0>
    a1f8:	ff8b2c03          	lw	s8,-8(s6)
    a1fc:	41890c33          	sub	s8,s2,s8
    a200:	004c2783          	lw	a5,4(s8)
    a204:	ffc7f793          	andi	a5,a5,-4
    a208:	00d786b3          	add	a3,a5,a3
    a20c:	00968a33          	add	s4,a3,s1
    a210:	dcba46e3          	blt	s4,a1,9fdc <_realloc_r+0xc8>
    a214:	00cc2783          	lw	a5,12(s8)
    a218:	008c2703          	lw	a4,8(s8)
    a21c:	ffc48613          	addi	a2,s1,-4
    a220:	02400693          	li	a3,36
    a224:	00f72623          	sw	a5,12(a4)
    a228:	00e7a423          	sw	a4,8(a5)
    a22c:	008c0993          	addi	s3,s8,8
    a230:	22c6ea63          	bltu	a3,a2,a464 <_realloc_r+0x550>
    a234:	01300593          	li	a1,19
    a238:	000b2703          	lw	a4,0(s6)
    a23c:	00098793          	mv	a5,s3
    a240:	02c5f263          	bgeu	a1,a2,a264 <_realloc_r+0x350>
    a244:	00ec2423          	sw	a4,8(s8)
    a248:	004b2703          	lw	a4,4(s6)
    a24c:	01b00793          	li	a5,27
    a250:	00ec2623          	sw	a4,12(s8)
    a254:	24c7ee63          	bltu	a5,a2,a4b0 <_realloc_r+0x59c>
    a258:	008b2703          	lw	a4,8(s6)
    a25c:	010c0793          	addi	a5,s8,16
    a260:	008b0b13          	addi	s6,s6,8
    a264:	00e7a023          	sw	a4,0(a5)
    a268:	004b2703          	lw	a4,4(s6)
    a26c:	00e7a223          	sw	a4,4(a5)
    a270:	008b2703          	lw	a4,8(s6)
    a274:	00e7a423          	sw	a4,8(a5)
    a278:	008c0733          	add	a4,s8,s0
    a27c:	408a07b3          	sub	a5,s4,s0
    a280:	0000c697          	auipc	a3,0xc
    a284:	62e6ae23          	sw	a4,1596(a3) # 168bc <__malloc_av_+0x8>
    a288:	0017e793          	ori	a5,a5,1
    a28c:	00f72223          	sw	a5,4(a4)
    a290:	004c2783          	lw	a5,4(s8)
    a294:	000a8513          	mv	a0,s5
    a298:	0017f793          	andi	a5,a5,1
    a29c:	0087e433          	or	s0,a5,s0
    a2a0:	008c2223          	sw	s0,4(s8)
    a2a4:	c65fe0ef          	jal	ra,8f08 <__malloc_unlock>
    a2a8:	dc9ff06f          	j	a070 <_realloc_r+0x15c>
    a2ac:	00d52023          	sw	a3,0(a0)
    a2b0:	004b2683          	lw	a3,4(s6)
    a2b4:	01b00713          	li	a4,27
    a2b8:	00d52223          	sw	a3,4(a0)
    a2bc:	10c76e63          	bltu	a4,a2,a3d8 <_realloc_r+0x4c4>
    a2c0:	008b0713          	addi	a4,s6,8
    a2c4:	00850793          	addi	a5,a0,8
    a2c8:	008b2683          	lw	a3,8(s6)
    a2cc:	d61ff06f          	j	a02c <_realloc_r+0x118>
    a2d0:	00890933          	add	s2,s2,s0
    a2d4:	408607b3          	sub	a5,a2,s0
    a2d8:	0000c717          	auipc	a4,0xc
    a2dc:	5f272223          	sw	s2,1508(a4) # 168bc <__malloc_av_+0x8>
    a2e0:	0017e793          	ori	a5,a5,1
    a2e4:	00f92223          	sw	a5,4(s2)
    a2e8:	ffcb2783          	lw	a5,-4(s6)
    a2ec:	000a8513          	mv	a0,s5
    a2f0:	000b0993          	mv	s3,s6
    a2f4:	0017f793          	andi	a5,a5,1
    a2f8:	0087e433          	or	s0,a5,s0
    a2fc:	fe8b2e23          	sw	s0,-4(s6)
    a300:	c09fe0ef          	jal	ra,8f08 <__malloc_unlock>
    a304:	d6dff06f          	j	a070 <_realloc_r+0x15c>
    a308:	00ca2783          	lw	a5,12(s4)
    a30c:	008a2703          	lw	a4,8(s4)
    a310:	00060493          	mv	s1,a2
    a314:	00c90a33          	add	s4,s2,a2
    a318:	00f72623          	sw	a5,12(a4)
    a31c:	00e7a423          	sw	a4,8(a5)
    a320:	e09ff06f          	j	a128 <_realloc_r+0x214>
    a324:	ffc52783          	lw	a5,-4(a0)
    a328:	ffc7f793          	andi	a5,a5,-4
    a32c:	00f484b3          	add	s1,s1,a5
    a330:	00990a33          	add	s4,s2,s1
    a334:	df5ff06f          	j	a128 <_realloc_r+0x214>
    a338:	00cc2703          	lw	a4,12(s8)
    a33c:	008c2683          	lw	a3,8(s8)
    a340:	ffc48613          	addi	a2,s1,-4
    a344:	02400593          	li	a1,36
    a348:	00e6a623          	sw	a4,12(a3)
    a34c:	00d72423          	sw	a3,8(a4)
    a350:	008c0993          	addi	s3,s8,8
    a354:	017c0a33          	add	s4,s8,s7
    a358:	06c5e263          	bltu	a1,a2,a3bc <_realloc_r+0x4a8>
    a35c:	01300513          	li	a0,19
    a360:	000b2683          	lw	a3,0(s6)
    a364:	00098713          	mv	a4,s3
    a368:	02c57263          	bgeu	a0,a2,a38c <_realloc_r+0x478>
    a36c:	00dc2423          	sw	a3,8(s8)
    a370:	004b2703          	lw	a4,4(s6)
    a374:	01b00793          	li	a5,27
    a378:	00ec2623          	sw	a4,12(s8)
    a37c:	0ac7e063          	bltu	a5,a2,a41c <_realloc_r+0x508>
    a380:	008b2683          	lw	a3,8(s6)
    a384:	010c0713          	addi	a4,s8,16
    a388:	008b0b13          	addi	s6,s6,8
    a38c:	00d72023          	sw	a3,0(a4)
    a390:	004b2683          	lw	a3,4(s6)
    a394:	000b8493          	mv	s1,s7
    a398:	000c0913          	mv	s2,s8
    a39c:	00d72223          	sw	a3,4(a4)
    a3a0:	008b2783          	lw	a5,8(s6)
    a3a4:	00098b13          	mv	s6,s3
    a3a8:	00f72423          	sw	a5,8(a4)
    a3ac:	d7dff06f          	j	a128 <_realloc_r+0x214>
    a3b0:	000b0593          	mv	a1,s6
    a3b4:	955fe0ef          	jal	ra,8d08 <memmove>
    a3b8:	c89ff06f          	j	a040 <_realloc_r+0x12c>
    a3bc:	000b0593          	mv	a1,s6
    a3c0:	00098513          	mv	a0,s3
    a3c4:	945fe0ef          	jal	ra,8d08 <memmove>
    a3c8:	00098b13          	mv	s6,s3
    a3cc:	000b8493          	mv	s1,s7
    a3d0:	000c0913          	mv	s2,s8
    a3d4:	d55ff06f          	j	a128 <_realloc_r+0x214>
    a3d8:	008b2703          	lw	a4,8(s6)
    a3dc:	00e52423          	sw	a4,8(a0)
    a3e0:	00cb2703          	lw	a4,12(s6)
    a3e4:	00e52623          	sw	a4,12(a0)
    a3e8:	00f60a63          	beq	a2,a5,a3fc <_realloc_r+0x4e8>
    a3ec:	010b0713          	addi	a4,s6,16
    a3f0:	01050793          	addi	a5,a0,16
    a3f4:	010b2683          	lw	a3,16(s6)
    a3f8:	c35ff06f          	j	a02c <_realloc_r+0x118>
    a3fc:	010b2683          	lw	a3,16(s6)
    a400:	018b0713          	addi	a4,s6,24
    a404:	01850793          	addi	a5,a0,24
    a408:	00d52823          	sw	a3,16(a0)
    a40c:	014b2683          	lw	a3,20(s6)
    a410:	00d52a23          	sw	a3,20(a0)
    a414:	018b2683          	lw	a3,24(s6)
    a418:	c15ff06f          	j	a02c <_realloc_r+0x118>
    a41c:	008b2783          	lw	a5,8(s6)
    a420:	00fc2823          	sw	a5,16(s8)
    a424:	00cb2783          	lw	a5,12(s6)
    a428:	00fc2a23          	sw	a5,20(s8)
    a42c:	04b60463          	beq	a2,a1,a474 <_realloc_r+0x560>
    a430:	010b2683          	lw	a3,16(s6)
    a434:	018c0713          	addi	a4,s8,24
    a438:	010b0b13          	addi	s6,s6,16
    a43c:	f51ff06f          	j	a38c <_realloc_r+0x478>
    a440:	00ec2823          	sw	a4,16(s8)
    a444:	00cb2703          	lw	a4,12(s6)
    a448:	02400793          	li	a5,36
    a44c:	00ec2a23          	sw	a4,20(s8)
    a450:	010b2703          	lw	a4,16(s6)
    a454:	04f60063          	beq	a2,a5,a494 <_realloc_r+0x580>
    a458:	018c0793          	addi	a5,s8,24
    a45c:	010b0b13          	addi	s6,s6,16
    a460:	ca9ff06f          	j	a108 <_realloc_r+0x1f4>
    a464:	000b0593          	mv	a1,s6
    a468:	00098513          	mv	a0,s3
    a46c:	89dfe0ef          	jal	ra,8d08 <memmove>
    a470:	e09ff06f          	j	a278 <_realloc_r+0x364>
    a474:	010b2783          	lw	a5,16(s6)
    a478:	020c0713          	addi	a4,s8,32
    a47c:	018b0b13          	addi	s6,s6,24
    a480:	00fc2c23          	sw	a5,24(s8)
    a484:	ffcb2783          	lw	a5,-4(s6)
    a488:	00fc2e23          	sw	a5,28(s8)
    a48c:	000b2683          	lw	a3,0(s6)
    a490:	efdff06f          	j	a38c <_realloc_r+0x478>
    a494:	00ec2c23          	sw	a4,24(s8)
    a498:	014b2703          	lw	a4,20(s6)
    a49c:	020c0793          	addi	a5,s8,32
    a4a0:	018b0b13          	addi	s6,s6,24
    a4a4:	00ec2e23          	sw	a4,28(s8)
    a4a8:	000b2703          	lw	a4,0(s6)
    a4ac:	c5dff06f          	j	a108 <_realloc_r+0x1f4>
    a4b0:	008b2783          	lw	a5,8(s6)
    a4b4:	00fc2823          	sw	a5,16(s8)
    a4b8:	00cb2783          	lw	a5,12(s6)
    a4bc:	00fc2a23          	sw	a5,20(s8)
    a4c0:	010b2703          	lw	a4,16(s6)
    a4c4:	00d60863          	beq	a2,a3,a4d4 <_realloc_r+0x5c0>
    a4c8:	018c0793          	addi	a5,s8,24
    a4cc:	010b0b13          	addi	s6,s6,16
    a4d0:	d95ff06f          	j	a264 <_realloc_r+0x350>
    a4d4:	00ec2c23          	sw	a4,24(s8)
    a4d8:	014b2703          	lw	a4,20(s6)
    a4dc:	020c0793          	addi	a5,s8,32
    a4e0:	018b0b13          	addi	s6,s6,24
    a4e4:	00ec2e23          	sw	a4,28(s8)
    a4e8:	000b2703          	lw	a4,0(s6)
    a4ec:	d79ff06f          	j	a264 <_realloc_r+0x350>

0000a4f0 <_sbrk_r>:
    a4f0:	ff010113          	addi	sp,sp,-16
    a4f4:	00812423          	sw	s0,8(sp)
    a4f8:	00050413          	mv	s0,a0
    a4fc:	00058513          	mv	a0,a1
    a500:	8601a423          	sw	zero,-1944(gp) # 16d18 <errno>
    a504:	00112623          	sw	ra,12(sp)
    a508:	5910a0ef          	jal	ra,15298 <_sbrk>
    a50c:	fff00793          	li	a5,-1
    a510:	00f50a63          	beq	a0,a5,a524 <_sbrk_r+0x34>
    a514:	00c12083          	lw	ra,12(sp)
    a518:	00812403          	lw	s0,8(sp)
    a51c:	01010113          	addi	sp,sp,16
    a520:	00008067          	ret
    a524:	86818793          	addi	a5,gp,-1944 # 16d18 <errno>
    a528:	0007a783          	lw	a5,0(a5)
    a52c:	fe0784e3          	beqz	a5,a514 <_sbrk_r+0x24>
    a530:	00f42023          	sw	a5,0(s0)
    a534:	00c12083          	lw	ra,12(sp)
    a538:	00812403          	lw	s0,8(sp)
    a53c:	01010113          	addi	sp,sp,16
    a540:	00008067          	ret

0000a544 <frexp>:
    a544:	ff010113          	addi	sp,sp,-16
    a548:	00812423          	sw	s0,8(sp)
    a54c:	80000437          	lui	s0,0x80000
    a550:	00912223          	sw	s1,4(sp)
    a554:	00112623          	sw	ra,12(sp)
    a558:	fff44413          	not	s0,s0
    a55c:	00060493          	mv	s1,a2
    a560:	00062023          	sw	zero,0(a2)
    a564:	00b47733          	and	a4,s0,a1
    a568:	7ff00637          	lui	a2,0x7ff00
    a56c:	00058793          	mv	a5,a1
    a570:	00050693          	mv	a3,a0
    a574:	06c75263          	bge	a4,a2,a5d8 <frexp+0x94>
    a578:	00a768b3          	or	a7,a4,a0
    a57c:	04088e63          	beqz	a7,a5d8 <frexp+0x94>
    a580:	00c5f633          	and	a2,a1,a2
    a584:	00058813          	mv	a6,a1
    a588:	00000893          	li	a7,0
    a58c:	02061463          	bnez	a2,a5b4 <frexp+0x70>
    a590:	0000b797          	auipc	a5,0xb
    a594:	62078793          	addi	a5,a5,1568 # 15bb0 <p05.3298+0x10>
    a598:	0047a683          	lw	a3,4(a5)
    a59c:	0007a603          	lw	a2,0(a5)
    a5a0:	2e8070ef          	jal	ra,11888 <__muldf3>
    a5a4:	00050693          	mv	a3,a0
    a5a8:	00058813          	mv	a6,a1
    a5ac:	00b47733          	and	a4,s0,a1
    a5b0:	fca00893          	li	a7,-54
    a5b4:	41475713          	srai	a4,a4,0x14
    a5b8:	801007b7          	lui	a5,0x80100
    a5bc:	fff78793          	addi	a5,a5,-1 # 800fffff <__freertos_irq_stack_top+0x800e82df>
    a5c0:	c0270713          	addi	a4,a4,-1022
    a5c4:	00f87833          	and	a6,a6,a5
    a5c8:	01170733          	add	a4,a4,a7
    a5cc:	3fe007b7          	lui	a5,0x3fe00
    a5d0:	00f867b3          	or	a5,a6,a5
    a5d4:	00e4a023          	sw	a4,0(s1)
    a5d8:	00c12083          	lw	ra,12(sp)
    a5dc:	00812403          	lw	s0,8(sp)
    a5e0:	00412483          	lw	s1,4(sp)
    a5e4:	00068513          	mv	a0,a3
    a5e8:	00078593          	mv	a1,a5
    a5ec:	01010113          	addi	sp,sp,16
    a5f0:	00008067          	ret

0000a5f4 <_sprintf_r>:
    a5f4:	f6010113          	addi	sp,sp,-160
    a5f8:	08c10e13          	addi	t3,sp,140
    a5fc:	08f12a23          	sw	a5,148(sp)
    a600:	80000337          	lui	t1,0x80000
    a604:	ffff07b7          	lui	a5,0xffff0
    a608:	00058e93          	mv	t4,a1
    a60c:	fff34313          	not	t1,t1
    a610:	08d12623          	sw	a3,140(sp)
    a614:	20878793          	addi	a5,a5,520 # ffff0208 <__freertos_irq_stack_top+0xfffd84e8>
    a618:	00810593          	addi	a1,sp,8
    a61c:	000e0693          	mv	a3,t3
    a620:	06112e23          	sw	ra,124(sp)
    a624:	00f12a23          	sw	a5,20(sp)
    a628:	08e12823          	sw	a4,144(sp)
    a62c:	09012c23          	sw	a6,152(sp)
    a630:	09112e23          	sw	a7,156(sp)
    a634:	01d12423          	sw	t4,8(sp)
    a638:	01d12c23          	sw	t4,24(sp)
    a63c:	00612e23          	sw	t1,28(sp)
    a640:	00612823          	sw	t1,16(sp)
    a644:	01c12223          	sw	t3,4(sp)
    a648:	438000ef          	jal	ra,aa80 <_svfprintf_r>
    a64c:	00812783          	lw	a5,8(sp)
    a650:	00078023          	sb	zero,0(a5)
    a654:	07c12083          	lw	ra,124(sp)
    a658:	0a010113          	addi	sp,sp,160
    a65c:	00008067          	ret

0000a660 <sprintf>:
    a660:	00050e93          	mv	t4,a0
    a664:	81018513          	addi	a0,gp,-2032 # 16cc0 <_impure_ptr>
    a668:	f6010113          	addi	sp,sp,-160
    a66c:	00052503          	lw	a0,0(a0)
    a670:	08810e13          	addi	t3,sp,136
    a674:	08f12a23          	sw	a5,148(sp)
    a678:	80000337          	lui	t1,0x80000
    a67c:	ffff07b7          	lui	a5,0xffff0
    a680:	fff34313          	not	t1,t1
    a684:	08c12423          	sw	a2,136(sp)
    a688:	08d12623          	sw	a3,140(sp)
    a68c:	20878793          	addi	a5,a5,520 # ffff0208 <__freertos_irq_stack_top+0xfffd84e8>
    a690:	00058613          	mv	a2,a1
    a694:	000e0693          	mv	a3,t3
    a698:	00810593          	addi	a1,sp,8
    a69c:	06112e23          	sw	ra,124(sp)
    a6a0:	00f12a23          	sw	a5,20(sp)
    a6a4:	08e12823          	sw	a4,144(sp)
    a6a8:	09012c23          	sw	a6,152(sp)
    a6ac:	09112e23          	sw	a7,156(sp)
    a6b0:	01d12423          	sw	t4,8(sp)
    a6b4:	01d12c23          	sw	t4,24(sp)
    a6b8:	00612e23          	sw	t1,28(sp)
    a6bc:	00612823          	sw	t1,16(sp)
    a6c0:	01c12223          	sw	t3,4(sp)
    a6c4:	3bc000ef          	jal	ra,aa80 <_svfprintf_r>
    a6c8:	00812783          	lw	a5,8(sp)
    a6cc:	00078023          	sb	zero,0(a5)
    a6d0:	07c12083          	lw	ra,124(sp)
    a6d4:	0a010113          	addi	sp,sp,160
    a6d8:	00008067          	ret

0000a6dc <__sread>:
    a6dc:	ff010113          	addi	sp,sp,-16
    a6e0:	00812423          	sw	s0,8(sp)
    a6e4:	00058413          	mv	s0,a1
    a6e8:	00e59583          	lh	a1,14(a1)
    a6ec:	00112623          	sw	ra,12(sp)
    a6f0:	0bd040ef          	jal	ra,efac <_read_r>
    a6f4:	02054063          	bltz	a0,a714 <__sread+0x38>
    a6f8:	05042783          	lw	a5,80(s0) # 80000050 <__freertos_irq_stack_top+0x7ffe8330>
    a6fc:	00c12083          	lw	ra,12(sp)
    a700:	00a787b3          	add	a5,a5,a0
    a704:	04f42823          	sw	a5,80(s0)
    a708:	00812403          	lw	s0,8(sp)
    a70c:	01010113          	addi	sp,sp,16
    a710:	00008067          	ret
    a714:	00c45783          	lhu	a5,12(s0)
    a718:	fffff737          	lui	a4,0xfffff
    a71c:	fff70713          	addi	a4,a4,-1 # ffffefff <__freertos_irq_stack_top+0xfffe72df>
    a720:	00e7f7b3          	and	a5,a5,a4
    a724:	00f41623          	sh	a5,12(s0)
    a728:	00c12083          	lw	ra,12(sp)
    a72c:	00812403          	lw	s0,8(sp)
    a730:	01010113          	addi	sp,sp,16
    a734:	00008067          	ret

0000a738 <__seofread>:
    a738:	00000513          	li	a0,0
    a73c:	00008067          	ret

0000a740 <__swrite>:
    a740:	00c59783          	lh	a5,12(a1)
    a744:	fe010113          	addi	sp,sp,-32
    a748:	00812c23          	sw	s0,24(sp)
    a74c:	00912a23          	sw	s1,20(sp)
    a750:	01212823          	sw	s2,16(sp)
    a754:	01312623          	sw	s3,12(sp)
    a758:	00112e23          	sw	ra,28(sp)
    a75c:	1007f713          	andi	a4,a5,256
    a760:	00058413          	mv	s0,a1
    a764:	00050493          	mv	s1,a0
    a768:	00060913          	mv	s2,a2
    a76c:	00068993          	mv	s3,a3
    a770:	00e59583          	lh	a1,14(a1)
    a774:	02071e63          	bnez	a4,a7b0 <__swrite+0x70>
    a778:	fffff737          	lui	a4,0xfffff
    a77c:	fff70713          	addi	a4,a4,-1 # ffffefff <__freertos_irq_stack_top+0xfffe72df>
    a780:	00e7f7b3          	and	a5,a5,a4
    a784:	00f41623          	sh	a5,12(s0)
    a788:	01812403          	lw	s0,24(sp)
    a78c:	01c12083          	lw	ra,28(sp)
    a790:	00098693          	mv	a3,s3
    a794:	00090613          	mv	a2,s2
    a798:	00c12983          	lw	s3,12(sp)
    a79c:	01012903          	lw	s2,16(sp)
    a7a0:	00048513          	mv	a0,s1
    a7a4:	01412483          	lw	s1,20(sp)
    a7a8:	02010113          	addi	sp,sp,32
    a7ac:	2900406f          	j	ea3c <_write_r>
    a7b0:	00200693          	li	a3,2
    a7b4:	00000613          	li	a2,0
    a7b8:	794040ef          	jal	ra,ef4c <_lseek_r>
    a7bc:	00c41783          	lh	a5,12(s0)
    a7c0:	00e41583          	lh	a1,14(s0)
    a7c4:	fb5ff06f          	j	a778 <__swrite+0x38>

0000a7c8 <__sseek>:
    a7c8:	ff010113          	addi	sp,sp,-16
    a7cc:	00812423          	sw	s0,8(sp)
    a7d0:	00058413          	mv	s0,a1
    a7d4:	00e59583          	lh	a1,14(a1)
    a7d8:	00112623          	sw	ra,12(sp)
    a7dc:	770040ef          	jal	ra,ef4c <_lseek_r>
    a7e0:	fff00793          	li	a5,-1
    a7e4:	02f50463          	beq	a0,a5,a80c <__sseek+0x44>
    a7e8:	00c45783          	lhu	a5,12(s0)
    a7ec:	00001737          	lui	a4,0x1
    a7f0:	04a42823          	sw	a0,80(s0)
    a7f4:	00e7e7b3          	or	a5,a5,a4
    a7f8:	00f41623          	sh	a5,12(s0)
    a7fc:	00c12083          	lw	ra,12(sp)
    a800:	00812403          	lw	s0,8(sp)
    a804:	01010113          	addi	sp,sp,16
    a808:	00008067          	ret
    a80c:	00c45783          	lhu	a5,12(s0)
    a810:	fffff737          	lui	a4,0xfffff
    a814:	fff70713          	addi	a4,a4,-1 # ffffefff <__freertos_irq_stack_top+0xfffe72df>
    a818:	00e7f7b3          	and	a5,a5,a4
    a81c:	00f41623          	sh	a5,12(s0)
    a820:	00c12083          	lw	ra,12(sp)
    a824:	00812403          	lw	s0,8(sp)
    a828:	01010113          	addi	sp,sp,16
    a82c:	00008067          	ret

0000a830 <__sclose>:
    a830:	00e59583          	lh	a1,14(a1)
    a834:	3180406f          	j	eb4c <_close_r>

0000a838 <strcmp>:
    a838:	00b56733          	or	a4,a0,a1
    a83c:	fff00393          	li	t2,-1
    a840:	00377713          	andi	a4,a4,3
    a844:	10071063          	bnez	a4,a944 <strcmp+0x10c>
    a848:	7f7f87b7          	lui	a5,0x7f7f8
    a84c:	f7f78793          	addi	a5,a5,-129 # 7f7f7f7f <__freertos_irq_stack_top+0x7f7e025f>
    a850:	00052603          	lw	a2,0(a0)
    a854:	0005a683          	lw	a3,0(a1)
    a858:	00f672b3          	and	t0,a2,a5
    a85c:	00f66333          	or	t1,a2,a5
    a860:	00f282b3          	add	t0,t0,a5
    a864:	0062e2b3          	or	t0,t0,t1
    a868:	10729263          	bne	t0,t2,a96c <strcmp+0x134>
    a86c:	08d61663          	bne	a2,a3,a8f8 <strcmp+0xc0>
    a870:	00452603          	lw	a2,4(a0)
    a874:	0045a683          	lw	a3,4(a1)
    a878:	00f672b3          	and	t0,a2,a5
    a87c:	00f66333          	or	t1,a2,a5
    a880:	00f282b3          	add	t0,t0,a5
    a884:	0062e2b3          	or	t0,t0,t1
    a888:	0c729e63          	bne	t0,t2,a964 <strcmp+0x12c>
    a88c:	06d61663          	bne	a2,a3,a8f8 <strcmp+0xc0>
    a890:	00852603          	lw	a2,8(a0)
    a894:	0085a683          	lw	a3,8(a1)
    a898:	00f672b3          	and	t0,a2,a5
    a89c:	00f66333          	or	t1,a2,a5
    a8a0:	00f282b3          	add	t0,t0,a5
    a8a4:	0062e2b3          	or	t0,t0,t1
    a8a8:	0c729863          	bne	t0,t2,a978 <strcmp+0x140>
    a8ac:	04d61663          	bne	a2,a3,a8f8 <strcmp+0xc0>
    a8b0:	00c52603          	lw	a2,12(a0)
    a8b4:	00c5a683          	lw	a3,12(a1)
    a8b8:	00f672b3          	and	t0,a2,a5
    a8bc:	00f66333          	or	t1,a2,a5
    a8c0:	00f282b3          	add	t0,t0,a5
    a8c4:	0062e2b3          	or	t0,t0,t1
    a8c8:	0c729263          	bne	t0,t2,a98c <strcmp+0x154>
    a8cc:	02d61663          	bne	a2,a3,a8f8 <strcmp+0xc0>
    a8d0:	01052603          	lw	a2,16(a0)
    a8d4:	0105a683          	lw	a3,16(a1)
    a8d8:	00f672b3          	and	t0,a2,a5
    a8dc:	00f66333          	or	t1,a2,a5
    a8e0:	00f282b3          	add	t0,t0,a5
    a8e4:	0062e2b3          	or	t0,t0,t1
    a8e8:	0a729c63          	bne	t0,t2,a9a0 <strcmp+0x168>
    a8ec:	01450513          	addi	a0,a0,20
    a8f0:	01458593          	addi	a1,a1,20
    a8f4:	f4d60ee3          	beq	a2,a3,a850 <strcmp+0x18>
    a8f8:	01061713          	slli	a4,a2,0x10
    a8fc:	01069793          	slli	a5,a3,0x10
    a900:	00f71e63          	bne	a4,a5,a91c <strcmp+0xe4>
    a904:	01065713          	srli	a4,a2,0x10
    a908:	0106d793          	srli	a5,a3,0x10
    a90c:	40f70533          	sub	a0,a4,a5
    a910:	0ff57593          	andi	a1,a0,255
    a914:	02059063          	bnez	a1,a934 <strcmp+0xfc>
    a918:	00008067          	ret
    a91c:	01075713          	srli	a4,a4,0x10
    a920:	0107d793          	srli	a5,a5,0x10
    a924:	40f70533          	sub	a0,a4,a5
    a928:	0ff57593          	andi	a1,a0,255
    a92c:	00059463          	bnez	a1,a934 <strcmp+0xfc>
    a930:	00008067          	ret
    a934:	0ff77713          	andi	a4,a4,255
    a938:	0ff7f793          	andi	a5,a5,255
    a93c:	40f70533          	sub	a0,a4,a5
    a940:	00008067          	ret
    a944:	00054603          	lbu	a2,0(a0)
    a948:	0005c683          	lbu	a3,0(a1)
    a94c:	00150513          	addi	a0,a0,1
    a950:	00158593          	addi	a1,a1,1
    a954:	00d61463          	bne	a2,a3,a95c <strcmp+0x124>
    a958:	fe0616e3          	bnez	a2,a944 <strcmp+0x10c>
    a95c:	40d60533          	sub	a0,a2,a3
    a960:	00008067          	ret
    a964:	00450513          	addi	a0,a0,4
    a968:	00458593          	addi	a1,a1,4
    a96c:	fcd61ce3          	bne	a2,a3,a944 <strcmp+0x10c>
    a970:	00000513          	li	a0,0
    a974:	00008067          	ret
    a978:	00850513          	addi	a0,a0,8
    a97c:	00858593          	addi	a1,a1,8
    a980:	fcd612e3          	bne	a2,a3,a944 <strcmp+0x10c>
    a984:	00000513          	li	a0,0
    a988:	00008067          	ret
    a98c:	00c50513          	addi	a0,a0,12
    a990:	00c58593          	addi	a1,a1,12
    a994:	fad618e3          	bne	a2,a3,a944 <strcmp+0x10c>
    a998:	00000513          	li	a0,0
    a99c:	00008067          	ret
    a9a0:	01050513          	addi	a0,a0,16
    a9a4:	01058593          	addi	a1,a1,16
    a9a8:	f8d61ee3          	bne	a2,a3,a944 <strcmp+0x10c>
    a9ac:	00000513          	li	a0,0
    a9b0:	00008067          	ret

0000a9b4 <strncpy>:
    a9b4:	00a5e7b3          	or	a5,a1,a0
    a9b8:	0037f793          	andi	a5,a5,3
    a9bc:	06079a63          	bnez	a5,aa30 <strncpy+0x7c>
    a9c0:	00300793          	li	a5,3
    a9c4:	00050713          	mv	a4,a0
    a9c8:	06c7e863          	bltu	a5,a2,aa38 <strncpy+0x84>
    a9cc:	06060063          	beqz	a2,aa2c <strncpy+0x78>
    a9d0:	0005c803          	lbu	a6,0(a1)
    a9d4:	fff60693          	addi	a3,a2,-1 # 7fefffff <__freertos_irq_stack_top+0x7fee82df>
    a9d8:	00158593          	addi	a1,a1,1
    a9dc:	01070023          	sb	a6,0(a4)
    a9e0:	00170793          	addi	a5,a4,1
    a9e4:	02080863          	beqz	a6,aa14 <strncpy+0x60>
    a9e8:	00c70633          	add	a2,a4,a2
    a9ec:	00d706b3          	add	a3,a4,a3
    a9f0:	0140006f          	j	aa04 <strncpy+0x50>
    a9f4:	fff5c703          	lbu	a4,-1(a1)
    a9f8:	00178793          	addi	a5,a5,1
    a9fc:	fee78fa3          	sb	a4,-1(a5)
    aa00:	00070c63          	beqz	a4,aa18 <strncpy+0x64>
    aa04:	00158593          	addi	a1,a1,1
    aa08:	40f68833          	sub	a6,a3,a5
    aa0c:	fec794e3          	bne	a5,a2,a9f4 <strncpy+0x40>
    aa10:	00008067          	ret
    aa14:	00068813          	mv	a6,a3
    aa18:	01078733          	add	a4,a5,a6
    aa1c:	06080063          	beqz	a6,aa7c <strncpy+0xc8>
    aa20:	00178793          	addi	a5,a5,1
    aa24:	fe078fa3          	sb	zero,-1(a5)
    aa28:	fee79ce3          	bne	a5,a4,aa20 <strncpy+0x6c>
    aa2c:	00008067          	ret
    aa30:	00050713          	mv	a4,a0
    aa34:	f99ff06f          	j	a9cc <strncpy+0x18>
    aa38:	feff0337          	lui	t1,0xfeff0
    aa3c:	808088b7          	lui	a7,0x80808
    aa40:	eff30313          	addi	t1,t1,-257 # fefefeff <__freertos_irq_stack_top+0xfefd81df>
    aa44:	08088893          	addi	a7,a7,128 # 80808080 <__freertos_irq_stack_top+0x807f0360>
    aa48:	00300e13          	li	t3,3
    aa4c:	0005a683          	lw	a3,0(a1)
    aa50:	006687b3          	add	a5,a3,t1
    aa54:	fff6c813          	not	a6,a3
    aa58:	0107f7b3          	and	a5,a5,a6
    aa5c:	0117f7b3          	and	a5,a5,a7
    aa60:	f60798e3          	bnez	a5,a9d0 <strncpy+0x1c>
    aa64:	00470713          	addi	a4,a4,4
    aa68:	ffc60613          	addi	a2,a2,-4
    aa6c:	fed72e23          	sw	a3,-4(a4)
    aa70:	00458593          	addi	a1,a1,4
    aa74:	fcce6ce3          	bltu	t3,a2,aa4c <strncpy+0x98>
    aa78:	f55ff06f          	j	a9cc <strncpy+0x18>
    aa7c:	00008067          	ret

0000aa80 <_svfprintf_r>:
    aa80:	e1010113          	addi	sp,sp,-496
    aa84:	1e112623          	sw	ra,492(sp)
    aa88:	1e812423          	sw	s0,488(sp)
    aa8c:	1d812423          	sw	s8,456(sp)
    aa90:	00058413          	mv	s0,a1
    aa94:	00b12423          	sw	a1,8(sp)
    aa98:	00060c13          	mv	s8,a2
    aa9c:	00d12823          	sw	a3,16(sp)
    aaa0:	1e912223          	sw	s1,484(sp)
    aaa4:	1f212023          	sw	s2,480(sp)
    aaa8:	1d312e23          	sw	s3,476(sp)
    aaac:	1d412c23          	sw	s4,472(sp)
    aab0:	1d512a23          	sw	s5,468(sp)
    aab4:	1d612823          	sw	s6,464(sp)
    aab8:	1d712623          	sw	s7,460(sp)
    aabc:	1d912223          	sw	s9,452(sp)
    aac0:	1da12023          	sw	s10,448(sp)
    aac4:	1bb12e23          	sw	s11,444(sp)
    aac8:	02a12223          	sw	a0,36(sp)
    aacc:	d20fd0ef          	jal	ra,7fec <_localeconv_r>
    aad0:	00052783          	lw	a5,0(a0)
    aad4:	00078513          	mv	a0,a5
    aad8:	02f12823          	sw	a5,48(sp)
    aadc:	99df60ef          	jal	ra,1478 <strlen>
    aae0:	00c45783          	lhu	a5,12(s0)
    aae4:	02a12423          	sw	a0,40(sp)
    aae8:	0e012823          	sw	zero,240(sp)
    aaec:	0e012a23          	sw	zero,244(sp)
    aaf0:	0e012c23          	sw	zero,248(sp)
    aaf4:	0e012e23          	sw	zero,252(sp)
    aaf8:	0807f793          	andi	a5,a5,128
    aafc:	00078863          	beqz	a5,ab0c <_svfprintf_r+0x8c>
    ab00:	01042783          	lw	a5,16(s0)
    ab04:	00079463          	bnez	a5,ab0c <_svfprintf_r+0x8c>
    ab08:	6ec0106f          	j	c1f4 <_svfprintf_r+0x1774>
    ab0c:	000c0c93          	mv	s9,s8
    ab10:	000cc703          	lbu	a4,0(s9)
    ab14:	10c10793          	addi	a5,sp,268
    ab18:	0ef12223          	sw	a5,228(sp)
    ab1c:	0e012623          	sw	zero,236(sp)
    ab20:	0e012423          	sw	zero,232(sp)
    ab24:	00012c23          	sw	zero,24(sp)
    ab28:	02012623          	sw	zero,44(sp)
    ab2c:	02012c23          	sw	zero,56(sp)
    ab30:	02012e23          	sw	zero,60(sp)
    ab34:	04012023          	sw	zero,64(sp)
    ab38:	04012223          	sw	zero,68(sp)
    ab3c:	00012223          	sw	zero,4(sp)
    ab40:	01000b93          	li	s7,16
    ab44:	00078d13          	mv	s10,a5
    ab48:	02412a03          	lw	s4,36(sp)
    ab4c:	3a070463          	beqz	a4,aef4 <_svfprintf_r+0x474>
    ab50:	02500693          	li	a3,37
    ab54:	00d71463          	bne	a4,a3,ab5c <_svfprintf_r+0xdc>
    ab58:	5400106f          	j	c098 <_svfprintf_r+0x1618>
    ab5c:	000c8413          	mv	s0,s9
    ab60:	00c0006f          	j	ab6c <_svfprintf_r+0xec>
    ab64:	0ed78e63          	beq	a5,a3,ac60 <_svfprintf_r+0x1e0>
    ab68:	00090413          	mv	s0,s2
    ab6c:	00144783          	lbu	a5,1(s0)
    ab70:	00140913          	addi	s2,s0,1
    ab74:	fe0798e3          	bnez	a5,ab64 <_svfprintf_r+0xe4>
    ab78:	419904b3          	sub	s1,s2,s9
    ab7c:	36048c63          	beqz	s1,aef4 <_svfprintf_r+0x474>
    ab80:	0ec12683          	lw	a3,236(sp)
    ab84:	0e812703          	lw	a4,232(sp)
    ab88:	019d2023          	sw	s9,0(s10) # 1000 <__stack_size>
    ab8c:	009686b3          	add	a3,a3,s1
    ab90:	00170713          	addi	a4,a4,1
    ab94:	009d2223          	sw	s1,4(s10)
    ab98:	0ed12623          	sw	a3,236(sp)
    ab9c:	0ee12423          	sw	a4,232(sp)
    aba0:	00700693          	li	a3,7
    aba4:	008d0d13          	addi	s10,s10,8
    aba8:	0ce6c263          	blt	a3,a4,ac6c <_svfprintf_r+0x1ec>
    abac:	00412783          	lw	a5,4(sp)
    abb0:	00144703          	lbu	a4,1(s0)
    abb4:	009787b3          	add	a5,a5,s1
    abb8:	00f12223          	sw	a5,4(sp)
    abbc:	32070c63          	beqz	a4,aef4 <_svfprintf_r+0x474>
    abc0:	fff00313          	li	t1,-1
    abc4:	00190493          	addi	s1,s2,1
    abc8:	00194e03          	lbu	t3,1(s2)
    abcc:	0c0103a3          	sb	zero,199(sp)
    abd0:	00000413          	li	s0,0
    abd4:	00000913          	li	s2,0
    abd8:	00900993          	li	s3,9
    abdc:	02a00b13          	li	s6,42
    abe0:	00030c13          	mv	s8,t1
    abe4:	00148493          	addi	s1,s1,1
    abe8:	000e0a93          	mv	s5,t3
    abec:	05a00713          	li	a4,90
    abf0:	fe0a8793          	addi	a5,s5,-32
    abf4:	1ef76863          	bltu	a4,a5,ade4 <_svfprintf_r+0x364>
    abf8:	0000b697          	auipc	a3,0xb
    abfc:	fc068693          	addi	a3,a3,-64 # 15bb8 <p05.3298+0x18>
    ac00:	00279793          	slli	a5,a5,0x2
    ac04:	00d787b3          	add	a5,a5,a3
    ac08:	0007a783          	lw	a5,0(a5)
    ac0c:	00d787b3          	add	a5,a5,a3
    ac10:	00078067          	jr	a5
    ac14:	000a0513          	mv	a0,s4
    ac18:	bd4fd0ef          	jal	ra,7fec <_localeconv_r>
    ac1c:	00452783          	lw	a5,4(a0)
    ac20:	00078513          	mv	a0,a5
    ac24:	04f12223          	sw	a5,68(sp)
    ac28:	851f60ef          	jal	ra,1478 <strlen>
    ac2c:	04a12023          	sw	a0,64(sp)
    ac30:	00050a93          	mv	s5,a0
    ac34:	000a0513          	mv	a0,s4
    ac38:	bb4fd0ef          	jal	ra,7fec <_localeconv_r>
    ac3c:	00852783          	lw	a5,8(a0)
    ac40:	02f12e23          	sw	a5,60(sp)
    ac44:	000a8463          	beqz	s5,ac4c <_svfprintf_r+0x1cc>
    ac48:	5040106f          	j	c14c <_svfprintf_r+0x16cc>
    ac4c:	0004ce03          	lbu	t3,0(s1)
    ac50:	f95ff06f          	j	abe4 <_svfprintf_r+0x164>
    ac54:	02096913          	ori	s2,s2,32
    ac58:	0004ce03          	lbu	t3,0(s1)
    ac5c:	f89ff06f          	j	abe4 <_svfprintf_r+0x164>
    ac60:	419904b3          	sub	s1,s2,s9
    ac64:	f4048ee3          	beqz	s1,abc0 <_svfprintf_r+0x140>
    ac68:	f19ff06f          	j	ab80 <_svfprintf_r+0x100>
    ac6c:	00812583          	lw	a1,8(sp)
    ac70:	0e410613          	addi	a2,sp,228
    ac74:	000a0513          	mv	a0,s4
    ac78:	4e4040ef          	jal	ra,f15c <__ssprint_r>
    ac7c:	02051a63          	bnez	a0,acb0 <_svfprintf_r+0x230>
    ac80:	10c10d13          	addi	s10,sp,268
    ac84:	f29ff06f          	j	abac <_svfprintf_r+0x12c>
    ac88:	00812583          	lw	a1,8(sp)
    ac8c:	0e410613          	addi	a2,sp,228
    ac90:	000a0513          	mv	a0,s4
    ac94:	4c8040ef          	jal	ra,f15c <__ssprint_r>
    ac98:	040506e3          	beqz	a0,b4e4 <_svfprintf_r+0xa64>
    ac9c:	00c12783          	lw	a5,12(sp)
    aca0:	00078863          	beqz	a5,acb0 <_svfprintf_r+0x230>
    aca4:	00c12583          	lw	a1,12(sp)
    aca8:	02412503          	lw	a0,36(sp)
    acac:	ed9f90ef          	jal	ra,4b84 <_free_r>
    acb0:	00812783          	lw	a5,8(sp)
    acb4:	00c7d783          	lhu	a5,12(a5)
    acb8:	0407f793          	andi	a5,a5,64
    acbc:	00078463          	beqz	a5,acc4 <_svfprintf_r+0x244>
    acc0:	56c0206f          	j	d22c <_svfprintf_r+0x27ac>
    acc4:	1ec12083          	lw	ra,492(sp)
    acc8:	1e812403          	lw	s0,488(sp)
    accc:	00412503          	lw	a0,4(sp)
    acd0:	1e412483          	lw	s1,484(sp)
    acd4:	1e012903          	lw	s2,480(sp)
    acd8:	1dc12983          	lw	s3,476(sp)
    acdc:	1d812a03          	lw	s4,472(sp)
    ace0:	1d412a83          	lw	s5,468(sp)
    ace4:	1d012b03          	lw	s6,464(sp)
    ace8:	1cc12b83          	lw	s7,460(sp)
    acec:	1c812c03          	lw	s8,456(sp)
    acf0:	1c412c83          	lw	s9,452(sp)
    acf4:	1c012d03          	lw	s10,448(sp)
    acf8:	1bc12d83          	lw	s11,444(sp)
    acfc:	1f010113          	addi	sp,sp,496
    ad00:	00008067          	ret
    ad04:	0000b797          	auipc	a5,0xb
    ad08:	a9478793          	addi	a5,a5,-1388 # 15798 <_data+0x480>
    ad0c:	02f12623          	sw	a5,44(sp)
    ad10:	02097793          	andi	a5,s2,32
    ad14:	000c0313          	mv	t1,s8
    ad18:	10078063          	beqz	a5,ae18 <_svfprintf_r+0x398>
    ad1c:	01012783          	lw	a5,16(sp)
    ad20:	00778793          	addi	a5,a5,7
    ad24:	ff87f793          	andi	a5,a5,-8
    ad28:	0007ac03          	lw	s8,0(a5)
    ad2c:	0047ad83          	lw	s11,4(a5)
    ad30:	00878713          	addi	a4,a5,8
    ad34:	00e12823          	sw	a4,16(sp)
    ad38:	00197793          	andi	a5,s2,1
    ad3c:	00078863          	beqz	a5,ad4c <_svfprintf_r+0x2cc>
    ad40:	01bc67b3          	or	a5,s8,s11
    ad44:	00078463          	beqz	a5,ad4c <_svfprintf_r+0x2cc>
    ad48:	3e80106f          	j	c130 <_svfprintf_r+0x16b0>
    ad4c:	bff97993          	andi	s3,s2,-1025
    ad50:	00200793          	li	a5,2
    ad54:	0c0103a3          	sb	zero,199(sp)
    ad58:	fff00713          	li	a4,-1
    ad5c:	0ee308e3          	beq	t1,a4,b64c <_svfprintf_r+0xbcc>
    ad60:	01bc6733          	or	a4,s8,s11
    ad64:	f7f9f913          	andi	s2,s3,-129
    ad68:	00070463          	beqz	a4,ad70 <_svfprintf_r+0x2f0>
    ad6c:	7bd0006f          	j	bd28 <_svfprintf_r+0x12a8>
    ad70:	2e0310e3          	bnez	t1,b850 <_svfprintf_r+0xdd0>
    ad74:	62079a63          	bnez	a5,b3a8 <_svfprintf_r+0x928>
    ad78:	0019fb13          	andi	s6,s3,1
    ad7c:	1b010c93          	addi	s9,sp,432
    ad80:	000b0463          	beqz	s6,ad88 <_svfprintf_r+0x308>
    ad84:	36c0106f          	j	c0f0 <_svfprintf_r+0x1670>
    ad88:	000b0993          	mv	s3,s6
    ad8c:	006b5463          	bge	s6,t1,ad94 <_svfprintf_r+0x314>
    ad90:	00030993          	mv	s3,t1
    ad94:	0c714703          	lbu	a4,199(sp)
    ad98:	00012623          	sw	zero,12(sp)
    ad9c:	02012023          	sw	zero,32(sp)
    ada0:	00012e23          	sw	zero,28(sp)
    ada4:	00012a23          	sw	zero,20(sp)
    ada8:	64070463          	beqz	a4,b3f0 <_svfprintf_r+0x970>
    adac:	00198993          	addi	s3,s3,1
    adb0:	6400006f          	j	b3f0 <_svfprintf_r+0x970>
    adb4:	00000413          	li	s0,0
    adb8:	fd0a8693          	addi	a3,s5,-48
    adbc:	00148493          	addi	s1,s1,1
    adc0:	00241793          	slli	a5,s0,0x2
    adc4:	fff4ca83          	lbu	s5,-1(s1)
    adc8:	008787b3          	add	a5,a5,s0
    adcc:	00179793          	slli	a5,a5,0x1
    add0:	00f68433          	add	s0,a3,a5
    add4:	fd0a8693          	addi	a3,s5,-48
    add8:	fed9f2e3          	bgeu	s3,a3,adbc <_svfprintf_r+0x33c>
    addc:	fe0a8793          	addi	a5,s5,-32
    ade0:	e0f77ce3          	bgeu	a4,a5,abf8 <_svfprintf_r+0x178>
    ade4:	100a8863          	beqz	s5,aef4 <_svfprintf_r+0x474>
    ade8:	15510623          	sb	s5,332(sp)
    adec:	0c0103a3          	sb	zero,199(sp)
    adf0:	00100993          	li	s3,1
    adf4:	00100b13          	li	s6,1
    adf8:	14c10c93          	addi	s9,sp,332
    adfc:	5e00006f          	j	b3dc <_svfprintf_r+0x95c>
    ae00:	0000b797          	auipc	a5,0xb
    ae04:	9ac78793          	addi	a5,a5,-1620 # 157ac <_data+0x494>
    ae08:	02f12623          	sw	a5,44(sp)
    ae0c:	02097793          	andi	a5,s2,32
    ae10:	000c0313          	mv	t1,s8
    ae14:	f00794e3          	bnez	a5,ad1c <_svfprintf_r+0x29c>
    ae18:	01012703          	lw	a4,16(sp)
    ae1c:	01097793          	andi	a5,s2,16
    ae20:	00072c03          	lw	s8,0(a4)
    ae24:	00470713          	addi	a4,a4,4
    ae28:	00e12823          	sw	a4,16(sp)
    ae2c:	00078463          	beqz	a5,ae34 <_svfprintf_r+0x3b4>
    ae30:	2d80106f          	j	c108 <_svfprintf_r+0x1688>
    ae34:	04097793          	andi	a5,s2,64
    ae38:	00079463          	bnez	a5,ae40 <_svfprintf_r+0x3c0>
    ae3c:	2c40106f          	j	c100 <_svfprintf_r+0x1680>
    ae40:	010c1c13          	slli	s8,s8,0x10
    ae44:	010c5c13          	srli	s8,s8,0x10
    ae48:	00000d93          	li	s11,0
    ae4c:	eedff06f          	j	ad38 <_svfprintf_r+0x2b8>
    ae50:	0004ce03          	lbu	t3,0(s1)
    ae54:	00496913          	ori	s2,s2,4
    ae58:	d8dff06f          	j	abe4 <_svfprintf_r+0x164>
    ae5c:	02097793          	andi	a5,s2,32
    ae60:	000c0313          	mv	t1,s8
    ae64:	140796e3          	bnez	a5,b7b0 <_svfprintf_r+0xd30>
    ae68:	01012683          	lw	a3,16(sp)
    ae6c:	01097713          	andi	a4,s2,16
    ae70:	00468793          	addi	a5,a3,4
    ae74:	0006ac03          	lw	s8,0(a3)
    ae78:	4c071263          	bnez	a4,b33c <_svfprintf_r+0x8bc>
    ae7c:	04097713          	andi	a4,s2,64
    ae80:	00071463          	bnez	a4,ae88 <_svfprintf_r+0x408>
    ae84:	1a90106f          	j	c82c <_svfprintf_r+0x1dac>
    ae88:	010c1c13          	slli	s8,s8,0x10
    ae8c:	010c5c13          	srli	s8,s8,0x10
    ae90:	00000d93          	li	s11,0
    ae94:	00f12823          	sw	a5,16(sp)
    ae98:	1350006f          	j	b7cc <_svfprintf_r+0xd4c>
    ae9c:	01012683          	lw	a3,16(sp)
    aea0:	02097793          	andi	a5,s2,32
    aea4:	00468713          	addi	a4,a3,4
    aea8:	00078463          	beqz	a5,aeb0 <_svfprintf_r+0x430>
    aeac:	2640106f          	j	c110 <_svfprintf_r+0x1690>
    aeb0:	01097793          	andi	a5,s2,16
    aeb4:	00078463          	beqz	a5,aebc <_svfprintf_r+0x43c>
    aeb8:	0450106f          	j	c6fc <_svfprintf_r+0x1c7c>
    aebc:	04097793          	andi	a5,s2,64
    aec0:	00078463          	beqz	a5,aec8 <_svfprintf_r+0x448>
    aec4:	2710106f          	j	c934 <_svfprintf_r+0x1eb4>
    aec8:	20097913          	andi	s2,s2,512
    aecc:	00091463          	bnez	s2,aed4 <_svfprintf_r+0x454>
    aed0:	02d0106f          	j	c6fc <_svfprintf_r+0x1c7c>
    aed4:	01012783          	lw	a5,16(sp)
    aed8:	00e12823          	sw	a4,16(sp)
    aedc:	00412703          	lw	a4,4(sp)
    aee0:	0007a783          	lw	a5,0(a5)
    aee4:	00048c93          	mv	s9,s1
    aee8:	00e78023          	sb	a4,0(a5)
    aeec:	000cc703          	lbu	a4,0(s9)
    aef0:	c60710e3          	bnez	a4,ab50 <_svfprintf_r+0xd0>
    aef4:	0ec12783          	lw	a5,236(sp)
    aef8:	da078ce3          	beqz	a5,acb0 <_svfprintf_r+0x230>
    aefc:	00812403          	lw	s0,8(sp)
    af00:	02412503          	lw	a0,36(sp)
    af04:	0e410613          	addi	a2,sp,228
    af08:	00040593          	mv	a1,s0
    af0c:	250040ef          	jal	ra,f15c <__ssprint_r>
    af10:	00c45783          	lhu	a5,12(s0)
    af14:	da5ff06f          	j	acb8 <_svfprintf_r+0x238>
    af18:	0004ce03          	lbu	t3,0(s1)
    af1c:	06c00793          	li	a5,108
    af20:	00fe1463          	bne	t3,a5,af28 <_svfprintf_r+0x4a8>
    af24:	2c00106f          	j	c1e4 <_svfprintf_r+0x1764>
    af28:	01096913          	ori	s2,s2,16
    af2c:	cb9ff06f          	j	abe4 <_svfprintf_r+0x164>
    af30:	0004ce03          	lbu	t3,0(s1)
    af34:	06800793          	li	a5,104
    af38:	00fe1463          	bne	t3,a5,af40 <_svfprintf_r+0x4c0>
    af3c:	2980106f          	j	c1d4 <_svfprintf_r+0x1754>
    af40:	04096913          	ori	s2,s2,64
    af44:	ca1ff06f          	j	abe4 <_svfprintf_r+0x164>
    af48:	01012703          	lw	a4,16(sp)
    af4c:	ffff87b7          	lui	a5,0xffff8
    af50:	8307c793          	xori	a5,a5,-2000
    af54:	0cf11423          	sh	a5,200(sp)
    af58:	00470793          	addi	a5,a4,4
    af5c:	00f12823          	sw	a5,16(sp)
    af60:	0000b797          	auipc	a5,0xb
    af64:	83878793          	addi	a5,a5,-1992 # 15798 <_data+0x480>
    af68:	000c0313          	mv	t1,s8
    af6c:	02f12623          	sw	a5,44(sp)
    af70:	00072c03          	lw	s8,0(a4)
    af74:	00000d93          	li	s11,0
    af78:	00296993          	ori	s3,s2,2
    af7c:	00200793          	li	a5,2
    af80:	07800a93          	li	s5,120
    af84:	dd1ff06f          	j	ad54 <_svfprintf_r+0x2d4>
    af88:	00897713          	andi	a4,s2,8
    af8c:	000c0313          	mv	t1,s8
    af90:	00070463          	beqz	a4,af98 <_svfprintf_r+0x518>
    af94:	1dc0106f          	j	c170 <_svfprintf_r+0x16f0>
    af98:	01012783          	lw	a5,16(sp)
    af9c:	0b010513          	addi	a0,sp,176
    afa0:	01812623          	sw	s8,12(sp)
    afa4:	00778793          	addi	a5,a5,7
    afa8:	ff87f793          	andi	a5,a5,-8
    afac:	0007a583          	lw	a1,0(a5)
    afb0:	0047a603          	lw	a2,4(a5)
    afb4:	00878793          	addi	a5,a5,8
    afb8:	00f12823          	sw	a5,16(sp)
    afbc:	49d090ef          	jal	ra,14c58 <__extenddftf2>
    afc0:	0b012703          	lw	a4,176(sp)
    afc4:	00c12303          	lw	t1,12(sp)
    afc8:	0ee12823          	sw	a4,240(sp)
    afcc:	0b412703          	lw	a4,180(sp)
    afd0:	0ee12a23          	sw	a4,244(sp)
    afd4:	0b812703          	lw	a4,184(sp)
    afd8:	0ee12c23          	sw	a4,248(sp)
    afdc:	0bc12703          	lw	a4,188(sp)
    afe0:	0ee12e23          	sw	a4,252(sp)
    afe4:	0f010513          	addi	a0,sp,240
    afe8:	00612623          	sw	t1,12(sp)
    afec:	f95fc0ef          	jal	ra,7f80 <_ldcheck>
    aff0:	0ca12623          	sw	a0,204(sp)
    aff4:	00200713          	li	a4,2
    aff8:	00c12303          	lw	t1,12(sp)
    affc:	00e51463          	bne	a0,a4,b004 <_svfprintf_r+0x584>
    b000:	67c0106f          	j	c67c <_svfprintf_r+0x1bfc>
    b004:	00100713          	li	a4,1
    b008:	00e51463          	bne	a0,a4,b010 <_svfprintf_r+0x590>
    b00c:	05d0106f          	j	c868 <_svfprintf_r+0x1de8>
    b010:	06100713          	li	a4,97
    b014:	00ea9463          	bne	s5,a4,b01c <_svfprintf_r+0x59c>
    b018:	12c0206f          	j	d144 <_svfprintf_r+0x26c4>
    b01c:	04100713          	li	a4,65
    b020:	00ea9463          	bne	s5,a4,b028 <_svfprintf_r+0x5a8>
    b024:	4b90106f          	j	ccdc <_svfprintf_r+0x225c>
    b028:	fdfaf793          	andi	a5,s5,-33
    b02c:	fff00713          	li	a4,-1
    b030:	04f12423          	sw	a5,72(sp)
    b034:	00e31463          	bne	t1,a4,b03c <_svfprintf_r+0x5bc>
    b038:	1a10106f          	j	c9d8 <_svfprintf_r+0x1f58>
    b03c:	04700713          	li	a4,71
    b040:	00e79463          	bne	a5,a4,b048 <_svfprintf_r+0x5c8>
    b044:	1d80206f          	j	d21c <_svfprintf_r+0x279c>
    b048:	0fc12b03          	lw	s6,252(sp)
    b04c:	05212a23          	sw	s2,84(sp)
    b050:	10096713          	ori	a4,s2,256
    b054:	0f012f03          	lw	t5,240(sp)
    b058:	0f412d83          	lw	s11,244(sp)
    b05c:	0f812e83          	lw	t4,248(sp)
    b060:	000b5463          	bgez	s6,b068 <_svfprintf_r+0x5e8>
    b064:	0400206f          	j	d0a4 <_svfprintf_r+0x2624>
    b068:	04012e23          	sw	zero,92(sp)
    b06c:	00070913          	mv	s2,a4
    b070:	00012623          	sw	zero,12(sp)
    b074:	04812703          	lw	a4,72(sp)
    b078:	04600793          	li	a5,70
    b07c:	00f71463          	bne	a4,a5,b084 <_svfprintf_r+0x604>
    b080:	2a90106f          	j	cb28 <_svfprintf_r+0x20a8>
    b084:	04500793          	li	a5,69
    b088:	00f71463          	bne	a4,a5,b090 <_svfprintf_r+0x610>
    b08c:	0c80206f          	j	d154 <_svfprintf_r+0x26d4>
    b090:	0b010c13          	addi	s8,sp,176
    b094:	0d010793          	addi	a5,sp,208
    b098:	0cc10713          	addi	a4,sp,204
    b09c:	00030693          	mv	a3,t1
    b0a0:	0dc10813          	addi	a6,sp,220
    b0a4:	00200613          	li	a2,2
    b0a8:	000c0593          	mv	a1,s8
    b0ac:	000a0513          	mv	a0,s4
    b0b0:	00612e23          	sw	t1,28(sp)
    b0b4:	0be12823          	sw	t5,176(sp)
    b0b8:	01e12c23          	sw	t5,24(sp)
    b0bc:	0bd12c23          	sw	t4,184(sp)
    b0c0:	01d12a23          	sw	t4,20(sp)
    b0c4:	0bb12a23          	sw	s11,180(sp)
    b0c8:	0b612e23          	sw	s6,188(sp)
    b0cc:	bc1fb0ef          	jal	ra,6c8c <_ldtoa_r>
    b0d0:	04812783          	lw	a5,72(sp)
    b0d4:	04700713          	li	a4,71
    b0d8:	00050c93          	mv	s9,a0
    b0dc:	01412e83          	lw	t4,20(sp)
    b0e0:	01812f03          	lw	t5,24(sp)
    b0e4:	01c12303          	lw	t1,28(sp)
    b0e8:	00e78463          	beq	a5,a4,b0f0 <_svfprintf_r+0x670>
    b0ec:	4140206f          	j	d500 <_svfprintf_r+0x2a80>
    b0f0:	05412783          	lw	a5,84(sp)
    b0f4:	0017f713          	andi	a4,a5,1
    b0f8:	00070463          	beqz	a4,b100 <_svfprintf_r+0x680>
    b0fc:	1100206f          	j	d20c <_svfprintf_r+0x278c>
    b100:	0dc12703          	lw	a4,220(sp)
    b104:	419707b3          	sub	a5,a4,s9
    b108:	00f12c23          	sw	a5,24(sp)
    b10c:	0cc12783          	lw	a5,204(sp)
    b110:	04700713          	li	a4,71
    b114:	00f12a23          	sw	a5,20(sp)
    b118:	04812783          	lw	a5,72(sp)
    b11c:	00e79463          	bne	a5,a4,b124 <_svfprintf_r+0x6a4>
    b120:	0f90106f          	j	ca18 <_svfprintf_r+0x1f98>
    b124:	04812783          	lw	a5,72(sp)
    b128:	04600713          	li	a4,70
    b12c:	00e79463          	bne	a5,a4,b134 <_svfprintf_r+0x6b4>
    b130:	3890106f          	j	ccb8 <_svfprintf_r+0x2238>
    b134:	01412783          	lw	a5,20(sp)
    b138:	04100593          	li	a1,65
    b13c:	0ffaf693          	andi	a3,s5,255
    b140:	fff78713          	addi	a4,a5,-1
    b144:	04812783          	lw	a5,72(sp)
    b148:	0ce12623          	sw	a4,204(sp)
    b14c:	00000613          	li	a2,0
    b150:	00b79863          	bne	a5,a1,b160 <_svfprintf_r+0x6e0>
    b154:	00f68693          	addi	a3,a3,15
    b158:	0ff6f693          	andi	a3,a3,255
    b15c:	00100613          	li	a2,1
    b160:	0cd10a23          	sb	a3,212(sp)
    b164:	02b00693          	li	a3,43
    b168:	00075a63          	bgez	a4,b17c <_svfprintf_r+0x6fc>
    b16c:	01412783          	lw	a5,20(sp)
    b170:	00100713          	li	a4,1
    b174:	02d00693          	li	a3,45
    b178:	40f70733          	sub	a4,a4,a5
    b17c:	0cd10aa3          	sb	a3,213(sp)
    b180:	00900693          	li	a3,9
    b184:	00e6c463          	blt	a3,a4,b18c <_svfprintf_r+0x70c>
    b188:	2440206f          	j	d3cc <_svfprintf_r+0x294c>
    b18c:	0e310813          	addi	a6,sp,227
    b190:	00080613          	mv	a2,a6
    b194:	00a00513          	li	a0,10
    b198:	06300313          	li	t1,99
    b19c:	00c0006f          	j	b1a8 <_svfprintf_r+0x728>
    b1a0:	00058613          	mv	a2,a1
    b1a4:	00068713          	mv	a4,a3
    b1a8:	02a767b3          	rem	a5,a4,a0
    b1ac:	fff60593          	addi	a1,a2,-1
    b1b0:	03078793          	addi	a5,a5,48
    b1b4:	fef60fa3          	sb	a5,-1(a2)
    b1b8:	02a746b3          	div	a3,a4,a0
    b1bc:	fee342e3          	blt	t1,a4,b1a0 <_svfprintf_r+0x720>
    b1c0:	03068713          	addi	a4,a3,48
    b1c4:	0ff77713          	andi	a4,a4,255
    b1c8:	ffe60693          	addi	a3,a2,-2
    b1cc:	fee58fa3          	sb	a4,-1(a1)
    b1d0:	0106e463          	bltu	a3,a6,b1d8 <_svfprintf_r+0x758>
    b1d4:	3340206f          	j	d508 <_svfprintf_r+0x2a88>
    b1d8:	0d610593          	addi	a1,sp,214
    b1dc:	0080006f          	j	b1e4 <_svfprintf_r+0x764>
    b1e0:	0006c703          	lbu	a4,0(a3)
    b1e4:	00158593          	addi	a1,a1,1
    b1e8:	00168693          	addi	a3,a3,1
    b1ec:	fee58fa3          	sb	a4,-1(a1)
    b1f0:	ff0698e3          	bne	a3,a6,b1e0 <_svfprintf_r+0x760>
    b1f4:	0e510713          	addi	a4,sp,229
    b1f8:	0d610793          	addi	a5,sp,214
    b1fc:	40c70733          	sub	a4,a4,a2
    b200:	00e78733          	add	a4,a5,a4
    b204:	0d410693          	addi	a3,sp,212
    b208:	40d707b3          	sub	a5,a4,a3
    b20c:	02f12c23          	sw	a5,56(sp)
    b210:	01812783          	lw	a5,24(sp)
    b214:	03812683          	lw	a3,56(sp)
    b218:	00100713          	li	a4,1
    b21c:	00d78b33          	add	s6,a5,a3
    b220:	00f74463          	blt	a4,a5,b228 <_svfprintf_r+0x7a8>
    b224:	2600206f          	j	d484 <_svfprintf_r+0x2a04>
    b228:	02812783          	lw	a5,40(sp)
    b22c:	00fb0b33          	add	s6,s6,a5
    b230:	05412783          	lw	a5,84(sp)
    b234:	fffb4993          	not	s3,s6
    b238:	41f9d993          	srai	s3,s3,0x1f
    b23c:	bff7f913          	andi	s2,a5,-1025
    b240:	10096913          	ori	s2,s2,256
    b244:	013b79b3          	and	s3,s6,s3
    b248:	02012023          	sw	zero,32(sp)
    b24c:	00012e23          	sw	zero,28(sp)
    b250:	00012a23          	sw	zero,20(sp)
    b254:	05c12783          	lw	a5,92(sp)
    b258:	00079463          	bnez	a5,b260 <_svfprintf_r+0x7e0>
    b25c:	0310106f          	j	ca8c <_svfprintf_r+0x200c>
    b260:	02d00713          	li	a4,45
    b264:	0ce103a3          	sb	a4,199(sp)
    b268:	00000313          	li	t1,0
    b26c:	00198993          	addi	s3,s3,1
    b270:	1800006f          	j	b3f0 <_svfprintf_r+0x970>
    b274:	02097793          	andi	a5,s2,32
    b278:	000c0313          	mv	t1,s8
    b27c:	01096993          	ori	s3,s2,16
    b280:	54079e63          	bnez	a5,b7dc <_svfprintf_r+0xd5c>
    b284:	01012783          	lw	a5,16(sp)
    b288:	00478793          	addi	a5,a5,4
    b28c:	01012703          	lw	a4,16(sp)
    b290:	00000d93          	li	s11,0
    b294:	00f12823          	sw	a5,16(sp)
    b298:	00072c03          	lw	s8,0(a4)
    b29c:	00100793          	li	a5,1
    b2a0:	ab5ff06f          	j	ad54 <_svfprintf_r+0x2d4>
    b2a4:	01012783          	lw	a5,16(sp)
    b2a8:	0c0103a3          	sb	zero,199(sp)
    b2ac:	000c0313          	mv	t1,s8
    b2b0:	0007ac83          	lw	s9,0(a5)
    b2b4:	00478c13          	addi	s8,a5,4
    b2b8:	760c86e3          	beqz	s9,c224 <_svfprintf_r+0x17a4>
    b2bc:	fff00713          	li	a4,-1
    b2c0:	00e31463          	bne	t1,a4,b2c8 <_svfprintf_r+0x848>
    b2c4:	4540106f          	j	c718 <_svfprintf_r+0x1c98>
    b2c8:	00030613          	mv	a2,t1
    b2cc:	00000593          	li	a1,0
    b2d0:	000c8513          	mv	a0,s9
    b2d4:	00612823          	sw	t1,16(sp)
    b2d8:	839fd0ef          	jal	ra,8b10 <memchr>
    b2dc:	00a12623          	sw	a0,12(sp)
    b2e0:	01012303          	lw	t1,16(sp)
    b2e4:	00051463          	bnez	a0,b2ec <_svfprintf_r+0x86c>
    b2e8:	1410106f          	j	cc28 <_svfprintf_r+0x21a8>
    b2ec:	00c12783          	lw	a5,12(sp)
    b2f0:	41978b33          	sub	s6,a5,s9
    b2f4:	0c714703          	lbu	a4,199(sp)
    b2f8:	fffb4993          	not	s3,s6
    b2fc:	41f9d993          	srai	s3,s3,0x1f
    b300:	01812823          	sw	s8,16(sp)
    b304:	00012623          	sw	zero,12(sp)
    b308:	02012023          	sw	zero,32(sp)
    b30c:	00012e23          	sw	zero,28(sp)
    b310:	00012a23          	sw	zero,20(sp)
    b314:	013b79b3          	and	s3,s6,s3
    b318:	00000313          	li	t1,0
    b31c:	a80718e3          	bnez	a4,adac <_svfprintf_r+0x32c>
    b320:	0d00006f          	j	b3f0 <_svfprintf_r+0x970>
    b324:	02097793          	andi	a5,s2,32
    b328:	000c0313          	mv	t1,s8
    b32c:	01096913          	ori	s2,s2,16
    b330:	48079063          	bnez	a5,b7b0 <_svfprintf_r+0xd30>
    b334:	01012783          	lw	a5,16(sp)
    b338:	00478793          	addi	a5,a5,4
    b33c:	01012703          	lw	a4,16(sp)
    b340:	00000d93          	li	s11,0
    b344:	00f12823          	sw	a5,16(sp)
    b348:	00072c03          	lw	s8,0(a4)
    b34c:	4800006f          	j	b7cc <_svfprintf_r+0xd4c>
    b350:	00896913          	ori	s2,s2,8
    b354:	0004ce03          	lbu	t3,0(s1)
    b358:	88dff06f          	j	abe4 <_svfprintf_r+0x164>
    b35c:	02097793          	andi	a5,s2,32
    b360:	000c0313          	mv	t1,s8
    b364:	01096993          	ori	s3,s2,16
    b368:	48079e63          	bnez	a5,b804 <_svfprintf_r+0xd84>
    b36c:	01012783          	lw	a5,16(sp)
    b370:	00478793          	addi	a5,a5,4
    b374:	01012703          	lw	a4,16(sp)
    b378:	00f12823          	sw	a5,16(sp)
    b37c:	00072c03          	lw	s8,0(a4)
    b380:	41fc5d93          	srai	s11,s8,0x1f
    b384:	000d8713          	mv	a4,s11
    b388:	2a074063          	bltz	a4,b628 <_svfprintf_r+0xba8>
    b38c:	fff00793          	li	a5,-1
    b390:	48f30e63          	beq	t1,a5,b82c <_svfprintf_r+0xdac>
    b394:	01bc67b3          	or	a5,s8,s11
    b398:	f7f9f913          	andi	s2,s3,-129
    b39c:	48079663          	bnez	a5,b828 <_svfprintf_r+0xda8>
    b3a0:	00030463          	beqz	t1,b3a8 <_svfprintf_r+0x928>
    b3a4:	63c0106f          	j	c9e0 <_svfprintf_r+0x1f60>
    b3a8:	00000313          	li	t1,0
    b3ac:	00000b13          	li	s6,0
    b3b0:	1b010c93          	addi	s9,sp,432
    b3b4:	9d5ff06f          	j	ad88 <_svfprintf_r+0x308>
    b3b8:	01012703          	lw	a4,16(sp)
    b3bc:	0c0103a3          	sb	zero,199(sp)
    b3c0:	00100993          	li	s3,1
    b3c4:	00072783          	lw	a5,0(a4)
    b3c8:	00470713          	addi	a4,a4,4
    b3cc:	00e12823          	sw	a4,16(sp)
    b3d0:	14f10623          	sb	a5,332(sp)
    b3d4:	00100b13          	li	s6,1
    b3d8:	14c10c93          	addi	s9,sp,332
    b3dc:	00012623          	sw	zero,12(sp)
    b3e0:	00000313          	li	t1,0
    b3e4:	02012023          	sw	zero,32(sp)
    b3e8:	00012e23          	sw	zero,28(sp)
    b3ec:	00012a23          	sw	zero,20(sp)
    b3f0:	00297f93          	andi	t6,s2,2
    b3f4:	000f8463          	beqz	t6,b3fc <_svfprintf_r+0x97c>
    b3f8:	00298993          	addi	s3,s3,2
    b3fc:	08497d93          	andi	s11,s2,132
    b400:	0ec12703          	lw	a4,236(sp)
    b404:	000d9663          	bnez	s11,b410 <_svfprintf_r+0x990>
    b408:	41340833          	sub	a6,s0,s3
    b40c:	130042e3          	bgtz	a6,bd30 <_svfprintf_r+0x12b0>
    b410:	0c714683          	lbu	a3,199(sp)
    b414:	02068a63          	beqz	a3,b448 <_svfprintf_r+0x9c8>
    b418:	0e812683          	lw	a3,232(sp)
    b41c:	0c710613          	addi	a2,sp,199
    b420:	00cd2023          	sw	a2,0(s10)
    b424:	00170713          	addi	a4,a4,1
    b428:	00100613          	li	a2,1
    b42c:	00168693          	addi	a3,a3,1
    b430:	00cd2223          	sw	a2,4(s10)
    b434:	0ee12623          	sw	a4,236(sp)
    b438:	0ed12423          	sw	a3,232(sp)
    b43c:	00700613          	li	a2,7
    b440:	008d0d13          	addi	s10,s10,8
    b444:	0cd64263          	blt	a2,a3,b508 <_svfprintf_r+0xa88>
    b448:	020f8a63          	beqz	t6,b47c <_svfprintf_r+0x9fc>
    b44c:	0e812683          	lw	a3,232(sp)
    b450:	0c810613          	addi	a2,sp,200
    b454:	00cd2023          	sw	a2,0(s10)
    b458:	00270713          	addi	a4,a4,2
    b45c:	00200613          	li	a2,2
    b460:	00168693          	addi	a3,a3,1
    b464:	00cd2223          	sw	a2,4(s10)
    b468:	0ee12623          	sw	a4,236(sp)
    b46c:	0ed12423          	sw	a3,232(sp)
    b470:	00700613          	li	a2,7
    b474:	008d0d13          	addi	s10,s10,8
    b478:	1cd64ee3          	blt	a2,a3,be54 <_svfprintf_r+0x13d4>
    b47c:	08000693          	li	a3,128
    b480:	56dd8a63          	beq	s11,a3,b9f4 <_svfprintf_r+0xf74>
    b484:	41630c33          	sub	s8,t1,s6
    b488:	67804c63          	bgtz	s8,bb00 <_svfprintf_r+0x1080>
    b48c:	10097693          	andi	a3,s2,256
    b490:	40069e63          	bnez	a3,b8ac <_svfprintf_r+0xe2c>
    b494:	0e812783          	lw	a5,232(sp)
    b498:	01670733          	add	a4,a4,s6
    b49c:	019d2023          	sw	s9,0(s10)
    b4a0:	00178793          	addi	a5,a5,1
    b4a4:	016d2223          	sw	s6,4(s10)
    b4a8:	0ee12623          	sw	a4,236(sp)
    b4ac:	0ef12423          	sw	a5,232(sp)
    b4b0:	00700693          	li	a3,7
    b4b4:	008d0d13          	addi	s10,s10,8
    b4b8:	04f6c6e3          	blt	a3,a5,bd04 <_svfprintf_r+0x1284>
    b4bc:	00497913          	andi	s2,s2,4
    b4c0:	00090663          	beqz	s2,b4cc <_svfprintf_r+0xa4c>
    b4c4:	41340933          	sub	s2,s0,s3
    b4c8:	07204863          	bgtz	s2,b538 <_svfprintf_r+0xab8>
    b4cc:	01345463          	bge	s0,s3,b4d4 <_svfprintf_r+0xa54>
    b4d0:	00098413          	mv	s0,s3
    b4d4:	00412783          	lw	a5,4(sp)
    b4d8:	008787b3          	add	a5,a5,s0
    b4dc:	00f12223          	sw	a5,4(sp)
    b4e0:	fa071463          	bnez	a4,ac88 <_svfprintf_r+0x208>
    b4e4:	00c12783          	lw	a5,12(sp)
    b4e8:	0e012423          	sw	zero,232(sp)
    b4ec:	00078863          	beqz	a5,b4fc <_svfprintf_r+0xa7c>
    b4f0:	00c12583          	lw	a1,12(sp)
    b4f4:	000a0513          	mv	a0,s4
    b4f8:	e8cf90ef          	jal	ra,4b84 <_free_r>
    b4fc:	10c10d13          	addi	s10,sp,268
    b500:	00048c93          	mv	s9,s1
    b504:	9e9ff06f          	j	aeec <_svfprintf_r+0x46c>
    b508:	00812583          	lw	a1,8(sp)
    b50c:	0e410613          	addi	a2,sp,228
    b510:	000a0513          	mv	a0,s4
    b514:	04612423          	sw	t1,72(sp)
    b518:	03f12a23          	sw	t6,52(sp)
    b51c:	441030ef          	jal	ra,f15c <__ssprint_r>
    b520:	f6051e63          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    b524:	0ec12703          	lw	a4,236(sp)
    b528:	10c10d13          	addi	s10,sp,268
    b52c:	04812303          	lw	t1,72(sp)
    b530:	03412f83          	lw	t6,52(sp)
    b534:	f15ff06f          	j	b448 <_svfprintf_r+0x9c8>
    b538:	0e812783          	lw	a5,232(sp)
    b53c:	0000ac17          	auipc	s8,0xa
    b540:	7e8c0c13          	addi	s8,s8,2024 # 15d24 <blanks.4489>
    b544:	072bd063          	bge	s7,s2,b5a4 <_svfprintf_r+0xb24>
    b548:	00700b13          	li	s6,7
    b54c:	00812a83          	lw	s5,8(sp)
    b550:	00c0006f          	j	b55c <_svfprintf_r+0xadc>
    b554:	ff090913          	addi	s2,s2,-16
    b558:	052bd663          	bge	s7,s2,b5a4 <_svfprintf_r+0xb24>
    b55c:	01070713          	addi	a4,a4,16
    b560:	00178793          	addi	a5,a5,1
    b564:	018d2023          	sw	s8,0(s10)
    b568:	017d2223          	sw	s7,4(s10)
    b56c:	0ee12623          	sw	a4,236(sp)
    b570:	0ef12423          	sw	a5,232(sp)
    b574:	008d0d13          	addi	s10,s10,8
    b578:	fcfb5ee3          	bge	s6,a5,b554 <_svfprintf_r+0xad4>
    b57c:	0e410613          	addi	a2,sp,228
    b580:	000a8593          	mv	a1,s5
    b584:	000a0513          	mv	a0,s4
    b588:	3d5030ef          	jal	ra,f15c <__ssprint_r>
    b58c:	f0051863          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    b590:	ff090913          	addi	s2,s2,-16
    b594:	0ec12703          	lw	a4,236(sp)
    b598:	0e812783          	lw	a5,232(sp)
    b59c:	10c10d13          	addi	s10,sp,268
    b5a0:	fb2bcee3          	blt	s7,s2,b55c <_svfprintf_r+0xadc>
    b5a4:	01270733          	add	a4,a4,s2
    b5a8:	00178793          	addi	a5,a5,1
    b5ac:	018d2023          	sw	s8,0(s10)
    b5b0:	012d2223          	sw	s2,4(s10)
    b5b4:	0ee12623          	sw	a4,236(sp)
    b5b8:	0ef12423          	sw	a5,232(sp)
    b5bc:	00700693          	li	a3,7
    b5c0:	f0f6d6e3          	bge	a3,a5,b4cc <_svfprintf_r+0xa4c>
    b5c4:	00812583          	lw	a1,8(sp)
    b5c8:	0e410613          	addi	a2,sp,228
    b5cc:	000a0513          	mv	a0,s4
    b5d0:	38d030ef          	jal	ra,f15c <__ssprint_r>
    b5d4:	ec051463          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    b5d8:	0ec12703          	lw	a4,236(sp)
    b5dc:	ef1ff06f          	j	b4cc <_svfprintf_r+0xa4c>
    b5e0:	02097793          	andi	a5,s2,32
    b5e4:	000c0313          	mv	t1,s8
    b5e8:	20079c63          	bnez	a5,b800 <_svfprintf_r+0xd80>
    b5ec:	01012783          	lw	a5,16(sp)
    b5f0:	01097713          	andi	a4,s2,16
    b5f4:	00478793          	addi	a5,a5,4
    b5f8:	00070463          	beqz	a4,b600 <_svfprintf_r+0xb80>
    b5fc:	6fd0106f          	j	d4f8 <_svfprintf_r+0x2a78>
    b600:	04097713          	andi	a4,s2,64
    b604:	00071463          	bnez	a4,b60c <_svfprintf_r+0xb8c>
    b608:	23c0106f          	j	c844 <_svfprintf_r+0x1dc4>
    b60c:	01012703          	lw	a4,16(sp)
    b610:	00f12823          	sw	a5,16(sp)
    b614:	00090993          	mv	s3,s2
    b618:	00071c03          	lh	s8,0(a4)
    b61c:	41fc5d93          	srai	s11,s8,0x1f
    b620:	000d8713          	mv	a4,s11
    b624:	d60754e3          	bgez	a4,b38c <_svfprintf_r+0x90c>
    b628:	41800c33          	neg	s8,s8
    b62c:	018037b3          	snez	a5,s8
    b630:	41b00db3          	neg	s11,s11
    b634:	40fd8db3          	sub	s11,s11,a5
    b638:	02d00793          	li	a5,45
    b63c:	0cf103a3          	sb	a5,199(sp)
    b640:	fff00713          	li	a4,-1
    b644:	00100793          	li	a5,1
    b648:	f0e31c63          	bne	t1,a4,ad60 <_svfprintf_r+0x2e0>
    b64c:	00100713          	li	a4,1
    b650:	1ce78e63          	beq	a5,a4,b82c <_svfprintf_r+0xdac>
    b654:	00200713          	li	a4,2
    b658:	20e78863          	beq	a5,a4,b868 <_svfprintf_r+0xde8>
    b65c:	1b010693          	addi	a3,sp,432
    b660:	0080006f          	j	b668 <_svfprintf_r+0xbe8>
    b664:	000c8693          	mv	a3,s9
    b668:	01dd9793          	slli	a5,s11,0x1d
    b66c:	007c7713          	andi	a4,s8,7
    b670:	003c5c13          	srli	s8,s8,0x3
    b674:	03070713          	addi	a4,a4,48
    b678:	0187ec33          	or	s8,a5,s8
    b67c:	003ddd93          	srli	s11,s11,0x3
    b680:	fee68fa3          	sb	a4,-1(a3)
    b684:	01bc67b3          	or	a5,s8,s11
    b688:	fff68c93          	addi	s9,a3,-1
    b68c:	fc079ce3          	bnez	a5,b664 <_svfprintf_r+0xbe4>
    b690:	0019f613          	andi	a2,s3,1
    b694:	20060463          	beqz	a2,b89c <_svfprintf_r+0xe1c>
    b698:	03000613          	li	a2,48
    b69c:	20c70063          	beq	a4,a2,b89c <_svfprintf_r+0xe1c>
    b6a0:	ffe68693          	addi	a3,a3,-2
    b6a4:	1b010793          	addi	a5,sp,432
    b6a8:	fecc8fa3          	sb	a2,-1(s9)
    b6ac:	40d78b33          	sub	s6,a5,a3
    b6b0:	00098913          	mv	s2,s3
    b6b4:	00068c93          	mv	s9,a3
    b6b8:	ed0ff06f          	j	ad88 <_svfprintf_r+0x308>
    b6bc:	02b00793          	li	a5,43
    b6c0:	0cf103a3          	sb	a5,199(sp)
    b6c4:	0004ce03          	lbu	t3,0(s1)
    b6c8:	d1cff06f          	j	abe4 <_svfprintf_r+0x164>
    b6cc:	01012783          	lw	a5,16(sp)
    b6d0:	0004ce03          	lbu	t3,0(s1)
    b6d4:	0007a403          	lw	s0,0(a5)
    b6d8:	00478793          	addi	a5,a5,4
    b6dc:	00f12823          	sw	a5,16(sp)
    b6e0:	d0045263          	bgez	s0,abe4 <_svfprintf_r+0x164>
    b6e4:	40800433          	neg	s0,s0
    b6e8:	00496913          	ori	s2,s2,4
    b6ec:	cf8ff06f          	j	abe4 <_svfprintf_r+0x164>
    b6f0:	08096913          	ori	s2,s2,128
    b6f4:	0004ce03          	lbu	t3,0(s1)
    b6f8:	cecff06f          	j	abe4 <_svfprintf_r+0x164>
    b6fc:	0004ca83          	lbu	s5,0(s1)
    b700:	00148793          	addi	a5,s1,1
    b704:	016a9463          	bne	s5,s6,b70c <_svfprintf_r+0xc8c>
    b708:	5cd0106f          	j	d4d4 <_svfprintf_r+0x2a54>
    b70c:	fd0a8693          	addi	a3,s5,-48
    b710:	00078493          	mv	s1,a5
    b714:	00000c13          	li	s8,0
    b718:	ccd9ec63          	bltu	s3,a3,abf0 <_svfprintf_r+0x170>
    b71c:	00148493          	addi	s1,s1,1
    b720:	002c1793          	slli	a5,s8,0x2
    b724:	fff4ca83          	lbu	s5,-1(s1)
    b728:	018787b3          	add	a5,a5,s8
    b72c:	00179793          	slli	a5,a5,0x1
    b730:	00d78c33          	add	s8,a5,a3
    b734:	fd0a8693          	addi	a3,s5,-48
    b738:	fed9f2e3          	bgeu	s3,a3,b71c <_svfprintf_r+0xc9c>
    b73c:	cb4ff06f          	j	abf0 <_svfprintf_r+0x170>
    b740:	00196913          	ori	s2,s2,1
    b744:	0004ce03          	lbu	t3,0(s1)
    b748:	c9cff06f          	j	abe4 <_svfprintf_r+0x164>
    b74c:	0c714783          	lbu	a5,199(sp)
    b750:	0004ce03          	lbu	t3,0(s1)
    b754:	c8079863          	bnez	a5,abe4 <_svfprintf_r+0x164>
    b758:	02000793          	li	a5,32
    b75c:	0cf103a3          	sb	a5,199(sp)
    b760:	c84ff06f          	j	abe4 <_svfprintf_r+0x164>
    b764:	02097793          	andi	a5,s2,32
    b768:	000c0313          	mv	t1,s8
    b76c:	06079663          	bnez	a5,b7d8 <_svfprintf_r+0xd58>
    b770:	01012683          	lw	a3,16(sp)
    b774:	01097713          	andi	a4,s2,16
    b778:	00468793          	addi	a5,a3,4
    b77c:	0006ac03          	lw	s8,0(a3)
    b780:	00070463          	beqz	a4,b788 <_svfprintf_r+0xd08>
    b784:	5a90106f          	j	d52c <_svfprintf_r+0x2aac>
    b788:	04097713          	andi	a4,s2,64
    b78c:	00071463          	bnez	a4,b794 <_svfprintf_r+0xd14>
    b790:	07c0106f          	j	c80c <_svfprintf_r+0x1d8c>
    b794:	010c1c13          	slli	s8,s8,0x10
    b798:	00f12823          	sw	a5,16(sp)
    b79c:	010c5c13          	srli	s8,s8,0x10
    b7a0:	00000d93          	li	s11,0
    b7a4:	00090993          	mv	s3,s2
    b7a8:	00100793          	li	a5,1
    b7ac:	da8ff06f          	j	ad54 <_svfprintf_r+0x2d4>
    b7b0:	01012783          	lw	a5,16(sp)
    b7b4:	00778793          	addi	a5,a5,7
    b7b8:	ff87f793          	andi	a5,a5,-8
    b7bc:	0007ac03          	lw	s8,0(a5)
    b7c0:	0047ad83          	lw	s11,4(a5)
    b7c4:	00878713          	addi	a4,a5,8
    b7c8:	00e12823          	sw	a4,16(sp)
    b7cc:	bff97993          	andi	s3,s2,-1025
    b7d0:	00000793          	li	a5,0
    b7d4:	d80ff06f          	j	ad54 <_svfprintf_r+0x2d4>
    b7d8:	00090993          	mv	s3,s2
    b7dc:	01012783          	lw	a5,16(sp)
    b7e0:	00778793          	addi	a5,a5,7
    b7e4:	ff87f793          	andi	a5,a5,-8
    b7e8:	00878713          	addi	a4,a5,8
    b7ec:	0007ac03          	lw	s8,0(a5)
    b7f0:	0047ad83          	lw	s11,4(a5)
    b7f4:	00e12823          	sw	a4,16(sp)
    b7f8:	00100793          	li	a5,1
    b7fc:	d58ff06f          	j	ad54 <_svfprintf_r+0x2d4>
    b800:	00090993          	mv	s3,s2
    b804:	01012783          	lw	a5,16(sp)
    b808:	00778793          	addi	a5,a5,7
    b80c:	ff87f793          	andi	a5,a5,-8
    b810:	0047a703          	lw	a4,4(a5)
    b814:	00878693          	addi	a3,a5,8
    b818:	00d12823          	sw	a3,16(sp)
    b81c:	0007ac03          	lw	s8,0(a5)
    b820:	00070d93          	mv	s11,a4
    b824:	b65ff06f          	j	b388 <_svfprintf_r+0x908>
    b828:	00090993          	mv	s3,s2
    b82c:	540d90e3          	bnez	s11,c56c <_svfprintf_r+0x1aec>
    b830:	00900793          	li	a5,9
    b834:	5387ece3          	bltu	a5,s8,c56c <_svfprintf_r+0x1aec>
    b838:	030c0c13          	addi	s8,s8,48
    b83c:	1b8107a3          	sb	s8,431(sp)
    b840:	00098913          	mv	s2,s3
    b844:	00100b13          	li	s6,1
    b848:	1af10c93          	addi	s9,sp,431
    b84c:	d3cff06f          	j	ad88 <_svfprintf_r+0x308>
    b850:	00100713          	li	a4,1
    b854:	00e79463          	bne	a5,a4,b85c <_svfprintf_r+0xddc>
    b858:	1880106f          	j	c9e0 <_svfprintf_r+0x1f60>
    b85c:	00200713          	li	a4,2
    b860:	00090993          	mv	s3,s2
    b864:	dee79ce3          	bne	a5,a4,b65c <_svfprintf_r+0xbdc>
    b868:	02c12683          	lw	a3,44(sp)
    b86c:	1b010c93          	addi	s9,sp,432
    b870:	00fc7793          	andi	a5,s8,15
    b874:	00f687b3          	add	a5,a3,a5
    b878:	0007c783          	lbu	a5,0(a5)
    b87c:	01cd9713          	slli	a4,s11,0x1c
    b880:	004c5c13          	srli	s8,s8,0x4
    b884:	fffc8c93          	addi	s9,s9,-1
    b888:	01876c33          	or	s8,a4,s8
    b88c:	004ddd93          	srli	s11,s11,0x4
    b890:	00fc8023          	sb	a5,0(s9)
    b894:	01bc67b3          	or	a5,s8,s11
    b898:	fc079ce3          	bnez	a5,b870 <_svfprintf_r+0xdf0>
    b89c:	1b010793          	addi	a5,sp,432
    b8a0:	41978b33          	sub	s6,a5,s9
    b8a4:	00098913          	mv	s2,s3
    b8a8:	ce0ff06f          	j	ad88 <_svfprintf_r+0x308>
    b8ac:	06500693          	li	a3,101
    b8b0:	3356d863          	bge	a3,s5,bbe0 <_svfprintf_r+0x1160>
    b8b4:	0f012683          	lw	a3,240(sp)
    b8b8:	0a010593          	addi	a1,sp,160
    b8bc:	0b010513          	addi	a0,sp,176
    b8c0:	0ad12823          	sw	a3,176(sp)
    b8c4:	0f412683          	lw	a3,244(sp)
    b8c8:	02e12a23          	sw	a4,52(sp)
    b8cc:	0a012023          	sw	zero,160(sp)
    b8d0:	0ad12a23          	sw	a3,180(sp)
    b8d4:	0f812683          	lw	a3,248(sp)
    b8d8:	0a012223          	sw	zero,164(sp)
    b8dc:	0a012423          	sw	zero,168(sp)
    b8e0:	0ad12c23          	sw	a3,184(sp)
    b8e4:	0fc12683          	lw	a3,252(sp)
    b8e8:	0a012623          	sw	zero,172(sp)
    b8ec:	0ad12e23          	sw	a3,188(sp)
    b8f0:	5ec060ef          	jal	ra,11edc <__eqtf2>
    b8f4:	03412703          	lw	a4,52(sp)
    b8f8:	58051463          	bnez	a0,be80 <_svfprintf_r+0x1400>
    b8fc:	0e812783          	lw	a5,232(sp)
    b900:	0000a697          	auipc	a3,0xa
    b904:	ec868693          	addi	a3,a3,-312 # 157c8 <_data+0x4b0>
    b908:	00170713          	addi	a4,a4,1
    b90c:	00dd2023          	sw	a3,0(s10)
    b910:	00178793          	addi	a5,a5,1
    b914:	00100693          	li	a3,1
    b918:	00dd2223          	sw	a3,4(s10)
    b91c:	0ee12623          	sw	a4,236(sp)
    b920:	0ef12423          	sw	a5,232(sp)
    b924:	00700713          	li	a4,7
    b928:	008d0d13          	addi	s10,s10,8
    b92c:	42f740e3          	blt	a4,a5,c54c <_svfprintf_r+0x1acc>
    b930:	0cc12783          	lw	a5,204(sp)
    b934:	01812703          	lw	a4,24(sp)
    b938:	00e7ca63          	blt	a5,a4,b94c <_svfprintf_r+0xecc>
    b93c:	00197793          	andi	a5,s2,1
    b940:	00079663          	bnez	a5,b94c <_svfprintf_r+0xecc>
    b944:	0ec12703          	lw	a4,236(sp)
    b948:	b75ff06f          	j	b4bc <_svfprintf_r+0xa3c>
    b94c:	03012783          	lw	a5,48(sp)
    b950:	02812683          	lw	a3,40(sp)
    b954:	0ec12703          	lw	a4,236(sp)
    b958:	00fd2023          	sw	a5,0(s10)
    b95c:	0e812783          	lw	a5,232(sp)
    b960:	00e68733          	add	a4,a3,a4
    b964:	00dd2223          	sw	a3,4(s10)
    b968:	00178793          	addi	a5,a5,1
    b96c:	0ee12623          	sw	a4,236(sp)
    b970:	0ef12423          	sw	a5,232(sp)
    b974:	00700693          	li	a3,7
    b978:	008d0d13          	addi	s10,s10,8
    b97c:	02f6cae3          	blt	a3,a5,c1b0 <_svfprintf_r+0x1730>
    b980:	01812783          	lw	a5,24(sp)
    b984:	fff78b13          	addi	s6,a5,-1
    b988:	b3605ae3          	blez	s6,b4bc <_svfprintf_r+0xa3c>
    b98c:	0e812783          	lw	a5,232(sp)
    b990:	4b6bd6e3          	bge	s7,s6,c63c <_svfprintf_r+0x1bbc>
    b994:	00700c13          	li	s8,7
    b998:	00812a83          	lw	s5,8(sp)
    b99c:	00c0006f          	j	b9a8 <_svfprintf_r+0xf28>
    b9a0:	ff0b0b13          	addi	s6,s6,-16
    b9a4:	496bdce3          	bge	s7,s6,c63c <_svfprintf_r+0x1bbc>
    b9a8:	01070713          	addi	a4,a4,16
    b9ac:	00178793          	addi	a5,a5,1
    b9b0:	0000a697          	auipc	a3,0xa
    b9b4:	38468693          	addi	a3,a3,900 # 15d34 <zeroes.4490>
    b9b8:	00dd2023          	sw	a3,0(s10)
    b9bc:	017d2223          	sw	s7,4(s10)
    b9c0:	0ee12623          	sw	a4,236(sp)
    b9c4:	0ef12423          	sw	a5,232(sp)
    b9c8:	008d0d13          	addi	s10,s10,8
    b9cc:	fcfc5ae3          	bge	s8,a5,b9a0 <_svfprintf_r+0xf20>
    b9d0:	0e410613          	addi	a2,sp,228
    b9d4:	000a8593          	mv	a1,s5
    b9d8:	000a0513          	mv	a0,s4
    b9dc:	780030ef          	jal	ra,f15c <__ssprint_r>
    b9e0:	aa051e63          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    b9e4:	0ec12703          	lw	a4,236(sp)
    b9e8:	0e812783          	lw	a5,232(sp)
    b9ec:	10c10d13          	addi	s10,sp,268
    b9f0:	fb1ff06f          	j	b9a0 <_svfprintf_r+0xf20>
    b9f4:	41340c33          	sub	s8,s0,s3
    b9f8:	a98056e3          	blez	s8,b484 <_svfprintf_r+0xa04>
    b9fc:	0e812683          	lw	a3,232(sp)
    ba00:	0b8bd463          	bge	s7,s8,baa8 <_svfprintf_r+0x1028>
    ba04:	02912a23          	sw	s1,52(sp)
    ba08:	000d0793          	mv	a5,s10
    ba0c:	000c0493          	mv	s1,s8
    ba10:	000c8d13          	mv	s10,s9
    ba14:	00098c13          	mv	s8,s3
    ba18:	000b0c93          	mv	s9,s6
    ba1c:	00040993          	mv	s3,s0
    ba20:	00700d93          	li	s11,7
    ba24:	00812403          	lw	s0,8(sp)
    ba28:	00030b13          	mv	s6,t1
    ba2c:	00c0006f          	j	ba38 <_svfprintf_r+0xfb8>
    ba30:	ff048493          	addi	s1,s1,-16
    ba34:	049bda63          	bge	s7,s1,ba88 <_svfprintf_r+0x1008>
    ba38:	01070713          	addi	a4,a4,16
    ba3c:	00168693          	addi	a3,a3,1
    ba40:	0000a617          	auipc	a2,0xa
    ba44:	2f460613          	addi	a2,a2,756 # 15d34 <zeroes.4490>
    ba48:	00c7a023          	sw	a2,0(a5)
    ba4c:	0177a223          	sw	s7,4(a5)
    ba50:	0ee12623          	sw	a4,236(sp)
    ba54:	0ed12423          	sw	a3,232(sp)
    ba58:	00878793          	addi	a5,a5,8
    ba5c:	fcdddae3          	bge	s11,a3,ba30 <_svfprintf_r+0xfb0>
    ba60:	0e410613          	addi	a2,sp,228
    ba64:	00040593          	mv	a1,s0
    ba68:	000a0513          	mv	a0,s4
    ba6c:	6f0030ef          	jal	ra,f15c <__ssprint_r>
    ba70:	a2051663          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    ba74:	ff048493          	addi	s1,s1,-16
    ba78:	0ec12703          	lw	a4,236(sp)
    ba7c:	0e812683          	lw	a3,232(sp)
    ba80:	10c10793          	addi	a5,sp,268
    ba84:	fa9bcae3          	blt	s7,s1,ba38 <_svfprintf_r+0xfb8>
    ba88:	00098413          	mv	s0,s3
    ba8c:	000c0993          	mv	s3,s8
    ba90:	00048c13          	mv	s8,s1
    ba94:	03412483          	lw	s1,52(sp)
    ba98:	000b0313          	mv	t1,s6
    ba9c:	000c8b13          	mv	s6,s9
    baa0:	000d0c93          	mv	s9,s10
    baa4:	00078d13          	mv	s10,a5
    baa8:	01870733          	add	a4,a4,s8
    baac:	00168693          	addi	a3,a3,1
    bab0:	0000a797          	auipc	a5,0xa
    bab4:	28478793          	addi	a5,a5,644 # 15d34 <zeroes.4490>
    bab8:	00fd2023          	sw	a5,0(s10)
    babc:	018d2223          	sw	s8,4(s10)
    bac0:	0ee12623          	sw	a4,236(sp)
    bac4:	0ed12423          	sw	a3,232(sp)
    bac8:	00700613          	li	a2,7
    bacc:	008d0d13          	addi	s10,s10,8
    bad0:	9ad65ae3          	bge	a2,a3,b484 <_svfprintf_r+0xa04>
    bad4:	00812583          	lw	a1,8(sp)
    bad8:	0e410613          	addi	a2,sp,228
    badc:	000a0513          	mv	a0,s4
    bae0:	02612a23          	sw	t1,52(sp)
    bae4:	678030ef          	jal	ra,f15c <__ssprint_r>
    bae8:	9a051a63          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    baec:	03412303          	lw	t1,52(sp)
    baf0:	0ec12703          	lw	a4,236(sp)
    baf4:	10c10d13          	addi	s10,sp,268
    baf8:	41630c33          	sub	s8,t1,s6
    bafc:	998058e3          	blez	s8,b48c <_svfprintf_r+0xa0c>
    bb00:	0e812683          	lw	a3,232(sp)
    bb04:	098bd863          	bge	s7,s8,bb94 <_svfprintf_r+0x1114>
    bb08:	02912a23          	sw	s1,52(sp)
    bb0c:	00700d93          	li	s11,7
    bb10:	000c0493          	mv	s1,s8
    bb14:	000b0c13          	mv	s8,s6
    bb18:	00098b13          	mv	s6,s3
    bb1c:	00040993          	mv	s3,s0
    bb20:	00812403          	lw	s0,8(sp)
    bb24:	00c0006f          	j	bb30 <_svfprintf_r+0x10b0>
    bb28:	ff048493          	addi	s1,s1,-16
    bb2c:	049bda63          	bge	s7,s1,bb80 <_svfprintf_r+0x1100>
    bb30:	01070713          	addi	a4,a4,16
    bb34:	00168693          	addi	a3,a3,1
    bb38:	0000a797          	auipc	a5,0xa
    bb3c:	1fc78793          	addi	a5,a5,508 # 15d34 <zeroes.4490>
    bb40:	00fd2023          	sw	a5,0(s10)
    bb44:	017d2223          	sw	s7,4(s10)
    bb48:	0ee12623          	sw	a4,236(sp)
    bb4c:	0ed12423          	sw	a3,232(sp)
    bb50:	008d0d13          	addi	s10,s10,8
    bb54:	fcdddae3          	bge	s11,a3,bb28 <_svfprintf_r+0x10a8>
    bb58:	0e410613          	addi	a2,sp,228
    bb5c:	00040593          	mv	a1,s0
    bb60:	000a0513          	mv	a0,s4
    bb64:	5f8030ef          	jal	ra,f15c <__ssprint_r>
    bb68:	92051a63          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    bb6c:	ff048493          	addi	s1,s1,-16
    bb70:	0ec12703          	lw	a4,236(sp)
    bb74:	0e812683          	lw	a3,232(sp)
    bb78:	10c10d13          	addi	s10,sp,268
    bb7c:	fa9bcae3          	blt	s7,s1,bb30 <_svfprintf_r+0x10b0>
    bb80:	00098413          	mv	s0,s3
    bb84:	000b0993          	mv	s3,s6
    bb88:	000c0b13          	mv	s6,s8
    bb8c:	00048c13          	mv	s8,s1
    bb90:	03412483          	lw	s1,52(sp)
    bb94:	01870733          	add	a4,a4,s8
    bb98:	00168693          	addi	a3,a3,1
    bb9c:	0000a797          	auipc	a5,0xa
    bba0:	19878793          	addi	a5,a5,408 # 15d34 <zeroes.4490>
    bba4:	00fd2023          	sw	a5,0(s10)
    bba8:	018d2223          	sw	s8,4(s10)
    bbac:	0ee12623          	sw	a4,236(sp)
    bbb0:	0ed12423          	sw	a3,232(sp)
    bbb4:	00700613          	li	a2,7
    bbb8:	008d0d13          	addi	s10,s10,8
    bbbc:	8cd658e3          	bge	a2,a3,b48c <_svfprintf_r+0xa0c>
    bbc0:	00812583          	lw	a1,8(sp)
    bbc4:	0e410613          	addi	a2,sp,228
    bbc8:	000a0513          	mv	a0,s4
    bbcc:	590030ef          	jal	ra,f15c <__ssprint_r>
    bbd0:	8c051663          	bnez	a0,ac9c <_svfprintf_r+0x21c>
    bbd4:	0ec12703          	lw	a4,236(sp)
    bbd8:	10c10d13          	addi	s10,sp,268
    bbdc:	8b1ff06f          	j	b48c <_svfprintf_r+0xa0c>
    bbe0:	0e812603          	lw	a2,232(sp)
    bbe4:	01812783          	lw	a5,24(sp)
    bbe8:	00100693          	li	a3,1
    bbec:	019d2023          	sw	s9,0(s10)
    bbf0:	00170713          	addi	a4,a4,1
    bbf4:	00160b13          	addi	s6,a2,1
    bbf8:	008d0c13          	addi	s8,s10,8
    bbfc:	3ef6de63          	bge	a3,a5,bff8 <_svfprintf_r+0x1578>
    bc00:	00100693          	li	a3,1
    bc04:	00dd2223          	sw	a3,4(s10)
    bc08:	0ee12623          	sw	a4,236(sp)
    bc0c:	0f612423          	sw	s6,232(sp)
    bc10:	00700693          	li	a3,7
    bc14:	4966c663          	blt	a3,s6,c0a0 <_svfprintf_r+0x1620>
    bc18:	02812783          	lw	a5,40(sp)
    bc1c:	03012683          	lw	a3,48(sp)
    bc20:	001b0b13          	addi	s6,s6,1
    bc24:	00f70733          	add	a4,a4,a5
    bc28:	00dc2023          	sw	a3,0(s8)
    bc2c:	00fc2223          	sw	a5,4(s8)
    bc30:	0ee12623          	sw	a4,236(sp)
    bc34:	0f612423          	sw	s6,232(sp)
    bc38:	00700693          	li	a3,7
    bc3c:	008c0c13          	addi	s8,s8,8
    bc40:	4966c463          	blt	a3,s6,c0c8 <_svfprintf_r+0x1648>
    bc44:	0f012683          	lw	a3,240(sp)
    bc48:	01812783          	lw	a5,24(sp)
    bc4c:	001b0813          	addi	a6,s6,1
    bc50:	0ad12823          	sw	a3,176(sp)
    bc54:	0f412683          	lw	a3,244(sp)
    bc58:	0a010593          	addi	a1,sp,160
    bc5c:	0b010513          	addi	a0,sp,176
    bc60:	0ad12a23          	sw	a3,180(sp)
    bc64:	0f812683          	lw	a3,248(sp)
    bc68:	02e12023          	sw	a4,32(sp)
    bc6c:	00080a93          	mv	s5,a6
    bc70:	0ad12c23          	sw	a3,184(sp)
    bc74:	0fc12683          	lw	a3,252(sp)
    bc78:	01012e23          	sw	a6,28(sp)
    bc7c:	0a012023          	sw	zero,160(sp)
    bc80:	0ad12e23          	sw	a3,188(sp)
    bc84:	fff78693          	addi	a3,a5,-1
    bc88:	00d12a23          	sw	a3,20(sp)
    bc8c:	0a012223          	sw	zero,164(sp)
    bc90:	0a012423          	sw	zero,168(sp)
    bc94:	0a012623          	sw	zero,172(sp)
    bc98:	244060ef          	jal	ra,11edc <__eqtf2>
    bc9c:	008c0d13          	addi	s10,s8,8
    bca0:	01412683          	lw	a3,20(sp)
    bca4:	01c12803          	lw	a6,28(sp)
    bca8:	02012703          	lw	a4,32(sp)
    bcac:	36050a63          	beqz	a0,c020 <_svfprintf_r+0x15a0>
    bcb0:	001c8793          	addi	a5,s9,1
    bcb4:	00d70733          	add	a4,a4,a3
    bcb8:	00fc2023          	sw	a5,0(s8)
    bcbc:	00dc2223          	sw	a3,4(s8)
    bcc0:	0ee12623          	sw	a4,236(sp)
    bcc4:	0f512423          	sw	s5,232(sp)
    bcc8:	00700793          	li	a5,7
    bccc:	7557cc63          	blt	a5,s5,c424 <_svfprintf_r+0x19a4>
    bcd0:	010c0793          	addi	a5,s8,16
    bcd4:	002b0a93          	addi	s5,s6,2
    bcd8:	000d0c13          	mv	s8,s10
    bcdc:	00078d13          	mv	s10,a5
    bce0:	03812683          	lw	a3,56(sp)
    bce4:	0d410793          	addi	a5,sp,212
    bce8:	00fc2023          	sw	a5,0(s8)
    bcec:	00e68733          	add	a4,a3,a4
    bcf0:	00dc2223          	sw	a3,4(s8)
    bcf4:	0ee12623          	sw	a4,236(sp)
    bcf8:	0f512423          	sw	s5,232(sp)
    bcfc:	00700793          	li	a5,7
    bd00:	fb57de63          	bge	a5,s5,b4bc <_svfprintf_r+0xa3c>
    bd04:	00812583          	lw	a1,8(sp)
    bd08:	0e410613          	addi	a2,sp,228
    bd0c:	000a0513          	mv	a0,s4
    bd10:	44c030ef          	jal	ra,f15c <__ssprint_r>
    bd14:	00050463          	beqz	a0,bd1c <_svfprintf_r+0x129c>
    bd18:	f85fe06f          	j	ac9c <_svfprintf_r+0x21c>
    bd1c:	0ec12703          	lw	a4,236(sp)
    bd20:	10c10d13          	addi	s10,sp,268
    bd24:	f98ff06f          	j	b4bc <_svfprintf_r+0xa3c>
    bd28:	00090993          	mv	s3,s2
    bd2c:	921ff06f          	j	b64c <_svfprintf_r+0xbcc>
    bd30:	0e812683          	lw	a3,232(sp)
    bd34:	0000ac17          	auipc	s8,0xa
    bd38:	ff0c0c13          	addi	s8,s8,-16 # 15d24 <blanks.4489>
    bd3c:	0d0bd063          	bge	s7,a6,bdfc <_svfprintf_r+0x137c>
    bd40:	04912423          	sw	s1,72(sp)
    bd44:	05212623          	sw	s2,76(sp)
    bd48:	000d0793          	mv	a5,s10
    bd4c:	000c0913          	mv	s2,s8
    bd50:	000c8d13          	mv	s10,s9
    bd54:	00098c13          	mv	s8,s3
    bd58:	000b0c93          	mv	s9,s6
    bd5c:	00040993          	mv	s3,s0
    bd60:	00700293          	li	t0,7
    bd64:	03f12a23          	sw	t6,52(sp)
    bd68:	00812483          	lw	s1,8(sp)
    bd6c:	00030b13          	mv	s6,t1
    bd70:	00080413          	mv	s0,a6
    bd74:	00c0006f          	j	bd80 <_svfprintf_r+0x1300>
    bd78:	ff040413          	addi	s0,s0,-16
    bd7c:	048bda63          	bge	s7,s0,bdd0 <_svfprintf_r+0x1350>
    bd80:	01070713          	addi	a4,a4,16
    bd84:	00168693          	addi	a3,a3,1
    bd88:	0127a023          	sw	s2,0(a5)
    bd8c:	0177a223          	sw	s7,4(a5)
    bd90:	0ee12623          	sw	a4,236(sp)
    bd94:	0ed12423          	sw	a3,232(sp)
    bd98:	00878793          	addi	a5,a5,8
    bd9c:	fcd2dee3          	bge	t0,a3,bd78 <_svfprintf_r+0x12f8>
    bda0:	0e410613          	addi	a2,sp,228
    bda4:	00048593          	mv	a1,s1
    bda8:	000a0513          	mv	a0,s4
    bdac:	3b0030ef          	jal	ra,f15c <__ssprint_r>
    bdb0:	00050463          	beqz	a0,bdb8 <_svfprintf_r+0x1338>
    bdb4:	ee9fe06f          	j	ac9c <_svfprintf_r+0x21c>
    bdb8:	ff040413          	addi	s0,s0,-16
    bdbc:	0ec12703          	lw	a4,236(sp)
    bdc0:	0e812683          	lw	a3,232(sp)
    bdc4:	10c10793          	addi	a5,sp,268
    bdc8:	00700293          	li	t0,7
    bdcc:	fa8bcae3          	blt	s7,s0,bd80 <_svfprintf_r+0x1300>
    bdd0:	00040813          	mv	a6,s0
    bdd4:	03412f83          	lw	t6,52(sp)
    bdd8:	00098413          	mv	s0,s3
    bddc:	04812483          	lw	s1,72(sp)
    bde0:	000c0993          	mv	s3,s8
    bde4:	00090c13          	mv	s8,s2
    bde8:	04c12903          	lw	s2,76(sp)
    bdec:	000b0313          	mv	t1,s6
    bdf0:	000c8b13          	mv	s6,s9
    bdf4:	000d0c93          	mv	s9,s10
    bdf8:	00078d13          	mv	s10,a5
    bdfc:	01070733          	add	a4,a4,a6
    be00:	00168693          	addi	a3,a3,1
    be04:	018d2023          	sw	s8,0(s10)
    be08:	010d2223          	sw	a6,4(s10)
    be0c:	0ee12623          	sw	a4,236(sp)
    be10:	0ed12423          	sw	a3,232(sp)
    be14:	00700613          	li	a2,7
    be18:	008d0d13          	addi	s10,s10,8
    be1c:	ded65a63          	bge	a2,a3,b410 <_svfprintf_r+0x990>
    be20:	00812583          	lw	a1,8(sp)
    be24:	0e410613          	addi	a2,sp,228
    be28:	000a0513          	mv	a0,s4
    be2c:	04612423          	sw	t1,72(sp)
    be30:	03f12a23          	sw	t6,52(sp)
    be34:	328030ef          	jal	ra,f15c <__ssprint_r>
    be38:	00050463          	beqz	a0,be40 <_svfprintf_r+0x13c0>
    be3c:	e61fe06f          	j	ac9c <_svfprintf_r+0x21c>
    be40:	0ec12703          	lw	a4,236(sp)
    be44:	10c10d13          	addi	s10,sp,268
    be48:	04812303          	lw	t1,72(sp)
    be4c:	03412f83          	lw	t6,52(sp)
    be50:	dc0ff06f          	j	b410 <_svfprintf_r+0x990>
    be54:	00812583          	lw	a1,8(sp)
    be58:	0e410613          	addi	a2,sp,228
    be5c:	000a0513          	mv	a0,s4
    be60:	02612a23          	sw	t1,52(sp)
    be64:	2f8030ef          	jal	ra,f15c <__ssprint_r>
    be68:	00050463          	beqz	a0,be70 <_svfprintf_r+0x13f0>
    be6c:	e31fe06f          	j	ac9c <_svfprintf_r+0x21c>
    be70:	0ec12703          	lw	a4,236(sp)
    be74:	10c10d13          	addi	s10,sp,268
    be78:	03412303          	lw	t1,52(sp)
    be7c:	e00ff06f          	j	b47c <_svfprintf_r+0x9fc>
    be80:	0cc12603          	lw	a2,204(sp)
    be84:	5ec05a63          	blez	a2,c478 <_svfprintf_r+0x19f8>
    be88:	01812783          	lw	a5,24(sp)
    be8c:	01412683          	lw	a3,20(sp)
    be90:	00078b13          	mv	s6,a5
    be94:	30f6c863          	blt	a3,a5,c1a4 <_svfprintf_r+0x1724>
    be98:	03605663          	blez	s6,bec4 <_svfprintf_r+0x1444>
    be9c:	0e812683          	lw	a3,232(sp)
    bea0:	01670733          	add	a4,a4,s6
    bea4:	019d2023          	sw	s9,0(s10)
    bea8:	00168693          	addi	a3,a3,1
    beac:	016d2223          	sw	s6,4(s10)
    beb0:	0ee12623          	sw	a4,236(sp)
    beb4:	0ed12423          	sw	a3,232(sp)
    beb8:	00700613          	li	a2,7
    bebc:	008d0d13          	addi	s10,s10,8
    bec0:	22d646e3          	blt	a2,a3,c8ec <_svfprintf_r+0x1e6c>
    bec4:	fffb4693          	not	a3,s6
    bec8:	01412783          	lw	a5,20(sp)
    becc:	41f6d693          	srai	a3,a3,0x1f
    bed0:	00db7b33          	and	s6,s6,a3
    bed4:	41678b33          	sub	s6,a5,s6
    bed8:	37604663          	bgtz	s6,c244 <_svfprintf_r+0x17c4>
    bedc:	01412783          	lw	a5,20(sp)
    bee0:	40097693          	andi	a3,s2,1024
    bee4:	00fc8ab3          	add	s5,s9,a5
    bee8:	3c069463          	bnez	a3,c2b0 <_svfprintf_r+0x1830>
    beec:	0cc12b03          	lw	s6,204(sp)
    bef0:	01812783          	lw	a5,24(sp)
    bef4:	00fb4663          	blt	s6,a5,bf00 <_svfprintf_r+0x1480>
    bef8:	00197693          	andi	a3,s2,1
    befc:	20068ee3          	beqz	a3,c918 <_svfprintf_r+0x1e98>
    bf00:	03012683          	lw	a3,48(sp)
    bf04:	02812783          	lw	a5,40(sp)
    bf08:	00700613          	li	a2,7
    bf0c:	00dd2023          	sw	a3,0(s10)
    bf10:	0e812683          	lw	a3,232(sp)
    bf14:	00f70733          	add	a4,a4,a5
    bf18:	00fd2223          	sw	a5,4(s10)
    bf1c:	00168693          	addi	a3,a3,1
    bf20:	0ee12623          	sw	a4,236(sp)
    bf24:	0ed12423          	sw	a3,232(sp)
    bf28:	008d0d13          	addi	s10,s10,8
    bf2c:	4cd64ae3          	blt	a2,a3,cc00 <_svfprintf_r+0x2180>
    bf30:	01812683          	lw	a3,24(sp)
    bf34:	00dc87b3          	add	a5,s9,a3
    bf38:	41668b33          	sub	s6,a3,s6
    bf3c:	415787b3          	sub	a5,a5,s5
    bf40:	000b0c13          	mv	s8,s6
    bf44:	0167d463          	bge	a5,s6,bf4c <_svfprintf_r+0x14cc>
    bf48:	00078c13          	mv	s8,a5
    bf4c:	03805663          	blez	s8,bf78 <_svfprintf_r+0x14f8>
    bf50:	0e812783          	lw	a5,232(sp)
    bf54:	01870733          	add	a4,a4,s8
    bf58:	015d2023          	sw	s5,0(s10)
    bf5c:	00178793          	addi	a5,a5,1
    bf60:	018d2223          	sw	s8,4(s10)
    bf64:	0ee12623          	sw	a4,236(sp)
    bf68:	0ef12423          	sw	a5,232(sp)
    bf6c:	00700693          	li	a3,7
    bf70:	008d0d13          	addi	s10,s10,8
    bf74:	4ef6c0e3          	blt	a3,a5,cc54 <_svfprintf_r+0x21d4>
    bf78:	fffc4793          	not	a5,s8
    bf7c:	41f7d793          	srai	a5,a5,0x1f
    bf80:	00fc7c33          	and	s8,s8,a5
    bf84:	418b0b33          	sub	s6,s6,s8
    bf88:	d3605a63          	blez	s6,b4bc <_svfprintf_r+0xa3c>
    bf8c:	0e812783          	lw	a5,232(sp)
    bf90:	6b6bd663          	bge	s7,s6,c63c <_svfprintf_r+0x1bbc>
    bf94:	00700c13          	li	s8,7
    bf98:	00812a83          	lw	s5,8(sp)
    bf9c:	00c0006f          	j	bfa8 <_svfprintf_r+0x1528>
    bfa0:	ff0b0b13          	addi	s6,s6,-16
    bfa4:	696bdc63          	bge	s7,s6,c63c <_svfprintf_r+0x1bbc>
    bfa8:	01070713          	addi	a4,a4,16
    bfac:	00178793          	addi	a5,a5,1
    bfb0:	0000a697          	auipc	a3,0xa
    bfb4:	d8468693          	addi	a3,a3,-636 # 15d34 <zeroes.4490>
    bfb8:	00dd2023          	sw	a3,0(s10)
    bfbc:	017d2223          	sw	s7,4(s10)
    bfc0:	0ee12623          	sw	a4,236(sp)
    bfc4:	0ef12423          	sw	a5,232(sp)
    bfc8:	008d0d13          	addi	s10,s10,8
    bfcc:	fcfc5ae3          	bge	s8,a5,bfa0 <_svfprintf_r+0x1520>
    bfd0:	0e410613          	addi	a2,sp,228
    bfd4:	000a8593          	mv	a1,s5
    bfd8:	000a0513          	mv	a0,s4
    bfdc:	180030ef          	jal	ra,f15c <__ssprint_r>
    bfe0:	00050463          	beqz	a0,bfe8 <_svfprintf_r+0x1568>
    bfe4:	cb9fe06f          	j	ac9c <_svfprintf_r+0x21c>
    bfe8:	0ec12703          	lw	a4,236(sp)
    bfec:	0e812783          	lw	a5,232(sp)
    bff0:	10c10d13          	addi	s10,sp,268
    bff4:	fadff06f          	j	bfa0 <_svfprintf_r+0x1520>
    bff8:	00197593          	andi	a1,s2,1
    bffc:	c00592e3          	bnez	a1,bc00 <_svfprintf_r+0x1180>
    c000:	00dd2223          	sw	a3,4(s10)
    c004:	0ee12623          	sw	a4,236(sp)
    c008:	0f612423          	sw	s6,232(sp)
    c00c:	00700793          	li	a5,7
    c010:	4167ca63          	blt	a5,s6,c424 <_svfprintf_r+0x19a4>
    c014:	00260a93          	addi	s5,a2,2
    c018:	010d0d13          	addi	s10,s10,16
    c01c:	cc5ff06f          	j	bce0 <_svfprintf_r+0x1260>
    c020:	ccd050e3          	blez	a3,bce0 <_svfprintf_r+0x1260>
    c024:	00dbc463          	blt	s7,a3,c02c <_svfprintf_r+0x15ac>
    c028:	4700106f          	j	d498 <_svfprintf_r+0x2a18>
    c02c:	00700a93          	li	s5,7
    c030:	00068d13          	mv	s10,a3
    c034:	00812c83          	lw	s9,8(sp)
    c038:	00080b13          	mv	s6,a6
    c03c:	0100006f          	j	c04c <_svfprintf_r+0x15cc>
    c040:	ff0d0d13          	addi	s10,s10,-16
    c044:	79abd463          	bge	s7,s10,c7cc <_svfprintf_r+0x1d4c>
    c048:	001b0b13          	addi	s6,s6,1
    c04c:	01070713          	addi	a4,a4,16
    c050:	0000a797          	auipc	a5,0xa
    c054:	ce478793          	addi	a5,a5,-796 # 15d34 <zeroes.4490>
    c058:	00fc2023          	sw	a5,0(s8)
    c05c:	017c2223          	sw	s7,4(s8)
    c060:	0ee12623          	sw	a4,236(sp)
    c064:	0f612423          	sw	s6,232(sp)
    c068:	008c0c13          	addi	s8,s8,8
    c06c:	fd6adae3          	bge	s5,s6,c040 <_svfprintf_r+0x15c0>
    c070:	0e410613          	addi	a2,sp,228
    c074:	000c8593          	mv	a1,s9
    c078:	000a0513          	mv	a0,s4
    c07c:	0e0030ef          	jal	ra,f15c <__ssprint_r>
    c080:	00050463          	beqz	a0,c088 <_svfprintf_r+0x1608>
    c084:	c19fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c088:	0ec12703          	lw	a4,236(sp)
    c08c:	0e812b03          	lw	s6,232(sp)
    c090:	10c10c13          	addi	s8,sp,268
    c094:	fadff06f          	j	c040 <_svfprintf_r+0x15c0>
    c098:	000c8913          	mv	s2,s9
    c09c:	b25fe06f          	j	abc0 <_svfprintf_r+0x140>
    c0a0:	00812583          	lw	a1,8(sp)
    c0a4:	0e410613          	addi	a2,sp,228
    c0a8:	000a0513          	mv	a0,s4
    c0ac:	0b0030ef          	jal	ra,f15c <__ssprint_r>
    c0b0:	00050463          	beqz	a0,c0b8 <_svfprintf_r+0x1638>
    c0b4:	be9fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c0b8:	0ec12703          	lw	a4,236(sp)
    c0bc:	0e812b03          	lw	s6,232(sp)
    c0c0:	10c10c13          	addi	s8,sp,268
    c0c4:	b55ff06f          	j	bc18 <_svfprintf_r+0x1198>
    c0c8:	00812583          	lw	a1,8(sp)
    c0cc:	0e410613          	addi	a2,sp,228
    c0d0:	000a0513          	mv	a0,s4
    c0d4:	088030ef          	jal	ra,f15c <__ssprint_r>
    c0d8:	00050463          	beqz	a0,c0e0 <_svfprintf_r+0x1660>
    c0dc:	bc1fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c0e0:	0ec12703          	lw	a4,236(sp)
    c0e4:	0e812b03          	lw	s6,232(sp)
    c0e8:	10c10c13          	addi	s8,sp,268
    c0ec:	b59ff06f          	j	bc44 <_svfprintf_r+0x11c4>
    c0f0:	03000793          	li	a5,48
    c0f4:	1af107a3          	sb	a5,431(sp)
    c0f8:	1af10c93          	addi	s9,sp,431
    c0fc:	c8dfe06f          	j	ad88 <_svfprintf_r+0x308>
    c100:	20097793          	andi	a5,s2,512
    c104:	080794e3          	bnez	a5,c98c <_svfprintf_r+0x1f0c>
    c108:	00000d93          	li	s11,0
    c10c:	c2dfe06f          	j	ad38 <_svfprintf_r+0x2b8>
    c110:	00412603          	lw	a2,4(sp)
    c114:	0006a783          	lw	a5,0(a3)
    c118:	00e12823          	sw	a4,16(sp)
    c11c:	41f65693          	srai	a3,a2,0x1f
    c120:	00c7a023          	sw	a2,0(a5)
    c124:	00d7a223          	sw	a3,4(a5)
    c128:	00048c93          	mv	s9,s1
    c12c:	dc1fe06f          	j	aeec <_svfprintf_r+0x46c>
    c130:	03000793          	li	a5,48
    c134:	00296913          	ori	s2,s2,2
    c138:	0cf10423          	sb	a5,200(sp)
    c13c:	0d5104a3          	sb	s5,201(sp)
    c140:	bff97993          	andi	s3,s2,-1025
    c144:	00200793          	li	a5,2
    c148:	c0dfe06f          	j	ad54 <_svfprintf_r+0x2d4>
    c14c:	03c12783          	lw	a5,60(sp)
    c150:	0004ce03          	lbu	t3,0(s1)
    c154:	00079463          	bnez	a5,c15c <_svfprintf_r+0x16dc>
    c158:	a8dfe06f          	j	abe4 <_svfprintf_r+0x164>
    c15c:	0007c783          	lbu	a5,0(a5)
    c160:	00079463          	bnez	a5,c168 <_svfprintf_r+0x16e8>
    c164:	a81fe06f          	j	abe4 <_svfprintf_r+0x164>
    c168:	40096913          	ori	s2,s2,1024
    c16c:	a79fe06f          	j	abe4 <_svfprintf_r+0x164>
    c170:	01012783          	lw	a5,16(sp)
    c174:	0007a703          	lw	a4,0(a5)
    c178:	00478793          	addi	a5,a5,4
    c17c:	00f12823          	sw	a5,16(sp)
    c180:	00072583          	lw	a1,0(a4)
    c184:	00472603          	lw	a2,4(a4)
    c188:	00872683          	lw	a3,8(a4)
    c18c:	00c72703          	lw	a4,12(a4)
    c190:	0eb12823          	sw	a1,240(sp)
    c194:	0ec12a23          	sw	a2,244(sp)
    c198:	0ed12c23          	sw	a3,248(sp)
    c19c:	0ee12e23          	sw	a4,252(sp)
    c1a0:	e45fe06f          	j	afe4 <_svfprintf_r+0x564>
    c1a4:	00068b13          	mv	s6,a3
    c1a8:	cf604ae3          	bgtz	s6,be9c <_svfprintf_r+0x141c>
    c1ac:	d19ff06f          	j	bec4 <_svfprintf_r+0x1444>
    c1b0:	00812583          	lw	a1,8(sp)
    c1b4:	0e410613          	addi	a2,sp,228
    c1b8:	000a0513          	mv	a0,s4
    c1bc:	7a1020ef          	jal	ra,f15c <__ssprint_r>
    c1c0:	00050463          	beqz	a0,c1c8 <_svfprintf_r+0x1748>
    c1c4:	ad9fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c1c8:	0ec12703          	lw	a4,236(sp)
    c1cc:	10c10d13          	addi	s10,sp,268
    c1d0:	fb0ff06f          	j	b980 <_svfprintf_r+0xf00>
    c1d4:	0014ce03          	lbu	t3,1(s1)
    c1d8:	20096913          	ori	s2,s2,512
    c1dc:	00148493          	addi	s1,s1,1
    c1e0:	a05fe06f          	j	abe4 <_svfprintf_r+0x164>
    c1e4:	0014ce03          	lbu	t3,1(s1)
    c1e8:	02096913          	ori	s2,s2,32
    c1ec:	00148493          	addi	s1,s1,1
    c1f0:	9f5fe06f          	j	abe4 <_svfprintf_r+0x164>
    c1f4:	02412503          	lw	a0,36(sp)
    c1f8:	04000593          	li	a1,64
    c1fc:	894fc0ef          	jal	ra,8290 <_malloc_r>
    c200:	00812783          	lw	a5,8(sp)
    c204:	00a7a023          	sw	a0,0(a5)
    c208:	00a7a823          	sw	a0,16(a5)
    c20c:	00051463          	bnez	a0,c214 <_svfprintf_r+0x1794>
    c210:	3040106f          	j	d514 <_svfprintf_r+0x2a94>
    c214:	00812703          	lw	a4,8(sp)
    c218:	04000793          	li	a5,64
    c21c:	00f72a23          	sw	a5,20(a4)
    c220:	8edfe06f          	j	ab0c <_svfprintf_r+0x8c>
    c224:	00600793          	li	a5,6
    c228:	00030b13          	mv	s6,t1
    c22c:	6e67e263          	bltu	a5,t1,c910 <_svfprintf_r+0x1e90>
    c230:	000b0993          	mv	s3,s6
    c234:	01812823          	sw	s8,16(sp)
    c238:	00009c97          	auipc	s9,0x9
    c23c:	588c8c93          	addi	s9,s9,1416 # 157c0 <_data+0x4a8>
    c240:	99cff06f          	j	b3dc <_svfprintf_r+0x95c>
    c244:	0e812683          	lw	a3,232(sp)
    c248:	656bd463          	bge	s7,s6,c890 <_svfprintf_r+0x1e10>
    c24c:	00700a93          	li	s5,7
    c250:	00812c03          	lw	s8,8(sp)
    c254:	00c0006f          	j	c260 <_svfprintf_r+0x17e0>
    c258:	ff0b0b13          	addi	s6,s6,-16
    c25c:	636bda63          	bge	s7,s6,c890 <_svfprintf_r+0x1e10>
    c260:	01070713          	addi	a4,a4,16
    c264:	00168693          	addi	a3,a3,1
    c268:	0000a797          	auipc	a5,0xa
    c26c:	acc78793          	addi	a5,a5,-1332 # 15d34 <zeroes.4490>
    c270:	00fd2023          	sw	a5,0(s10)
    c274:	017d2223          	sw	s7,4(s10)
    c278:	0ee12623          	sw	a4,236(sp)
    c27c:	0ed12423          	sw	a3,232(sp)
    c280:	008d0d13          	addi	s10,s10,8
    c284:	fcdadae3          	bge	s5,a3,c258 <_svfprintf_r+0x17d8>
    c288:	0e410613          	addi	a2,sp,228
    c28c:	000c0593          	mv	a1,s8
    c290:	000a0513          	mv	a0,s4
    c294:	6c9020ef          	jal	ra,f15c <__ssprint_r>
    c298:	00050463          	beqz	a0,c2a0 <_svfprintf_r+0x1820>
    c29c:	a01fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c2a0:	0ec12703          	lw	a4,236(sp)
    c2a4:	0e812683          	lw	a3,232(sp)
    c2a8:	10c10d13          	addi	s10,sp,268
    c2ac:	fadff06f          	j	c258 <_svfprintf_r+0x17d8>
    c2b0:	01812783          	lw	a5,24(sp)
    c2b4:	01c12c03          	lw	s8,28(sp)
    c2b8:	00912a23          	sw	s1,20(sp)
    c2bc:	03212a23          	sw	s2,52(sp)
    c2c0:	04812423          	sw	s0,72(sp)
    c2c4:	02012483          	lw	s1,32(sp)
    c2c8:	01312e23          	sw	s3,28(sp)
    c2cc:	03912023          	sw	s9,32(sp)
    c2d0:	00fc8db3          	add	s11,s9,a5
    c2d4:	00700b13          	li	s6,7
    c2d8:	04012903          	lw	s2,64(sp)
    c2dc:	03c12403          	lw	s0,60(sp)
    c2e0:	000d0693          	mv	a3,s10
    c2e4:	00812983          	lw	s3,8(sp)
    c2e8:	04412c83          	lw	s9,68(sp)
    c2ec:	080c0863          	beqz	s8,c37c <_svfprintf_r+0x18fc>
    c2f0:	08049863          	bnez	s1,c380 <_svfprintf_r+0x1900>
    c2f4:	fff40413          	addi	s0,s0,-1
    c2f8:	fffc0c13          	addi	s8,s8,-1
    c2fc:	0e812783          	lw	a5,232(sp)
    c300:	01270733          	add	a4,a4,s2
    c304:	0196a023          	sw	s9,0(a3)
    c308:	00178793          	addi	a5,a5,1
    c30c:	0126a223          	sw	s2,4(a3)
    c310:	0ee12623          	sw	a4,236(sp)
    c314:	0ef12423          	sw	a5,232(sp)
    c318:	00868693          	addi	a3,a3,8
    c31c:	12fb4c63          	blt	s6,a5,c454 <_svfprintf_r+0x19d4>
    c320:	00044603          	lbu	a2,0(s0)
    c324:	415d85b3          	sub	a1,s11,s5
    c328:	00060d13          	mv	s10,a2
    c32c:	00c5d463          	bge	a1,a2,c334 <_svfprintf_r+0x18b4>
    c330:	00058d13          	mv	s10,a1
    c334:	03a05663          	blez	s10,c360 <_svfprintf_r+0x18e0>
    c338:	0e812603          	lw	a2,232(sp)
    c33c:	01a70733          	add	a4,a4,s10
    c340:	0156a023          	sw	s5,0(a3)
    c344:	00160613          	addi	a2,a2,1
    c348:	01a6a223          	sw	s10,4(a3)
    c34c:	0ee12623          	sw	a4,236(sp)
    c350:	0ec12423          	sw	a2,232(sp)
    c354:	30cb4063          	blt	s6,a2,c654 <_svfprintf_r+0x1bd4>
    c358:	00044603          	lbu	a2,0(s0)
    c35c:	00868693          	addi	a3,a3,8
    c360:	fffd4593          	not	a1,s10
    c364:	41f5d593          	srai	a1,a1,0x1f
    c368:	00bd77b3          	and	a5,s10,a1
    c36c:	40f60d33          	sub	s10,a2,a5
    c370:	01a04c63          	bgtz	s10,c388 <_svfprintf_r+0x1908>
    c374:	00ca8ab3          	add	s5,s5,a2
    c378:	f60c1ce3          	bnez	s8,c2f0 <_svfprintf_r+0x1870>
    c37c:	66048663          	beqz	s1,c9e8 <_svfprintf_r+0x1f68>
    c380:	fff48493          	addi	s1,s1,-1
    c384:	f79ff06f          	j	c2fc <_svfprintf_r+0x187c>
    c388:	0e812603          	lw	a2,232(sp)
    c38c:	01abc863          	blt	s7,s10,c39c <_svfprintf_r+0x191c>
    c390:	0600006f          	j	c3f0 <_svfprintf_r+0x1970>
    c394:	ff0d0d13          	addi	s10,s10,-16
    c398:	05abdc63          	bge	s7,s10,c3f0 <_svfprintf_r+0x1970>
    c39c:	01070713          	addi	a4,a4,16
    c3a0:	00160613          	addi	a2,a2,1
    c3a4:	0000a797          	auipc	a5,0xa
    c3a8:	99078793          	addi	a5,a5,-1648 # 15d34 <zeroes.4490>
    c3ac:	00f6a023          	sw	a5,0(a3)
    c3b0:	0176a223          	sw	s7,4(a3)
    c3b4:	0ee12623          	sw	a4,236(sp)
    c3b8:	0ec12423          	sw	a2,232(sp)
    c3bc:	00868693          	addi	a3,a3,8
    c3c0:	fccb5ae3          	bge	s6,a2,c394 <_svfprintf_r+0x1914>
    c3c4:	0e410613          	addi	a2,sp,228
    c3c8:	00098593          	mv	a1,s3
    c3cc:	000a0513          	mv	a0,s4
    c3d0:	58d020ef          	jal	ra,f15c <__ssprint_r>
    c3d4:	00050463          	beqz	a0,c3dc <_svfprintf_r+0x195c>
    c3d8:	8c5fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c3dc:	ff0d0d13          	addi	s10,s10,-16
    c3e0:	0ec12703          	lw	a4,236(sp)
    c3e4:	0e812603          	lw	a2,232(sp)
    c3e8:	10c10693          	addi	a3,sp,268
    c3ec:	fbabc8e3          	blt	s7,s10,c39c <_svfprintf_r+0x191c>
    c3f0:	01a70733          	add	a4,a4,s10
    c3f4:	00160613          	addi	a2,a2,1
    c3f8:	0000a797          	auipc	a5,0xa
    c3fc:	93c78793          	addi	a5,a5,-1732 # 15d34 <zeroes.4490>
    c400:	00f6a023          	sw	a5,0(a3)
    c404:	01a6a223          	sw	s10,4(a3)
    c408:	0ee12623          	sw	a4,236(sp)
    c40c:	0ec12423          	sw	a2,232(sp)
    c410:	68cb4863          	blt	s6,a2,caa0 <_svfprintf_r+0x2020>
    c414:	00044603          	lbu	a2,0(s0)
    c418:	00868693          	addi	a3,a3,8
    c41c:	00ca8ab3          	add	s5,s5,a2
    c420:	f59ff06f          	j	c378 <_svfprintf_r+0x18f8>
    c424:	00812583          	lw	a1,8(sp)
    c428:	0e410613          	addi	a2,sp,228
    c42c:	000a0513          	mv	a0,s4
    c430:	52d020ef          	jal	ra,f15c <__ssprint_r>
    c434:	00050463          	beqz	a0,c43c <_svfprintf_r+0x19bc>
    c438:	865fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c43c:	0e812603          	lw	a2,232(sp)
    c440:	0ec12703          	lw	a4,236(sp)
    c444:	11410d13          	addi	s10,sp,276
    c448:	00160a93          	addi	s5,a2,1
    c44c:	10c10c13          	addi	s8,sp,268
    c450:	891ff06f          	j	bce0 <_svfprintf_r+0x1260>
    c454:	0e410613          	addi	a2,sp,228
    c458:	00098593          	mv	a1,s3
    c45c:	000a0513          	mv	a0,s4
    c460:	4fd020ef          	jal	ra,f15c <__ssprint_r>
    c464:	00050463          	beqz	a0,c46c <_svfprintf_r+0x19ec>
    c468:	835fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c46c:	0ec12703          	lw	a4,236(sp)
    c470:	10c10693          	addi	a3,sp,268
    c474:	eadff06f          	j	c320 <_svfprintf_r+0x18a0>
    c478:	0e812683          	lw	a3,232(sp)
    c47c:	00009597          	auipc	a1,0x9
    c480:	34c58593          	addi	a1,a1,844 # 157c8 <_data+0x4b0>
    c484:	00bd2023          	sw	a1,0(s10)
    c488:	00170713          	addi	a4,a4,1
    c48c:	00100593          	li	a1,1
    c490:	00168693          	addi	a3,a3,1
    c494:	00bd2223          	sw	a1,4(s10)
    c498:	0ee12623          	sw	a4,236(sp)
    c49c:	0ed12423          	sw	a3,232(sp)
    c4a0:	00700593          	li	a1,7
    c4a4:	008d0d13          	addi	s10,s10,8
    c4a8:	06d5ce63          	blt	a1,a3,c524 <_svfprintf_r+0x1aa4>
    c4ac:	26061e63          	bnez	a2,c728 <_svfprintf_r+0x1ca8>
    c4b0:	01812783          	lw	a5,24(sp)
    c4b4:	00197693          	andi	a3,s2,1
    c4b8:	00f6e6b3          	or	a3,a3,a5
    c4bc:	00069463          	bnez	a3,c4c4 <_svfprintf_r+0x1a44>
    c4c0:	ffdfe06f          	j	b4bc <_svfprintf_r+0xa3c>
    c4c4:	03012683          	lw	a3,48(sp)
    c4c8:	02812783          	lw	a5,40(sp)
    c4cc:	00700613          	li	a2,7
    c4d0:	00dd2023          	sw	a3,0(s10)
    c4d4:	0e812683          	lw	a3,232(sp)
    c4d8:	00e78733          	add	a4,a5,a4
    c4dc:	00fd2223          	sw	a5,4(s10)
    c4e0:	00168693          	addi	a3,a3,1
    c4e4:	0ee12623          	sw	a4,236(sp)
    c4e8:	0ed12423          	sw	a3,232(sp)
    c4ec:	008d0893          	addi	a7,s10,8
    c4f0:	4ad64c63          	blt	a2,a3,c9a8 <_svfprintf_r+0x1f28>
    c4f4:	01812783          	lw	a5,24(sp)
    c4f8:	00168693          	addi	a3,a3,1
    c4fc:	0198a023          	sw	s9,0(a7)
    c500:	00e78733          	add	a4,a5,a4
    c504:	00f8a223          	sw	a5,4(a7)
    c508:	0ee12623          	sw	a4,236(sp)
    c50c:	0ed12423          	sw	a3,232(sp)
    c510:	00700793          	li	a5,7
    c514:	00888d13          	addi	s10,a7,8
    c518:	00d7c463          	blt	a5,a3,c520 <_svfprintf_r+0x1aa0>
    c51c:	fa1fe06f          	j	b4bc <_svfprintf_r+0xa3c>
    c520:	fe4ff06f          	j	bd04 <_svfprintf_r+0x1284>
    c524:	00812583          	lw	a1,8(sp)
    c528:	0e410613          	addi	a2,sp,228
    c52c:	000a0513          	mv	a0,s4
    c530:	42d020ef          	jal	ra,f15c <__ssprint_r>
    c534:	00050463          	beqz	a0,c53c <_svfprintf_r+0x1abc>
    c538:	f64fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c53c:	0cc12603          	lw	a2,204(sp)
    c540:	0ec12703          	lw	a4,236(sp)
    c544:	10c10d13          	addi	s10,sp,268
    c548:	f65ff06f          	j	c4ac <_svfprintf_r+0x1a2c>
    c54c:	00812583          	lw	a1,8(sp)
    c550:	0e410613          	addi	a2,sp,228
    c554:	000a0513          	mv	a0,s4
    c558:	405020ef          	jal	ra,f15c <__ssprint_r>
    c55c:	00050463          	beqz	a0,c564 <_svfprintf_r+0x1ae4>
    c560:	f3cfe06f          	j	ac9c <_svfprintf_r+0x21c>
    c564:	10c10d13          	addi	s10,sp,268
    c568:	bc8ff06f          	j	b930 <_svfprintf_r+0xeb0>
    c56c:	1b010c93          	addi	s9,sp,432
    c570:	00000793          	li	a5,0
    c574:	4009f913          	andi	s2,s3,1024
    c578:	00912623          	sw	s1,12(sp)
    c57c:	01312a23          	sw	s3,20(sp)
    c580:	0ff00b13          	li	s6,255
    c584:	000c8993          	mv	s3,s9
    c588:	00612e23          	sw	t1,28(sp)
    c58c:	000a0c93          	mv	s9,s4
    c590:	03c12483          	lw	s1,60(sp)
    c594:	000d8a13          	mv	s4,s11
    c598:	000d0d93          	mv	s11,s10
    c59c:	00040d13          	mv	s10,s0
    c5a0:	00078413          	mv	s0,a5
    c5a4:	0240006f          	j	c5c8 <_svfprintf_r+0x1b48>
    c5a8:	00a00613          	li	a2,10
    c5ac:	00000693          	li	a3,0
    c5b0:	000c0513          	mv	a0,s8
    c5b4:	000a0593          	mv	a1,s4
    c5b8:	254040ef          	jal	ra,1080c <__udivdi3>
    c5bc:	500a0863          	beqz	s4,cacc <_svfprintf_r+0x204c>
    c5c0:	00050c13          	mv	s8,a0
    c5c4:	00058a13          	mv	s4,a1
    c5c8:	00a00613          	li	a2,10
    c5cc:	00000693          	li	a3,0
    c5d0:	000c0513          	mv	a0,s8
    c5d4:	000a0593          	mv	a1,s4
    c5d8:	6d4040ef          	jal	ra,10cac <__umoddi3>
    c5dc:	03050513          	addi	a0,a0,48
    c5e0:	fea98fa3          	sb	a0,-1(s3)
    c5e4:	00140413          	addi	s0,s0,1
    c5e8:	fff98993          	addi	s3,s3,-1
    c5ec:	fa090ee3          	beqz	s2,c5a8 <_svfprintf_r+0x1b28>
    c5f0:	0004c683          	lbu	a3,0(s1)
    c5f4:	fad41ae3          	bne	s0,a3,c5a8 <_svfprintf_r+0x1b28>
    c5f8:	fb6408e3          	beq	s0,s6,c5a8 <_svfprintf_r+0x1b28>
    c5fc:	4c0a1e63          	bnez	s4,cad8 <_svfprintf_r+0x2058>
    c600:	00900793          	li	a5,9
    c604:	4d87ea63          	bltu	a5,s8,cad8 <_svfprintf_r+0x2058>
    c608:	000c8a13          	mv	s4,s9
    c60c:	00098c93          	mv	s9,s3
    c610:	01412983          	lw	s3,20(sp)
    c614:	1b010793          	addi	a5,sp,432
    c618:	00812c23          	sw	s0,24(sp)
    c61c:	02912e23          	sw	s1,60(sp)
    c620:	000d0413          	mv	s0,s10
    c624:	01c12303          	lw	t1,28(sp)
    c628:	00c12483          	lw	s1,12(sp)
    c62c:	000d8d13          	mv	s10,s11
    c630:	41978b33          	sub	s6,a5,s9
    c634:	00098913          	mv	s2,s3
    c638:	f50fe06f          	j	ad88 <_svfprintf_r+0x308>
    c63c:	00009697          	auipc	a3,0x9
    c640:	6f868693          	addi	a3,a3,1784 # 15d34 <zeroes.4490>
    c644:	01670733          	add	a4,a4,s6
    c648:	00178793          	addi	a5,a5,1
    c64c:	00dd2023          	sw	a3,0(s10)
    c650:	e55fe06f          	j	b4a4 <_svfprintf_r+0xa24>
    c654:	0e410613          	addi	a2,sp,228
    c658:	00098593          	mv	a1,s3
    c65c:	000a0513          	mv	a0,s4
    c660:	2fd020ef          	jal	ra,f15c <__ssprint_r>
    c664:	00050463          	beqz	a0,c66c <_svfprintf_r+0x1bec>
    c668:	e34fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c66c:	00044603          	lbu	a2,0(s0)
    c670:	0ec12703          	lw	a4,236(sp)
    c674:	10c10693          	addi	a3,sp,268
    c678:	ce9ff06f          	j	c360 <_svfprintf_r+0x18e0>
    c67c:	0f012783          	lw	a5,240(sp)
    c680:	0a010593          	addi	a1,sp,160
    c684:	0b010513          	addi	a0,sp,176
    c688:	0af12823          	sw	a5,176(sp)
    c68c:	0f412783          	lw	a5,244(sp)
    c690:	0a012023          	sw	zero,160(sp)
    c694:	0a012223          	sw	zero,164(sp)
    c698:	0af12a23          	sw	a5,180(sp)
    c69c:	0f812783          	lw	a5,248(sp)
    c6a0:	0a012423          	sw	zero,168(sp)
    c6a4:	0a012623          	sw	zero,172(sp)
    c6a8:	0af12c23          	sw	a5,184(sp)
    c6ac:	0fc12783          	lw	a5,252(sp)
    c6b0:	0af12e23          	sw	a5,188(sp)
    c6b4:	269050ef          	jal	ra,1211c <__letf2>
    c6b8:	46054063          	bltz	a0,cb18 <_svfprintf_r+0x2098>
    c6bc:	0c714703          	lbu	a4,199(sp)
    c6c0:	04700693          	li	a3,71
    c6c4:	00009c97          	auipc	s9,0x9
    c6c8:	0c4c8c93          	addi	s9,s9,196 # 15788 <_data+0x470>
    c6cc:	2156ca63          	blt	a3,s5,c8e0 <_svfprintf_r+0x1e60>
    c6d0:	00012623          	sw	zero,12(sp)
    c6d4:	02012023          	sw	zero,32(sp)
    c6d8:	00012e23          	sw	zero,28(sp)
    c6dc:	00012a23          	sw	zero,20(sp)
    c6e0:	f7f97913          	andi	s2,s2,-129
    c6e4:	00300993          	li	s3,3
    c6e8:	00300b13          	li	s6,3
    c6ec:	00000313          	li	t1,0
    c6f0:	00070463          	beqz	a4,c6f8 <_svfprintf_r+0x1c78>
    c6f4:	eb8fe06f          	j	adac <_svfprintf_r+0x32c>
    c6f8:	cf9fe06f          	j	b3f0 <_svfprintf_r+0x970>
    c6fc:	01012783          	lw	a5,16(sp)
    c700:	00048c93          	mv	s9,s1
    c704:	0007a783          	lw	a5,0(a5)
    c708:	00e12823          	sw	a4,16(sp)
    c70c:	00412703          	lw	a4,4(sp)
    c710:	00e7a023          	sw	a4,0(a5)
    c714:	fd8fe06f          	j	aeec <_svfprintf_r+0x46c>
    c718:	000c8513          	mv	a0,s9
    c71c:	d5df40ef          	jal	ra,1478 <strlen>
    c720:	00050b13          	mv	s6,a0
    c724:	bd1fe06f          	j	b2f4 <_svfprintf_r+0x874>
    c728:	03012683          	lw	a3,48(sp)
    c72c:	02812783          	lw	a5,40(sp)
    c730:	00700593          	li	a1,7
    c734:	00dd2023          	sw	a3,0(s10)
    c738:	0e812683          	lw	a3,232(sp)
    c73c:	00e78733          	add	a4,a5,a4
    c740:	00fd2223          	sw	a5,4(s10)
    c744:	00168693          	addi	a3,a3,1
    c748:	0ee12623          	sw	a4,236(sp)
    c74c:	0ed12423          	sw	a3,232(sp)
    c750:	008d0893          	addi	a7,s10,8
    c754:	24d5ca63          	blt	a1,a3,c9a8 <_svfprintf_r+0x1f28>
    c758:	d8065ee3          	bgez	a2,c4f4 <_svfprintf_r+0x1a74>
    c75c:	ff000593          	li	a1,-16
    c760:	40c00b33          	neg	s6,a2
    c764:	24b65ae3          	bge	a2,a1,d1b8 <_svfprintf_r+0x2738>
    c768:	00700c13          	li	s8,7
    c76c:	00812a83          	lw	s5,8(sp)
    c770:	00c0006f          	j	c77c <_svfprintf_r+0x1cfc>
    c774:	ff0b0b13          	addi	s6,s6,-16
    c778:	256bd0e3          	bge	s7,s6,d1b8 <_svfprintf_r+0x2738>
    c77c:	01070713          	addi	a4,a4,16
    c780:	00168693          	addi	a3,a3,1
    c784:	00009797          	auipc	a5,0x9
    c788:	5b078793          	addi	a5,a5,1456 # 15d34 <zeroes.4490>
    c78c:	00f8a023          	sw	a5,0(a7)
    c790:	0178a223          	sw	s7,4(a7)
    c794:	0ee12623          	sw	a4,236(sp)
    c798:	0ed12423          	sw	a3,232(sp)
    c79c:	00888893          	addi	a7,a7,8
    c7a0:	fcdc5ae3          	bge	s8,a3,c774 <_svfprintf_r+0x1cf4>
    c7a4:	0e410613          	addi	a2,sp,228
    c7a8:	000a8593          	mv	a1,s5
    c7ac:	000a0513          	mv	a0,s4
    c7b0:	1ad020ef          	jal	ra,f15c <__ssprint_r>
    c7b4:	00050463          	beqz	a0,c7bc <_svfprintf_r+0x1d3c>
    c7b8:	ce4fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c7bc:	0ec12703          	lw	a4,236(sp)
    c7c0:	0e812683          	lw	a3,232(sp)
    c7c4:	10c10893          	addi	a7,sp,268
    c7c8:	fadff06f          	j	c774 <_svfprintf_r+0x1cf4>
    c7cc:	000d0693          	mv	a3,s10
    c7d0:	001b0a93          	addi	s5,s6,1
    c7d4:	008c0793          	addi	a5,s8,8
    c7d8:	00d70733          	add	a4,a4,a3
    c7dc:	00009617          	auipc	a2,0x9
    c7e0:	55860613          	addi	a2,a2,1368 # 15d34 <zeroes.4490>
    c7e4:	00dc2223          	sw	a3,4(s8)
    c7e8:	00cc2023          	sw	a2,0(s8)
    c7ec:	0ee12623          	sw	a4,236(sp)
    c7f0:	0f512423          	sw	s5,232(sp)
    c7f4:	00700693          	li	a3,7
    c7f8:	c356c6e3          	blt	a3,s5,c424 <_svfprintf_r+0x19a4>
    c7fc:	001a8a93          	addi	s5,s5,1
    c800:	00878d13          	addi	s10,a5,8
    c804:	00078c13          	mv	s8,a5
    c808:	cd8ff06f          	j	bce0 <_svfprintf_r+0x1260>
    c80c:	20097713          	andi	a4,s2,512
    c810:	16070463          	beqz	a4,c978 <_svfprintf_r+0x1ef8>
    c814:	00f12823          	sw	a5,16(sp)
    c818:	0ffc7c13          	andi	s8,s8,255
    c81c:	00000d93          	li	s11,0
    c820:	00090993          	mv	s3,s2
    c824:	00100793          	li	a5,1
    c828:	d2cfe06f          	j	ad54 <_svfprintf_r+0x2d4>
    c82c:	20097713          	andi	a4,s2,512
    c830:	12070e63          	beqz	a4,c96c <_svfprintf_r+0x1eec>
    c834:	0ffc7c13          	andi	s8,s8,255
    c838:	00000d93          	li	s11,0
    c83c:	00f12823          	sw	a5,16(sp)
    c840:	f8dfe06f          	j	b7cc <_svfprintf_r+0xd4c>
    c844:	20097713          	andi	a4,s2,512
    c848:	10070463          	beqz	a4,c950 <_svfprintf_r+0x1ed0>
    c84c:	01012703          	lw	a4,16(sp)
    c850:	00090993          	mv	s3,s2
    c854:	00f12823          	sw	a5,16(sp)
    c858:	00070c03          	lb	s8,0(a4)
    c85c:	41fc5d93          	srai	s11,s8,0x1f
    c860:	000d8713          	mv	a4,s11
    c864:	b25fe06f          	j	b388 <_svfprintf_r+0x908>
    c868:	0fc12783          	lw	a5,252(sp)
    c86c:	1207c663          	bltz	a5,c998 <_svfprintf_r+0x1f18>
    c870:	0c714703          	lbu	a4,199(sp)
    c874:	04700693          	li	a3,71
    c878:	00009c97          	auipc	s9,0x9
    c87c:	f18c8c93          	addi	s9,s9,-232 # 15790 <_data+0x478>
    c880:	e556d8e3          	bge	a3,s5,c6d0 <_svfprintf_r+0x1c50>
    c884:	00009c97          	auipc	s9,0x9
    c888:	f10c8c93          	addi	s9,s9,-240 # 15794 <_data+0x47c>
    c88c:	e45ff06f          	j	c6d0 <_svfprintf_r+0x1c50>
    c890:	01670733          	add	a4,a4,s6
    c894:	00168693          	addi	a3,a3,1
    c898:	00009797          	auipc	a5,0x9
    c89c:	49c78793          	addi	a5,a5,1180 # 15d34 <zeroes.4490>
    c8a0:	00fd2023          	sw	a5,0(s10)
    c8a4:	016d2223          	sw	s6,4(s10)
    c8a8:	0ee12623          	sw	a4,236(sp)
    c8ac:	0ed12423          	sw	a3,232(sp)
    c8b0:	00700613          	li	a2,7
    c8b4:	008d0d13          	addi	s10,s10,8
    c8b8:	e2d65263          	bge	a2,a3,bedc <_svfprintf_r+0x145c>
    c8bc:	00812583          	lw	a1,8(sp)
    c8c0:	0e410613          	addi	a2,sp,228
    c8c4:	000a0513          	mv	a0,s4
    c8c8:	095020ef          	jal	ra,f15c <__ssprint_r>
    c8cc:	00050463          	beqz	a0,c8d4 <_svfprintf_r+0x1e54>
    c8d0:	bccfe06f          	j	ac9c <_svfprintf_r+0x21c>
    c8d4:	0ec12703          	lw	a4,236(sp)
    c8d8:	10c10d13          	addi	s10,sp,268
    c8dc:	e00ff06f          	j	bedc <_svfprintf_r+0x145c>
    c8e0:	00009c97          	auipc	s9,0x9
    c8e4:	eacc8c93          	addi	s9,s9,-340 # 1578c <_data+0x474>
    c8e8:	de9ff06f          	j	c6d0 <_svfprintf_r+0x1c50>
    c8ec:	00812583          	lw	a1,8(sp)
    c8f0:	0e410613          	addi	a2,sp,228
    c8f4:	000a0513          	mv	a0,s4
    c8f8:	065020ef          	jal	ra,f15c <__ssprint_r>
    c8fc:	00050463          	beqz	a0,c904 <_svfprintf_r+0x1e84>
    c900:	b9cfe06f          	j	ac9c <_svfprintf_r+0x21c>
    c904:	0ec12703          	lw	a4,236(sp)
    c908:	10c10d13          	addi	s10,sp,268
    c90c:	db8ff06f          	j	bec4 <_svfprintf_r+0x1444>
    c910:	00600b13          	li	s6,6
    c914:	91dff06f          	j	c230 <_svfprintf_r+0x17b0>
    c918:	01812683          	lw	a3,24(sp)
    c91c:	00dc87b3          	add	a5,s9,a3
    c920:	41668b33          	sub	s6,a3,s6
    c924:	41578c33          	sub	s8,a5,s5
    c928:	e58b5863          	bge	s6,s8,bf78 <_svfprintf_r+0x14f8>
    c92c:	000b0c13          	mv	s8,s6
    c930:	e48ff06f          	j	bf78 <_svfprintf_r+0x14f8>
    c934:	01012783          	lw	a5,16(sp)
    c938:	00e12823          	sw	a4,16(sp)
    c93c:	00412703          	lw	a4,4(sp)
    c940:	0007a783          	lw	a5,0(a5)
    c944:	00048c93          	mv	s9,s1
    c948:	00e79023          	sh	a4,0(a5)
    c94c:	da0fe06f          	j	aeec <_svfprintf_r+0x46c>
    c950:	01012703          	lw	a4,16(sp)
    c954:	00090993          	mv	s3,s2
    c958:	00f12823          	sw	a5,16(sp)
    c95c:	00072c03          	lw	s8,0(a4)
    c960:	41fc5d93          	srai	s11,s8,0x1f
    c964:	000d8713          	mv	a4,s11
    c968:	a21fe06f          	j	b388 <_svfprintf_r+0x908>
    c96c:	00000d93          	li	s11,0
    c970:	00f12823          	sw	a5,16(sp)
    c974:	e59fe06f          	j	b7cc <_svfprintf_r+0xd4c>
    c978:	00f12823          	sw	a5,16(sp)
    c97c:	00000d93          	li	s11,0
    c980:	00090993          	mv	s3,s2
    c984:	00100793          	li	a5,1
    c988:	bccfe06f          	j	ad54 <_svfprintf_r+0x2d4>
    c98c:	0ffc7c13          	andi	s8,s8,255
    c990:	00000d93          	li	s11,0
    c994:	ba4fe06f          	j	ad38 <_svfprintf_r+0x2b8>
    c998:	02d00793          	li	a5,45
    c99c:	0cf103a3          	sb	a5,199(sp)
    c9a0:	02d00713          	li	a4,45
    c9a4:	ed1ff06f          	j	c874 <_svfprintf_r+0x1df4>
    c9a8:	00812583          	lw	a1,8(sp)
    c9ac:	0e410613          	addi	a2,sp,228
    c9b0:	000a0513          	mv	a0,s4
    c9b4:	7a8020ef          	jal	ra,f15c <__ssprint_r>
    c9b8:	00050463          	beqz	a0,c9c0 <_svfprintf_r+0x1f40>
    c9bc:	ae0fe06f          	j	ac9c <_svfprintf_r+0x21c>
    c9c0:	0cc12603          	lw	a2,204(sp)
    c9c4:	0ec12703          	lw	a4,236(sp)
    c9c8:	0e812683          	lw	a3,232(sp)
    c9cc:	10c10893          	addi	a7,sp,268
    c9d0:	b20652e3          	bgez	a2,c4f4 <_svfprintf_r+0x1a74>
    c9d4:	d89ff06f          	j	c75c <_svfprintf_r+0x1cdc>
    c9d8:	00600313          	li	t1,6
    c9dc:	e6cfe06f          	j	b048 <_svfprintf_r+0x5c8>
    c9e0:	00090993          	mv	s3,s2
    c9e4:	e55fe06f          	j	b838 <_svfprintf_r+0xdb8>
    c9e8:	02012c83          	lw	s9,32(sp)
    c9ec:	01812783          	lw	a5,24(sp)
    c9f0:	02812e23          	sw	s0,60(sp)
    c9f4:	00068d13          	mv	s10,a3
    c9f8:	00fc86b3          	add	a3,s9,a5
    c9fc:	01412483          	lw	s1,20(sp)
    ca00:	03412903          	lw	s2,52(sp)
    ca04:	04812403          	lw	s0,72(sp)
    ca08:	01c12983          	lw	s3,28(sp)
    ca0c:	cf56f063          	bgeu	a3,s5,beec <_svfprintf_r+0x146c>
    ca10:	00068a93          	mv	s5,a3
    ca14:	cd8ff06f          	j	beec <_svfprintf_r+0x146c>
    ca18:	01412783          	lw	a5,20(sp)
    ca1c:	ffd00713          	li	a4,-3
    ca20:	00e7c463          	blt	a5,a4,ca28 <_svfprintf_r+0x1fa8>
    ca24:	00f35a63          	bge	t1,a5,ca38 <_svfprintf_r+0x1fb8>
    ca28:	ffea8a93          	addi	s5,s5,-2
    ca2c:	fdfaf793          	andi	a5,s5,-33
    ca30:	04f12423          	sw	a5,72(sp)
    ca34:	f00fe06f          	j	b134 <_svfprintf_r+0x6b4>
    ca38:	01812703          	lw	a4,24(sp)
    ca3c:	01412783          	lw	a5,20(sp)
    ca40:	24e7c263          	blt	a5,a4,cc84 <_svfprintf_r+0x2204>
    ca44:	05412703          	lw	a4,84(sp)
    ca48:	00078b13          	mv	s6,a5
    ca4c:	00177713          	andi	a4,a4,1
    ca50:	00070663          	beqz	a4,ca5c <_svfprintf_r+0x1fdc>
    ca54:	02812703          	lw	a4,40(sp)
    ca58:	00e78b33          	add	s6,a5,a4
    ca5c:	05412783          	lw	a5,84(sp)
    ca60:	4007f713          	andi	a4,a5,1024
    ca64:	00070663          	beqz	a4,ca70 <_svfprintf_r+0x1ff0>
    ca68:	01412783          	lw	a5,20(sp)
    ca6c:	7cf04663          	bgtz	a5,d238 <_svfprintf_r+0x27b8>
    ca70:	fffb4993          	not	s3,s6
    ca74:	41f9d993          	srai	s3,s3,0x1f
    ca78:	013b79b3          	and	s3,s6,s3
    ca7c:	06700a93          	li	s5,103
    ca80:	02012023          	sw	zero,32(sp)
    ca84:	00012e23          	sw	zero,28(sp)
    ca88:	fccfe06f          	j	b254 <_svfprintf_r+0x7d4>
    ca8c:	0c714703          	lbu	a4,199(sp)
    ca90:	00000313          	li	t1,0
    ca94:	00070463          	beqz	a4,ca9c <_svfprintf_r+0x201c>
    ca98:	b14fe06f          	j	adac <_svfprintf_r+0x32c>
    ca9c:	955fe06f          	j	b3f0 <_svfprintf_r+0x970>
    caa0:	0e410613          	addi	a2,sp,228
    caa4:	00098593          	mv	a1,s3
    caa8:	000a0513          	mv	a0,s4
    caac:	6b0020ef          	jal	ra,f15c <__ssprint_r>
    cab0:	00050463          	beqz	a0,cab8 <_svfprintf_r+0x2038>
    cab4:	9e8fe06f          	j	ac9c <_svfprintf_r+0x21c>
    cab8:	00044603          	lbu	a2,0(s0)
    cabc:	0ec12703          	lw	a4,236(sp)
    cac0:	10c10693          	addi	a3,sp,268
    cac4:	00ca8ab3          	add	s5,s5,a2
    cac8:	8b1ff06f          	j	c378 <_svfprintf_r+0x18f8>
    cacc:	00900793          	li	a5,9
    cad0:	af87e8e3          	bltu	a5,s8,c5c0 <_svfprintf_r+0x1b40>
    cad4:	b35ff06f          	j	c608 <_svfprintf_r+0x1b88>
    cad8:	04012783          	lw	a5,64(sp)
    cadc:	04412583          	lw	a1,68(sp)
    cae0:	00000413          	li	s0,0
    cae4:	40f989b3          	sub	s3,s3,a5
    cae8:	00078613          	mv	a2,a5
    caec:	00098513          	mv	a0,s3
    caf0:	ec5fd0ef          	jal	ra,a9b4 <strncpy>
    caf4:	0014c803          	lbu	a6,1(s1)
    caf8:	00a00613          	li	a2,10
    cafc:	00000693          	li	a3,0
    cb00:	01003833          	snez	a6,a6
    cb04:	000c0513          	mv	a0,s8
    cb08:	000a0593          	mv	a1,s4
    cb0c:	010484b3          	add	s1,s1,a6
    cb10:	4fd030ef          	jal	ra,1080c <__udivdi3>
    cb14:	aadff06f          	j	c5c0 <_svfprintf_r+0x1b40>
    cb18:	02d00793          	li	a5,45
    cb1c:	0cf103a3          	sb	a5,199(sp)
    cb20:	02d00713          	li	a4,45
    cb24:	b9dff06f          	j	c6c0 <_svfprintf_r+0x1c40>
    cb28:	0b010c13          	addi	s8,sp,176
    cb2c:	00030693          	mv	a3,t1
    cb30:	0cc10713          	addi	a4,sp,204
    cb34:	0dc10813          	addi	a6,sp,220
    cb38:	0d010793          	addi	a5,sp,208
    cb3c:	00300613          	li	a2,3
    cb40:	000c0593          	mv	a1,s8
    cb44:	000a0513          	mv	a0,s4
    cb48:	00612e23          	sw	t1,28(sp)
    cb4c:	0be12823          	sw	t5,176(sp)
    cb50:	01e12c23          	sw	t5,24(sp)
    cb54:	0bd12c23          	sw	t4,184(sp)
    cb58:	01d12a23          	sw	t4,20(sp)
    cb5c:	0bb12a23          	sw	s11,180(sp)
    cb60:	0b612e23          	sw	s6,188(sp)
    cb64:	928fa0ef          	jal	ra,6c8c <_ldtoa_r>
    cb68:	00054683          	lbu	a3,0(a0)
    cb6c:	03000713          	li	a4,48
    cb70:	00050c93          	mv	s9,a0
    cb74:	01412e83          	lw	t4,20(sp)
    cb78:	01812f03          	lw	t5,24(sp)
    cb7c:	01c12303          	lw	t1,28(sp)
    cb80:	0ae684e3          	beq	a3,a4,d428 <_svfprintf_r+0x29a8>
    cb84:	0a010793          	addi	a5,sp,160
    cb88:	04f12c23          	sw	a5,88(sp)
    cb8c:	0cc12703          	lw	a4,204(sp)
    cb90:	006709b3          	add	s3,a4,t1
    cb94:	013c89b3          	add	s3,s9,s3
    cb98:	05812583          	lw	a1,88(sp)
    cb9c:	000c0513          	mv	a0,s8
    cba0:	00612a23          	sw	t1,20(sp)
    cba4:	0be12823          	sw	t5,176(sp)
    cba8:	0bb12a23          	sw	s11,180(sp)
    cbac:	0bd12c23          	sw	t4,184(sp)
    cbb0:	0b612e23          	sw	s6,188(sp)
    cbb4:	0a012023          	sw	zero,160(sp)
    cbb8:	0a012223          	sw	zero,164(sp)
    cbbc:	0a012423          	sw	zero,168(sp)
    cbc0:	0a012623          	sw	zero,172(sp)
    cbc4:	318050ef          	jal	ra,11edc <__eqtf2>
    cbc8:	00098713          	mv	a4,s3
    cbcc:	01412303          	lw	t1,20(sp)
    cbd0:	00051463          	bnez	a0,cbd8 <_svfprintf_r+0x2158>
    cbd4:	d30fe06f          	j	b104 <_svfprintf_r+0x684>
    cbd8:	0dc12703          	lw	a4,220(sp)
    cbdc:	03000613          	li	a2,48
    cbe0:	01376463          	bltu	a4,s3,cbe8 <_svfprintf_r+0x2168>
    cbe4:	d20fe06f          	j	b104 <_svfprintf_r+0x684>
    cbe8:	00170793          	addi	a5,a4,1
    cbec:	0cf12e23          	sw	a5,220(sp)
    cbf0:	00c70023          	sb	a2,0(a4)
    cbf4:	0dc12703          	lw	a4,220(sp)
    cbf8:	ff3768e3          	bltu	a4,s3,cbe8 <_svfprintf_r+0x2168>
    cbfc:	d08fe06f          	j	b104 <_svfprintf_r+0x684>
    cc00:	00812583          	lw	a1,8(sp)
    cc04:	0e410613          	addi	a2,sp,228
    cc08:	000a0513          	mv	a0,s4
    cc0c:	550020ef          	jal	ra,f15c <__ssprint_r>
    cc10:	00050463          	beqz	a0,cc18 <_svfprintf_r+0x2198>
    cc14:	888fe06f          	j	ac9c <_svfprintf_r+0x21c>
    cc18:	0cc12b03          	lw	s6,204(sp)
    cc1c:	0ec12703          	lw	a4,236(sp)
    cc20:	10c10d13          	addi	s10,sp,268
    cc24:	b0cff06f          	j	bf30 <_svfprintf_r+0x14b0>
    cc28:	0c714703          	lbu	a4,199(sp)
    cc2c:	01812823          	sw	s8,16(sp)
    cc30:	02012023          	sw	zero,32(sp)
    cc34:	00012e23          	sw	zero,28(sp)
    cc38:	00012a23          	sw	zero,20(sp)
    cc3c:	00030993          	mv	s3,t1
    cc40:	00030b13          	mv	s6,t1
    cc44:	00000313          	li	t1,0
    cc48:	00070463          	beqz	a4,cc50 <_svfprintf_r+0x21d0>
    cc4c:	960fe06f          	j	adac <_svfprintf_r+0x32c>
    cc50:	fa0fe06f          	j	b3f0 <_svfprintf_r+0x970>
    cc54:	00812583          	lw	a1,8(sp)
    cc58:	0e410613          	addi	a2,sp,228
    cc5c:	000a0513          	mv	a0,s4
    cc60:	4fc020ef          	jal	ra,f15c <__ssprint_r>
    cc64:	00050463          	beqz	a0,cc6c <_svfprintf_r+0x21ec>
    cc68:	834fe06f          	j	ac9c <_svfprintf_r+0x21c>
    cc6c:	0cc12b03          	lw	s6,204(sp)
    cc70:	01812783          	lw	a5,24(sp)
    cc74:	0ec12703          	lw	a4,236(sp)
    cc78:	10c10d13          	addi	s10,sp,268
    cc7c:	41678b33          	sub	s6,a5,s6
    cc80:	af8ff06f          	j	bf78 <_svfprintf_r+0x14f8>
    cc84:	01812783          	lw	a5,24(sp)
    cc88:	02812703          	lw	a4,40(sp)
    cc8c:	06700a93          	li	s5,103
    cc90:	00e78b33          	add	s6,a5,a4
    cc94:	01412783          	lw	a5,20(sp)
    cc98:	76f05c63          	blez	a5,d410 <_svfprintf_r+0x2990>
    cc9c:	05412783          	lw	a5,84(sp)
    cca0:	4007f713          	andi	a4,a5,1024
    cca4:	58071c63          	bnez	a4,d23c <_svfprintf_r+0x27bc>
    cca8:	fffb4993          	not	s3,s6
    ccac:	41f9d993          	srai	s3,s3,0x1f
    ccb0:	013b79b3          	and	s3,s6,s3
    ccb4:	dcdff06f          	j	ca80 <_svfprintf_r+0x2000>
    ccb8:	05412783          	lw	a5,84(sp)
    ccbc:	0017f713          	andi	a4,a5,1
    ccc0:	01412783          	lw	a5,20(sp)
    ccc4:	00676733          	or	a4,a4,t1
    ccc8:	7cf05c63          	blez	a5,d4a0 <_svfprintf_r+0x2a20>
    cccc:	72071863          	bnez	a4,d3fc <_svfprintf_r+0x297c>
    ccd0:	01412b03          	lw	s6,20(sp)
    ccd4:	06600a93          	li	s5,102
    ccd8:	fc5ff06f          	j	cc9c <_svfprintf_r+0x221c>
    ccdc:	03000793          	li	a5,48
    cce0:	0cf10423          	sb	a5,200(sp)
    cce4:	05800793          	li	a5,88
    cce8:	0cf104a3          	sb	a5,201(sp)
    ccec:	00296793          	ori	a5,s2,2
    ccf0:	06300713          	li	a4,99
    ccf4:	04f12a23          	sw	a5,84(sp)
    ccf8:	00012623          	sw	zero,12(sp)
    ccfc:	14c10c93          	addi	s9,sp,332
    cd00:	3c674063          	blt	a4,t1,d0c0 <_svfprintf_r+0x2640>
    cd04:	0fc12b03          	lw	s6,252(sp)
    cd08:	fdfaf793          	andi	a5,s5,-33
    cd0c:	04f12423          	sw	a5,72(sp)
    cd10:	04012e23          	sw	zero,92(sp)
    cd14:	10296913          	ori	s2,s2,258
    cd18:	0f012f03          	lw	t5,240(sp)
    cd1c:	0f412d83          	lw	s11,244(sp)
    cd20:	0f812e83          	lw	t4,248(sp)
    cd24:	380b4463          	bltz	s6,d0ac <_svfprintf_r+0x262c>
    cd28:	06100713          	li	a4,97
    cd2c:	58ea8a63          	beq	s5,a4,d2c0 <_svfprintf_r+0x2840>
    cd30:	04100713          	li	a4,65
    cd34:	00ea8463          	beq	s5,a4,cd3c <_svfprintf_r+0x22bc>
    cd38:	b3cfe06f          	j	b074 <_svfprintf_r+0x5f4>
    cd3c:	0b010c13          	addi	s8,sp,176
    cd40:	000c0513          	mv	a0,s8
    cd44:	02612a23          	sw	t1,52(sp)
    cd48:	0be12823          	sw	t5,176(sp)
    cd4c:	0bd12c23          	sw	t4,184(sp)
    cd50:	0b612e23          	sw	s6,188(sp)
    cd54:	0bb12a23          	sw	s11,180(sp)
    cd58:	16c080ef          	jal	ra,14ec4 <__trunctfdf2>
    cd5c:	0cc10613          	addi	a2,sp,204
    cd60:	fe4fd0ef          	jal	ra,a544 <frexp>
    cd64:	00058613          	mv	a2,a1
    cd68:	00050593          	mv	a1,a0
    cd6c:	000c0513          	mv	a0,s8
    cd70:	6e9070ef          	jal	ra,14c58 <__extenddftf2>
    cd74:	0b012703          	lw	a4,176(sp)
    cd78:	09010793          	addi	a5,sp,144
    cd7c:	0a010993          	addi	s3,sp,160
    cd80:	08e12823          	sw	a4,144(sp)
    cd84:	0b412703          	lw	a4,180(sp)
    cd88:	08010613          	addi	a2,sp,128
    cd8c:	00078593          	mv	a1,a5
    cd90:	08e12a23          	sw	a4,148(sp)
    cd94:	0b812703          	lw	a4,184(sp)
    cd98:	00098513          	mv	a0,s3
    cd9c:	00078b13          	mv	s6,a5
    cda0:	08e12c23          	sw	a4,152(sp)
    cda4:	0bc12703          	lw	a4,188(sp)
    cda8:	04c12623          	sw	a2,76(sp)
    cdac:	05312c23          	sw	s3,88(sp)
    cdb0:	08e12e23          	sw	a4,156(sp)
    cdb4:	3ffc0737          	lui	a4,0x3ffc0
    cdb8:	08e12623          	sw	a4,140(sp)
    cdbc:	08012023          	sw	zero,128(sp)
    cdc0:	08012223          	sw	zero,132(sp)
    cdc4:	08012423          	sw	zero,136(sp)
    cdc8:	4c8050ef          	jal	ra,12290 <__multf3>
    cdcc:	0a012703          	lw	a4,160(sp)
    cdd0:	0a412683          	lw	a3,164(sp)
    cdd4:	0a812803          	lw	a6,168(sp)
    cdd8:	0ac12e83          	lw	t4,172(sp)
    cddc:	00098593          	mv	a1,s3
    cde0:	000c0513          	mv	a0,s8
    cde4:	0ae12823          	sw	a4,176(sp)
    cde8:	02e12023          	sw	a4,32(sp)
    cdec:	0ad12a23          	sw	a3,180(sp)
    cdf0:	00d12e23          	sw	a3,28(sp)
    cdf4:	0b012c23          	sw	a6,184(sp)
    cdf8:	01012c23          	sw	a6,24(sp)
    cdfc:	0bd12e23          	sw	t4,188(sp)
    ce00:	01d12a23          	sw	t4,20(sp)
    ce04:	0a012023          	sw	zero,160(sp)
    ce08:	0a012223          	sw	zero,164(sp)
    ce0c:	0a012423          	sw	zero,168(sp)
    ce10:	0a012623          	sw	zero,172(sp)
    ce14:	0c8050ef          	jal	ra,11edc <__eqtf2>
    ce18:	01412e83          	lw	t4,20(sp)
    ce1c:	01812803          	lw	a6,24(sp)
    ce20:	01c12683          	lw	a3,28(sp)
    ce24:	02012703          	lw	a4,32(sp)
    ce28:	03412303          	lw	t1,52(sp)
    ce2c:	00051663          	bnez	a0,ce38 <_svfprintf_r+0x23b8>
    ce30:	00100613          	li	a2,1
    ce34:	0cc12623          	sw	a2,204(sp)
    ce38:	00009797          	auipc	a5,0x9
    ce3c:	97478793          	addi	a5,a5,-1676 # 157ac <_data+0x494>
    ce40:	02f12a23          	sw	a5,52(sp)
    ce44:	fff30d93          	addi	s11,t1,-1
    ce48:	01912a23          	sw	s9,20(sp)
    ce4c:	06912023          	sw	s1,96(sp)
    ce50:	07512223          	sw	s5,100(sp)
    ce54:	06812623          	sw	s0,108(sp)
    ce58:	07a12a23          	sw	s10,116(sp)
    ce5c:	07412c23          	sw	s4,120(sp)
    ce60:	07912e23          	sw	s9,124(sp)
    ce64:	07212423          	sw	s2,104(sp)
    ce68:	000d8c93          	mv	s9,s11
    ce6c:	06612823          	sw	t1,112(sp)
    ce70:	00070d13          	mv	s10,a4
    ce74:	00068d93          	mv	s11,a3
    ce78:	00080a13          	mv	s4,a6
    ce7c:	000e8a93          	mv	s5,t4
    ce80:	000b0493          	mv	s1,s6
    ce84:	05812403          	lw	s0,88(sp)
    ce88:	0540006f          	j	cedc <_svfprintf_r+0x245c>
    ce8c:	00040593          	mv	a1,s0
    ce90:	000c0513          	mv	a0,s8
    ce94:	02c12023          	sw	a2,32(sp)
    ce98:	01e12e23          	sw	t5,28(sp)
    ce9c:	01f12c23          	sw	t6,24(sp)
    cea0:	0bf12a23          	sw	t6,180(sp)
    cea4:	0be12c23          	sw	t5,184(sp)
    cea8:	0ac12e23          	sw	a2,188(sp)
    ceac:	0b212823          	sw	s2,176(sp)
    ceb0:	0a012023          	sw	zero,160(sp)
    ceb4:	0a012223          	sw	zero,164(sp)
    ceb8:	0a012423          	sw	zero,168(sp)
    cebc:	0a012623          	sw	zero,172(sp)
    cec0:	01c050ef          	jal	ra,11edc <__eqtf2>
    cec4:	fffc8c93          	addi	s9,s9,-1
    cec8:	01812f83          	lw	t6,24(sp)
    cecc:	01c12f03          	lw	t5,28(sp)
    ced0:	02012603          	lw	a2,32(sp)
    ced4:	0e050463          	beqz	a0,cfbc <_svfprintf_r+0x253c>
    ced8:	01612a23          	sw	s6,20(sp)
    cedc:	400307b7          	lui	a5,0x40030
    cee0:	00048613          	mv	a2,s1
    cee4:	00040593          	mv	a1,s0
    cee8:	000c0513          	mv	a0,s8
    ceec:	08f12e23          	sw	a5,156(sp)
    cef0:	0ba12023          	sw	s10,160(sp)
    cef4:	0bb12223          	sw	s11,164(sp)
    cef8:	0b412423          	sw	s4,168(sp)
    cefc:	0b512623          	sw	s5,172(sp)
    cf00:	08012823          	sw	zero,144(sp)
    cf04:	08012a23          	sw	zero,148(sp)
    cf08:	08012c23          	sw	zero,152(sp)
    cf0c:	384050ef          	jal	ra,12290 <__multf3>
    cf10:	000c0513          	mv	a0,s8
    cf14:	24d070ef          	jal	ra,14960 <__fixtfsi>
    cf18:	00050593          	mv	a1,a0
    cf1c:	00050993          	mv	s3,a0
    cf20:	000c0513          	mv	a0,s8
    cf24:	0bc12b03          	lw	s6,188(sp)
    cf28:	0b012a83          	lw	s5,176(sp)
    cf2c:	0b412a03          	lw	s4,180(sp)
    cf30:	0b812903          	lw	s2,184(sp)
    cf34:	379070ef          	jal	ra,14aac <__floatsitf>
    cf38:	0b012703          	lw	a4,176(sp)
    cf3c:	04c12603          	lw	a2,76(sp)
    cf40:	00048593          	mv	a1,s1
    cf44:	08e12023          	sw	a4,128(sp)
    cf48:	0b412703          	lw	a4,180(sp)
    cf4c:	00040513          	mv	a0,s0
    cf50:	09612e23          	sw	s6,156(sp)
    cf54:	08e12223          	sw	a4,132(sp)
    cf58:	0b812703          	lw	a4,184(sp)
    cf5c:	09512823          	sw	s5,144(sp)
    cf60:	09412a23          	sw	s4,148(sp)
    cf64:	08e12423          	sw	a4,136(sp)
    cf68:	0bc12703          	lw	a4,188(sp)
    cf6c:	09212c23          	sw	s2,152(sp)
    cf70:	08e12623          	sw	a4,140(sp)
    cf74:	474060ef          	jal	ra,133e8 <__subtf3>
    cf78:	03412783          	lw	a5,52(sp)
    cf7c:	0a012903          	lw	s2,160(sp)
    cf80:	0a412f83          	lw	t6,164(sp)
    cf84:	01378733          	add	a4,a5,s3
    cf88:	01412783          	lw	a5,20(sp)
    cf8c:	00074703          	lbu	a4,0(a4) # 3ffc0000 <__freertos_irq_stack_top+0x3ffa82e0>
    cf90:	0a812f03          	lw	t5,168(sp)
    cf94:	0ac12603          	lw	a2,172(sp)
    cf98:	00178b13          	addi	s6,a5,1 # 40030001 <__freertos_irq_stack_top+0x400182e1>
    cf9c:	feeb0fa3          	sb	a4,-1(s6)
    cfa0:	05912823          	sw	s9,80(sp)
    cfa4:	fff00793          	li	a5,-1
    cfa8:	00090d13          	mv	s10,s2
    cfac:	000f8d93          	mv	s11,t6
    cfb0:	000f0a13          	mv	s4,t5
    cfb4:	00060a93          	mv	s5,a2
    cfb8:	ecfc9ae3          	bne	s9,a5,ce8c <_svfprintf_r+0x240c>
    cfbc:	07012303          	lw	t1,112(sp)
    cfc0:	05812583          	lw	a1,88(sp)
    cfc4:	00090293          	mv	t0,s2
    cfc8:	3ffe0db7          	lui	s11,0x3ffe0
    cfcc:	000c0513          	mv	a0,s8
    cfd0:	00612c23          	sw	t1,24(sp)
    cfd4:	06012483          	lw	s1,96(sp)
    cfd8:	0a512823          	sw	t0,176(sp)
    cfdc:	06512023          	sw	t0,96(sp)
    cfe0:	0bf12a23          	sw	t6,180(sp)
    cfe4:	05f12623          	sw	t6,76(sp)
    cfe8:	0be12c23          	sw	t5,184(sp)
    cfec:	03e12023          	sw	t5,32(sp)
    cff0:	0ac12e23          	sw	a2,188(sp)
    cff4:	00c12e23          	sw	a2,28(sp)
    cff8:	0a012023          	sw	zero,160(sp)
    cffc:	0a012223          	sw	zero,164(sp)
    d000:	0a012423          	sw	zero,168(sp)
    d004:	0bb12623          	sw	s11,172(sp)
    d008:	7a5040ef          	jal	ra,11fac <__getf2>
    d00c:	06412a83          	lw	s5,100(sp)
    d010:	06c12403          	lw	s0,108(sp)
    d014:	07412d03          	lw	s10,116(sp)
    d018:	07812a03          	lw	s4,120(sp)
    d01c:	07c12c83          	lw	s9,124(sp)
    d020:	06812903          	lw	s2,104(sp)
    d024:	01812303          	lw	t1,24(sp)
    d028:	0aa04e63          	bgtz	a0,d0e4 <_svfprintf_r+0x2664>
    d02c:	06012283          	lw	t0,96(sp)
    d030:	04c12f83          	lw	t6,76(sp)
    d034:	02012f03          	lw	t5,32(sp)
    d038:	01c12603          	lw	a2,28(sp)
    d03c:	05812583          	lw	a1,88(sp)
    d040:	000c0513          	mv	a0,s8
    d044:	0a512823          	sw	t0,176(sp)
    d048:	0bf12a23          	sw	t6,180(sp)
    d04c:	0be12c23          	sw	t5,184(sp)
    d050:	0ac12e23          	sw	a2,188(sp)
    d054:	0a012023          	sw	zero,160(sp)
    d058:	0a012223          	sw	zero,164(sp)
    d05c:	0a012423          	sw	zero,168(sp)
    d060:	0bb12623          	sw	s11,172(sp)
    d064:	679040ef          	jal	ra,11edc <__eqtf2>
    d068:	01812303          	lw	t1,24(sp)
    d06c:	00051663          	bnez	a0,d078 <_svfprintf_r+0x25f8>
    d070:	0019f993          	andi	s3,s3,1
    d074:	06099863          	bnez	s3,d0e4 <_svfprintf_r+0x2664>
    d078:	05012783          	lw	a5,80(sp)
    d07c:	03000693          	li	a3,48
    d080:	00178713          	addi	a4,a5,1
    d084:	00eb0733          	add	a4,s6,a4
    d088:	0007c863          	bltz	a5,d098 <_svfprintf_r+0x2618>
    d08c:	001b0b13          	addi	s6,s6,1
    d090:	fedb0fa3          	sb	a3,-1(s6)
    d094:	ff671ce3          	bne	a4,s6,d08c <_svfprintf_r+0x260c>
    d098:	419b07b3          	sub	a5,s6,s9
    d09c:	00f12c23          	sw	a5,24(sp)
    d0a0:	86cfe06f          	j	b10c <_svfprintf_r+0x68c>
    d0a4:	00012623          	sw	zero,12(sp)
    d0a8:	00070913          	mv	s2,a4
    d0ac:	80000737          	lui	a4,0x80000
    d0b0:	02d00793          	li	a5,45
    d0b4:	01674b33          	xor	s6,a4,s6
    d0b8:	04f12e23          	sw	a5,92(sp)
    d0bc:	c6dff06f          	j	cd28 <_svfprintf_r+0x22a8>
    d0c0:	00130593          	addi	a1,t1,1
    d0c4:	000a0513          	mv	a0,s4
    d0c8:	00612623          	sw	t1,12(sp)
    d0cc:	9c4fb0ef          	jal	ra,8290 <_malloc_r>
    d0d0:	00050c93          	mv	s9,a0
    d0d4:	00c12303          	lw	t1,12(sp)
    d0d8:	44050e63          	beqz	a0,d534 <_svfprintf_r+0x2ab4>
    d0dc:	00a12623          	sw	a0,12(sp)
    d0e0:	c25ff06f          	j	cd04 <_svfprintf_r+0x2284>
    d0e4:	01412783          	lw	a5,20(sp)
    d0e8:	000b0713          	mv	a4,s6
    d0ec:	0cf12e23          	sw	a5,220(sp)
    d0f0:	03412783          	lw	a5,52(sp)
    d0f4:	fffb4683          	lbu	a3,-1(s6)
    d0f8:	00f7c603          	lbu	a2,15(a5)
    d0fc:	02d61063          	bne	a2,a3,d11c <_svfprintf_r+0x269c>
    d100:	03000593          	li	a1,48
    d104:	feb70fa3          	sb	a1,-1(a4) # 7fffffff <__freertos_irq_stack_top+0x7ffe82df>
    d108:	0dc12703          	lw	a4,220(sp)
    d10c:	fff70793          	addi	a5,a4,-1
    d110:	0cf12e23          	sw	a5,220(sp)
    d114:	fff74683          	lbu	a3,-1(a4)
    d118:	fed606e3          	beq	a2,a3,d104 <_svfprintf_r+0x2684>
    d11c:	00168613          	addi	a2,a3,1
    d120:	03900593          	li	a1,57
    d124:	0ff67613          	andi	a2,a2,255
    d128:	00b68663          	beq	a3,a1,d134 <_svfprintf_r+0x26b4>
    d12c:	fec70fa3          	sb	a2,-1(a4)
    d130:	f69ff06f          	j	d098 <_svfprintf_r+0x2618>
    d134:	03412783          	lw	a5,52(sp)
    d138:	00a7c603          	lbu	a2,10(a5)
    d13c:	fec70fa3          	sb	a2,-1(a4)
    d140:	f59ff06f          	j	d098 <_svfprintf_r+0x2618>
    d144:	03000793          	li	a5,48
    d148:	0cf10423          	sb	a5,200(sp)
    d14c:	07800793          	li	a5,120
    d150:	b99ff06f          	j	cce8 <_svfprintf_r+0x2268>
    d154:	00130993          	addi	s3,t1,1
    d158:	0b010c13          	addi	s8,sp,176
    d15c:	0dc10813          	addi	a6,sp,220
    d160:	0d010793          	addi	a5,sp,208
    d164:	0cc10713          	addi	a4,sp,204
    d168:	00098693          	mv	a3,s3
    d16c:	00200613          	li	a2,2
    d170:	000c0593          	mv	a1,s8
    d174:	000a0513          	mv	a0,s4
    d178:	00612e23          	sw	t1,28(sp)
    d17c:	0be12823          	sw	t5,176(sp)
    d180:	01e12c23          	sw	t5,24(sp)
    d184:	0bd12c23          	sw	t4,184(sp)
    d188:	01d12a23          	sw	t4,20(sp)
    d18c:	0bb12a23          	sw	s11,180(sp)
    d190:	0b612e23          	sw	s6,188(sp)
    d194:	af9f90ef          	jal	ra,6c8c <_ldtoa_r>
    d198:	01412e83          	lw	t4,20(sp)
    d19c:	01812f03          	lw	t5,24(sp)
    d1a0:	01c12303          	lw	t1,28(sp)
    d1a4:	00050c93          	mv	s9,a0
    d1a8:	0a010793          	addi	a5,sp,160
    d1ac:	013c89b3          	add	s3,s9,s3
    d1b0:	04f12c23          	sw	a5,88(sp)
    d1b4:	9e5ff06f          	j	cb98 <_svfprintf_r+0x2118>
    d1b8:	01670733          	add	a4,a4,s6
    d1bc:	00168693          	addi	a3,a3,1
    d1c0:	00009797          	auipc	a5,0x9
    d1c4:	b7478793          	addi	a5,a5,-1164 # 15d34 <zeroes.4490>
    d1c8:	00f8a023          	sw	a5,0(a7)
    d1cc:	0168a223          	sw	s6,4(a7)
    d1d0:	0ee12623          	sw	a4,236(sp)
    d1d4:	0ed12423          	sw	a3,232(sp)
    d1d8:	00700613          	li	a2,7
    d1dc:	00888893          	addi	a7,a7,8
    d1e0:	b0d65a63          	bge	a2,a3,c4f4 <_svfprintf_r+0x1a74>
    d1e4:	00812583          	lw	a1,8(sp)
    d1e8:	0e410613          	addi	a2,sp,228
    d1ec:	000a0513          	mv	a0,s4
    d1f0:	76d010ef          	jal	ra,f15c <__ssprint_r>
    d1f4:	00050463          	beqz	a0,d1fc <_svfprintf_r+0x277c>
    d1f8:	aa5fd06f          	j	ac9c <_svfprintf_r+0x21c>
    d1fc:	0ec12703          	lw	a4,236(sp)
    d200:	0e812683          	lw	a3,232(sp)
    d204:	10c10893          	addi	a7,sp,268
    d208:	aecff06f          	j	c4f4 <_svfprintf_r+0x1a74>
    d20c:	0a010793          	addi	a5,sp,160
    d210:	006c89b3          	add	s3,s9,t1
    d214:	04f12c23          	sw	a5,88(sp)
    d218:	981ff06f          	j	cb98 <_svfprintf_r+0x2118>
    d21c:	00030463          	beqz	t1,d224 <_svfprintf_r+0x27a4>
    d220:	e29fd06f          	j	b048 <_svfprintf_r+0x5c8>
    d224:	00100313          	li	t1,1
    d228:	e21fd06f          	j	b048 <_svfprintf_r+0x5c8>
    d22c:	fff00793          	li	a5,-1
    d230:	00f12223          	sw	a5,4(sp)
    d234:	a91fd06f          	j	acc4 <_svfprintf_r+0x244>
    d238:	06700a93          	li	s5,103
    d23c:	03c12583          	lw	a1,60(sp)
    d240:	01412783          	lw	a5,20(sp)
    d244:	02012023          	sw	zero,32(sp)
    d248:	0005c703          	lbu	a4,0(a1)
    d24c:	00012e23          	sw	zero,28(sp)
    d250:	0ff00613          	li	a2,255
    d254:	02c70e63          	beq	a4,a2,d290 <_svfprintf_r+0x2810>
    d258:	02f75c63          	bge	a4,a5,d290 <_svfprintf_r+0x2810>
    d25c:	0015c683          	lbu	a3,1(a1)
    d260:	40e787b3          	sub	a5,a5,a4
    d264:	00068e63          	beqz	a3,d280 <_svfprintf_r+0x2800>
    d268:	01c12703          	lw	a4,28(sp)
    d26c:	00158593          	addi	a1,a1,1
    d270:	00170713          	addi	a4,a4,1
    d274:	00e12e23          	sw	a4,28(sp)
    d278:	00068713          	mv	a4,a3
    d27c:	fd9ff06f          	j	d254 <_svfprintf_r+0x27d4>
    d280:	02012683          	lw	a3,32(sp)
    d284:	00168693          	addi	a3,a3,1
    d288:	02d12023          	sw	a3,32(sp)
    d28c:	fc9ff06f          	j	d254 <_svfprintf_r+0x27d4>
    d290:	00f12a23          	sw	a5,20(sp)
    d294:	02012703          	lw	a4,32(sp)
    d298:	01c12783          	lw	a5,28(sp)
    d29c:	02b12e23          	sw	a1,60(sp)
    d2a0:	00e78733          	add	a4,a5,a4
    d2a4:	04012783          	lw	a5,64(sp)
    d2a8:	02f70733          	mul	a4,a4,a5
    d2ac:	01670b33          	add	s6,a4,s6
    d2b0:	fffb4993          	not	s3,s6
    d2b4:	41f9d993          	srai	s3,s3,0x1f
    d2b8:	013b79b3          	and	s3,s6,s3
    d2bc:	f99fd06f          	j	b254 <_svfprintf_r+0x7d4>
    d2c0:	0b010c13          	addi	s8,sp,176
    d2c4:	000c0513          	mv	a0,s8
    d2c8:	02612a23          	sw	t1,52(sp)
    d2cc:	0be12823          	sw	t5,176(sp)
    d2d0:	0bd12c23          	sw	t4,184(sp)
    d2d4:	0b612e23          	sw	s6,188(sp)
    d2d8:	0bb12a23          	sw	s11,180(sp)
    d2dc:	3e9070ef          	jal	ra,14ec4 <__trunctfdf2>
    d2e0:	0cc10613          	addi	a2,sp,204
    d2e4:	a60fd0ef          	jal	ra,a544 <frexp>
    d2e8:	00058613          	mv	a2,a1
    d2ec:	00050593          	mv	a1,a0
    d2f0:	000c0513          	mv	a0,s8
    d2f4:	165070ef          	jal	ra,14c58 <__extenddftf2>
    d2f8:	0b012703          	lw	a4,176(sp)
    d2fc:	09010793          	addi	a5,sp,144
    d300:	0a010993          	addi	s3,sp,160
    d304:	08e12823          	sw	a4,144(sp)
    d308:	0b412703          	lw	a4,180(sp)
    d30c:	08010613          	addi	a2,sp,128
    d310:	00078593          	mv	a1,a5
    d314:	08e12a23          	sw	a4,148(sp)
    d318:	0b812703          	lw	a4,184(sp)
    d31c:	00098513          	mv	a0,s3
    d320:	00078b13          	mv	s6,a5
    d324:	08e12c23          	sw	a4,152(sp)
    d328:	0bc12703          	lw	a4,188(sp)
    d32c:	04c12623          	sw	a2,76(sp)
    d330:	05312c23          	sw	s3,88(sp)
    d334:	08e12e23          	sw	a4,156(sp)
    d338:	3ffc0737          	lui	a4,0x3ffc0
    d33c:	08e12623          	sw	a4,140(sp)
    d340:	08012023          	sw	zero,128(sp)
    d344:	08012223          	sw	zero,132(sp)
    d348:	08012423          	sw	zero,136(sp)
    d34c:	745040ef          	jal	ra,12290 <__multf3>
    d350:	0a012703          	lw	a4,160(sp)
    d354:	0a412683          	lw	a3,164(sp)
    d358:	0a812803          	lw	a6,168(sp)
    d35c:	0ac12e83          	lw	t4,172(sp)
    d360:	00098593          	mv	a1,s3
    d364:	000c0513          	mv	a0,s8
    d368:	0ae12823          	sw	a4,176(sp)
    d36c:	02e12023          	sw	a4,32(sp)
    d370:	0ad12a23          	sw	a3,180(sp)
    d374:	00d12e23          	sw	a3,28(sp)
    d378:	0b012c23          	sw	a6,184(sp)
    d37c:	01012c23          	sw	a6,24(sp)
    d380:	0bd12e23          	sw	t4,188(sp)
    d384:	01d12a23          	sw	t4,20(sp)
    d388:	0a012023          	sw	zero,160(sp)
    d38c:	0a012223          	sw	zero,164(sp)
    d390:	0a012423          	sw	zero,168(sp)
    d394:	0a012623          	sw	zero,172(sp)
    d398:	345040ef          	jal	ra,11edc <__eqtf2>
    d39c:	01412e83          	lw	t4,20(sp)
    d3a0:	01812803          	lw	a6,24(sp)
    d3a4:	01c12683          	lw	a3,28(sp)
    d3a8:	02012703          	lw	a4,32(sp)
    d3ac:	03412303          	lw	t1,52(sp)
    d3b0:	00051663          	bnez	a0,d3bc <_svfprintf_r+0x293c>
    d3b4:	00100613          	li	a2,1
    d3b8:	0cc12623          	sw	a2,204(sp)
    d3bc:	00008797          	auipc	a5,0x8
    d3c0:	3dc78793          	addi	a5,a5,988 # 15798 <_data+0x480>
    d3c4:	02f12a23          	sw	a5,52(sp)
    d3c8:	a7dff06f          	j	ce44 <_svfprintf_r+0x23c4>
    d3cc:	0d610693          	addi	a3,sp,214
    d3d0:	00061863          	bnez	a2,d3e0 <_svfprintf_r+0x2960>
    d3d4:	03000693          	li	a3,48
    d3d8:	0cd10b23          	sb	a3,214(sp)
    d3dc:	0d710693          	addi	a3,sp,215
    d3e0:	1b010793          	addi	a5,sp,432
    d3e4:	40f68633          	sub	a2,a3,a5
    d3e8:	03070713          	addi	a4,a4,48 # 3ffc0030 <__freertos_irq_stack_top+0x3ffa8310>
    d3ec:	0dd60793          	addi	a5,a2,221
    d3f0:	00e68023          	sb	a4,0(a3)
    d3f4:	02f12c23          	sw	a5,56(sp)
    d3f8:	e19fd06f          	j	b210 <_svfprintf_r+0x790>
    d3fc:	02812703          	lw	a4,40(sp)
    d400:	06600a93          	li	s5,102
    d404:	00e78b33          	add	s6,a5,a4
    d408:	006b0b33          	add	s6,s6,t1
    d40c:	891ff06f          	j	cc9c <_svfprintf_r+0x221c>
    d410:	40fb0b33          	sub	s6,s6,a5
    d414:	001b0b13          	addi	s6,s6,1
    d418:	fffb4993          	not	s3,s6
    d41c:	41f9d993          	srai	s3,s3,0x1f
    d420:	013b79b3          	and	s3,s6,s3
    d424:	e5cff06f          	j	ca80 <_svfprintf_r+0x2000>
    d428:	0a010593          	addi	a1,sp,160
    d42c:	000c0513          	mv	a0,s8
    d430:	00612e23          	sw	t1,28(sp)
    d434:	0be12823          	sw	t5,176(sp)
    d438:	01e12c23          	sw	t5,24(sp)
    d43c:	0bd12c23          	sw	t4,184(sp)
    d440:	01d12a23          	sw	t4,20(sp)
    d444:	04b12c23          	sw	a1,88(sp)
    d448:	0bb12a23          	sw	s11,180(sp)
    d44c:	0b612e23          	sw	s6,188(sp)
    d450:	0a012023          	sw	zero,160(sp)
    d454:	0a012223          	sw	zero,164(sp)
    d458:	0a012423          	sw	zero,168(sp)
    d45c:	0a012623          	sw	zero,172(sp)
    d460:	27d040ef          	jal	ra,11edc <__eqtf2>
    d464:	01412e83          	lw	t4,20(sp)
    d468:	01812f03          	lw	t5,24(sp)
    d46c:	01c12303          	lw	t1,28(sp)
    d470:	f0050e63          	beqz	a0,cb8c <_svfprintf_r+0x210c>
    d474:	00100713          	li	a4,1
    d478:	40670733          	sub	a4,a4,t1
    d47c:	0ce12623          	sw	a4,204(sp)
    d480:	f10ff06f          	j	cb90 <_svfprintf_r+0x2110>
    d484:	05412783          	lw	a5,84(sp)
    d488:	0017f713          	andi	a4,a5,1
    d48c:	00071463          	bnez	a4,d494 <_svfprintf_r+0x2a14>
    d490:	da1fd06f          	j	b230 <_svfprintf_r+0x7b0>
    d494:	d95fd06f          	j	b228 <_svfprintf_r+0x7a8>
    d498:	000d0793          	mv	a5,s10
    d49c:	b3cff06f          	j	c7d8 <_svfprintf_r+0x1d58>
    d4a0:	00071a63          	bnez	a4,d4b4 <_svfprintf_r+0x2a34>
    d4a4:	00100993          	li	s3,1
    d4a8:	06600a93          	li	s5,102
    d4ac:	00100b13          	li	s6,1
    d4b0:	dd0ff06f          	j	ca80 <_svfprintf_r+0x2000>
    d4b4:	02812783          	lw	a5,40(sp)
    d4b8:	06600a93          	li	s5,102
    d4bc:	00178b13          	addi	s6,a5,1
    d4c0:	006b0b33          	add	s6,s6,t1
    d4c4:	fffb4993          	not	s3,s6
    d4c8:	41f9d993          	srai	s3,s3,0x1f
    d4cc:	013b79b3          	and	s3,s6,s3
    d4d0:	db0ff06f          	j	ca80 <_svfprintf_r+0x2000>
    d4d4:	01012703          	lw	a4,16(sp)
    d4d8:	00072c03          	lw	s8,0(a4)
    d4dc:	00470713          	addi	a4,a4,4
    d4e0:	000c5463          	bgez	s8,d4e8 <_svfprintf_r+0x2a68>
    d4e4:	fff00c13          	li	s8,-1
    d4e8:	0014ce03          	lbu	t3,1(s1)
    d4ec:	00e12823          	sw	a4,16(sp)
    d4f0:	00078493          	mv	s1,a5
    d4f4:	ef0fd06f          	j	abe4 <_svfprintf_r+0x164>
    d4f8:	00090993          	mv	s3,s2
    d4fc:	e79fd06f          	j	b374 <_svfprintf_r+0x8f4>
    d500:	00030993          	mv	s3,t1
    d504:	ca5ff06f          	j	d1a8 <_svfprintf_r+0x2728>
    d508:	00200793          	li	a5,2
    d50c:	02f12c23          	sw	a5,56(sp)
    d510:	d01fd06f          	j	b210 <_svfprintf_r+0x790>
    d514:	02412703          	lw	a4,36(sp)
    d518:	00c00793          	li	a5,12
    d51c:	00f72023          	sw	a5,0(a4)
    d520:	fff00793          	li	a5,-1
    d524:	00f12223          	sw	a5,4(sp)
    d528:	f9cfd06f          	j	acc4 <_svfprintf_r+0x244>
    d52c:	00090993          	mv	s3,s2
    d530:	d5dfd06f          	j	b28c <_svfprintf_r+0x80c>
    d534:	00812683          	lw	a3,8(sp)
    d538:	00c6d783          	lhu	a5,12(a3)
    d53c:	0407e713          	ori	a4,a5,64
    d540:	00070793          	mv	a5,a4
    d544:	00e69623          	sh	a4,12(a3)
    d548:	f70fd06f          	j	acb8 <_svfprintf_r+0x238>

0000d54c <__sprint_r.part.0>:
    d54c:	0645a783          	lw	a5,100(a1)
    d550:	fd010113          	addi	sp,sp,-48
    d554:	01612823          	sw	s6,16(sp)
    d558:	02112623          	sw	ra,44(sp)
    d55c:	02812423          	sw	s0,40(sp)
    d560:	02912223          	sw	s1,36(sp)
    d564:	03212023          	sw	s2,32(sp)
    d568:	01312e23          	sw	s3,28(sp)
    d56c:	01412c23          	sw	s4,24(sp)
    d570:	01512a23          	sw	s5,20(sp)
    d574:	01712623          	sw	s7,12(sp)
    d578:	01812423          	sw	s8,8(sp)
    d57c:	01279713          	slli	a4,a5,0x12
    d580:	00060b13          	mv	s6,a2
    d584:	0a075863          	bgez	a4,d634 <__sprint_r.part.0+0xe8>
    d588:	00862783          	lw	a5,8(a2)
    d58c:	00058913          	mv	s2,a1
    d590:	00050a13          	mv	s4,a0
    d594:	00062b83          	lw	s7,0(a2)
    d598:	fff00a93          	li	s5,-1
    d59c:	08078863          	beqz	a5,d62c <__sprint_r.part.0+0xe0>
    d5a0:	004bac03          	lw	s8,4(s7)
    d5a4:	000ba403          	lw	s0,0(s7)
    d5a8:	002c5993          	srli	s3,s8,0x2
    d5ac:	06098663          	beqz	s3,d618 <__sprint_r.part.0+0xcc>
    d5b0:	00000493          	li	s1,0
    d5b4:	00c0006f          	j	d5c0 <__sprint_r.part.0+0x74>
    d5b8:	00440413          	addi	s0,s0,4
    d5bc:	04998c63          	beq	s3,s1,d614 <__sprint_r.part.0+0xc8>
    d5c0:	00042583          	lw	a1,0(s0)
    d5c4:	00090613          	mv	a2,s2
    d5c8:	000a0513          	mv	a0,s4
    d5cc:	021010ef          	jal	ra,edec <_fputwc_r>
    d5d0:	00148493          	addi	s1,s1,1
    d5d4:	ff5512e3          	bne	a0,s5,d5b8 <__sprint_r.part.0+0x6c>
    d5d8:	fff00513          	li	a0,-1
    d5dc:	02c12083          	lw	ra,44(sp)
    d5e0:	02812403          	lw	s0,40(sp)
    d5e4:	000b2423          	sw	zero,8(s6)
    d5e8:	000b2223          	sw	zero,4(s6)
    d5ec:	02412483          	lw	s1,36(sp)
    d5f0:	02012903          	lw	s2,32(sp)
    d5f4:	01c12983          	lw	s3,28(sp)
    d5f8:	01812a03          	lw	s4,24(sp)
    d5fc:	01412a83          	lw	s5,20(sp)
    d600:	01012b03          	lw	s6,16(sp)
    d604:	00c12b83          	lw	s7,12(sp)
    d608:	00812c03          	lw	s8,8(sp)
    d60c:	03010113          	addi	sp,sp,48
    d610:	00008067          	ret
    d614:	008b2783          	lw	a5,8(s6)
    d618:	ffcc7c13          	andi	s8,s8,-4
    d61c:	418787b3          	sub	a5,a5,s8
    d620:	00fb2423          	sw	a5,8(s6)
    d624:	008b8b93          	addi	s7,s7,8
    d628:	f6079ce3          	bnez	a5,d5a0 <__sprint_r.part.0+0x54>
    d62c:	00000513          	li	a0,0
    d630:	fadff06f          	j	d5dc <__sprint_r.part.0+0x90>
    d634:	869f70ef          	jal	ra,4e9c <__sfvwrite_r>
    d638:	fa5ff06f          	j	d5dc <__sprint_r.part.0+0x90>

0000d63c <__sprint_r>:
    d63c:	00862703          	lw	a4,8(a2)
    d640:	00070463          	beqz	a4,d648 <__sprint_r+0xc>
    d644:	f09ff06f          	j	d54c <__sprint_r.part.0>
    d648:	00062223          	sw	zero,4(a2)
    d64c:	00000513          	li	a0,0
    d650:	00008067          	ret

0000d654 <_vfiprintf_r>:
    d654:	ed010113          	addi	sp,sp,-304
    d658:	13212023          	sw	s2,288(sp)
    d65c:	11312e23          	sw	s3,284(sp)
    d660:	11812423          	sw	s8,264(sp)
    d664:	12112623          	sw	ra,300(sp)
    d668:	12812423          	sw	s0,296(sp)
    d66c:	12912223          	sw	s1,292(sp)
    d670:	11412c23          	sw	s4,280(sp)
    d674:	11512a23          	sw	s5,276(sp)
    d678:	11612823          	sw	s6,272(sp)
    d67c:	11712623          	sw	s7,268(sp)
    d680:	11912223          	sw	s9,260(sp)
    d684:	11a12023          	sw	s10,256(sp)
    d688:	0fb12e23          	sw	s11,252(sp)
    d68c:	00d12623          	sw	a3,12(sp)
    d690:	00050993          	mv	s3,a0
    d694:	00058913          	mv	s2,a1
    d698:	00060c13          	mv	s8,a2
    d69c:	00050663          	beqz	a0,d6a8 <_vfiprintf_r+0x54>
    d6a0:	03852783          	lw	a5,56(a0)
    d6a4:	180782e3          	beqz	a5,e028 <_vfiprintf_r+0x9d4>
    d6a8:	00c91703          	lh	a4,12(s2)
    d6ac:	01071793          	slli	a5,a4,0x10
    d6b0:	0107d793          	srli	a5,a5,0x10
    d6b4:	01279693          	slli	a3,a5,0x12
    d6b8:	0206c663          	bltz	a3,d6e4 <_vfiprintf_r+0x90>
    d6bc:	06492683          	lw	a3,100(s2)
    d6c0:	000027b7          	lui	a5,0x2
    d6c4:	00f767b3          	or	a5,a4,a5
    d6c8:	ffffe737          	lui	a4,0xffffe
    d6cc:	fff70713          	addi	a4,a4,-1 # ffffdfff <__freertos_irq_stack_top+0xfffe62df>
    d6d0:	00e6f733          	and	a4,a3,a4
    d6d4:	00f91623          	sh	a5,12(s2)
    d6d8:	01079793          	slli	a5,a5,0x10
    d6dc:	06e92223          	sw	a4,100(s2)
    d6e0:	0107d793          	srli	a5,a5,0x10
    d6e4:	0087f713          	andi	a4,a5,8
    d6e8:	16070863          	beqz	a4,d858 <_vfiprintf_r+0x204>
    d6ec:	01092703          	lw	a4,16(s2)
    d6f0:	16070463          	beqz	a4,d858 <_vfiprintf_r+0x204>
    d6f4:	01a7f793          	andi	a5,a5,26
    d6f8:	00a00713          	li	a4,10
    d6fc:	18e78063          	beq	a5,a4,d87c <_vfiprintf_r+0x228>
    d700:	ffff87b7          	lui	a5,0xffff8
    d704:	04c10493          	addi	s1,sp,76
    d708:	8307c793          	xori	a5,a5,-2000
    d70c:	04912023          	sw	s1,64(sp)
    d710:	04012423          	sw	zero,72(sp)
    d714:	04012223          	sw	zero,68(sp)
    d718:	00012823          	sw	zero,16(sp)
    d71c:	00012c23          	sw	zero,24(sp)
    d720:	02012023          	sw	zero,32(sp)
    d724:	00012e23          	sw	zero,28(sp)
    d728:	00012423          	sw	zero,8(sp)
    d72c:	00008a97          	auipc	s5,0x8
    d730:	618a8a93          	addi	s5,s5,1560 # 15d44 <zeroes.4490+0x10>
    d734:	02f12223          	sw	a5,36(sp)
    d738:	00048413          	mv	s0,s1
    d73c:	000c0c93          	mv	s9,s8
    d740:	000cc783          	lbu	a5,0(s9)
    d744:	16078463          	beqz	a5,d8ac <_vfiprintf_r+0x258>
    d748:	02500713          	li	a4,37
    d74c:	5ce784e3          	beq	a5,a4,e514 <_vfiprintf_r+0xec0>
    d750:	000c8a13          	mv	s4,s9
    d754:	00c0006f          	j	d760 <_vfiprintf_r+0x10c>
    d758:	14e78463          	beq	a5,a4,d8a0 <_vfiprintf_r+0x24c>
    d75c:	000d0a13          	mv	s4,s10
    d760:	001a4783          	lbu	a5,1(s4)
    d764:	001a0d13          	addi	s10,s4,1
    d768:	fe0798e3          	bnez	a5,d758 <_vfiprintf_r+0x104>
    d76c:	419d0c33          	sub	s8,s10,s9
    d770:	120c0e63          	beqz	s8,d8ac <_vfiprintf_r+0x258>
    d774:	04812703          	lw	a4,72(sp)
    d778:	04412783          	lw	a5,68(sp)
    d77c:	01942023          	sw	s9,0(s0)
    d780:	00ec0733          	add	a4,s8,a4
    d784:	00178793          	addi	a5,a5,1 # ffff8001 <__freertos_irq_stack_top+0xfffe02e1>
    d788:	01842223          	sw	s8,4(s0)
    d78c:	04e12423          	sw	a4,72(sp)
    d790:	04f12223          	sw	a5,68(sp)
    d794:	00700693          	li	a3,7
    d798:	00840413          	addi	s0,s0,8
    d79c:	02f6d063          	bge	a3,a5,d7bc <_vfiprintf_r+0x168>
    d7a0:	520706e3          	beqz	a4,e4cc <_vfiprintf_r+0xe78>
    d7a4:	04010613          	addi	a2,sp,64
    d7a8:	00090593          	mv	a1,s2
    d7ac:	00098513          	mv	a0,s3
    d7b0:	d9dff0ef          	jal	ra,d54c <__sprint_r.part.0>
    d7b4:	10051863          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    d7b8:	00048413          	mv	s0,s1
    d7bc:	00812703          	lw	a4,8(sp)
    d7c0:	001a4783          	lbu	a5,1(s4)
    d7c4:	01870733          	add	a4,a4,s8
    d7c8:	00e12423          	sw	a4,8(sp)
    d7cc:	0e078063          	beqz	a5,d8ac <_vfiprintf_r+0x258>
    d7d0:	001d0c93          	addi	s9,s10,1
    d7d4:	001d4703          	lbu	a4,1(s10)
    d7d8:	02010da3          	sb	zero,59(sp)
    d7dc:	fff00c13          	li	s8,-1
    d7e0:	00000a13          	li	s4,0
    d7e4:	00000b93          	li	s7,0
    d7e8:	02a00d13          	li	s10,42
    d7ec:	001c8c93          	addi	s9,s9,1
    d7f0:	05a00693          	li	a3,90
    d7f4:	fe070793          	addi	a5,a4,-32
    d7f8:	1ef6e063          	bltu	a3,a5,d9d8 <_vfiprintf_r+0x384>
    d7fc:	00279793          	slli	a5,a5,0x2
    d800:	015787b3          	add	a5,a5,s5
    d804:	0007a783          	lw	a5,0(a5)
    d808:	015787b3          	add	a5,a5,s5
    d80c:	00078067          	jr	a5
    d810:	00098513          	mv	a0,s3
    d814:	fd8fa0ef          	jal	ra,7fec <_localeconv_r>
    d818:	00452783          	lw	a5,4(a0)
    d81c:	00078513          	mv	a0,a5
    d820:	00f12e23          	sw	a5,28(sp)
    d824:	c55f30ef          	jal	ra,1478 <strlen>
    d828:	02a12023          	sw	a0,32(sp)
    d82c:	00050b13          	mv	s6,a0
    d830:	00098513          	mv	a0,s3
    d834:	fb8fa0ef          	jal	ra,7fec <_localeconv_r>
    d838:	00852783          	lw	a5,8(a0)
    d83c:	00f12c23          	sw	a5,24(sp)
    d840:	560b14e3          	bnez	s6,e5a8 <_vfiprintf_r+0xf54>
    d844:	000cc703          	lbu	a4,0(s9)
    d848:	fa5ff06f          	j	d7ec <_vfiprintf_r+0x198>
    d84c:	020beb93          	ori	s7,s7,32
    d850:	000cc703          	lbu	a4,0(s9)
    d854:	f99ff06f          	j	d7ec <_vfiprintf_r+0x198>
    d858:	00090593          	mv	a1,s2
    d85c:	00098513          	mv	a0,s3
    d860:	a35f60ef          	jal	ra,4294 <__swsetup_r>
    d864:	00050463          	beqz	a0,d86c <_vfiprintf_r+0x218>
    d868:	0600106f          	j	e8c8 <_vfiprintf_r+0x1274>
    d86c:	00c95783          	lhu	a5,12(s2)
    d870:	00a00713          	li	a4,10
    d874:	01a7f793          	andi	a5,a5,26
    d878:	e8e794e3          	bne	a5,a4,d700 <_vfiprintf_r+0xac>
    d87c:	00e91783          	lh	a5,14(s2)
    d880:	e807c0e3          	bltz	a5,d700 <_vfiprintf_r+0xac>
    d884:	00c12683          	lw	a3,12(sp)
    d888:	000c0613          	mv	a2,s8
    d88c:	00090593          	mv	a1,s2
    d890:	00098513          	mv	a0,s3
    d894:	0a8010ef          	jal	ra,e93c <__sbprintf>
    d898:	00a12423          	sw	a0,8(sp)
    d89c:	0380006f          	j	d8d4 <_vfiprintf_r+0x280>
    d8a0:	419d0c33          	sub	s8,s10,s9
    d8a4:	f20c06e3          	beqz	s8,d7d0 <_vfiprintf_r+0x17c>
    d8a8:	ecdff06f          	j	d774 <_vfiprintf_r+0x120>
    d8ac:	04812783          	lw	a5,72(sp)
    d8b0:	00078a63          	beqz	a5,d8c4 <_vfiprintf_r+0x270>
    d8b4:	04010613          	addi	a2,sp,64
    d8b8:	00090593          	mv	a1,s2
    d8bc:	00098513          	mv	a0,s3
    d8c0:	c8dff0ef          	jal	ra,d54c <__sprint_r.part.0>
    d8c4:	00c95783          	lhu	a5,12(s2)
    d8c8:	0407f793          	andi	a5,a5,64
    d8cc:	00078463          	beqz	a5,d8d4 <_vfiprintf_r+0x280>
    d8d0:	7f90006f          	j	e8c8 <_vfiprintf_r+0x1274>
    d8d4:	12c12083          	lw	ra,300(sp)
    d8d8:	12812403          	lw	s0,296(sp)
    d8dc:	00812503          	lw	a0,8(sp)
    d8e0:	12412483          	lw	s1,292(sp)
    d8e4:	12012903          	lw	s2,288(sp)
    d8e8:	11c12983          	lw	s3,284(sp)
    d8ec:	11812a03          	lw	s4,280(sp)
    d8f0:	11412a83          	lw	s5,276(sp)
    d8f4:	11012b03          	lw	s6,272(sp)
    d8f8:	10c12b83          	lw	s7,268(sp)
    d8fc:	10812c03          	lw	s8,264(sp)
    d900:	10412c83          	lw	s9,260(sp)
    d904:	10012d03          	lw	s10,256(sp)
    d908:	0fc12d83          	lw	s11,252(sp)
    d90c:	13010113          	addi	sp,sp,304
    d910:	00008067          	ret
    d914:	00008797          	auipc	a5,0x8
    d918:	e9878793          	addi	a5,a5,-360 # 157ac <_data+0x494>
    d91c:	00f12823          	sw	a5,16(sp)
    d920:	020bf793          	andi	a5,s7,32
    d924:	52078463          	beqz	a5,de4c <_vfiprintf_r+0x7f8>
    d928:	00c12783          	lw	a5,12(sp)
    d92c:	00778693          	addi	a3,a5,7
    d930:	ff86f693          	andi	a3,a3,-8
    d934:	0006ad83          	lw	s11,0(a3)
    d938:	0046ae03          	lw	t3,4(a3)
    d93c:	00868793          	addi	a5,a3,8
    d940:	00f12623          	sw	a5,12(sp)
    d944:	001bf693          	andi	a3,s7,1
    d948:	00068663          	beqz	a3,d954 <_vfiprintf_r+0x300>
    d94c:	01cde6b3          	or	a3,s11,t3
    d950:	42069ee3          	bnez	a3,e58c <_vfiprintf_r+0xf38>
    d954:	bffbfd13          	andi	s10,s7,-1025
    d958:	00200713          	li	a4,2
    d95c:	02010da3          	sb	zero,59(sp)
    d960:	fff00693          	li	a3,-1
    d964:	64dc0a63          	beq	s8,a3,dfb8 <_vfiprintf_r+0x964>
    d968:	01cde6b3          	or	a3,s11,t3
    d96c:	f7fd7b93          	andi	s7,s10,-129
    d970:	20069ee3          	bnez	a3,e38c <_vfiprintf_r+0xd38>
    d974:	720c1c63          	bnez	s8,e0ac <_vfiprintf_r+0xa58>
    d978:	360712e3          	bnez	a4,e4dc <_vfiprintf_r+0xe88>
    d97c:	001d7d93          	andi	s11,s10,1
    d980:	0f010b13          	addi	s6,sp,240
    d984:	3a0d96e3          	bnez	s11,e530 <_vfiprintf_r+0xedc>
    d988:	000c0d13          	mv	s10,s8
    d98c:	01bc5463          	bge	s8,s11,d994 <_vfiprintf_r+0x340>
    d990:	000d8d13          	mv	s10,s11
    d994:	03b14783          	lbu	a5,59(sp)
    d998:	00f037b3          	snez	a5,a5
    d99c:	00fd0d33          	add	s10,s10,a5
    d9a0:	0540006f          	j	d9f4 <_vfiprintf_r+0x3a0>
    d9a4:	00000a13          	li	s4,0
    d9a8:	fd070613          	addi	a2,a4,-48
    d9ac:	001c8c93          	addi	s9,s9,1
    d9b0:	002a1793          	slli	a5,s4,0x2
    d9b4:	fffcc703          	lbu	a4,-1(s9)
    d9b8:	01478a33          	add	s4,a5,s4
    d9bc:	001a1a13          	slli	s4,s4,0x1
    d9c0:	01460a33          	add	s4,a2,s4
    d9c4:	00900793          	li	a5,9
    d9c8:	fd070613          	addi	a2,a4,-48
    d9cc:	fec7f0e3          	bgeu	a5,a2,d9ac <_vfiprintf_r+0x358>
    d9d0:	fe070793          	addi	a5,a4,-32
    d9d4:	e2f6f4e3          	bgeu	a3,a5,d7fc <_vfiprintf_r+0x1a8>
    d9d8:	ec070ae3          	beqz	a4,d8ac <_vfiprintf_r+0x258>
    d9dc:	08e10623          	sb	a4,140(sp)
    d9e0:	02010da3          	sb	zero,59(sp)
    d9e4:	00100d13          	li	s10,1
    d9e8:	00100d93          	li	s11,1
    d9ec:	08c10b13          	addi	s6,sp,140
    d9f0:	00000c13          	li	s8,0
    d9f4:	002bff93          	andi	t6,s7,2
    d9f8:	000f8463          	beqz	t6,da00 <_vfiprintf_r+0x3ac>
    d9fc:	002d0d13          	addi	s10,s10,2
    da00:	04412703          	lw	a4,68(sp)
    da04:	084bf813          	andi	a6,s7,132
    da08:	04812783          	lw	a5,72(sp)
    da0c:	00170693          	addi	a3,a4,1
    da10:	00068613          	mv	a2,a3
    da14:	00081663          	bnez	a6,da20 <_vfiprintf_r+0x3cc>
    da18:	41aa0e33          	sub	t3,s4,s10
    da1c:	17c04ce3          	bgtz	t3,e394 <_vfiprintf_r+0xd40>
    da20:	03b14583          	lbu	a1,59(sp)
    da24:	00840693          	addi	a3,s0,8
    da28:	02058c63          	beqz	a1,da60 <_vfiprintf_r+0x40c>
    da2c:	03b10713          	addi	a4,sp,59
    da30:	00178793          	addi	a5,a5,1
    da34:	00e42023          	sw	a4,0(s0)
    da38:	00100713          	li	a4,1
    da3c:	00e42223          	sw	a4,4(s0)
    da40:	04f12423          	sw	a5,72(sp)
    da44:	04c12223          	sw	a2,68(sp)
    da48:	00700713          	li	a4,7
    da4c:	10c740e3          	blt	a4,a2,e34c <_vfiprintf_r+0xcf8>
    da50:	00060713          	mv	a4,a2
    da54:	00068413          	mv	s0,a3
    da58:	00160613          	addi	a2,a2,1
    da5c:	00868693          	addi	a3,a3,8
    da60:	040f8e63          	beqz	t6,dabc <_vfiprintf_r+0x468>
    da64:	03c10713          	addi	a4,sp,60
    da68:	00278793          	addi	a5,a5,2
    da6c:	00e42023          	sw	a4,0(s0)
    da70:	00200713          	li	a4,2
    da74:	00e42223          	sw	a4,4(s0)
    da78:	04f12423          	sw	a5,72(sp)
    da7c:	04c12223          	sw	a2,68(sp)
    da80:	00700713          	li	a4,7
    da84:	0ac75ae3          	bge	a4,a2,e338 <_vfiprintf_r+0xce4>
    da88:	26078ce3          	beqz	a5,e500 <_vfiprintf_r+0xeac>
    da8c:	04010613          	addi	a2,sp,64
    da90:	00090593          	mv	a1,s2
    da94:	00098513          	mv	a0,s3
    da98:	01012a23          	sw	a6,20(sp)
    da9c:	ab1ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    daa0:	e20512e3          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    daa4:	04412703          	lw	a4,68(sp)
    daa8:	04812783          	lw	a5,72(sp)
    daac:	01412803          	lw	a6,20(sp)
    dab0:	05410693          	addi	a3,sp,84
    dab4:	00170613          	addi	a2,a4,1
    dab8:	00048413          	mv	s0,s1
    dabc:	08000593          	li	a1,128
    dac0:	64b80a63          	beq	a6,a1,e114 <_vfiprintf_r+0xac0>
    dac4:	41bc0c33          	sub	s8,s8,s11
    dac8:	75804663          	bgtz	s8,e214 <_vfiprintf_r+0xbc0>
    dacc:	00fd87b3          	add	a5,s11,a5
    dad0:	01642023          	sw	s6,0(s0)
    dad4:	01b42223          	sw	s11,4(s0)
    dad8:	04f12423          	sw	a5,72(sp)
    dadc:	04c12223          	sw	a2,68(sp)
    dae0:	00700713          	li	a4,7
    dae4:	02c75263          	bge	a4,a2,db08 <_vfiprintf_r+0x4b4>
    dae8:	18078463          	beqz	a5,dc70 <_vfiprintf_r+0x61c>
    daec:	04010613          	addi	a2,sp,64
    daf0:	00090593          	mv	a1,s2
    daf4:	00098513          	mv	a0,s3
    daf8:	a55ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    dafc:	dc0514e3          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    db00:	04812783          	lw	a5,72(sp)
    db04:	00048693          	mv	a3,s1
    db08:	004bf893          	andi	a7,s7,4
    db0c:	00088663          	beqz	a7,db18 <_vfiprintf_r+0x4c4>
    db10:	41aa0433          	sub	s0,s4,s10
    db14:	16804a63          	bgtz	s0,dc88 <_vfiprintf_r+0x634>
    db18:	01aa5463          	bge	s4,s10,db20 <_vfiprintf_r+0x4cc>
    db1c:	000d0a13          	mv	s4,s10
    db20:	00812703          	lw	a4,8(sp)
    db24:	01470733          	add	a4,a4,s4
    db28:	00e12423          	sw	a4,8(sp)
    db2c:	7a079e63          	bnez	a5,e2e8 <_vfiprintf_r+0xc94>
    db30:	04012223          	sw	zero,68(sp)
    db34:	00048413          	mv	s0,s1
    db38:	c09ff06f          	j	d740 <_vfiprintf_r+0xec>
    db3c:	020bf793          	andi	a5,s7,32
    db40:	010bed13          	ori	s10,s7,16
    db44:	54079263          	bnez	a5,e088 <_vfiprintf_r+0xa34>
    db48:	00c12783          	lw	a5,12(sp)
    db4c:	00478713          	addi	a4,a5,4
    db50:	00c12783          	lw	a5,12(sp)
    db54:	00000e13          	li	t3,0
    db58:	00e12623          	sw	a4,12(sp)
    db5c:	0007ad83          	lw	s11,0(a5)
    db60:	00100713          	li	a4,1
    db64:	df9ff06f          	j	d95c <_vfiprintf_r+0x308>
    db68:	080beb93          	ori	s7,s7,128
    db6c:	000cc703          	lbu	a4,0(s9)
    db70:	c7dff06f          	j	d7ec <_vfiprintf_r+0x198>
    db74:	00c12783          	lw	a5,12(sp)
    db78:	02010da3          	sb	zero,59(sp)
    db7c:	0007ab03          	lw	s6,0(a5)
    db80:	00478713          	addi	a4,a5,4
    db84:	380b06e3          	beqz	s6,e710 <_vfiprintf_r+0x10bc>
    db88:	fff00793          	li	a5,-1
    db8c:	00e12623          	sw	a4,12(sp)
    db90:	24fc08e3          	beq	s8,a5,e5e0 <_vfiprintf_r+0xf8c>
    db94:	000c0613          	mv	a2,s8
    db98:	00000593          	li	a1,0
    db9c:	000b0513          	mv	a0,s6
    dba0:	f71fa0ef          	jal	ra,8b10 <memchr>
    dba4:	00c12703          	lw	a4,12(sp)
    dba8:	4e0508e3          	beqz	a0,e898 <_vfiprintf_r+0x1244>
    dbac:	41650db3          	sub	s11,a0,s6
    dbb0:	00000c13          	li	s8,0
    dbb4:	dd5ff06f          	j	d988 <_vfiprintf_r+0x334>
    dbb8:	020bf793          	andi	a5,s7,32
    dbbc:	010be893          	ori	a7,s7,16
    dbc0:	46079a63          	bnez	a5,e034 <_vfiprintf_r+0x9e0>
    dbc4:	00c12783          	lw	a5,12(sp)
    dbc8:	00478713          	addi	a4,a5,4
    dbcc:	00c12783          	lw	a5,12(sp)
    dbd0:	00000e13          	li	t3,0
    dbd4:	00e12623          	sw	a4,12(sp)
    dbd8:	0007ad83          	lw	s11,0(a5)
    dbdc:	4740006f          	j	e050 <_vfiprintf_r+0x9fc>
    dbe0:	020bf793          	andi	a5,s7,32
    dbe4:	010bed13          	ori	s10,s7,16
    dbe8:	46079c63          	bnez	a5,e060 <_vfiprintf_r+0xa0c>
    dbec:	00c12783          	lw	a5,12(sp)
    dbf0:	00478713          	addi	a4,a5,4
    dbf4:	00c12783          	lw	a5,12(sp)
    dbf8:	00e12623          	sw	a4,12(sp)
    dbfc:	0007ad83          	lw	s11,0(a5)
    dc00:	41fdde13          	srai	t3,s11,0x1f
    dc04:	000e0713          	mv	a4,t3
    dc08:	38074463          	bltz	a4,df90 <_vfiprintf_r+0x93c>
    dc0c:	fff00713          	li	a4,-1
    dc10:	00ec0a63          	beq	s8,a4,dc24 <_vfiprintf_r+0x5d0>
    dc14:	01cde733          	or	a4,s11,t3
    dc18:	f7fd7b93          	andi	s7,s10,-129
    dc1c:	0a070ee3          	beqz	a4,e4d8 <_vfiprintf_r+0xe84>
    dc20:	000b8d13          	mv	s10,s7
    dc24:	1e0e18e3          	bnez	t3,e614 <_vfiprintf_r+0xfc0>
    dc28:	00900793          	li	a5,9
    dc2c:	1fb7e4e3          	bltu	a5,s11,e614 <_vfiprintf_r+0xfc0>
    dc30:	030d8793          	addi	a5,s11,48 # 3ffe0030 <__freertos_irq_stack_top+0x3ffc8310>
    dc34:	0ef107a3          	sb	a5,239(sp)
    dc38:	000d0b93          	mv	s7,s10
    dc3c:	00100d93          	li	s11,1
    dc40:	0ef10b13          	addi	s6,sp,239
    dc44:	d45ff06f          	j	d988 <_vfiprintf_r+0x334>
    dc48:	00c12703          	lw	a4,12(sp)
    dc4c:	02010da3          	sb	zero,59(sp)
    dc50:	00100d13          	li	s10,1
    dc54:	00072783          	lw	a5,0(a4)
    dc58:	00470713          	addi	a4,a4,4
    dc5c:	00e12623          	sw	a4,12(sp)
    dc60:	08f10623          	sb	a5,140(sp)
    dc64:	00100d93          	li	s11,1
    dc68:	08c10b13          	addi	s6,sp,140
    dc6c:	d85ff06f          	j	d9f0 <_vfiprintf_r+0x39c>
    dc70:	04012223          	sw	zero,68(sp)
    dc74:	004bf893          	andi	a7,s7,4
    dc78:	000886e3          	beqz	a7,e484 <_vfiprintf_r+0xe30>
    dc7c:	41aa0433          	sub	s0,s4,s10
    dc80:	008052e3          	blez	s0,e484 <_vfiprintf_r+0xe30>
    dc84:	00048693          	mv	a3,s1
    dc88:	01000713          	li	a4,16
    dc8c:	04412603          	lw	a2,68(sp)
    dc90:	428754e3          	bge	a4,s0,e8b8 <_vfiprintf_r+0x1264>
    dc94:	00008e97          	auipc	t4,0x8
    dc98:	21ce8e93          	addi	t4,t4,540 # 15eb0 <blanks.4480>
    dc9c:	01000c13          	li	s8,16
    dca0:	00700d93          	li	s11,7
    dca4:	000e8b13          	mv	s6,t4
    dca8:	0180006f          	j	dcc0 <_vfiprintf_r+0x66c>
    dcac:	00260593          	addi	a1,a2,2
    dcb0:	00868693          	addi	a3,a3,8
    dcb4:	00070613          	mv	a2,a4
    dcb8:	ff040413          	addi	s0,s0,-16
    dcbc:	048c5863          	bge	s8,s0,dd0c <_vfiprintf_r+0x6b8>
    dcc0:	01078793          	addi	a5,a5,16
    dcc4:	00160713          	addi	a4,a2,1
    dcc8:	0166a023          	sw	s6,0(a3)
    dccc:	0186a223          	sw	s8,4(a3)
    dcd0:	04f12423          	sw	a5,72(sp)
    dcd4:	04e12223          	sw	a4,68(sp)
    dcd8:	fceddae3          	bge	s11,a4,dcac <_vfiprintf_r+0x658>
    dcdc:	42078463          	beqz	a5,e104 <_vfiprintf_r+0xab0>
    dce0:	04010613          	addi	a2,sp,64
    dce4:	00090593          	mv	a1,s2
    dce8:	00098513          	mv	a0,s3
    dcec:	861ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    dcf0:	bc051ae3          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    dcf4:	04412603          	lw	a2,68(sp)
    dcf8:	ff040413          	addi	s0,s0,-16
    dcfc:	04812783          	lw	a5,72(sp)
    dd00:	00048693          	mv	a3,s1
    dd04:	00160593          	addi	a1,a2,1
    dd08:	fa8c4ce3          	blt	s8,s0,dcc0 <_vfiprintf_r+0x66c>
    dd0c:	000b0e93          	mv	t4,s6
    dd10:	008787b3          	add	a5,a5,s0
    dd14:	01d6a023          	sw	t4,0(a3)
    dd18:	0086a223          	sw	s0,4(a3)
    dd1c:	04f12423          	sw	a5,72(sp)
    dd20:	04b12223          	sw	a1,68(sp)
    dd24:	00700713          	li	a4,7
    dd28:	deb758e3          	bge	a4,a1,db18 <_vfiprintf_r+0x4c4>
    dd2c:	74078c63          	beqz	a5,e484 <_vfiprintf_r+0xe30>
    dd30:	04010613          	addi	a2,sp,64
    dd34:	00090593          	mv	a1,s2
    dd38:	00098513          	mv	a0,s3
    dd3c:	811ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    dd40:	b80512e3          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    dd44:	04812783          	lw	a5,72(sp)
    dd48:	dd1ff06f          	j	db18 <_vfiprintf_r+0x4c4>
    dd4c:	03b14783          	lbu	a5,59(sp)
    dd50:	000cc703          	lbu	a4,0(s9)
    dd54:	a8079ce3          	bnez	a5,d7ec <_vfiprintf_r+0x198>
    dd58:	02000793          	li	a5,32
    dd5c:	02f10da3          	sb	a5,59(sp)
    dd60:	a8dff06f          	j	d7ec <_vfiprintf_r+0x198>
    dd64:	02b00793          	li	a5,43
    dd68:	02f10da3          	sb	a5,59(sp)
    dd6c:	000cc703          	lbu	a4,0(s9)
    dd70:	a7dff06f          	j	d7ec <_vfiprintf_r+0x198>
    dd74:	00c12783          	lw	a5,12(sp)
    dd78:	000cc703          	lbu	a4,0(s9)
    dd7c:	0007aa03          	lw	s4,0(a5)
    dd80:	00478793          	addi	a5,a5,4
    dd84:	00f12623          	sw	a5,12(sp)
    dd88:	a60a52e3          	bgez	s4,d7ec <_vfiprintf_r+0x198>
    dd8c:	41400a33          	neg	s4,s4
    dd90:	004beb93          	ori	s7,s7,4
    dd94:	a59ff06f          	j	d7ec <_vfiprintf_r+0x198>
    dd98:	001beb93          	ori	s7,s7,1
    dd9c:	000cc703          	lbu	a4,0(s9)
    dda0:	a4dff06f          	j	d7ec <_vfiprintf_r+0x198>
    dda4:	000cc703          	lbu	a4,0(s9)
    dda8:	001c8793          	addi	a5,s9,1
    ddac:	33a70ee3          	beq	a4,s10,e8e8 <_vfiprintf_r+0x1294>
    ddb0:	00078c93          	mv	s9,a5
    ddb4:	fd070613          	addi	a2,a4,-48
    ddb8:	00900793          	li	a5,9
    ddbc:	00000c13          	li	s8,0
    ddc0:	a2c7eae3          	bltu	a5,a2,d7f4 <_vfiprintf_r+0x1a0>
    ddc4:	001c8c93          	addi	s9,s9,1
    ddc8:	002c1793          	slli	a5,s8,0x2
    ddcc:	fffcc703          	lbu	a4,-1(s9)
    ddd0:	01878c33          	add	s8,a5,s8
    ddd4:	001c1c13          	slli	s8,s8,0x1
    ddd8:	00cc0c33          	add	s8,s8,a2
    dddc:	00900793          	li	a5,9
    dde0:	fd070613          	addi	a2,a4,-48
    dde4:	fec7f0e3          	bgeu	a5,a2,ddc4 <_vfiprintf_r+0x770>
    dde8:	a0dff06f          	j	d7f4 <_vfiprintf_r+0x1a0>
    ddec:	000cc703          	lbu	a4,0(s9)
    ddf0:	004beb93          	ori	s7,s7,4
    ddf4:	9f9ff06f          	j	d7ec <_vfiprintf_r+0x198>
    ddf8:	020bf793          	andi	a5,s7,32
    ddfc:	28079463          	bnez	a5,e084 <_vfiprintf_r+0xa30>
    de00:	00c12783          	lw	a5,12(sp)
    de04:	010bf693          	andi	a3,s7,16
    de08:	00478713          	addi	a4,a5,4
    de0c:	0007a783          	lw	a5,0(a5)
    de10:	2e069ee3          	bnez	a3,e90c <_vfiprintf_r+0x12b8>
    de14:	040bf693          	andi	a3,s7,64
    de18:	10068ce3          	beqz	a3,e730 <_vfiprintf_r+0x10dc>
    de1c:	01079d93          	slli	s11,a5,0x10
    de20:	00e12623          	sw	a4,12(sp)
    de24:	010ddd93          	srli	s11,s11,0x10
    de28:	00000e13          	li	t3,0
    de2c:	000b8d13          	mv	s10,s7
    de30:	00100713          	li	a4,1
    de34:	b29ff06f          	j	d95c <_vfiprintf_r+0x308>
    de38:	00008797          	auipc	a5,0x8
    de3c:	96078793          	addi	a5,a5,-1696 # 15798 <_data+0x480>
    de40:	00f12823          	sw	a5,16(sp)
    de44:	020bf793          	andi	a5,s7,32
    de48:	ae0790e3          	bnez	a5,d928 <_vfiprintf_r+0x2d4>
    de4c:	00c12603          	lw	a2,12(sp)
    de50:	010bf693          	andi	a3,s7,16
    de54:	00062783          	lw	a5,0(a2)
    de58:	00460613          	addi	a2,a2,4
    de5c:	00c12623          	sw	a2,12(sp)
    de60:	68069a63          	bnez	a3,e4f4 <_vfiprintf_r+0xea0>
    de64:	040bf693          	andi	a3,s7,64
    de68:	68068263          	beqz	a3,e4ec <_vfiprintf_r+0xe98>
    de6c:	01079d93          	slli	s11,a5,0x10
    de70:	010ddd93          	srli	s11,s11,0x10
    de74:	00000e13          	li	t3,0
    de78:	acdff06f          	j	d944 <_vfiprintf_r+0x2f0>
    de7c:	00c12783          	lw	a5,12(sp)
    de80:	02412703          	lw	a4,36(sp)
    de84:	00000e13          	li	t3,0
    de88:	0007ad83          	lw	s11,0(a5)
    de8c:	00478793          	addi	a5,a5,4
    de90:	00f12623          	sw	a5,12(sp)
    de94:	00008797          	auipc	a5,0x8
    de98:	90478793          	addi	a5,a5,-1788 # 15798 <_data+0x480>
    de9c:	02e11e23          	sh	a4,60(sp)
    dea0:	002bed13          	ori	s10,s7,2
    dea4:	00f12823          	sw	a5,16(sp)
    dea8:	00200713          	li	a4,2
    deac:	ab1ff06f          	j	d95c <_vfiprintf_r+0x308>
    deb0:	020bf793          	andi	a5,s7,32
    deb4:	16079e63          	bnez	a5,e030 <_vfiprintf_r+0x9dc>
    deb8:	00c12783          	lw	a5,12(sp)
    debc:	010bf693          	andi	a3,s7,16
    dec0:	00478713          	addi	a4,a5,4
    dec4:	0007a783          	lw	a5,0(a5)
    dec8:	240696e3          	bnez	a3,e914 <_vfiprintf_r+0x12c0>
    decc:	040bf693          	andi	a3,s7,64
    ded0:	080680e3          	beqz	a3,e750 <_vfiprintf_r+0x10fc>
    ded4:	01079d93          	slli	s11,a5,0x10
    ded8:	010ddd93          	srli	s11,s11,0x10
    dedc:	00000e13          	li	t3,0
    dee0:	000b8893          	mv	a7,s7
    dee4:	00e12623          	sw	a4,12(sp)
    dee8:	1680006f          	j	e050 <_vfiprintf_r+0x9fc>
    deec:	00c12683          	lw	a3,12(sp)
    def0:	020bf793          	andi	a5,s7,32
    def4:	00468713          	addi	a4,a3,4
    def8:	6c079663          	bnez	a5,e5c4 <_vfiprintf_r+0xf70>
    defc:	010bf793          	andi	a5,s7,16
    df00:	7e079c63          	bnez	a5,e6f8 <_vfiprintf_r+0x10a4>
    df04:	040bf793          	andi	a5,s7,64
    df08:	100798e3          	bnez	a5,e818 <_vfiprintf_r+0x11c4>
    df0c:	200bf893          	andi	a7,s7,512
    df10:	7e088463          	beqz	a7,e6f8 <_vfiprintf_r+0x10a4>
    df14:	00c12783          	lw	a5,12(sp)
    df18:	00e12623          	sw	a4,12(sp)
    df1c:	00812703          	lw	a4,8(sp)
    df20:	0007a783          	lw	a5,0(a5)
    df24:	00e78023          	sb	a4,0(a5)
    df28:	819ff06f          	j	d740 <_vfiprintf_r+0xec>
    df2c:	000cc703          	lbu	a4,0(s9)
    df30:	06c00793          	li	a5,108
    df34:	7af70a63          	beq	a4,a5,e6e8 <_vfiprintf_r+0x1094>
    df38:	010beb93          	ori	s7,s7,16
    df3c:	8b1ff06f          	j	d7ec <_vfiprintf_r+0x198>
    df40:	000cc703          	lbu	a4,0(s9)
    df44:	06800793          	li	a5,104
    df48:	78f70863          	beq	a4,a5,e6d8 <_vfiprintf_r+0x1084>
    df4c:	040beb93          	ori	s7,s7,64
    df50:	89dff06f          	j	d7ec <_vfiprintf_r+0x198>
    df54:	020bf793          	andi	a5,s7,32
    df58:	10079263          	bnez	a5,e05c <_vfiprintf_r+0xa08>
    df5c:	00c12703          	lw	a4,12(sp)
    df60:	010bf793          	andi	a5,s7,16
    df64:	00470713          	addi	a4,a4,4
    df68:	1a079ae3          	bnez	a5,e91c <_vfiprintf_r+0x12c8>
    df6c:	040bf793          	andi	a5,s7,64
    df70:	7e078e63          	beqz	a5,e76c <_vfiprintf_r+0x1118>
    df74:	00c12783          	lw	a5,12(sp)
    df78:	00e12623          	sw	a4,12(sp)
    df7c:	000b8d13          	mv	s10,s7
    df80:	00079d83          	lh	s11,0(a5)
    df84:	41fdde13          	srai	t3,s11,0x1f
    df88:	000e0713          	mv	a4,t3
    df8c:	c80750e3          	bgez	a4,dc0c <_vfiprintf_r+0x5b8>
    df90:	41b007b3          	neg	a5,s11
    df94:	00f03733          	snez	a4,a5
    df98:	41c00e33          	neg	t3,t3
    df9c:	40ee0e33          	sub	t3,t3,a4
    dfa0:	02d00713          	li	a4,45
    dfa4:	02e10da3          	sb	a4,59(sp)
    dfa8:	fff00693          	li	a3,-1
    dfac:	00078d93          	mv	s11,a5
    dfb0:	00100713          	li	a4,1
    dfb4:	9adc1ae3          	bne	s8,a3,d968 <_vfiprintf_r+0x314>
    dfb8:	00100693          	li	a3,1
    dfbc:	c6d704e3          	beq	a4,a3,dc24 <_vfiprintf_r+0x5d0>
    dfc0:	00200693          	li	a3,2
    dfc4:	0ed70e63          	beq	a4,a3,e0c0 <_vfiprintf_r+0xa6c>
    dfc8:	0f010693          	addi	a3,sp,240
    dfcc:	0080006f          	j	dfd4 <_vfiprintf_r+0x980>
    dfd0:	000b0693          	mv	a3,s6
    dfd4:	01de1793          	slli	a5,t3,0x1d
    dfd8:	007df713          	andi	a4,s11,7
    dfdc:	003ddd93          	srli	s11,s11,0x3
    dfe0:	03070713          	addi	a4,a4,48
    dfe4:	01b7edb3          	or	s11,a5,s11
    dfe8:	003e5e13          	srli	t3,t3,0x3
    dfec:	fee68fa3          	sb	a4,-1(a3)
    dff0:	01cde7b3          	or	a5,s11,t3
    dff4:	fff68b13          	addi	s6,a3,-1
    dff8:	fc079ce3          	bnez	a5,dfd0 <_vfiprintf_r+0x97c>
    dffc:	001d7793          	andi	a5,s10,1
    e000:	0e078a63          	beqz	a5,e0f4 <_vfiprintf_r+0xaa0>
    e004:	03000793          	li	a5,48
    e008:	0ef70663          	beq	a4,a5,e0f4 <_vfiprintf_r+0xaa0>
    e00c:	ffe68693          	addi	a3,a3,-2
    e010:	fefb0fa3          	sb	a5,-1(s6)
    e014:	0f010793          	addi	a5,sp,240
    e018:	40d78db3          	sub	s11,a5,a3
    e01c:	000d0b93          	mv	s7,s10
    e020:	00068b13          	mv	s6,a3
    e024:	965ff06f          	j	d988 <_vfiprintf_r+0x334>
    e028:	9e9f60ef          	jal	ra,4a10 <__sinit>
    e02c:	e7cff06f          	j	d6a8 <_vfiprintf_r+0x54>
    e030:	000b8893          	mv	a7,s7
    e034:	00c12783          	lw	a5,12(sp)
    e038:	00778713          	addi	a4,a5,7
    e03c:	ff877713          	andi	a4,a4,-8
    e040:	00072d83          	lw	s11,0(a4)
    e044:	00472e03          	lw	t3,4(a4)
    e048:	00870793          	addi	a5,a4,8
    e04c:	00f12623          	sw	a5,12(sp)
    e050:	bff8fd13          	andi	s10,a7,-1025
    e054:	00000713          	li	a4,0
    e058:	905ff06f          	j	d95c <_vfiprintf_r+0x308>
    e05c:	000b8d13          	mv	s10,s7
    e060:	00c12783          	lw	a5,12(sp)
    e064:	00778793          	addi	a5,a5,7
    e068:	ff87f793          	andi	a5,a5,-8
    e06c:	0047a703          	lw	a4,4(a5)
    e070:	00878693          	addi	a3,a5,8
    e074:	00d12623          	sw	a3,12(sp)
    e078:	0007ad83          	lw	s11,0(a5)
    e07c:	00070e13          	mv	t3,a4
    e080:	b89ff06f          	j	dc08 <_vfiprintf_r+0x5b4>
    e084:	000b8d13          	mv	s10,s7
    e088:	00c12783          	lw	a5,12(sp)
    e08c:	00778713          	addi	a4,a5,7
    e090:	ff877713          	andi	a4,a4,-8
    e094:	00870793          	addi	a5,a4,8
    e098:	00072d83          	lw	s11,0(a4)
    e09c:	00472e03          	lw	t3,4(a4)
    e0a0:	00f12623          	sw	a5,12(sp)
    e0a4:	00100713          	li	a4,1
    e0a8:	8b5ff06f          	j	d95c <_vfiprintf_r+0x308>
    e0ac:	00100693          	li	a3,1
    e0b0:	7cd70a63          	beq	a4,a3,e884 <_vfiprintf_r+0x1230>
    e0b4:	00200693          	li	a3,2
    e0b8:	000b8d13          	mv	s10,s7
    e0bc:	f0d716e3          	bne	a4,a3,dfc8 <_vfiprintf_r+0x974>
    e0c0:	01012683          	lw	a3,16(sp)
    e0c4:	0f010b13          	addi	s6,sp,240
    e0c8:	00fdf793          	andi	a5,s11,15
    e0cc:	00f687b3          	add	a5,a3,a5
    e0d0:	0007c783          	lbu	a5,0(a5)
    e0d4:	01ce1713          	slli	a4,t3,0x1c
    e0d8:	004ddd93          	srli	s11,s11,0x4
    e0dc:	fffb0b13          	addi	s6,s6,-1
    e0e0:	01b76db3          	or	s11,a4,s11
    e0e4:	004e5e13          	srli	t3,t3,0x4
    e0e8:	00fb0023          	sb	a5,0(s6)
    e0ec:	01cde7b3          	or	a5,s11,t3
    e0f0:	fc079ce3          	bnez	a5,e0c8 <_vfiprintf_r+0xa74>
    e0f4:	0f010793          	addi	a5,sp,240
    e0f8:	41678db3          	sub	s11,a5,s6
    e0fc:	000d0b93          	mv	s7,s10
    e100:	889ff06f          	j	d988 <_vfiprintf_r+0x334>
    e104:	00100593          	li	a1,1
    e108:	00000613          	li	a2,0
    e10c:	00048693          	mv	a3,s1
    e110:	ba9ff06f          	j	dcb8 <_vfiprintf_r+0x664>
    e114:	41aa0e33          	sub	t3,s4,s10
    e118:	9bc056e3          	blez	t3,dac4 <_vfiprintf_r+0x470>
    e11c:	01000593          	li	a1,16
    e120:	7bc5da63          	bge	a1,t3,e8d4 <_vfiprintf_r+0x1280>
    e124:	00008e97          	auipc	t4,0x8
    e128:	d9ce8e93          	addi	t4,t4,-612 # 15ec0 <zeroes.4481>
    e12c:	01612a23          	sw	s6,20(sp)
    e130:	03412423          	sw	s4,40(sp)
    e134:	01000f13          	li	t5,16
    e138:	00700f93          	li	t6,7
    e13c:	000e0a13          	mv	s4,t3
    e140:	000e8b13          	mv	s6,t4
    e144:	0180006f          	j	e15c <_vfiprintf_r+0xb08>
    e148:	00270593          	addi	a1,a4,2
    e14c:	00840413          	addi	s0,s0,8
    e150:	00068713          	mv	a4,a3
    e154:	ff0a0a13          	addi	s4,s4,-16
    e158:	054f5c63          	bge	t5,s4,e1b0 <_vfiprintf_r+0xb5c>
    e15c:	01078793          	addi	a5,a5,16
    e160:	00170693          	addi	a3,a4,1
    e164:	01642023          	sw	s6,0(s0)
    e168:	01e42223          	sw	t5,4(s0)
    e16c:	04f12423          	sw	a5,72(sp)
    e170:	04d12223          	sw	a3,68(sp)
    e174:	fcdfdae3          	bge	t6,a3,e148 <_vfiprintf_r+0xaf4>
    e178:	18078463          	beqz	a5,e300 <_vfiprintf_r+0xcac>
    e17c:	04010613          	addi	a2,sp,64
    e180:	00090593          	mv	a1,s2
    e184:	00098513          	mv	a0,s3
    e188:	bc4ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    e18c:	f2051c63          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    e190:	04412703          	lw	a4,68(sp)
    e194:	01000f13          	li	t5,16
    e198:	ff0a0a13          	addi	s4,s4,-16
    e19c:	04812783          	lw	a5,72(sp)
    e1a0:	00048413          	mv	s0,s1
    e1a4:	00170593          	addi	a1,a4,1
    e1a8:	00700f93          	li	t6,7
    e1ac:	fb4f48e3          	blt	t5,s4,e15c <_vfiprintf_r+0xb08>
    e1b0:	000a0e13          	mv	t3,s4
    e1b4:	000b0e93          	mv	t4,s6
    e1b8:	02812a03          	lw	s4,40(sp)
    e1bc:	01412b03          	lw	s6,20(sp)
    e1c0:	00840513          	addi	a0,s0,8
    e1c4:	01c787b3          	add	a5,a5,t3
    e1c8:	01d42023          	sw	t4,0(s0)
    e1cc:	01c42223          	sw	t3,4(s0)
    e1d0:	04f12423          	sw	a5,72(sp)
    e1d4:	04b12223          	sw	a1,68(sp)
    e1d8:	00700713          	li	a4,7
    e1dc:	38b75e63          	bge	a4,a1,e578 <_vfiprintf_r+0xf24>
    e1e0:	5c078063          	beqz	a5,e7a0 <_vfiprintf_r+0x114c>
    e1e4:	04010613          	addi	a2,sp,64
    e1e8:	00090593          	mv	a1,s2
    e1ec:	00098513          	mv	a0,s3
    e1f0:	b5cff0ef          	jal	ra,d54c <__sprint_r.part.0>
    e1f4:	ec051863          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    e1f8:	04412703          	lw	a4,68(sp)
    e1fc:	41bc0c33          	sub	s8,s8,s11
    e200:	04812783          	lw	a5,72(sp)
    e204:	05410693          	addi	a3,sp,84
    e208:	00170613          	addi	a2,a4,1
    e20c:	00048413          	mv	s0,s1
    e210:	8b805ee3          	blez	s8,dacc <_vfiprintf_r+0x478>
    e214:	01000593          	li	a1,16
    e218:	5785dc63          	bge	a1,s8,e790 <_vfiprintf_r+0x113c>
    e21c:	00008e97          	auipc	t4,0x8
    e220:	ca4e8e93          	addi	t4,t4,-860 # 15ec0 <zeroes.4481>
    e224:	01412a23          	sw	s4,20(sp)
    e228:	01000e13          	li	t3,16
    e22c:	00700f13          	li	t5,7
    e230:	000e8a13          	mv	s4,t4
    e234:	0180006f          	j	e24c <_vfiprintf_r+0xbf8>
    e238:	00270613          	addi	a2,a4,2
    e23c:	00840413          	addi	s0,s0,8
    e240:	00068713          	mv	a4,a3
    e244:	ff0c0c13          	addi	s8,s8,-16
    e248:	058e5c63          	bge	t3,s8,e2a0 <_vfiprintf_r+0xc4c>
    e24c:	01078793          	addi	a5,a5,16
    e250:	00170693          	addi	a3,a4,1
    e254:	01442023          	sw	s4,0(s0)
    e258:	01c42223          	sw	t3,4(s0)
    e25c:	04f12423          	sw	a5,72(sp)
    e260:	04d12223          	sw	a3,68(sp)
    e264:	fcdf5ae3          	bge	t5,a3,e238 <_vfiprintf_r+0xbe4>
    e268:	06078863          	beqz	a5,e2d8 <_vfiprintf_r+0xc84>
    e26c:	04010613          	addi	a2,sp,64
    e270:	00090593          	mv	a1,s2
    e274:	00098513          	mv	a0,s3
    e278:	ad4ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    e27c:	e4051463          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    e280:	04412703          	lw	a4,68(sp)
    e284:	01000e13          	li	t3,16
    e288:	ff0c0c13          	addi	s8,s8,-16
    e28c:	04812783          	lw	a5,72(sp)
    e290:	00048413          	mv	s0,s1
    e294:	00170613          	addi	a2,a4,1
    e298:	00700f13          	li	t5,7
    e29c:	fb8e48e3          	blt	t3,s8,e24c <_vfiprintf_r+0xbf8>
    e2a0:	000a0e93          	mv	t4,s4
    e2a4:	01412a03          	lw	s4,20(sp)
    e2a8:	00840593          	addi	a1,s0,8
    e2ac:	018787b3          	add	a5,a5,s8
    e2b0:	01d42023          	sw	t4,0(s0)
    e2b4:	01842223          	sw	s8,4(s0)
    e2b8:	04f12423          	sw	a5,72(sp)
    e2bc:	04c12223          	sw	a2,68(sp)
    e2c0:	00700713          	li	a4,7
    e2c4:	1cc74c63          	blt	a4,a2,e49c <_vfiprintf_r+0xe48>
    e2c8:	00160613          	addi	a2,a2,1
    e2cc:	00858693          	addi	a3,a1,8
    e2d0:	00058413          	mv	s0,a1
    e2d4:	ff8ff06f          	j	dacc <_vfiprintf_r+0x478>
    e2d8:	00100613          	li	a2,1
    e2dc:	00000713          	li	a4,0
    e2e0:	00048413          	mv	s0,s1
    e2e4:	f61ff06f          	j	e244 <_vfiprintf_r+0xbf0>
    e2e8:	04010613          	addi	a2,sp,64
    e2ec:	00090593          	mv	a1,s2
    e2f0:	00098513          	mv	a0,s3
    e2f4:	a58ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    e2f8:	82050ce3          	beqz	a0,db30 <_vfiprintf_r+0x4dc>
    e2fc:	dc8ff06f          	j	d8c4 <_vfiprintf_r+0x270>
    e300:	00100593          	li	a1,1
    e304:	00000713          	li	a4,0
    e308:	00048413          	mv	s0,s1
    e30c:	e49ff06f          	j	e154 <_vfiprintf_r+0xb00>
    e310:	22079863          	bnez	a5,e540 <_vfiprintf_r+0xeec>
    e314:	03b14703          	lbu	a4,59(sp)
    e318:	4e071263          	bnez	a4,e7fc <_vfiprintf_r+0x11a8>
    e31c:	200f8063          	beqz	t6,e51c <_vfiprintf_r+0xec8>
    e320:	03c10793          	addi	a5,sp,60
    e324:	04f12623          	sw	a5,76(sp)
    e328:	00200793          	li	a5,2
    e32c:	04f12823          	sw	a5,80(sp)
    e330:	00100613          	li	a2,1
    e334:	05410693          	addi	a3,sp,84
    e338:	00060713          	mv	a4,a2
    e33c:	00068413          	mv	s0,a3
    e340:	00160613          	addi	a2,a2,1
    e344:	00868693          	addi	a3,a3,8
    e348:	f74ff06f          	j	dabc <_vfiprintf_r+0x468>
    e34c:	fc0788e3          	beqz	a5,e31c <_vfiprintf_r+0xcc8>
    e350:	04010613          	addi	a2,sp,64
    e354:	00090593          	mv	a1,s2
    e358:	00098513          	mv	a0,s3
    e35c:	03012423          	sw	a6,40(sp)
    e360:	01f12a23          	sw	t6,20(sp)
    e364:	9e8ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    e368:	d4051e63          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    e36c:	04412703          	lw	a4,68(sp)
    e370:	04812783          	lw	a5,72(sp)
    e374:	05410693          	addi	a3,sp,84
    e378:	00170613          	addi	a2,a4,1
    e37c:	00048413          	mv	s0,s1
    e380:	02812803          	lw	a6,40(sp)
    e384:	01412f83          	lw	t6,20(sp)
    e388:	ed8ff06f          	j	da60 <_vfiprintf_r+0x40c>
    e38c:	000b8d13          	mv	s10,s7
    e390:	c29ff06f          	j	dfb8 <_vfiprintf_r+0x964>
    e394:	01000613          	li	a2,16
    e398:	51c65863          	bge	a2,t3,e8a8 <_vfiprintf_r+0x1254>
    e39c:	00008e97          	auipc	t4,0x8
    e3a0:	b14e8e93          	addi	t4,t4,-1260 # 15eb0 <blanks.4480>
    e3a4:	00040613          	mv	a2,s0
    e3a8:	03412623          	sw	s4,44(sp)
    e3ac:	01000293          	li	t0,16
    e3b0:	00700393          	li	t2,7
    e3b4:	01f12a23          	sw	t6,20(sp)
    e3b8:	03012423          	sw	a6,40(sp)
    e3bc:	000e0413          	mv	s0,t3
    e3c0:	000e8a13          	mv	s4,t4
    e3c4:	01c0006f          	j	e3e0 <_vfiprintf_r+0xd8c>
    e3c8:	00270593          	addi	a1,a4,2
    e3cc:	00860613          	addi	a2,a2,8
    e3d0:	00068713          	mv	a4,a3
    e3d4:	ff040413          	addi	s0,s0,-16
    e3d8:	0482dc63          	bge	t0,s0,e430 <_vfiprintf_r+0xddc>
    e3dc:	00170693          	addi	a3,a4,1
    e3e0:	01078793          	addi	a5,a5,16
    e3e4:	01462023          	sw	s4,0(a2)
    e3e8:	00562223          	sw	t0,4(a2)
    e3ec:	04f12423          	sw	a5,72(sp)
    e3f0:	04d12223          	sw	a3,68(sp)
    e3f4:	fcd3dae3          	bge	t2,a3,e3c8 <_vfiprintf_r+0xd74>
    e3f8:	06078e63          	beqz	a5,e474 <_vfiprintf_r+0xe20>
    e3fc:	04010613          	addi	a2,sp,64
    e400:	00090593          	mv	a1,s2
    e404:	00098513          	mv	a0,s3
    e408:	944ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    e40c:	ca051c63          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    e410:	04412703          	lw	a4,68(sp)
    e414:	01000293          	li	t0,16
    e418:	ff040413          	addi	s0,s0,-16
    e41c:	04812783          	lw	a5,72(sp)
    e420:	00048613          	mv	a2,s1
    e424:	00170593          	addi	a1,a4,1
    e428:	00700393          	li	t2,7
    e42c:	fa82c8e3          	blt	t0,s0,e3dc <_vfiprintf_r+0xd88>
    e430:	000a0e93          	mv	t4,s4
    e434:	01412f83          	lw	t6,20(sp)
    e438:	02812803          	lw	a6,40(sp)
    e43c:	02c12a03          	lw	s4,44(sp)
    e440:	00040e13          	mv	t3,s0
    e444:	00060413          	mv	s0,a2
    e448:	01c787b3          	add	a5,a5,t3
    e44c:	01d42023          	sw	t4,0(s0)
    e450:	01c42223          	sw	t3,4(s0)
    e454:	04f12423          	sw	a5,72(sp)
    e458:	04b12223          	sw	a1,68(sp)
    e45c:	00700713          	li	a4,7
    e460:	eab748e3          	blt	a4,a1,e310 <_vfiprintf_r+0xcbc>
    e464:	00840413          	addi	s0,s0,8
    e468:	00158613          	addi	a2,a1,1
    e46c:	00058713          	mv	a4,a1
    e470:	db0ff06f          	j	da20 <_vfiprintf_r+0x3cc>
    e474:	00000713          	li	a4,0
    e478:	00100593          	li	a1,1
    e47c:	00048613          	mv	a2,s1
    e480:	f55ff06f          	j	e3d4 <_vfiprintf_r+0xd80>
    e484:	01aa5463          	bge	s4,s10,e48c <_vfiprintf_r+0xe38>
    e488:	000d0a13          	mv	s4,s10
    e48c:	00812783          	lw	a5,8(sp)
    e490:	014787b3          	add	a5,a5,s4
    e494:	00f12423          	sw	a5,8(sp)
    e498:	e98ff06f          	j	db30 <_vfiprintf_r+0x4dc>
    e49c:	14078c63          	beqz	a5,e5f4 <_vfiprintf_r+0xfa0>
    e4a0:	04010613          	addi	a2,sp,64
    e4a4:	00090593          	mv	a1,s2
    e4a8:	00098513          	mv	a0,s3
    e4ac:	8a0ff0ef          	jal	ra,d54c <__sprint_r.part.0>
    e4b0:	c0051a63          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    e4b4:	04412603          	lw	a2,68(sp)
    e4b8:	04812783          	lw	a5,72(sp)
    e4bc:	05410693          	addi	a3,sp,84
    e4c0:	00160613          	addi	a2,a2,1
    e4c4:	00048413          	mv	s0,s1
    e4c8:	e04ff06f          	j	dacc <_vfiprintf_r+0x478>
    e4cc:	04012223          	sw	zero,68(sp)
    e4d0:	00048413          	mv	s0,s1
    e4d4:	ae8ff06f          	j	d7bc <_vfiprintf_r+0x168>
    e4d8:	3a0c1663          	bnez	s8,e884 <_vfiprintf_r+0x1230>
    e4dc:	00000c13          	li	s8,0
    e4e0:	00000d93          	li	s11,0
    e4e4:	0f010b13          	addi	s6,sp,240
    e4e8:	ca0ff06f          	j	d988 <_vfiprintf_r+0x334>
    e4ec:	200bf693          	andi	a3,s7,512
    e4f0:	38069463          	bnez	a3,e878 <_vfiprintf_r+0x1224>
    e4f4:	00078d93          	mv	s11,a5
    e4f8:	00000e13          	li	t3,0
    e4fc:	c48ff06f          	j	d944 <_vfiprintf_r+0x2f0>
    e500:	05410693          	addi	a3,sp,84
    e504:	00100613          	li	a2,1
    e508:	00000713          	li	a4,0
    e50c:	00048413          	mv	s0,s1
    e510:	dacff06f          	j	dabc <_vfiprintf_r+0x468>
    e514:	000c8d13          	mv	s10,s9
    e518:	ab8ff06f          	j	d7d0 <_vfiprintf_r+0x17c>
    e51c:	00000713          	li	a4,0
    e520:	05410693          	addi	a3,sp,84
    e524:	00100613          	li	a2,1
    e528:	00048413          	mv	s0,s1
    e52c:	d90ff06f          	j	dabc <_vfiprintf_r+0x468>
    e530:	03000793          	li	a5,48
    e534:	0ef107a3          	sb	a5,239(sp)
    e538:	0ef10b13          	addi	s6,sp,239
    e53c:	c4cff06f          	j	d988 <_vfiprintf_r+0x334>
    e540:	04010613          	addi	a2,sp,64
    e544:	00090593          	mv	a1,s2
    e548:	00098513          	mv	a0,s3
    e54c:	03012423          	sw	a6,40(sp)
    e550:	01f12a23          	sw	t6,20(sp)
    e554:	ff9fe0ef          	jal	ra,d54c <__sprint_r.part.0>
    e558:	b6051663          	bnez	a0,d8c4 <_vfiprintf_r+0x270>
    e55c:	04412703          	lw	a4,68(sp)
    e560:	04812783          	lw	a5,72(sp)
    e564:	00048413          	mv	s0,s1
    e568:	00170613          	addi	a2,a4,1
    e56c:	02812803          	lw	a6,40(sp)
    e570:	01412f83          	lw	t6,20(sp)
    e574:	cacff06f          	j	da20 <_vfiprintf_r+0x3cc>
    e578:	00158613          	addi	a2,a1,1
    e57c:	00850693          	addi	a3,a0,8
    e580:	00058713          	mv	a4,a1
    e584:	00050413          	mv	s0,a0
    e588:	d3cff06f          	j	dac4 <_vfiprintf_r+0x470>
    e58c:	03000693          	li	a3,48
    e590:	002beb93          	ori	s7,s7,2
    e594:	02e10ea3          	sb	a4,61(sp)
    e598:	02d10e23          	sb	a3,60(sp)
    e59c:	bffbfd13          	andi	s10,s7,-1025
    e5a0:	00200713          	li	a4,2
    e5a4:	bb8ff06f          	j	d95c <_vfiprintf_r+0x308>
    e5a8:	01812783          	lw	a5,24(sp)
    e5ac:	000cc703          	lbu	a4,0(s9)
    e5b0:	a2078e63          	beqz	a5,d7ec <_vfiprintf_r+0x198>
    e5b4:	0007c783          	lbu	a5,0(a5)
    e5b8:	a2078a63          	beqz	a5,d7ec <_vfiprintf_r+0x198>
    e5bc:	400beb93          	ori	s7,s7,1024
    e5c0:	a2cff06f          	j	d7ec <_vfiprintf_r+0x198>
    e5c4:	00812603          	lw	a2,8(sp)
    e5c8:	0006a783          	lw	a5,0(a3)
    e5cc:	00e12623          	sw	a4,12(sp)
    e5d0:	41f65693          	srai	a3,a2,0x1f
    e5d4:	00c7a023          	sw	a2,0(a5)
    e5d8:	00d7a223          	sw	a3,4(a5)
    e5dc:	964ff06f          	j	d740 <_vfiprintf_r+0xec>
    e5e0:	000b0513          	mv	a0,s6
    e5e4:	e95f20ef          	jal	ra,1478 <strlen>
    e5e8:	00050d93          	mv	s11,a0
    e5ec:	00000c13          	li	s8,0
    e5f0:	b98ff06f          	j	d988 <_vfiprintf_r+0x334>
    e5f4:	00100713          	li	a4,1
    e5f8:	000d8793          	mv	a5,s11
    e5fc:	05612623          	sw	s6,76(sp)
    e600:	05b12823          	sw	s11,80(sp)
    e604:	05b12423          	sw	s11,72(sp)
    e608:	04e12223          	sw	a4,68(sp)
    e60c:	05410693          	addi	a3,sp,84
    e610:	cf8ff06f          	j	db08 <_vfiprintf_r+0x4b4>
    e614:	0f010b13          	addi	s6,sp,240
    e618:	400d7793          	andi	a5,s10,1024
    e61c:	00812a23          	sw	s0,20(sp)
    e620:	03412423          	sw	s4,40(sp)
    e624:	03312623          	sw	s3,44(sp)
    e628:	00000b93          	li	s7,0
    e62c:	000b0993          	mv	s3,s6
    e630:	00078413          	mv	s0,a5
    e634:	000c8b13          	mv	s6,s9
    e638:	000e0a13          	mv	s4,t3
    e63c:	00090c93          	mv	s9,s2
    e640:	01812903          	lw	s2,24(sp)
    e644:	0240006f          	j	e668 <_vfiprintf_r+0x1014>
    e648:	00a00613          	li	a2,10
    e64c:	00000693          	li	a3,0
    e650:	000d8513          	mv	a0,s11
    e654:	000a0593          	mv	a1,s4
    e658:	1b4020ef          	jal	ra,1080c <__udivdi3>
    e65c:	220a0863          	beqz	s4,e88c <_vfiprintf_r+0x1238>
    e660:	00050d93          	mv	s11,a0
    e664:	00058a13          	mv	s4,a1
    e668:	00a00613          	li	a2,10
    e66c:	00000693          	li	a3,0
    e670:	000d8513          	mv	a0,s11
    e674:	000a0593          	mv	a1,s4
    e678:	634020ef          	jal	ra,10cac <__umoddi3>
    e67c:	03050513          	addi	a0,a0,48
    e680:	fea98fa3          	sb	a0,-1(s3)
    e684:	001b8b93          	addi	s7,s7,1
    e688:	fff98993          	addi	s3,s3,-1
    e68c:	fa040ee3          	beqz	s0,e648 <_vfiprintf_r+0xff4>
    e690:	00094703          	lbu	a4,0(s2)
    e694:	fb771ae3          	bne	a4,s7,e648 <_vfiprintf_r+0xff4>
    e698:	0ff00793          	li	a5,255
    e69c:	fafb86e3          	beq	s7,a5,e648 <_vfiprintf_r+0xff4>
    e6a0:	100a1a63          	bnez	s4,e7b4 <_vfiprintf_r+0x1160>
    e6a4:	00900793          	li	a5,9
    e6a8:	11b7e663          	bltu	a5,s11,e7b4 <_vfiprintf_r+0x1160>
    e6ac:	01212c23          	sw	s2,24(sp)
    e6b0:	0f010793          	addi	a5,sp,240
    e6b4:	000c8913          	mv	s2,s9
    e6b8:	000b0c93          	mv	s9,s6
    e6bc:	00098b13          	mv	s6,s3
    e6c0:	01412403          	lw	s0,20(sp)
    e6c4:	02812a03          	lw	s4,40(sp)
    e6c8:	02c12983          	lw	s3,44(sp)
    e6cc:	41678db3          	sub	s11,a5,s6
    e6d0:	000d0b93          	mv	s7,s10
    e6d4:	ab4ff06f          	j	d988 <_vfiprintf_r+0x334>
    e6d8:	001cc703          	lbu	a4,1(s9)
    e6dc:	200beb93          	ori	s7,s7,512
    e6e0:	001c8c93          	addi	s9,s9,1
    e6e4:	908ff06f          	j	d7ec <_vfiprintf_r+0x198>
    e6e8:	001cc703          	lbu	a4,1(s9)
    e6ec:	020beb93          	ori	s7,s7,32
    e6f0:	001c8c93          	addi	s9,s9,1
    e6f4:	8f8ff06f          	j	d7ec <_vfiprintf_r+0x198>
    e6f8:	00c12783          	lw	a5,12(sp)
    e6fc:	0007a783          	lw	a5,0(a5)
    e700:	00e12623          	sw	a4,12(sp)
    e704:	00812703          	lw	a4,8(sp)
    e708:	00e7a023          	sw	a4,0(a5)
    e70c:	834ff06f          	j	d740 <_vfiprintf_r+0xec>
    e710:	00600793          	li	a5,6
    e714:	000c0d93          	mv	s11,s8
    e718:	0d87ee63          	bltu	a5,s8,e7f4 <_vfiprintf_r+0x11a0>
    e71c:	000d8d13          	mv	s10,s11
    e720:	00e12623          	sw	a4,12(sp)
    e724:	00007b17          	auipc	s6,0x7
    e728:	09cb0b13          	addi	s6,s6,156 # 157c0 <_data+0x4a8>
    e72c:	ac4ff06f          	j	d9f0 <_vfiprintf_r+0x39c>
    e730:	200bf693          	andi	a3,s7,512
    e734:	12068663          	beqz	a3,e860 <_vfiprintf_r+0x120c>
    e738:	00e12623          	sw	a4,12(sp)
    e73c:	0ff7fd93          	andi	s11,a5,255
    e740:	00000e13          	li	t3,0
    e744:	000b8d13          	mv	s10,s7
    e748:	00100713          	li	a4,1
    e74c:	a10ff06f          	j	d95c <_vfiprintf_r+0x308>
    e750:	200bf693          	andi	a3,s7,512
    e754:	0e068c63          	beqz	a3,e84c <_vfiprintf_r+0x11f8>
    e758:	0ff7fd93          	andi	s11,a5,255
    e75c:	00000e13          	li	t3,0
    e760:	000b8893          	mv	a7,s7
    e764:	00e12623          	sw	a4,12(sp)
    e768:	8e9ff06f          	j	e050 <_vfiprintf_r+0x9fc>
    e76c:	200bf793          	andi	a5,s7,512
    e770:	0c078063          	beqz	a5,e830 <_vfiprintf_r+0x11dc>
    e774:	00c12783          	lw	a5,12(sp)
    e778:	000b8d13          	mv	s10,s7
    e77c:	00e12623          	sw	a4,12(sp)
    e780:	00078d83          	lb	s11,0(a5)
    e784:	41fdde13          	srai	t3,s11,0x1f
    e788:	000e0713          	mv	a4,t3
    e78c:	c7cff06f          	j	dc08 <_vfiprintf_r+0x5b4>
    e790:	00068593          	mv	a1,a3
    e794:	00007e97          	auipc	t4,0x7
    e798:	72ce8e93          	addi	t4,t4,1836 # 15ec0 <zeroes.4481>
    e79c:	b11ff06f          	j	e2ac <_vfiprintf_r+0xc58>
    e7a0:	05410693          	addi	a3,sp,84
    e7a4:	00100613          	li	a2,1
    e7a8:	00000713          	li	a4,0
    e7ac:	00048413          	mv	s0,s1
    e7b0:	b14ff06f          	j	dac4 <_vfiprintf_r+0x470>
    e7b4:	02012783          	lw	a5,32(sp)
    e7b8:	01c12583          	lw	a1,28(sp)
    e7bc:	00000b93          	li	s7,0
    e7c0:	40f989b3          	sub	s3,s3,a5
    e7c4:	00078613          	mv	a2,a5
    e7c8:	00098513          	mv	a0,s3
    e7cc:	9e8fc0ef          	jal	ra,a9b4 <strncpy>
    e7d0:	00194703          	lbu	a4,1(s2)
    e7d4:	00a00613          	li	a2,10
    e7d8:	00000693          	li	a3,0
    e7dc:	00e03733          	snez	a4,a4
    e7e0:	000d8513          	mv	a0,s11
    e7e4:	000a0593          	mv	a1,s4
    e7e8:	00e90933          	add	s2,s2,a4
    e7ec:	020020ef          	jal	ra,1080c <__udivdi3>
    e7f0:	e71ff06f          	j	e660 <_vfiprintf_r+0x100c>
    e7f4:	00600d93          	li	s11,6
    e7f8:	f25ff06f          	j	e71c <_vfiprintf_r+0x10c8>
    e7fc:	03b10793          	addi	a5,sp,59
    e800:	04f12623          	sw	a5,76(sp)
    e804:	00100793          	li	a5,1
    e808:	04f12823          	sw	a5,80(sp)
    e80c:	00100613          	li	a2,1
    e810:	05410693          	addi	a3,sp,84
    e814:	a3cff06f          	j	da50 <_vfiprintf_r+0x3fc>
    e818:	00c12783          	lw	a5,12(sp)
    e81c:	00e12623          	sw	a4,12(sp)
    e820:	00812703          	lw	a4,8(sp)
    e824:	0007a783          	lw	a5,0(a5)
    e828:	00e79023          	sh	a4,0(a5)
    e82c:	f15fe06f          	j	d740 <_vfiprintf_r+0xec>
    e830:	00c12783          	lw	a5,12(sp)
    e834:	000b8d13          	mv	s10,s7
    e838:	00e12623          	sw	a4,12(sp)
    e83c:	0007ad83          	lw	s11,0(a5)
    e840:	41fdde13          	srai	t3,s11,0x1f
    e844:	000e0713          	mv	a4,t3
    e848:	bc0ff06f          	j	dc08 <_vfiprintf_r+0x5b4>
    e84c:	00078d93          	mv	s11,a5
    e850:	00000e13          	li	t3,0
    e854:	000b8893          	mv	a7,s7
    e858:	00e12623          	sw	a4,12(sp)
    e85c:	ff4ff06f          	j	e050 <_vfiprintf_r+0x9fc>
    e860:	00e12623          	sw	a4,12(sp)
    e864:	00078d93          	mv	s11,a5
    e868:	00000e13          	li	t3,0
    e86c:	000b8d13          	mv	s10,s7
    e870:	00100713          	li	a4,1
    e874:	8e8ff06f          	j	d95c <_vfiprintf_r+0x308>
    e878:	0ff7fd93          	andi	s11,a5,255
    e87c:	00000e13          	li	t3,0
    e880:	8c4ff06f          	j	d944 <_vfiprintf_r+0x2f0>
    e884:	000b8d13          	mv	s10,s7
    e888:	ba8ff06f          	j	dc30 <_vfiprintf_r+0x5dc>
    e88c:	00900793          	li	a5,9
    e890:	ddb7e8e3          	bltu	a5,s11,e660 <_vfiprintf_r+0x100c>
    e894:	e19ff06f          	j	e6ac <_vfiprintf_r+0x1058>
    e898:	000c0d93          	mv	s11,s8
    e89c:	00e12623          	sw	a4,12(sp)
    e8a0:	00000c13          	li	s8,0
    e8a4:	8e4ff06f          	j	d988 <_vfiprintf_r+0x334>
    e8a8:	00068593          	mv	a1,a3
    e8ac:	00007e97          	auipc	t4,0x7
    e8b0:	604e8e93          	addi	t4,t4,1540 # 15eb0 <blanks.4480>
    e8b4:	b95ff06f          	j	e448 <_vfiprintf_r+0xdf4>
    e8b8:	00160593          	addi	a1,a2,1
    e8bc:	00007e97          	auipc	t4,0x7
    e8c0:	5f4e8e93          	addi	t4,t4,1524 # 15eb0 <blanks.4480>
    e8c4:	c4cff06f          	j	dd10 <_vfiprintf_r+0x6bc>
    e8c8:	fff00793          	li	a5,-1
    e8cc:	00f12423          	sw	a5,8(sp)
    e8d0:	804ff06f          	j	d8d4 <_vfiprintf_r+0x280>
    e8d4:	00068513          	mv	a0,a3
    e8d8:	00060593          	mv	a1,a2
    e8dc:	00007e97          	auipc	t4,0x7
    e8e0:	5e4e8e93          	addi	t4,t4,1508 # 15ec0 <zeroes.4481>
    e8e4:	8e1ff06f          	j	e1c4 <_vfiprintf_r+0xb70>
    e8e8:	00c12703          	lw	a4,12(sp)
    e8ec:	00072c03          	lw	s8,0(a4)
    e8f0:	00470693          	addi	a3,a4,4
    e8f4:	000c5463          	bgez	s8,e8fc <_vfiprintf_r+0x12a8>
    e8f8:	fff00c13          	li	s8,-1
    e8fc:	001cc703          	lbu	a4,1(s9)
    e900:	00d12623          	sw	a3,12(sp)
    e904:	00078c93          	mv	s9,a5
    e908:	ee5fe06f          	j	d7ec <_vfiprintf_r+0x198>
    e90c:	000b8d13          	mv	s10,s7
    e910:	a40ff06f          	j	db50 <_vfiprintf_r+0x4fc>
    e914:	000b8893          	mv	a7,s7
    e918:	ab4ff06f          	j	dbcc <_vfiprintf_r+0x578>
    e91c:	000b8d13          	mv	s10,s7
    e920:	ad4ff06f          	j	dbf4 <_vfiprintf_r+0x5a0>

0000e924 <vfiprintf>:
    e924:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    e928:	00060693          	mv	a3,a2
    e92c:	00058613          	mv	a2,a1
    e930:	00050593          	mv	a1,a0
    e934:	0007a503          	lw	a0,0(a5)
    e938:	d1dfe06f          	j	d654 <_vfiprintf_r>

0000e93c <__sbprintf>:
    e93c:	00c5d783          	lhu	a5,12(a1)
    e940:	0645ae03          	lw	t3,100(a1)
    e944:	00e5d303          	lhu	t1,14(a1)
    e948:	01c5a883          	lw	a7,28(a1)
    e94c:	0245a803          	lw	a6,36(a1)
    e950:	b8010113          	addi	sp,sp,-1152
    e954:	ffd7f793          	andi	a5,a5,-3
    e958:	40000713          	li	a4,1024
    e95c:	46812c23          	sw	s0,1144(sp)
    e960:	00f11a23          	sh	a5,20(sp)
    e964:	00058413          	mv	s0,a1
    e968:	07010793          	addi	a5,sp,112
    e96c:	00810593          	addi	a1,sp,8
    e970:	46912a23          	sw	s1,1140(sp)
    e974:	47212823          	sw	s2,1136(sp)
    e978:	46112e23          	sw	ra,1148(sp)
    e97c:	00050913          	mv	s2,a0
    e980:	07c12623          	sw	t3,108(sp)
    e984:	00611b23          	sh	t1,22(sp)
    e988:	03112223          	sw	a7,36(sp)
    e98c:	03012623          	sw	a6,44(sp)
    e990:	00f12423          	sw	a5,8(sp)
    e994:	00f12c23          	sw	a5,24(sp)
    e998:	00e12823          	sw	a4,16(sp)
    e99c:	00e12e23          	sw	a4,28(sp)
    e9a0:	02012023          	sw	zero,32(sp)
    e9a4:	cb1fe0ef          	jal	ra,d654 <_vfiprintf_r>
    e9a8:	00050493          	mv	s1,a0
    e9ac:	02055c63          	bgez	a0,e9e4 <__sbprintf+0xa8>
    e9b0:	01415783          	lhu	a5,20(sp)
    e9b4:	0407f793          	andi	a5,a5,64
    e9b8:	00078863          	beqz	a5,e9c8 <__sbprintf+0x8c>
    e9bc:	00c45783          	lhu	a5,12(s0)
    e9c0:	0407e793          	ori	a5,a5,64
    e9c4:	00f41623          	sh	a5,12(s0)
    e9c8:	47c12083          	lw	ra,1148(sp)
    e9cc:	47812403          	lw	s0,1144(sp)
    e9d0:	00048513          	mv	a0,s1
    e9d4:	47012903          	lw	s2,1136(sp)
    e9d8:	47412483          	lw	s1,1140(sp)
    e9dc:	48010113          	addi	sp,sp,1152
    e9e0:	00008067          	ret
    e9e4:	00810593          	addi	a1,sp,8
    e9e8:	00090513          	mv	a0,s2
    e9ec:	c6df50ef          	jal	ra,4658 <_fflush_r>
    e9f0:	fc0500e3          	beqz	a0,e9b0 <__sbprintf+0x74>
    e9f4:	fff00493          	li	s1,-1
    e9f8:	fb9ff06f          	j	e9b0 <__sbprintf+0x74>

0000e9fc <_wctomb_r>:
    e9fc:	00008797          	auipc	a5,0x8
    ea00:	d4c78793          	addi	a5,a5,-692 # 16748 <__global_locale>
    ea04:	0e07a303          	lw	t1,224(a5)
    ea08:	00030067          	jr	t1

0000ea0c <__ascii_wctomb>:
    ea0c:	02058463          	beqz	a1,ea34 <__ascii_wctomb+0x28>
    ea10:	0ff00793          	li	a5,255
    ea14:	00c7e863          	bltu	a5,a2,ea24 <__ascii_wctomb+0x18>
    ea18:	00c58023          	sb	a2,0(a1)
    ea1c:	00100513          	li	a0,1
    ea20:	00008067          	ret
    ea24:	08a00793          	li	a5,138
    ea28:	00f52023          	sw	a5,0(a0)
    ea2c:	fff00513          	li	a0,-1
    ea30:	00008067          	ret
    ea34:	00000513          	li	a0,0
    ea38:	00008067          	ret

0000ea3c <_write_r>:
    ea3c:	00058793          	mv	a5,a1
    ea40:	ff010113          	addi	sp,sp,-16
    ea44:	00812423          	sw	s0,8(sp)
    ea48:	00060593          	mv	a1,a2
    ea4c:	00050413          	mv	s0,a0
    ea50:	00068613          	mv	a2,a3
    ea54:	00078513          	mv	a0,a5
    ea58:	00112623          	sw	ra,12(sp)
    ea5c:	8601a423          	sw	zero,-1944(gp) # 16d18 <errno>
    ea60:	069060ef          	jal	ra,152c8 <_write>
    ea64:	fff00793          	li	a5,-1
    ea68:	00f50a63          	beq	a0,a5,ea7c <_write_r+0x40>
    ea6c:	00c12083          	lw	ra,12(sp)
    ea70:	00812403          	lw	s0,8(sp)
    ea74:	01010113          	addi	sp,sp,16
    ea78:	00008067          	ret
    ea7c:	86818793          	addi	a5,gp,-1944 # 16d18 <errno>
    ea80:	0007a783          	lw	a5,0(a5)
    ea84:	fe0784e3          	beqz	a5,ea6c <_write_r+0x30>
    ea88:	00f42023          	sw	a5,0(s0)
    ea8c:	00c12083          	lw	ra,12(sp)
    ea90:	00812403          	lw	s0,8(sp)
    ea94:	01010113          	addi	sp,sp,16
    ea98:	00008067          	ret

0000ea9c <_calloc_r>:
    ea9c:	02c585b3          	mul	a1,a1,a2
    eaa0:	ff010113          	addi	sp,sp,-16
    eaa4:	00812423          	sw	s0,8(sp)
    eaa8:	00112623          	sw	ra,12(sp)
    eaac:	fe4f90ef          	jal	ra,8290 <_malloc_r>
    eab0:	00050413          	mv	s0,a0
    eab4:	02050863          	beqz	a0,eae4 <_calloc_r+0x48>
    eab8:	ffc52603          	lw	a2,-4(a0)
    eabc:	02400713          	li	a4,36
    eac0:	ffc67613          	andi	a2,a2,-4
    eac4:	ffc60613          	addi	a2,a2,-4
    eac8:	06c76063          	bltu	a4,a2,eb28 <_calloc_r+0x8c>
    eacc:	01300693          	li	a3,19
    ead0:	00050793          	mv	a5,a0
    ead4:	02c6e263          	bltu	a3,a2,eaf8 <_calloc_r+0x5c>
    ead8:	0007a023          	sw	zero,0(a5)
    eadc:	0007a223          	sw	zero,4(a5)
    eae0:	0007a423          	sw	zero,8(a5)
    eae4:	00040513          	mv	a0,s0
    eae8:	00c12083          	lw	ra,12(sp)
    eaec:	00812403          	lw	s0,8(sp)
    eaf0:	01010113          	addi	sp,sp,16
    eaf4:	00008067          	ret
    eaf8:	00052023          	sw	zero,0(a0)
    eafc:	00052223          	sw	zero,4(a0)
    eb00:	01b00793          	li	a5,27
    eb04:	04c7f063          	bgeu	a5,a2,eb44 <_calloc_r+0xa8>
    eb08:	00052423          	sw	zero,8(a0)
    eb0c:	00052623          	sw	zero,12(a0)
    eb10:	01050793          	addi	a5,a0,16
    eb14:	fce612e3          	bne	a2,a4,ead8 <_calloc_r+0x3c>
    eb18:	00052823          	sw	zero,16(a0)
    eb1c:	01850793          	addi	a5,a0,24
    eb20:	00052a23          	sw	zero,20(a0)
    eb24:	fb5ff06f          	j	ead8 <_calloc_r+0x3c>
    eb28:	00000593          	li	a1,0
    eb2c:	afcfa0ef          	jal	ra,8e28 <memset>
    eb30:	00040513          	mv	a0,s0
    eb34:	00c12083          	lw	ra,12(sp)
    eb38:	00812403          	lw	s0,8(sp)
    eb3c:	01010113          	addi	sp,sp,16
    eb40:	00008067          	ret
    eb44:	00850793          	addi	a5,a0,8
    eb48:	f91ff06f          	j	ead8 <_calloc_r+0x3c>

0000eb4c <_close_r>:
    eb4c:	ff010113          	addi	sp,sp,-16
    eb50:	00812423          	sw	s0,8(sp)
    eb54:	00050413          	mv	s0,a0
    eb58:	00058513          	mv	a0,a1
    eb5c:	8601a423          	sw	zero,-1944(gp) # 16d18 <errno>
    eb60:	00112623          	sw	ra,12(sp)
    eb64:	6e4060ef          	jal	ra,15248 <_close>
    eb68:	fff00793          	li	a5,-1
    eb6c:	00f50a63          	beq	a0,a5,eb80 <_close_r+0x34>
    eb70:	00c12083          	lw	ra,12(sp)
    eb74:	00812403          	lw	s0,8(sp)
    eb78:	01010113          	addi	sp,sp,16
    eb7c:	00008067          	ret
    eb80:	86818793          	addi	a5,gp,-1944 # 16d18 <errno>
    eb84:	0007a783          	lw	a5,0(a5)
    eb88:	fe0784e3          	beqz	a5,eb70 <_close_r+0x24>
    eb8c:	00f42023          	sw	a5,0(s0)
    eb90:	00c12083          	lw	ra,12(sp)
    eb94:	00812403          	lw	s0,8(sp)
    eb98:	01010113          	addi	sp,sp,16
    eb9c:	00008067          	ret

0000eba0 <_fclose_r>:
    eba0:	ff010113          	addi	sp,sp,-16
    eba4:	00112623          	sw	ra,12(sp)
    eba8:	00812423          	sw	s0,8(sp)
    ebac:	00912223          	sw	s1,4(sp)
    ebb0:	01212023          	sw	s2,0(sp)
    ebb4:	02058063          	beqz	a1,ebd4 <_fclose_r+0x34>
    ebb8:	00050493          	mv	s1,a0
    ebbc:	00058413          	mv	s0,a1
    ebc0:	00050663          	beqz	a0,ebcc <_fclose_r+0x2c>
    ebc4:	03852783          	lw	a5,56(a0)
    ebc8:	0a078c63          	beqz	a5,ec80 <_fclose_r+0xe0>
    ebcc:	00c41783          	lh	a5,12(s0)
    ebd0:	02079263          	bnez	a5,ebf4 <_fclose_r+0x54>
    ebd4:	00c12083          	lw	ra,12(sp)
    ebd8:	00812403          	lw	s0,8(sp)
    ebdc:	00000913          	li	s2,0
    ebe0:	00090513          	mv	a0,s2
    ebe4:	00412483          	lw	s1,4(sp)
    ebe8:	00012903          	lw	s2,0(sp)
    ebec:	01010113          	addi	sp,sp,16
    ebf0:	00008067          	ret
    ebf4:	00040593          	mv	a1,s0
    ebf8:	00048513          	mv	a0,s1
    ebfc:	801f50ef          	jal	ra,43fc <__sflush_r>
    ec00:	02c42783          	lw	a5,44(s0)
    ec04:	00050913          	mv	s2,a0
    ec08:	00078a63          	beqz	a5,ec1c <_fclose_r+0x7c>
    ec0c:	01c42583          	lw	a1,28(s0)
    ec10:	00048513          	mv	a0,s1
    ec14:	000780e7          	jalr	a5
    ec18:	06054c63          	bltz	a0,ec90 <_fclose_r+0xf0>
    ec1c:	00c45783          	lhu	a5,12(s0)
    ec20:	0807f793          	andi	a5,a5,128
    ec24:	06079e63          	bnez	a5,eca0 <_fclose_r+0x100>
    ec28:	03042583          	lw	a1,48(s0)
    ec2c:	00058c63          	beqz	a1,ec44 <_fclose_r+0xa4>
    ec30:	04040793          	addi	a5,s0,64
    ec34:	00f58663          	beq	a1,a5,ec40 <_fclose_r+0xa0>
    ec38:	00048513          	mv	a0,s1
    ec3c:	f49f50ef          	jal	ra,4b84 <_free_r>
    ec40:	02042823          	sw	zero,48(s0)
    ec44:	04442583          	lw	a1,68(s0)
    ec48:	00058863          	beqz	a1,ec58 <_fclose_r+0xb8>
    ec4c:	00048513          	mv	a0,s1
    ec50:	f35f50ef          	jal	ra,4b84 <_free_r>
    ec54:	04042223          	sw	zero,68(s0)
    ec58:	dc9f50ef          	jal	ra,4a20 <__sfp_lock_acquire>
    ec5c:	00041623          	sh	zero,12(s0)
    ec60:	dc5f50ef          	jal	ra,4a24 <__sfp_lock_release>
    ec64:	00c12083          	lw	ra,12(sp)
    ec68:	00812403          	lw	s0,8(sp)
    ec6c:	00090513          	mv	a0,s2
    ec70:	00412483          	lw	s1,4(sp)
    ec74:	00012903          	lw	s2,0(sp)
    ec78:	01010113          	addi	sp,sp,16
    ec7c:	00008067          	ret
    ec80:	d91f50ef          	jal	ra,4a10 <__sinit>
    ec84:	00c41783          	lh	a5,12(s0)
    ec88:	f40786e3          	beqz	a5,ebd4 <_fclose_r+0x34>
    ec8c:	f69ff06f          	j	ebf4 <_fclose_r+0x54>
    ec90:	00c45783          	lhu	a5,12(s0)
    ec94:	fff00913          	li	s2,-1
    ec98:	0807f793          	andi	a5,a5,128
    ec9c:	f80786e3          	beqz	a5,ec28 <_fclose_r+0x88>
    eca0:	01042583          	lw	a1,16(s0)
    eca4:	00048513          	mv	a0,s1
    eca8:	eddf50ef          	jal	ra,4b84 <_free_r>
    ecac:	f7dff06f          	j	ec28 <_fclose_r+0x88>

0000ecb0 <fclose>:
    ecb0:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    ecb4:	00050593          	mv	a1,a0
    ecb8:	0007a503          	lw	a0,0(a5)
    ecbc:	ee5ff06f          	j	eba0 <_fclose_r>

0000ecc0 <__fputwc>:
    ecc0:	fd010113          	addi	sp,sp,-48
    ecc4:	02812423          	sw	s0,40(sp)
    ecc8:	01312e23          	sw	s3,28(sp)
    eccc:	01512a23          	sw	s5,20(sp)
    ecd0:	02112623          	sw	ra,44(sp)
    ecd4:	02912223          	sw	s1,36(sp)
    ecd8:	03212023          	sw	s2,32(sp)
    ecdc:	01412c23          	sw	s4,24(sp)
    ece0:	01612823          	sw	s6,16(sp)
    ece4:	00050993          	mv	s3,a0
    ece8:	00058a93          	mv	s5,a1
    ecec:	00060413          	mv	s0,a2
    ecf0:	b90f90ef          	jal	ra,8080 <__locale_mb_cur_max>
    ecf4:	00100793          	li	a5,1
    ecf8:	02f51063          	bne	a0,a5,ed18 <__fputwc+0x58>
    ecfc:	fffa8793          	addi	a5,s5,-1
    ed00:	0fe00713          	li	a4,254
    ed04:	00f76a63          	bltu	a4,a5,ed18 <__fputwc+0x58>
    ed08:	0ffaf713          	andi	a4,s5,255
    ed0c:	00e10623          	sb	a4,12(sp)
    ed10:	00100913          	li	s2,1
    ed14:	02c0006f          	j	ed40 <__fputwc+0x80>
    ed18:	05c40693          	addi	a3,s0,92
    ed1c:	000a8613          	mv	a2,s5
    ed20:	00c10593          	addi	a1,sp,12
    ed24:	00098513          	mv	a0,s3
    ed28:	6d0010ef          	jal	ra,103f8 <_wcrtomb_r>
    ed2c:	fff00793          	li	a5,-1
    ed30:	00050913          	mv	s2,a0
    ed34:	0af50463          	beq	a0,a5,eddc <__fputwc+0x11c>
    ed38:	08050e63          	beqz	a0,edd4 <__fputwc+0x114>
    ed3c:	00c14703          	lbu	a4,12(sp)
    ed40:	00000493          	li	s1,0
    ed44:	fff00a13          	li	s4,-1
    ed48:	00a00b13          	li	s6,10
    ed4c:	0280006f          	j	ed74 <__fputwc+0xb4>
    ed50:	00042783          	lw	a5,0(s0)
    ed54:	00178693          	addi	a3,a5,1
    ed58:	00d42023          	sw	a3,0(s0)
    ed5c:	00e78023          	sb	a4,0(a5)
    ed60:	00148493          	addi	s1,s1,1
    ed64:	00c10793          	addi	a5,sp,12
    ed68:	009787b3          	add	a5,a5,s1
    ed6c:	0724f463          	bgeu	s1,s2,edd4 <__fputwc+0x114>
    ed70:	0007c703          	lbu	a4,0(a5)
    ed74:	00842783          	lw	a5,8(s0)
    ed78:	fff78793          	addi	a5,a5,-1
    ed7c:	00f42423          	sw	a5,8(s0)
    ed80:	fc07d8e3          	bgez	a5,ed50 <__fputwc+0x90>
    ed84:	01842683          	lw	a3,24(s0)
    ed88:	00070593          	mv	a1,a4
    ed8c:	00040613          	mv	a2,s0
    ed90:	00098513          	mv	a0,s3
    ed94:	00d7c463          	blt	a5,a3,ed9c <__fputwc+0xdc>
    ed98:	fb671ce3          	bne	a4,s6,ed50 <__fputwc+0x90>
    ed9c:	b60f50ef          	jal	ra,40fc <__swbuf_r>
    eda0:	fd4510e3          	bne	a0,s4,ed60 <__fputwc+0xa0>
    eda4:	fff00913          	li	s2,-1
    eda8:	02c12083          	lw	ra,44(sp)
    edac:	02812403          	lw	s0,40(sp)
    edb0:	00090513          	mv	a0,s2
    edb4:	02412483          	lw	s1,36(sp)
    edb8:	02012903          	lw	s2,32(sp)
    edbc:	01c12983          	lw	s3,28(sp)
    edc0:	01812a03          	lw	s4,24(sp)
    edc4:	01412a83          	lw	s5,20(sp)
    edc8:	01012b03          	lw	s6,16(sp)
    edcc:	03010113          	addi	sp,sp,48
    edd0:	00008067          	ret
    edd4:	000a8913          	mv	s2,s5
    edd8:	fd1ff06f          	j	eda8 <__fputwc+0xe8>
    eddc:	00c45783          	lhu	a5,12(s0)
    ede0:	0407e793          	ori	a5,a5,64
    ede4:	00f41623          	sh	a5,12(s0)
    ede8:	fc1ff06f          	j	eda8 <__fputwc+0xe8>

0000edec <_fputwc_r>:
    edec:	00c61783          	lh	a5,12(a2)
    edf0:	01279713          	slli	a4,a5,0x12
    edf4:	02074063          	bltz	a4,ee14 <_fputwc_r+0x28>
    edf8:	06462703          	lw	a4,100(a2)
    edfc:	000026b7          	lui	a3,0x2
    ee00:	00d7e7b3          	or	a5,a5,a3
    ee04:	000026b7          	lui	a3,0x2
    ee08:	00d76733          	or	a4,a4,a3
    ee0c:	00f61623          	sh	a5,12(a2)
    ee10:	06e62223          	sw	a4,100(a2)
    ee14:	eadff06f          	j	ecc0 <__fputwc>

0000ee18 <fputwc>:
    ee18:	fe010113          	addi	sp,sp,-32
    ee1c:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    ee20:	00812c23          	sw	s0,24(sp)
    ee24:	0007a403          	lw	s0,0(a5)
    ee28:	00912a23          	sw	s1,20(sp)
    ee2c:	00112e23          	sw	ra,28(sp)
    ee30:	00050493          	mv	s1,a0
    ee34:	00058613          	mv	a2,a1
    ee38:	00040663          	beqz	s0,ee44 <fputwc+0x2c>
    ee3c:	03842783          	lw	a5,56(s0)
    ee40:	04078463          	beqz	a5,ee88 <fputwc+0x70>
    ee44:	00c61783          	lh	a5,12(a2)
    ee48:	01279713          	slli	a4,a5,0x12
    ee4c:	02074063          	bltz	a4,ee6c <fputwc+0x54>
    ee50:	06462703          	lw	a4,100(a2)
    ee54:	000026b7          	lui	a3,0x2
    ee58:	00d7e7b3          	or	a5,a5,a3
    ee5c:	000026b7          	lui	a3,0x2
    ee60:	00d76733          	or	a4,a4,a3
    ee64:	00f61623          	sh	a5,12(a2)
    ee68:	06e62223          	sw	a4,100(a2)
    ee6c:	00040513          	mv	a0,s0
    ee70:	01812403          	lw	s0,24(sp)
    ee74:	01c12083          	lw	ra,28(sp)
    ee78:	00048593          	mv	a1,s1
    ee7c:	01412483          	lw	s1,20(sp)
    ee80:	02010113          	addi	sp,sp,32
    ee84:	e3dff06f          	j	ecc0 <__fputwc>
    ee88:	00040513          	mv	a0,s0
    ee8c:	00b12623          	sw	a1,12(sp)
    ee90:	b81f50ef          	jal	ra,4a10 <__sinit>
    ee94:	00c12603          	lw	a2,12(sp)
    ee98:	fadff06f          	j	ee44 <fputwc+0x2c>

0000ee9c <_fstat_r>:
    ee9c:	00058793          	mv	a5,a1
    eea0:	ff010113          	addi	sp,sp,-16
    eea4:	00812423          	sw	s0,8(sp)
    eea8:	00060593          	mv	a1,a2
    eeac:	00050413          	mv	s0,a0
    eeb0:	00078513          	mv	a0,a5
    eeb4:	00112623          	sw	ra,12(sp)
    eeb8:	8601a423          	sw	zero,-1944(gp) # 16d18 <errno>
    eebc:	39c060ef          	jal	ra,15258 <_fstat>
    eec0:	fff00793          	li	a5,-1
    eec4:	00f50a63          	beq	a0,a5,eed8 <_fstat_r+0x3c>
    eec8:	00c12083          	lw	ra,12(sp)
    eecc:	00812403          	lw	s0,8(sp)
    eed0:	01010113          	addi	sp,sp,16
    eed4:	00008067          	ret
    eed8:	86818793          	addi	a5,gp,-1944 # 16d18 <errno>
    eedc:	0007a783          	lw	a5,0(a5)
    eee0:	fe0784e3          	beqz	a5,eec8 <_fstat_r+0x2c>
    eee4:	00f42023          	sw	a5,0(s0)
    eee8:	00c12083          	lw	ra,12(sp)
    eeec:	00812403          	lw	s0,8(sp)
    eef0:	01010113          	addi	sp,sp,16
    eef4:	00008067          	ret

0000eef8 <_isatty_r>:
    eef8:	ff010113          	addi	sp,sp,-16
    eefc:	00812423          	sw	s0,8(sp)
    ef00:	00050413          	mv	s0,a0
    ef04:	00058513          	mv	a0,a1
    ef08:	8601a423          	sw	zero,-1944(gp) # 16d18 <errno>
    ef0c:	00112623          	sw	ra,12(sp)
    ef10:	358060ef          	jal	ra,15268 <_isatty>
    ef14:	fff00793          	li	a5,-1
    ef18:	00f50a63          	beq	a0,a5,ef2c <_isatty_r+0x34>
    ef1c:	00c12083          	lw	ra,12(sp)
    ef20:	00812403          	lw	s0,8(sp)
    ef24:	01010113          	addi	sp,sp,16
    ef28:	00008067          	ret
    ef2c:	86818793          	addi	a5,gp,-1944 # 16d18 <errno>
    ef30:	0007a783          	lw	a5,0(a5)
    ef34:	fe0784e3          	beqz	a5,ef1c <_isatty_r+0x24>
    ef38:	00f42023          	sw	a5,0(s0)
    ef3c:	00c12083          	lw	ra,12(sp)
    ef40:	00812403          	lw	s0,8(sp)
    ef44:	01010113          	addi	sp,sp,16
    ef48:	00008067          	ret

0000ef4c <_lseek_r>:
    ef4c:	00058793          	mv	a5,a1
    ef50:	ff010113          	addi	sp,sp,-16
    ef54:	00812423          	sw	s0,8(sp)
    ef58:	00060593          	mv	a1,a2
    ef5c:	00050413          	mv	s0,a0
    ef60:	00068613          	mv	a2,a3
    ef64:	00078513          	mv	a0,a5
    ef68:	00112623          	sw	ra,12(sp)
    ef6c:	8601a423          	sw	zero,-1944(gp) # 16d18 <errno>
    ef70:	308060ef          	jal	ra,15278 <_lseek>
    ef74:	fff00793          	li	a5,-1
    ef78:	00f50a63          	beq	a0,a5,ef8c <_lseek_r+0x40>
    ef7c:	00c12083          	lw	ra,12(sp)
    ef80:	00812403          	lw	s0,8(sp)
    ef84:	01010113          	addi	sp,sp,16
    ef88:	00008067          	ret
    ef8c:	86818793          	addi	a5,gp,-1944 # 16d18 <errno>
    ef90:	0007a783          	lw	a5,0(a5)
    ef94:	fe0784e3          	beqz	a5,ef7c <_lseek_r+0x30>
    ef98:	00f42023          	sw	a5,0(s0)
    ef9c:	00c12083          	lw	ra,12(sp)
    efa0:	00812403          	lw	s0,8(sp)
    efa4:	01010113          	addi	sp,sp,16
    efa8:	00008067          	ret

0000efac <_read_r>:
    efac:	00058793          	mv	a5,a1
    efb0:	ff010113          	addi	sp,sp,-16
    efb4:	00812423          	sw	s0,8(sp)
    efb8:	00060593          	mv	a1,a2
    efbc:	00050413          	mv	s0,a0
    efc0:	00068613          	mv	a2,a3
    efc4:	00078513          	mv	a0,a5
    efc8:	00112623          	sw	ra,12(sp)
    efcc:	8601a423          	sw	zero,-1944(gp) # 16d18 <errno>
    efd0:	2b8060ef          	jal	ra,15288 <_read>
    efd4:	fff00793          	li	a5,-1
    efd8:	00f50a63          	beq	a0,a5,efec <_read_r+0x40>
    efdc:	00c12083          	lw	ra,12(sp)
    efe0:	00812403          	lw	s0,8(sp)
    efe4:	01010113          	addi	sp,sp,16
    efe8:	00008067          	ret
    efec:	86818793          	addi	a5,gp,-1944 # 16d18 <errno>
    eff0:	0007a783          	lw	a5,0(a5)
    eff4:	fe0784e3          	beqz	a5,efdc <_read_r+0x30>
    eff8:	00f42023          	sw	a5,0(s0)
    effc:	00c12083          	lw	ra,12(sp)
    f000:	00812403          	lw	s0,8(sp)
    f004:	01010113          	addi	sp,sp,16
    f008:	00008067          	ret

0000f00c <cleanup_glue>:
    f00c:	ff010113          	addi	sp,sp,-16
    f010:	00812423          	sw	s0,8(sp)
    f014:	00058413          	mv	s0,a1
    f018:	0005a583          	lw	a1,0(a1)
    f01c:	00912223          	sw	s1,4(sp)
    f020:	00112623          	sw	ra,12(sp)
    f024:	00050493          	mv	s1,a0
    f028:	00058463          	beqz	a1,f030 <cleanup_glue+0x24>
    f02c:	fe1ff0ef          	jal	ra,f00c <cleanup_glue>
    f030:	00040593          	mv	a1,s0
    f034:	00812403          	lw	s0,8(sp)
    f038:	00c12083          	lw	ra,12(sp)
    f03c:	00048513          	mv	a0,s1
    f040:	00412483          	lw	s1,4(sp)
    f044:	01010113          	addi	sp,sp,16
    f048:	b3df506f          	j	4b84 <_free_r>

0000f04c <_reclaim_reent>:
    f04c:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
    f050:	0007a783          	lw	a5,0(a5)
    f054:	10a78263          	beq	a5,a0,f158 <_reclaim_reent+0x10c>
    f058:	04c52703          	lw	a4,76(a0)
    f05c:	fe010113          	addi	sp,sp,-32
    f060:	00912a23          	sw	s1,20(sp)
    f064:	00112e23          	sw	ra,28(sp)
    f068:	00812c23          	sw	s0,24(sp)
    f06c:	01212823          	sw	s2,16(sp)
    f070:	01312623          	sw	s3,12(sp)
    f074:	00050493          	mv	s1,a0
    f078:	04070263          	beqz	a4,f0bc <_reclaim_reent+0x70>
    f07c:	00000913          	li	s2,0
    f080:	08000993          	li	s3,128
    f084:	012707b3          	add	a5,a4,s2
    f088:	0007a583          	lw	a1,0(a5)
    f08c:	00058e63          	beqz	a1,f0a8 <_reclaim_reent+0x5c>
    f090:	0005a403          	lw	s0,0(a1)
    f094:	00048513          	mv	a0,s1
    f098:	aedf50ef          	jal	ra,4b84 <_free_r>
    f09c:	00040593          	mv	a1,s0
    f0a0:	fe0418e3          	bnez	s0,f090 <_reclaim_reent+0x44>
    f0a4:	04c4a703          	lw	a4,76(s1)
    f0a8:	00490913          	addi	s2,s2,4
    f0ac:	fd391ce3          	bne	s2,s3,f084 <_reclaim_reent+0x38>
    f0b0:	00070593          	mv	a1,a4
    f0b4:	00048513          	mv	a0,s1
    f0b8:	acdf50ef          	jal	ra,4b84 <_free_r>
    f0bc:	0404a583          	lw	a1,64(s1)
    f0c0:	00058663          	beqz	a1,f0cc <_reclaim_reent+0x80>
    f0c4:	00048513          	mv	a0,s1
    f0c8:	abdf50ef          	jal	ra,4b84 <_free_r>
    f0cc:	1484a583          	lw	a1,328(s1)
    f0d0:	02058063          	beqz	a1,f0f0 <_reclaim_reent+0xa4>
    f0d4:	14c48913          	addi	s2,s1,332
    f0d8:	01258c63          	beq	a1,s2,f0f0 <_reclaim_reent+0xa4>
    f0dc:	0005a403          	lw	s0,0(a1)
    f0e0:	00048513          	mv	a0,s1
    f0e4:	aa1f50ef          	jal	ra,4b84 <_free_r>
    f0e8:	00040593          	mv	a1,s0
    f0ec:	fe8918e3          	bne	s2,s0,f0dc <_reclaim_reent+0x90>
    f0f0:	0544a583          	lw	a1,84(s1)
    f0f4:	00058663          	beqz	a1,f100 <_reclaim_reent+0xb4>
    f0f8:	00048513          	mv	a0,s1
    f0fc:	a89f50ef          	jal	ra,4b84 <_free_r>
    f100:	0384a783          	lw	a5,56(s1)
    f104:	02078c63          	beqz	a5,f13c <_reclaim_reent+0xf0>
    f108:	03c4a783          	lw	a5,60(s1)
    f10c:	00048513          	mv	a0,s1
    f110:	000780e7          	jalr	a5
    f114:	2e04a583          	lw	a1,736(s1)
    f118:	02058263          	beqz	a1,f13c <_reclaim_reent+0xf0>
    f11c:	01812403          	lw	s0,24(sp)
    f120:	01c12083          	lw	ra,28(sp)
    f124:	01012903          	lw	s2,16(sp)
    f128:	00c12983          	lw	s3,12(sp)
    f12c:	00048513          	mv	a0,s1
    f130:	01412483          	lw	s1,20(sp)
    f134:	02010113          	addi	sp,sp,32
    f138:	ed5ff06f          	j	f00c <cleanup_glue>
    f13c:	01c12083          	lw	ra,28(sp)
    f140:	01812403          	lw	s0,24(sp)
    f144:	01412483          	lw	s1,20(sp)
    f148:	01012903          	lw	s2,16(sp)
    f14c:	00c12983          	lw	s3,12(sp)
    f150:	02010113          	addi	sp,sp,32
    f154:	00008067          	ret
    f158:	00008067          	ret

0000f15c <__ssprint_r>:
    f15c:	00862783          	lw	a5,8(a2)
    f160:	fd010113          	addi	sp,sp,-48
    f164:	01512a23          	sw	s5,20(sp)
    f168:	02112623          	sw	ra,44(sp)
    f16c:	02812423          	sw	s0,40(sp)
    f170:	02912223          	sw	s1,36(sp)
    f174:	03212023          	sw	s2,32(sp)
    f178:	01312e23          	sw	s3,28(sp)
    f17c:	01412c23          	sw	s4,24(sp)
    f180:	01612823          	sw	s6,16(sp)
    f184:	01712623          	sw	s7,12(sp)
    f188:	01812423          	sw	s8,8(sp)
    f18c:	00060a93          	mv	s5,a2
    f190:	14078863          	beqz	a5,f2e0 <__ssprint_r+0x184>
    f194:	00050b13          	mv	s6,a0
    f198:	00058413          	mv	s0,a1
    f19c:	00062983          	lw	s3,0(a2)
    f1a0:	0005a503          	lw	a0,0(a1)
    f1a4:	0085a483          	lw	s1,8(a1)
    f1a8:	0d40006f          	j	f27c <__ssprint_r+0x120>
    f1ac:	00c45783          	lhu	a5,12(s0)
    f1b0:	4807f713          	andi	a4,a5,1152
    f1b4:	08070a63          	beqz	a4,f248 <__ssprint_r+0xec>
    f1b8:	01442683          	lw	a3,20(s0)
    f1bc:	01042583          	lw	a1,16(s0)
    f1c0:	00190713          	addi	a4,s2,1
    f1c4:	00169493          	slli	s1,a3,0x1
    f1c8:	00d486b3          	add	a3,s1,a3
    f1cc:	01f6d493          	srli	s1,a3,0x1f
    f1d0:	40b50a33          	sub	s4,a0,a1
    f1d4:	00d484b3          	add	s1,s1,a3
    f1d8:	4014d493          	srai	s1,s1,0x1
    f1dc:	01470733          	add	a4,a4,s4
    f1e0:	00048613          	mv	a2,s1
    f1e4:	00e4f663          	bgeu	s1,a4,f1f0 <__ssprint_r+0x94>
    f1e8:	00070493          	mv	s1,a4
    f1ec:	00070613          	mv	a2,a4
    f1f0:	4007f793          	andi	a5,a5,1024
    f1f4:	0a078663          	beqz	a5,f2a0 <__ssprint_r+0x144>
    f1f8:	00060593          	mv	a1,a2
    f1fc:	000b0513          	mv	a0,s6
    f200:	890f90ef          	jal	ra,8290 <_malloc_r>
    f204:	00050c13          	mv	s8,a0
    f208:	0a050a63          	beqz	a0,f2bc <__ssprint_r+0x160>
    f20c:	01042583          	lw	a1,16(s0)
    f210:	000a0613          	mv	a2,s4
    f214:	9d9f90ef          	jal	ra,8bec <memcpy>
    f218:	00c45783          	lhu	a5,12(s0)
    f21c:	b7f7f793          	andi	a5,a5,-1153
    f220:	0807e793          	ori	a5,a5,128
    f224:	00f41623          	sh	a5,12(s0)
    f228:	014c0533          	add	a0,s8,s4
    f22c:	41448a33          	sub	s4,s1,s4
    f230:	00942a23          	sw	s1,20(s0)
    f234:	01442423          	sw	s4,8(s0)
    f238:	01842823          	sw	s8,16(s0)
    f23c:	00a42023          	sw	a0,0(s0)
    f240:	00090493          	mv	s1,s2
    f244:	00090a13          	mv	s4,s2
    f248:	000a0613          	mv	a2,s4
    f24c:	000b8593          	mv	a1,s7
    f250:	ab9f90ef          	jal	ra,8d08 <memmove>
    f254:	00842703          	lw	a4,8(s0)
    f258:	00042503          	lw	a0,0(s0)
    f25c:	008aa783          	lw	a5,8(s5)
    f260:	409704b3          	sub	s1,a4,s1
    f264:	01450533          	add	a0,a0,s4
    f268:	00942423          	sw	s1,8(s0)
    f26c:	00a42023          	sw	a0,0(s0)
    f270:	41278933          	sub	s2,a5,s2
    f274:	012aa423          	sw	s2,8(s5)
    f278:	06090463          	beqz	s2,f2e0 <__ssprint_r+0x184>
    f27c:	0049a903          	lw	s2,4(s3)
    f280:	0009ab83          	lw	s7,0(s3)
    f284:	00048a13          	mv	s4,s1
    f288:	00898993          	addi	s3,s3,8
    f28c:	fe0908e3          	beqz	s2,f27c <__ssprint_r+0x120>
    f290:	f0997ee3          	bgeu	s2,s1,f1ac <__ssprint_r+0x50>
    f294:	00090493          	mv	s1,s2
    f298:	00090a13          	mv	s4,s2
    f29c:	fadff06f          	j	f248 <__ssprint_r+0xec>
    f2a0:	000b0513          	mv	a0,s6
    f2a4:	c71fa0ef          	jal	ra,9f14 <_realloc_r>
    f2a8:	00050c13          	mv	s8,a0
    f2ac:	f6051ee3          	bnez	a0,f228 <__ssprint_r+0xcc>
    f2b0:	01042583          	lw	a1,16(s0)
    f2b4:	000b0513          	mv	a0,s6
    f2b8:	8cdf50ef          	jal	ra,4b84 <_free_r>
    f2bc:	00c00793          	li	a5,12
    f2c0:	00fb2023          	sw	a5,0(s6)
    f2c4:	00c45783          	lhu	a5,12(s0)
    f2c8:	fff00513          	li	a0,-1
    f2cc:	0407e793          	ori	a5,a5,64
    f2d0:	00f41623          	sh	a5,12(s0)
    f2d4:	000aa423          	sw	zero,8(s5)
    f2d8:	000aa223          	sw	zero,4(s5)
    f2dc:	00c0006f          	j	f2e8 <__ssprint_r+0x18c>
    f2e0:	000aa223          	sw	zero,4(s5)
    f2e4:	00000513          	li	a0,0
    f2e8:	02c12083          	lw	ra,44(sp)
    f2ec:	02812403          	lw	s0,40(sp)
    f2f0:	02412483          	lw	s1,36(sp)
    f2f4:	02012903          	lw	s2,32(sp)
    f2f8:	01c12983          	lw	s3,28(sp)
    f2fc:	01812a03          	lw	s4,24(sp)
    f300:	01412a83          	lw	s5,20(sp)
    f304:	01012b03          	lw	s6,16(sp)
    f308:	00c12b83          	lw	s7,12(sp)
    f30c:	00812c03          	lw	s8,8(sp)
    f310:	03010113          	addi	sp,sp,48
    f314:	00008067          	ret

0000f318 <_svfiprintf_r>:
    f318:	00c5d783          	lhu	a5,12(a1)
    f31c:	ed010113          	addi	sp,sp,-304
    f320:	11312e23          	sw	s3,284(sp)
    f324:	11412c23          	sw	s4,280(sp)
    f328:	11812423          	sw	s8,264(sp)
    f32c:	12112623          	sw	ra,300(sp)
    f330:	12812423          	sw	s0,296(sp)
    f334:	12912223          	sw	s1,292(sp)
    f338:	13212023          	sw	s2,288(sp)
    f33c:	11512a23          	sw	s5,276(sp)
    f340:	11612823          	sw	s6,272(sp)
    f344:	11712623          	sw	s7,268(sp)
    f348:	11912223          	sw	s9,260(sp)
    f34c:	11a12023          	sw	s10,256(sp)
    f350:	0fb12e23          	sw	s11,252(sp)
    f354:	0807f793          	andi	a5,a5,128
    f358:	00d12623          	sw	a3,12(sp)
    f35c:	00058993          	mv	s3,a1
    f360:	00050a13          	mv	s4,a0
    f364:	00060c13          	mv	s8,a2
    f368:	00078663          	beqz	a5,f374 <_svfiprintf_r+0x5c>
    f36c:	0105a783          	lw	a5,16(a1)
    f370:	560786e3          	beqz	a5,100dc <_svfiprintf_r+0xdc4>
    f374:	ffff87b7          	lui	a5,0xffff8
    f378:	04c10493          	addi	s1,sp,76
    f37c:	8307c793          	xori	a5,a5,-2000
    f380:	04912023          	sw	s1,64(sp)
    f384:	04012423          	sw	zero,72(sp)
    f388:	04012223          	sw	zero,68(sp)
    f38c:	00012823          	sw	zero,16(sp)
    f390:	00012c23          	sw	zero,24(sp)
    f394:	02012023          	sw	zero,32(sp)
    f398:	00012e23          	sw	zero,28(sp)
    f39c:	00012423          	sw	zero,8(sp)
    f3a0:	00007a97          	auipc	s5,0x7
    f3a4:	c34a8a93          	addi	s5,s5,-972 # 15fd4 <_ctype_+0x104>
    f3a8:	02f12223          	sw	a5,36(sp)
    f3ac:	00048413          	mv	s0,s1
    f3b0:	000c0d13          	mv	s10,s8
    f3b4:	000d4783          	lbu	a5,0(s10)
    f3b8:	12078063          	beqz	a5,f4d8 <_svfiprintf_r+0x1c0>
    f3bc:	02500693          	li	a3,37
    f3c0:	4ad786e3          	beq	a5,a3,1006c <_svfiprintf_r+0xd54>
    f3c4:	000d0913          	mv	s2,s10
    f3c8:	00c0006f          	j	f3d4 <_svfiprintf_r+0xbc>
    f3cc:	0ed78263          	beq	a5,a3,f4b0 <_svfiprintf_r+0x198>
    f3d0:	000b0913          	mv	s2,s6
    f3d4:	00194783          	lbu	a5,1(s2)
    f3d8:	00190b13          	addi	s6,s2,1
    f3dc:	fe0798e3          	bnez	a5,f3cc <_svfiprintf_r+0xb4>
    f3e0:	41ab0c33          	sub	s8,s6,s10
    f3e4:	0e0c0a63          	beqz	s8,f4d8 <_svfiprintf_r+0x1c0>
    f3e8:	04812703          	lw	a4,72(sp)
    f3ec:	04412783          	lw	a5,68(sp)
    f3f0:	01a42023          	sw	s10,0(s0)
    f3f4:	01870733          	add	a4,a4,s8
    f3f8:	00178793          	addi	a5,a5,1 # ffff8001 <__freertos_irq_stack_top+0xfffe02e1>
    f3fc:	01842223          	sw	s8,4(s0)
    f400:	04e12423          	sw	a4,72(sp)
    f404:	04f12223          	sw	a5,68(sp)
    f408:	00700713          	li	a4,7
    f40c:	00840413          	addi	s0,s0,8
    f410:	0af74663          	blt	a4,a5,f4bc <_svfiprintf_r+0x1a4>
    f414:	00812703          	lw	a4,8(sp)
    f418:	00194783          	lbu	a5,1(s2)
    f41c:	01870733          	add	a4,a4,s8
    f420:	00e12423          	sw	a4,8(sp)
    f424:	0a078a63          	beqz	a5,f4d8 <_svfiprintf_r+0x1c0>
    f428:	001b0d13          	addi	s10,s6,1
    f42c:	001b4683          	lbu	a3,1(s6)
    f430:	02010da3          	sb	zero,59(sp)
    f434:	fff00c13          	li	s8,-1
    f438:	00000913          	li	s2,0
    f43c:	00000c93          	li	s9,0
    f440:	02a00b13          	li	s6,42
    f444:	001d0d13          	addi	s10,s10,1
    f448:	05a00713          	li	a4,90
    f44c:	fe068793          	addi	a5,a3,-32 # 1fe0 <_vfprintf_r+0xadc>
    f450:	1af76e63          	bltu	a4,a5,f60c <_svfiprintf_r+0x2f4>
    f454:	00279793          	slli	a5,a5,0x2
    f458:	015787b3          	add	a5,a5,s5
    f45c:	0007a783          	lw	a5,0(a5)
    f460:	015787b3          	add	a5,a5,s5
    f464:	00078067          	jr	a5
    f468:	000a0513          	mv	a0,s4
    f46c:	b81f80ef          	jal	ra,7fec <_localeconv_r>
    f470:	00452783          	lw	a5,4(a0)
    f474:	00078513          	mv	a0,a5
    f478:	00f12e23          	sw	a5,28(sp)
    f47c:	ffdf10ef          	jal	ra,1478 <strlen>
    f480:	02a12023          	sw	a0,32(sp)
    f484:	00050b93          	mv	s7,a0
    f488:	000a0513          	mv	a0,s4
    f48c:	b61f80ef          	jal	ra,7fec <_localeconv_r>
    f490:	00852783          	lw	a5,8(a0)
    f494:	00f12c23          	sw	a5,24(sp)
    f498:	3c0b9ee3          	bnez	s7,10074 <_svfiprintf_r+0xd5c>
    f49c:	000d4683          	lbu	a3,0(s10)
    f4a0:	fa5ff06f          	j	f444 <_svfiprintf_r+0x12c>
    f4a4:	020cec93          	ori	s9,s9,32
    f4a8:	000d4683          	lbu	a3,0(s10)
    f4ac:	f99ff06f          	j	f444 <_svfiprintf_r+0x12c>
    f4b0:	41ab0c33          	sub	s8,s6,s10
    f4b4:	f60c0ae3          	beqz	s8,f428 <_svfiprintf_r+0x110>
    f4b8:	f31ff06f          	j	f3e8 <_svfiprintf_r+0xd0>
    f4bc:	04010613          	addi	a2,sp,64
    f4c0:	00098593          	mv	a1,s3
    f4c4:	000a0513          	mv	a0,s4
    f4c8:	c95ff0ef          	jal	ra,f15c <__ssprint_r>
    f4cc:	02051263          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    f4d0:	00048413          	mv	s0,s1
    f4d4:	f41ff06f          	j	f414 <_svfiprintf_r+0xfc>
    f4d8:	04812783          	lw	a5,72(sp)
    f4dc:	00078a63          	beqz	a5,f4f0 <_svfiprintf_r+0x1d8>
    f4e0:	04010613          	addi	a2,sp,64
    f4e4:	00098593          	mv	a1,s3
    f4e8:	000a0513          	mv	a0,s4
    f4ec:	c71ff0ef          	jal	ra,f15c <__ssprint_r>
    f4f0:	00c9d783          	lhu	a5,12(s3)
    f4f4:	0407f793          	andi	a5,a5,64
    f4f8:	6a0792e3          	bnez	a5,1039c <_svfiprintf_r+0x1084>
    f4fc:	12c12083          	lw	ra,300(sp)
    f500:	12812403          	lw	s0,296(sp)
    f504:	00812503          	lw	a0,8(sp)
    f508:	12412483          	lw	s1,292(sp)
    f50c:	12012903          	lw	s2,288(sp)
    f510:	11c12983          	lw	s3,284(sp)
    f514:	11812a03          	lw	s4,280(sp)
    f518:	11412a83          	lw	s5,276(sp)
    f51c:	11012b03          	lw	s6,272(sp)
    f520:	10c12b83          	lw	s7,268(sp)
    f524:	10812c03          	lw	s8,264(sp)
    f528:	10412c83          	lw	s9,260(sp)
    f52c:	10012d03          	lw	s10,256(sp)
    f530:	0fc12d83          	lw	s11,252(sp)
    f534:	13010113          	addi	sp,sp,304
    f538:	00008067          	ret
    f53c:	00006797          	auipc	a5,0x6
    f540:	27078793          	addi	a5,a5,624 # 157ac <_data+0x494>
    f544:	00f12823          	sw	a5,16(sp)
    f548:	020cf793          	andi	a5,s9,32
    f54c:	4c078663          	beqz	a5,fa18 <_svfiprintf_r+0x700>
    f550:	00c12783          	lw	a5,12(sp)
    f554:	00778613          	addi	a2,a5,7
    f558:	ff867613          	andi	a2,a2,-8
    f55c:	00062d83          	lw	s11,0(a2)
    f560:	00462303          	lw	t1,4(a2)
    f564:	00860793          	addi	a5,a2,8
    f568:	00f12623          	sw	a5,12(sp)
    f56c:	001cf613          	andi	a2,s9,1
    f570:	00060663          	beqz	a2,f57c <_svfiprintf_r+0x264>
    f574:	006de633          	or	a2,s11,t1
    f578:	30061ce3          	bnez	a2,10090 <_svfiprintf_r+0xd78>
    f57c:	bffcfb13          	andi	s6,s9,-1025
    f580:	00200693          	li	a3,2
    f584:	02010da3          	sb	zero,59(sp)
    f588:	fff00613          	li	a2,-1
    f58c:	5ecc0c63          	beq	s8,a2,fb84 <_svfiprintf_r+0x86c>
    f590:	006de633          	or	a2,s11,t1
    f594:	f7fb7c93          	andi	s9,s6,-129
    f598:	100616e3          	bnez	a2,fea4 <_svfiprintf_r+0xb8c>
    f59c:	6c0c1a63          	bnez	s8,fc70 <_svfiprintf_r+0x958>
    f5a0:	26069ee3          	bnez	a3,1001c <_svfiprintf_r+0xd04>
    f5a4:	001b7d93          	andi	s11,s6,1
    f5a8:	0f010b93          	addi	s7,sp,240
    f5ac:	000d8863          	beqz	s11,f5bc <_svfiprintf_r+0x2a4>
    f5b0:	03000793          	li	a5,48
    f5b4:	0ef107a3          	sb	a5,239(sp)
    f5b8:	0ef10b93          	addi	s7,sp,239
    f5bc:	000c0b13          	mv	s6,s8
    f5c0:	01bc5463          	bge	s8,s11,f5c8 <_svfiprintf_r+0x2b0>
    f5c4:	000d8b13          	mv	s6,s11
    f5c8:	03b14783          	lbu	a5,59(sp)
    f5cc:	00f037b3          	snez	a5,a5
    f5d0:	00fb0b33          	add	s6,s6,a5
    f5d4:	0540006f          	j	f628 <_svfiprintf_r+0x310>
    f5d8:	00000913          	li	s2,0
    f5dc:	fd068613          	addi	a2,a3,-48
    f5e0:	001d0d13          	addi	s10,s10,1
    f5e4:	00291793          	slli	a5,s2,0x2
    f5e8:	fffd4683          	lbu	a3,-1(s10)
    f5ec:	01278933          	add	s2,a5,s2
    f5f0:	00191913          	slli	s2,s2,0x1
    f5f4:	01260933          	add	s2,a2,s2
    f5f8:	00900793          	li	a5,9
    f5fc:	fd068613          	addi	a2,a3,-48
    f600:	fec7f0e3          	bgeu	a5,a2,f5e0 <_svfiprintf_r+0x2c8>
    f604:	fe068793          	addi	a5,a3,-32
    f608:	e4f776e3          	bgeu	a4,a5,f454 <_svfiprintf_r+0x13c>
    f60c:	ec0686e3          	beqz	a3,f4d8 <_svfiprintf_r+0x1c0>
    f610:	08d10623          	sb	a3,140(sp)
    f614:	02010da3          	sb	zero,59(sp)
    f618:	00100b13          	li	s6,1
    f61c:	00100d93          	li	s11,1
    f620:	08c10b93          	addi	s7,sp,140
    f624:	00000c13          	li	s8,0
    f628:	002cff13          	andi	t5,s9,2
    f62c:	000f0463          	beqz	t5,f634 <_svfiprintf_r+0x31c>
    f630:	002b0b13          	addi	s6,s6,2
    f634:	084cfe93          	andi	t4,s9,132
    f638:	04812783          	lw	a5,72(sp)
    f63c:	04412603          	lw	a2,68(sp)
    f640:	000e9663          	bnez	t4,f64c <_svfiprintf_r+0x334>
    f644:	416906b3          	sub	a3,s2,s6
    f648:	06d042e3          	bgtz	a3,feac <_svfiprintf_r+0xb94>
    f64c:	03b14503          	lbu	a0,59(sp)
    f650:	00160593          	addi	a1,a2,1
    f654:	00840693          	addi	a3,s0,8
    f658:	04050063          	beqz	a0,f698 <_svfiprintf_r+0x380>
    f65c:	03b10513          	addi	a0,sp,59
    f660:	00178793          	addi	a5,a5,1
    f664:	00a42023          	sw	a0,0(s0)
    f668:	00100513          	li	a0,1
    f66c:	00a42223          	sw	a0,4(s0)
    f670:	04f12423          	sw	a5,72(sp)
    f674:	04b12223          	sw	a1,68(sp)
    f678:	00700513          	li	a0,7
    f67c:	12b546e3          	blt	a0,a1,ffa8 <_svfiprintf_r+0xc90>
    f680:	00260313          	addi	t1,a2,2
    f684:	01040513          	addi	a0,s0,16
    f688:	00058613          	mv	a2,a1
    f68c:	00068413          	mv	s0,a3
    f690:	00030593          	mv	a1,t1
    f694:	00050693          	mv	a3,a0
    f698:	020f0c63          	beqz	t5,f6d0 <_svfiprintf_r+0x3b8>
    f69c:	03c10613          	addi	a2,sp,60
    f6a0:	00278793          	addi	a5,a5,2
    f6a4:	00c42023          	sw	a2,0(s0)
    f6a8:	00200613          	li	a2,2
    f6ac:	00c42223          	sw	a2,4(s0)
    f6b0:	04f12423          	sw	a5,72(sp)
    f6b4:	04b12223          	sw	a1,68(sp)
    f6b8:	00700613          	li	a2,7
    f6bc:	12b644e3          	blt	a2,a1,ffe4 <_svfiprintf_r+0xccc>
    f6c0:	00058613          	mv	a2,a1
    f6c4:	00068413          	mv	s0,a3
    f6c8:	00158593          	addi	a1,a1,1
    f6cc:	00868693          	addi	a3,a3,8
    f6d0:	08000513          	li	a0,128
    f6d4:	5eae8a63          	beq	t4,a0,fcc8 <_svfiprintf_r+0x9b0>
    f6d8:	41bc0c33          	sub	s8,s8,s11
    f6dc:	6d804063          	bgtz	s8,fd9c <_svfiprintf_r+0xa84>
    f6e0:	00fd87b3          	add	a5,s11,a5
    f6e4:	01742023          	sw	s7,0(s0)
    f6e8:	01b42223          	sw	s11,4(s0)
    f6ec:	04f12423          	sw	a5,72(sp)
    f6f0:	04b12223          	sw	a1,68(sp)
    f6f4:	00700613          	li	a2,7
    f6f8:	76b64a63          	blt	a2,a1,fe6c <_svfiprintf_r+0xb54>
    f6fc:	004cf813          	andi	a6,s9,4
    f700:	00080663          	beqz	a6,f70c <_svfiprintf_r+0x3f4>
    f704:	41690433          	sub	s0,s2,s6
    f708:	1e804263          	bgtz	s0,f8ec <_svfiprintf_r+0x5d4>
    f70c:	01695463          	bge	s2,s6,f714 <_svfiprintf_r+0x3fc>
    f710:	000b0913          	mv	s2,s6
    f714:	00812703          	lw	a4,8(sp)
    f718:	01270733          	add	a4,a4,s2
    f71c:	00e12423          	sw	a4,8(sp)
    f720:	76079663          	bnez	a5,fe8c <_svfiprintf_r+0xb74>
    f724:	04012223          	sw	zero,68(sp)
    f728:	00048413          	mv	s0,s1
    f72c:	c89ff06f          	j	f3b4 <_svfiprintf_r+0x9c>
    f730:	00c12783          	lw	a5,12(sp)
    f734:	02010da3          	sb	zero,59(sp)
    f738:	0007ab83          	lw	s7,0(a5)
    f73c:	00478713          	addi	a4,a5,4
    f740:	2e0b82e3          	beqz	s7,10224 <_svfiprintf_r+0xf0c>
    f744:	fff00793          	li	a5,-1
    f748:	00e12623          	sw	a4,12(sp)
    f74c:	16fc0ee3          	beq	s8,a5,100c8 <_svfiprintf_r+0xdb0>
    f750:	000c0613          	mv	a2,s8
    f754:	00000593          	li	a1,0
    f758:	000b8513          	mv	a0,s7
    f75c:	bb4f90ef          	jal	ra,8b10 <memchr>
    f760:	00c12703          	lw	a4,12(sp)
    f764:	40050ae3          	beqz	a0,10378 <_svfiprintf_r+0x1060>
    f768:	41750db3          	sub	s11,a0,s7
    f76c:	00000c13          	li	s8,0
    f770:	e4dff06f          	j	f5bc <_svfiprintf_r+0x2a4>
    f774:	020cf793          	andi	a5,s9,32
    f778:	010ce813          	ori	a6,s9,16
    f77c:	46079e63          	bnez	a5,fbf8 <_svfiprintf_r+0x8e0>
    f780:	00c12783          	lw	a5,12(sp)
    f784:	00478693          	addi	a3,a5,4
    f788:	00c12783          	lw	a5,12(sp)
    f78c:	00000313          	li	t1,0
    f790:	00d12623          	sw	a3,12(sp)
    f794:	0007ad83          	lw	s11,0(a5)
    f798:	47c0006f          	j	fc14 <_svfiprintf_r+0x8fc>
    f79c:	020cf793          	andi	a5,s9,32
    f7a0:	010ceb13          	ori	s6,s9,16
    f7a4:	48079063          	bnez	a5,fc24 <_svfiprintf_r+0x90c>
    f7a8:	00c12783          	lw	a5,12(sp)
    f7ac:	00478693          	addi	a3,a5,4
    f7b0:	00c12783          	lw	a5,12(sp)
    f7b4:	00000313          	li	t1,0
    f7b8:	00d12623          	sw	a3,12(sp)
    f7bc:	0007ad83          	lw	s11,0(a5)
    f7c0:	00100693          	li	a3,1
    f7c4:	dc1ff06f          	j	f584 <_svfiprintf_r+0x26c>
    f7c8:	080cec93          	ori	s9,s9,128
    f7cc:	000d4683          	lbu	a3,0(s10)
    f7d0:	c75ff06f          	j	f444 <_svfiprintf_r+0x12c>
    f7d4:	000d4683          	lbu	a3,0(s10)
    f7d8:	001d0793          	addi	a5,s10,1
    f7dc:	3d6686e3          	beq	a3,s6,103a8 <_svfiprintf_r+0x1090>
    f7e0:	00078d13          	mv	s10,a5
    f7e4:	fd068613          	addi	a2,a3,-48
    f7e8:	00900793          	li	a5,9
    f7ec:	00000c13          	li	s8,0
    f7f0:	c4c7eee3          	bltu	a5,a2,f44c <_svfiprintf_r+0x134>
    f7f4:	001d0d13          	addi	s10,s10,1
    f7f8:	002c1793          	slli	a5,s8,0x2
    f7fc:	fffd4683          	lbu	a3,-1(s10)
    f800:	01878c33          	add	s8,a5,s8
    f804:	001c1c13          	slli	s8,s8,0x1
    f808:	00cc0c33          	add	s8,s8,a2
    f80c:	00900793          	li	a5,9
    f810:	fd068613          	addi	a2,a3,-48
    f814:	fec7f0e3          	bgeu	a5,a2,f7f4 <_svfiprintf_r+0x4dc>
    f818:	c35ff06f          	j	f44c <_svfiprintf_r+0x134>
    f81c:	000d4683          	lbu	a3,0(s10)
    f820:	004cec93          	ori	s9,s9,4
    f824:	c21ff06f          	j	f444 <_svfiprintf_r+0x12c>
    f828:	02b00793          	li	a5,43
    f82c:	02f10da3          	sb	a5,59(sp)
    f830:	000d4683          	lbu	a3,0(s10)
    f834:	c11ff06f          	j	f444 <_svfiprintf_r+0x12c>
    f838:	00c12783          	lw	a5,12(sp)
    f83c:	000d4683          	lbu	a3,0(s10)
    f840:	0007a903          	lw	s2,0(a5)
    f844:	00478793          	addi	a5,a5,4
    f848:	00f12623          	sw	a5,12(sp)
    f84c:	be095ce3          	bgez	s2,f444 <_svfiprintf_r+0x12c>
    f850:	41200933          	neg	s2,s2
    f854:	004cec93          	ori	s9,s9,4
    f858:	bedff06f          	j	f444 <_svfiprintf_r+0x12c>
    f85c:	020cf793          	andi	a5,s9,32
    f860:	010ceb13          	ori	s6,s9,16
    f864:	3e079463          	bnez	a5,fc4c <_svfiprintf_r+0x934>
    f868:	00c12783          	lw	a5,12(sp)
    f86c:	00478693          	addi	a3,a5,4
    f870:	00c12783          	lw	a5,12(sp)
    f874:	00d12623          	sw	a3,12(sp)
    f878:	0007ad83          	lw	s11,0(a5)
    f87c:	41fdd313          	srai	t1,s11,0x1f
    f880:	00030693          	mv	a3,t1
    f884:	2c06cc63          	bltz	a3,fb5c <_svfiprintf_r+0x844>
    f888:	fff00693          	li	a3,-1
    f88c:	00dc0a63          	beq	s8,a3,f8a0 <_svfiprintf_r+0x588>
    f890:	006de6b3          	or	a3,s11,t1
    f894:	f7fb7c93          	andi	s9,s6,-129
    f898:	78068063          	beqz	a3,10018 <_svfiprintf_r+0xd00>
    f89c:	000c8b13          	mv	s6,s9
    f8a0:	04031ee3          	bnez	t1,100fc <_svfiprintf_r+0xde4>
    f8a4:	00900793          	li	a5,9
    f8a8:	05b7eae3          	bltu	a5,s11,100fc <_svfiprintf_r+0xde4>
    f8ac:	030d8793          	addi	a5,s11,48
    f8b0:	0ef107a3          	sb	a5,239(sp)
    f8b4:	000b0c93          	mv	s9,s6
    f8b8:	00100d93          	li	s11,1
    f8bc:	0ef10b93          	addi	s7,sp,239
    f8c0:	cfdff06f          	j	f5bc <_svfiprintf_r+0x2a4>
    f8c4:	00c12703          	lw	a4,12(sp)
    f8c8:	02010da3          	sb	zero,59(sp)
    f8cc:	00100b13          	li	s6,1
    f8d0:	00072783          	lw	a5,0(a4)
    f8d4:	00470713          	addi	a4,a4,4
    f8d8:	00e12623          	sw	a4,12(sp)
    f8dc:	08f10623          	sb	a5,140(sp)
    f8e0:	00100d93          	li	s11,1
    f8e4:	08c10b93          	addi	s7,sp,140
    f8e8:	d3dff06f          	j	f624 <_svfiprintf_r+0x30c>
    f8ec:	00007317          	auipc	t1,0x7
    f8f0:	85430313          	addi	t1,t1,-1964 # 16140 <blanks.4466>
    f8f4:	01000593          	li	a1,16
    f8f8:	04412603          	lw	a2,68(sp)
    f8fc:	01000c13          	li	s8,16
    f900:	00700d93          	li	s11,7
    f904:	00030b93          	mv	s7,t1
    f908:	0085c863          	blt	a1,s0,f918 <_svfiprintf_r+0x600>
    f90c:	0580006f          	j	f964 <_svfiprintf_r+0x64c>
    f910:	ff040413          	addi	s0,s0,-16
    f914:	048c5663          	bge	s8,s0,f960 <_svfiprintf_r+0x648>
    f918:	01078793          	addi	a5,a5,16
    f91c:	00160613          	addi	a2,a2,1
    f920:	0176a023          	sw	s7,0(a3)
    f924:	0186a223          	sw	s8,4(a3)
    f928:	04f12423          	sw	a5,72(sp)
    f92c:	04c12223          	sw	a2,68(sp)
    f930:	00868693          	addi	a3,a3,8
    f934:	fccddee3          	bge	s11,a2,f910 <_svfiprintf_r+0x5f8>
    f938:	04010613          	addi	a2,sp,64
    f93c:	00098593          	mv	a1,s3
    f940:	000a0513          	mv	a0,s4
    f944:	819ff0ef          	jal	ra,f15c <__ssprint_r>
    f948:	ba0514e3          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    f94c:	ff040413          	addi	s0,s0,-16
    f950:	04812783          	lw	a5,72(sp)
    f954:	04412603          	lw	a2,68(sp)
    f958:	00048693          	mv	a3,s1
    f95c:	fa8c4ee3          	blt	s8,s0,f918 <_svfiprintf_r+0x600>
    f960:	000b8313          	mv	t1,s7
    f964:	008787b3          	add	a5,a5,s0
    f968:	00160613          	addi	a2,a2,1
    f96c:	0066a023          	sw	t1,0(a3)
    f970:	0086a223          	sw	s0,4(a3)
    f974:	04f12423          	sw	a5,72(sp)
    f978:	04c12223          	sw	a2,68(sp)
    f97c:	00700693          	li	a3,7
    f980:	d8c6d6e3          	bge	a3,a2,f70c <_svfiprintf_r+0x3f4>
    f984:	04010613          	addi	a2,sp,64
    f988:	00098593          	mv	a1,s3
    f98c:	000a0513          	mv	a0,s4
    f990:	fccff0ef          	jal	ra,f15c <__ssprint_r>
    f994:	b4051ee3          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    f998:	04812783          	lw	a5,72(sp)
    f99c:	d71ff06f          	j	f70c <_svfiprintf_r+0x3f4>
    f9a0:	001cec93          	ori	s9,s9,1
    f9a4:	000d4683          	lbu	a3,0(s10)
    f9a8:	a9dff06f          	j	f444 <_svfiprintf_r+0x12c>
    f9ac:	03b14783          	lbu	a5,59(sp)
    f9b0:	000d4683          	lbu	a3,0(s10)
    f9b4:	a80798e3          	bnez	a5,f444 <_svfiprintf_r+0x12c>
    f9b8:	02000793          	li	a5,32
    f9bc:	02f10da3          	sb	a5,59(sp)
    f9c0:	a85ff06f          	j	f444 <_svfiprintf_r+0x12c>
    f9c4:	020cf793          	andi	a5,s9,32
    f9c8:	24079c63          	bnez	a5,fc20 <_svfiprintf_r+0x908>
    f9cc:	00c12783          	lw	a5,12(sp)
    f9d0:	010cf613          	andi	a2,s9,16
    f9d4:	00478693          	addi	a3,a5,4
    f9d8:	0007a783          	lw	a5,0(a5)
    f9dc:	20061ae3          	bnez	a2,103f0 <_svfiprintf_r+0x10d8>
    f9e0:	040cf613          	andi	a2,s9,64
    f9e4:	060602e3          	beqz	a2,10248 <_svfiprintf_r+0xf30>
    f9e8:	01079d93          	slli	s11,a5,0x10
    f9ec:	00d12623          	sw	a3,12(sp)
    f9f0:	010ddd93          	srli	s11,s11,0x10
    f9f4:	00000313          	li	t1,0
    f9f8:	000c8b13          	mv	s6,s9
    f9fc:	00100693          	li	a3,1
    fa00:	b85ff06f          	j	f584 <_svfiprintf_r+0x26c>
    fa04:	00006797          	auipc	a5,0x6
    fa08:	d9478793          	addi	a5,a5,-620 # 15798 <_data+0x480>
    fa0c:	00f12823          	sw	a5,16(sp)
    fa10:	020cf793          	andi	a5,s9,32
    fa14:	b2079ee3          	bnez	a5,f550 <_svfiprintf_r+0x238>
    fa18:	00c12703          	lw	a4,12(sp)
    fa1c:	010cf613          	andi	a2,s9,16
    fa20:	00072783          	lw	a5,0(a4)
    fa24:	00470713          	addi	a4,a4,4
    fa28:	00e12623          	sw	a4,12(sp)
    fa2c:	60061463          	bnez	a2,10034 <_svfiprintf_r+0xd1c>
    fa30:	040cf613          	andi	a2,s9,64
    fa34:	5e060c63          	beqz	a2,1002c <_svfiprintf_r+0xd14>
    fa38:	01079d93          	slli	s11,a5,0x10
    fa3c:	010ddd93          	srli	s11,s11,0x10
    fa40:	00000313          	li	t1,0
    fa44:	b29ff06f          	j	f56c <_svfiprintf_r+0x254>
    fa48:	00c12783          	lw	a5,12(sp)
    fa4c:	02412703          	lw	a4,36(sp)
    fa50:	00000313          	li	t1,0
    fa54:	0007ad83          	lw	s11,0(a5)
    fa58:	00478793          	addi	a5,a5,4
    fa5c:	00f12623          	sw	a5,12(sp)
    fa60:	00006797          	auipc	a5,0x6
    fa64:	d3878793          	addi	a5,a5,-712 # 15798 <_data+0x480>
    fa68:	002ceb13          	ori	s6,s9,2
    fa6c:	02e11e23          	sh	a4,60(sp)
    fa70:	00f12823          	sw	a5,16(sp)
    fa74:	00200693          	li	a3,2
    fa78:	b0dff06f          	j	f584 <_svfiprintf_r+0x26c>
    fa7c:	020cf793          	andi	a5,s9,32
    fa80:	16079a63          	bnez	a5,fbf4 <_svfiprintf_r+0x8dc>
    fa84:	00c12783          	lw	a5,12(sp)
    fa88:	010cf613          	andi	a2,s9,16
    fa8c:	00478693          	addi	a3,a5,4
    fa90:	0007a783          	lw	a5,0(a5)
    fa94:	14061ae3          	bnez	a2,103e8 <_svfiprintf_r+0x10d0>
    fa98:	040cf613          	andi	a2,s9,64
    fa9c:	7e060863          	beqz	a2,1028c <_svfiprintf_r+0xf74>
    faa0:	01079d93          	slli	s11,a5,0x10
    faa4:	010ddd93          	srli	s11,s11,0x10
    faa8:	00000313          	li	t1,0
    faac:	000c8813          	mv	a6,s9
    fab0:	00d12623          	sw	a3,12(sp)
    fab4:	1600006f          	j	fc14 <_svfiprintf_r+0x8fc>
    fab8:	00c12703          	lw	a4,12(sp)
    fabc:	020cf793          	andi	a5,s9,32
    fac0:	00470693          	addi	a3,a4,4
    fac4:	5e079463          	bnez	a5,100ac <_svfiprintf_r+0xd94>
    fac8:	010cf793          	andi	a5,s9,16
    facc:	74079063          	bnez	a5,1020c <_svfiprintf_r+0xef4>
    fad0:	040cf793          	andi	a5,s9,64
    fad4:	080792e3          	bnez	a5,10358 <_svfiprintf_r+0x1040>
    fad8:	200cf813          	andi	a6,s9,512
    fadc:	72080863          	beqz	a6,1020c <_svfiprintf_r+0xef4>
    fae0:	00c12783          	lw	a5,12(sp)
    fae4:	00812703          	lw	a4,8(sp)
    fae8:	00d12623          	sw	a3,12(sp)
    faec:	0007a783          	lw	a5,0(a5)
    faf0:	00e78023          	sb	a4,0(a5)
    faf4:	8c1ff06f          	j	f3b4 <_svfiprintf_r+0x9c>
    faf8:	000d4683          	lbu	a3,0(s10)
    fafc:	06c00793          	li	a5,108
    fb00:	6cf68863          	beq	a3,a5,101d0 <_svfiprintf_r+0xeb8>
    fb04:	010cec93          	ori	s9,s9,16
    fb08:	93dff06f          	j	f444 <_svfiprintf_r+0x12c>
    fb0c:	000d4683          	lbu	a3,0(s10)
    fb10:	06800793          	li	a5,104
    fb14:	6af68663          	beq	a3,a5,101c0 <_svfiprintf_r+0xea8>
    fb18:	040cec93          	ori	s9,s9,64
    fb1c:	929ff06f          	j	f444 <_svfiprintf_r+0x12c>
    fb20:	020cf793          	andi	a5,s9,32
    fb24:	12079263          	bnez	a5,fc48 <_svfiprintf_r+0x930>
    fb28:	00c12703          	lw	a4,12(sp)
    fb2c:	010cf793          	andi	a5,s9,16
    fb30:	00470693          	addi	a3,a4,4
    fb34:	0a0796e3          	bnez	a5,103e0 <_svfiprintf_r+0x10c8>
    fb38:	040cf793          	andi	a5,s9,64
    fb3c:	72078663          	beqz	a5,10268 <_svfiprintf_r+0xf50>
    fb40:	00c12783          	lw	a5,12(sp)
    fb44:	00d12623          	sw	a3,12(sp)
    fb48:	000c8b13          	mv	s6,s9
    fb4c:	00079d83          	lh	s11,0(a5)
    fb50:	41fdd313          	srai	t1,s11,0x1f
    fb54:	00030693          	mv	a3,t1
    fb58:	d206d8e3          	bgez	a3,f888 <_svfiprintf_r+0x570>
    fb5c:	41b007b3          	neg	a5,s11
    fb60:	00f036b3          	snez	a3,a5
    fb64:	40600333          	neg	t1,t1
    fb68:	40d30333          	sub	t1,t1,a3
    fb6c:	02d00693          	li	a3,45
    fb70:	02d10da3          	sb	a3,59(sp)
    fb74:	fff00613          	li	a2,-1
    fb78:	00078d93          	mv	s11,a5
    fb7c:	00100693          	li	a3,1
    fb80:	a0cc18e3          	bne	s8,a2,f590 <_svfiprintf_r+0x278>
    fb84:	00100613          	li	a2,1
    fb88:	d0c68ce3          	beq	a3,a2,f8a0 <_svfiprintf_r+0x588>
    fb8c:	00200613          	li	a2,2
    fb90:	0ec68a63          	beq	a3,a2,fc84 <_svfiprintf_r+0x96c>
    fb94:	0f010613          	addi	a2,sp,240
    fb98:	0080006f          	j	fba0 <_svfiprintf_r+0x888>
    fb9c:	000b8613          	mv	a2,s7
    fba0:	01d31793          	slli	a5,t1,0x1d
    fba4:	007df693          	andi	a3,s11,7
    fba8:	003ddd93          	srli	s11,s11,0x3
    fbac:	03068693          	addi	a3,a3,48
    fbb0:	01b7edb3          	or	s11,a5,s11
    fbb4:	00335313          	srli	t1,t1,0x3
    fbb8:	fed60fa3          	sb	a3,-1(a2)
    fbbc:	006de7b3          	or	a5,s11,t1
    fbc0:	fff60b93          	addi	s7,a2,-1
    fbc4:	fc079ce3          	bnez	a5,fb9c <_svfiprintf_r+0x884>
    fbc8:	001b7793          	andi	a5,s6,1
    fbcc:	0e078663          	beqz	a5,fcb8 <_svfiprintf_r+0x9a0>
    fbd0:	03000793          	li	a5,48
    fbd4:	0ef68263          	beq	a3,a5,fcb8 <_svfiprintf_r+0x9a0>
    fbd8:	ffe60613          	addi	a2,a2,-2
    fbdc:	fefb8fa3          	sb	a5,-1(s7)
    fbe0:	0f010793          	addi	a5,sp,240
    fbe4:	40c78db3          	sub	s11,a5,a2
    fbe8:	000b0c93          	mv	s9,s6
    fbec:	00060b93          	mv	s7,a2
    fbf0:	9cdff06f          	j	f5bc <_svfiprintf_r+0x2a4>
    fbf4:	000c8813          	mv	a6,s9
    fbf8:	00c12783          	lw	a5,12(sp)
    fbfc:	00778693          	addi	a3,a5,7
    fc00:	ff86f693          	andi	a3,a3,-8
    fc04:	0006ad83          	lw	s11,0(a3)
    fc08:	0046a303          	lw	t1,4(a3)
    fc0c:	00868793          	addi	a5,a3,8
    fc10:	00f12623          	sw	a5,12(sp)
    fc14:	bff87b13          	andi	s6,a6,-1025
    fc18:	00000693          	li	a3,0
    fc1c:	969ff06f          	j	f584 <_svfiprintf_r+0x26c>
    fc20:	000c8b13          	mv	s6,s9
    fc24:	00c12783          	lw	a5,12(sp)
    fc28:	00778693          	addi	a3,a5,7
    fc2c:	ff86f693          	andi	a3,a3,-8
    fc30:	00868793          	addi	a5,a3,8
    fc34:	0006ad83          	lw	s11,0(a3)
    fc38:	0046a303          	lw	t1,4(a3)
    fc3c:	00f12623          	sw	a5,12(sp)
    fc40:	00100693          	li	a3,1
    fc44:	941ff06f          	j	f584 <_svfiprintf_r+0x26c>
    fc48:	000c8b13          	mv	s6,s9
    fc4c:	00c12783          	lw	a5,12(sp)
    fc50:	00778793          	addi	a5,a5,7
    fc54:	ff87f793          	andi	a5,a5,-8
    fc58:	0047a683          	lw	a3,4(a5)
    fc5c:	00878713          	addi	a4,a5,8
    fc60:	00e12623          	sw	a4,12(sp)
    fc64:	0007ad83          	lw	s11,0(a5)
    fc68:	00068313          	mv	t1,a3
    fc6c:	c19ff06f          	j	f884 <_svfiprintf_r+0x56c>
    fc70:	00100613          	li	a2,1
    fc74:	6ec68e63          	beq	a3,a2,10370 <_svfiprintf_r+0x1058>
    fc78:	00200613          	li	a2,2
    fc7c:	000c8b13          	mv	s6,s9
    fc80:	f0c69ae3          	bne	a3,a2,fb94 <_svfiprintf_r+0x87c>
    fc84:	01012683          	lw	a3,16(sp)
    fc88:	0f010b93          	addi	s7,sp,240
    fc8c:	00fdf793          	andi	a5,s11,15
    fc90:	00f687b3          	add	a5,a3,a5
    fc94:	0007c783          	lbu	a5,0(a5)
    fc98:	01c31713          	slli	a4,t1,0x1c
    fc9c:	004ddd93          	srli	s11,s11,0x4
    fca0:	fffb8b93          	addi	s7,s7,-1
    fca4:	01b76db3          	or	s11,a4,s11
    fca8:	00435313          	srli	t1,t1,0x4
    fcac:	00fb8023          	sb	a5,0(s7)
    fcb0:	006de7b3          	or	a5,s11,t1
    fcb4:	fc079ce3          	bnez	a5,fc8c <_svfiprintf_r+0x974>
    fcb8:	0f010793          	addi	a5,sp,240
    fcbc:	41778db3          	sub	s11,a5,s7
    fcc0:	000b0c93          	mv	s9,s6
    fcc4:	8f9ff06f          	j	f5bc <_svfiprintf_r+0x2a4>
    fcc8:	41690e33          	sub	t3,s2,s6
    fccc:	a1c056e3          	blez	t3,f6d8 <_svfiprintf_r+0x3c0>
    fcd0:	01000513          	li	a0,16
    fcd4:	6bc55a63          	bge	a0,t3,10388 <_svfiprintf_r+0x1070>
    fcd8:	00006317          	auipc	t1,0x6
    fcdc:	47830313          	addi	t1,t1,1144 # 16150 <zeroes.4467>
    fce0:	01212a23          	sw	s2,20(sp)
    fce4:	03612423          	sw	s6,40(sp)
    fce8:	01000693          	li	a3,16
    fcec:	00700e93          	li	t4,7
    fcf0:	000e0913          	mv	s2,t3
    fcf4:	00030b13          	mv	s6,t1
    fcf8:	00c0006f          	j	fd04 <_svfiprintf_r+0x9ec>
    fcfc:	ff090913          	addi	s2,s2,-16
    fd00:	0526da63          	bge	a3,s2,fd54 <_svfiprintf_r+0xa3c>
    fd04:	01078793          	addi	a5,a5,16
    fd08:	00160613          	addi	a2,a2,1
    fd0c:	01642023          	sw	s6,0(s0)
    fd10:	00d42223          	sw	a3,4(s0)
    fd14:	04f12423          	sw	a5,72(sp)
    fd18:	04c12223          	sw	a2,68(sp)
    fd1c:	00840413          	addi	s0,s0,8
    fd20:	fccedee3          	bge	t4,a2,fcfc <_svfiprintf_r+0x9e4>
    fd24:	04010613          	addi	a2,sp,64
    fd28:	00098593          	mv	a1,s3
    fd2c:	000a0513          	mv	a0,s4
    fd30:	c2cff0ef          	jal	ra,f15c <__ssprint_r>
    fd34:	fa051e63          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    fd38:	01000693          	li	a3,16
    fd3c:	ff090913          	addi	s2,s2,-16
    fd40:	04812783          	lw	a5,72(sp)
    fd44:	04412603          	lw	a2,68(sp)
    fd48:	00048413          	mv	s0,s1
    fd4c:	00700e93          	li	t4,7
    fd50:	fb26cae3          	blt	a3,s2,fd04 <_svfiprintf_r+0x9ec>
    fd54:	00090e13          	mv	t3,s2
    fd58:	000b0313          	mv	t1,s6
    fd5c:	01412903          	lw	s2,20(sp)
    fd60:	02812b03          	lw	s6,40(sp)
    fd64:	00160613          	addi	a2,a2,1
    fd68:	00840513          	addi	a0,s0,8
    fd6c:	01c787b3          	add	a5,a5,t3
    fd70:	00642023          	sw	t1,0(s0)
    fd74:	01c42223          	sw	t3,4(s0)
    fd78:	04f12423          	sw	a5,72(sp)
    fd7c:	04c12223          	sw	a2,68(sp)
    fd80:	00700693          	li	a3,7
    fd84:	44c6ce63          	blt	a3,a2,101e0 <_svfiprintf_r+0xec8>
    fd88:	41bc0c33          	sub	s8,s8,s11
    fd8c:	00160593          	addi	a1,a2,1
    fd90:	00850693          	addi	a3,a0,8
    fd94:	00050413          	mv	s0,a0
    fd98:	958054e3          	blez	s8,f6e0 <_svfiprintf_r+0x3c8>
    fd9c:	01000513          	li	a0,16
    fda0:	51855463          	bge	a0,s8,102a8 <_svfiprintf_r+0xf90>
    fda4:	00006317          	auipc	t1,0x6
    fda8:	3ac30313          	addi	t1,t1,940 # 16150 <zeroes.4467>
    fdac:	01212a23          	sw	s2,20(sp)
    fdb0:	01000693          	li	a3,16
    fdb4:	00700e13          	li	t3,7
    fdb8:	00030913          	mv	s2,t1
    fdbc:	00c0006f          	j	fdc8 <_svfiprintf_r+0xab0>
    fdc0:	ff0c0c13          	addi	s8,s8,-16
    fdc4:	0586da63          	bge	a3,s8,fe18 <_svfiprintf_r+0xb00>
    fdc8:	01078793          	addi	a5,a5,16
    fdcc:	00160613          	addi	a2,a2,1
    fdd0:	01242023          	sw	s2,0(s0)
    fdd4:	00d42223          	sw	a3,4(s0)
    fdd8:	04f12423          	sw	a5,72(sp)
    fddc:	04c12223          	sw	a2,68(sp)
    fde0:	00840413          	addi	s0,s0,8
    fde4:	fcce5ee3          	bge	t3,a2,fdc0 <_svfiprintf_r+0xaa8>
    fde8:	04010613          	addi	a2,sp,64
    fdec:	00098593          	mv	a1,s3
    fdf0:	000a0513          	mv	a0,s4
    fdf4:	b68ff0ef          	jal	ra,f15c <__ssprint_r>
    fdf8:	ee051c63          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    fdfc:	01000693          	li	a3,16
    fe00:	ff0c0c13          	addi	s8,s8,-16
    fe04:	04812783          	lw	a5,72(sp)
    fe08:	04412603          	lw	a2,68(sp)
    fe0c:	00048413          	mv	s0,s1
    fe10:	00700e13          	li	t3,7
    fe14:	fb86cae3          	blt	a3,s8,fdc8 <_svfiprintf_r+0xab0>
    fe18:	00090313          	mv	t1,s2
    fe1c:	01412903          	lw	s2,20(sp)
    fe20:	00160593          	addi	a1,a2,1
    fe24:	00840613          	addi	a2,s0,8
    fe28:	018787b3          	add	a5,a5,s8
    fe2c:	00642023          	sw	t1,0(s0)
    fe30:	01842223          	sw	s8,4(s0)
    fe34:	04f12423          	sw	a5,72(sp)
    fe38:	04b12223          	sw	a1,68(sp)
    fe3c:	00700693          	li	a3,7
    fe40:	20b6c063          	blt	a3,a1,10040 <_svfiprintf_r+0xd28>
    fe44:	00060413          	mv	s0,a2
    fe48:	00158593          	addi	a1,a1,1
    fe4c:	00fd87b3          	add	a5,s11,a5
    fe50:	00860693          	addi	a3,a2,8
    fe54:	01742023          	sw	s7,0(s0)
    fe58:	01b42223          	sw	s11,4(s0)
    fe5c:	04f12423          	sw	a5,72(sp)
    fe60:	04b12223          	sw	a1,68(sp)
    fe64:	00700613          	li	a2,7
    fe68:	88b65ae3          	bge	a2,a1,f6fc <_svfiprintf_r+0x3e4>
    fe6c:	04010613          	addi	a2,sp,64
    fe70:	00098593          	mv	a1,s3
    fe74:	000a0513          	mv	a0,s4
    fe78:	ae4ff0ef          	jal	ra,f15c <__ssprint_r>
    fe7c:	e6051a63          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    fe80:	04812783          	lw	a5,72(sp)
    fe84:	00048693          	mv	a3,s1
    fe88:	875ff06f          	j	f6fc <_svfiprintf_r+0x3e4>
    fe8c:	04010613          	addi	a2,sp,64
    fe90:	00098593          	mv	a1,s3
    fe94:	000a0513          	mv	a0,s4
    fe98:	ac4ff0ef          	jal	ra,f15c <__ssprint_r>
    fe9c:	880504e3          	beqz	a0,f724 <_svfiprintf_r+0x40c>
    fea0:	e50ff06f          	j	f4f0 <_svfiprintf_r+0x1d8>
    fea4:	000c8b13          	mv	s6,s9
    fea8:	cddff06f          	j	fb84 <_svfiprintf_r+0x86c>
    feac:	01000593          	li	a1,16
    feb0:	00006317          	auipc	t1,0x6
    feb4:	29030313          	addi	t1,t1,656 # 16140 <blanks.4466>
    feb8:	08d5dc63          	bge	a1,a3,ff50 <_svfiprintf_r+0xc38>
    febc:	03212623          	sw	s2,44(sp)
    fec0:	00040713          	mv	a4,s0
    fec4:	01000e13          	li	t3,16
    fec8:	00700f93          	li	t6,7
    fecc:	01e12a23          	sw	t5,20(sp)
    fed0:	03d12423          	sw	t4,40(sp)
    fed4:	00068413          	mv	s0,a3
    fed8:	00030913          	mv	s2,t1
    fedc:	00c0006f          	j	fee8 <_svfiprintf_r+0xbd0>
    fee0:	ff040413          	addi	s0,s0,-16
    fee4:	048e5a63          	bge	t3,s0,ff38 <_svfiprintf_r+0xc20>
    fee8:	01078793          	addi	a5,a5,16
    feec:	00160613          	addi	a2,a2,1
    fef0:	01272023          	sw	s2,0(a4)
    fef4:	01c72223          	sw	t3,4(a4)
    fef8:	04f12423          	sw	a5,72(sp)
    fefc:	04c12223          	sw	a2,68(sp)
    ff00:	00870713          	addi	a4,a4,8
    ff04:	fccfdee3          	bge	t6,a2,fee0 <_svfiprintf_r+0xbc8>
    ff08:	04010613          	addi	a2,sp,64
    ff0c:	00098593          	mv	a1,s3
    ff10:	000a0513          	mv	a0,s4
    ff14:	a48ff0ef          	jal	ra,f15c <__ssprint_r>
    ff18:	dc051c63          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    ff1c:	01000e13          	li	t3,16
    ff20:	ff040413          	addi	s0,s0,-16
    ff24:	04812783          	lw	a5,72(sp)
    ff28:	04412603          	lw	a2,68(sp)
    ff2c:	00048713          	mv	a4,s1
    ff30:	00700f93          	li	t6,7
    ff34:	fa8e4ae3          	blt	t3,s0,fee8 <_svfiprintf_r+0xbd0>
    ff38:	00090313          	mv	t1,s2
    ff3c:	01412f03          	lw	t5,20(sp)
    ff40:	02812e83          	lw	t4,40(sp)
    ff44:	02c12903          	lw	s2,44(sp)
    ff48:	00040693          	mv	a3,s0
    ff4c:	00070413          	mv	s0,a4
    ff50:	00d787b3          	add	a5,a5,a3
    ff54:	00160613          	addi	a2,a2,1
    ff58:	00d42223          	sw	a3,4(s0)
    ff5c:	00642023          	sw	t1,0(s0)
    ff60:	04f12423          	sw	a5,72(sp)
    ff64:	04c12223          	sw	a2,68(sp)
    ff68:	00700693          	li	a3,7
    ff6c:	00840413          	addi	s0,s0,8
    ff70:	ecc6de63          	bge	a3,a2,f64c <_svfiprintf_r+0x334>
    ff74:	04010613          	addi	a2,sp,64
    ff78:	00098593          	mv	a1,s3
    ff7c:	000a0513          	mv	a0,s4
    ff80:	03d12423          	sw	t4,40(sp)
    ff84:	01e12a23          	sw	t5,20(sp)
    ff88:	9d4ff0ef          	jal	ra,f15c <__ssprint_r>
    ff8c:	d6051263          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    ff90:	04812783          	lw	a5,72(sp)
    ff94:	04412603          	lw	a2,68(sp)
    ff98:	00048413          	mv	s0,s1
    ff9c:	02812e83          	lw	t4,40(sp)
    ffa0:	01412f03          	lw	t5,20(sp)
    ffa4:	ea8ff06f          	j	f64c <_svfiprintf_r+0x334>
    ffa8:	04010613          	addi	a2,sp,64
    ffac:	00098593          	mv	a1,s3
    ffb0:	000a0513          	mv	a0,s4
    ffb4:	03d12423          	sw	t4,40(sp)
    ffb8:	01e12a23          	sw	t5,20(sp)
    ffbc:	9a0ff0ef          	jal	ra,f15c <__ssprint_r>
    ffc0:	d2051863          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    ffc4:	04412603          	lw	a2,68(sp)
    ffc8:	04812783          	lw	a5,72(sp)
    ffcc:	05410693          	addi	a3,sp,84
    ffd0:	00160593          	addi	a1,a2,1
    ffd4:	00048413          	mv	s0,s1
    ffd8:	02812e83          	lw	t4,40(sp)
    ffdc:	01412f03          	lw	t5,20(sp)
    ffe0:	eb8ff06f          	j	f698 <_svfiprintf_r+0x380>
    ffe4:	04010613          	addi	a2,sp,64
    ffe8:	00098593          	mv	a1,s3
    ffec:	000a0513          	mv	a0,s4
    fff0:	01d12a23          	sw	t4,20(sp)
    fff4:	968ff0ef          	jal	ra,f15c <__ssprint_r>
    fff8:	ce051c63          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
    fffc:	04412603          	lw	a2,68(sp)
   10000:	04812783          	lw	a5,72(sp)
   10004:	05410693          	addi	a3,sp,84
   10008:	00160593          	addi	a1,a2,1
   1000c:	00048413          	mv	s0,s1
   10010:	01412e83          	lw	t4,20(sp)
   10014:	ebcff06f          	j	f6d0 <_svfiprintf_r+0x3b8>
   10018:	340c1c63          	bnez	s8,10370 <_svfiprintf_r+0x1058>
   1001c:	00000c13          	li	s8,0
   10020:	00000d93          	li	s11,0
   10024:	0f010b93          	addi	s7,sp,240
   10028:	d94ff06f          	j	f5bc <_svfiprintf_r+0x2a4>
   1002c:	200cf613          	andi	a2,s9,512
   10030:	30061e63          	bnez	a2,1034c <_svfiprintf_r+0x1034>
   10034:	00078d93          	mv	s11,a5
   10038:	00000313          	li	t1,0
   1003c:	d30ff06f          	j	f56c <_svfiprintf_r+0x254>
   10040:	04010613          	addi	a2,sp,64
   10044:	00098593          	mv	a1,s3
   10048:	000a0513          	mv	a0,s4
   1004c:	910ff0ef          	jal	ra,f15c <__ssprint_r>
   10050:	ca051063          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
   10054:	04412583          	lw	a1,68(sp)
   10058:	04812783          	lw	a5,72(sp)
   1005c:	05410693          	addi	a3,sp,84
   10060:	00158593          	addi	a1,a1,1
   10064:	00048413          	mv	s0,s1
   10068:	e78ff06f          	j	f6e0 <_svfiprintf_r+0x3c8>
   1006c:	000d0b13          	mv	s6,s10
   10070:	bb8ff06f          	j	f428 <_svfiprintf_r+0x110>
   10074:	01812783          	lw	a5,24(sp)
   10078:	000d4683          	lbu	a3,0(s10)
   1007c:	bc078463          	beqz	a5,f444 <_svfiprintf_r+0x12c>
   10080:	0007c783          	lbu	a5,0(a5)
   10084:	bc078063          	beqz	a5,f444 <_svfiprintf_r+0x12c>
   10088:	400cec93          	ori	s9,s9,1024
   1008c:	bb8ff06f          	j	f444 <_svfiprintf_r+0x12c>
   10090:	03000613          	li	a2,48
   10094:	002cec93          	ori	s9,s9,2
   10098:	02d10ea3          	sb	a3,61(sp)
   1009c:	02c10e23          	sb	a2,60(sp)
   100a0:	bffcfb13          	andi	s6,s9,-1025
   100a4:	00200693          	li	a3,2
   100a8:	cdcff06f          	j	f584 <_svfiprintf_r+0x26c>
   100ac:	00072783          	lw	a5,0(a4)
   100b0:	00812703          	lw	a4,8(sp)
   100b4:	00d12623          	sw	a3,12(sp)
   100b8:	41f75613          	srai	a2,a4,0x1f
   100bc:	00e7a023          	sw	a4,0(a5)
   100c0:	00c7a223          	sw	a2,4(a5)
   100c4:	af0ff06f          	j	f3b4 <_svfiprintf_r+0x9c>
   100c8:	000b8513          	mv	a0,s7
   100cc:	bacf10ef          	jal	ra,1478 <strlen>
   100d0:	00050d93          	mv	s11,a0
   100d4:	00000c13          	li	s8,0
   100d8:	ce4ff06f          	j	f5bc <_svfiprintf_r+0x2a4>
   100dc:	04000593          	li	a1,64
   100e0:	9b0f80ef          	jal	ra,8290 <_malloc_r>
   100e4:	00a9a023          	sw	a0,0(s3)
   100e8:	00a9a823          	sw	a0,16(s3)
   100ec:	2e050063          	beqz	a0,103cc <_svfiprintf_r+0x10b4>
   100f0:	04000793          	li	a5,64
   100f4:	00f9aa23          	sw	a5,20(s3)
   100f8:	a7cff06f          	j	f374 <_svfiprintf_r+0x5c>
   100fc:	0f010b93          	addi	s7,sp,240
   10100:	400b7793          	andi	a5,s6,1024
   10104:	01612a23          	sw	s6,20(sp)
   10108:	03212423          	sw	s2,40(sp)
   1010c:	02812623          	sw	s0,44(sp)
   10110:	000b8913          	mv	s2,s7
   10114:	00000c93          	li	s9,0
   10118:	000d0b93          	mv	s7,s10
   1011c:	01812403          	lw	s0,24(sp)
   10120:	00098d13          	mv	s10,s3
   10124:	00078b13          	mv	s6,a5
   10128:	00030993          	mv	s3,t1
   1012c:	0240006f          	j	10150 <_svfiprintf_r+0xe38>
   10130:	00a00613          	li	a2,10
   10134:	00000693          	li	a3,0
   10138:	000d8513          	mv	a0,s11
   1013c:	00098593          	mv	a1,s3
   10140:	6cc000ef          	jal	ra,1080c <__udivdi3>
   10144:	16098a63          	beqz	s3,102b8 <_svfiprintf_r+0xfa0>
   10148:	00050d93          	mv	s11,a0
   1014c:	00058993          	mv	s3,a1
   10150:	00a00613          	li	a2,10
   10154:	00000693          	li	a3,0
   10158:	000d8513          	mv	a0,s11
   1015c:	00098593          	mv	a1,s3
   10160:	34d000ef          	jal	ra,10cac <__umoddi3>
   10164:	03050513          	addi	a0,a0,48
   10168:	fea90fa3          	sb	a0,-1(s2)
   1016c:	001c8c93          	addi	s9,s9,1
   10170:	fff90913          	addi	s2,s2,-1
   10174:	fa0b0ee3          	beqz	s6,10130 <_svfiprintf_r+0xe18>
   10178:	00044703          	lbu	a4,0(s0)
   1017c:	fb971ae3          	bne	a4,s9,10130 <_svfiprintf_r+0xe18>
   10180:	0ff00793          	li	a5,255
   10184:	fafc86e3          	beq	s9,a5,10130 <_svfiprintf_r+0xe18>
   10188:	12099e63          	bnez	s3,102c4 <_svfiprintf_r+0xfac>
   1018c:	00900793          	li	a5,9
   10190:	13b7ea63          	bltu	a5,s11,102c4 <_svfiprintf_r+0xfac>
   10194:	01412b03          	lw	s6,20(sp)
   10198:	000d0993          	mv	s3,s10
   1019c:	0f010793          	addi	a5,sp,240
   101a0:	000b8d13          	mv	s10,s7
   101a4:	00090b93          	mv	s7,s2
   101a8:	00812c23          	sw	s0,24(sp)
   101ac:	02812903          	lw	s2,40(sp)
   101b0:	02c12403          	lw	s0,44(sp)
   101b4:	41778db3          	sub	s11,a5,s7
   101b8:	000b0c93          	mv	s9,s6
   101bc:	c00ff06f          	j	f5bc <_svfiprintf_r+0x2a4>
   101c0:	001d4683          	lbu	a3,1(s10)
   101c4:	200cec93          	ori	s9,s9,512
   101c8:	001d0d13          	addi	s10,s10,1
   101cc:	a78ff06f          	j	f444 <_svfiprintf_r+0x12c>
   101d0:	001d4683          	lbu	a3,1(s10)
   101d4:	020cec93          	ori	s9,s9,32
   101d8:	001d0d13          	addi	s10,s10,1
   101dc:	a68ff06f          	j	f444 <_svfiprintf_r+0x12c>
   101e0:	04010613          	addi	a2,sp,64
   101e4:	00098593          	mv	a1,s3
   101e8:	000a0513          	mv	a0,s4
   101ec:	f71fe0ef          	jal	ra,f15c <__ssprint_r>
   101f0:	b0051063          	bnez	a0,f4f0 <_svfiprintf_r+0x1d8>
   101f4:	04412603          	lw	a2,68(sp)
   101f8:	04812783          	lw	a5,72(sp)
   101fc:	05410693          	addi	a3,sp,84
   10200:	00160593          	addi	a1,a2,1
   10204:	00048413          	mv	s0,s1
   10208:	cd0ff06f          	j	f6d8 <_svfiprintf_r+0x3c0>
   1020c:	00c12783          	lw	a5,12(sp)
   10210:	00812703          	lw	a4,8(sp)
   10214:	0007a783          	lw	a5,0(a5)
   10218:	00d12623          	sw	a3,12(sp)
   1021c:	00e7a023          	sw	a4,0(a5)
   10220:	994ff06f          	j	f3b4 <_svfiprintf_r+0x9c>
   10224:	00600793          	li	a5,6
   10228:	000c0d93          	mv	s11,s8
   1022c:	0187f463          	bgeu	a5,s8,10234 <_svfiprintf_r+0xf1c>
   10230:	00600d93          	li	s11,6
   10234:	000d8b13          	mv	s6,s11
   10238:	00e12623          	sw	a4,12(sp)
   1023c:	00005b97          	auipc	s7,0x5
   10240:	584b8b93          	addi	s7,s7,1412 # 157c0 <_data+0x4a8>
   10244:	be0ff06f          	j	f624 <_svfiprintf_r+0x30c>
   10248:	200cf613          	andi	a2,s9,512
   1024c:	0e060463          	beqz	a2,10334 <_svfiprintf_r+0x101c>
   10250:	00d12623          	sw	a3,12(sp)
   10254:	0ff7fd93          	andi	s11,a5,255
   10258:	00000313          	li	t1,0
   1025c:	000c8b13          	mv	s6,s9
   10260:	00100693          	li	a3,1
   10264:	b20ff06f          	j	f584 <_svfiprintf_r+0x26c>
   10268:	200cf793          	andi	a5,s9,512
   1026c:	0a078663          	beqz	a5,10318 <_svfiprintf_r+0x1000>
   10270:	00c12783          	lw	a5,12(sp)
   10274:	000c8b13          	mv	s6,s9
   10278:	00d12623          	sw	a3,12(sp)
   1027c:	00078d83          	lb	s11,0(a5)
   10280:	41fdd313          	srai	t1,s11,0x1f
   10284:	00030693          	mv	a3,t1
   10288:	dfcff06f          	j	f884 <_svfiprintf_r+0x56c>
   1028c:	200cf613          	andi	a2,s9,512
   10290:	06060a63          	beqz	a2,10304 <_svfiprintf_r+0xfec>
   10294:	0ff7fd93          	andi	s11,a5,255
   10298:	00000313          	li	t1,0
   1029c:	000c8813          	mv	a6,s9
   102a0:	00d12623          	sw	a3,12(sp)
   102a4:	971ff06f          	j	fc14 <_svfiprintf_r+0x8fc>
   102a8:	00068613          	mv	a2,a3
   102ac:	00006317          	auipc	t1,0x6
   102b0:	ea430313          	addi	t1,t1,-348 # 16150 <zeroes.4467>
   102b4:	b75ff06f          	j	fe28 <_svfiprintf_r+0xb10>
   102b8:	00900793          	li	a5,9
   102bc:	e9b7e6e3          	bltu	a5,s11,10148 <_svfiprintf_r+0xe30>
   102c0:	ed5ff06f          	j	10194 <_svfiprintf_r+0xe7c>
   102c4:	02012783          	lw	a5,32(sp)
   102c8:	01c12583          	lw	a1,28(sp)
   102cc:	00000c93          	li	s9,0
   102d0:	40f90933          	sub	s2,s2,a5
   102d4:	00078613          	mv	a2,a5
   102d8:	00090513          	mv	a0,s2
   102dc:	ed8fa0ef          	jal	ra,a9b4 <strncpy>
   102e0:	00144703          	lbu	a4,1(s0)
   102e4:	00a00613          	li	a2,10
   102e8:	00000693          	li	a3,0
   102ec:	00e03733          	snez	a4,a4
   102f0:	000d8513          	mv	a0,s11
   102f4:	00098593          	mv	a1,s3
   102f8:	00e40433          	add	s0,s0,a4
   102fc:	510000ef          	jal	ra,1080c <__udivdi3>
   10300:	e49ff06f          	j	10148 <_svfiprintf_r+0xe30>
   10304:	00078d93          	mv	s11,a5
   10308:	00000313          	li	t1,0
   1030c:	000c8813          	mv	a6,s9
   10310:	00d12623          	sw	a3,12(sp)
   10314:	901ff06f          	j	fc14 <_svfiprintf_r+0x8fc>
   10318:	00c12783          	lw	a5,12(sp)
   1031c:	000c8b13          	mv	s6,s9
   10320:	00d12623          	sw	a3,12(sp)
   10324:	0007ad83          	lw	s11,0(a5)
   10328:	41fdd313          	srai	t1,s11,0x1f
   1032c:	00030693          	mv	a3,t1
   10330:	d54ff06f          	j	f884 <_svfiprintf_r+0x56c>
   10334:	00d12623          	sw	a3,12(sp)
   10338:	00078d93          	mv	s11,a5
   1033c:	00000313          	li	t1,0
   10340:	000c8b13          	mv	s6,s9
   10344:	00100693          	li	a3,1
   10348:	a3cff06f          	j	f584 <_svfiprintf_r+0x26c>
   1034c:	0ff7fd93          	andi	s11,a5,255
   10350:	00000313          	li	t1,0
   10354:	a18ff06f          	j	f56c <_svfiprintf_r+0x254>
   10358:	00c12783          	lw	a5,12(sp)
   1035c:	00812703          	lw	a4,8(sp)
   10360:	00d12623          	sw	a3,12(sp)
   10364:	0007a783          	lw	a5,0(a5)
   10368:	00e79023          	sh	a4,0(a5)
   1036c:	848ff06f          	j	f3b4 <_svfiprintf_r+0x9c>
   10370:	000c8b13          	mv	s6,s9
   10374:	d38ff06f          	j	f8ac <_svfiprintf_r+0x594>
   10378:	000c0d93          	mv	s11,s8
   1037c:	00e12623          	sw	a4,12(sp)
   10380:	00000c13          	li	s8,0
   10384:	a38ff06f          	j	f5bc <_svfiprintf_r+0x2a4>
   10388:	00068513          	mv	a0,a3
   1038c:	00058613          	mv	a2,a1
   10390:	00006317          	auipc	t1,0x6
   10394:	dc030313          	addi	t1,t1,-576 # 16150 <zeroes.4467>
   10398:	9d5ff06f          	j	fd6c <_svfiprintf_r+0xa54>
   1039c:	fff00793          	li	a5,-1
   103a0:	00f12423          	sw	a5,8(sp)
   103a4:	958ff06f          	j	f4fc <_svfiprintf_r+0x1e4>
   103a8:	00c12703          	lw	a4,12(sp)
   103ac:	00072c03          	lw	s8,0(a4)
   103b0:	00470713          	addi	a4,a4,4
   103b4:	000c5463          	bgez	s8,103bc <_svfiprintf_r+0x10a4>
   103b8:	fff00c13          	li	s8,-1
   103bc:	001d4683          	lbu	a3,1(s10)
   103c0:	00e12623          	sw	a4,12(sp)
   103c4:	00078d13          	mv	s10,a5
   103c8:	87cff06f          	j	f444 <_svfiprintf_r+0x12c>
   103cc:	00c00793          	li	a5,12
   103d0:	00fa2023          	sw	a5,0(s4)
   103d4:	fff00793          	li	a5,-1
   103d8:	00f12423          	sw	a5,8(sp)
   103dc:	920ff06f          	j	f4fc <_svfiprintf_r+0x1e4>
   103e0:	000c8b13          	mv	s6,s9
   103e4:	c8cff06f          	j	f870 <_svfiprintf_r+0x558>
   103e8:	000c8813          	mv	a6,s9
   103ec:	b9cff06f          	j	f788 <_svfiprintf_r+0x470>
   103f0:	000c8b13          	mv	s6,s9
   103f4:	bbcff06f          	j	f7b0 <_svfiprintf_r+0x498>

000103f8 <_wcrtomb_r>:
   103f8:	fe010113          	addi	sp,sp,-32
   103fc:	00812c23          	sw	s0,24(sp)
   10400:	00912a23          	sw	s1,20(sp)
   10404:	00006797          	auipc	a5,0x6
   10408:	34478793          	addi	a5,a5,836 # 16748 <__global_locale>
   1040c:	00112e23          	sw	ra,28(sp)
   10410:	00050413          	mv	s0,a0
   10414:	00068493          	mv	s1,a3
   10418:	0e07a783          	lw	a5,224(a5)
   1041c:	02058263          	beqz	a1,10440 <_wcrtomb_r+0x48>
   10420:	000780e7          	jalr	a5
   10424:	fff00793          	li	a5,-1
   10428:	02f50663          	beq	a0,a5,10454 <_wcrtomb_r+0x5c>
   1042c:	01c12083          	lw	ra,28(sp)
   10430:	01812403          	lw	s0,24(sp)
   10434:	01412483          	lw	s1,20(sp)
   10438:	02010113          	addi	sp,sp,32
   1043c:	00008067          	ret
   10440:	00000613          	li	a2,0
   10444:	00410593          	addi	a1,sp,4
   10448:	000780e7          	jalr	a5
   1044c:	fff00793          	li	a5,-1
   10450:	fcf51ee3          	bne	a0,a5,1042c <_wcrtomb_r+0x34>
   10454:	0004a023          	sw	zero,0(s1)
   10458:	08a00793          	li	a5,138
   1045c:	00f42023          	sw	a5,0(s0)
   10460:	01c12083          	lw	ra,28(sp)
   10464:	01812403          	lw	s0,24(sp)
   10468:	01412483          	lw	s1,20(sp)
   1046c:	02010113          	addi	sp,sp,32
   10470:	00008067          	ret

00010474 <wcrtomb>:
   10474:	fe010113          	addi	sp,sp,-32
   10478:	81018793          	addi	a5,gp,-2032 # 16cc0 <_impure_ptr>
   1047c:	00812c23          	sw	s0,24(sp)
   10480:	00912a23          	sw	s1,20(sp)
   10484:	0007a403          	lw	s0,0(a5)
   10488:	00112e23          	sw	ra,28(sp)
   1048c:	00006797          	auipc	a5,0x6
   10490:	2bc78793          	addi	a5,a5,700 # 16748 <__global_locale>
   10494:	00060493          	mv	s1,a2
   10498:	0e07a783          	lw	a5,224(a5)
   1049c:	00060693          	mv	a3,a2
   104a0:	02050863          	beqz	a0,104d0 <wcrtomb+0x5c>
   104a4:	00058613          	mv	a2,a1
   104a8:	00050593          	mv	a1,a0
   104ac:	00040513          	mv	a0,s0
   104b0:	000780e7          	jalr	a5
   104b4:	fff00793          	li	a5,-1
   104b8:	02f50863          	beq	a0,a5,104e8 <wcrtomb+0x74>
   104bc:	01c12083          	lw	ra,28(sp)
   104c0:	01812403          	lw	s0,24(sp)
   104c4:	01412483          	lw	s1,20(sp)
   104c8:	02010113          	addi	sp,sp,32
   104cc:	00008067          	ret
   104d0:	00000613          	li	a2,0
   104d4:	00410593          	addi	a1,sp,4
   104d8:	00040513          	mv	a0,s0
   104dc:	000780e7          	jalr	a5
   104e0:	fff00793          	li	a5,-1
   104e4:	fcf51ce3          	bne	a0,a5,104bc <wcrtomb+0x48>
   104e8:	0004a023          	sw	zero,0(s1)
   104ec:	08a00793          	li	a5,138
   104f0:	00f42023          	sw	a5,0(s0)
   104f4:	01c12083          	lw	ra,28(sp)
   104f8:	01812403          	lw	s0,24(sp)
   104fc:	01412483          	lw	s1,20(sp)
   10500:	02010113          	addi	sp,sp,32
   10504:	00008067          	ret

00010508 <mdio_read>:
uint16_t mdio_read(uint8_t phy_addr, uint8_t reg_addr) {
    volatile uint32_t *ctrl   = (uint32_t *)MDIO_CTRL;
    volatile uint32_t *status = (uint32_t *)MDIO_STATUS;
    
    // Build control word: [31:16]=0, [15]=0, [14:10]=reg_addr, [9:5]=phy_addr, [4:2]=0, [1]=1 (READ), [0]=1 (START)
    uint32_t cmd = ((reg_addr & 0x1F) << 10) | ((phy_addr & 0x1F) << 5) | 0x03;
   10508:	00a59593          	slli	a1,a1,0xa
   1050c:	000087b7          	lui	a5,0x8
   10510:	c0078793          	addi	a5,a5,-1024 # 7c00 <_ldtoa_r+0xf74>
   10514:	00f5f5b3          	and	a1,a1,a5
   10518:	00551513          	slli	a0,a0,0x5
   1051c:	3e057513          	andi	a0,a0,992
   10520:	00a5e5b3          	or	a1,a1,a0
   10524:	0035e593          	ori	a1,a1,3
    
    // Write command
    *ctrl = cmd;
   10528:	800107b7          	lui	a5,0x80010
   1052c:	00b7a023          	sw	a1,0(a5) # 80010000 <__freertos_irq_stack_top+0x7fff82e0>
    
    // Wait for DONE bit
    int timeout = 10000;
   10530:	00002737          	lui	a4,0x2
   10534:	71070713          	addi	a4,a4,1808 # 2710 <_vfprintf_r+0x120c>
    while (timeout-- > 0) {
   10538:	fff70693          	addi	a3,a4,-1
   1053c:	00e05c63          	blez	a4,10554 <mdio_read+0x4c>
        if (*status & 0x02) {  // DONE bit [1]
   10540:	800107b7          	lui	a5,0x80010
   10544:	0047a783          	lw	a5,4(a5) # 80010004 <__freertos_irq_stack_top+0x7fff82e4>
   10548:	0027f793          	andi	a5,a5,2
    while (timeout-- > 0) {
   1054c:	00068713          	mv	a4,a3
        if (*status & 0x02) {  // DONE bit [1]
   10550:	fe0784e3          	beqz	a5,10538 <mdio_read+0x30>
            break;
        }
    }
    
    // Read data from STATUS[31:16]
    uint16_t rdata = (*status >> 16) & 0xFFFF;
   10554:	800107b7          	lui	a5,0x80010
   10558:	0047a503          	lw	a0,4(a5) # 80010004 <__freertos_irq_stack_top+0x7fff82e4>
    
    // Clear DONE bit by writing 0x02 to status
    *status = 0x02;
   1055c:	00200713          	li	a4,2
   10560:	00e7a223          	sw	a4,4(a5)
    
    return rdata;
}
   10564:	01055513          	srli	a0,a0,0x10
   10568:	00008067          	ret

0001056c <test_ddram3>:

// Function to test DDRAM3
int test_ddram3() {
   1056c:	ff010113          	addi	sp,sp,-16
   10570:	00112623          	sw	ra,12(sp)
   10574:	00812423          	sw	s0,8(sp)
   10578:	00912223          	sw	s1,4(sp)
    printf("\n========== DDRAM3 TEST ==========\n");
   1057c:	00015537          	lui	a0,0x15
   10580:	31850513          	addi	a0,a0,792 # 15318 <_data>
   10584:	ee5f00ef          	jal	ra,1468 <puts>
    
    volatile uint32_t *dram = (uint32_t *)DDRAM_BASE;
    uint32_t test_pattern = 0xDEADBEEF;
    
    // Write test pattern
    *dram = test_pattern;
   10588:	800004b7          	lui	s1,0x80000
   1058c:	deadc437          	lui	s0,0xdeadc
   10590:	eef40413          	addi	s0,s0,-273 # deadbeef <__freertos_irq_stack_top+0xdeac41cf>
   10594:	0084a023          	sw	s0,0(s1) # 80000000 <__freertos_irq_stack_top+0x7ffe82e0>
    printf("Wrote: 0x%08X to 0x%08X\n", test_pattern, DDRAM_BASE);
   10598:	80000637          	lui	a2,0x80000
   1059c:	00040593          	mv	a1,s0
   105a0:	00015537          	lui	a0,0x15
   105a4:	33c50513          	addi	a0,a0,828 # 1533c <_data+0x24>
   105a8:	c45f00ef          	jal	ra,11ec <printf>
    
    // Read back
    uint32_t readback = *dram;
   105ac:	0004a483          	lw	s1,0(s1)
    printf("Read:  0x%08X from 0x%08X\n", readback, DDRAM_BASE);
   105b0:	80000637          	lui	a2,0x80000
   105b4:	00048593          	mv	a1,s1
   105b8:	00015537          	lui	a0,0x15
   105bc:	35850513          	addi	a0,a0,856 # 15358 <_data+0x40>
   105c0:	c2df00ef          	jal	ra,11ec <printf>
    
    if (readback == test_pattern) {
   105c4:	02848a63          	beq	s1,s0,105f8 <test_ddram3+0x8c>
        printf("DDRAM3: PASS ✓\n");
        return 1;
    } else {
        printf("DDRAM3: FAIL ✗ (expected 0x%08X, got 0x%08X)\n", test_pattern, readback);
   105c8:	00048613          	mv	a2,s1
   105cc:	deadc5b7          	lui	a1,0xdeadc
   105d0:	eef58593          	addi	a1,a1,-273 # deadbeef <__freertos_irq_stack_top+0xdeac41cf>
   105d4:	00015537          	lui	a0,0x15
   105d8:	38850513          	addi	a0,a0,904 # 15388 <_data+0x70>
   105dc:	c11f00ef          	jal	ra,11ec <printf>
        return 0;
   105e0:	00000513          	li	a0,0
    }
}
   105e4:	00c12083          	lw	ra,12(sp)
   105e8:	00812403          	lw	s0,8(sp)
   105ec:	00412483          	lw	s1,4(sp)
   105f0:	01010113          	addi	sp,sp,16
   105f4:	00008067          	ret
        printf("DDRAM3: PASS ✓\n");
   105f8:	00015537          	lui	a0,0x15
   105fc:	37450513          	addi	a0,a0,884 # 15374 <_data+0x5c>
   10600:	e69f00ef          	jal	ra,1468 <puts>
        return 1;
   10604:	00100513          	li	a0,1
   10608:	fddff06f          	j	105e4 <test_ddram3+0x78>

0001060c <main>:

int main(int argc, char **argv) {
   1060c:	ff010113          	addi	sp,sp,-16
   10610:	00112623          	sw	ra,12(sp)
   10614:	00812423          	sw	s0,8(sp)
   10618:	00912223          	sw	s1,4(sp)
   1061c:	01212023          	sw	s2,0(sp)
    printf("\n");
   10620:	00a00513          	li	a0,10
   10624:	c25f00ef          	jal	ra,1248 <putchar>
    printf("================================\n");
   10628:	00015437          	lui	s0,0x15
   1062c:	3d440513          	addi	a0,s0,980 # 153d4 <_data+0xbc>
   10630:	e39f00ef          	jal	ra,1468 <puts>
    printf("  Efinix T120F324 PHY Bringup  \n");
   10634:	00015537          	lui	a0,0x15
   10638:	3f850513          	addi	a0,a0,1016 # 153f8 <_data+0xe0>
   1063c:	e2df00ef          	jal	ra,1468 <puts>
    printf("  MDIO + DDRAM3 Test            \n");
   10640:	00015537          	lui	a0,0x15
   10644:	41850513          	addi	a0,a0,1048 # 15418 <_data+0x100>
   10648:	e21f00ef          	jal	ra,1468 <puts>
    printf("================================\n");
   1064c:	3d440513          	addi	a0,s0,980
   10650:	e19f00ef          	jal	ra,1468 <puts>
    
    // Test PHYID1 (register 0x02)
    printf("\n========== MDIO TEST ==========\n");
   10654:	00015537          	lui	a0,0x15
   10658:	43c50513          	addi	a0,a0,1084 # 1543c <_data+0x124>
   1065c:	e0df00ef          	jal	ra,1468 <puts>
    printf("Reading PHYID1 (reg 0x02, PHY 0x01)...\n");
   10660:	00015537          	lui	a0,0x15
   10664:	46050513          	addi	a0,a0,1120 # 15460 <_data+0x148>
   10668:	e01f00ef          	jal	ra,1468 <puts>
    uint16_t phyid1 = mdio_read(0x01, 0x02);
   1066c:	00200593          	li	a1,2
   10670:	00100513          	li	a0,1
   10674:	e95ff0ef          	jal	ra,10508 <mdio_read>
   10678:	00050913          	mv	s2,a0
    printf("PHYID1: 0x%04X\n", phyid1);
   1067c:	00050593          	mv	a1,a0
   10680:	00015537          	lui	a0,0x15
   10684:	48850513          	addi	a0,a0,1160 # 15488 <_data+0x170>
   10688:	b65f00ef          	jal	ra,11ec <printf>
    if (phyid1 == 0x001C) {
   1068c:	01c00793          	li	a5,28
   10690:	12f90663          	beq	s2,a5,107bc <main+0x1b0>
        printf("PHYID1: PASS ✓ (RTL8211F detected)\n");
    } else {
        printf("PHYID1: FAIL ✗ (expected 0x001C)\n");
   10694:	00015537          	lui	a0,0x15
   10698:	4c050513          	addi	a0,a0,1216 # 154c0 <_data+0x1a8>
   1069c:	dcdf00ef          	jal	ra,1468 <puts>
    }
    
    // Test PHYID2 (register 0x03)
    printf("\nReading PHYID2 (reg 0x03, PHY 0x01)...\n");
   106a0:	00015537          	lui	a0,0x15
   106a4:	4e450513          	addi	a0,a0,1252 # 154e4 <_data+0x1cc>
   106a8:	dc1f00ef          	jal	ra,1468 <puts>
    uint16_t phyid2 = mdio_read(0x01, 0x03);
   106ac:	00300593          	li	a1,3
   106b0:	00100513          	li	a0,1
   106b4:	e55ff0ef          	jal	ra,10508 <mdio_read>
   106b8:	00050493          	mv	s1,a0
    printf("PHYID2: 0x%04X\n", phyid2);
   106bc:	00050593          	mv	a1,a0
   106c0:	00015537          	lui	a0,0x15
   106c4:	50c50513          	addi	a0,a0,1292 # 1550c <_data+0x1f4>
   106c8:	b25f00ef          	jal	ra,11ec <printf>
    if (phyid2 == 0xC916) {
   106cc:	0000d7b7          	lui	a5,0xd
   106d0:	91678793          	addi	a5,a5,-1770 # c916 <_svfprintf_r+0x1e96>
   106d4:	0ef48c63          	beq	s1,a5,107cc <main+0x1c0>
        printf("PHYID2: PASS ✓ (RTL8211F detected)\n");
    } else {
        printf("PHYID2: FAIL ✗ (expected 0xC916)\n");
   106d8:	00015537          	lui	a0,0x15
   106dc:	54450513          	addi	a0,a0,1348 # 15544 <_data+0x22c>
   106e0:	d89f00ef          	jal	ra,1468 <puts>
    }
    
    // Test Status Register (register 0x01)
    printf("\nReading Status (reg 0x01, PHY 0x01)...\n");
   106e4:	00015537          	lui	a0,0x15
   106e8:	56850513          	addi	a0,a0,1384 # 15568 <_data+0x250>
   106ec:	d7df00ef          	jal	ra,1468 <puts>
    uint16_t status = mdio_read(0x01, 0x01);
   106f0:	00100593          	li	a1,1
   106f4:	00100513          	li	a0,1
   106f8:	e11ff0ef          	jal	ra,10508 <mdio_read>
   106fc:	00050413          	mv	s0,a0
    printf("STATUS: 0x%04X\n", status);
   10700:	00050593          	mv	a1,a0
   10704:	00015537          	lui	a0,0x15
   10708:	59050513          	addi	a0,a0,1424 # 15590 <_data+0x278>
   1070c:	ae1f00ef          	jal	ra,11ec <printf>
    printf("  Link Status: %s\n", (status & 0x0004) ? "UP" : "DOWN");
   10710:	00447413          	andi	s0,s0,4
   10714:	0c040463          	beqz	s0,107dc <main+0x1d0>
   10718:	000155b7          	lui	a1,0x15
   1071c:	3c058593          	addi	a1,a1,960 # 153c0 <_data+0xa8>
   10720:	00015537          	lui	a0,0x15
   10724:	5a050513          	addi	a0,a0,1440 # 155a0 <_data+0x288>
   10728:	ac5f00ef          	jal	ra,11ec <printf>
    
    // Test DDRAM3
    int ddram_ok = test_ddram3();
   1072c:	e41ff0ef          	jal	ra,1056c <test_ddram3>
   10730:	00050413          	mv	s0,a0
    
    // Summary
    printf("\n========== SUMMARY ==========\n");
   10734:	00015537          	lui	a0,0x15
   10738:	5b450513          	addi	a0,a0,1460 # 155b4 <_data+0x29c>
   1073c:	d2df00ef          	jal	ra,1468 <puts>
    printf("PHYID1: %s\n", (phyid1 == 0x001C) ? "PASS" : "FAIL");
   10740:	01c00793          	li	a5,28
   10744:	0af90263          	beq	s2,a5,107e8 <main+0x1dc>
   10748:	000155b7          	lui	a1,0x15
   1074c:	3c458593          	addi	a1,a1,964 # 153c4 <_data+0xac>
   10750:	00015537          	lui	a0,0x15
   10754:	5d450513          	addi	a0,a0,1492 # 155d4 <_data+0x2bc>
   10758:	a95f00ef          	jal	ra,11ec <printf>
    printf("PHYID2: %s\n", (phyid2 == 0xC916) ? "PASS" : "FAIL");
   1075c:	0000d7b7          	lui	a5,0xd
   10760:	91678793          	addi	a5,a5,-1770 # c916 <_svfprintf_r+0x1e96>
   10764:	08f48863          	beq	s1,a5,107f4 <main+0x1e8>
   10768:	000155b7          	lui	a1,0x15
   1076c:	3c458593          	addi	a1,a1,964 # 153c4 <_data+0xac>
   10770:	00015537          	lui	a0,0x15
   10774:	5e050513          	addi	a0,a0,1504 # 155e0 <_data+0x2c8>
   10778:	a75f00ef          	jal	ra,11ec <printf>
    printf("DDRAM3: %s\n", ddram_ok ? "PASS" : "FAIL");
   1077c:	08040263          	beqz	s0,10800 <main+0x1f4>
   10780:	000155b7          	lui	a1,0x15
   10784:	3cc58593          	addi	a1,a1,972 # 153cc <_data+0xb4>
   10788:	00015537          	lui	a0,0x15
   1078c:	5ec50513          	addi	a0,a0,1516 # 155ec <_data+0x2d4>
   10790:	a5df00ef          	jal	ra,11ec <printf>
    printf("=============================\n\n");
   10794:	00015537          	lui	a0,0x15
   10798:	5f850513          	addi	a0,a0,1528 # 155f8 <_data+0x2e0>
   1079c:	ccdf00ef          	jal	ra,1468 <puts>
    
    return 0;
}
   107a0:	00000513          	li	a0,0
   107a4:	00c12083          	lw	ra,12(sp)
   107a8:	00812403          	lw	s0,8(sp)
   107ac:	00412483          	lw	s1,4(sp)
   107b0:	00012903          	lw	s2,0(sp)
   107b4:	01010113          	addi	sp,sp,16
   107b8:	00008067          	ret
        printf("PHYID1: PASS ✓ (RTL8211F detected)\n");
   107bc:	00015537          	lui	a0,0x15
   107c0:	49850513          	addi	a0,a0,1176 # 15498 <_data+0x180>
   107c4:	ca5f00ef          	jal	ra,1468 <puts>
   107c8:	ed9ff06f          	j	106a0 <main+0x94>
        printf("PHYID2: PASS ✓ (RTL8211F detected)\n");
   107cc:	00015537          	lui	a0,0x15
   107d0:	51c50513          	addi	a0,a0,1308 # 1551c <_data+0x204>
   107d4:	c95f00ef          	jal	ra,1468 <puts>
   107d8:	f0dff06f          	j	106e4 <main+0xd8>
    printf("  Link Status: %s\n", (status & 0x0004) ? "UP" : "DOWN");
   107dc:	000155b7          	lui	a1,0x15
   107e0:	3b858593          	addi	a1,a1,952 # 153b8 <_data+0xa0>
   107e4:	f3dff06f          	j	10720 <main+0x114>
    printf("PHYID1: %s\n", (phyid1 == 0x001C) ? "PASS" : "FAIL");
   107e8:	000155b7          	lui	a1,0x15
   107ec:	3cc58593          	addi	a1,a1,972 # 153cc <_data+0xb4>
   107f0:	f61ff06f          	j	10750 <main+0x144>
    printf("PHYID2: %s\n", (phyid2 == 0xC916) ? "PASS" : "FAIL");
   107f4:	000155b7          	lui	a1,0x15
   107f8:	3cc58593          	addi	a1,a1,972 # 153cc <_data+0xb4>
   107fc:	f75ff06f          	j	10770 <main+0x164>
    printf("DDRAM3: %s\n", ddram_ok ? "PASS" : "FAIL");
   10800:	000155b7          	lui	a1,0x15
   10804:	3c458593          	addi	a1,a1,964 # 153c4 <_data+0xac>
   10808:	f81ff06f          	j	10788 <main+0x17c>

0001080c <__udivdi3>:
   1080c:	00068793          	mv	a5,a3
   10810:	00060893          	mv	a7,a2
   10814:	00050313          	mv	t1,a0
   10818:	00058813          	mv	a6,a1
   1081c:	1a069663          	bnez	a3,109c8 <__udivdi3+0x1bc>
   10820:	0cc5fc63          	bgeu	a1,a2,108f8 <__udivdi3+0xec>
   10824:	00010737          	lui	a4,0x10
   10828:	22e66463          	bltu	a2,a4,10a50 <__udivdi3+0x244>
   1082c:	010007b7          	lui	a5,0x1000
   10830:	40f66a63          	bltu	a2,a5,10c44 <__udivdi3+0x438>
   10834:	01865693          	srli	a3,a2,0x18
   10838:	01800793          	li	a5,24
   1083c:	00006717          	auipc	a4,0x6
   10840:	9e470713          	addi	a4,a4,-1564 # 16220 <__clz_tab>
   10844:	00d70733          	add	a4,a4,a3
   10848:	00074703          	lbu	a4,0(a4)
   1084c:	00f707b3          	add	a5,a4,a5
   10850:	02000713          	li	a4,32
   10854:	40f70733          	sub	a4,a4,a5
   10858:	00070c63          	beqz	a4,10870 <__udivdi3+0x64>
   1085c:	00e59833          	sll	a6,a1,a4
   10860:	00f557b3          	srl	a5,a0,a5
   10864:	00e618b3          	sll	a7,a2,a4
   10868:	0107e833          	or	a6,a5,a6
   1086c:	00e51333          	sll	t1,a0,a4
   10870:	0108d613          	srli	a2,a7,0x10
   10874:	02c85533          	divu	a0,a6,a2
   10878:	01089693          	slli	a3,a7,0x10
   1087c:	0106d693          	srli	a3,a3,0x10
   10880:	01035793          	srli	a5,t1,0x10
   10884:	02c87733          	remu	a4,a6,a2
   10888:	02a685b3          	mul	a1,a3,a0
   1088c:	01071713          	slli	a4,a4,0x10
   10890:	00f76833          	or	a6,a4,a5
   10894:	00b87c63          	bgeu	a6,a1,108ac <__udivdi3+0xa0>
   10898:	01180833          	add	a6,a6,a7
   1089c:	fff50793          	addi	a5,a0,-1
   108a0:	01186463          	bltu	a6,a7,108a8 <__udivdi3+0x9c>
   108a4:	3eb86863          	bltu	a6,a1,10c94 <__udivdi3+0x488>
   108a8:	00078513          	mv	a0,a5
   108ac:	40b80833          	sub	a6,a6,a1
   108b0:	02c85733          	divu	a4,a6,a2
   108b4:	01031313          	slli	t1,t1,0x10
   108b8:	01035313          	srli	t1,t1,0x10
   108bc:	02c87833          	remu	a6,a6,a2
   108c0:	02e686b3          	mul	a3,a3,a4
   108c4:	01081813          	slli	a6,a6,0x10
   108c8:	00686833          	or	a6,a6,t1
   108cc:	00d87e63          	bgeu	a6,a3,108e8 <__udivdi3+0xdc>
   108d0:	01088833          	add	a6,a7,a6
   108d4:	fff70793          	addi	a5,a4,-1
   108d8:	01186663          	bltu	a6,a7,108e4 <__udivdi3+0xd8>
   108dc:	ffe70713          	addi	a4,a4,-2
   108e0:	00d86463          	bltu	a6,a3,108e8 <__udivdi3+0xdc>
   108e4:	00078713          	mv	a4,a5
   108e8:	01051513          	slli	a0,a0,0x10
   108ec:	00e56533          	or	a0,a0,a4
   108f0:	00000593          	li	a1,0
   108f4:	00008067          	ret
   108f8:	00061663          	bnez	a2,10904 <__udivdi3+0xf8>
   108fc:	00100713          	li	a4,1
   10900:	02c758b3          	divu	a7,a4,a2
   10904:	00010737          	lui	a4,0x10
   10908:	12e8e863          	bltu	a7,a4,10a38 <__udivdi3+0x22c>
   1090c:	010007b7          	lui	a5,0x1000
   10910:	34f8e063          	bltu	a7,a5,10c50 <__udivdi3+0x444>
   10914:	0188d693          	srli	a3,a7,0x18
   10918:	01800793          	li	a5,24
   1091c:	00006717          	auipc	a4,0x6
   10920:	90470713          	addi	a4,a4,-1788 # 16220 <__clz_tab>
   10924:	00d70733          	add	a4,a4,a3
   10928:	00074683          	lbu	a3,0(a4)
   1092c:	00f686b3          	add	a3,a3,a5
   10930:	02000793          	li	a5,32
   10934:	40d787b3          	sub	a5,a5,a3
   10938:	12079863          	bnez	a5,10a68 <__udivdi3+0x25c>
   1093c:	01089e93          	slli	t4,a7,0x10
   10940:	41158733          	sub	a4,a1,a7
   10944:	0108df13          	srli	t5,a7,0x10
   10948:	010ede93          	srli	t4,t4,0x10
   1094c:	00100593          	li	a1,1
   10950:	01035793          	srli	a5,t1,0x10
   10954:	03e75533          	divu	a0,a4,t5
   10958:	03e77733          	remu	a4,a4,t5
   1095c:	03d506b3          	mul	a3,a0,t4
   10960:	01071713          	slli	a4,a4,0x10
   10964:	00f767b3          	or	a5,a4,a5
   10968:	00d7fc63          	bgeu	a5,a3,10980 <__udivdi3+0x174>
   1096c:	011787b3          	add	a5,a5,a7
   10970:	fff50713          	addi	a4,a0,-1
   10974:	0117e463          	bltu	a5,a7,1097c <__udivdi3+0x170>
   10978:	32d7e463          	bltu	a5,a3,10ca0 <__udivdi3+0x494>
   1097c:	00070513          	mv	a0,a4
   10980:	40d787b3          	sub	a5,a5,a3
   10984:	03e7d733          	divu	a4,a5,t5
   10988:	01031313          	slli	t1,t1,0x10
   1098c:	01035313          	srli	t1,t1,0x10
   10990:	03e7f7b3          	remu	a5,a5,t5
   10994:	03d70eb3          	mul	t4,a4,t4
   10998:	01079793          	slli	a5,a5,0x10
   1099c:	0067e7b3          	or	a5,a5,t1
   109a0:	01d7fe63          	bgeu	a5,t4,109bc <__udivdi3+0x1b0>
   109a4:	00f887b3          	add	a5,a7,a5
   109a8:	fff70693          	addi	a3,a4,-1
   109ac:	0117e663          	bltu	a5,a7,109b8 <__udivdi3+0x1ac>
   109b0:	ffe70713          	addi	a4,a4,-2
   109b4:	01d7e463          	bltu	a5,t4,109bc <__udivdi3+0x1b0>
   109b8:	00068713          	mv	a4,a3
   109bc:	01051513          	slli	a0,a0,0x10
   109c0:	00e56533          	or	a0,a0,a4
   109c4:	00008067          	ret
   109c8:	04d5e863          	bltu	a1,a3,10a18 <__udivdi3+0x20c>
   109cc:	000107b7          	lui	a5,0x10
   109d0:	04f6ea63          	bltu	a3,a5,10a24 <__udivdi3+0x218>
   109d4:	010007b7          	lui	a5,0x1000
   109d8:	26f6e063          	bltu	a3,a5,10c38 <__udivdi3+0x42c>
   109dc:	0186d713          	srli	a4,a3,0x18
   109e0:	01800813          	li	a6,24
   109e4:	00006797          	auipc	a5,0x6
   109e8:	83c78793          	addi	a5,a5,-1988 # 16220 <__clz_tab>
   109ec:	00e787b3          	add	a5,a5,a4
   109f0:	0007c703          	lbu	a4,0(a5)
   109f4:	02000e13          	li	t3,32
   109f8:	01070733          	add	a4,a4,a6
   109fc:	40ee0e33          	sub	t3,t3,a4
   10a00:	100e1663          	bnez	t3,10b0c <__udivdi3+0x300>
   10a04:	24b6ec63          	bltu	a3,a1,10c5c <__udivdi3+0x450>
   10a08:	00c53533          	sltu	a0,a0,a2
   10a0c:	00154513          	xori	a0,a0,1
   10a10:	00000593          	li	a1,0
   10a14:	00008067          	ret
   10a18:	00000593          	li	a1,0
   10a1c:	00000513          	li	a0,0
   10a20:	00008067          	ret
   10a24:	0ff00793          	li	a5,255
   10a28:	24d7f063          	bgeu	a5,a3,10c68 <__udivdi3+0x45c>
   10a2c:	0086d713          	srli	a4,a3,0x8
   10a30:	00800813          	li	a6,8
   10a34:	fb1ff06f          	j	109e4 <__udivdi3+0x1d8>
   10a38:	0ff00713          	li	a4,255
   10a3c:	00088693          	mv	a3,a7
   10a40:	ed177ee3          	bgeu	a4,a7,1091c <__udivdi3+0x110>
   10a44:	0088d693          	srli	a3,a7,0x8
   10a48:	00800793          	li	a5,8
   10a4c:	ed1ff06f          	j	1091c <__udivdi3+0x110>
   10a50:	0ff00713          	li	a4,255
   10a54:	00060693          	mv	a3,a2
   10a58:	dec772e3          	bgeu	a4,a2,1083c <__udivdi3+0x30>
   10a5c:	00865693          	srli	a3,a2,0x8
   10a60:	00800793          	li	a5,8
   10a64:	dd9ff06f          	j	1083c <__udivdi3+0x30>
   10a68:	00f898b3          	sll	a7,a7,a5
   10a6c:	00d5d633          	srl	a2,a1,a3
   10a70:	0108df13          	srli	t5,a7,0x10
   10a74:	03e65e33          	divu	t3,a2,t5
   10a78:	00f59733          	sll	a4,a1,a5
   10a7c:	00d556b3          	srl	a3,a0,a3
   10a80:	00e6e733          	or	a4,a3,a4
   10a84:	01089e93          	slli	t4,a7,0x10
   10a88:	010ede93          	srli	t4,t4,0x10
   10a8c:	00f51333          	sll	t1,a0,a5
   10a90:	01075593          	srli	a1,a4,0x10
   10a94:	03e676b3          	remu	a3,a2,t5
   10a98:	03ce87b3          	mul	a5,t4,t3
   10a9c:	01069693          	slli	a3,a3,0x10
   10aa0:	00b6e6b3          	or	a3,a3,a1
   10aa4:	00f6fe63          	bgeu	a3,a5,10ac0 <__udivdi3+0x2b4>
   10aa8:	011686b3          	add	a3,a3,a7
   10aac:	fffe0613          	addi	a2,t3,-1
   10ab0:	1d16ee63          	bltu	a3,a7,10c8c <__udivdi3+0x480>
   10ab4:	1cf6fc63          	bgeu	a3,a5,10c8c <__udivdi3+0x480>
   10ab8:	ffee0e13          	addi	t3,t3,-2
   10abc:	011686b3          	add	a3,a3,a7
   10ac0:	40f686b3          	sub	a3,a3,a5
   10ac4:	03e6d633          	divu	a2,a3,t5
   10ac8:	01071793          	slli	a5,a4,0x10
   10acc:	0107d793          	srli	a5,a5,0x10
   10ad0:	03e6f6b3          	remu	a3,a3,t5
   10ad4:	02ce8533          	mul	a0,t4,a2
   10ad8:	01069713          	slli	a4,a3,0x10
   10adc:	00f76733          	or	a4,a4,a5
   10ae0:	00a77e63          	bgeu	a4,a0,10afc <__udivdi3+0x2f0>
   10ae4:	01170733          	add	a4,a4,a7
   10ae8:	fff60793          	addi	a5,a2,-1 # 7fffffff <__freertos_irq_stack_top+0x7ffe82df>
   10aec:	19176863          	bltu	a4,a7,10c7c <__udivdi3+0x470>
   10af0:	18a77663          	bgeu	a4,a0,10c7c <__udivdi3+0x470>
   10af4:	ffe60613          	addi	a2,a2,-2
   10af8:	01170733          	add	a4,a4,a7
   10afc:	010e1593          	slli	a1,t3,0x10
   10b00:	40a70733          	sub	a4,a4,a0
   10b04:	00c5e5b3          	or	a1,a1,a2
   10b08:	e49ff06f          	j	10950 <__udivdi3+0x144>
   10b0c:	00e657b3          	srl	a5,a2,a4
   10b10:	01c696b3          	sll	a3,a3,t3
   10b14:	00d7e6b3          	or	a3,a5,a3
   10b18:	00e5d333          	srl	t1,a1,a4
   10b1c:	0106df13          	srli	t5,a3,0x10
   10b20:	03e357b3          	divu	a5,t1,t5
   10b24:	01069e93          	slli	t4,a3,0x10
   10b28:	010ede93          	srli	t4,t4,0x10
   10b2c:	01c59833          	sll	a6,a1,t3
   10b30:	00e55733          	srl	a4,a0,a4
   10b34:	01076833          	or	a6,a4,a6
   10b38:	01085893          	srli	a7,a6,0x10
   10b3c:	01c61633          	sll	a2,a2,t3
   10b40:	03e37333          	remu	t1,t1,t5
   10b44:	02fe85b3          	mul	a1,t4,a5
   10b48:	01031313          	slli	t1,t1,0x10
   10b4c:	011368b3          	or	a7,t1,a7
   10b50:	00b8fe63          	bgeu	a7,a1,10b6c <__udivdi3+0x360>
   10b54:	00d888b3          	add	a7,a7,a3
   10b58:	fff78713          	addi	a4,a5,-1
   10b5c:	12d8e463          	bltu	a7,a3,10c84 <__udivdi3+0x478>
   10b60:	12b8f263          	bgeu	a7,a1,10c84 <__udivdi3+0x478>
   10b64:	ffe78793          	addi	a5,a5,-2
   10b68:	00d888b3          	add	a7,a7,a3
   10b6c:	40b888b3          	sub	a7,a7,a1
   10b70:	03e8d733          	divu	a4,a7,t5
   10b74:	01081813          	slli	a6,a6,0x10
   10b78:	01085813          	srli	a6,a6,0x10
   10b7c:	03e8f8b3          	remu	a7,a7,t5
   10b80:	02ee8333          	mul	t1,t4,a4
   10b84:	01089893          	slli	a7,a7,0x10
   10b88:	0108e5b3          	or	a1,a7,a6
   10b8c:	0065fe63          	bgeu	a1,t1,10ba8 <__udivdi3+0x39c>
   10b90:	00d585b3          	add	a1,a1,a3
   10b94:	fff70813          	addi	a6,a4,-1
   10b98:	0cd5ee63          	bltu	a1,a3,10c74 <__udivdi3+0x468>
   10b9c:	0c65fc63          	bgeu	a1,t1,10c74 <__udivdi3+0x468>
   10ba0:	ffe70713          	addi	a4,a4,-2
   10ba4:	00d585b3          	add	a1,a1,a3
   10ba8:	01079793          	slli	a5,a5,0x10
   10bac:	00010f37          	lui	t5,0x10
   10bb0:	00e7e7b3          	or	a5,a5,a4
   10bb4:	ffff0713          	addi	a4,t5,-1 # ffff <_svfiprintf_r+0xce7>
   10bb8:	00e7f6b3          	and	a3,a5,a4
   10bbc:	0107d893          	srli	a7,a5,0x10
   10bc0:	00e67733          	and	a4,a2,a4
   10bc4:	01065613          	srli	a2,a2,0x10
   10bc8:	02e68eb3          	mul	t4,a3,a4
   10bcc:	406585b3          	sub	a1,a1,t1
   10bd0:	02c686b3          	mul	a3,a3,a2
   10bd4:	010ed813          	srli	a6,t4,0x10
   10bd8:	02e88733          	mul	a4,a7,a4
   10bdc:	00e686b3          	add	a3,a3,a4
   10be0:	00d806b3          	add	a3,a6,a3
   10be4:	02c88633          	mul	a2,a7,a2
   10be8:	00e6f463          	bgeu	a3,a4,10bf0 <__udivdi3+0x3e4>
   10bec:	01e60633          	add	a2,a2,t5
   10bf0:	0106d893          	srli	a7,a3,0x10
   10bf4:	00c88633          	add	a2,a7,a2
   10bf8:	02c5ea63          	bltu	a1,a2,10c2c <__udivdi3+0x420>
   10bfc:	00c58863          	beq	a1,a2,10c0c <__udivdi3+0x400>
   10c00:	00078513          	mv	a0,a5
   10c04:	00000593          	li	a1,0
   10c08:	00008067          	ret
   10c0c:	00010737          	lui	a4,0x10
   10c10:	fff70713          	addi	a4,a4,-1 # ffff <_svfiprintf_r+0xce7>
   10c14:	00e6f6b3          	and	a3,a3,a4
   10c18:	01069693          	slli	a3,a3,0x10
   10c1c:	00eefeb3          	and	t4,t4,a4
   10c20:	01c51533          	sll	a0,a0,t3
   10c24:	01d686b3          	add	a3,a3,t4
   10c28:	fcd57ce3          	bgeu	a0,a3,10c00 <__udivdi3+0x3f4>
   10c2c:	fff78513          	addi	a0,a5,-1
   10c30:	00000593          	li	a1,0
   10c34:	00008067          	ret
   10c38:	0106d713          	srli	a4,a3,0x10
   10c3c:	01000813          	li	a6,16
   10c40:	da5ff06f          	j	109e4 <__udivdi3+0x1d8>
   10c44:	01065693          	srli	a3,a2,0x10
   10c48:	01000793          	li	a5,16
   10c4c:	bf1ff06f          	j	1083c <__udivdi3+0x30>
   10c50:	0108d693          	srli	a3,a7,0x10
   10c54:	01000793          	li	a5,16
   10c58:	cc5ff06f          	j	1091c <__udivdi3+0x110>
   10c5c:	00000593          	li	a1,0
   10c60:	00100513          	li	a0,1
   10c64:	00008067          	ret
   10c68:	00068713          	mv	a4,a3
   10c6c:	00000813          	li	a6,0
   10c70:	d75ff06f          	j	109e4 <__udivdi3+0x1d8>
   10c74:	00080713          	mv	a4,a6
   10c78:	f31ff06f          	j	10ba8 <__udivdi3+0x39c>
   10c7c:	00078613          	mv	a2,a5
   10c80:	e7dff06f          	j	10afc <__udivdi3+0x2f0>
   10c84:	00070793          	mv	a5,a4
   10c88:	ee5ff06f          	j	10b6c <__udivdi3+0x360>
   10c8c:	00060e13          	mv	t3,a2
   10c90:	e31ff06f          	j	10ac0 <__udivdi3+0x2b4>
   10c94:	ffe50513          	addi	a0,a0,-2
   10c98:	01180833          	add	a6,a6,a7
   10c9c:	c11ff06f          	j	108ac <__udivdi3+0xa0>
   10ca0:	ffe50513          	addi	a0,a0,-2
   10ca4:	011787b3          	add	a5,a5,a7
   10ca8:	cd9ff06f          	j	10980 <__udivdi3+0x174>

00010cac <__umoddi3>:
   10cac:	00068793          	mv	a5,a3
   10cb0:	00060813          	mv	a6,a2
   10cb4:	00050313          	mv	t1,a0
   10cb8:	00058713          	mv	a4,a1
   10cbc:	00058e13          	mv	t3,a1
   10cc0:	18069263          	bnez	a3,10e44 <__umoddi3+0x198>
   10cc4:	0cc5f063          	bgeu	a1,a2,10d84 <__umoddi3+0xd8>
   10cc8:	00010737          	lui	a4,0x10
   10ccc:	20e67463          	bgeu	a2,a4,10ed4 <__umoddi3+0x228>
   10cd0:	0ff00713          	li	a4,255
   10cd4:	00060693          	mv	a3,a2
   10cd8:	00c77663          	bgeu	a4,a2,10ce4 <__umoddi3+0x38>
   10cdc:	00865693          	srli	a3,a2,0x8
   10ce0:	00800793          	li	a5,8
   10ce4:	00005717          	auipc	a4,0x5
   10ce8:	53c70713          	addi	a4,a4,1340 # 16220 <__clz_tab>
   10cec:	00d70733          	add	a4,a4,a3
   10cf0:	00074703          	lbu	a4,0(a4)
   10cf4:	02000893          	li	a7,32
   10cf8:	00f707b3          	add	a5,a4,a5
   10cfc:	40f888b3          	sub	a7,a7,a5
   10d00:	00088c63          	beqz	a7,10d18 <__umoddi3+0x6c>
   10d04:	011595b3          	sll	a1,a1,a7
   10d08:	00f557b3          	srl	a5,a0,a5
   10d0c:	01161833          	sll	a6,a2,a7
   10d10:	00b7ee33          	or	t3,a5,a1
   10d14:	01151333          	sll	t1,a0,a7
   10d18:	01085613          	srli	a2,a6,0x10
   10d1c:	02ce57b3          	divu	a5,t3,a2
   10d20:	01081513          	slli	a0,a6,0x10
   10d24:	01055513          	srli	a0,a0,0x10
   10d28:	01035693          	srli	a3,t1,0x10
   10d2c:	02ce7e33          	remu	t3,t3,a2
   10d30:	02f507b3          	mul	a5,a0,a5
   10d34:	010e1e13          	slli	t3,t3,0x10
   10d38:	00de6733          	or	a4,t3,a3
   10d3c:	00f77a63          	bgeu	a4,a5,10d50 <__umoddi3+0xa4>
   10d40:	01070733          	add	a4,a4,a6
   10d44:	01076663          	bltu	a4,a6,10d50 <__umoddi3+0xa4>
   10d48:	00f77463          	bgeu	a4,a5,10d50 <__umoddi3+0xa4>
   10d4c:	01070733          	add	a4,a4,a6
   10d50:	40f70733          	sub	a4,a4,a5
   10d54:	02c756b3          	divu	a3,a4,a2
   10d58:	01031793          	slli	a5,t1,0x10
   10d5c:	0107d793          	srli	a5,a5,0x10
   10d60:	02c77733          	remu	a4,a4,a2
   10d64:	02d50533          	mul	a0,a0,a3
   10d68:	01071713          	slli	a4,a4,0x10
   10d6c:	00f767b3          	or	a5,a4,a5
   10d70:	0aa7ea63          	bltu	a5,a0,10e24 <__umoddi3+0x178>
   10d74:	40a78533          	sub	a0,a5,a0
   10d78:	01155533          	srl	a0,a0,a7
   10d7c:	00000593          	li	a1,0
   10d80:	00008067          	ret
   10d84:	00061663          	bnez	a2,10d90 <__umoddi3+0xe4>
   10d88:	00100713          	li	a4,1
   10d8c:	02c75833          	divu	a6,a4,a2
   10d90:	00010737          	lui	a4,0x10
   10d94:	12e86463          	bltu	a6,a4,10ebc <__umoddi3+0x210>
   10d98:	010007b7          	lui	a5,0x1000
   10d9c:	32f86a63          	bltu	a6,a5,110d0 <__umoddi3+0x424>
   10da0:	01885693          	srli	a3,a6,0x18
   10da4:	01800793          	li	a5,24
   10da8:	00005717          	auipc	a4,0x5
   10dac:	47870713          	addi	a4,a4,1144 # 16220 <__clz_tab>
   10db0:	00d70733          	add	a4,a4,a3
   10db4:	00074703          	lbu	a4,0(a4)
   10db8:	02000893          	li	a7,32
   10dbc:	00f707b3          	add	a5,a4,a5
   10dc0:	40f888b3          	sub	a7,a7,a5
   10dc4:	24089c63          	bnez	a7,1101c <__umoddi3+0x370>
   10dc8:	01081e13          	slli	t3,a6,0x10
   10dcc:	410585b3          	sub	a1,a1,a6
   10dd0:	01085613          	srli	a2,a6,0x10
   10dd4:	010e5e13          	srli	t3,t3,0x10
   10dd8:	01035713          	srli	a4,t1,0x10
   10ddc:	02c5d6b3          	divu	a3,a1,a2
   10de0:	02c5f5b3          	remu	a1,a1,a2
   10de4:	03c686b3          	mul	a3,a3,t3
   10de8:	01059593          	slli	a1,a1,0x10
   10dec:	00e5e733          	or	a4,a1,a4
   10df0:	00d77863          	bgeu	a4,a3,10e00 <__umoddi3+0x154>
   10df4:	01070733          	add	a4,a4,a6
   10df8:	01076463          	bltu	a4,a6,10e00 <__umoddi3+0x154>
   10dfc:	30d76463          	bltu	a4,a3,11104 <__umoddi3+0x458>
   10e00:	40d70733          	sub	a4,a4,a3
   10e04:	02c75533          	divu	a0,a4,a2
   10e08:	01031313          	slli	t1,t1,0x10
   10e0c:	01035313          	srli	t1,t1,0x10
   10e10:	02c77733          	remu	a4,a4,a2
   10e14:	03c50533          	mul	a0,a0,t3
   10e18:	01071713          	slli	a4,a4,0x10
   10e1c:	006767b3          	or	a5,a4,t1
   10e20:	00a7fa63          	bgeu	a5,a0,10e34 <__umoddi3+0x188>
   10e24:	010787b3          	add	a5,a5,a6
   10e28:	0107e663          	bltu	a5,a6,10e34 <__umoddi3+0x188>
   10e2c:	00a7f463          	bgeu	a5,a0,10e34 <__umoddi3+0x188>
   10e30:	010787b3          	add	a5,a5,a6
   10e34:	40a78533          	sub	a0,a5,a0
   10e38:	01155533          	srl	a0,a0,a7
   10e3c:	00000593          	li	a1,0
   10e40:	00008067          	ret
   10e44:	00050813          	mv	a6,a0
   10e48:	f2d5ece3          	bltu	a1,a3,10d80 <__umoddi3+0xd4>
   10e4c:	000107b7          	lui	a5,0x10
   10e50:	04f6ec63          	bltu	a3,a5,10ea8 <__umoddi3+0x1fc>
   10e54:	010007b7          	lui	a5,0x1000
   10e58:	26f6e663          	bltu	a3,a5,110c4 <__umoddi3+0x418>
   10e5c:	0186d313          	srli	t1,a3,0x18
   10e60:	01800893          	li	a7,24
   10e64:	00005797          	auipc	a5,0x5
   10e68:	3bc78793          	addi	a5,a5,956 # 16220 <__clz_tab>
   10e6c:	006787b3          	add	a5,a5,t1
   10e70:	0007ce03          	lbu	t3,0(a5)
   10e74:	02000313          	li	t1,32
   10e78:	011e0e33          	add	t3,t3,a7
   10e7c:	41c30333          	sub	t1,t1,t3
   10e80:	06031463          	bnez	t1,10ee8 <__umoddi3+0x23c>
   10e84:	00b6e463          	bltu	a3,a1,10e8c <__umoddi3+0x1e0>
   10e88:	00c56a63          	bltu	a0,a2,10e9c <__umoddi3+0x1f0>
   10e8c:	40c50833          	sub	a6,a0,a2
   10e90:	40d585b3          	sub	a1,a1,a3
   10e94:	01053733          	sltu	a4,a0,a6
   10e98:	40e58733          	sub	a4,a1,a4
   10e9c:	00080513          	mv	a0,a6
   10ea0:	00070593          	mv	a1,a4
   10ea4:	00008067          	ret
   10ea8:	0ff00793          	li	a5,255
   10eac:	22d7fe63          	bgeu	a5,a3,110e8 <__umoddi3+0x43c>
   10eb0:	0086d313          	srli	t1,a3,0x8
   10eb4:	00800893          	li	a7,8
   10eb8:	fadff06f          	j	10e64 <__umoddi3+0x1b8>
   10ebc:	0ff00713          	li	a4,255
   10ec0:	00080693          	mv	a3,a6
   10ec4:	ef0772e3          	bgeu	a4,a6,10da8 <__umoddi3+0xfc>
   10ec8:	00885693          	srli	a3,a6,0x8
   10ecc:	00800793          	li	a5,8
   10ed0:	ed9ff06f          	j	10da8 <__umoddi3+0xfc>
   10ed4:	010007b7          	lui	a5,0x1000
   10ed8:	20f66263          	bltu	a2,a5,110dc <__umoddi3+0x430>
   10edc:	01865693          	srli	a3,a2,0x18
   10ee0:	01800793          	li	a5,24
   10ee4:	e01ff06f          	j	10ce4 <__umoddi3+0x38>
   10ee8:	01c657b3          	srl	a5,a2,t3
   10eec:	006696b3          	sll	a3,a3,t1
   10ef0:	00d7e6b3          	or	a3,a5,a3
   10ef4:	01c5d8b3          	srl	a7,a1,t3
   10ef8:	0106d713          	srli	a4,a3,0x10
   10efc:	02e8deb3          	divu	t4,a7,a4
   10f00:	01069f13          	slli	t5,a3,0x10
   10f04:	01c557b3          	srl	a5,a0,t3
   10f08:	010f5f13          	srli	t5,t5,0x10
   10f0c:	006595b3          	sll	a1,a1,t1
   10f10:	00b7e5b3          	or	a1,a5,a1
   10f14:	0105d813          	srli	a6,a1,0x10
   10f18:	00661633          	sll	a2,a2,t1
   10f1c:	00651533          	sll	a0,a0,t1
   10f20:	02e8f8b3          	remu	a7,a7,a4
   10f24:	03df07b3          	mul	a5,t5,t4
   10f28:	01089893          	slli	a7,a7,0x10
   10f2c:	0108e833          	or	a6,a7,a6
   10f30:	00f87e63          	bgeu	a6,a5,10f4c <__umoddi3+0x2a0>
   10f34:	00d80833          	add	a6,a6,a3
   10f38:	fffe8893          	addi	a7,t4,-1
   10f3c:	1cd86063          	bltu	a6,a3,110fc <__umoddi3+0x450>
   10f40:	1af87e63          	bgeu	a6,a5,110fc <__umoddi3+0x450>
   10f44:	ffee8e93          	addi	t4,t4,-2
   10f48:	00d80833          	add	a6,a6,a3
   10f4c:	40f80833          	sub	a6,a6,a5
   10f50:	02e857b3          	divu	a5,a6,a4
   10f54:	01059593          	slli	a1,a1,0x10
   10f58:	0105d593          	srli	a1,a1,0x10
   10f5c:	02e87833          	remu	a6,a6,a4
   10f60:	02ff0f33          	mul	t5,t5,a5
   10f64:	01081713          	slli	a4,a6,0x10
   10f68:	00b76733          	or	a4,a4,a1
   10f6c:	01e77e63          	bgeu	a4,t5,10f88 <__umoddi3+0x2dc>
   10f70:	00d70733          	add	a4,a4,a3
   10f74:	fff78593          	addi	a1,a5,-1 # ffffff <__freertos_irq_stack_top+0xfe82df>
   10f78:	16d76e63          	bltu	a4,a3,110f4 <__umoddi3+0x448>
   10f7c:	17e77c63          	bgeu	a4,t5,110f4 <__umoddi3+0x448>
   10f80:	ffe78793          	addi	a5,a5,-2
   10f84:	00d70733          	add	a4,a4,a3
   10f88:	010e9e93          	slli	t4,t4,0x10
   10f8c:	000102b7          	lui	t0,0x10
   10f90:	00feeeb3          	or	t4,t4,a5
   10f94:	fff28813          	addi	a6,t0,-1 # ffff <_svfiprintf_r+0xce7>
   10f98:	010ef8b3          	and	a7,t4,a6
   10f9c:	01065593          	srli	a1,a2,0x10
   10fa0:	010ede93          	srli	t4,t4,0x10
   10fa4:	01067833          	and	a6,a2,a6
   10fa8:	03088fb3          	mul	t6,a7,a6
   10fac:	41e70733          	sub	a4,a4,t5
   10fb0:	030e8833          	mul	a6,t4,a6
   10fb4:	010fd793          	srli	a5,t6,0x10
   10fb8:	02b888b3          	mul	a7,a7,a1
   10fbc:	010888b3          	add	a7,a7,a6
   10fc0:	011787b3          	add	a5,a5,a7
   10fc4:	02be8eb3          	mul	t4,t4,a1
   10fc8:	0107f463          	bgeu	a5,a6,10fd0 <__umoddi3+0x324>
   10fcc:	005e8eb3          	add	t4,t4,t0
   10fd0:	00010837          	lui	a6,0x10
   10fd4:	fff80813          	addi	a6,a6,-1 # ffff <_svfiprintf_r+0xce7>
   10fd8:	0107d593          	srli	a1,a5,0x10
   10fdc:	0107f7b3          	and	a5,a5,a6
   10fe0:	01079793          	slli	a5,a5,0x10
   10fe4:	010fffb3          	and	t6,t6,a6
   10fe8:	01d585b3          	add	a1,a1,t4
   10fec:	01f787b3          	add	a5,a5,t6
   10ff0:	0ab76e63          	bltu	a4,a1,110ac <__umoddi3+0x400>
   10ff4:	0ab70a63          	beq	a4,a1,110a8 <__umoddi3+0x3fc>
   10ff8:	40f507b3          	sub	a5,a0,a5
   10ffc:	00f53533          	sltu	a0,a0,a5
   11000:	40b705b3          	sub	a1,a4,a1
   11004:	40a585b3          	sub	a1,a1,a0
   11008:	01c59e33          	sll	t3,a1,t3
   1100c:	0067d533          	srl	a0,a5,t1
   11010:	00ae6533          	or	a0,t3,a0
   11014:	0065d5b3          	srl	a1,a1,t1
   11018:	00008067          	ret
   1101c:	01181833          	sll	a6,a6,a7
   11020:	00f5d733          	srl	a4,a1,a5
   11024:	01085613          	srli	a2,a6,0x10
   11028:	02c756b3          	divu	a3,a4,a2
   1102c:	01081e13          	slli	t3,a6,0x10
   11030:	00f557b3          	srl	a5,a0,a5
   11034:	010e5e13          	srli	t3,t3,0x10
   11038:	011595b3          	sll	a1,a1,a7
   1103c:	00b7e5b3          	or	a1,a5,a1
   11040:	0105de93          	srli	t4,a1,0x10
   11044:	01151333          	sll	t1,a0,a7
   11048:	02c77733          	remu	a4,a4,a2
   1104c:	02de07b3          	mul	a5,t3,a3
   11050:	01071693          	slli	a3,a4,0x10
   11054:	01d6e6b3          	or	a3,a3,t4
   11058:	00f6fa63          	bgeu	a3,a5,1106c <__umoddi3+0x3c0>
   1105c:	010686b3          	add	a3,a3,a6
   11060:	0106e663          	bltu	a3,a6,1106c <__umoddi3+0x3c0>
   11064:	00f6f463          	bgeu	a3,a5,1106c <__umoddi3+0x3c0>
   11068:	010686b3          	add	a3,a3,a6
   1106c:	40f686b3          	sub	a3,a3,a5
   11070:	02c6d733          	divu	a4,a3,a2
   11074:	01059793          	slli	a5,a1,0x10
   11078:	0107d793          	srli	a5,a5,0x10
   1107c:	02c6f6b3          	remu	a3,a3,a2
   11080:	02ee0733          	mul	a4,t3,a4
   11084:	01069593          	slli	a1,a3,0x10
   11088:	00f5e5b3          	or	a1,a1,a5
   1108c:	00e5fa63          	bgeu	a1,a4,110a0 <__umoddi3+0x3f4>
   11090:	010585b3          	add	a1,a1,a6
   11094:	0105e663          	bltu	a1,a6,110a0 <__umoddi3+0x3f4>
   11098:	00e5f463          	bgeu	a1,a4,110a0 <__umoddi3+0x3f4>
   1109c:	010585b3          	add	a1,a1,a6
   110a0:	40e585b3          	sub	a1,a1,a4
   110a4:	d35ff06f          	j	10dd8 <__umoddi3+0x12c>
   110a8:	f4f578e3          	bgeu	a0,a5,10ff8 <__umoddi3+0x34c>
   110ac:	40c78633          	sub	a2,a5,a2
   110b0:	00c7b7b3          	sltu	a5,a5,a2
   110b4:	00d787b3          	add	a5,a5,a3
   110b8:	40f585b3          	sub	a1,a1,a5
   110bc:	00060793          	mv	a5,a2
   110c0:	f39ff06f          	j	10ff8 <__umoddi3+0x34c>
   110c4:	0106d313          	srli	t1,a3,0x10
   110c8:	01000893          	li	a7,16
   110cc:	d99ff06f          	j	10e64 <__umoddi3+0x1b8>
   110d0:	01085693          	srli	a3,a6,0x10
   110d4:	01000793          	li	a5,16
   110d8:	cd1ff06f          	j	10da8 <__umoddi3+0xfc>
   110dc:	01065693          	srli	a3,a2,0x10
   110e0:	01000793          	li	a5,16
   110e4:	c01ff06f          	j	10ce4 <__umoddi3+0x38>
   110e8:	00068313          	mv	t1,a3
   110ec:	00000893          	li	a7,0
   110f0:	d75ff06f          	j	10e64 <__umoddi3+0x1b8>
   110f4:	00058793          	mv	a5,a1
   110f8:	e91ff06f          	j	10f88 <__umoddi3+0x2dc>
   110fc:	00088e93          	mv	t4,a7
   11100:	e4dff06f          	j	10f4c <__umoddi3+0x2a0>
   11104:	01070733          	add	a4,a4,a6
   11108:	cf9ff06f          	j	10e00 <__umoddi3+0x154>

0001110c <__divdf3>:
   1110c:	fc010113          	addi	sp,sp,-64
   11110:	0145d793          	srli	a5,a1,0x14
   11114:	02812c23          	sw	s0,56(sp)
   11118:	02912a23          	sw	s1,52(sp)
   1111c:	03312623          	sw	s3,44(sp)
   11120:	00050493          	mv	s1,a0
   11124:	00c59413          	slli	s0,a1,0xc
   11128:	02112e23          	sw	ra,60(sp)
   1112c:	03212823          	sw	s2,48(sp)
   11130:	03412423          	sw	s4,40(sp)
   11134:	03512223          	sw	s5,36(sp)
   11138:	03612023          	sw	s6,32(sp)
   1113c:	01712e23          	sw	s7,28(sp)
   11140:	7ff7f513          	andi	a0,a5,2047
   11144:	00c45413          	srli	s0,s0,0xc
   11148:	01f5d993          	srli	s3,a1,0x1f
   1114c:	16050863          	beqz	a0,112bc <__divdf3+0x1b0>
   11150:	7ff00793          	li	a5,2047
   11154:	1cf50263          	beq	a0,a5,11318 <__divdf3+0x20c>
   11158:	01d4da93          	srli	s5,s1,0x1d
   1115c:	00341413          	slli	s0,s0,0x3
   11160:	008ae433          	or	s0,s5,s0
   11164:	00800ab7          	lui	s5,0x800
   11168:	00349b13          	slli	s6,s1,0x3
   1116c:	01546ab3          	or	s5,s0,s5
   11170:	c0150913          	addi	s2,a0,-1023
   11174:	00000493          	li	s1,0
   11178:	00000b93          	li	s7,0
   1117c:	0146d713          	srli	a4,a3,0x14
   11180:	00c69413          	slli	s0,a3,0xc
   11184:	7ff77713          	andi	a4,a4,2047
   11188:	00c45413          	srli	s0,s0,0xc
   1118c:	01f6da13          	srli	s4,a3,0x1f
   11190:	0e070063          	beqz	a4,11270 <__divdf3+0x164>
   11194:	7ff00793          	li	a5,2047
   11198:	04f70863          	beq	a4,a5,111e8 <__divdf3+0xdc>
   1119c:	00341793          	slli	a5,s0,0x3
   111a0:	01d65413          	srli	s0,a2,0x1d
   111a4:	00f467b3          	or	a5,s0,a5
   111a8:	c0170713          	addi	a4,a4,-1023
   111ac:	00800437          	lui	s0,0x800
   111b0:	0087e433          	or	s0,a5,s0
   111b4:	00361813          	slli	a6,a2,0x3
   111b8:	40e90933          	sub	s2,s2,a4
   111bc:	00000693          	li	a3,0
   111c0:	00f00793          	li	a5,15
   111c4:	0149c5b3          	xor	a1,s3,s4
   111c8:	2497ec63          	bltu	a5,s1,11420 <__divdf3+0x314>
   111cc:	00005717          	auipc	a4,0x5
   111d0:	f9470713          	addi	a4,a4,-108 # 16160 <zeroes.4467+0x10>
   111d4:	00249493          	slli	s1,s1,0x2
   111d8:	00e484b3          	add	s1,s1,a4
   111dc:	0004a783          	lw	a5,0(s1)
   111e0:	00e787b3          	add	a5,a5,a4
   111e4:	00078067          	jr	a5
   111e8:	00c46833          	or	a6,s0,a2
   111ec:	80190913          	addi	s2,s2,-2047
   111f0:	18081063          	bnez	a6,11370 <__divdf3+0x264>
   111f4:	0024e493          	ori	s1,s1,2
   111f8:	00000413          	li	s0,0
   111fc:	00200693          	li	a3,2
   11200:	fc1ff06f          	j	111c0 <__divdf3+0xb4>
   11204:	7ff00713          	li	a4,2047
   11208:	00000793          	li	a5,0
   1120c:	00000413          	li	s0,0
   11210:	00c79793          	slli	a5,a5,0xc
   11214:	00040513          	mv	a0,s0
   11218:	03c12083          	lw	ra,60(sp)
   1121c:	03812403          	lw	s0,56(sp)
   11220:	01471713          	slli	a4,a4,0x14
   11224:	00c7d793          	srli	a5,a5,0xc
   11228:	01f59593          	slli	a1,a1,0x1f
   1122c:	00e7e7b3          	or	a5,a5,a4
   11230:	00b7e7b3          	or	a5,a5,a1
   11234:	03412483          	lw	s1,52(sp)
   11238:	03012903          	lw	s2,48(sp)
   1123c:	02c12983          	lw	s3,44(sp)
   11240:	02812a03          	lw	s4,40(sp)
   11244:	02412a83          	lw	s5,36(sp)
   11248:	02012b03          	lw	s6,32(sp)
   1124c:	01c12b83          	lw	s7,28(sp)
   11250:	00078593          	mv	a1,a5
   11254:	04010113          	addi	sp,sp,64
   11258:	00008067          	ret
   1125c:	00000593          	li	a1,0
   11260:	7ff00713          	li	a4,2047
   11264:	000807b7          	lui	a5,0x80
   11268:	00000413          	li	s0,0
   1126c:	fa5ff06f          	j	11210 <__divdf3+0x104>
   11270:	00c46833          	or	a6,s0,a2
   11274:	0e080663          	beqz	a6,11360 <__divdf3+0x254>
   11278:	3e040a63          	beqz	s0,1166c <__divdf3+0x560>
   1127c:	00040513          	mv	a0,s0
   11280:	00c12423          	sw	a2,8(sp)
   11284:	731030ef          	jal	ra,151b4 <__clzsi2>
   11288:	00812603          	lw	a2,8(sp)
   1128c:	ff550593          	addi	a1,a0,-11
   11290:	01d00693          	li	a3,29
   11294:	ff850713          	addi	a4,a0,-8
   11298:	40b686b3          	sub	a3,a3,a1
   1129c:	00e417b3          	sll	a5,s0,a4
   112a0:	00d656b3          	srl	a3,a2,a3
   112a4:	00f6e433          	or	s0,a3,a5
   112a8:	00e61833          	sll	a6,a2,a4
   112ac:	01250533          	add	a0,a0,s2
   112b0:	3f350913          	addi	s2,a0,1011
   112b4:	00000693          	li	a3,0
   112b8:	f09ff06f          	j	111c0 <__divdf3+0xb4>
   112bc:	00946ab3          	or	s5,s0,s1
   112c0:	080a8663          	beqz	s5,1134c <__divdf3+0x240>
   112c4:	00d12623          	sw	a3,12(sp)
   112c8:	00c12423          	sw	a2,8(sp)
   112cc:	36040863          	beqz	s0,1163c <__divdf3+0x530>
   112d0:	00040513          	mv	a0,s0
   112d4:	6e1030ef          	jal	ra,151b4 <__clzsi2>
   112d8:	00812603          	lw	a2,8(sp)
   112dc:	00c12683          	lw	a3,12(sp)
   112e0:	00050913          	mv	s2,a0
   112e4:	ff550713          	addi	a4,a0,-11
   112e8:	01d00a93          	li	s5,29
   112ec:	ff890b13          	addi	s6,s2,-8
   112f0:	40ea8ab3          	sub	s5,s5,a4
   112f4:	01641433          	sll	s0,s0,s6
   112f8:	0154dab3          	srl	s5,s1,s5
   112fc:	008aeab3          	or	s5,s5,s0
   11300:	01649b33          	sll	s6,s1,s6
   11304:	c0d00513          	li	a0,-1011
   11308:	41250933          	sub	s2,a0,s2
   1130c:	00000493          	li	s1,0
   11310:	00000b93          	li	s7,0
   11314:	e69ff06f          	j	1117c <__divdf3+0x70>
   11318:	00946ab3          	or	s5,s0,s1
   1131c:	000a9c63          	bnez	s5,11334 <__divdf3+0x228>
   11320:	00000b13          	li	s6,0
   11324:	00800493          	li	s1,8
   11328:	7ff00913          	li	s2,2047
   1132c:	00200b93          	li	s7,2
   11330:	e4dff06f          	j	1117c <__divdf3+0x70>
   11334:	00048b13          	mv	s6,s1
   11338:	00040a93          	mv	s5,s0
   1133c:	00c00493          	li	s1,12
   11340:	7ff00913          	li	s2,2047
   11344:	00300b93          	li	s7,3
   11348:	e35ff06f          	j	1117c <__divdf3+0x70>
   1134c:	00000b13          	li	s6,0
   11350:	00400493          	li	s1,4
   11354:	00000913          	li	s2,0
   11358:	00100b93          	li	s7,1
   1135c:	e21ff06f          	j	1117c <__divdf3+0x70>
   11360:	0014e493          	ori	s1,s1,1
   11364:	00000413          	li	s0,0
   11368:	00100693          	li	a3,1
   1136c:	e55ff06f          	j	111c0 <__divdf3+0xb4>
   11370:	0034e493          	ori	s1,s1,3
   11374:	00060813          	mv	a6,a2
   11378:	00300693          	li	a3,3
   1137c:	e45ff06f          	j	111c0 <__divdf3+0xb4>
   11380:	3c070063          	beqz	a4,11740 <__divdf3+0x634>
   11384:	00100793          	li	a5,1
   11388:	40e787b3          	sub	a5,a5,a4
   1138c:	03800693          	li	a3,56
   11390:	42f6d063          	bge	a3,a5,117b0 <__divdf3+0x6a4>
   11394:	00000713          	li	a4,0
   11398:	00000793          	li	a5,0
   1139c:	00000413          	li	s0,0
   113a0:	e71ff06f          	j	11210 <__divdf3+0x104>
   113a4:	000a0593          	mv	a1,s4
   113a8:	00200793          	li	a5,2
   113ac:	e4f68ce3          	beq	a3,a5,11204 <__divdf3+0xf8>
   113b0:	00300793          	li	a5,3
   113b4:	eaf684e3          	beq	a3,a5,1125c <__divdf3+0x150>
   113b8:	00100793          	li	a5,1
   113bc:	fcf68ce3          	beq	a3,a5,11394 <__divdf3+0x288>
   113c0:	3ff90713          	addi	a4,s2,1023
   113c4:	fae05ee3          	blez	a4,11380 <__divdf3+0x274>
   113c8:	00787793          	andi	a5,a6,7
   113cc:	32079c63          	bnez	a5,11704 <__divdf3+0x5f8>
   113d0:	00385813          	srli	a6,a6,0x3
   113d4:	00741793          	slli	a5,s0,0x7
   113d8:	0007da63          	bgez	a5,113ec <__divdf3+0x2e0>
   113dc:	ff0007b7          	lui	a5,0xff000
   113e0:	fff78793          	addi	a5,a5,-1 # feffffff <__freertos_irq_stack_top+0xfefe82df>
   113e4:	00f47433          	and	s0,s0,a5
   113e8:	40090713          	addi	a4,s2,1024
   113ec:	7fe00793          	li	a5,2046
   113f0:	e0e7cae3          	blt	a5,a4,11204 <__divdf3+0xf8>
   113f4:	00941793          	slli	a5,s0,0x9
   113f8:	01d41693          	slli	a3,s0,0x1d
   113fc:	0106e433          	or	s0,a3,a6
   11400:	00c7d793          	srli	a5,a5,0xc
   11404:	7ff77713          	andi	a4,a4,2047
   11408:	e09ff06f          	j	11210 <__divdf3+0x104>
   1140c:	00098593          	mv	a1,s3
   11410:	000a8413          	mv	s0,s5
   11414:	000b0813          	mv	a6,s6
   11418:	000b8693          	mv	a3,s7
   1141c:	f8dff06f          	j	113a8 <__divdf3+0x29c>
   11420:	2b546863          	bltu	s0,s5,116d0 <__divdf3+0x5c4>
   11424:	2a8a8463          	beq	s5,s0,116cc <__divdf3+0x5c0>
   11428:	000b0713          	mv	a4,s6
   1142c:	fff90913          	addi	s2,s2,-1
   11430:	00000b13          	li	s6,0
   11434:	00841793          	slli	a5,s0,0x8
   11438:	01885893          	srli	a7,a6,0x18
   1143c:	00f8e8b3          	or	a7,a7,a5
   11440:	0108de13          	srli	t3,a7,0x10
   11444:	03cad7b3          	divu	a5,s5,t3
   11448:	01089e93          	slli	t4,a7,0x10
   1144c:	010ede93          	srli	t4,t4,0x10
   11450:	01075613          	srli	a2,a4,0x10
   11454:	00881313          	slli	t1,a6,0x8
   11458:	03cafab3          	remu	s5,s5,t3
   1145c:	02fe86b3          	mul	a3,t4,a5
   11460:	010a9a93          	slli	s5,s5,0x10
   11464:	01566633          	or	a2,a2,s5
   11468:	00d67e63          	bgeu	a2,a3,11484 <__divdf3+0x378>
   1146c:	01160633          	add	a2,a2,a7
   11470:	fff78513          	addi	a0,a5,-1
   11474:	33166a63          	bltu	a2,a7,117a8 <__divdf3+0x69c>
   11478:	32d67863          	bgeu	a2,a3,117a8 <__divdf3+0x69c>
   1147c:	ffe78793          	addi	a5,a5,-2
   11480:	01160633          	add	a2,a2,a7
   11484:	40d60633          	sub	a2,a2,a3
   11488:	03c65433          	divu	s0,a2,t3
   1148c:	01071713          	slli	a4,a4,0x10
   11490:	01075713          	srli	a4,a4,0x10
   11494:	03c67633          	remu	a2,a2,t3
   11498:	028e86b3          	mul	a3,t4,s0
   1149c:	01061613          	slli	a2,a2,0x10
   114a0:	00c76633          	or	a2,a4,a2
   114a4:	00d67e63          	bgeu	a2,a3,114c0 <__divdf3+0x3b4>
   114a8:	01160633          	add	a2,a2,a7
   114ac:	fff40713          	addi	a4,s0,-1 # 7fffff <__freertos_irq_stack_top+0x7e82df>
   114b0:	2f166863          	bltu	a2,a7,117a0 <__divdf3+0x694>
   114b4:	2ed67663          	bgeu	a2,a3,117a0 <__divdf3+0x694>
   114b8:	ffe40413          	addi	s0,s0,-2
   114bc:	01160633          	add	a2,a2,a7
   114c0:	01079793          	slli	a5,a5,0x10
   114c4:	000103b7          	lui	t2,0x10
   114c8:	0087e433          	or	s0,a5,s0
   114cc:	fff38793          	addi	a5,t2,-1 # ffff <_svfiprintf_r+0xce7>
   114d0:	00f47833          	and	a6,s0,a5
   114d4:	01045f13          	srli	t5,s0,0x10
   114d8:	01035513          	srli	a0,t1,0x10
   114dc:	00f377b3          	and	a5,t1,a5
   114e0:	02f80fb3          	mul	t6,a6,a5
   114e4:	40d60733          	sub	a4,a2,a3
   114e8:	02ff02b3          	mul	t0,t5,a5
   114ec:	010fd613          	srli	a2,t6,0x10
   114f0:	030506b3          	mul	a3,a0,a6
   114f4:	005686b3          	add	a3,a3,t0
   114f8:	00d606b3          	add	a3,a2,a3
   114fc:	02af0833          	mul	a6,t5,a0
   11500:	0056f463          	bgeu	a3,t0,11508 <__divdf3+0x3fc>
   11504:	00780833          	add	a6,a6,t2
   11508:	00010f37          	lui	t5,0x10
   1150c:	ffff0f13          	addi	t5,t5,-1 # ffff <_svfiprintf_r+0xce7>
   11510:	0106d613          	srli	a2,a3,0x10
   11514:	01e6f6b3          	and	a3,a3,t5
   11518:	01069693          	slli	a3,a3,0x10
   1151c:	01efff33          	and	t5,t6,t5
   11520:	01060633          	add	a2,a2,a6
   11524:	01e686b3          	add	a3,a3,t5
   11528:	16c76e63          	bltu	a4,a2,116a4 <__divdf3+0x598>
   1152c:	16c70a63          	beq	a4,a2,116a0 <__divdf3+0x594>
   11530:	40db06b3          	sub	a3,s6,a3
   11534:	40c70733          	sub	a4,a4,a2
   11538:	00db3b33          	sltu	s6,s6,a3
   1153c:	41670b33          	sub	s6,a4,s6
   11540:	3ff90713          	addi	a4,s2,1023
   11544:	1f688263          	beq	a7,s6,11728 <__divdf3+0x61c>
   11548:	03cb5833          	divu	a6,s6,t3
   1154c:	0106d613          	srli	a2,a3,0x10
   11550:	03cb7b33          	remu	s6,s6,t3
   11554:	030e8f33          	mul	t5,t4,a6
   11558:	010b1b13          	slli	s6,s6,0x10
   1155c:	01666b33          	or	s6,a2,s6
   11560:	01eb7e63          	bgeu	s6,t5,1157c <__divdf3+0x470>
   11564:	011b0b33          	add	s6,s6,a7
   11568:	fff80613          	addi	a2,a6,-1
   1156c:	2d1b6863          	bltu	s6,a7,1183c <__divdf3+0x730>
   11570:	2deb7663          	bgeu	s6,t5,1183c <__divdf3+0x730>
   11574:	ffe80813          	addi	a6,a6,-2
   11578:	011b0b33          	add	s6,s6,a7
   1157c:	41eb0b33          	sub	s6,s6,t5
   11580:	03cb5633          	divu	a2,s6,t3
   11584:	01069693          	slli	a3,a3,0x10
   11588:	0106d693          	srli	a3,a3,0x10
   1158c:	03cb7b33          	remu	s6,s6,t3
   11590:	02ce8eb3          	mul	t4,t4,a2
   11594:	010b1b13          	slli	s6,s6,0x10
   11598:	0166e6b3          	or	a3,a3,s6
   1159c:	01d6fe63          	bgeu	a3,t4,115b8 <__divdf3+0x4ac>
   115a0:	011686b3          	add	a3,a3,a7
   115a4:	fff60e13          	addi	t3,a2,-1
   115a8:	2916e663          	bltu	a3,a7,11834 <__divdf3+0x728>
   115ac:	29d6f463          	bgeu	a3,t4,11834 <__divdf3+0x728>
   115b0:	ffe60613          	addi	a2,a2,-2
   115b4:	011686b3          	add	a3,a3,a7
   115b8:	01081813          	slli	a6,a6,0x10
   115bc:	00c86833          	or	a6,a6,a2
   115c0:	01081e13          	slli	t3,a6,0x10
   115c4:	01085f93          	srli	t6,a6,0x10
   115c8:	010e5e13          	srli	t3,t3,0x10
   115cc:	02fe0f33          	mul	t5,t3,a5
   115d0:	41d686b3          	sub	a3,a3,t4
   115d4:	03c50e33          	mul	t3,a0,t3
   115d8:	010f5613          	srli	a2,t5,0x10
   115dc:	02ff87b3          	mul	a5,t6,a5
   115e0:	00fe0e33          	add	t3,t3,a5
   115e4:	01c60633          	add	a2,a2,t3
   115e8:	03f50533          	mul	a0,a0,t6
   115ec:	00f67663          	bgeu	a2,a5,115f8 <__divdf3+0x4ec>
   115f0:	000107b7          	lui	a5,0x10
   115f4:	00f50533          	add	a0,a0,a5
   115f8:	00010e37          	lui	t3,0x10
   115fc:	fffe0e13          	addi	t3,t3,-1 # ffff <_svfiprintf_r+0xce7>
   11600:	01065793          	srli	a5,a2,0x10
   11604:	01c67633          	and	a2,a2,t3
   11608:	01061613          	slli	a2,a2,0x10
   1160c:	01cf7f33          	and	t5,t5,t3
   11610:	00a78533          	add	a0,a5,a0
   11614:	01e60633          	add	a2,a2,t5
   11618:	0ca6f863          	bgeu	a3,a0,116e8 <__divdf3+0x5dc>
   1161c:	00d886b3          	add	a3,a7,a3
   11620:	fff80793          	addi	a5,a6,-1
   11624:	2516e463          	bltu	a3,a7,1186c <__divdf3+0x760>
   11628:	20a6ee63          	bltu	a3,a0,11844 <__divdf3+0x738>
   1162c:	24a68663          	beq	a3,a0,11878 <__divdf3+0x76c>
   11630:	00078813          	mv	a6,a5
   11634:	00186813          	ori	a6,a6,1
   11638:	d8dff06f          	j	113c4 <__divdf3+0x2b8>
   1163c:	00048513          	mv	a0,s1
   11640:	375030ef          	jal	ra,151b4 <__clzsi2>
   11644:	01550713          	addi	a4,a0,21
   11648:	01c00593          	li	a1,28
   1164c:	02050913          	addi	s2,a0,32
   11650:	00812603          	lw	a2,8(sp)
   11654:	00c12683          	lw	a3,12(sp)
   11658:	c8e5d8e3          	bge	a1,a4,112e8 <__divdf3+0x1dc>
   1165c:	ff850413          	addi	s0,a0,-8
   11660:	00849ab3          	sll	s5,s1,s0
   11664:	00000b13          	li	s6,0
   11668:	c9dff06f          	j	11304 <__divdf3+0x1f8>
   1166c:	00060513          	mv	a0,a2
   11670:	00c12423          	sw	a2,8(sp)
   11674:	341030ef          	jal	ra,151b4 <__clzsi2>
   11678:	01550593          	addi	a1,a0,21
   1167c:	01c00713          	li	a4,28
   11680:	00050793          	mv	a5,a0
   11684:	00812603          	lw	a2,8(sp)
   11688:	02050513          	addi	a0,a0,32
   1168c:	c0b752e3          	bge	a4,a1,11290 <__divdf3+0x184>
   11690:	ff878793          	addi	a5,a5,-8 # fff8 <_svfiprintf_r+0xce0>
   11694:	00000813          	li	a6,0
   11698:	00f61433          	sll	s0,a2,a5
   1169c:	c11ff06f          	j	112ac <__divdf3+0x1a0>
   116a0:	e8db78e3          	bgeu	s6,a3,11530 <__divdf3+0x424>
   116a4:	006b0b33          	add	s6,s6,t1
   116a8:	006b3833          	sltu	a6,s6,t1
   116ac:	01180833          	add	a6,a6,a7
   116b0:	01070733          	add	a4,a4,a6
   116b4:	fff40813          	addi	a6,s0,-1
   116b8:	02e8fe63          	bgeu	a7,a4,116f4 <__divdf3+0x5e8>
   116bc:	16c76063          	bltu	a4,a2,1181c <__divdf3+0x710>
   116c0:	14e60c63          	beq	a2,a4,11818 <__divdf3+0x70c>
   116c4:	00080413          	mv	s0,a6
   116c8:	e69ff06f          	j	11530 <__divdf3+0x424>
   116cc:	d50b6ee3          	bltu	s6,a6,11428 <__divdf3+0x31c>
   116d0:	01fa9713          	slli	a4,s5,0x1f
   116d4:	001b5613          	srli	a2,s6,0x1
   116d8:	001ada93          	srli	s5,s5,0x1
   116dc:	00c76733          	or	a4,a4,a2
   116e0:	01fb1b13          	slli	s6,s6,0x1f
   116e4:	d51ff06f          	j	11434 <__divdf3+0x328>
   116e8:	f4a696e3          	bne	a3,a0,11634 <__divdf3+0x528>
   116ec:	cc060ce3          	beqz	a2,113c4 <__divdf3+0x2b8>
   116f0:	f2dff06f          	j	1161c <__divdf3+0x510>
   116f4:	fce898e3          	bne	a7,a4,116c4 <__divdf3+0x5b8>
   116f8:	fc6b72e3          	bgeu	s6,t1,116bc <__divdf3+0x5b0>
   116fc:	00080413          	mv	s0,a6
   11700:	e31ff06f          	j	11530 <__divdf3+0x424>
   11704:	00f87793          	andi	a5,a6,15
   11708:	00400693          	li	a3,4
   1170c:	ccd782e3          	beq	a5,a3,113d0 <__divdf3+0x2c4>
   11710:	ffc83793          	sltiu	a5,a6,-4
   11714:	00480813          	addi	a6,a6,4
   11718:	0017c793          	xori	a5,a5,1
   1171c:	00385813          	srli	a6,a6,0x3
   11720:	00f40433          	add	s0,s0,a5
   11724:	cb1ff06f          	j	113d4 <__divdf3+0x2c8>
   11728:	00000813          	li	a6,0
   1172c:	00100793          	li	a5,1
   11730:	fee048e3          	bgtz	a4,11720 <__divdf3+0x614>
   11734:	fff00813          	li	a6,-1
   11738:	c40716e3          	bnez	a4,11384 <__divdf3+0x278>
   1173c:	c0100913          	li	s2,-1023
   11740:	00100793          	li	a5,1
   11744:	41e90513          	addi	a0,s2,1054
   11748:	00a41733          	sll	a4,s0,a0
   1174c:	00f856b3          	srl	a3,a6,a5
   11750:	00a81533          	sll	a0,a6,a0
   11754:	00d76733          	or	a4,a4,a3
   11758:	00a03533          	snez	a0,a0
   1175c:	00a76733          	or	a4,a4,a0
   11760:	00777693          	andi	a3,a4,7
   11764:	00f45433          	srl	s0,s0,a5
   11768:	02068063          	beqz	a3,11788 <__divdf3+0x67c>
   1176c:	00f77793          	andi	a5,a4,15
   11770:	00400693          	li	a3,4
   11774:	00d78a63          	beq	a5,a3,11788 <__divdf3+0x67c>
   11778:	00470793          	addi	a5,a4,4
   1177c:	00e7b733          	sltu	a4,a5,a4
   11780:	00e40433          	add	s0,s0,a4
   11784:	00078713          	mv	a4,a5
   11788:	00841793          	slli	a5,s0,0x8
   1178c:	0607d863          	bgez	a5,117fc <__divdf3+0x6f0>
   11790:	00100713          	li	a4,1
   11794:	00000793          	li	a5,0
   11798:	00000413          	li	s0,0
   1179c:	a75ff06f          	j	11210 <__divdf3+0x104>
   117a0:	00070413          	mv	s0,a4
   117a4:	d1dff06f          	j	114c0 <__divdf3+0x3b4>
   117a8:	00050793          	mv	a5,a0
   117ac:	cd9ff06f          	j	11484 <__divdf3+0x378>
   117b0:	01f00693          	li	a3,31
   117b4:	f8f6d8e3          	bge	a3,a5,11744 <__divdf3+0x638>
   117b8:	fe100693          	li	a3,-31
   117bc:	40e68733          	sub	a4,a3,a4
   117c0:	02000613          	li	a2,32
   117c4:	00e456b3          	srl	a3,s0,a4
   117c8:	00c78863          	beq	a5,a2,117d8 <__divdf3+0x6cc>
   117cc:	43e90793          	addi	a5,s2,1086
   117d0:	00f417b3          	sll	a5,s0,a5
   117d4:	00f86833          	or	a6,a6,a5
   117d8:	01003733          	snez	a4,a6
   117dc:	00d76733          	or	a4,a4,a3
   117e0:	00777413          	andi	s0,a4,7
   117e4:	00000793          	li	a5,0
   117e8:	02040063          	beqz	s0,11808 <__divdf3+0x6fc>
   117ec:	00f77793          	andi	a5,a4,15
   117f0:	00400693          	li	a3,4
   117f4:	00000413          	li	s0,0
   117f8:	f8d790e3          	bne	a5,a3,11778 <__divdf3+0x66c>
   117fc:	00941793          	slli	a5,s0,0x9
   11800:	00c7d793          	srli	a5,a5,0xc
   11804:	01d41413          	slli	s0,s0,0x1d
   11808:	00375713          	srli	a4,a4,0x3
   1180c:	00876433          	or	s0,a4,s0
   11810:	00000713          	li	a4,0
   11814:	9fdff06f          	j	11210 <__divdf3+0x104>
   11818:	eadb76e3          	bgeu	s6,a3,116c4 <__divdf3+0x5b8>
   1181c:	006b0b33          	add	s6,s6,t1
   11820:	006b3833          	sltu	a6,s6,t1
   11824:	01180833          	add	a6,a6,a7
   11828:	ffe40413          	addi	s0,s0,-2
   1182c:	01070733          	add	a4,a4,a6
   11830:	d01ff06f          	j	11530 <__divdf3+0x424>
   11834:	000e0613          	mv	a2,t3
   11838:	d81ff06f          	j	115b8 <__divdf3+0x4ac>
   1183c:	00060813          	mv	a6,a2
   11840:	d3dff06f          	j	1157c <__divdf3+0x470>
   11844:	00131793          	slli	a5,t1,0x1
   11848:	0067b333          	sltu	t1,a5,t1
   1184c:	011308b3          	add	a7,t1,a7
   11850:	011686b3          	add	a3,a3,a7
   11854:	ffe80813          	addi	a6,a6,-2
   11858:	00078313          	mv	t1,a5
   1185c:	dca69ce3          	bne	a3,a0,11634 <__divdf3+0x528>
   11860:	b6c302e3          	beq	t1,a2,113c4 <__divdf3+0x2b8>
   11864:	00186813          	ori	a6,a6,1
   11868:	b5dff06f          	j	113c4 <__divdf3+0x2b8>
   1186c:	00078813          	mv	a6,a5
   11870:	fea688e3          	beq	a3,a0,11860 <__divdf3+0x754>
   11874:	dc1ff06f          	j	11634 <__divdf3+0x528>
   11878:	fcc366e3          	bltu	t1,a2,11844 <__divdf3+0x738>
   1187c:	00078813          	mv	a6,a5
   11880:	fec312e3          	bne	t1,a2,11864 <__divdf3+0x758>
   11884:	b41ff06f          	j	113c4 <__divdf3+0x2b8>

00011888 <__muldf3>:
   11888:	fc010113          	addi	sp,sp,-64
   1188c:	0145d793          	srli	a5,a1,0x14
   11890:	02812c23          	sw	s0,56(sp)
   11894:	03212823          	sw	s2,48(sp)
   11898:	03412423          	sw	s4,40(sp)
   1189c:	00c59413          	slli	s0,a1,0xc
   118a0:	02112e23          	sw	ra,60(sp)
   118a4:	02912a23          	sw	s1,52(sp)
   118a8:	03312623          	sw	s3,44(sp)
   118ac:	03512223          	sw	s5,36(sp)
   118b0:	03612023          	sw	s6,32(sp)
   118b4:	01712e23          	sw	s7,28(sp)
   118b8:	7ff7f793          	andi	a5,a5,2047
   118bc:	00050913          	mv	s2,a0
   118c0:	00c45413          	srli	s0,s0,0xc
   118c4:	01f5da13          	srli	s4,a1,0x1f
   118c8:	14078c63          	beqz	a5,11a20 <__muldf3+0x198>
   118cc:	7ff00713          	li	a4,2047
   118d0:	20e78863          	beq	a5,a4,11ae0 <__muldf3+0x258>
   118d4:	00341513          	slli	a0,s0,0x3
   118d8:	01d95413          	srli	s0,s2,0x1d
   118dc:	00a46433          	or	s0,s0,a0
   118e0:	00800537          	lui	a0,0x800
   118e4:	00a46433          	or	s0,s0,a0
   118e8:	00391493          	slli	s1,s2,0x3
   118ec:	c0178b13          	addi	s6,a5,-1023
   118f0:	00000993          	li	s3,0
   118f4:	00000b93          	li	s7,0
   118f8:	0146d793          	srli	a5,a3,0x14
   118fc:	00c69913          	slli	s2,a3,0xc
   11900:	7ff7f793          	andi	a5,a5,2047
   11904:	00c95913          	srli	s2,s2,0xc
   11908:	01f6da93          	srli	s5,a3,0x1f
   1190c:	18078263          	beqz	a5,11a90 <__muldf3+0x208>
   11910:	7ff00713          	li	a4,2047
   11914:	04e78c63          	beq	a5,a4,1196c <__muldf3+0xe4>
   11918:	00391513          	slli	a0,s2,0x3
   1191c:	01d65913          	srli	s2,a2,0x1d
   11920:	00a96933          	or	s2,s2,a0
   11924:	c0178793          	addi	a5,a5,-1023
   11928:	00800537          	lui	a0,0x800
   1192c:	00a96933          	or	s2,s2,a0
   11930:	00361593          	slli	a1,a2,0x3
   11934:	00fb0b33          	add	s6,s6,a5
   11938:	00000813          	li	a6,0
   1193c:	015a46b3          	xor	a3,s4,s5
   11940:	00f00793          	li	a5,15
   11944:	00068513          	mv	a0,a3
   11948:	001b0613          	addi	a2,s6,1
   1194c:	2137ec63          	bltu	a5,s3,11b64 <__muldf3+0x2dc>
   11950:	00005797          	auipc	a5,0x5
   11954:	85078793          	addi	a5,a5,-1968 # 161a0 <zeroes.4467+0x50>
   11958:	00299993          	slli	s3,s3,0x2
   1195c:	00f989b3          	add	s3,s3,a5
   11960:	0009a703          	lw	a4,0(s3)
   11964:	00f70733          	add	a4,a4,a5
   11968:	00070067          	jr	a4
   1196c:	00c965b3          	or	a1,s2,a2
   11970:	7ffb0b13          	addi	s6,s6,2047
   11974:	1c059063          	bnez	a1,11b34 <__muldf3+0x2ac>
   11978:	0029e993          	ori	s3,s3,2
   1197c:	00000913          	li	s2,0
   11980:	00200813          	li	a6,2
   11984:	fb9ff06f          	j	1193c <__muldf3+0xb4>
   11988:	00000693          	li	a3,0
   1198c:	7ff00793          	li	a5,2047
   11990:	00080437          	lui	s0,0x80
   11994:	00000493          	li	s1,0
   11998:	00c41413          	slli	s0,s0,0xc
   1199c:	01479793          	slli	a5,a5,0x14
   119a0:	00c45413          	srli	s0,s0,0xc
   119a4:	01f69693          	slli	a3,a3,0x1f
   119a8:	00f46433          	or	s0,s0,a5
   119ac:	00d46433          	or	s0,s0,a3
   119b0:	00040593          	mv	a1,s0
   119b4:	03c12083          	lw	ra,60(sp)
   119b8:	03812403          	lw	s0,56(sp)
   119bc:	00048513          	mv	a0,s1
   119c0:	03012903          	lw	s2,48(sp)
   119c4:	03412483          	lw	s1,52(sp)
   119c8:	02c12983          	lw	s3,44(sp)
   119cc:	02812a03          	lw	s4,40(sp)
   119d0:	02412a83          	lw	s5,36(sp)
   119d4:	02012b03          	lw	s6,32(sp)
   119d8:	01c12b83          	lw	s7,28(sp)
   119dc:	04010113          	addi	sp,sp,64
   119e0:	00008067          	ret
   119e4:	000a8513          	mv	a0,s5
   119e8:	00090413          	mv	s0,s2
   119ec:	00058493          	mv	s1,a1
   119f0:	00080b93          	mv	s7,a6
   119f4:	00200793          	li	a5,2
   119f8:	14fb8c63          	beq	s7,a5,11b50 <__muldf3+0x2c8>
   119fc:	00300793          	li	a5,3
   11a00:	f8fb84e3          	beq	s7,a5,11988 <__muldf3+0x100>
   11a04:	00100793          	li	a5,1
   11a08:	00050693          	mv	a3,a0
   11a0c:	4cfb9463          	bne	s7,a5,11ed4 <__muldf3+0x64c>
   11a10:	00000793          	li	a5,0
   11a14:	00000413          	li	s0,0
   11a18:	00000493          	li	s1,0
   11a1c:	f7dff06f          	j	11998 <__muldf3+0x110>
   11a20:	00a464b3          	or	s1,s0,a0
   11a24:	0e048e63          	beqz	s1,11b20 <__muldf3+0x298>
   11a28:	00d12623          	sw	a3,12(sp)
   11a2c:	00c12423          	sw	a2,8(sp)
   11a30:	38040863          	beqz	s0,11dc0 <__muldf3+0x538>
   11a34:	00040513          	mv	a0,s0
   11a38:	77c030ef          	jal	ra,151b4 <__clzsi2>
   11a3c:	00812603          	lw	a2,8(sp)
   11a40:	00c12683          	lw	a3,12(sp)
   11a44:	00050793          	mv	a5,a0
   11a48:	ff550593          	addi	a1,a0,-11 # 7ffff5 <__freertos_irq_stack_top+0x7e82d5>
   11a4c:	01d00713          	li	a4,29
   11a50:	ff878493          	addi	s1,a5,-8
   11a54:	40b70733          	sub	a4,a4,a1
   11a58:	00941433          	sll	s0,s0,s1
   11a5c:	00e95733          	srl	a4,s2,a4
   11a60:	00876433          	or	s0,a4,s0
   11a64:	009914b3          	sll	s1,s2,s1
   11a68:	c0d00b13          	li	s6,-1011
   11a6c:	40fb0b33          	sub	s6,s6,a5
   11a70:	0146d793          	srli	a5,a3,0x14
   11a74:	00c69913          	slli	s2,a3,0xc
   11a78:	7ff7f793          	andi	a5,a5,2047
   11a7c:	00000993          	li	s3,0
   11a80:	00000b93          	li	s7,0
   11a84:	00c95913          	srli	s2,s2,0xc
   11a88:	01f6da93          	srli	s5,a3,0x1f
   11a8c:	e80792e3          	bnez	a5,11910 <__muldf3+0x88>
   11a90:	00c965b3          	or	a1,s2,a2
   11a94:	06058463          	beqz	a1,11afc <__muldf3+0x274>
   11a98:	2e090c63          	beqz	s2,11d90 <__muldf3+0x508>
   11a9c:	00090513          	mv	a0,s2
   11aa0:	00c12423          	sw	a2,8(sp)
   11aa4:	710030ef          	jal	ra,151b4 <__clzsi2>
   11aa8:	00812603          	lw	a2,8(sp)
   11aac:	00050793          	mv	a5,a0
   11ab0:	ff550693          	addi	a3,a0,-11
   11ab4:	01d00713          	li	a4,29
   11ab8:	ff878593          	addi	a1,a5,-8
   11abc:	40d70733          	sub	a4,a4,a3
   11ac0:	00b91933          	sll	s2,s2,a1
   11ac4:	00e65733          	srl	a4,a2,a4
   11ac8:	01276933          	or	s2,a4,s2
   11acc:	00b615b3          	sll	a1,a2,a1
   11ad0:	40fb07b3          	sub	a5,s6,a5
   11ad4:	c0d78b13          	addi	s6,a5,-1011
   11ad8:	00000813          	li	a6,0
   11adc:	e61ff06f          	j	1193c <__muldf3+0xb4>
   11ae0:	00a464b3          	or	s1,s0,a0
   11ae4:	02049463          	bnez	s1,11b0c <__muldf3+0x284>
   11ae8:	00000413          	li	s0,0
   11aec:	00800993          	li	s3,8
   11af0:	7ff00b13          	li	s6,2047
   11af4:	00200b93          	li	s7,2
   11af8:	e01ff06f          	j	118f8 <__muldf3+0x70>
   11afc:	0019e993          	ori	s3,s3,1
   11b00:	00000913          	li	s2,0
   11b04:	00100813          	li	a6,1
   11b08:	e35ff06f          	j	1193c <__muldf3+0xb4>
   11b0c:	00050493          	mv	s1,a0
   11b10:	00c00993          	li	s3,12
   11b14:	7ff00b13          	li	s6,2047
   11b18:	00300b93          	li	s7,3
   11b1c:	dddff06f          	j	118f8 <__muldf3+0x70>
   11b20:	00000413          	li	s0,0
   11b24:	00400993          	li	s3,4
   11b28:	00000b13          	li	s6,0
   11b2c:	00100b93          	li	s7,1
   11b30:	dc9ff06f          	j	118f8 <__muldf3+0x70>
   11b34:	0039e993          	ori	s3,s3,3
   11b38:	00060593          	mv	a1,a2
   11b3c:	00300813          	li	a6,3
   11b40:	dfdff06f          	j	1193c <__muldf3+0xb4>
   11b44:	00200793          	li	a5,2
   11b48:	000a0513          	mv	a0,s4
   11b4c:	eafb98e3          	bne	s7,a5,119fc <__muldf3+0x174>
   11b50:	00050693          	mv	a3,a0
   11b54:	7ff00793          	li	a5,2047
   11b58:	00000413          	li	s0,0
   11b5c:	00000493          	li	s1,0
   11b60:	e39ff06f          	j	11998 <__muldf3+0x110>
   11b64:	00010e37          	lui	t3,0x10
   11b68:	fffe0713          	addi	a4,t3,-1 # ffff <_svfiprintf_r+0xce7>
   11b6c:	0104d793          	srli	a5,s1,0x10
   11b70:	0105d813          	srli	a6,a1,0x10
   11b74:	00e4f4b3          	and	s1,s1,a4
   11b78:	00e5f5b3          	and	a1,a1,a4
   11b7c:	02958733          	mul	a4,a1,s1
   11b80:	02b78333          	mul	t1,a5,a1
   11b84:	01075513          	srli	a0,a4,0x10
   11b88:	029808b3          	mul	a7,a6,s1
   11b8c:	006888b3          	add	a7,a7,t1
   11b90:	01150533          	add	a0,a0,a7
   11b94:	03078f33          	mul	t5,a5,a6
   11b98:	00657463          	bgeu	a0,t1,11ba0 <__muldf3+0x318>
   11b9c:	01cf0f33          	add	t5,t5,t3
   11ba0:	00010eb7          	lui	t4,0x10
   11ba4:	fffe8893          	addi	a7,t4,-1 # ffff <_svfiprintf_r+0xce7>
   11ba8:	01095293          	srli	t0,s2,0x10
   11bac:	01197933          	and	s2,s2,a7
   11bb0:	01157333          	and	t1,a0,a7
   11bb4:	01177733          	and	a4,a4,a7
   11bb8:	01031313          	slli	t1,t1,0x10
   11bbc:	029908b3          	mul	a7,s2,s1
   11bc0:	00e30333          	add	t1,t1,a4
   11bc4:	01055513          	srli	a0,a0,0x10
   11bc8:	03278fb3          	mul	t6,a5,s2
   11bcc:	0108de13          	srli	t3,a7,0x10
   11bd0:	029284b3          	mul	s1,t0,s1
   11bd4:	01f484b3          	add	s1,s1,t6
   11bd8:	009e04b3          	add	s1,t3,s1
   11bdc:	02578733          	mul	a4,a5,t0
   11be0:	01f4f463          	bgeu	s1,t6,11be8 <__muldf3+0x360>
   11be4:	01d70733          	add	a4,a4,t4
   11be8:	000109b7          	lui	s3,0x10
   11bec:	fff98e13          	addi	t3,s3,-1 # ffff <_svfiprintf_r+0xce7>
   11bf0:	01c477b3          	and	a5,s0,t3
   11bf4:	01c4feb3          	and	t4,s1,t3
   11bf8:	01045f93          	srli	t6,s0,0x10
   11bfc:	0104d493          	srli	s1,s1,0x10
   11c00:	01c8f8b3          	and	a7,a7,t3
   11c04:	02f583b3          	mul	t2,a1,a5
   11c08:	00e48e33          	add	t3,s1,a4
   11c0c:	010e9e93          	slli	t4,t4,0x10
   11c10:	011e8eb3          	add	t4,t4,a7
   11c14:	01d50533          	add	a0,a0,t4
   11c18:	02f80733          	mul	a4,a6,a5
   11c1c:	0103d893          	srli	a7,t2,0x10
   11c20:	02bf85b3          	mul	a1,t6,a1
   11c24:	00b70733          	add	a4,a4,a1
   11c28:	00e888b3          	add	a7,a7,a4
   11c2c:	03f80833          	mul	a6,a6,t6
   11c30:	00b8f463          	bgeu	a7,a1,11c38 <__muldf3+0x3b0>
   11c34:	01380833          	add	a6,a6,s3
   11c38:	00010737          	lui	a4,0x10
   11c3c:	fff70413          	addi	s0,a4,-1 # ffff <_svfiprintf_r+0xce7>
   11c40:	0088f5b3          	and	a1,a7,s0
   11c44:	0108d893          	srli	a7,a7,0x10
   11c48:	010888b3          	add	a7,a7,a6
   11c4c:	0083f3b3          	and	t2,t2,s0
   11c50:	01059593          	slli	a1,a1,0x10
   11c54:	02f90833          	mul	a6,s2,a5
   11c58:	007585b3          	add	a1,a1,t2
   11c5c:	032f8933          	mul	s2,t6,s2
   11c60:	01085413          	srli	s0,a6,0x10
   11c64:	02f287b3          	mul	a5,t0,a5
   11c68:	012787b3          	add	a5,a5,s2
   11c6c:	00f407b3          	add	a5,s0,a5
   11c70:	03f28fb3          	mul	t6,t0,t6
   11c74:	0127f463          	bgeu	a5,s2,11c7c <__muldf3+0x3f4>
   11c78:	00ef8fb3          	add	t6,t6,a4
   11c7c:	000102b7          	lui	t0,0x10
   11c80:	fff28293          	addi	t0,t0,-1 # ffff <_svfiprintf_r+0xce7>
   11c84:	0057f733          	and	a4,a5,t0
   11c88:	00587833          	and	a6,a6,t0
   11c8c:	01071713          	slli	a4,a4,0x10
   11c90:	01e50533          	add	a0,a0,t5
   11c94:	01070733          	add	a4,a4,a6
   11c98:	01d53eb3          	sltu	t4,a0,t4
   11c9c:	01c70733          	add	a4,a4,t3
   11ca0:	00b50533          	add	a0,a0,a1
   11ca4:	01d70433          	add	s0,a4,t4
   11ca8:	00b535b3          	sltu	a1,a0,a1
   11cac:	01140833          	add	a6,s0,a7
   11cb0:	00b80f33          	add	t5,a6,a1
   11cb4:	01c73733          	sltu	a4,a4,t3
   11cb8:	01d43433          	sltu	s0,s0,t4
   11cbc:	00876433          	or	s0,a4,s0
   11cc0:	0107d793          	srli	a5,a5,0x10
   11cc4:	011838b3          	sltu	a7,a6,a7
   11cc8:	00bf35b3          	sltu	a1,t5,a1
   11ccc:	00f40433          	add	s0,s0,a5
   11cd0:	00b8e5b3          	or	a1,a7,a1
   11cd4:	00951493          	slli	s1,a0,0x9
   11cd8:	00b40433          	add	s0,s0,a1
   11cdc:	01f40433          	add	s0,s0,t6
   11ce0:	0064e4b3          	or	s1,s1,t1
   11ce4:	00941713          	slli	a4,s0,0x9
   11ce8:	009034b3          	snez	s1,s1
   11cec:	017f5413          	srli	s0,t5,0x17
   11cf0:	01755513          	srli	a0,a0,0x17
   11cf4:	009f1793          	slli	a5,t5,0x9
   11cf8:	00a4e4b3          	or	s1,s1,a0
   11cfc:	00876433          	or	s0,a4,s0
   11d00:	00f4e4b3          	or	s1,s1,a5
   11d04:	00741793          	slli	a5,s0,0x7
   11d08:	0207d063          	bgez	a5,11d28 <__muldf3+0x4a0>
   11d0c:	0014d793          	srli	a5,s1,0x1
   11d10:	0014f493          	andi	s1,s1,1
   11d14:	01f41713          	slli	a4,s0,0x1f
   11d18:	0097e4b3          	or	s1,a5,s1
   11d1c:	00e4e4b3          	or	s1,s1,a4
   11d20:	00145413          	srli	s0,s0,0x1
   11d24:	00060b13          	mv	s6,a2
   11d28:	3ffb0713          	addi	a4,s6,1023
   11d2c:	0ce05063          	blez	a4,11dec <__muldf3+0x564>
   11d30:	0074f793          	andi	a5,s1,7
   11d34:	02078063          	beqz	a5,11d54 <__muldf3+0x4cc>
   11d38:	00f4f793          	andi	a5,s1,15
   11d3c:	00400613          	li	a2,4
   11d40:	00c78a63          	beq	a5,a2,11d54 <__muldf3+0x4cc>
   11d44:	00448793          	addi	a5,s1,4
   11d48:	0097b4b3          	sltu	s1,a5,s1
   11d4c:	00940433          	add	s0,s0,s1
   11d50:	00078493          	mv	s1,a5
   11d54:	00741793          	slli	a5,s0,0x7
   11d58:	0007da63          	bgez	a5,11d6c <__muldf3+0x4e4>
   11d5c:	ff0007b7          	lui	a5,0xff000
   11d60:	fff78793          	addi	a5,a5,-1 # feffffff <__freertos_irq_stack_top+0xfefe82df>
   11d64:	00f47433          	and	s0,s0,a5
   11d68:	400b0713          	addi	a4,s6,1024
   11d6c:	7fe00793          	li	a5,2046
   11d70:	14e7ca63          	blt	a5,a4,11ec4 <__muldf3+0x63c>
   11d74:	0034d793          	srli	a5,s1,0x3
   11d78:	01d41493          	slli	s1,s0,0x1d
   11d7c:	00941413          	slli	s0,s0,0x9
   11d80:	00f4e4b3          	or	s1,s1,a5
   11d84:	00c45413          	srli	s0,s0,0xc
   11d88:	7ff77793          	andi	a5,a4,2047
   11d8c:	c0dff06f          	j	11998 <__muldf3+0x110>
   11d90:	00060513          	mv	a0,a2
   11d94:	00c12423          	sw	a2,8(sp)
   11d98:	41c030ef          	jal	ra,151b4 <__clzsi2>
   11d9c:	01550693          	addi	a3,a0,21
   11da0:	01c00713          	li	a4,28
   11da4:	02050793          	addi	a5,a0,32
   11da8:	00812603          	lw	a2,8(sp)
   11dac:	d0d754e3          	bge	a4,a3,11ab4 <__muldf3+0x22c>
   11db0:	ff850513          	addi	a0,a0,-8
   11db4:	00000593          	li	a1,0
   11db8:	00a61933          	sll	s2,a2,a0
   11dbc:	d15ff06f          	j	11ad0 <__muldf3+0x248>
   11dc0:	3f4030ef          	jal	ra,151b4 <__clzsi2>
   11dc4:	01550593          	addi	a1,a0,21
   11dc8:	01c00713          	li	a4,28
   11dcc:	02050793          	addi	a5,a0,32
   11dd0:	00812603          	lw	a2,8(sp)
   11dd4:	00c12683          	lw	a3,12(sp)
   11dd8:	c6b75ae3          	bge	a4,a1,11a4c <__muldf3+0x1c4>
   11ddc:	ff850513          	addi	a0,a0,-8
   11de0:	00000493          	li	s1,0
   11de4:	00a91433          	sll	s0,s2,a0
   11de8:	c81ff06f          	j	11a68 <__muldf3+0x1e0>
   11dec:	00100613          	li	a2,1
   11df0:	40e60633          	sub	a2,a2,a4
   11df4:	06071063          	bnez	a4,11e54 <__muldf3+0x5cc>
   11df8:	41eb0793          	addi	a5,s6,1054
   11dfc:	00f49733          	sll	a4,s1,a5
   11e00:	00f417b3          	sll	a5,s0,a5
   11e04:	00c4d4b3          	srl	s1,s1,a2
   11e08:	0097e4b3          	or	s1,a5,s1
   11e0c:	00e03733          	snez	a4,a4
   11e10:	00e4e4b3          	or	s1,s1,a4
   11e14:	0074f793          	andi	a5,s1,7
   11e18:	00c45633          	srl	a2,s0,a2
   11e1c:	02078063          	beqz	a5,11e3c <__muldf3+0x5b4>
   11e20:	00f4f793          	andi	a5,s1,15
   11e24:	00400713          	li	a4,4
   11e28:	00e78a63          	beq	a5,a4,11e3c <__muldf3+0x5b4>
   11e2c:	00448793          	addi	a5,s1,4
   11e30:	0097b4b3          	sltu	s1,a5,s1
   11e34:	00960633          	add	a2,a2,s1
   11e38:	00078493          	mv	s1,a5
   11e3c:	00861793          	slli	a5,a2,0x8
   11e40:	0607d463          	bgez	a5,11ea8 <__muldf3+0x620>
   11e44:	00100793          	li	a5,1
   11e48:	00000413          	li	s0,0
   11e4c:	00000493          	li	s1,0
   11e50:	b49ff06f          	j	11998 <__muldf3+0x110>
   11e54:	03800793          	li	a5,56
   11e58:	bac7cce3          	blt	a5,a2,11a10 <__muldf3+0x188>
   11e5c:	01f00793          	li	a5,31
   11e60:	f8c7dce3          	bge	a5,a2,11df8 <__muldf3+0x570>
   11e64:	fe100793          	li	a5,-31
   11e68:	40e78733          	sub	a4,a5,a4
   11e6c:	02000793          	li	a5,32
   11e70:	00e45733          	srl	a4,s0,a4
   11e74:	00f60863          	beq	a2,a5,11e84 <__muldf3+0x5fc>
   11e78:	43eb0793          	addi	a5,s6,1086
   11e7c:	00f417b3          	sll	a5,s0,a5
   11e80:	00f4e4b3          	or	s1,s1,a5
   11e84:	009034b3          	snez	s1,s1
   11e88:	00e4e4b3          	or	s1,s1,a4
   11e8c:	0074f613          	andi	a2,s1,7
   11e90:	00000413          	li	s0,0
   11e94:	02060063          	beqz	a2,11eb4 <__muldf3+0x62c>
   11e98:	00f4f793          	andi	a5,s1,15
   11e9c:	00400713          	li	a4,4
   11ea0:	00000613          	li	a2,0
   11ea4:	f8e794e3          	bne	a5,a4,11e2c <__muldf3+0x5a4>
   11ea8:	00961413          	slli	s0,a2,0x9
   11eac:	00c45413          	srli	s0,s0,0xc
   11eb0:	01d61613          	slli	a2,a2,0x1d
   11eb4:	0034d493          	srli	s1,s1,0x3
   11eb8:	00c4e4b3          	or	s1,s1,a2
   11ebc:	00000793          	li	a5,0
   11ec0:	ad9ff06f          	j	11998 <__muldf3+0x110>
   11ec4:	7ff00793          	li	a5,2047
   11ec8:	00000413          	li	s0,0
   11ecc:	00000493          	li	s1,0
   11ed0:	ac9ff06f          	j	11998 <__muldf3+0x110>
   11ed4:	00060b13          	mv	s6,a2
   11ed8:	e51ff06f          	j	11d28 <__muldf3+0x4a0>

00011edc <__eqtf2>:
   11edc:	00c52703          	lw	a4,12(a0)
   11ee0:	00c5a683          	lw	a3,12(a1)
   11ee4:	000087b7          	lui	a5,0x8
   11ee8:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   11eec:	01075613          	srli	a2,a4,0x10
   11ef0:	0106d813          	srli	a6,a3,0x10
   11ef4:	01071e93          	slli	t4,a4,0x10
   11ef8:	01069393          	slli	t2,a3,0x10
   11efc:	00f67633          	and	a2,a2,a5
   11f00:	0005af03          	lw	t5,0(a1)
   11f04:	0045af83          	lw	t6,4(a1)
   11f08:	0085a283          	lw	t0,8(a1)
   11f0c:	ff010113          	addi	sp,sp,-16
   11f10:	00052883          	lw	a7,0(a0)
   11f14:	00452303          	lw	t1,4(a0)
   11f18:	00852e03          	lw	t3,8(a0)
   11f1c:	010ede93          	srli	t4,t4,0x10
   11f20:	01f75713          	srli	a4,a4,0x1f
   11f24:	0103d393          	srli	t2,t2,0x10
   11f28:	00f875b3          	and	a1,a6,a5
   11f2c:	01f6d693          	srli	a3,a3,0x1f
   11f30:	02f60063          	beq	a2,a5,11f50 <__eqtf2+0x74>
   11f34:	00100513          	li	a0,1
   11f38:	00f58863          	beq	a1,a5,11f48 <__eqtf2+0x6c>
   11f3c:	00c59663          	bne	a1,a2,11f48 <__eqtf2+0x6c>
   11f40:	00100513          	li	a0,1
   11f44:	03e88c63          	beq	a7,t5,11f7c <__eqtf2+0xa0>
   11f48:	01010113          	addi	sp,sp,16
   11f4c:	00008067          	ret
   11f50:	0068e7b3          	or	a5,a7,t1
   11f54:	01c7e7b3          	or	a5,a5,t3
   11f58:	01d7e7b3          	or	a5,a5,t4
   11f5c:	00100513          	li	a0,1
   11f60:	fe0794e3          	bnez	a5,11f48 <__eqtf2+0x6c>
   11f64:	fec592e3          	bne	a1,a2,11f48 <__eqtf2+0x6c>
   11f68:	01ff67b3          	or	a5,t5,t6
   11f6c:	0057e7b3          	or	a5,a5,t0
   11f70:	0077e7b3          	or	a5,a5,t2
   11f74:	fc079ae3          	bnez	a5,11f48 <__eqtf2+0x6c>
   11f78:	fc9ff06f          	j	11f40 <__eqtf2+0x64>
   11f7c:	fdf316e3          	bne	t1,t6,11f48 <__eqtf2+0x6c>
   11f80:	fc5e14e3          	bne	t3,t0,11f48 <__eqtf2+0x6c>
   11f84:	fc7e92e3          	bne	t4,t2,11f48 <__eqtf2+0x6c>
   11f88:	00000513          	li	a0,0
   11f8c:	fad70ee3          	beq	a4,a3,11f48 <__eqtf2+0x6c>
   11f90:	00100513          	li	a0,1
   11f94:	fa061ae3          	bnez	a2,11f48 <__eqtf2+0x6c>
   11f98:	0068e533          	or	a0,a7,t1
   11f9c:	01c56533          	or	a0,a0,t3
   11fa0:	01d56533          	or	a0,a0,t4
   11fa4:	00a03533          	snez	a0,a0
   11fa8:	fa1ff06f          	j	11f48 <__eqtf2+0x6c>

00011fac <__getf2>:
   11fac:	00c52603          	lw	a2,12(a0)
   11fb0:	00c5a703          	lw	a4,12(a1)
   11fb4:	000087b7          	lui	a5,0x8
   11fb8:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   11fbc:	01065813          	srli	a6,a2,0x10
   11fc0:	01075693          	srli	a3,a4,0x10
   11fc4:	0005a283          	lw	t0,0(a1)
   11fc8:	0045af83          	lw	t6,4(a1)
   11fcc:	0085af03          	lw	t5,8(a1)
   11fd0:	01071893          	slli	a7,a4,0x10
   11fd4:	01061593          	slli	a1,a2,0x10
   11fd8:	00f87833          	and	a6,a6,a5
   11fdc:	00052e83          	lw	t4,0(a0)
   11fe0:	00452303          	lw	t1,4(a0)
   11fe4:	00852e03          	lw	t3,8(a0)
   11fe8:	ff010113          	addi	sp,sp,-16
   11fec:	0105d593          	srli	a1,a1,0x10
   11ff0:	01f65613          	srli	a2,a2,0x1f
   11ff4:	0108d893          	srli	a7,a7,0x10
   11ff8:	00f6f6b3          	and	a3,a3,a5
   11ffc:	01f75513          	srli	a0,a4,0x1f
   12000:	04f80e63          	beq	a6,a5,1205c <__getf2+0xb0>
   12004:	04f68063          	beq	a3,a5,12044 <__getf2+0x98>
   12008:	06081463          	bnez	a6,12070 <__getf2+0xc4>
   1200c:	01d367b3          	or	a5,t1,t4
   12010:	01c7e7b3          	or	a5,a5,t3
   12014:	00b7e7b3          	or	a5,a5,a1
   12018:	00069a63          	bnez	a3,1202c <__getf2+0x80>
   1201c:	005fe733          	or	a4,t6,t0
   12020:	01e76733          	or	a4,a4,t5
   12024:	01176733          	or	a4,a4,a7
   12028:	06070e63          	beqz	a4,120a4 <__getf2+0xf8>
   1202c:	06078663          	beqz	a5,12098 <__getf2+0xec>
   12030:	08a60c63          	beq	a2,a0,120c8 <__getf2+0x11c>
   12034:	00100513          	li	a0,1
   12038:	06061263          	bnez	a2,1209c <__getf2+0xf0>
   1203c:	01010113          	addi	sp,sp,16
   12040:	00008067          	ret
   12044:	005fe7b3          	or	a5,t6,t0
   12048:	01e7e7b3          	or	a5,a5,t5
   1204c:	0117e7b3          	or	a5,a5,a7
   12050:	fa078ce3          	beqz	a5,12008 <__getf2+0x5c>
   12054:	ffe00513          	li	a0,-2
   12058:	fe5ff06f          	j	1203c <__getf2+0x90>
   1205c:	01d367b3          	or	a5,t1,t4
   12060:	01c7e7b3          	or	a5,a5,t3
   12064:	00b7e7b3          	or	a5,a5,a1
   12068:	fe0796e3          	bnez	a5,12054 <__getf2+0xa8>
   1206c:	05068263          	beq	a3,a6,120b0 <__getf2+0x104>
   12070:	00069a63          	bnez	a3,12084 <__getf2+0xd8>
   12074:	005fe7b3          	or	a5,t6,t0
   12078:	01e7e7b3          	or	a5,a5,t5
   1207c:	0117e7b3          	or	a5,a5,a7
   12080:	fa078ae3          	beqz	a5,12034 <__getf2+0x88>
   12084:	faa618e3          	bne	a2,a0,12034 <__getf2+0x88>
   12088:	0506d063          	bge	a3,a6,120c8 <__getf2+0x11c>
   1208c:	00051863          	bnez	a0,1209c <__getf2+0xf0>
   12090:	00100513          	li	a0,1
   12094:	fa9ff06f          	j	1203c <__getf2+0x90>
   12098:	fa0512e3          	bnez	a0,1203c <__getf2+0x90>
   1209c:	fff00513          	li	a0,-1
   120a0:	f9dff06f          	j	1203c <__getf2+0x90>
   120a4:	00000513          	li	a0,0
   120a8:	f8078ae3          	beqz	a5,1203c <__getf2+0x90>
   120ac:	f89ff06f          	j	12034 <__getf2+0x88>
   120b0:	005fe7b3          	or	a5,t6,t0
   120b4:	01e7e7b3          	or	a5,a5,t5
   120b8:	0117e7b3          	or	a5,a5,a7
   120bc:	fc0784e3          	beqz	a5,12084 <__getf2+0xd8>
   120c0:	ffe00513          	li	a0,-2
   120c4:	f79ff06f          	j	1203c <__getf2+0x90>
   120c8:	00d84863          	blt	a6,a3,120d8 <__getf2+0x12c>
   120cc:	f6b8e4e3          	bltu	a7,a1,12034 <__getf2+0x88>
   120d0:	01158a63          	beq	a1,a7,120e4 <__getf2+0x138>
   120d4:	0115fe63          	bgeu	a1,a7,120f0 <__getf2+0x144>
   120d8:	fc0602e3          	beqz	a2,1209c <__getf2+0xf0>
   120dc:	00060513          	mv	a0,a2
   120e0:	f5dff06f          	j	1203c <__getf2+0x90>
   120e4:	f5cf68e3          	bltu	t5,t3,12034 <__getf2+0x88>
   120e8:	01cf0863          	beq	t5,t3,120f8 <__getf2+0x14c>
   120ec:	ffee66e3          	bltu	t3,t5,120d8 <__getf2+0x12c>
   120f0:	00000513          	li	a0,0
   120f4:	f49ff06f          	j	1203c <__getf2+0x90>
   120f8:	f26feee3          	bltu	t6,t1,12034 <__getf2+0x88>
   120fc:	006f8c63          	beq	t6,t1,12114 <__getf2+0x168>
   12100:	fdf36ce3          	bltu	t1,t6,120d8 <__getf2+0x12c>
   12104:	00000513          	li	a0,0
   12108:	f26f9ae3          	bne	t6,t1,1203c <__getf2+0x90>
   1210c:	f25ef8e3          	bgeu	t4,t0,1203c <__getf2+0x90>
   12110:	fc9ff06f          	j	120d8 <__getf2+0x12c>
   12114:	ffd2f6e3          	bgeu	t0,t4,12100 <__getf2+0x154>
   12118:	f1dff06f          	j	12034 <__getf2+0x88>

0001211c <__letf2>:
   1211c:	00c52603          	lw	a2,12(a0)
   12120:	00c5a703          	lw	a4,12(a1)
   12124:	000087b7          	lui	a5,0x8
   12128:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   1212c:	01065813          	srli	a6,a2,0x10
   12130:	01075693          	srli	a3,a4,0x10
   12134:	0005a283          	lw	t0,0(a1)
   12138:	0045af83          	lw	t6,4(a1)
   1213c:	0085af03          	lw	t5,8(a1)
   12140:	01071e93          	slli	t4,a4,0x10
   12144:	01061593          	slli	a1,a2,0x10
   12148:	00f87833          	and	a6,a6,a5
   1214c:	00052e03          	lw	t3,0(a0)
   12150:	00452883          	lw	a7,4(a0)
   12154:	00852303          	lw	t1,8(a0)
   12158:	ff010113          	addi	sp,sp,-16
   1215c:	0105d593          	srli	a1,a1,0x10
   12160:	01f65613          	srli	a2,a2,0x1f
   12164:	010ede93          	srli	t4,t4,0x10
   12168:	00f6f6b3          	and	a3,a3,a5
   1216c:	01f75513          	srli	a0,a4,0x1f
   12170:	06f80663          	beq	a6,a5,121dc <__letf2+0xc0>
   12174:	02f68a63          	beq	a3,a5,121a8 <__letf2+0x8c>
   12178:	06081c63          	bnez	a6,121f0 <__letf2+0xd4>
   1217c:	01c8e7b3          	or	a5,a7,t3
   12180:	0067e7b3          	or	a5,a5,t1
   12184:	00b7e7b3          	or	a5,a5,a1
   12188:	02069e63          	bnez	a3,121c4 <__letf2+0xa8>
   1218c:	005fe733          	or	a4,t6,t0
   12190:	01e76733          	or	a4,a4,t5
   12194:	01d76733          	or	a4,a4,t4
   12198:	02071663          	bnez	a4,121c4 <__letf2+0xa8>
   1219c:	00000513          	li	a0,0
   121a0:	06078e63          	beqz	a5,1221c <__letf2+0x100>
   121a4:	0280006f          	j	121cc <__letf2+0xb0>
   121a8:	005fe7b3          	or	a5,t6,t0
   121ac:	01e7e7b3          	or	a5,a5,t5
   121b0:	01d7e7b3          	or	a5,a5,t4
   121b4:	fc0782e3          	beqz	a5,12178 <__letf2+0x5c>
   121b8:	00200513          	li	a0,2
   121bc:	01010113          	addi	sp,sp,16
   121c0:	00008067          	ret
   121c4:	04078a63          	beqz	a5,12218 <__letf2+0xfc>
   121c8:	06a60a63          	beq	a2,a0,1223c <__letf2+0x120>
   121cc:	00100513          	li	a0,1
   121d0:	04060663          	beqz	a2,1221c <__letf2+0x100>
   121d4:	fff00513          	li	a0,-1
   121d8:	0440006f          	j	1221c <__letf2+0x100>
   121dc:	01c8e7b3          	or	a5,a7,t3
   121e0:	0067e7b3          	or	a5,a5,t1
   121e4:	00b7e7b3          	or	a5,a5,a1
   121e8:	fc0798e3          	bnez	a5,121b8 <__letf2+0x9c>
   121ec:	03068c63          	beq	a3,a6,12224 <__letf2+0x108>
   121f0:	00069a63          	bnez	a3,12204 <__letf2+0xe8>
   121f4:	005fe7b3          	or	a5,t6,t0
   121f8:	01e7e7b3          	or	a5,a5,t5
   121fc:	01d7e7b3          	or	a5,a5,t4
   12200:	fc0786e3          	beqz	a5,121cc <__letf2+0xb0>
   12204:	fca614e3          	bne	a2,a0,121cc <__letf2+0xb0>
   12208:	0306da63          	bge	a3,a6,1223c <__letf2+0x120>
   1220c:	fc0514e3          	bnez	a0,121d4 <__letf2+0xb8>
   12210:	00100513          	li	a0,1
   12214:	0080006f          	j	1221c <__letf2+0x100>
   12218:	fa050ee3          	beqz	a0,121d4 <__letf2+0xb8>
   1221c:	01010113          	addi	sp,sp,16
   12220:	00008067          	ret
   12224:	005fe7b3          	or	a5,t6,t0
   12228:	01e7e7b3          	or	a5,a5,t5
   1222c:	01d7e7b3          	or	a5,a5,t4
   12230:	fc078ae3          	beqz	a5,12204 <__letf2+0xe8>
   12234:	00200513          	li	a0,2
   12238:	f85ff06f          	j	121bc <__letf2+0xa0>
   1223c:	00d84863          	blt	a6,a3,1224c <__letf2+0x130>
   12240:	f8bee6e3          	bltu	t4,a1,121cc <__letf2+0xb0>
   12244:	01d58a63          	beq	a1,t4,12258 <__letf2+0x13c>
   12248:	01d5fe63          	bgeu	a1,t4,12264 <__letf2+0x148>
   1224c:	f80604e3          	beqz	a2,121d4 <__letf2+0xb8>
   12250:	00060513          	mv	a0,a2
   12254:	fc9ff06f          	j	1221c <__letf2+0x100>
   12258:	f66f6ae3          	bltu	t5,t1,121cc <__letf2+0xb0>
   1225c:	006f0863          	beq	t5,t1,1226c <__letf2+0x150>
   12260:	ffe366e3          	bltu	t1,t5,1224c <__letf2+0x130>
   12264:	00000513          	li	a0,0
   12268:	fb5ff06f          	j	1221c <__letf2+0x100>
   1226c:	f71fe0e3          	bltu	t6,a7,121cc <__letf2+0xb0>
   12270:	011f8c63          	beq	t6,a7,12288 <__letf2+0x16c>
   12274:	fdf8ece3          	bltu	a7,t6,1224c <__letf2+0x130>
   12278:	00000513          	li	a0,0
   1227c:	fb1f90e3          	bne	t6,a7,1221c <__letf2+0x100>
   12280:	f85e7ee3          	bgeu	t3,t0,1221c <__letf2+0x100>
   12284:	fc9ff06f          	j	1224c <__letf2+0x130>
   12288:	ffc2f6e3          	bgeu	t0,t3,12274 <__letf2+0x158>
   1228c:	f41ff06f          	j	121cc <__letf2+0xb0>

00012290 <__multf3>:
   12290:	f4010113          	addi	sp,sp,-192
   12294:	0b412423          	sw	s4,168(sp)
   12298:	00c5aa03          	lw	s4,12(a1)
   1229c:	0045a783          	lw	a5,4(a1)
   122a0:	0085a683          	lw	a3,8(a1)
   122a4:	0b212823          	sw	s2,176(sp)
   122a8:	0005a903          	lw	s2,0(a1)
   122ac:	010a1713          	slli	a4,s4,0x10
   122b0:	000085b7          	lui	a1,0x8
   122b4:	0a812c23          	sw	s0,184(sp)
   122b8:	01075713          	srli	a4,a4,0x10
   122bc:	010a5413          	srli	s0,s4,0x10
   122c0:	fff58593          	addi	a1,a1,-1 # 7fff <localeconv+0x7>
   122c4:	0a912a23          	sw	s1,180(sp)
   122c8:	0b312623          	sw	s3,172(sp)
   122cc:	0b512223          	sw	s5,164(sp)
   122d0:	0b612023          	sw	s6,160(sp)
   122d4:	09712e23          	sw	s7,156(sp)
   122d8:	07412623          	sw	s4,108(sp)
   122dc:	0a112e23          	sw	ra,188(sp)
   122e0:	09812c23          	sw	s8,152(sp)
   122e4:	09912a23          	sw	s9,148(sp)
   122e8:	09a12823          	sw	s10,144(sp)
   122ec:	09b12623          	sw	s11,140(sp)
   122f0:	07212023          	sw	s2,96(sp)
   122f4:	06f12223          	sw	a5,100(sp)
   122f8:	06d12423          	sw	a3,104(sp)
   122fc:	03212823          	sw	s2,48(sp)
   12300:	02f12a23          	sw	a5,52(sp)
   12304:	02d12c23          	sw	a3,56(sp)
   12308:	02e12e23          	sw	a4,60(sp)
   1230c:	00b47433          	and	s0,s0,a1
   12310:	00050493          	mv	s1,a0
   12314:	00062a83          	lw	s5,0(a2)
   12318:	00462b03          	lw	s6,4(a2)
   1231c:	00862b83          	lw	s7,8(a2)
   12320:	00c62983          	lw	s3,12(a2)
   12324:	01fa5a13          	srli	s4,s4,0x1f
   12328:	34040863          	beqz	s0,12678 <__multf3+0x3e8>
   1232c:	40b40863          	beq	s0,a1,1273c <__multf3+0x4ac>
   12330:	00080637          	lui	a2,0x80
   12334:	00371713          	slli	a4,a4,0x3
   12338:	01d6d513          	srli	a0,a3,0x1d
   1233c:	00c76733          	or	a4,a4,a2
   12340:	01d7d593          	srli	a1,a5,0x1d
   12344:	01d95613          	srli	a2,s2,0x1d
   12348:	00379793          	slli	a5,a5,0x3
   1234c:	00a76733          	or	a4,a4,a0
   12350:	00369693          	slli	a3,a3,0x3
   12354:	ffffc537          	lui	a0,0xffffc
   12358:	00c7e633          	or	a2,a5,a2
   1235c:	00d5e6b3          	or	a3,a1,a3
   12360:	00391793          	slli	a5,s2,0x3
   12364:	00150513          	addi	a0,a0,1 # ffffc001 <__freertos_irq_stack_top+0xfffe42e1>
   12368:	02e12e23          	sw	a4,60(sp)
   1236c:	02d12c23          	sw	a3,56(sp)
   12370:	02c12a23          	sw	a2,52(sp)
   12374:	02f12823          	sw	a5,48(sp)
   12378:	00a40433          	add	s0,s0,a0
   1237c:	00000913          	li	s2,0
   12380:	00000c13          	li	s8,0
   12384:	01099513          	slli	a0,s3,0x10
   12388:	000087b7          	lui	a5,0x8
   1238c:	0109d713          	srli	a4,s3,0x10
   12390:	01055513          	srli	a0,a0,0x10
   12394:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   12398:	07312623          	sw	s3,108(sp)
   1239c:	07512023          	sw	s5,96(sp)
   123a0:	07612223          	sw	s6,100(sp)
   123a4:	07712423          	sw	s7,104(sp)
   123a8:	05512023          	sw	s5,64(sp)
   123ac:	05612223          	sw	s6,68(sp)
   123b0:	05712423          	sw	s7,72(sp)
   123b4:	04a12623          	sw	a0,76(sp)
   123b8:	00f77733          	and	a4,a4,a5
   123bc:	01f9d993          	srli	s3,s3,0x1f
   123c0:	1e070c63          	beqz	a4,125b8 <__multf3+0x328>
   123c4:	08f70663          	beq	a4,a5,12450 <__multf3+0x1c0>
   123c8:	000807b7          	lui	a5,0x80
   123cc:	00351513          	slli	a0,a0,0x3
   123d0:	01db5693          	srli	a3,s6,0x1d
   123d4:	00f56533          	or	a0,a0,a5
   123d8:	003b1b13          	slli	s6,s6,0x3
   123dc:	01dad793          	srli	a5,s5,0x1d
   123e0:	00fb6b33          	or	s6,s6,a5
   123e4:	ffffc7b7          	lui	a5,0xffffc
   123e8:	01dbd613          	srli	a2,s7,0x1d
   123ec:	00178793          	addi	a5,a5,1 # ffffc001 <__freertos_irq_stack_top+0xfffe42e1>
   123f0:	003b9b93          	slli	s7,s7,0x3
   123f4:	0176ebb3          	or	s7,a3,s7
   123f8:	00c56533          	or	a0,a0,a2
   123fc:	003a9a93          	slli	s5,s5,0x3
   12400:	00f707b3          	add	a5,a4,a5
   12404:	04a12623          	sw	a0,76(sp)
   12408:	05712423          	sw	s7,72(sp)
   1240c:	05612223          	sw	s6,68(sp)
   12410:	05512023          	sw	s5,64(sp)
   12414:	00f40433          	add	s0,s0,a5
   12418:	00000693          	li	a3,0
   1241c:	00140613          	addi	a2,s0,1 # 80001 <__freertos_irq_stack_top+0x682e1>
   12420:	013a47b3          	xor	a5,s4,s3
   12424:	00f00713          	li	a4,15
   12428:	00c12223          	sw	a2,4(sp)
   1242c:	00078593          	mv	a1,a5
   12430:	35276e63          	bltu	a4,s2,1278c <__multf3+0x4fc>
   12434:	00004617          	auipc	a2,0x4
   12438:	dac60613          	addi	a2,a2,-596 # 161e0 <zeroes.4467+0x90>
   1243c:	00291713          	slli	a4,s2,0x2
   12440:	00c70733          	add	a4,a4,a2
   12444:	00072703          	lw	a4,0(a4)
   12448:	00c70733          	add	a4,a4,a2
   1244c:	00070067          	jr	a4
   12450:	016aeab3          	or	s5,s5,s6
   12454:	017aeab3          	or	s5,s5,s7
   12458:	00aaeab3          	or	s5,s5,a0
   1245c:	00e40433          	add	s0,s0,a4
   12460:	320a9063          	bnez	s5,12780 <__multf3+0x4f0>
   12464:	00296913          	ori	s2,s2,2
   12468:	00200693          	li	a3,2
   1246c:	fb1ff06f          	j	1241c <__multf3+0x18c>
   12470:	00008737          	lui	a4,0x8
   12474:	00000793          	li	a5,0
   12478:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
   1247c:	000086b7          	lui	a3,0x8
   12480:	00000513          	li	a0,0
   12484:	00000813          	li	a6,0
   12488:	00000593          	li	a1,0
   1248c:	01171713          	slli	a4,a4,0x11
   12490:	06d11623          	sh	a3,108(sp)
   12494:	01175713          	srli	a4,a4,0x11
   12498:	01071693          	slli	a3,a4,0x10
   1249c:	06c12703          	lw	a4,108(sp)
   124a0:	80010637          	lui	a2,0x80010
   124a4:	fff60613          	addi	a2,a2,-1 # 8000ffff <__freertos_irq_stack_top+0x7fff82df>
   124a8:	00c77733          	and	a4,a4,a2
   124ac:	00d76733          	or	a4,a4,a3
   124b0:	00171713          	slli	a4,a4,0x1
   124b4:	0bc12083          	lw	ra,188(sp)
   124b8:	0b812403          	lw	s0,184(sp)
   124bc:	01f79793          	slli	a5,a5,0x1f
   124c0:	00175713          	srli	a4,a4,0x1
   124c4:	00f76733          	or	a4,a4,a5
   124c8:	00a4a423          	sw	a0,8(s1)
   124cc:	00b4a023          	sw	a1,0(s1)
   124d0:	0104a223          	sw	a6,4(s1)
   124d4:	00e4a623          	sw	a4,12(s1)
   124d8:	00048513          	mv	a0,s1
   124dc:	0b012903          	lw	s2,176(sp)
   124e0:	0b412483          	lw	s1,180(sp)
   124e4:	0ac12983          	lw	s3,172(sp)
   124e8:	0a812a03          	lw	s4,168(sp)
   124ec:	0a412a83          	lw	s5,164(sp)
   124f0:	0a012b03          	lw	s6,160(sp)
   124f4:	09c12b83          	lw	s7,156(sp)
   124f8:	09812c03          	lw	s8,152(sp)
   124fc:	09412c83          	lw	s9,148(sp)
   12500:	09012d03          	lw	s10,144(sp)
   12504:	08c12d83          	lw	s11,140(sp)
   12508:	0c010113          	addi	sp,sp,192
   1250c:	00008067          	ret
   12510:	000a0593          	mv	a1,s4
   12514:	03012783          	lw	a5,48(sp)
   12518:	000c0693          	mv	a3,s8
   1251c:	04f12823          	sw	a5,80(sp)
   12520:	03412783          	lw	a5,52(sp)
   12524:	04f12a23          	sw	a5,84(sp)
   12528:	03812783          	lw	a5,56(sp)
   1252c:	04f12c23          	sw	a5,88(sp)
   12530:	03c12783          	lw	a5,60(sp)
   12534:	04f12e23          	sw	a5,92(sp)
   12538:	00200793          	li	a5,2
   1253c:	04f68e63          	beq	a3,a5,12598 <__multf3+0x308>
   12540:	00300793          	li	a5,3
   12544:	f2f686e3          	beq	a3,a5,12470 <__multf3+0x1e0>
   12548:	00100793          	li	a5,1
   1254c:	54f696e3          	bne	a3,a5,13298 <__multf3+0x1008>
   12550:	00058793          	mv	a5,a1
   12554:	00000713          	li	a4,0
   12558:	00000693          	li	a3,0
   1255c:	00000513          	li	a0,0
   12560:	00000813          	li	a6,0
   12564:	00000593          	li	a1,0
   12568:	f25ff06f          	j	1248c <__multf3+0x1fc>
   1256c:	00098593          	mv	a1,s3
   12570:	04012783          	lw	a5,64(sp)
   12574:	04f12823          	sw	a5,80(sp)
   12578:	04412783          	lw	a5,68(sp)
   1257c:	04f12a23          	sw	a5,84(sp)
   12580:	04812783          	lw	a5,72(sp)
   12584:	04f12c23          	sw	a5,88(sp)
   12588:	04c12783          	lw	a5,76(sp)
   1258c:	04f12e23          	sw	a5,92(sp)
   12590:	00200793          	li	a5,2
   12594:	faf696e3          	bne	a3,a5,12540 <__multf3+0x2b0>
   12598:	00008737          	lui	a4,0x8
   1259c:	00058793          	mv	a5,a1
   125a0:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
   125a4:	00000693          	li	a3,0
   125a8:	00000513          	li	a0,0
   125ac:	00000813          	li	a6,0
   125b0:	00000593          	li	a1,0
   125b4:	ed9ff06f          	j	1248c <__multf3+0x1fc>
   125b8:	016ae7b3          	or	a5,s5,s6
   125bc:	0177e7b3          	or	a5,a5,s7
   125c0:	00a7e7b3          	or	a5,a5,a0
   125c4:	1a078863          	beqz	a5,12774 <__multf3+0x4e4>
   125c8:	260508e3          	beqz	a0,13038 <__multf3+0xda8>
   125cc:	3e9020ef          	jal	ra,151b4 <__clzsi2>
   125d0:	ff450813          	addi	a6,a0,-12
   125d4:	02000893          	li	a7,32
   125d8:	410888b3          	sub	a7,a7,a6
   125dc:	00000793          	li	a5,0
   125e0:	40f00733          	neg	a4,a5
   125e4:	00271713          	slli	a4,a4,0x2
   125e8:	04010593          	addi	a1,sp,64
   125ec:	00c70713          	addi	a4,a4,12
   125f0:	00e58733          	add	a4,a1,a4
   125f4:	00279e13          	slli	t3,a5,0x2
   125f8:	00072683          	lw	a3,0(a4)
   125fc:	ffc72603          	lw	a2,-4(a4)
   12600:	01c70333          	add	t1,a4,t3
   12604:	010696b3          	sll	a3,a3,a6
   12608:	01165633          	srl	a2,a2,a7
   1260c:	00c6e6b3          	or	a3,a3,a2
   12610:	00d32023          	sw	a3,0(t1)
   12614:	ffc70713          	addi	a4,a4,-4
   12618:	fee590e3          	bne	a1,a4,125f8 <__multf3+0x368>
   1261c:	08010713          	addi	a4,sp,128
   12620:	01c70e33          	add	t3,a4,t3
   12624:	04012703          	lw	a4,64(sp)
   12628:	fff78793          	addi	a5,a5,-1
   1262c:	01071833          	sll	a6,a4,a6
   12630:	fd0e2023          	sw	a6,-64(t3)
   12634:	fff00713          	li	a4,-1
   12638:	02e78463          	beq	a5,a4,12660 <__multf3+0x3d0>
   1263c:	00279793          	slli	a5,a5,0x2
   12640:	00f587b3          	add	a5,a1,a5
   12644:	0007a023          	sw	zero,0(a5)
   12648:	ffc78713          	addi	a4,a5,-4
   1264c:	00f58a63          	beq	a1,a5,12660 <__multf3+0x3d0>
   12650:	00070793          	mv	a5,a4
   12654:	0007a023          	sw	zero,0(a5)
   12658:	ffc78713          	addi	a4,a5,-4
   1265c:	fef59ae3          	bne	a1,a5,12650 <__multf3+0x3c0>
   12660:	ffffc7b7          	lui	a5,0xffffc
   12664:	01178793          	addi	a5,a5,17 # ffffc011 <__freertos_irq_stack_top+0xfffe42f1>
   12668:	40a787b3          	sub	a5,a5,a0
   1266c:	00f40433          	add	s0,s0,a5
   12670:	00000693          	li	a3,0
   12674:	da9ff06f          	j	1241c <__multf3+0x18c>
   12678:	0127e633          	or	a2,a5,s2
   1267c:	00d66633          	or	a2,a2,a3
   12680:	00e66633          	or	a2,a2,a4
   12684:	0e060063          	beqz	a2,12764 <__multf3+0x4d4>
   12688:	220700e3          	beqz	a4,130a8 <__multf3+0xe18>
   1268c:	00070513          	mv	a0,a4
   12690:	325020ef          	jal	ra,151b4 <__clzsi2>
   12694:	ff450813          	addi	a6,a0,-12
   12698:	02000893          	li	a7,32
   1269c:	410888b3          	sub	a7,a7,a6
   126a0:	00000713          	li	a4,0
   126a4:	40e007b3          	neg	a5,a4
   126a8:	00279793          	slli	a5,a5,0x2
   126ac:	03010593          	addi	a1,sp,48
   126b0:	00c78793          	addi	a5,a5,12
   126b4:	00f587b3          	add	a5,a1,a5
   126b8:	00271e13          	slli	t3,a4,0x2
   126bc:	0007a683          	lw	a3,0(a5)
   126c0:	ffc7a603          	lw	a2,-4(a5)
   126c4:	01c78333          	add	t1,a5,t3
   126c8:	010696b3          	sll	a3,a3,a6
   126cc:	01165633          	srl	a2,a2,a7
   126d0:	00c6e6b3          	or	a3,a3,a2
   126d4:	00d32023          	sw	a3,0(t1)
   126d8:	ffc78793          	addi	a5,a5,-4
   126dc:	fef590e3          	bne	a1,a5,126bc <__multf3+0x42c>
   126e0:	08010793          	addi	a5,sp,128
   126e4:	01c78e33          	add	t3,a5,t3
   126e8:	03012783          	lw	a5,48(sp)
   126ec:	fff70713          	addi	a4,a4,-1
   126f0:	01079833          	sll	a6,a5,a6
   126f4:	fb0e2823          	sw	a6,-80(t3)
   126f8:	fff00793          	li	a5,-1
   126fc:	02f70463          	beq	a4,a5,12724 <__multf3+0x494>
   12700:	00271713          	slli	a4,a4,0x2
   12704:	00e587b3          	add	a5,a1,a4
   12708:	0007a023          	sw	zero,0(a5)
   1270c:	ffc78713          	addi	a4,a5,-4
   12710:	00f58a63          	beq	a1,a5,12724 <__multf3+0x494>
   12714:	00070793          	mv	a5,a4
   12718:	0007a023          	sw	zero,0(a5)
   1271c:	ffc78713          	addi	a4,a5,-4
   12720:	fef59ae3          	bne	a1,a5,12714 <__multf3+0x484>
   12724:	ffffc437          	lui	s0,0xffffc
   12728:	01140413          	addi	s0,s0,17 # ffffc011 <__freertos_irq_stack_top+0xfffe42f1>
   1272c:	40a40433          	sub	s0,s0,a0
   12730:	00000913          	li	s2,0
   12734:	00000c13          	li	s8,0
   12738:	c4dff06f          	j	12384 <__multf3+0xf4>
   1273c:	0127e7b3          	or	a5,a5,s2
   12740:	00d7e7b3          	or	a5,a5,a3
   12744:	00e7e7b3          	or	a5,a5,a4
   12748:	00079863          	bnez	a5,12758 <__multf3+0x4c8>
   1274c:	00800913          	li	s2,8
   12750:	00200c13          	li	s8,2
   12754:	c31ff06f          	j	12384 <__multf3+0xf4>
   12758:	00c00913          	li	s2,12
   1275c:	00300c13          	li	s8,3
   12760:	c25ff06f          	j	12384 <__multf3+0xf4>
   12764:	00400913          	li	s2,4
   12768:	00000413          	li	s0,0
   1276c:	00100c13          	li	s8,1
   12770:	c15ff06f          	j	12384 <__multf3+0xf4>
   12774:	00196913          	ori	s2,s2,1
   12778:	00100693          	li	a3,1
   1277c:	ca1ff06f          	j	1241c <__multf3+0x18c>
   12780:	00396913          	ori	s2,s2,3
   12784:	00300693          	li	a3,3
   12788:	c95ff06f          	j	1241c <__multf3+0x18c>
   1278c:	03012683          	lw	a3,48(sp)
   12790:	04012503          	lw	a0,64(sp)
   12794:	000105b7          	lui	a1,0x10
   12798:	fff58713          	addi	a4,a1,-1 # ffff <_svfiprintf_r+0xce7>
   1279c:	0106de13          	srli	t3,a3,0x10
   127a0:	01055293          	srli	t0,a0,0x10
   127a4:	00e6f6b3          	and	a3,a3,a4
   127a8:	00e57533          	and	a0,a0,a4
   127ac:	02d50733          	mul	a4,a0,a3
   127b0:	02ae0633          	mul	a2,t3,a0
   127b4:	01075b13          	srli	s6,a4,0x10
   127b8:	02d28833          	mul	a6,t0,a3
   127bc:	00c80833          	add	a6,a6,a2
   127c0:	010b0b33          	add	s6,s6,a6
   127c4:	025e0c33          	mul	s8,t3,t0
   127c8:	00cb7463          	bgeu	s6,a2,127d0 <__multf3+0x540>
   127cc:	00bc0c33          	add	s8,s8,a1
   127d0:	04412603          	lw	a2,68(sp)
   127d4:	00010837          	lui	a6,0x10
   127d8:	fff80593          	addi	a1,a6,-1 # ffff <_svfiprintf_r+0xce7>
   127dc:	00b678b3          	and	a7,a2,a1
   127e0:	01065e93          	srli	t4,a2,0x10
   127e4:	00bb7633          	and	a2,s6,a1
   127e8:	00b77733          	and	a4,a4,a1
   127ec:	01061613          	slli	a2,a2,0x10
   127f0:	00e60733          	add	a4,a2,a4
   127f4:	031e05b3          	mul	a1,t3,a7
   127f8:	02e12623          	sw	a4,44(sp)
   127fc:	06e12023          	sw	a4,96(sp)
   12800:	01112e23          	sw	a7,28(sp)
   12804:	01d12623          	sw	t4,12(sp)
   12808:	010b5b13          	srli	s6,s6,0x10
   1280c:	02d88333          	mul	t1,a7,a3
   12810:	02de8733          	mul	a4,t4,a3
   12814:	01035893          	srli	a7,t1,0x10
   12818:	00b70733          	add	a4,a4,a1
   1281c:	00e888b3          	add	a7,a7,a4
   12820:	03de0bb3          	mul	s7,t3,t4
   12824:	00b8f463          	bgeu	a7,a1,1282c <__multf3+0x59c>
   12828:	010b8bb3          	add	s7,s7,a6
   1282c:	03412583          	lw	a1,52(sp)
   12830:	00010737          	lui	a4,0x10
   12834:	fff70613          	addi	a2,a4,-1 # ffff <_svfiprintf_r+0xce7>
   12838:	00c8fab3          	and	s5,a7,a2
   1283c:	0105df13          	srli	t5,a1,0x10
   12840:	00c37333          	and	t1,t1,a2
   12844:	00c5f5b3          	and	a1,a1,a2
   12848:	010a9a93          	slli	s5,s5,0x10
   1284c:	006a8ab3          	add	s5,s5,t1
   12850:	02b50eb3          	mul	t4,a0,a1
   12854:	01e12823          	sw	t5,16(sp)
   12858:	0108d893          	srli	a7,a7,0x10
   1285c:	015b0833          	add	a6,s6,s5
   12860:	02af0333          	mul	t1,t5,a0
   12864:	010ed613          	srli	a2,t4,0x10
   12868:	02b28933          	mul	s2,t0,a1
   1286c:	00690933          	add	s2,s2,t1
   12870:	01260633          	add	a2,a2,s2
   12874:	03e28933          	mul	s2,t0,t5
   12878:	00667463          	bgeu	a2,t1,12880 <__multf3+0x5f0>
   1287c:	00e90933          	add	s2,s2,a4
   12880:	00010337          	lui	t1,0x10
   12884:	fff30f93          	addi	t6,t1,-1 # ffff <_svfiprintf_r+0xce7>
   12888:	01f67733          	and	a4,a2,t6
   1288c:	01065613          	srli	a2,a2,0x10
   12890:	01012383          	lw	t2,16(sp)
   12894:	00c12983          	lw	s3,12(sp)
   12898:	01260933          	add	s2,a2,s2
   1289c:	01c12603          	lw	a2,28(sp)
   128a0:	01071f13          	slli	t5,a4,0x10
   128a4:	01fef733          	and	a4,t4,t6
   128a8:	02c58eb3          	mul	t4,a1,a2
   128ac:	00ef0733          	add	a4,t5,a4
   128b0:	02c38fb3          	mul	t6,t2,a2
   128b4:	010edf13          	srli	t5,t4,0x10
   128b8:	02b98633          	mul	a2,s3,a1
   128bc:	01f60633          	add	a2,a2,t6
   128c0:	00cf0633          	add	a2,t5,a2
   128c4:	02798f33          	mul	t5,s3,t2
   128c8:	01f67463          	bgeu	a2,t6,128d0 <__multf3+0x640>
   128cc:	006f0f33          	add	t5,t5,t1
   128d0:	04812f83          	lw	t6,72(sp)
   128d4:	00010337          	lui	t1,0x10
   128d8:	fff30393          	addi	t2,t1,-1 # ffff <_svfiprintf_r+0xce7>
   128dc:	00767a33          	and	s4,a2,t2
   128e0:	007ffb33          	and	s6,t6,t2
   128e4:	010fd993          	srli	s3,t6,0x10
   128e8:	007efeb3          	and	t4,t4,t2
   128ec:	01065613          	srli	a2,a2,0x10
   128f0:	010a1a13          	slli	s4,s4,0x10
   128f4:	02db0fb3          	mul	t6,s6,a3
   128f8:	01e60d33          	add	s10,a2,t5
   128fc:	01da0a33          	add	s4,s4,t4
   12900:	01612c23          	sw	s6,24(sp)
   12904:	01312a23          	sw	s3,20(sp)
   12908:	036e0633          	mul	a2,t3,s6
   1290c:	010fd393          	srli	t2,t6,0x10
   12910:	02d98eb3          	mul	t4,s3,a3
   12914:	00ce8eb3          	add	t4,t4,a2
   12918:	01d383b3          	add	t2,t2,t4
   1291c:	033e0b33          	mul	s6,t3,s3
   12920:	00c3f463          	bgeu	t2,a2,12928 <__multf3+0x698>
   12924:	006b0b33          	add	s6,s6,t1
   12928:	03812e83          	lw	t4,56(sp)
   1292c:	00010637          	lui	a2,0x10
   12930:	fff60c93          	addi	s9,a2,-1 # ffff <_svfiprintf_r+0xce7>
   12934:	0193f9b3          	and	s3,t2,s9
   12938:	010edf13          	srli	t5,t4,0x10
   1293c:	019fffb3          	and	t6,t6,s9
   12940:	019efeb3          	and	t4,t4,s9
   12944:	0103d393          	srli	t2,t2,0x10
   12948:	01099993          	slli	s3,s3,0x10
   1294c:	02ae8333          	mul	t1,t4,a0
   12950:	016383b3          	add	t2,t2,s6
   12954:	01f989b3          	add	s3,s3,t6
   12958:	02af0b33          	mul	s6,t5,a0
   1295c:	01035c93          	srli	s9,t1,0x10
   12960:	03d28fb3          	mul	t6,t0,t4
   12964:	016f8fb3          	add	t6,t6,s6
   12968:	01fc8fb3          	add	t6,s9,t6
   1296c:	03e28cb3          	mul	s9,t0,t5
   12970:	016ff463          	bgeu	t6,s6,12978 <__multf3+0x6e8>
   12974:	00cc8cb3          	add	s9,s9,a2
   12978:	010c0b33          	add	s6,s8,a6
   1297c:	04c12803          	lw	a6,76(sp)
   12980:	015b3ab3          	sltu	s5,s6,s5
   12984:	01588633          	add	a2,a7,s5
   12988:	000108b7          	lui	a7,0x10
   1298c:	fff88c13          	addi	s8,a7,-1 # ffff <_svfiprintf_r+0xce7>
   12990:	01760633          	add	a2,a2,s7
   12994:	00eb08b3          	add	a7,s6,a4
   12998:	01085b13          	srli	s6,a6,0x10
   1299c:	00e8b733          	sltu	a4,a7,a4
   129a0:	03112023          	sw	a7,32(sp)
   129a4:	01612423          	sw	s6,8(sp)
   129a8:	012608b3          	add	a7,a2,s2
   129ac:	01887833          	and	a6,a6,s8
   129b0:	00e88b33          	add	s6,a7,a4
   129b4:	01837333          	and	t1,t1,s8
   129b8:	0128b933          	sltu	s2,a7,s2
   129bc:	018ff8b3          	and	a7,t6,s8
   129c0:	00812c03          	lw	s8,8(sp)
   129c4:	00eb3733          	sltu	a4,s6,a4
   129c8:	00e96933          	or	s2,s2,a4
   129cc:	01563633          	sltu	a2,a2,s5
   129d0:	02d80bb3          	mul	s7,a6,a3
   129d4:	014b0b33          	add	s6,s6,s4
   129d8:	00c90633          	add	a2,s2,a2
   129dc:	014b3a33          	sltu	s4,s6,s4
   129e0:	01a60633          	add	a2,a2,s10
   129e4:	01460733          	add	a4,a2,s4
   129e8:	013b0b33          	add	s6,s6,s3
   129ec:	01089893          	slli	a7,a7,0x10
   129f0:	013b39b3          	sltu	s3,s6,s3
   129f4:	00770db3          	add	s11,a4,t2
   129f8:	030e0933          	mul	s2,t3,a6
   129fc:	006888b3          	add	a7,a7,t1
   12a00:	010fdf93          	srli	t6,t6,0x10
   12a04:	011b0333          	add	t1,s6,a7
   12a08:	019f8cb3          	add	s9,t6,s9
   12a0c:	013d8fb3          	add	t6,s11,s3
   12a10:	019f8b33          	add	s6,t6,s9
   12a14:	011338b3          	sltu	a7,t1,a7
   12a18:	02612223          	sw	t1,36(sp)
   12a1c:	011b0333          	add	t1,s6,a7
   12a20:	02dc06b3          	mul	a3,s8,a3
   12a24:	011338b3          	sltu	a7,t1,a7
   12a28:	019b3cb3          	sltu	s9,s6,s9
   12a2c:	01473a33          	sltu	s4,a4,s4
   12a30:	011cecb3          	or	s9,s9,a7
   12a34:	02412703          	lw	a4,36(sp)
   12a38:	02012883          	lw	a7,32(sp)
   12a3c:	013fb9b3          	sltu	s3,t6,s3
   12a40:	01a63633          	sltu	a2,a2,s10
   12a44:	007db3b3          	sltu	t2,s11,t2
   12a48:	01466a33          	or	s4,a2,s4
   12a4c:	0133e9b3          	or	s3,t2,s3
   12a50:	012686b3          	add	a3,a3,s2
   12a54:	010bda93          	srli	s5,s7,0x10
   12a58:	013a0a33          	add	s4,s4,s3
   12a5c:	07112223          	sw	a7,100(sp)
   12a60:	06e12423          	sw	a4,104(sp)
   12a64:	00da8ab3          	add	s5,s5,a3
   12a68:	019a0cb3          	add	s9,s4,s9
   12a6c:	038e0fb3          	mul	t6,t3,s8
   12a70:	012af663          	bgeu	s5,s2,12a7c <__multf3+0x7ec>
   12a74:	000108b7          	lui	a7,0x10
   12a78:	011f8fb3          	add	t6,t6,a7
   12a7c:	03c12683          	lw	a3,60(sp)
   12a80:	00010637          	lui	a2,0x10
   12a84:	fff60393          	addi	t2,a2,-1 # ffff <_svfiprintf_r+0xce7>
   12a88:	0106de13          	srli	t3,a3,0x10
   12a8c:	007afc33          	and	s8,s5,t2
   12a90:	0076f6b3          	and	a3,a3,t2
   12a94:	010ada93          	srli	s5,s5,0x10
   12a98:	01fa88b3          	add	a7,s5,t6
   12a9c:	02d50733          	mul	a4,a0,a3
   12aa0:	00088b13          	mv	s6,a7
   12aa4:	010c1c13          	slli	s8,s8,0x10
   12aa8:	007bfbb3          	and	s7,s7,t2
   12aac:	017c0c33          	add	s8,s8,s7
   12ab0:	02d28fb3          	mul	t6,t0,a3
   12ab4:	01075d93          	srli	s11,a4,0x10
   12ab8:	02ae0533          	mul	a0,t3,a0
   12abc:	00af88b3          	add	a7,t6,a0
   12ac0:	011d8fb3          	add	t6,s11,a7
   12ac4:	03c282b3          	mul	t0,t0,t3
   12ac8:	00aff463          	bgeu	t6,a0,12ad0 <__multf3+0x840>
   12acc:	00c282b3          	add	t0,t0,a2
   12ad0:	000108b7          	lui	a7,0x10
   12ad4:	fff88513          	addi	a0,a7,-1 # ffff <_svfiprintf_r+0xce7>
   12ad8:	010fda93          	srli	s5,t6,0x10
   12adc:	00aff633          	and	a2,t6,a0
   12ae0:	00a77733          	and	a4,a4,a0
   12ae4:	01412903          	lw	s2,20(sp)
   12ae8:	01812503          	lw	a0,24(sp)
   12aec:	005a8db3          	add	s11,s5,t0
   12af0:	01012283          	lw	t0,16(sp)
   12af4:	01061613          	slli	a2,a2,0x10
   12af8:	02b50fb3          	mul	t6,a0,a1
   12afc:	00e60633          	add	a2,a2,a4
   12b00:	02a28733          	mul	a4,t0,a0
   12b04:	010fd393          	srli	t2,t6,0x10
   12b08:	02b90533          	mul	a0,s2,a1
   12b0c:	00e50533          	add	a0,a0,a4
   12b10:	00a383b3          	add	t2,t2,a0
   12b14:	03228533          	mul	a0,t0,s2
   12b18:	00e3f463          	bgeu	t2,a4,12b20 <__multf3+0x890>
   12b1c:	01150533          	add	a0,a0,a7
   12b20:	000108b7          	lui	a7,0x10
   12b24:	fff88713          	addi	a4,a7,-1 # ffff <_svfiprintf_r+0xce7>
   12b28:	00e3f933          	and	s2,t2,a4
   12b2c:	0103d393          	srli	t2,t2,0x10
   12b30:	00c12983          	lw	s3,12(sp)
   12b34:	00a383b3          	add	t2,t2,a0
   12b38:	01c12503          	lw	a0,28(sp)
   12b3c:	00eff733          	and	a4,t6,a4
   12b40:	01091913          	slli	s2,s2,0x10
   12b44:	03d982b3          	mul	t0,s3,t4
   12b48:	00e90933          	add	s2,s2,a4
   12b4c:	02ae8a33          	mul	s4,t4,a0
   12b50:	02af0733          	mul	a4,t5,a0
   12b54:	010a5f93          	srli	t6,s4,0x10
   12b58:	00e28533          	add	a0,t0,a4
   12b5c:	00af82b3          	add	t0,t6,a0
   12b60:	03e989b3          	mul	s3,s3,t5
   12b64:	00e2f463          	bgeu	t0,a4,12b6c <__multf3+0x8dc>
   12b68:	011989b3          	add	s3,s3,a7
   12b6c:	01812b83          	lw	s7,24(sp)
   12b70:	01830733          	add	a4,t1,s8
   12b74:	018738b3          	sltu	a7,a4,s8
   12b78:	016c8fb3          	add	t6,s9,s6
   12b7c:	00010cb7          	lui	s9,0x10
   12b80:	011f8c33          	add	s8,t6,a7
   12b84:	fffc8513          	addi	a0,s9,-1 # ffff <_svfiprintf_r+0xce7>
   12b88:	03db8333          	mul	t1,s7,t4
   12b8c:	016fbfb3          	sltu	t6,t6,s6
   12b90:	01412b03          	lw	s6,20(sp)
   12b94:	00aa7a33          	and	s4,s4,a0
   12b98:	01bc0ab3          	add	s5,s8,s11
   12b9c:	011c3c33          	sltu	s8,s8,a7
   12ba0:	00c70733          	add	a4,a4,a2
   12ba4:	00c73633          	sltu	a2,a4,a2
   12ba8:	00ca8d33          	add	s10,s5,a2
   12bac:	01270733          	add	a4,a4,s2
   12bb0:	02612423          	sw	t1,40(sp)
   12bb4:	00a2f333          	and	t1,t0,a0
   12bb8:	01031313          	slli	t1,t1,0x10
   12bbc:	01430333          	add	t1,t1,s4
   12bc0:	03db08b3          	mul	a7,s6,t4
   12bc4:	01273933          	sltu	s2,a4,s2
   12bc8:	0102d293          	srli	t0,t0,0x10
   12bcc:	013282b3          	add	t0,t0,s3
   12bd0:	00670733          	add	a4,a4,t1
   12bd4:	00673333          	sltu	t1,a4,t1
   12bd8:	01babab3          	sltu	s5,s5,s11
   12bdc:	018fefb3          	or	t6,t6,s8
   12be0:	06e12623          	sw	a4,108(sp)
   12be4:	037f0a33          	mul	s4,t5,s7
   12be8:	007d0bb3          	add	s7,s10,t2
   12bec:	012b8533          	add	a0,s7,s2
   12bf0:	005509b3          	add	s3,a0,t0
   12bf4:	007bb3b3          	sltu	t2,s7,t2
   12bf8:	01253533          	sltu	a0,a0,s2
   12bfc:	00a3e3b3          	or	t2,t2,a0
   12c00:	02812503          	lw	a0,40(sp)
   12c04:	00cd3d33          	sltu	s10,s10,a2
   12c08:	01aaed33          	or	s10,s5,s10
   12c0c:	00698633          	add	a2,s3,t1
   12c10:	00663333          	sltu	t1,a2,t1
   12c14:	01055d93          	srli	s11,a0,0x10
   12c18:	01af8d33          	add	s10,t6,s10
   12c1c:	0059b2b3          	sltu	t0,s3,t0
   12c20:	014888b3          	add	a7,a7,s4
   12c24:	0062e2b3          	or	t0,t0,t1
   12c28:	007d0533          	add	a0,s10,t2
   12c2c:	011d88b3          	add	a7,s11,a7
   12c30:	00550533          	add	a0,a0,t0
   12c34:	03eb0333          	mul	t1,s6,t5
   12c38:	0148f463          	bgeu	a7,s4,12c40 <__multf3+0x9b0>
   12c3c:	01930333          	add	t1,t1,s9
   12c40:	02812383          	lw	t2,40(sp)
   12c44:	00010fb7          	lui	t6,0x10
   12c48:	ffff8293          	addi	t0,t6,-1 # ffff <_svfiprintf_r+0xce7>
   12c4c:	0058fa33          	and	s4,a7,t0
   12c50:	0053fb33          	and	s6,t2,t0
   12c54:	00812983          	lw	s3,8(sp)
   12c58:	01012283          	lw	t0,16(sp)
   12c5c:	0108d893          	srli	a7,a7,0x10
   12c60:	006888b3          	add	a7,a7,t1
   12c64:	03028933          	mul	s2,t0,a6
   12c68:	010a1a13          	slli	s4,s4,0x10
   12c6c:	016a0a33          	add	s4,s4,s6
   12c70:	02b80333          	mul	t1,a6,a1
   12c74:	02b985b3          	mul	a1,s3,a1
   12c78:	01035393          	srli	t2,t1,0x10
   12c7c:	012585b3          	add	a1,a1,s2
   12c80:	00b385b3          	add	a1,t2,a1
   12c84:	033282b3          	mul	t0,t0,s3
   12c88:	0125f463          	bgeu	a1,s2,12c90 <__multf3+0xa00>
   12c8c:	01f282b3          	add	t0,t0,t6
   12c90:	00010937          	lui	s2,0x10
   12c94:	fff90f93          	addi	t6,s2,-1 # ffff <_svfiprintf_r+0xce7>
   12c98:	01f5f9b3          	and	s3,a1,t6
   12c9c:	0105d393          	srli	t2,a1,0x10
   12ca0:	00c12a83          	lw	s5,12(sp)
   12ca4:	01c12583          	lw	a1,28(sp)
   12ca8:	01f37333          	and	t1,t1,t6
   12cac:	01099993          	slli	s3,s3,0x10
   12cb0:	02b68fb3          	mul	t6,a3,a1
   12cb4:	006989b3          	add	s3,s3,t1
   12cb8:	005383b3          	add	t2,t2,t0
   12cbc:	02be0333          	mul	t1,t3,a1
   12cc0:	010fd293          	srli	t0,t6,0x10
   12cc4:	02da85b3          	mul	a1,s5,a3
   12cc8:	006585b3          	add	a1,a1,t1
   12ccc:	00b285b3          	add	a1,t0,a1
   12cd0:	03ca82b3          	mul	t0,s5,t3
   12cd4:	0065f463          	bgeu	a1,t1,12cdc <__multf3+0xa4c>
   12cd8:	012282b3          	add	t0,t0,s2
   12cdc:	00812b03          	lw	s6,8(sp)
   12ce0:	00010937          	lui	s2,0x10
   12ce4:	fff90a93          	addi	s5,s2,-1 # ffff <_svfiprintf_r+0xce7>
   12ce8:	0155f333          	and	t1,a1,s5
   12cec:	0105d593          	srli	a1,a1,0x10
   12cf0:	015fffb3          	and	t6,t6,s5
   12cf4:	005582b3          	add	t0,a1,t0
   12cf8:	030e8ab3          	mul	s5,t4,a6
   12cfc:	01031313          	slli	t1,t1,0x10
   12d00:	01f30333          	add	t1,t1,t6
   12d04:	030f05b3          	mul	a1,t5,a6
   12d08:	010adf93          	srli	t6,s5,0x10
   12d0c:	03db0eb3          	mul	t4,s6,t4
   12d10:	00be8eb3          	add	t4,t4,a1
   12d14:	01df8eb3          	add	t4,t6,t4
   12d18:	036f0f33          	mul	t5,t5,s6
   12d1c:	00bef463          	bgeu	t4,a1,12d24 <__multf3+0xa94>
   12d20:	012f0f33          	add	t5,t5,s2
   12d24:	000105b7          	lui	a1,0x10
   12d28:	fff58b13          	addi	s6,a1,-1 # ffff <_svfiprintf_r+0xce7>
   12d2c:	016ef933          	and	s2,t4,s6
   12d30:	010edf93          	srli	t6,t4,0x10
   12d34:	01412c03          	lw	s8,20(sp)
   12d38:	01812e83          	lw	t4,24(sp)
   12d3c:	016afab3          	and	s5,s5,s6
   12d40:	01091913          	slli	s2,s2,0x10
   12d44:	02de8bb3          	mul	s7,t4,a3
   12d48:	01ef8fb3          	add	t6,t6,t5
   12d4c:	01590933          	add	s2,s2,s5
   12d50:	02dc0f33          	mul	t5,s8,a3
   12d54:	010bdb13          	srli	s6,s7,0x10
   12d58:	03de0ab3          	mul	s5,t3,t4
   12d5c:	015f0eb3          	add	t4,t5,s5
   12d60:	01db0f33          	add	t5,s6,t4
   12d64:	03cc0eb3          	mul	t4,s8,t3
   12d68:	015f7463          	bgeu	t5,s5,12d70 <__multf3+0xae0>
   12d6c:	00be8eb3          	add	t4,t4,a1
   12d70:	01460633          	add	a2,a2,s4
   12d74:	01463a33          	sltu	s4,a2,s4
   12d78:	01150533          	add	a0,a0,a7
   12d7c:	01450d33          	add	s10,a0,s4
   12d80:	01360633          	add	a2,a2,s3
   12d84:	013639b3          	sltu	s3,a2,s3
   12d88:	007d0cb3          	add	s9,s10,t2
   12d8c:	013c85b3          	add	a1,s9,s3
   12d90:	00660633          	add	a2,a2,t1
   12d94:	00558c33          	add	s8,a1,t0
   12d98:	00663333          	sltu	t1,a2,t1
   12d9c:	006c0ab3          	add	s5,s8,t1
   12da0:	006ab333          	sltu	t1,s5,t1
   12da4:	005c32b3          	sltu	t0,s8,t0
   12da8:	0062e2b3          	or	t0,t0,t1
   12dac:	00812303          	lw	t1,8(sp)
   12db0:	02d80b33          	mul	s6,a6,a3
   12db4:	01153533          	sltu	a0,a0,a7
   12db8:	014d3a33          	sltu	s4,s10,s4
   12dbc:	0135b5b3          	sltu	a1,a1,s3
   12dc0:	00010db7          	lui	s11,0x10
   12dc4:	007cb3b3          	sltu	t2,s9,t2
   12dc8:	00b3e3b3          	or	t2,t2,a1
   12dcc:	fffd8d13          	addi	s10,s11,-1 # ffff <_svfiprintf_r+0xce7>
   12dd0:	01456533          	or	a0,a0,s4
   12dd4:	01af78b3          	and	a7,t5,s10
   12dd8:	030e0833          	mul	a6,t3,a6
   12ddc:	00750533          	add	a0,a0,t2
   12de0:	012a8ab3          	add	s5,s5,s2
   12de4:	01089893          	slli	a7,a7,0x10
   12de8:	005503b3          	add	t2,a0,t0
   12dec:	01abfbb3          	and	s7,s7,s10
   12df0:	01788bb3          	add	s7,a7,s7
   12df4:	012ab933          	sltu	s2,s5,s2
   12df8:	01f383b3          	add	t2,t2,t6
   12dfc:	010f5f13          	srli	t5,t5,0x10
   12e00:	02d306b3          	mul	a3,t1,a3
   12e04:	01df0f33          	add	t5,t5,t4
   12e08:	012385b3          	add	a1,t2,s2
   12e0c:	017a8ab3          	add	s5,s5,s7
   12e10:	017abbb3          	sltu	s7,s5,s7
   12e14:	01e58eb3          	add	t4,a1,t5
   12e18:	017e8533          	add	a0,t4,s7
   12e1c:	010b5893          	srli	a7,s6,0x10
   12e20:	01f3bfb3          	sltu	t6,t2,t6
   12e24:	0125b933          	sltu	s2,a1,s2
   12e28:	010686b3          	add	a3,a3,a6
   12e2c:	01eebf33          	sltu	t5,t4,t5
   12e30:	01753bb3          	sltu	s7,a0,s7
   12e34:	06c12823          	sw	a2,112(sp)
   12e38:	07512a23          	sw	s5,116(sp)
   12e3c:	00d886b3          	add	a3,a7,a3
   12e40:	012fefb3          	or	t6,t6,s2
   12e44:	017f6bb3          	or	s7,t5,s7
   12e48:	03c30e33          	mul	t3,t1,t3
   12e4c:	0106f463          	bgeu	a3,a6,12e54 <__multf3+0xbc4>
   12e50:	01be0e33          	add	t3,t3,s11
   12e54:	00010837          	lui	a6,0x10
   12e58:	fff80813          	addi	a6,a6,-1 # ffff <_svfiprintf_r+0xce7>
   12e5c:	0106f5b3          	and	a1,a3,a6
   12e60:	01059593          	slli	a1,a1,0x10
   12e64:	010b7b33          	and	s6,s6,a6
   12e68:	01658b33          	add	s6,a1,s6
   12e6c:	0106d693          	srli	a3,a3,0x10
   12e70:	01650533          	add	a0,a0,s6
   12e74:	01f686b3          	add	a3,a3,t6
   12e78:	01653b33          	sltu	s6,a0,s6
   12e7c:	017686b3          	add	a3,a3,s7
   12e80:	016686b3          	add	a3,a3,s6
   12e84:	02c12583          	lw	a1,44(sp)
   12e88:	02012803          	lw	a6,32(sp)
   12e8c:	01c68e33          	add	t3,a3,t3
   12e90:	02412683          	lw	a3,36(sp)
   12e94:	0105eb33          	or	s6,a1,a6
   12e98:	00d61613          	slli	a2,a2,0xd
   12e9c:	0166e5b3          	or	a1,a3,s6
   12ea0:	00d71b13          	slli	s6,a4,0xd
   12ea4:	01375713          	srli	a4,a4,0x13
   12ea8:	06010693          	addi	a3,sp,96
   12eac:	07c12e23          	sw	t3,124(sp)
   12eb0:	06a12c23          	sw	a0,120(sp)
   12eb4:	00c76733          	or	a4,a4,a2
   12eb8:	00bb6b33          	or	s6,s6,a1
   12ebc:	00e6a023          	sw	a4,0(a3) # 8000 <localeconv+0x8>
   12ec0:	07010593          	addi	a1,sp,112
   12ec4:	00468693          	addi	a3,a3,4
   12ec8:	02d58263          	beq	a1,a3,12eec <__multf3+0xc5c>
   12ecc:	00c6a703          	lw	a4,12(a3)
   12ed0:	0106a603          	lw	a2,16(a3)
   12ed4:	00468693          	addi	a3,a3,4
   12ed8:	01375713          	srli	a4,a4,0x13
   12edc:	00d61613          	slli	a2,a2,0xd
   12ee0:	00c76733          	or	a4,a4,a2
   12ee4:	fee6ae23          	sw	a4,-4(a3)
   12ee8:	fed592e3          	bne	a1,a3,12ecc <__multf3+0xc3c>
   12eec:	06012503          	lw	a0,96(sp)
   12ef0:	06c12683          	lw	a3,108(sp)
   12ef4:	06812603          	lw	a2,104(sp)
   12ef8:	06412583          	lw	a1,100(sp)
   12efc:	01603733          	snez	a4,s6
   12f00:	00a76733          	or	a4,a4,a0
   12f04:	04d12e23          	sw	a3,92(sp)
   12f08:	04c12c23          	sw	a2,88(sp)
   12f0c:	04b12a23          	sw	a1,84(sp)
   12f10:	04e12823          	sw	a4,80(sp)
   12f14:	00b69513          	slli	a0,a3,0xb
   12f18:	04055463          	bgez	a0,12f60 <__multf3+0xcd0>
   12f1c:	01f59513          	slli	a0,a1,0x1f
   12f20:	00175313          	srli	t1,a4,0x1
   12f24:	01f61813          	slli	a6,a2,0x1f
   12f28:	01f69893          	slli	a7,a3,0x1f
   12f2c:	0015d593          	srli	a1,a1,0x1
   12f30:	00165613          	srli	a2,a2,0x1
   12f34:	00656533          	or	a0,a0,t1
   12f38:	00177713          	andi	a4,a4,1
   12f3c:	00412403          	lw	s0,4(sp)
   12f40:	00b865b3          	or	a1,a6,a1
   12f44:	01166633          	or	a2,a2,a7
   12f48:	0016d693          	srli	a3,a3,0x1
   12f4c:	00e56733          	or	a4,a0,a4
   12f50:	04b12a23          	sw	a1,84(sp)
   12f54:	04c12c23          	sw	a2,88(sp)
   12f58:	04d12e23          	sw	a3,92(sp)
   12f5c:	04e12823          	sw	a4,80(sp)
   12f60:	00004737          	lui	a4,0x4
   12f64:	fff70713          	addi	a4,a4,-1 # 3fff <_vfprintf_r+0x2afb>
   12f68:	00e408b3          	add	a7,s0,a4
   12f6c:	1b105663          	blez	a7,13118 <__multf3+0xe88>
   12f70:	05012603          	lw	a2,80(sp)
   12f74:	05412803          	lw	a6,84(sp)
   12f78:	05c12703          	lw	a4,92(sp)
   12f7c:	00767693          	andi	a3,a2,7
   12f80:	00080593          	mv	a1,a6
   12f84:	02068e63          	beqz	a3,12fc0 <__multf3+0xd30>
   12f88:	00f67693          	andi	a3,a2,15
   12f8c:	00400513          	li	a0,4
   12f90:	02a68863          	beq	a3,a0,12fc0 <__multf3+0xd30>
   12f94:	00460613          	addi	a2,a2,4
   12f98:	00463693          	sltiu	a3,a2,4
   12f9c:	05812503          	lw	a0,88(sp)
   12fa0:	00d805b3          	add	a1,a6,a3
   12fa4:	00d5b6b3          	sltu	a3,a1,a3
   12fa8:	00a68533          	add	a0,a3,a0
   12fac:	00d536b3          	sltu	a3,a0,a3
   12fb0:	00d70733          	add	a4,a4,a3
   12fb4:	04e12e23          	sw	a4,92(sp)
   12fb8:	00058813          	mv	a6,a1
   12fbc:	0080006f          	j	12fc4 <__multf3+0xd34>
   12fc0:	05812503          	lw	a0,88(sp)
   12fc4:	00b71693          	slli	a3,a4,0xb
   12fc8:	0006de63          	bgez	a3,12fe4 <__multf3+0xd54>
   12fcc:	fff006b7          	lui	a3,0xfff00
   12fd0:	fff68693          	addi	a3,a3,-1 # ffefffff <__freertos_irq_stack_top+0xffee82df>
   12fd4:	00d77733          	and	a4,a4,a3
   12fd8:	04e12e23          	sw	a4,92(sp)
   12fdc:	00004737          	lui	a4,0x4
   12fe0:	00e408b3          	add	a7,s0,a4
   12fe4:	05c12683          	lw	a3,92(sp)
   12fe8:	00008737          	lui	a4,0x8
   12fec:	01d51e93          	slli	t4,a0,0x1d
   12ff0:	01d69e13          	slli	t3,a3,0x1d
   12ff4:	00365613          	srli	a2,a2,0x3
   12ff8:	01d59593          	slli	a1,a1,0x1d
   12ffc:	00385813          	srli	a6,a6,0x3
   13000:	00355513          	srli	a0,a0,0x3
   13004:	ffe70313          	addi	t1,a4,-2 # 7ffe <localeconv+0x6>
   13008:	00b665b3          	or	a1,a2,a1
   1300c:	01d86833          	or	a6,a6,t4
   13010:	01c56533          	or	a0,a0,t3
   13014:	0036d693          	srli	a3,a3,0x3
   13018:	fff70713          	addi	a4,a4,-1
   1301c:	d3134e63          	blt	t1,a7,12558 <__multf3+0x2c8>
   13020:	00e8f733          	and	a4,a7,a4
   13024:	01069693          	slli	a3,a3,0x10
   13028:	01071713          	slli	a4,a4,0x10
   1302c:	0106d693          	srli	a3,a3,0x10
   13030:	01075713          	srli	a4,a4,0x10
   13034:	c58ff06f          	j	1248c <__multf3+0x1fc>
   13038:	200b9863          	bnez	s7,13248 <__multf3+0xfb8>
   1303c:	280b0663          	beqz	s6,132c8 <__multf3+0x1038>
   13040:	000b0513          	mv	a0,s6
   13044:	170020ef          	jal	ra,151b4 <__clzsi2>
   13048:	04050513          	addi	a0,a0,64
   1304c:	ff450793          	addi	a5,a0,-12
   13050:	01f7f813          	andi	a6,a5,31
   13054:	4057d793          	srai	a5,a5,0x5
   13058:	24081663          	bnez	a6,132a4 <__multf3+0x1014>
   1305c:	40f00733          	neg	a4,a5
   13060:	00271713          	slli	a4,a4,0x2
   13064:	04010593          	addi	a1,sp,64
   13068:	00c70713          	addi	a4,a4,12
   1306c:	00e58733          	add	a4,a1,a4
   13070:	00072603          	lw	a2,0(a4)
   13074:	00279893          	slli	a7,a5,0x2
   13078:	011706b3          	add	a3,a4,a7
   1307c:	00c6a023          	sw	a2,0(a3)
   13080:	ffc70813          	addi	a6,a4,-4
   13084:	00e58e63          	beq	a1,a4,130a0 <__multf3+0xe10>
   13088:	00080713          	mv	a4,a6
   1308c:	00072603          	lw	a2,0(a4)
   13090:	011706b3          	add	a3,a4,a7
   13094:	ffc70813          	addi	a6,a4,-4
   13098:	00c6a023          	sw	a2,0(a3)
   1309c:	fee596e3          	bne	a1,a4,13088 <__multf3+0xdf8>
   130a0:	fff78793          	addi	a5,a5,-1
   130a4:	d90ff06f          	j	12634 <__multf3+0x3a4>
   130a8:	18069863          	bnez	a3,13238 <__multf3+0xfa8>
   130ac:	24078863          	beqz	a5,132fc <__multf3+0x106c>
   130b0:	00078513          	mv	a0,a5
   130b4:	100020ef          	jal	ra,151b4 <__clzsi2>
   130b8:	04050513          	addi	a0,a0,64
   130bc:	ff450713          	addi	a4,a0,-12
   130c0:	01f77813          	andi	a6,a4,31
   130c4:	40575713          	srai	a4,a4,0x5
   130c8:	20081863          	bnez	a6,132d8 <__multf3+0x1048>
   130cc:	40e007b3          	neg	a5,a4
   130d0:	00279793          	slli	a5,a5,0x2
   130d4:	03010593          	addi	a1,sp,48
   130d8:	00c78793          	addi	a5,a5,12
   130dc:	00f587b3          	add	a5,a1,a5
   130e0:	0007a603          	lw	a2,0(a5)
   130e4:	00271893          	slli	a7,a4,0x2
   130e8:	011786b3          	add	a3,a5,a7
   130ec:	00c6a023          	sw	a2,0(a3)
   130f0:	ffc78813          	addi	a6,a5,-4
   130f4:	00f58e63          	beq	a1,a5,13110 <__multf3+0xe80>
   130f8:	00080793          	mv	a5,a6
   130fc:	0007a603          	lw	a2,0(a5)
   13100:	011786b3          	add	a3,a5,a7
   13104:	ffc78813          	addi	a6,a5,-4
   13108:	00c6a023          	sw	a2,0(a3)
   1310c:	fef596e3          	bne	a1,a5,130f8 <__multf3+0xe68>
   13110:	fff70713          	addi	a4,a4,-1
   13114:	de4ff06f          	j	126f8 <__multf3+0x468>
   13118:	00100713          	li	a4,1
   1311c:	41170733          	sub	a4,a4,a7
   13120:	12089c63          	bnez	a7,13258 <__multf3+0xfc8>
   13124:	40575593          	srai	a1,a4,0x5
   13128:	01f77513          	andi	a0,a4,31
   1312c:	00000613          	li	a2,0
   13130:	05010813          	addi	a6,sp,80
   13134:	00300693          	li	a3,3
   13138:	40b686b3          	sub	a3,a3,a1
   1313c:	1e051463          	bnez	a0,13324 <__multf3+0x1094>
   13140:	00080513          	mv	a0,a6
   13144:	00259593          	slli	a1,a1,0x2
   13148:	00000713          	li	a4,0
   1314c:	00b508b3          	add	a7,a0,a1
   13150:	0008a883          	lw	a7,0(a7)
   13154:	00450513          	addi	a0,a0,4
   13158:	00170713          	addi	a4,a4,1
   1315c:	ff152e23          	sw	a7,-4(a0)
   13160:	fee6d6e3          	bge	a3,a4,1314c <__multf3+0xebc>
   13164:	00168693          	addi	a3,a3,1
   13168:	00400713          	li	a4,4
   1316c:	00e68e63          	beq	a3,a4,13188 <__multf3+0xef8>
   13170:	00269693          	slli	a3,a3,0x2
   13174:	00d80733          	add	a4,a6,a3
   13178:	06010693          	addi	a3,sp,96
   1317c:	00072023          	sw	zero,0(a4)
   13180:	00470713          	addi	a4,a4,4
   13184:	fed71ce3          	bne	a4,a3,1317c <__multf3+0xeec>
   13188:	05012683          	lw	a3,80(sp)
   1318c:	00c03633          	snez	a2,a2
   13190:	05c12703          	lw	a4,92(sp)
   13194:	00d66633          	or	a2,a2,a3
   13198:	04c12823          	sw	a2,80(sp)
   1319c:	00767693          	andi	a3,a2,7
   131a0:	04068263          	beqz	a3,131e4 <__multf3+0xf54>
   131a4:	00f67693          	andi	a3,a2,15
   131a8:	00400593          	li	a1,4
   131ac:	02b68c63          	beq	a3,a1,131e4 <__multf3+0xf54>
   131b0:	05412503          	lw	a0,84(sp)
   131b4:	00460613          	addi	a2,a2,4
   131b8:	00463693          	sltiu	a3,a2,4
   131bc:	05812583          	lw	a1,88(sp)
   131c0:	00a68533          	add	a0,a3,a0
   131c4:	00d536b3          	sltu	a3,a0,a3
   131c8:	00b685b3          	add	a1,a3,a1
   131cc:	00d5b6b3          	sltu	a3,a1,a3
   131d0:	00d70733          	add	a4,a4,a3
   131d4:	04c12823          	sw	a2,80(sp)
   131d8:	04a12a23          	sw	a0,84(sp)
   131dc:	04b12c23          	sw	a1,88(sp)
   131e0:	04e12e23          	sw	a4,92(sp)
   131e4:	00c71693          	slli	a3,a4,0xc
   131e8:	1206c263          	bltz	a3,1330c <__multf3+0x107c>
   131ec:	00080713          	mv	a4,a6
   131f0:	05c10593          	addi	a1,sp,92
   131f4:	00072683          	lw	a3,0(a4)
   131f8:	00472603          	lw	a2,4(a4)
   131fc:	00470713          	addi	a4,a4,4
   13200:	0036d693          	srli	a3,a3,0x3
   13204:	01d61613          	slli	a2,a2,0x1d
   13208:	00c6e6b3          	or	a3,a3,a2
   1320c:	fed72e23          	sw	a3,-4(a4)
   13210:	fee592e3          	bne	a1,a4,131f4 <__multf3+0xf64>
   13214:	05c12683          	lw	a3,92(sp)
   13218:	05012583          	lw	a1,80(sp)
   1321c:	05412803          	lw	a6,84(sp)
   13220:	0036d693          	srli	a3,a3,0x3
   13224:	01069693          	slli	a3,a3,0x10
   13228:	05812503          	lw	a0,88(sp)
   1322c:	0106d693          	srli	a3,a3,0x10
   13230:	00000713          	li	a4,0
   13234:	a58ff06f          	j	1248c <__multf3+0x1fc>
   13238:	00068513          	mv	a0,a3
   1323c:	779010ef          	jal	ra,151b4 <__clzsi2>
   13240:	02050513          	addi	a0,a0,32
   13244:	e79ff06f          	j	130bc <__multf3+0xe2c>
   13248:	000b8513          	mv	a0,s7
   1324c:	769010ef          	jal	ra,151b4 <__clzsi2>
   13250:	02050513          	addi	a0,a0,32
   13254:	df9ff06f          	j	1304c <__multf3+0xdbc>
   13258:	07400693          	li	a3,116
   1325c:	aee6cc63          	blt	a3,a4,12554 <__multf3+0x2c4>
   13260:	40575893          	srai	a7,a4,0x5
   13264:	01f77513          	andi	a0,a4,31
   13268:	14088463          	beqz	a7,133b0 <__multf3+0x1120>
   1326c:	05010813          	addi	a6,sp,80
   13270:	00289693          	slli	a3,a7,0x2
   13274:	00080713          	mv	a4,a6
   13278:	010686b3          	add	a3,a3,a6
   1327c:	00000613          	li	a2,0
   13280:	00072583          	lw	a1,0(a4)
   13284:	00470713          	addi	a4,a4,4
   13288:	00b66633          	or	a2,a2,a1
   1328c:	fed71ae3          	bne	a4,a3,13280 <__multf3+0xff0>
   13290:	00088593          	mv	a1,a7
   13294:	ea1ff06f          	j	13134 <__multf3+0xea4>
   13298:	00058793          	mv	a5,a1
   1329c:	00412403          	lw	s0,4(sp)
   132a0:	cc1ff06f          	j	12f60 <__multf3+0xcd0>
   132a4:	02000893          	li	a7,32
   132a8:	00300713          	li	a4,3
   132ac:	410888b3          	sub	a7,a7,a6
   132b0:	b2e79863          	bne	a5,a4,125e0 <__multf3+0x350>
   132b4:	010a9833          	sll	a6,s5,a6
   132b8:	05012623          	sw	a6,76(sp)
   132bc:	00200793          	li	a5,2
   132c0:	04010593          	addi	a1,sp,64
   132c4:	b78ff06f          	j	1263c <__multf3+0x3ac>
   132c8:	000a8513          	mv	a0,s5
   132cc:	6e9010ef          	jal	ra,151b4 <__clzsi2>
   132d0:	06050513          	addi	a0,a0,96
   132d4:	d79ff06f          	j	1304c <__multf3+0xdbc>
   132d8:	02000893          	li	a7,32
   132dc:	00300793          	li	a5,3
   132e0:	410888b3          	sub	a7,a7,a6
   132e4:	bcf71063          	bne	a4,a5,126a4 <__multf3+0x414>
   132e8:	010917b3          	sll	a5,s2,a6
   132ec:	02f12e23          	sw	a5,60(sp)
   132f0:	00200713          	li	a4,2
   132f4:	03010593          	addi	a1,sp,48
   132f8:	c08ff06f          	j	12700 <__multf3+0x470>
   132fc:	00090513          	mv	a0,s2
   13300:	6b5010ef          	jal	ra,151b4 <__clzsi2>
   13304:	06050513          	addi	a0,a0,96
   13308:	db5ff06f          	j	130bc <__multf3+0xe2c>
   1330c:	00100713          	li	a4,1
   13310:	00000693          	li	a3,0
   13314:	00000513          	li	a0,0
   13318:	00000813          	li	a6,0
   1331c:	00000593          	li	a1,0
   13320:	96cff06f          	j	1248c <__multf3+0x1fc>
   13324:	00289713          	slli	a4,a7,0x2
   13328:	08010893          	addi	a7,sp,128
   1332c:	00e88733          	add	a4,a7,a4
   13330:	fd072703          	lw	a4,-48(a4)
   13334:	02000e13          	li	t3,32
   13338:	40ae0e33          	sub	t3,t3,a0
   1333c:	01c71733          	sll	a4,a4,t3
   13340:	00e66633          	or	a2,a2,a4
   13344:	04068c63          	beqz	a3,1339c <__multf3+0x110c>
   13348:	00259713          	slli	a4,a1,0x2
   1334c:	00269f13          	slli	t5,a3,0x2
   13350:	00e80733          	add	a4,a6,a4
   13354:	00080893          	mv	a7,a6
   13358:	01e80eb3          	add	t4,a6,t5
   1335c:	00072583          	lw	a1,0(a4)
   13360:	00472303          	lw	t1,4(a4)
   13364:	00488893          	addi	a7,a7,4
   13368:	00a5d5b3          	srl	a1,a1,a0
   1336c:	01c31333          	sll	t1,t1,t3
   13370:	0065e5b3          	or	a1,a1,t1
   13374:	feb8ae23          	sw	a1,-4(a7)
   13378:	00470713          	addi	a4,a4,4
   1337c:	ff1e90e3          	bne	t4,a7,1335c <__multf3+0x10cc>
   13380:	08010713          	addi	a4,sp,128
   13384:	01e70f33          	add	t5,a4,t5
   13388:	05c12703          	lw	a4,92(sp)
   1338c:	00168693          	addi	a3,a3,1
   13390:	00a75733          	srl	a4,a4,a0
   13394:	fcef2823          	sw	a4,-48(t5)
   13398:	dd1ff06f          	j	13168 <__multf3+0xed8>
   1339c:	05c12703          	lw	a4,92(sp)
   133a0:	00100693          	li	a3,1
   133a4:	00a75733          	srl	a4,a4,a0
   133a8:	04e12823          	sw	a4,80(sp)
   133ac:	dc5ff06f          	j	13170 <__multf3+0xee0>
   133b0:	00051c63          	bnez	a0,133c8 <__multf3+0x1138>
   133b4:	00000593          	li	a1,0
   133b8:	00300693          	li	a3,3
   133bc:	00000613          	li	a2,0
   133c0:	05010813          	addi	a6,sp,80
   133c4:	d7dff06f          	j	13140 <__multf3+0xeb0>
   133c8:	05012603          	lw	a2,80(sp)
   133cc:	02000e13          	li	t3,32
   133d0:	40ae0e33          	sub	t3,t3,a0
   133d4:	01c61633          	sll	a2,a2,t3
   133d8:	00000593          	li	a1,0
   133dc:	00300693          	li	a3,3
   133e0:	05010813          	addi	a6,sp,80
   133e4:	f65ff06f          	j	13348 <__multf3+0x10b8>

000133e8 <__subtf3>:
   133e8:	fa010113          	addi	sp,sp,-96
   133ec:	00c62703          	lw	a4,12(a2)
   133f0:	04912a23          	sw	s1,84(sp)
   133f4:	00c5a483          	lw	s1,12(a1)
   133f8:	00862883          	lw	a7,8(a2)
   133fc:	00462383          	lw	t2,4(a2)
   13400:	0085a683          	lw	a3,8(a1)
   13404:	0005a303          	lw	t1,0(a1)
   13408:	0045a783          	lw	a5,4(a1)
   1340c:	04812c23          	sw	s0,88(sp)
   13410:	00062403          	lw	s0,0(a2)
   13414:	01049813          	slli	a6,s1,0x10
   13418:	01071593          	slli	a1,a4,0x10
   1341c:	01085813          	srli	a6,a6,0x10
   13420:	0105d593          	srli	a1,a1,0x10
   13424:	01d35f93          	srli	t6,t1,0x1d
   13428:	01d6df13          	srli	t5,a3,0x1d
   1342c:	00369613          	slli	a2,a3,0x3
   13430:	00339293          	slli	t0,t2,0x3
   13434:	01d45e13          	srli	t3,s0,0x1d
   13438:	05312623          	sw	s3,76(sp)
   1343c:	05412423          	sw	s4,72(sp)
   13440:	00389993          	slli	s3,a7,0x3
   13444:	01d8da13          	srli	s4,a7,0x1d
   13448:	05512223          	sw	s5,68(sp)
   1344c:	00381813          	slli	a6,a6,0x3
   13450:	01d7da93          	srli	s5,a5,0x1d
   13454:	00359593          	slli	a1,a1,0x3
   13458:	00379793          	slli	a5,a5,0x3
   1345c:	01d3d693          	srli	a3,t2,0x1d
   13460:	00008eb7          	lui	t4,0x8
   13464:	fffe8e93          	addi	t4,t4,-1 # 7fff <localeconv+0x7>
   13468:	01f7e7b3          	or	a5,a5,t6
   1346c:	01c2ee33          	or	t3,t0,t3
   13470:	01075f93          	srli	t6,a4,0x10
   13474:	00341293          	slli	t0,s0,0x3
   13478:	05212823          	sw	s2,80(sp)
   1347c:	010f6f33          	or	t5,t5,a6
   13480:	0104d913          	srli	s2,s1,0x10
   13484:	00cae633          	or	a2,s5,a2
   13488:	00331313          	slli	t1,t1,0x3
   1348c:	00ba65b3          	or	a1,s4,a1
   13490:	0136e6b3          	or	a3,a3,s3
   13494:	01d97933          	and	s2,s2,t4
   13498:	01dfffb3          	and	t6,t6,t4
   1349c:	02812823          	sw	s0,48(sp)
   134a0:	03112c23          	sw	a7,56(sp)
   134a4:	02e12e23          	sw	a4,60(sp)
   134a8:	04112e23          	sw	ra,92(sp)
   134ac:	01e12e23          	sw	t5,28(sp)
   134b0:	00c12c23          	sw	a2,24(sp)
   134b4:	00f12a23          	sw	a5,20(sp)
   134b8:	00612823          	sw	t1,16(sp)
   134bc:	02712a23          	sw	t2,52(sp)
   134c0:	02b12623          	sw	a1,44(sp)
   134c4:	02d12423          	sw	a3,40(sp)
   134c8:	03c12223          	sw	t3,36(sp)
   134cc:	02512023          	sw	t0,32(sp)
   134d0:	00050413          	mv	s0,a0
   134d4:	01f4d493          	srli	s1,s1,0x1f
   134d8:	01f75713          	srli	a4,a4,0x1f
   134dc:	41f908b3          	sub	a7,s2,t6
   134e0:	1fdf8e63          	beq	t6,t4,136dc <__subtf3+0x2f4>
   134e4:	00174713          	xori	a4,a4,1
   134e8:	3ae48c63          	beq	s1,a4,138a0 <__subtf3+0x4b8>
   134ec:	11105063          	blez	a7,135ec <__subtf3+0x204>
   134f0:	200f9263          	bnez	t6,136f4 <__subtf3+0x30c>
   134f4:	00de6733          	or	a4,t3,a3
   134f8:	00b76733          	or	a4,a4,a1
   134fc:	00576733          	or	a4,a4,t0
   13500:	060704e3          	beqz	a4,13d68 <__subtf3+0x980>
   13504:	fff88713          	addi	a4,a7,-1
   13508:	6c0704e3          	beqz	a4,143d0 <__subtf3+0xfe8>
   1350c:	000086b7          	lui	a3,0x8
   13510:	fff68693          	addi	a3,a3,-1 # 7fff <localeconv+0x7>
   13514:	04d88ae3          	beq	a7,a3,13d68 <__subtf3+0x980>
   13518:	07400693          	li	a3,116
   1351c:	1ee6cc63          	blt	a3,a4,13714 <__subtf3+0x32c>
   13520:	00070893          	mv	a7,a4
   13524:	4058d813          	srai	a6,a7,0x5
   13528:	01f8f893          	andi	a7,a7,31
   1352c:	00081463          	bnez	a6,13534 <__subtf3+0x14c>
   13530:	0a40106f          	j	145d4 <__subtf3+0x11ec>
   13534:	02010e93          	addi	t4,sp,32
   13538:	00281713          	slli	a4,a6,0x2
   1353c:	000e8693          	mv	a3,t4
   13540:	00000e13          	li	t3,0
   13544:	00ee8733          	add	a4,t4,a4
   13548:	00468693          	addi	a3,a3,4
   1354c:	005e6e33          	or	t3,t3,t0
   13550:	00d70a63          	beq	a4,a3,13564 <__subtf3+0x17c>
   13554:	0006a283          	lw	t0,0(a3)
   13558:	00468693          	addi	a3,a3,4
   1355c:	005e6e33          	or	t3,t3,t0
   13560:	fed71ae3          	bne	a4,a3,13554 <__subtf3+0x16c>
   13564:	00080713          	mv	a4,a6
   13568:	00300513          	li	a0,3
   1356c:	41050533          	sub	a0,a0,a6
   13570:	460890e3          	bnez	a7,141d0 <__subtf3+0xde8>
   13574:	000e8693          	mv	a3,t4
   13578:	00281593          	slli	a1,a6,0x2
   1357c:	00b68733          	add	a4,a3,a1
   13580:	00072703          	lw	a4,0(a4)
   13584:	00468693          	addi	a3,a3,4
   13588:	00188893          	addi	a7,a7,1
   1358c:	fee6ae23          	sw	a4,-4(a3)
   13590:	ff1556e3          	bge	a0,a7,1357c <__subtf3+0x194>
   13594:	00400713          	li	a4,4
   13598:	41070733          	sub	a4,a4,a6
   1359c:	00400693          	li	a3,4
   135a0:	00d70e63          	beq	a4,a3,135bc <__subtf3+0x1d4>
   135a4:	00271713          	slli	a4,a4,0x2
   135a8:	00ee8733          	add	a4,t4,a4
   135ac:	03010593          	addi	a1,sp,48
   135b0:	00072023          	sw	zero,0(a4)
   135b4:	00470713          	addi	a4,a4,4
   135b8:	fee59ce3          	bne	a1,a4,135b0 <__subtf3+0x1c8>
   135bc:	02412e83          	lw	t4,36(sp)
   135c0:	02812583          	lw	a1,40(sp)
   135c4:	01c03733          	snez	a4,t3
   135c8:	02012503          	lw	a0,32(sp)
   135cc:	02c12e03          	lw	t3,44(sp)
   135d0:	41d78833          	sub	a6,a5,t4
   135d4:	40b606b3          	sub	a3,a2,a1
   135d8:	00a76733          	or	a4,a4,a0
   135dc:	0107b8b3          	sltu	a7,a5,a6
   135e0:	00d63533          	sltu	a0,a2,a3
   135e4:	41cf0f33          	sub	t5,t5,t3
   135e8:	1480006f          	j	13730 <__subtf3+0x348>
   135ec:	3a089863          	bnez	a7,1399c <__subtf3+0x5b4>
   135f0:	00008eb7          	lui	t4,0x8
   135f4:	00190513          	addi	a0,s2,1
   135f8:	ffee8813          	addi	a6,t4,-2 # 7ffe <localeconv+0x6>
   135fc:	01057533          	and	a0,a0,a6
   13600:	08051ce3          	bnez	a0,13e98 <__subtf3+0xab0>
   13604:	00c7e533          	or	a0,a5,a2
   13608:	00de6833          	or	a6,t3,a3
   1360c:	01e56533          	or	a0,a0,t5
   13610:	00b86833          	or	a6,a6,a1
   13614:	00656533          	or	a0,a0,t1
   13618:	00586833          	or	a6,a6,t0
   1361c:	78091ae3          	bnez	s2,145b0 <__subtf3+0x11c8>
   13620:	52050ee3          	beqz	a0,1435c <__subtf3+0xf74>
   13624:	74080263          	beqz	a6,13d68 <__subtf3+0x980>
   13628:	40530533          	sub	a0,t1,t0
   1362c:	41c78833          	sub	a6,a5,t3
   13630:	00a338b3          	sltu	a7,t1,a0
   13634:	411808b3          	sub	a7,a6,a7
   13638:	40d60ab3          	sub	s5,a2,a3
   1363c:	015633b3          	sltu	t2,a2,s5
   13640:	02a12823          	sw	a0,48(sp)
   13644:	03112a23          	sw	a7,52(sp)
   13648:	0107beb3          	sltu	t4,a5,a6
   1364c:	00038f93          	mv	t6,t2
   13650:	00a37663          	bgeu	t1,a0,1365c <__subtf3+0x274>
   13654:	01c79463          	bne	a5,t3,1365c <__subtf3+0x274>
   13658:	1900106f          	j	147e8 <__subtf3+0x1400>
   1365c:	41da8eb3          	sub	t4,s5,t4
   13660:	03d12c23          	sw	t4,56(sp)
   13664:	0107f463          	bgeu	a5,a6,1366c <__subtf3+0x284>
   13668:	1880106f          	j	147f0 <__subtf3+0x1408>
   1366c:	40bf0833          	sub	a6,t5,a1
   13670:	41f80833          	sub	a6,a6,t6
   13674:	03012e23          	sw	a6,60(sp)
   13678:	00c81f93          	slli	t6,a6,0xc
   1367c:	000fc463          	bltz	t6,13684 <__subtf3+0x29c>
   13680:	14c0106f          	j	147cc <__subtf3+0x13e4>
   13684:	40628533          	sub	a0,t0,t1
   13688:	40fe08b3          	sub	a7,t3,a5
   1368c:	00a2b833          	sltu	a6,t0,a0
   13690:	41088833          	sub	a6,a7,a6
   13694:	40c68633          	sub	a2,a3,a2
   13698:	00c6b6b3          	sltu	a3,a3,a2
   1369c:	03012a23          	sw	a6,52(sp)
   136a0:	02a12823          	sw	a0,48(sp)
   136a4:	011e3333          	sltu	t1,t3,a7
   136a8:	00068813          	mv	a6,a3
   136ac:	00a2f663          	bgeu	t0,a0,136b8 <__subtf3+0x2d0>
   136b0:	01c79463          	bne	a5,t3,136b8 <__subtf3+0x2d0>
   136b4:	2600106f          	j	14914 <__subtf3+0x152c>
   136b8:	40660633          	sub	a2,a2,t1
   136bc:	02c12c23          	sw	a2,56(sp)
   136c0:	011e7463          	bgeu	t3,a7,136c8 <__subtf3+0x2e0>
   136c4:	2580106f          	j	1491c <__subtf3+0x1534>
   136c8:	41e585b3          	sub	a1,a1,t5
   136cc:	41058833          	sub	a6,a1,a6
   136d0:	03012e23          	sw	a6,60(sp)
   136d4:	00070493          	mv	s1,a4
   136d8:	2ed0006f          	j	141c4 <__subtf3+0xddc>
   136dc:	00de6533          	or	a0,t3,a3
   136e0:	00b56533          	or	a0,a0,a1
   136e4:	00556533          	or	a0,a0,t0
   136e8:	de050ee3          	beqz	a0,134e4 <__subtf3+0xfc>
   136ec:	6ae48063          	beq	s1,a4,13d8c <__subtf3+0x9a4>
   136f0:	ef105ee3          	blez	a7,135ec <__subtf3+0x204>
   136f4:	00008737          	lui	a4,0x8
   136f8:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
   136fc:	00e90ce3          	beq	s2,a4,13f14 <__subtf3+0xb2c>
   13700:	00080837          	lui	a6,0x80
   13704:	0105e833          	or	a6,a1,a6
   13708:	03012623          	sw	a6,44(sp)
   1370c:	07400713          	li	a4,116
   13710:	e1175ae3          	bge	a4,a7,13524 <__subtf3+0x13c>
   13714:	00060693          	mv	a3,a2
   13718:	00078813          	mv	a6,a5
   1371c:	00000513          	li	a0,0
   13720:	00000893          	li	a7,0
   13724:	00000593          	li	a1,0
   13728:	00000e93          	li	t4,0
   1372c:	00100713          	li	a4,1
   13730:	40e30733          	sub	a4,t1,a4
   13734:	00e33e33          	sltu	t3,t1,a4
   13738:	41c80833          	sub	a6,a6,t3
   1373c:	02e12823          	sw	a4,48(sp)
   13740:	03012a23          	sw	a6,52(sp)
   13744:	00e37463          	bgeu	t1,a4,1374c <__subtf3+0x364>
   13748:	6dd78663          	beq	a5,t4,13e14 <__subtf3+0xa2c>
   1374c:	411686b3          	sub	a3,a3,a7
   13750:	02d12c23          	sw	a3,56(sp)
   13754:	6c089463          	bnez	a7,13e1c <__subtf3+0xa34>
   13758:	40af0833          	sub	a6,t5,a0
   1375c:	03012e23          	sw	a6,60(sp)
   13760:	00c81793          	slli	a5,a6,0xc
   13764:	4a07ce63          	bltz	a5,13c20 <__subtf3+0x838>
   13768:	03012503          	lw	a0,48(sp)
   1376c:	03c12703          	lw	a4,60(sp)
   13770:	00757793          	andi	a5,a0,7
   13774:	00070813          	mv	a6,a4
   13778:	4a0784e3          	beqz	a5,14420 <__subtf3+0x1038>
   1377c:	00f57793          	andi	a5,a0,15
   13780:	00400713          	li	a4,4
   13784:	02e78c63          	beq	a5,a4,137bc <__subtf3+0x3d4>
   13788:	03412603          	lw	a2,52(sp)
   1378c:	00450513          	addi	a0,a0,4
   13790:	00453793          	sltiu	a5,a0,4
   13794:	03812703          	lw	a4,56(sp)
   13798:	00c78633          	add	a2,a5,a2
   1379c:	00f637b3          	sltu	a5,a2,a5
   137a0:	00e78733          	add	a4,a5,a4
   137a4:	00f737b3          	sltu	a5,a4,a5
   137a8:	00f80833          	add	a6,a6,a5
   137ac:	02a12823          	sw	a0,48(sp)
   137b0:	02c12a23          	sw	a2,52(sp)
   137b4:	02e12c23          	sw	a4,56(sp)
   137b8:	03012e23          	sw	a6,60(sp)
   137bc:	000807b7          	lui	a5,0x80
   137c0:	00f877b3          	and	a5,a6,a5
   137c4:	62078ae3          	beqz	a5,145f8 <__subtf3+0x1210>
   137c8:	000087b7          	lui	a5,0x8
   137cc:	fff80737          	lui	a4,0xfff80
   137d0:	fff70713          	addi	a4,a4,-1 # fff7ffff <__freertos_irq_stack_top+0xfff682df>
   137d4:	00190893          	addi	a7,s2,1
   137d8:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   137dc:	00e87733          	and	a4,a6,a4
   137e0:	40f88863          	beq	a7,a5,13bf0 <__subtf3+0x808>
   137e4:	03412583          	lw	a1,52(sp)
   137e8:	03012503          	lw	a0,48(sp)
   137ec:	00058693          	mv	a3,a1
   137f0:	03812603          	lw	a2,56(sp)
   137f4:	00355313          	srli	t1,a0,0x3
   137f8:	00008537          	lui	a0,0x8
   137fc:	01d61813          	slli	a6,a2,0x1d
   13800:	01d71793          	slli	a5,a4,0x1d
   13804:	01d69693          	slli	a3,a3,0x1d
   13808:	0035d593          	srli	a1,a1,0x3
   1380c:	00365613          	srli	a2,a2,0x3
   13810:	fff50513          	addi	a0,a0,-1 # 7fff <localeconv+0x7>
   13814:	0066e6b3          	or	a3,a3,t1
   13818:	0105e5b3          	or	a1,a1,a6
   1381c:	00f66633          	or	a2,a2,a5
   13820:	00375713          	srli	a4,a4,0x3
   13824:	3aa88463          	beq	a7,a0,13bcc <__subtf3+0x7e4>
   13828:	01071713          	slli	a4,a4,0x10
   1382c:	01075713          	srli	a4,a4,0x10
   13830:	0014f813          	andi	a6,s1,1
   13834:	01189793          	slli	a5,a7,0x11
   13838:	00e11623          	sh	a4,12(sp)
   1383c:	0117d793          	srli	a5,a5,0x11
   13840:	01079713          	slli	a4,a5,0x10
   13844:	00c12783          	lw	a5,12(sp)
   13848:	80010537          	lui	a0,0x80010
   1384c:	fff50513          	addi	a0,a0,-1 # 8000ffff <__freertos_irq_stack_top+0x7fff82df>
   13850:	00a7f7b3          	and	a5,a5,a0
   13854:	00e7e7b3          	or	a5,a5,a4
   13858:	00179793          	slli	a5,a5,0x1
   1385c:	01f81713          	slli	a4,a6,0x1f
   13860:	0017d793          	srli	a5,a5,0x1
   13864:	00e7e7b3          	or	a5,a5,a4
   13868:	00d42023          	sw	a3,0(s0)
   1386c:	00b42223          	sw	a1,4(s0)
   13870:	00c42423          	sw	a2,8(s0)
   13874:	00f42623          	sw	a5,12(s0)
   13878:	00040513          	mv	a0,s0
   1387c:	05c12083          	lw	ra,92(sp)
   13880:	05812403          	lw	s0,88(sp)
   13884:	05412483          	lw	s1,84(sp)
   13888:	05012903          	lw	s2,80(sp)
   1388c:	04c12983          	lw	s3,76(sp)
   13890:	04812a03          	lw	s4,72(sp)
   13894:	04412a83          	lw	s5,68(sp)
   13898:	06010113          	addi	sp,sp,96
   1389c:	00008067          	ret
   138a0:	4f105663          	blez	a7,13d8c <__subtf3+0x9a4>
   138a4:	200f9e63          	bnez	t6,13ac0 <__subtf3+0x6d8>
   138a8:	00de6733          	or	a4,t3,a3
   138ac:	00b76733          	or	a4,a4,a1
   138b0:	00576733          	or	a4,a4,t0
   138b4:	4a070a63          	beqz	a4,13d68 <__subtf3+0x980>
   138b8:	fff88713          	addi	a4,a7,-1
   138bc:	20070ee3          	beqz	a4,142d8 <__subtf3+0xef0>
   138c0:	000086b7          	lui	a3,0x8
   138c4:	fff68693          	addi	a3,a3,-1 # 7fff <localeconv+0x7>
   138c8:	4ad88063          	beq	a7,a3,13d68 <__subtf3+0x980>
   138cc:	07400693          	li	a3,116
   138d0:	20e6c863          	blt	a3,a4,13ae0 <__subtf3+0x6f8>
   138d4:	00070893          	mv	a7,a4
   138d8:	4058d693          	srai	a3,a7,0x5
   138dc:	01f8f893          	andi	a7,a7,31
   138e0:	28068ee3          	beqz	a3,1437c <__subtf3+0xf94>
   138e4:	02010e93          	addi	t4,sp,32
   138e8:	00269513          	slli	a0,a3,0x2
   138ec:	000e8713          	mv	a4,t4
   138f0:	00000593          	li	a1,0
   138f4:	00ae8533          	add	a0,t4,a0
   138f8:	00470713          	addi	a4,a4,4
   138fc:	0055e5b3          	or	a1,a1,t0
   13900:	00e50a63          	beq	a0,a4,13914 <__subtf3+0x52c>
   13904:	00072283          	lw	t0,0(a4)
   13908:	00470713          	addi	a4,a4,4
   1390c:	0055e5b3          	or	a1,a1,t0
   13910:	fee51ae3          	bne	a0,a4,13904 <__subtf3+0x51c>
   13914:	00068713          	mv	a4,a3
   13918:	00300813          	li	a6,3
   1391c:	40d80833          	sub	a6,a6,a3
   13920:	400894e3          	bnez	a7,14528 <__subtf3+0x1140>
   13924:	000e8713          	mv	a4,t4
   13928:	00269e13          	slli	t3,a3,0x2
   1392c:	01c70533          	add	a0,a4,t3
   13930:	00052503          	lw	a0,0(a0)
   13934:	00470713          	addi	a4,a4,4
   13938:	00188893          	addi	a7,a7,1
   1393c:	fea72e23          	sw	a0,-4(a4)
   13940:	ff1856e3          	bge	a6,a7,1392c <__subtf3+0x544>
   13944:	00400713          	li	a4,4
   13948:	40d706b3          	sub	a3,a4,a3
   1394c:	00400713          	li	a4,4
   13950:	00e68e63          	beq	a3,a4,1396c <__subtf3+0x584>
   13954:	00269693          	slli	a3,a3,0x2
   13958:	00de8733          	add	a4,t4,a3
   1395c:	03010693          	addi	a3,sp,48
   13960:	00072023          	sw	zero,0(a4)
   13964:	00470713          	addi	a4,a4,4
   13968:	fee69ce3          	bne	a3,a4,13960 <__subtf3+0x578>
   1396c:	02812703          	lw	a4,40(sp)
   13970:	02412683          	lw	a3,36(sp)
   13974:	00b03533          	snez	a0,a1
   13978:	00e60733          	add	a4,a2,a4
   1397c:	02012583          	lw	a1,32(sp)
   13980:	00c73833          	sltu	a6,a4,a2
   13984:	02c12603          	lw	a2,44(sp)
   13988:	00d786b3          	add	a3,a5,a3
   1398c:	00b56533          	or	a0,a0,a1
   13990:	00f6b7b3          	sltu	a5,a3,a5
   13994:	00cf0f33          	add	t5,t5,a2
   13998:	15c0006f          	j	13af4 <__subtf3+0x70c>
   1399c:	412f88b3          	sub	a7,t6,s2
   139a0:	6a091863          	bnez	s2,14050 <__subtf3+0xc68>
   139a4:	00c7e533          	or	a0,a5,a2
   139a8:	01e56533          	or	a0,a0,t5
   139ac:	00656533          	or	a0,a0,t1
   139b0:	16050ce3          	beqz	a0,14328 <__subtf3+0xf40>
   139b4:	fff88513          	addi	a0,a7,-1
   139b8:	540502e3          	beqz	a0,146fc <__subtf3+0x1314>
   139bc:	000087b7          	lui	a5,0x8
   139c0:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   139c4:	16f882e3          	beq	a7,a5,14328 <__subtf3+0xf40>
   139c8:	07400793          	li	a5,116
   139cc:	6aa7c263          	blt	a5,a0,14070 <__subtf3+0xc88>
   139d0:	00050893          	mv	a7,a0
   139d4:	41f8d793          	srai	a5,a7,0x1f
   139d8:	01b7d613          	srli	a2,a5,0x1b
   139dc:	00c883b3          	add	t2,a7,a2
   139e0:	01f7f793          	andi	a5,a5,31
   139e4:	011787b3          	add	a5,a5,a7
   139e8:	01f3f393          	andi	t2,t2,31
   139ec:	01f00513          	li	a0,31
   139f0:	4057d793          	srai	a5,a5,0x5
   139f4:	40c383b3          	sub	t2,t2,a2
   139f8:	611552e3          	bge	a0,a7,147fc <__subtf3+0x1414>
   139fc:	01010e93          	addi	t4,sp,16
   13a00:	00000613          	li	a2,0
   13a04:	000e8513          	mv	a0,t4
   13a08:	00000f13          	li	t5,0
   13a0c:	00160613          	addi	a2,a2,1
   13a10:	006f6f33          	or	t5,t5,t1
   13a14:	00450513          	addi	a0,a0,4
   13a18:	00f65c63          	bge	a2,a5,13a30 <__subtf3+0x648>
   13a1c:	00052303          	lw	t1,0(a0)
   13a20:	00160613          	addi	a2,a2,1
   13a24:	00450513          	addi	a0,a0,4
   13a28:	006f6f33          	or	t5,t5,t1
   13a2c:	fef648e3          	blt	a2,a5,13a1c <__subtf3+0x634>
   13a30:	00078613          	mv	a2,a5
   13a34:	00f04463          	bgtz	a5,13a3c <__subtf3+0x654>
   13a38:	00100613          	li	a2,1
   13a3c:	00300813          	li	a6,3
   13a40:	40f80833          	sub	a6,a6,a5
   13a44:	3e0396e3          	bnez	t2,14630 <__subtf3+0x1248>
   13a48:	000e8613          	mv	a2,t4
   13a4c:	00279893          	slli	a7,a5,0x2
   13a50:	01160533          	add	a0,a2,a7
   13a54:	00052503          	lw	a0,0(a0)
   13a58:	00460613          	addi	a2,a2,4
   13a5c:	00138393          	addi	t2,t2,1
   13a60:	fea62e23          	sw	a0,-4(a2)
   13a64:	fe7856e3          	bge	a6,t2,13a50 <__subtf3+0x668>
   13a68:	00400613          	li	a2,4
   13a6c:	40f607b3          	sub	a5,a2,a5
   13a70:	00300613          	li	a2,3
   13a74:	00f64e63          	blt	a2,a5,13a90 <__subtf3+0x6a8>
   13a78:	00279793          	slli	a5,a5,0x2
   13a7c:	00fe87b3          	add	a5,t4,a5
   13a80:	02010613          	addi	a2,sp,32
   13a84:	0007a023          	sw	zero,0(a5)
   13a88:	00478793          	addi	a5,a5,4
   13a8c:	fef61ce3          	bne	a2,a5,13a84 <__subtf3+0x69c>
   13a90:	01412e83          	lw	t4,20(sp)
   13a94:	01812503          	lw	a0,24(sp)
   13a98:	01e037b3          	snez	a5,t5
   13a9c:	01012803          	lw	a6,16(sp)
   13aa0:	01c12f03          	lw	t5,28(sp)
   13aa4:	41de08b3          	sub	a7,t3,t4
   13aa8:	40a68633          	sub	a2,a3,a0
   13aac:	0107e7b3          	or	a5,a5,a6
   13ab0:	011e3333          	sltu	t1,t3,a7
   13ab4:	00c6b833          	sltu	a6,a3,a2
   13ab8:	41e585b3          	sub	a1,a1,t5
   13abc:	5d00006f          	j	1408c <__subtf3+0xca4>
   13ac0:	00008737          	lui	a4,0x8
   13ac4:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
   13ac8:	44e90663          	beq	s2,a4,13f14 <__subtf3+0xb2c>
   13acc:	00080837          	lui	a6,0x80
   13ad0:	0105e833          	or	a6,a1,a6
   13ad4:	03012623          	sw	a6,44(sp)
   13ad8:	07400713          	li	a4,116
   13adc:	df175ee3          	bge	a4,a7,138d8 <__subtf3+0x4f0>
   13ae0:	00078693          	mv	a3,a5
   13ae4:	00060713          	mv	a4,a2
   13ae8:	00000813          	li	a6,0
   13aec:	00000793          	li	a5,0
   13af0:	00100513          	li	a0,1
   13af4:	00a30533          	add	a0,t1,a0
   13af8:	00653333          	sltu	t1,a0,t1
   13afc:	00d306b3          	add	a3,t1,a3
   13b00:	0066b333          	sltu	t1,a3,t1
   13b04:	0067e7b3          	or	a5,a5,t1
   13b08:	00e78733          	add	a4,a5,a4
   13b0c:	00f737b3          	sltu	a5,a4,a5
   13b10:	00f86833          	or	a6,a6,a5
   13b14:	01e80833          	add	a6,a6,t5
   13b18:	02a12823          	sw	a0,48(sp)
   13b1c:	02d12a23          	sw	a3,52(sp)
   13b20:	02e12c23          	sw	a4,56(sp)
   13b24:	03012e23          	sw	a6,60(sp)
   13b28:	00c81793          	slli	a5,a6,0xc
   13b2c:	c407d0e3          	bgez	a5,1376c <__subtf3+0x384>
   13b30:	fff805b7          	lui	a1,0xfff80
   13b34:	fff58593          	addi	a1,a1,-1 # fff7ffff <__freertos_irq_stack_top+0xfff682df>
   13b38:	00b87833          	and	a6,a6,a1
   13b3c:	03010793          	addi	a5,sp,48
   13b40:	03012e23          	sw	a6,60(sp)
   13b44:	0047a703          	lw	a4,4(a5)
   13b48:	01f51693          	slli	a3,a0,0x1f
   13b4c:	00155513          	srli	a0,a0,0x1
   13b50:	01f71713          	slli	a4,a4,0x1f
   13b54:	00478793          	addi	a5,a5,4
   13b58:	00a76533          	or	a0,a4,a0
   13b5c:	03c10613          	addi	a2,sp,60
   13b60:	fea7ae23          	sw	a0,-4(a5)
   13b64:	00190913          	addi	s2,s2,1
   13b68:	02f60263          	beq	a2,a5,13b8c <__subtf3+0x7a4>
   13b6c:	0007a503          	lw	a0,0(a5)
   13b70:	0047a703          	lw	a4,4(a5)
   13b74:	00478793          	addi	a5,a5,4
   13b78:	00155513          	srli	a0,a0,0x1
   13b7c:	01f71713          	slli	a4,a4,0x1f
   13b80:	00a76533          	or	a0,a4,a0
   13b84:	fea7ae23          	sw	a0,-4(a5)
   13b88:	fef612e3          	bne	a2,a5,13b6c <__subtf3+0x784>
   13b8c:	03c12703          	lw	a4,60(sp)
   13b90:	03012503          	lw	a0,48(sp)
   13b94:	00d037b3          	snez	a5,a3
   13b98:	00175813          	srli	a6,a4,0x1
   13b9c:	00a7e533          	or	a0,a5,a0
   13ba0:	000087b7          	lui	a5,0x8
   13ba4:	03012e23          	sw	a6,60(sp)
   13ba8:	02a12823          	sw	a0,48(sp)
   13bac:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   13bb0:	60f91a63          	bne	s2,a5,141c4 <__subtf3+0xddc>
   13bb4:	02012e23          	sw	zero,60(sp)
   13bb8:	02012c23          	sw	zero,56(sp)
   13bbc:	02012a23          	sw	zero,52(sp)
   13bc0:	02012823          	sw	zero,48(sp)
   13bc4:	00090893          	mv	a7,s2
   13bc8:	1b00006f          	j	13d78 <__subtf3+0x990>
   13bcc:	00b6e6b3          	or	a3,a3,a1
   13bd0:	00c6e6b3          	or	a3,a3,a2
   13bd4:	00e6e6b3          	or	a3,a3,a4
   13bd8:	02069863          	bnez	a3,13c08 <__subtf3+0x820>
   13bdc:	0014f813          	andi	a6,s1,1
   13be0:	00000613          	li	a2,0
   13be4:	00000593          	li	a1,0
   13be8:	00000713          	li	a4,0
   13bec:	c49ff06f          	j	13834 <__subtf3+0x44c>
   13bf0:	02012c23          	sw	zero,56(sp)
   13bf4:	00000693          	li	a3,0
   13bf8:	00000513          	li	a0,0
   13bfc:	00000713          	li	a4,0
   13c00:	00000593          	li	a1,0
   13c04:	bedff06f          	j	137f0 <__subtf3+0x408>
   13c08:	00000813          	li	a6,0
   13c0c:	00008737          	lui	a4,0x8
   13c10:	00000613          	li	a2,0
   13c14:	00000593          	li	a1,0
   13c18:	00000693          	li	a3,0
   13c1c:	c19ff06f          	j	13834 <__subtf3+0x44c>
   13c20:	00080537          	lui	a0,0x80
   13c24:	fff50513          	addi	a0,a0,-1 # 7ffff <__freertos_irq_stack_top+0x682df>
   13c28:	00a87533          	and	a0,a6,a0
   13c2c:	02a12e23          	sw	a0,60(sp)
   13c30:	1c050863          	beqz	a0,13e00 <__subtf3+0xa18>
   13c34:	580010ef          	jal	ra,151b4 <__clzsi2>
   13c38:	ff450513          	addi	a0,a0,-12
   13c3c:	41f55793          	srai	a5,a0,0x1f
   13c40:	01b7d693          	srli	a3,a5,0x1b
   13c44:	00d50633          	add	a2,a0,a3
   13c48:	01f7f713          	andi	a4,a5,31
   13c4c:	01f67613          	andi	a2,a2,31
   13c50:	00a70733          	add	a4,a4,a0
   13c54:	40d60633          	sub	a2,a2,a3
   13c58:	40575713          	srai	a4,a4,0x5
   13c5c:	1c061863          	bnez	a2,13e2c <__subtf3+0xa44>
   13c60:	40e006b3          	neg	a3,a4
   13c64:	00269693          	slli	a3,a3,0x2
   13c68:	03010593          	addi	a1,sp,48
   13c6c:	00c68693          	addi	a3,a3,12
   13c70:	00d586b3          	add	a3,a1,a3
   13c74:	0006a603          	lw	a2,0(a3)
   13c78:	00271893          	slli	a7,a4,0x2
   13c7c:	011687b3          	add	a5,a3,a7
   13c80:	00c7a023          	sw	a2,0(a5)
   13c84:	ffc68813          	addi	a6,a3,-4
   13c88:	00d58e63          	beq	a1,a3,13ca4 <__subtf3+0x8bc>
   13c8c:	00080693          	mv	a3,a6
   13c90:	0006a603          	lw	a2,0(a3)
   13c94:	011687b3          	add	a5,a3,a7
   13c98:	ffc68813          	addi	a6,a3,-4
   13c9c:	00c7a023          	sw	a2,0(a5)
   13ca0:	fed596e3          	bne	a1,a3,13c8c <__subtf3+0x8a4>
   13ca4:	fff70713          	addi	a4,a4,-1 # 7fff <localeconv+0x7>
   13ca8:	fff00793          	li	a5,-1
   13cac:	02f70463          	beq	a4,a5,13cd4 <__subtf3+0x8ec>
   13cb0:	00271713          	slli	a4,a4,0x2
   13cb4:	00e58733          	add	a4,a1,a4
   13cb8:	00072023          	sw	zero,0(a4)
   13cbc:	ffc70793          	addi	a5,a4,-4
   13cc0:	00e58a63          	beq	a1,a4,13cd4 <__subtf3+0x8ec>
   13cc4:	00078713          	mv	a4,a5
   13cc8:	00072023          	sw	zero,0(a4)
   13ccc:	ffc70793          	addi	a5,a4,-4
   13cd0:	fee59ae3          	bne	a1,a4,13cc4 <__subtf3+0x8dc>
   13cd4:	11254663          	blt	a0,s2,13de0 <__subtf3+0x9f8>
   13cd8:	41250533          	sub	a0,a0,s2
   13cdc:	00150513          	addi	a0,a0,1
   13ce0:	41f55793          	srai	a5,a0,0x1f
   13ce4:	01b7d713          	srli	a4,a5,0x1b
   13ce8:	00e50833          	add	a6,a0,a4
   13cec:	01f7f793          	andi	a5,a5,31
   13cf0:	00a787b3          	add	a5,a5,a0
   13cf4:	01f87813          	andi	a6,a6,31
   13cf8:	01f00693          	li	a3,31
   13cfc:	4057d793          	srai	a5,a5,0x5
   13d00:	40e80833          	sub	a6,a6,a4
   13d04:	0aa6d0e3          	bge	a3,a0,145a4 <__subtf3+0x11bc>
   13d08:	00058693          	mv	a3,a1
   13d0c:	00000513          	li	a0,0
   13d10:	00000713          	li	a4,0
   13d14:	0006a603          	lw	a2,0(a3)
   13d18:	00170713          	addi	a4,a4,1
   13d1c:	00468693          	addi	a3,a3,4
   13d20:	00c56533          	or	a0,a0,a2
   13d24:	fef748e3          	blt	a4,a5,13d14 <__subtf3+0x92c>
   13d28:	00078713          	mv	a4,a5
   13d2c:	52f05463          	blez	a5,14254 <__subtf3+0xe6c>
   13d30:	00300893          	li	a7,3
   13d34:	40f888b3          	sub	a7,a7,a5
   13d38:	3c081863          	bnez	a6,14108 <__subtf3+0xd20>
   13d3c:	00058713          	mv	a4,a1
   13d40:	00279613          	slli	a2,a5,0x2
   13d44:	00c706b3          	add	a3,a4,a2
   13d48:	0006a683          	lw	a3,0(a3)
   13d4c:	00470713          	addi	a4,a4,4
   13d50:	00180813          	addi	a6,a6,1 # 80001 <__freertos_irq_stack_top+0x682e1>
   13d54:	fed72e23          	sw	a3,-4(a4)
   13d58:	ff08d6e3          	bge	a7,a6,13d44 <__subtf3+0x95c>
   13d5c:	00400713          	li	a4,4
   13d60:	40f707b3          	sub	a5,a4,a5
   13d64:	4280006f          	j	1418c <__subtf3+0xda4>
   13d68:	02612823          	sw	t1,48(sp)
   13d6c:	02f12a23          	sw	a5,52(sp)
   13d70:	02c12c23          	sw	a2,56(sp)
   13d74:	03e12e23          	sw	t5,60(sp)
   13d78:	03412583          	lw	a1,52(sp)
   13d7c:	03012503          	lw	a0,48(sp)
   13d80:	03c12703          	lw	a4,60(sp)
   13d84:	00058693          	mv	a3,a1
   13d88:	a69ff06f          	j	137f0 <__subtf3+0x408>
   13d8c:	1a089063          	bnez	a7,13f2c <__subtf3+0xb44>
   13d90:	00008eb7          	lui	t4,0x8
   13d94:	00190893          	addi	a7,s2,1
   13d98:	ffee8713          	addi	a4,t4,-2 # 7ffe <localeconv+0x6>
   13d9c:	00e8f733          	and	a4,a7,a4
   13da0:	6a071463          	bnez	a4,14448 <__subtf3+0x1060>
   13da4:	00c7e733          	or	a4,a5,a2
   13da8:	01e76733          	or	a4,a4,t5
   13dac:	00676733          	or	a4,a4,t1
   13db0:	58091863          	bnez	s2,14340 <__subtf3+0xf58>
   13db4:	200700e3          	beqz	a4,147b4 <__subtf3+0x13cc>
   13db8:	00de6733          	or	a4,t3,a3
   13dbc:	00576733          	or	a4,a4,t0
   13dc0:	00b76733          	or	a4,a4,a1
   13dc4:	180716e3          	bnez	a4,14750 <__subtf3+0x1368>
   13dc8:	02612823          	sw	t1,48(sp)
   13dcc:	02f12a23          	sw	a5,52(sp)
   13dd0:	02c12c23          	sw	a2,56(sp)
   13dd4:	03e12e23          	sw	t5,60(sp)
   13dd8:	00000893          	li	a7,0
   13ddc:	f9dff06f          	j	13d78 <__subtf3+0x990>
   13de0:	03c12703          	lw	a4,60(sp)
   13de4:	fff807b7          	lui	a5,0xfff80
   13de8:	fff78793          	addi	a5,a5,-1 # fff7ffff <__freertos_irq_stack_top+0xfff682df>
   13dec:	00f77733          	and	a4,a4,a5
   13df0:	40a90933          	sub	s2,s2,a0
   13df4:	02e12e23          	sw	a4,60(sp)
   13df8:	03012503          	lw	a0,48(sp)
   13dfc:	975ff06f          	j	13770 <__subtf3+0x388>
   13e00:	03812503          	lw	a0,56(sp)
   13e04:	2c050263          	beqz	a0,140c8 <__subtf3+0xce0>
   13e08:	3ac010ef          	jal	ra,151b4 <__clzsi2>
   13e0c:	02050513          	addi	a0,a0,32
   13e10:	e29ff06f          	j	13c38 <__subtf3+0x850>
   13e14:	fff68693          	addi	a3,a3,-1
   13e18:	02d12c23          	sw	a3,56(sp)
   13e1c:	40b60633          	sub	a2,a2,a1
   13e20:	00163613          	seqz	a2,a2
   13e24:	00c56533          	or	a0,a0,a2
   13e28:	931ff06f          	j	13758 <__subtf3+0x370>
   13e2c:	03010593          	addi	a1,sp,48
   13e30:	00271693          	slli	a3,a4,0x2
   13e34:	02000e13          	li	t3,32
   13e38:	40d586b3          	sub	a3,a1,a3
   13e3c:	00271e93          	slli	t4,a4,0x2
   13e40:	00300893          	li	a7,3
   13e44:	40ce0e33          	sub	t3,t3,a2
   13e48:	0086a783          	lw	a5,8(a3)
   13e4c:	00c6a803          	lw	a6,12(a3)
   13e50:	01d68333          	add	t1,a3,t4
   13e54:	01c7d7b3          	srl	a5,a5,t3
   13e58:	00c81833          	sll	a6,a6,a2
   13e5c:	0107e7b3          	or	a5,a5,a6
   13e60:	00f32623          	sw	a5,12(t1)
   13e64:	fff88893          	addi	a7,a7,-1
   13e68:	ffc68693          	addi	a3,a3,-4
   13e6c:	fd174ee3          	blt	a4,a7,13e48 <__subtf3+0xa60>
   13e70:	00200793          	li	a5,2
   13e74:	3ce7cc63          	blt	a5,a4,1424c <__subtf3+0xe64>
   13e78:	00271793          	slli	a5,a4,0x2
   13e7c:	04010693          	addi	a3,sp,64
   13e80:	00f687b3          	add	a5,a3,a5
   13e84:	03012683          	lw	a3,48(sp)
   13e88:	fff70713          	addi	a4,a4,-1
   13e8c:	00c69633          	sll	a2,a3,a2
   13e90:	fec7a823          	sw	a2,-16(a5)
   13e94:	e15ff06f          	j	13ca8 <__subtf3+0x8c0>
   13e98:	40530eb3          	sub	t4,t1,t0
   13e9c:	41c789b3          	sub	s3,a5,t3
   13ea0:	01d33fb3          	sltu	t6,t1,t4
   13ea4:	41f98fb3          	sub	t6,s3,t6
   13ea8:	40d60ab3          	sub	s5,a2,a3
   13eac:	01563a33          	sltu	s4,a2,s5
   13eb0:	03d12823          	sw	t4,48(sp)
   13eb4:	03f12a23          	sw	t6,52(sp)
   13eb8:	0137b3b3          	sltu	t2,a5,s3
   13ebc:	000a0813          	mv	a6,s4
   13ec0:	05d37263          	bgeu	t1,t4,13f04 <__subtf3+0xb1c>
   13ec4:	05c79063          	bne	a5,t3,13f04 <__subtf3+0xb1c>
   13ec8:	fffa8393          	addi	t2,s5,-1 # 7fffff <__freertos_irq_stack_top+0x7e82df>
   13ecc:	02712c23          	sw	t2,56(sp)
   13ed0:	001ab513          	seqz	a0,s5
   13ed4:	00aa6833          	or	a6,s4,a0
   13ed8:	40bf0533          	sub	a0,t5,a1
   13edc:	41050533          	sub	a0,a0,a6
   13ee0:	02a12e23          	sw	a0,60(sp)
   13ee4:	00c51813          	slli	a6,a0,0xc
   13ee8:	5e084863          	bltz	a6,144d8 <__subtf3+0x10f0>
   13eec:	01fee7b3          	or	a5,t4,t6
   13ef0:	0077e7b3          	or	a5,a5,t2
   13ef4:	00a7e7b3          	or	a5,a5,a0
   13ef8:	d2079ce3          	bnez	a5,13c30 <__subtf3+0x848>
   13efc:	00000493          	li	s1,0
   13f00:	e79ff06f          	j	13d78 <__subtf3+0x990>
   13f04:	407a83b3          	sub	t2,s5,t2
   13f08:	02712c23          	sw	t2,56(sp)
   13f0c:	fd37f6e3          	bgeu	a5,s3,13ed8 <__subtf3+0xaf0>
   13f10:	fc1ff06f          	j	13ed0 <__subtf3+0xae8>
   13f14:	02612823          	sw	t1,48(sp)
   13f18:	02f12a23          	sw	a5,52(sp)
   13f1c:	02c12c23          	sw	a2,56(sp)
   13f20:	03e12e23          	sw	t5,60(sp)
   13f24:	00090893          	mv	a7,s2
   13f28:	e51ff06f          	j	13d78 <__subtf3+0x990>
   13f2c:	412f88b3          	sub	a7,t6,s2
   13f30:	32091663          	bnez	s2,1425c <__subtf3+0xe74>
   13f34:	00c7e733          	or	a4,a5,a2
   13f38:	01e76733          	or	a4,a4,t5
   13f3c:	00676733          	or	a4,a4,t1
   13f40:	76070c63          	beqz	a4,146b8 <__subtf3+0x12d0>
   13f44:	fff88713          	addi	a4,a7,-1
   13f48:	160700e3          	beqz	a4,148a8 <__subtf3+0x14c0>
   13f4c:	000087b7          	lui	a5,0x8
   13f50:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   13f54:	76f88263          	beq	a7,a5,146b8 <__subtf3+0x12d0>
   13f58:	07400793          	li	a5,116
   13f5c:	32e7c063          	blt	a5,a4,1427c <__subtf3+0xe94>
   13f60:	00070893          	mv	a7,a4
   13f64:	41f8d793          	srai	a5,a7,0x1f
   13f68:	01b7d713          	srli	a4,a5,0x1b
   13f6c:	00e88f33          	add	t5,a7,a4
   13f70:	01f7f793          	andi	a5,a5,31
   13f74:	011787b3          	add	a5,a5,a7
   13f78:	01ff7f13          	andi	t5,t5,31
   13f7c:	01f00613          	li	a2,31
   13f80:	4057d793          	srai	a5,a5,0x5
   13f84:	40ef0f33          	sub	t5,t5,a4
   13f88:	1b1650e3          	bge	a2,a7,14928 <__subtf3+0x1540>
   13f8c:	01010e93          	addi	t4,sp,16
   13f90:	00000713          	li	a4,0
   13f94:	000e8613          	mv	a2,t4
   13f98:	00000893          	li	a7,0
   13f9c:	00170713          	addi	a4,a4,1
   13fa0:	0068e8b3          	or	a7,a7,t1
   13fa4:	00460613          	addi	a2,a2,4
   13fa8:	00f75c63          	bge	a4,a5,13fc0 <__subtf3+0xbd8>
   13fac:	00062303          	lw	t1,0(a2)
   13fb0:	00170713          	addi	a4,a4,1
   13fb4:	00460613          	addi	a2,a2,4
   13fb8:	0068e8b3          	or	a7,a7,t1
   13fbc:	fef748e3          	blt	a4,a5,13fac <__subtf3+0xbc4>
   13fc0:	00078713          	mv	a4,a5
   13fc4:	00f04463          	bgtz	a5,13fcc <__subtf3+0xbe4>
   13fc8:	00100713          	li	a4,1
   13fcc:	00300813          	li	a6,3
   13fd0:	40f80833          	sub	a6,a6,a5
   13fd4:	020f1ce3          	bnez	t5,1480c <__subtf3+0x1424>
   13fd8:	000e8713          	mv	a4,t4
   13fdc:	00279513          	slli	a0,a5,0x2
   13fe0:	00a70633          	add	a2,a4,a0
   13fe4:	00062603          	lw	a2,0(a2)
   13fe8:	00470713          	addi	a4,a4,4
   13fec:	001f0f13          	addi	t5,t5,1
   13ff0:	fec72e23          	sw	a2,-4(a4)
   13ff4:	ffe856e3          	bge	a6,t5,13fe0 <__subtf3+0xbf8>
   13ff8:	00400713          	li	a4,4
   13ffc:	40f707b3          	sub	a5,a4,a5
   14000:	00300713          	li	a4,3
   14004:	00f74e63          	blt	a4,a5,14020 <__subtf3+0xc38>
   14008:	00279793          	slli	a5,a5,0x2
   1400c:	00fe87b3          	add	a5,t4,a5
   14010:	02010713          	addi	a4,sp,32
   14014:	0007a023          	sw	zero,0(a5)
   14018:	00478793          	addi	a5,a5,4
   1401c:	fee79ce3          	bne	a5,a4,14014 <__subtf3+0xc2c>
   14020:	01812703          	lw	a4,24(sp)
   14024:	01412603          	lw	a2,20(sp)
   14028:	01012783          	lw	a5,16(sp)
   1402c:	00e68733          	add	a4,a3,a4
   14030:	00d73833          	sltu	a6,a4,a3
   14034:	01c12683          	lw	a3,28(sp)
   14038:	01103533          	snez	a0,a7
   1403c:	00ce0633          	add	a2,t3,a2
   14040:	00f56533          	or	a0,a0,a5
   14044:	00d585b3          	add	a1,a1,a3
   14048:	01c637b3          	sltu	a5,a2,t3
   1404c:	2440006f          	j	14290 <__subtf3+0xea8>
   14050:	000087b7          	lui	a5,0x8
   14054:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   14058:	34ff8463          	beq	t6,a5,143a0 <__subtf3+0xfb8>
   1405c:	00080837          	lui	a6,0x80
   14060:	010f6833          	or	a6,t5,a6
   14064:	01012e23          	sw	a6,28(sp)
   14068:	07400793          	li	a5,116
   1406c:	9717d4e3          	bge	a5,a7,139d4 <__subtf3+0x5ec>
   14070:	00068613          	mv	a2,a3
   14074:	000e0893          	mv	a7,t3
   14078:	00000813          	li	a6,0
   1407c:	00000313          	li	t1,0
   14080:	00000513          	li	a0,0
   14084:	00000e93          	li	t4,0
   14088:	00100793          	li	a5,1
   1408c:	40f287b3          	sub	a5,t0,a5
   14090:	00f2bf33          	sltu	t5,t0,a5
   14094:	41e888b3          	sub	a7,a7,t5
   14098:	02f12823          	sw	a5,48(sp)
   1409c:	03112a23          	sw	a7,52(sp)
   140a0:	00f2f463          	bgeu	t0,a5,140a8 <__subtf3+0xcc0>
   140a4:	39de0663          	beq	t3,t4,14430 <__subtf3+0x1048>
   140a8:	40660633          	sub	a2,a2,t1
   140ac:	02c12c23          	sw	a2,56(sp)
   140b0:	38031463          	bnez	t1,14438 <__subtf3+0x1050>
   140b4:	41058833          	sub	a6,a1,a6
   140b8:	03012e23          	sw	a6,60(sp)
   140bc:	000f8913          	mv	s2,t6
   140c0:	00070493          	mv	s1,a4
   140c4:	e9cff06f          	j	13760 <__subtf3+0x378>
   140c8:	03412503          	lw	a0,52(sp)
   140cc:	20051063          	bnez	a0,142cc <__subtf3+0xee4>
   140d0:	03012503          	lw	a0,48(sp)
   140d4:	0e0010ef          	jal	ra,151b4 <__clzsi2>
   140d8:	05450513          	addi	a0,a0,84
   140dc:	01f57613          	andi	a2,a0,31
   140e0:	40555713          	srai	a4,a0,0x5
   140e4:	b6060ee3          	beqz	a2,13c60 <__subtf3+0x878>
   140e8:	05f00793          	li	a5,95
   140ec:	d4a7d0e3          	bge	a5,a0,13e2c <__subtf3+0xa44>
   140f0:	03012783          	lw	a5,48(sp)
   140f4:	00200713          	li	a4,2
   140f8:	03010593          	addi	a1,sp,48
   140fc:	00c79633          	sll	a2,a5,a2
   14100:	02c12e23          	sw	a2,60(sp)
   14104:	badff06f          	j	13cb0 <__subtf3+0x8c8>
   14108:	00271713          	slli	a4,a4,0x2
   1410c:	04010693          	addi	a3,sp,64
   14110:	00e68733          	add	a4,a3,a4
   14114:	ff072703          	lw	a4,-16(a4)
   14118:	02000e93          	li	t4,32
   1411c:	410e8eb3          	sub	t4,t4,a6
   14120:	01d71733          	sll	a4,a4,t4
   14124:	00e56533          	or	a0,a0,a4
   14128:	28088a63          	beqz	a7,143bc <__subtf3+0xfd4>
   1412c:	00f88333          	add	t1,a7,a5
   14130:	00279713          	slli	a4,a5,0x2
   14134:	00231313          	slli	t1,t1,0x2
   14138:	40f00f33          	neg	t5,a5
   1413c:	00e58733          	add	a4,a1,a4
   14140:	00658333          	add	t1,a1,t1
   14144:	002f1f13          	slli	t5,t5,0x2
   14148:	00072683          	lw	a3,0(a4)
   1414c:	00472603          	lw	a2,4(a4)
   14150:	01e70e33          	add	t3,a4,t5
   14154:	0106d6b3          	srl	a3,a3,a6
   14158:	01d61633          	sll	a2,a2,t4
   1415c:	00c6e6b3          	or	a3,a3,a2
   14160:	00de2023          	sw	a3,0(t3)
   14164:	00470713          	addi	a4,a4,4
   14168:	fee310e3          	bne	t1,a4,14148 <__subtf3+0xd60>
   1416c:	04010693          	addi	a3,sp,64
   14170:	00289713          	slli	a4,a7,0x2
   14174:	00e68733          	add	a4,a3,a4
   14178:	03c12683          	lw	a3,60(sp)
   1417c:	0106d833          	srl	a6,a3,a6
   14180:	00400693          	li	a3,4
   14184:	40f687b3          	sub	a5,a3,a5
   14188:	ff072823          	sw	a6,-16(a4)
   1418c:	00300713          	li	a4,3
   14190:	00f74e63          	blt	a4,a5,141ac <__subtf3+0xdc4>
   14194:	00279793          	slli	a5,a5,0x2
   14198:	00f587b3          	add	a5,a1,a5
   1419c:	04010713          	addi	a4,sp,64
   141a0:	0007a023          	sw	zero,0(a5)
   141a4:	00478793          	addi	a5,a5,4
   141a8:	fef71ce3          	bne	a4,a5,141a0 <__subtf3+0xdb8>
   141ac:	03012783          	lw	a5,48(sp)
   141b0:	00a03533          	snez	a0,a0
   141b4:	03c12803          	lw	a6,60(sp)
   141b8:	00f56533          	or	a0,a0,a5
   141bc:	02a12823          	sw	a0,48(sp)
   141c0:	00000913          	li	s2,0
   141c4:	00757793          	andi	a5,a0,7
   141c8:	da079a63          	bnez	a5,1377c <__subtf3+0x394>
   141cc:	df0ff06f          	j	137bc <__subtf3+0x3d4>
   141d0:	00271713          	slli	a4,a4,0x2
   141d4:	04010693          	addi	a3,sp,64
   141d8:	00e68733          	add	a4,a3,a4
   141dc:	fe072703          	lw	a4,-32(a4)
   141e0:	02000293          	li	t0,32
   141e4:	411282b3          	sub	t0,t0,a7
   141e8:	00571733          	sll	a4,a4,t0
   141ec:	00ee6e33          	or	t3,t3,a4
   141f0:	18050e63          	beqz	a0,1438c <__subtf3+0xfa4>
   141f4:	00281593          	slli	a1,a6,0x2
   141f8:	00251513          	slli	a0,a0,0x2
   141fc:	00be85b3          	add	a1,t4,a1
   14200:	000e8713          	mv	a4,t4
   14204:	00ae83b3          	add	t2,t4,a0
   14208:	0005a683          	lw	a3,0(a1)
   1420c:	0045af83          	lw	t6,4(a1)
   14210:	00470713          	addi	a4,a4,4
   14214:	0116d6b3          	srl	a3,a3,a7
   14218:	005f9fb3          	sll	t6,t6,t0
   1421c:	01f6e6b3          	or	a3,a3,t6
   14220:	fed72e23          	sw	a3,-4(a4)
   14224:	00458593          	addi	a1,a1,4
   14228:	fee390e3          	bne	t2,a4,14208 <__subtf3+0xe20>
   1422c:	04010713          	addi	a4,sp,64
   14230:	00a70533          	add	a0,a4,a0
   14234:	02c12703          	lw	a4,44(sp)
   14238:	011758b3          	srl	a7,a4,a7
   1423c:	00400713          	li	a4,4
   14240:	41070733          	sub	a4,a4,a6
   14244:	ff152023          	sw	a7,-32(a0)
   14248:	b54ff06f          	j	1359c <__subtf3+0x1b4>
   1424c:	00200713          	li	a4,2
   14250:	c29ff06f          	j	13e78 <__subtf3+0xa90>
   14254:	00100713          	li	a4,1
   14258:	ad9ff06f          	j	13d30 <__subtf3+0x948>
   1425c:	000087b7          	lui	a5,0x8
   14260:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   14264:	68ff8c63          	beq	t6,a5,148fc <__subtf3+0x1514>
   14268:	00080837          	lui	a6,0x80
   1426c:	010f6833          	or	a6,t5,a6
   14270:	01012e23          	sw	a6,28(sp)
   14274:	07400793          	li	a5,116
   14278:	cf17d6e3          	bge	a5,a7,13f64 <__subtf3+0xb7c>
   1427c:	00068713          	mv	a4,a3
   14280:	000e0613          	mv	a2,t3
   14284:	00000813          	li	a6,0
   14288:	00000793          	li	a5,0
   1428c:	00100513          	li	a0,1
   14290:	00a28533          	add	a0,t0,a0
   14294:	005532b3          	sltu	t0,a0,t0
   14298:	00c286b3          	add	a3,t0,a2
   1429c:	0056b2b3          	sltu	t0,a3,t0
   142a0:	0057e7b3          	or	a5,a5,t0
   142a4:	00e78733          	add	a4,a5,a4
   142a8:	00f737b3          	sltu	a5,a4,a5
   142ac:	00f86833          	or	a6,a6,a5
   142b0:	00b80833          	add	a6,a6,a1
   142b4:	02a12823          	sw	a0,48(sp)
   142b8:	02d12a23          	sw	a3,52(sp)
   142bc:	02e12c23          	sw	a4,56(sp)
   142c0:	03012e23          	sw	a6,60(sp)
   142c4:	000f8913          	mv	s2,t6
   142c8:	861ff06f          	j	13b28 <__subtf3+0x740>
   142cc:	6e9000ef          	jal	ra,151b4 <__clzsi2>
   142d0:	04050513          	addi	a0,a0,64
   142d4:	965ff06f          	j	13c38 <__subtf3+0x850>
   142d8:	00530533          	add	a0,t1,t0
   142dc:	00653333          	sltu	t1,a0,t1
   142e0:	01c78e33          	add	t3,a5,t3
   142e4:	006e08b3          	add	a7,t3,t1
   142e8:	00fe37b3          	sltu	a5,t3,a5
   142ec:	0068b333          	sltu	t1,a7,t1
   142f0:	0067e7b3          	or	a5,a5,t1
   142f4:	00d606b3          	add	a3,a2,a3
   142f8:	00f68733          	add	a4,a3,a5
   142fc:	00f737b3          	sltu	a5,a4,a5
   14300:	00c6b6b3          	sltu	a3,a3,a2
   14304:	00f6e7b3          	or	a5,a3,a5
   14308:	00bf0833          	add	a6,t5,a1
   1430c:	01078833          	add	a6,a5,a6
   14310:	02a12823          	sw	a0,48(sp)
   14314:	03112a23          	sw	a7,52(sp)
   14318:	02e12c23          	sw	a4,56(sp)
   1431c:	03012e23          	sw	a6,60(sp)
   14320:	00100913          	li	s2,1
   14324:	805ff06f          	j	13b28 <__subtf3+0x740>
   14328:	02512823          	sw	t0,48(sp)
   1432c:	03c12a23          	sw	t3,52(sp)
   14330:	02d12c23          	sw	a3,56(sp)
   14334:	02b12e23          	sw	a1,60(sp)
   14338:	00070493          	mv	s1,a4
   1433c:	a3dff06f          	j	13d78 <__subtf3+0x990>
   14340:	2c071063          	bnez	a4,14600 <__subtf3+0x1218>
   14344:	02512823          	sw	t0,48(sp)
   14348:	03c12a23          	sw	t3,52(sp)
   1434c:	02d12c23          	sw	a3,56(sp)
   14350:	02b12e23          	sw	a1,60(sp)
   14354:	fffe8893          	addi	a7,t4,-1
   14358:	a21ff06f          	j	13d78 <__subtf3+0x990>
   1435c:	02512823          	sw	t0,48(sp)
   14360:	03c12a23          	sw	t3,52(sp)
   14364:	02d12c23          	sw	a3,56(sp)
   14368:	02b12e23          	sw	a1,60(sp)
   1436c:	00000493          	li	s1,0
   14370:	a00804e3          	beqz	a6,13d78 <__subtf3+0x990>
   14374:	00070493          	mv	s1,a4
   14378:	a01ff06f          	j	13d78 <__subtf3+0x990>
   1437c:	00000713          	li	a4,0
   14380:	00000593          	li	a1,0
   14384:	02010e93          	addi	t4,sp,32
   14388:	d90ff06f          	j	13918 <__subtf3+0x530>
   1438c:	02c12683          	lw	a3,44(sp)
   14390:	00100713          	li	a4,1
   14394:	0116d8b3          	srl	a7,a3,a7
   14398:	03112023          	sw	a7,32(sp)
   1439c:	a08ff06f          	j	135a4 <__subtf3+0x1bc>
   143a0:	02512823          	sw	t0,48(sp)
   143a4:	03c12a23          	sw	t3,52(sp)
   143a8:	02d12c23          	sw	a3,56(sp)
   143ac:	02b12e23          	sw	a1,60(sp)
   143b0:	000f8893          	mv	a7,t6
   143b4:	00070493          	mv	s1,a4
   143b8:	9c1ff06f          	j	13d78 <__subtf3+0x990>
   143bc:	03c12703          	lw	a4,60(sp)
   143c0:	00100793          	li	a5,1
   143c4:	01075833          	srl	a6,a4,a6
   143c8:	03012823          	sw	a6,48(sp)
   143cc:	dc9ff06f          	j	14194 <__subtf3+0xdac>
   143d0:	405302b3          	sub	t0,t1,t0
   143d4:	41c78533          	sub	a0,a5,t3
   143d8:	00533733          	sltu	a4,t1,t0
   143dc:	40e50733          	sub	a4,a0,a4
   143e0:	40d60ab3          	sub	s5,a2,a3
   143e4:	01563633          	sltu	a2,a2,s5
   143e8:	02e12a23          	sw	a4,52(sp)
   143ec:	02512823          	sw	t0,48(sp)
   143f0:	00a7b733          	sltu	a4,a5,a0
   143f4:	00060693          	mv	a3,a2
   143f8:	00537463          	bgeu	t1,t0,14400 <__subtf3+0x1018>
   143fc:	1fc78463          	beq	a5,t3,145e4 <__subtf3+0x11fc>
   14400:	40ea8733          	sub	a4,s5,a4
   14404:	02e12c23          	sw	a4,56(sp)
   14408:	1ea7e263          	bltu	a5,a0,145ec <__subtf3+0x1204>
   1440c:	40bf0833          	sub	a6,t5,a1
   14410:	40d80833          	sub	a6,a6,a3
   14414:	03012e23          	sw	a6,60(sp)
   14418:	00100913          	li	s2,1
   1441c:	b44ff06f          	j	13760 <__subtf3+0x378>
   14420:	03412583          	lw	a1,52(sp)
   14424:	00090893          	mv	a7,s2
   14428:	00058693          	mv	a3,a1
   1442c:	bc4ff06f          	j	137f0 <__subtf3+0x408>
   14430:	fff60613          	addi	a2,a2,-1
   14434:	02c12c23          	sw	a2,56(sp)
   14438:	40a687b3          	sub	a5,a3,a0
   1443c:	0017b793          	seqz	a5,a5
   14440:	00f86833          	or	a6,a6,a5
   14444:	c71ff06f          	j	140b4 <__subtf3+0xccc>
   14448:	005302b3          	add	t0,t1,t0
   1444c:	0062b333          	sltu	t1,t0,t1
   14450:	01c78e33          	add	t3,a5,t3
   14454:	006e0fb3          	add	t6,t3,t1
   14458:	006fb333          	sltu	t1,t6,t1
   1445c:	00fe37b3          	sltu	a5,t3,a5
   14460:	00d606b3          	add	a3,a2,a3
   14464:	0067e7b3          	or	a5,a5,t1
   14468:	00f68333          	add	t1,a3,a5
   1446c:	00c6b733          	sltu	a4,a3,a2
   14470:	00f337b3          	sltu	a5,t1,a5
   14474:	00f76733          	or	a4,a4,a5
   14478:	00bf0833          	add	a6,t5,a1
   1447c:	01070733          	add	a4,a4,a6
   14480:	01ff9513          	slli	a0,t6,0x1f
   14484:	0012d293          	srli	t0,t0,0x1
   14488:	01f31693          	slli	a3,t1,0x1f
   1448c:	001fdf93          	srli	t6,t6,0x1
   14490:	00135793          	srli	a5,t1,0x1
   14494:	01f71613          	slli	a2,a4,0x1f
   14498:	00556533          	or	a0,a0,t0
   1449c:	01f6efb3          	or	t6,a3,t6
   144a0:	00c7e7b3          	or	a5,a5,a2
   144a4:	00175813          	srli	a6,a4,0x1
   144a8:	02a12823          	sw	a0,48(sp)
   144ac:	03f12a23          	sw	t6,52(sp)
   144b0:	02f12c23          	sw	a5,56(sp)
   144b4:	03012e23          	sw	a6,60(sp)
   144b8:	fffe8e93          	addi	t4,t4,-1
   144bc:	00088913          	mv	s2,a7
   144c0:	d1d892e3          	bne	a7,t4,141c4 <__subtf3+0xddc>
   144c4:	02012e23          	sw	zero,60(sp)
   144c8:	02012c23          	sw	zero,56(sp)
   144cc:	02012a23          	sw	zero,52(sp)
   144d0:	02012823          	sw	zero,48(sp)
   144d4:	8a5ff06f          	j	13d78 <__subtf3+0x990>
   144d8:	40628333          	sub	t1,t0,t1
   144dc:	40fe0833          	sub	a6,t3,a5
   144e0:	0062b533          	sltu	a0,t0,t1
   144e4:	40a80533          	sub	a0,a6,a0
   144e8:	40c68633          	sub	a2,a3,a2
   144ec:	00c6b6b3          	sltu	a3,a3,a2
   144f0:	02a12a23          	sw	a0,52(sp)
   144f4:	02612823          	sw	t1,48(sp)
   144f8:	010e3533          	sltu	a0,t3,a6
   144fc:	00068893          	mv	a7,a3
   14500:	0062f463          	bgeu	t0,t1,14508 <__subtf3+0x1120>
   14504:	1fc78263          	beq	a5,t3,146e8 <__subtf3+0x1300>
   14508:	40a60633          	sub	a2,a2,a0
   1450c:	02c12c23          	sw	a2,56(sp)
   14510:	1f0e6063          	bltu	t3,a6,146f0 <__subtf3+0x1308>
   14514:	41e58533          	sub	a0,a1,t5
   14518:	41150533          	sub	a0,a0,a7
   1451c:	02a12e23          	sw	a0,60(sp)
   14520:	00070493          	mv	s1,a4
   14524:	f0cff06f          	j	13c30 <__subtf3+0x848>
   14528:	00271713          	slli	a4,a4,0x2
   1452c:	04010513          	addi	a0,sp,64
   14530:	00e50733          	add	a4,a0,a4
   14534:	fe072703          	lw	a4,-32(a4)
   14538:	02000293          	li	t0,32
   1453c:	411282b3          	sub	t0,t0,a7
   14540:	00571733          	sll	a4,a4,t0
   14544:	00e5e5b3          	or	a1,a1,a4
   14548:	34080663          	beqz	a6,14894 <__subtf3+0x14ac>
   1454c:	00269513          	slli	a0,a3,0x2
   14550:	00281813          	slli	a6,a6,0x2
   14554:	00ae8533          	add	a0,t4,a0
   14558:	000e8e13          	mv	t3,t4
   1455c:	010e83b3          	add	t2,t4,a6
   14560:	00052703          	lw	a4,0(a0)
   14564:	00452f83          	lw	t6,4(a0)
   14568:	004e0e13          	addi	t3,t3,4
   1456c:	01175733          	srl	a4,a4,a7
   14570:	005f9fb3          	sll	t6,t6,t0
   14574:	01f76733          	or	a4,a4,t6
   14578:	feee2e23          	sw	a4,-4(t3)
   1457c:	00450513          	addi	a0,a0,4
   14580:	ffc390e3          	bne	t2,t3,14560 <__subtf3+0x1178>
   14584:	04010713          	addi	a4,sp,64
   14588:	01070833          	add	a6,a4,a6
   1458c:	02c12703          	lw	a4,44(sp)
   14590:	011758b3          	srl	a7,a4,a7
   14594:	00400713          	li	a4,4
   14598:	40d706b3          	sub	a3,a4,a3
   1459c:	ff182023          	sw	a7,-32(a6) # 7ffe0 <__freertos_irq_stack_top+0x682c0>
   145a0:	bacff06f          	j	1394c <__subtf3+0x564>
   145a4:	00000513          	li	a0,0
   145a8:	00000713          	li	a4,0
   145ac:	f84ff06f          	j	13d30 <__subtf3+0x948>
   145b0:	10051e63          	bnez	a0,146cc <__subtf3+0x12e4>
   145b4:	04080e63          	beqz	a6,14610 <__subtf3+0x1228>
   145b8:	02512823          	sw	t0,48(sp)
   145bc:	03c12a23          	sw	t3,52(sp)
   145c0:	02d12c23          	sw	a3,56(sp)
   145c4:	02b12e23          	sw	a1,60(sp)
   145c8:	00070493          	mv	s1,a4
   145cc:	fffe8893          	addi	a7,t4,-1
   145d0:	fa8ff06f          	j	13d78 <__subtf3+0x990>
   145d4:	00000713          	li	a4,0
   145d8:	00000e13          	li	t3,0
   145dc:	02010e93          	addi	t4,sp,32
   145e0:	f89fe06f          	j	13568 <__subtf3+0x180>
   145e4:	fffa8793          	addi	a5,s5,-1
   145e8:	02f12c23          	sw	a5,56(sp)
   145ec:	001ab693          	seqz	a3,s5
   145f0:	00d666b3          	or	a3,a2,a3
   145f4:	e19ff06f          	j	1440c <__subtf3+0x1024>
   145f8:	00090893          	mv	a7,s2
   145fc:	f7cff06f          	j	13d78 <__subtf3+0x990>
   14600:	00de6833          	or	a6,t3,a3
   14604:	00586833          	or	a6,a6,t0
   14608:	00b86833          	or	a6,a6,a1
   1460c:	0c080263          	beqz	a6,146d0 <__subtf3+0x12e8>
   14610:	000407b7          	lui	a5,0x40
   14614:	02f12e23          	sw	a5,60(sp)
   14618:	02012c23          	sw	zero,56(sp)
   1461c:	02012a23          	sw	zero,52(sp)
   14620:	02012823          	sw	zero,48(sp)
   14624:	00000493          	li	s1,0
   14628:	fffe8893          	addi	a7,t4,-1
   1462c:	f4cff06f          	j	13d78 <__subtf3+0x990>
   14630:	00261613          	slli	a2,a2,0x2
   14634:	04010513          	addi	a0,sp,64
   14638:	00c50633          	add	a2,a0,a2
   1463c:	fd062603          	lw	a2,-48(a2)
   14640:	02000913          	li	s2,32
   14644:	40790933          	sub	s2,s2,t2
   14648:	01261633          	sll	a2,a2,s2
   1464c:	00cf6f33          	or	t5,t5,a2
   14650:	2e080463          	beqz	a6,14938 <__subtf3+0x1550>
   14654:	00f80333          	add	t1,a6,a5
   14658:	00279613          	slli	a2,a5,0x2
   1465c:	00231313          	slli	t1,t1,0x2
   14660:	40f004b3          	neg	s1,a5
   14664:	00ce8633          	add	a2,t4,a2
   14668:	006e8333          	add	t1,t4,t1
   1466c:	00249493          	slli	s1,s1,0x2
   14670:	00062503          	lw	a0,0(a2)
   14674:	00462883          	lw	a7,4(a2)
   14678:	009609b3          	add	s3,a2,s1
   1467c:	00755533          	srl	a0,a0,t2
   14680:	012898b3          	sll	a7,a7,s2
   14684:	01156533          	or	a0,a0,a7
   14688:	00a9a023          	sw	a0,0(s3)
   1468c:	00460613          	addi	a2,a2,4
   14690:	fec310e3          	bne	t1,a2,14670 <__subtf3+0x1288>
   14694:	04010513          	addi	a0,sp,64
   14698:	00281613          	slli	a2,a6,0x2
   1469c:	00c50633          	add	a2,a0,a2
   146a0:	01c12503          	lw	a0,28(sp)
   146a4:	007553b3          	srl	t2,a0,t2
   146a8:	00400513          	li	a0,4
   146ac:	40f507b3          	sub	a5,a0,a5
   146b0:	fc762823          	sw	t2,-48(a2)
   146b4:	bbcff06f          	j	13a70 <__subtf3+0x688>
   146b8:	02512823          	sw	t0,48(sp)
   146bc:	03c12a23          	sw	t3,52(sp)
   146c0:	02d12c23          	sw	a3,56(sp)
   146c4:	02b12e23          	sw	a1,60(sp)
   146c8:	eb0ff06f          	j	13d78 <__subtf3+0x990>
   146cc:	f40812e3          	bnez	a6,14610 <__subtf3+0x1228>
   146d0:	02612823          	sw	t1,48(sp)
   146d4:	02f12a23          	sw	a5,52(sp)
   146d8:	02c12c23          	sw	a2,56(sp)
   146dc:	03e12e23          	sw	t5,60(sp)
   146e0:	fffe8893          	addi	a7,t4,-1
   146e4:	e94ff06f          	j	13d78 <__subtf3+0x990>
   146e8:	fff60613          	addi	a2,a2,-1
   146ec:	02c12c23          	sw	a2,56(sp)
   146f0:	001ab513          	seqz	a0,s5
   146f4:	00a6e8b3          	or	a7,a3,a0
   146f8:	e1dff06f          	j	14514 <__subtf3+0x112c>
   146fc:	40628333          	sub	t1,t0,t1
   14700:	40fe0eb3          	sub	t4,t3,a5
   14704:	0062b833          	sltu	a6,t0,t1
   14708:	410e8833          	sub	a6,t4,a6
   1470c:	40c68533          	sub	a0,a3,a2
   14710:	00a6bfb3          	sltu	t6,a3,a0
   14714:	03012a23          	sw	a6,52(sp)
   14718:	02612823          	sw	t1,48(sp)
   1471c:	01de3833          	sltu	a6,t3,t4
   14720:	000f8893          	mv	a7,t6
   14724:	0062f463          	bgeu	t0,t1,1472c <__subtf3+0x1344>
   14728:	1bc78a63          	beq	a5,t3,148dc <__subtf3+0x14f4>
   1472c:	41050533          	sub	a0,a0,a6
   14730:	02a12c23          	sw	a0,56(sp)
   14734:	1bde6863          	bltu	t3,t4,148e4 <__subtf3+0x14fc>
   14738:	41e58833          	sub	a6,a1,t5
   1473c:	41180833          	sub	a6,a6,a7
   14740:	03012e23          	sw	a6,60(sp)
   14744:	00070493          	mv	s1,a4
   14748:	00100913          	li	s2,1
   1474c:	814ff06f          	j	13760 <__subtf3+0x378>
   14750:	00530533          	add	a0,t1,t0
   14754:	00653333          	sltu	t1,a0,t1
   14758:	01c78e33          	add	t3,a5,t3
   1475c:	006e0eb3          	add	t4,t3,t1
   14760:	00fe37b3          	sltu	a5,t3,a5
   14764:	006eb333          	sltu	t1,t4,t1
   14768:	0067e7b3          	or	a5,a5,t1
   1476c:	00d606b3          	add	a3,a2,a3
   14770:	00f688b3          	add	a7,a3,a5
   14774:	00f8b7b3          	sltu	a5,a7,a5
   14778:	00c6b733          	sltu	a4,a3,a2
   1477c:	00f76733          	or	a4,a4,a5
   14780:	00bf0833          	add	a6,t5,a1
   14784:	01070733          	add	a4,a4,a6
   14788:	02a12823          	sw	a0,48(sp)
   1478c:	03d12a23          	sw	t4,52(sp)
   14790:	03112c23          	sw	a7,56(sp)
   14794:	00c71793          	slli	a5,a4,0xc
   14798:	1407de63          	bgez	a5,148f4 <__subtf3+0x150c>
   1479c:	fff807b7          	lui	a5,0xfff80
   147a0:	fff78793          	addi	a5,a5,-1 # fff7ffff <__freertos_irq_stack_top+0xfff682df>
   147a4:	00f77733          	and	a4,a4,a5
   147a8:	02e12e23          	sw	a4,60(sp)
   147ac:	00100913          	li	s2,1
   147b0:	fc1fe06f          	j	13770 <__subtf3+0x388>
   147b4:	02512823          	sw	t0,48(sp)
   147b8:	03c12a23          	sw	t3,52(sp)
   147bc:	02d12c23          	sw	a3,56(sp)
   147c0:	02b12e23          	sw	a1,60(sp)
   147c4:	00000893          	li	a7,0
   147c8:	db0ff06f          	j	13d78 <__subtf3+0x990>
   147cc:	011567b3          	or	a5,a0,a7
   147d0:	01d7e7b3          	or	a5,a5,t4
   147d4:	0107e7b3          	or	a5,a5,a6
   147d8:	9e0796e3          	bnez	a5,141c4 <__subtf3+0xddc>
   147dc:	00000493          	li	s1,0
   147e0:	00000893          	li	a7,0
   147e4:	d94ff06f          	j	13d78 <__subtf3+0x990>
   147e8:	fffa8e93          	addi	t4,s5,-1
   147ec:	03d12c23          	sw	t4,56(sp)
   147f0:	001ab813          	seqz	a6,s5
   147f4:	0103efb3          	or	t6,t2,a6
   147f8:	e75fe06f          	j	1366c <__subtf3+0x284>
   147fc:	00000f13          	li	t5,0
   14800:	00000613          	li	a2,0
   14804:	01010e93          	addi	t4,sp,16
   14808:	a34ff06f          	j	13a3c <__subtf3+0x654>
   1480c:	00271713          	slli	a4,a4,0x2
   14810:	04010613          	addi	a2,sp,64
   14814:	00e60733          	add	a4,a2,a4
   14818:	fd072703          	lw	a4,-48(a4)
   1481c:	02000993          	li	s3,32
   14820:	41e989b3          	sub	s3,s3,t5
   14824:	01371733          	sll	a4,a4,s3
   14828:	00e8e8b3          	or	a7,a7,a4
   1482c:	12080063          	beqz	a6,1494c <__subtf3+0x1564>
   14830:	00f80333          	add	t1,a6,a5
   14834:	00279713          	slli	a4,a5,0x2
   14838:	00231313          	slli	t1,t1,0x2
   1483c:	40f00933          	neg	s2,a5
   14840:	00ee8733          	add	a4,t4,a4
   14844:	006e8333          	add	t1,t4,t1
   14848:	00291913          	slli	s2,s2,0x2
   1484c:	00072603          	lw	a2,0(a4)
   14850:	00472503          	lw	a0,4(a4)
   14854:	012703b3          	add	t2,a4,s2
   14858:	01e65633          	srl	a2,a2,t5
   1485c:	01351533          	sll	a0,a0,s3
   14860:	00a66633          	or	a2,a2,a0
   14864:	00c3a023          	sw	a2,0(t2)
   14868:	00470713          	addi	a4,a4,4
   1486c:	fee310e3          	bne	t1,a4,1484c <__subtf3+0x1464>
   14870:	04010613          	addi	a2,sp,64
   14874:	00281713          	slli	a4,a6,0x2
   14878:	00e60733          	add	a4,a2,a4
   1487c:	01c12603          	lw	a2,28(sp)
   14880:	01e65f33          	srl	t5,a2,t5
   14884:	00400613          	li	a2,4
   14888:	40f607b3          	sub	a5,a2,a5
   1488c:	fde72823          	sw	t5,-48(a4)
   14890:	f70ff06f          	j	14000 <__subtf3+0xc18>
   14894:	02c12703          	lw	a4,44(sp)
   14898:	00100693          	li	a3,1
   1489c:	011758b3          	srl	a7,a4,a7
   148a0:	03112023          	sw	a7,32(sp)
   148a4:	8b0ff06f          	j	13954 <__subtf3+0x56c>
   148a8:	00530533          	add	a0,t1,t0
   148ac:	005532b3          	sltu	t0,a0,t0
   148b0:	01c787b3          	add	a5,a5,t3
   148b4:	005788b3          	add	a7,a5,t0
   148b8:	0058b2b3          	sltu	t0,a7,t0
   148bc:	01c7b7b3          	sltu	a5,a5,t3
   148c0:	0057e7b3          	or	a5,a5,t0
   148c4:	00d60633          	add	a2,a2,a3
   148c8:	00f60733          	add	a4,a2,a5
   148cc:	00f737b3          	sltu	a5,a4,a5
   148d0:	00d63633          	sltu	a2,a2,a3
   148d4:	00f667b3          	or	a5,a2,a5
   148d8:	a31ff06f          	j	14308 <__subtf3+0xf20>
   148dc:	fff50513          	addi	a0,a0,-1
   148e0:	02a12c23          	sw	a0,56(sp)
   148e4:	40d60633          	sub	a2,a2,a3
   148e8:	00163813          	seqz	a6,a2
   148ec:	010fe8b3          	or	a7,t6,a6
   148f0:	e49ff06f          	j	14738 <__subtf3+0x1350>
   148f4:	02e12e23          	sw	a4,60(sp)
   148f8:	e79fe06f          	j	13770 <__subtf3+0x388>
   148fc:	02512823          	sw	t0,48(sp)
   14900:	03c12a23          	sw	t3,52(sp)
   14904:	02d12c23          	sw	a3,56(sp)
   14908:	02b12e23          	sw	a1,60(sp)
   1490c:	000f8893          	mv	a7,t6
   14910:	c68ff06f          	j	13d78 <__subtf3+0x990>
   14914:	fff60613          	addi	a2,a2,-1
   14918:	02c12c23          	sw	a2,56(sp)
   1491c:	001ab813          	seqz	a6,s5
   14920:	0106e833          	or	a6,a3,a6
   14924:	da5fe06f          	j	136c8 <__subtf3+0x2e0>
   14928:	00000893          	li	a7,0
   1492c:	00000713          	li	a4,0
   14930:	01010e93          	addi	t4,sp,16
   14934:	e98ff06f          	j	13fcc <__subtf3+0xbe4>
   14938:	01c12603          	lw	a2,28(sp)
   1493c:	00100793          	li	a5,1
   14940:	007653b3          	srl	t2,a2,t2
   14944:	00712823          	sw	t2,16(sp)
   14948:	930ff06f          	j	13a78 <__subtf3+0x690>
   1494c:	01c12703          	lw	a4,28(sp)
   14950:	00100793          	li	a5,1
   14954:	01e75f33          	srl	t5,a4,t5
   14958:	01e12823          	sw	t5,16(sp)
   1495c:	eacff06f          	j	14008 <__subtf3+0xc20>

00014960 <__fixtfsi>:
   14960:	00c52703          	lw	a4,12(a0)
   14964:	00452583          	lw	a1,4(a0)
   14968:	00052803          	lw	a6,0(a0)
   1496c:	00852603          	lw	a2,8(a0)
   14970:	fe010113          	addi	sp,sp,-32
   14974:	00171693          	slli	a3,a4,0x1
   14978:	000047b7          	lui	a5,0x4
   1497c:	00b12223          	sw	a1,4(sp)
   14980:	00b12a23          	sw	a1,20(sp)
   14984:	01012023          	sw	a6,0(sp)
   14988:	00c12423          	sw	a2,8(sp)
   1498c:	00e12623          	sw	a4,12(sp)
   14990:	01012823          	sw	a6,16(sp)
   14994:	00c12c23          	sw	a2,24(sp)
   14998:	0116d693          	srli	a3,a3,0x11
   1499c:	ffe78593          	addi	a1,a5,-2 # 3ffe <_vfprintf_r+0x2afa>
   149a0:	00000513          	li	a0,0
   149a4:	02d5d063          	bge	a1,a3,149c4 <__fixtfsi+0x64>
   149a8:	01d78593          	addi	a1,a5,29
   149ac:	01071613          	slli	a2,a4,0x10
   149b0:	01f75713          	srli	a4,a4,0x1f
   149b4:	00d5dc63          	bge	a1,a3,149cc <__fixtfsi+0x6c>
   149b8:	80000537          	lui	a0,0x80000
   149bc:	fff54513          	not	a0,a0
   149c0:	00a70533          	add	a0,a4,a0
   149c4:	02010113          	addi	sp,sp,32
   149c8:	00008067          	ret
   149cc:	06f78793          	addi	a5,a5,111
   149d0:	40d787b3          	sub	a5,a5,a3
   149d4:	01065613          	srli	a2,a2,0x10
   149d8:	000106b7          	lui	a3,0x10
   149dc:	00d66633          	or	a2,a2,a3
   149e0:	02000513          	li	a0,32
   149e4:	4057d693          	srai	a3,a5,0x5
   149e8:	00300593          	li	a1,3
   149ec:	01f7f793          	andi	a5,a5,31
   149f0:	00c12e23          	sw	a2,28(sp)
   149f4:	40f508b3          	sub	a7,a0,a5
   149f8:	40d585b3          	sub	a1,a1,a3
   149fc:	08078463          	beqz	a5,14a84 <__fixtfsi+0x124>
   14a00:	00100513          	li	a0,1
   14a04:	0aa59063          	bne	a1,a0,14aa4 <__fixtfsi+0x144>
   14a08:	00168813          	addi	a6,a3,1 # 10001 <_svfiprintf_r+0xce9>
   14a0c:	02010513          	addi	a0,sp,32
   14a10:	00281813          	slli	a6,a6,0x2
   14a14:	00269693          	slli	a3,a3,0x2
   14a18:	00d506b3          	add	a3,a0,a3
   14a1c:	01050833          	add	a6,a0,a6
   14a20:	ff082503          	lw	a0,-16(a6)
   14a24:	ff06a803          	lw	a6,-16(a3)
   14a28:	00200693          	li	a3,2
   14a2c:	01151533          	sll	a0,a0,a7
   14a30:	00f85833          	srl	a6,a6,a5
   14a34:	01056533          	or	a0,a0,a6
   14a38:	00a12823          	sw	a0,16(sp)
   14a3c:	00259593          	slli	a1,a1,0x2
   14a40:	02010513          	addi	a0,sp,32
   14a44:	00b505b3          	add	a1,a0,a1
   14a48:	00f65633          	srl	a2,a2,a5
   14a4c:	fec5a823          	sw	a2,-16(a1)
   14a50:	00269693          	slli	a3,a3,0x2
   14a54:	01010793          	addi	a5,sp,16
   14a58:	00d787b3          	add	a5,a5,a3
   14a5c:	02010693          	addi	a3,sp,32
   14a60:	0007a023          	sw	zero,0(a5)
   14a64:	00478793          	addi	a5,a5,4
   14a68:	fed79ce3          	bne	a5,a3,14a60 <__fixtfsi+0x100>
   14a6c:	01012783          	lw	a5,16(sp)
   14a70:	40f00533          	neg	a0,a5
   14a74:	f40718e3          	bnez	a4,149c4 <__fixtfsi+0x64>
   14a78:	00078513          	mv	a0,a5
   14a7c:	02010113          	addi	sp,sp,32
   14a80:	00008067          	ret
   14a84:	00269793          	slli	a5,a3,0x2
   14a88:	02010613          	addi	a2,sp,32
   14a8c:	00f607b3          	add	a5,a2,a5
   14a90:	ff07a603          	lw	a2,-16(a5)
   14a94:	00400793          	li	a5,4
   14a98:	40d786b3          	sub	a3,a5,a3
   14a9c:	00c12823          	sw	a2,16(sp)
   14aa0:	fb1ff06f          	j	14a50 <__fixtfsi+0xf0>
   14aa4:	00100693          	li	a3,1
   14aa8:	f95ff06f          	j	14a3c <__fixtfsi+0xdc>

00014aac <__floatsitf>:
   14aac:	fd010113          	addi	sp,sp,-48
   14ab0:	02912223          	sw	s1,36(sp)
   14ab4:	02112623          	sw	ra,44(sp)
   14ab8:	02812423          	sw	s0,40(sp)
   14abc:	03212023          	sw	s2,32(sp)
   14ac0:	00050493          	mv	s1,a0
   14ac4:	06058663          	beqz	a1,14b30 <__floatsitf+0x84>
   14ac8:	41f5d793          	srai	a5,a1,0x1f
   14acc:	00b7c433          	xor	s0,a5,a1
   14ad0:	40f40433          	sub	s0,s0,a5
   14ad4:	00040513          	mv	a0,s0
   14ad8:	01f5d913          	srli	s2,a1,0x1f
   14adc:	6d8000ef          	jal	ra,151b4 <__clzsi2>
   14ae0:	05150693          	addi	a3,a0,81 # 80000051 <__freertos_irq_stack_top+0x7ffe8331>
   14ae4:	00004737          	lui	a4,0x4
   14ae8:	01e70713          	addi	a4,a4,30 # 401e <_vfprintf_r+0x2b1a>
   14aec:	00812823          	sw	s0,16(sp)
   14af0:	00012a23          	sw	zero,20(sp)
   14af4:	00012c23          	sw	zero,24(sp)
   14af8:	00012e23          	sw	zero,28(sp)
   14afc:	01f6f613          	andi	a2,a3,31
   14b00:	40a70533          	sub	a0,a4,a0
   14b04:	0a060263          	beqz	a2,14ba8 <__floatsitf+0xfc>
   14b08:	05f00793          	li	a5,95
   14b0c:	12d7d463          	bge	a5,a3,14c34 <__floatsitf+0x188>
   14b10:	00200713          	li	a4,2
   14b14:	00300793          	li	a5,3
   14b18:	00279793          	slli	a5,a5,0x2
   14b1c:	02010693          	addi	a3,sp,32
   14b20:	00f687b3          	add	a5,a3,a5
   14b24:	00c41433          	sll	s0,s0,a2
   14b28:	fe87a823          	sw	s0,-16(a5)
   14b2c:	0c40006f          	j	14bf0 <__floatsitf+0x144>
   14b30:	00000913          	li	s2,0
   14b34:	00000793          	li	a5,0
   14b38:	00000713          	li	a4,0
   14b3c:	00000613          	li	a2,0
   14b40:	00000513          	li	a0,0
   14b44:	00000813          	li	a6,0
   14b48:	01179793          	slli	a5,a5,0x11
   14b4c:	00e11623          	sh	a4,12(sp)
   14b50:	0117d793          	srli	a5,a5,0x11
   14b54:	01079713          	slli	a4,a5,0x10
   14b58:	00c12783          	lw	a5,12(sp)
   14b5c:	800106b7          	lui	a3,0x80010
   14b60:	fff68693          	addi	a3,a3,-1 # 8000ffff <__freertos_irq_stack_top+0x7fff82df>
   14b64:	00d7f7b3          	and	a5,a5,a3
   14b68:	00e7e7b3          	or	a5,a5,a4
   14b6c:	00179793          	slli	a5,a5,0x1
   14b70:	01f91593          	slli	a1,s2,0x1f
   14b74:	02c12083          	lw	ra,44(sp)
   14b78:	02812403          	lw	s0,40(sp)
   14b7c:	0017d793          	srli	a5,a5,0x1
   14b80:	00b7e7b3          	or	a5,a5,a1
   14b84:	00a4a223          	sw	a0,4(s1)
   14b88:	0104a023          	sw	a6,0(s1)
   14b8c:	00c4a423          	sw	a2,8(s1)
   14b90:	00f4a623          	sw	a5,12(s1)
   14b94:	00048513          	mv	a0,s1
   14b98:	02012903          	lw	s2,32(sp)
   14b9c:	02412483          	lw	s1,36(sp)
   14ba0:	03010113          	addi	sp,sp,48
   14ba4:	00008067          	ret
   14ba8:	4056d713          	srai	a4,a3,0x5
   14bac:	00300793          	li	a5,3
   14bb0:	40e787b3          	sub	a5,a5,a4
   14bb4:	02010613          	addi	a2,sp,32
   14bb8:	00279793          	slli	a5,a5,0x2
   14bbc:	00f607b3          	add	a5,a2,a5
   14bc0:	ff07a603          	lw	a2,-16(a5)
   14bc4:	05f00793          	li	a5,95
   14bc8:	00c12e23          	sw	a2,28(sp)
   14bcc:	08d7c263          	blt	a5,a3,14c50 <__floatsitf+0x1a4>
   14bd0:	00200793          	li	a5,2
   14bd4:	40e787b3          	sub	a5,a5,a4
   14bd8:	00279793          	slli	a5,a5,0x2
   14bdc:	02010713          	addi	a4,sp,32
   14be0:	00f707b3          	add	a5,a4,a5
   14be4:	ff07a783          	lw	a5,-16(a5)
   14be8:	00100713          	li	a4,1
   14bec:	00f12c23          	sw	a5,24(sp)
   14bf0:	01010613          	addi	a2,sp,16
   14bf4:	00271713          	slli	a4,a4,0x2
   14bf8:	00e60733          	add	a4,a2,a4
   14bfc:	00072023          	sw	zero,0(a4)
   14c00:	ffc70693          	addi	a3,a4,-4
   14c04:	00e60a63          	beq	a2,a4,14c18 <__floatsitf+0x16c>
   14c08:	00068713          	mv	a4,a3
   14c0c:	00072023          	sw	zero,0(a4)
   14c10:	ffc70693          	addi	a3,a4,-4
   14c14:	fee61ae3          	bne	a2,a4,14c08 <__floatsitf+0x15c>
   14c18:	01151793          	slli	a5,a0,0x11
   14c1c:	01012803          	lw	a6,16(sp)
   14c20:	01412503          	lw	a0,20(sp)
   14c24:	01812603          	lw	a2,24(sp)
   14c28:	01c15703          	lhu	a4,28(sp)
   14c2c:	0117d793          	srli	a5,a5,0x11
   14c30:	f19ff06f          	j	14b48 <__floatsitf+0x9c>
   14c34:	02000793          	li	a5,32
   14c38:	40c787b3          	sub	a5,a5,a2
   14c3c:	00f457b3          	srl	a5,s0,a5
   14c40:	00f12e23          	sw	a5,28(sp)
   14c44:	00100713          	li	a4,1
   14c48:	00200793          	li	a5,2
   14c4c:	ecdff06f          	j	14b18 <__floatsitf+0x6c>
   14c50:	00200713          	li	a4,2
   14c54:	f9dff06f          	j	14bf0 <__floatsitf+0x144>

00014c58 <__extenddftf2>:
   14c58:	01465793          	srli	a5,a2,0x14
   14c5c:	00c61713          	slli	a4,a2,0xc
   14c60:	7ff7f793          	andi	a5,a5,2047
   14c64:	fd010113          	addi	sp,sp,-48
   14c68:	00c75713          	srli	a4,a4,0xc
   14c6c:	00178693          	addi	a3,a5,1
   14c70:	02812423          	sw	s0,40(sp)
   14c74:	02912223          	sw	s1,36(sp)
   14c78:	02112623          	sw	ra,44(sp)
   14c7c:	03212023          	sw	s2,32(sp)
   14c80:	00b12823          	sw	a1,16(sp)
   14c84:	00e12a23          	sw	a4,20(sp)
   14c88:	00012e23          	sw	zero,28(sp)
   14c8c:	00012c23          	sw	zero,24(sp)
   14c90:	7fe6f693          	andi	a3,a3,2046
   14c94:	00050413          	mv	s0,a0
   14c98:	01f65493          	srli	s1,a2,0x1f
   14c9c:	08068863          	beqz	a3,14d2c <__extenddftf2+0xd4>
   14ca0:	000046b7          	lui	a3,0x4
   14ca4:	c0068693          	addi	a3,a3,-1024 # 3c00 <_vfprintf_r+0x26fc>
   14ca8:	00d787b3          	add	a5,a5,a3
   14cac:	0045d613          	srli	a2,a1,0x4
   14cb0:	01c71693          	slli	a3,a4,0x1c
   14cb4:	01179793          	slli	a5,a5,0x11
   14cb8:	00c6e6b3          	or	a3,a3,a2
   14cbc:	01c59593          	slli	a1,a1,0x1c
   14cc0:	00475713          	srli	a4,a4,0x4
   14cc4:	0117d793          	srli	a5,a5,0x11
   14cc8:	00000813          	li	a6,0
   14ccc:	00e11623          	sh	a4,12(sp)
   14cd0:	00c12703          	lw	a4,12(sp)
   14cd4:	01179793          	slli	a5,a5,0x11
   14cd8:	80010537          	lui	a0,0x80010
   14cdc:	fff50513          	addi	a0,a0,-1 # 8000ffff <__freertos_irq_stack_top+0x7fff82df>
   14ce0:	0117d793          	srli	a5,a5,0x11
   14ce4:	00a77733          	and	a4,a4,a0
   14ce8:	01079793          	slli	a5,a5,0x10
   14cec:	00f767b3          	or	a5,a4,a5
   14cf0:	00179793          	slli	a5,a5,0x1
   14cf4:	01f49613          	slli	a2,s1,0x1f
   14cf8:	0017d793          	srli	a5,a5,0x1
   14cfc:	00c7e7b3          	or	a5,a5,a2
   14d00:	01042023          	sw	a6,0(s0)
   14d04:	00b42223          	sw	a1,4(s0)
   14d08:	00d42423          	sw	a3,8(s0)
   14d0c:	00f42623          	sw	a5,12(s0)
   14d10:	00040513          	mv	a0,s0
   14d14:	02c12083          	lw	ra,44(sp)
   14d18:	02812403          	lw	s0,40(sp)
   14d1c:	02412483          	lw	s1,36(sp)
   14d20:	02012903          	lw	s2,32(sp)
   14d24:	03010113          	addi	sp,sp,48
   14d28:	00008067          	ret
   14d2c:	00b76833          	or	a6,a4,a1
   14d30:	08079e63          	bnez	a5,14dcc <__extenddftf2+0x174>
   14d34:	0e080263          	beqz	a6,14e18 <__extenddftf2+0x1c0>
   14d38:	0e070a63          	beqz	a4,14e2c <__extenddftf2+0x1d4>
   14d3c:	00070513          	mv	a0,a4
   14d40:	474000ef          	jal	ra,151b4 <__clzsi2>
   14d44:	03150713          	addi	a4,a0,49
   14d48:	01f77813          	andi	a6,a4,31
   14d4c:	40575713          	srai	a4,a4,0x5
   14d50:	10081a63          	bnez	a6,14e64 <__extenddftf2+0x20c>
   14d54:	01010613          	addi	a2,sp,16
   14d58:	00271693          	slli	a3,a4,0x2
   14d5c:	40d606b3          	sub	a3,a2,a3
   14d60:	00010893          	mv	a7,sp
   14d64:	00271813          	slli	a6,a4,0x2
   14d68:	00c6a583          	lw	a1,12(a3)
   14d6c:	010687b3          	add	a5,a3,a6
   14d70:	ffc68693          	addi	a3,a3,-4
   14d74:	00b7a623          	sw	a1,12(a5)
   14d78:	fed898e3          	bne	a7,a3,14d68 <__extenddftf2+0x110>
   14d7c:	fff70713          	addi	a4,a4,-1
   14d80:	00271713          	slli	a4,a4,0x2
   14d84:	00e60733          	add	a4,a2,a4
   14d88:	00072023          	sw	zero,0(a4)
   14d8c:	ffc70693          	addi	a3,a4,-4
   14d90:	00e60a63          	beq	a2,a4,14da4 <__extenddftf2+0x14c>
   14d94:	00068713          	mv	a4,a3
   14d98:	00072023          	sw	zero,0(a4)
   14d9c:	ffc70693          	addi	a3,a4,-4
   14da0:	fee61ae3          	bne	a2,a4,14d94 <__extenddftf2+0x13c>
   14da4:	000047b7          	lui	a5,0x4
   14da8:	c0c78793          	addi	a5,a5,-1012 # 3c0c <_vfprintf_r+0x2708>
   14dac:	40a787b3          	sub	a5,a5,a0
   14db0:	01179793          	slli	a5,a5,0x11
   14db4:	01012803          	lw	a6,16(sp)
   14db8:	01412583          	lw	a1,20(sp)
   14dbc:	01812683          	lw	a3,24(sp)
   14dc0:	01c15703          	lhu	a4,28(sp)
   14dc4:	0117d793          	srli	a5,a5,0x11
   14dc8:	f05ff06f          	j	14ccc <__extenddftf2+0x74>
   14dcc:	02080a63          	beqz	a6,14e00 <__extenddftf2+0x1a8>
   14dd0:	000087b7          	lui	a5,0x8
   14dd4:	00475513          	srli	a0,a4,0x4
   14dd8:	01c71693          	slli	a3,a4,0x1c
   14ddc:	00f56733          	or	a4,a0,a5
   14de0:	0045d613          	srli	a2,a1,0x4
   14de4:	01071713          	slli	a4,a4,0x10
   14de8:	00c6e6b3          	or	a3,a3,a2
   14dec:	01c59593          	slli	a1,a1,0x1c
   14df0:	01075713          	srli	a4,a4,0x10
   14df4:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   14df8:	00000813          	li	a6,0
   14dfc:	ed1ff06f          	j	14ccc <__extenddftf2+0x74>
   14e00:	000087b7          	lui	a5,0x8
   14e04:	00000693          	li	a3,0
   14e08:	00000593          	li	a1,0
   14e0c:	fff78793          	addi	a5,a5,-1 # 7fff <localeconv+0x7>
   14e10:	00000713          	li	a4,0
   14e14:	eb9ff06f          	j	14ccc <__extenddftf2+0x74>
   14e18:	00000693          	li	a3,0
   14e1c:	00000593          	li	a1,0
   14e20:	00000793          	li	a5,0
   14e24:	00000713          	li	a4,0
   14e28:	ea5ff06f          	j	14ccc <__extenddftf2+0x74>
   14e2c:	00058513          	mv	a0,a1
   14e30:	00058913          	mv	s2,a1
   14e34:	380000ef          	jal	ra,151b4 <__clzsi2>
   14e38:	05150713          	addi	a4,a0,81
   14e3c:	01f77813          	andi	a6,a4,31
   14e40:	02050513          	addi	a0,a0,32
   14e44:	40575713          	srai	a4,a4,0x5
   14e48:	f00806e3          	beqz	a6,14d54 <__extenddftf2+0xfc>
   14e4c:	00200793          	li	a5,2
   14e50:	00f70a63          	beq	a4,a5,14e64 <__extenddftf2+0x20c>
   14e54:	00200713          	li	a4,2
   14e58:	01010613          	addi	a2,sp,16
   14e5c:	00c00893          	li	a7,12
   14e60:	0500006f          	j	14eb0 <__extenddftf2+0x258>
   14e64:	40e006b3          	neg	a3,a4
   14e68:	00269693          	slli	a3,a3,0x2
   14e6c:	01010613          	addi	a2,sp,16
   14e70:	00c68693          	addi	a3,a3,12
   14e74:	02000e13          	li	t3,32
   14e78:	00d606b3          	add	a3,a2,a3
   14e7c:	00271893          	slli	a7,a4,0x2
   14e80:	410e0e33          	sub	t3,t3,a6
   14e84:	ffc6a583          	lw	a1,-4(a3)
   14e88:	0006a783          	lw	a5,0(a3)
   14e8c:	01168333          	add	t1,a3,a7
   14e90:	01c5d5b3          	srl	a1,a1,t3
   14e94:	010797b3          	sll	a5,a5,a6
   14e98:	00f5e5b3          	or	a1,a1,a5
   14e9c:	00b32023          	sw	a1,0(t1)
   14ea0:	ffc68693          	addi	a3,a3,-4
   14ea4:	fed610e3          	bne	a2,a3,14e84 <__extenddftf2+0x22c>
   14ea8:	01012903          	lw	s2,16(sp)
   14eac:	fff70713          	addi	a4,a4,-1
   14eb0:	02010793          	addi	a5,sp,32
   14eb4:	011788b3          	add	a7,a5,a7
   14eb8:	01091933          	sll	s2,s2,a6
   14ebc:	ff28a823          	sw	s2,-16(a7)
   14ec0:	ec1ff06f          	j	14d80 <__extenddftf2+0x128>

00014ec4 <__trunctfdf2>:
   14ec4:	00c52803          	lw	a6,12(a0)
   14ec8:	00052703          	lw	a4,0(a0)
   14ecc:	00452683          	lw	a3,4(a0)
   14ed0:	00852583          	lw	a1,8(a0)
   14ed4:	00008537          	lui	a0,0x8
   14ed8:	fff50793          	addi	a5,a0,-1 # 7fff <localeconv+0x7>
   14edc:	01085613          	srli	a2,a6,0x10
   14ee0:	00359e13          	slli	t3,a1,0x3
   14ee4:	00f67633          	and	a2,a2,a5
   14ee8:	01d75893          	srli	a7,a4,0x1d
   14eec:	01d6d793          	srli	a5,a3,0x1d
   14ef0:	01081313          	slli	t1,a6,0x10
   14ef4:	00369693          	slli	a3,a3,0x3
   14ef8:	ff010113          	addi	sp,sp,-16
   14efc:	01c7e7b3          	or	a5,a5,t3
   14f00:	0116e6b3          	or	a3,a3,a7
   14f04:	01035313          	srli	t1,t1,0x10
   14f08:	00371e13          	slli	t3,a4,0x3
   14f0c:	00160893          	addi	a7,a2,1
   14f10:	ffe50513          	addi	a0,a0,-2
   14f14:	01d5d593          	srli	a1,a1,0x1d
   14f18:	00331313          	slli	t1,t1,0x3
   14f1c:	00f12423          	sw	a5,8(sp)
   14f20:	00d12223          	sw	a3,4(sp)
   14f24:	01c12023          	sw	t3,0(sp)
   14f28:	00a8f533          	and	a0,a7,a0
   14f2c:	01f85813          	srli	a6,a6,0x1f
   14f30:	0065e5b3          	or	a1,a1,t1
   14f34:	04050663          	beqz	a0,14f80 <__trunctfdf2+0xbc>
   14f38:	ffffc737          	lui	a4,0xffffc
   14f3c:	40070713          	addi	a4,a4,1024 # ffffc400 <__freertos_irq_stack_top+0xfffe46e0>
   14f40:	00e60633          	add	a2,a2,a4
   14f44:	7fe00713          	li	a4,2046
   14f48:	08c75463          	bge	a4,a2,14fd0 <__trunctfdf2+0x10c>
   14f4c:	7ff00613          	li	a2,2047
   14f50:	00000713          	li	a4,0
   14f54:	00000793          	li	a5,0
   14f58:	00c71713          	slli	a4,a4,0xc
   14f5c:	01461613          	slli	a2,a2,0x14
   14f60:	00c75713          	srli	a4,a4,0xc
   14f64:	01f81813          	slli	a6,a6,0x1f
   14f68:	00c76733          	or	a4,a4,a2
   14f6c:	01076733          	or	a4,a4,a6
   14f70:	00078513          	mv	a0,a5
   14f74:	00070593          	mv	a1,a4
   14f78:	01010113          	addi	sp,sp,16
   14f7c:	00008067          	ret
   14f80:	00f6e7b3          	or	a5,a3,a5
   14f84:	00b7e7b3          	or	a5,a5,a1
   14f88:	01c7e7b3          	or	a5,a5,t3
   14f8c:	02061663          	bnez	a2,14fb8 <__trunctfdf2+0xf4>
   14f90:	10078a63          	beqz	a5,150a4 <__trunctfdf2+0x1e0>
   14f94:	00000793          	li	a5,0
   14f98:	00500693          	li	a3,5
   14f9c:	0036d593          	srli	a1,a3,0x3
   14fa0:	00979713          	slli	a4,a5,0x9
   14fa4:	01d79693          	slli	a3,a5,0x1d
   14fa8:	00b6e7b3          	or	a5,a3,a1
   14fac:	00c75713          	srli	a4,a4,0xc
   14fb0:	7ff67613          	andi	a2,a2,2047
   14fb4:	fa5ff06f          	j	14f58 <__trunctfdf2+0x94>
   14fb8:	f8078ae3          	beqz	a5,14f4c <__trunctfdf2+0x88>
   14fbc:	00000813          	li	a6,0
   14fc0:	7ff00613          	li	a2,2047
   14fc4:	00080737          	lui	a4,0x80
   14fc8:	00000793          	li	a5,0
   14fcc:	f8dff06f          	j	14f58 <__trunctfdf2+0x94>
   14fd0:	0ec04063          	bgtz	a2,150b0 <__trunctfdf2+0x1ec>
   14fd4:	fcc00793          	li	a5,-52
   14fd8:	14f64a63          	blt	a2,a5,1512c <__trunctfdf2+0x268>
   14fdc:	03d00793          	li	a5,61
   14fe0:	40c78633          	sub	a2,a5,a2
   14fe4:	40565793          	srai	a5,a2,0x5
   14fe8:	00080737          	lui	a4,0x80
   14fec:	00e5e5b3          	or	a1,a1,a4
   14ff0:	00279513          	slli	a0,a5,0x2
   14ff4:	00010713          	mv	a4,sp
   14ff8:	00000693          	li	a3,0
   14ffc:	00b12623          	sw	a1,12(sp)
   15000:	00a108b3          	add	a7,sp,a0
   15004:	00470713          	addi	a4,a4,4 # 80004 <__freertos_irq_stack_top+0x682e4>
   15008:	01f67613          	andi	a2,a2,31
   1500c:	01c6e6b3          	or	a3,a3,t3
   15010:	01170a63          	beq	a4,a7,15024 <__trunctfdf2+0x160>
   15014:	00072e03          	lw	t3,0(a4)
   15018:	00470713          	addi	a4,a4,4
   1501c:	01c6e6b3          	or	a3,a3,t3
   15020:	ff171ae3          	bne	a4,a7,15014 <__trunctfdf2+0x150>
   15024:	00300713          	li	a4,3
   15028:	40f70733          	sub	a4,a4,a5
   1502c:	12060463          	beqz	a2,15154 <__trunctfdf2+0x290>
   15030:	01010893          	addi	a7,sp,16
   15034:	00a888b3          	add	a7,a7,a0
   15038:	ff08a883          	lw	a7,-16(a7)
   1503c:	02000e13          	li	t3,32
   15040:	40ce0e33          	sub	t3,t3,a2
   15044:	01c898b3          	sll	a7,a7,t3
   15048:	0116e6b3          	or	a3,a3,a7
   1504c:	14070e63          	beqz	a4,151a8 <__trunctfdf2+0x2e4>
   15050:	00271713          	slli	a4,a4,0x2
   15054:	00a10533          	add	a0,sp,a0
   15058:	00e10eb3          	add	t4,sp,a4
   1505c:	00010893          	mv	a7,sp
   15060:	00052583          	lw	a1,0(a0)
   15064:	00452303          	lw	t1,4(a0)
   15068:	00488893          	addi	a7,a7,4
   1506c:	00c5d5b3          	srl	a1,a1,a2
   15070:	01c31333          	sll	t1,t1,t3
   15074:	0065e5b3          	or	a1,a1,t1
   15078:	feb8ae23          	sw	a1,-4(a7)
   1507c:	00450513          	addi	a0,a0,4
   15080:	ff1e90e3          	bne	t4,a7,15060 <__trunctfdf2+0x19c>
   15084:	00400593          	li	a1,4
   15088:	40f587b3          	sub	a5,a1,a5
   1508c:	00c12583          	lw	a1,12(sp)
   15090:	01010513          	addi	a0,sp,16
   15094:	00e50733          	add	a4,a0,a4
   15098:	00c5d5b3          	srl	a1,a1,a2
   1509c:	feb72823          	sw	a1,-16(a4)
   150a0:	0d80006f          	j	15178 <__trunctfdf2+0x2b4>
   150a4:	00000613          	li	a2,0
   150a8:	00000713          	li	a4,0
   150ac:	eadff06f          	j	14f58 <__trunctfdf2+0x94>
   150b0:	00469713          	slli	a4,a3,0x4
   150b4:	00479513          	slli	a0,a5,0x4
   150b8:	01c76733          	or	a4,a4,t3
   150bc:	01c6d693          	srli	a3,a3,0x1c
   150c0:	01c7d793          	srli	a5,a5,0x1c
   150c4:	00459593          	slli	a1,a1,0x4
   150c8:	00e03733          	snez	a4,a4
   150cc:	00a6e6b3          	or	a3,a3,a0
   150d0:	00b7e7b3          	or	a5,a5,a1
   150d4:	00d766b3          	or	a3,a4,a3
   150d8:	0076f713          	andi	a4,a3,7
   150dc:	00070863          	beqz	a4,150ec <__trunctfdf2+0x228>
   150e0:	00f6f713          	andi	a4,a3,15
   150e4:	00400593          	li	a1,4
   150e8:	04b71863          	bne	a4,a1,15138 <__trunctfdf2+0x274>
   150ec:	00800737          	lui	a4,0x800
   150f0:	00e7f733          	and	a4,a5,a4
   150f4:	ea0704e3          	beqz	a4,14f9c <__trunctfdf2+0xd8>
   150f8:	00160613          	addi	a2,a2,1
   150fc:	7ff00713          	li	a4,2047
   15100:	e4e606e3          	beq	a2,a4,14f4c <__trunctfdf2+0x88>
   15104:	ff800737          	lui	a4,0xff800
   15108:	fff70713          	addi	a4,a4,-1 # ff7fffff <__freertos_irq_stack_top+0xff7e82df>
   1510c:	00e7f733          	and	a4,a5,a4
   15110:	01d71793          	slli	a5,a4,0x1d
   15114:	0036d693          	srli	a3,a3,0x3
   15118:	00971713          	slli	a4,a4,0x9
   1511c:	7ff67613          	andi	a2,a2,2047
   15120:	00d7e7b3          	or	a5,a5,a3
   15124:	00c75713          	srli	a4,a4,0xc
   15128:	e31ff06f          	j	14f58 <__trunctfdf2+0x94>
   1512c:	00100693          	li	a3,1
   15130:	00000793          	li	a5,0
   15134:	00000613          	li	a2,0
   15138:	ffc6b713          	sltiu	a4,a3,-4
   1513c:	00174713          	xori	a4,a4,1
   15140:	00e787b3          	add	a5,a5,a4
   15144:	00800737          	lui	a4,0x800
   15148:	00468693          	addi	a3,a3,4
   1514c:	00e7f733          	and	a4,a5,a4
   15150:	fa5ff06f          	j	150f4 <__trunctfdf2+0x230>
   15154:	00010593          	mv	a1,sp
   15158:	00a588b3          	add	a7,a1,a0
   1515c:	0008a883          	lw	a7,0(a7)
   15160:	00458593          	addi	a1,a1,4
   15164:	00160613          	addi	a2,a2,1
   15168:	ff15ae23          	sw	a7,-4(a1)
   1516c:	fec756e3          	bge	a4,a2,15158 <__trunctfdf2+0x294>
   15170:	00400713          	li	a4,4
   15174:	40f707b3          	sub	a5,a4,a5
   15178:	00279793          	slli	a5,a5,0x2
   1517c:	00f107b3          	add	a5,sp,a5
   15180:	01010713          	addi	a4,sp,16
   15184:	0007a023          	sw	zero,0(a5)
   15188:	00478793          	addi	a5,a5,4
   1518c:	fee79ce3          	bne	a5,a4,15184 <__trunctfdf2+0x2c0>
   15190:	00012703          	lw	a4,0(sp)
   15194:	00d036b3          	snez	a3,a3
   15198:	00412783          	lw	a5,4(sp)
   1519c:	00e6e6b3          	or	a3,a3,a4
   151a0:	00000613          	li	a2,0
   151a4:	f35ff06f          	j	150d8 <__trunctfdf2+0x214>
   151a8:	00100793          	li	a5,1
   151ac:	00000713          	li	a4,0
   151b0:	ee1ff06f          	j	15090 <__trunctfdf2+0x1cc>

000151b4 <__clzsi2>:
   151b4:	000107b7          	lui	a5,0x10
   151b8:	04f57463          	bgeu	a0,a5,15200 <__clzsi2+0x4c>
   151bc:	0ff00793          	li	a5,255
   151c0:	02000713          	li	a4,32
   151c4:	00a7ee63          	bltu	a5,a0,151e0 <__clzsi2+0x2c>
   151c8:	00001797          	auipc	a5,0x1
   151cc:	05878793          	addi	a5,a5,88 # 16220 <__clz_tab>
   151d0:	00a787b3          	add	a5,a5,a0
   151d4:	0007c503          	lbu	a0,0(a5)
   151d8:	40a70533          	sub	a0,a4,a0
   151dc:	00008067          	ret
   151e0:	00855513          	srli	a0,a0,0x8
   151e4:	00001797          	auipc	a5,0x1
   151e8:	03c78793          	addi	a5,a5,60 # 16220 <__clz_tab>
   151ec:	00a787b3          	add	a5,a5,a0
   151f0:	0007c503          	lbu	a0,0(a5)
   151f4:	01800713          	li	a4,24
   151f8:	40a70533          	sub	a0,a4,a0
   151fc:	00008067          	ret
   15200:	010007b7          	lui	a5,0x1000
   15204:	02f56263          	bltu	a0,a5,15228 <__clzsi2+0x74>
   15208:	01855513          	srli	a0,a0,0x18
   1520c:	00001797          	auipc	a5,0x1
   15210:	01478793          	addi	a5,a5,20 # 16220 <__clz_tab>
   15214:	00a787b3          	add	a5,a5,a0
   15218:	0007c503          	lbu	a0,0(a5)
   1521c:	00800713          	li	a4,8
   15220:	40a70533          	sub	a0,a4,a0
   15224:	00008067          	ret
   15228:	01055513          	srli	a0,a0,0x10
   1522c:	00001797          	auipc	a5,0x1
   15230:	ff478793          	addi	a5,a5,-12 # 16220 <__clz_tab>
   15234:	00a787b3          	add	a5,a5,a0
   15238:	0007c503          	lbu	a0,0(a5)
   1523c:	01000713          	li	a4,16
   15240:	40a70533          	sub	a0,a4,a0
   15244:	00008067          	ret

00015248 <_close>:
   15248:	05800793          	li	a5,88
   1524c:	86f1a423          	sw	a5,-1944(gp) # 16d18 <errno>
   15250:	fff00513          	li	a0,-1
   15254:	00008067          	ret

00015258 <_fstat>:
   15258:	05800793          	li	a5,88
   1525c:	86f1a423          	sw	a5,-1944(gp) # 16d18 <errno>
   15260:	fff00513          	li	a0,-1
   15264:	00008067          	ret

00015268 <_isatty>:
   15268:	05800793          	li	a5,88
   1526c:	86f1a423          	sw	a5,-1944(gp) # 16d18 <errno>
   15270:	00000513          	li	a0,0
   15274:	00008067          	ret

00015278 <_lseek>:
   15278:	05800793          	li	a5,88
   1527c:	86f1a423          	sw	a5,-1944(gp) # 16d18 <errno>
   15280:	fff00513          	li	a0,-1
   15284:	00008067          	ret

00015288 <_read>:
   15288:	05800793          	li	a5,88
   1528c:	86f1a423          	sw	a5,-1944(gp) # 16d18 <errno>
   15290:	fff00513          	li	a0,-1
   15294:	00008067          	ret

00015298 <_sbrk>:
   15298:	83c18793          	addi	a5,gp,-1988 # 16cec <heap_end.1518>
   1529c:	0007a783          	lw	a5,0(a5)
   152a0:	00078a63          	beqz	a5,152b4 <_sbrk+0x1c>
   152a4:	00a78533          	add	a0,a5,a0
   152a8:	82a1ae23          	sw	a0,-1988(gp) # 16cec <heap_end.1518>
   152ac:	00078513          	mv	a0,a5
   152b0:	00008067          	ret
   152b4:	87018793          	addi	a5,gp,-1936 # 16d20 <_end>
   152b8:	00a78533          	add	a0,a5,a0
   152bc:	82a1ae23          	sw	a0,-1988(gp) # 16cec <heap_end.1518>
   152c0:	00078513          	mv	a0,a5
   152c4:	00008067          	ret

000152c8 <_write>:
   152c8:	05800793          	li	a5,88
   152cc:	86f1a423          	sw	a5,-1944(gp) # 16d18 <errno>
   152d0:	fff00513          	li	a0,-1
   152d4:	00008067          	ret
