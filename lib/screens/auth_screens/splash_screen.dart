import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool admin = false;

  void initState(){
    super.initState();
    checkRole();
  }


  void checkRole() async {
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

    setState((){
      admin = snapshot['admin'];
      print(admin);
    });

    if (admin == true) {
      Timer(Duration(milliseconds: 750),() {
        Navigator.pushNamed(context, '/admin_main_menu');
      });
    }
    else {
      Timer(Duration(milliseconds: 750),() {
        Navigator.pushNamed(context, '/user_main_menu');
      });
    }
  }

  Future signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: SpinKitSquareCircle(
          color: Colors.white,
          size: 50
        )
      )
    );
  }
}
