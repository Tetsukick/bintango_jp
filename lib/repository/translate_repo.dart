import 'package:bintango_jp/api/api.dart';
import 'package:bintango_jp/api/clients/general_client.dart';
import 'package:bintango_jp/model/translate_response_entity.dart';
import 'package:bintango_jp/utils/logger.dart';

class TranslateRepo {
  Api translateApi = Api(generalClient: GeneralClient(
    apiKey: '',
    baseUrl: 'https://script.google.com/macros/s/AKfycbwwsokn-ihd3ffq0rTu--Qa5p4XtQLgJbL3audTm397ZwFwVQplNPYlEeKrH4AsSIuS',
    logger: logger
  ));

  Future<TranslateResponseEntity> translate(String origin, {bool isIndonesianToJapanese = true}) {
    final _japaneseCode = 'ja';
    final _indonesianCode = 'id';

    return translateApi.generalClient.get<TranslateResponseEntity>(
        endpoint: 'exec',
        queryParams: {
          'text': origin,
          'source': isIndonesianToJapanese ? _indonesianCode : _japaneseCode,
          'target': isIndonesianToJapanese ? _japaneseCode : _indonesianCode,
        },
        serializer: (json) {
          final response = TranslateResponseEntity.fromJson(json);
          return response;
        });
  }
}