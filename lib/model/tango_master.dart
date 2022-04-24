import 'package:bintango_jp/model/category.dart';
import 'package:bintango_jp/model/lecture.dart';
import 'package:bintango_jp/model/level.dart';
import 'package:bintango_jp/model/part_of_speech.dart';
import 'package:bintango_jp/model/tango_entity.dart';
import 'package:bintango_jp/model/translate_master.dart';
import 'package:bintango_jp/repository/sheat_repo.dart';

class TangoMaster {
  Dictionary dictionary = Dictionary();
  Lesson lesson = Lesson();
  TranslateMaster translateMaster = TranslateMaster();
  double totalAchievement = 0;
}

class Dictionary {
  List<TangoEntity> allTangos = [];
  List<TangoEntity> sortAndFilteredTangos = [];
}

class Lesson {
  LectureFolder? folder;
  TangoCategory? category;
  PartOfSpeechEnum? partOfSpeech;
  LevelGroup? levelGroup;
  bool isBookmark = false;
  bool isNotRemembered = false;
  bool isTest = false;
  List<TangoEntity> tangos = [];
  List<QuizResult> quizResults = [];
}

class QuizResult {
  TangoEntity? entity;
  bool isCorrect = false;
  int answerTime = 15 * 1000;
}