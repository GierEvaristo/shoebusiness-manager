import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/main.dart';

class AdminMainMenu extends StatelessWidget {
  const AdminMainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Welcome Admin!',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold
             ),
              textDirection: TextDirection.ltr,
            ),
            CustomButton(
                text: 'Manage Inventory',
                icon: Icons.inventory,
                onPressed: (){
                  Navigator.pushNamed(context, '/company_menu');
                }
            ),
            CustomButton(
                text: 'Report Sales',
                icon: Icons.point_of_sale,
                onPressed: (){
                  Navigator.pushNamed(context,'/report_sales_menu');
                }
            ),
            CustomButton(
                text: 'Manage Orders',
                icon: Icons.checklist_rounded,
                onPressed: (){
                  Navigator.pushNamed(context,'/manage_orders_menu');
                }
            ),
            CustomButton(
                text: 'Track Sales',
                icon: Icons.receipt_long_rounded,
                onPressed: (){
                  Navigator.pushNamed(context,'/track_sales_menu');
                }
            ),
            CustomButton(
                text: 'Logout',
                icon: Icons.logout,
                onPressed: (){signOut(context);}
            ),
          ],
        ),
      )
    );
  }

  Future signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final void Function()? onPressed;
  const CustomButton({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Icon(icon, size: 40),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text!,
            textScaleFactor: 1.3,
          ),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Theme.of(context).colorScheme.primary,
              minimumSize: Size(250,55)
          ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
        ),
      ],
    );
  }
}
