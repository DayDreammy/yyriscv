
uart_test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
  int * p1;
  int * p2;
  int * p3;

  p1 = 0x00002004;
  *p1 = 4;
   10054:	000027b7          	lui	a5,0x2

  p2 = 0x00002008;
  *p2 = 1;
  p2 = 0x0000200c;
  *p2 = 2;
   10058:	00200613          	li	a2,2
  *p1 = 4;
   1005c:	00400693          	li	a3,4
  *p2 = 1;
   10060:	00100713          	li	a4,1
  *p2 = 2;
   10064:	00c7a623          	sw	a2,12(a5) # 200c <main-0xe048>
  p2 = 0x00002010;
  *p2 = 3;
   10068:	00300613          	li	a2,3
  *p1 = 4;
   1006c:	00d7a223          	sw	a3,4(a5)
  *p2 = 1;
   10070:	00e7a423          	sw	a4,8(a5)
  *p2 = 3;
   10074:	00c7a823          	sw	a2,16(a5)
  p2 = 0x00002014;
  *p2 = 4;
   10078:	00d7aa23          	sw	a3,20(a5)

  p3 = 0x00002000;
  *p3 = 1;
   1007c:	00e7a023          	sw	a4,0(a5)
  
  return 0;
}
   10080:	00000513          	li	a0,0
   10084:	00008067          	ret
