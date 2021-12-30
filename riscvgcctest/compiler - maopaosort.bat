riscv-none-embed-gcc.exe -mabi=ilp32e -march=rv32e -o2 -nostdlib -g -o maopao_sort.elf maopao_sort.c
riscv-none-embed-objdump.exe -S maopao_sort.elf > maopao_sort.asm
riscv-none-embed-objcopy.exe -j .text -j .rodata -S maopao_sort.elf -O binary maopao_sort.bin