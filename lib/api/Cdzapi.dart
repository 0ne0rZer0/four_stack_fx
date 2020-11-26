import 'dart:convert';
import '../main.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class CdzAPI {
  Random random = new Random();
  String _url = "https://currencydatafeed.com/api";
  String _url2 = "https://free.currconv.com/api/v7/convert?apiKey=";
  String _apiKey2 = "0a96c48ff75a25b4f95f";
  String _apiKey = "aqcg8adcz26i2alcpkat"; //Api key
  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + target;
    var responseJSON =
        await http.get(_url + "/live?currency=$convert,&api_key=" + _apiKey);
    var convertedJSON = jsonDecode(responseJSON.body);
    var data = convertedJSON["quotes"][0];
    var buy = data["ask"];
    buy = buy + random.nextDouble();
    var sell = data["bid"];
    sell = sell - random.nextDouble();
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    Random random = new Random();
    String convert = base + "_" + target;
    var responseJSON = await http.get(_url2 +
        _apiKey2 +
        "&q=$convert&compact=ultra&date=$startDate&endDate=$endDate");
    var convertedJSON = jsonDecode(responseJSON.body.toString());
    List<CurrencyRate> result = new List<CurrencyRate>();
    var value = new Map();
    var date = convertedJSON["$convert"];
    for (final name in date.keys) {
      var buy = date[name];
      var sell = buy - random.nextDouble();
      result.add(CurrencyRate(buy.toString(), sell.toString()));
    }
    return result;
  }
}
