import 'package:shoebusiness_manager/services/stock.dart';

class Report {
  late String stockDocID;
  late String size;
  late int qty;
  late dynamic time_date;
  late int price_sold;

  Report();

  static Report fromJson(Map<String, dynamic> json, String docID) {
    return Report(
    );
  }
}
