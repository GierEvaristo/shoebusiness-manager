import 'package:flutter/material.dart';


class ReportSales extends StatefulWidget {
  const ReportSales({Key? key}) : super(key: key);

  @override
  State<ReportSales> createState() => _ReportSalesState();
}

class _ReportSalesState extends State<ReportSales> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Report Sales',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                textDirection: TextDirection.ltr,
                ),
                MyDropDown(title: 'Stock'),
                MyDropDown(title: 'Color'),
                MyDropDown(title: 'Size'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text('Price sold',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          )),
                    ),
                    Flexible(child: SizedBox(width: 20)),
                    Flexible(
                      flex:4,
                      child: TextField( // email
                        onChanged: (val){},
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20)
                        ),
                      ),
                    )
                  ],
                )

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
  final items = ['item 1', 'item 2', 'item 3', 'item 4', 'item 5'];
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


