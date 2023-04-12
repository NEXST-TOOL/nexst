.PHONY: qdma_drv opensbi target_dt

NM37_SW_LOC := target/nm37-xiangshan/software

EXPORT_CC_PATH := export PATH=$(LINUX_GCC_PATH):$$PATH

EXPORT_DTC_PATH := export PATH=$(DTC_LOC):$$PATH

include $(NM37_SW_LOC)/../scripts/sw_target/qdma_drv.mk

include $(NM37_SW_LOC)/../scripts/sw_target/opensbi.mk

include $(NM37_SW_LOC)/../scripts/sw_target/dt.mk

