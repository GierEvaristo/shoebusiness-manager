import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Customer {
  late String name;
  late String address;
  late String number;
  late dynamic date;
  late bool status;
  late String docID;
  late List<dynamic> orders;

  Customer({required this.name, required this.address, required this.number,
    required this.date, required this.status, required this.docID, required this.orders});

  static Customer fromJson(Map<String, dynamic> json, String docID) {
    return Customer(
      name: json['name'],
      address: json['address'],
      number: json['contact number'],
      status: json['completed'],
      date: json['date'],
      docID : docID,
      orders : json['orders']
    );
  }
}
