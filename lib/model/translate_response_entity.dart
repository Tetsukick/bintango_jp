import 'dart:convert';
import 'package:bintango_jp/generated/json/base/json_field.dart';
import 'package:bintango_jp/generated/json/translate_response_entity.g.dart';

@JsonSerializable()
class TranslateResponseEntity {

	int? code;
	String? text;
  
  TranslateResponseEntity();

  factory TranslateResponseEntity.fromJson(Map<String, dynamic> json) => $TranslateResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => $TranslateResponseEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}