import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row, Column, Alignment;
import 'dart:io';
import 'package:path_provider/path_provider.dart';


import '../../services/sales.dart';

class GenerateExcel extends StatefulWidget {
  String chosenBrand;
  GenerateExcel({required this.chosenBrand});

  @override
  State<GenerateExcel> createState() => _GenerateExcelState();
}

class _GenerateExcelState extends State<GenerateExcel> {
  late String chosenBrandProper;
  late List<Sales> filtered = [];

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now()
  );

  @override
  initState(){
    super.initState();
    if (widget.chosenBrand == 'l_evaristo') chosenBrandProper = 'L. Evaristo';
    else chosenBrandProper = 'Seacrest';
  }

  Stream<List<Sales>> readSales(){
    return FirebaseFirestore.instance.collection('${widget.chosenBrand}_sales').orderBy('time_date', descending: false).snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Sales.fromJson(doc.data(), doc.id)).toList());
  }

  Future<String?> generateStockName(Sales sale) async{
    Map<String, dynamic> stock = await FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory')
        .doc(sale.stockDocID).get().then((snapshot) => snapshot.data()!);
    return ('${stock['name'] as String}');
  }

  Future<String?> generateStockColor(Sales sale) async{
    Map<String, dynamic> stock = await FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory')
        .doc(sale.stockDocID).get().then((snapshot) => snapshot.data()!);
    return ('${stock['color'] as String}');
  }

  Future<void> generateFilteredSales() async {
    Stream<List<Sales>> stream = readSales();
    stream.listen((snapshot) async {
      print('snapshot: $snapshot');
      for (int i = 0 ; i<snapshot.length; i++){
        DateTime saleTime = DateTime.parse(snapshot[i].timeDate.toDate().toString());
        print(saleTime);
        if (saleTime.isBefore(dateRange.end) && saleTime.isAfter(dateRange.start)){
          print('pass');
          print('iterated snapshot: ${snapshot[i]}');
          setState(() {
            filtered.add(snapshot[i]);
          });
        }
      }
    });
  }

  Future<void> generateExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    sheet.getRangeByName('A1').columnWidth = 9;
    sheet.getRangeByName('B1').columnWidth = 9;
    sheet.getRangeByName('C1').columnWidth = 9;
    sheet.getRangeByName('D1').columnWidth = 9;
    sheet.getRangeByName('E1').columnWidth = 10;
    sheet.getRangeByName('F1').columnWidth = 15;
    sheet.getRangeByName('G1').columnWidth = 15;

    sheet.getRangeByName('A1').setText('$chosenBrandProper Sales Report');
    sheet.getRangeByName('F1').setText('Start Date');
    sheet.getRangeByName('F2').setDateTime(dateRange.start);
    sheet.getRangeByName('G1').setText('End Date');
    sheet.getRangeByName('G2').setDateTime(dateRange.end);

    sheet.getRangeByName('A3').setText('Model');
    sheet.getRangeByName('B3').setText('Color');
    sheet.getRangeByName('C3').setText('Size');
    sheet.getRangeByName('D3').setText('Quantity');
    sheet.getRangeByName('E3').setText('Price Sold');
    sheet.getRangeByName('F3').setText('Total Amount');
    sheet.getRangeByName('G3').setText('Transaction Date');

    sheet.getRangeByName('A1:C1').merge();

    print('loop time');
    for (int i = 0; i<filtered.length; i++){
      print('looping');
      sheet.getRangeByName('A${i+4}').setText(await generateStockName(filtered[i]));
      sheet.getRangeByName('B${i+4}').setText(await generateStockColor(filtered[i]));
      sheet.getRangeByName('C${i+4}').setText(filtered[i].size);
      sheet.getRangeByName('D${i+4}').setNumber(filtered[i].qty.toDouble());
      sheet.getRangeByName('E${i+4}').setNumber(filtered[i].priceSold.toDouble());
      sheet.getRangeByName('F${i+4}').setNumber((filtered[i].qty * filtered[i].priceSold).toDouble());
      sheet.getRangeByName('G${i+4}').setDateTime(DateTime.parse(filtered[i].timeDate.toDate().toString()));
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getExternalStorageDirectory())!.path;
    print(path);
    final String filename = '${widget.chosenBrand}_salesreport_${
      DateFormat.yMMMd().format(DateTime.now())}.xlsx';
    final String filepath = '$path/$filename';
    final File file = File(filepath);
    print(filepath);
    await file.writeAsBytes(bytes, flush:true);
    //backup
    await FirebaseStorage.instance.ref().child("backups/sales_reports/${widget.chosenBrand}/${filename}").putFile(File(filepath));

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
              Text('Generate Sales Report Excel\n\nSelect Date Range',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text('Range',
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
                        '${dateRange.start.year}/${dateRange.start.month}/${dateRange.start.day} - '
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
                      onPressed: () async {
                        await generateFilteredSales();
                        Fluttertoast.showToast(
                          msg: "Checking for validity...",
                          toastLength: Toast.LENGTH_SHORT,
                          textColor: Colors.black,
                          fontSize: 16,
                          backgroundColor: Colors.grey[200],
                        );
                        await Future.delayed(Duration(seconds:5));
                        if (filtered.isNotEmpty){
                          Fluttertoast.showToast(
                            msg: "Writing file...",
                            toastLength: Toast.LENGTH_SHORT,
                            textColor: Colors.black,
                            fontSize: 16,
                            backgroundColor: Colors.grey[200],
                          );
                          await generateExcel();
                          setState((){filtered = [];});
                          Fluttertoast.showToast(
                            msg: "File saved at App directory",
                            toastLength: Toast.LENGTH_SHORT,
                            textColor: Colors.black,
                            fontSize: 16,
                            backgroundColor: Colors.grey[200],
                          );
                        }
                        else if (filtered.isEmpty) Fluttertoast.showToast(
                          msg: "An error occurred",
                          toastLength: Toast.LENGTH_SHORT,
                          textColor: Colors.black,
                          fontSize: 16,
                          backgroundColor: Colors.grey[200],
                        );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        minimumSize: Size(100, 40)
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //   },
                  //   child: Text(
                  //     'Edit',
                  //   ),
                  // ),
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
