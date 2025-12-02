import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

/// ShowUpAnimationCustom
///
/// Wrapper sencillo alrededor de [ShowUpAnimation] para animar widgets
/// apareciendo con un delay según orden.
///
/// - [order]: multiplica el delay por 100ms → 0 = sin delay, 1 = 100ms, 2 = 200ms...
/// - [duration]: duración de la animación en ms.
/// - [child]: widget a animar.
class ShowUpCustom extends StatelessWidget {
  final Widget child;
  final int order;
  final int duration;

  const ShowUpCustom({
    super.key,
    required this.child,
    this.order = 0,
    this.duration = 300,
  });

  @override
  Widget build(BuildContext context) {
    return ShowUpAnimation(
      delayStart: Duration(milliseconds: order * 100),
      animationDuration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
      direction: Direction.vertical,
      offset: 0.5,
      child: child,
    );
  }
}
