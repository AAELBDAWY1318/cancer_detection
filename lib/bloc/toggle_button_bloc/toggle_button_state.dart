part of 'toggle_button_cubit.dart';

enum RadioButtonOption {
  local_inference,
  api_inference,
}

@immutable
class ToggleButtonState {
  ToggleButtonState({required this.option, required this.selected});
  RadioButtonOption option;
  List<bool> selected;

}

final class ToggleButtonInitial extends ToggleButtonState {
  ToggleButtonInitial({super.option = RadioButtonOption.local_inference, super.selected = const [true, false]});
}
