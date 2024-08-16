# routing
route_design

# Physical design optimization
phys_opt_design -sll_reg_hold_fix -slr_crossing_opt

report_utilization -file ${impl_rpt_dir}/post_route_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_route_timing.rpt -delay_type max -max_paths 1000

report_route_status -file ${impl_rpt_dir}/post_route_status.rpt

write_checkpoint -force ${dcp_dir}/route.dcp

exec mkdir -p ${out_dir}/${target_path}
