`timescale 1ns / 1ps

typedef struct {
    logic load_A;
    logic load_B;
    logic load_add;
    logic shift_HQ_LQ_Q_1;
    logic add_sub;
} mult_control_t;

module top #(parameter N=8)(
    input logic clk,
    input logic rst,
    input logic [N-1:0] A,
    input logic [N-1:0] B,
    
    output logic [1:0] Q_LSB,
    output logic [2*N-1:0] Y,
    output logic ready
);

    mult_control_t mult_control; // Declaración de la estructura mult_control

    FlipFlopRegister susbsistemaFF(
        .clk(clk),
        .reset(rst),
        .enable(mult_control.load_A),
        .data_in(A),
        .data_out()
    );

    mult_with_sm#(.N(N)) subsistemaMult(
        .clk(clk),
        .rst(rst),
        .A(subsistemaFF.data_out),
        .B(B),
        .mult_control(mult_control),
        .Q_LSB(Q_LSB),
        .Y(Y),
        .ready(ready)
    );

    display_system subsistemaDisplay (
        .clk(clk),
        .rst(rst),
        .data_in(Y),
        .seg_out(),
        .an_out()
    );

endmodule