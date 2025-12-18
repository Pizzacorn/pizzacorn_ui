import 'package:flutter/material.dart';

import '../../pizzacorn_ui.dart';


class IconPickerCustom extends StatelessWidget {
  /// CodePoint del icono seleccionado (MaterialIcons). 0 = ninguno.
  final int selectedCodePoint;

  /// Callback al seleccionar un icono (devuelve codePoint).
  /// Si es null, el grid queda solo visual (sin interacción).
  final Function(int)? onSelected;

  /// Lista de iconos (si viene vacía, usa una lista curada por defecto).
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
    this.selectedCodePoint = 0,
    this.onSelected,
    this.icons = const [],
    this.crossAxisCount = 12,
    this.height = 260,
    this.accentColor = Colors.blueAccent,
    this.iconSize = 18,
    this.space = SPACE_SMALL,
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
    for (int i = 0; i < iconList.length; i++) {
      finalIcons.add(iconList[i]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPreview) buildPreview(),
        if (showPreview) Space(SPACE_MEDIUM),

        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
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
              final int codePoint = isNoneTile ? 0 : iconData.codePoint;

              final bool selected = selectedCodePoint == codePoint;

              return InkWell(
                onTap: onSelected == null
                    ? null
                    : () {
                  onSelected!(codePoint);
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
                      isNoneTile ? noneIcon : iconData,
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

        if (showClear) Space(SPACE_MEDIUM),
        if (showClear)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSelected == null
                  ? null
                  : () {
                onSelected!(0);
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
              color: selectedCodePoint == 0
                  ? Colors.white.withOpacity(0.08)
                  : accentColor.withOpacity(0.7),
              width: 1,
            ),
          ),
          child: Center(
            child: selectedCodePoint == 0
                ? Icon(noneIcon, size: 20)
                : Icon(
              IconData(
                selectedCodePoint,
                fontFamily: "MaterialIcons",
              ),
              color: accentColor,
              size: 22,
            ),
          ),
        ),
        Space(SPACE_MEDIUM),
        Expanded(
          child: TextBody(
            selectedCodePoint == 0 ? "Selecciona un icono" : "Icono seleccionado",
          ),
        ),
      ],
    );
  }

  /// Lista curada (la puedes ampliar cuando quieras)
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
