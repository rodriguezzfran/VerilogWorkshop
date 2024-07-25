# Verilog Workshop
El fin de este repositorio es el de dejar constancia de mis esfuerzos realizados en la capacitación de Verilog, en el marco de mi beca en la fundación Fulgor.

# Introducción 
Antes de comenzar a desarrollar es necesario ganar confianza sobre algunos conceptos importantes, de forma de no sólo saber de lo que estamos hablando, sino también de encontrar las razones de por qué hacemos las cosas de la manera en que las hacemos.

### ¿Qué es una FPGA?

- *__Field-Programmable (FP) -->__* Te indica la posibilidad de cambiar la función del hardware después de la fabricación.
- *__Gate Array (GA) -->__* Describe un lienzo en blanco de hardware capaz de ser configurado de diferentes maneras de forma que podamos generar una multitud de funciones diferentes.

Una *__FPGA__* se compone de 3 partes fundamentales:
- *__CLB:__* Llamado Configurable Logic Block, permite implementar diferentes funciones lógicas, las cuales pueden ser combinacionales o secuenciales (a través de look up tables) o almacenar estados (usando flip flops o registros).
- *__IOB:__* Input Output Block, funciona como interfaz entre pines físicos y líneas de conexión internas.
- *__SM:__* Switch Matrix, permite reconfigurar las conexiones entre los elementos de forma que la FPGA cambie sus funcionalidades, como vimos anteriormente.

Esos son algunos de los bloques más importantes, una FPGA también incluye otros bloques como el microprocesador, interfaces PCI Express, bloques de memoria RAM entre otros.



<div align="center">
  <img src="https://github.com/user-attachments/assets/4c08b739-bcec-439a-a5e6-f17d8c00dbfe" alt="FPGA Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

La adaptabilidad del hardware de las FPGA es el factor relevante, que las diferencia en cuanto a flexiblidad y eficiencia de otros tipos como las CPUs, GPUs y ASIC.

# Flujo de diseño en Vivado

### Que es vivado?
 
Vivado es un IDE creado por Xilinx para el diseño y la implementación de sistemas digitales basados en sus dispositivos FPGA. Ofrece herramientas para el diseño de hardware, síntesis, simulación, y análisis de rendimiento, entre otras funcionalidades.<br>

Cabe destacar que *__Vivado__* no es un lenguaje de programación de software, sino de descripción de hardware, además se trrrata de un lenguaje concurrente ya que sus sentencias se ejecutan en paralelo. <br>

Además, a diferencia de los otros lenguajes, *__Vivado__* no es sintetizable por una sola herramienta, sino que esta lo traduce a un diseño a nivel de compuertas lógicas llamado *__RTL__* cuyo objetivo es el de la colocación de registros en el diseño y el flujo de datos entre estos registros.

### Desarrollo de Algoritmos:

Se trata de definir las necesidades y requerimientos del diseño, estableciendo qué debe hacer el sistema y describiendo el comportamiento del sistema utilizando aritmética de punto flotante para modelar y simular el algoritmo deseado antes de implementarlo en hardware.

### Diseño a Nivel de Sistema, Verificación y Testeo:

Dividir el diseño en componentes de software y hardware, verificar que la interacción entre el software y el hardware funcione correctamente, integrar todos los componentes del sistema y realizar pruebas para asegurar que el sistema funcione como se espera.

### Desarrollo de Software y Testeo:

Desarrollo del software necesario para el sistema, diseñar las operaciones de punto flotante a punto fijo para implementarlas en hardware, optimizando la eficiencia del sistema.

### Desarrollo de Hardware y Testeo:

Implementación del diseño en hardware, convertir las operaciones de punto flotante a punto fijo, asegurando que el diseño sea eficiente y funcional en hardware, describir el diseño del hardware a nivel de Registro-Transfer-Level (RTL), verificando que el diseño hardware cumpla con las especificaciones funcionales, convirtiendo la descripción RTL a una red de puertas lógicas (netlist) que luego son conectadas según lo especificado. Verificar el rendimiento temporal del diseño y asegurarse de que siga siendo funcional después de todas las transformaciones, para luego crear el layout final del diseño para su fabricación, ya sea como ASIC o configuración en FPGA.

<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/033b046b-f7d0-4939-9f55-4fb490a0153e" alt="VIVADO Flow Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

# Proyecto de leds RGB

