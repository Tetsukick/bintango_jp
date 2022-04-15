import 'dart:convert';
import 'package:bintango_jp/generated/json/base/json_field.dart';
import 'package:bintango_jp/generated/json/tango_entity.g.dart';

@JsonSerializable()
class TangoEntity {

	int? id;
	String? indonesian;
	String? english;
	String? japanese;
	String? japaneseKana;
	String? romaji;
	String? option1;
	String? option2;
	String? option3;
	int? category;
	int? level;
	String? description;
	String? option1Kana;
	String? option1Romaji;
	String? option2Kana;
	String? option2Romaji;
	String? option3Kana;
	String? option3Romaji;
  
  TangoEntity();

  factory TangoEntity.fromJson(Map<String, dynamic> json) => $TangoEntityFromJson(json);

  Map<String, dynamic> toJson() => $TangoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}