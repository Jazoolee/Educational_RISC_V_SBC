# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(DESIGN_DIR)/fixed_dont_change/fixed_wrapper_cfgs.tcl


# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(DESIGN_DIR)/fixed_dont_change/default_wrapper_cfgs.tcl


set script_dir [file dirname [file normalize [info script]]]
set proj_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) SLRV
set verilog_root $::env(DESIGN_DIR)/../../verilog/
set lef_root $::env(DESIGN_DIR)/../../lef/
set gds_root $::env(DESIGN_DIR)/../../gds/
#section end

# User Configurations
#
set ::env(DESIGN_IS_CORE) 1


## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(DESIGN_DIR)/../../verilog/rtl/defines.v \
	$::env(DESIGN_DIR)/../../verilog/rtl/SLRV.v"


## Clock configurations
set ::env(CLOCK_PORT) "wb_clk_i"
#set ::env(CLOCK_NET) "mprj.clk"

set ::env(CLOCK_PERIOD) "100"

## Internal Macros
### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $::env(DESIGN_DIR)/macro.cfg

#set ::env(PDN_CFG) $::env(DESIGN_DIR)/pdn_cfg.tcl

set ::env(SDC_FILE) $::env(DESIGN_DIR)/base_SLRV.sdc
set ::env(BASE_SDC_FILE) $::env(DESIGN_DIR)/base_SLRV.sdc

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
        $::env(DESIGN_DIR)/../../verilog/gl/dmem.v \
        $::env(DESIGN_DIR)/../../verilog/gl/processor_only.v \
	"

set ::env(EXTRA_LEFS) "\
	$lef_root/dmem.lef \
	$lef_root/processor_only.lef \
	"

set ::env(EXTRA_GDS_FILES) "\
	$gds_root/dmem.gds \
	$gds_root/processor_only.gds \
	"

set ::env(SYNTH_DEFINES) [list SYNTHESIS YCR_DBG_EN ]

set ::env(VERILOG_INCLUDE_DIRS) [glob $::env(DESIGN_DIR)/../../verilog/includes ]

#set ::env(GLB_RT_MAXLAYER) 6
set ::env(RT_MAX_LAYER) {met5}
set ::env(GRT_ALLOW_CONGESTION) {1}


## Internal Macros
### Macro PDN Connections
set ::env(FP_PDN_CHECK_NODES) 1
set ::env(FP_PDN_IRDROP) "1"
set ::env(RUN_IRDROP_REPORT) "1"
####################

set ::env(FP_PDN_ENABLE_MACROS_GRID) {1}
set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) "0"
set ::env(FP_PDN_CHECK_NODES) 1
set ::env(FP_PDN_ENABLE_RAILS) 0
set ::env(FP_PDN_IRDROP) "1"
set ::env(FP_PDN_HORIZONTAL_HALO) "10"
set ::env(FP_PDN_VERTICAL_HALO) "10"
set ::env(FP_PDN_VOFFSET) "5"
set ::env(FP_PDN_VPITCH) "150"
set ::env(FP_PDN_HOFFSET) "5"
set ::env(FP_PDN_HPITCH) "150"
set ::env(FP_PDN_HWIDTH) {4.2}
set ::env(FP_PDN_VWIDTH) {4.2}
set ::env(FP_PDN_HSPACING) {13.8}
set ::env(FP_PDN_VSPACING) {13.8}

set ::env(VDD_NETS) {vccd1 vccd2 vdda1 vdda2}
set ::env(GND_NETS) {vssd1 vssd2 vssa1 vssa2}
set ::env(VDD_NET) {vccd1}
set ::env(GND_NET) {vssd1}
set ::env(VDD_PIN) {vccd1}
set ::env(GND_PIN) {vssd1}

set ::env(PDN_STRIPE) {vccd1 vdda1 vssd1 vssa1}
set ::env(DRT_OPT_ITERS) {32}

set ::env(GRT_OBS) "                              \
	                met5  0 0 2920 3520"

#set ::env(GRT_OBS) "                              \
#	                li1   150 130  833.1  546.54,\
#	                met1  150 130  833.1  546.54,\
#	                met2  150 130  833.1  546.54,\
#                    met3  150 130  833.1  546.54,\
#	                li1   950 130  1633.1 546.54,\
#	                met1  950 130  1633.1 546.54,\
#	                met2  950 130  1633.1 546.54,\
#                    met3  950 130  1633.1 546.54,\
#                    li1   150  750 833.1  1166.54,\
#                    met1  150  750 833.1  1166.54,\
#                    met2  150  750 833.1  1166.54,\
#                    met3  150  750 833.1  1166.54,\
#                    met3  50   100 100    3350,\
#	                met5  0 0 2920 3520"

#set ::env(FP_PDN_POWER_STRAPS) "vccd1 vssd1 1, vccd2 vssd2 0, vdda1 vssa1 1, vdda2 vssa2 1"

set ::env(FP_PDN_MACRO_HOOKS) " \
    dmem                       vccd1 vssd1 VPWR  VGND, \
	processor_only                  vccd1 vssd1 vccd1 vssd1
      	"



# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 0
set ::env(RUN_LINTER) 0
set ::env(IO_SYNC) 0
set ::env(PL_RANDOM_GLB_PLACEMENT) 1
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(RUN_FILL_INSERTION) 0
set ::env(RUN_TAP_DECAP_INSERTION) 0
#set ::env(CLOCK_TREE_SYNTH) 0
set ::env(RUN_CTS) 0
set ::env(QUIT_ON_LVS_ERROR) "1"
set ::env(QUIT_ON_MAGIC_DRC) "0"
set ::env(QUIT_ON_NEGATIVE_WNS) "0"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "0"
set ::env(QUIT_ON_TIMING_VIOLATIONS) "0"

## Temp Masked due to long Run Time
#set ::env(RUN_KLAYOUT_XOR) {0}

