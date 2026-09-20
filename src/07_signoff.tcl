# =============================================================
# 07_signoff.tcl
# =============================================================

puts "=== SIGNOFF ==="

report_timing -delay max -nworst 10 > "./reports/signoff_setup.rpt"
report_timing -delay min -nworst 10 > "./reports/signoff_hold.rpt"
report_area                          > "./reports/signoff_area.rpt"
report_power                         > "./reports/signoff_power.rpt"

write_verilog -hierarchy "./${DESIGN_NAME}_final.v"
write_sdc                "./${DESIGN_NAME}_final.sdc"

if {[catch {
    write_gds \
        -output   "./${DESIGN_NAME}_final.gds" \
        -map_file "$PDK_DIR/techfiles/saed32nm_1p9m_gdsout_m.map"
} err]} {
    puts "WARNING: GDS write: $err"
}

verify_drc > "./reports/signoff_drc.rpt"

puts "=== SIGNOFF COMPLETE ==="
puts "=== PD FLOW DONE ==="
