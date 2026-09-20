# =============================================================
# run_all.tcl
# Run: fc_shell -f run_all.tcl |& tee pd_run.log
# =============================================================

source 01_setup.tcl
source 02_synthesis.tcl
source 03_floorplan.tcl
source 04_placement.tcl
source 05_cts.tcl
source 06_routing.tcl
source 07_signoff.tcl
