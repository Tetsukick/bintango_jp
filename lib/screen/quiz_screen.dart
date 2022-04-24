import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bintango_jp/config/color_config.dart';
import 'package:bintango_jp/config/size_config.dart';
import 'package:bintango_jp/domain/tango_list_service.dart';
import 'package:bintango_jp/gen/assets.gen.dart';
import 'package:bintango_jp/model/floor_entity/activity.dart';
import 'package:bintango_jp/model/floor_entity/word_status.dart';
import 'package:bintango_jp/model/tango_entity.dart';
import 'package:bintango_jp/model/tango_master.dart';
import 'package:bintango_jp/model/word_status_type.dart';
import 'package:bintango_jp/screen/completion_screen.dart';
import 'package:bintango_jp/screen/completion_today_test_screen.dart';
import 'package:bintango_jp/utils/common_text_widget.dart';
import 'package:bintango_jp/utils/shimmer.dart';
import 'package:bintango_jp/utils/utils.dart';
import 'package:lottie/lottie.dart';

import '../config/config.dart';
import '../model/floor_database/database.dart';
import '../model/floor_migrations/migration_v1_to_v2_add_bookmark_column_in_word_status_table.dart';
import '../utils/analytics/analytics_event_entity.dart';
import '../utils/analytics/analytics_parameters.dart';
import '../utils/analytics/firebase_analytics.dart';

class QuizScreen extends ConsumerStatefulWidget {

