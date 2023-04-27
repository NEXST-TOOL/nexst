# Placement
place_design

report_clock_utilization -file ${impl_rpt_dir}/clock_util.rpt

# Physical design optimization
phys_opt_design
		
write_checkpoint -force ${dcp_dir}/place.dcp

report_utilization -file ${impl_rpt_dir}/post_place_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_timing.rpt -delay_type max -max_paths 1000

