#!/bin/bash

if [ $# -ge 1 ]; then

    xdma_user=/dev/${1}_user
    xdma_h2c=/dev/${1}_h2c_0
    if [ ! -c $xdma_user ]; then
        echo "ERROR: not a character device: $xdma_user"
        exit 1
    fi

    if [ ! -c $xdma_bypass ]; then
        echo "ERROR: not a character device: $xdma_bypass"
        exit 1
    fi

fi

if [ $# -eq 1 ]; then

    ./pcie-util $xdma_user uart 0x11000

elif [ $# -eq 3 ]; then

    bootrom=$2
    fw_payload=$3

    if [ ! -f $bootrom ]; then
        echo "ERROR: file not found: $bootrom"
        exit 1
    fi

    if [ ! -f $fw_payload ]; then
        echo "ERROR: file not found: $fw_payload"
        exit 1
    fi

    echo "Assert reset"
    ./pcie-util $xdma_user write 0x100000 1

    echo "Load $bootrom"
    ./pcie-util $xdma_user load 0x0 0x10000 $bootrom

    echo "Load $fw_payload"
    ./load_workload $fw_payload
    echo "Deassert reset"
    ./pcie-util $xdma_user write 0x100000 0

    echo "Start serial connection"
    ./pcie-util $xdma_user uart 0x11000

else

cat <<EOF
Usage: $0 <xdmaN> <bootrom.bin> <fw_payload.bin>    Load images & run from reset state
   Or: $0 <xdmaN>                                   Continue from last state
EOF
exit 1

fi
