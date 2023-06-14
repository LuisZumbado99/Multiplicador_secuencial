# Multiplicador Secuencial

Este proyecto consta del diseño y la implementación de un multiplicador secuencial utilizando SystemVerilog y Vivado. El multiplicador secuencial es un circuito digital sincrónico que realiza la multiplicación de dos operandos de 8 bits. El circuito consta de tres subsistemas principales: 

1. **Subsistema de lectura de datos:** Este bloque adquiere los operandos A y B de 8 bits cada uno para realizar la operación de multiplicación. Los operandos se interpretan como enteros sin signo. El subsistema se encarga de capturar y sincronizar las entradas de los operandos mediante un circuito antirrebote y un botón de inicio.

2. **Subsistema de cálculo de multiplicación:** En este bloque se realiza la multiplicación secuencial utilizando el algoritmo de Booth. 

3. **Subsistema de despliegue de resultado:** Este subsistema se encarga de mostrar el resultado de la multiplicación en un display de 7 segmentos. Se utiliza un decodificador BCD para convertir los dígitos binarios en su representación decimal y se controla el encendido de los segmentos correspondientes.

## Diagramas de bloques

A continuación se muestran los diagramas de bloques de cada subsistema:

1. **Subsistema de lectura de datos:**

<p align="center">
<img src="" alt="texto_alternativo" width="450" height="400">
</p>



2. **Subsistema de cálculo de multiplicación:**

<!--...-->

3. **Subsistema de despliegue de resultado:**

<!--...-->

## Diagramas de estado

Se han diseñado las siguientes máquinas de estados para controlar el funcionamiento del circuito:

1. **Diagrama de estados - Subsistema de lectura:**

<p align="center">
<img src="https://github.com/LuisZumbado99/Multiplicador_secuencial/blob/main/DiagramaSistemaLectura.PNG" alt="texto_alternativo" width="600" height="400">
</p>

2. **Máquina de estados - Subsistema de cálculo de multiplicación:**

<p align="center">
<img src="https://github.com/LuisZumbado99/Multiplicador_secuencial/blob/main/M%C3%A1quinaMult.PNG" alt="texto_alternativo" width="450" height="400">
</p>

3. **Máquina de estados - Subsistema de despliegue de resultado:**

<p align="center">
<img src="https://github.com/LuisZumbado99/Multiplicador_secuencial/blob/main/M%C3%A1quinaDespliegue.PNG" alt="texto_alternativo" width="500" height="400">
</p>

## Simulación funcional

Se ha realizado una simulación funcional del sistema completo para verificar su correcto funcionamiento. La simulación abarca desde la entrada de los operandos hasta el manejo de los 7 segmentos para mostrar el resultado.

<!--## Análisis de consumo de recursos y potencia

Se ha realizado un análisis del consumo de recursos en la FPGA utilizado por el circuito. Se han medido los recursos utilizados, como LUTs, FFs, y otros elementos lógicos, así como el consumo de potencia reportado por la herramienta Vivado.-->

<!--## Problemas encontrados y soluciones aplicadas

Durante el desarrollo del proyecto, se encontraron algunos problemas y desafíos. Algunos de ellos incluyeron la sincronización adecuada de las señales de entrada, la implementación correcta del algoritmo de Booth y el control preciso del despliegue de los resultados en el display de 7 segmentos. Se detallan los problemas encontrados y las soluciones aplicadas en el archivo `problems_and_solutions.txt`.-->


## Autores

Este proyecto fue desarrollado por Fiorela Chavarría como parte del curso de Diseño Lógico del Tecnológico de Costa Rica.

