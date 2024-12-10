`include "alu.sv"
`include "pc_progmem.sv"
`include "id.sv"
`include "data_memory.sv"
import pkg::*;
import op_code::*;

module cpu(
    input i_clk, i_rst, i_ce,
    input [7:0] i_register_file,
    output logic [4:0] o_pc_addr,
    output logic [15:0] o_program_memory,
    output logic [7:0] o_register_file,
    output logic [1:0] register_file_mux,
    output logic [2:0] register_file_ce,
    output logic [7:0] o_alu,
    output logic [7:0] o_acumulator,
    output logic acumulator_ce,
    output operation o_operation_code_2_alu,
    output full_operation o_operation_code_2_id,
    output logic o_carry,
    output logic [7:0] o_data_memory,
    output logic direct_load,
    output logic [7:0] direct_data
);
//----------------------------
// Inside connections
//----------------------------
logic [2:0] w_operation_code_2_alu;
logic [1:0] w_register_file_mux;
logic [2:0] w_register_file_ce;
logic [9:0] w_data_memory_addr;
logic w_acumulator_ce;
logic w_data_memory_write_enable;
logic w_data_memory_read_enable;
//---------------------------
// Instances
//---------------------------
pc_progmem pc_progmem_inst(
.i_clk(i_clk),
.i_rst(i_rst),
.i_ce(i_ce),
.o_pc_addr(o_pc_addr),
.o_program_memory(o_program_memory),
.o_operation_code_2_id(o_operation_code_2_id)
);

id id_inst(
.i_instruction(o_program_memory),
.o_operation_code(w_operation_code_2_alu),
.o_register_file_addr(w_register_file_mux),
.o_register_file_ce(w_register_file_ce),
.o_acumulator_ce(w_acumulator_ce),
.o_data_memory_addr(w_data_memory_addr),
.o_memory_read_enable(w_data_memory_read_enable),
.o_memory_write_enable(w_data_memory_write_enable),
.o_direct_data(direct_data),
.o_direct_load(direct_load)
);

alu alu_inst(
.i_clk(i_clk),
.i_rst(i_rst),
.i_acumulator_ce(w_acumulator_ce),
.i_register_file(i_register_file),
.i_operation_code(w_operation_code_2_alu),
.i_register_file_ce(w_register_file_ce),
.i_register_file_mux_addr(w_register_file_mux),
.i_data_memory_read_enable(w_data_memory_read_enable),
.i_data_memory(o_data_memory),
.o_register_file(o_register_file),
.o_alu(o_alu),
.o_acumulator(o_acumulator),
.o_carry(o_carry),
.i_direct_data(direct_data),
.i_direct_load(direct_load)
);

data_memory data_memory_inst (
.i_clk(i_clk),
.i_rst(i_rst),
.i_data_memory_addr(w_data_memory_addr),
.i_data_memory(o_acumulator),
.o_data_memory(o_data_memory),
.i_write_enable(w_data_memory_write_enable),
.i_read_enable(w_data_memory_read_enable)
);

assign o_operation_code_2_alu = operation'(w_operation_code_2_alu);
assign acumulator_ce = w_acumulator_ce;
assign register_file_ce = w_register_file_ce;
assign register_file_mux = w_register_file_mux; 

endmodule