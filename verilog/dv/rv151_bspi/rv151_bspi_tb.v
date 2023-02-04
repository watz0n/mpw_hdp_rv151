// MIT License
// -----------
// 
// Copyright (c) 2023 Watson Huang (watson.edx@gmail.com)
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// -----------
// SPDX-License-Identifier: MIT

`default_nettype none

`timescale 1 ns / 1 ps

`include "opcode.vh"

`ifdef GL
	//direct call instance
`else
	`define MEM_BM0 uut.mprj.rv151.soc.bios_mem0
	`define MEM_DM0 uut.mprj.rv151.soc.dmem0
	`define MEM_IM0 uut.mprj.rv151.soc.imem0
`endif

module tb_rf();
  reg [31:0] mem [0:31];
endmodule

module rv151_bspi_tb;
	reg clock;
	reg RSTB;
	reg CSB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;
	wire [7:0] mprj_io_0;

	assign mprj_io_0 = mprj_io[7:0];
	// assign mprj_io_0 = {mprj_io[8:4],mprj_io[2:0]};

	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	// assign mprj_io[3] = 1'b1;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	parameter CLK_CYCLE=100.0;

	always #(CLK_CYCLE/2) clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	`ifdef ENABLE_SDF
		initial begin
			$sdf_annotate("../../../sdf/user_project_wrapper.sdf", uut.mprj) ;
			$sdf_annotate("../../../mgmt_core_wrapper/sdf/DFFRAM.sdf", uut.soc.DFFRAM_0) ;
			$sdf_annotate("../../../mgmt_core_wrapper/sdf/mgmt_core.sdf", uut.soc.core) ;
			$sdf_annotate("../../../caravel/sdf/housekeeping.sdf", uut.housekeeping) ;
			$sdf_annotate("../../../caravel/sdf/chip_io.sdf", uut.padframe) ;
			$sdf_annotate("../../../caravel/sdf/mprj_logic_high.sdf", uut.mgmt_buffers.mprj_logic_high_inst) ;
			$sdf_annotate("../../../caravel/sdf/mprj2_logic_high.sdf", uut.mgmt_buffers.mprj2_logic_high_inst) ;
			$sdf_annotate("../../../caravel/sdf/mgmt_protect_hv.sdf", uut.mgmt_buffers.powergood_check) ;
			$sdf_annotate("../../../caravel/sdf/mgmt_protect.sdf", uut.mgmt_buffers) ;
			$sdf_annotate("../../../caravel/sdf/caravel_clocking.sdf", uut.clocking) ;
			$sdf_annotate("../../../caravel/sdf/digital_pll.sdf", uut.pll) ;
			$sdf_annotate("../../../caravel/sdf/xres_buf.sdf", uut.rstb_level) ;
			$sdf_annotate("../../../caravel/sdf/user_id_programming.sdf", uut.user_id_value) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[3] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[4] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[5] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[6] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[7] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[8] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[9] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[10] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[3] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[4] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[5] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[3] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[4] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[5] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[6] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[7] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[8] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[9] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[10] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[11] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[12] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[13] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[14] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[15] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_5) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_6) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_7) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_8) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_9) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_10) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_11) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_12) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_13) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_14) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_15) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_16) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_17) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_18) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_19) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_20) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_21) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_22) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_23) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_24) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_25) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_26) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_27) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_28) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_29) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_30) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_31) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_32) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_33) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_34) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_35) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_36) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_37) ;
		end
	`endif 

	initial begin
		$dumpfile("rv151_bspi.vcd");
		$dumpvars(0, rv151_bspi_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (2) begin
			repeat (1000) @(posedge clock);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test Mega-Project IO Ports (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end
	
//=======================================================================================

	tb_rf RF();

`ifdef GL

	//FLATTEN
	always@(*) begin
		RF.mem[1]  = {uut.mprj.\rv151.soc.rf.mem[1][31] ,uut.mprj.\rv151.soc.rf.mem[1][30] ,uut.mprj.\rv151.soc.rf.mem[1][29] ,uut.mprj.\rv151.soc.rf.mem[1][28] , 
					  uut.mprj.\rv151.soc.rf.mem[1][27] ,uut.mprj.\rv151.soc.rf.mem[1][26] ,uut.mprj.\rv151.soc.rf.mem[1][25] ,uut.mprj.\rv151.soc.rf.mem[1][24] , 
					  uut.mprj.\rv151.soc.rf.mem[1][23] ,uut.mprj.\rv151.soc.rf.mem[1][22] ,uut.mprj.\rv151.soc.rf.mem[1][21] ,uut.mprj.\rv151.soc.rf.mem[1][20] , 
					  uut.mprj.\rv151.soc.rf.mem[1][19] ,uut.mprj.\rv151.soc.rf.mem[1][18] ,uut.mprj.\rv151.soc.rf.mem[1][17] ,uut.mprj.\rv151.soc.rf.mem[1][16] , 
					  uut.mprj.\rv151.soc.rf.mem[1][15] ,uut.mprj.\rv151.soc.rf.mem[1][14] ,uut.mprj.\rv151.soc.rf.mem[1][13] ,uut.mprj.\rv151.soc.rf.mem[1][12] , 
					  uut.mprj.\rv151.soc.rf.mem[1][11] ,uut.mprj.\rv151.soc.rf.mem[1][10] ,uut.mprj.\rv151.soc.rf.mem[1][9]  ,uut.mprj.\rv151.soc.rf.mem[1][8] , 
					  uut.mprj.\rv151.soc.rf.mem[1][7]  ,uut.mprj.\rv151.soc.rf.mem[1][6]  ,uut.mprj.\rv151.soc.rf.mem[1][5]  ,uut.mprj.\rv151.soc.rf.mem[1][4] , 
					  uut.mprj.\rv151.soc.rf.mem[1][3]  ,uut.mprj.\rv151.soc.rf.mem[1][2]  ,uut.mprj.\rv151.soc.rf.mem[1][1]  ,uut.mprj.\rv151.soc.rf.mem[1][0] } ;
		RF.mem[2]  = {uut.mprj.\rv151.soc.rf.mem[2][31] ,uut.mprj.\rv151.soc.rf.mem[2][30] ,uut.mprj.\rv151.soc.rf.mem[2][29] ,uut.mprj.\rv151.soc.rf.mem[2][28] , 
					  uut.mprj.\rv151.soc.rf.mem[2][27] ,uut.mprj.\rv151.soc.rf.mem[2][26] ,uut.mprj.\rv151.soc.rf.mem[2][25] ,uut.mprj.\rv151.soc.rf.mem[2][24] , 
					  uut.mprj.\rv151.soc.rf.mem[2][23] ,uut.mprj.\rv151.soc.rf.mem[2][22] ,uut.mprj.\rv151.soc.rf.mem[2][21] ,uut.mprj.\rv151.soc.rf.mem[2][20] , 
					  uut.mprj.\rv151.soc.rf.mem[2][19] ,uut.mprj.\rv151.soc.rf.mem[2][18] ,uut.mprj.\rv151.soc.rf.mem[2][17] ,uut.mprj.\rv151.soc.rf.mem[2][16] , 
					  uut.mprj.\rv151.soc.rf.mem[2][15] ,uut.mprj.\rv151.soc.rf.mem[2][14] ,uut.mprj.\rv151.soc.rf.mem[2][13] ,uut.mprj.\rv151.soc.rf.mem[2][12] , 
					  uut.mprj.\rv151.soc.rf.mem[2][11] ,uut.mprj.\rv151.soc.rf.mem[2][10] ,uut.mprj.\rv151.soc.rf.mem[2][9]  ,uut.mprj.\rv151.soc.rf.mem[2][8] , 
					  uut.mprj.\rv151.soc.rf.mem[2][7]  ,uut.mprj.\rv151.soc.rf.mem[2][6]  ,uut.mprj.\rv151.soc.rf.mem[2][5]  ,uut.mprj.\rv151.soc.rf.mem[2][4] , 
					  uut.mprj.\rv151.soc.rf.mem[2][3]  ,uut.mprj.\rv151.soc.rf.mem[2][2]  ,uut.mprj.\rv151.soc.rf.mem[2][1]  ,uut.mprj.\rv151.soc.rf.mem[2][0] } ;
		RF.mem[3]  = {uut.mprj.\rv151.soc.rf.mem[3][31] ,uut.mprj.\rv151.soc.rf.mem[3][30] ,uut.mprj.\rv151.soc.rf.mem[3][29] ,uut.mprj.\rv151.soc.rf.mem[3][28] , 
					  uut.mprj.\rv151.soc.rf.mem[3][27] ,uut.mprj.\rv151.soc.rf.mem[3][26] ,uut.mprj.\rv151.soc.rf.mem[3][25] ,uut.mprj.\rv151.soc.rf.mem[3][24] , 
					  uut.mprj.\rv151.soc.rf.mem[3][23] ,uut.mprj.\rv151.soc.rf.mem[3][22] ,uut.mprj.\rv151.soc.rf.mem[3][21] ,uut.mprj.\rv151.soc.rf.mem[3][20] , 
					  uut.mprj.\rv151.soc.rf.mem[3][19] ,uut.mprj.\rv151.soc.rf.mem[3][18] ,uut.mprj.\rv151.soc.rf.mem[3][17] ,uut.mprj.\rv151.soc.rf.mem[3][16] , 
					  uut.mprj.\rv151.soc.rf.mem[3][15] ,uut.mprj.\rv151.soc.rf.mem[3][14] ,uut.mprj.\rv151.soc.rf.mem[3][13] ,uut.mprj.\rv151.soc.rf.mem[3][12] , 
					  uut.mprj.\rv151.soc.rf.mem[3][11] ,uut.mprj.\rv151.soc.rf.mem[3][10] ,uut.mprj.\rv151.soc.rf.mem[3][9]  ,uut.mprj.\rv151.soc.rf.mem[3][8] , 
					  uut.mprj.\rv151.soc.rf.mem[3][7]  ,uut.mprj.\rv151.soc.rf.mem[3][6]  ,uut.mprj.\rv151.soc.rf.mem[3][5]  ,uut.mprj.\rv151.soc.rf.mem[3][4] , 
					  uut.mprj.\rv151.soc.rf.mem[3][3]  ,uut.mprj.\rv151.soc.rf.mem[3][2]  ,uut.mprj.\rv151.soc.rf.mem[3][1]  ,uut.mprj.\rv151.soc.rf.mem[3][0] } ;
		RF.mem[4]  = {uut.mprj.\rv151.soc.rf.mem[4][31] ,uut.mprj.\rv151.soc.rf.mem[4][30] ,uut.mprj.\rv151.soc.rf.mem[4][29] ,uut.mprj.\rv151.soc.rf.mem[4][28] , 
					  uut.mprj.\rv151.soc.rf.mem[4][27] ,uut.mprj.\rv151.soc.rf.mem[4][26] ,uut.mprj.\rv151.soc.rf.mem[4][25] ,uut.mprj.\rv151.soc.rf.mem[4][24] , 
					  uut.mprj.\rv151.soc.rf.mem[4][23] ,uut.mprj.\rv151.soc.rf.mem[4][22] ,uut.mprj.\rv151.soc.rf.mem[4][21] ,uut.mprj.\rv151.soc.rf.mem[4][20] , 
					  uut.mprj.\rv151.soc.rf.mem[4][19] ,uut.mprj.\rv151.soc.rf.mem[4][18] ,uut.mprj.\rv151.soc.rf.mem[4][17] ,uut.mprj.\rv151.soc.rf.mem[4][16] , 
					  uut.mprj.\rv151.soc.rf.mem[4][15] ,uut.mprj.\rv151.soc.rf.mem[4][14] ,uut.mprj.\rv151.soc.rf.mem[4][13] ,uut.mprj.\rv151.soc.rf.mem[4][12] , 
					  uut.mprj.\rv151.soc.rf.mem[4][11] ,uut.mprj.\rv151.soc.rf.mem[4][10] ,uut.mprj.\rv151.soc.rf.mem[4][9]  ,uut.mprj.\rv151.soc.rf.mem[4][8] , 
					  uut.mprj.\rv151.soc.rf.mem[4][7]  ,uut.mprj.\rv151.soc.rf.mem[4][6]  ,uut.mprj.\rv151.soc.rf.mem[4][5]  ,uut.mprj.\rv151.soc.rf.mem[4][4] , 
					  uut.mprj.\rv151.soc.rf.mem[4][3]  ,uut.mprj.\rv151.soc.rf.mem[4][2]  ,uut.mprj.\rv151.soc.rf.mem[4][1]  ,uut.mprj.\rv151.soc.rf.mem[4][0] } ;
		RF.mem[5]  = {uut.mprj.\rv151.soc.rf.mem[5][31] ,uut.mprj.\rv151.soc.rf.mem[5][30] ,uut.mprj.\rv151.soc.rf.mem[5][29] ,uut.mprj.\rv151.soc.rf.mem[5][28] , 
					  uut.mprj.\rv151.soc.rf.mem[5][27] ,uut.mprj.\rv151.soc.rf.mem[5][26] ,uut.mprj.\rv151.soc.rf.mem[5][25] ,uut.mprj.\rv151.soc.rf.mem[5][24] , 
					  uut.mprj.\rv151.soc.rf.mem[5][23] ,uut.mprj.\rv151.soc.rf.mem[5][22] ,uut.mprj.\rv151.soc.rf.mem[5][21] ,uut.mprj.\rv151.soc.rf.mem[5][20] , 
					  uut.mprj.\rv151.soc.rf.mem[5][19] ,uut.mprj.\rv151.soc.rf.mem[5][18] ,uut.mprj.\rv151.soc.rf.mem[5][17] ,uut.mprj.\rv151.soc.rf.mem[5][16] , 
					  uut.mprj.\rv151.soc.rf.mem[5][15] ,uut.mprj.\rv151.soc.rf.mem[5][14] ,uut.mprj.\rv151.soc.rf.mem[5][13] ,uut.mprj.\rv151.soc.rf.mem[5][12] , 
					  uut.mprj.\rv151.soc.rf.mem[5][11] ,uut.mprj.\rv151.soc.rf.mem[5][10] ,uut.mprj.\rv151.soc.rf.mem[5][9]  ,uut.mprj.\rv151.soc.rf.mem[5][8] , 
					  uut.mprj.\rv151.soc.rf.mem[5][7]  ,uut.mprj.\rv151.soc.rf.mem[5][6]  ,uut.mprj.\rv151.soc.rf.mem[5][5]  ,uut.mprj.\rv151.soc.rf.mem[5][4] , 
					  uut.mprj.\rv151.soc.rf.mem[5][3]  ,uut.mprj.\rv151.soc.rf.mem[5][2]  ,uut.mprj.\rv151.soc.rf.mem[5][1]  ,uut.mprj.\rv151.soc.rf.mem[5][0] } ;
		RF.mem[6]  = {uut.mprj.\rv151.soc.rf.mem[6][31] ,uut.mprj.\rv151.soc.rf.mem[6][30] ,uut.mprj.\rv151.soc.rf.mem[6][29] ,uut.mprj.\rv151.soc.rf.mem[6][28] , 
					  uut.mprj.\rv151.soc.rf.mem[6][27] ,uut.mprj.\rv151.soc.rf.mem[6][26] ,uut.mprj.\rv151.soc.rf.mem[6][25] ,uut.mprj.\rv151.soc.rf.mem[6][24] , 
					  uut.mprj.\rv151.soc.rf.mem[6][23] ,uut.mprj.\rv151.soc.rf.mem[6][22] ,uut.mprj.\rv151.soc.rf.mem[6][21] ,uut.mprj.\rv151.soc.rf.mem[6][20] , 
					  uut.mprj.\rv151.soc.rf.mem[6][19] ,uut.mprj.\rv151.soc.rf.mem[6][18] ,uut.mprj.\rv151.soc.rf.mem[6][17] ,uut.mprj.\rv151.soc.rf.mem[6][16] , 
					  uut.mprj.\rv151.soc.rf.mem[6][15] ,uut.mprj.\rv151.soc.rf.mem[6][14] ,uut.mprj.\rv151.soc.rf.mem[6][13] ,uut.mprj.\rv151.soc.rf.mem[6][12] , 
					  uut.mprj.\rv151.soc.rf.mem[6][11] ,uut.mprj.\rv151.soc.rf.mem[6][10] ,uut.mprj.\rv151.soc.rf.mem[6][9]  ,uut.mprj.\rv151.soc.rf.mem[6][8] , 
					  uut.mprj.\rv151.soc.rf.mem[6][7]  ,uut.mprj.\rv151.soc.rf.mem[6][6]  ,uut.mprj.\rv151.soc.rf.mem[6][5]  ,uut.mprj.\rv151.soc.rf.mem[6][4] , 
					  uut.mprj.\rv151.soc.rf.mem[6][3]  ,uut.mprj.\rv151.soc.rf.mem[6][2]  ,uut.mprj.\rv151.soc.rf.mem[6][1]  ,uut.mprj.\rv151.soc.rf.mem[6][0] } ;
		RF.mem[7]  = {uut.mprj.\rv151.soc.rf.mem[7][31] ,uut.mprj.\rv151.soc.rf.mem[7][30] ,uut.mprj.\rv151.soc.rf.mem[7][29] ,uut.mprj.\rv151.soc.rf.mem[7][28] , 
					  uut.mprj.\rv151.soc.rf.mem[7][27] ,uut.mprj.\rv151.soc.rf.mem[7][26] ,uut.mprj.\rv151.soc.rf.mem[7][25] ,uut.mprj.\rv151.soc.rf.mem[7][24] , 
					  uut.mprj.\rv151.soc.rf.mem[7][23] ,uut.mprj.\rv151.soc.rf.mem[7][22] ,uut.mprj.\rv151.soc.rf.mem[7][21] ,uut.mprj.\rv151.soc.rf.mem[7][20] , 
					  uut.mprj.\rv151.soc.rf.mem[7][19] ,uut.mprj.\rv151.soc.rf.mem[7][18] ,uut.mprj.\rv151.soc.rf.mem[7][17] ,uut.mprj.\rv151.soc.rf.mem[7][16] , 
					  uut.mprj.\rv151.soc.rf.mem[7][15] ,uut.mprj.\rv151.soc.rf.mem[7][14] ,uut.mprj.\rv151.soc.rf.mem[7][13] ,uut.mprj.\rv151.soc.rf.mem[7][12] , 
					  uut.mprj.\rv151.soc.rf.mem[7][11] ,uut.mprj.\rv151.soc.rf.mem[7][10] ,uut.mprj.\rv151.soc.rf.mem[7][9]  ,uut.mprj.\rv151.soc.rf.mem[7][8] , 
					  uut.mprj.\rv151.soc.rf.mem[7][7]  ,uut.mprj.\rv151.soc.rf.mem[7][6]  ,uut.mprj.\rv151.soc.rf.mem[7][5]  ,uut.mprj.\rv151.soc.rf.mem[7][4] , 
					  uut.mprj.\rv151.soc.rf.mem[7][3]  ,uut.mprj.\rv151.soc.rf.mem[7][2]  ,uut.mprj.\rv151.soc.rf.mem[7][1]  ,uut.mprj.\rv151.soc.rf.mem[7][0] } ;
		RF.mem[8]  = {uut.mprj.\rv151.soc.rf.mem[8][31] ,uut.mprj.\rv151.soc.rf.mem[8][30] ,uut.mprj.\rv151.soc.rf.mem[8][29] ,uut.mprj.\rv151.soc.rf.mem[8][28] , 
					  uut.mprj.\rv151.soc.rf.mem[8][27] ,uut.mprj.\rv151.soc.rf.mem[8][26] ,uut.mprj.\rv151.soc.rf.mem[8][25] ,uut.mprj.\rv151.soc.rf.mem[8][24] , 
					  uut.mprj.\rv151.soc.rf.mem[8][23] ,uut.mprj.\rv151.soc.rf.mem[8][22] ,uut.mprj.\rv151.soc.rf.mem[8][21] ,uut.mprj.\rv151.soc.rf.mem[8][20] , 
					  uut.mprj.\rv151.soc.rf.mem[8][19] ,uut.mprj.\rv151.soc.rf.mem[8][18] ,uut.mprj.\rv151.soc.rf.mem[8][17] ,uut.mprj.\rv151.soc.rf.mem[8][16] , 
					  uut.mprj.\rv151.soc.rf.mem[8][15] ,uut.mprj.\rv151.soc.rf.mem[8][14] ,uut.mprj.\rv151.soc.rf.mem[8][13] ,uut.mprj.\rv151.soc.rf.mem[8][12] , 
					  uut.mprj.\rv151.soc.rf.mem[8][11] ,uut.mprj.\rv151.soc.rf.mem[8][10] ,uut.mprj.\rv151.soc.rf.mem[8][9]  ,uut.mprj.\rv151.soc.rf.mem[8][8] , 
					  uut.mprj.\rv151.soc.rf.mem[8][7]  ,uut.mprj.\rv151.soc.rf.mem[8][6]  ,uut.mprj.\rv151.soc.rf.mem[8][5]  ,uut.mprj.\rv151.soc.rf.mem[8][4] , 
					  uut.mprj.\rv151.soc.rf.mem[8][3]  ,uut.mprj.\rv151.soc.rf.mem[8][2]  ,uut.mprj.\rv151.soc.rf.mem[8][1]  ,uut.mprj.\rv151.soc.rf.mem[8][0] } ;
		RF.mem[9]  = {uut.mprj.\rv151.soc.rf.mem[9][31] ,uut.mprj.\rv151.soc.rf.mem[9][30] ,uut.mprj.\rv151.soc.rf.mem[9][29] ,uut.mprj.\rv151.soc.rf.mem[9][28] , 
					  uut.mprj.\rv151.soc.rf.mem[9][27] ,uut.mprj.\rv151.soc.rf.mem[9][26] ,uut.mprj.\rv151.soc.rf.mem[9][25] ,uut.mprj.\rv151.soc.rf.mem[9][24] , 
					  uut.mprj.\rv151.soc.rf.mem[9][23] ,uut.mprj.\rv151.soc.rf.mem[9][22] ,uut.mprj.\rv151.soc.rf.mem[9][21] ,uut.mprj.\rv151.soc.rf.mem[9][20] , 
					  uut.mprj.\rv151.soc.rf.mem[9][19] ,uut.mprj.\rv151.soc.rf.mem[9][18] ,uut.mprj.\rv151.soc.rf.mem[9][17] ,uut.mprj.\rv151.soc.rf.mem[9][16] , 
					  uut.mprj.\rv151.soc.rf.mem[9][15] ,uut.mprj.\rv151.soc.rf.mem[9][14] ,uut.mprj.\rv151.soc.rf.mem[9][13] ,uut.mprj.\rv151.soc.rf.mem[9][12] , 
					  uut.mprj.\rv151.soc.rf.mem[9][11] ,uut.mprj.\rv151.soc.rf.mem[9][10] ,uut.mprj.\rv151.soc.rf.mem[9][9]  ,uut.mprj.\rv151.soc.rf.mem[9][8] , 
					  uut.mprj.\rv151.soc.rf.mem[9][7]  ,uut.mprj.\rv151.soc.rf.mem[9][6]  ,uut.mprj.\rv151.soc.rf.mem[9][5]  ,uut.mprj.\rv151.soc.rf.mem[9][4] , 
					  uut.mprj.\rv151.soc.rf.mem[9][3]  ,uut.mprj.\rv151.soc.rf.mem[9][2]  ,uut.mprj.\rv151.soc.rf.mem[9][1]  ,uut.mprj.\rv151.soc.rf.mem[9][0] } ;
		RF.mem[10]  = {uut.mprj.\rv151.soc.rf.mem[10][31] ,uut.mprj.\rv151.soc.rf.mem[10][30] ,uut.mprj.\rv151.soc.rf.mem[10][29] ,uut.mprj.\rv151.soc.rf.mem[10][28] , 
					  uut.mprj.\rv151.soc.rf.mem[10][27] ,uut.mprj.\rv151.soc.rf.mem[10][26] ,uut.mprj.\rv151.soc.rf.mem[10][25] ,uut.mprj.\rv151.soc.rf.mem[10][24] , 
					  uut.mprj.\rv151.soc.rf.mem[10][23] ,uut.mprj.\rv151.soc.rf.mem[10][22] ,uut.mprj.\rv151.soc.rf.mem[10][21] ,uut.mprj.\rv151.soc.rf.mem[10][20] , 
					  uut.mprj.\rv151.soc.rf.mem[10][19] ,uut.mprj.\rv151.soc.rf.mem[10][18] ,uut.mprj.\rv151.soc.rf.mem[10][17] ,uut.mprj.\rv151.soc.rf.mem[10][16] , 
					  uut.mprj.\rv151.soc.rf.mem[10][15] ,uut.mprj.\rv151.soc.rf.mem[10][14] ,uut.mprj.\rv151.soc.rf.mem[10][13] ,uut.mprj.\rv151.soc.rf.mem[10][12] , 
					  uut.mprj.\rv151.soc.rf.mem[10][11] ,uut.mprj.\rv151.soc.rf.mem[10][10] ,uut.mprj.\rv151.soc.rf.mem[10][9]  ,uut.mprj.\rv151.soc.rf.mem[10][8] , 
					  uut.mprj.\rv151.soc.rf.mem[10][7]  ,uut.mprj.\rv151.soc.rf.mem[10][6]  ,uut.mprj.\rv151.soc.rf.mem[10][5]  ,uut.mprj.\rv151.soc.rf.mem[10][4] , 
					  uut.mprj.\rv151.soc.rf.mem[10][3]  ,uut.mprj.\rv151.soc.rf.mem[10][2]  ,uut.mprj.\rv151.soc.rf.mem[10][1]  ,uut.mprj.\rv151.soc.rf.mem[10][0] } ;
		RF.mem[11]  = {uut.mprj.\rv151.soc.rf.mem[11][31] ,uut.mprj.\rv151.soc.rf.mem[11][30] ,uut.mprj.\rv151.soc.rf.mem[11][29] ,uut.mprj.\rv151.soc.rf.mem[11][28] , 
					  uut.mprj.\rv151.soc.rf.mem[11][27] ,uut.mprj.\rv151.soc.rf.mem[11][26] ,uut.mprj.\rv151.soc.rf.mem[11][25] ,uut.mprj.\rv151.soc.rf.mem[11][24] , 
					  uut.mprj.\rv151.soc.rf.mem[11][23] ,uut.mprj.\rv151.soc.rf.mem[11][22] ,uut.mprj.\rv151.soc.rf.mem[11][21] ,uut.mprj.\rv151.soc.rf.mem[11][20] , 
					  uut.mprj.\rv151.soc.rf.mem[11][19] ,uut.mprj.\rv151.soc.rf.mem[11][18] ,uut.mprj.\rv151.soc.rf.mem[11][17] ,uut.mprj.\rv151.soc.rf.mem[11][16] , 
					  uut.mprj.\rv151.soc.rf.mem[11][15] ,uut.mprj.\rv151.soc.rf.mem[11][14] ,uut.mprj.\rv151.soc.rf.mem[11][13] ,uut.mprj.\rv151.soc.rf.mem[11][12] , 
					  uut.mprj.\rv151.soc.rf.mem[11][11] ,uut.mprj.\rv151.soc.rf.mem[11][10] ,uut.mprj.\rv151.soc.rf.mem[11][9]  ,uut.mprj.\rv151.soc.rf.mem[11][8] , 
					  uut.mprj.\rv151.soc.rf.mem[11][7]  ,uut.mprj.\rv151.soc.rf.mem[11][6]  ,uut.mprj.\rv151.soc.rf.mem[11][5]  ,uut.mprj.\rv151.soc.rf.mem[11][4] , 
					  uut.mprj.\rv151.soc.rf.mem[11][3]  ,uut.mprj.\rv151.soc.rf.mem[11][2]  ,uut.mprj.\rv151.soc.rf.mem[11][1]  ,uut.mprj.\rv151.soc.rf.mem[11][0] } ;
		RF.mem[12]  = {uut.mprj.\rv151.soc.rf.mem[12][31] ,uut.mprj.\rv151.soc.rf.mem[12][30] ,uut.mprj.\rv151.soc.rf.mem[12][29] ,uut.mprj.\rv151.soc.rf.mem[12][28] , 
					  uut.mprj.\rv151.soc.rf.mem[12][27] ,uut.mprj.\rv151.soc.rf.mem[12][26] ,uut.mprj.\rv151.soc.rf.mem[12][25] ,uut.mprj.\rv151.soc.rf.mem[12][24] , 
					  uut.mprj.\rv151.soc.rf.mem[12][23] ,uut.mprj.\rv151.soc.rf.mem[12][22] ,uut.mprj.\rv151.soc.rf.mem[12][21] ,uut.mprj.\rv151.soc.rf.mem[12][20] , 
					  uut.mprj.\rv151.soc.rf.mem[12][19] ,uut.mprj.\rv151.soc.rf.mem[12][18] ,uut.mprj.\rv151.soc.rf.mem[12][17] ,uut.mprj.\rv151.soc.rf.mem[12][16] , 
					  uut.mprj.\rv151.soc.rf.mem[12][15] ,uut.mprj.\rv151.soc.rf.mem[12][14] ,uut.mprj.\rv151.soc.rf.mem[12][13] ,uut.mprj.\rv151.soc.rf.mem[12][12] , 
					  uut.mprj.\rv151.soc.rf.mem[12][11] ,uut.mprj.\rv151.soc.rf.mem[12][10] ,uut.mprj.\rv151.soc.rf.mem[12][9]  ,uut.mprj.\rv151.soc.rf.mem[12][8] , 
					  uut.mprj.\rv151.soc.rf.mem[12][7]  ,uut.mprj.\rv151.soc.rf.mem[12][6]  ,uut.mprj.\rv151.soc.rf.mem[12][5]  ,uut.mprj.\rv151.soc.rf.mem[12][4] , 
					  uut.mprj.\rv151.soc.rf.mem[12][3]  ,uut.mprj.\rv151.soc.rf.mem[12][2]  ,uut.mprj.\rv151.soc.rf.mem[12][1]  ,uut.mprj.\rv151.soc.rf.mem[12][0] } ;
		RF.mem[13]  = {uut.mprj.\rv151.soc.rf.mem[13][31] ,uut.mprj.\rv151.soc.rf.mem[13][30] ,uut.mprj.\rv151.soc.rf.mem[13][29] ,uut.mprj.\rv151.soc.rf.mem[13][28] , 
					  uut.mprj.\rv151.soc.rf.mem[13][27] ,uut.mprj.\rv151.soc.rf.mem[13][26] ,uut.mprj.\rv151.soc.rf.mem[13][25] ,uut.mprj.\rv151.soc.rf.mem[13][24] , 
					  uut.mprj.\rv151.soc.rf.mem[13][23] ,uut.mprj.\rv151.soc.rf.mem[13][22] ,uut.mprj.\rv151.soc.rf.mem[13][21] ,uut.mprj.\rv151.soc.rf.mem[13][20] , 
					  uut.mprj.\rv151.soc.rf.mem[13][19] ,uut.mprj.\rv151.soc.rf.mem[13][18] ,uut.mprj.\rv151.soc.rf.mem[13][17] ,uut.mprj.\rv151.soc.rf.mem[13][16] , 
					  uut.mprj.\rv151.soc.rf.mem[13][15] ,uut.mprj.\rv151.soc.rf.mem[13][14] ,uut.mprj.\rv151.soc.rf.mem[13][13] ,uut.mprj.\rv151.soc.rf.mem[13][12] , 
					  uut.mprj.\rv151.soc.rf.mem[13][11] ,uut.mprj.\rv151.soc.rf.mem[13][10] ,uut.mprj.\rv151.soc.rf.mem[13][9]  ,uut.mprj.\rv151.soc.rf.mem[13][8] , 
					  uut.mprj.\rv151.soc.rf.mem[13][7]  ,uut.mprj.\rv151.soc.rf.mem[13][6]  ,uut.mprj.\rv151.soc.rf.mem[13][5]  ,uut.mprj.\rv151.soc.rf.mem[13][4] , 
					  uut.mprj.\rv151.soc.rf.mem[13][3]  ,uut.mprj.\rv151.soc.rf.mem[13][2]  ,uut.mprj.\rv151.soc.rf.mem[13][1]  ,uut.mprj.\rv151.soc.rf.mem[13][0] } ;
		RF.mem[14]  = {uut.mprj.\rv151.soc.rf.mem[14][31] ,uut.mprj.\rv151.soc.rf.mem[14][30] ,uut.mprj.\rv151.soc.rf.mem[14][29] ,uut.mprj.\rv151.soc.rf.mem[14][28] , 
					  uut.mprj.\rv151.soc.rf.mem[14][27] ,uut.mprj.\rv151.soc.rf.mem[14][26] ,uut.mprj.\rv151.soc.rf.mem[14][25] ,uut.mprj.\rv151.soc.rf.mem[14][24] , 
					  uut.mprj.\rv151.soc.rf.mem[14][23] ,uut.mprj.\rv151.soc.rf.mem[14][22] ,uut.mprj.\rv151.soc.rf.mem[14][21] ,uut.mprj.\rv151.soc.rf.mem[14][20] , 
					  uut.mprj.\rv151.soc.rf.mem[14][19] ,uut.mprj.\rv151.soc.rf.mem[14][18] ,uut.mprj.\rv151.soc.rf.mem[14][17] ,uut.mprj.\rv151.soc.rf.mem[14][16] , 
					  uut.mprj.\rv151.soc.rf.mem[14][15] ,uut.mprj.\rv151.soc.rf.mem[14][14] ,uut.mprj.\rv151.soc.rf.mem[14][13] ,uut.mprj.\rv151.soc.rf.mem[14][12] , 
					  uut.mprj.\rv151.soc.rf.mem[14][11] ,uut.mprj.\rv151.soc.rf.mem[14][10] ,uut.mprj.\rv151.soc.rf.mem[14][9]  ,uut.mprj.\rv151.soc.rf.mem[14][8] , 
					  uut.mprj.\rv151.soc.rf.mem[14][7]  ,uut.mprj.\rv151.soc.rf.mem[14][6]  ,uut.mprj.\rv151.soc.rf.mem[14][5]  ,uut.mprj.\rv151.soc.rf.mem[14][4] , 
					  uut.mprj.\rv151.soc.rf.mem[14][3]  ,uut.mprj.\rv151.soc.rf.mem[14][2]  ,uut.mprj.\rv151.soc.rf.mem[14][1]  ,uut.mprj.\rv151.soc.rf.mem[14][0] } ;
		RF.mem[15]  = {uut.mprj.\rv151.soc.rf.mem[15][31] ,uut.mprj.\rv151.soc.rf.mem[15][30] ,uut.mprj.\rv151.soc.rf.mem[15][29] ,uut.mprj.\rv151.soc.rf.mem[15][28] , 
					  uut.mprj.\rv151.soc.rf.mem[15][27] ,uut.mprj.\rv151.soc.rf.mem[15][26] ,uut.mprj.\rv151.soc.rf.mem[15][25] ,uut.mprj.\rv151.soc.rf.mem[15][24] , 
					  uut.mprj.\rv151.soc.rf.mem[15][23] ,uut.mprj.\rv151.soc.rf.mem[15][22] ,uut.mprj.\rv151.soc.rf.mem[15][21] ,uut.mprj.\rv151.soc.rf.mem[15][20] , 
					  uut.mprj.\rv151.soc.rf.mem[15][19] ,uut.mprj.\rv151.soc.rf.mem[15][18] ,uut.mprj.\rv151.soc.rf.mem[15][17] ,uut.mprj.\rv151.soc.rf.mem[15][16] , 
					  uut.mprj.\rv151.soc.rf.mem[15][15] ,uut.mprj.\rv151.soc.rf.mem[15][14] ,uut.mprj.\rv151.soc.rf.mem[15][13] ,uut.mprj.\rv151.soc.rf.mem[15][12] , 
					  uut.mprj.\rv151.soc.rf.mem[15][11] ,uut.mprj.\rv151.soc.rf.mem[15][10] ,uut.mprj.\rv151.soc.rf.mem[15][9]  ,uut.mprj.\rv151.soc.rf.mem[15][8] , 
					  uut.mprj.\rv151.soc.rf.mem[15][7]  ,uut.mprj.\rv151.soc.rf.mem[15][6]  ,uut.mprj.\rv151.soc.rf.mem[15][5]  ,uut.mprj.\rv151.soc.rf.mem[15][4] , 
					  uut.mprj.\rv151.soc.rf.mem[15][3]  ,uut.mprj.\rv151.soc.rf.mem[15][2]  ,uut.mprj.\rv151.soc.rf.mem[15][1]  ,uut.mprj.\rv151.soc.rf.mem[15][0] } ;
		RF.mem[16]  = {uut.mprj.\rv151.soc.rf.mem[16][31] ,uut.mprj.\rv151.soc.rf.mem[16][30] ,uut.mprj.\rv151.soc.rf.mem[16][29] ,uut.mprj.\rv151.soc.rf.mem[16][28] , 
					  uut.mprj.\rv151.soc.rf.mem[16][27] ,uut.mprj.\rv151.soc.rf.mem[16][26] ,uut.mprj.\rv151.soc.rf.mem[16][25] ,uut.mprj.\rv151.soc.rf.mem[16][24] , 
					  uut.mprj.\rv151.soc.rf.mem[16][23] ,uut.mprj.\rv151.soc.rf.mem[16][22] ,uut.mprj.\rv151.soc.rf.mem[16][21] ,uut.mprj.\rv151.soc.rf.mem[16][20] , 
					  uut.mprj.\rv151.soc.rf.mem[16][19] ,uut.mprj.\rv151.soc.rf.mem[16][18] ,uut.mprj.\rv151.soc.rf.mem[16][17] ,uut.mprj.\rv151.soc.rf.mem[16][16] , 
					  uut.mprj.\rv151.soc.rf.mem[16][15] ,uut.mprj.\rv151.soc.rf.mem[16][14] ,uut.mprj.\rv151.soc.rf.mem[16][13] ,uut.mprj.\rv151.soc.rf.mem[16][12] , 
					  uut.mprj.\rv151.soc.rf.mem[16][11] ,uut.mprj.\rv151.soc.rf.mem[16][10] ,uut.mprj.\rv151.soc.rf.mem[16][9]  ,uut.mprj.\rv151.soc.rf.mem[16][8] , 
					  uut.mprj.\rv151.soc.rf.mem[16][7]  ,uut.mprj.\rv151.soc.rf.mem[16][6]  ,uut.mprj.\rv151.soc.rf.mem[16][5]  ,uut.mprj.\rv151.soc.rf.mem[16][4] , 
					  uut.mprj.\rv151.soc.rf.mem[16][3]  ,uut.mprj.\rv151.soc.rf.mem[16][2]  ,uut.mprj.\rv151.soc.rf.mem[16][1]  ,uut.mprj.\rv151.soc.rf.mem[16][0] } ;
		RF.mem[17]  = {uut.mprj.\rv151.soc.rf.mem[17][31] ,uut.mprj.\rv151.soc.rf.mem[17][30] ,uut.mprj.\rv151.soc.rf.mem[17][29] ,uut.mprj.\rv151.soc.rf.mem[17][28] , 
					  uut.mprj.\rv151.soc.rf.mem[17][27] ,uut.mprj.\rv151.soc.rf.mem[17][26] ,uut.mprj.\rv151.soc.rf.mem[17][25] ,uut.mprj.\rv151.soc.rf.mem[17][24] , 
					  uut.mprj.\rv151.soc.rf.mem[17][23] ,uut.mprj.\rv151.soc.rf.mem[17][22] ,uut.mprj.\rv151.soc.rf.mem[17][21] ,uut.mprj.\rv151.soc.rf.mem[17][20] , 
					  uut.mprj.\rv151.soc.rf.mem[17][19] ,uut.mprj.\rv151.soc.rf.mem[17][18] ,uut.mprj.\rv151.soc.rf.mem[17][17] ,uut.mprj.\rv151.soc.rf.mem[17][16] , 
					  uut.mprj.\rv151.soc.rf.mem[17][15] ,uut.mprj.\rv151.soc.rf.mem[17][14] ,uut.mprj.\rv151.soc.rf.mem[17][13] ,uut.mprj.\rv151.soc.rf.mem[17][12] , 
					  uut.mprj.\rv151.soc.rf.mem[17][11] ,uut.mprj.\rv151.soc.rf.mem[17][10] ,uut.mprj.\rv151.soc.rf.mem[17][9]  ,uut.mprj.\rv151.soc.rf.mem[17][8] , 
					  uut.mprj.\rv151.soc.rf.mem[17][7]  ,uut.mprj.\rv151.soc.rf.mem[17][6]  ,uut.mprj.\rv151.soc.rf.mem[17][5]  ,uut.mprj.\rv151.soc.rf.mem[17][4] , 
					  uut.mprj.\rv151.soc.rf.mem[17][3]  ,uut.mprj.\rv151.soc.rf.mem[17][2]  ,uut.mprj.\rv151.soc.rf.mem[17][1]  ,uut.mprj.\rv151.soc.rf.mem[17][0] } ;
		RF.mem[18]  = {uut.mprj.\rv151.soc.rf.mem[18][31] ,uut.mprj.\rv151.soc.rf.mem[18][30] ,uut.mprj.\rv151.soc.rf.mem[18][29] ,uut.mprj.\rv151.soc.rf.mem[18][28] , 
					  uut.mprj.\rv151.soc.rf.mem[18][27] ,uut.mprj.\rv151.soc.rf.mem[18][26] ,uut.mprj.\rv151.soc.rf.mem[18][25] ,uut.mprj.\rv151.soc.rf.mem[18][24] , 
					  uut.mprj.\rv151.soc.rf.mem[18][23] ,uut.mprj.\rv151.soc.rf.mem[18][22] ,uut.mprj.\rv151.soc.rf.mem[18][21] ,uut.mprj.\rv151.soc.rf.mem[18][20] , 
					  uut.mprj.\rv151.soc.rf.mem[18][19] ,uut.mprj.\rv151.soc.rf.mem[18][18] ,uut.mprj.\rv151.soc.rf.mem[18][17] ,uut.mprj.\rv151.soc.rf.mem[18][16] , 
					  uut.mprj.\rv151.soc.rf.mem[18][15] ,uut.mprj.\rv151.soc.rf.mem[18][14] ,uut.mprj.\rv151.soc.rf.mem[18][13] ,uut.mprj.\rv151.soc.rf.mem[18][12] , 
					  uut.mprj.\rv151.soc.rf.mem[18][11] ,uut.mprj.\rv151.soc.rf.mem[18][10] ,uut.mprj.\rv151.soc.rf.mem[18][9]  ,uut.mprj.\rv151.soc.rf.mem[18][8] , 
					  uut.mprj.\rv151.soc.rf.mem[18][7]  ,uut.mprj.\rv151.soc.rf.mem[18][6]  ,uut.mprj.\rv151.soc.rf.mem[18][5]  ,uut.mprj.\rv151.soc.rf.mem[18][4] , 
					  uut.mprj.\rv151.soc.rf.mem[18][3]  ,uut.mprj.\rv151.soc.rf.mem[18][2]  ,uut.mprj.\rv151.soc.rf.mem[18][1]  ,uut.mprj.\rv151.soc.rf.mem[18][0] } ;
		RF.mem[19]  = {uut.mprj.\rv151.soc.rf.mem[19][31] ,uut.mprj.\rv151.soc.rf.mem[19][30] ,uut.mprj.\rv151.soc.rf.mem[19][29] ,uut.mprj.\rv151.soc.rf.mem[19][28] , 
					  uut.mprj.\rv151.soc.rf.mem[19][27] ,uut.mprj.\rv151.soc.rf.mem[19][26] ,uut.mprj.\rv151.soc.rf.mem[19][25] ,uut.mprj.\rv151.soc.rf.mem[19][24] , 
					  uut.mprj.\rv151.soc.rf.mem[19][23] ,uut.mprj.\rv151.soc.rf.mem[19][22] ,uut.mprj.\rv151.soc.rf.mem[19][21] ,uut.mprj.\rv151.soc.rf.mem[19][20] , 
					  uut.mprj.\rv151.soc.rf.mem[19][19] ,uut.mprj.\rv151.soc.rf.mem[19][18] ,uut.mprj.\rv151.soc.rf.mem[19][17] ,uut.mprj.\rv151.soc.rf.mem[19][16] , 
					  uut.mprj.\rv151.soc.rf.mem[19][15] ,uut.mprj.\rv151.soc.rf.mem[19][14] ,uut.mprj.\rv151.soc.rf.mem[19][13] ,uut.mprj.\rv151.soc.rf.mem[19][12] , 
					  uut.mprj.\rv151.soc.rf.mem[19][11] ,uut.mprj.\rv151.soc.rf.mem[19][10] ,uut.mprj.\rv151.soc.rf.mem[19][9]  ,uut.mprj.\rv151.soc.rf.mem[19][8] , 
					  uut.mprj.\rv151.soc.rf.mem[19][7]  ,uut.mprj.\rv151.soc.rf.mem[19][6]  ,uut.mprj.\rv151.soc.rf.mem[19][5]  ,uut.mprj.\rv151.soc.rf.mem[19][4] , 
					  uut.mprj.\rv151.soc.rf.mem[19][3]  ,uut.mprj.\rv151.soc.rf.mem[19][2]  ,uut.mprj.\rv151.soc.rf.mem[19][1]  ,uut.mprj.\rv151.soc.rf.mem[19][0] } ;
		RF.mem[20]  = {uut.mprj.\rv151.soc.rf.mem[20][31] ,uut.mprj.\rv151.soc.rf.mem[20][30] ,uut.mprj.\rv151.soc.rf.mem[20][29] ,uut.mprj.\rv151.soc.rf.mem[20][28] , 
					  uut.mprj.\rv151.soc.rf.mem[20][27] ,uut.mprj.\rv151.soc.rf.mem[20][26] ,uut.mprj.\rv151.soc.rf.mem[20][25] ,uut.mprj.\rv151.soc.rf.mem[20][24] , 
					  uut.mprj.\rv151.soc.rf.mem[20][23] ,uut.mprj.\rv151.soc.rf.mem[20][22] ,uut.mprj.\rv151.soc.rf.mem[20][21] ,uut.mprj.\rv151.soc.rf.mem[20][20] , 
					  uut.mprj.\rv151.soc.rf.mem[20][19] ,uut.mprj.\rv151.soc.rf.mem[20][18] ,uut.mprj.\rv151.soc.rf.mem[20][17] ,uut.mprj.\rv151.soc.rf.mem[20][16] , 
					  uut.mprj.\rv151.soc.rf.mem[20][15] ,uut.mprj.\rv151.soc.rf.mem[20][14] ,uut.mprj.\rv151.soc.rf.mem[20][13] ,uut.mprj.\rv151.soc.rf.mem[20][12] , 
					  uut.mprj.\rv151.soc.rf.mem[20][11] ,uut.mprj.\rv151.soc.rf.mem[20][10] ,uut.mprj.\rv151.soc.rf.mem[20][9]  ,uut.mprj.\rv151.soc.rf.mem[20][8] , 
					  uut.mprj.\rv151.soc.rf.mem[20][7]  ,uut.mprj.\rv151.soc.rf.mem[20][6]  ,uut.mprj.\rv151.soc.rf.mem[20][5]  ,uut.mprj.\rv151.soc.rf.mem[20][4] , 
					  uut.mprj.\rv151.soc.rf.mem[20][3]  ,uut.mprj.\rv151.soc.rf.mem[20][2]  ,uut.mprj.\rv151.soc.rf.mem[20][1]  ,uut.mprj.\rv151.soc.rf.mem[20][0] } ;
		RF.mem[21]  = {uut.mprj.\rv151.soc.rf.mem[21][31] ,uut.mprj.\rv151.soc.rf.mem[21][30] ,uut.mprj.\rv151.soc.rf.mem[21][29] ,uut.mprj.\rv151.soc.rf.mem[21][28] , 
					  uut.mprj.\rv151.soc.rf.mem[21][27] ,uut.mprj.\rv151.soc.rf.mem[21][26] ,uut.mprj.\rv151.soc.rf.mem[21][25] ,uut.mprj.\rv151.soc.rf.mem[21][24] , 
					  uut.mprj.\rv151.soc.rf.mem[21][23] ,uut.mprj.\rv151.soc.rf.mem[21][22] ,uut.mprj.\rv151.soc.rf.mem[21][21] ,uut.mprj.\rv151.soc.rf.mem[21][20] , 
					  uut.mprj.\rv151.soc.rf.mem[21][19] ,uut.mprj.\rv151.soc.rf.mem[21][18] ,uut.mprj.\rv151.soc.rf.mem[21][17] ,uut.mprj.\rv151.soc.rf.mem[21][16] , 
					  uut.mprj.\rv151.soc.rf.mem[21][15] ,uut.mprj.\rv151.soc.rf.mem[21][14] ,uut.mprj.\rv151.soc.rf.mem[21][13] ,uut.mprj.\rv151.soc.rf.mem[21][12] , 
					  uut.mprj.\rv151.soc.rf.mem[21][11] ,uut.mprj.\rv151.soc.rf.mem[21][10] ,uut.mprj.\rv151.soc.rf.mem[21][9]  ,uut.mprj.\rv151.soc.rf.mem[21][8] , 
					  uut.mprj.\rv151.soc.rf.mem[21][7]  ,uut.mprj.\rv151.soc.rf.mem[21][6]  ,uut.mprj.\rv151.soc.rf.mem[21][5]  ,uut.mprj.\rv151.soc.rf.mem[21][4] , 
					  uut.mprj.\rv151.soc.rf.mem[21][3]  ,uut.mprj.\rv151.soc.rf.mem[21][2]  ,uut.mprj.\rv151.soc.rf.mem[21][1]  ,uut.mprj.\rv151.soc.rf.mem[21][0] } ;
		RF.mem[22]  = {uut.mprj.\rv151.soc.rf.mem[22][31] ,uut.mprj.\rv151.soc.rf.mem[22][30] ,uut.mprj.\rv151.soc.rf.mem[22][29] ,uut.mprj.\rv151.soc.rf.mem[22][28] , 
					  uut.mprj.\rv151.soc.rf.mem[22][27] ,uut.mprj.\rv151.soc.rf.mem[22][26] ,uut.mprj.\rv151.soc.rf.mem[22][25] ,uut.mprj.\rv151.soc.rf.mem[22][24] , 
					  uut.mprj.\rv151.soc.rf.mem[22][23] ,uut.mprj.\rv151.soc.rf.mem[22][22] ,uut.mprj.\rv151.soc.rf.mem[22][21] ,uut.mprj.\rv151.soc.rf.mem[22][20] , 
					  uut.mprj.\rv151.soc.rf.mem[22][19] ,uut.mprj.\rv151.soc.rf.mem[22][18] ,uut.mprj.\rv151.soc.rf.mem[22][17] ,uut.mprj.\rv151.soc.rf.mem[22][16] , 
					  uut.mprj.\rv151.soc.rf.mem[22][15] ,uut.mprj.\rv151.soc.rf.mem[22][14] ,uut.mprj.\rv151.soc.rf.mem[22][13] ,uut.mprj.\rv151.soc.rf.mem[22][12] , 
					  uut.mprj.\rv151.soc.rf.mem[22][11] ,uut.mprj.\rv151.soc.rf.mem[22][10] ,uut.mprj.\rv151.soc.rf.mem[22][9]  ,uut.mprj.\rv151.soc.rf.mem[22][8] , 
					  uut.mprj.\rv151.soc.rf.mem[22][7]  ,uut.mprj.\rv151.soc.rf.mem[22][6]  ,uut.mprj.\rv151.soc.rf.mem[22][5]  ,uut.mprj.\rv151.soc.rf.mem[22][4] , 
					  uut.mprj.\rv151.soc.rf.mem[22][3]  ,uut.mprj.\rv151.soc.rf.mem[22][2]  ,uut.mprj.\rv151.soc.rf.mem[22][1]  ,uut.mprj.\rv151.soc.rf.mem[22][0] } ;
		RF.mem[23]  = {uut.mprj.\rv151.soc.rf.mem[23][31] ,uut.mprj.\rv151.soc.rf.mem[23][30] ,uut.mprj.\rv151.soc.rf.mem[23][29] ,uut.mprj.\rv151.soc.rf.mem[23][28] , 
					  uut.mprj.\rv151.soc.rf.mem[23][27] ,uut.mprj.\rv151.soc.rf.mem[23][26] ,uut.mprj.\rv151.soc.rf.mem[23][25] ,uut.mprj.\rv151.soc.rf.mem[23][24] , 
					  uut.mprj.\rv151.soc.rf.mem[23][23] ,uut.mprj.\rv151.soc.rf.mem[23][22] ,uut.mprj.\rv151.soc.rf.mem[23][21] ,uut.mprj.\rv151.soc.rf.mem[23][20] , 
					  uut.mprj.\rv151.soc.rf.mem[23][19] ,uut.mprj.\rv151.soc.rf.mem[23][18] ,uut.mprj.\rv151.soc.rf.mem[23][17] ,uut.mprj.\rv151.soc.rf.mem[23][16] , 
					  uut.mprj.\rv151.soc.rf.mem[23][15] ,uut.mprj.\rv151.soc.rf.mem[23][14] ,uut.mprj.\rv151.soc.rf.mem[23][13] ,uut.mprj.\rv151.soc.rf.mem[23][12] , 
					  uut.mprj.\rv151.soc.rf.mem[23][11] ,uut.mprj.\rv151.soc.rf.mem[23][10] ,uut.mprj.\rv151.soc.rf.mem[23][9]  ,uut.mprj.\rv151.soc.rf.mem[23][8] , 
					  uut.mprj.\rv151.soc.rf.mem[23][7]  ,uut.mprj.\rv151.soc.rf.mem[23][6]  ,uut.mprj.\rv151.soc.rf.mem[23][5]  ,uut.mprj.\rv151.soc.rf.mem[23][4] , 
					  uut.mprj.\rv151.soc.rf.mem[23][3]  ,uut.mprj.\rv151.soc.rf.mem[23][2]  ,uut.mprj.\rv151.soc.rf.mem[23][1]  ,uut.mprj.\rv151.soc.rf.mem[23][0] } ;
		RF.mem[24]  = {uut.mprj.\rv151.soc.rf.mem[24][31] ,uut.mprj.\rv151.soc.rf.mem[24][30] ,uut.mprj.\rv151.soc.rf.mem[24][29] ,uut.mprj.\rv151.soc.rf.mem[24][28] , 
					  uut.mprj.\rv151.soc.rf.mem[24][27] ,uut.mprj.\rv151.soc.rf.mem[24][26] ,uut.mprj.\rv151.soc.rf.mem[24][25] ,uut.mprj.\rv151.soc.rf.mem[24][24] , 
					  uut.mprj.\rv151.soc.rf.mem[24][23] ,uut.mprj.\rv151.soc.rf.mem[24][22] ,uut.mprj.\rv151.soc.rf.mem[24][21] ,uut.mprj.\rv151.soc.rf.mem[24][20] , 
					  uut.mprj.\rv151.soc.rf.mem[24][19] ,uut.mprj.\rv151.soc.rf.mem[24][18] ,uut.mprj.\rv151.soc.rf.mem[24][17] ,uut.mprj.\rv151.soc.rf.mem[24][16] , 
					  uut.mprj.\rv151.soc.rf.mem[24][15] ,uut.mprj.\rv151.soc.rf.mem[24][14] ,uut.mprj.\rv151.soc.rf.mem[24][13] ,uut.mprj.\rv151.soc.rf.mem[24][12] , 
					  uut.mprj.\rv151.soc.rf.mem[24][11] ,uut.mprj.\rv151.soc.rf.mem[24][10] ,uut.mprj.\rv151.soc.rf.mem[24][9]  ,uut.mprj.\rv151.soc.rf.mem[24][8] , 
					  uut.mprj.\rv151.soc.rf.mem[24][7]  ,uut.mprj.\rv151.soc.rf.mem[24][6]  ,uut.mprj.\rv151.soc.rf.mem[24][5]  ,uut.mprj.\rv151.soc.rf.mem[24][4] , 
					  uut.mprj.\rv151.soc.rf.mem[24][3]  ,uut.mprj.\rv151.soc.rf.mem[24][2]  ,uut.mprj.\rv151.soc.rf.mem[24][1]  ,uut.mprj.\rv151.soc.rf.mem[24][0] } ;
		RF.mem[25]  = {uut.mprj.\rv151.soc.rf.mem[25][31] ,uut.mprj.\rv151.soc.rf.mem[25][30] ,uut.mprj.\rv151.soc.rf.mem[25][29] ,uut.mprj.\rv151.soc.rf.mem[25][28] , 
					  uut.mprj.\rv151.soc.rf.mem[25][27] ,uut.mprj.\rv151.soc.rf.mem[25][26] ,uut.mprj.\rv151.soc.rf.mem[25][25] ,uut.mprj.\rv151.soc.rf.mem[25][24] , 
					  uut.mprj.\rv151.soc.rf.mem[25][23] ,uut.mprj.\rv151.soc.rf.mem[25][22] ,uut.mprj.\rv151.soc.rf.mem[25][21] ,uut.mprj.\rv151.soc.rf.mem[25][20] , 
					  uut.mprj.\rv151.soc.rf.mem[25][19] ,uut.mprj.\rv151.soc.rf.mem[25][18] ,uut.mprj.\rv151.soc.rf.mem[25][17] ,uut.mprj.\rv151.soc.rf.mem[25][16] , 
					  uut.mprj.\rv151.soc.rf.mem[25][15] ,uut.mprj.\rv151.soc.rf.mem[25][14] ,uut.mprj.\rv151.soc.rf.mem[25][13] ,uut.mprj.\rv151.soc.rf.mem[25][12] , 
					  uut.mprj.\rv151.soc.rf.mem[25][11] ,uut.mprj.\rv151.soc.rf.mem[25][10] ,uut.mprj.\rv151.soc.rf.mem[25][9]  ,uut.mprj.\rv151.soc.rf.mem[25][8] , 
					  uut.mprj.\rv151.soc.rf.mem[25][7]  ,uut.mprj.\rv151.soc.rf.mem[25][6]  ,uut.mprj.\rv151.soc.rf.mem[25][5]  ,uut.mprj.\rv151.soc.rf.mem[25][4] , 
					  uut.mprj.\rv151.soc.rf.mem[25][3]  ,uut.mprj.\rv151.soc.rf.mem[25][2]  ,uut.mprj.\rv151.soc.rf.mem[25][1]  ,uut.mprj.\rv151.soc.rf.mem[25][0] } ;
		RF.mem[26]  = {uut.mprj.\rv151.soc.rf.mem[26][31] ,uut.mprj.\rv151.soc.rf.mem[26][30] ,uut.mprj.\rv151.soc.rf.mem[26][29] ,uut.mprj.\rv151.soc.rf.mem[26][28] , 
					  uut.mprj.\rv151.soc.rf.mem[26][27] ,uut.mprj.\rv151.soc.rf.mem[26][26] ,uut.mprj.\rv151.soc.rf.mem[26][25] ,uut.mprj.\rv151.soc.rf.mem[26][24] , 
					  uut.mprj.\rv151.soc.rf.mem[26][23] ,uut.mprj.\rv151.soc.rf.mem[26][22] ,uut.mprj.\rv151.soc.rf.mem[26][21] ,uut.mprj.\rv151.soc.rf.mem[26][20] , 
					  uut.mprj.\rv151.soc.rf.mem[26][19] ,uut.mprj.\rv151.soc.rf.mem[26][18] ,uut.mprj.\rv151.soc.rf.mem[26][17] ,uut.mprj.\rv151.soc.rf.mem[26][16] , 
					  uut.mprj.\rv151.soc.rf.mem[26][15] ,uut.mprj.\rv151.soc.rf.mem[26][14] ,uut.mprj.\rv151.soc.rf.mem[26][13] ,uut.mprj.\rv151.soc.rf.mem[26][12] , 
					  uut.mprj.\rv151.soc.rf.mem[26][11] ,uut.mprj.\rv151.soc.rf.mem[26][10] ,uut.mprj.\rv151.soc.rf.mem[26][9]  ,uut.mprj.\rv151.soc.rf.mem[26][8] , 
					  uut.mprj.\rv151.soc.rf.mem[26][7]  ,uut.mprj.\rv151.soc.rf.mem[26][6]  ,uut.mprj.\rv151.soc.rf.mem[26][5]  ,uut.mprj.\rv151.soc.rf.mem[26][4] , 
					  uut.mprj.\rv151.soc.rf.mem[26][3]  ,uut.mprj.\rv151.soc.rf.mem[26][2]  ,uut.mprj.\rv151.soc.rf.mem[26][1]  ,uut.mprj.\rv151.soc.rf.mem[26][0] } ;
		RF.mem[27]  = {uut.mprj.\rv151.soc.rf.mem[27][31] ,uut.mprj.\rv151.soc.rf.mem[27][30] ,uut.mprj.\rv151.soc.rf.mem[27][29] ,uut.mprj.\rv151.soc.rf.mem[27][28] , 
					  uut.mprj.\rv151.soc.rf.mem[27][27] ,uut.mprj.\rv151.soc.rf.mem[27][26] ,uut.mprj.\rv151.soc.rf.mem[27][25] ,uut.mprj.\rv151.soc.rf.mem[27][24] , 
					  uut.mprj.\rv151.soc.rf.mem[27][23] ,uut.mprj.\rv151.soc.rf.mem[27][22] ,uut.mprj.\rv151.soc.rf.mem[27][21] ,uut.mprj.\rv151.soc.rf.mem[27][20] , 
					  uut.mprj.\rv151.soc.rf.mem[27][19] ,uut.mprj.\rv151.soc.rf.mem[27][18] ,uut.mprj.\rv151.soc.rf.mem[27][17] ,uut.mprj.\rv151.soc.rf.mem[27][16] , 
					  uut.mprj.\rv151.soc.rf.mem[27][15] ,uut.mprj.\rv151.soc.rf.mem[27][14] ,uut.mprj.\rv151.soc.rf.mem[27][13] ,uut.mprj.\rv151.soc.rf.mem[27][12] , 
					  uut.mprj.\rv151.soc.rf.mem[27][11] ,uut.mprj.\rv151.soc.rf.mem[27][10] ,uut.mprj.\rv151.soc.rf.mem[27][9]  ,uut.mprj.\rv151.soc.rf.mem[27][8] , 
					  uut.mprj.\rv151.soc.rf.mem[27][7]  ,uut.mprj.\rv151.soc.rf.mem[27][6]  ,uut.mprj.\rv151.soc.rf.mem[27][5]  ,uut.mprj.\rv151.soc.rf.mem[27][4] , 
					  uut.mprj.\rv151.soc.rf.mem[27][3]  ,uut.mprj.\rv151.soc.rf.mem[27][2]  ,uut.mprj.\rv151.soc.rf.mem[27][1]  ,uut.mprj.\rv151.soc.rf.mem[27][0] } ;
		RF.mem[28]  = {uut.mprj.\rv151.soc.rf.mem[28][31] ,uut.mprj.\rv151.soc.rf.mem[28][30] ,uut.mprj.\rv151.soc.rf.mem[28][29] ,uut.mprj.\rv151.soc.rf.mem[28][28] , 
					  uut.mprj.\rv151.soc.rf.mem[28][27] ,uut.mprj.\rv151.soc.rf.mem[28][26] ,uut.mprj.\rv151.soc.rf.mem[28][25] ,uut.mprj.\rv151.soc.rf.mem[28][24] , 
					  uut.mprj.\rv151.soc.rf.mem[28][23] ,uut.mprj.\rv151.soc.rf.mem[28][22] ,uut.mprj.\rv151.soc.rf.mem[28][21] ,uut.mprj.\rv151.soc.rf.mem[28][20] , 
					  uut.mprj.\rv151.soc.rf.mem[28][19] ,uut.mprj.\rv151.soc.rf.mem[28][18] ,uut.mprj.\rv151.soc.rf.mem[28][17] ,uut.mprj.\rv151.soc.rf.mem[28][16] , 
					  uut.mprj.\rv151.soc.rf.mem[28][15] ,uut.mprj.\rv151.soc.rf.mem[28][14] ,uut.mprj.\rv151.soc.rf.mem[28][13] ,uut.mprj.\rv151.soc.rf.mem[28][12] , 
					  uut.mprj.\rv151.soc.rf.mem[28][11] ,uut.mprj.\rv151.soc.rf.mem[28][10] ,uut.mprj.\rv151.soc.rf.mem[28][9]  ,uut.mprj.\rv151.soc.rf.mem[28][8] , 
					  uut.mprj.\rv151.soc.rf.mem[28][7]  ,uut.mprj.\rv151.soc.rf.mem[28][6]  ,uut.mprj.\rv151.soc.rf.mem[28][5]  ,uut.mprj.\rv151.soc.rf.mem[28][4] , 
					  uut.mprj.\rv151.soc.rf.mem[28][3]  ,uut.mprj.\rv151.soc.rf.mem[28][2]  ,uut.mprj.\rv151.soc.rf.mem[28][1]  ,uut.mprj.\rv151.soc.rf.mem[28][0] } ;
		RF.mem[29]  = {uut.mprj.\rv151.soc.rf.mem[29][31] ,uut.mprj.\rv151.soc.rf.mem[29][30] ,uut.mprj.\rv151.soc.rf.mem[29][29] ,uut.mprj.\rv151.soc.rf.mem[29][28] , 
					  uut.mprj.\rv151.soc.rf.mem[29][27] ,uut.mprj.\rv151.soc.rf.mem[29][26] ,uut.mprj.\rv151.soc.rf.mem[29][25] ,uut.mprj.\rv151.soc.rf.mem[29][24] , 
					  uut.mprj.\rv151.soc.rf.mem[29][23] ,uut.mprj.\rv151.soc.rf.mem[29][22] ,uut.mprj.\rv151.soc.rf.mem[29][21] ,uut.mprj.\rv151.soc.rf.mem[29][20] , 
					  uut.mprj.\rv151.soc.rf.mem[29][19] ,uut.mprj.\rv151.soc.rf.mem[29][18] ,uut.mprj.\rv151.soc.rf.mem[29][17] ,uut.mprj.\rv151.soc.rf.mem[29][16] , 
					  uut.mprj.\rv151.soc.rf.mem[29][15] ,uut.mprj.\rv151.soc.rf.mem[29][14] ,uut.mprj.\rv151.soc.rf.mem[29][13] ,uut.mprj.\rv151.soc.rf.mem[29][12] , 
					  uut.mprj.\rv151.soc.rf.mem[29][11] ,uut.mprj.\rv151.soc.rf.mem[29][10] ,uut.mprj.\rv151.soc.rf.mem[29][9]  ,uut.mprj.\rv151.soc.rf.mem[29][8] , 
					  uut.mprj.\rv151.soc.rf.mem[29][7]  ,uut.mprj.\rv151.soc.rf.mem[29][6]  ,uut.mprj.\rv151.soc.rf.mem[29][5]  ,uut.mprj.\rv151.soc.rf.mem[29][4] , 
					  uut.mprj.\rv151.soc.rf.mem[29][3]  ,uut.mprj.\rv151.soc.rf.mem[29][2]  ,uut.mprj.\rv151.soc.rf.mem[29][1]  ,uut.mprj.\rv151.soc.rf.mem[29][0] } ;
		RF.mem[30]  = {uut.mprj.\rv151.soc.rf.mem[30][31] ,uut.mprj.\rv151.soc.rf.mem[30][30] ,uut.mprj.\rv151.soc.rf.mem[30][29] ,uut.mprj.\rv151.soc.rf.mem[30][28] , 
					  uut.mprj.\rv151.soc.rf.mem[30][27] ,uut.mprj.\rv151.soc.rf.mem[30][26] ,uut.mprj.\rv151.soc.rf.mem[30][25] ,uut.mprj.\rv151.soc.rf.mem[30][24] , 
					  uut.mprj.\rv151.soc.rf.mem[30][23] ,uut.mprj.\rv151.soc.rf.mem[30][22] ,uut.mprj.\rv151.soc.rf.mem[30][21] ,uut.mprj.\rv151.soc.rf.mem[30][20] , 
					  uut.mprj.\rv151.soc.rf.mem[30][19] ,uut.mprj.\rv151.soc.rf.mem[30][18] ,uut.mprj.\rv151.soc.rf.mem[30][17] ,uut.mprj.\rv151.soc.rf.mem[30][16] , 
					  uut.mprj.\rv151.soc.rf.mem[30][15] ,uut.mprj.\rv151.soc.rf.mem[30][14] ,uut.mprj.\rv151.soc.rf.mem[30][13] ,uut.mprj.\rv151.soc.rf.mem[30][12] , 
					  uut.mprj.\rv151.soc.rf.mem[30][11] ,uut.mprj.\rv151.soc.rf.mem[30][10] ,uut.mprj.\rv151.soc.rf.mem[30][9]  ,uut.mprj.\rv151.soc.rf.mem[30][8] , 
					  uut.mprj.\rv151.soc.rf.mem[30][7]  ,uut.mprj.\rv151.soc.rf.mem[30][6]  ,uut.mprj.\rv151.soc.rf.mem[30][5]  ,uut.mprj.\rv151.soc.rf.mem[30][4] , 
					  uut.mprj.\rv151.soc.rf.mem[30][3]  ,uut.mprj.\rv151.soc.rf.mem[30][2]  ,uut.mprj.\rv151.soc.rf.mem[30][1]  ,uut.mprj.\rv151.soc.rf.mem[30][0] } ;
		RF.mem[31]  = {uut.mprj.\rv151.soc.rf.mem[31][31] ,uut.mprj.\rv151.soc.rf.mem[31][30] ,uut.mprj.\rv151.soc.rf.mem[31][29] ,uut.mprj.\rv151.soc.rf.mem[31][28] , 
					  uut.mprj.\rv151.soc.rf.mem[31][27] ,uut.mprj.\rv151.soc.rf.mem[31][26] ,uut.mprj.\rv151.soc.rf.mem[31][25] ,uut.mprj.\rv151.soc.rf.mem[31][24] , 
					  uut.mprj.\rv151.soc.rf.mem[31][23] ,uut.mprj.\rv151.soc.rf.mem[31][22] ,uut.mprj.\rv151.soc.rf.mem[31][21] ,uut.mprj.\rv151.soc.rf.mem[31][20] , 
					  uut.mprj.\rv151.soc.rf.mem[31][19] ,uut.mprj.\rv151.soc.rf.mem[31][18] ,uut.mprj.\rv151.soc.rf.mem[31][17] ,uut.mprj.\rv151.soc.rf.mem[31][16] , 
					  uut.mprj.\rv151.soc.rf.mem[31][15] ,uut.mprj.\rv151.soc.rf.mem[31][14] ,uut.mprj.\rv151.soc.rf.mem[31][13] ,uut.mprj.\rv151.soc.rf.mem[31][12] , 
					  uut.mprj.\rv151.soc.rf.mem[31][11] ,uut.mprj.\rv151.soc.rf.mem[31][10] ,uut.mprj.\rv151.soc.rf.mem[31][9]  ,uut.mprj.\rv151.soc.rf.mem[31][8] , 
					  uut.mprj.\rv151.soc.rf.mem[31][7]  ,uut.mprj.\rv151.soc.rf.mem[31][6]  ,uut.mprj.\rv151.soc.rf.mem[31][5]  ,uut.mprj.\rv151.soc.rf.mem[31][4] , 
					  uut.mprj.\rv151.soc.rf.mem[31][3]  ,uut.mprj.\rv151.soc.rf.mem[31][2]  ,uut.mprj.\rv151.soc.rf.mem[31][1]  ,uut.mprj.\rv151.soc.rf.mem[31][0] } ;
	end
