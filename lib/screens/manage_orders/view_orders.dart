import 'package:flutter/material.dart';
import '../../services/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Customer?>(
        future: dataFuture,
        builder: (context, snapshot){
          if (snapshot.hasData){
            String test = '';
            Customer? customer = snapshot.data;
            print(customer?.orders);
            print(customer?.orders[0]['size']);
            //customer!.orders.forEach((element) {test+=element['color'];});
            return Text(test);
          }
          else return Text('No data');
        }
      ),
    );
  }
}