  static void navigateTo(BuildContext context) {
    Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) {
        return const QuizScreen();
      },
    ));
  }

  static void navigateReplacementTo(BuildContext context) {
    Navigator.pushReplacement<void, void>(context, MaterialPageRoute(
      builder: (context) {
        return const QuizScreen();
      },
    ));
  }

  const QuizScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentIndex = 0;
  bool allCardsFinished = false;
  final _cardHeight = 100.0;
  AppDatabase? database;
  String currentText = '';
  CountdownTimerController? countDownController;
  final baseQuestionTime = 1000 * 10;
  late int endTime = DateTime.now().millisecondsSinceEpoch + baseQuestionTime;
  final questionExplanation = 'Silakan pilih arti yang paling benar';
  bool _visibleOptions = true;

  @override
  void initState() {
    FirebaseAnalyticsUtils.analytics.setCurrentScreen(screenName: AnalyticsScreen.quiz.name);
    initializeDB();
    super.initState();
  }

  void initializeDB() async {
    final _database = await $FloorAppDatabase
        .databaseBuilder(Config.dbName)
        .addMigrations([migration1to2])
        .build();
    setState(() => database = _database);
  }

  @override
  void dispose() {
    countDownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.bgPinkColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(SizeConfig.mediumMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _topBarSection(),
                SizedBox(height: SizeConfig.smallMargin),
                _questionTitleCard(),
                SizedBox(height: SizeConfig.smallMargin),
                _questionAnswerCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBarSection() {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget.titleGraySmallBold('${currentIndex + 1} / ${questionAnswerList.lesson.tangos.length} 問目'),
        SizedBox(width: SizeConfig.smallMargin),
        CountdownTimer(
          controller: countDownController,
          endTime: endTime,
        ),
        Spacer(),
        IconButton(
            onPressed: () {
              analytics(FlushCardItem.back);
              Navigator.pop(context);
            },
            icon: Icon(Icons.close,
              color: ColorConfig.bgGrey,
              size: SizeConfig.largeSmallMargin,
            ))
      ],
    );
  }

  Widget _questionTitleCard() {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    if (questionAnswerList.lesson.tangos.isEmpty) {
      return _shimmerFlashCard();
    }
    return _flashCard(
        title: 'bahasa Indonesia',
        tango: questionAnswerList.lesson.tangos[currentIndex]);
  }

  Widget _questionAnswerCard() {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    final entity = questionAnswerList.lesson.tangos[currentIndex];
    List<QuizOptionEntity> optionList = [];
    optionList.add(QuizOptionEntity()
      ..kana = entity.japaneseKana!
      ..romaji = entity.romaji!
    );
    optionList.add(QuizOptionEntity()
      ..kana = entity.option1Kana!
      ..romaji = entity.option1Romaji!
    );
    optionList.add(QuizOptionEntity()
      ..kana = entity.option2Kana!
      ..romaji = entity.option2Romaji!
    );
    optionList.add(QuizOptionEntity()
      ..kana = entity.option3Kana!
      ..romaji = entity.option3Romaji!
    );
    optionList.shuffle();
    return Visibility(
      visible: _visibleOptions,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: optionList.length,
        itemBuilder: (BuildContext context, int index) {
          return _optionAnswerCard(optionEntity: optionList[index]);
        },
      ),
    );
  }

  Widget _optionAnswerCard({required QuizOptionEntity optionEntity}) {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    final entity = questionAnswerList.lesson.tangos[currentIndex];
    return Card(
      child: InkWell(
        onTap: () {
          _answer(optionEntity.kana, entity: entity);
        },
        child: Container(
          padding: const EdgeInsets.all(SizeConfig.mediumSmallMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget.titleBlackLargeBold(optionEntity.kana, maxLines: 2),
              SizedBox(height: SizeConfig.smallestMargin),
              TextWidget.titleBlackMediumBold(optionEntity.romaji, maxLines: 2),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _answer(String input, {required TangoEntity entity}) async {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    final entity = questionAnswerList.lesson.tangos[currentIndex];
    if (entity.japaneseKana == input) {
      final remainTime = endTime - DateTime.now().millisecondsSinceEpoch;
      await registerWordStatus(isCorrect: true);
      await registerActivity();
      final result = QuizResult()
        ..entity = entity
        ..isCorrect = true
        ..answerTime = baseQuestionTime - remainTime;
      ref.read(tangoListControllerProvider.notifier).addQuizResult(result);
      showTrueFalseDialog(true, entity: entity, remainTime: remainTime);
      getNextCard();
    } else {
      wrongAnswerAction(entity);
    }
  }

  Widget _flashCard({required String title, required TangoEntity tango, bool isFront = true}) {
    return Card(
      child: Container(
          height: _cardHeight,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextWidget.titleRedMedium(title),
              Flexible(
                child: TextWidget.titleBlackLargestBold(
                  isFront ? tango.indonesian! : tango.japanese!, maxLines: 2)
              ),
            ],
          )
      ),
    );
  }

  Widget _shimmerFlashCard({bool isJapanese = true}) {
    return Stack(
      children: [
        Card(
          child: Container(
            height: _cardHeight,
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextWidget.titleRedMedium(isJapanese ? 'bahasa Jepang' : 'bahasa Indonesia'),
                  ShimmerWidget.rectangular(height: 40, width: 240,)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> registerWordStatus({required bool isCorrect}) async {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    final currentTango = questionAnswerList.lesson.tangos[currentIndex];

    final wordStatusDao = database?.wordStatusDao;
    final wordStatus = await wordStatusDao?.findWordStatusById(currentTango.id!);
    if (wordStatus != null) {
      if (isCorrect) {
        if (wordStatus.status == WordStatusType.remembered.id || wordStatus.status == WordStatusType.perfectRemembered.id) {
          await wordStatusDao?.updateWordStatus(wordStatus..status = WordStatusType.perfectRemembered.id);
        } else {
          await wordStatusDao?.updateWordStatus(wordStatus..status = WordStatusType.remembered.id);
        }
      } else {
        await wordStatusDao?.updateWordStatus(wordStatus..status = WordStatusType.notRemembered.id);
      }
    } else {
      if (isCorrect) {
        await wordStatusDao?.insertWordStatus(WordStatus(wordId: currentTango.id!, status: WordStatusType.remembered.id));
      } else {
        await wordStatusDao?.insertWordStatus(WordStatus(wordId: currentTango.id!, status: WordStatusType.notRemembered.id));
      }
    }
  }

  Future<void> registerActivity() async {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    final currentTango = questionAnswerList.lesson.tangos[currentIndex];

    final activityDao = database?.activityDao;
    final now = Utils.dateTimeToString(DateTime.now());
    await activityDao?.insertActivity(Activity(date: now, wordId: currentTango.id!));
  }

  void getNextCard() async {
    final questionAnswerList = ref.watch(tangoListControllerProvider);
    if (questionAnswerList.lesson.tangos.length <= currentIndex + 1) {
      setState(() => allCardsFinished = true);
      await Future<void>.delayed(Duration(milliseconds: 2500));
      if (questionAnswerList.lesson.isTest) {
        CompletionTodayTestScreen.navigateTo(context);
      } else {
        CompletionScreen.navigateTo(context);
      }
      return;
    }
    setState(() {
      currentText = '';
      currentIndex++;
    });
    final entity = questionAnswerList.lesson.tangos[currentIndex];
    setPinCodeTextField(entity);
  }

  void analytics(FlushCardItem item, {String? others = ''}) {
    final eventDetail = AnalyticsEventAnalyticsEventDetail()
      ..id = item.id.toString()
      ..screen = AnalyticsScreen.lectureSelector.name
      ..item = item.shortName
      ..action = AnalyticsActionType.tap.name
      ..others = others;
    FirebaseAnalyticsUtils.eventsTrack(AnalyticsEventEntity()
      ..name = item.name
      ..analyticsEventDetail = eventDetail);
  }

  void setPinCodeTextField(TangoEntity entity) async {
    countDownController?.disposeTimer();
    setState(() {
      _visibleOptions = false;
      countDownController = null;
    });

    await Future<void>.delayed(Duration(milliseconds: 1200));

    setState(() => _visibleOptions = true);
    setCountDownController(entity);
  }

  double getFontSize(int length) {
    if (length < 8) {
      return 16.0;
    } else if (length < 10) {
      return 15.0;
    } else if (length < 12) {
      return 13.0;
    } else if (length < 16) {
      return 11.0;
    } else {
      return 9.5;
    }
  }

  void setCountDownController(TangoEntity entity) {
    setState(() {
      endTime = DateTime.now().millisecondsSinceEpoch + baseQuestionTime + 500;
      countDownController = CountdownTimerController(
        endTime: endTime,
        onEnd: () async {
          await wrongAnswerAction(entity);
        },
      );
    });
  }

  Future<void> showTrueFalseDialog(bool isTrue, {required TangoEntity entity, int? remainTime}) async {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  isTrue ? Assets.lottie.checkGreen : Assets.lottie.crossRed,
                  height: _cardHeight * 2,
                ),
                Visibility(
                  visible: remainTime != null,
                    child: Padding(
                      padding: const EdgeInsets.all(SizeConfig.mediumSmallMargin),
                      child: TextWidget.titleWhiteLargeBold('${(baseQuestionTime - (remainTime ?? 0)).toString()} ms'),
                    ),
                ),
                Visibility(
                  visible: !isTrue,
                  child: _flashCard(
                    title: 'インドネシア語',
                    tango: entity,
                    isFront: false
                  ),
                ),
              ],
            ),
          );
        }
    );
    await Future<void>.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
  }

  Future<void> wrongAnswerAction(TangoEntity entity) async {
    await registerWordStatus(isCorrect: false);
    await registerActivity();
    await showTrueFalseDialog(false, entity: entity);
    final result = QuizResult()
      ..entity = entity
      ..isCorrect = false;
    ref.read(tangoListControllerProvider.notifier).addQuizResult(result);
    getNextCard();
  }

  String hintText(String value) {
    return value.replaceAll(RegExp(r'[a-zA-Z]'), '*');
  }
}

class QuizOptionEntity {
  String kana = '';
  String romaji = '';
}
