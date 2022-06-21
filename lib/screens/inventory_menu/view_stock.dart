import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoebusiness_manager/services/stock.dart';

class ViewStock extends StatefulWidget {
  Stock currentStock;
  ViewStock({Key? key, required this.currentStock}) : super(key: key);

  @override
  State<ViewStock> createState() => _ViewStockState();
}

class _ViewStockState extends State<ViewStock> {
  late Future<Stock?> dataFuture;
  late String stockID;
  late String stockBrand;
  late String stockBrandProper;
  late List<TextEditingController> controllers = [];
  late List<int> quantities = [];

  @override
  initState() {
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

    return Card(
      child: ListTile(
        title: Text('Size: ${size}'),
        trailing: Text('Quantity: $qty')
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
              )
            ],
          ),
        ),
      )
    );
  }

}
