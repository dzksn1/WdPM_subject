module data_memory (
  input i_clk, i_rst,
  input [7:0] i_data_memory,
  input [9:0] i_data_memory_addr,
  input i_write_enable,
  input i_read_enable,
  output logic [7:0] o_data_memory
);
logic [7:0] data_memory [1023:0]; //mozna dac [1024] tak o
//---------------------------------
// Data memory
//---------------------------------
always_ff @(posedge i_clk or posedge i_rst) begin : p_data_memory
  if(i_rst) begin
    for(integer i = 0; i < 1023; i = i + 1) begin
      data_memory[i] <= '0;
    end
    //data_memory <= '{default:0};
  end
  else begin
    case ({i_write_enable,i_read_enable})
    2'b01 : o_data_memory <= data_memory[i_data_memory_addr];
    2'b10 : data_memory[i_data_memory_addr] <= i_data_memory;
    endcase
  end
end : p_data_memory

endmodule