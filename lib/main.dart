import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:four_stack_fx/api/sarrafchi.dart';
import 'package:four_stack_fx/color.dart';
import 'package:four_stack_fx/screens/aggregator_screen.dart';
import 'package:four_stack_fx/screens/data_sample.dart';

void main() {
  runApp(App());
}

String selectedFrom = 'INR';
String selectedTo = 'USD';
double amount = 0;
var currencies = [
  "USD",
  "EUR",
  "GBP",
  "INR",
  "HKD",
  "SEK",
  "CHF",
  "CAD",
  "AUD",
  "AED",
];

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryDarkColor,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isVisible = false;
  setFrom(String name2) {
    setState(() {
      selectedFrom = name2;
    });
  }

  setTo(String name) {
    setState(() {
      selectedTo = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Four Stack FX',
            style: TextStyle(fontWeight: FontWeight.w100)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
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
                'Find out the best Liquidity Providers for you in the market',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
              ),
              SizedBox(
                height: 70,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropDownMenu(hint: "From", callback: setFrom, value: 1),
                    DropDownMenu(
                      hint: "To",
                      callback: setTo,
                      value: 2,
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  height: 100,
                  width: 200,
                  child: TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Enter Amount',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onChanged: (String amountInput) {
                      setState(() {
                        amount = double.parse(amountInput);
                      });
                    },
                  ),
                ),
              ),
              RaisedButton(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  'Check Rates',
                  style: TextStyle(color: Colors.white),
                ),
                color: kPrimaryDarkColor,
                onPressed: () {
                  debugPrint(selectedFrom);
                  debugPrint(selectedTo);
                  debugPrint(amount.toString());
                  // Scrollable.ensureVisible(dataKey.currentContext);
                  // isVisible = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AggregatorPage(
                        amount: amount,
                        fromCur: selectedFrom,
                        toCur: selectedTo,
                      ),
                    ),
                  );
                },
              ),
              // Visibility(
              //   visible: isVisible,
              //   child: AggregatorPage(
              //     key: dataKey,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  final Function callback;
  final String hint;
  final int value;
  DropDownMenu({this.hint = "", this.callback, this.value});
  @override
  _DropDownMenuState createState() =>
      _DropDownMenuState(hint: hint, callback: this.callback, value: value);
}

class _DropDownMenuState extends State<DropDownMenu> {
  String hint = "";
  Function callback;
  int value;
  _DropDownMenuState({this.hint, this.callback, this.value});

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
              callback(name);
            });
          },
          value: value == 1 ? selectedFrom : selectedTo,
          elevation: 0,
        ),
      ],
    );
  }
}