`else
	always@(*) begin
      RF.mem[1]  = uut.mprj.rv151.soc.rf.mem[1] ;
      RF.mem[2]  = uut.mprj.rv151.soc.rf.mem[2] ;
      RF.mem[3]  = uut.mprj.rv151.soc.rf.mem[3] ;
      RF.mem[4]  = uut.mprj.rv151.soc.rf.mem[4] ;
      RF.mem[5]  = uut.mprj.rv151.soc.rf.mem[5] ;
      RF.mem[6]  = uut.mprj.rv151.soc.rf.mem[6] ;
      RF.mem[7]  = uut.mprj.rv151.soc.rf.mem[7] ;
      RF.mem[8]  = uut.mprj.rv151.soc.rf.mem[8] ;
      RF.mem[9]  = uut.mprj.rv151.soc.rf.mem[9] ;
      RF.mem[10] = uut.mprj.rv151.soc.rf.mem[10] ;
      RF.mem[11] = uut.mprj.rv151.soc.rf.mem[11] ;
      RF.mem[12] = uut.mprj.rv151.soc.rf.mem[12] ;
      RF.mem[13] = uut.mprj.rv151.soc.rf.mem[13] ;
      RF.mem[14] = uut.mprj.rv151.soc.rf.mem[14] ;
      RF.mem[15] = uut.mprj.rv151.soc.rf.mem[15] ;
      RF.mem[16] = uut.mprj.rv151.soc.rf.mem[16] ;
      RF.mem[17] = uut.mprj.rv151.soc.rf.mem[17] ;
      RF.mem[18] = uut.mprj.rv151.soc.rf.mem[18] ;
      RF.mem[19] = uut.mprj.rv151.soc.rf.mem[19] ;
      RF.mem[20] = uut.mprj.rv151.soc.rf.mem[20] ;
      RF.mem[21] = uut.mprj.rv151.soc.rf.mem[21] ;
      RF.mem[22] = uut.mprj.rv151.soc.rf.mem[22] ;
      RF.mem[23] = uut.mprj.rv151.soc.rf.mem[23] ;
      RF.mem[24] = uut.mprj.rv151.soc.rf.mem[24] ;
      RF.mem[25] = uut.mprj.rv151.soc.rf.mem[25] ;
      RF.mem[26] = uut.mprj.rv151.soc.rf.mem[26] ;
      RF.mem[27] = uut.mprj.rv151.soc.rf.mem[27] ;
      RF.mem[28] = uut.mprj.rv151.soc.rf.mem[28] ;
      RF.mem[29] = uut.mprj.rv151.soc.rf.mem[29] ;
      RF.mem[30] = uut.mprj.rv151.soc.rf.mem[30] ;
      RF.mem[31] = uut.mprj.rv151.soc.rf.mem[31] ;
  end
`endif

	reg [31:0] IMM;
  	reg [31:0] CLU;

	reg  io_rst = 1'b1;
	reg  bcfg = 1'b0;
	reg  bscs = 1'b1;
	reg  bsdi = 1'b1;
	reg  bsck = 1'b1;

	assign mprj_io[17] = 1'b1;
	assign mprj_io[18] = clock;
	assign mprj_io[19] = io_rst;

	assign mprj_io[16] = bcfg;
	assign mprj_io[15] = bscs;
	assign mprj_io[14] = bsck;
	assign mprj_io[13] = bsdi;

	initial begin : sim_main
	    
		$display("[INFO] start sim_main");

		io_rst = 1'b1;

		@(posedge RSTB);
		repeat(2) @(posedge clock);

