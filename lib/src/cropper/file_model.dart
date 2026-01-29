// lib/src/cropper/file_model.dart

import 'dart:typed_data';

/// Modelo simple de archivo usado en el cropper / picker de imágenes.
///
/// - [url]: ruta remota o local (path) del archivo.
/// - [dataUint8List]: bytes en memoria (por ejemplo, al seleccionar una imagen).
class FileModel {
  FileModel({this.url = "", this.dataUint8List});

  String url;
  Uint8List? dataUint8List;
}
