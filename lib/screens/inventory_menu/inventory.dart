import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/screens/company_menu/company_inventory_menu.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {

  List<String> items = List.generate(
    15,
    (index) => 'Item ${index + 1}',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                child: ListView.builder(
                  padding:  EdgeInsets.all(8),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index){
                    if(index < items.length){
                      final item = items[index];
                      return ListTile(title: Text(item));
                    } else{
                      return  Padding(
                        padding:  EdgeInsets.symmetric(vertical: 32),
                        child:(Center(child:CircularProgressIndicator())),
                      );
                    }
                  },
                ),
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

class ItemCards extends StatelessWidget {
  late Image image;
  late String name;
  late String color;
  ItemCards({required this.image, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          image,
          Column(
            children: [
              Text(name),
              Text(color),
              ElevatedButton(onPressed: (){}, child: Text('Edit'))
            ]
          )
        ],
      )
    );
  }
}
