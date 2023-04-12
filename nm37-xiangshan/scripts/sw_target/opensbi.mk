#=================================================
# Parameters for OpenSBI
#=================================================

OPENSBI_SRC := $(NM37_SW_LOC)/opensbi
OPENSBI_LOC := $(abspath $(NM37_SW_LOC)/riscv-opensbi)

OPENSBI_PAYLOAD := $(OPENSBI_LOC)/../../../work_farm/software/riscv-linux/phy_os/vmlinux
OPENSBI_DTB := $(OPENSBI_LOC)/../dt/XSTop.dtb

# sub platform-specific OpenSBI compilation flags 
USER_FLAGS := SERVE_PLAT=h \
              HART_COUNT=1 \
	      RV_TARGET=xiangshan \
	      WITH_SM=n

# OpenSBI cross compile flags
OPENSBI_COMPILE_FLAGS := O=$(OPENSBI_LOC) \
	CROSS_COMPILE=$(LINUX_GCC_PREFIX) \
	PLATFORM=ict \
	OPENSBI_PAYLOAD=$(OPENSBI_PAYLOAD) \
	FW_FDT_PATH=$(OPENSBI_DTB)\
	$(USER_FLAGS)

RV_BOOT_BIN_LOC := $(OPENSBI_LOC)/platform/$(PLATFORM)/firmware
RV_OPENSBI := $(RV_BOOT_BIN_LOC)/fw_payload.bin
RV_BOOTBIN := $(RV_BOOT_BIN_LOC)/RV_BOOT.bin

#=================================================
# OpenSBI Compilation
#=================================================
opensbi:
	$(EXPORT_CC_PATH) && \
		$(MAKE) -C $(OPENSBI_SRC) \
		$(OPENSBI_COMPILE_FLAGS)
	
opensbi_clean:
	$(EXPORT_CC_PATH) && \
		$(MAKE) -C $(OPENSBI_SRC) \
		$(OPENSBI_COMPILE_FLAGS) clean
	@rm -f $(RV_BOOT_BIN)

opensbi_distclean:
	@rm -rf $(OPENSBI_LOC) $(RV_BOOT_BIN)
