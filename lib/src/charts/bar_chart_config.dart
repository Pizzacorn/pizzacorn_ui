import 'package:cloud_firestore/cloud_firestore.dart';

enum BarChartMode {
  fieldValues,
  groupedCount,
}

enum BarChartFieldType {
  date,
  number,
  text,
}

enum BarChartSortType {
  xAsc,
  xDesc,
  yAsc,
  yDesc,
}

/// ⚙️ Configuración pública para gráficas de barras.
class BarChartConfig {
  BarChartConfig({
    this.title = 'Gráfico',
    this.collection = '',
    this.databaseName = '',
    this.mode = BarChartMode.fieldValues,
    this.query,
    this.xField = '',
    this.yField = '',
    this.groupField = '',
    this.xFieldType = BarChartFieldType.text,
    this.sortType = BarChartSortType.xAsc,
    this.limit = 0,
    this.maxBars = 50,
    this.dateFormat = 'dd/MM/yy',
    this.emptyText = 'No hay datos para mostrar',
    this.valuePrefix = '',
    this.valueSuffix = '',
    this.buttonText = 'Ver gráfico',
  });

  String title;
  String collection;
  String databaseName;
  BarChartMode mode;
  Query Function(Query query)? query;
  String xField;
  String yField;
  String groupField;
  BarChartFieldType xFieldType;
  BarChartSortType sortType;
  int limit;
  int maxBars;
  String dateFormat;
  String emptyText;
  String valuePrefix;
  String valueSuffix;
  String buttonText;
}
