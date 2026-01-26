# bitstream generation
write_bitstream -force ${out_dir}/system.bit

# write_bitstream -cell [get_cells xiangshan_i/u_role/inst] \
#     -force ${out_dir}/${target_path}/role.bit \
#     -logic_location_file