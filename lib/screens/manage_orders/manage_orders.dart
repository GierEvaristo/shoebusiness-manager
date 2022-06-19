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


class ManageOrders extends StatefulWidget {
  late bool chosenstatus;
  ManageOrders({Key? key, required this.chosenstatus}) : super(key: key);
  @override
  State<ManageOrders> createState() => _ManageOrdersState();

}

class _ManageOrdersState extends State<ManageOrders> {

  List<Customer> filtered = [];

  @override
  initState() {
    super.initState();
    bool getstatus = widget.chosenstatus;
  }


  Stream<List<Customer>> readOrder(){
    return FirebaseFirestore.instance.
    collection('seacrest_orders').
    snapshots().
    map((snapshot) => snapshot.docs.map((doc) {
      return Customer.fromJson(doc.data(),doc.id);
    }).toList());
  }

  Future<void> deleteOrderInDatabase(Customer customer) async {
    FirebaseFirestore.instance.collection('seacrest_orders').doc(customer.docID).delete();
  }


  List<String> items = List.generate(
    15,
        (index) => 'Item ${index + 1}',
  );



  Widget buildCard(Customer customer){
    return Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<List<Customer>>(
              stream: readOrder(),
              builder: (context, snapshot) {
                return Row(
                  children: [
                    Flexible (
                      flex:6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${customer.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Address: ${customer.address}'),
                              Text('Contact Number: ${customer.number}'),
                              Text('Date: ${DateFormat.yMMMd().add_jm().format(customer.date.toDate())}'),
                              Text('Completed: ${customer.status.toString()}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(onPressed: (){
                                    showAlertDialogDelete(context, customer);
                                  }, child: Text('Delete')),
                                  ElevatedButton(onPressed: (){

                                  }, child: Text('Dismiss')),
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
                      //controller: ,
                      //onChanged: (val){},
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
                  child: StreamBuilder<List<Customer>>(
                      stream: readOrder(),
                      builder: (context, snapshot){
                        if (snapshot.hasData){
                          print("snapshot has data xdddddddddddddddddddddddddddd");
                          final customer = snapshot.data!;
                          return ListView(
                            children: customer.map(buildCard).toList(),
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
}
