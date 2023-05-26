`timescale 1ns / 1ps

typedef struct {
    logic load_A; //Indica si se debe cargar operando A en registro interno del multiplicador
    logic load_B; //Indica si se debe cargar operando B en registro interno del multiplicador
    logic load_add; //Indica si se debe cargar el resultado de la operación de suma/resta en los registros internos del multiplicador
    logic shift_HQ_LQ_Q_1; //Controla la operación de desplazamiento aritmético en los registros internos del multiplicador
    logic add_sub; //Controla si se debe realizar una operación de suma o resta en el multiplicador
}   mult_control_t; //Es un tipo de dato definido. Controla los diferentes estados y acciones del multiplicador.

module mult_with_sm#(
    parameter N = 8 //Tamaño de 8 bits para operandos
)(
    input logic clk,
    input logic rst,

    input logic [N-1:0] A, 
    input logic [N-1:0] B,

    input mult_control_t mult_control, //Se declara una señal de entrada llamada mult_control de tipo mult_control_t

    output logic [1:0] Q_LSB, //Como arrojaba error se cambió [2] por un vector de 2 bits definido como [1:0]
    output logic [2*N-1:0] Y, //El vector Y representa el resultado completo de la multiplicación
    output logic ready //Define una salida "ready" para indicar que el resultado está listo o no
);

    logic [N-1:0] M; // M se utiliza como un registro interno para almacenar el valor del operando A.
    logic [N-1:0] adder_sub_out; // Se utiliza para almacenar el resultado de la operación de suma o resta entre los registros M y HQ.
    logic [2*N:0] shift; // Se utiliza para implementar los registros de desplazamiento
    logic [N-1:0] HQ; // Se utiliza para almacenar la parte alta del registro de desplazamiento durante la multiplicación.
    logic [N-1:0] LQ; // Se utiliza para almacenar la parte baja del registro de desplazamiento durante la multiplicación.
    logic Q_1; // Se utiliza para almacenar el bit menos significativo del registro de desplazamiento durante la multiplicación.

    // Register M
    always_ff @(posedge clk, rst) begin
        if (rst)
            M <= 'b0;
        else
            M<=(mult_control.load_A)? A : M;
    end

    // Adder/Subtractor
    always_comb begin
        if (mult_control.add_sub) // Condición que verifica el valor de la señal add_sub
            adder_sub_out = M + HQ; // Suma el vector M y HQ y lo guarda en adder_sub_out
        else
            adder_sub_out = M - HQ; // Resta el vector M y HQ y lo guarda en adder_sub_out
    end

    // Shift registers
    always_ff @(posedge clk, rst) begin
        if (rst)
            shift <= 'b0; // Estado inicial donde se establece todo slos bits de shift en 0
        else if (mult_control.shift_HQ_LQ_Q_1) // Se realiza un desplazamiento a la derecha un bit
            // Arithmetic shift
            shift <= $signed(shift) >>> 1; // $signed() se utiliza para convertir la variable shift en un tipo de dato con signo
        else begin
            if (mult_control.load_B) // Controla la carga del operando B en el multiplicador basándose en la señal load_B
                shift[N:1] <= B; // Se carga B en el registro interno del multiplicador, vector shift
            if (mult_control.load_add) // Se realiza la carga del resultado de la operación de suma/resta, vector shift
                shift[2*N:N+1] <= adder_sub_out;
        end
    end

    // Output assignments
    always_comb begin
        Y = {HQ, LQ};
        HQ = shift[2*N:N+1];
        LQ = shift[N:1];
        Q_1 = shift[0];
        Q_LSB = {LQ[0], Q_1};
        ready = mult_control.load_A & mult_control.load_B; //*Parámetro de Ready: indica cuándo el resultado es válido
    end

endmodule