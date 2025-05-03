import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../widgets/camera_overlay.dart';
import '../../data/image_utils.dart';

class TakePicturePage extends StatelessWidget {
  const TakePicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({
    super.key, required this.camera
  });

  final CameraDescription camera;
  //final InferenceRepository inferenceRepository;


  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  Map<String, double>? classification;

  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
    widget.camera,
    // Define the resolution to use.
    ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _controller.setZoomLevel(3.0);
            // If the Future is complete, display the preview.
            return Stack(
              children: [
                CameraPreview(_controller),
                CameraOverlay(overlayColour: Colors.black.withOpacity(0.5))
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.

            final image = await _controller.takePicture();

            if (!context.mounted) return;

            //BlocProvider.of<TakePictureCubit>(context).takePicture(cropped_image);
            File cropped_image = await ImageUtils.cropImageFile(File(image.path));
            Navigator.pop(context, cropped_image);

            /*
            classification = await widget.inferenceRepository.inference_local_model(cropped_image);

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClassifyView(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  image: cropped_image,
                  classification: classification!,
                ),
              ),
            );
             */
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}