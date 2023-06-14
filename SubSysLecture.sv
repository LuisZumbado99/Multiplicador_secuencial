module SubSysLecture (
  input logic clk,         // Reloj
  input logic reset,       // Señal de reinicio asincrónico (activo bajo)
  input logic btn,         // Push button de entrada
  output logic [7:0] A,    // Operando A de 8 bits
  output logic [7:0] B,    // Operando B de 8 bits
  output logic start       // Señal de inicio de la operación
);

  logic [7:0] btn_stages[3:0];         // Registros que almacenan las etapas del circuito antirrebote del botón
  logic [7:0] btn_stages_delayed[3:0]; // Registros que almacenan las etapas del circuito antirrebote del botón, pero con retardo
  logic [7:0] A_tmp;                   // Variable temporal A
  logic [7:0] B_tmp;                   // Variable temporal B
  logic capture_done;                  // Variable para captura de operandos cuando se completa

  // Circuitos antirrebote de 4 etapas
  
  /* Cuatro registros FF: Registros que eliminan el efecto 
  de rebote en la señal de btn */
  FlipFlopRegister #(8) ff_btn_stages[3:0] (
    .clk(clk),
    .reset(reset),
    .enable(1'b1), // se establece en 1 para que funcionen normalmente los registros
    .data_in(btn), 
    .data_out_array(btn_stages)
  );

  /* Cuatro registros FF: almacenan el estado filtrado del botón
  después de haber pasado por las etapas antirrebote anteriores.  
  Esto permite retrasar la señal filtrada en el tiempo, 
  asegurando que la salida sea estable y libre de rebotes.*/
  FlipFlopRegister #(8) ff_btn_stages_delayed[3:0] (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .data_in_array(btn_stages),
    .data_out_array(btn_stages_delayed)
  );

   /* Registro FF: captura el valor del operando A */
  FlipFlopRegister #(8) reg_A (
    .clk(clk),
    .reset(reset),
    .enable(capture_done), // Solo captura el valor de A_tmp cuando capture_done = 1
    .data_in(A_tmp), 
    .data_out(A)
  );

   /* Registro FF: captura el valor del operando B  */
  FlipFlopRegister #(8) reg_B (
    .clk(clk),
    .reset(reset),
    .enable(capture_done),
    .data_in(B_tmp),
    .data_out(B)
  );

  // Captura de los operandos A y B
  always_ff @(posedge clk, negedge reset) begin
    if (~reset) begin
      A_tmp <= 8'h00; // Se inicializan en valores hexadecimales para estableerlos en valores conocidos
      B_tmp <= 8'h00;
      capture_done <= 1'b0; // Se establece a 0
    end else begin
      if (btn_stages_delayed[3] && ~btn_stages_delayed[0]) begin // Esta condición captura los valores actuales de A y B
        A_tmp <= A;
        B_tmp <= B;
        capture_done <= 1'b1; // Captura realizada
      end else begin  // (btn_stages_delayed[3] && ~btn_stages_delayed[0]) no se cumple
        A_tmp <= A_tmp; 
        B_tmp <= B_tmp;
        capture_done <= 1'b0; // Establece la señal a 0
      end
    end
  end

  // Espera hasta que el boton vuelva a su estado inicial
  always_ff @(posedge clk, negedge reset) begin 
    if (~reset) begin
      start <= 1'b0; // No se ha iniciado la operación - Está esperando a que se cumplan  las condiciones
    end else begin
      if (capture_done && btn_stages_delayed[0]) begin
        start <= 1'b0; // Se establece en 0
      end else if (capture_done && ~btn_stages_delayed[0]) begin
        start <= 1'b1; // Se establece en 1
      end else begin
        start <= start; // Mantiene su valor actual
      end
    end
  end

endmodule