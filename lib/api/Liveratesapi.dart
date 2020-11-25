import 'dart:convert';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class LiveratesAPI {
  String _url = "https://www.live-rates.com/api";
  String _apiKey = "524e482870";
  Future<CurrencyRate> getData(String base, String target) async {
    String convert =
        base + "_" + target; //To convert the parameters in usable form of URL
    //API URL

    var responseJSON =
        await http.get(_url + "/price?rate=$convert&key=" + _apiKey);
    var convertedJSON = jsonDecode(responseJSON.body);
    var fetchedData = convertedJSON[0];

    var buy = fetchedData["bid"];
    var sell = fetchedData["ask"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }
}
