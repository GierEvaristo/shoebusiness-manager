
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shoebusiness_manager/screens/company_menu/company_inventory_menu.dart';
import 'package:shoebusiness_manager/services/stock.dart';
import 'package:image/image.dart';
import 'dart:io' as i;

class AddProducts extends StatefulWidget {
  String chosenBrand;
  AddProducts({required this.chosenBrand});
  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productColorController = TextEditingController();
  String text = 'Pick image';
  String productName = '';
  String productColor = '';

  late XFile? _image;

  Future<void> uploadData() async {
    Map<String,dynamic> stockData = {
      'brand' : widget.chosenBrand,
      'name' : productNameController.text,
      'color' : productColorController.text,
      'filename' : _image?.name
    };
    Map<String, int> size_qtyData = {
      '50' : 0,
      '55' : 0,
      '60' : 0,
      '65' : 0,
      '70' : 0,
      '75' : 0,
      '80' : 0,
      '85' : 0,
      '90' : 0,
      '95' : 0,
      '100' : 0,
      '105' : 0,
      '110' : 0,
      '115' : 0,
      '120' : 0,
    };
    stockData['size_qty'] = size_qtyData;
    FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory').add(stockData).
    then((documentSnapshot) => print("Added data with ID: ${documentSnapshot.id}"));
    FirebaseStorage.instance.ref().child("images/${widget.chosenBrand}/${_image?.name}").putFile(i.File(_image!.path));
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 120,
        maxWidth: 120,
        );
    setState(() {
      _image = image;
      print(_image?.name);
    });
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
              Text('Add ${widget.chosenBrand} product',
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
                  Text('Color',
                        style: TextStyle(
                            fontSize: 16
                        )),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: productColorController,
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
              ElevatedButton(
                onPressed: () async {
                  await getImage();
                },
                child: Text(text),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    minimumSize: Size(100, 40)
                ),
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
                          productColorController.value != '' &&
                          _image != null) {
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