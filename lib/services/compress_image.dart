//https://github.com/brendan-duncan/image/wiki/Examples
import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class DecodeParam {
  final File file;
  final SendPort sendPort;
  DecodeParam(this.file, this.sendPort);
}

Future<String> get _temporyDirectoryPath async {
  Directory _tempDir = await getTemporaryDirectory();

  return _tempDir.path;
}

void decode(DecodeParam param) {
  // Read an image from file (webp in this case).
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  Image image = decodeImage(param.file.readAsBytesSync());
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  print('IMAGE WIDTH : ${image.width} AND IMAGE HIEGHT : ${image.height}');
  Image thumbnail = copyResize(image, width: image.width >= 1080 ? 1080 : image.width);
  param.sendPort.send(thumbnail);
}

// Decode and process an image file in a separate thread (isolate) to avoid
// stalling the main UI thread.
Future <String> compressImage(String filePath) async {

  ReceivePort receivePort = ReceivePort();

  //Get the tempory directory.
  String tempDirectoryPath = await _temporyDirectoryPath;
  print('Tem Directory Path: ' +tempDirectoryPath);

  await Isolate.spawn(decode,DecodeParam(File(filePath), receivePort.sendPort));

  // Get the processed image from the isolate.
  Image image = await receivePort.first;

  //Generating File Name
  String fileName = filePath.split("/").last;

  //new file path
  //String toBeConvertedImagePath = '/storage/emulated/0/gn-now/' + fileName;
  String toBeConvertedImagePath = '$tempDirectoryPath/'+ fileName;
  print("TO BE CONVERTED : " + toBeConvertedImagePath);

  File(toBeConvertedImagePath).writeAsBytesSync(encodeJpg(image, quality: 95));
  //  /document/primary:Android/data/com.example.gn_v3/files/Pictures/
  //  /document/primary:Android/data/com.example.gn_v3/files/converted_pictures/
  return toBeConvertedImagePath;
}
