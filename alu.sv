`include "pkg.sv"
import pkg::*;
module alu (
  input i_clk, i_rst,
  input i_acumulator_ce,
  input [2:0] i_operation_code,
  input [7:0] i_register_file, //wej diagnostyczne
  input [2:0] i_register_file_ce,
  input [1:0] i_register_file_mux_addr,
  input i_data_memory_read_enable,
  input [7:0] i_data_memory,
  input [7:0] i_direct_data,
  input i_direct_load,
  output logic [7:0] o_alu,
  output logic [7:0] o_acumulator,
  output logic [7:0] o_register_file,
  output logic o_carry
);
operation current_operation;
logic [7:0] register_file_index [3:0];
logic [7:0] alu_argument;
//--------------------------------
// MUX (DM or RF connected to ALU)
//--------------------------------
always_comb begin : p_rf_or_dm
case(i_data_memory_read_enable)
  default : alu_argument = o_register_file;
  1'b1 : alu_argument = i_data_memory;
endcase
end : p_rf_or_dm
//--------------------------------
// ALU
//--------------------------------
always_comb begin : p_alu 
  current_operation = operation'(i_operation_code);
  o_carry = 1'b0;
  case (current_operation)
    ADD : o_alu = o_acumulator + alu_argument;
    SUB : o_alu = o_acumulator - alu_argument;
    MUL_BIT : o_alu = o_acumulator & alu_argument;
    OR_BIT : o_alu = o_acumulator | alu_argument;
    XOR_BIT : o_alu = o_acumulator ^ alu_argument;
    NOT : o_alu = ~alu_argument;
    default : o_alu = alu_argument; // 110 op code as default (LD)
  endcase
end : p_alu
//------------------------------
// Acumulator
//------------------------------
always_ff @(posedge i_clk or posedge i_rst) begin : p_acumulator
  if(i_rst) begin
    o_acumulator <= 8'd0;
  end
  else if(i_acumulator_ce) begin
    if(i_direct_load) begin
      o_acumulator <= i_direct_data;
    end
      else begin
      o_acumulator <= o_alu;
      end
  end
end : p_acumulator
//------------------------------------
// Register File
//------------------------------------
always_ff @(posedge i_clk or posedge i_rst) begin : p_register_file_ce
  if(i_rst) begin
    register_file_index <= '{default:0};
  end
  else begin
    case (i_register_file_ce)
    3'b000 : register_file_index[0] <= o_acumulator;
    3'b001 : register_file_index[1] <= o_acumulator;
    3'b010 : register_file_index[2] <= o_acumulator;
    3'b011 : register_file_index[3] <= o_acumulator;
    endcase
  end
end : p_register_file_ce
//------------------------------------
// Register File - register choose
//------------------------------------
always_comb begin : p_register_file_mux_addr
  case (i_register_file_mux_addr)
  2'b00 : o_register_file = register_file_index[0]; // Temporary input
  2'b01 : o_register_file = register_file_index[1];
  2'b10 : o_register_file = register_file_index[2];
  2'b11 : o_register_file = register_file_index[3];
  default : o_register_file = register_file_index[0];
  endcase
end : p_register_file_mux_addr

endmodule