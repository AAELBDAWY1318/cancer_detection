import 'package:flutter/material.dart';

import '../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.network("https://img.freepik.com/free-vector/rhinoplasty-abstract-concept-vector-illustration-nose-correction-procedure-non-surgical-rhinoplasty-changes-shape-nose-respiratory-problems-aesthetic-reshaping-risks-abstract-metaphor_335657-4012.jpg?t=st=1729880868~exp=1729884468~hmac=d50d205c94d69c111bb6fde03a3c5650983f8bf0bf8793f8fbeb114363ebb357&w=826"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
