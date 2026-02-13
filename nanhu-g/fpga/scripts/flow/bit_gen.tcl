# bitstream generation
if {${::board} == "uvhs2"} {
  write_device_image -force ${out_dir}/system.pdi
} else {
  write_bitstream -force ${out_dir}/system.bit
}
