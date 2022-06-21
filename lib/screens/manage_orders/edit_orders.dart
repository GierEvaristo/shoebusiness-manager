import 'package:flutter/material.dart';
import 'package:image/image.dart';
import '../../services/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoebusiness_manager/screens/inventory_menu/inventory.dart';

import '../../services/order.dart';
import '../../services/stock.dart';



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
    dataFuture= readCustomer();
  }

  Future<Customer?> readCustomer() async{
    final docCustomer = FirebaseFirestore.instance.collection('seacrest_orders').doc(customerID);
    final snapshot = await docCustomer.get();
    if (snapshot.exists){
      return Customer.fromJson(snapshot.data()!, customerID);
    }
  }

  Future<void> deleteOrderInDatabase(Customer customer) async {
    FirebaseFirestore.instance.collection('seacrest_orders').doc(customer.customerDocID).delete();
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

  Widget buildCard(Order order){
    return Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Flexible (
                flex:10,
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
              Flexible (
                flex:10,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(onPressed: (

                                ){
                            }, child: Text('Delete')),
                          ]
                      ),
                    ],
                  ),
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
            shape: CircleBorder(),
            child : Text('Add',
                style: TextStyle(color: Colors.white)),
            onPressed: (){}
        ),
        body: SafeArea(
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
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
