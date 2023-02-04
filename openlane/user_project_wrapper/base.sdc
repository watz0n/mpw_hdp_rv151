create_clock -name clk -period 100.0 [get_ports {user_clock2}]
create_clock -name sck -period 100.0 [get_ports {io_in[14]}]
create_clock -name ick -period 100.0 [get_ports {io_in[18]}]

set_clock_groups -name grp_clks -physically_exclusive -group { clk } -group { sck } -group { ick }

set_timing_derate -early 0.95
set_timing_derate -late 1.05

set_input_delay  -clock [get_clocks sck] 30.0 -add_delay [get_ports {io_in[15] io_in[13]}]; #//{io_scs io_sdi}]
set_output_delay -clock [get_clocks sck] 30.0 -add_delay [get_ports {io_out[12]}]; #//{io_sdo}]

#set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {gpio_in[*]}]
#set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {gpio_out[*] gpio_oeb[*]}]
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[24]}];
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[25]}];
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[26]}];
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[27]}];
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[28]}];
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[29]}];
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[30]}];
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[31]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[24] io_oeb[24]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[25] io_oeb[25]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[26] io_oeb[26]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[27] io_oeb[27]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[28] io_oeb[28]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[29] io_oeb[29]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[30] io_oeb[30]}];
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[31] io_oeb[31]}];

set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[23]}]; #//{serial_in}]
set_output_delay -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_out[22]}]; #//{serial_out}]
set_input_delay  -clock [get_clocks clk] 30.0 -add_delay [get_ports {io_in[17]}]; #//{io_cslt}]

#set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {gpio_in[*]}]
#set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {gpio_out[*] gpio_oeb[*]}]
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[24]}];
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[25]}];
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[26]}];
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[27]}];
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[28]}];
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[29]}];
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[30]}];
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[31]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[24] io_oeb[24]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[25] io_oeb[25]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[26] io_oeb[26]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[27] io_oeb[27]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[28] io_oeb[28]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[29] io_oeb[29]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[30] io_oeb[30]}];
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[31] io_oeb[31]}];

set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[23]}]; #//{serial_in}]
set_output_delay -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_out[22]}]; #//{serial_out}]
set_input_delay  -clock [get_clocks ick] 15.0 -add_delay [get_ports {io_in[17]}]; #//{io_cslt}]