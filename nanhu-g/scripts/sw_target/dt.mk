# DT building target

CPP_PARAMS :=

ifeq ($(NUM_CORES), 4)
	NUM_CORES_H := "\"cores/quad-core.dtsi\""
else ifeq ($(NUM_CORES), 2)
	NUM_CORES_H := "\"cores/dual-core.dtsi\""
else
	NUM_CORES_H := "\"cores/single-core.dtsi\""
endif

CPP_PARAMS += -DNUM_CORES_H=$(NUM_CORES_H)

ifeq ($(WITH_PCIE), 1)
	CPP_PARAMS += -DWITH_PCIE=1
endif

DT_LOC := $(abspath $(NANHU_G_SW_LOC)/dt)

DT_TARGET ?= XSTop
dts := $(DT_TARGET).dts
dtb := $(DT_TARGET).dtb

DTS := $(DT_LOC)/$(dts)
DTB := $(DT_LOC)/$(dtb)

#==========================================
# Device Tree Source and Blob compilation 
#==========================================
target_dt: $(DTB)
	@mkdir -p $(INSTALL_LOC)
	@cp $(DTB) $(INSTALL_LOC)/

$(DTB): $(DTS)
	cpp $(CPP_PARAMS) -I $(DT_LOC) -E -P -x assembler-with-cpp $(DTS) | \
		dtc -I dts -O dtb -o $@ -

target_dt_clean:
	@rm -f $(DTB)
