// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

wire io_bcf;
wire io_scs;
wire io_sdi;
wire io_sdo;
wire io_sck;

wire io_hlt;
wire io_irc;

wire serial_in;
wire serial_out;

wire [7:0] gpio_in;
wire [7:0] gpio_out;
wire [7:0] gpio_oeb;

wire io_cslt;
wire io_clk;
wire io_rst;

wire clk;
wire rst;

//GPIO assign

assign {io_out[ 0], io_oeb[ 0]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 1], io_oeb[ 1]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 2], io_oeb[ 2]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 3], io_oeb[ 3]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 4], io_oeb[ 4]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 5], io_oeb[ 5]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 6], io_oeb[ 6]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 7], io_oeb[ 7]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 8], io_oeb[ 8]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[ 9], io_oeb[ 9]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[10], io_oeb[10]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[11], io_oeb[11]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[12], io_oeb[12]} = {io_sdo, 1'b0};
assign {io_out[13], io_oeb[13]} = {1'b0, 1'b1};                 //io_sdi
assign {io_out[14], io_oeb[14]} = {1'b0, 1'b1};                 //io_sck

assign {io_out[15], io_oeb[15]} = {1'b0, 1'b1};                 //io_scs
assign {io_out[16], io_oeb[16]} = {1'b0, 1'b1};                 //io_bcf
assign {io_out[17], io_oeb[17]} = {1'b0, 1'b1};                 //io_cslt
assign {io_out[18], io_oeb[18]} = {1'b0, 1'b1};                 //io_clk 
assign {io_out[19], io_oeb[19]} = {1'b0, 1'b1};                 //io_rst 
assign {io_out[20], io_oeb[20]} = {io_hlt, 1'b0};
assign {io_out[21], io_oeb[21]} = {io_irc, 1'b0};
assign {io_out[22], io_oeb[22]} = {serial_out, 1'b0};
assign {io_out[23], io_oeb[23]} = {1'b0, 1'b1};                 //serial_in
assign {io_out[24], io_oeb[24]} = {gpio_out[0], gpio_oeb[0]};

assign {io_out[25], io_oeb[25]} = {gpio_out[1], gpio_oeb[1]};
assign {io_out[26], io_oeb[26]} = {gpio_out[2], gpio_oeb[2]};
assign {io_out[27], io_oeb[27]} = {gpio_out[3], gpio_oeb[3]};
assign {io_out[28], io_oeb[28]} = {gpio_out[4], gpio_oeb[4]};
assign {io_out[29], io_oeb[29]} = {gpio_out[5], gpio_oeb[5]};
assign {io_out[30], io_oeb[30]} = {gpio_out[6], gpio_oeb[6]};
assign {io_out[31], io_oeb[31]} = {gpio_out[7], gpio_oeb[7]};

assign {io_out[32], io_oeb[32]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[33], io_oeb[33]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[34], io_oeb[34]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[35], io_oeb[35]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[36], io_oeb[36]} = {1'b0, 1'b1};                 //MGMT
assign {io_out[37], io_oeb[37]} = {1'b0, 1'b1};                 //MGMT

//inputs

assign io_sdi = io_in[13];
assign io_sck = io_in[14];
assign io_scs = io_in[15];
assign io_bcf = io_in[16];

assign io_cslt = io_in[17];
assign io_clk  = io_in[18];
assign io_rst  = io_in[19];

assign serial_in = io_in[23];

assign gpio_in[7:0] = io_in[31:24];

assign clk = user_clock2;
assign rst = wb_rst_i;

hdp_rv151 rv151(
    .io_bcf(io_bcf),
    .io_scs(io_scs),
    .io_sdi(io_sdi),
    .io_sdo(io_sdo),
    .io_sck(io_sck),

    .io_hlt(io_hlt),
    .io_irc(io_irc),
    .serial_in(serial_in),
    .serial_out(serial_out),

    .gpio_in(gpio_in),
    .gpio_out(gpio_out),
    .gpio_oeb(gpio_oeb),
    
    .io_cslt(io_cslt),
    .io_clk(io_clk),
    .io_rst(io_rst),
    
    .clk(clk),
    .rst(rst)
);

endmodule	// user_project_wrapper

`default_nettype wire
