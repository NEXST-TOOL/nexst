# Remove greybox
update_design -cell xiangshan_i/u_role/inst -black_box

# Lock static logic and routing
lock_design -level routing
write_checkpoint -force ${dcp_dir}/shell.dcp
