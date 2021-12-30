riscv-none-embed-gcc.exe -mabi=ilp32e -march=rv32e -o2 -nostdlib -g -o bra_test.elf bra_test.c
riscv-none-embed-objdump.exe -S bra_test.elf > bra_test.asm
riscv-none-embed-objcopy.exe -j .text -j .rodata -S bra_test.elf -O binary bra_test_icode.bin