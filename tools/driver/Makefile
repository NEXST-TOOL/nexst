#=================================================
# Parameters for XDMA Driver
#=================================================
XDMA_SRC := xdma_drv/XDMA/linux-kernel
XDMA_DST := build

# source file locations of XDMA driver and apps
XDMA_DRV_SRC := $(XDMA_SRC)/xdma
XDMA_TOOL_SRC := $(XDMA_SRC)/tools

GEN_TARGET := *.ko modules.order *.mod.c *.o .*.o.cmd *.mod .*.ko.cmd .*.mod.cmd .*.order.cmd .*.symvers.cmd Module.symvers
GEN_FILES := $(foreach obj,$(GEN_TARGET),$(XDMA_DRV_SRC)/$(obj)) 

#=================================================
# XDMA Driver Compilation
#=================================================
xdma_drv:
	@echo "Compiling XDMA Linux driver..."
	@mkdir -p $(XDMA_DST)
	$(MAKE) $(MODULE) -C $(XDMA_DRV_SRC)
	@mv $(GEN_FILES) $(abspath $(XDMA_DST))

xdma_drv_clean:
	$(MAKE) -C $(XDMA_DRV_SRC) clean
	@rm -rf $(XDMA_DST)

.PHONY: xdma_drv xdma_drv_clean

all: xdma_drv
