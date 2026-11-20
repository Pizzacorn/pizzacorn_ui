import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';

/// Destino identificado por un valor estable que controla la aplicación.
class AdaptiveNavigationDestination<T extends Object> {
  final T value;
  final String label;
  final IconData? icon;
  final String? iconAsset;
  final bool enabled;
  final bool hasNotification;
  final int notificationCount;
  final String? notificationLabel;

  const AdaptiveNavigationDestination({
    required this.value,
    required this.label,
    this.icon,
    this.iconAsset,
    this.enabled = true,
    this.hasNotification = false,
    this.notificationCount = 0,
    this.notificationLabel,
  }) : assert((icon != null) != (iconAsset != null)),
       assert(notificationCount >= 0);
}

/// Acción independiente de la selección de destino.
class AdaptiveNavigationAction {
  final String label;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback? onPressed;

  const AdaptiveNavigationAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconAsset,
  }) : assert((icon != null) != (iconAsset != null));
}

/// Conserva el cuerpo al cambiar entre la barra inferior y la lateral.
class AdaptiveNavigationScaffold<T extends Object> extends StatelessWidget {
  final List<AdaptiveNavigationDestination<T>> destinations;
  final T? selectedValue;
  final ValueChanged<T> onDestinationSelected;
  final AdaptiveNavigationAction? primaryAction;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final double breakpoint;
  final double sidebarWidth;
  final Color? navigationColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? notificationColor;
  final Color? backgroundColor;

  AdaptiveNavigationScaffold({
    super.key,
    required this.destinations,
    required this.selectedValue,
    required this.onDestinationSelected,
    required this.body,
    this.primaryAction,
    this.appBar,
    this.breakpoint = 720,
    this.sidebarWidth = 208,
    this.navigationColor,
    this.activeColor,
    this.inactiveColor,
    this.notificationColor,
    this.backgroundColor,
  }) : assert(breakpoint > 0 && breakpoint.isFinite),
       assert(sidebarWidth > 0 && sidebarWidth.isFinite),
       assert(destinations.map((destination) => destination.value).toSet().length ==
           destinations.length);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final bool wide = width >= breakpoint;
        final bool hasNavigation = destinations.isNotEmpty || primaryAction != null;
        final double railWidth = min(sidebarWidth, width / 2);
        final menu = hasNavigation
            ? AdaptiveNavigationMenu<T>(
                destinations: destinations,
                selectedValue: selectedValue,
                onDestinationSelected: onDestinationSelected,
                primaryAction: primaryAction,
                wide: wide,
                availableWidth: wide ? railWidth : width,
                protectTop: appBar == null,
                color: navigationColor ?? COLOR_BACKGROUND,
                activeColor: activeColor ?? COLOR_ACCENT,
                inactiveColor: inactiveColor ?? COLOR_TEXT,
                notificationColor: notificationColor ?? COLOR_ERROR,
              )
            : null;

        return Scaffold(
          appBar: appBar,
          backgroundColor: backgroundColor ?? COLOR_BACKGROUND,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: wide && hasNavigation ? railWidth : 0,
                child: wide ? menu : null,
              ),
              Expanded(child: body),
            ],
          ),
          bottomNavigationBar: wide ? null : menu,
        );
      },
    );
  }
}

class AdaptiveNavigationMenu<T extends Object> extends StatefulWidget {
  final List<AdaptiveNavigationDestination<T>> destinations;
  final T? selectedValue;
  final ValueChanged<T> onDestinationSelected;
  final AdaptiveNavigationAction? primaryAction;
  final bool wide;
  final double availableWidth;
  final bool protectTop;
  final Color color;
  final Color activeColor;
  final Color inactiveColor;
  final Color notificationColor;

  AdaptiveNavigationMenu({
    super.key,
    required this.destinations,
    required this.selectedValue,
    required this.onDestinationSelected,
    required this.primaryAction,
    required this.wide,
    required this.availableWidth,
    required this.protectTop,
    required this.color,
    required this.activeColor,
    required this.inactiveColor,
    required this.notificationColor,
  });

  @override
  State<AdaptiveNavigationMenu<T>> createState() => AdaptiveNavigationMenuState<T>();
}

