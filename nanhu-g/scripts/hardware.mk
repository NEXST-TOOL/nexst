NANHU_G_LOC := target/nanhu-g/hardware
XS_SRC := $(NANHU_G_LOC)/xs-gen
GEN_DIR := $(NANHU_G_LOC)/sources/generated
PATCH_DIR := $(NANHU_G_LOC)/sources/patch

CONFIG ?= NanHuGNEXSTConfig
NUM_CORES ?= 1

.PHONY: xs_gen
xs_gen:
	make -C $(XS_SRC) CONFIG=$(CONFIG) NUM_CORES=$(NUM_CORES) verilog
	mkdir -p $(GEN_DIR)
	cp $(XS_SRC)/build/*.v $(GEN_DIR)
	cp $(PATCH_DIR)/*.v $(GEN_DIR)
	$(PATCH_DIR)/XSTop_patch.py $(XS_SRC)/build/XSTop.v > $(GEN_DIR)/XSTop.v

.PHONY: xs_clean
xs_clean:
	rm -rf $(GEN_DIR)
	rm -rf $(XS_SRC)/build

REMU_INSTALL_PREFIX := $(abspath tools/remu/install)
REMU_SRC_DIR := $(NANHU_G_LOC)/sources/remu
REMU_OUT_DIR := $(NANHU_G_LOC)/remu_out

REMU_SRCS := $(wildcard $(GEN_DIR)/*.v) $(wildcard $(REMU_SRC_DIR)/*.v)

SYSTEM_V     := $(REMU_OUT_DIR)/emu_system.v
ELAB_V       := $(REMU_OUT_DIR)/emu_elab.v
SYSINFO_FILE := $(REMU_OUT_DIR)/sysinfo.json
CKPT_PATH    := $(REMU_OUT_DIR)/ckpt
REPLAY_VVP   := $(REMU_OUT_DIR)/replay.vvp
REPLAY_DUMP  := $(REMU_OUT_DIR)/replay.fst

REMU_CFG := $(REMU_INSTALL_PREFIX)/bin/remu-config
YOSYS := $(REMU_INSTALL_PREFIX)/bin/yosys
IVL := $(REMU_INSTALL_PREFIX)/bin/iverilog
VVP := $(REMU_INSTALL_PREFIX)/bin/vvp

TRANSFORM_FLAGS := -top emu_top -elab $(ELAB_V) -sysinfo $(SYSINFO_FILE) -ckpt $(CKPT_PATH) -rewrite_arst -out $(SYSTEM_V)
YOSYS_FLAGS := -d -m transform -p "read_verilog $(REMU_SRCS); emu_transform $(TRANSFORM_FLAGS)"

IVL_SRCS        := $(shell $(REMU_CFG) --ivl-srcs)
IVL_FLAGS       := $(shell $(REMU_CFG) --ivl-flags)
VVP_FLAGS       := $(shell $(REMU_CFG) --vvp-flags)

TICK ?= 0
DURATION ?= 1000

REPLAY_PLUSARGS += -fst
REPLAY_PLUSARGS += -sysinfo $(SYSINFO_FILE)
REPLAY_PLUSARGS += -checkpoint $(CKPT_PATH)
REPLAY_PLUSARGS += -tick $(TICK)
REPLAY_PLUSARGS += +dumpfile=$(REPLAY_DUMP)
REPLAY_PLUSARGS += +duration=$(DURATION)

.PHONY: remu_transform
remu_transform:
	mkdir -p $(REMU_OUT_DIR)
	$(YOSYS) $(YOSYS_FLAGS)

.PHONY: remu_replay
remu_replay: $(REPLAY_VVP)
	$(VVP) $(VVP_FLAGS) $^ $(REPLAY_PLUSARGS)

$(REPLAY_VVP): $(ELAB_V) $(IVL_SRCS)
	mkdir -p $(REMU_OUT_DIR)
	$(IVL) $(IVL_FLAGS) -o $@ $^
