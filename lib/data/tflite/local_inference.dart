import 'dart:io';
import 'image_classification_helper.dart';
import 'package:image/image.dart' as image_lib;

class LocalInferenceModel {
  late ImageClassificationHelper imageClassificationHelper;

  init() async {
    imageClassificationHelper = ImageClassificationHelper();
    await imageClassificationHelper.initHelper();
  }

Future<Map<String, double>> inference(File image) async {

  final imageData = image.readAsBytesSync();

  // Decode image using package:image/image.dart (https://pub.dev/image)
  image_lib.Image? img = image_lib.decodeImage(imageData);

  Map<String, double>? classification = await imageClassificationHelper.inferenceImage(img!);
  print(classification.toString());
  return classification;
}
}