class AdaptiveNavigationMenuState<T extends Object> extends State<AdaptiveNavigationMenu<T>> {
  final destinationKeys = <T, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    revealSelection();
  }

  @override
  void didUpdateWidget(covariant AdaptiveNavigationMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final values = widget.destinations.map((destination) => destination.value).toSet();
    destinationKeys.removeWhere((value, key) => !values.contains(value));
    if (oldWidget.selectedValue != widget.selectedValue ||
        oldWidget.availableWidth != widget.availableWidth ||
        oldWidget.destinations.length != widget.destinations.length ||
        (oldWidget.primaryAction == null) != (widget.primaryAction == null)) {
      revealSelection();
    }
  }

  void revealSelection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? itemContext =
          mounted ? destinationKeys[widget.selectedValue]?.currentContext : null;
      if (itemContext != null) {
        Scrollable.ensureVisible(
          itemContext,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (int i = 0; i < widget.destinations.length; i++) {
      final destination = widget.destinations[i];
      final bool selected = destination.value == widget.selectedValue;
      items.add(AdaptiveNavigationItem(
        key: destinationKeys.putIfAbsent(destination.value, GlobalKey.new),
        label: destination.label,
        icon: destination.icon,
        iconAsset: destination.iconAsset,
        onPressed: destination.enabled
            ? () => widget.onDestinationSelected(destination.value)
            : null,
        selected: selected,
        wide: widget.wide,
        foreground: selected ? widget.activeColor : widget.inactiveColor,
        accent: widget.activeColor,
        notificationColor: widget.notificationColor,
        hasNotification: destination.hasNotification,
        notificationCount: destination.notificationCount,
        notificationLabel: destination.notificationLabel,
      ));
    }

    final action = widget.primaryAction;
    if (action != null) {
      items.insert(
        widget.wide ? 0 : items.length ~/ 2,
        AdaptiveNavigationItem(
          label: action.label,
          icon: action.icon,
          iconAsset: action.iconAsset,
          onPressed: action.onPressed,
          wide: widget.wide,
          foreground: COLOR_TEXT_BUTTONS,
          accent: widget.activeColor,
          notificationColor: widget.notificationColor,
          primary: true,
        ),
      );
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          border: widget.wide
              ? BorderDirectional(end: BorderSide(color: COLOR_BORDER))
              : Border(top: BorderSide(color: COLOR_BORDER)),
        ),
        child: SafeArea(
          top: widget.wide && widget.protectTop,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = widget.wide
                  ? constraints.maxWidth
                  : max(64, constraints.maxWidth / items.length);
              return SingleChildScrollView(
                primary: false,
                scrollDirection: widget.wide ? Axis.vertical : Axis.horizontal,
                padding: widget.wide ? PADDING_ALL_SMALL : EdgeInsets.zero,
                child: Flex(
                  direction: widget.wide ? Axis.vertical : Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    items.length,
                    (index) => SizedBox(
                      width: widget.wide ? double.infinity : itemWidth,
                      child: items[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AdaptiveNavigationItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback? onPressed;
  final bool? selected;
  final bool wide;
  final Color foreground;
  final Color accent;
  final Color notificationColor;
  final bool primary;
  final bool hasNotification;
  final int notificationCount;
  final String? notificationLabel;

  AdaptiveNavigationItem({
    super.key,
    required this.label,
    required this.icon,
    required this.iconAsset,
    required this.onPressed,
    required this.wide,
    required this.foreground,
    required this.accent,
    required this.notificationColor,
    this.selected,
    this.primary = false,
    this.hasNotification = false,
    this.notificationCount = 0,
    this.notificationLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final bool showBadge = hasNotification || notificationCount > 0;
    final Color textColor = enabled ? foreground : COLOR_SUBTEXT;
    final color = primary
        ? enabled ? accent : COLOR_BACKGROUND_BLOCKED
        : selected == true ? accent.withValues(alpha: 0.10) : Colors.transparent;
    final radius = BorderRadius.circular(RADIUS);
    final iconWidget = icon == null
        ? SvgCustom(fullIcon: iconAsset!, size: 22, color: textColor)
        : Icon(icon, size: 22, color: textColor);
    final contentIcon = showBadge
        ? Badge(
            backgroundColor: notificationColor,
            textColor: COLOR_TEXT_BUTTONS,
            label: notificationCount > 0
                ? Text(notificationCount > 99 ? '99+' : '$notificationCount')
                : null,
            child: iconWidget,
          )
        : iconWidget;
    final labelWidget = TextSmall(
      label,
      color: textColor,
      textAlign: wide ? TextAlign.start : TextAlign.center,
      fontWeight: selected == true || primary ? WEIGHT_BOLD : WEIGHT_NORMAL,
      maxlines: 2,
    );
    final String? status = showBadge
        ? notificationLabel ??
            (notificationCount > 0 ? 'Notificaciones: $notificationCount' : 'Nueva notificación')
        : null;

    return Padding(
      padding: EdgeInsets.all(SPACE_SMALLEST),
      child: Semantics(
        button: true,
        enabled: enabled,
        selected: selected,
        label: label,
        value: status,
        child: Material(
          color: color,
          borderRadius: radius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            focusColor: (primary ? COLOR_TEXT_BUTTONS : accent).withValues(alpha: 0.24),
            child: ExcludeSemantics(
              child: Container(
                constraints: BoxConstraints(minHeight: wide ? 48 : 60),
                padding: PADDING_ALL_SMALL,
                child: wide
                    ? Row(children: [contentIcon, Space(SPACE_SMALL), Expanded(child: labelWidget)])
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [contentIcon, Space(SPACE_SMALLEST), labelWidget],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
