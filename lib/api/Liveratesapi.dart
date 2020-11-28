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
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body);
      var fetchedData = convertedJSON[0];

      var buy = fetchedData["bid"];
      var sell = fetchedData["ask"];
      CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
      return currencyRate;
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Future<List<CurrencyRate>> getRangeData(
  //     String base, String target, String startDate, String endDate) async {
  //   Random random = new Random();
  //   var responseJSON = await http.get(_url +
  //       "/historical/series?base=$base&start=$startDate&end=$endDate&symbols=$target&key=" +
  //       _apiKey);
  //   if (responseJSON.statusCode == 200) {
  //     var convertedJSON = jsonDecode(responseJSON.body.toString());
  //     List<CurrencyRate> result = new List();
  //     debugPrint(convertedJSON.toString());
  //     var value;
  //     for (final dates in convertedJSON.keys) {
  //       var buy = convertedJSON[dates]["USD"];
  //       var sell = convertedJSON[dates]["USD"] - random.nextDouble();
  //       result.add(CurrencyRate(buy.toString(), sell.toString()));
  //     }
  //     return result;
  //   } else {
  //     throw Exception('Failed to load post');
  //   }
  // }
  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    //YYYY-MM-DD
    String _url =
        "https://www1.oanda.com/rates/api/v2/rates/aggregated.json?api_key=8FmuBoxPfGI7PgDZoMvLO0uW&start_time=2020-11-24&end_time=2020-11-26&base=EUR&quote=USD&fields=highs&fields=lows"; //key is updated
    var responseJSON = await http.get(_url);
    var convertedJSON = jsonDecode(responseJSON.body.toString());
    //debugPrint(convertedJSON.toString());
    var quotes = convertedJSON["quotes"];
    debugPrint(quotes.toString());
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body.toString());
      var arrayOfdates = convertedJSON["quotes"];
      List<CurrencyRate> result = new List<CurrencyRate>();
      for (int i = 0; i < arrayOfdates.length; i++) {
        var buy = arrayOfdates[i]["average_bid"];
        var sell = arrayOfdates[i]["average_ask"];
        result.add(CurrencyRate(buy.toString(), sell.toString()));
      }
      return result;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<CurrencyRate> getGivenDate(
      String base, String target, String date) async {
    var responseJSON = await http.get(_url +
        "/historical?base=$base&date=$date&symbols=$target&key=" +
        _apiKey);

    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body);
      var buy;
      //debugPrint(convertedJSON.toString());
      for (final name in convertedJSON.keys) {
        buy = convertedJSON[name];
      }
      //debugPrint(buy.runtimeType.toString());
      buy = buy + 0.002;
      var sell = buy - 0.001;

      CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
      return currencyRate;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
