import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  Stream<List<Sales>> readSales(){
    return FirebaseFirestore.instance.collection('${widget.chosenBrand}_sales').snapshots().
    map((snapshot) =>
        snapshot.docs.map((doc) => Sales.fromJson(doc.data(), doc.id)).toList());
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
                        Text(sale.stockDocID, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Price Sold: ${sale.priceSold}"),
                        Text("Quantity: $sale.qty.toString()"),
                        Text("Size: ${sale.size}"),
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
            Text('Track Sales', style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold),
            textDirection: ui.TextDirection.ltr,
            ),
          SizedBox(height: 20),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Back'),
              )
            ]
          ),
          ],
        ),
      ),
    );
  }
}