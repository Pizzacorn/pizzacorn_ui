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
class PaginationWhereFilter {
  final String field;
  final dynamic value;
  PaginationWhereFilter(this.field, this.value);

  // 🟢 Añadido para que la comparación de parámetros funcione correctamente
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaginationWhereFilter &&
              runtimeType == other.runtimeType &&
              field == other.field &&
              value == other.value;

  @override
  int get hashCode => field.hashCode ^ value.hashCode;
}

class PaginationParams<T> {
  final String collection;
  final List<PaginationWhereFilter>? whereFilters;
  final String? orderBy;
  final bool descending;
  final T Function(Map<String, dynamic> data, String id) fromJson;

  PaginationParams({
    required this.collection,
    required this.fromJson,
    this.whereFilters,
    this.orderBy,
    this.descending = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaginationParams &&
              runtimeType == other.runtimeType &&
              collection == other.collection &&
              orderBy == other.orderBy &&
              descending == other.descending &&
              // 🟢 Ahora comparamos también los filtros
              const ListEquality().equals(whereFilters, other.whereFilters);

  @override
  int get hashCode =>
      collection.hashCode ^
      orderBy.hashCode ^
      descending.hashCode ^
      const ListEquality().hash(whereFilters);
}

// --- CONTROLADOR ---
class PaginationController<T> extends AutoDisposeFamilyNotifier<PaginationState<T>, PaginationParams<T>> {
  DocumentSnapshot? lastDocument;
  final int limit = 15;
  bool isMounted = true; // 🟢 Para evitar setear estado si el provider se destruye

  @override
  PaginationState<T> build(PaginationParams<T> arg) {
    ref.onDispose(() => isMounted = false);
    Future.microtask(() => loadItems());
    return PaginationState<T>();
  }

  Future<void> loadItems() async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      Query query = FirebaseFirestore.instance.collection(arg.collection).limit(limit);

      if (arg.whereFilters != null) {
        for (int i = 0; i < arg.whereFilters!.length; i++) {
          final filter = arg.whereFilters![i];
          query = query.where(filter.field, isEqualTo: filter.value);
        }
      }

      if (arg.orderBy != null) {
        query = query.orderBy(arg.orderBy!, descending: arg.descending);
      }

      final snapshot = await query.get();

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
          hasMore: snapshot.docs.length == limit,
        );
      } else {
        state = state.copyWith(isLoading: false, hasMore: false, items: []);
      }
    } catch (e) {
      if (isMounted) state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchMore() async {
    // 🟢 Evitamos múltiples llamadas simultáneas que causan LAG
    if (state.isFetchingMore || !state.hasMore || lastDocument == null) return;

    try {
      state = state.copyWith(isFetchingMore: true);

      Query query = FirebaseFirestore.instance
          .collection(arg.collection)
          .limit(limit)
          .startAfterDocument(lastDocument!);

      if (arg.whereFilters != null) {
        for (int i = 0; i < arg.whereFilters!.length; i++) {
          final filter = arg.whereFilters![i];
          query = query.where(filter.field, isEqualTo: filter.value);
        }
      }

      if (arg.orderBy != null) {
        query = query.orderBy(arg.orderBy!, descending: arg.descending);
      }

      final snapshot = await query.get();

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
          hasMore: snapshot.docs.length == limit,
        );
      } else {
        state = state.copyWith(isFetchingMore: false, hasMore: false);
      }
    } catch (e) {
      if (isMounted) state = state.copyWith(isFetchingMore: false, error: e.toString());
    }
  }
}

// --- PROVIDER ---
final paginationProvider = NotifierProvider.autoDispose.family<PaginationController, PaginationState, PaginationParams>(() {
  return PaginationController();
});