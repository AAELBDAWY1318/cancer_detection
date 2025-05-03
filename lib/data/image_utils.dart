import 'dart:io';
import 'package:image/image.dart' as image_lib;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageUtils {
  static Future<File> cropImageFile(File file, [int? side]) async {
    final image = await image_lib.decodeImageFile(file.path);
    if (image == null) throw Exception('Unable to decode image');
    int crop_size = 350;
    double aspect_ratio = image.width / image.height;
    int x = (image.width / 2 - crop_size / 2).toInt();
    int y = (image.height / 2 - aspect_ratio * crop_size / 2).toInt();

    final croppedImage = image_lib.copyCrop(image,
        x: x, y: y, width: crop_size, height: crop_size);
    final croppedFile = await _convertImageToFile(croppedImage, file.path);
    return croppedFile;
  }

  static Future<File> _convertImageToFile(
      image_lib.Image image, String path) async {
    final newPath = await _croppedFilePath(path);
    final jpegBytes = image_lib.encodeJpg(image);

    final convertedFile = await File(newPath).writeAsBytes(jpegBytes);
    await File(path).delete();
    return convertedFile;
  }

  static Future<String> _croppedFilePath(String path) async {
    final tempDir = await getTemporaryDirectory();
    return join(
      tempDir.path,
      '${basenameWithoutExtension(path)}_compressed.jpg',
    );
  }
}
