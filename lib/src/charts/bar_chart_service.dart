import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// 🔥 Servicio que transforma Firestore en puntos de gráfica.
class BarChartService {
  BarChartService({required this.barChartConfig});

  BarChartConfig barChartConfig;

  FirebaseFirestore get firestore {
    return PizzacornPaginationConfig.getFirestore(
      databaseName: barChartConfig.databaseName,
    );
  }

  Query getQuery() {
    Query query = firestore.collection(barChartConfig.collection);

    if (barChartConfig.query != null) {
      query = barChartConfig.query!(query);
    }

    if (barChartConfig.limit > 0) {
      query = query.limit(barChartConfig.limit);
    }

    return query;
  }

  Future<List<BarChartPointModel>> getPointList() async {
    if (barChartConfig.collection.isEmpty) {
      return <BarChartPointModel>[];
    }

    final QuerySnapshot snapshot = await getQuery().get();
    final List<Map<String, dynamic>> dataList = <Map<String, dynamic>>[];

    for (int i = 0; i < snapshot.docs.length; i++) {
      final dynamic rawData = snapshot.docs[i].data();
      if (rawData is Map<String, dynamic>) {
        dataList.add(rawData);
      }
    }

    if (barChartConfig.mode == BarChartMode.groupedCount) {
      return buildGroupedCountPoints(dataList);
    }

    return buildFieldValuePoints(dataList);
  }

  List<BarChartPointModel> buildFieldValuePoints(
    List<Map<String, dynamic>> dataList,
  ) {
    final List<BarChartPointModel> pointList = <BarChartPointModel>[];
    final DateFormat dateFormat = DateFormat(
      barChartConfig.dateFormat,
      'es_ES',
    );

    for (int i = 0; i < dataList.length; i++) {
      final dynamic rawX = dataList[i][barChartConfig.xField];
      final dynamic rawY = dataList[i][barChartConfig.yField];
      final double value = parseNumber(rawY);

      if (value == 0 && rawY == null) {
        continue;
      }

      String label = '';
      DateTime? orderDate;
      double orderNumber = 0;
      String rawKey = '';

      if (barChartConfig.xFieldType == BarChartFieldType.date) {
        final DateTime date = parseDate(rawX);
        label = dateFormat.format(date);
        orderDate = date;
        rawKey = date.toIso8601String();
      } else if (barChartConfig.xFieldType == BarChartFieldType.number) {
        orderNumber = parseNumber(rawX);
        label = normalizeNumber(orderNumber);
        rawKey = label;
      } else {
        label = rawX?.toString() ?? '';
        rawKey = label;
      }

      if (label.isEmpty) {
        continue;
      }

      pointList.add(
        BarChartPointModel(
          label: label,
          value: value,
          orderDate: orderDate,
          orderNumber: orderNumber,
          rawKey: rawKey,
        ),
      );
    }

    return applySortingAndLimit(pointList);
  }

  List<BarChartPointModel> buildGroupedCountPoints(
    List<Map<String, dynamic>> dataList,
  ) {
    final Map<String, BarChartPointModel> groupedMap =
        <String, BarChartPointModel>{};
    final DateFormat dateFormat = DateFormat(
      barChartConfig.dateFormat,
      'es_ES',
    );
    final String effectiveGroupField = barChartConfig.groupField.isNotEmpty
        ? barChartConfig.groupField
        : barChartConfig.xField;

    for (int i = 0; i < dataList.length; i++) {
      final dynamic rawValue = dataList[i][effectiveGroupField];
      String label = '';
      DateTime? orderDate;
      double orderNumber = 0;
      String rawKey = '';

      if (barChartConfig.xFieldType == BarChartFieldType.date) {
        final DateTime date = parseDate(rawValue);
        label = dateFormat.format(date);
        orderDate = date;
        rawKey = date.toIso8601String();
      } else if (barChartConfig.xFieldType == BarChartFieldType.number) {
        orderNumber = parseNumber(rawValue);
        label = normalizeNumber(orderNumber);
        rawKey = label;
      } else {
        label = rawValue?.toString() ?? '';
        rawKey = label;
      }

      if (label.isEmpty) {
        continue;
      }

      if (!groupedMap.containsKey(rawKey)) {
        groupedMap[rawKey] = BarChartPointModel(
          label: label,
          value: 0,
          orderDate: orderDate,
          orderNumber: orderNumber,
          rawKey: rawKey,
        );
      }

      groupedMap[rawKey] = groupedMap[rawKey]!.copyWith(
        value: groupedMap[rawKey]!.value + 1,
      );
    }

    final List<BarChartPointModel> pointList = groupedMap.values.toList();
    return applySortingAndLimit(pointList);
  }

  List<BarChartPointModel> applySortingAndLimit(
    List<BarChartPointModel> pointList,
  ) {
    pointList.sort((a, b) {
      if (barChartConfig.sortType == BarChartSortType.yAsc) {
        return a.value.compareTo(b.value);
      }

      if (barChartConfig.sortType == BarChartSortType.yDesc) {
        return b.value.compareTo(a.value);
      }

      if (barChartConfig.xFieldType == BarChartFieldType.date) {
        final DateTime safeA = a.orderDate ?? DateTime(2000);
        final DateTime safeB = b.orderDate ?? DateTime(2000);
        return barChartConfig.sortType == BarChartSortType.xDesc
            ? safeB.compareTo(safeA)
            : safeA.compareTo(safeB);
      }

      if (barChartConfig.xFieldType == BarChartFieldType.number) {
        return barChartConfig.sortType == BarChartSortType.xDesc
            ? b.orderNumber.compareTo(a.orderNumber)
            : a.orderNumber.compareTo(b.orderNumber);
      }

      return barChartConfig.sortType == BarChartSortType.xDesc
          ? b.label.toLowerCase().compareTo(a.label.toLowerCase())
          : a.label.toLowerCase().compareTo(b.label.toLowerCase());
    });

    if (barChartConfig.maxBars > 0 && pointList.length > barChartConfig.maxBars) {
      return pointList.sublist(0, barChartConfig.maxBars);
    }

    return pointList;
  }

  double parseNumber(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  String normalizeNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}
