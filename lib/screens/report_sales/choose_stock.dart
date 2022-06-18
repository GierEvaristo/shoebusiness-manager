import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoebusiness_manager/screens/inventory_menu/view_stock.dart';
import 'package:shoebusiness_manager/services/stock.dart';

class ChooseStock extends StatefulWidget {
  String chosenBrand;
  ChooseStock({Key? key, required this.chosenBrand}) : super(key: key);
  @override
  State<ChooseStock> createState() => _ChooseStockState();
}

class _ChooseStockState extends State<ChooseStock> {
  TextEditingController searchController = TextEditingController();


  Stream<List<Stock>> readStocks(){
    return FirebaseFirestore.instance.
    collection('${widget.chosenBrand}_inventory').
    snapshots().
    map((snapshot) => snapshot.docs.map((doc) {
      return Stock.fromJson(doc.data(),doc.id);
    }).toList());
  }

  List<String> items = List.generate(
    15,
    (index) => 'Item ${index + 1}',
  );

  Widget buildCard(Stock stock){
    return Card(
      color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<List<Stock>>(
              stream: readStocks(),
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        child: FutureBuilder<String>(
                          future: stock.generateURL(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) return Container(width: 300,
                                 child: Image.network(snapshot.data.toString()));
                            else return Center(child: CircularProgressIndicator());
                          }
                        ),
                      ),
                    ),
                    Flexible (
                      flex:6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Model: ${stock.name.toString()}', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Color: ${stock.color.toString()}'),
                              Text('SRP: ${stock.srp.toString()}'),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context,stock.docID);
                                      },
                                      child: Text('Choose'),
                                      style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      onPrimary: Colors.white)
                                    ),
                                  ],
                                ),
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                );
              }
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 80, 15, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Choose Stock',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              ),
              textDirection: TextDirection.ltr,
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: searchController,
                      onChanged: (val){setState((){});},
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'Search Model',
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon:Icon(
                    Icons.search
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                child: StreamBuilder<List<Stock>>(
                  stream: readStocks(),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      print("snapshot has data xdddddddddddddddddddddddddddd");
                      final stocks = snapshot.data!;
                      List<Stock> filteredStocks = [];
                      for (int i = 0; i< stocks.length; i++){
                        String sample = stocks[i].name.toLowerCase() + ' ' + stocks[i].color.toLowerCase();
                        String input = searchController.text.toLowerCase();
                        if (sample.contains(input)) filteredStocks.add(stocks[i]);
                      }
                      return ListView(
                        children: filteredStocks.map(buildCard).toList(),
                      );
                    } else {
                      print("snapshot has NO data xdddddddddddddddddddddddddddd");
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                )
              ),
            ),
            SizedBox(height: 20),
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
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

}
