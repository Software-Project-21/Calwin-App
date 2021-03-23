import 'package:flutter/material.dart';
import 'Screens/sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calwin App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: SignInScreen(),
    );
  }
}


/*
https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/ -- For SignIn Feature.

*/