import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoebusiness_manager/services/stock.dart';

class EditStock extends StatefulWidget {
  Stock currentStock;
  EditStock({Key? key, required this.currentStock}) : super(key: key);

  @override
  State<EditStock> createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {
  late Future<Stock?> dataFuture;
  late String stockID;
  late String stockBrand;
  late String stockBrandProper;
  late List<TextEditingController> controllers = [];
  late List<int> quantities = [];

  @override
  initState() {
    super.initState();
    stockID = widget.currentStock.docID;
    stockBrand = widget.currentStock.brand;
    dataFuture = readStock();
    if (stockBrand == 'l_evaristo'){
      stockBrandProper = 'L. Evaristo';
    }
    else {
      stockBrandProper = 'Seacrest';
    }
  }

  Future<Stock?> readStock() async{
    final docStock = FirebaseFirestore.instance.collection('${stockBrand}_inventory').doc(stockID);
    final snapshot = await docStock.get();

    if (snapshot.exists){
      return Stock.fromJson(snapshot.data()!, stockID);
    }
  }

  Widget buildCard(String size, int qty){

    final controller = TextEditingController();
    controller.text = qty.toString();
    controllers.add(controller);
    quantities.add(qty);

    return Card(
      child: ListTile(
        title: Text('Size: ${size}'),
        trailing: Row (
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              splashRadius: 20,
              icon: Icon(Icons.remove),
              onPressed: (){
                controller.text = (int.parse(controller.text) - 1).toString();
              },
            ),
            Container(
              width: 60,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: (val){},
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: ('Qty.'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5)
                ),
              ),
            ),
            IconButton(
              splashRadius: 20,
              icon: Icon(Icons.add),
              onPressed: (){
                 controller.text = (int.parse(controller.text) + 1).toString();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody(Stock stock){
    List<Widget> cardList = [];
    stock.size_qty.forEach((key, value) {
      cardList.add(buildCard(key, value));
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

  List<double> sizesToChange(){
    List<double> sizes = [];
    for (int i = 0; i<quantities.length; i++){
      if (quantities[i] != int.parse(controllers[i].text)){
        sizes.add(i/2 + 5);
      }
    }
    return sizes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                future: widget.currentStock.generateURL(),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Container(
                          width: 150,
                          child: Image.network(snapshot.data.toString())
                        )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 150,
                        child: Column (
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stockBrandProper),
                            Text('Model: ${widget.currentStock.name}'),
                            Text('Color: ${widget.currentStock.color}')
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

              FutureBuilder<Stock?>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    final stock = snapshot.data;
                    return stock == null ? Center(child: CircularProgressIndicator()) : buildBody(stock);
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
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        minimumSize: Size(100, 40)
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    child: Text(
                      'Back',
                    ),
                  ),

                  SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: (){
                      if (sizesToChange().isEmpty){
                        Fluttertoast.showToast(
                          msg: "Nothing to save",
                          toastLength: Toast.LENGTH_SHORT,
                          textColor: Colors.black,
                          fontSize: 16,
                          backgroundColor: Colors.grey[200],
                        );
                      }
                      else showAlertDialogEdit(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        onPrimary: Colors.white,
                        minimumSize: Size(100, 40)
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    child: Text(
                      'Save',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  String generateMessage(){
    String displayText = 'Would you like to save changes?\n\n';
    List<double> sizes = sizesToChange();
    for (int i = 0; i<sizes.length; i++){
      int controllerIndex = ((sizes[i] - 5)*2).toInt();
      displayText += 'Size: ${sizes[i]} | Previous: ${widget.currentStock.size_qty['${sizes[i]}']} | New: ${controllers[controllerIndex].text}\n';
    }
    return displayText;
  }

  Future<void> updateStock() async{
    List<double> sizes = sizesToChange();
    List<String> sizeRef = sizes.map((size) => size.toString().replaceAll('.', '')).toList();
    final doc = FirebaseFirestore.instance.collection('${stockBrand}_inventory').doc(stockID);
    for (int i = 0; i<sizes.length; i++){
      int controllerIndex = ((sizes[i] - 5)*2).toInt();
      await doc.update({'size_qty.${sizeRef[i]}' : int.parse(controllers[controllerIndex].text)});
    }
  }

  showAlertDialogEdit(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () async {
        await updateStock();
        Fluttertoast.showToast(
          msg: "Saved successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.black,
          fontSize: 16,
          backgroundColor: Colors.grey[200],
        );
        Navigator.of(context).pop();
        await Future.delayed(Duration(milliseconds: 500), (){
          Navigator.of(context).pop();
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Save changes"),
      content: Text(generateMessage()),
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
