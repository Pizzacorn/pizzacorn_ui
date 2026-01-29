## 0.0.19

### ♿ ACCESSIBILITY (SEMANTICS)
- **Universal Semantics Support**: Implementación de `Semantics` en toda la librería de textos (`TextBig`, `TextTitle`, `TextBody`, etc.).
- **Header Navigation**: Los títulos ahora están marcados como `header: true` para facilitar la navegación a usuarios con lectores de pantalla.
- **Button Accessibility**: `ButtonCustom` y `TextButtonCustom` ahora se identifican correctamente como `button: true` y generan etiquetas de voz automáticas basadas en su contenido o `semanticLabel`.
- **Navigation Clarity**: Las AppBars (`AppBarBack`, `AppBarClose`) ahora anuncian explícitamente las acciones "Atrás" y "Cerrar".

### 🚀 NEW WIDGETS (PIZZACORN_UI CANDIDATES)
- **`BottomBarCustom`**: Nueva barra de navegación premium con soporte híbrido para `IconData` (UIconsPro) y `SVG`. Incluye efectos de elevación, gradientes de fondo y animaciones de selección.
- **`CheckboxPolitics`**: Componente legal estandarizado con `RichText` integrado, enlaces táctiles para términos y condiciones, y soporte de accesibilidad.
- **`BlurChildWidget`**: Widget de efecto visual para aplicar desenfoque gaussiano dinámico (`ImageFilter.blur`) a cualquier elemento hijo.
- **`FullScreenImagePage`**: Pantalla completa para visualización de imágenes con soporte de gestos (pinch-to-zoom) mediante `PhotoView`.
- **`LoadingWidget`**: Extracción del loader estándar como componente independiente y reutilizable.

### 🛠️ IMPROVEMENTS & FIXES
- **`ButtonCustom` Color Logic**: Se ha corregido el "Expediente X" de los colores. Ahora el color de texto se adapta inteligentemente: `COLOR_TEXT_BUTTONS` para botones sólidos y `COLOR_TEXT` para botones con borde.
- **Icon Rendering**: Optimización de la lógica de renderizado de iconos en el BottomBar para distinguir automáticamente entre fuentes tipográficas y archivos vectoriales.
- **Flutter Modernization**: Actualización de los métodos de color con opacidad al nuevo estándar `.withValues(alpha: ...)` de Flutter 3.27+.