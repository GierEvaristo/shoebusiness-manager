import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shoebusiness_manager/screens/report_sales/choose_stock.dart';

import '../../services/stock.dart';


class ReportSales extends StatefulWidget {
  late String chosenBrand;
  ReportSales({required this.chosenBrand});

  @override
  State<ReportSales> createState() => _ReportSalesState();
}

class _ReportSalesState extends State<ReportSales> {
  List<String> sizes = [];
  String? chosenSize;
  String chosenBrandProper = '';
  String itemName = 'Choose';
  String? docID;
  TextEditingController priceSoldController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  @override
  initState(){
    super.initState();
    for (double i = 5.0; i<=12.0; i+=0.5){
      sizes.add(i.toString());
    }
    if (widget.chosenBrand == 'l_evaristo') chosenBrandProper = 'L. Evaristo';
    else chosenBrandProper = 'Seacrest';
  }

  Future<void> uploadData() async {
    String uploadSize = chosenSize!.replaceAll('.', '');
    Map<String,dynamic> salesData = {
      'brand' : widget.chosenBrand,
      'price_sold' : int.parse(priceSoldController.text),
      'qty' : int.parse(qtyController.text),
      'size' : uploadSize,
      'stock_docID' : docID,
      'time_date' : FieldValue.serverTimestamp()
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(
                child: CircularProgressIndicator()
            )
    );
    await FirebaseFirestore.instance.collection('${widget.chosenBrand}_sales').add(salesData).
    then((documentSnapshot) => print("Reported sales with ID: ${documentSnapshot.id}"));

    final doc = FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory').doc(docID);
    Map<String,dynamic> stock = await doc.get().then((snapshot) => snapshot.data()!);
    print(stock);
    print(uploadSize);
    int qtyForSize = stock['size_qty']['$uploadSize'] as int;
    int newQty = qtyForSize - int.parse(qtyController.text);
    await doc.update({'size_qty.${uploadSize}' : newQty});

    Fluttertoast.showToast(
      msg: "Reported successfully and stock deducted in inventory",
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.black,
      fontSize: 16,
      backgroundColor: Colors.grey[200],
    );
    Navigator.pop(context);
  }

  DropdownMenuItem<String> buildMenuItem(String item){
    return DropdownMenuItem(
      value: item,
      child: Text(item),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(right: 30, left: 30, top: 90, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Report ${chosenBrandProper} Sales',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text('Stock',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        )
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String? chosenStockID = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              ChooseStock(chosenBrand: widget.chosenBrand)));
                          if (chosenStockID != null){
                            Map<String,dynamic> stock = await
                            FirebaseFirestore.instance.collection('${widget.chosenBrand}_inventory').
                            doc(chosenStockID).get().then((snapshot) => snapshot.data()!);
                            setState((){
                              docID = chosenStockID;
                              itemName = '${stock['name']} - ${stock['color']}';
                            });
                          }

                        },
                        child: Text(
                          '$itemName',
                          textScaleFactor: 1.3,
                        ),
                        style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            primary: Theme.of(context).colorScheme.primary,
                            minimumSize: Size(10, 47)
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      ),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text('Size',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 47,
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black38),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              iconSize: 30,
                              elevation: 2,
                              items: sizes.map(buildMenuItem).toList(),
                              onChanged: (value) => setState(()=> this.chosenSize = value),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(20),
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              value: chosenSize
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:20),
                      child: Text('Quantity',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          )
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: qtyController,
                        onChanged: (val){},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20)
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:20),
                      child: Text('Price Sold',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          )),
                    ),
                    Expanded(
                      child: TextField(
                        controller: priceSoldController,
                        onChanged: (val){},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20)
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back'
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        minimumSize: Size(100, 40)
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        if (docID != null && chosenSize != null && qtyController.text != '' && priceSoldController.text != ''){
                          uploadData();
                        }
                        else {
                          Fluttertoast.showToast(
                            msg: "Please complete the fields",
                            toastLength: Toast.LENGTH_SHORT,
                            textColor: Colors.black,
                            fontSize: 16,
                            backgroundColor: Colors.grey[200],
                          );
                        }
                      },
                      child: Text(
                          'Report'
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          onPrimary: Colors.white,
                          minimumSize: Size(100, 40)
                      ),
                    ),

                  ],
                ),
              ]
            ),
        ),
    );
  }

}

class MyDropDown extends StatefulWidget {
  final String title;

  const MyDropDown({Key?key, required this.title}) : super(key: key);
  State<MyDropDown> createState() => _MyDropDownState();
}


class _MyDropDownState extends State<MyDropDown> {
  final items = ['5.0','5.5'];
  String? value;

  DropdownMenuItem<String> buildMenuItem(String item){
    return DropdownMenuItem(
      value: item,
      child: Text(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Text(widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                )),
          ),
          Flexible(child: SizedBox(width: 20)),
          Flexible(
            flex: 9,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all()
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  iconSize: 30,
                  elevation: 2,
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(()=>this.value = value),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(20),
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  value: value,
                ),
              ),
            ),
          ),
        ]
    );
  }
}


