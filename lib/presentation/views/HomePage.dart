import 'dart:developer';
import 'dart:io';
import 'package:first_app/presentation/views/take_picture.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/cubits/inference_cubit.dart';
import '../../bloc/toggle_button_bloc/toggle_button_cubit.dart';
import '../../data/cloudInference/Tf_Serving.dart';
import '../../data/tflite/local_inference.dart';

import '../widgets/InfoBoxes.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key}) {}

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    localInferenceModel = LocalInferenceModel();
    localInferenceModel.init();
    super.initState();
  }

  TfServing tfServing = TfServing(
      url: "https://54.93.172.29.nip.io/v1/models/skin_cancer:predict",
      labelsPath: "assets/labels.txt");

  LocalInferenceModel localInferenceModel = LocalInferenceModel()..init();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InferenceCubit(
          localInferenceModel: localInferenceModel, tfServing: tfServing),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    init();
  }

  final GlobalKey _key = GlobalKey();
  final GlobalKey _key2 = GlobalKey();
  final imagePicker = ImagePicker();
  late CameraDescription firstCamera;
  var topPredictions;

  init() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;
  }

  Future<void> _getImageAndClassifciation(BuildContext context) async {
    File imageFile = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TakePictureScreen(
                camera: firstCamera,
              )),
    );

    if (context.read<ToggleButtonCubit>().state.option ==
        RadioButtonOption.local_inference) {
      BlocProvider.of<InferenceCubit>(context).inference_local(imageFile);
    } else {
      BlocProvider.of<InferenceCubit>(context).inference_local(imageFile);
    }
  }

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
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50,
                            top: 140,
                          ),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Theme.of(context).colorScheme.primary,
                            child: Image.network(
                                'https://img.freepik.com/free-vector/isolated-phonendoscope_1262-6423.jpg?ga=GA1.1.1159215571.1743146981&semt=ais_hybrid&w=740'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 220,
                            top: 90,
                          ),
                          child: Container(
                            height: 150,
                            width: 150,
                            color: Theme.of(context).colorScheme.primary,
                            child: Image.network(
                                'https://img.freepik.com/free-photo/beautiful-young-female-doctor-looking-camera-office_1301-7807.jpg?ga=GA1.1.1159215571.1743146981&semt=ais_hybrid&w=740'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 290,
                            top: 6,
                          ),
                          child: IconButton(
                            key: _key,
                            icon: const Icon(
                              Icons.info,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () => showOverlay(
                                context, _key, buildClassificationInfo()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 210,
                          ),
                          child: SizedBox(
                            width: 320,
                            child: GestureDetector(
                              onTap: () => _getImageAndClassifciation(context),
                              child: Card(
                                  elevation: 10,
                                  color: Colors.white,
                                  child: ListTile(
                                    title: const Text("Take photo"),
                                    subtitle: const Text(
                                        "It will take a moment to process"),
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue.shade800,
                                      size: 40,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 170,
                          top: 20,
                          child: Text(
                            "Hi!",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 85,
                            top: 50,
                          ),
                          child: SizedBox(
                              width: 200,
                              child: Text(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  "Please take a picture and I will give you my opinion.")),
                        ),
                      ],
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text("Inference modes",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                            const SizedBox(
                              width: 162,
                            ),
                            Expanded(
                              child: IconButton(
                                key: _key2,
                                icon: Icon(
                                  Icons.info,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () => showOverlay(
                                    context, _key2, buildInferneceInfo()),
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        ]),
                        const SizedBox(height: 10),
                        Center(
                          child:
                              BlocBuilder<ToggleButtonCubit, ToggleButtonState>(
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
                                borderColor:
                                    Theme.of(context).colorScheme.primary,
                                selectedBorderColor:
                                    Theme.of(context).colorScheme.primary,
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Do you know the ABCDE evaluation?",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Image.network(
                                    "https://img.freepik.com/premium-photo/abcd-word-written-wood-cubes-with-white-background_705411-903.jpg?ga=GA1.1.1159215571.1743146981&semt=ais_hybrid&w=740"),
                              ],
                            )))),
              ],
            ),
          ),
          BlocBuilder<InferenceCubit, InferenceState>(
              builder: (context, state) {
            if (state is InferenceLoading) {
              return Container(
                color: Colors.grey.shade100.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Colors.red,
                  ),
                ),
              );
            } else if (state is InferenceError) {
              log(state.error);
              return Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  child: Card(
                    borderOnForeground: true,
                    color: Colors.white,
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            state.error,
                            maxLines: 3,
                          ),
                          ElevatedButton(
                              onPressed: () =>
                                  BlocProvider.of<InferenceCubit>(context)
                                      .reset_state(),
                              child: const Text("Ok"))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is InferenceSuccess) {
              return Center(
                child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    height: MediaQuery.sizeOf(context).height * 0.62,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: state.isMalignant
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black38,
                              blurRadius: 3.0,
                              spreadRadius: 0.0,
                              offset: Offset(1.0, 1.0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              state.isMalignant
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                              state.isMalignant
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                              Colors.green.shade200,
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context)
                                  .colorScheme
                                  .primary //Colors.green.shade700
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(state.image,
                                  fit: BoxFit.contain,
                                  width:
                                      MediaQuery.sizeOf(context).height * 0.3,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.3),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height: 160,
                                  child: Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      "It could be a ${state.lesionName} with the following probabilty:"),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    300.0),
                                                        child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            child: Center(
                                                              child: state
                                                                      .isMalignant
                                                                  ? Text(
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onPrimary,
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                      "Benign")
                                                                  : Text(
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .onPrimary,
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      "Malginant"),
                                                            ))),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    300.0),
                                                        child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            child: Center(
                                                              child: Text(
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .onPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  "${state.probabilty} %"),
                                                            ))),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )))),
                          Padding(
                            padding: const EdgeInsets.only(left: 235),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                onPressed: () {
                                  BlocProvider.of<InferenceCubit>(context)
                                      .reset_state();
                                },
                                child: Text(
                                  "Close",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                )),
                          )
                        ],
                      ),
                    )),
              );

            }
            return Container();
          })
        ],
      ),
    );
  }
}
