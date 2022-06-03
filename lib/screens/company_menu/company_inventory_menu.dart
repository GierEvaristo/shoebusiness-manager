import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_menus/admin_main_menu.dart';

class CompanyMenu extends StatelessWidget {
  const CompanyMenu({Key? key}) : super(key: key);

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
              CustomButton2(
                  text: 'L Evaristo',
                  filename: 'l_evaristo_logo.png',
                  onPressed: (){
                    Navigator.pushNamed(context, '/inventory_menu');
                  }
              ),
              CustomButton2(
                  text: 'Seacrest',
                  filename: 'seacrest_logo.png',
                  onPressed: (){
                    Navigator.pushNamed(context, '/inventory_menu');
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


class CustomButton2 extends StatelessWidget {
  final String? text;
  final String filename;
  final void Function()? onPressed;
  const CustomButton2({required this.text,
    required this.onPressed, required this.filename});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(child: Image.asset('assets/$filename'), height: 45, width: 45,),
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
