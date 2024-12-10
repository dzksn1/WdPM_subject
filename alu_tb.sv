`timescale 1ns/100ps
import pkg::*;
module alu_tb;
//-------------------------------
// Inputs
//-------------------------------
logic i_clk, i_rst, i_acumulator_ce;
operation i_operation_code;
logic [7:0] i_register_file;
logic [2:0] i_register_file_ce;
logic [3:0] i_register_file_mux_addr;
//-------------------------------
// Outputs
//-------------------------------
logic [7:0] o_acumulator;

alu uut (.i_clk(i_clk),
.i_rst(i_rst),
.i_operation_code(i_operation_code),
.i_acumulator_ce(i_acumulator_ce),
.i_register_file(i_register_file),
.i_register_file_ce(i_register_file_ce),
.i_register_file_mux_addr(i_register_file_mux_addr),
.o_acumulator(o_acumulator)
);

initial begin : p_clk
  i_clk = 1'b0;
  forever #5 i_clk = ~i_clk;
end : p_clk

initial begin : testbench
  i_rst = 1'b1; i_acumulator_ce = 1'b1; 
  i_operation_code = ADD;
  i_register_file = 8'd5;
  i_register_file_ce = 3'd0;
  i_register_file_mux_addr = 4'b0000;
  #5
  i_rst = 1'b0;
  @(posedge i_clk);

  repeat(10) begin
    @(posedge i_clk);
    i_operation_code++;
  end
  #350
  $finish;
end : testbench

initial begin
  $dumpfile("alu_tb.vcd");
  $dumpvars(0,uut);
end
endmodule