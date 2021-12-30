
test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
int main() {
   10054:	fd410113          	addi	sp,sp,-44
   10058:	02812423          	sw	s0,40(sp)
   1005c:	02c10413          	addi	s0,sp,44
  volatile int * p1;
  volatile int * p2;
  volatile int * p3;

  int a = 1;
   10060:	00100793          	li	a5,1
   10064:	fef42c23          	sw	a5,-8(s0)
  int b = 2;
   10068:	00200793          	li	a5,2
   1006c:	fef42a23          	sw	a5,-12(s0)
  int c = 3;
   10070:	00300793          	li	a5,3
   10074:	fef42823          	sw	a5,-16(s0)
  int d = 4;
   10078:	00400793          	li	a5,4
   1007c:	fef42623          	sw	a5,-20(s0)

  int add_res;
  int sub_res;
  int sll_res;

  add_res = a + b;
   10080:	ff842703          	lw	a4,-8(s0)
   10084:	ff442783          	lw	a5,-12(s0)
   10088:	00f707b3          	add	a5,a4,a5
   1008c:	fef42423          	sw	a5,-24(s0)
  sub_res = d - c;
   10090:	fec42703          	lw	a4,-20(s0)
   10094:	ff042783          	lw	a5,-16(s0)
   10098:	40f707b3          	sub	a5,a4,a5
   1009c:	fef42223          	sw	a5,-28(s0)
  sll_res = a << b;
   100a0:	ff442783          	lw	a5,-12(s0)
   100a4:	ff842703          	lw	a4,-8(s0)
   100a8:	00f717b3          	sll	a5,a4,a5
   100ac:	fef42023          	sw	a5,-32(s0)

  p1 = 0x0000;
   100b0:	fc042e23          	sw	zero,-36(s0)
  p2 = 0x0400;
   100b4:	40000793          	li	a5,1024
   100b8:	fcf42c23          	sw	a5,-40(s0)
  p3 = 0x0800;
   100bc:	000017b7          	lui	a5,0x1
   100c0:	80078793          	addi	a5,a5,-2048 # 800 <main-0xf854>
   100c4:	fcf42a23          	sw	a5,-44(s0)

  *p1 = add_res;
   100c8:	fdc42783          	lw	a5,-36(s0)
   100cc:	fe842703          	lw	a4,-24(s0)
   100d0:	00e7a023          	sw	a4,0(a5)
  *p2 = sub_res;
   100d4:	fd842783          	lw	a5,-40(s0)
   100d8:	fe442703          	lw	a4,-28(s0)
   100dc:	00e7a023          	sw	a4,0(a5)
  *p3 = sll_res;
   100e0:	fd442783          	lw	a5,-44(s0)
   100e4:	fe042703          	lw	a4,-32(s0)
   100e8:	00e7a023          	sw	a4,0(a5)

  return 0;
   100ec:	00000793          	li	a5,0
}
   100f0:	00078513          	mv	a0,a5
   100f4:	02812403          	lw	s0,40(sp)
   100f8:	02c10113          	addi	sp,sp,44
   100fc:	00008067          	ret
