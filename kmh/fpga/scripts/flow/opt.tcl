# open shell checkpoint
open_checkpoint ${dcp_dir}/../../shell_${board}_${board}/dcp/synth.dcp

# open role checkpoint
read_checkpoint -cell [get_cells xiangshan_i/u_role/inst] \
    ${dcp_dir}/synth.dcp

report_utilization -file ${impl_rpt_dir}/pre_opt_util.rpt
report_timing_summary -file ${impl_rpt_dir}/pre_opt_util.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/pre_opt_util.dcp

# Design optimization
## Pass 1: LUT reduction
opt_design -directive ExploreArea

report_utilization -file ${impl_rpt_dir}/opt_explore_area_util.rpt
report_timing_summary -file ${impl_rpt_dir}/opt_explore_area_timing.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/opt_explore_area.dcp

## Pass 2: Reduction in Levels of logics
opt_design -directive AddRemap

report_utilization -file ${impl_rpt_dir}/opt_add_remap_util.rpt
report_timing_summary -file ${impl_rpt_dir}/opt_add_remap_timing.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/opt_add_remap.dcp

## Pass 3: Control set merging and equivalent driver merging
opt_design -control_set_merge -merge_equivalent_drivers

report_utilization -file ${impl_rpt_dir}/opt_logic_merge_util.rpt
report_timing_summary -file ${impl_rpt_dir}/opt_logic_merge_timing.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/opt_logic_merge.dcp

# Save debug probe file
write_debug_probes -force ${out_dir}/debug_nets.ltx
