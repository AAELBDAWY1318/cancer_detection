import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'toggle_button_state.dart';



class ToggleButtonCubit extends Cubit<ToggleButtonState> {
  ToggleButtonCubit() : super(ToggleButtonInitial());

  void changeOption(int index) {
    List<bool> selected =[false, false];
    selected[index] = true;

    emit(ToggleButtonState(option: RadioButtonOption.values[index], selected: selected));
  }
}