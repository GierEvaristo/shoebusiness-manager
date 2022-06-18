import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shoebusiness_manager/screens/inventory_menu/view_stock.dart';
import 'package:shoebusiness_manager/services/stock.dart';

import '../../services/sales.dart';

class GenerateExcel extends StatefulWidget {
  String chosenBrand;
  GenerateExcel({required this.chosenBrand} );

  @override
  State<GenerateExcel> createState() => _GenerateExcelState();
}

class _GenerateExcelState extends State<GenerateExcel> {
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now()
  );


  Stream<List<Sales>> readSales(){
    return FirebaseFirestore.instance.collection('${widget.chosenBrand}_sales').snapshots().
    map((snapshot) =>
        snapshot.docs.map((doc) => Sales.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> generateExcel() async {
    List<Sales> filtered = [];
    Stream<List<Sales>> stream = readSales();
    stream.listen((snapshot){
      print(snapshot);
      for (int i = 0 ; i<snapshot.length; i++){
        DateTime saleTime = DateTime.parse(snapshot[i].timeDate.toDate().toString());
        print(saleTime);
        if (saleTime.isBefore(dateRange.end) && saleTime.isAfter(dateRange.start)){
          print('pass');
          filtered.add(snapshot[i]);
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Select Date Range',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text('Start',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        )
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        pickDateRange();
                      },
                      child: Text(
                        '${dateRange.start.year}/${dateRange.start.month}/${dateRange.start.day}',
                        textScaleFactor: 1.3,
                      ),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Theme.of(context).colorScheme.primary,
                          minimumSize: Size(10, 47)
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text('End',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        )
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        pickDateRange();
                      },
                      child: Text(
                        '${dateRange.end.year}/${dateRange.end.month}/${dateRange.end.day}',
                        textScaleFactor: 1.3,
                      ),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Theme.of(context).colorScheme.primary,
                          minimumSize: Size(10, 47)
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        generateExcel();
                      },
                      child: Text(
                        'Generate Excel',
                        textScaleFactor: 1.3,
                      ),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.green,
                          minimumSize: Size(10, 47)
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      )
    );
  }
  Future pickDateRange() async{
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2022),
      lastDate: DateTime(DateTime.now().year + 1)
    );
    if (result == null) return;
    setState(() => dateRange = result);
  }
}
