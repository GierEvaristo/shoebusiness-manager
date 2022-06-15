import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Order {
  late String name;
  late String address;
  late String number;
  late dynamic date;
  late bool status;


  Order(
      {required this.name, required this.address, required this.number, required this.date, required this.status}) {
  }

  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'],
      address: json['address'],
      number: json['contact number'],
      status: json['completed'],
      date: json['date'],

    );
  }
}
