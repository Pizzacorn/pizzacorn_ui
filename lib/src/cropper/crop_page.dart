import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pizzacorn_ui/src/models/file_model.dart';
import '../../pizzacorn_ui.dart';

class CropPage extends StatefulWidget {
  final FileModel filemodel;
  final double resolution;
  final double width;
  final double height;
  final bool isCircular;
  final String appBarTitle;
  final String saveButtonTitle;
  final Function(Uint8List, String) onFinish;

  const CropPage({
    super.key,
    required this.filemodel,
    required this.onFinish,
    this.resolution = 1,
    this.isCircular = false,
    this.appBarTitle = "Recortar imagen",
    this.saveButtonTitle = "Guardar cambios",
    required this.width,
    required this.height,
  });

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  bool loading = false;
  final CropController controllerCrop = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBarBack(context: context, title: widget.appBarTitle),
      body: Loading(
        loading: loading,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Crop(
              image: widget.filemodel.dataUint8List!,
              controller: controllerCrop,
              onCropped: (result) {
                switch (result) {
                  case CropSuccess(:final croppedImage):
                    finishCrop(croppedImage);
                  case CropFailure(:final cause):
                    debugPrint("·🔴 Error al recortar: $cause");
                }
              },

              // Relación de aspecto (si quieres usar la resolución que pasas)
              aspectRatio: widget.resolution,

              // Estilos
              maskColor: COLOR_BACKGROUND.withValues(alpha: 0.8),
              withCircleUi: widget.isCircular,
              baseColor: COLOR_BACKGROUND_SECONDARY,
              radius: 0,
              progressIndicator: const CircularProgressIndicator(),

              willUpdateScale: (newScale) => newScale < 5,

              // No queremos puntos en las esquinas
              cornerDotBuilder: (size, edgeAlignment) =>
                  const SizedBox.shrink(),

              clipBehavior: Clip.none,
              interactive: true,
              fixCropRect: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSheetCustomOneButton(
        title: widget.saveButtonTitle,
        onPressed: () {
          setState(() => loading = true);
          controllerCrop.crop();
        },
      ),
    );
  }

  Future<void> finishCrop(Uint8List croppedData) async {
    setState(() => loading = true);

    // PATH
    final String pathFile = DateTime.now().millisecondsSinceEpoch.toString();

    // Directorio local
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$pathFile.png');
    await file.writeAsBytes(croppedData);

    final String path = file.path;

    setState(() => loading = false);

    widget.onFinish(croppedData, path);
  }
}
