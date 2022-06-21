import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoebusiness_manager/screens/auth_screens/login.dart';
import 'package:shoebusiness_manager/screens/auth_screens/splash_screen.dart';
import 'package:shoebusiness_manager/screens/company_menu/company_inventory_menu.dart';
import 'package:shoebusiness_manager/screens/main_menus/admin_main_menu.dart';
import 'package:shoebusiness_manager/screens/main_menus/user_main_menu.dart';
import 'package:shoebusiness_manager/screens/manage_orders/manage_orders.dart';
import 'package:shoebusiness_manager/screens/manage_orders/manage_orders_menu.dart';
import 'package:shoebusiness_manager/screens/report_sales/report_sales.dart';
import 'package:shoebusiness_manager/screens/report_sales/report_sales_menu.dart';
import 'package:shoebusiness_manager/screens/track_sales/track_sales_menu.dart';
import 'package:shoebusiness_manager/screens/track_sales/track_sales.dart';

import 'screens/inventory_menu/inventory.dart';


//hello
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
      routes: {
        '/admin_main_menu':(context) => AdminMainMenu(),
        '/user_main_menu':(context) => UserMainMenu(),
        '/company_menu': (context) => CompanyMenu(),
        '/report_sales_menu': (context) => ReportSalesMenu(),
        '/manage_orders' : (context) => OrdersMenu(),
        '/track_sales_menu': (context) => TrackSalesMenu(),
      },

      navigatorKey: navigatorKey,
      home: const Wrapper(),
      title: 'L.EvaristoShoeShop',
      theme: ThemeData(
        cardTheme: CardTheme(
          surfaceTintColor: Colors.transparent,
          elevation: 0
        ),
        splashFactory: InkSplash.splashFactory,
        useMaterial3: true,
        primaryColor: Colors.amber[600],
        accentColor: Colors.amberAccent,
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
          return snapshot.hasData ? SplashScreen() : Login();
        }
      )
    );
  }
}



