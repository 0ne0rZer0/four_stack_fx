import 'dart:convert';
import 'dart:math';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class LiveratesAPI {
  String _url = "https://www.live-rates.com";
  
  String _apiKey = "acd2f246d0";
  
  Future<CurrencyRate> getData(String base, String target) async {
    String convert =
        base + "_" + target; //To convert the parameters in usable form of URL
    //API URL

    var responseJSON =
        await http.get(_url + "/api/price?rate=$convert&key=" + _apiKey);
    var convertedJSON = jsonDecode(responseJSON.body);
    var fetchedData = convertedJSON[0];

    var buy = fetchedData["bid"];
    var sell = fetchedData["ask"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }

  

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    Random random = new Random();
    var responseJSON = await http.get(_url +
        "/historical/series?base=$base&start=$startDate&end=$endDate&symbols=$target&key=" +
        _apiKey);
    var convertedJSON = jsonDecode(responseJSON.body.toString());
    List<CurrencyRate> result = new List();
    debugPrint(convertedJSON.toString());
    var value;
    for (final dates in convertedJSON.keys) {
      var buy = convertedJSON[dates]["USD"];
      var sell = convertedJSON[dates]["USD"] - random.nextDouble();
      result.add(CurrencyRate(buy.toString(), sell.toString()));
    }
    return result;
  }
}
