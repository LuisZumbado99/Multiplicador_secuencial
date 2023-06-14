module FlipFlopRegister(
        input logic clk,
        input logic reset,
        input logic enable,
        input logic [7:0] data_in,
        output logic [7:0] data_out
    );
    logic [7:0] register;
    always_ff@(posedge clk or posedge reset) begin
        if (reset)
            register <= 8'b00000000;
        else if (enable)
            register <= data_in;
    end
  assign data_out = register;
endmodule