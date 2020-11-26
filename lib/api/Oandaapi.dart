import 'dart:convert';
import '../main.dart';

import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class OandaAPI {
  String _url = "https://www1.oanda.com/rates/api/v2";
  String _apiKey = " BEnvswX3s5Aiyw40gdp6muYg";
  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + "_" + target;
    var responseJSON = await http.get(_url +
        " /rates/spot.json?api_key=" +
        _apiKey +
        "&base=$base&quote=$target");
    var convertedJSON = jsonDecode(responseJSON.body);
    var data = convertedJSON["quotes"][0];
    var buy = data["bid"];
    var sell = data["ask"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    //YYYY-MM-DD
    var responseJSON = await http.get(_url +
        "/rates/candles.json?base=$base&quote=$target&start_time=$startDate&end_time=$endDate&api_key=" +
        _apiKey);
    var convertedJSON = jsonDecode(responseJSON.body.toString());
    var arrayOfdates = convertedJSON["quotes"];
    List<CurrencyRate> result = new List<CurrencyRate>();
    for (int i = 0; i < arrayOfdates.length; i++) {
      var buy = arrayOfdates[i]["average_bid"];
      var sell = arrayOfdates[i]["average_ask"];
      result.add(CurrencyRate(buy.toString(), sell.toString()));
    }
    return result;
  }
}
