import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoebusiness_manager/screens/auth_screens/login.dart';
import 'package:shoebusiness_manager/screens/main_menus/admin_main_menu.dart';
import 'package:shoebusiness_manager/screens/main_menus/user_main_menu.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const Wrapper(),
      title: 'L.EvaristoShoeShop',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.amber[600],
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.robotoTextTheme()
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData ? AdminMainMenu() : Login();
        }
      )
    );
  }
}



