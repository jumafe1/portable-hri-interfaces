# Portable HRI Interfaces

Contratos ROS 2 comunes para desacoplar las aplicaciones de interacción
humano-robot de los proveedores y del hardware de NAO, Pepper u otras
plataformas.

## Paquetes

### `hri_capability_interfaces`

Define los contratos `Speak`, `DetectPeople`, `MoveRelative` y `MoveVelocity` y exporta sus
descripciones como interfaces de Capabilities2.

#### `Speak`

El punto de acceso común es `/hri/speak`; el proveedor activo es responsable de
traducir esa solicitud a la interfaz concreta del robot o motor de voz.

Solicitud:

- `text`: texto que debe pronunciarse.
- `language`: idioma solicitado; una cadena vacía conserva el idioma
  predeterminado del proveedor.

Respuesta:

- `success`: indica si el proveedor completó la solicitud.
- `provider`: identifica el proveedor que atendió la solicitud.
- `message`: detalle legible del resultado o error.

#### `DetectPeople`

El flujo común continuo es `/hri/people`, de tipo
`hri_capability_interfaces/msg/PersonDetection2DArray`. Cada mensaje representa
un frame ya evaluado: `people=[]` es un resultado válido sin personas, mientras
que la ausencia de mensajes recientes se interpreta mediante la edad del
`header`. El campo `provider` conserva trazabilidad sin filtrar tipos propios
del motor de visión a la aplicación.

También existe la consulta puntual `/hri/detect_people`. La solicitud permite
elegir la confianza mínima y la edad máxima del último frame. Valores menores
o iguales a cero conservan los valores predeterminados del proveedor.

Una respuesta exitosa significa que se evaluó un frame reciente; `people`
puede estar vacío cuando no hay personas. Una respuesta fallida distingue la
ausencia de datos, un frame vencido o una solicitud inválida. Cada detección
incluye confianza, identificador de seguimiento opcional y cuadro 2D en
píxeles, sin exponer mensajes específicos de YOLO.

#### `MoveRelative`

El punto de acceso común es `/hri/move_relative`. La solicitud expresa un
objetivo relativo al marco inicial del robot mediante `x_m`, `y_m` y
`theta_rad`. La respuesta distingue aceptación de objetivo alcanzado: solo es
exitosa cuando el proveedor verifica el movimiento y devuelve los tres
desplazamientos medidos. Los proveedores pueden aplicar límites más
conservadores según la morfología y condiciones de seguridad de cada robot.

#### `MoveVelocity`

El tópico de entrada `/hri/cmd_vel` usa `geometry_msgs/msg/Twist`: `linear.x`
y `linear.y` son velocidades en m/s en el marco corporal actual; `angular.z`
es la velocidad de giro en rad/s. Los otros ejes deben ser cero. No son
coordenadas de destino ni distancias. Un único cliente debe mantener un flujo
de órdenes recientes; una orden cero solicita parar. La capacidad se adquiere
y libera mediante Capabilities2, igual que las anteriores.

El tópico `/hri/move_velocity/status` (`std_msgs/msg/String`) informa periódicamente
`ready`, `moving`, `stopped`, `command_timeout`, `invalid_command` o
`backend_unavailable`. Estos estados describen al proveedor y sus órdenes:
**`stopped` no certifica que el robot se haya detenido físicamente**.

El proveedor inicial exige órdenes cada menos de 300 ms y aplica límites
conservadores de 0.10 m/s, 0.05 m/s y 0.20 rad/s, respectivamente. Usa QoS
reliable, volatile, keep-last 1. `Twist` no lleva sello temporal: el watchdog
mide tiempo desde recepción, no edad de la orden en origen. No debe reenviarse
indefinidamente una orden derivada de percepción caducada.

Los mecanismos de parada deben verificarse por plataforma. Un watchdog dentro
del proveedor no protege por sí solo ante su caída, la del driver o pérdida de red.

#### `TranscribeSpeech`

`/hri/speech/transcribe` admite una captura futura; nunca recupera audio previo
a la solicitud. Con `continuous=false` (predeterminado) conserva una ventana de
0.5 a 10 s y un resultado asíncrono en `/hri/speech/transcript`.

Con `continuous=true`, `duration_sec` limita cada fragmento a entre 1 y 10 s,
y `silence_sec` define la pausa que cierra una frase (0 significa 0.8 s;
valores explícitos entre 0.2 y 2 s, menores que `duration_sec`). La sesión dura
hasta liberar la capacidad, perder la autorización o un error terminal. El
proveedor debe acotar buffers/cola y comunicar pérdidas, sin acumular audio
indefinidamente. Adquirir la capacidad por sí solo no inicia captura.

Los resultados conservan el `request_id` público. `segment_index` es creciente
en una sesión continua (puede tener huecos por descartes); vale 0 para una
ventana única o error terminal. `final=true` termina la solicitud; las frases
continuas tienen `final=false`. `header` corresponde al audio, no al fin de la
inferencia. El texto no constituye una orden autenticada ni una confianza medida.

`/hri/speech/capture_status` (`SpeechCaptureStatus`) informa periódicamente
`listening`, `speech`, `processing` o `speech_and_processing`, junto con el
número de frases pendientes y descartadas. No contiene audio ni texto. Permite
distinguir silencio legítimo de un worker perdido. El proveedor Whisper lo
emite cada 0.25 s y el proxy termina una sesión tras 2 s sin heartbeat.

Esta ampliación cambia las definiciones ROS: reconstruir interfaces, proveedor
Whisper y aplicación, y reiniciar sus procesos antes de usarlas conjuntamente.

## Compilación

Desde la raíz de un workspace ROS 2:

```bash
colcon build --packages-select hri_capability_interfaces
source install/setup.bash
```

Para inspeccionar el contrato generado:

```bash
ros2 interface show hri_capability_interfaces/srv/Speak
ros2 interface show hri_capability_interfaces/srv/DetectPeople
ros2 interface show hri_capability_interfaces/msg/PersonDetection2DArray
ros2 interface show hri_capability_interfaces/srv/MoveRelative
```

## Licencia

El código propio de este repositorio se distribuye bajo la licencia MIT.
