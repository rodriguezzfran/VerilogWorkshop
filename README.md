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

Por lo que con 16 taps el número máximo de la secuencia es *__255__* y para lograrlo los taps deben ir en el *__2__*,*__3__* y *__4__*.

<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/a9e1ab76-9441-497d-9e4e-67f6f055d970" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

Luego, el código en Verilog que proporciona el programa es el siguiente


```Verilog
module LFSR8_11D(
  input clk,
  output reg [7:0] LFSR = 255
);

wire feedback = LFSR[7];

always @(posedge clk)
begin
  LFSR[0] <= feedback;
  LFSR[1] <= LFSR[0];
  LFSR[2] <= LFSR[1] ^ feedback;
  LFSR[3] <= LFSR[2] ^ feedback;
  LFSR[4] <= LFSR[3] ^ feedback;
  LFSR[5] <= LFSR[4];
  LFSR[6] <= LFSR[5];
  LFSR[7] <= LFSR[6];
end
endmodule

```
Con las correcciones solicitadas queda de la siguiente manera

```Verilog
module LFSR16_1002D(
  input wire clk,
  input wire i_valid, // signal to indicate that we can genereate a new bit secuence 
  input wire [7:0 ] i_seed, // new initial seed
  input wire i_rst, // reset signal
  input wire i_soft_reset, // soft reset signal

  output reg [7:0] LFSR
);

wire feedback = LFSR[7] ^ (LFSR[6:0]==7'b0000000);

parameter seed = 8'b00000001 ;

// inside the always block the i_rst has the priority over the i_soft_reset and the other blocks are secuentual
always @(posedge clk or posedge i_rst) begin // i_rst is for an eventual hard reset of the system
  if(i_rst) begin
    LFSR <= seed;
  end
  else if(i_soft_reset) begin
    LFSR <= i_seed;
  end
  else if (i_valid) begin
    LFSR[0] <= feedback;
    LFSR[1] <= LFSR[0];
    LFSR[2] <= LFSR[1] ^ feedback;
    LFSR[3] <= LFSR[2] ^ feedback;
    LFSR[4] <= LFSR[3] ^ feedback;
    LFSR[5] <= LFSR[4];
    LFSR[6] <= LFSR[5];
    LFSR[7] <= LFSR[6];
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
`timescale 1ns / 1ps // the first number is the time unit, the second is the time precision

module tb_lfsr;

// now the inputs and outputs are regs 'cause now these have values
reg clk;
reg i_valid;
reg i_rst;
reg i_soft_reset;
reg [7:0] i_seed;

// the output is a wire 'cause it's a signal that we can't change
wire  [7:0] LFSR;

// the module that we want to test
LFSR16_1002D lfsr(
  .clk(clk),
  .i_valid(i_valid),
  .i_rst(i_rst),
  .i_soft_reset(i_soft_reset),
  .i_seed(i_seed),
  .LFSR(LFSR)
);
```

Ahora debemos generar la señal del clock de 10MHZ

```Verilog
// the clock signal, it has to be a 10MHz signal so 1/10MHz = 100ns
// So it has to be 50ns high and 50ns low
initial begin
  clk = 0;
  forever #50 clk = ~clk;
end
```
La task para cambiar el valor de la seed se implementa de la siguiente forma, usando un retardo de 100ns paraa estabilizar el sistema

```Verilog
// task to change the value of i_seed
task change_seed;
  input [7:0] new_seed; // vivado let us to choose the new seed
  begin
    @(posedge clk); // wait for the next rising edge
    i_seed = new_seed;
    i_soft_reset = 1;
    @(posedge clk); // wait for the next rising edge
    i_soft_reset = 0;
  end
endtask
```
Las task para los reset se implementan de la siguiente manera, suponiendo que el tiempo de reset mencionado era para los 2 reset
```Verilog
// task to stay in the asincronous reset state for a random time between 1 and 250 us
task async_reset;
  integer async_delay;
  begin
    async_delay = (($urandom % 250) + 1) * 1000; // random time between 1 and 250 us
    i_rst = 1;
    #(async_delay);
    @(posedge clk);
    i_rst = 0;
  end
endtask

// task to generate a syncronous reset
task sync_reset;
  integer sync_delay;
  begin
    sync_delay = (($urandom % 250) + 1) * 1000; // random time between 1 and 250 us
    i_soft_reset = 1;
    #(sync_delay);
    @(posedge clk);
    i_soft_reset = 0;
  end
