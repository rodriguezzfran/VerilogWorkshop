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

Que tiene que contener una *__declaración__*? 
- *__Tipo de dato:__* Como los mencionados anteriormente, aunque los más usados son wire/reg), si la variable es

- *__Signed/Unsigned:__* Por defecto siempre son unsigned, entendiendo a esto como que los bits de la variable representan la magnitud del número)

- *__Range:__* Define el número de bits o ancho de palabra de la variable. Si es suna memoria, entonces la segunda difinición determina el número de filas. Si no se define el valor es un bit.

Entonces, una declaración de variable quedaría de la siguiente manera
```Verilog
wire / reg <signed / unsigned> [ <range or width_word> ] <name> [ <range or len_memory> ] ;
````
tipicamente los mas significativos estan a la izquierda y los menos significativos a la dereca. Esto puede varias segun el protocolo así que hay que estar atento a esto para no provocar inconsitencias en el diseño digital, tanto para diseño como para validación. 

Las *__constantes__* son muy similares a las variables y de igual forma pueden ser de cualquier tamaño. Se pueden escribir en diferentes formatos, como el *__decimal__*, *__binario__* o *__hexadecimal__* aunque generalmente el decimal es el formato predefinido.

Una constante se representa de la forma:
- *__Width__*: Tamaño de la constante.
- *__Type__*: Tipo de formato.
- *__Value__*: Valor representado.

En caso de no especificar nada se tomarpa como entero con signo, en cambio, si definimos tamaño y formato se toma como entero sin signo. Podemos ver algunos ejemplos a continuación.

```Verilog
4'b1010    // Binario, 4 bits, valor 10 (decimal)
8'hFF      // Hexadecimal, 8 bits, valor 255 (decimal)
12'o755    // Octal, 12 bits, valor 493 (decimal)
6'd35      // Decimal, 6 bits, valor 35 (decimal)
````
# Los Cuatro Niveles de Abstracción

### Nivel de Comportamiento

Es el nivel más alto de abstracción, describe lo que hace el circuito sin especificar cómo se implementa. Se utiliza principalmente para escribir *__testbenches__* y modelos de referencia (que veremos más adelante).

Este nivel proporciona construcciones de lenguaje de alto nivel como *__for__*, *__while*__, *__repeat__* y *__case__*.

Existen herramientas de síntesis de nivel de comportamiento que toman un modelo completo y lo sintetizan, pero la lógica no suele ser óptima, sobretodo si tenemos que prestar atención a cosas como el área, potencia y velocidad.

*__Verilog__* restringe todas las declaraciones de comportamiento para ser encerrado en un bloque de procedimiento dónde todas las variables en el lado izquierdo de las sentencias deben declararse como *__reg*__, mientras que los operandos del lado derecho en las expresiones pueden ser *__reg__* o *__wire__*.

Generalmente hay 2 tipos de bloqueo de procedimiento los cuales contienen una o varias instrucciones por bloque. Una instrucción de asignación utilizada en un bloque de procedimiento se denomina asignación de procedimiento.

*__Bloque Initial__*
- Se utiliza para realizar inicializaciones y tareas que se ejecutan solo una vez al comienzo de la simulación.
- Comienza en t = 0 en tiempo de simulación
- No es sintetizable, sólo sirve para estímulos en simulación.
- Si hay más de un bloque de estímulos, se ejecutan todos concurrentemente.

```Verilog
module testbench;
    reg clk;
    reg reset;
    reg [3:0] data;

    // Bloque initial para inicializar señales y aplicar estímulos
    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 1;
        data = 4'b0000;

        // Esperar 10 unidades de tiempo
        #10; // '#' significa unidad de tiempo
        
        // Dejar de resetear el sistema
        reset = 0;

        // Aplicar algunos valores de datos luego de 5 unidades de tiempo
        #5 data = 4'b1010;
        #5 data = 4'b0101;
        
        // Finalizar la simulación
        #20 $finish;
    end
endmodule
```

*__Bloque Always__*

- Se usa para describir la lógica secuencial y conmbinacional.
- Se ejecuta de forma continua y repetidamente durante la simulación y puede activarse por diferentes eventos tales como *__posedge__* (flanco positivo) o *__negedge__* (flanco negativo).
- Se puede ejecutar en respuesta a eventos especificos conteniendo una lista de instrucciones.
- Es sintetizable.

