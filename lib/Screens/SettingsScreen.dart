import 'package:calwin/Screens/sign_in.dart';
import 'package:calwin/Utils/Authentication.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/consumer.dart';
import 'package:calwin/Utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  final User user;
  const SettingsScreen({Key key, @required this.user}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: Theme.of(context).primaryTextTheme.headline1),
      ),
      body: Container(
        color: Theme
            .of(context)
            .primaryColor,
        padding: EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(widget.user.photoURL),
                ),
                  SizedBox(height: 10,),
                  Text(widget.user.displayName,style: Theme.of(context).primaryTextTheme.headline2,),
                  Text(widget.user.email,style: Theme.of(context).primaryTextTheme.bodyText1,),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states){
                            return 0.0;
                          }
                      ),
                      backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context).primaryColor;
                          return Theme.of(context).primaryColor; // Use the component's default.
                        },
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 30,right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Theme ',style: Theme.of(context).primaryTextTheme.bodyText1),
                          notifier.isDarkTheme
                              ? FaIcon(
                            FontAwesomeIcons.moon,
                            size: 20,
                            color: notifier.isDarkTheme
                                ? Colors.white
                                : Colors.black54,
                          )
                              : Icon(Icons.wb_sunny,
                            size: 20,
                            color: notifier.isDarkTheme
                                ? Colors.white
                                : Colors.black54,),
                        ],
                      ),
                    ),
                    onPressed: () => {notifier.toggleTheme()},
                  ),
                ),
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states){
                            return 0.0;
                          }
                      ),
                      backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context).primaryColor;
                          return Theme.of(context).primaryColor; // Use the component's default.
                        },
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 30,right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sign Out ',style: Theme.of(context).primaryTextTheme.bodyText1),
                          notifier.isDarkTheme
                              ? Icon(
                            Icons.exit_to_app_rounded,
                            size: 20,
                            color: notifier.isDarkTheme
                                ? Colors.white
                                : Colors.black54,
                          ): Icon(Icons.exit_to_app_rounded,
                            size: 20,
                            color: notifier.isDarkTheme
                                ? Colors.white
                                : Colors.black54,),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await Authentication.signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context)
                          .pushReplacement(_routeToSignInScreen());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

