import 'package:flutter/material.dart';
import '../../services/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoebusiness_manager/screens/manage_orders/add_items_order.dart';
import '../../services/order.dart';
import 'package:fluttertoast/fluttertoast.dart';





class EditOrders extends StatefulWidget {
  late Customer currentCustomer;
  EditOrders({Key? key, required this.currentCustomer}) : super(key: key);
  @override
  State<EditOrders> createState() => _EditOrdersState();
}

class _EditOrdersState extends State<EditOrders> {
  late String customerID;
  late Future<Customer?> dataFuture;


  @override
  initState(){
    super.initState();
    customerID = widget.currentCustomer.customerDocID;
    dataFuture = readCustomer();
  }

  Future<Customer?> readCustomer() async{
    final docCustomer = FirebaseFirestore.instance.collection('seacrest_orders').doc(customerID);
    final snapshot = await docCustomer.get();
    if (snapshot.exists){
      return Customer.fromJson(snapshot.data()!, customerID);
    }
  }

  bool checkForOrderEquality(Order order1, Order order2){
    if (order1.docID == order2.docID &&
        order1.size == order2.size &&
        order1.price == order2.price &&
        order1.qty == order2.qty) return true;
    else return false;
  }

  Future<void> deleteOrderInDatabase(Order order) async {
    Map<String,dynamic> customerInfo = await FirebaseFirestore.instance.
    collection('seacrest_orders').doc(widget.currentCustomer.customerDocID).get().then((snapshot) => snapshot.data()!);
    List<dynamic> customerOrders = customerInfo['orders'];

    List<dynamic> newOrders = [];

    for (final item in customerOrders){
      Order temp = Order(docID: item['docID'], size: item['size'], qty: item['qty'], price: item['price_sold']);
      if (!checkForOrderEquality(temp, order)){
        newOrders.add(item);
      }
    }

    print(newOrders);

    FirebaseFirestore.instance.collection('seacrest_orders').
    doc(widget.currentCustomer.customerDocID).update({'orders' : newOrders});

  }

  Future<String> getStockName(Order order) async {
    String stockDocID = order.docID;
    Map<String,dynamic> stockFields = await FirebaseFirestore.instance.collection('seacrest_inventory').doc(stockDocID).get()
        .then((snapshot) => snapshot.data()!);
    return stockFields['name'];
  }

  Future<String> getStockColor(Order order) async {
    String stockDocID = order.docID;
    Map<String,dynamic> stockFields = await FirebaseFirestore.instance.collection('seacrest_inventory').doc(stockDocID).get()
        .then((snapshot) => snapshot.data()!);
    return stockFields['color'];
  }

  Future<List<String>> getStockNameAndColor(Order order) async {
    String stockDocID = order.docID;
    Map<String,dynamic> stockFields = await FirebaseFirestore.instance.collection('seacrest_inventory').doc(stockDocID).get()
        .then((snapshot) => snapshot.data()!);
    return [stockFields['name'], stockFields['color']];
  }

  Widget buildCard(Order order){
    return Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded (
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                            future: getStockName(order),
                            builder: (context, snapshot) {
                              if (snapshot.hasData){
                                return Text('Name: ${snapshot.data!}', style: TextStyle(fontWeight: FontWeight.bold));
                              }
                              else {
                                return Text('...', style: TextStyle(fontWeight: FontWeight.bold));
                              }
                            }
                        ),
                        FutureBuilder<String>(
                            future: getStockColor(order),
                            builder: (context, snapshot) {
                              if (snapshot.hasData){
                                return Container(child: Text('Color: ${snapshot.data!}', style: TextStyle(fontWeight: FontWeight.bold)));
                              }
                              else {
                                return Text('...', style: TextStyle(fontWeight: FontWeight.bold));
                              }
                            }
                        ),
                        Text('Size: ${order.size}'),
                        Text('Quantity: ${order.qty}'),
                        Text('Price: ${order.price}'),
                      ]
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(onPressed: (){
                            showAlertDialogDelete(context, order);
                          }, child: Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                  minimumSize: Size(100, 40)
                              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0))),
                        ]
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget buildBody(Customer customer){
    List<Widget> cardList = [];
    customer.orders.forEach((element) {
      cardList.add(buildCard(
          Order(
              docID: element['docID'],
              size: element['size'],
              qty: element['qty'],
              price: element['price_sold']
          )
      ));
    });

    for (int i = 0 ; i<cardList.length; i++){
      print(cardList);
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: cardList,
        ),
      ),
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
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddItemsOrder(chosencustomer: widget.currentCustomer))).then((_) =>
              setState((){dataFuture = readCustomer();}));
            }
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<dynamic>(
                    future: dataFuture,
                    builder: (context,snapshot) {
                      if (snapshot.hasData) {
                        Customer? customer = snapshot.data;
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 150,
                                child: Column (
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Name: ${customer!.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Address: ${customer.address}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('Contact Number: ${customer.number}', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Center(child: Container(margin: EdgeInsets.all(50),child: CircularProgressIndicator()));
                      }
                    }
                ),

                FutureBuilder<Customer?>(
                    future: dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData){
                        final customer_orders = snapshot.data;
                        return customer_orders == null ? Center(child: CircularProgressIndicator()) : buildBody(customer_orders);
                      }
                      else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back',
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            minimumSize: Size(100, 40)
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0))
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  showAlertDialogDelete(BuildContext context, Order order) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () async {
        await deleteOrderInDatabase(order);
        Fluttertoast.showToast(
          msg: "Deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.black,
          fontSize: 16,
          backgroundColor: Colors.grey[200],
        );
        Navigator.of(context).pop();
        setState((){dataFuture = readCustomer();});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: FutureBuilder<List<String>>(
        future: getStockNameAndColor(order),
        builder: (context, snapshot){
          if (snapshot.hasData) return Text("Are you sure you want to delete\n${snapshot.data![0]} - ${snapshot.data![1]}?");
          else return Text("Are you sure you want to delete\nNaN?");
        }
      ),
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
