# Portable HRI Interfaces

Contratos ROS 2 comunes para desacoplar las aplicaciones de interacción
humano-robot de los proveedores y del hardware de NAO, Pepper u otras
plataformas.

## Paquetes

### `hri_capability_interfaces`

Define el servicio `Speak` y exporta su descripción como interfaz de
Capabilities2. El punto de acceso común es `/hri/speak`; el proveedor activo es
responsable de traducir esa solicitud a la interfaz concreta del robot o motor
de voz.

Solicitud:

- `text`: texto que debe pronunciarse.
- `language`: idioma solicitado; una cadena vacía conserva el idioma
  predeterminado del proveedor.

Respuesta:

- `success`: indica si el proveedor completó la solicitud.
- `provider`: identifica el proveedor que atendió la solicitud.
- `message`: detalle legible del resultado o error.

## Compilación

Desde la raíz de un workspace ROS 2:

```bash
colcon build --packages-select hri_capability_interfaces
source install/setup.bash
```

Para inspeccionar el contrato generado:

```bash
ros2 interface show hri_capability_interfaces/srv/Speak
```

## Licencia

El código propio de este repositorio se distribuye bajo la licencia MIT.
