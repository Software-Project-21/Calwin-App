import 'package:calwin/Screens/holidays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/sign_in.dart';
import 'Utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // getHolidayDetails();
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
