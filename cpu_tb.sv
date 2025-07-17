`timescale 1ns/100ps
`include "pkg.sv"
`include "cpu.sv"
import pkg::*;

module cpu_tb;
// Inputs
logic i_clk, i_rst, i_ce;
logic [7:0] i_register_file;

// Outputs
logic [4:0] o_pc_addr;
logic [15:0] o_program_memory;
logic [7:0] o_register_file;
logic [1:0] register_file_mux;
logic [2:0] register_file_ce;
logic [7:0] o_alu;
logic [7:0] o_acumulator;
logic acumulator_ce;
logic [7:0] o_data_memory;
operation o_operation_code_2_alu;
full_operation o_operation_code_2_id;
logic o_carry;
logic direct_load;
logic [7:0] direct_data;

integer i;

cpu uut(.*);

initial begin
  i_clk = 1'b0;
  forever #5 i_clk = ~i_clk;
end

initial begin
  i_rst = 1'b1; i_register_file = 8'd0;
  i = 0; i_ce = 1'b1;
  @(negedge i_clk);
  i_rst = 1'b0;
  i_register_file = 8'd2;
  #100
  $finish;
end

initial begin
  $dumpfile("cpu.vcd");
  $dumpvars(0,uut);
end

endmodule