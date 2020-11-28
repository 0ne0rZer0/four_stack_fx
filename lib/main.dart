import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:four_stack_fx/color.dart';
import 'package:four_stack_fx/screens/aggregator_screen.dart';
import 'screens/liquidty_info_screen.dart';

//
void main() {
  runApp(App());
}

String selectedFrom = 'EUR';
String selectedTo = 'GBP';
double amount = 1;
DateTime selectedDate = DateTime.now();
var fromCurrencies = [
  "USD",
  "EUR",
  "GBP",
];
var toCurrencies = [
  "GBP",
  "AUD",
  "CAD",
  "CHF",
  "SEF",
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now(),
      helpText: "Upto last week",
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AggregatorPage(
              amount: amount,
              fromCur: selectedFrom,
              toCur: selectedTo,
              dateTime: selectedDate,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Four Stacks FX',
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
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  'Check Old Rates',
                  style: TextStyle(color: Colors.white),
                ),
                color: kPrimaryDarkColor,
                onPressed: () async {
                  debugPrint(selectedFrom);
                  debugPrint(selectedTo);
                  debugPrint(amount.toString());
                  await _selectDate(context);
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
          items: value == 1
              ? fromCurrencies
                  .map(
                    (name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    ),
                  )
                  .toList()
              : toCurrencies
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
