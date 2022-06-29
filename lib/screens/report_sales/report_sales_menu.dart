import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/screens/report_sales/report_sales.dart';

import '../main_menus/admin_main_menu.dart';

class ReportSalesMenu extends StatelessWidget {
  const ReportSalesMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(right: 30, left: 30, top: 90, bottom: 50),
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
                filename: 'l_evaristo_logo.png',
                text: 'L. Evaristo',

                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      ReportSales(chosenBrand: 'l_evaristo')));
                }
              ),
              CustomButton2(
                filename: 'seacrest_logo.png',
                text: 'Seacrest',
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      ReportSales(chosenBrand: 'seacrest')));
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
        Expanded(
          child: ElevatedButton(
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
        ),
      ],
    );
  }
}
