import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

void main() {
  testWidgets('muestra el tipo y entrega el modelo al pulsar', (tester) async {
    final NotificationCustomModel notificationModel = NotificationCustomModel(
      id: 'notification-1',
      title: 'Invitación',
      body: 'Tienes una invitación',
      type: 'invitation',
      relatedId: 'pena-1',
      createdAt: DateTime(2026, 10, 8).millisecondsSinceEpoch,
    );
    NotificationCustomModel? pressedModel;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCardCustom(
            notificationModel: notificationModel,
            appearance: NotificationTypeAppearance(
              icon: Icons.person_add,
              color: Colors.blue,
            ),
            titleStyle: TextStyle(fontSize: 19),
            bodyStyle: TextStyle(fontSize: 14),
            dateStyle: TextStyle(fontSize: 11),
            backgroundSecondaryColor: Colors.white,
            radius: 18,
            onPressed: (value) => pressedModel = value,
          ),
        ),
      ),
    );

    expect(find.text('Invitación'), findsOneWidget);
    expect(find.text('Tienes una invitación'), findsOneWidget);
    expect(find.byIcon(Icons.person_add), findsOneWidget);
    await tester.tap(find.text('Invitación'));
    expect(pressedModel, same(notificationModel));
  });
}