`ifdef GL
		//DMEM
		IMM = 32'd300;
		uut.mprj.\rv151.soc.dmem0 .mem[0] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd1, `OPC_ARI_ITYPE};
		IMM = 32'd11;
		uut.mprj.\rv151.soc.dmem0 .mem[1] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE};
`else
		//DMEM
		IMM = 32'd300;
		`MEM_DM0.mem[0] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd1, `OPC_ARI_ITYPE};
		IMM = 32'd11;
		`MEM_DM0.mem[1] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE};
`endif
		repeat(2) @(posedge clock);
		io_rst = 1'b0;

		repeat(2) @(posedge clock);
		
		repeat(2) @(negedge clock);
		bcfg = 1'b1;
		IMM = 32'd10;
		bspi_wr(11'h000+0, {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE});
		IMM = 32'h30000000; CLU = IMM+{19'h0,IMM[11],12'h0}; //R-DMEM0
		bspi_wr(11'h000+1, {CLU[31:12], 5'd29, `OPC_LUI});
		IMM = 32'h20000000; CLU = IMM+{19'h0,IMM[11],12'h0}; //W-IMEM0
		bspi_wr(11'h000+2, {CLU[31:12], 5'd30, `OPC_LUI});
		IMM = 32'h30000000; //R-DMEM0
		bspi_wr(11'h000+3, {IMM[11:0], 5'd29, `FNC_LW, 5'd10, `OPC_LOAD});
		IMM = 32'h20000000; //W-IMEM0
		bspi_wr(11'h000+4, {IMM[11:5] , 5'd10, 5'd30, `FNC_SW, IMM[4:0], `OPC_STORE});
		IMM = 32'h30000004; //R-DMEM0
		bspi_wr(11'h000+5, {IMM[11:0], 5'd29, `FNC_LW, 5'd10, `OPC_LOAD});
		IMM = 32'h20000004; //W-IMEM0
		bspi_wr(11'h000+6, {IMM[11:5] , 5'd10, 5'd30, `FNC_SW, IMM[4:0], `OPC_STORE});
		IMM = 32'h10000000; CLU = IMM+{19'h0,IMM[11],12'h0}; //E-IMEM0
		bspi_wr(11'h000+7, {CLU[31:12], 5'd30, `OPC_LUI});
		bspi_wr(11'h000+8, {IMM[11:0], 5'd30, 3'b000, 5'd31, `OPC_JALR});

		@(negedge clock);
		bcfg = 1'b0;

		// Tests
		wait_for_reg_to_equal(20, 32'd10);       // Run the simulation until the flag is set to 10
		wait_for_reg_to_equal(20, 32'd11);       // Run the simulation until the flag is set to 1
		check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
		$fflush();

		`ifdef GL
	    	$display("Monitor: Test 1 Mega-Project IO (GL) Passed");
		`else
		    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
		`endif
	    $finish;
	end

// mem-bindings to solve model behavior issue

`ifdef GL

	//`define MEM_BM0 uut.mprj.\rv151.soc.bios_mem0 
	//`define MEM_DM0 uut.mprj.\rv151.soc.dmem0 
	//`define MEM_IM0 uut.mprj.\rv151.soc.imem0 

	reg [31:0] bmd0, bmd1;
	always@(negedge uut.mprj.\rv151.soc.bios_mem0 .clk0)
		if(!uut.mprj.\rv151.soc.bios_mem0 .csb0)
			if(!uut.mprj.\rv151.soc.bios_mem0 .web0) begin
				uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*0+:8] <= uut.mprj.\rv151.soc.bios_mem0 .wmask0[0] ? uut.mprj.\rv151.soc.bios_mem0 .din0[8*0+:8] : uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*0+:8] ;
				uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*1+:8] <= uut.mprj.\rv151.soc.bios_mem0 .wmask0[1] ? uut.mprj.\rv151.soc.bios_mem0 .din0[8*1+:8] : uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*1+:8] ;
				uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*2+:8] <= uut.mprj.\rv151.soc.bios_mem0 .wmask0[2] ? uut.mprj.\rv151.soc.bios_mem0 .din0[8*2+:8] : uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*2+:8] ;
				uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*3+:8] <= uut.mprj.\rv151.soc.bios_mem0 .wmask0[3] ? uut.mprj.\rv151.soc.bios_mem0 .din0[8*3+:8] : uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0][8*3+:8] ;
			end
			else
				bmd0 <= uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr0];
	always@(negedge uut.mprj.\rv151.soc.bios_mem0 .clk1)
		if(!uut.mprj.\rv151.soc.bios_mem0 .csb1)
			bmd1 <= uut.mprj.\rv151.soc.bios_mem0 .mem[uut.mprj.\rv151.soc.bios_mem0 .addr1];

	reg [31:0] dmd0;
	always@(negedge uut.mprj.\rv151.soc.dmem0 .clk0)
		if(!uut.mprj.\rv151.soc.dmem0 .csb0)
			if(!uut.mprj.\rv151.soc.dmem0 .web0) begin
				uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*0+:8] <= uut.mprj.\rv151.soc.dmem0 .wmask0[0] ? uut.mprj.\rv151.soc.dmem0 .din0[8*0+:8] : uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*0+:8] ;
				uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*1+:8] <= uut.mprj.\rv151.soc.dmem0 .wmask0[1] ? uut.mprj.\rv151.soc.dmem0 .din0[8*1+:8] : uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*1+:8] ;
				uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*2+:8] <= uut.mprj.\rv151.soc.dmem0 .wmask0[2] ? uut.mprj.\rv151.soc.dmem0 .din0[8*2+:8] : uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*2+:8] ;
				uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*3+:8] <= uut.mprj.\rv151.soc.dmem0 .wmask0[3] ? uut.mprj.\rv151.soc.dmem0 .din0[8*3+:8] : uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0][8*3+:8] ;
			end
			else
				dmd0 <= uut.mprj.\rv151.soc.dmem0 .mem[uut.mprj.\rv151.soc.dmem0 .addr0];

	reg [31:0] imd0, imd1;
	always@(negedge uut.mprj.\rv151.soc.imem0 .clk0)
		if(!uut.mprj.\rv151.soc.imem0 .csb0)
			if(!uut.mprj.\rv151.soc.imem0 .web0) begin
				uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*0+:8] <= uut.mprj.\rv151.soc.imem0 .wmask0[0] ? uut.mprj.\rv151.soc.imem0 .din0[8*0+:8] : uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*0+:8] ;
				uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*1+:8] <= uut.mprj.\rv151.soc.imem0 .wmask0[1] ? uut.mprj.\rv151.soc.imem0 .din0[8*1+:8] : uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*1+:8] ;
				uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*2+:8] <= uut.mprj.\rv151.soc.imem0 .wmask0[2] ? uut.mprj.\rv151.soc.imem0 .din0[8*2+:8] : uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*2+:8] ;
				uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*3+:8] <= uut.mprj.\rv151.soc.imem0 .wmask0[3] ? uut.mprj.\rv151.soc.imem0 .din0[8*3+:8] : uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0][8*3+:8] ;
			end
			else
				imd0 <= uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr0];
	always@(negedge uut.mprj.\rv151.soc.imem0 .clk1)
		if(!uut.mprj.\rv151.soc.imem0 .csb1)
			imd1 <= uut.mprj.\rv151.soc.imem0 .mem[uut.mprj.\rv151.soc.imem0 .addr1];

	initial begin : mem_binding
		force uut.mprj.\rv151.soc.bios_mem0 .csb0_reg = 1'b1;
		force uut.mprj.\rv151.soc.bios_mem0 .csb1_reg = 1'b1;
		force uut.mprj.\rv151.soc.dmem0 .csb0_reg = 1'b1;
		force uut.mprj.\rv151.soc.imem0 .csb0_reg = 1'b1;
		force uut.mprj.\rv151.soc.imem0 .csb1_reg = 1'b1;

		force uut.mprj.\rv151.soc.bios_mem0 .dout0 = bmd0;
		force uut.mprj.\rv151.soc.bios_mem0 .dout1 = bmd1;
		force uut.mprj.\rv151.soc.dmem0 .dout0 = dmd0;
		force uut.mprj.\rv151.soc.imem0 .dout0 = imd0;
		force uut.mprj.\rv151.soc.imem0 .dout1 = imd1;
	end

