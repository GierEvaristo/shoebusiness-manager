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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    child: TextField( // email
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
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  padding:  EdgeInsets.all(8),
                  itemCount: items.length + 1,
                  itemBuilder: (conext, index){
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text(
                    'Back',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text(
                    'Edit',
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
