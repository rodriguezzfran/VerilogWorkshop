# Análisis Ifsr + Mac Pause Control TX

Antes de poder analizar lo indicado, resulta importante generar una suerte de glosario para no perder el foco de lo que realmente estamos investigando. Aunque algunas definiciones puedan resultar simples y obvias, también sirve de modo de legajo para las investigaciones realizadas.

- *__MAC__*: Significa __Media Acces Control__ y es oarte de la capa de enlace de datos en el modelo __OSI__. Entre sus funciones más importantes está la de regular el acceso al medio compartido, asegurando que las colisiones de minimicen y los datos se transmitan correctamente.
  
- *__PHY__*: Es la responsable de la transmisión y recepción de señales a través del medio físico. Traduce las tramas MAC en señales eléctricas u ópticas, es decir, es el encargado de conectar un dispositivo de capa de enlace de datos con un medio físico.
  
-  *__XGMII__*: Significa __10 Gigabit Media Independent Interface__ y sirve como conexión entre la capa MAC y la capa PHY. Utiliza dos buses de datos de 32 bits: uno para la transmisión y otro para la recepción, junto con señales de control y reloj.

# Análisis
Hay un módulo que se nos encomendó analizar como *__top__* del proyecto. El módulo *__MAC de Ethernet de 10G__* pareciera ser que su función principal es manejar la transmisión y recepción de datos a través de la interfaz XGMII
