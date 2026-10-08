import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  test('configura tipos y envía los datos de navegación a la Cloud Function', () async {
    ConfigurePizzacornNotifications(types: ['post']);
    late Map<String, dynamic> payload;
    final MockClient client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.headers['content-type'], 'application/json');
      payload = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response('{"success":true}', 200);
    });

    final SendNotificationCustomResult result = await sendNotificationCustom(
      url: 'https://example.com/sendNotification',
      title: 'Nuevo mensaje',
      body: 'Abre la publicación',
      type: 'post',
      relatedId: 'post-1',
      client: client,
    );

    expect(result.sent, isTrue);
    expect(result.saved, isFalse);
    expect(payload['type'], 'post');
    expect(payload['relatedId'], 'post-1');
    expect(payload['topic'], 'all');
    client.close();
  });

  test('conserva el esquema de NotificationCustomModel', () {
    final NotificationCustomModel notificationModel = NotificationCustomModel(
      id: 'notification-1',
      userId: 'user-1',
      type: 'post',
      relatedId: 'post-1',
      extraData: {'source': 'test'},
    );

    final Map<String, dynamic> created = notificationModel.toJsonCreate();
    expect(created['createdAt'], greaterThan(0));
    expect(created['updatedAt'], greaterThan(0));
    expect(created['isRead'], isFalse);
    expect(NotificationCustomModel.fromJson(created).type, 'post');
    expect(notificationModel.toJsonUpdate().containsKey('createdAt'), isFalse);
    expect(notificationModel.toJsonUpdate().containsKey('id'), isFalse);
  });
}
