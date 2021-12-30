
led_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
int main() {
   10054:	ff410113          	addi	sp,sp,-12
   10058:	00812423          	sw	s0,8(sp)
   1005c:	00c10413          	addi	s0,sp,12
  int a = 1;
   10060:	00100793          	li	a5,1
   10064:	fef42c23          	sw	a5,-8(s0)
  int * p;

  p = 0x00001000;
   10068:	000017b7          	lui	a5,0x1
   1006c:	fef42a23          	sw	a5,-12(s0)

  *p = a;
   10070:	ff442783          	lw	a5,-12(s0)
   10074:	ff842703          	lw	a4,-8(s0)
   10078:	00e7a023          	sw	a4,0(a5) # 1000 <main-0xf054>

  return 0;
   1007c:	00000793          	li	a5,0
}
   10080:	00078513          	mv	a0,a5
   10084:	00812403          	lw	s0,8(sp)
   10088:	00c10113          	addi	sp,sp,12
   1008c:	00008067          	ret
