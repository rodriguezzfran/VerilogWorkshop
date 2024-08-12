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

Por lo que con 16 taps el número máximo de la secuencia es *__65536__* y para lograrlo los tpas deben ir en el *__2__*,*__3__* y *__5__*.

<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/fab6f984-bc54-44f2-b593-3af9ad95b5de" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>








 