`else

	reg [31:0] bmd0, bmd1;
	always@(negedge `MEM_BM0.clk0)
		if(!`MEM_BM0.csb0)
			if(!`MEM_BM0.web0) begin
				`MEM_BM0.mem[`MEM_BM0.addr0][8*0+:8] <= `MEM_BM0.wmask0[0] ? `MEM_BM0.din0[8*0+:8] : `MEM_BM0.mem[`MEM_BM0.addr0][8*0+:8] ;
				`MEM_BM0.mem[`MEM_BM0.addr0][8*1+:8] <= `MEM_BM0.wmask0[1] ? `MEM_BM0.din0[8*1+:8] : `MEM_BM0.mem[`MEM_BM0.addr0][8*1+:8] ;
				`MEM_BM0.mem[`MEM_BM0.addr0][8*2+:8] <= `MEM_BM0.wmask0[2] ? `MEM_BM0.din0[8*2+:8] : `MEM_BM0.mem[`MEM_BM0.addr0][8*2+:8] ;
				`MEM_BM0.mem[`MEM_BM0.addr0][8*3+:8] <= `MEM_BM0.wmask0[3] ? `MEM_BM0.din0[8*3+:8] : `MEM_BM0.mem[`MEM_BM0.addr0][8*3+:8] ;
			end
			else
				bmd0 <= `MEM_BM0.mem[`MEM_BM0.addr0];
	always@(negedge `MEM_BM0.clk1)
		if(!`MEM_BM0.csb1)
			bmd1 <= `MEM_BM0.mem[`MEM_BM0.addr1];

	reg [31:0] dmd0;
	always@(negedge `MEM_DM0.clk0)
		if(!`MEM_DM0.csb0)
			if(!`MEM_DM0.web0) begin
				`MEM_DM0.mem[`MEM_DM0.addr0][8*0+:8] <= `MEM_DM0.wmask0[0] ? `MEM_DM0.din0[8*0+:8] : `MEM_DM0.mem[`MEM_DM0.addr0][8*0+:8] ;
				`MEM_DM0.mem[`MEM_DM0.addr0][8*1+:8] <= `MEM_DM0.wmask0[1] ? `MEM_DM0.din0[8*1+:8] : `MEM_DM0.mem[`MEM_DM0.addr0][8*1+:8] ;
				`MEM_DM0.mem[`MEM_DM0.addr0][8*2+:8] <= `MEM_DM0.wmask0[2] ? `MEM_DM0.din0[8*2+:8] : `MEM_DM0.mem[`MEM_DM0.addr0][8*2+:8] ;
				`MEM_DM0.mem[`MEM_DM0.addr0][8*3+:8] <= `MEM_DM0.wmask0[3] ? `MEM_DM0.din0[8*3+:8] : `MEM_DM0.mem[`MEM_DM0.addr0][8*3+:8] ;
			end
			else
				dmd0 <= `MEM_DM0.mem[`MEM_DM0.addr0];

	reg [31:0] imd0, imd1;
	always@(negedge `MEM_IM0.clk0)
		if(!`MEM_IM0.csb0)
			if(!`MEM_IM0.web0) begin
				`MEM_IM0.mem[`MEM_IM0.addr0][8*0+:8] <= `MEM_IM0.wmask0[0] ? `MEM_IM0.din0[8*0+:8] : `MEM_IM0.mem[`MEM_IM0.addr0][8*0+:8] ;
				`MEM_IM0.mem[`MEM_IM0.addr0][8*1+:8] <= `MEM_IM0.wmask0[1] ? `MEM_IM0.din0[8*1+:8] : `MEM_IM0.mem[`MEM_IM0.addr0][8*1+:8] ;
				`MEM_IM0.mem[`MEM_IM0.addr0][8*2+:8] <= `MEM_IM0.wmask0[2] ? `MEM_IM0.din0[8*2+:8] : `MEM_IM0.mem[`MEM_IM0.addr0][8*2+:8] ;
				`MEM_IM0.mem[`MEM_IM0.addr0][8*3+:8] <= `MEM_IM0.wmask0[3] ? `MEM_IM0.din0[8*3+:8] : `MEM_IM0.mem[`MEM_IM0.addr0][8*3+:8] ;
			end
			else
				imd0 <= `MEM_IM0.mem[`MEM_IM0.addr0];
	always@(negedge `MEM_IM0.clk1)
		if(!`MEM_IM0.csb1)
			imd1 <= `MEM_IM0.mem[`MEM_IM0.addr1];

	initial begin : mem_binding
		force `MEM_BM0.csb0_reg = 1'b1;
		force `MEM_BM0.csb1_reg = 1'b1;
		force `MEM_DM0.csb0_reg = 1'b1;
		force `MEM_IM0.csb0_reg = 1'b1;
		force `MEM_IM0.csb1_reg = 1'b1;

		force `MEM_BM0.dout0 = bmd0;
		force `MEM_BM0.dout1 = bmd1;
		force `MEM_DM0.dout0 = dmd0;
		force `MEM_IM0.dout0 = imd0;
		force `MEM_IM0.dout1 = imd1;
	end

