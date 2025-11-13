import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

/// Navega a una nueva página manteniendo la pantalla anterior en el stack.
/// [page] es el widget de destino.
/// [onBack] se ejecuta cuando se hace pop y se vuelve a la pantalla anterior.
void GoTo(Widget page, {Function()? onBack}) {
  NavigationService.navigatorKey.currentState
      ?.push(
    MaterialPageRoute(
      builder: (_) => page,
    ),
  )
      .then((_) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// Navega a una nueva página reemplazando la actual (no se puede volver atrás).
/// [page] es el widget de destino.
/// [onBack] se ejecuta cuando esa página se cierra (por ejemplo, con otro GoBack()).
void GoToNoBack(Widget page, {Function()? onBack}) {
  NavigationService.navigatorKey.currentState
      ?.pushReplacement(
    MaterialPageRoute(
      builder: (_) => page,
    ),
  )
      .then((_) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// Navega a una nueva página y limpia por completo el histórico de navegación.
/// Ideal para flujos de login → home.
/// [page] es el widget de destino.
/// [onBack] se ejecuta cuando esa página se cierre (si se llega a cerrar).
void GoToClear(Widget page, {Function()? onBack}) {
  NavigationService.navigatorKey.currentState
      ?.pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => page,
    ),
        (_) => false,
  )
      .then((_) {
    if (onBack != null) {
      onBack();
    }
  });
}

/// Hace pop de la ruta actual si es posible (equivalente a Navigator.pop()).
void GoBack() {
  NavigationService.navigatorKey.currentState?.pop();
}
