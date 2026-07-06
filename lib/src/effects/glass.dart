import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../theme/config.dart';

class PizzacornGlassConfig {
  static bool loadingGlass = false;
  static Widget? loadingWidget;
}

/// Inicializa Liquid Glass y configura el loader global de Pizzacorn.
/// 🍕 Llamar desde main antes de runApp().
Future<void> InitializePizzacornGlass({
  Widget? loadingWidget,
  bool loadingGlass = true,
}) async {
  await LiquidGlassWidgets.initialize();
  ConfigurePizzacornLoading(
    loadingWidget: loadingWidget,
    loadingGlass: loadingGlass,
  );
}

/// Configura solo el loading global, útil si no quieres activar glass.
/// ✨ El widget se reutiliza como centro por defecto en Loading y LoadingCustom.
void ConfigurePizzacornLoading({Widget? loadingWidget, bool? loadingGlass}) {
  if (loadingWidget != null) {
    PizzacornGlassConfig.loadingWidget = loadingWidget;
  }
  if (loadingGlass != null) {
    PizzacornGlassConfig.loadingGlass = loadingGlass;
  }
}

class GlassContainerCustom extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double? visibility;
  final Color? glassColor;
  final double? thickness;
  final double? blur;
  final double? chromaticAberration;
  final double? lightAngle;
  final double? lightIntensity;
  final double? ambientStrength;
  final double? refractiveIndex;
  final double? saturation;
  final double? glowIntensity;
  final GlassSpecularSharpness? specularSharpness;
  final double? standardOpacityMultiplier;
  final double? width;
  final double? height;

  GlassContainerCustom({
    super.key,
    required this.child,
    this.radius = 0,
    this.padding = EdgeInsets.zero,
    this.visibility,
    this.glassColor,
    this.thickness,
    this.blur,
    this.chromaticAberration,
    this.lightAngle,
    this.lightIntensity,
    this.ambientStrength,
    this.refractiveIndex,
    this.saturation,
    this.glowIntensity,
    this.specularSharpness,
    this.standardOpacityMultiplier,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final LiquidGlassSettings defaultSettings = LiquidGlassSettings(
      blur: 5,
      thickness: 30,
      chromaticAberration: 1,
      saturation: 1,
      lightIntensity: 0,
      glowIntensity: 1,
      glassColor: COLOR_BACKGROUND.withValues(alpha: 0.50),
    );

    return GlassPanel(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      padding: padding,
      useOwnLayer: true,
      quality: GlassQuality.premium,
      shape: LiquidRoundedRectangle(borderRadius: radius, side: BorderSide()),
      settings: LiquidGlassSettings(
        visibility: visibility ?? defaultSettings.visibility,
        glassColor: glassColor ?? defaultSettings.glassColor,
        thickness: thickness ?? defaultSettings.thickness,
        blur: blur ?? defaultSettings.blur,
        chromaticAberration:
            chromaticAberration ?? defaultSettings.chromaticAberration,
        lightAngle: lightAngle ?? defaultSettings.lightAngle,
        lightIntensity: lightIntensity ?? defaultSettings.lightIntensity,
        ambientStrength: ambientStrength ?? defaultSettings.ambientStrength,
        refractiveIndex: refractiveIndex ?? defaultSettings.refractiveIndex,
        saturation: saturation ?? defaultSettings.saturation,
        glowIntensity: glowIntensity ?? defaultSettings.glowIntensity,
        specularSharpness:
            specularSharpness ?? defaultSettings.specularSharpness,
        standardOpacityMultiplier:
            standardOpacityMultiplier ??
            defaultSettings.standardOpacityMultiplier,
      ),
      child: child,
    );
  }
}
