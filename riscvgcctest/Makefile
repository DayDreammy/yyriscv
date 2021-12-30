
case = hello

inte = 1

CASE_NAME = $(case)

LOG_FILE = ${CASE_NAME}_run.log

# ---------------------------------------------------------------------------------------
# gcc
RISCV_GCC = ./riscv32-none-embed-gcc.exe
RISCV_OBJDUMP = ./riscv32-none-embed-objdump.exe
RISCV_OBJCOPY = ./riscv32-none-embed-objcopy.exe

# ---------------------------------------------------------------------------------------
# interactive mode
ifdef inte
  INTER = --interactive
else
  INTER = 
endif

# ---------------------------------------------------------------------------------------
# run
all: comp

comp:
	$(RISCV_GCC) -mabi=ilp32e \
	             -march=rv32emc \
		     -o2 \
		     -nostdlib \
		     -g -o $(CASE_NAME).elf \
		     $(CASE_NAME).c
		
	$(RISCV_OBJDUMP) -S $(CASE_NAME).elf > $(CASE_NAME).asm
	
	$(RISCV_OBJCOPY) -j .text -j .rodata \
	-S $(CASE_NAME).elf \
	-O binary $(CASE_NAME)_icode.bin
	
	$(RISCV_OBJCOPY) -j .bss -j .data \
	-S $(CASE_NAME).elf \
	-O binary $(CASE_NAME)_dcode.bin
	
	hexdump -v -e '1/4 "%08x\n"' \
	$(CASE_NAME)_icode.bin > $(CASE_NAME)_icode.hex
	
	hexdump -v -e '1/4 "%08x\n"' \
	$(CASE_NAME)_dcode.bin > $(CASE_NAME)_dcode.hex

.PHONY:whisper
whisper:
	/eda/riscv/ISS/whisper   --newlib \
				 --isa imc \
				 --tohost 0xffffffbc \
				 --setreg x2=0 x3=0 \
				 --logfile $(LOG_FILE) \
				 $(INTER) \
				 $(CASE_NAME).elf
	
	/eda/script/whisper_log.sh $(LOG_FILE)
		  	
.PHONY:clean
clean:
	rm -rf *.asm *.bin *.elf *.hex *.log *.dat
