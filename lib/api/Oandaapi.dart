import 'dart:convert';
import '../main.dart';

import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';

class OandaAPI {
  Future<CurrencyRate> getData(String base, String target) async {
    String convert = base + "_" + target;
    String _url =
        "https://www1.oanda.com/rates/api/v2/rates/spot.json?api_key=BEnvswX3s5Aiyw40gdp6muYg&base=$base&quote=$target";

    var responseJSON = await http.get(_url);
    var convertedJSON = jsonDecode(responseJSON.body);
    var data = convertedJSON["quotes"][0];
    var buy = data["bid"];
    var sell = data["ask"];
    CurrencyRate currencyRate = CurrencyRate(buy.toString(), sell.toString());
    return currencyRate;
  }
}
