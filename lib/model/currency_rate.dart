class CurrencyRate {
  String _buy;
  String _sell;
  CurrencyRate(this._buy, this._sell);

  String get buy => _buy;

  String get sell => _sell;

  set buy(buy) {
    _buy = buy;
  }

  set sell(sell) {
    _sell = sell;
  }
}
