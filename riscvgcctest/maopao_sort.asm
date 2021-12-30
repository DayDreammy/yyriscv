
maopao_sort.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <main>:
int main() {
   10054:	fd810113          	addi	sp,sp,-40
   10058:	02812223          	sw	s0,36(sp)
   1005c:	02810413          	addi	s0,sp,40
    int a[5] = {0 };
   10060:	fc042c23          	sw	zero,-40(s0)
   10064:	fc042e23          	sw	zero,-36(s0)
   10068:	fe042023          	sw	zero,-32(s0)
   1006c:	fe042223          	sw	zero,-28(s0)
   10070:	fe042423          	sw	zero,-24(s0)
    int i ,j,temp;
	int c=0;
   10074:	fe042823          	sw	zero,-16(s0)
	a[0]=5;
   10078:	00500793          	li	a5,5
   1007c:	fcf42c23          	sw	a5,-40(s0)
	a[1]=4;
   10080:	00400793          	li	a5,4
   10084:	fcf42e23          	sw	a5,-36(s0)
	a[2]=1;
   10088:	00100793          	li	a5,1
   1008c:	fef42023          	sw	a5,-32(s0)
	a[3]=3;
   10090:	00300793          	li	a5,3
   10094:	fef42223          	sw	a5,-28(s0)
	a[4]=2;
   10098:	00200793          	li	a5,2
   1009c:	fef42423          	sw	a5,-24(s0)
    
    for(i=0;i<5;i++){
   100a0:	fe042c23          	sw	zero,-8(s0)
   100a4:	0c00006f          	j	10164 <main+0x110>
    	for(j=0;j<5-1;j++)
   100a8:	fe042a23          	sw	zero,-12(s0)
   100ac:	0a00006f          	j	1014c <main+0xf8>
    		if(a[j]>a[j+1]){
   100b0:	ff442783          	lw	a5,-12(s0)
   100b4:	00279793          	slli	a5,a5,0x2
   100b8:	ffc40713          	addi	a4,s0,-4
   100bc:	00f707b3          	add	a5,a4,a5
   100c0:	fdc7a703          	lw	a4,-36(a5)
   100c4:	ff442783          	lw	a5,-12(s0)
   100c8:	00178793          	addi	a5,a5,1
   100cc:	00279793          	slli	a5,a5,0x2
   100d0:	ffc40693          	addi	a3,s0,-4
   100d4:	00f687b3          	add	a5,a3,a5
   100d8:	fdc7a783          	lw	a5,-36(a5)
   100dc:	06e7d263          	bge	a5,a4,10140 <main+0xec>
    			temp=a[j];
   100e0:	ff442783          	lw	a5,-12(s0)
   100e4:	00279793          	slli	a5,a5,0x2
   100e8:	ffc40713          	addi	a4,s0,-4
   100ec:	00f707b3          	add	a5,a4,a5
   100f0:	fdc7a783          	lw	a5,-36(a5)
   100f4:	fef42623          	sw	a5,-20(s0)
    			a[j]=a[j+1];
   100f8:	ff442783          	lw	a5,-12(s0)
   100fc:	00178793          	addi	a5,a5,1
   10100:	00279793          	slli	a5,a5,0x2
   10104:	ffc40713          	addi	a4,s0,-4
   10108:	00f707b3          	add	a5,a4,a5
   1010c:	fdc7a703          	lw	a4,-36(a5)
   10110:	ff442783          	lw	a5,-12(s0)
   10114:	00279793          	slli	a5,a5,0x2
   10118:	ffc40693          	addi	a3,s0,-4
   1011c:	00f687b3          	add	a5,a3,a5
   10120:	fce7ae23          	sw	a4,-36(a5)
    			a[j+1]=temp;
   10124:	ff442783          	lw	a5,-12(s0)
   10128:	00178793          	addi	a5,a5,1
   1012c:	00279793          	slli	a5,a5,0x2
   10130:	ffc40713          	addi	a4,s0,-4
   10134:	00f707b3          	add	a5,a4,a5
   10138:	fec42703          	lw	a4,-20(s0)
   1013c:	fce7ae23          	sw	a4,-36(a5)
    	for(j=0;j<5-1;j++)
   10140:	ff442783          	lw	a5,-12(s0)
   10144:	00178793          	addi	a5,a5,1
   10148:	fef42a23          	sw	a5,-12(s0)
   1014c:	ff442703          	lw	a4,-12(s0)
   10150:	00300793          	li	a5,3
   10154:	f4e7dee3          	bge	a5,a4,100b0 <main+0x5c>
    for(i=0;i<5;i++){
   10158:	ff842783          	lw	a5,-8(s0)
   1015c:	00178793          	addi	a5,a5,1
   10160:	fef42c23          	sw	a5,-8(s0)
   10164:	ff842703          	lw	a4,-8(s0)
   10168:	00400793          	li	a5,4
   1016c:	f2e7dee3          	bge	a5,a4,100a8 <main+0x54>
			}
	}

	if(a[4]==5)
   10170:	fe842703          	lw	a4,-24(s0)
   10174:	00500793          	li	a5,5
   10178:	00f71663          	bne	a4,a5,10184 <main+0x130>
		c=1;
   1017c:	00100793          	li	a5,1
   10180:	fef42823          	sw	a5,-16(s0)

  return 0;
   10184:	00000793          	li	a5,0
}
   10188:	00078513          	mv	a0,a5
   1018c:	02412403          	lw	s0,36(sp)
   10190:	02810113          	addi	sp,sp,40
   10194:	00008067          	ret
