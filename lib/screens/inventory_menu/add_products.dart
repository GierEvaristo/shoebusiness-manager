
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as i;

import '../../main.dart';

class AddProducts extends StatefulWidget {
  String chosenBrand;
  AddProducts({required this.chosenBrand});
  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productColorController = TextEditingController();
  TextEditingController productSRPController = TextEditingController();
  String text = 'Pick image';

  late XFile? _image = null;
  String chosenBrandProper = '';

  @override
  initState(){
    super.initState();
    if (widget.chosenBrand == 'l_evaristo') chosenBrandProper = 'L. Evaristo';
    else chosenBrandProper = 'Seacrest';
  }

  Future<void> uploadData() async {
    Map<String,dynamic> stockData = {
      'brand' : widget.chosenBrand,
      'name' : productNameController.text,
      'color' : productColorController.text,
      'filename' : _image?.name,
      'srp' : int.parse(productSRPController.text),
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
        Center(
          child: CircularProgressIndicator()
        )
    );
    stockData['size_qty'] = size_qtyData;
    await FirebaseStorage.instance.ref().child("images/${widget.chosenBrand}/${_image?.name}").putFile(i.File(_image!.path));
    await FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory').add(stockData).
    then((documentSnapshot) => print("Added data with ID: ${documentSnapshot.id}"));
    Navigator.pop(context);
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 500,
        maxWidth: 500,
        );
    setState(() {
      _image = image;
      print(image);
      if (_image != null)
        text = 'Image added';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 30, left: 30, top: 90, bottom: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Add ${chosenBrandProper} product',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('SRP',
                      style: TextStyle(
                          fontSize: 16
                      )),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: productSRPController,
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