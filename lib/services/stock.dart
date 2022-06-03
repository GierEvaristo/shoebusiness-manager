import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Stock {
  late String name;
  late String color;
  late Image image;
  late var size_qty = Map<String, int>;
  Stock({required this.name, required this.color});

  static Stock fromJson(Map<String,dynamic> json){
    return Stock(
      name: json['name'],
      color: json['color'],
    );
  }
}