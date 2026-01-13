## 0.0.10

### 🚀 NEW FEATURES
- **Web Responsive Adapters**: Incorporación de `WebPopUpAdapter` para la gestión de diálogos estandarizados en versiones de escritorio y `WebColumnRowAdapter` para layouts dinámicos basados en el ancho de pantalla.
- **Interactive UI**: Añadido `HoverWidget` para proporcionar feedback visual (elevación y cambio de color) al interactuar con el puntero en aplicaciones Web/Desktop.
- **Contextual Menus**: Implementación de `BottomSheetPopUps`, la barra de acciones inferior estandarizada para flujos de guardado y eliminación.

### 🎨 THEME & DECORATIONS
- **Dynamic Decorations**: Adición de `BoxDecorationCustom` y `BorderRadiusCustomAll` que consumen directamente los tokens de `config.dart` (RADIUS, COLOR_BACKGROUND, etc.).
- **Enhanced Configuration**: Se añade el token `WEBSIZE` (1100px por defecto) al `PizzacornThemeConfig` para centralizar el punto de ruptura del diseño responsive.
- **Shadow Tokens**: Integración de `COLOR_SHADOW` en las decoraciones globales para una profundidad consistente.

### 🛠️ ARCHITECTURAL CHANGES
- **Pubspec Optimization**: Corrección de restricciones de versiones (carets `^`) en todas las dependencias para garantizar la compatibilidad con otros paquetes del ecosistema Flutter.
- **Reactive Tokens**: Refactorización de paddings y márgenes para usar getters reactivos en lugar de constantes, permitiendo cambios de tema en caliente sin reiniciar la app.

### 🧹 CODE QUALITY (Don Sputknif Rules)
- **Zero Underscores**: Limpieza total de guiones bajos en los estados internos de los nuevos widgets (`HoverWidgetState`, `DropdownCustomState`, etc.).
- **Positional Consistency**: Todos los nuevos widgets de texto y espaciado cumplen estrictamente con el uso de parámetros posicionales.
- **No-Const Policy**: Eliminación de `const` en los componentes de la librería para asegurar la reactividad completa ante cambios en `ConfigurePizzacornColors`.