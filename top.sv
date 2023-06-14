module TopModule (
  // Puertos de inputs y outputs
  input logic clk,
  input logic reset,
  input logic btn,
  output logic [7:0] A,
  output logic [7:0] B,
  output logic start,
  output logic [1:0] Q_LSB,
  output logic [15:0] Y,
  output logic ready
);

  /* Variables internas que almacenan las señales de 
  los operandos A, B y start.  A_internal y B_internal
  se toman de las salidas A y B del módulo SubSysLecture
  para que mult_with_sm sean capturados */ 
  logic [7:0] A_internal;
  logic [7:0] B_internal;
  logic start_internal;

  // Instancias 
  SubSysLecture sub_sys (
    .clk(clk),
    .reset(reset),
    .btn(btn),
    .A(A_internal),
    .B(B_internal),
    .start(start_internal)
  );

  // Declaración de avariable que controla los diferentes estados y acciones del módulo mult_with_sm
  mult_control_t mult_control; // Declaración de la estructura mult_control

  // Asignación de valores a la estructura mult_control
  assign mult_control.load_A = 1'b1; // Al asignarle 1 indica que debe cargar el operando A
  assign mult_control.load_B = 1'b1; // Al asignarle 1 indica que debe cargar el operando B
  assign mult_control.load_add = 1'b0; // Se indica que no se debe cargar el resultado de la operación de suma/resta
  assign mult_control.shift_HQ_LQ_Q_1 = 1'b1; // Se indica que se debe realizar un desplazamiento a la derecha en los registros internos.
  assign mult_control.add_sub = 1'b0; // Se indica que se debe realizar una operación de resta.

  mult_with_sm #(8) multiplier (
    .clk(clk),
    .rst(reset),
    .A(A_internal),
    .B(B_internal),
    .mult_control(mult_control), // Paso de la estructura mult_control como argumento
    .Q_LSB(Q_LSB),
    .Y(Y),
    .ready(ready)
  );

  assign A = A_internal;
  assign B = B_internal;
  assign start = start_internal;

endmodule