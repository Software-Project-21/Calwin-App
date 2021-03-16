import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
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
              onPressed: () async{
                // print(email);
                // print(password);
                try{
                  final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if(newUser!=null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>HomeScreen())
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
      ),
    );
  }
}

