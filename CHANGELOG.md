##0.0.9

### 🚀 NEW FEATURES
- **Firebase Engine**: Se añade `FirebasePagination` para gestionar cargas de datos asíncronas desde Firestore de forma genérica `<T>`.
- **Infinite Scroll**: Incorporación de `InfiniteListView`, un widget inteligente que detecta el final del scroll y dispara cargas automáticas.
- **Advanced Dropdown**: Nuevo `DropdownCustom<T>` basado en PopupMenu para una selección de elementos más fluida y elegante.
- **Icon Actions**: Adición de `ButtonIcon`, un botón ultra-configurable que soporta tanto Material Icons como SVGs (con y sin color dinámico).

### 🛠️ ARCHITECTURAL CHANGES
- **Firebase Integration**: Se añaden las dependencias `cloud_firestore` y `firebase_core` al core de la librería.
- **Pubspec Organization**: Limpieza y categorización del archivo `pubspec.yaml` por módulos (Core, UI, Utils, Assets).
- **Global Exports**: Centralización de todas las nuevas funcionalidades en `pizzacorn_ui.dart` para acceso global.

### 🎨 THEME & UI CONSISTENCY
- **Reactive Colors**: Todos los nuevos widgets eliminan el uso de `const` para reaccionar inmediatamente a los cambios en `PizzacornThemeConfig`.
- **Token Alignment**: Implementación de `PADDING_MEDIUM`, `RADIUS_SMALL` y `RADIUS_MEDIUM` en los nuevos componentes para mantener la armonía visual.

### 🧹 CODE QUALITY (Don Sputknif Rules)
- **Zero Underscores**: Eliminación de guiones bajos en todos los States y métodos internos.
- **Loop Optimization**: Sustitución de `.map().toList()` por bucles `for` con índice para mejorar el rendimiento.
- **Positional Texts**: Los widgets de texto ahora cumplen estrictamente con el parámetro posicional.