import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:first_app/presentation/authentication/Screens/Login/login_screen.dart';
import 'package:first_app/presentation/authentication/constants.dart';
import 'package:first_app/presentation/widgets/custom_tab_bar.dart';

import 'bloc/toggle_button_bloc/toggle_button_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleButtonCubit(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Skin lesion detection",
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 44),
            minimumSize: const Size(double.infinity, 44),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          contentPadding: EdgeInsets.all(0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
        ),
        colorScheme: const ColorScheme(
            surface: Colors.white70,
            onSurface: Colors.black,
            primary: Color.fromRGBO(200, 158, 133, 1),
            onPrimary: Colors.white,
            secondary: Colors.white,
            onSecondary: Colors.black,
            tertiary: Color.fromRGBO(255, 204, 128, 1),
            error: Colors.red,
            outline: Color(0xFF424242),
            brightness: Brightness.light,
            onError: Colors.red,
            background: Colors.black,
            onBackground: Colors.black),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(200, 158, 133, 1),
          surfaceTintColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const PersistentTabScreen()
          : const LoginScreen(),
    );
  }
}
