NANHU_G_LOC := target/nanhu-g/hardware
XS_SRC := $(NANHU_G_LOC)/xs-gen
GEN_DIR := $(NANHU_G_LOC)/sources/generated
PATCH_DIR := $(NANHU_G_LOC)/sources/patch

CONFIG ?= NanHuGServeConfig
NUM_CORES ?= 1

.PHONY: xs_gen
xs_gen:
	make -C $(XS_SRC) CONFIG=$(CONFIG) NUM_CORES=$(NUM_CORES) verilog
	mkdir -p $(GEN_DIR)
	cp $(XS_SRC)/build/*.v $(GEN_DIR)
	cp $(PATCH_DIR)/*.v $(GEN_DIR)
	$(PATCH_DIR)/XSTop_patch.py $(XS_SRC)/build/XSTop.v > $(GEN_DIR)/XSTop.v

.PHONY: xs_clean
xs_clean:
	rm -rf $(GEN_DIR)
	rm -rf $(XS_SRC)/build
