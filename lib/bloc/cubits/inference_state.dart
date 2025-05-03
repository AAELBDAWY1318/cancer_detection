part of 'inference_cubit.dart';

enum InferenceStatus {inital, loading, error, success}

@immutable
sealed class InferenceState {
}

final class InferenceInitial extends InferenceState {
  InferenceInitial();
}

class InferenceSuccess extends InferenceState {
  String lesionName;
  File image;
  String probabilty;
  bool isMalignant;



  InferenceSuccess({required this.lesionName, required this.image, required this.isMalignant, required this.probabilty});
}

class InferenceLoading extends InferenceState {

}

class InferenceError extends InferenceState {
  InferenceError({required this.error});

  String error;
}