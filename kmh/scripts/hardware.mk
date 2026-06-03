NANHU_G_LOC := target/kmh/hardware
XS_SRC := $(NANHU_G_LOC)/xs-gen
GEN_DIR := $(NANHU_G_LOC)/sources/generated
PATCH_DIR := $(NANHU_G_LOC)/sources/patch

CONFIG ?= FpgaMinimalMatrixConfig
L2_CACHE_SIZE ?= 256
L3_CACHE_SIZE ?= 768
NUM_CORES ?= 1

.PHONY: xs_gen
xs_gen:
	cd $(XS_SRC)
	patch -p1 < $(PATCH_DIR)/config.patch
	make -C $(XS_SRC) \
		NOOP_HOME=$(XS_SRC) \
		CONFIG=$(CONFIG) \
		L2_CACHE_SIZE=$(L2_CACHE_SIZE) \
		L3_CACHE_SIZE=$(L3_CACHE_SIZE) \
		NUM_CORES=$(NUM_CORES) verilog
	mkdir -p $(GEN_DIR)
	cp $(XS_SRC)/build/rtl/*.v $(GEN_DIR)
	cp $(XS_SRC)/build/rtl/*.sv $(GEN_DIR)
	cp $(PATCH_DIR)/*.sv $(GEN_DIR)
	mv $(GEN_DIR)/XSTop.sv $(GEN_DIR)/XSTop.v
	$(PATCH_DIR)/XSTop_patch.py $(XS_SRC)/build/rtl/SoCMisc.sv > $(GEN_DIR)/SoCMisc.sv

.PHONY: xs_clean
xs_clean:
	rm -rf $(GEN_DIR)
	rm -rf $(XS_SRC)/build
