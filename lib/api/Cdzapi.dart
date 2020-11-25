import 'dart:convert';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class CdzAPI {
  String _url = "https://marketdata.tradermade.com/api/v1";
  String _apiKey = "-3F23YQDx2mgHUv6-M-m"; //Api key
  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + target;
    var responseJSON =
        await http.get(_url + "/live?currency=$convert&api_key=" + _apiKey);
    var convertedJSON = jsonDecode(responseJSON.body);
    var data = convertedJSON["quotes"][0];
    var buy = data["ask"];
    var sell = data["bid"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }
}
