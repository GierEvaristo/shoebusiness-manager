import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoebusiness_manager/screens/inventory_menu/view_stock.dart';
import 'package:shoebusiness_manager/services/stock.dart';

import 'add_products.dart';
import 'edit_stock.dart';

class Inventory extends StatefulWidget {
  String chosenBrand;
  Inventory({Key? key, required this.chosenBrand}) : super(key: key);
  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late Future<bool> admin;
  TextEditingController searchController = TextEditingController();

  initState()  {
    super.initState();
    setState((){
      admin = checkRole();
    });
  }

  Future<void> deleteStockInDatabase(Stock stock) async {
    FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory').doc(stock.docID).delete();
    FirebaseStorage.instance.ref().child("images/${widget.chosenBrand}/${stock.filename}").delete();
  }

  Future<bool> checkRole() async{
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    return snapshot['admin']!;
  }

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
                                    FutureBuilder<bool>(
                                      future: admin,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData && snapshot.data == true){
                                          return ElevatedButton(
                                              onPressed: () {
                                                showAlertDialogDelete(context, stock);
                                              },
                                              child: Text('Delete'),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  onPrimary: Colors.white)
                                          );
                                        }
                                        else return Container();
                                      }
                                    ),

                                    SizedBox(width: 10),
                                    IconButton(
                                      onPressed: (){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => ViewStock(currentStock: stock)));
                                        // ADD FUNCTION, REDIRECT TO EDIT STOCK SCREEN
                                      },
                                      icon: Icon(Icons.view_agenda),
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                        onPressed: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => EditStock(currentStock: stock)));
                                          // ADD FUNCTION, REDIRECT TO EDIT STOCK SCREEN
                                        },
                                        icon: Icon(Icons.edit),
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
      floatingActionButton: FutureBuilder<bool>(
        future: checkRole(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data == true){
            return FloatingActionButton(
                shape: CircleBorder(),
                child : Icon(Icons.add, color: Colors.white),
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddProducts(chosenBrand: widget.chosenBrand)));
                }
            );
          }
          else return Container();
        }
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 80, 15, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Manage Inventory',
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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.amber,
                        onPrimary: Colors.white
                    ),
                    child: Text(
                      'Back',
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialogDelete(BuildContext context, Stock stock) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () async {
        await deleteStockInDatabase(stock);
        Fluttertoast.showToast(
          msg: "Deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.black,
          fontSize: 16,
          backgroundColor: Colors.grey[200],
        );
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete\n${stock.name} : ${stock.color} ?"),
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
