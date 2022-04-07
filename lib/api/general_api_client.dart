import 'package:dio/dio.dart';
import 'package:bintango_jp/api/api_client.dart';
import 'package:logger/logger.dart';

abstract class GeneralApiClient extends ApiClient {

  GeneralApiClient(
    String apiKey,
    String baseUrl,
    Logger logger,
  ) : super(apiKey, baseUrl, logger);


  @override
  void handleError(Response? response) {
    print(response?.statusCode);
    print(response?.data);
  }

}