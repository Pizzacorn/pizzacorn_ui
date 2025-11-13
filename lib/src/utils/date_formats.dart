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
