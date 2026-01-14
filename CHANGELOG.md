## 0.0.11

### 🚀 NEW FEATURES (The Form Revolution)
- **`ChoiceField`**: Nuevo selector de opciones en cuadrícula (Grid) totalmente personalizable para formularios rápidos.
- **`RelationField`**: Integración nativa con Firestore para crear selectores que cargan datos de otras colecciones automáticamente.
- **`SubtitleField`**: Separador visual de secciones con línea decorativa para organizar flujos de usuario complejos.
- **`StringField`**: Input de texto estandarizado que incluye etiqueta y gestión de errores reactiva.

### 🎨 UI & THEME CONSISTENCY
- **Standardized Heights**: Implementación de los tokens `BUTTON_HEIGHT` y `FIELD_HEIGHT` (seteo inicial a 40px) en `ButtonCustom` y `TextFieldCustom`.
- **Global Text Color**: El color de texto por defecto en los botones ahora es `COLOR_TEXT`, mejorando la sobriedad y legibilidad.
- **Dynamic Paddings**: Ajuste de los paddings internos de los inputs para garantizar el centrado vertical perfecto con cualquier altura.

### 💻 WEB & ADAPTERS
- **Responsive Logic**: Refactorización de `WebPopUpAdapter` y `WebColumnRowAdapter` para usar el nuevo token global `WEBSIZE`.
- **Interaction Feedback**: Mejora en `HoverWidget` para soportar opacidades dinámicas y transformaciones en el eje Y.

### 🧹 CODE QUALITY (Don Sputknif Rules)
- **Agnostic Architecture**: Todos los nuevos widgets han sido desacoplados de Riverpod, convirtiéndose en componentes de UI puros y reutilizables.
- **Zero Underscores**: Limpieza total de guiones bajos en los estados internos (`TextFieldCustomState`, `HoverWidgetState`, etc.).
- **Loop Optimization**: Sustitución de `.map()` por bucles `for` con índice en la generación de RichText y menús dinámicos.
- **No-Const Enforcement**: Eliminación de `const` en widgets de la librería para asegurar la reactividad completa ante cambios en `ConfigurePizzacornColors`.