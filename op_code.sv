package op_code;
typedef enum logic [3:0] {
OP_ADD = 4'b0000,
OP_SUB = 4'b0001,
OP_MUL_BIT = 4'b0010,
OP_OR_BIT = 4'b0011,
OP_XOR_BIT = 4'b0100,
OP_NOT = 4'b0101,
OP_NOP = 4'b0110,
OP_STM = 4'b1000,
OP_ST = 4'b1010,
OP_LDM = 4'b1100,
OP_LD = 4'b1110
} full_operation;
endpackage

