NM37_HW_LOC := target/nm37-xiangshan/hardware
XS_SRC := $(NM37_HW_LOC)/xs-gen
GEN_SRC := $(NM37_HW_LOC)/sources/generated

CONFIG ?= NanHuGFPGAConfig

.PHONY: xs_gen
xs_gen:
	make -C $(XS_SRC) CONFIG=$(CONFIG) verilog
	mkdir -p $(GEN_SRC)
	cp $(XS_SRC)/build/*.v $(GEN_SRC)

.PHONY: xs_clean
xs_clean:
	rm -rf $(GEN_SRC)
	rm -rf $(XS_SRC)/build
