
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as i;

import '../../main.dart';

class AddPerOrder extends StatefulWidget {
  String chosenBrand;
  AddPerOrder({required this.chosenBrand});
  @override
  State<AddPerOrder> createState() => _AddPerOrderState();
}

class _AddPerOrderState extends State<AddPerOrder> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productAddressController = TextEditingController();
  TextEditingController productNumberController = TextEditingController();


  @override
  initState(){
    super.initState();
  }

  Future<void> uploadData() async {
    Map<String,dynamic> stockData = {
      'name' : productNameController.text,
      'address' : productAddressController.text,
      'contact number' : productNumberController.text,
      'completed' : false,
      'date' : DateTime.now(),
    };
    List<dynamic> orders = [
      {
        'color' : ' ',
        'docID' : ' ',
        'price_sold' : 0,
        'qty' : 0,
        'size' : 0,
        'model' : ' ',
      },
    ];


    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(
                child: CircularProgressIndicator()
            )
    );
    stockData['orders'] = orders;
    await FirebaseFirestore.instance.collection('${widget.chosenBrand}_orders').add(stockData).
    then((documentSnapshot) => print("Added data with ID: ${documentSnapshot.id}"));
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Add Seacrest order',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),
                textDirection: TextDirection.ltr,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Name',
                      style: TextStyle(
                          fontSize: 16
                      )),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: productNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Address',
                      style: TextStyle(
                          fontSize: 16
                      )),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: productAddressController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Contact Number',
                      style: TextStyle(
                          fontSize: 16
                      )),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: productNumberController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)
                      ),
                    ),
                  )
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text(
                        'Back'
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        minimumSize: Size(100, 40)
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      if (productNameController.value != '' &&
                          productNumberController.value != '' &&
                          productAddressController.value != '') {
                        await uploadData();
                        Fluttertoast.showToast(
                          msg: "Added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          textColor: Colors.black,
                          fontSize: 16,
                          backgroundColor: Colors.grey[200],
                        );
                        Navigator.pop(context);
                      }
                      else Fluttertoast.showToast(
                        msg: "Please complete the fields",
                        toastLength: Toast.LENGTH_SHORT,
                        textColor: Colors.black,
                        fontSize: 16,
                        backgroundColor: Colors.grey[200],
                      );
                    },
                    child: Text(
                        'Add'
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        onPrimary: Colors.white,
                        minimumSize: Size(100, 40)
                    ),
                  ),

                ],
              ),
            ]
        ),
      ),
    );
  }
}