class NotificationCustomModel {
  String id;
  String userId;
  String title;
  String body;
  String type;
  String relatedId;
  int createdAt;
  int updatedAt;
  bool isRead;
  Map<String, dynamic> extraData;

  NotificationCustomModel({
    this.id = '',
    this.userId = '',
    this.title = '',
    this.body = '',
    this.type = 'system',
    this.relatedId = '',
    this.createdAt = 0,
    this.updatedAt = 0,
    this.isRead = false,
    this.extraData = const {},
  });

  factory NotificationCustomModel.fromJson(Map<String, dynamic> json) {
    return NotificationCustomModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? 'system',
      relatedId: json['relatedId'] as String? ?? '',
      createdAt: json['createdAt'] as int? ?? 0,
      updatedAt: json['updatedAt'] as int? ?? 0,
      isRead: json['isRead'] as bool? ?? false,
      extraData: Map<String, dynamic>.from(json['extraData'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'relatedId': relatedId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isRead': isRead,
      'extraData': extraData,
    };
  }

  Map<String, dynamic> toJsonCreate() {
    final int now = DateTime.now().millisecondsSinceEpoch;
    return copyWith(createdAt: now, updatedAt: now, isRead: false).toJson();
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    ).toJson();
    data.remove('id');
    data.remove('createdAt');
    return data;
  }

  NotificationCustomModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    String? relatedId,
    int? createdAt,
    int? updatedAt,
    bool? isRead,
    Map<String, dynamic>? extraData,
  }) {
    return NotificationCustomModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
      extraData: extraData ?? this.extraData,
    );
  }
}
