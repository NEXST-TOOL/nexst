#!/bin/bash

if [ $# -ge 1 ]; then

    qdma_bdf=${1:4:2}:${1:6:2}.${1:8:1}

    qdma_user=/sys/bus/pci/devices/0000:$qdma_bdf/resource1
    qdma_bypass=/sys/bus/pci/devices/0000:$qdma_bdf/resource2

    if [ ! -e $qdma_user ]; then
        echo "ERROR: not a character device: $qdma_user"
        exit 1
    fi

    if [ ! -e $qdma_bypass ]; then
        echo "ERROR: not a character device: $qdma_bypass"
        exit 1
    fi

fi

if [ $# -eq 1 ]; then

    ./pcie-util $qdma_user uart 0x11000

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
    ./pcie-util $qdma_user write 0x100000 1

    echo "Load $bootrom"
    ./pcie-util $qdma_user load 0x0 0x10000 $bootrom

    echo "Load $fw_payload"
    ./pcie-util $qdma_bypass load 0x80000000 0x10000000 $fw_payload

    echo "Deassert reset"
    ./pcie-util $qdma_user write 0x100000 0

    echo "Start serial connection"
    ./pcie-util $qdma_user uart 0x11000
else

cat <<EOF
Usage: $0 <qdmaNN000> <bootrom.bin> <fw_payload.bin>    Load images & run from reset state
   Or: $0 <qdmaNN000>                                   Continue from last state
EOF
exit 1

fi
