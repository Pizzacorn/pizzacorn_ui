import 'package:flutter/material.dart';

/// Navega a una nueva página manteniendo la pantalla anterior en el stack.
///
/// Uso:
/// ```dart
/// goTo(context, const HomePage());
/// ```
Future<T?> goTo<T>(BuildContext context, Widget page, {VoidCallback? onBack}) {
  return Navigator.of(
    context,
  ).push<T>(MaterialPageRoute(builder: (_) => page)).then((value) {
    if (onBack != null) {
      onBack();
    }
    return value;
  });
}

/// Navega a una nueva página reemplazando la actual (no se puede volver atrás).
///
/// Uso:
/// ```dart
/// goToNoBack(context, const LoginPage());
/// ```
Future<T?> goToNoBack<T>(
  BuildContext context,
  Widget page, {
  VoidCallback? onBack,
}) {
  return Navigator.of(context)
      .pushReplacement<T, T?>(MaterialPageRoute(builder: (_) => page))
      .then((value) {
        if (onBack != null) {
          onBack();
        }
        return value;
      });
}

/// Navega a una nueva página y limpia por completo el histórico de navegación.
///
/// Ideal para flujos de login → home.
///
/// Uso:
/// ```dart
/// goToClear(context, const HomePage());
/// ```
Future<T?> goToClear<T>(
  BuildContext context,
  Widget page, {
  VoidCallback? onBack,
}) {
  return Navigator.of(context)
      .pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        (_) => false,
      )
      .then((value) {
        if (onBack != null) {
          onBack();
        }
        return value;
      });
}

/// Hace pop de la ruta actual si es posible (equivalente a Navigator.pop()).
///
/// Uso:
/// ```dart
/// goBack(context);
/// ```
void goBack(BuildContext context, {Object? result}) {
  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop(result);
  }
}
