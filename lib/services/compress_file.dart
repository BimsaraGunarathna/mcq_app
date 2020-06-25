import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

// 2. compress file and get file.
Future<File> compressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    targetPath,
    quality: 88,
    rotate: 180,
    format: CompressFormat.png
  );

  print(file.lengthSync());
  print(result.lengthSync());

  return result;
}
