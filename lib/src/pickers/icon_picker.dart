import 'package:flutter/material.dart';
import '../../pizzacorn_ui.dart';

class IconPickerCustom extends StatelessWidget {
  /// El IconData seleccionado. Null = ninguno.
  final IconData? selectedIcon;

  /// Callback al seleccionar un icono.
  final Function(IconData?)? onSelected;

  /// Lista de iconos.
  final List<IconData> icons;

  /// Config grid
  final int crossAxisCount;
  final double height;

  /// Estilo
  final Color accentColor;
  final double iconSize;
  final double space;

  /// UI opcional
  final bool showPreview;
  final bool showClear;
  final bool showNoneTile;
  final IconData noneIcon;

  IconPickerCustom({
    super.key,
    this.selectedIcon,
    this.onSelected,
    this.icons = const [],
    this.crossAxisCount = 12,
    this.height = 260,
    this.accentColor = Colors.blueAccent,
    this.iconSize = 18,
    this.space = 10, // Usando valor directo o token
    this.showPreview = true,
    this.showClear = true,
    this.showNoneTile = true,
    this.noneIcon = Icons.help_outline,
  });

  @override
  Widget build(BuildContext context) {
    final List<IconData> iconList = icons.isEmpty ? getDefaultIcons() : icons;

    final List<IconData> finalIcons = <IconData>[];
    if (showNoneTile) {
      finalIcons.add(noneIcon);
    }

    // REGLA: Bucle con índice (Prohibido for-in)
    for (int i = 0; i < iconList.length; i++) {
      finalIcons.add(iconList[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPreview) buildPreview(),
        if (showPreview) Space(PADDING_SIZE),

        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(RADIUS),
            border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
          ),
          child: GridView.builder(
            padding: EdgeInsets.all(space),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: space,
              mainAxisSpacing: space,
            ),
            itemCount: finalIcons.length,
            itemBuilder: (context, index) {
              final IconData iconData = finalIcons[index];
              final bool isNoneTile = showNoneTile && index == 0;

              // Comparamos los IconData directamente
              final bool selected =
                  selectedIcon == (isNoneTile ? null : iconData);

              return InkWell(
                onTap: onSelected == null
                    ? null
                    : () {
                        onSelected!(isNoneTile ? null : iconData);
                      },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? accentColor.withOpacity(0.12)
                        : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? accentColor.withOpacity(0.85)
                          : Colors.white.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      size: iconSize,
                      color: selected
                          ? accentColor
                          : Colors.white.withOpacity(0.75),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (showClear) Space(PADDING_SIZE),
        if (showClear)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSelected == null
                  ? null
                  : () {
                      onSelected!(null);
                    },
              child: TextCaption("Quitar icono"),
            ),
          ),
      ],
    );
  }

  Widget buildPreview() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedIcon == null
                  ? COLOR_SUBTEXT.withOpacity(0.08)
                  : accentColor.withOpacity(0.7),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              selectedIcon ?? noneIcon,
              color: selectedIcon == null ? COLOR_SUBTEXT : accentColor,
              size: 22,
            ),
          ),
        ),
        Space(PADDING_SIZE),
        Expanded(
          child: TextBody(
            selectedIcon == null ? "Selecciona un icono" : "Icono seleccionado",
          ),
        ),
      ],
    );
  }

  List<IconData> getDefaultIcons() {
    return <IconData>[
      Icons.person,
      Icons.people,
      Icons.badge,
      Icons.email,
      Icons.phone,
      Icons.home,
      Icons.settings,
      Icons.tune,
      Icons.security,
      Icons.lock,
      Icons.public,
      Icons.language,
      Icons.shopping_cart,
      Icons.store,
      Icons.payments,
      Icons.credit_card,
      Icons.receipt_long,
      Icons.calendar_month,
      Icons.schedule,
      Icons.event,
      Icons.list,
      Icons.view_list,
      Icons.table_chart,
      Icons.analytics,
      Icons.bar_chart,
      Icons.pie_chart,
      Icons.description,
      Icons.article,
      Icons.folder,
      Icons.folder_open,
      Icons.cloud,
      Icons.cloud_done,
      Icons.upload,
      Icons.download,
      Icons.image,
      Icons.photo,
      Icons.camera_alt,
      Icons.video_library,
      Icons.chat,
      Icons.forum,
      Icons.notifications,
      Icons.campaign,
      Icons.star,
      Icons.favorite,
      Icons.thumb_up,
      Icons.flag,
      Icons.map,
      Icons.place,
      Icons.navigation,
      Icons.link,
      Icons.share,
      Icons.qr_code,
      Icons.qr_code_scanner,
      Icons.search,
      Icons.filter_alt,
      Icons.sort,
      Icons.edit,
      Icons.delete,
      Icons.add,
      Icons.remove,
      Icons.check,
      Icons.close,
      Icons.info,
      Icons.help,
    ];
  }
}
