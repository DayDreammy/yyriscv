riscv-none-embed-gcc.exe -mabi=ilp32e -march=rv32e -o2 -nostdlib -g -o led_test.elf led_test.c
riscv-none-embed-objdump.exe -S led_test.elf > led_test.asm
riscv-none-embed-objcopy.exe -j .text -j .rodata -S led_test.elf -O binary led_test_icode.bin