import 'package:calwin/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'RegisterUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';




class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth2;
  bool isUserSignedIn = false;

  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth2 = FirebaseAuth.instanceFor(app: defaultApp);
    // immediately check whether the user is signed in
    checkIfUserIsSignedIn();
  }
  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  Future<User> _handleSignIn() async {
    User user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = _auth.currentUser;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
    else {
      print('Now here <<<<<<<<<<<<<<<<<<<<<<<<<');
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    User user = await _handleSignIn();
    var userSignedIn = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomeScreen()),
    );

    setState(() {
      isUserSignedIn = userSignedIn == null ? true : false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 6,),
        Container(
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
          onPressed: (){
            try {
              final user = _auth.signInWithEmailAndPassword(
                  email: email, password: password);
              if(user!=null){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              }
            }catch(e){
              print(e);
            }
          },
          child: Text('Login'),
        ),
        TextButton(
          child: Text('New User? Register'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
          },
        ),
        _signInButton(),
        Spacer(flex: 2,),
      ],
    );
  }

  Widget _signInButton() {
    return OutlinedButton(
      onPressed: (){
        onGoogleSignIn(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        elevation: 5,
        animationDuration: Duration(seconds: 1),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}

