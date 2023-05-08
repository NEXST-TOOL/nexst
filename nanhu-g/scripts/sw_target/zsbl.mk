ZSBL_SRC := $(NANHU_G_SW_LOC)/zsbl
ZSBL_LOC := $(abspath $(NANHU_G_SW_LOC)/riscv-zsbl)
 
ZSBL_COMPILE_FLAGS := O=$(ZSBL_LOC) CROSS_COMPILE=$(LINUX_GCC_PREFIX)

BOOTROM_BIN := $(INSTALL_LOC)/bootrom.bin

zsbl:
	@mkdir -p $(ZSBL_LOC) $(INSTALL_LOC)
	$(EXPORT_CC_PATH) && \
		$(MAKE) -C $(ZSBL_SRC) $(ZSBL_COMPILE_FLAGS)
	@cp $(ZSBL_LOC)/bootrom.bin $(BOOTROM_BIN)

zsbl_clean:
	$(EXPORT_CC_PATH) && \
		$(MAKE) -C $(ZSBL_SRC) $(ZSBL_COMPILE_FLAGS) clean

zsbl_distclean:
	@rm -rf $(ZSBL_LOC)
