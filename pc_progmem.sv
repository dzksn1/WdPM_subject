`include "op_code.sv"
import op_code::*;
module pc_progmem #(
  localparam DIRECT_LD = 2'b10,
  localparam DEFAULT_LD = 2'b00
)(
    input i_clk, i_rst,
    input i_ce,
    output logic [4:0] o_pc_addr,
    output logic [15:0] o_program_memory,
    output full_operation o_operation_code_2_id
);
logic [15:0] program_memory [31:0];
//----------------------------------
// Program counter
//----------------------------------
always_ff @(posedge i_clk or posedge i_rst) begin : p_program_counter
  if(i_rst) begin
    o_pc_addr <= 5'd0;
  end
  else if(i_ce) begin
    o_pc_addr <= o_pc_addr + 1;
  end
end : p_program_counter
//--------------------------------- 
// Program Memory
//---------------------------------
always_comb begin : p_program_memory
  if(i_rst) begin
    o_program_memory = {10'b00_0000_0000, OP_NOP, 2'b00};
    for (int i = 0; i < 31; i++) begin
      program_memory[i] = {10'b00_0000_0000, OP_NOP, 2'b00};
    end 
  // Program:
  program_memory[0] = {8'b1111_1110, DIRECT_LD, OP_LD, 2'b00}; //direct LD
  program_memory[1] = {10'b00_0000_0000, OP_ST, 2'b00}; // ST to RF 00
  program_memory[2] = {8'd1, DIRECT_LD, OP_LD, 2'b00}; //direct LD
  program_memory[3] = {10'b00_0000_0000, OP_ADD, 2'b00}; //ADD operation
  program_memory[4] = {10'd0, OP_ST, 2'b01}; // ST to RF 01
  program_memory[5] = {10'b00_0000_0000, OP_XOR_BIT, 2'b00}; //XOR operation
  program_memory[6] = {10'd10, OP_STM, 2'b00}; //ST to data mem
  program_memory[7] = {10'd0, OP_NOP, 2'b00}; // NOP
  end
  else begin
    o_program_memory = program_memory[o_pc_addr];
  end
end : p_program_memory
assign o_operation_code_2_id = full_operation'(o_program_memory[5:2]);
// instruction pass

//-----------------
// Instruction format:
// Basic instruction:
// program_memory[] = {10'b addr data mem, operation with prefix OP, 2'b addr RF};

// LD instruction with Direct Load
// program_memory[] = {8'b data, DIRECT_LD, OP_LD, 2'b addr RF};
//-----------------
endmodule 
