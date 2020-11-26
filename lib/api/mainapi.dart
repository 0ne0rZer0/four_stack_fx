import 'dart:convert';
import '../main.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:four_stack_fx/model/currency_rate.dart';
import 'Cdzapi.dart';
import 'Forexapi.dart';
import 'Oandaapi.dart';
import 'sarrafchi.dart';
import 'Tradersapi.dart';
import 'Liveratesapi.dart';

class APICall {
  CdzAPI api1 = new CdzAPI();
  ForexAPI api2 = new ForexAPI();
  LiveratesAPI api3 = new LiveratesAPI();
  OandaAPI api4 = new OandaAPI();
  TradersAPI api5 = new TradersAPI();
  SarrafchiAPI api6 = new SarrafchiAPI();
  Future<List<CurrencyRate>> getmaindata(String base, String target) async {
    List<CurrencyRate> result = new List<CurrencyRate>();
    result.add(await api1.getData(base, target));
    result.add(await api2.getData(base, target));
    result.add(await api3.getData(base, target));
    result.add(await api4.getData(base, target));
    result.add(await api5.getData(base, target));
    result.add(await api6.getData(base, target));
    return result;
  }

  Future<List<List<CurrencyRate>>> getRangesData(
      String base, String target, String startDate, String endDate) async {
    List<List<CurrencyRate>> result = new List<List<CurrencyRate>>();
    result.add(await api1.getRangeData(base, target, startDate, endDate));
    result.add(await api2.getRangeData(base, target, startDate, endDate));
    result.add(await api3.getRangeData(base, target, startDate, endDate));
    result.add(await api4.getRangeData(base, target, startDate, endDate));
    result.add(await api5.getRangeData(base, target, startDate, endDate));
    result.add(await api6.getRangeData(base, target, startDate, endDate));
    return result;
  }
}
