import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoebusiness_manager/screens/manage_orders/add_per_order.dart';
import 'package:shoebusiness_manager/screens/manage_orders/edit_orders.dart';
import 'package:shoebusiness_manager/screens/manage_orders/view_orders.dart';
import 'package:shoebusiness_manager/services/customer.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../../services/order.dart';



class ManageOrders extends StatefulWidget {
  late bool chosenstatus;
  ManageOrders({Key? key, required this.chosenstatus}) : super(key: key);
  @override
  State<ManageOrders> createState() => _ManageOrdersState();

}

class _ManageOrdersState extends State<ManageOrders> {


  TextEditingController searchController = TextEditingController();
  late bool getStatus;
  @override
  initState() {
    super.initState();
    getStatus = widget.chosenstatus;
  }

  Future<void> uploadReportData(Map<String,dynamic> order) async {
    String uploadSize = order['size'].toString();
    Map<String,dynamic> salesData = {
      'brand' : 'seacrest',
      'price_sold' : order['price_sold'],
      'qty' : order['qty'],
      'size' : uploadSize,
      'stock_docID' : order['docID'],
      'time_date' : FieldValue.serverTimestamp()
    };
    FirebaseFirestore.instance.collection('seacrest_sales').add(salesData).
    then((documentSnapshot) => print("Reported sales with ID: ${documentSnapshot.id}"));
  }

  Stream<List<Customer>> readOrder(){
    return FirebaseFirestore.instance.
    collection('seacrest_orders').where('completed', isEqualTo :getStatus).
    snapshots().
    map((snapshot) => snapshot.docs.map((doc) {
      return Customer.fromJson(doc.data(),doc.id);
    }).toList());
  }

  Future<void> deleteOrderInDatabase(Customer customer) async {
    FirebaseFirestore.instance.collection('seacrest_orders').doc(customer.customerDocID).delete();
  }
  
  Future<void> dismissOrderInDatabase(Customer customer) async {
    await FirebaseFirestore.instance.collection('seacrest_orders').doc(customer.customerDocID).update({'completed' : true});
    if (customer.orders.isNotEmpty) {
      for (int i = 0; i < customer.orders.length; i++){
        final doc = FirebaseFirestore.instance.collection('seacrest_inventory').doc(customer.orders[i]['docID']);
        Map<String,dynamic>? stock = await doc.get().then((snapshot) => snapshot.data());
        int ordersize = customer.orders[i]['size'];
        int orderqty = customer.orders[i]['qty'];
        int qtyForSize = stock?['size_qty']['${ordersize}'] as int;
        int newQty = qtyForSize - orderqty;
        doc.update({'size_qty.${ordersize}' : newQty});
        print('doc updated');



        //report sales
        String uploadSize = customer.orders[i]['size'].toString();
        Map<String,dynamic> salesData = {
          'brand' : 'seacrest',
          'price_sold' : customer.orders[i]['price_sold'],
          'qty' : customer.orders[i]['qty'],
          'size' : uploadSize,
          'stock_docID' : customer.orders[i]['docID'],
          'time_date' : FieldValue.serverTimestamp()
        };
        await FirebaseFirestore.instance.collection('seacrest_sales').add(salesData).
        then((documentSnapshot) => print("Reported sales with ID: ${documentSnapshot.id}"));
        print('order reported');
      }
    }
  }

  List<String> items = List.generate(
    15,
        (index) => 'Item ${index + 1}',
  );



  Widget buildCard(BuildContext context, Customer customer){
    return Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<List<Customer>>(
              stream: readOrder(),
              builder: (context, snapshot) {
                return Row(
                  children: [
                    Expanded (
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${customer.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Address: ${customer.address}'),
                              Text('Contact Number: ${customer.number}'),
                              Text('Added on: ${DateFormat.yMMMd().add_jm().format(customer.date.toDate())}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(onPressed: (){
                                    showAlertDialogDelete(context, customer);
                                  }, child: Text('Delete')
                                  , style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          onPrimary: Colors.white,
                                          minimumSize: Size(50, 40)
                                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0))),
                                  if (!widget.chosenstatus) ElevatedButton(onPressed: (){
                                    showAlertDialogDismiss(context, customer);
                                  }, child: Text('Dismiss'),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.amber,
                                          onPrimary: Colors.white,
                                          minimumSize: Size(50, 40)
                                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0))),
                                  IconButton(
                                    onPressed: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => EditOrders(currentCustomer: customer)));
                                      // ADD FUNCTION, REDIRECT TO EDIT STOCK SCREEN
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => ViewOrders(currentCustomer: customer)));
                                      // ADD FUNCTION, REDIRECT TO EDIT STOCK SCREEN
                                    },
                                    icon: Icon(Icons.view_agenda),
                                  ),
                                ],
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
      floatingActionButton: FloatingActionButton(
          highlightElevation: 0,
          elevation: 0,
          shape: CircleBorder(),
          child : Text('Add',
              style: TextStyle(color: Colors.white)),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPerOrder(chosenBrand: 'seacrest')));
          }
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 80, 30, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Manage Orders',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              ),
              textDirection: ui.TextDirection.ltr,
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
                        labelText: 'Search Order',
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
                  child: StreamBuilder(
                      stream: readOrder(),
                      builder: (context, snapshot){
                        if (snapshot.hasData){
                          print("snapshot has data xdddddddddddddddddddddddddddd");
                          final customer = snapshot.data! as List<Customer>;
                          List<Customer> filteredStocks = [];
                          for (int i = 0; i< customer.length; i++){
                            String sample = customer[i].name.toLowerCase() + ' ' + customer[i].address.toLowerCase() + ' ' + customer[i].number.toLowerCase();
                            String input = searchController.text.toLowerCase();
                            if (sample.contains(input)) filteredStocks.add(customer[i]);
                          }
                          return ListView(
                            children: filteredStocks.map((stock)=> buildCard(context, stock)).toList(),
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
        ),
      ),
    );
  }
  showAlertDialogDelete(BuildContext context, Customer customer) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () async {
        await deleteOrderInDatabase(customer);
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
      content: Text("Are you sure you want to delete\n${customer.name}?"),
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

  showAlertDialogDismiss(BuildContext context, Customer customer) {
    final dialogContextCompleter = Completer<BuildContext>();
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        await dismissOrderInDatabase(customer);
        final dialogContext = await dialogContextCompleter.future;
        Navigator.pop(dialogContext);
        Fluttertoast.showToast(
          msg: "Dismissed successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.black,
          fontSize: 16,
          backgroundColor: Colors.grey[200],
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Dismiss"),
      content: Text("Are you sure you want to dismiss\n${customer.name}?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );


    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if(!dialogContextCompleter.isCompleted) {
          dialogContextCompleter.complete(context);
        }
        return alert;
      },
    );
  }
}
