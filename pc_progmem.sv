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
  if (i_rst) begin
    /* // Pierwszy set instrukcji do testow
  o_program_memory = {10'b00_0000_0000, OP_NOP, 2'b00};
  //program_memory = '{default:0};
  program_memory[0] = {10'b00_0000_0000, OP_NOP, 2'b00};
  program_memory[1] = {10'b00_0000_0000, OP_LD, 2'b00};
  program_memory[2] = {10'b00_0000_0000, OP_ST, 2'b01};
  program_memory[3] = {10'b00_0000_0000, OP_NOP, 2'b00};
  program_memory[4] = {10'b00_0000_0001, OP_STM, 2'b00};
  program_memory[5] = {10'b00_0000_0000, OP_LD, 2'b00};
  program_memory[6] = {10'b00_0000_0000, OP_NOP, 2'b00};
  program_memory[7] = {10'b00_0000_0001, OP_LDM, 2'b00};
  program_memory[8] = {10'b00_0000_0000, OP_NOP, 2'b00};
  */
  //o_program_memory = {10'b00_0000_0000, OP_NOP, 2'b00};
  program_memory[0] = {10'b00_0000_0000, OP_NOP, 2'b11};
  program_memory[1] = {8'b1111_1110, 2'b10, OP_LD, 2'b11}; //direct LD
  program_memory[2] = {10'b00_0000_0000, OP_ST, 2'b11}; // ST to RF
  program_memory[3] = {8'd1, 2'b10, OP_LD, 2'b11}; //direct LD
  program_memory[4] = {10'b00_0000_0000, OP_ADD, 2'b11}; //basic LD operation
  program_memory[5] = {10'b00_0000_0000, OP_LD, 2'b11};
  end
  else begin
    o_program_memory = program_memory[o_pc_addr];
  end
end : p_program_memory
assign o_operation_code_2_id = full_operation'(o_program_memory[5:2]);
// przekazanie instrukcji

//-----------------
// Format instrukcji:
// Zwyczajna instrukcja:
// program_memory[] = {10'b adres data mem, operacja z prefixem OP, 2'b adres RF};

// Instrukcja LD wykorzystujaca wpis bezposredni
// program_memory[] = {8'b dane, DIRECT_LD, OP_LD, 2'b adres RF};
//-----------------
endmodule 
