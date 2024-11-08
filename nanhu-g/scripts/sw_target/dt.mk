# DT building target

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

$(DTB): 
	$(EXPORT_DTC_PATH) && \
		cpp -I $(DT_LOC) -E -P -x assembler-with-cpp $(DTS) | \
		dtc -I dts -O dtb -o $@ -

target_dt_clean:
	@rm -f $(DTB)

