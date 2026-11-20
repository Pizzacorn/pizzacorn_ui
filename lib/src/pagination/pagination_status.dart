import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Textos de los estados visibles de una lista o un grid paginado.
class PaginationMessages {
  final String empty;
  final String initialError;
  final String loadMoreError;
  final String retry;
  final String loadMore;
  final String loading;

  const PaginationMessages({
    this.empty = 'No hay resultados',
    this.initialError = 'No se pudieron cargar los resultados.',
    this.loadMoreError = 'No se pudieron cargar más resultados.',
    this.retry = 'Reintentar',
    this.loadMore = 'Cargar más resultados',
    this.loading = 'Cargando resultados',
  });
}

class PaginationStatus extends StatelessWidget {
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool loading;
  final String? loadingLabel;

  PaginationStatus({
    super.key,
    this.message,
    this.actionLabel,
    this.onAction,
    this.loading = false,
    this.loadingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        primary: false,
        padding: PADDING_ALL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message != null)
              Semantics(
                liveRegion: true,
                child: TextBody(message!, textAlign: TextAlign.center),
              ),
            if (message != null && actionLabel != null) Space(SPACE_SMALL),
            if (loading)
              SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  semanticsLabel: loadingLabel,
                ),
              )
            else if (actionLabel != null)
              OutlinedButton(
                onPressed: onAction,
                child: TextBody(actionLabel!, textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
    );
  }
}
