# Análisis Ifsr + Mac Pause Control TX

Antes de poder analizar lo indicado, resulta importante generar una suerte de glosario para no perder el foco de lo que realmente estamos investigando. Aunque algunas definiciones puedan resultar simples y obvias, también sirve de modo de legajo para las investigaciones realizadas.

- *__MAC__*: Significa __Media Acces Control__ y es oarte de la capa de enlace de datos en el modelo __OSI__. Entre sus funciones más importantes está la de regular el acceso al medio compartido, asegurando que las colisiones de minimicen y los datos se transmitan correctamente.
  
- *__PHY__*: Es la responsable de la transmisión y recepción de señales a través del medio físico. Traduce las tramas MAC en señales eléctricas u ópticas, es decir, es el encargado de conectar un dispositivo de capa de enlace de datos con un medio físico.
  
-  *__XGMII__*: Significa __10 Gigabit Media Independent Interface__ y sirve como conexión entre la capa MAC y la capa PHY. Utiliza dos buses de datos de 32 bits: uno para la transmisión y otro para la recepción, junto con señales de control y reloj.

# Análisis
Hay un módulo que se nos encomendó analizar como *__top__* del proyecto. El módulo *__MAC de Ethernet de 10G__* pareciera ser que su función principal es manejar la transmisión y recepción de datos a través de la interfaz XGMII. Con ella se pretende realizar funciones para control de flujo, etiquetado de tiempo PTP y manejo de tramas Ethernet (quizás ahí es dónde radica la importancia del módulo que nos indicaron seleccionar).

Pareciera ser que el módulo *__mac_pause_ctrl_tx__* se menciona varias veces, la que más sentido tiene para mí es que se observa que es parte de una serie de señales y conexiones relacionadas con el control de pausas en las transmisiones, pero ¿Que es eso del control de pausas? para ello tenemos que investigar un poco acerca del *__Flow control__*.

#### Ethernet Flow Control
Según el enlace que nos facilitaron (Wikipedia) se trasta de un mecanismo para frenar temporalmente la transmission de información cuándo se usa Ethernet, con el objetivo de evitar la pérdida de paquetes en situaciones de mucha congestión de la red.

Funciona utilizando un *__pause frame__* definido a partir de la *__IEE 802.3x__* con la idea de que ante eventuales congestiones, el receptor envíe un frame de pausa para que el receptor se tome un descanso del envío así los demás dispositivos pueden ponerse al día con los frames, evitando la perdida de paquetes (sobretodo enr redes con dispositivos que funcionan a diferentes velocidades). El hecho de que sea un *__Pause frame__* viene indicado dentro del payload del *__Mac frame__*. Hay cierta información sobre la cantidad de tiempo (llamada quantos) en que tardas en poner 1 bit en la red <-- INVESTIGAR A FUTURO.

Resulta que esta solución no es ideal, ya que cuándo se solicita una pausa se pausan todos los flujos. En el *__IEE 802.1Q__* se actualizaron a 
una forma en la cual los frames de pausa se envían a través de colas de prioridad divididas por niveles, de esta manera, sólo frenamos el tráfico de menor prioridad evitando afectar, por ejemplo, a los de tiempo real como voz o video.

PREGUNTAR AL PROFE --> Segun el video, MAC es una trama especial de ethernet usada en el flow control.




