create_clock -name clk -period 10.000 [get_ports clk]

set_input_delay 2.000 -clock clk [get_ports A]
set_input_delay 2.000 -clock clk [get_ports B]
set_input_delay 2.000 -clock clk [get_ports op]

set_output_delay 2.000 -clock clk [get_ports result]
set_output_delay 2.000 -clock clk [get_ports zero]
set_output_delay 2.000 -clock clk [get_ports carry]

set_false_path -from [get_ports reset]