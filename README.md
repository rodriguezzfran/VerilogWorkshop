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

*__Que es vivado?__*
 
Vivado es un IDE creado por Xilinx para el diseño y la implementación de sistemas digitales basados en sus dispositivos FPGA. Ofrece herramientas para el diseño de hardware, síntesis, simulación, y análisis de rendimiento, entre otras funcionalidades. 

*__Desarrollo de Algoritmos:__*

Se trata de definir las necesidades y requerimientos del diseño, estableciendo qué debe hacer el sistema y describiendo el comportamiento del sistema utilizando aritmética de punto flotante para modelar y simular el algoritmo deseado antes de implementarlo en hardware.

*__Diseño a Nivel de Sistema, Verificación y Testeo:__*

Dividir el diseño en componentes de software y hardware, verificar que la interacción entre el software y el hardware funcione correctamente, integrar todos los componentes del sistema y realizar pruebas para asegurar que el sistema funcione como se espera.

*__Desarrollo de Software y Testeo:__*

Desarrollo del software necesario para el sistema, diseñar las operaciones de punto flotante a punto fijo para implementarlas en hardware, optimizando la eficiencia del sistema.

*__Desarrollo de Hardware y Testeo:__*

Implementación del diseño en hardware, convertir las operaciones de punto flotante a punto fijo, asegurando que el diseño sea eficiente y funcional en hardware, describir el diseño del hardware a nivel de Registro-Transfer-Level (RTL), verificando que el diseño hardware cumpla con las especificaciones funcionales, convirtiendo la descripción RTL a una red de puertas lógicas (netlist) que luego son conectadas según lo especificado. Verificar el rendimiento temporal del diseño y asegurarse de que siga siendo funcional después de todas las transformaciones, para luego crear el layout final del diseño para su fabricación, ya sea como ASIC o configuración en FPGA.


<div align="center">
  <img src="https://github.com/user-attachments/assets/033b046b-f7d0-4939-9f55-4fb490a0153e" alt="VIVADO Flow Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>







