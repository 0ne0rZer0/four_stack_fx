import 'package:flutter/material.dart';
import 'package:four_stack_fx/api/sarrafchi.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SarrafchiAPI sarrafchiAPI = SarrafchiAPI();
    sarrafchiAPI.getLatest(quote: 'US Dollar', base: 'Indian Rupee');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF151E28),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Four Stack FX',
            style: TextStyle(fontWeight: FontWeight.w100)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            'Always get the Best Forex Rates',
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.w100),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Find out the best LPs for you in the market',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
          ),
          SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropDownMenu(hint: "From"),
              DropDownMenu(hint: "To"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Quantity',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  final String hint;
  DropDownMenu({this.hint = ""});
  @override
  _DropDownMenuState createState() => _DropDownMenuState(hint: hint);
}

class _DropDownMenuState extends State<DropDownMenu> {
  String selectedFrom = 'INR';
  String selectedTo = 'USD';
  var currencies = [
    "USD",
    "INR",
    "EUR",
  ];
  String hint = "";
  _DropDownMenuState({this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint),
        SizedBox(
          height: 10,
        ),
        DropdownButton<String>(
          items: currencies
              .map(
                (name) => DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                ),
              )
              .toList(),
          onChanged: (String name) {
            setState(() {
              selectedTo = name;
            });
          },
          value: selectedTo,
          elevation: 0,
        ),
      ],
    );
  }
}
