/// 📊 Punto individual de la gráfica.
class BarChartPointModel {
  BarChartPointModel({
    this.label = '',
    this.value = 0,
    this.orderDate,
    this.orderNumber = 0,
    this.rawKey = '',
  });

  String label;
  double value;
  DateTime? orderDate;
  double orderNumber;
  String rawKey;

  BarChartPointModel copyWith({
    String? label,
    double? value,
    DateTime? orderDate,
    double? orderNumber,
    String? rawKey,
  }) {
    return BarChartPointModel(
      label: label ?? this.label,
      value: value ?? this.value,
      orderDate: orderDate ?? this.orderDate,
      orderNumber: orderNumber ?? this.orderNumber,
      rawKey: rawKey ?? this.rawKey,
    );
  }
}
