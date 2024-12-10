`include "op_code.sv"
import op_code::*;
module id (
  input [15:0] i_instruction,
  output logic [2:0] o_operation_code,
  output logic [1:0] o_register_file_addr,
  output logic [2:0] o_register_file_ce,
  output logic o_acumulator_ce,
  output logic [9:0] o_data_memory_addr,
  output logic o_memory_write_enable,
  output logic o_memory_read_enable,
  output logic [7:0] o_direct_data,
  output logic o_direct_load
);
//--------------------------------
// Instruction Decoder
//--------------------------------
always @(*) begin
//----------------------------------------
// Default settings as a NOP operation
//----------------------------------------
full_operation instruction;
instruction = full_operation'(i_instruction[5:2]);
o_operation_code = i_instruction[4:2]; //Op code assign to ALU
o_register_file_ce = {1'b1, i_instruction[1:0]}; //RF clocks are disabled
o_register_file_addr = i_instruction[1:0]; //Mux addr
o_acumulator_ce = 1'b0; //Acumulator closed
o_memory_read_enable = 1'b0;
o_memory_write_enable = 1'b0;
o_data_memory_addr = i_instruction[15:6];
o_direct_data = '0;
o_direct_load = 1'b0;

case(instruction)
  default : begin //Basic alu operations
      o_acumulator_ce = 1'b0;
      o_register_file_ce = {1'b1, i_instruction[1:0]}; //disable rf clocks
  end
  OP_STM : begin // STM (Store to data memroy from aku)
      o_memory_write_enable = 1'b1;
  end
  OP_ST : begin // ST (Store to RF from aku)
      o_register_file_ce = {1'b0, i_instruction[1:0]}; //Enable RF
  end
  OP_LDM : begin // LDM (Load to aku from data memory)
      o_acumulator_ce = 1'b1;
      o_memory_read_enable = 1'b1;
  end
  OP_LD : begin // LD (Load to aku from RF)
      o_acumulator_ce = 1'b1;
      if(i_instruction[7] == 1'b1) begin //Direct LD
        o_direct_data = i_instruction[15:8];
        o_direct_load = 1'b1;
      end
  end
endcase
end

endmodule

//---------------------
// Instruction construction
// instruction[15:0]
// [15:6] - data memory addr
// [5:2] - operation code
// [1:0] - rf addr
//----------------------

/*
case(instruction[5])
  1'b0 : begin // basic ALU operations, a3 = 0
    if ((instruction[4:2] >= 3'b000) || (instruction[4:2] <= 3'b101)) begin
      o_acumulator_ce = 1'b0;
      o_register_file_ce = {1'b1, instruction[1:0]}; //disable rf clocks
    end
  end
  1'b1 : begin // a3 = 1
    case(instruction[4])
      1'b0 : begin //a3a2 = 10, All STOTRE operations are here
        if (instruction[3] == 1'b0) begin // a3a2a1a0 = 100-, STM -> ST to data_mem from aku
          o_memory_write_enable = 1'b1;
        end
        else if (instruction[3] == 1'b1) begin // a3a2a1a0 = 101-, ST from acumulator
          o_register_file_ce = {1'b0, instruction[1:0]}; //Enable RF
        end
      end
      1'b1 : begin //a3a2 = 11 -> LD'M (Load to aku from data memory) or LD to acumulator
        if(instruction[3] == 1'b0) begin //LD to aku from data_mem
          o_acumulator_ce = 1'b1;
          o_memory_read_enable = 1'b1;
        end
        else if(instruction[3] == 1'b1) begin //LD to acumulator
          o_acumulator_ce = 1'b1;
        end
      end
    endcase
  end
endcase
*/