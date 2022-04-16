import 'package:flutter/foundation.dart';

class Config {
  static const dictionarySpreadSheetName = '日本語学習アプリ_N5_prod';
  static const dbName = 'app_database.db';
  static const adUnitIdAndroidBanner = kDebugMode ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3388807447141549/1005593741';
  static const adUnitIdIosBanner = kDebugMode ? 'ca-app-pub-3940256099942544/2934735716' : 'ca-app-pub-3388807447141549/9239306980';
  static const adUnitIdAndroidInterstitial = kDebugMode ? 'ca-app-pub-3940256099942544/8691691433' : 'ca-app-pub-3388807447141549/1743960348';
  static const adUnitIdIosInterstitial = kDebugMode ? 'ca-app-pub-3940256099942544/5135589807' : 'ca-app-pub-3388807447141549/1360816962';

  static const apiKeyHeader = "x-api-key";
  static const contentTypeHeader = "Content-type";
  static const acceptHeader = "Accept";
  static const authorizationHeader = "Authorization";
}