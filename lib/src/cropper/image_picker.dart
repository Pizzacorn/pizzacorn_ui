import 'package:flutter/material.dart';
import 'package:pizzacorn_ui/src/cropper/pressed_image.dart';
import '../../pizzacorn_ui.dart';
import 'file_model.dart';

// OJO: aquí debes importar tu FileModel y la función pressedImage
// import 'package:TU_APP/models/file_model.dart';
// import 'pressed_image.dart'; // o donde la tengas

class ImagePublish extends StatefulWidget {
  final FileModel imageFile;
  final Function(FileModel) onFinish;
  final VoidCallback? onPressedDelete;

  final double width;
  final double height;
  final bool isCircular;
  final bool hasRadius;
  final BoxFit boxFit;

  final Color backgroundColor;
  final bool hasBorder;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadows;

  final double deleteButtonSize;
  final bool deleteButtonShadow;
  final bool deleteButtonHasBorder;
  final Color? deleteButtonBorderColor;
  final double deleteButtonBorderWidth;
  final Color? deleteButtonBackgroundColor;

  const ImagePublish({
    super.key,
    required this.imageFile,
    required this.onFinish,
    this.onPressedDelete,
    this.width = 100,
    this.height = 100,
    this.isCircular = false,
    this.hasRadius = true,
    this.boxFit = BoxFit.cover,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = true,
    this.borderColor,
    this.borderWidth = 1,
    this.boxShadows,
    this.deleteButtonSize = 40,
    this.deleteButtonShadow = true,
    this.deleteButtonHasBorder = true,
    this.deleteButtonBorderColor,
    this.deleteButtonBorderWidth = 1,
    this.deleteButtonBackgroundColor,
  });

  @override
  State<ImagePublish> createState() => _ImagePublishState();
}

class _ImagePublishState extends State<ImagePublish> {
  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor = widget.borderColor ?? COLOR_BORDER;
    final Color effectiveDeleteBorderColor =
        widget.deleteButtonBorderColor ?? COLOR_BORDER;
    final Color effectiveDeleteBackgroundColor =
        widget.deleteButtonBackgroundColor ?? COLOR_BACKGROUND;

    return Align(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Imagen
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: widget.hasRadius && !widget.isCircular
                    ? BorderRadius.circular(RADIUS)
                    : null,
                border: widget.hasBorder
                    ? Border.all(
                        color: effectiveBorderColor,
                        width: widget.borderWidth,
                      )
                    : null,
                boxShadow: widget.boxShadows,
                image: DecorationImage(
                  fit: widget.boxFit,
                  image: widget.imageFile.dataUint8List != null
                      ? MemoryImage(widget.imageFile.dataUint8List!)
                            as ImageProvider
                      : widget.imageFile.url.isEmpty
                      ? const AssetImage('assets/image/nada.png')
                      : NetworkImage(widget.imageFile.url),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: TextButton(
                style: styleTransparent(),
                onPressed: () {
                  onImagePressed(
                    context,
                    onFinish: widget.onFinish,
                    isCircular: widget.isCircular,
                    cropResolution: widget.width / widget.height,
                    width: widget.width,
                    height: widget.height,
                  );
                },
                child: Center(
                  child:
                      (widget.imageFile.url.isNotEmpty ||
                          widget.imageFile.dataUint8List != null)
                      ? const SizedBox.shrink()
                      : SvgCustom(
                          icon: 'anadir-imagen',
                          color: COLOR_ACCENT.withValues(alpha: 0.5),
                          size: 30,
                        ),
                ),
              ),
            ),

            // Botón de eliminación
            Positioned(
              top: 5,
              right: 5,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity:
                    (widget.imageFile.url.isNotEmpty ||
                        widget.imageFile.dataUint8List != null)
                    ? 1
                    : 0,
                child: Container(
                  width: widget.deleteButtonSize,
                  height: widget.deleteButtonSize,
                  decoration: BoxDecoration(
                    color: effectiveDeleteBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: widget.deleteButtonShadow
                        ? [BoxShadowCustom()]
                        : null,
                    border: widget.deleteButtonHasBorder
                        ? Border.all(
                            color: effectiveDeleteBorderColor,
                            width: widget.deleteButtonBorderWidth,
                          )
                        : null,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: widget.deleteButtonSize * 0.6,
                    icon: Icon(
                      Icons.clear,
                      size: widget.deleteButtonSize * 0.4,
                    ),
                    onPressed: () {
                      widget.onFinish(FileModel());
                      widget.onPressedDelete?.call();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
