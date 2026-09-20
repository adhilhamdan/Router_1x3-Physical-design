# =============================================================
# 01_setup.tcl
# =============================================================

set DESIGN_NAME       "router_top"
set TARGET_FREQ       500
set CLK_PERIOD        [expr 1000.0 / $TARGET_FREQ]
set UNCERTAINTY_SETUP 0.1
set UNCERTAINTY_HOLD  0.05
set IO_DELAY_IN       0.4
set IO_DELAY_OUT      0.4

set PDK_DIR  "/home/install/synopsys/PDK/SAED32nm_PDK_04152022"
set FC_LIB   "/home/install/synopsys/fusioncompiler/U-2022.12-SP1/libraries/syn"
set RTL_DIR  "/home/sanjay/Router_1x3/Router-1-x-3-/PD/RTL"

# Use gtech for compile
set_app_var target_library "$FC_LIB/gtech.db"
set_app_var link_library   "* $FC_LIB/gtech.db"

set MW_DESIGN_LIB "./${DESIGN_NAME}_lib"

if {[catch {
    create_lib \
        -technology "$PDK_DIR/techfiles/saed32nm_1p9m_mw.tf" \
        -ref_libs   "$PDK_DIR/sym_libs" \
        $MW_DESIGN_LIB
} err]} {
    puts "WARNING: create_lib: $err"
}

file mkdir ./reports

puts "=== SETUP COMPLETE ==="
