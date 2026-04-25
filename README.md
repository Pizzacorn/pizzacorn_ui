# 🍕 Pizzacorn UI

**Pizzacorn UI** es el design system oficial de Pizzacorn para Flutter: widgets reutilizables, tokens visuales, tipografía configurable, helpers de navegación, componentes responsive y un motor de paginación para Firestore listo para producción.

Está pensado para construir apps rápidas, limpias y con una identidad visual consistente en móvil, web y desktop.

---

## ✨ Qué incluye

- 🎨 **Theme tokens dinámicos**: colores, paddings, radios, alturas y breakpoints configurables.
- 🔤 **Sistema tipográfico**: textos semánticos como `TextTitle`, `TextBody` y `TextCaption`.
- 🔥 **Paginación Firebase + Riverpod**: `PaginationController`, `SliverListCustom` y `SliverGridCustom`.
- 🍏 **Segmented controls estilo Apple**: controles simples, Cupertino y tipo tabs.
- 🧩 **Widgets custom**: botones, inputs, appbars, overlays, imágenes, dropdowns, calendarios y helpers.
- 💻 **Adaptadores responsive**: layouts y popups adaptados a web/escritorio.

---

## 📦 Instalación

Añade la dependencia en tu `pubspec.yaml`:

```yaml
dependencies:
  pizzacorn_ui:
    git:
      url: https://github.com/Pizzacorn/pizzacorn_ui
```

Importa la librería en tus archivos Dart:

```dart
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
```

> Regla Pizzacorn: en los proyectos de app usamos barrel import desde `lib/config/imports.dart`, así que normalmente exportaremos `pizzacorn_ui` desde ahí y cada archivo de pantalla importará solo ese archivo global.

---

## 🚀 Configuración inicial

Configura colores, layout y tipografías antes de `runApp()`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ConfigurePizzacornColors(
    accent: const Color(0xFF5256D6),
    background: const Color(0xFFFFFFFF),
    backgroundSecondary: const Color(0xFFF4F4F6),
    text: const Color(0xFF151727),
    subtext: const Color(0xFF8E929E),
  );

  ConfigurePizzacornLayout(
    radius: 8,
    paddingSize: 20,
    paddingSmallSize: 10,
    buttonHeight: 44,
    fieldHeight: 44,
    webSize: 1100,
  );

  PizzacornTextConfig.configure(
    primaryFontFamily: 'Montserrat',
    secondaryFontFamily: 'Inter',
    sizes: const PizzacornTextSizes(
      big: 32,
      title: 22,
      subtitle: 18,
      body: 14,
      button: 14,
      caption: 12,
      small: 10,
    ),
    weights: const PizzacornTextWeights(
      normal: FontWeight.w400,
      bold: FontWeight.w700,
    ),
  );

  ConfigurePizzacornPagination(
    databaseName: 'mi-base-firestore',
  );

  runApp(MyApp());
}
```

`ConfigurePizzacornPagination` es opcional. Si no lo llamas, o si pasas `null`, `''` o `'(default)'`, la paginación seguirá usando la base Firestore `(default)`.

---

## 🧠 Reglas de oro

1. **No uses `const` en widgets de Pizzacorn UI.** Muchos leen tokens dinámicos en runtime.
2. **Textos con string posicional:** `TextBody("Hola")`, no `TextBody(text: "Hola")`.
3. **Espaciado con tokens:** usa `Space(SPACE_SMALL)`, `PADDING`, `PADDING_ALL`, etc.
4. **Paginación con placeholder:** `SliverListCustom` y `SliverGridCustom` siempre deben recibir `itemPlaceholder`.
5. **Firestore con modelos:** el `fromJson` de `PaginationParams<T>` debe construir tu modelo.

---

## 🎨 Design tokens

### Colores

| Token | Uso |
| --- | --- |
| `COLOR_BACKGROUND` | Fondo principal |
| `COLOR_BACKGROUND_SECONDARY` | Fondos secundarios, inputs o scaffolds |
| `COLOR_BACKGROUND_TERCIARY` | Superficies elevadas |
| `COLOR_ACCENT` | Acción principal y marca |
| `COLOR_ACCENT_SECONDARY` | Acción secundaria |
| `COLOR_TEXT` | Texto principal |
| `COLOR_SUBTEXT` | Texto secundario |
| `COLOR_TEXT_BUTTONS` | Texto sobre botones de acento |
| `COLOR_BORDER` | Bordes y contornos |
| `COLOR_DIVIDER` | Separadores |
| `COLOR_ERROR` | Errores |
| `COLOR_ALERT` | Avisos |
| `COLOR_DONE` | Éxitos |
| `COLOR_INFO` | Información |

### Layout

| Token | Uso |
| --- | --- |
| `RADIUS` | Radio global |
| `WEBSIZE` | Breakpoint responsive |
| `BUTTON_HEIGHT` | Altura estándar de botones |
| `FIELD_HEIGHT` | Altura estándar de campos |
| `DOUBLE_PADDING` | Padding base numérico |
| `DOUBLE_PADDING_SMALL` | Padding compacto numérico |
| `PADDING` | Padding horizontal base |
| `PADDING_SMALL` | Padding horizontal compacto |
| `PADDING_ALL` | Padding completo base |
| `PADDING_ALL_SMALL` | Padding completo compacto |

### Espacios

| Token | Valor | Uso |
| --- | ---: | --- |
| `SPACE_BIGGER` | `60` | Separación grande entre bloques |
| `SPACE_BIG` | `40` | Separación amplia |
| `SPACE_MEDIUM` | `20` | Separación estándar |
| `SPACE_SMALL` | `10` | Elementos relacionados |
| `SPACE_SMALLEST` | `5` | Ajustes finos |

```dart
Column(
  children: [
    TextTitle("Resumen"),
    Space(SPACE_SMALL),
    TextBody("Contenido de la sección"),
  ],
)
```

---

## 🔤 Textos

Los widgets de texto usan la configuración global de `PizzacornTextConfig` y los colores del tema.

| Widget | Uso recomendado |
| --- | --- |
| `TextBig("Texto")` | Mensajes de gran impacto |
| `TextTitle("Texto")` | Títulos de sección |
| `TextSubtitle("Texto")` | Subtítulos |
| `TextBody("Texto")` | Texto estándar |
| `TextButtonCustom("Texto")` | Texto dentro de botones |
| `TextCaption("Texto")` | Texto secundario, fechas, ayudas |
| `TextSmall("Texto")` | Microtexto |
| `TextCustom("Texto")` | Control manual de tamaño, peso y espaciado |

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    TextBig("Dashboard"),
    Space(SPACE_SMALL),
    TextTitle("Ventas de hoy"),
    TextBody("Aquí se muestra el rendimiento de la tienda."),
    TextCaption("Actualizado hace 2 minutos"),
  ],
)
```

