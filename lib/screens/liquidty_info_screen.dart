import 'package:flutter/material.dart';
import 'package:four_stack_fx/api/Cdzapi.dart';
import 'package:four_stack_fx/api/Forexapi.dart';
import 'package:four_stack_fx/api/Liveratesapi.dart';
import 'package:four_stack_fx/api/Oandaapi.dart';
import 'package:four_stack_fx/api/Tradersapi.dart';

import 'package:four_stack_fx/model/currency_rate.dart';
import 'package:responsive_table/ResponsiveDatatable.dart';
import 'package:responsive_table/DatatableHeader.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class LiquidityPage extends StatefulWidget {
  String fromCur = "USD";
  String toCur = "EUR";
  double amount;
  String apiName = "Liquidity Provider";
  DateTime currentDate;
  LiquidityPage(
      {this.amount, this.fromCur, this.toCur, this.apiName, this.currentDate});
  @override
  _LiquidityPageState createState() => _LiquidityPageState(
      amount: amount,
      fromCur: fromCur,
      toCur: toCur,
      apiName: apiName,
      currentDate: currentDate);
}

class _LiquidityPageState extends State<LiquidityPage> {
  String fromCur = "USD";
  String toCur = "EUR";
  double amount;
  Timer _timer;
  String apiName = "Liquidity Provider";
  DateTime currentDate;
  _LiquidityPageState(
      {this.amount, this.fromCur, this.toCur, this.apiName, this.currentDate});
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
        text: "Date",
        value: "date",
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
  List<CurrencyRate> result;
  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    if (fromCur == null) {
      fromCur = "USD";
    }
    if (toCur == null) {
      toCur = "EUR";
    }
    if (apiName == null) {
      apiName = "Liquidity Provider";
    }
    if (currentDate == null) {
      currentDate = DateTime.now();
    }
    Future.delayed(Duration(seconds: 3)).then((value) async {
      setState(() => _isLoading = true);
      DateTime dateTime = currentDate.subtract(Duration(days: 6));
      String startDate = DateFormat('yyyy-MM-dd').format(dateTime).toString();
      String endDate = DateFormat('yyyy-MM-dd').format(currentDate).toString();
      debugPrint(startDate);
      debugPrint(endDate);
      debugPrint(apiName);
      debugPrint(fromCur);
      debugPrint(toCur);
      switch (apiName) {
        case 'CDZ':
          CdzAPI cdzAPICall = CdzAPI();
          result =
              await cdzAPICall.getRangeData(fromCur, toCur, startDate, endDate);
          break;
        case 'ForexFree':
          ForexAPI forexAPICall = ForexAPI();
          result = await forexAPICall.getRangeData(
              fromCur, toCur, startDate, endDate);
          break;
        case 'LiveRate':
          LiveratesAPI liveAPICall = LiveratesAPI();
          result = await liveAPICall.getRangeData(
              fromCur, toCur, startDate, endDate);
          break;
        case 'Oanda':
          OandaAPI oandaAPICall = OandaAPI();
          result = await oandaAPICall.getRangeData(
              fromCur, toCur, startDate, endDate);
          break;
        case 'Traders':
          TradersAPI tradersAPICall = TradersAPI();
          result = await tradersAPICall.getRangeData(
              fromCur, toCur, startDate, endDate);
          break;
      }
      for (int i = 0; i < result.length; i++) {
        _source.add({
          'id': i + 1,
          'date': DateFormat('yyyy-MM-dd').format(dateTime).toString(),
          'buyPrice': result[i].buy,
          'sellPrice': result[i].sell,
        });
        dateTime = dateTime.add(Duration(days: 1));
      }
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 800;
    return Scaffold(
      appBar: AppBar(
        title: Text('Four Stacks FX',
            style: TextStyle(fontWeight: FontWeight.w100)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: Container(
                    width: 500,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              apiName,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
                            ),
                            Text(fromCur + ' to ' + toCur + ' rates')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Flex(
                  direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: 900, maxWidth: 800),
                      child: ResponsiveDatatable(
                        headers: _headers,
                        source: _source,
                        selecteds: _selecteds,
                        autoHeight: true,
                        onSort: (value) {
                          setState(() {
                            _sortColumn = value;
                            _sortAscending = !_sortAscending;
                            if (_sortAscending) {
                              _source.sort((a, b) => b["$_sortColumn"]
                                  .compareTo(a["$_sortColumn"]));
                            } else {
                              _source.sort((a, b) => a["$_sortColumn"]
                                  .compareTo(b["$_sortColumn"]));
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
                            setState(() =>
                                _selecteds.removeAt(_selecteds.indexOf(item)));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: isScreenWide ? 0 : 100,
                    ),
                    result == null
                        ? CircularProgressIndicator()
                        : _getRangeAreaChart()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the Cartesian Range area chart.
  SfCartesianChart _getRangeAreaChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Bid-Offer spread'),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          isVisible: false,
          dateFormat: DateFormat.Md(),
          interval: 1,
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getRangeAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: true, decimalPlaces: 1),
    );
  }

  /// Gets the random data for the Rnage area chart series.
  List<ChartSampleData> _getData() {
    List<ChartSampleData> _chartData;
    _chartData = <ChartSampleData>[];

    for (int i = 0; i < result.length; i++) {
      _chartData.add(ChartSampleData(
          x: DateTime(2000, i + 2, i),
          high: double.parse(result[i].buy),
          low: double.parse(result[i].sell)));
    }
    return _chartData;
  }

  /// Returns the list of Chart series
  /// which need to render on the Range area chart.
  List<ChartSeries<ChartSampleData, DateTime>> _getRangeAreaSeries() {
    final List<ChartSampleData> chartData = _getData();
    return <ChartSeries<ChartSampleData, DateTime>>[
      RangeAreaSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        name: 'API',
        borderWidth: 2,
        opacity: 0.5,
        borderColor: const Color.fromRGBO(50, 198, 255, 1),
        color: const Color.fromRGBO(50, 198, 255, 1),
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        highValueMapper: (ChartSampleData sales, _) => sales.high,
        lowValueMapper: (ChartSampleData sales, _) => sales.low,
      )
    ];
  }

  /// Return the list of  area series which need to be animated.

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  /// Return the random value in area series.

}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color pointColor;

  /// Holds size of the datapoint
  final num size;

  /// Holds datalabel/text value mapper of the datapoint
  final String text;

  /// Holds open value of the datapoint
  final num open;

  /// Holds close value of the datapoint
  final num close;

  /// Holds low value of the datapoint
  final num low;

  /// Holds high value of the datapoint
  final num high;

  /// Holds open value of the datapoint
  final num volume;
}
