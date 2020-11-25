import 'dart:convert';
import '../main.dart';

import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class ForexAPI {
  String _url = "https://fcsapi.com/api-v3/forex";
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
}
