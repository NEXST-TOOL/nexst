.PHONY: qdma_drv opensbi target_dt zsbl

NANHU_G_SW_LOC := target/nanhu-g/software

EXPORT_CC_PATH := export PATH=$(LINUX_GCC_PATH):$$PATH

EXPORT_DTC_PATH := export PATH=$(DTC_LOC):$$PATH

include $(NANHU_G_SW_LOC)/../scripts/sw_target/xdma_drv.mk

include $(NANHU_G_SW_LOC)/../scripts/sw_target/opensbi.mk

include $(NANHU_G_SW_LOC)/../scripts/sw_target/kernel.mk

include $(NANHU_G_SW_LOC)/../scripts/sw_target/dt.mk

include $(NANHU_G_SW_LOC)/../scripts/sw_target/zsbl.mk

