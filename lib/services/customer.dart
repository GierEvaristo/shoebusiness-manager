import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoebusiness_manager/services/stock.dart';

class Customer {
  late String name;
  late String address;
  late String number;
  late dynamic date;
  late dynamic dateCompleted;
  late bool status;
  late String customerDocID;
  late List<dynamic> orders;

  Customer({required this.name, required this.address, required this.number,
    required this.date, required this.status, required this.customerDocID, required this.orders, required this.dateCompleted}){
  }

  static Customer fromJson(Map<String, dynamic> json, String customerDocID) {
    return Customer(
      name: json['name'],
      address: json['address'],
      number: json['contact number'],
      status: json['completed'],
      date: json['date'],
      customerDocID : customerDocID,
      orders : json['orders'] as List<dynamic>,
      dateCompleted : json['time_completed']
    );
  }
}
