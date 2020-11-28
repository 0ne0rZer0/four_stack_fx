import 'dart:convert';
import '../main.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class ForexAPI {
  String _url = "https://fcsapi.com/api-v3/forex";
  String _url2 = "https://api.exchangeratesapi.io/history?";
  String apiKey = "dsUx9GI5jsA4lGzHmzisLCj8"; //Apikey
  String _url3 = "https://www1.oanda.com/rates/api/v2/rates/spot.json?api_key=";
  String _apiKey2 = "8FmuBoxPfGI7PgDZoMvLO0uW";
  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + "/" + target;
    var responseJSON =
        await http.get(_url + "/latest?symbol=$convert&access_key=" + apiKey);
    if (responseJSON.statusCode == 200) {
      var convertedJSON = jsonDecode(responseJSON.body);
      var data = convertedJSON["response"][0];
      var buy = data["h"];
      var sell = data["l"];
      CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
      return currencyRate;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    var responseJSON = await http.get(_url2 +
        "start_at=$startDate&end_at=$endDate&base=$base&symbols=$target");

    var convertedJSON = jsonDecode(responseJSON.body.toString());
    List<CurrencyRate> result = new List<CurrencyRate>();
    var value = new Map();

    var date = convertedJSON["rates"];
    //debugPrint(date.toString());
    for (final name in date.keys) {
      value = date[name];

      for (final name2 in value.keys) {
        var buy = value[name2];
        var sell = buy - 0.002;
        result.add(CurrencyRate(buy.toString(), sell.toString()));
      }
    }
    //debugPrint(result[0]._sell.toString());
    return result;
  }

  Future<CurrencyRate> getGivenDate(
      String base, String target, String date) async {
    var responseJSON = await http
        .get(_url3 + _apiKey2 + "&date_time=$date&base=$base&quote=$target");
    var convertedJSON = jsonDecode(responseJSON.body);
    var data = convertedJSON["quotes"];
    var data2 = convertedJSON["quotes"][0];
    double buy = double.parse(data2["bid"]) + 0.002;
    double sell = double.parse(data2["ask"]) + 0.002;
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }
}
