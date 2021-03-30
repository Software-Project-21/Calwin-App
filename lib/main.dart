import 'package:calwin/Screens/Calendar.dart';
import 'package:calwin/secrets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Model/CalendarCilent.dart';
import 'Screens/sign_in.dart';
import 'Utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:url_launcher/url_launcher.dart';
import 'Screens/holidays.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          title: 'Calwin App',
          debugShowCheckedModeBanner: false,
          theme: notifier.isDarkTheme ? dark : light,
          home: SignInScreen(),
        );
      }),
    );
  }
}

/*
https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/ -- For SignIn Feature.

*/