La idea del proyecto es aprender a usar Verilog a medida que vamos diseñando un módulo que nos permita manejar los leds de la FPGA. Estos leds deberán prenderse uno a la vez durante un tiempo definido por constantes, dos switches serán los encargados de seleccionar el tiempo de encendido, mientras otro habilita este comportamiento y el último cambiará a otro color los leds. Se aprovechará el resset del sistema para inicializar todas las variables.


<div align="center">
  <img src="https://github.com/user-attachments/assets/c661d754-a9ec-4487-b5aa-c4ecccecce42" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

### Módulos
Un modulo es una unidad fundamental de diseño que encapsula una porción del hardware. Es la estructura básica en la que se describe el comportamiento y la interconexión de componentes de un circuito digital.

Un código en *__Verilog__* tiene un módulo de nivel superior, que puede instanciar muchos otros módulos, en el diseño *__RTL__* este módulo, una vez sintetizado infiere la lógica digital.

Nuestro trabajo como diseñadores es el de implementar el hardware como módulos jerárquicamente interconectados a nivel inferior que luego forman módulos de nivel superior.

Algo importante a destacar es que los módulos son declarados e instanciados de manera similar a las clases de *__C++__* pero estas declaraciones no se pueden anidar.

Cada módulo de bajo nivel se interconectan a través de puertos (inputs y outputs). Los puertos van en listado dentro de la descripción.

```Verilog
// module set up
1 module fulladder (<port declaration>) ;
2 . . .
3 endmodule

// description
1 module fulladder (
2   output o_sum,
3   output o_c ,
4   input i_a ,
5   input i_b ,
6   input i_c ) ;
7   assign {o_c , o_sum}= i_a+i_b+i_c ;
8 endmodule
```
###

El tamaño de los puertos se definen siguiendo la nomeclatura *__MSB (Most Significant Bit)__* y *__LSB (Less Significant Bit)__*, entonces definimos *__[MSB:LSB]__* o *__[LSB:MSB]__*

```Verilog
1 module adder (
2   output [4:0] o_sum,
3   input [3:0] i_a ,
4   input [3:0] i_b ) ;
5   assign o_sum = i_a + i_b ;
6 endmodule
```
### Jerarquías

En Verilog, las jerarquías se refieren a la estructura de un diseño donde los módulos están organizados en niveles de detalle y complejidad. Un diseño jerárquico permite que un sistema complejo se divida en componentes más pequeños y manejables, cada uno descrito por su propio módulo. 

El módulo de nivel superior, conocido como *__Top Level__*, no se instancia en ningún lugar.

Cada instanciación de un módulo, una vez sintetizado, infiere una copia física del hardware con sus propias compuertas lógicas, registros y cables.

<div align="center">
  <img src="https://github.com/user-attachments/assets/36550f7b-7694-450a-97e3-2591cc49b6e6" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

### Instancias

Instanciar significa incluir un módulo dentro de otro.

La instancia consiste en:

- Nombre del módulo (fulladder).
- Nombre de la instancia (u_fulladder).
- Declaración de puertos.

El orden en la declaración de los puertos es importante dependiendo el estilo que utilicemos.

- Verilog 95 solo permite declarar los puertos según el orden que fueron definidos en la declaración del
módulo.

- Verilog 2001 incorpora la lista de puertos en la instancia sin tener en cuenta el orden que fueron definidos
en la declaración del módulo.

```Verilog
// Definición de un módulo fulladder
module fulladder (
    input wire a,      // Primer bit de entrada
    input wire b,      // Segundo bit de entrada
    output wire sum,   // Bit de suma de salida
);
    assign sum = a ^ b ^ cin;     // Suma (XOR de a, b, y cin)
endmodule

// Definición del módulo de nivel superior
module top_module (
    input wire a,      // Primer bit de entrada
    input wire b,      // Segundo bit de entrada
    output wire sum,   // Bit de suma de salida
);

    // Instancia del módulo fulladder
    fulladder u_fulladder (
        .a(a),       // Conecta el puerto 'a' del módulo top_module al puerto 'a' del módulo fulladder
        .b(b),       // Conecta el puerto 'b' del módulo top_module al puerto 'b' del módulo fulladder
        .sum(sum),   // Conecta el puerto 'sum' del módulo top_module al puerto 'sum' del módulo fulladder  
    );

endmodule
```

### Valores Lógicos

Un *__bit__* en Verilog puede tomar uno de cuatro posibles valores <br>
- *__0 -->__* Cero, Lógico Bajo, Falso o Massa
- *__1 -->__* Uno, Lógico Alto, Potencia
- *__X -->__* Zona de indeterminación
- *__Z -->__* Alta impedancia, desconectado o puerto Tri-State

