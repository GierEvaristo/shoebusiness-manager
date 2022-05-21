import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminMainMenu extends StatelessWidget {
  const AdminMainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                onPressed: (){print('hello');}
            ),
            CustomButton(
                text: 'Report Sales',
                icon: Icons.point_of_sale,
                onPressed: (){print('hello');}
            ),
            CustomButton(
                text: 'Manage Orders',
                icon: Icons.checklist_rounded,
                onPressed: (){print('hello');}
            ),
            CustomButton(
                text: 'Track Sales',
                icon: Icons.receipt_long_rounded,
                onPressed: (){print('hello');}
            ),
            CustomButton(
                text: 'Logout',
                icon: Icons.logout,
                onPressed: signOut
            ),
          ],
        ),
      )
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, size: 40),
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