`endif

// mem-bindings end

	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#3_00_000;
		CSB = 1'b0;		// CSB can be released
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#100;
		power1 <= 1'b1;
		#100;
		power2 <= 1'b1;
		#100;
		power3 <= 1'b1;
		#100;
		power4 <= 1'b1;
	end

	always @(mprj_io[7:0]) begin
		#1 $display("MPRJ-IO state = %b ", mprj_io[7:0]);
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;
	
	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vddio_2  (VDD3V3),
		.vssio	  (VSS),
		.vssio_2  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda1_2  (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa1_2  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("rv151_bspi.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

	task check_reg;
		input [4:0] reg_number;
		input [31:0] expected_value;
		input [10:0] test_num;
		if (expected_value !== RF.mem[reg_number]) begin
		$display("FAIL - test %d, got: %d, expected: %d for reg %d",
				test_num, RF.mem[reg_number], expected_value, reg_number);
		$finish();
		end
		else begin
		$display("PASS - test %d, got: %d for reg %d", test_num, expected_value, reg_number);
		end
	endtask

	task wait_for_reg_to_equal;
		input [4:0] reg_number;
		input [31:0] expected_value;
		while (RF.mem[reg_number] !== expected_value)
		@(posedge clock);
	endtask

	task bspi_wr;
    input [10:0] ad;
    input [31:0] dt;
    reg [15:0] hd;
    begin
      hd = {2'h2, {3{1'b0}}, ad};

      bscs = 1'b0;

      for(integer i=0; i<16; i=i+1) begin
        {bsck, bsdi} = {1'b0, hd[15-i]};
        #(CLK_CYCLE/2);
        {bsck, bsdi} = {1'b1, hd[15-i]};
        #(CLK_CYCLE/2);
      end

      for(integer i=0; i<32; i=i+1) begin
        {bsck, bsdi} = {1'b0, dt[31-i]};
        #(CLK_CYCLE/2);
        {bsck, bsdi} = {1'b1, dt[31-i]};
        #(CLK_CYCLE/2);
      end

      bscs = 1'b1;
      {bsck, bsdi} = {1'b0, 1'b0};
      #(CLK_CYCLE);

      repeat(4) @(posedge clock);
      //$display("hd[%04X]", hd); //debug 

      $display("bspi_wr[%04X]:%08X", ad, dt);

      $fflush();

    end
  endtask

endmodule
`default_nettype wire
