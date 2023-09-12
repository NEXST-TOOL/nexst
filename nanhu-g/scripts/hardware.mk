NANHU_G_LOC := target/nanhu-g/hardware
XS_SRC := $(NANHU_G_LOC)/xs-gen
GEN_SRC := $(NANHU_G_LOC)/sources/generated

CONFIG ?= NohypeFPGAConfig
NUM_CORES ?= 2

.PHONY: xs_gen
xs_gen:
	make -C $(XS_SRC) CONFIG=$(CONFIG) verilog
	mkdir -p $(GEN_SRC)
	cp $(XS_SRC)/build/*.v $(GEN_SRC)

.PHONY: xs_clean
xs_clean:
	rm -rf $(GEN_SRC)
	rm -rf $(XS_SRC)/build
