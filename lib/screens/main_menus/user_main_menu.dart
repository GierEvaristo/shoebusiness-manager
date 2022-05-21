import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/screens/main_menus/admin_main_menu.dart';

class UserMainMenu extends AdminMainMenu {
  const UserMainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome user!'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){super.signOut();},
          child: Text('Logout')
        )
      )
    );
  }

}
