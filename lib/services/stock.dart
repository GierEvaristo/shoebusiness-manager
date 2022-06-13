import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Stock {
  late String docID;
  late String brand;
  late String name;
  late String color;
  late Image image;
  late Map<String, int> size_qty;

  Future<String> generateURL() async {
    String temp_name = name.toLowerCase();
    String temp_color = color.toLowerCase();
    temp_name = temp_name.replaceAll(' ', '_');
    temp_name = temp_name.replaceAll('\'', '');
    temp_color = temp_color.replaceAll(' ', '_');
    String filename = temp_name + '_' +temp_color;
    print(filename + '---------------');
    Reference ref = FirebaseStorage.instance.ref().child('images/${brand}/${filename}.jpg');
    String url = (await ref.getDownloadURL()).toString();
    return url;
    // print(url + ' UUUUUUUUUUUUUUUUUUUUUUUUUUUUU');
    // return Image.network(url);
  }


  Stock({required this.brand, required this.name, required this.color, required this.docID, required this.size_qty}) {
  }

  static Stock fromJson(Map<String,dynamic> json, String docID){
    return Stock(
      brand: json['brand'],
      name: json['name'],
      color: json['color'],
      size_qty: {
        '5': json['size_qty']['5'],
        '5.5': json['size_qty']['5.5'],
        '6': json['size_qty']['6'],
        '6.5': json['size_qty']['6.5'],
        '7': json['size_qty']['7'],
        '7.5': json['size_qty']['7.5'],
        '8': json['size_qty']['8'],
        '8.5': json['size_qty']['8.5'],
        '9': json['size_qty']['9'],
        '9.5': json['size_qty']['9.5'],
        '10': json['size_qty']['10'],
        '10.5': json['size_qty']['10.5'],
        '11': json['size_qty']['11'],
        '11.5': json['size_qty']['11.5'],
        '12': json['size_qty']['12'],
      },
      docID: docID
    );
  }

}