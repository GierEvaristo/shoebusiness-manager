import 'package:cloud_firestore/cloud_firestore.dart';

class Sales {
  late int priceSold;
  late int qty;
  late String size;
  late String stockDocID;
  late Timestamp timeDate;

  Sales({required this.priceSold, required this.qty, required this.size,
  required this.stockDocID, required this.timeDate});

  static Sales fromJson(Map<String, dynamic> json, String docID) {

    return Sales(
      priceSold: json['price_sold'],
      qty: json['qty'],
      size: json['size'],
      stockDocID: json['stock_docID'],
      timeDate: json['time_date']
    );
  }
}
