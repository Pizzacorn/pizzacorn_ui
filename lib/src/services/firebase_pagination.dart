import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebasePagination {
  /// Función MAESTRA GENÉRICA para Firestore
  static Future<PaginationResult<T>> get<T>({
    required BuildContext context,
    required String collection,
    required String orderBy,
    required T Function(Map<String, dynamic>) fromFirestore,
    int limit = 20,
    DocumentSnapshot? lastDocument,
    bool descending = false,
  }) async {
    // Usamos tus constantes de debug si existen, si no, prints limpios
    if (kDebugMode) print("🚀 Cargando $collection (Paginando)...");

    try {
      Query query = FirebaseFirestore.instance
          .collection(collection)
          .orderBy(orderBy, descending: descending)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      // REGLA: Bucles con índice, prohibido for-in o forEach
      final List<T> items = <T>[];
      for (int i = 0; i < snapshot.docs.length; i++) {
        final data = snapshot.docs[i].data() as Map<String, dynamic>;
        items.add(fromFirestore(data));
      }

      if (kDebugMode) print("✅ $collection - Cargados: ${items.length}");

      return PaginationResult<T>(
        items: items,
        hasMore: snapshot.docs.length == limit,
        lastDocument: snapshot.docs.isNotEmpty
            ? snapshot.docs.last
            : lastDocument,
      );
    } catch (e) {
      if (kDebugMode) print("❌ Error al cargar $collection: $e");
      // Asumimos que openSnackbar es parte de tu toolkit
      // openSnackbar(context, text: "Error al cargar $collection");
      return PaginationResult<T>(
        items: [],
        hasMore: false,
        lastDocument: lastDocument,
      );
    }
  }
}

class PaginationResult<T> {
  final List<T> items;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;

  PaginationResult({
    required this.items,
    required this.hasMore,
    this.lastDocument,
  });
}

class PaginationState<T> {
  final List<T> items;
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;

  PaginationState({
    this.items = const [],
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = true,
    this.lastDocument,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}
