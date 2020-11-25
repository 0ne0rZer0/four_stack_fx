import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:four_stack_fx/model/currency_rate.dart';
import 'package:http/http.dart' as http;

class SarrafchiAPI {
  String _url = "https://api.sarrafchi.ir/rate/";

  Future<CurrencyRate> getLatest({String base, String quote}) async {
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
}
