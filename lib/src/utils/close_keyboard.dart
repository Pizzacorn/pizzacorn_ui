import 'package:flutter/material.dart';

// Función: closeKeyboard
/// Motivo: Cierra el teclado virtual de forma segura desenfocando cualquier input activo.
/// API: closeKeyboard(context);

void closeKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.unfocus();
  }
}