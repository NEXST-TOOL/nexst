INSTALL_PREFIX := $(shell pwd)/install

ABCURL := "https://gitlab.agileserve.org.cn:8001/remu/yosys-abc.git"
export ABCURL

.PHONY: all
all: iverilog remu

$(INSTALL_PREFIX):
	mkdir -p $@

.PHONY: iverilog
iverilog: iverilog-build/Makefile $(INSTALL_PREFIX)
	$(MAKE) -C iverilog-build install

iverilog-build/Makefile:
	mkdir -p iverilog-build
	cd iverilog && sh autoconf.sh
	cd iverilog-build && ../iverilog/configure --prefix=$(INSTALL_PREFIX)

.PHONY: remu
remu: framework-build/Makefile $(INSTALL_PREFIX)
	$(MAKE) -C framework-build install

framework-build/Makefile:
	mkdir -p framework-build
	cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) -DENABLE_REMU_COSIM=ON -S framework -B framework-build
