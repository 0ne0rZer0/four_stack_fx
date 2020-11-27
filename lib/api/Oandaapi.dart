import 'dart:convert';
import '../main.dart';

import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class OandaAPI {
  String _url = "https://www1.oanda.com/rates/api/v2/rates/spot.json?api_key=";
  String _apiKey = "8FmuBoxPfGI7PgDZoMvLO0uW"; //key is updated
  Future<CurrencyRate> getData(String base, String target) async {
    var responseJSON =
        await http.get(_url + _apiKey + "&base=$base&quote=$target");
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body);
      var data = convertedJSON["quotes"];
      var data2 = convertedJSON["quotes"][0];
      var buy = data2["bid"];
      var sell = data2["ask"];
      CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
      return currencyRate;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    //YYYY-MM-DD
    var responseJSON = await http.get(_url +
        "/rates/candles.json?base=$base&quote=$target&start_time=$startDate&end_time=$endDate&api_key=" +
        _apiKey);
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
    var responseJSON = await http
        .get(_url + _apiKey + "&date_time=$date&base=$base&quote=$target");
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body);
      var data = convertedJSON["quotes"];
      var data2 = convertedJSON["quotes"][0];
      var buy = data2["bid"];
      var sell = data2["ask"];
      CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
      return currencyRate;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
