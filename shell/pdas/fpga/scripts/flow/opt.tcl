# open shell checkpoint
open_checkpoint ${dcp_dir}/synth.dcp

# change role to a gray box
set_property HD.RECONFIGURABLE true [get_cells xiangshan_i/u_role/inst]
update_design -cell xiangshan_i/u_role/inst -buffer_ports
set_property HD.RECONFIGURABLE false [get_cells xiangshan_i/u_role/inst]

create_pblock pblock_axi_axil_adapter
resize_pblock pblock_axi_axil_adapter -add CLOCKREGION_S1X5Y4:CLOCKREGION_S1X6Y4
add_cells_to_pblock pblock_axi_axil_adapter [get_cells [list xiangshan_i/axi_axil_adapter]] -clear_locs

# Design optimization
opt_design

report_utilization -file ${impl_rpt_dir}/opt_util.rpt
report_timing_summary -file ${impl_rpt_dir}/opt_timing.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/opt.dcp
