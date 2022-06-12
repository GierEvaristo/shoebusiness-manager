import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/services/stock.dart';

class EditStock extends StatefulWidget {
  Stock currentStock;
  EditStock({Key? key, required this.currentStock}) : super(key: key);

  @override
  State<EditStock> createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(child: Text(widget.currentStock.docID)),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                'Back',
              ),
            )
          ],
        ),
      )
    );
  }
}
