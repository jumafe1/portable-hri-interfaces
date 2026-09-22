# Portable HRI Interfaces

Contratos ROS 2 comunes para desacoplar las aplicaciones de interacción
humano-robot de los proveedores y del hardware de NAO, Pepper u otras
plataformas.

## Paquetes

### `hri_capability_interfaces`

Define los contratos `Speak` y `DetectPeople` y exporta sus descripciones como
interfaces de Capabilities2.

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

El punto de acceso común es `/hri/detect_people`. La solicitud permite elegir
la confianza mínima y la edad máxima del último frame. Valores menores o
iguales a cero conservan los valores predeterminados del proveedor.

Una respuesta exitosa significa que se evaluó un frame reciente; `people`
puede estar vacío cuando no hay personas. Una respuesta fallida distingue la
ausencia de datos, un frame vencido o una solicitud inválida. Cada detección
incluye confianza, identificador de seguimiento opcional y cuadro 2D en
píxeles, sin exponer mensajes específicos de YOLO.

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
```

## Licencia

El código propio de este repositorio se distribuye bajo la licencia MIT.
