# 🍕 Pizzacorn UI 🦄

**Pizzacorn UI** es el *design system* definitivo de Pizzacorn para Flutter. Un ecosistema robusto diseñado para construir aplicaciones profesionales, escalables y totalmente configurables en tiempo de ejecución.

Este paquete no es solo una colección de widgets; es un motor completo que incluye:
- 🎨 **Dynamic Theme System**: Cambia colores y dimensiones en runtime.
- 🚀 **Firebase Engine**: Paginación genérica y scroll infinito listos para usar.
- 💻 **Web First**: Adaptadores y layouts inteligentes para experiencias Desktop/Web.
- 🔤 **Typography & Design Tokens**: Consistencia visual absoluta.

---

## 🚀 Instalación

Añade la dependencia en tu `pubspec.yaml`:


---

## 🛠️ Configuración Inicial

Configura tu marca y tipografía en el `main()` antes de lanzar la app. ¡Sin reinicios, todo reactivo!

/// =================== CONFIG GLOBAL (Fonts, Sizes, Weights) ===================
/// Úsalo en tu app antes de runApp(), por ejemplo:
///
/// PizzacornTextConfig.configure(
///   primaryFontFamily: 'Montserrat',
///   secondaryFontFamily: 'Inter',
///   sizes: PizzacornTextSizes(
///     big: 40,
///     title: 26,
///     subtitle: 22,
///     body: 13,
///     button: 13,
///     caption: 11,
///     small: 9,
///   ),
///   weights: PizzacornTextWeights(
///     normal: FontWeight.w400,
///     bold: FontWeight.w700,
///   ),
/// );

---

## 📦 Componentes Destacados

### 1. Motor de Datos (Firebase & Lists)
Gestiona miles de registros con facilidad.
- **`FirebasePagination`**: Lógica genérica para traer datos de Firestore.
- **`InfiniteListView`**: Scroll infinito con indicadores de carga y "fin de registros".

### 2. Adaptadores Web & Responsive
Diseñado para que tu app se vea genial en cualquier pantalla.
- **`WebPopUpAdapter`**: Modales centrados y elegantes para escritorio.
- **`WebColumnRowAdapter`**: Cambia de `Row` a `Column` automáticamente según el ancho (`WEBSIZE`).
- **`HoverWidget`**: Feedback visual (elevación/color) al pasar el ratón.

### 3. Inputs y Botones Premium
- **`DropdownCustom<T>`**: Selector elegante basado en PopupMenu (evita el feo dropdown estándar).
- **`ButtonIcon`**: Soporte total para `IconData` y `SVG` con colores dinámicos.
- **`MoreMenuButton`**: Menú de acciones (Editar, Eliminar, Duplicar) listo para usar.

### 4. Decoraciones Inteligentes
Usa nuestras funciones para mantener la armonía:
- **`BoxDecorationCustom()`**: Aplica sombras suaves y el radio de borde configurado globalmente.
- **`BorderRadiusCustomAll()`**: El radio perfecto en toda tu app.

---

## 📏 Design Tokens (Getters Globales)

Olvídate de los números mágicos. Usa nuestros tokens reactivos:

| Token | Descripción |
|-------|-------------|
| `COLOR_ACCENT` | Color principal de marca |
| `COLOR_BACKGROUND` | Fondo principal de la app |
| `RADIUS` | Radio de borde por defecto |
| `PADDING` | Padding lateral estándar (EdgeInsets) |
| `WEBSIZE` | Punto de ruptura para responsive (1100px) |

---

## 📜 Reglas de Oro del Sistema
Para mantener la consistencia en el ecosistema Pizzacorn:
1. **No usar `const`** en los widgets de la librería para permitir la reactividad del tema.
2. **Textos posicionales**: `TextBody("Hola")` en lugar de `text: "Hola"`.
3. **Espaciado**: Usar siempre el widget `Space(DOUBLE_PADDING)`.

---

## 👨‍💻 Desarrollado por
**Señor Sputo** & **Don Sputknif** (Pizzacorn Team).
-
"Porque una app sin estilo es como una pizza sin queso." 🍕✨