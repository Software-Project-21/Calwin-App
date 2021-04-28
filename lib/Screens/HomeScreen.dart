import 'dart:async';
import 'dart:core';
import 'package:calwin/Screens/AllHolidayScreen.dart';
import 'package:calwin/Screens/CalenderScreen.dart';
import 'package:calwin/Screens/CheckInviteScreen.dart';
import 'package:calwin/Screens/SettingsScreen.dart';
import 'package:calwin/Screens/ViewAllEvent.dart';
import 'package:calwin/Utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/consumer.dart';
import 'package:rive/rive.dart';

import 'eventsChooser.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key key, @required this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Artboard _riveArtboard;
  Artboard _riveArtboard2;
  RiveAnimationController _controller;
  RiveAnimationController _controller2;
  double maxHeight;
  double maxWidth;
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
    rootBundle.load('assets/turtle.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(_controller2 = SimpleAnimation('Swim'));
        setState(() => _riveArtboard2 = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    maxHeight = MediaQuery.of(context).size.height;
    maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calwin',
            style: Theme.of(context).primaryTextTheme.headline1),
        actions: [
          Consumer<ThemeNotifier>(
            builder: (context2, notifier, child) => IconButton(
              icon: notifier.isDarkTheme
                  ? Icon(
                      Icons.settings,
                      size: 30,
                      color:
                          notifier.isDarkTheme ? Colors.white : Colors.black54,
                    )
                  : Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 100),
                        child: SettingsScreen(
                          user: widget.user,
                        )));
              },
            ),
          )
        ],
      ),
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
                    ), // Goto calender
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 300),
                                      child: AllHolidayScreen(),
                                    ),
                                  );
                                },
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          duration: Duration(milliseconds: 300),
                                          child: CheckInviteScreen(
                                            user: widget.user,
                                          )));
                                },
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 300),
                                      child: ViewAllEvents(
                                        user: widget.user,
                                      )));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 110,
                                  child: _riveArtboard2 == null
                                      ? const SizedBox()
                                      : Rive(
                                          artboard: _riveArtboard2,
                                          fit: BoxFit.fitWidth,
                                        ),
                                ),
                                Text(
                                  "View",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 54,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text("Events",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white70,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                                  .green; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 300),
                                  child: EventsChooser(
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
                                    "Create",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text("Events",
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
                                Icons.add_circle,
                                size: 80,
                              ),
                            ]),
                      ),
                    ), // create events
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
