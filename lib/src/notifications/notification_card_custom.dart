import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

class NotificationTypeAppearance {
  final String? imageUrl;
  final IconData? icon;
  final Color? color;

  NotificationTypeAppearance({this.imageUrl, this.icon, this.color});
}

class NotificationCardCustom extends StatelessWidget {
  final NotificationCustomModel notificationModel;
  final NotificationTypeAppearance? appearance;
  final FutureOr<void> Function(NotificationCustomModel notificationModel)? onPressed;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  final TextStyle? dateStyle;
  final Color? backgroundSecondaryColor;
  final Color? unreadBackgroundColor;
  final Color? unreadIndicatorColor;
  final double? radius;
  final String Function(NotificationCustomModel notificationModel)? dateBuilder;

  NotificationCardCustom({
    super.key,
    required this.notificationModel,
    this.appearance,
    this.onPressed,
    this.titleStyle,
    this.bodyStyle,
    this.dateStyle,
    this.backgroundSecondaryColor,
    this.unreadBackgroundColor,
    this.unreadIndicatorColor,
    this.radius,
    this.dateBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = appearance?.color ?? COLOR_ACCENT;
    final String date = dateBuilder?.call(notificationModel) ??
        (notificationModel.createdAt == 0
            ? ''
            : DateFormat('HH:mm - dd/MM/yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(notificationModel.createdAt),
              ));

    return Material(
      color: notificationModel.isRead
          ? backgroundSecondaryColor ?? COLOR_BACKGROUND_SECONDARY
          : unreadBackgroundColor ?? accentColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(radius ?? RADIUS),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed == null
            ? null
            : () => onPressed!(notificationModel),
        child: Padding(
          padding: PADDING_ALL,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appearance?.imageUrl != null && appearance!.imageUrl!.isNotEmpty)
                ImageCustom(
                  imageUrl: appearance!.imageUrl!,
                  width: 38,
                  height: 38,
                  isCircular: true,
                )
              else
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    appearance?.icon ?? Icons.notifications_rounded,
                    size: 20,
                    color: accentColor,
                  ),
                ),
              Space(SPACE_MEDIUM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: titleStyle == null
                              ? TextSubtitle(
                                  notificationModel.title,
                                  fontWeight: FontWeight.bold,
                                  maxlines: 10,
                                )
                              : Text(
                                  notificationModel.title,
                                  style: titleStyle,
                                  maxLines: 10,
                                ),
                        ),
                        if (!notificationModel.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: unreadIndicatorColor ?? accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    Space(SPACE_SMALL),
                    bodyStyle == null
                        ? TextBody(notificationModel.body, maxlines: 10)
                        : Text(
                            notificationModel.body,
                            style: bodyStyle,
                            maxLines: 10,
                          ),
                    if (date.isNotEmpty) ...[
                      Space(SPACE_SMALL),
                      dateStyle == null
                          ? TextCaption(date, color: COLOR_SUBTEXT)
                          : Text(date, style: dateStyle),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
