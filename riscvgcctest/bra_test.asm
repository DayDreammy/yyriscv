
bra_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
int main() {
   10054:	ff010113          	addi	sp,sp,-16
   10058:	00812623          	sw	s0,12(sp)
   1005c:	01010413          	addi	s0,sp,16
  int a = 1;
   10060:	00100793          	li	a5,1
   10064:	fef42c23          	sw	a5,-8(s0)
  int b = 2;
   10068:	00200793          	li	a5,2
   1006c:	fef42a23          	sw	a5,-12(s0)
  int c = 0;
   10070:	fe042823          	sw	zero,-16(s0)

  if (a < b){
   10074:	ff842703          	lw	a4,-8(s0)
   10078:	ff442783          	lw	a5,-12(s0)
   1007c:	00f75663          	bge	a4,a5,10088 <main+0x34>
	c=1;
   10080:	00100793          	li	a5,1
   10084:	fef42823          	sw	a5,-16(s0)
  }


  return 0;
   10088:	00000793          	li	a5,0
}
   1008c:	00078513          	mv	a0,a5
   10090:	00c12403          	lw	s0,12(sp)
   10094:	01010113          	addi	sp,sp,16
   10098:	00008067          	ret
