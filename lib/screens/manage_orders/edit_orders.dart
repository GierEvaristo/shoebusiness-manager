import 'package:flutter/material.dart';
import 'package:image/image.dart';
import '../../services/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoebusiness_manager/screens/inventory_menu/inventory.dart';

import '../../services/stock.dart';



class ViewOrders extends StatefulWidget {
  late Customer currentCustomer;
  ViewOrders({Key? key, required this.currentCustomer}) : super(key: key);
  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  late String customerID;
  late Future<Customer?> dataFuture;


  @override
  initState(){
    super.initState();
    customerID = widget.currentCustomer.docID;
    dataFuture= readCustomer();
  }

  Future<Customer?> readCustomer() async{
    final docCustomer = FirebaseFirestore.instance.collection('seacrest_orders').doc(customerID);
    final snapshot = await docCustomer.get();
    if (snapshot.exists){
      return Customer.fromJson(snapshot.data()!, customerID);
    }
  }

  Widget buildCard(String model, String color, int size, int qty, int price){

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
                        Text('Model: ${model}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Color: ${color}'),
                        Text('Size: ${size}'),
                        Text('Quantity: ${qty}'),
                        Text('Price: ${price}'),
                      ]
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
  Widget buildBody(Customer customer){
    List<Widget> cardList = [];
    customer.orders.forEach((element) {
      cardList.add(buildCard( element['model'], element['color'],element['size'], element['qty'], element['price_sold']));
    });

    for (int i = 0 ; i<cardList.length; i++){
      print(cardList);
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              children: [
                ListView(
                  children: cardList,
                ),
              ],
            ),
            Column(

            ),
          ],
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
              FutureBuilder<dynamic>(
                  future: dataFuture,
                  builder: (context,snapshot) {
                    if (snapshot.hasData) {
                      Customer? customer = snapshot.data;
                      return Row(
                        children: [
                          Container(
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              )
            ],
          ),
        )
    );
  }
}
