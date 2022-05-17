read_verilog ../tabtest.v
read_verilog ../../../picorv32.v
read_xdc test_20.xdc
synth_design -flatten_hierarchy full -part xc7k70t-fbg676-2 -top top
opt_design -sweep -remap -propconst
opt_design -directive Explore
place_design -directive Explore
phys_opt_design -retime -rewire -critical_pin_opt -placement_opt -critical_cell_opt
route_design -directive Explore
place_design -post_place_opt
phys_opt_design -retime
route_design -directive NoTimingRelaxation
report_utilization
report_timing
