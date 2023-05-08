O ?= $(shell pwd)
BOOTROM_ELF = $(O)/bootrom.elf
BOOTROM_BIN = $(O)/bootrom.bin
ASFLAGS =
LDFLAGS = -Ttext=0x10000000

objs-y += start.o

objs-path-y = $(foreach obj,$(objs-y),$(O)/$(obj))

.PHONY: all clean

all: $(BOOTROM_BIN)

clean:
	rm -f $(objs-path-y) $(BOOTROM_ELF) $(BOOTROM_BIN)

$(O)/%.o: %.S
	$(CROSS_COMPILE)as $(ASFLAGS) -o $@ $^

$(BOOTROM_ELF): $(objs-path-y)
	$(CROSS_COMPILE)ld $(LDFLAGS) -o $@ $^

$(BOOTROM_BIN): $(BOOTROM_ELF)
	$(CROSS_COMPILE)objcopy -O binary $< $@
