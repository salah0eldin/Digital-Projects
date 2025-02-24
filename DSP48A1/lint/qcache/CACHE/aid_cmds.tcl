# 
# Questa Static Verification System
# Version 2021.1 4558100 win64 28-Jan-2021

clear settings -all
clear directives
#configure output directory  D:/Learning/DigitalKareem/Projects/DSP48A1/lint
clear settings  -lib
#configure output directory  D:/Learning/DigitalKareem/Projects/DSP48A1/lint
#clear directives 
#configure output directory  D:/Learning/DigitalKareem/Projects/DSP48A1/lint
#clear directives 
lint on clk_port_conn_complex 
lint on clock_signal_as_non_clock 
lint on flop_with_inverted_clock 
lint on bus_bit_as_clk 
lint on clock_in_wait_stmt 
lint on async_reset_active_high 
lint on flop_redundant 
lint on long_combinational_path 
lint on module_has_blackbox_instance 
lint on re_entrant_output 
lint on mux_select_const 
lint on blackbox_input_conn_inconsistent 
lint on blackbox_output_control_signal 
lint on inout_port_exists 
lint on input_port_set 
lint on port_conn_is_expression 
lint on comment_has_control_char 
lint on comment_not_in_english 
lint on parameter_name_duplicate 
lint on flop_async_reset_const 
lint on reset_port_connection_static 
lint on reset_set_non_const_assign 
lint on reset_set_with_both_polarity 
lint on assign_chain 
lint on signal_with_negative_value 
lint on data_event_has_edge 
lint on delay_in_non_flop_expr 
lint on condition_const 
lint on condition_has_assign 
lint on condition_is_multi_bit 
lint on logical_not_on_multi_bit 
lint on logical_operator_on_multi_bit 
lint on gen_loop_index_not_int 
lint on loop_index_in_multi_always_blocks 
lint on loop_var_not_in_condition 
lint on loop_var_not_in_init 
lint on synth_pragma_prefix_missing 
lint on while_loop_iteration_limit 
lint on module_with_duplicate_ports 
lint on module_with_null_port 
lint on multi_ports_in_single_line 
lint on parameter_count_large 
lint on sensitivity_list_edge_multi_bit 
lint on sensitivity_list_operator_unexpected 
lint on sensitivity_list_signal_repeated 
lint on assign_with_multi_arith_operations 
lint on unsynth_dc_shell_script 
lint on always_exceeds_line_limit 
lint on always_signal_assign_large 
lint on always_without_event 
lint on bus_bits_in_multi_seq_blocks 
lint on case_with_memory_output 
lint on concurrent_block_with_duplicate_assign 
lint on conversion_to_stdlogicvector_invalid 
lint on data_type_std_ulogic 
lint on empty_module 
lint on enum_decl_invalid 
lint on flop_output_in_initial 
lint on func_expr_input_size_mismatch 
lint on gen_inst_label_duplicate 
lint on gen_label_duplicate 
lint on if_stmt_shares_arithmetic_operator 
lint on if_with_memory_output 
lint on inferred_blackbox 
lint on inst_param_width_overflow 
lint on line_char_large 
lint on memory_not_set 
lint on memory_redefined 
lint on part_select_illegal 
lint on pragma_coverage_off_nested 
lint on pragma_translate_off_nested 
lint on pragma_translate_on_nested 
lint on process_exceeds_line_limit 
lint on process_signal_assign_large 
lint on process_var_assign_disorder 
lint on reference_event_without_edge 
lint on seq_block_has_duplicate_assign 
lint on shared_variable_in_multi_process 
lint on signal_assign_in_multi_initial 
lint on string_has_control_char 
lint on sync_read_as_async 
lint on synopsys_attribute 
lint on tristate_not_at_top_level 
lint on unresolved_module 
lint on user_blackbox 
lint on var_read_before_set 
lint on var_read_not_set 
lint on assign_width_overflow 
lint on inst_port_width_mismatch 
lint on sensitivity_list_var_modified 
lint on casez_has_x 
lint on index_x_z 
lint on std_logic_vector_without_range 
lint on assigns_mixed 
lint on assigns_mixed_in_always_block 
lint on combo_loop_with_latch 
lint on multi_driven_signal 
lint on synth_pragma_prefix_invalid 
lint on task_has_event_and_input 
lint on task_has_event_and_output 
lint report check -severity info always_exceeds_line_limit 
lint report check -severity info always_signal_assign_large 
lint report check -severity error always_without_event 
lint report check -severity warning assign_chain 
lint report check -severity info assign_width_overflow 
lint report check -severity warning assign_with_multi_arith_operations 
lint report check -severity info assigns_mixed 
lint report check -severity info assigns_mixed_in_always_block 
lint report check -severity info async_reset_active_high 
lint report check -severity warning blackbox_input_conn_inconsistent 
lint report check -severity info blackbox_output_control_signal 
lint report check -severity warning bus_bit_as_clk 
lint report check -severity warning bus_bits_in_multi_seq_blocks 
lint report check -severity warning case_with_memory_output 
lint report check -severity info casez_has_x 
lint report check -severity warning clk_port_conn_complex 
lint report check -severity warning clock_in_wait_stmt 
lint report check -severity warning clock_signal_as_non_clock 
lint report check -severity warning combo_loop_with_latch 
lint report check -severity info comment_has_control_char 
lint report check -severity info comment_not_in_english 
lint report check -severity warning concurrent_block_with_duplicate_assign 
lint report check -severity info condition_const 
lint report check -severity error condition_has_assign 
lint report check -severity error condition_is_multi_bit 
lint report check -severity info conversion_to_stdlogicvector_invalid 
lint report check -severity warning data_event_has_edge 
lint report check -severity info data_type_std_ulogic 
lint report check -severity info delay_in_non_flop_expr 
lint report check -severity warning empty_module 
lint report check -severity info enum_decl_invalid 
lint report check -severity info flop_async_reset_const 
lint report check -severity warning flop_output_in_initial 
lint report check -severity info flop_redundant 
lint report check -severity info flop_with_inverted_clock 
lint report check -severity warning func_expr_input_size_mismatch 
lint report check -severity error gen_inst_label_duplicate 
lint report check -severity error gen_label_duplicate 
lint report check -severity warning gen_loop_index_not_int 
lint report check -severity warning if_stmt_shares_arithmetic_operator 
lint report check -severity warning if_with_memory_output 
lint report check -severity error index_x_z 
lint report check -severity warning inferred_blackbox 
lint report check -severity info inout_port_exists 
lint report check -severity error input_port_set 
lint report check -severity warning inst_param_width_overflow 
lint report check -severity error inst_port_width_mismatch 
lint report check -severity info line_char_large 
lint report check -severity info logical_not_on_multi_bit 
lint report check -severity info logical_operator_on_multi_bit 
lint report check -severity warning long_combinational_path 
lint report check -severity info loop_index_in_multi_always_blocks 
lint report check -severity info loop_var_not_in_condition 
lint report check -severity info loop_var_not_in_init 
lint report check -severity warning memory_not_set 
lint report check -severity warning memory_redefined 
lint report check -severity info module_has_blackbox_instance 
lint report check -severity warning module_with_duplicate_ports 
lint report check -severity warning module_with_null_port 
lint report check -severity warning multi_driven_signal 
lint report check -severity info multi_ports_in_single_line 
lint report check -severity warning mux_select_const 
lint report check -severity info parameter_count_large 
lint report check -severity info parameter_name_duplicate 
lint report check -severity error part_select_illegal 
lint report check -severity info port_conn_is_expression 
lint report check -severity warning pragma_coverage_off_nested 
lint report check -severity warning pragma_translate_off_nested 
lint report check -severity warning pragma_translate_on_nested 
lint report check -severity warning process_exceeds_line_limit 
lint report check -severity warning process_signal_assign_large 
lint report check -severity warning process_var_assign_disorder 
lint report check -severity info re_entrant_output 
lint report check -severity warning reference_event_without_edge 
lint report check -severity info reset_port_connection_static 
lint report check -severity warning reset_set_non_const_assign 
lint report check -severity warning reset_set_with_both_polarity 
lint report check -severity error sensitivity_list_edge_multi_bit 
lint report check -severity error sensitivity_list_operator_unexpected 
lint report check -severity info sensitivity_list_signal_repeated 
lint report check -severity error sensitivity_list_var_modified 
lint report check -severity warning seq_block_has_duplicate_assign 
lint report check -severity warning shared_variable_in_multi_process 
lint report check -severity warning signal_assign_in_multi_initial 
lint report check -severity warning signal_with_negative_value 
lint report check -severity warning std_logic_vector_without_range 
lint report check -severity warning string_has_control_char 
lint report check -severity warning sync_read_as_async 
lint report check -severity info synopsys_attribute 
lint report check -severity warning synth_pragma_prefix_invalid 
lint report check -severity warning synth_pragma_prefix_missing 
lint report check -severity info task_has_event_and_input 
lint report check -severity info task_has_event_and_output 
lint report check -severity warning tristate_not_at_top_level 
lint report check -severity warning unresolved_module 
lint report check -severity warning unsynth_dc_shell_script 
lint report check -severity info user_blackbox 
lint report check -severity warning var_read_before_set 
lint report check -severity error var_read_not_set 
lint report check -severity warning while_loop_iteration_limit 
lint methodology soc -goal start 
lint run -d DSP48A1 -L work
