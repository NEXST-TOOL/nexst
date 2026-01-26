# DT building target

CPP_PARAMS :=

CPP_PARAMS += -DFPGA_$(shell echo $(FPGA_BD) | tr a-z A-Z)

DT_LOC := $(abspath $(NANHU_G_SW_LOC)/dt)

DT_TARGET ?= XSTop
dts := $(DT_TARGET).dts
dtb := $(DT_TARGET).dtb

DTS := $(DT_LOC)/$(dts)
DTB := $(INSTALL_LOC)/$(dtb)

#==========================================
# Device Tree Source and Blob compilation 
#==========================================
target_dt: $(DTB)

$(DTB): $(DTS)
	@mkdir -p $(INSTALL_LOC)
	cpp $(CPP_PARAMS) -I $(DT_LOC) -E -P -x assembler-with-cpp $(DTS) | \
		dtc -I dts -O dtb -o $@ -

target_dt_clean:
	@rm -f $(DTB)

