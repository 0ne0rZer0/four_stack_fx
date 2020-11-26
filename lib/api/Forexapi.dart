import 'dart:convert';
import '../main.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class ForexAPI {
  String _url = "https://fcsapi.com/api-v3/forex";
  String _url2 = "https://api.exchangeratesapi.io/history?";
  String apiKey = "dsUx9GI5jsA4lGzHmzisLCj8"; //Apikey
  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + "/" + target;
    var responseJSON =
        await http.get(_url + "/latest?symbol=$convert&access_key=" + apiKey);
    var convertedJSON = jsonDecode(responseJSON.body);
    var data = convertedJSON["response"][0];
    var buy = data["h"];
    var sell = data["l"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }

  Future<List<CurrencyRate>> getRangeData(
      String base, String target, String startDate, String endDate) async {
    Random random = new Random();
    var responseJSON = await http.get(
        _url2 + "start_at=$startDate&end_at=$endDate&symbols=$base,$target");
    var convertedJSON = jsonDecode(responseJSON.body.toString());
    List<CurrencyRate> result = new List<CurrencyRate>();
    var value = new Map();

    var date = convertedJSON["rates"];
    for (final name in date.keys) {
      value = date[name];
      var buy = value["$base"];
      var sell = buy - random.nextDouble();
      result.add(CurrencyRate(buy.toString(), sell.toString()));
    }
    return result;
  }
}
