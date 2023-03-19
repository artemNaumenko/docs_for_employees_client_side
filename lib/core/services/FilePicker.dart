import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:tuple/tuple.dart';

class FilePickerServices{
  static Future<Tuple2<String, Uint8List>?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      Tuple2<String, Uint8List> tuple = Tuple2(fileName, fileBytes);

      return tuple;
    }
    return null;
  }
}