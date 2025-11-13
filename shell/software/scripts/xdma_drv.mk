#=================================================
# Parameters for XDMA Driver
#=================================================
XDMA_SRC := shell/software/xdma_drv/XDMA/linux-kernel

# source file locations of XDMA driver and apps
XDMA_DRV_SRC := $(XDMA_SRC)/xdma
XDMA_TOOL_SRC := $(XDMA_SRC)/tools

# ARMv8 kernel source files and cross-compiler PATH
ifeq ($(TARGET_HOST),aarch64)
KSRC := $(abspath software/linux)
KOBJ:= $(abspath software/arm-linux/phy_os)
endif

ifeq ($(TARGET_HOST),aarch64)
drv-flags := ARCH=$(TARGET_HOST) CROSS_COMPILE=$(LINUX_GCC_PREFIX) \
             KSRC=$(KSRC) KOBJ=$(KOBJ)
else
drv-flags := 
endif

GEN_TARGET := *.ko modules.order *.mod.c *.o .*.o.cmd *.mod .*.ko.cmd .*.mod.cmd .*.order.cmd .*.symvers.cmd Module.symvers
GEN_FILES := $(foreach obj,$(GEN_TARGET),$(XDMA_DRV_SRC)/$(obj)) 

#=================================================
# XDMA Driver Compilation
#=================================================
xdma_drv:
	@echo "Compiling XDMA Linux driver..."
	@mkdir -p shell/software/build/xdma_drv
	$(MAKE) $(MODULE) -C $(XDMA_DRV_SRC) \
		$(drv-flags)
	@mv $(GEN_FILES) $(abspath shell/software/build/xdma_drv)

xdma_drv_clean:
	$(MAKE) -C $(XDMA_DRV_SRC) clean
	@rm -rf shell/software/build/xdma_drv
