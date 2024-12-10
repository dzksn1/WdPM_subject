`timescale 1ns/100ps
`include "id.sv"
`include "op_code.sv"
import op_code::*;
module id_tb;

// Inputs
logic i_clk;
logic [15:0] i_instruction;

// Outputs
logic [2:0] o_operation_code;
logic [1:0] o_register_file_addr;
logic [2:0] o_register_file_ce;
logic [9:0] o_data_memory_addr;
logic o_memory_write_enable;
logic o_memory_read_enable;
logic o_acumulator_ce;
logic [7:0] o_direct_data;
logic o_direct_load;

//Variable
full_operation op_code;
logic [1:0] rf_addr;

id uut(.*);

initial begin
  i_clk = 1'b0;
  forever #5 i_clk = ~i_clk;
end

initial begin
  i_instruction = 16'd0; op_code = '0; rf_addr = '0;
  repeat (70) begin
  @(posedge i_clk);
  rf_addr = 2'b11;
  op_code = op_code + 1;
  i_instruction = {10'd0, op_code, rf_addr};
  end
  #750
  $finish;
end

initial begin
  $dumpfile("id.vcd");
  $dumpvars(0,uut);
end
endmodule