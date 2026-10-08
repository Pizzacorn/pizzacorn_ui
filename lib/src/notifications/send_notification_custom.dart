import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:pizzacorn_ui/src/models/notification_custom_model.dart';

class PizzacornNotificationsConfig {
  static List<String> types = const ['system'];
}

/// Configura los tipos admitidos por el paquete y la aplicación.
void ConfigurePizzacornNotifications({required List<String> types}) {
  final List<String> cleanTypes = ['system'];
  for (int i = 0; i < types.length; i++) {
    final String type = types[i].trim();
    if (type.isEmpty) {
      throw ArgumentError.value(types[i], 'types', 'El tipo no puede estar vacío');
    }
    if (!cleanTypes.contains(type)) {
      cleanTypes.add(type);
    }
  }
  PizzacornNotificationsConfig.types = List.unmodifiable(cleanTypes);
}

class SendNotificationCustomResult {
  final bool sent;
  final int? statusCode;
  final String? sendError;
  final String? notificationId;
  final Object? writeError;

  SendNotificationCustomResult({
    required this.sent,
    this.statusCode,
    this.sendError,
    this.notificationId,
    this.writeError,
  });

  bool get saved => notificationId != null;
}

/// Envía la notificación por HTTP y, si hay usuario, registra su copia en Firestore.
/// La instancia [firestore] determina explícitamente el proyecto y la base.
Future<SendNotificationCustomResult> sendNotificationCustom({
  required String url,
  required String title,
  required String body,
  required String type,
  String relatedId = '',
  FirebaseFirestore? firestore,
  String topic = 'all',
  String userId = '',
  Map<String, dynamic> extraData = const {},
  http.Client? client,
}) async {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null ||
      (uri.scheme != 'https' && uri.scheme != 'http') ||
      uri.host.isEmpty) {
    throw ArgumentError.value(url, 'url', 'Debe ser una URL HTTP válida');
  }
  if (title.trim().isEmpty || body.trim().isEmpty || topic.trim().isEmpty) {
    throw ArgumentError('title, body y topic son obligatorios');
  }
  if (!PizzacornNotificationsConfig.types.contains(type)) {
    throw ArgumentError.value(type, 'type', 'Tipo no configurado');
  }
  if (userId.trim().isNotEmpty && firestore == null) {
    throw ArgumentError('firestore es obligatorio cuando se proporciona userId');
  }

  final http.Client httpClient = client ?? http.Client();
  bool sent = false;
  int? statusCode;
  String? sendError;

  try {
    final http.Response response = await httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'topic': topic,
        'type': type,
        'relatedId': relatedId,
        'extraData': extraData,
      }),
    ).timeout(const Duration(seconds: 20));
    statusCode = response.statusCode;
    sent = response.statusCode >= 200 && response.statusCode < 300;
    if (!sent) {
      sendError = response.body;
    }
  } catch (error) {
    sendError = error.toString();
  } finally {
    if (client == null) {
      httpClient.close();
    }
  }

  String? notificationId;
  Object? writeError;
  if (userId.trim().isNotEmpty) {
    try {
      final DocumentReference<Map<String, dynamic>> reference =
          firestore!.collection('Notifications').doc();
      final NotificationCustomModel notificationModel = NotificationCustomModel(
        id: reference.id,
        userId: userId,
        title: title,
        body: body,
        type: type,
        relatedId: relatedId,
        extraData: extraData,
      );
      await reference.set(notificationModel.toJsonCreate());
      notificationId = reference.id;
    } catch (error) {
      writeError = error;
    }
  }

  return SendNotificationCustomResult(
    sent: sent,
    statusCode: statusCode,
    sendError: sendError,
    notificationId: notificationId,
    writeError: writeError,
  );
}
