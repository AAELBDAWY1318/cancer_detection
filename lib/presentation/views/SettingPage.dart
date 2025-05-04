import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/toggle_button_bloc/toggle_button_cubit.dart';
import '../widgets/InfoBoxes.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  final GlobalKey _key = GlobalKey();

  List<Widget> buttonTitles = <Widget>[
    const Row(children: [
      Icon(Icons.phone_android_rounded),
      SizedBox(
        width: 7,
      ),
      Text('local Tflite')
    ]),
    const Row(children: [
      Icon(Icons.public),
      SizedBox(
        width: 7,
      ),
      Text('Cloud API call')
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Inference modes",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary)),
                        const SizedBox(
                          width: 162,
                        ),
                        Expanded(
                          child: IconButton(
                            key: _key,
                            icon: Icon(
                              Icons.info,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () =>
                                showOverlay(context, _key, buildInferneceInfo()),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Use local prediction or cloud service:",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Center(
                      child: BlocBuilder<ToggleButtonCubit, ToggleButtonState>(
                        builder: (context, state) {
                          return ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              context
                                  .read<ToggleButtonCubit>()
                                  .changeOption(index);
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderColor: Theme.of(context).colorScheme.primary,
                            selectedBorderColor:
                                Theme.of(context).colorScheme.primary,
                            fillColor: Theme.of(context).colorScheme.primary,
                            selectedColor: Colors.white,
                            color: Colors.black,
                            constraints: const BoxConstraints(
                              minHeight: 40.0,
                              minWidth: 150.0,
                            ),
                            isSelected: state.selected,
                            children: buttonTitles,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Model information: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("The model output seven different lesion types and their porbabilty."),                          ],
                      )

                  ))),
        ],
      ),
    );
  }
}
