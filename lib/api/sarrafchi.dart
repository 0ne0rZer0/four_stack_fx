import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:four_stack_fx/model/currency_rate.dart';
import 'package:http/http.dart' as http;

class SarrafchiAPI {
  String _url = "https://api.sarrafchi.ir/rate/";
  String _url2 = "https://fxmarketapi.com/apitimeseries?api_key=";
  String _apiKey2 = "alwOFGWZ7dIx9obANrmR";

  Future<CurrencyRate> getData(String base, String quote) async {
    var responseJSON = await http.get(_url);
    var convertedJSON = jsonDecode(responseJSON.body);

    double baseBuy = double.parse(convertedJSON['currencies'][base]['buy']);
    double quoteBuy = double.parse(convertedJSON['currencies'][quote]['buy']);
    double baseSell = double.parse(convertedJSON['currencies'][base]['sell']);
    double quoteSell = double.parse(convertedJSON['currencies'][quote]['sell']);
    double buy = (quoteBuy / baseBuy);
    double sell = (quoteSell / baseSell);

    // debugPrint(baseBuy.toString());
    // debugPrint(baseSell.toString());
    // debugPrint(quoteBuy.toString());
    // debugPrint(quoteSell.toString());
    // debugPrint(buy.toString());
    // debugPrint(sell.toString());

    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    String convert = base + target;
    var responseJSON = await http.get(_url +
        _apiKey2 +
        "&currency=$convert&start_date=$startDate&end_date=$endDate");
    var convertedJSON = jsonDecode(responseJSON.body.toString());

    List<CurrencyRate> result = new List<CurrencyRate>();

    var value = convertedJSON["price"];
    debugPrint(value.toString());
    var nested1;
    var nested2;
    //debugPrint(date.runtimeType.toString());
    //debugPrint(date.toString());
    //var i = 0;

    for (final name in value.keys) {
      nested1 = value[name];
      for (final names in nested1.keys) {
        nested2 = nested1[names];
        var buy = nested2["high"];
        var sell = nested2["low"];
        result.add(CurrencyRate(buy.toString(), sell.toString()));
      }
    }
  }
}
