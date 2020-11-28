import 'package:flutter/material.dart';
import 'package:four_stack_fx/api/mainapi.dart';
import 'package:four_stack_fx/model/currency_rate.dart';
import 'package:four_stack_fx/screens/liquidty_info_screen.dart';
import 'package:responsive_table/DatatableHeader.dart';
import 'package:responsive_table/ResponsiveDatatable.dart';
import 'package:intl/intl.dart';

class AggregatorPage extends StatefulWidget {
  final double amount;
  final String fromCur;
  final String toCur;
  final DateTime dateTime;
  AggregatorPage({this.amount, this.fromCur, this.toCur, this.dateTime});
  @override
  _AggregatorPageState createState() => _AggregatorPageState(
      amount: amount, fromCur: fromCur, toCur: toCur, date: dateTime);
}

class _AggregatorPageState extends State<AggregatorPage> {
  String fromCur;
  String toCur;
  double amount;
  DateTime date = DateTime.now();
  _AggregatorPageState({this.amount, this.fromCur, this.toCur, this.date});
  List<String> lpName = ["CDZ", "ForexFree", "LiveRate", "Oanda", "Traders"];
  List<DatatableHeader> _headers = [
    DatatableHeader(
      text: "ID",
      value: "id",
      show: false,
      flex: 1,
      sortable: true,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Buy Price",
        value: "buyPrice",
        show: true,
        flex: 3,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Sell Price",
        value: "sellPrice",
        show: true,
        flex: 3,
        sortable: true,
        textAlign: TextAlign.left)
  ];
  List<int> _perPages = [5, 10, 15, 100];
  int _total = 100;
  int _currentPerPage;
  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _source = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> _selecteds = List<Map<String, dynamic>>();
  String _selectableKey = "id";

  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;

  initData() async {
    setState(() => _isLoading = true);
    APICall apiCall = APICall();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      String dateString = DateFormat('yyyy-MM-dd')
          .format(date == null ? DateTime.now() : date)
          .toString();
      String currentDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      List<CurrencyRate> lrc;
      dateString = '2020-11-26';
      if (date == null || dateString == currentDate) {
        lrc = await apiCall.getmaindata(fromCur, toCur);
      } else {
        debugPrint(dateString);
        lrc = await apiCall.getGivenDates(fromCur, toCur, dateString);
      }
      for (int i = 0; i < lrc.length; i++) {
        _source.add({
          "id": (i + 1).toString(),
          "name": lpName[i],
          "buyPrice": (double.parse(lrc[i].buy) * amount).toString(),
          "sellPrice": (double.parse(lrc[i].sell) * amount).toString(),
        });
      }
      setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Four Stacks FX',
            style: TextStyle(fontWeight: FontWeight.w100)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(maxHeight: 700),
              child: Card(
                elevation: 0,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title:
                      /*!_isSearch
                          ? RaisedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.add),
                              label: Text("ADD CATEGORY"))
                          : */
                      Text(_source.length == 0
                          ? 'Loading...'
                          : 'Total ' +
                              _source.length.toString() +
                              ' Results found!'),
                  /* actions: [
                        if (_isSearch)
                          Expanded(
                              child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        _isSearch = false;
                                      });
                                    }),
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.search), onPressed: () {})),
                          )),
                        if (!_isSearch)
                          IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  _isSearch = true;
                                });
                              })
                      ],*/
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  showSelect: false,
                  autoHeight: true,
                  onTabRow: (data) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiquidityPage(
                          amount: amount,
                          fromCur: fromCur,
                          toCur: toCur,
                          apiName: data["name"],
                          currentDate: date,
                        ),
                      ),
                    );
                  },
                  onSort: (value) {
                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      if (_sortAscending) {
                        _source.sort((a, b) =>
                            b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                      } else {
                        _source.sort((a, b) =>
                            a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                      }
                    });
                  },
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                  onSelect: (value, item) {
                    print("$value  $item ");
                    if (value) {
                      _selecteds.clear();
                      setState(() => _selecteds.add(item));
                    } else {
                      setState(
                          () => _selecteds.removeAt(_selecteds.indexOf(item)));
                    }
                  },
                  // onSelectAll: (value) {
                  //   if (value) {
                  //     setState(() => _selecteds =
                  //         _source.map((entry) => entry).toList().cast());
                  //   } else {
                  //     setState(() => _selecteds.clear());
                  //   }
                  // },
                  // footers: [
                  //   Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 15),
                  //     child: Text("Rows per page:"),
                  //   ),
                  //   if (_perPages != null)
                  //     Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 15),
                  //       child: DropdownButton(
                  //           value: _currentPerPage,
                  //           items: _perPages
                  //               .map((e) => DropdownMenuItem(
                  //                     child: Text("$e"),
                  //                     value: e,
                  //                   ))
                  //               .toList(),
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _currentPerPage = value;
                  //             });
                  //           }),
                  //     ),
                  //   Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 15),
                  //     child: Text("$_currentPage"),
                  //   ),
                  //   IconButton(
                  //     icon: Icon(
                  //       Icons.arrow_back_ios,
                  //       size: 16,
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         _currentPage =
                  //             _currentPage >= 2 ? _currentPage - 1 : 1;
                  //       });
                  //     },
                  //     padding: EdgeInsets.symmetric(horizontal: 15),
                  //   ),
                  // ],
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.next_plan),
      // ),
    );
  }
}
