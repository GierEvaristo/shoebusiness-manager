import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shoebusiness_manager/screens/track_sales/track_sales.dart';
import 'package:shoebusiness_manager/services/sales.dart';
import 'dart:ui' as ui;

class TrackSales extends StatefulWidget{
  String chosenBrand;
  TrackSales({required this.chosenBrand});
  @override
  State<TrackSales> createState() => _TrackSalesState();
}

class _TrackSalesState extends State<TrackSales>{

  late String chosenBrandProper;

  @override
  initState(){
    super.initState();
    if (widget.chosenBrand == 'l_evaristo') chosenBrandProper = 'L. Evaristo';
    else chosenBrandProper = 'Seacrest';
  }

  Stream<List<Sales>> readSales(){
    return FirebaseFirestore.instance.collection('${widget.chosenBrand}_sales').snapshots().
    map((snapshot) =>
        snapshot.docs.map((doc) => Sales.fromJson(doc.data(), doc.id)).toList());
  }

  String convertToProperSize(String size){
    if (size == '50') return '5.0';
    else if (size == '55') return '5.5';
    else if (size == '60') return '6.0';
    else if (size == '65') return '6.5';
    else if (size == '70') return '7.0';
    else if (size == '75') return '7.5';
    else if (size == '80') return '8.0';
    else if (size == '85') return '8.5';
    else if (size == '90') return '9.0';
    else if (size == '95') return '9.5';
    else if (size == '100') return '10.0';
    else if (size == '105') return '10.5';
    else if (size == '110') return '11.0';
    else if (size == '115') return '11.5';
    else return '12.0';
  }

  Future<String?> generateStockName(Sales sale) async{
    Map<String, dynamic> stock = await FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory')
        .doc(sale.stockDocID).get().then((snapshot) => snapshot.data()!);
    return ('${stock['name'] as String} - ${stock['color'] as String}');
  }

  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');

  Widget buildCard(Sales sale){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<List<Sales>>(
          stream: readSales(),
          builder: (context, snapshot) {
            return Row(
              children: [
                Flexible(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:  15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String?>(
                          future: generateStockName(sale),
                          builder: (context, snapshot) {
                            if (snapshot.hasData){
                              return Text(snapshot.data!, style: TextStyle(fontWeight: FontWeight.bold));
                            }
                            else {
                              return Text('...', style: TextStyle(fontWeight: FontWeight.bold));
                            }
                          }
                        ),
                        Text("Price Sold: ${sale.priceSold}"),
                        Text("Quantity: ${sale.qty.toString()}"),
                        Text("Size: ${convertToProperSize(sale.size)}"),
                        Text(DateFormat.yMMMd().add_jm().format(sale.timeDate.toDate()))
                      ]
                    )
                  )

                )
              ]
            );
          }
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(30,80,30,40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('View ${chosenBrandProper} Sales', style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold),
            textDirection: ui.TextDirection.ltr,
            ),
          Expanded(
            child: SizedBox(
              child: StreamBuilder<List<Sales>>(
                stream: readSales(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    print("Snapshot data found!");
                    final sales = snapshot.data!;
                    return ListView(
                      children: sales.map(buildCard).toList()
                    );
                  } else {
                    print("Snapshot data not found!");
                    return Center(child: CircularProgressIndicator());
                  }
                }
              )
            )
          ),
          SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.white
                  ),
                  child: Text(
                    'Back',
                  )
              ),
              SizedBox(width: 20),
              ElevatedButton(
                  onPressed: (){
                    showAlertDialogExcel(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white
                  ),
                  child: Text(
                    'Generate monthly report (Excel)',
                  )
              )
            ]
          ),
          ],
        ),
      ),
    );
  }

  showAlertDialogExcel(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () async {
        Fluttertoast.showToast(
          msg: "Saved successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.black,
          fontSize: 16,
          backgroundColor: Colors.grey[200],
        );
        Navigator.of(context).pop();
        await Future.delayed(Duration(milliseconds: 500), (){
          Navigator.of(context).pop();
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Select month"),
      content: Text('Date'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}