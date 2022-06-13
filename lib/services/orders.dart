import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Order {
  late String name;
  late String address;
  late String number;

  Order(
      {required this.name, required this.address, required this.number}) {
  }

  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'],
      address: json['address'],
      number: json['number'],

    );
  }
}