```Verilog
module counter(
    input wire clk,
    input wire reset,
    output reg [3:0] count
);

    // Bloque always para la lógica secuencial del contador
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reinicia el contador cuando reset es alto
        end else begin
            count <= count + 1; // Incrementa el contador en cada flanco positivo del reloj
        end
    end

endmodule
```

*__Asignación bloqueante ( = )__*

- Es una asignación regular dentro de un bloque de procedimiento como los vistos anteriormente.
- Se llaman bloqueantes porque cada asignación bloquea la ejecución de las siguientes asignaciones en la secuencia.
- Generalmente, para que el códdigo RTL deduzca como es la lógica combinatoria estas asignaciones de procedimiento bloqueantes se colocan dentro del mismo bloque Always.
- Hay una lista de sensibilidad que permite que sólo se ejecute un bloque cuándo cambia alguna de las variables de la lista, que generalmente van entre paréntesis separadas por una etiqueta "or". A partir de *__Verilog-2001__* se usan listas separadas por coma. También se admite *.

```Verilog
module combinational_logic (
    input wire [3:0] a,  // Entrada de 4 bits a
    input wire [3:0] b,  // Entrada de 4 bits b
    output reg [3:0] sum,  // Salida de 4 bits para la suma
    output reg [7:0] product  // Salida de 8 bits para el producto
);

    // Bloque always que se ejecuta cuando cambia cualquiera de las señales de la lista de sensibilidad
    always @(a or b) begin
        // Asignación bloqueante para la suma
        sum = a + b;  // La suma de a y b se asigna a sum
        
        // Asignación bloqueante para el producto
        product = a * b;  // El producto de a y b se asigna a product
    end

endmodule
```
Ahí vemos como el bloque always sólo se ejecutará ante un cambio de estado de *__a__* o *__b__*, luego la sentencia `product = a * b` no se ejecutará hasta que no termine la suma que la bloquea, de esta manera logramos generar la lógica combinacional de forma secuencial.

Sobre las listas de sensibilidad son los que se ponen entre paréntesis dentro del bloque always, cuyo cambio de estado es el que dispara la ejecución del bloque. A lo que se refiere la lista de arriba es que pueden estar separados por la sentencia or, una coma o directamente un *, el cuál significa que será sensible a cualquier cambio de las señales leídas dentro del bloque.

````Verilog
always @(a or b) begin
    // Código del bloque
end

always @(a, b) begin
    // Código del bloque
end

always @(*) begin
    // Código del bloque
end
````

*__Asignación no bloqueante ( <= )__*

- Se diferencian de las bloqueantes en que permiten la ejecución en paralelo de múltiples operaciones dentro de un bloque en lugar de frenarlas hasta que termine la anterior.
- A diferencia de las bloqueantes que se asignan a variables en el momento, acá el simulador no actualiza inmediatamente la variable del lado izquierdo, sino que se almacena en una variable temporal. Luego, cuándo todas las asignaciones del bloque *__always__* hayan terminado, el simulador asigna al mismo tiempo todos los valores almacenados en las variables temporales a las reales.
- Este mecanismo asegura que todas las operaciones del *__always__* se vewan como si ocurriesen simultaneamente al final del ciclo del reloj.
- Las variables del lado izquierdo son del tipo *__reg__* logicamente.
- Se usa para inferir lógica sincrónica.
- Todas las asignaciones se realizan en paralelo.

*__Bloqueante vs no-Bloqueante__*
La asignación procedural no bloqueante (<=) debe usarse sólo para modelar lógica secuencial y la asignación procedural bloqueante (=) debe usarse sólo para modelar lógica combinacional.
Por ninguna razón hay que mezclar ambas.

*__Control de tiempo__*

Verilog proporciona diferentes maneras de modelar el tiempo y los retardos, aunque internamente trabaja sin unidades de tiempo. Paras poder simular tiempo en cualquier instancia del diseño se puede ausar la variable especial `$time`.

- Se pueden insertar retardos en código colocando `*#<numero>`.
- La simulación detiene la ejecución hasta que hayan pasado esa cantidad de unidades de tiempo, mientras se ejecutan otros bloques en paralelo.
- No se usa para síntesis.

