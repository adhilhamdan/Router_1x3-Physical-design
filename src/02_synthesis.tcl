# =============================================================
# 02_synthesis.tcl
# =============================================================

puts "=== SYNTHESIS ==="

read_verilog "$RTL_DIR/router_fifo.v"
read_verilog "$RTL_DIR/router_fsm.v"
read_verilog "$RTL_DIR/router_reg.v"
read_verilog "$RTL_DIR/router_sync.v"
read_verilog "$RTL_DIR/router_top.v"

elaborate  $DESIGN_NAME
link_design $DESIGN_NAME

create_clock -name clk -period $CLK_PERIOD [get_ports clk]
set_clock_uncertainty -setup $UNCERTAINTY_SETUP [get_clocks clk]
set_clock_uncertainty -hold  $UNCERTAINTY_HOLD  [get_clocks clk]
set_input_delay  $IO_DELAY_IN  -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay $IO_DELAY_OUT -clock clk [all_outputs]

syn_generic
syn_map

write_verilog  -hierarchy "./${DESIGN_NAME}_syn.v"
write_sdc      "./${DESIGN_NAME}_syn.sdc"
report_timing  > "./reports/timing_syn.rpt"
report_area    > "./reports/area_syn.rpt"

puts "=== SYNTHESIS COMPLETE ==="
