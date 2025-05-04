import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:first_app/data/cloudInference/Tf_Serving.dart';
import 'package:image/image.dart' as image_lib;

import '../../data/result_processing.dart';
import '../../data/tflite/local_inference.dart';
part 'inference_state.dart';

class InferenceCubit extends Cubit<InferenceState> {
  InferenceCubit({required this.localInferenceModel, required this.tfServing})
      : super(InferenceInitial());

  final LocalInferenceModel localInferenceModel;
  final TfServing tfServing;

  (bool, String, String) processInferenceData(predictions) {
    var topPrediction = TfServing.getTopProbabilities(predictions, 1);
    String lesionType = topPrediction.first.key;
    String lesionName = ResultProcessing.getLesionName(lesionType);
    bool isBenign = ResultProcessing.getBenign(lesionType);
    print("##################### ${topPrediction.first.value}");
    String probabilty =
        (topPrediction.first.value * 100).toString().substring(0, 4);
    return (isBenign, probabilty, lesionName);
  }

  inference_local(File image) async {
    try {
      emit(InferenceLoading());
      var predictions = await localInferenceModel.inference(image);
      log("##################### ${predictions.values}");
      bool isMalignant;
      String probabilty;
      String lesionName;
      (isMalignant, probabilty, lesionName) = processInferenceData(predictions);

      emit(InferenceSuccess(
          lesionName: lesionName,
          image: image,
          isMalignant: isMalignant,
          probabilty: probabilty));
    } catch (e) {
      emit(InferenceError(error: "Error loading users: ${e.toString()}"));
    }
  }

  inference_api(File imageFile) async {
    try {
      emit(InferenceLoading());
      image_lib.Image image = image_lib.decodeJpg(imageFile.readAsBytesSync())!;
      var predictions = await tfServing.inference(image);
      bool isMalignant;
      String probability;
      String lesionName;
      (isMalignant, probability, lesionName) =
          processInferenceData(predictions);

      emit(InferenceSuccess(
          lesionName: lesionName,
          image: imageFile,
          isMalignant: isMalignant,
          probabilty: probability));
    } catch (e) {
      emit(InferenceError(error: "Error loading users: ${e.toString()}"));
    }
  }

  reset_state() {
    emit(InferenceInitial());
  }
}
