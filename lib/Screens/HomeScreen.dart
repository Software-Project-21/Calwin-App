import 'dart:async';
import 'dart:core';
import 'package:calwin/Screens/CalenderScreen.dart';
import 'package:calwin/Screens/sign_in.dart';
import 'package:calwin/Utils/Authentication.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/slides/v1.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/consumer.dart';
import 'package:rive/rive.dart';
import 'package:slide_drawer/slide_drawer.dart';


class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key key, @required this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  bool _isSigningOut = false;
  double maxHeight;
  double maxWidth;

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
  void initState() {
    super.initState();
    rootBundle.load('assets/buggy.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('idle'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    maxHeight = MediaQuery.of(context).size.height;
    maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          title: Text('Welcome,',
              style: Theme.of(context).primaryTextTheme.headline1),
          actions: [
            Consumer<ThemeNotifier>(
              builder: (context2, notifier, child) => IconButton(
                icon: notifier.isDarkTheme
                    ? Icon(
                        Icons.menu,
                        size: 30,
                        color: notifier.isDarkTheme
                            ? Colors.white
                            : Colors.black54,
                      )
                    : Icon(Icons.menu),
                // onPressed: () => SlideDrawer.of(context).toggle()
              ),
            )
          ]),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Theme.of(context).primaryColor,
              height: maxHeight * 7 / 8,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 235,
                      child: _riveArtboard == null
                          ? const SizedBox()
                          : Rive(
                              artboard: _riveArtboard,
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.lightBlueAccent;
                              return Colors
                                  .orange; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 300),
                                  child: CalenderScreen(
                                    user: widget.user,
                                  )));
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: maxWidth / 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Go To",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text("Calender",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white60,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              SizedBox(
                                width: maxWidth / 7,
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 80,
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green;
                                      return Colors
                                          .red; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "View",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 42,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text("Holidays",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white60,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              width: maxWidth / 2 - 15,
                              height: 150,
                            ),
                            SizedBox(
                              height: 10,
                              width: maxWidth / 2 - 30,
                            ),
                            Container(
                              width: maxWidth / 2 - 15,
                              height: 150,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green;
                                      return Colors
                                          .yellowAccent; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {},
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Check",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.red,
                                          fontSize: 42,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text("Invites",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black45,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: maxWidth / 2 - 15,
                          height: 310,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.orangeAccent;
                                  return Colors
                                      .blue; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "02hr",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 54,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text("26min",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white24,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700)),
                                Text("chill\ntime",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black45,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700)),
                                Text("remaining",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black45, fontSize: 15))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// Widget Drawert() {
//   return Drawer(
//     elevation: 20,
//     child: Container(
//       color: Theme
//           .of(context)
//           .primaryColor,
//       padding: EdgeInsets.only(left: 20, top: 45),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: CircleAvatar(
//               radius: 70,
//               backgroundImage: NetworkImage(widget.user.photoURL),
//             ),
//           ),
//
//           Consumer<ThemeNotifier>(
//               builder: (context, notifier, child) =>
//                   IconButton(
//                       icon: notifier.isDarkTheme
//                           ? FaIcon(
//                         FontAwesomeIcons.moon,
//                         size: 20,
//                         color: notifier.isDarkTheme
//                             ? Colors.white
//                             : Colors.black54,
//                       )
//                           : Icon(Icons.wb_sunny),
//                       onPressed: () => {notifier.toggleTheme()})),
//           Consumer<ThemeNotifier>(
//             builder: (context2, notifier, child) =>
//                 IconButton(
//                   icon: notifier.isDarkTheme
//                       ? Icon(
//                     Icons.exit_to_app_rounded,
//                     size: 20,
//                     color: notifier.isDarkTheme
//                         ? Colors.white
//                         : Colors.black54,
//                   )
//                       : Icon(Icons.exit_to_app_rounded),
//                   onPressed: () async {
//                     setState(() {
//                       _isSigningOut = true;
//                     });
//                     await Authentication.signOut(context: context);
//                     setState(() {
//                       _isSigningOut = false;
//                     });
//                     Navigator.of(context)
//                         .pushReplacement(_routeToSignInScreen());
//                   },
//                 ),
//           ),
//           Expanded(
//             child: Container(),
//           ),
//         ],
//       ),
//     ),
//   );
// }
