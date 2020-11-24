import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/constants/sarrafchi.dart';

Future<void> getLatest() async {
  String _url = sarrafchi_url;
  var responseJSON = await http.get(_url);
  var convertedJSON = jsonDecode(responseJSON.body);
  debugPrint(convertedJSON['currencies']['US Dollar']['buy'].toString());
  debugPrint(convertedJSON['currencies']['US Dollar']['sell'].toString());
}
