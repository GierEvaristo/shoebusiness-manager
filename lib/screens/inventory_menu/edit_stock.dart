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
  late String stockID;
  late String stockBrand;
  @override

  initState() {
    stockID = widget.currentStock.docID;
    stockBrand = widget.currentStock.brand;
  }

  Future<Stock?> readStock() async{
    final docStock = FirebaseFirestore.instance.collection('${stockBrand}_inventory').doc(stockID);
    final snapshot = await docStock.get();

    if (snapshot.exists){
      return Stock.fromJson(snapshot.data()!, stockID);
    }
  }

  Widget buildCard(String size, int qty){
    return Card(
      child: ListTile(
        leading: FlutterLogo(),
        title: Text('Size: ${size} | Qty: $qty'),
      ),
    );
  }

  Widget buildBody(Stock stock){
    List<Widget> cardList = [];
    stock.size_qty.forEach((key, value) {
      cardList.add(buildCard(key, value));
    });
    for (int i = 0 ; i<cardList.length; i++){
      print(cardList);
    }
    return Expanded(
      child: Container(
        child: ListView(
          children: cardList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Stock?>(
              future: readStock(),
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  final stock = snapshot.data;
                  return stock == null ? Center(child: Text('Error')) : buildBody(stock);
                }
                else {
                  return Center(child: Container());
                }
              }
            ),

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
