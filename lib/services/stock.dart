import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Stock {
  late String docID;
  late String brand;
  late String name;
  late String color;
  late String address;
  late String filename;
  late Map<String, int> size_qty;

  Future<String> generateURL() async {
    print(filename + '---------------');
    Reference ref = await FirebaseStorage.instance.ref().child('images/${brand}/${filename}');
    String url = (await ref.getDownloadURL()).toString();
    return url;
    // print(url + ' UUUUUUUUUUUUUUUUUUUUUUUUUUUUU');
    // return Image.network(url);
  }


  Stock({required this.brand, required this.name, required this.color, required this.docID, required this.size_qty
  ,required this.filename}) {
    // String temp_name = name.toLowerCase();
    // String temp_color = color.toLowerCase();
    // temp_name = temp_name.replaceAll(' ', '_');
    // temp_name = temp_name.replaceAll('\'', '');
    // temp_color = temp_color.replaceAll(' ', '_');
    // filename = temp_name + '_' +temp_color;
  }

  static Stock fromJson(Map<String,dynamic> json, String docID){
    return Stock(
      brand: json['brand'],
      name: json['name'],
      color: json['color'],
      filename : json['filename'],
      size_qty: {
        '5.0': json['size_qty']['50'],
        '5.5': json['size_qty']['55'],
        '6.0': json['size_qty']['60'],
        '6.5': json['size_qty']['65'],
        '7.0': json['size_qty']['70'],
        '7.5': json['size_qty']['75'],
        '8.0': json['size_qty']['80'],
        '8.5': json['size_qty']['85'],
        '9.0': json['size_qty']['90'],
        '9.5': json['size_qty']['95'],
        '10.0': json['size_qty']['100'],
        '10.5': json['size_qty']['105'],
        '11.0': json['size_qty']['110'],
        '11.5': json['size_qty']['115'],
        '12.0': json['size_qty']['120'],
      },
      docID: docID
    );
  }

}