import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_app/presentation/authentication/auth_class.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoView();
  }
}

class InfoView extends StatelessWidget {
  InfoView({super.key});

  List<Widget> buttonTitles = <Widget>[
    Row(children: [
      Icon(Icons.phone_android_rounded),
      SizedBox(
        width: 7,
      ),
      Text('local Tflite')
    ]),
    Row(children: [
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
        title: Text(
          "Credits",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1729881615~exp=1729885215~hmac=98aa7c0b97d0e4aa39b418ed9eb0cb7f47bbb96d41c1e78421c718decd363188&w=826'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(FirebaseAuth.instance.currentUser!.email!)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: InkWell(
                onTap: () {
                  Authentication.signOut(context: context);
                },
                child: Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://img.freepik.com/free-vector/illustration-exit-door_53876-5844.jpg?t=st=1729881749~exp=1729885349~hmac=778945b8231da64367a4109227fe707f0c3ee8cfc4ea9fe41b0134e90f8de1b6&w=826'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Logout')
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
