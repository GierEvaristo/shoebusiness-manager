import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminMainMenu extends StatelessWidget {
  const AdminMainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome admin!')
        ),
        body: Center(
            child: ElevatedButton(
                onPressed: signOut,
                child: Text('Logout')
            )
        )
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