También puedes usar estilos directamente:

```dart
Text(
  "Texto nativo con estilo Pizzacorn",
  style: styleBody(color: COLOR_TEXT, fontWeight: WEIGHT_BOLD),
)
```

---

## 🔥 Paginación Firestore

La paginación combina:

- `PaginationParams<T>`: configuración de colección, query y parser.
- `paginationProvider`: provider Riverpod auto-dispose.
- `PaginationController<T>`: carga inicial, refresh y fetch more.
- `SliverListCustom<T>` / `SliverGridCustom<T>`: render con skeleton, vacío, error y scroll infinito.

### 0. Configuración opcional de base de datos

Por defecto se usa la base Firestore `(default)`. Si tu proyecto usa otra base de datos, configúrala una vez al iniciar la app:

```dart
ConfigurePizzacornPagination(
  databaseName: 'mi-base-firestore',
);
```

Para volver a `(default)`, no llames a la función o pásale `null`, `''` o `'(default)'`.

### 1. Define los parámetros

```dart
final params = PaginationParams<UserModel>(
  collection: "users",
  limit: 20,
  identifier: "users_home",
  fromJson: (data) => UserModel.fromJson(data),
  query: (q) => q.orderBy("createdAt", descending: true),
);
```

### 2. Lista paginada

```dart
class UsersPage extends ConsumerWidget {
  UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = PaginationParams<UserModel>(
      collection: "users",
      limit: 20,
      identifier: "users_home",
      fromJson: (data) => UserModel.fromJson(data),
      query: (q) => q.orderBy("createdAt", descending: true),
    );

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () {
              return ref.read(paginationProvider(params).notifier).refresh();
            },
          ),
          SliverPadding(
            padding: PADDING,
            sliver: SliverListCustom<UserModel>(
              params: params,
              itemPlaceholder: UserModel(),
              idExtractor: (userModel) => userModel.id,
              itemBuilder: (userModel) {
                return UserWidget(userModel: userModel);
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3. Grid paginado

```dart
SliverGridCustom<ProductModel>(
  params: productParams,
  itemPlaceholder: ProductModel(),
  crossAxisCount: 2,
  childAspectRatio: 0.78,
  mainAxisSpacing: SPACE_SMALL,
  crossAxisSpacing: SPACE_SMALL,
  idExtractor: (productModel) => productModel.id,
  itemBuilder: (productModel) {
    return ProductCard(productModel: productModel);
  },
)
```

### Estados incluidos

| Estado | Qué hace |
| --- | --- |
| `isLoading` | Muestra skeleton inicial |
| `isFetchingMore` | Muestra skeleton inferior |
| `hasMore` | Controla si se solicita la siguiente página |
| `error` | Muestra error inicial o error al cargar más |

---

## 🍏 Segmented controls

### `SegmentedCupertinoCustom`

Ideal para filtros principales con look nativo Apple.

```dart
SegmentedCupertinoCustom(
  items: ["Hoy", "Semana", "Mes"],
  itemsSecondary: ["12", "48", "130"],
  currentIndex: state.currentTab,
  onValueChanged: (index) {
    controller.changeTab(index);
  },
)
```

### `SegmentedControlCustom`

Control custom con thumb animado y altura configurable.

```dart
SegmentedControlCustom(
  items: ["Pendientes", "Pagadas"],
  currentIndex: state.currentStatus,
  height: 38,
  thumbRadius: RADIUS,
  onValueChanged: (index) {
    controller.changeStatus(index);
  },
)
```

### `SegmentedTabCustom`

Selector tipo tab con línea inferior animada.

```dart
SegmentedTabCustom(
  items: ["Explorar", "Mis reservas"],
  currentIndex: state.currentTab,
  onValueChanged: (index) {
    controller.changeTab(index);
  },
)
```

---

## 🔘 Botones

### `ButtonCustom`

Botón principal con soporte para texto, rich text, iconos `IconData`, SVG, borde, gradiente y semántica.

```dart
ButtonCustom(
  text: "Guardar cambios",
  prefixIcon: Icons.save_rounded,
  onPressed: () {
    controller.save();
  },
)
```

```dart
ButtonCustom(
  text: "Cancelar",
  border: true,
  color: Colors.transparent,
  textColor: COLOR_TEXT,
  borderColor: COLOR_BORDER,
  onPressed: () => Navigator.pop(context),
)
```

### `ButtonCustomIcon`

Botón solo icono con fondo, borde, SVG o `IconData`.

```dart
ButtonCustomIcon(
  icon: Icons.edit_rounded,
  color: COLOR_TEXT,
  colorBackground: COLOR_BACKGROUND_SECONDARY,
  borderColor: COLOR_BORDER,
  borderWidth: 1,
  onPressed: () {
    controller.edit();
  },
)
```

### `OptionButton`

Fila accionable para ajustes, perfiles o menús.

```dart
OptionButton(
  title: "Métodos de pago",
  prefixIcon: Icons.credit_card_rounded,
  suffixIcon: Icons.chevron_right_rounded,
  onTap: () => goTo(context, PaymentsPage()),
)
```

### `MoreMenuButton`

Menú rápido de acciones comunes: editar, eliminar, duplicar y reportar.

```dart
MoreMenuButton(
  onEdit: () {
    controller.edit();
  },
  onDelete: () {
    controller.delete();
  },
)
```

---

## 📝 Formularios e inputs

### `TextFieldCustom`

Campo de texto con tokens visuales, iconos, password, validación, max length, teclado numérico y shadow.

```dart
TextFieldCustom(
  controller: nameController,
  hintText: "Nombre",
  prefixIcon: Icons.person_rounded,
  errorText: "Escribe un nombre",
  onChanged: (value) {
    controller.changeName(value);
  },
)
```

```dart
TextFieldCustom(
  controller: passwordController,
  hintText: "Contraseña",
  password: true,
)
```

### Otros campos

| Widget | Uso |
| --- | --- |
| `TextFieldPhoneCustom` | Teléfono con selector de país |
| `DatePickerField` | Campo que abre selector de fecha |
| `TimePickerField` | Campo que abre selector de hora |
| `TitleAndTextField` | Título + campo en bloque |
| `SelectorList` | Lista de opciones seleccionables |
| `CheckboxPolitics` | Checkbox para políticas/condiciones |

---

## 🔽 Dropdowns

### `DropdownCustom<T>`

Dropdown basado en `PopupMenuButton`, con nombre por función.

```dart
DropdownCustom<CategoryModel>(
  items: categories,
  initialItem: state.categoryModel,
  hintText: "Selecciona categoría",
  tooltip: "Categorías",
  getName: (categoryModel) => categoryModel.name,
  onChanged: (categoryModel) {
    controller.changeCategory(categoryModel);
  },
)
```

### `DropdownSearch<T>`

Versión con búsqueda para listas más largas.

```dart
DropdownSearch<UserModel>(
  items: users,
  initialItem: state.userModel,
  hintText: "Buscar usuario",
  tooltip: "Usuarios",
  getName: (userModel) => userModel.name,
  onChanged: (userModel) {
    controller.changeUser(userModel);
  },
)
```

---

## 🧭 AppBars y navegación

| Helper / Widget | Uso |
| --- | --- |
| `AppBarBack` | AppBar con back estándar |
| `AppBarBackAction` | AppBar con back y acción |
| `AppBarClose` | AppBar con cierre |
| `AppBarDrag` | Barra para bottom sheets o zonas drag |
| `AppBarHome` | AppBar principal con menú, logo y perfil |
| `goTo` | Navega con back |
| `goToNoBack` | Navega sin animación/back estándar |
| `goToClear` | Limpia stack y navega |
| `goBack` | Cierra pantalla devolviendo resultado opcional |

```dart
appBar: AppBarBack(
  context: context,
  title: "Detalle",
)
```

```dart
goTo(context, UserDetailPage(userModel: userModel));
```

---

## 🧊 Overlays, loading y sheets

### `Loading`

Envuelve una pantalla y muestra bloqueo cuando `loading` es true.

```dart
Loading(
  loading: state.isLoading,
  child: CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: TextTitle("Contenido"),
      ),
    ],
  ),
)
```

### `LoadingWithText`

```dart
LoadingWithText(
  loading: state.isLoading,
  text: "Guardando...",
  child: body,
)
```

### `LoadingCustomWidget`

Loader compacto para botones, cards o zonas pequeñas donde no necesitas bloquear toda la pantalla.

```dart
LoadingCustomWidget(
  size: 22,
  strokeWidth: 2.5,
)
```

### Bottom sheets

```dart
openBottomSheet(
  context,
  BottomSheetCustomTwoButtons(
    leftTitle: "Cancelar",
    rightTitle: "Eliminar",
    onLeftPressed: () => goBack(context),
    onRightPressed: () => controller.delete(),
    rightColor: COLOR_ERROR,
  ),
);
```

### `BottomSheetPopUps`

Barra inferior de acciones para popups o editores con acción principal y eliminación opcional.

```dart
BottomSheetPopUps(
  title: "Guardar",
  onPressedSave: () {
    controller.save();
  },
  onPressedDelete: () {
    controller.delete();
  },
)
```

Widgets disponibles:

| Widget / Helper | Uso |
| --- | --- |
| `Loading` | Overlay bloqueante con loader centrado |
| `LoadingWithText` | Overlay bloqueante con texto de estado |
| `LoadingCustomWidget` | Loader compacto reutilizable |
| `BottomSheetCustomOneButton` | Sheet inferior con un botón |
| `BottomSheetCustomTwoButtons` | Sheet inferior con dos botones |
| `BottomSheetPopUps` | Barra inferior para guardar/eliminar en popups |
| `openBottomSheet` | Abre bottom sheet estándar con altura configurable |
| `openStupidSheet` | Abre sheet flotante usando `stupid_simple_sheet` |
| `openStupidCupertinoSheet` | Abre sheet Cupertino con navegación integrada |
| `openBottomNoBack` | Sheet no descartable |
| `openDialog` | Dialog helper |
| `openSnackbar` | Snackbar helper con estados `isError`, `isAlert`, `isDone` |

---

## 🖼️ Imágenes, iconos y media

### `ImageCustom`

Imagen de red con placeholder, borde, radio, modo circular y overlay.

```dart
ImageCustom(
  imageUrl: productModel.image,
  height: 180,
  borderRadius: RADIUS,
  overlay: Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: PADDING_ALL_SMALL,
      child: TextCaption("Nuevo", color: COLOR_TEXT_BUTTONS),
    ),
  ),
)
```

### Otros widgets

| Widget / Helper | Uso |
| --- | --- |
| `ProfileImageCustom` | Avatar de usuario |
| `FullScreenImagePage` | Visor de imagen a pantalla completa |
| `SvgCustom` | SVG con color |
| `SvgCustomNoColor` | SVG sin recolorear |
| `FeaturedIconCustom` | Icono destacado |
| `FeaturedTitle` | Bloque con icono y título |
| `FeaturedSubtitle` | Bloque con icono, título y subtítulo |
| `IconPickerCustom` | Selector de iconos Material |
| `IconGalleryPage` | Galería de iconos UIcons |

---

## 📅 Calendarios y pickers

| Widget | Uso |
| --- | --- |
| `MonthlyCalendar` | Calendario mensual con selección simple o por rango |
| `SliderCalendar` | Calendario horizontal |
| `DatePickerCustom` | Selector custom de fecha |
| `TimePickerCustom` | Selector custom de hora |
| `IconPickerCustom` | Selector de `IconData` en grid |
| `IconGalleryPage` | Galería buscable de iconos UIcons Pro |
| `DatePickerField` | Campo de formulario que abre selector de fecha |
| `TimePickerField` | Campo de formulario que abre selector de hora |

```dart
MonthlyCalendar(
  startDate: DateTime.now(),
  initialDate: state.selectedDate,
  selectionMode: CalendarSelectionMode.single,
  markedDates: state.reservationDates,
  blockedWeekdays: [DateTime.sunday],
  style: CalendarStyle(),
  onDaySelected: (date) {
    controller.changeDate(date);
  },
)
```

### `DatePickerCustom`

Picker Cupertino para fecha, pensado para abrirse dentro de un bottom sheet. Soporta fecha mínima y máxima.

```dart
openBottomSheet(
  context,
  DatePickerCustom(
    initialDateTime: state.selectedDate,
    minimumDate: DateTime.now(),
    maximumDate: DateTime.now().add(Duration(days: 365)),
    onDateTimeChanged: (date) {
      controller.changeDate(date);
    },
  ),
  height: 350,
);
```

### `TimePickerCustom`

Picker Cupertino para hora en formato 24h.

```dart
openBottomSheet(
  context,
  TimePickerCustom(
    initialDateTime: state.selectedTime,
    onDateTimeChanged: (date) {
      controller.changeTime(date);
    },
  ),
  height: 350,
);
```

### `IconPickerCustom`

Selector visual de `IconData`. Puedes usar la lista interna por defecto o pasar una lista propia.

```dart
IconPickerCustom(
  selectedIcon: state.icon,
  accentColor: COLOR_ACCENT,
  crossAxisCount: 8,
  onSelected: (icon) {
    controller.changeIcon(icon);
  },
)
```

### `IconGalleryPage`

Galería de iconos UIcons Pro con búsqueda, paginación interna y selección por nombre.

```dart
goTo(
  context,
  IconGalleryPage(
    initialSelectedIconName: state.iconName,
    onIconSelected: (iconName) {
      controller.changeIconName(iconName);
    },
  ),
);
```

---

## 💻 Responsive web

| Widget | Uso |
| --- | --- |
| `WebAdapterCustom` | Adapta layouts según `WEBSIZE` |
| `WebPopupCustom` | Contenedor/popup optimizado para desktop |
| `HoverCustom` | Feedback visual en hover |
| `BlurCustom` | Efecto blur |
| `ShowUpCustom` | Animación de entrada |
| `ShimmerCustom` | Placeholder shimmer |

---

## 🌍 Multiidioma

Pizzacorn UI incluye helpers para cargar traducciones desde Excel y selectores de idioma.

```dart
await initMultilanguage(defaultLang: 'es');
```

| Widget / Helper | Uso |
| --- | --- |
| `loadExcelTranslations` | Carga traducciones desde Excel |
| `initMultilanguage` | Inicializa localización |
| `LanguageSelector` | Selector completo de idioma |
| `LanguageSmallSelector` | Selector compacto |
| `getFlagEmoji` | Devuelve bandera por código |

---

## 🧰 Catálogo rápido

| Categoría | Widgets / helpers |
| --- | --- |
| Textos | `TextBig`, `TextTitle`, `TextSubtitle`, `TextBody`, `TextButtonCustom`, `TextCaption`, `TextSmall`, `TextCustom` |
| Paginación | `ConfigurePizzacornPagination`, `PizzacornPaginationConfig`, `PaginationParams`, `PaginationState`, `paginationProvider`, `SliverListCustom`, `SliverGridCustom` |
| Segments | `SegmentedCupertinoCustom`, `SegmentedControlCustom`, `SegmentedTabCustom` |
| Botones | `ButtonCustom`, `ButtonCustomIcon`, `OptionButton`, `MoreMenuButton`, `PopupMenuOptions` |
| Formularios | `TextFieldCustom`, `TextFieldPhoneCustom`, `DatePickerField`, `TimePickerField`, `TitleAndTextField`, `SelectorList`, `CheckboxPolitics` |
| Dropdowns | `DropdownCustom`, `DropdownSearch` |
| AppBars | `AppBarBack`, `AppBarBackAction`, `AppBarClose`, `AppBarDrag`, `AppBarHome` |
| Overlays | `Loading`, `LoadingWithText`, `LoadingCustomWidget`, `BottomSheetCustomOneButton`, `BottomSheetCustomTwoButtons`, `BottomSheetPopUps`, `openBottomSheet`, `openStupidSheet`, `openStupidCupertinoSheet`, `openBottomNoBack`, `openDialog`, `openSnackbar` |
| Imágenes | `ImageCustom`, `ProfileImageCustom`, `FullScreenImagePage`, `ImagePublish`, `CropPage` |
| Iconos | `SvgCustom`, `SvgCustomNoColor`, `FeaturedIconCustom`, `FeaturedTitle`, `FeaturedSubtitle`, `IconPickerCustom`, `IconGalleryPage` |
| Calendarios y pickers | `MonthlyCalendar`, `SliderCalendar`, `DatePickerCustom`, `TimePickerCustom`, `IconPickerCustom`, `IconGalleryPage`, `DatePickerField`, `TimePickerField` |
| Navegación | `goTo`, `goToNoBack`, `goToClear`, `goBack`, `openBottomSheet`, `openDialog`, `openSnackbar` |
| Decoración | `DecorationCustom`, `BoxDecorationCustom`, `BorderRadiusCustomAll`, `BoxShadowCustom` |
| Efectos | `ShimmerCustom`, `ShowUpCustom`, `HoverCustom`, `BlurCustom` |
| Login | `LoginCustomPage`, `SelectorCustomPage`, `LoginCustomAuthRepository`, `VerifyEmailCustomPage` |
| Modelos | `FileModel`, `SocialModel` |
| Utils | `parseDate`, `BestOnColor`, `ContrastRatio`, `closeKeyboard`, `UIconsMappingHelper` |

---

## ✅ Ejemplo de pantalla Pizzacorn

```dart
class ReservationsPage extends ConsumerWidget {
  ReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationsProvider);
    final controller = ref.read(reservationsProvider.notifier);
    final params = controller.getPaginationParams();

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      body: Loading(
        loading: state.isLoading,
        child: CustomScrollView(
          slivers: [
            ReservationsAppBar(),
            CupertinoSliverRefreshControl(
              onRefresh: () {
                return ref.read(paginationProvider(params).notifier).refresh();
              },
            ),
            SliverPadding(
              padding: PADDING,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle("Reservas"),
                    Space(SPACE_SMALL),
                    TextBody("Gestiona las próximas reservas."),
                    Space(SPACE_MEDIUM),
                    SegmentedCupertinoCustom(
                      items: ["Próximas", "Historial"],
                      currentIndex: state.currentTab,
                      onValueChanged: (index) {
                        controller.changeTab(index);
                      },
                    ),
                    Space(SPACE_MEDIUM),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: PADDING,
              sliver: SliverListCustom<ReservationModel>(
                params: params,
                itemPlaceholder: ReservationModel(),
                idExtractor: (reservationModel) => reservationModel.id,
                itemBuilder: (reservationModel) {
                  return ReservationWidget(
                    reservationModel: reservationModel,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🧑‍🍳 Equipo

Hecho con mimo por el equipo **Pizzacorn**.

Porque una app sin sistema visual es como una pizza sin queso: puede existir, pero no debería. 🍕✨
