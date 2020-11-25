import 'dart:convert';
import '../main.dart';

import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class ForexAPI {
  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + "/" + target;
    String _url =
        "https://fcsapi.com/api-v3/forex/latest?symbol=$convert&access_key=dsUx9GI5jsA4lGzHmzisLCj8";

    var responseJSON = await http.get(_url);
    var convertedJSON = jsonDecode(responseJSON.body);

    var data = convertedJSON["response"][0];
    var buy = data["h"];
    var sell = data["l"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }
}
