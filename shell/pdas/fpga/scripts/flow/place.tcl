# Placement
place_design

report_utilization -file ${impl_rpt_dir}/post_place_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_timing_setup.rpt -delay_type max -max_paths 1000
report_timing_summary -file ${impl_rpt_dir}/post_place_timing_hold.rpt -delay_type min -max_paths 1000

write_checkpoint -force ${dcp_dir}/place.dcp
