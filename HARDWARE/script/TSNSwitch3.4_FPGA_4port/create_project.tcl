# Copyright (C) 2019  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: TSN_FPGA_4port.tcl
# Generated on: Mon May 23 08:37:47 2022

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "TSN_FPGA_4port"]} {
		puts "Project TSN_FPGA_4port is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists TSN_FPGA_4port]} {
		project_open -revision TSN_FPGA_4port TSN_FPGA_4port
	} else {
		project_new -revision TSN_FPGA_4port TSN_FPGA_4port
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Arria 10"
	set_global_assignment -name DEVICE 10AX048H2F34E2SG
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 19.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "14:58:41  JULY 18, 2020"
	set_global_assignment -name LAST_QUARTUS_VERSION "19.1.0 Standard Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 2
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name ENABLE_SIGNALTAP ON
	set_global_assignment -name USE_SIGNALTAP_FILE output_files/stp1.stp
	set_global_assignment -name IGNORE_PARTITIONS OFF
	set_global_assignment -name ENABLE_OCT_DONE OFF
	set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
	set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "PASSIVE SERIAL"
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
	set_global_assignment -name STRATIXII_CONFIGURATION_DEVICE AUTO
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
	set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/syn_clk_judge.v
	set_global_assignment -name QSYS_FILE ipcore/hardware_control_point/ram/truedualportram_singleclock_rdenab_outputaclr_w34d4096.qsys
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/packet_switch/pkt_dispatch.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/packet_switch/pkt_select.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/packet_switch/packet_switch.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/cycle_control/cycle_start_judge.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/cycle_control/cycle_control.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/cycle_control/command_parse_and_encapsulate_cc.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/cpu_hcp_select/pkt_select.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/cpu_hcp_select/pkt_dispatch.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/cpu_hcp_select/cpu_hcp_select.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/tunnel_frame_process.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/control_output_process/control_tx/control_tx.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/control_output_process/control_tx/control_read_control.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/control_output_process/control_tx/control_output_interface.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/control_output_process/control_output_process.v
	set_global_assignment -name VERILOG_FILE rtl/TSN_FPGA_4port.v
	set_global_assignment -name VERILOG_FILE rtl/TSNSwitch_8port.V
	set_global_assignment -name VERILOG_FILE rtl/tsnswitch.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/signal_sync.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/reset_top.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/reset_sync.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/reset_glitch.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/reset_clock_check.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/opentsn_time_sensitive_switch.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/led_on_time.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/global_registers_management.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/asynfifo_overflow_underflow_output.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/ram_shell/SFIFO_9_512.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/pkt_centralized_buffer/pkt_write.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/pkt_centralized_buffer/pkt_read.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/pkt_centralized_buffer/pkt_centralized_buffer.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/pkt_centralized_buffer/command_parse_and_encapsulate_pcb.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/pkt_centralized_buffer/address_write.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/pkt_centralized_buffer/address_read.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_output_process_top.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_output_process.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/queue_gate_control/time_slot_calculation.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/queue_gate_control/queue_gate_control.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/queue_gate_control/gate_control.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/queue_gate_control/command_parse_and_encapsulate_qgc.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_tx/pkt_read_control.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_tx/output_control.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_tx/network_tx.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_queue_manage/network_queue_manage.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_output_schedule/virtual_queue_manage.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_output_schedule/output_schedule_control.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_output_schedule/network_output_schedule.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_output_process/network_input_queue/network_input_queue.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/network_input_process_top.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/network_input_process.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/input_buffer_interface.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/frame_filter/head_and_tail_distinguish.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/frame_filter/frame_transmittion_select.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/frame_filter/frame_filter.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/frame_filter/command_parse_and_encapsulate_ffi.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/descriptor_extract/descriptor_send.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/descriptor_extract/descriptor_generate.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/descriptor_extract/descriptor_extract.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/descriptor_extract/data_splice.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/network_input_process/descriptor_extract/command_parse_and_encapsulate_dex.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/mac_self_learning/packet_parse.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/mac_self_learning/mac_self_learning_top.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/mac_self_learning/mac_self_learning.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/mac_self_learning/entry_compare.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/tsn_packet_action.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/time_division_multiplexing.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/standard_packet_action.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/forward_lookup_table.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/flowid_lookup.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/dmac_tsntag_distinguish.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/dmac_lookup.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/descriptor_delay_manage.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/command_parse_and_encapsulate_flt.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/forward_lookup_table/action_selecting.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/control_output_process/control_queue_management/control_queue_management.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/control_output_process/control_queue_management/control_output_queue.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/control_output_process/control_queue_management/control_input_queue.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/command_parse_and_encapsulate_tss/tss_commandack_generate.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/command_parse_and_encapsulate_tss/tss_command_parse.v
	set_global_assignment -name VERILOG_FILE rtl/opentsn_time_sensitive_switch/command_parse_and_encapsulate_tss/command_parse_and_encapsulate_tss.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_mac.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/mbus_parse_and_encapsulate_osm.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_receive_pit_record.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_protocol_encapsulate.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_protocol_decapsulate.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_dispatch_pit_compensate.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_1gmac.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/interface_switch_2to1.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/interface_switch_1to2.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/clock_domain_cross.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_correctionfield_update/residence_time_calculate.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_correctionfield_update/opensync_correctionfield_update.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/opensync_correctionfield_update/command_parse_and_encapsulate_cfu.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/mac_process/transmit_mac_process.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/mac_process/receive_mac_process.v
	set_global_assignment -name VERILOG_FILE rtl/opensync_mac/opensync_1gmac/mac_process/mac_process.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/hardware_control_point.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/control_cycle.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_forward_table/tsmp_forward_table.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_forward_table/mid_lookup_table.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_forward_table/command_parse_and_encapsulate_tft.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/tsmp_protocol_process.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/tsmp_agent.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/reset_sync.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/packet_out_process.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/packet_in_process.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/opensync_protocol.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/hcp_register_group.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/address_dispatch.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/tsmp_transmit_control/tsmp_transmit_control.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/tsmp_transmit_control/controller_output_schedule.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/ram_shell/ASFIFO_9_16.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/ram_shell/ASFIFO_8_16.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/ram_shell/afifo_top.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/ram_shell/afifo_sync_dff.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/ram_shell/afifo_gray_sync.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/ram_shell/afifo.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/network_management/network_management_parse.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/network_management/network_management_generate.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/network_management/network_management.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/network_management/ack_type_parse.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/local_access_control/local_access_control.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/local_access_control/command_parse_and_encapsulate_inex/command_parse_inex.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/local_access_control/command_parse_and_encapsulate_inex/command_parse_and_encapsulate_inex.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/local_access_control/command_parse_and_encapsulate_inex/command_encapsulate_inex.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/local_access_control/command_parse_and_encapsulate_hcp/command_parse_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/local_access_control/command_parse_and_encapsulate_hcp/command_parse_and_encapsulate_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/local_access_control/command_parse_and_encapsulate_hcp/command_encapsulate_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/head_and_tail_discard/head_and_tail_discard.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/head_and_tail_discard/cross_clock_domain_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/head_and_tail_add/head_and_tail_add.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/head_and_tail_add/gmii_write_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/tsmp_agent/head_and_tail_add/gmii_read_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/opensync_timing/opensync_timing.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/opensync_timing/local_cnt_timing.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/opensync_timing/command_parse_and_encapsulate_ost.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/opensync_timing/clock_timing_and_correcting.v
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/suhddpsram65536x134_s.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/suhddpsram16384x9_s.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/suhddpsram1024x8_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/suhddpsram512x4_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/suhddpsram32x57.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/sdprf512x9_s.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/asdprf16x9_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/ram/asdprf16x8_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/fifo/syncfifo_showahead_aclr_w71d32.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/fifo/fifo_w61d32.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/fifo/fifo_w14d16.qsys
	set_global_assignment -name QSYS_FILE ipcore/time_sensitive_switch/fifo/DCFIFO_10bit_64.qsys
	set_global_assignment -name QSYS_FILE ipcore/three_speed_ethernet/sgmii_pcs_8port.qsys
	set_global_assignment -name QSYS_FILE ipcore/hardware_control_point/ram/simpledualportram_drwclock_outputaclr_w9d16.qsys
	set_global_assignment -name QSYS_FILE ipcore/hardware_control_point/ram/simpledualportram_drwclock_outputaclr_w8d16.qsys
	set_global_assignment -name QSYS_FILE ipcore/hardware_control_point/fifo/syncfifo_showahead_aclr_w64d256.qsys
	set_global_assignment -name QSYS_FILE ipcore/hardware_control_point/fifo/syncfifo_showahead_aclr_w35d4.qsys
	set_global_assignment -name QSYS_FILE ipcore/hardware_control_point/fifo/syncfifo_showahead_aclr_w9d256.qsys
	set_global_assignment -name VERILOG_FILE "rtl/time_sensitive_switch/network_input_process/network_rx/pkt distinguish.v"
	set_global_assignment -name QSYS_FILE ipcore/three_speed_ethernet/sgmii_pcs_share.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/suhddpsram65536x134_s.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/suhddpsram16384x9_s.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/suhddpsram1024x8_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/suhddpsram512x4_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/suhddpsram32x57.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/sdprf512x9_s.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/fifo_w61d32.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/fifo_w14d16.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/asdprf16x9_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/ram/asdprf16x8_rq.qsys
	set_global_assignment -name QSYS_FILE ipcore/pll/clk125M_50M125M.qsys
	set_global_assignment -name QSYS_FILE ipcore/fifo/syncfifo_showahead_aclr_w35d4.qsys
	set_global_assignment -name QSYS_FILE ipcore/fifo/dcm_fifo9x256.qsys
	set_global_assignment -name QSYS_FILE ipcore/fifo/DCFIFO_10bit_64.qsys
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_output_process.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_tx/cross_clock_domain.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_tx/control_tx.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_tx/control_read_control.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_tx/control_output_interface.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_queue_management/control_queue_management.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_queue_management/control_output_queue.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/control_output_process/control_queue_management/control_input_queue.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/tsn_packet_action.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/time_division_multiplexing.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/standard_packet_action.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/forward_lookup_table.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/flowid_lookup.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/dmac_tsntag_distinguish.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/dmac_lookup.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/descriptor_delay_manage.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/forward_lookup_table/action_selecting.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/gmii_adapter/gmii_txctrl.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/gmii_adapter/gmii_rxctrl.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/gmii_adapter/gmii_adapter_top.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/gmii_adapter/gmii_adapter.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/frame_parser/frame_parser.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/frame_parser/descriptor_send.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/frame_parser/descriptor_extract.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/frame_parser/data_splice.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/network_rx/timer.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/network_rx/pkt_filter.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/network_rx/pkt_distinguish.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/network_rx/network_rx.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/network_rx/gmii_write.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/network_input_process_top.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/network_input_process.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_input_process/input_buffer_interface.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_input_queue/network_input_queue.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_output_schedule/virtual_queue_manage.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_output_schedule/output_schedule_control.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_output_schedule/network_output_schedule.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_queue_manage/network_queue_manage.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_tx/transparent_clock_calculate.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_tx/pkt_read_control.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_tx/output_control.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_tx/network_tx.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_tx/cross_clock_domain.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/queue_gate_control/queue_gate_control.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/queue_gate_control/gate_control.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_output_port.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/port_passthrough/write_start.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/port_passthrough/read_delay.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/port_passthrough/port_passthrough.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/network_output_process/network_output_process.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/pkt_centralized_buffer/pkt_write.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/pkt_centralized_buffer/pkt_read.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/pkt_centralized_buffer/pkt_centralized_buffer.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/pkt_centralized_buffer/address_write.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/pkt_centralized_buffer/address_read.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/ram_shell/SFIFO_9_512.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/ram_shell/ASFIFO_9_16.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/ram_shell/ASFIFO_8_16.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/ram_shell/afifo_top.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/ram_shell/afifo_sync_dff.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/ram_shell/afifo_gray_sync.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/ram_shell/afifo.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/TSSwitch_top.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/TSSwitch.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/signal_sync.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/reset_top.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/reset_sync.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/reset_glitch.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/reset_clock_check.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/led_on_time.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/command_parser.v
	set_global_assignment -name VERILOG_FILE rtl/time_sensitive_switch/asynfifo_overflow_underflow_output.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/TSN_FPGA_4port.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/STSMI.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/SMI.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/sgmii_config.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/phy_reset.v
	set_global_assignment -name VERILOG_FILE rtl/interface_process/extern_phy_config.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/configure_state_manage/statistic_module.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/configure_state_manage/ram_interface_handle.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/configure_state_manage/nmac_report_module.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/configure_state_manage/nmac_parse_module.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/configure_state_manage/configure_state_manage.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/decapsulation_and_encapsulation/frame_encapsulation_module.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/decapsulation_and_encapsulation/decapsulation_dispatch_module.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/global_time_sync/global_time_sync.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/gmii_adapter/gmii_txctrl_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/gmii_adapter/gmii_rxctrl_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/gmii_adapter/gmii_adapter_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/mac_self_learning/packet_parse.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/mac_self_learning/msl_top.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/mac_self_learning/entry_compare.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/network_rx_hcp/network_rx_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/network_rx_hcp/gmii_write_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/network_rx_hcp/gmii_read_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/network_tx_hcp/output_control_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/network_tx_hcp/network_tx_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/network_tx_hcp/cross_clock_domain_hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/time_slot_calculation.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/mux.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/hcp_frame_parse.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/hcp.v
	set_global_assignment -name VERILOG_FILE rtl/hardware_control_point/dmux.v
	set_global_assignment -name SDC_FILE TSN_FPGA_4port.sdc
	set_global_assignment -name SIGNALTAP_FILE output_files/stp1.stp
	set_global_assignment -name SLD_NODE_CREATOR_ID 110 -section_id CYCLE
	set_global_assignment -name SLD_NODE_ENTITY_NAME sld_signaltap -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_BLOCK_TYPE=AUTO" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_DATA_BITS=454" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_BITS=454" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_BITS=454" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_NODE_INFO=805334530" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_POWER_UP_TRIGGER=0" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK=000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK_LENGTH=1386" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_INVERSION_MASK_LENGTH=0" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SEGMENT_SIZE=1024" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ATTRIBUTE_MEM_MODE=OFF" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_FLOW_USE_GENERATED=0" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_BITS=11" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_BUFFER_FULL_STOP=1" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_CURRENT_RESOURCE_WIDTH=1" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INCREMENTAL_ROUTING=1" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL=1" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SAMPLE_DEPTH=1024" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_IN_ENABLED=0" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_PIPELINE=0" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_PIPELINE=0" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_COUNTER_PIPELINE=0" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ADVANCED_TRIGGER_ENTITY=basic,1," -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL_PIPELINE=1" -section_id CYCLE
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ENABLE_ADVANCED_TRIGGER=0" -section_id CYCLE
	set_global_assignment -name SLD_FILE db/stp1_auto_stripped.stp
	set_location_assignment PIN_K21 -to CARD_ID[2]
	set_location_assignment PIN_L21 -to CARD_ID[1]
	set_location_assignment PIN_M21 -to CARD_ID[0]
	set_location_assignment PIN_A21 -to DEBUG_LED[4]
	set_location_assignment PIN_B21 -to DEBUG_LED[3]
	set_location_assignment PIN_B22 -to DEBUG_LED[2]
	set_location_assignment PIN_C22 -to DEBUG_LED[1]
	set_location_assignment PIN_D22 -to DEBUG_LED[0]
	set_location_assignment PIN_E23 -to FPGA_SYS_CLK
	set_location_assignment PIN_J19 -to FPGA_SYS_RST_N
	set_location_assignment PIN_A20 -to LED[3]
	set_location_assignment PIN_B20 -to LED[2]
	set_location_assignment PIN_C20 -to LED[1]
	set_location_assignment PIN_D20 -to LED[0]
	set_location_assignment PIN_F21 -to MB_ID[2]
	set_location_assignment PIN_G21 -to MB_ID[1]
	set_location_assignment PIN_J21 -to MB_ID[0]
	set_location_assignment PIN_G18 -to PHY_MDC
	set_location_assignment PIN_H17 -to PHY_MDINT
	set_location_assignment PIN_G17 -to PHY_MDIO
	set_location_assignment PIN_J17 -to PHY_RST_N
	set_location_assignment PIN_K19 -to RSV_IO[9]
	set_location_assignment PIN_L19 -to RSV_IO[8]
	set_location_assignment PIN_F19 -to RSV_IO[7]
	set_location_assignment PIN_E19 -to RSV_IO[6]
	set_location_assignment PIN_D19 -to RSV_IO[5]
	set_location_assignment PIN_C18 -to RSV_IO[4]
	set_location_assignment PIN_B18 -to RSV_IO[3]
	set_location_assignment PIN_A18 -to RSV_IO[2]
	set_location_assignment PIN_C19 -to RSV_IO[1]
	set_location_assignment PIN_A19 -to RSV_IO[0]
	set_location_assignment PIN_AN24 -to SGMII_REFCLK
	set_location_assignment PIN_AP26 -to SGMII_RXD[3]
	set_location_assignment PIN_AJ22 -to SGMII_RXD[2]
	set_location_assignment PIN_AJ27 -to SGMII_RXD[1]
	set_location_assignment PIN_AM22 -to SGMII_RXD[0]
	set_location_assignment PIN_AN27 -to SGMII_TXD[3]
	set_location_assignment PIN_AL23 -to SGMII_TXD[2]
	set_location_assignment PIN_AJ26 -to SGMII_TXD[1]
	set_location_assignment PIN_AM23 -to SGMII_TXD[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to CARD_ID[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to CARD_ID[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to CARD_ID[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to CARD_ID
	set_instance_assignment -name IO_STANDARD "2.5 V" -to DEBUG_LED[4]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to DEBUG_LED[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to DEBUG_LED[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to DEBUG_LED[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to DEBUG_LED[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to DEBUG_LED
	set_instance_assignment -name IO_STANDARD LVDS -to FPGA_SYS_CLK
	set_location_assignment PIN_E24 -to "FPGA_SYS_CLK(n)"
	set_instance_assignment -name IO_STANDARD "2.5 V" -to FPGA_SYS_RST_N
	set_instance_assignment -name IO_STANDARD "2.5 V" -to LED[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to LED[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to LED[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to LED[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to LED
	set_instance_assignment -name IO_STANDARD "2.5 V" -to MB_ID[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to MB_ID[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to MB_ID[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to MB_ID
	set_instance_assignment -name IO_STANDARD "2.5 V" -to PHY_MDC
	set_instance_assignment -name IO_STANDARD "2.5 V" -to PHY_MDINT
	set_instance_assignment -name IO_STANDARD "2.5 V" -to PHY_MDIO
	set_instance_assignment -name IO_STANDARD "2.5 V" -to PHY_RST_N
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[9]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[8]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[7]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[6]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[5]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[4]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[3]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[2]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[1]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO[0]
	set_instance_assignment -name IO_STANDARD "2.5 V" -to RSV_IO
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_REFCLK
	set_location_assignment PIN_AP24 -to "SGMII_REFCLK(n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_RXD[3]
	set_location_assignment PIN_AP27 -to "SGMII_RXD[3](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_RXD[2]
	set_location_assignment PIN_AK22 -to "SGMII_RXD[2](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_RXD[1]
	set_location_assignment PIN_AH27 -to "SGMII_RXD[1](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_RXD[0]
	set_location_assignment PIN_AN22 -to "SGMII_RXD[0](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_RXD
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_TXD[3]
	set_location_assignment PIN_AM27 -to "SGMII_TXD[3](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_TXD[2]
	set_location_assignment PIN_AK23 -to "SGMII_TXD[2](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_TXD[1]
	set_location_assignment PIN_AH26 -to "SGMII_TXD[1](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_TXD[0]
	set_location_assignment PIN_AN23 -to "SGMII_TXD[0](n)"
	set_instance_assignment -name IO_STANDARD LVDS -to SGMII_TXD
	set_instance_assignment -name AUTO_GLOBAL_CLOCK ON -to SGMII_REFCLK
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_clk -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|i_clk" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[0] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[1] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[2] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[3] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[4] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[5] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[6] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[7] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[8] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[9] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[10] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[11] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[12] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[13] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[14] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[15] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[16] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[17] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[18] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[19] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[20] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[21] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[22] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[23] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[24] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[25] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[26] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[27] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[28] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[29] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[30] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[31] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[32] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[33] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[34] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[35] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[36] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[37] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[38] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[39] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[40] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[41] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[42] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[43] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[44] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[45] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[46] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[47] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[48] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[49] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[50] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[51] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[52] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[53] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[54] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[55] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[56] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[57] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[58] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[59] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[60] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[61] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[62] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[63] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[64] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[65] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[66] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[67] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[68] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[69] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[70] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[71] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[72] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[73] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[74] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[75] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[76] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[77] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[78] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[79] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[80] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[81] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[82] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[83] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[84] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[85] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[86] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[87] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[88] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[89] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[90] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[91] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[92] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[93] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[94] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[95] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[96] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[97] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[98] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[99] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[100] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[101] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[102] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[103] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[104] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[105] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[106] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[107] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[108] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[109] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[110] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[111] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[112] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[113] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[114] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[115] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[116] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[117] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[118] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[119] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[120] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[121] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[122] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[123] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[124] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[125] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[126] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[127] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[128] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[129] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[130] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[131] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[132] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[133] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[134] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[135] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[136] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[137] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[138] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[139] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[140] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[141] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[142] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[143] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[144] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[145] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[146] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[147] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[148] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[149] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[150] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[151] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[152] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[153] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[154] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[155] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[156] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[157] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[158] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[159] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[160] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|next_state.CYCLE_IDLE" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[161] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|next_state.SET_CYCLE_STATE_TIME" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[162] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|next_state.START_CYCLE" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[163] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|o_cycle_start" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[164] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[165] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[166] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[167] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[168] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[169] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[170] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[171] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[172] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[173] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[174] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[175] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[176] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[177] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[178] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[179] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[180] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[181] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[182] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[183] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[184] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[185] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[186] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[187] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[188] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[189] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[190] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[191] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[192] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[193] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[194] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[195] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[196] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[197] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[198] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[199] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[200] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[201] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[202] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[203] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[204] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[205] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[206] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[207] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[208] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[209] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[210] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[211] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[212] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[213] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[214] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[215] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[216] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[217] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[218] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[219] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[220] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[221] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[222] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[223] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[224] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[225] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[226] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[227] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[228] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|i_tsn_or_tte" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[229] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[230] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[231] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[232] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[233] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[234] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[235] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[236] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[237] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[238] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[239] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[240] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[241] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[242] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[243] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[244] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[245] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[246] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[247] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[248] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[249] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[250] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[251] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[252] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[253] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[254] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[255] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[256] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[257] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[258] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[259] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[260] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[261] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[262] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[263] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[264] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[265] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[266] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[267] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[268] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[269] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[270] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[271] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[272] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[273] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[274] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[275] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[276] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[277] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[278] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[279] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[280] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[281] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[282] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[283] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[284] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[285] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[286] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[287] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[288] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[289] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[290] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[291] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[292] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[293] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[294] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[295] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[296] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[297] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[298] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[299] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[300] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[301] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[302] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[303] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[304] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[305] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[306] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[307] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[308] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[309] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[310] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[311] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[312] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[313] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[314] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[315] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[316] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[317] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[318] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[319] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[320] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[321] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[322] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[323] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[324] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[325] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[326] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[327] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[328] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[329] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[330] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[331] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[332] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[333] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[334] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[335] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[336] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[337] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[338] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[339] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[340] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[341] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[342] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[343] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[344] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[345] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[346] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[347] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[348] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[349] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[350] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[351] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[352] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[353] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[354] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[355] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[356] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[357] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[358] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[359] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[360] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[361] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[362] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[363] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[364] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[365] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[366] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[367] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[368] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[369] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[370] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[371] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[372] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[373] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[374] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[375] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[376] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[377] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[378] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[379] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[380] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[381] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[382] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[383] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[384] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[385] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[386] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[387] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[388] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[389] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|r_syn_cycle_timer" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[390] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[391] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[392] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[393] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[394] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[395] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[396] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[397] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[398] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[399] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[400] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[401] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[402] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[403] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[404] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[405] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[406] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[407] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[408] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[409] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[410] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[411] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[412] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[413] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[414] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[415] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[416] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[417] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[418] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[419] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[420] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[421] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[422] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[423] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[424] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[425] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[426] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[427] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[428] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[429] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[430] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[431] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[432] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[433] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[434] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[435] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[436] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[437] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[438] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[439] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[440] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[441] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[442] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[443] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[444] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[445] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[446] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[447] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[448] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[449] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[450] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[451] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[452] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[453] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[0] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[1] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[2] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[3] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[4] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[5] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[6] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[7] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[8] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[9] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[10] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[11] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[12] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[13] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[14] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[15] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[16] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[17] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[18] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[19] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[20] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[21] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[22] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[23] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[24] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[25] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[26] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[27] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[28] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[29] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[30] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[31] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_cycle_length[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[32] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[33] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[34] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[35] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[36] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[37] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[38] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[39] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[40] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[41] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[42] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[43] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[44] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[45] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[46] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[47] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[48] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[49] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[50] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[51] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[52] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[53] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[54] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[55] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[56] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[57] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[58] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[59] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[60] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[61] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[62] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[63] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[64] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[65] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[66] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[67] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[68] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[69] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[70] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[71] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[72] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[73] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[74] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[75] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[76] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[77] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[78] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[79] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[80] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[81] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[82] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[83] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[84] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[85] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[86] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[87] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[88] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[89] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[90] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[91] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[92] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[93] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[94] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[95] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_oper_base[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[96] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[97] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[98] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[99] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[100] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[101] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[102] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[103] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[104] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[105] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[106] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[107] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[108] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[109] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[110] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[111] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[112] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[113] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[114] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[115] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[116] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[117] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[118] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[119] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[120] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[121] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[122] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[123] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[124] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[125] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[126] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[127] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[128] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[129] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[130] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[131] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[132] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[133] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[134] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[135] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[136] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[137] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[138] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[139] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[140] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[141] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[142] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[143] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[144] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[145] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[146] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[147] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[148] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[149] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[150] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[151] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[152] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[153] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[154] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[155] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[156] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[157] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[158] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[159] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|iv_syn_clk[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[160] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|next_state.CYCLE_IDLE" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[161] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|next_state.SET_CYCLE_STATE_TIME" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[162] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|next_state.START_CYCLE" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[163] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|o_cycle_start" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[164] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[165] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[166] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[167] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[168] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[169] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[170] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[171] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[172] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[173] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[174] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[175] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[176] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[177] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[178] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[179] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[180] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[181] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[182] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[183] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[184] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[185] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[186] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[187] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[188] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[189] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[190] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[191] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[192] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[193] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[194] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[195] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[196] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[197] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[198] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[199] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[200] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[201] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[202] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[203] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[204] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[205] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[206] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[207] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[208] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[209] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[210] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[211] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[212] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[213] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[214] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[215] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[216] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[217] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[218] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[219] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[220] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[221] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[222] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[223] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[224] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[225] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[226] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[227] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|cycle_control:cycle_control_inst|cycle_start_judge:cycle_start_judge_inst|rv_cycle_start_time[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[228] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|i_tsn_or_tte" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[229] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[230] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[231] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[232] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[233] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[234] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[235] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[236] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[237] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[238] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[239] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[240] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[241] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[242] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[243] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[244] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[245] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[246] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[247] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[248] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[249] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[250] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[251] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[252] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[253] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[254] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[255] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[256] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[257] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[258] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[259] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[260] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[261] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[262] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[263] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[264] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[265] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[266] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[267] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[268] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[269] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[270] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[271] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[272] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[273] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[274] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[275] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[276] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[277] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[278] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[279] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[280] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[281] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[282] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[283] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[284] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[285] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[286] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[287] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[288] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[289] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[290] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[291] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[292] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[293] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[294] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[295] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[296] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[297] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[298] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[299] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[300] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[301] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[302] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[303] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[304] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[305] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[306] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[307] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[308] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[309] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[310] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[311] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[312] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[313] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[314] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[315] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[316] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[317] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[318] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[319] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[320] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[321] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[322] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[323] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[324] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|iv_syn_clk_cycle[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[325] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[326] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[327] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[328] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[329] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[330] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[331] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[332] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[333] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[334] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[335] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[336] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[337] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[338] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[339] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[340] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[341] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[342] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[343] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[344] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[345] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[346] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[347] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[348] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[349] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[350] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[351] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[352] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[353] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[354] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[355] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[356] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[357] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[358] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[359] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[360] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[361] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[362] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[363] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[364] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[365] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[366] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[367] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[368] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[369] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[370] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[371] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[372] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[373] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[374] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[375] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[376] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[377] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[378] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[379] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[380] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[381] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[382] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[383] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[384] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[385] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[386] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[387] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[388] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|ov_syn_clk[9]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[389] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|r_syn_cycle_timer" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[390] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[0]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[391] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[10]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[392] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[11]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[393] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[12]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[394] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[13]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[395] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[14]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[396] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[15]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[397] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[16]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[398] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[17]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[399] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[18]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[400] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[19]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[401] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[1]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[402] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[20]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[403] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[21]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[404] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[22]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[405] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[23]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[406] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[24]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[407] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[25]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[408] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[26]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[409] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[27]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[410] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[28]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[411] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[29]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[412] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[2]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[413] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[30]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[414] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[31]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[415] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[32]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[416] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[33]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[417] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[34]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[418] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[35]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[419] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[36]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[420] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[37]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[421] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[38]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[422] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[39]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[423] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[3]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[424] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[40]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[425] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[41]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[426] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[42]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[427] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[43]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[428] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[44]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[429] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[45]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[430] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[46]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[431] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[47]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[432] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[48]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[433] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[49]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[434] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[4]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[435] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[50]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[436] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[51]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[437] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[52]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[438] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[53]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[439] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[54]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[440] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[55]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[441] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[56]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[442] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[57]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[443] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[58]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[444] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[59]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[445] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[5]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[446] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[60]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[447] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[61]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[448] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[62]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[449] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[63]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[450] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[6]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[451] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[7]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[452] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[8]" -section_id CYCLE
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[453] -to "tsnswitch:tsnswitch0_inst|hardware_control_point:hardware_control_point_inst|syn_clk_judge:syn_clk_judge_inst|rv_syn_cycle_offset[9]" -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[0] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[1] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[2] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[3] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[4] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[5] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[6] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[7] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[8] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[9] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[10] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[11] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[12] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[13] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[14] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[15] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[16] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[17] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[18] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[19] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[20] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[21] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[22] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[23] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[24] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[25] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[26] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[27] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[28] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[29] -to CYCLE|vcc -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[30] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[31] -to CYCLE|gnd -section_id CYCLE
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Including default assignments
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON -family "Arria 10"
	set_global_assignment -name TIMING_ANALYZER_REPORT_WORST_CASE_TIMING_PATHS OFF -family "Arria 10"
	set_global_assignment -name TIMING_ANALYZER_CCPP_TRADEOFF_TOLERANCE 0 -family "Arria 10"
	set_global_assignment -name TDC_CCPP_TRADEOFF_TOLERANCE 0 -family "Arria 10"
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON -family "Arria 10"
	set_global_assignment -name DISABLE_LEGACY_TIMING_ANALYZER ON -family "Arria 10"
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON -family "Arria 10"
	set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 3 -family "Arria 10"
	set_global_assignment -name SYNTH_RESOURCE_AWARE_INFERENCE_FOR_BLOCK_RAM ON -family "Arria 10"
	set_global_assignment -name USE_ADVANCED_DETAILED_LAB_LEGALITY ON -family "Arria 10"
	set_global_assignment -name ADVANCED_CLOCK_OPTIMIZATION OFF -family "Arria 10"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS" -family "Arria 10"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON -family "Arria 10"
	set_global_assignment -name PROGRAMMABLE_POWER_TECHNOLOGY_SETTING AUTOMATIC -family "Arria 10"
	set_global_assignment -name AUTO_DELAY_CHAINS ON -family "Arria 10"
	set_global_assignment -name ADVANCED_PHYSICAL_OPTIMIZATION ON -family "Arria 10"
	set_global_assignment -name HYPER_RETIMER OFF -family "Arria 10"
	set_global_assignment -name HYPER_AWARE_OPTIMIZE_REGISTER_CHAINS ON -family "Arria 10"

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
