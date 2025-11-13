#=================================================
# Parameters for OpenSBI
#=================================================

OPENSBI_SRC := $(NANHU_G_SW_LOC)/opensbi
OPENSBI_LOC := $(abspath $(NANHU_G_SW_LOC)/riscv-opensbi)

RV_BOOT_BIN_LOC := $(OPENSBI_LOC)/platform/ict/firmware
OPENSBI_PAYLOAD := $(abspath $(INSTALL_LOC)/Image)
DT_TARGET ?= XSTop
OPENSBI_DTB := $(abspath $(INSTALL_LOC)/$(DT_TARGET).dtb)

# sub platform-specific OpenSBI compilation flags 
USER_FLAGS := SERVE_PLAT=h \
              HART_COUNT=$(NUM_CORES) \
              RV_TARGET=xiangshan \
              WITH_SM=n

# OpenSBI cross compile flags
OPENSBI_COMPILE_FLAGS := O=$(OPENSBI_LOC) \
	CROSS_COMPILE=$(LINUX_GCC_PREFIX) \
	PLATFORM=ict \
	OPENSBI_PAYLOAD=$(OPENSBI_PAYLOAD) \
	FW_FDT_PATH=$(OPENSBI_DTB) \
	$(USER_FLAGS)

RV_OPENSBI := $(RV_BOOT_BIN_LOC)/fw_payload.bin
RV_BOOT_BIN := $(INSTALL_LOC)/RV_BOOT.bin

#=================================================
# OpenSBI Compilation
#=================================================
opensbi:
	@mkdir -p $(OPENSBI_LOC)
	$(MAKE) -C $(OPENSBI_SRC) \
		$(OPENSBI_COMPILE_FLAGS)
	@cp $(RV_OPENSBI) $(RV_BOOT_BIN)

opensbi_clean:
	$(MAKE) -C $(OPENSBI_SRC) \
		$(OPENSBI_COMPILE_FLAGS) clean

opensbi_distclean:
	@rm -rf $(OPENSBI_LOC)
