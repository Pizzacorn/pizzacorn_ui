import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- CONFIGURACIÓN GLOBAL DE PAGINACIÓN ---
class PizzacornPaginationConfig {
  static String? databaseName;

  static FirebaseFirestore get firestore {
    return getFirestore(databaseName: databaseName);
  }

  static FirebaseFirestore getFirestore({String? databaseName}) {
    final String? cleanDatabaseName = sanitizeDatabaseName(databaseName);

    if (cleanDatabaseName == null) {
      return FirebaseFirestore.instance;
    }

    // 🔥 Usamos Firebase.app() para no inicializar la instancia Firestore `(default)`.
    return FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: cleanDatabaseName,
    );
  }

  static String? sanitizeDatabaseName(String? databaseName) {
    final String? cleanDatabaseName = databaseName?.trim();

    if (cleanDatabaseName == null ||
        cleanDatabaseName.isEmpty ||
        cleanDatabaseName == '(default)') {
      return null;
    }

    return cleanDatabaseName;
  }
}

/// Configura la base de datos usada por la paginación Pizzacorn.
///
/// Si no se llama a esta función, o si [databaseName] viene vacío, Firestore usa
/// la base `(default)` como hasta ahora. 🍕
void ConfigurePizzacornPagination({String? databaseName}) {
  PizzacornPaginationConfig.databaseName =
      PizzacornPaginationConfig.sanitizeDatabaseName(databaseName);
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
  final String? databaseName;
  final bool Function(dynamic item)? itemFilter;
  final int maxFetchBatches;

  PaginationParams({
    required this.collection,
    required this.fromJson,
    this.query,
    this.limit = 15,
    this.identifier,
    bool Function(T item)? itemFilter,
    this.maxFetchBatches = 5,
    String? databaseName,
  }) : itemFilter = itemFilter == null
           ? null
           : ((dynamic item) => itemFilter(item as T)),
       databaseName = PizzacornPaginationConfig.sanitizeDatabaseName(
          databaseName ?? PizzacornPaginationConfig.databaseName,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaginationParams &&
              runtimeType == other.runtimeType &&
              collection == other.collection &&
              limit == other.limit &&
              maxFetchBatches == other.maxFetchBatches &&
              databaseName == other.databaseName &&
              identifier == other.identifier;

  @override
  int get hashCode =>
      collection.hashCode ^
      limit.hashCode ^
      maxFetchBatches.hashCode ^
      databaseName.hashCode ^
      identifier.hashCode;
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
    Query q = PizzacornPaginationConfig.getFirestore(
      databaseName: arg.databaseName,
    ).collection(arg.collection);
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
      final (List<T>, DocumentSnapshot?, bool) page = await readVisiblePage();
      if (!isMounted) return;
      lastDocument = page.$2;
      state = state.copyWith(items: page.$1, isLoading: false, hasMore: page.$3);
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

      final (List<T>, DocumentSnapshot?, bool) page = await readVisiblePage(
        afterDocument: lastDocument,
      );
      if (!isMounted) return;
      lastDocument = page.$2;
      state = state.copyWith(
        items: [...state.items, ...page.$1],
        isFetchingMore: false,
        hasMore: page.$3,
      );
    } catch (e) {
      if (isMounted) {
        // Si hay error, quitamos el loader y guardamos el error
        state = state.copyWith(isFetchingMore: false, error: e.toString());
      }
    }
  }

  Future<(List<T>, DocumentSnapshot?, bool)> readVisiblePage({
    DocumentSnapshot? afterDocument,
  }) async {
    final List<T> visibleItems = [];
    DocumentSnapshot? cursor = afterDocument;
    final int batchLimit = arg.itemFilter == null ? 1 : arg.maxFetchBatches;
    if (arg.limit <= 0 || batchLimit <= 0) {
      throw ArgumentError('limit y maxFetchBatches deben ser mayores que cero.');
    }

    for (int batch = 0; batch < batchLimit && visibleItems.length < arg.limit; batch++) {
      Query query = getQuery();
      if (cursor != null) query = query.startAfterDocument(cursor);
      final int remaining = arg.limit - visibleItems.length;
      final snapshot = await query.limit(remaining).get();
      if (snapshot.docs.isEmpty) return (visibleItems, cursor, false);

      for (int i = 0; i < snapshot.docs.length; i++) {
        final document = snapshot.docs[i];
        cursor = document;
        final data = document.data() as Map<String, dynamic>;
        final T item = arg.fromJson(data);
        if (arg.itemFilter == null || arg.itemFilter!(item)) {
          visibleItems.add(item);
        }
      }
      if (snapshot.docs.length < remaining) return (visibleItems, cursor, false);
    }
    return (visibleItems, cursor, true);
  }
}

final paginationProvider = NotifierProvider.autoDispose.family<
    PaginationController<dynamic>,
    PaginationState<dynamic>,
    PaginationParams<dynamic>
>(() {
  return PaginationController();
});
