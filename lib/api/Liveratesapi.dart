import 'dart:convert';

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

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    var responseJSON = await http.get(_url +
        "/historical/series?base=$base&start=$startDate&end=$endDate&symbols=$target&key=" +
        _apiKey);
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body.toString());
      //debugPrint(convertedJSON.toString());
      List<CurrencyRate> result = new List<CurrencyRate>();
      //debugPrint(convertedJSON.toString());
      var value;
      for (final name in convertedJSON.keys) {
        value = convertedJSON[name];
        for (final name2 in value.keys) {
          var buy = value[name2];
          var sell = buy - 0.002;
          result.add(CurrencyRate(buy.toString(), sell.toString()));
        }
      }
      //debugPrint(result[2].buy);
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
