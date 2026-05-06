import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// FORMATOS DE FECHA/HORA PIZZACORN //////////////////////////////////////////
///
/// Notas:
/// - Todos usan locale "es_ES".
/// - Se exponen como variables globales para reutilizarlos en toda la app.
/// - Si alguna app necesita otros formatos, puede definir los suyos propios.

final DateFormat FORMAT_MONTH_COMPRESS = DateFormat("MMM", "es_ES");
final DateFormat FORMAT_MONTH = DateFormat("MMMM", "es_ES");
final DateFormat FORMAT_MONTH_AND_DAY = DateFormat("dd MMM", "es_ES");
final DateFormat FORMAT_YEAR_MONTH_AND_DAY = DateFormat("dd MMM yyyy", "es_ES");
final DateFormat FORMAT_MONTH_NUMBER = DateFormat("MM", "es_ES");
final DateFormat FORMAT_MONTH_GLOBAL = DateFormat("yyyyMM", "es_ES");

final DateFormat FORMAT_DAY = DateFormat("EEE", "es_ES");
final DateFormat FORMAT_DAY_NUMBER = DateFormat("dd", "es_ES");
final DateFormat FORMAT_DATE = DateFormat("dd/MM/yy", "es_ES");
final DateFormat FORMAT_DATE_HOUR = DateFormat("dd/MM/yy - HH:mm", "es_ES");
final DateFormat FORMAT_DAY_WHATSAPP = DateFormat("dd MMMM yyyy", "es_ES");
final DateFormat FORMAT_DATE_GLOBAL = DateFormat("yyyyMMdd", "es_ES");

final DateFormat FORMAT_HOUR = DateFormat("HH:mm", "es_ES");
final DateFormat FORMAT_HOUR_GLOBAL = DateFormat("HHmm", "es_ES");

/// 🍕 Helper centralizado para parsear fechas de Firebase o DateTime.
/// 🚀 Si el valor es nulo o inválido, devuelve una fecha fallback segura.
/// ✨ Útil en fábricas fromJson para evitar `?? DateTime(2000)` repetidos.
DateTime parseDate(
  dynamic date, {
  DateTime? fallback,
}) {
  final DateTime safeFallback = fallback ?? DateTime(2000);

  if (date == null) return safeFallback;
  if (date is Timestamp) return date.toDate();
  if (date is DateTime) return date;
  return safeFallback;
}
