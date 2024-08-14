# Ejercicios de Facu

Se trata de una serie de ejercicios provistos por por profesores del curso con el objetivo de poder obtener más noción y práctica acerca del uso de Verilog.

Para eso se nos proporcionó un programa que es un *__generador LSFR__*. 

¿Que es un generador LSFR? Significa *__Registro de desplazamiento de realimentación lineal__* y es un registro cuyo bit de entrada es función lineal de su estado anterior, es decir, existe una realimentación en dónde transmite los estados anteriores en la próxima iteración que mediante compuertas XOR generan una aleatoriedad a la salida del sistema. Dicho de otra manera, sirve para generar secuencias pseudoaleatórias, dado un número inicial sabemos cuál será el siguiente pero va a tener cierta variación en los bits.

hay 2 técnicas para esto:

- *__Fibonacci LFSR__* La característica principal es que la realimentación se realiza con xor secuenciadas con el bit de salida, el cuál se realimenta al bit de la primera entrada. Se llama de Fibonacci porque la retroalimentación sigue un patrón similar a la relación de recurrencia en la secuencia de este mismo. 

- *__Galois LFSR__* Acá las compuertas XOR son independientes y están ubicadas en lugares determinados, los cuales tomando valores de la realimentación y de iteraciones anteriores se obtiene la aleatoriedad en la secuencia. Nosotros vamos a usar este.

<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/a54640c7-0e9d-45e6-a826-a5d126ddcd13" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

Como se ve en la captura del programa

- La solapa "taps" agrega XORS en diferentes puntos del sistema modificando su largo y los valores de la secuencia.
- Se puede modificar la cantidad máxima de registros hasta 14.
- Se puede obtener el feedback del código de verilog.
- Se puede seleccionar que se genere el máximo número de secuencia.

# Actividad N1

#### Punto 1

"Se propone utilizar el software proporcionado para encontrar la combinación que genere el mayor número de combinaciones antes de que el patrón se vuelva a repetir"

Según lo investigado, para poder obtener la máxima secuencia debemos

- Elegir un tamaño de registro *__n__* grande, entre mayor lo sea, mayor será el número de combinaciones diferentes posibles. En el caso de *__LFSR__* es de *__2<sup>2</sup> - 1__*
- Estructura de muchos a uno
- Puertas XOR
- Número inicial que no sean todos los bits iguales a 0.

Por lo que con 16 taps el número máximo de la secuencia es *__65536__* y para lograrlo los taps deben ir en el *__2__*,*__3__* y *__5__*.

<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/fab6f984-bc54-44f2-b593-3af9ad95b5de" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

Luego, el código en Verilog que proporciona el programa es el siguiente


```Verilog
module LFSR16_1002D(
  input clk,
  output reg [15:0] LFSR = 65535
);

wire feedback = LFSR[15];

always @(posedge clk)
begin
  LFSR[0] <= feedback;
  LFSR[1] <= LFSR[0];
  LFSR[2] <= LFSR[1] ^ feedback;
  LFSR[3] <= LFSR[2] ^ feedback;
  LFSR[4] <= LFSR[3];
  LFSR[5] <= LFSR[4] ^ feedback;
  LFSR[6] <= LFSR[5];
  LFSR[7] <= LFSR[6];
  LFSR[8] <= LFSR[7];
  LFSR[9] <= LFSR[8];
  LFSR[10] <= LFSR[9];
  LFSR[11] <= LFSR[10];
  LFSR[12] <= LFSR[11];
  LFSR[13] <= LFSR[12];
  LFSR[14] <= LFSR[13];
  LFSR[15] <= LFSR[14];
end
endmodule
```
Con las correcciones solicitadas queda de la siguiente manera

```Verilog
module LFSR16_1002D(
  input clk, // Señal de clock que controla el desplazamiento del registro
  input [15:0] i_seed, // Entrada para la semilla del registro
  input i_valid, // Entrada para habilitar la nueva secuencia de bits
  input i_rst // Reset asincrónico para cargar la seed de forma asincrónica
  input i_soft_rst, // Reset sincrónico para cargar la seed de forma sincrónica
  output reg [15:0] LFSR // Registro de desplazamiento de 16 bits
);

wire feedback = LFSR[15]; // Señal de feedback que se obtiene del bit más significativo del registro, determina el resto.

always @(posedge clk or posedge i_rst) begin // Si hay un flanco de subida en el reloj o en el reset asincrónico se ejecuta el bloque
    if (i_rst) begin// Si el reset asincrónico está activo
        LFSR <= i_seed; // Se carga la semilla en el registro
    end else if(i_soft_rst) begin // Si el reset sincrónico está activo
    LFSR <= i_seed; // Se carga la semilla en el registro
    end else if(i_valid) begin // Si la señal de validación está activa
        LFSR[0] <= feedback;
        LFSR[1] <= LFSR[0];
        LFSR[2] <= LFSR[1] ^ feedback; // Se hace un XOR entre el bit 1 y el feedback
        LFSR[3] <= LFSR[2] ^ feedback; // Se hace un XOR entre el bit 2 y el feedback
        LFSR[4] <= LFSR[3];
        LFSR[5] <= LFSR[4] ^ feedback; // Se hace un XOR entre el bit 4 y el feedback
        LFSR[6] <= LFSR[5];
        LFSR[7] <= LFSR[6];
        LFSR[8] <= LFSR[7];
        LFSR[9] <= LFSR[8];
        LFSR[10] <= LFSR[9];
        LFSR[11] <= LFSR[10];
        LFSR[12] <= LFSR[11];
        LFSR[13] <= LFSR[12];
        LFSR[14] <= LFSR[13];
        LFSR[15] <= LFSR[14];
    end
end

endmodule
```

# Activad 2

Luego de haber generado el código se pide una verificación mediante *__testbench__* que cumpla las siguientes consignas:

- Se utilice un clock con velocidad de 10MHz.

- Se realice un reset, en donde el tiempo en el que se esté
reseteando el módulo no debe ser un valor menor a 1us ni
mayor a 250us.

- Se genere una señal de valid, en donde aleatoriamente su
valor cambie o no en cada ciclo de clock.

- Se deberá crear task en donde se cambie el valor del
puerto de entrada i_seed.

- Se deberá crear dos tasks:
  - Una que seteara por un tiempo random el reset
asincrónico.
  -  Otra que hará lo mismo con el reset sincrónico.
 
Para hacer el testbench entonces comenzamos instanciando el módulo anterior

```Verilog
module tb_LFSR16_1002D;

reg clk; // Señal de clock que controla el desplazamiento del registro
reg [15:0] i_seed; // Entrada para la semilla del registro
reg i_valid; // Señal de validación
reg i_rst; // Reset asincrónico para cargar la seed de forma asincrónica
reg i_soft_rst; // Reset sincrónico para cargar la seed de forma sincrónica
wire [15:0] LFSR; // Registro de desplazamiento de 16 bits

// Instanciación del módulo LFSR16_1002D
LFSR16_1002D LFSR (
    .clk(clk), // asignación de la señal de clock del módulo tb_LFSR16_1002D a la señal de clock del testbench
    .i_seed(i_seed),
    .i_valid(i_valid),
    .i_rst(i_rst),
    .i_soft_rst(i_soft_rst),
    .LFSR(LFSR)
);
```













 
