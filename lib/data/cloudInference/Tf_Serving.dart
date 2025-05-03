import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

class TfServing {
  TfServing({required this.url, required this.labelsPath}) {
    _init();
  }
  
  final String url;
  final String labelsPath;
  
  late Uri _url;
  late final List<String> labels;

  Future<void> _init() async {
    _loadLabels();
    _url =  Uri.parse(url);
  }

  List<List<List<int>>> imageToArray(image_lib.Image image) {
    List<List<List<int>>> imgArray = [];

    final decodedBytes = image.getBytes();
    for (int y = 0; y < image.height; y++) {
      imgArray.add([]);
      for (int x = 0; x < image.width; x++) {
        int red = decodedBytes[y * image.width * 3 + x * 3];
        int green = decodedBytes[y * image.width * 3 + x * 3 + 1];
        int blue = decodedBytes[y * image.width * 3 + x * 3 + 2];
        imgArray[y].add([red, green, blue]);
      }
    }
    return imgArray;
  }

  Future<Map> getResponseArray(image_lib.Image image) async {
    var imgArray = imageToArray(image);
    Map data = {
      "signature_name": "serving_default",
      "instances": [imgArray]
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(_url,
        headers: {"Content-Type": "application/json"}, body: body);
    Map prediction = json.decode(response.body);
    print(response.headers.values);
    return prediction;
  }

  Future<Map> getResponseBase64(image_lib.Image image) async {
    String base64Img = _imageToBase64(image);

    Map data = {
      "signature_name": "serving_bytes",
      "instances": [base64Img]
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(_url,
        headers: {"Content-Type": "application/json"}, body: body);

    Map prediction = json.decode(response.body);

    return prediction;
  }

  Future<List<MapEntry>> predict(image_lib.Image inputImage, int numTopPredictions) async {
    // resize original image to match model shape.
    image_lib.Image image = image_lib.copyResize(
      inputImage,
      width: 224,
      height: 224,
    );

    print(image.height);

    Map predictions = await getResponseArray(image);
    //Map predictions = await getResponse_base64(img_base64);

    List probabilities = predictions["predictions"][0];

    Map<String, double> labeledProbs = getProbabilities(probabilities);

    final topPredictions = getTopProbabilities(labeledProbs, numTopPredictions);

    return topPredictions;
  }

  Future<Map<String, double>> inference(image_lib.Image inputImage) async {
    // resize original image to match model shape.
    image_lib.Image image = image_lib.copyResize(
      inputImage,
      width: 224,
      height: 224,
    );

    print(image.height);

    Map predictions = await getResponseArray(image);
    //Map predictions = await getResponse_base64(img_base64);

    List probabilities = predictions["predictions"][0];

    Map<String, double> labeledProbs = getProbabilities(probabilities);

    return labeledProbs;
  }

  _imageToBase64(image_lib.Image image) {
    Uint8List bytes = image.getBytes();
    String base64Image = base64Url.encode(bytes);

    return base64Image;
  }

// Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Map<String, double> getProbabilities(List probabilties) {
    Map<String, double> labeledProbabilities = {};

    for (final pairs
        in IterableZip([labels.sublist(1, labels.length), probabilties])) {
      labeledProbabilities[pairs[0]] = pairs[1];
    }
    return labeledProbabilities;
  }

  static List<MapEntry<String, double>> getTopProbabilities(Map<String, double> labeledProb, int numTopPredictions) {
    var pq = PriorityQueue<MapEntry<String, double>>(compare);
    pq.addAll(labeledProb.entries);

    return pq.toList().sublist(0, numTopPredictions);
  }

  static int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
    if (e1.value > e2.value) {
      return -1;
    } else if (e1.value == e2.value) {
      return 0;
    } else {
      return 1;
    }
  }
}
