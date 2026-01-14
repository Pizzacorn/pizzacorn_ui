## 0.0.12

### 🚀 NEW FEATURES (The Power Suite)
- **`DropdownSearch`**: Incorporación de un selector avanzado con buscador reactivo integrado en un diálogo modal para gestionar listas extensas.
- **`ChoiceField`**: Nuevo widget de selección tipo cuadrícula (Grid) agnóstico y altamente configurable.
- **`RelationField`**: Selector dinámico conectado a Firestore para gestionar relaciones entre colecciones con carga asíncrona.
- **`SubtitleField`**: Separador visual de secciones con línea decorativa para organizar formularios complejos.
- **`StringField`**: Input de texto estandarizado con etiqueta integrada y gestión de errores.

### 🎨 UI & THEME ENGINE
- **Standardized Heights**: Implementación de los tokens `BUTTON_HEIGHT` y `FIELD_HEIGHT` (seteados a 40px por defecto) para consistencia total.
- **Adaptive Design**: Nuevo token `WEBSIZE` en `PizzacornThemeConfig` para controlar el punto de ruptura del layout responsive.
- **Global Text Color**: Actualización de `ButtonCustom` para usar `COLOR_TEXT` por defecto, mejorando la sobriedad visual.
- **Dynamic Decorations**: Adición de `BoxDecorationCustom` y `BorderRadiusCustomAll` para unificar el estilo de los contenedores.

### 💻 WEB & ADAPTERS
- **`WebPopUpAdapter`**: Contenedor de popups para escritorio con dimensiones inteligentes.
- **`WebColumnRowAdapter`**: Layout dinámico que alterna entre Row y Column según el ancho de pantalla.
- **`BottomSheetPopUps`**: Barra de acciones inferior estandarizada para modales.
- **`HoverWidget`**: Feedback visual de elevación y color para interacciones Web/Desktop.

### 🧹 CODE QUALITY (Don Sputknif Rules)
- **Zero Underscores**: Eliminación total de guiones bajos en todos los estados y métodos de la librería.
- **Index Loops**: Sustitución de `.map()` y `.forEach()` por bucles `for (int i = 0; i < ...; i++)`.
- **Full Reactivity**: Eliminación de `const` en widgets de UI para garantizar que los cambios de tema en runtime se apliquen al instante.
- **Positional Texts**: Los widgets de tipografía ahora cumplen estrictamente con el parámetro posicional.