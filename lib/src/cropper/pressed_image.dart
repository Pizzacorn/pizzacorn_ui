import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'crop_page.dart';
import 'package:pizzacorn_ui/src/models/file_model.dart';

/// Abre el picker de imagen, opcionalmente recorta, y devuelve el resultado
/// mediante [onFinish].
///
/// - [needCrop]: si true, abre la pantalla de crop.
/// - [cropResolution]: relación ancho/alto del recorte (ej: 16/9).
/// - [galeria]: si true, abre galería; si false, cámara (depende de tu getImage()).
/// - [isCircular]: si true, el recorte será circular.
/// - [width]/[height]: tamaño objetivo del recorte (orientativo, para el cropper).
Future<void> onImagePressed(
  BuildContext context, {
  bool needCrop = true,
  double cropResolution = 16 / 9,
  bool galeria = true,
  bool isCircular = false,
  required Function(FileModel) onFinish,
  double width = 250,
  double height = 250,
}) async {
  // getImage() debería devolver un FileModel con al menos:
  // - Uint8List? dataUint8List
  // - String url
  final FileModel value = await getImage(galeria: galeria);

  if (value.dataUint8List != null && value.dataUint8List!.isNotEmpty) {
    if (needCrop) {
      // Navegamos a la pantalla de crop
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CropPage(
            filemodel: value,
            resolution: isCircular ? 1 : cropResolution,
            isCircular: isCircular,
            width: width,
            height: height,
            onFinish: (Uint8List bytes, String path) {
              // Devolvemos el resultado al callback
              onFinish(FileModel(dataUint8List: bytes, url: path));
              // Cerramos la pantalla de crop
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else {
      // Sin crop: devolvemos directamente la imagen cargada
      onFinish(FileModel(dataUint8List: value.dataUint8List, url: value.url));
      // Cerramos el contenedor desde el que se llamó (ej: bottomSheet)
      Navigator.of(context).pop();
    }
  }
}

Future<FileModel> getImage({bool galeria = true}) async {
  final picker = ImagePicker();
  FileModel fileModal = FileModel(dataUint8List: Uint8List(0));

  final pickedFile = await picker.pickImage(
    source: galeria ? ImageSource.gallery : ImageSource.camera,
  );

  if (pickedFile != null) {
    fileModal = FileModel(dataUint8List: await pickedFile.readAsBytes());
  }

  return fileModal;
}
