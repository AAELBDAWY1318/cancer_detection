import 'package:flutter/material.dart';

BoxDecoration customBoxDecoration(BuildContext context) {
  return BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      border: Border.all(color: Theme.of(context).colorScheme.primary),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ]);
}



Widget buildClassificationInfo() {
  return SizedBox(
    width: 200,
    child: Card(
      elevation: 10,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
            'The classification is based on a Deep Learning model and is not be guranteed to be correct.'),
      ),
    ),
  );
}

Widget buildInferneceInfo() {
  return SizedBox(
    width: 200,
    child: Card(
      elevation: 10,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
            'The local inference is done via tensforlite light model. The cloud service is based on a hosted tensorflow model. You need internet connection for it.'),
      ),
    ),
  );
}

void showOverlay(context, var key, Widget _buildInfo) async {
  final box = key.currentContext?.findRenderObject() as RenderBox;
  final offset = box.localToGlobal(Offset.zero);
  final entry = OverlayEntry(
    builder: (_) => Positioned(
      top: offset.dy,
      left: offset.dx - 190,
      child: _buildInfo,
    ),
  );

  Overlay.of(context).insert(entry);
  await Future.delayed(Duration(seconds: 3));
  entry.remove();
}

