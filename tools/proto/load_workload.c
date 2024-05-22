#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

#define BUF_SIZE              0x10000000
#define OFFSET_IN_FPGA_DRAM   0x80000000

int main( int argc, char *argv[])
{
    char* srcBuf;
    int write_fd;
    int i;
    int ret;
    char * file_name;

    srcBuf = (char*)malloc(BUF_SIZE * sizeof(char));

    file_name = argv[1];
    FILE *p;
    p = fopen(file_name, "rb");
    fread(srcBuf, 1, BUF_SIZE, p); 
    /* Open a XDMA write channel (Host to Core) */
    if ((write_fd = open("/dev/xdma0_h2c_0",O_WRONLY)) == -1) {
        perror("open failed with errno");
    }
    
    fclose(p);
    /* Write the entire source buffer to offset OFFSET_IN_FPGA_DRAM */
    ret = pwrite(write_fd , srcBuf, BUF_SIZE, OFFSET_IN_FPGA_DRAM);
    if (ret < 0) {
        perror("write failed with errno");
    }
    
    printf("Tried to write %u bytes, succeeded in writing %u bytes\n", BUF_SIZE, ret);

    if (close(write_fd) < 0) {
        perror("write_fd close failed with errno");
    }
    return 0;
} 
