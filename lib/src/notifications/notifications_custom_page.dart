import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class NotificationsCustomPage extends ConsumerWidget {
  final String userId;
  final String? databaseName;
  final String title;
  final bool showAppBar;
  final Map<String, NotificationTypeAppearance> typeAppearances;
  final FutureOr<void> Function(NotificationCustomModel notificationModel)? onPressed;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  final TextStyle? dateStyle;
  final Color? backgroundColor;
  final Color? backgroundSecondaryColor;
  final Color? unreadBackgroundColor;
  final Color? unreadIndicatorColor;
  final double? radius;
  final String emptyText;
  final String Function(NotificationCustomModel notificationModel)? dateBuilder;

  NotificationsCustomPage({
    super.key,
    required this.userId,
    this.databaseName,
    this.title = 'Notificaciones',
    this.showAppBar = true,
    this.typeAppearances = const {},
    this.onPressed,
    this.titleStyle,
    this.bodyStyle,
    this.dateStyle,
    this.backgroundColor,
    this.backgroundSecondaryColor,
    this.unreadBackgroundColor,
    this.unreadIndicatorColor,
    this.radius,
    this.emptyText = 'No tienes notificaciones por ahora',
    this.dateBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (userId.trim().isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'Debe indicar un usuario');
    }
    final PaginationParams<NotificationCustomModel> params =
        PaginationParams<NotificationCustomModel>(
      collection: 'Notifications',
      databaseName: databaseName,
      identifier: 'notifications:$userId',
      fromJson: (data) => NotificationCustomModel.fromJson(data),
      query: (query) => query
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true),
    );

    final Widget body = CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () => ref.read(paginationProvider(params).notifier).refresh(),
        ),
        SliverPadding(
          padding: PADDING_ALL,
          sliver: SliverListCustom<NotificationCustomModel>(
            params: params,
            itemPlaceholder: NotificationCustomModel(),
            emptyWidget: Padding(
              padding: PADDING_ALL,
              child: Center(child: TextBody(emptyText, color: COLOR_SUBTEXT)),
            ),
            itemBuilder: (notificationModel) => NotificationCardCustom(
              notificationModel: notificationModel,
              appearance: typeAppearances[notificationModel.type],
              onPressed: onPressed,
              titleStyle: titleStyle,
              bodyStyle: bodyStyle,
              dateStyle: dateStyle,
              backgroundSecondaryColor: backgroundSecondaryColor,
              unreadBackgroundColor: unreadBackgroundColor,
              unreadIndicatorColor: unreadIndicatorColor,
              radius: radius,
              dateBuilder: dateBuilder,
            ),
          ),
        ),
      ],
    );

    if (!showAppBar) {
      return ColoredBox(
        color: backgroundColor ?? COLOR_BACKGROUND,
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? COLOR_BACKGROUND,
      appBar: AppBarBack(
        context: context,
        title: title,
        color: backgroundSecondaryColor ?? COLOR_BACKGROUND_SECONDARY,
      ),
      body: body,
    );
  }
}
