// Copyright (c) 2023 Beijing Institute of Open Source Chip
// common is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_REGFILE_SV
`define INC_REGFILE_SV

`include "setting.sv"

`define TECH_REGFILE_BM_BACKEND
// `define NO_PG_PIN // for HL28HKHD1PRF512x64B1M2W1P1D1MCASA10_tt0p9v25c.v

// this file only include behavioral model, for ASIC tape-out need to reimplement those models
module tech_regfile #(
    parameter int BIT_WIDTH  = 128,
    parameter int WORD_DEPTH = 64
) (
    input  logic                          clk_i,
    input  logic                          en_i,
    input  logic                          wen_i,
    input  logic [$clog2(WORD_DEPTH)-1:0] addr_i,
    input  logic [         BIT_WIDTH-1:0] dat_i,
    output logic [         BIT_WIDTH-1:0] dat_o

);

`ifdef TECH_REGFILE_BACKEND
  $error("need to instantiate specific technology cell in this block and remove this statement");
`else
  logic [BIT_WIDTH-1:0] r_intern_ram[0:WORD_DEPTH-1];
  always_ff @(posedge clk_i) begin
    if (~en_i && ~wen_i) begin
      r_intern_ram[addr_i] <= #`REGISTER_DELAY dat_i;
    end else begin
      dat_o <= #`REGISTER_DELAY (~en_i && wen_i) ? r_intern_ram[addr_i] : {(BIT_WIDTH / 32) {32'b0}};
    end
  end
`endif
endmodule


module tech_regfile_bm #(
    parameter int BIT_WIDTH  = 128,
    parameter int WORD_DEPTH = 64
) (
    input  logic                          clk_i,
    input  logic                          en_i,
    input  logic                          wen_i,
    input  logic [       BIT_WIDTH/8-1:0] bm_i,
    input  logic [$clog2(WORD_DEPTH)-1:0] addr_i,
    input  logic [         BIT_WIDTH-1:0] dat_i,
    output logic [         BIT_WIDTH-1:0] dat_o

);

`ifdef TECH_REGFILE_BM_BACKEND
  // $error("need to instantiate specific technology cell in this block and remove this statement");
  // bm_i
  logic [BIT_WIDTH-1:0] s_bm;
  for (genvar i = 0; i < BIT_WIDTH / 8; i++) begin: REGFILE_BIT_MASK_BLOCK_BACKEND
      assign s_bm[i*8+:8] = {8{bm_i[i]}};
  end
  TS5N28HPCPLVTA512X64M4FW u_TS5N28HPCPLVTA512X64M4FW(.CLK(clk_i), .CEB(en_i), .WEB(wen_i), .A(addr_i), .D(dat_i), .BWEB(s_bm), .Q(dat_o));
`else
  logic s_en, s_wen;
  logic [BIT_WIDTH-1:0] s_bm;
  logic [BIT_WIDTH-1:0] r_intern_ram[0:WORD_DEPTH-1];

  assign s_en  = ~en_i;
  assign s_wen = ~wen_i;

  for (genvar i = 0; i < BIT_WIDTH / 8; i++) begin: REGFILE_BIT_MASK_BLOCK
    assign s_bm[i*8+:8] = ~{8{bm_i[i]}};
  end

  always_ff @(posedge clk_i) begin
    if (s_en && s_wen) begin
      r_intern_ram[addr_i] <= #`REGISTER_DELAY (dat_i & s_bm) | (r_intern_ram[addr_i] & ~s_bm);
    end
    dat_o <= #`REGISTER_DELAY (~en_i && wen_i) ? r_intern_ram[addr_i] : {(BIT_WIDTH / 32) {32'b0}};
  end
`endif
endmodule

`endif
