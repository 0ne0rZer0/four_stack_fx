import 'dart:convert';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiveratesAPI {
  Future<CurrencyRate> getData(String base, String target) async {
    String convert =
        base + "_" + target; //To convert the parameters in usable form of URL
    String _url =
        "https://www.live-rates.com/api/price?rate=$convert&key=524e482870"; //API URL

    var responseJSON = await http.get(_url);
    var convertedJSON = jsonDecode(responseJSON.body);
    var fetchedData = convertedJSON[0];

    var buy = fetchedData["bid"];
    var sell = fetchedData["ask"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }
}
