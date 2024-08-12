# Proyecto LEDS - Implementación en FPGA

Cómo se mencionó anteriormente en la rama `main` vamos a tratar de ejemplificar todo lo descripto con el siguiente ejemplo de LEDS

<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/61948ee1-d458-48e7-b2c8-0a1b8931f145" alt="RGB Diagram" style="box-shadow: 10px 10px 20px rgba(0, 0, 0, 0.5);">
</div>
<br>

Algunas cosas a tener en cuenta son:

- Los nombres en rojo son puertos
- *__VIO__* y *__ILA__* son submódulos.
- *__i_reset__* es el reset del sistema, pone al cero el contador e inicializa el shift register.
- *__i_sw[0]__* controla el enable del contador. si está en 0 detiene el funcionamiento sin alterar el estado actual del contador y del SR.
- El SR se desplaza cuándo el contador llegó a algún límite *__R0-R3__*.
- La selección del límite se realiza con la señal *__i_sw[2:1]__*
- La selección del límite se puede hacer en cualquier momento del funcionamiento.
- *__i_sw[3]__* elige el color de los leds RGB.

Que es entonces lo que vamos a hacer?

##
