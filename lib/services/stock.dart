import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Stock {
  late String docID;
  late String brand;
  late String name;
  late String color;
  late Image image;
  late var size_qty = Map<String, int>;

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


  Stock({required this.brand, required this.name, required this.color, required this.docID}) {
  }

  static Stock fromJson(Map<String,dynamic> json, String inputDocID){
    print("DOC ID!!!!!!!!!!!!!!! YEAH $inputDocID");
    return Stock(
      brand: json['brand'],
      name: json['name'],
      color: json['color'],
      docID: inputDocID
    );
  }
}