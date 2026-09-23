# Portable HRI Interfaces

Contratos ROS 2 comunes para desacoplar las aplicaciones de interacción
humano-robot de los proveedores y del hardware de NAO, Pepper u otras
plataformas.

## Paquetes

### `hri_capability_interfaces`

Define los contratos `Speak`, `DetectPeople` y `MoveRelative` y exporta sus
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
