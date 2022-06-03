import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrackSalesMenu extends StatelessWidget {
  const TrackSalesMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Choose Company',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                ),
                textDirection: TextDirection.ltr,
              ),
              CustomButton(
                  text: 'L Evaristo',
                  icon: Icons.inventory,
                  onPressed: (){
                    Navigator.pushNamed(context, '/report_sales');
                  }
              ),
              CustomButton(
                  text: 'Seacrest',
                  icon: Icons.receipt_long_rounded,
                  onPressed: (){
                    Navigator.pushNamed(context, '/report_sales');
                  }
              ),
              CustomButton(
                  text: 'Back',
                  icon: Icons.logout,
                  onPressed: () {
                    Navigator.pop(context);
                  }
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
