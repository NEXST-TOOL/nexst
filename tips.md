请手动在`nanhu-g/software/rootfs/apps/busybox/networking/tls_aesgcm.c`内添加：`#define LONG_BIT 64`

若要使用网络功能，请注意，可能出现host在FPGA初始化前发出探测包导致unhandled intr并最终造成FPGA无法收发包的情况，具体现象是FPGA linux初始化时报错can't find mapping for hwirq 6/7，并ping不通host；若已经出现该情况，请重新烧bit（烧bin无法清除中断）。
