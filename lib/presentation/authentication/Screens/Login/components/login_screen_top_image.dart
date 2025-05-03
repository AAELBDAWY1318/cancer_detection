import 'package:flutter/material.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Image(image: NetworkImage('https://img.freepik.com/free-vector/drug-allergy-abstract-concept-vector-illustration-triggers-drug-allergies-risk-factors-medicine-side-effect-remedy-intolerance-test-allergic-disease-symptom-treatment-abstract-metaphor_335657-4067.jpg?t=st=1729880614~exp=1729884214~hmac=134f51be3aa9219a97c4f093f9ca53797cb9cdee96a8b1051d73da919219d338&w=826')),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}