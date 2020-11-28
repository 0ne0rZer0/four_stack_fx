import 'dart:convert';
import '../main.dart';

import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class TradersAPI {
  String _url = "https://marketdata.tradermade.com/api/v1";
  String _apiKey = "-3F23YQDx2mgHUv6-M-m";

  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + target;
    var responseJSON =
        await http.get(_url + "/live?currency=$convert,&api_key=" + _apiKey);
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body);
      var data = convertedJSON["quotes"][0];
      var buy = data["ask"];
      var sell = data["bid"];

      CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
      return currencyRate;
    } else {
      throw Exception('Failed to load post');
    }
  }

  //Using same API getting range data
  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    //YYYY-MM-DD format of dates
    String convert = base + target;
    var responseJSON = await http.get(_url +
        "/timeseries?currency=$convert&start_date=$startDate&end_date=$endDate&api_key=" +
        _apiKey);
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body.toString());
      var arrayOfdates = convertedJSON["quotes"];
      List<CurrencyRate> result = new List<CurrencyRate>();
      for (int i = 0; i < arrayOfdates.length; i++) {
        var buy = arrayOfdates[i]["high"];
        var sell = arrayOfdates[i]["low"];
        result.add(CurrencyRate(buy.toString(), sell.toString()));
      }
      return result;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<CurrencyRate> getGivenDate(
      String base, String target, String date) async {
    String convert = base + target;
    var responseJSON = await http.get(_url +
        "/timeseries?currency=$convert&start_date=$date&end_date=$date&api_key=" +
        _apiKey);
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body);
      var data = convertedJSON["quotes"];

      var data2 = convertedJSON["quotes"][0];
      var buy = (data2["high"]);
      var sell = (data2["low"]);

      CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
      return currencyRate;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