Otra directiva de control de tiempo es `@` que modela el control basado en enventos (recordemos que ya la usamos para los bloques always). 

- Esta directiva detiene la ejecución de la sentencia hasta que sucede el evento.
- Esta construcción se usa para modelar lógica combinacional y secuencial en bloques procedurales.

En simulación se puede asignar una unidad de tiempo a los retardos mediante el uso de *__timescale__* que se define como `timescale <time_unit> / <time_precision>`
- La unidad de tiempo definirá la unidad de los retardos en simulación y la unidad de precisión definirpá como se redondean antes de ser usados en la simulación.


*__Sistema Realimentado__*

Sucede cuándo tenés un circuito combinacional único que se realimenta (sobretodo en circuitos dónde las entradas dependen de las salidas de otros bloques tales como contadores o registros), lo cuál provoca que no sea sintetizado ni simulado correctamente, se los suele llamar *__loops combinacionales__* y hay que evitarlos.
La señal podría seguir cambiando de manera indefinida porque cada cambio en la salida afecta a la entrada y viceversa, por lo tanto, Para evitar loops combinacionales, debes insertar registros en el camino de retroalimentación. Un registro almacena el valor actual y lo mantiene estable hasta la siguiente actualización.

*__Importancia del reset__*
El reset es crucial porque garantiza que el circuito comienza en un estado conocido. Sin este cualquier valor previo almacenado en un registro puede corromper cálculos futuros ya que un valor indefinido como *__x__* podría propagarse por el circuito. Puede ser síncrono o asíncrono y, en ambos casos, activo por alto o bajo.

- *__Reset sincrónico__*: El reset sólo afecta alk registro cuándo el reloj tiene un flanco positivo. E útil cuándo se quiere que el reset ocurra en sincronía con el resto del circuito .
- *__Reset Asíncrono__*: El reset puede ocurrir en cualquier momento, independientemente del reloj. Es útil cuándo se quiere que el reset tenga efecto inmediaqto, sin esperar al siguiente flanco.

*__Sentencia CASE__*

Muy parecido al de C y otros lenguajes

- Evalúa una expresión y en función de su valor ejecuta la sentencia o grupo de sentencias agrupadas en el caso que coincida.
- En caso de no cubrir sus posibles valores, se puede usar un caso *__default__*.
- Existen dos versiones extra las cuales son *__casex__* (para valores indeterminados) y *__casez__* (para valores de alta impedancia).

Ejemplo de *__casez__*

````Verilog
module casez_example;
    reg [3:0] in;
    reg out;

    always @(in) begin
        casez (in)
            4'b10?1: out = 1;  // Coincide con 4'b1001 o 4'b1011
            4'b01z1: out = 0;  // Coincide con 4'b0101 o 4'b0111
            default: out = 1'bx; // Desconocido
        endcase
    end
