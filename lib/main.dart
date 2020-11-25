import 'package:flutter/material.dart';
import 'package:four_stack_fx/api/sarrafchi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SarrafchiAPI sarrafchiAPI = SarrafchiAPI();
    sarrafchiAPI.getLatest(quote: 'US Dollar', base: 'Indian Rupee');
    var currencies = [
      "USD",
      "INR",
      "EUR",
    ];
    String selectedFrom = "USD";
    String selectedTo = "USD";
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFF151E28),
        ),
        home: Scaffold(
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
                'Always get the Best Forex Rate',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From'),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        hint: Text("From"),
                        items: currencies
                            .map((name) =>
                                DropdownMenuItem<String>(child: Text(name)))
                            .toList(),
                        onChanged: (String name) {
                          selectedFrom = name;
                        },
                        elevation: 0,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To'),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        items: currencies
                            .map((name) =>
                                DropdownMenuItem<String>(child: Text(name)))
                            .toList(),
                        onChanged: (String name) {
                          selectedTo = name;
                        },
                        elevation: 0,
                      ),
                    ],
                  ),
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
        ));
  }
}
