.PHONY: qdma_drv opensbi target_dt zsbl

NANHU_G_SW_LOC := target/nanhu-g/software

include $(NANHU_G_SW_LOC)/../scripts/sw_target/opensbi.mk

include $(NANHU_G_SW_LOC)/../scripts/sw_target/kernel.mk

include $(NANHU_G_SW_LOC)/../scripts/sw_target/dt.mk

include $(NANHU_G_SW_LOC)/../scripts/sw_target/zsbl.mk
