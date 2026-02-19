import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- ESTADO ---
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

// --- PARÁMETROS ---
class PaginationParams<T> {
  final String collection;
  final Query Function(Query q)? query;
  final int limit;
  final T Function(Map<String, dynamic> data, String id) fromJson;

  PaginationParams({
    required this.collection,
    required this.fromJson,
    this.query,
    this.limit = 15,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaginationParams &&
              runtimeType == other.runtimeType &&
              collection == other.collection &&
              limit == other.limit;

  @override
  int get hashCode => collection.hashCode ^ limit.hashCode;
}

// --- CONTROLADOR ---
class PaginationController<T> extends AutoDisposeFamilyNotifier<PaginationState<T>, PaginationParams<T>> {
  DocumentSnapshot? lastDocument;
  bool isMounted = true;

  @override
  PaginationState<T> build(PaginationParams<T> arg) {
    ref.onDispose(() => isMounted = false);
    Future.microtask(() => loadItems());
    return PaginationState<T>();
  }

  Query _getQuery() {
    Query q = FirebaseFirestore.instance.collection(arg.collection);
    if (arg.query != null) {
      q = arg.query!(q);
    }
    return q;
  }

  Future<void> loadItems() async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      Query q = _getQuery().limit(arg.limit);
      final snapshot = await q.get();

      if (!isMounted) return;

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
        final List<T> newItems = [];

        for (int i = 0; i < snapshot.docs.length; i++) {
          newItems.add(arg.fromJson(snapshot.docs[i].data() as Map<String, dynamic>, snapshot.docs[i].id));
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
      if (isMounted) state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchMore() async {
    if (state.isFetchingMore || !state.hasMore || lastDocument == null) return;

    try {
      state = state.copyWith(isFetchingMore: true);

      Query q = _getQuery().startAfterDocument(lastDocument!).limit(arg.limit);
      final snapshot = await q.get();

      if (!isMounted) return;

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
        final List<T> moreItems = List.from(state.items);

        for (int i = 0; i < snapshot.docs.length; i++) {
          moreItems.add(arg.fromJson(snapshot.docs[i].data() as Map<String, dynamic>, snapshot.docs[i].id));
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
      if (isMounted) state = state.copyWith(isFetchingMore: false, error: e.toString());
    }
  }
}

// 🟢 Tipado corregido para que el compilador sea feliz con los genéricos
final paginationProvider = NotifierProvider.autoDispose.family<
    PaginationController<dynamic>,
    PaginationState<dynamic>,
    PaginationParams<dynamic>
>(() {
  return PaginationController();
});