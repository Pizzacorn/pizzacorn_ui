## 0.0.15

### 🛠️ BUG FIXES & IMPROVEMENTS
- **`ButtonCustom` Visual Fix**: Se corrige el alineamiento del texto. Ahora el contenido se mantiene perfectamente centrado por defecto mediante un sistema de contrapesos dinámicos.
- **Button Padding**: Se establece un padding horizontal por defecto de 15px para evitar que el contenido se pegue a los bordes.
- **Color Consistency**: Forzado de `COLOR_TEXT` como color base para la tipografía de los botones, mejorando la legibilidad sobre fondos claros.
- **Icon Balancing**: Implementación de `SizedBox` de equilibrio para que el texto no se desplace lateralmente cuando solo hay un icono (inicial o final).

### 🎨 UI REFINEMENTS
- **TextField Alignment**: Ajuste fino del `contentPadding` en `TextFieldCustom` para garantizar el centrado vertical con la nueva altura de 40px (`FIELD_HEIGHT`).