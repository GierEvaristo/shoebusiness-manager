import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/screens/company_menu/company_inventory_menu.dart';
import 'package:shoebusiness_manager/services/stock.dart';

class Inventory extends StatefulWidget {
  String chosenBrand;
  Inventory({Key? key, required this.chosenBrand}) : super(key: key);
  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  Stream<List<Stock>> readStocks(){
    return FirebaseFirestore.instance.
    collection('${widget.chosenBrand}_inventory').
    snapshots().
    map((snapshot) => snapshot.docs.map((doc) => Stock.fromJson(doc.data())).toList());
  }

  List<String> items = List.generate(
    15,
    (index) => 'Item ${index + 1}',
  );

  Widget buildCard(Stock stock){
    return Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<List<Stock>>(
              stream: readStocks(),
              builder: (context, snapshot) {
                return Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: FutureBuilder<String>(
                        future: stock.generateURL(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) return Image.network(snapshot.data.toString());
                          else return Center(child: CircularProgressIndicator());
                        }
                      ),
                    ),
                    Flexible (
                      flex:6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stock.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(stock.color),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(onPressed: (){
                                    // ADD FUNCTION, REDIRECT TO EDIT STOCK SCREEN
                                  }, child: Text('Edit')),
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
        child : Text('Edit',
        style: TextStyle(color: Colors.white)),
        onPressed: (){}
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 80, 30, 40),
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
                      //controller: ,
                      //onChanged: (val){},
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
                      return ListView(
                        children: stocks.map(buildCard).toList(),
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
}


// LEGACY (can be removed if wished)

// class ItemCards extends StatelessWidget {
//   Image image = Image.asset('assets/openeye.png');
//   late String name;
//   late String color;
//
//   ItemCards(Stock stock){
//     name = stock.name;
//     color = stock.color;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(10.0),
//         child: StreamBuilder<Object>(
//           stream: null,
//           builder: (context, snapshot) {
//             return Row(
//               children: [
//                 Flexible(child: image, flex: 3),
//                 Flexible(
//                   flex:6,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(name),
//                       Text(color),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(onPressed: (){}, child: Text('Edit')),
//                         ],
//                       )
//                     ]
//                   ),
//                 )
//               ],
//             );
//           }
//         ),
//       )
//     );
//   }
// }