endtask
```
Finalmente, usamos los estímulos

```Verilog
// start of the test
initial begin
  
  $display("Start of the simulation");
  // take the system to a know state
  i_rst = 0;
  i_soft_reset = 0;
  i_valid = 0;
  i_seed = 8'b10101010;

  // wait for the system to stabilize and make a reset
  #100;
  i_rst = 1;
  #100; 
  i_rst = 0;

  // now make the i_valid signal change forever for a normal test
  forever begin
    @(posedge clk);
    i_valid = $urandom % 2;
  end
end

// we divide the initial block in two because the forever block is infinite

initial begin

  // waits 200 microseconds
  #200000;
  // now we print the current value of the LFSR
  // and trigger the async_reset task
  $display("LFSR = %b", LFSR);
  $display("Triggering async_reset task");
  async_reset;
  $display("LFSR = %b", LFSR);

  // waits 200 microseconds
  #200000;
  // now we trigger the sync_reset task
  $display("Triggering sync_reset task");
  sync_reset;
  $display("LFSR = %b", LFSR);

  // waits 200 microseconds
  #200000;
  // now we change the seed to 8'b11111111
  $display("Changing seed to 8'b11111111");
  $display("Time: %t", $time);
  change_seed(8'b11111111);
  $display("LFSR = %b", LFSR);

  //waits 200 microseconds
  #200000;

  // end of the simulation
  $finish;
end
endmodule
```

# Activad 3  

Para la actividad 3 se pide crear test que cumplan con las siguientes consignas

- Chequear la periodicidad del generador.
- CHequear la periodicidad del generador con diferentes seeds random

Para ambos test se usaron 2 task

```verilog
`timescale 1ns / 1ps

module tb_perodicity;

reg clk;
reg i_valid;
reg i_rst;
reg i_soft_reset;
reg [7:0] i_seed;

wire  [7:0] LFSR;

LFSR16_1002D lfsr(
  .clk(clk),
  .i_valid(i_valid),
  .i_rst(i_rst),
  .i_soft_reset(i_soft_reset),
  .i_seed(i_seed),
  .LFSR(LFSR)
);

initial begin
  clk = 0;
  forever #50 clk = ~clk;
end

task normal_periodicity;
    integer count;
    begin
        @(posedge clk);
        count = 0;
        i_seed = 8'b00000001;
        i_soft_reset = 1;
        @(posedge clk);
        i_soft_reset = 0;

        //wait for the LFSR to reach the seed
        #100

        while (LFSR != i_seed) begin
            @(posedge clk);
            count = count + 1;
        end
        $display("The period is %d", count);
    end
endtask

task random_periodicity;
    integer count;
    input [7:0] new_seed;
    begin
        @(posedge clk);
        count = 0;
        i_seed = new_seed;
        i_soft_reset = 1;
        @(posedge clk);
        i_soft_reset = 0;

        //wait for the LFSR to reach the new seed
        #100
        while (LFSR != new_seed) begin
            @(posedge clk);
            count = count + 1;
        end
        $display("The period is %d", count);
    end
endtask

// start of the test
initial begin
    $display("Start of the simulation");

    // take the system to a know state
    i_rst = 0;
    i_soft_reset = 0;
    i_valid = 0;

    // wait for the system to stabilize
    #100;

    // now make the i_valid signal change forever for a normal test
    forever begin
        @(posedge clk);
        i_valid = ~i_valid;
    end
end

initial begin
    
    //waits and ejecutes the normal periodicity task
    #20000
    normal_periodicity;

    //waits and ejecutes the random periodicity task
    #200000
    random_periodicity($urandom);

    $finish;
end
endmodule
````
Luego las actividades pedían la realización de un *__Checker__* que se conecte a la salida del LFSR, la idea de esto es tener una nueva señal *__o_lock__* que permita que el checker se bloquee luego de haber recibido 5 valores válidos del LFSR, en caso contrario, si recibe 3 inválidos se debloquea. Esto último se implementó con una máquina de estados.

```verilog
module checker
(
    input wire clock,
    input wire rst,
    input wire soft_rst,
    input wire i_valid,
    input wire [7:0] i_lfsr, // this is the LFSR generator output, now it is the input
    output reg o_lock // this is the output for lock or unlock the LFSR
);

// state machine states
localparam UNLOCK = 1'b0; // this is the unlock state
localparam LOCK = 1'b1; // this is the lock state

// internal signals for the state machine
reg     next_state;
reg     state;

// internal signals for the counters
reg [3:0] valid_counter;
reg [3:0] valid_counter_next; 
reg [1:0] invalid_counter;
reg [1:0] invalid_counter_next;

reg       resync; // this is the resync signal
reg [7:0] lfsr_local; // this is the local LFSR generator
wire feedback; // this is the feedback signal

// state machine logic
always@(*) begin
    
    case(state)

        UNLOCK:begin // here i'm unlock so i have to check the valids, not the invalids

            if (valid_counter >= 4'd5) begin // if i'm unlock and i have 5 valids, i go to lock

                next_state = LOCK; // next state is lock
                valid_counter_next = 'd0; // reset the valid counter
            
            end
            else begin

                if  (i_lfsr != lfsr_local) begin // if i'm unlock i'm out of sync, then if the secuence is still invalid i have to resync
                    
                    resync = 1; // resync signal is 1
                    valid_counter_next = 'd0; // reset the valid counter

                end
                else begin // if the secuence is valid, i don't have to resync

                    resync = 0; // resync signal is 0
                    valid_counter_next = valid_counter + 1'b1; // increment the valid counter
                
                end

                next_state = UNLOCK; // if i don't have 5 valids, i stay in unlock state

            end

            invalid_counter_next = 'd0; // don't need to check the invalids
        end

        LOCK: begin // here i'm lock so i have to check the invalids, not the valids

            if (invalid_counter >= 2'd3) begin // if i'm lock and i have 3 invalids, i go to unlock cause i'm out of sync
                
                next_state = UNLOCK; // next state is unlock
                invalid_counter_next = 'd0; // reset the invalid counter
                resync = 1; // resync signal is 1
            
            end
            else begin
                if  (i_lfsr != lfsr_local) begin // if i'm lock i'm out of sync, then have to 
                    invalid_counter_next = invalid_counter + 1'b1;
                    resync = 0; // no need to resync because the unlock state will do it
                    
                end
                else begin // if the secuence is valid, i don't have to resync
                    invalid_counter_next = 'd0; // reset the invalid counter
                    resync = 0;
                end

                next_state = LOCK; // if i don't have 3 invalids, i stay in lock state
            end

            valid_counter_next = 'd0; // don't need to check the valids
        end
        default:
        begin
            next_state = 0;
            valid_counter_next = 0;
            invalid_counter_next = 0;
            resync = 0;
            state = 0;
        end
    endcase
end

// Valid and invalid counters
always@(posedge clock or posedge rst)
begin
    if (rst) begin
       valid_counter <= 'd0;
    end
    else if (soft_rst) begin
        valid_counter <= 'd0;
    end
    else if (i_valid) begin
        valid_counter <= valid_counter_next;
    end
end

always@(posedge clock or posedge rst)
begin
    if (rst) begin
       invalid_counter <= 'd0;
    end
    else if (soft_rst) begin
        invalid_counter <= 'd0;
    end
    else if (i_valid)
    begin
        invalid_counter <= invalid_counter_next;
    end
end

// state machine
always@(posedge clock or posedge rst)
begin
    if (rst) begin
        state   <= UNLOCK;
    end
    else begin
        state   <= next_state;
    end
end

// feedback generation for the LFSR, if the LFSR is out of sync, the feedback is the input LFSR
assign feedback = (resync) ?    i_lfsr[7] ^ (i_lfsr[6:0]==7'b0000000):
                                lfsr_local  [7] ^   (lfsr_local[6:0]==7'b0000000);

always @(posedge clock or posedge rst) begin
    if (rst) begin
        lfsr_local <= 8'hFF;
    end
    else if (soft_rst) begin
        lfsr_local <= 8'hFF;
    end
    else if (resync & i_valid) begin
        lfsr_local[0] <= feedback;
        lfsr_local[1] <= i_lfsr[0];
        lfsr_local[2] <= i_lfsr[1] ^ feedback;
        lfsr_local[3] <= i_lfsr[2] ^ feedback;
        lfsr_local[4] <= i_lfsr[3] ^ feedback;
        lfsr_local[5] <= i_lfsr[4];
        lfsr_local[6] <= i_lfsr[5];
        lfsr_local[7] <= i_lfsr[6];
    end
    else if (i_valid) begin
        lfsr_local[0] <= feedback;
        lfsr_local[1] <= lfsr_local[0];
        lfsr_local[2] <= lfsr_local[1] ^ feedback;
        lfsr_local[3] <= lfsr_local[2] ^ feedback;
        lfsr_local[4] <= lfsr_local[3] ^ feedback;
        lfsr_local[5] <= lfsr_local[4];
        lfsr_local[6] <= lfsr_local[5];
        lfsr_local[7] <= lfsr_local[6];
    end
end

// output logic for o_lock
always @(posedge clock or posedge rst) begin
    if (rst) begin
        o_lock <= 1'b0;
    end else begin
        o_lock <= (state == LOCK);
    end
end


endmodule
```

Finalmente el TOP es el encargado de conectar ambos módulos y de incluir la lógica necesaria para poder introducir errores en el input del checker para proabr su funcionalidad mediante un nuevo puerto llamado *__i_corrupt__* que niego el bit 0 de la secuencia.

```verilog
module top_LFSR_Checker(
  input wire clk
);

  wire [7:0] i_lfsr; // output from the LFSR, input to the Checker
  wire [7:0] i_seed;
  wire [7:0] corrupted_lfsr; // signal to hold the corrupted LFSR

  wire rst;
  wire soft_rst;
  wire i_valid;
  wire i_corrupt; 
  
  wire o_lock;

  // Apply corruption to the LFSR output (negate bit 0 if i_corrupt is active)
  assign corrupted_lfsr = i_corrupt ? {i_lfsr[7:1], ~i_lfsr[0]} : i_lfsr;

  // LFSR's instance
  LFSR16_1002D lfsr_inst (
    .clk(clk),
    .i_valid(i_valid),
    .i_seed(i_seed),
    .i_rst(rst),
    .i_soft_reset(soft_rst),
    .LFSR(i_lfsr)
  );

  // Checker's instance with corrupted input
  checker checker_inst (
    .clock(clk),
    .rst(rst),
    .soft_rst(soft_rst),
    .i_valid(i_valid),
    .i_lfsr(corrupted_lfsr), // feed the potentially corrupted sequence
    .o_lock(o_lock)
  );

  
  //! vio instance
  vio u_vio (
      .clk_0       (clk),
      .probe_in0_0  (o_lock),
      .probe_out0_0 (i_corrupt),
      .probe_out1_0 (i_valid),
      .probe_out2_0 (rst),
      .probe_out3_0 (soft_rst),
      .probe_out4_0 (i_seed)       
  );


  //! ila instance - signals to check
  ila u_ila (
      .clk_0    (clk),
      .probe0_0 (i_valid),
      .probe1_0 (i_lfsr)  
  );


endmodule
```
Su testbench es el siguiente 

```verilog
module tb_top_LFSR_Checker();

  // Clock and reset
  reg clk;
  reg rst;
  reg soft_rst;
  reg i_valid;
  reg i_corrupt;
  
  reg [7:0] i_seed;

  // Output from top module
  wire o_lock;

  // Instancia del módulo top
  top_LFSR_Checker uut (
    .clk(clk),
    .rst(rst),
    .soft_rst(soft_rst),
    .i_valid(i_valid),
    .i_seed(i_seed),
    .o_lock(o_lock),
    .i_corrupt(i_corrupt)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #50 clk = ~clk; // 100 MHz clock
  end

  // Test sequence
  initial begin
    $display("Start of the simulation");
    // Initialize signals
    rst = 0;
    soft_rst = 0;
    i_valid = 0;
    i_corrupt = 0; // start with no corruption
    i_seed = 8'b11101110;

    // Wait for the system to stabilize and reset
    @(posedge clk);
    rst = 1;
    @(negedge clk);
    rst = 0;

    // Activate valid signal in a toggle pattern
    forever begin
      @(posedge clk);
      i_valid = ~i_valid;
    end
  end

  // Simulate corruption after a certain time
  initial begin
    // Let the system run normally for some time
    #10000;
    $display("Corrupting the sequence");
    @(posedge i_valid);
    i_corrupt = 1; // Start corrupting the LFSR output
    #1000 @(posedge i_valid);
    i_corrupt = 0; // Stop corrupting the LFSR output
    

    // Run for some time and observe outputs
    #5000;

    $display("Corrupting the sequence");
    @(posedge i_valid);
    i_corrupt = 1; // Start corrupting the LFSR output
    #1000 @(posedge i_valid);
    i_corrupt = 0; // Stop corrupting the LFSR output

    // Run for some time and observe outputs
    #5000;

    // Stop simulation
    $finish;
  end


endmodule
```





























 
