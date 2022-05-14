import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:bintango_jp/config/color_config.dart';
import 'package:bintango_jp/config/size_config.dart';
import 'package:bintango_jp/gen/assets.gen.dart';
import 'package:bintango_jp/model/part_of_speech.dart';
import 'package:bintango_jp/model/tango_entity.dart';
import 'package:bintango_jp/utils/common_text_widget.dart';
import 'package:lottie/lottie.dart';

import '../config/config.dart';
import '../model/floor_database/database.dart';
import '../model/floor_entity/word_status.dart';
import '../model/floor_migrations/migration_v1_to_v2_add_bookmark_column_in_word_status_table.dart';
import '../model/word_status_type.dart';
import '../utils/analytics/analytics_event_entity.dart';
import '../utils/analytics/analytics_parameters.dart';
import '../utils/analytics/firebase_analytics.dart';
import '../utils/shared_preference.dart';
import '../utils/shimmer.dart';

class DictionaryDetail extends ConsumerStatefulWidget {
  final TangoEntity tangoEntity;

  static void navigateTo(
      BuildContext context,
      {required TangoEntity tangoEntity}) {
    Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) {
        return DictionaryDetail(tangoEntity: tangoEntity);
      },
    ));
  }

  const DictionaryDetail({Key? key, required this.tangoEntity}) : super(key: key);

  @override
  ConsumerState<DictionaryDetail> createState() => _DictionaryDetailState();
}

class _DictionaryDetailState extends ConsumerState<DictionaryDetail> {
  FlutterTts flutterTts = FlutterTts();
  bool _isSoundOn = true;
  final _iconHeight = 20.0;
  final _iconWidth = 20.0;
  AppDatabase? database;

  @override
  void initState() {
    FirebaseAnalyticsUtils.analytics.setCurrentScreen(screenName: AnalyticsScreen.dictionaryDetail.name);
    initializeDB();
    setTTS();
    loadSoundSetting();
    super.initState();
  }

  void setTTS() {
    flutterTts.setLanguage('ja-JP');
  }

  void loadSoundSetting() async {
    _isSoundOn = await PreferenceKey.isSoundOn.getBool();
    setState(() {});
    if (_isSoundOn) {
      flutterTts.speak(this.widget.tangoEntity.japanese ?? '');
    }
  }

