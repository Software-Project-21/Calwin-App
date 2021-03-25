import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:calwin/Screens/sign_in_button.dart';
import 'package:calwin/Utils/Authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/marty_v6.riv').then(
      (data) async {
        final file = RiveFile();
        if (file.import(data)) {
          final artboard = file.mainArtboard;
          artboard.addController(_controller = SimpleAnimation('Animation1'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          Container(
            // width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            child: _riveArtboard == null
                ? const SizedBox()
                : Rive(
                    artboard: _riveArtboard,
                    fit: BoxFit.fitHeight,
                  ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width,
              child:Center(
                child: Column(
                  children:[
                    TypewriterAnimatedTextKit(
                      text: [
                        " CALWIN"
                      ],
                      speed: Duration(milliseconds: 200),
                      isRepeatingAnimation: false,
                      textStyle: TextStyle(
                          fontSize: 80.0,
                          fontFamily: "Agne",
                          color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.11,),
                    FutureBuilder(
                      future: Authentication.initializeFirebase(context: context),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error initializing Firebase');
                        } else if (snapshot.connectionState == ConnectionState.done) {
                          return GoogleSignInButton();
                        }
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
