import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- CONFIGURACIÓN GLOBAL DE PAGINACIÓN ---
class PizzacornPaginationConfig {
  static String? databaseName;

  static FirebaseFirestore get firestore {
    if (databaseName == null || databaseName!.trim().isEmpty) {
      return FirebaseFirestore.instance;
    }

    final FirebaseFirestore defaultFirestore = FirebaseFirestore.instance;

    return FirebaseFirestore.instanceFor(
      app: defaultFirestore.app,
      databaseId: databaseName!.trim(),
    );
  }
}

/// Configura la base de datos usada por la paginación Pizzacorn.
///
/// Si no se llama a esta función, o si [databaseName] viene vacío, Firestore usa
/// la base `(default)` como hasta ahora. 🍕
void ConfigurePizzacornPagination({String? databaseName}) {
  final String? cleanDatabaseName = databaseName?.trim();

  if (cleanDatabaseName == null ||
      cleanDatabaseName.isEmpty ||
      cleanDatabaseName == '(default)') {
    PizzacornPaginationConfig.databaseName = null;
    return;
  }

  PizzacornPaginationConfig.databaseName = cleanDatabaseName;
}

// --- ESTADO --- (Se mantiene igual, impecable)
class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasMore;
  final String error;

  PaginationState({
    this.items = const [],
    this.isLoading = true,
    this.isFetchingMore = false,
    this.hasMore = true,
    this.error = '',
  });

  PaginationState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasMore,
    String? error,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

// --- PARÁMETROS --- (Se mantiene igual, con tu identifier)
class PaginationParams<T> {
  final String collection;
  final Query Function(Query q)? query;
  final int limit;
  final T Function(Map<String, dynamic> data) fromJson;
  final String? identifier;

  PaginationParams({
    required this.collection,
    required this.fromJson,
    this.query,
    this.limit = 15,
    this.identifier,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaginationParams &&
              runtimeType == other.runtimeType &&
              collection == other.collection &&
              limit == other.limit &&
              identifier == other.identifier;

  @override
  int get hashCode => collection.hashCode ^ limit.hashCode ^ identifier.hashCode;
}


class PaginationController<T> extends AutoDisposeFamilyNotifier<PaginationState<T>, PaginationParams<T>> {
  DocumentSnapshot? lastDocument;
  bool isMounted = true;

  @override
  PaginationState<T> build(PaginationParams<T> arg) {
    ref.onDispose(() => isMounted = false);

    // Carga inicial
    Future.microtask(() => loadItems());

    return PaginationState<T>();
  }

  Query getQuery() {
    Query q = PizzacornPaginationConfig.firestore.collection(arg.collection);
    if (arg.query != null) {
      q = arg.query!(q);
    }
    return q;
  }

  Future<void> refresh() async {
    lastDocument = null;
    await loadItems();
  }

  Future<void> loadItems() async {
    try {
      state = state.copyWith(isLoading: true, items: [], error: '');

      Query q = getQuery().limit(arg.limit);
      final snapshot = await q.get();

      if (!isMounted) return;

      final List<T> newItems = [];

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;

        for (int i = 0; i < snapshot.docs.length; i++) {
          final data = snapshot.docs[i].data() as Map<String, dynamic>;
          newItems.add(arg.fromJson(data));
        }

        state = state.copyWith(
          items: newItems,
          isLoading: false,
          hasMore: snapshot.docs.length == arg.limit,
        );
      } else {
        state = state.copyWith(isLoading: false, hasMore: false, items: []);
      }
    } catch (e) {
      if (isMounted) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  Future<void> fetchMore() async {
    if (state.isFetchingMore || !state.hasMore || lastDocument == null || state.isLoading) return;

    try {
      // 🛡️ IMPORTANTE: Limpiamos el error aquí para que pueda reintentar de forma limpia
      state = state.copyWith(isFetchingMore: true, error: '');

      Query q = getQuery().startAfterDocument(lastDocument!).limit(arg.limit);
      final snapshot = await q.get();

      if (!isMounted) return;

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
        final List<T> moreItems = List.from(state.items);

        for (int i = 0; i < snapshot.docs.length; i++) {
          final data = snapshot.docs[i].data() as Map<String, dynamic>;
          moreItems.add(arg.fromJson(data));
        }

        state = state.copyWith(
          items: moreItems,
          isFetchingMore: false,
          hasMore: snapshot.docs.length == arg.limit,
        );
      } else {
        state = state.copyWith(isFetchingMore: false, hasMore: false);
      }
    } catch (e) {
      if (isMounted) {
        // Si hay error, quitamos el loader y guardamos el error
        state = state.copyWith(isFetchingMore: false, error: e.toString());
      }
    }
  }
}

final paginationProvider = NotifierProvider.autoDispose.family<
    PaginationController<dynamic>,
    PaginationState<dynamic>,
    PaginationParams<dynamic>
>(() {
  return PaginationController();
});
