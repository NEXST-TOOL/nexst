.PHONY: qdma_drv_armv8

NM37_SW_LOC := target/nm37-xiangshan/software

QDMA_SRC := $(NM37_SW_LOC)/qdma/QDMA/linux-kernel

# source file locations of QDMA driver and apps
QDMA_DRV_SRC := $(QDMA_SRC)/driver
QDMA_APP_SRC := $(QDMA_SRC)/apps

# ARMv8 kernel source files
KERN_SRC_LOC := software/linux

# generated Linux symbol version file
modulesymfile := $(abspath $(NM37_SW_LOC)/build/qdma/drv/Module.symvers)

qdma_drv_armv8: 
	@echo "Compiling QDMA Linux driver..."
	@mkdir -p $(NM37_SW_LOC)/build/qdma/drv 
	$(EXPORT_CC_PATH) && $(MAKE) $(MODULE) -C $(QDMA_DRV_SRC) \
		modulesymfile=$(modulesymfile) \
		CROSS_COMPILE=$(CROSS_COMPILE)
		KDIR=$(KERN_SRC_LOC)

qdma_drv_armv8_clean:
	$(MAKE) -C $(QDMA_DRV_SRC) clean

