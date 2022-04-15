import 'package:bintango_jp/generated/json/base/json_convert_content.dart';
import 'package:bintango_jp/model/tango_entity.dart';

TangoEntity $TangoEntityFromJson(Map<String, dynamic> json) {
	final TangoEntity tangoEntity = TangoEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		tangoEntity.id = id;
	}
	final String? indonesian = jsonConvert.convert<String>(json['indonesian']);
	if (indonesian != null) {
		tangoEntity.indonesian = indonesian;
	}
	final String? english = jsonConvert.convert<String>(json['english']);
	if (english != null) {
		tangoEntity.english = english;
	}
	final String? japanese = jsonConvert.convert<String>(json['japanese']);
	if (japanese != null) {
		tangoEntity.japanese = japanese;
	}
	final String? japaneseKana = jsonConvert.convert<String>(json['japaneseKana']);
	if (japaneseKana != null) {
		tangoEntity.japaneseKana = japaneseKana;
	}
	final String? romaji = jsonConvert.convert<String>(json['romaji']);
	if (romaji != null) {
		tangoEntity.romaji = romaji;
	}
	final String? option1 = jsonConvert.convert<String>(json['option1']);
	if (option1 != null) {
		tangoEntity.option1 = option1;
	}
	final String? option2 = jsonConvert.convert<String>(json['option2']);
	if (option2 != null) {
		tangoEntity.option2 = option2;
	}
	final String? option3 = jsonConvert.convert<String>(json['option3']);
	if (option3 != null) {
		tangoEntity.option3 = option3;
	}
	final int? category = jsonConvert.convert<int>(json['category']);
	if (category != null) {
		tangoEntity.category = category;
	}
	final int? level = jsonConvert.convert<int>(json['level']);
	if (level != null) {
		tangoEntity.level = level;
	}
	final String? description = jsonConvert.convert<String>(json['description']);
	if (description != null) {
		tangoEntity.description = description;
	}
	final String? option1Kana = jsonConvert.convert<String>(json['option1Kana']);
	if (option1Kana != null) {
		tangoEntity.option1Kana = option1Kana;
	}
	final String? option1Romaji = jsonConvert.convert<String>(json['option1Romaji']);
	if (option1Romaji != null) {
		tangoEntity.option1Romaji = option1Romaji;
	}
	final String? option2Kana = jsonConvert.convert<String>(json['option2Kana']);
	if (option2Kana != null) {
		tangoEntity.option2Kana = option2Kana;
	}
	final String? option2Romaji = jsonConvert.convert<String>(json['option2Romaji']);
	if (option2Romaji != null) {
		tangoEntity.option2Romaji = option2Romaji;
	}
	final String? option3Kana = jsonConvert.convert<String>(json['option3Kana']);
	if (option3Kana != null) {
		tangoEntity.option3Kana = option3Kana;
	}
	final String? option3Romaji = jsonConvert.convert<String>(json['option3Romaji']);
	if (option3Romaji != null) {
		tangoEntity.option3Romaji = option3Romaji;
	}
	return tangoEntity;
}

Map<String, dynamic> $TangoEntityToJson(TangoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['indonesian'] = entity.indonesian;
	data['english'] = entity.english;
	data['japanese'] = entity.japanese;
	data['japaneseKana'] = entity.japaneseKana;
	data['romaji'] = entity.romaji;
	data['option1'] = entity.option1;
	data['option2'] = entity.option2;
	data['option3'] = entity.option3;
	data['category'] = entity.category;
	data['level'] = entity.level;
	data['description'] = entity.description;
	data['option1Kana'] = entity.option1Kana;
	data['option1Romaji'] = entity.option1Romaji;
	data['option2Kana'] = entity.option2Kana;
	data['option2Romaji'] = entity.option2Romaji;
	data['option3Kana'] = entity.option3Kana;
	data['option3Romaji'] = entity.option3Romaji;
	return data;
}