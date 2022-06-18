import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/screens/track_sales/track_sales.dart';

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
              Text('Choose Brand',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                ),
                textDirection: TextDirection.ltr,
              ),
              CustomButton2(
                  text: 'L. Evaristo',
                  filename: 'l_evaristo_logo.png',
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      TrackSales(chosenBrand: 'l_evaristo')));
                  }
              ),
              CustomButton2(
                  text: 'Seacrest',
                  filename: 'seacrest_logo.png',
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        TrackSales(chosenBrand: 'seacrest')));
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
