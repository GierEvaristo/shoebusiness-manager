import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../report_sales/report_sales.dart';

class AdminMainMenu extends StatefulWidget {
  const AdminMainMenu({Key? key}) : super(key: key);

  @override
  State<AdminMainMenu> createState() => _AdminMainMenuState();
}

class _AdminMainMenuState extends State<AdminMainMenu> {

  String username = '';

  void initState(){
    super.initState();
    getName();
  }

  void getName() async{
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

    setState((){
      username = snapshot['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(right: 30, left: 30, top: 90, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome $username!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
               ),
                textDirection: TextDirection.ltr,
              ),
              CustomButton(
                  text: 'Manage Inventories',
                  icon: Icons.inventory,
                  onPressed: (){
                    Navigator.pushNamed(context, '/company_menu');
                  }
              ),
              CustomButton(
                  text: 'Report L. Evaristo Sales',
                  icon: Icons.point_of_sale,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        ReportSales(chosenBrand: 'l_evaristo')));
                  }
              ),
              CustomButton(
                  text: 'Manage Seacrest Orders',
                  icon: Icons.checklist_rounded,
                  onPressed: (){
                    Navigator.pushNamed(context,'/manage_orders');
                  }
              ),
              CustomButton(
                  text: 'View Sales Report',
                  icon: Icons.receipt_long_rounded,
                  onPressed: (){
                    Navigator.pushNamed(context,'/track_sales_menu');
                  }
              ),
              CustomButton(
                  text: 'Logout',
                  icon: Icons.logout,
                  onPressed: (){
                    signOut(context);
                  }
              ),
            ],
          ),
        )
      ),
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
        Expanded(
          child: Container(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(
                text!,
                textScaleFactor: 1.3,
              ),
              style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(200,55)
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            ),
          ),
        ),
      ],
    );
  }
}
