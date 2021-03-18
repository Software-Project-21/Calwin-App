import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  Artboard _riveArtboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/marty_v6.riv').then(
          (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Animation2'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            child: _riveArtboard == null
                ? const SizedBox()
                : Rive(artboard: _riveArtboard),
          ),
          Center(
            child: Column(
              children: [
                Spacer(flex: 6,),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      email = value;
                    },
                    decoration: InputDecoration(
                      hintText: '  Email',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      password = value;
                    },
                    decoration: InputDecoration(
                      hintText: '  Password',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async{
                    // print(email);
                    // print(password);
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      if(newUser!=null){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>HomeScreen(user: newUser.user,))
                        );
                      }
                    }catch(e){
                      print(e);
                    }
                  },
                  child: Text('Register'),
                ),
                Spacer(flex: 2,),
              ],
            ),
          )
        ],
      ),
    );
  }
}

