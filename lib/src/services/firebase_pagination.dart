import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebasePagination {
  static Future<PaginationResult<T>> get<T>({
    required BuildContext context,
    required String collection,
    required String orderBy,
    required T Function(Map<String, dynamic>) fromFirestore,
    int limit = 20,
    DocumentSnapshot? lastDocument,
    bool descending = false,
    List<WhereFilter>? where,
  }) async {
    if (kDebugMode) print("🚀 Cargando $collection (Paginando)...");

    try {
      // 1. Referencia base
      Query query = FirebaseFirestore.instance.collection(collection);

      // 2. Aplicar Filtros (Ley del Bucle Indexado)
      if (where != null && where.isNotEmpty) {
        for (int i = 0; i < where.length; i++) {
          final filter = where[i];

          // Ignoramos filtros con valores nulos para evitar que la query muera
          if (filter.value == null) continue;

          switch (filter.operator) {
            case WhereOperator.isEqualTo:
              query = query.where(filter.field, isEqualTo: filter.value);
              break;
            case WhereOperator.isNotEqualTo:
              query = query.where(filter.field, isNotEqualTo: filter.value);
              break;
            case WhereOperator.isGreaterThan:
              query = query.where(filter.field, isGreaterThan: filter.value);
              break;
            case WhereOperator.isGreaterThanOrEqualTo:
              query = query.where(filter.field, isGreaterThanOrEqualTo: filter.value);
              break;
            case WhereOperator.isLessThan:
              query = query.where(filter.field, isLessThan: filter.value);
              break;
            case WhereOperator.isLessThanOrEqualTo:
              query = query.where(filter.field, isLessThanOrEqualTo: filter.value);
              break;
            case WhereOperator.arrayContains:
              query = query.where(filter.field, arrayContains: filter.value);
              break;
            case WhereOperator.arrayContainsAny:
              query = query.where(filter.field, arrayContainsAny: filter.value as List);
              break;
          }
        }
      }

      // 3. Orden y Paginación
      // 🔥 IMPORTANTE: Si usas filtros de rango (<, >, <=, >=), el primer orderBy debe ser sobre ese mismo campo.
      query = query.orderBy(orderBy, descending: descending);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // 4. Ejecución con Límite
      final snapshot = await query.limit(limit).get();

      // 5. Mapeo de Resultados (Ley del Bucle Indexado)
      final List<T> items = <T>[];
      final docs = snapshot.docs;

      for (int i = 0; i < docs.length; i++) {
        final doc = docs[i];
        final data = doc.data() as Map<String, dynamic>;

        // Inyectamos el ID del documento siempre
        data['id'] = doc.id;

        items.add(fromFirestore(data));
      }

      return PaginationResult<T>(
        items: items,
        hasMore: docs.length == limit,
        lastDocument: docs.isNotEmpty ? docs.last : lastDocument,
      );
    } catch (e) {
      if (kDebugMode) print("❌ Error en FirebasePagination ($collection): $e");
      return PaginationResult<T>(items: [], hasMore: false, lastDocument: lastDocument);
    }
  }
}

// 🟢 Enum extendido para ser el Rey de las Queries
enum WhereOperator {
  isEqualTo,
  isNotEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  arrayContains,
  arrayContainsAny
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


class WhereFilter {
  final String field;
  final dynamic value;
  final WhereOperator operator;

  WhereFilter(this.field, this.value, {this.operator = WhereOperator.isEqualTo});
}