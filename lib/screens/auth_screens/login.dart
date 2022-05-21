import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome! Please Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: TextField( // email
                controller: emailController,
                onChanged: (val){},
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'Username (Email)',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20)
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: TextField( // password
                controller: passwordController,
                onChanged: (val){},
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Password',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20)
                ),
              ),
            ),
            SizedBox(height: 20),
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: signIn,
                  child: Text(
                    'Login'
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Theme.of(context).colorScheme.primary,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                ),
              ]
            )
          ],
        ),
      )
    );
  }

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

}