Cabe destacar que *__X__* no es valido en un circuito real, ya que no hay valores deconocidos en un circuito reales, simplemente Verilog no puede decidir entre 0 o 1.

### Tipos de Datos

- *__Nets__*

  Son utilizados para conectar diferentess partes del diseño, representan una conexión entre componentes, similar a un cable físico en hardware real.
  
  Sus principales tipos son:
  - *__wire:__* Es el tipo de net más común y básico, Se utiliza para conectar dos puntos en un diseño y transportar señales. No retiene su valor, simplemente propaga el valor de la fuente.
  - *__tri:__* Similar a wire, pero utilizado para representar buses de tres estados. Puede estar en un estado de alta impedancia (Z).
  - *__wor (wired OR):__* Representa una conexión donde los conductores están conectados con una operación OR cableada. Si varios drivers intentan controlar la net, el resultado es la operación OR de las señales.
  - *__trior (tri-state wired OR):__* Similar a wor, pero puede estar en un estado de alta impedancia.
  - *__wand (wired AND):__* Representa una conexión donde los conductores están conectados con una operación AND cableada. Si varios drivers intentan controlar la net, el resultado es la operación AND de las señales.
  - *__triand (tri-state wired AND):__* Similar a wand, pero puede estar en un estado de alta impedancia.
  - *__tri0:__* Similar a tri, pero por defecto está en estado bajo (0) cuando no está siendo conducido.
  - *__tri1:__* Similar a tri, pero por defecto está en estado alto (1) cuando no está siendo conducido.
  - *__supply0:__* Representa una conexión a una fuente de alimentación de nivel lógico bajo (0). No puede ser conducido por ninguna otra fuente.
  - *__supply1:__* Representa una conexión a una fuente de alimentación de nivel lógico alto (1). No puede ser conducido por ninguna otra fuente.
  - *__trireg:__* Similar a tri, pero retiene su valor anterior cuando está en alta impedancia. Utilizado para modelar almacenamiento de carga en circuitos analógicos.

- *__Register__*

  - Se usan para el almacenamiento implícito, es decir, que al asignarle un determinado valor a una variable de este estilo, a menos que se modifique dicha variable, conservará el valor previamente asignado.
  
  - Las variables *__reg__* es inferida como registro o dispositivo de almacenamientoi cuándo tiene asociado una señal de clock.

- *__Integer__*
  
  - integer es un tipo de dato de número entero con signo. 
  
  - Se utiliza para representar valores enteros que pueden ser positivos o negativos.
  
  - En la mayoría de las simulaciones de Verilog, los enteros son de 32 bits de tamaño.
  
  - Utilizado frecuentemente en bucles, contadores y para almacenar valores enteros temporales en tareas y funciones.

- *__Time__*

  - Time es un tipo de dato utilizado para almacenar el valor del tiempo simulado.
  
  - Generalmente es una variable de 64 bits sin signo, adecuada para representar un rango amplio de valores de tiempo.
  
  - Se utiliza para capturar o almacenar el tiempo actual de la simulación, hacer mediciones de tiempo y calcular retrasos.

- *__Real__*
  
  - real es un tipo de dato de punto flotante.
  
  - Se utiliza para representar números reales con decimales, similar a los números de punto flotante en otros lenguajes de programación.
  
  - Utilizado para cálculos que requieren precisión decimal, como operaciones matemáticas complejas, valores analógicos y modelado de comportamientos continuos.
<br>

Y para que es todo esto? para lo que conocemos como *__Declaración__*. Una declaración sirve para definir y nombrar variables que se utilizarán en el diseño de hardware descrito.

Que tiene que contener una declaración? 
- *__Tipo de dato:__* Como los mencionados anteriormente, aunque los más usados son wire/reg), si la variable es

- *__Signed/Unsigned:__* Por defecto siempre son unsigned, entendiendo a esto como que los bits de la variable representan la magnitud del número)

- *__Range:__* Define el número de bits o ancho de palabra de la variable. Si es suna memoria, entonces la segunda difinición determina el número de filas. Si no se define el valor es un bit.

Entonces, una declaración de variable quedaría de la siguiente manera
```Verilog
wire / reg <signed / unsigned> [ <range or width_word> ] <name> [ <range or len_memory> ] ;
````
tipicamente los mas significativos estan a la izquierda y los menos significativos a la dereca. Esto puede varias segun el protocolo así que hay que estar atento a esto para no provocar inconsitencias en el diseño digital, tanto para diseño como para validación




