endmodule
````
En el primer caso (4'b10?1), el ? indica que el tercer bit de in puede ser 0 o 1, por lo que esta cláusula coincidirá tanto con 4'b1001 como con 4'b1011.
En el segundo caso (4'b01z1), el z en el tercer bit se trata como un "don't care", por lo que coincidirá con 4'b0101 o 4'b0111, sin importar si el tercer bit es 0, 1, o z.

Ejemplo de *__casex__*

```Verilog
module casex_example;
    reg [3:0] in;
    reg out;

    always @(in) begin
        casex (in)
            4'b1xx1: out = 1;  // Coincide con 4'b1001, 4'b1011, 4'b1101, 4'b1111, 4'b1zx1, 4'b1xz1, 4'b1zz1
            4'b01z1: out = 0;  // Coincide con 4'b0101, 4'b0111, 4'b01x1, 4'b01z1
            default: out = 1'bx; // Desconocido
        endcase
    end
endmodule
````

En el primer caso (4'b1xx1), los dos bits centrales (xx) se consideran indiferentes ("don't care"), por lo que esta cláusula coincidirá con cualquier valor donde el primer bit sea 1, el último bit sea 1, y los dos bits centrales pueden ser 0, 1, x, o z.
En el segundo caso (4'b01z1), el z en el tercer bit también se considera indiferente, por lo que coincidirá con valores donde el primer bit es 0, el segundo es 1, el tercero puede ser 0, 1, x, o z, y el último bit es 1.

*__Evitar Latches__*
Un latch es un dispositivo de almacenamiento que guarda un valor sin el uso de un reloj. Para evitarlos el diseñador debe tener algunos cuidados respecto al uso de *__IF__* y el *__CASE__*. En el primero siempre hay que incluir un *__else__*, así como también asignar valores a todos las variables o bien asignarselos fuera del bloque condicional. En el segundo caso se deben especificar todas las condiciones posibles de la variable, también asignarles valores a todas las variables dentro, de no ser así, hay que incluir un default y asignar valores predeterminados.

*__Loops__*

Realmente no hay mucho para decir, son muy similares a otros lenguajes.

Se utilizan para ejecutar un bloque de sentencias múltiples veces.
– for: Es sintetizable y el más comúnmente usado en RTL.
– while: Es sintetizable pero no se recomienda su uso en RTL.
– repeat: Es sintetizable pero no se recomienda su uso en RTL.
– forever: No es sintetizable, sólo se usa en simulaciones.

```Verilog
integer ii ;
reg [ 7 : 0 ] op ;

always @(posedge i_clock ) begin
  if ( load_en ) begin
    op <= load_val ;
  end
  else begin
    for ( ii =0; ii <7; ii = ii+1) begin
      op [ ii +1] <= op [ ii ] ;
    end
    op [ 0 ] <= op [ 7 ] ;
  end
end
````

*__Control de simulaciones__*

Son diferentes funciones para controlar diferentes aspectos de la simulación. Entre ellas podemos encontrar:

– *__$finish__*: Sale de la simulación.
– *__$stop__*: Detiene la simulación, que luego puede ser retomada desde el punto de suspensión.
– *__$display__*: Imprime una salida.
– *__$monitor__*: Es similar a $display pero está activo todo el tiempo. Solo puede ejecutarse un $monitor a la
vez en toda la simulación.
– *__$fmonitor,$fdisplay__*: Escriben los valores en archivos, que deben ser abiertos previamente con la función
$fopen.
– *__$readmemb,$readmemh__*: Permiten la carga de datos desde archivos en formato binario o hexadecimal a
memorias.
– *__‘define__*: Define una macro, que consiste en la sustitución de una o varias lineas de texto por un nombre.
Se suele usar para definir constantes.
– *__‘ifdef - ‘else - ‘endif__*: Condicional pre-compilación.
– *__‘include__*: Permite insertar el contenido de un archivo fuente en otro archivo durante la compilación en el
lugar donde se define el comando. La compilación continúa como si el contenido del archivo fuente incluido
apareciera en lugar del comando ‘include. Se suele usar para incluir definiciones y tareas de uso común,
evitando código repetido dentro de los módulos. 

*__Generate__*

Se puede usar opara crear múltiples instancias de módulos y código, o instanciar modulos y definir código condicionalmente.

- Se definen dentro de un módulo, usando las palabras clave *__generate__* y *__endgenerate__*.
- Pueden contener instancias de módsulos, declaraciones de asignación, bloques procedurales, etc.
- NO pueden contener declaraciones de puertos ni parámetros.
- Pueden ser anidados
- Generalmente se usa *__Generate loop__* y *__generate condicional__*

Ejemplos

````Verilog
// Ejemplo de generate loop que permite replicar asignaciones N veces
module adder
    #(parameter N = 4)
    (
        input  [N-1:0] a, b,
        output [N-1:0] sum, cout
    );

    genvar i;

    generate
        for (i = 0; i < N; i = i + 1)
        begin : ha_instances // Nombrarlos es una buena práctica
            ha u_ha (
                .a(a[i]),
                .b(b[i]),
                .sum(sum[i]),
                .cout(cout[i])
            );
        end
    endgenerate

endmodule

// Half-adder
module ha (
    input  a, b,
    output sum, cout
);
    assign sum  = a ^ b;
    assign cout = a & b;
endmodule
````

*__Tareas__*

- Se puede utilizar para codificar una funcionalidad que se repite varias veces en un módulo.
- Tiene entradas, salidas y puede tener sus variables locales.
- Todas las variables definidas en el módulo también son accesibles en la tarea.
- Debe definirse en el mismo módulo utilizando palabras claves *__task__* y *__endtask__*. Se puede llamar desde varios
módulos siempre y cuando esté definida en un archivo aparte que se incluye utilizando la palabra clave *__’include__*
dentro de cada módulo.
- Se llaman desde bloques initial o always o desde otras tareas en un módulo.
- Pueden contener declaraciones de tiempo (#,@).
- Pueden usar y/o asignar valores a cualquier señal declarada como global.
- Importa el orden de los puertos de entrada y salida al momento de llamar una tarea.
- Pueden utilizarse para modelar lógica combinacional o secuencial.

*__Funciones__*
- Similar a una tarea, ya que también implementa código que se puede llamar varias veces dentro de un módulo.
- Se define en el módulo usando las palabras clave *__function__* y *__endfunction.__*
- 4Sólo puede calcular una salida, debiendo tener al menos una entrada.
- La salida debe asignarse a una variable implícita que lleve el nombre y el alcance de la función.
- No puede utilizar construcciones de tiempo (#,@).
- Puede ser llamada desde un bloque de procedimiento o una declaración de asignación continua.
- Puede llamarse desde otras funciones y tareas, mientras que una función no puede llamar a una tarea.
- Sólo pueden utilizarse para modelar lógica combinacional (no soportan asignaciones no bloqueantes).

Ejemplo
````Verilog
module MUX4to1 (
    output out,
    input  [3:0] in,
    input  [1:0] sel
);
    wire out1, out2;

    function MUX2to1;
        input in1, in2;
        input select;
        assign MUX2to1 = (select) ? in2 : in1;
    endfunction // MUX2to1

    assign out1 = MUX2to1(in[0], in[1], sel[0]);
    assign out2 = MUX2to1(in[2], in[3], sel[0]);
    assign out  = MUX2to1(out1, out2, sel[1]);

endmodule

module testFunction;
    reg [3:0] IN;
    reg [1:0] SEL;
    wire OUT;

    MUX4to1 mux(.out(OUT), .in(IN), .sel(SEL));

    initial begin
        IN = 1; SEL = 0;
        #5 IN = 7; SEL = 0;
        #5 IN = 2; SEL = 1;
        #5 IN = 4; SEL = 2;
        #5 IN = 8; SEL = 3;
    end

    initial
        $monitor($time, " IN=%b SEL=%b OUT=%b\n", IN, SEL, OUT);

endmodule
````
*__Set Up Hoold__*

Al usar lógica combinacional hay que tener en cuenta que los flip flops tienen un tiempo al usar asignación bloqueante y necesitamos que ciertos valores se estabilicen antes de guardarlos en los registros. Si yo tengo mucho combinacional el delay puede provocar resultados inesperados debido a que el guardado en el registro es muy sobre la llegada del flanco del reloj.

### Nivel de Transferencia de Registros ( RTL )

Describe el flujo de datos y las operaciones en registros bajo el control de un reloj, especifica cómo se mueven los datos entre los registros y las operaciones realizadas sobre ellos. Se suelen utilizar expresiones, operandos y operadores. Dependiendo del dispositivo en el que estamos se implementan de forma diferente, en nuestro caso, en la *__FPGA__* se detecta cuándo en el código *__RTL__* hay operaciones aritméticas y se asignan automaticamente a los bloques *__DPS__*.

Los operadores definidos son

<div align="center">
  <img src="https://github.com/user-attachments/assets/c616c1a5-2ff6-48ee-b22a-8e3c863cbd00" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br> 

Algunos ejemplos de operaciones

```Verilog
// Suma (recordemos que queda asignado de esta manera siempre porque es un cable)
assign c = a + b ;

// Condicional
assign out = expression ? true : false ;
assign out = sel ? a : b ;

if ( a ==1’b1 )
  out = 1 ’b1 ;
else
  out = 1 ’b0 ;

// Repeticion
A = 2 ’b01 ;
B = { 4 { A } } ; // B = 8 ’b01010101, osea repetir 4 veces A

// Logical Shift
A = 6'b101111;
B = A >> 2; // B = 6'b001011 se corren los bits 2 lugares a la derecha, rellena con 0

// Arithmetical Shift
A = 6'b101111;
B = A >>> 2; // B = 6'b111011 lo mismo que el logical pero rellena con 1, equivalente a dividir por 2^n

// Reduction
A = 4'b1011;
assign out = &A; // out = 1'b0, aplica la AND a todos los bits y produce un solo bit de salida
```


  






































