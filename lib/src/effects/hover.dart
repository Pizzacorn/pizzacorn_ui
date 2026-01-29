import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Widget que reacciona al pasar el ratón, ideal para botones o tarjetas en Web.
class HoverCustom extends StatefulWidget {
  final Widget child;
  final double hoverTranslationY;
  final Duration duration;
  final Curve curve;

  HoverCustom({
    super.key,
    required this.child,
    this.hoverTranslationY = -5.0,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  @override
  HoverCustomState createState() => HoverCustomState();
}

class HoverCustomState extends State<HoverCustom> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        // Aplicamos una pequeña transformación o cambio de color reactivo
        transform: Matrix4.translationValues(
          0,
          isHovered ? widget.hoverTranslationY : 0,
          0,
        ),
        decoration: BoxDecoration(
          // Si quieres un ligero cambio de color al hacer hover:
          color: isHovered
              ? COLOR_ACCENT.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(RADIUS),
        ),
        child: widget.child,
      ),
    );
  }
}