  void initializeDB() async {
    final _database = await $FloorAppDatabase
        .databaseBuilder(Config.dbName)
        .addMigrations([migration1to2])
        .build();;
    setState(() => database = _database);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.bgPinkColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SizeConfig.smallMargin),
          child: Stack(
            children: [
              Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(SizeConfig.mediumSmallMargin),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _topBarSection(),
                        SizedBox(height: SizeConfig.smallMargin),
                        _japanese(),
                        SizedBox(height: SizeConfig.smallestMargin),
                        _separater(),
                        _indonesian(),
                        SizedBox(height: SizeConfig.smallMargin),
                        _english(),
                        SizedBox(height: SizeConfig.smallMargin),
                        _descriptionHeader(),
                        SizedBox(height: SizeConfig.smallMargin),
                        _description(),
                        SizedBox(height: SizeConfig.smallMargin),
                      ],
                    ),
                  ),
                ),
              ),
              bookmark(this.widget.tangoEntity)
            ],
          ),
        ),
      ),
    );
  }

  Widget bookmark(TangoEntity entity) {
    final wordStatusDao = database?.wordStatusDao;

    return FutureBuilder(
        future: getBookmark(entity),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            WordStatus? status = snapshot.data as WordStatus?;
            bool isBookmark = status == null ? false : status.isBookmarked;
            if (status == null) {
              status = WordStatus(wordId: entity.id!, status: WordStatusType.notLearned.id, isBookmarked: false);
              wordStatusDao?.insertWordStatus(status);
            }
            return Padding(
              padding: const EdgeInsets.only(left: SizeConfig.mediumSmallMargin),
              child: InkWell(
                onTap: () {
                  analytics(DictionaryDetailItem.bookmark);
                  wordStatusDao?.updateWordStatus(status!..isBookmarked = !isBookmark);
                  setState(() => isBookmark = !isBookmark);
                },
                child: isBookmark ? Assets.png.bookmarkOn64.image(height: 32, width: 32)
                    : Assets.png.bookmarkOff64.image(height: 32, width: 32),
              ),
            );
          } else {
            return  Padding(
              padding: const EdgeInsets.only(left: SizeConfig.mediumSmallMargin),
              child: ShimmerWidget.rectangular(width: 24, height: 24,),
            );
          }
        });
  }

  Future<WordStatus?> getBookmark(TangoEntity entity) async {
    final wordStatusDao = database?.wordStatusDao;
    final wordStatus = await wordStatusDao?.findWordStatusById(entity.id!);
    return wordStatus;
  }

  Widget _topBarSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _soundButton(this.widget.tangoEntity.japanese!),
        IconButton(
            onPressed: () {
              analytics(DictionaryDetailItem.close);
              Navigator.pop(context);
            },
            icon: Icon(Icons.close,
              color: ColorConfig.bgGrey,
              size: SizeConfig.largeSmallMargin,
            ))
      ],
    );
  }

  Widget _indonesian() {
    return Row(
      children: [
        Assets.png.indonesia64.image(height: _iconHeight, width: _iconWidth),
        SizedBox(width: SizeConfig.mediumSmallMargin),
        Flexible(child: TextWidget.titleGrayLargeBold(this.widget.tangoEntity.indonesian!, maxLines: 2)),
      ],
    );
  }

  Widget _japanese() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Assets.png.japanFuji64.image(height: _iconHeight, width: _iconWidth),
            SizedBox(width: SizeConfig.mediumSmallMargin),
            Flexible(child: TextWidget.titleBlackLargestBold(this.widget.tangoEntity.japaneseKana!, maxLines: 2)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(SizeConfig.smallestMargin),
          child: TextWidget.titleBlackLargeBold(this.widget.tangoEntity.romaji!, maxLines: 2),
        ),
        Padding(
          padding: const EdgeInsets.all(SizeConfig.smallestMargin),
          child: TextWidget.titleBlackLargeBold(this.widget.tangoEntity.japanese!, maxLines: 2),
        ),
      ],
    );
  }

  Widget _english() {
    return Row(
      children: [
        Assets.png.english64.image(height: _iconHeight, width: _iconWidth),
        SizedBox(width: SizeConfig.mediumSmallMargin),
        Flexible(child: TextWidget.titleGrayLargeBold(this.widget.tangoEntity.english!, maxLines: 2)),
      ],
    );
  }

  Widget _exampleHeader() {
    return Row(
      children: [
        TextWidget.titleRedMedium('例文', maxLines: 1),
        SizedBox(width: SizeConfig.mediumSmallMargin),
        Flexible(child: _separater())
      ],
    );
  }

  Widget _descriptionHeader() {
    return Visibility(
      visible: this.widget.tangoEntity.description != null && this.widget.tangoEntity.description != '',
      child: Row(
        children: [
          TextWidget.titleRedMedium('豆知識', maxLines: 1),
          SizedBox(width: SizeConfig.mediumSmallMargin),
          Flexible(child: _separater())
        ],
      ),
    );
  }

  Widget _description() {
    return Visibility(
      visible: this.widget.tangoEntity.description != null && this.widget.tangoEntity.description != '',
      child: Row(
        children: [
          Assets.png.infoNotes.image(height: _iconHeight, width: _iconWidth),
          SizedBox(width: SizeConfig.mediumSmallMargin),
          Flexible(child: TextWidget.titleGrayMediumBold(this.widget.tangoEntity.description ?? '', maxLines: 10)),
        ],
      ),
    );
  }

  Widget _separater() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SizeConfig.mediumMargin),
      child: Container(
        height: 1,
        width: double.infinity,
        color: ColorConfig.bgGreySeparater,
      ),
    );
  }

  Widget _soundButton(String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            analytics(DictionaryDetailItem.sound);
            flutterTts.speak(data);
          },
          child: Padding(
            padding: const EdgeInsets.all(SizeConfig.mediumSmallMargin),
            child: Assets.png.soundOn64.image(height: 32)
          ),
        ),
      ],
    );
  }

  void analytics(DictionaryDetailItem item, {String? others = ''}) {
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
}
