.PHONY: qdma_drv

NM37_SW_LOC := target/nm37-xiangshan/software

QDMA_SRC := $(NM37_SW_LOC)/qdma/QDMA/linux-kernel

# source file locations of QDMA driver and apps
QDMA_DRV_SRC := $(QDMA_SRC)/driver
QDMA_APP_SRC := $(QDMA_SRC)/apps

# ARMv8 kernel source files and cross-compiler PATH
ifeq ($(TARGET_HOST),aarch64)
KSRC := $(abspath software/linux)
KOBJ:= $(abspath software/arm-linux/phy_os)
endif

EXPORT_CC_PATH := export PATH=$(LINUX_GCC_PATH):$$PATH

ifeq ($(TARGET_HOST),aarch64)
drv-flags := ARCH=$(TARGET_HOST) CROSS_COMPILE=$(LINUX_GCC_PREFIX) \
             KSRC=$(KSRC) KOBJ=$(KOBJ)
else
drv-flags := 
endif

# generated Linux symbol version file
modulesymfile := $(abspath $(NM37_SW_LOC)/build/qdma/drv/Module.symvers)

qdma_drv:
	@echo "Compiling QDMA Linux driver..."
	@mkdir -p $(NM37_SW_LOC)/build/qdma/drv 
	$(EXPORT_CC_PATH) && $(MAKE) $(MODULE) -C $(QDMA_DRV_SRC) \
		modulesymfile=$(modulesymfile) $(drv-flags)

	@mv $(abspath $(QDMA_DRV_SRC)/../bin/*) $(abspath $(NM37_SW_LOC)/build/qdma/drv)

qdma_drv_clean:
	$(MAKE) -C $(QDMA_DRV_SRC) clean
	@rm -rf $(NM37_SW_LOC)/build/qdma/drv

