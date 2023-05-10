O ?= $(shell pwd)
TARGET := pcie-util
CXX := g++

objs-y += devmem.o
objs-y += sighandler.o
objs-y += uart.o
objs-y += main.o

objs-path-y = $(foreach obj,$(objs-y),$(O)/$(obj))

.PHONY: all clean

all: $(TARGET)

clean:
	rm -f $(objs-path-y) $(TARGET)

$(O)/%.o: %.cc
	$(CXX) -c -o $@ $^

$(TARGET): $(objs-path-y)
	$(CXX) -o $@ $^
