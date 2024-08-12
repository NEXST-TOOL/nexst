请手动在`nanhu-g/software/rootfs/apps/busybox/networking/tls_aesgcm.c`内添加：`#define LONG_BIT 64`

若要使用网络功能，请注意，由于FPGA板卡的phy复位不完全，FPGA的网卡生命周期一定要完整包含host网卡的生命周期，否则容易出现host发出探测包导致unhandled intr并最终造成的卡死，具体现象是FPGA linux初始化时报错can't find mapping for hwirq 6/7；若已经出现该情况，请重新烧bit（烧bin无法清除中断）。
