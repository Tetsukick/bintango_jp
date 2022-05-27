import 'dart:io';

import 'package:bintango_jp/utils/common_banner_ad.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:bintango_jp/config/color_config.dart';
import 'package:bintango_jp/config/size_config.dart';
import 'package:bintango_jp/domain/tango_list_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bintango_jp/gen/assets.gen.dart';
import 'package:bintango_jp/model/tango_entity.dart';
import 'package:bintango_jp/model/word_status_type.dart';
import 'package:bintango_jp/screen/dictionary_detail_screen.dart';
import 'package:bintango_jp/utils/common_text_widget.dart';
import 'package:bintango_jp/utils/logger.dart';
import 'package:bintango_jp/utils/shimmer.dart';

import '../config/config.dart';
import '../model/floor_database/database.dart';
import '../model/floor_entity/word_status.dart';
import '../model/floor_migrations/migration_v1_to_v2_add_bookmark_column_in_word_status_table.dart';
import '../utils/analytics/analytics_event_entity.dart';
import '../utils/analytics/analytics_parameters.dart';
import '../utils/analytics/firebase_analytics.dart';

class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();

  static void navigateTo(BuildContext context) {
    Navigator.push<void>(context, MaterialPageRoute(
      builder: (context) {
        return const TranslationScreen();
      },
    ));
  }
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  final itemCardHeight = 88.0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<TangoEntity> _searchedTango = [];
  AppDatabase? database;
  bool _isIndonesiaToJapanese = true;
  TextEditingController _inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _inputFocusNode = FocusNode();

  @override
  void initState() {
    FirebaseAnalyticsUtils.analytics
        .setCurrentScreen(screenName: AnalyticsScreen.translation.name);
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
  Widget build(BuildContext context) {
    final tangoList = ref.watch(tangoListControllerProvider);
    return Scaffold(
      key: _key,
      backgroundColor: ColorConfig.bgPinkColor,
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SizeConfig.mediumSmallMargin),
          child: Column(
            children: [
              _titleBar(),
              SizedBox(height: SizeConfig.smallMargin),
              _inputField(),
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, SizeConfig.mediumSmallMargin, 0, SizeConfig.bottomBarHeight),
                  itemBuilder: (BuildContext context, int index){
                    if (index == 0) {
                      return _adWidget();
                    }
                    TangoEntity tango = tangoList.translateMaster.includedTangos[index - 1];
                    return tangoListItem(tango);
                  },
                  itemCount: tangoList.translateMaster.includedTangos.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adWidget() {
    return Container();
    return FutureBuilder<Widget>(
      future: Ads.buildBannerWidget(
        context: context,
      ),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Container();

        return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: snapshot.data,
        );
      },
    );
  }

  Widget _titleBar() {
    const _japanese = 'Japanese';
    const _indonesian = 'Indonesian';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextWidget.titleRedMedium(_isIndonesiaToJapanese ? _indonesian : _japanese),
        ElevatedButton(
          onPressed: () {
            setState(() => _isIndonesiaToJapanese = !_isIndonesiaToJapanese);
          },
          child: Assets.png.reverse128.image(width: 24, height: 24),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder()
          ),
        ),
        TextWidget.titleRedMedium(_isIndonesiaToJapanese ? _japanese : _indonesian),
      ],
    );
  }

  Widget _inputField() {
    const _japanese = '文章を入力してください';
    const _indonesian = 'Silakan masukkan kalimatnya';
    final tangoList = ref.watch(tangoListControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  maxLines: null,
                  minLines: null,
                  focusNode: _inputFocusNode,
                  controller: _inputController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    hintText: _isIndonesiaToJapanese ? _indonesian : _japanese,
                    alignLabelWithHint: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _inputController.clear(),
                    ),
                  ),
                  onSaved: (value) async {
                    logger.d('search orgin value: $value');
                    if (value != null) {
                      ref.read(tangoListControllerProvider.notifier).translate(value, isIndonesianToJapanese: _isIndonesiaToJapanese).then((result) async {
                        if (!_isIndonesiaToJapanese) {
                          await ref.read(tangoListControllerProvider.notifier).searchIncludeWords(result.text ?? '');
                        } else {
                          await ref.read(tangoListControllerProvider.notifier).searchIncludeWords(value);
                        }
                        setState(() {});
                      });
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _formKey.currentState?.save();
                },
                child: Assets.png.search128.image(width: 24, height: 24),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder()
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.mediumSmallMargin),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorConfig.bgGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(SizeConfig.mediumSmallMargin),
              child: TextWidget.titleGrayMedium(
                  tangoList.translateMaster.translateApiResponse?.text ?? '',
                  maxLines: 30),
            ),
          ),
        ],
      )
    );
  }

  Widget tangoListItem(TangoEntity tango) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: SizeConfig.mediumSmallMargin),
      child: InkWell(
        onTap: () {
          analytics(DictionaryItem.dictionaryItem);
          DictionaryDetail.navigateTo(context, tangoEntity: tango);
        },
        child: Card(
          child: Container(
            width: double.infinity,
            height: itemCardHeight,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: SizeConfig.smallMargin, horizontal: SizeConfig.mediumSmallMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      wordStatus(tango),
                      SizedBox(height: SizeConfig.smallestMargin,),
                      TextWidget.titleBlackMediumBold(tango.indonesian ?? ''),
                      SizedBox(height: 2,),
                      TextWidget.titleGraySmall(tango.japanese ?? ''),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: bookmark(tango),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<WordStatus?> getWordStatus(TangoEntity entity) async {
    final wordStatusDao = database?.wordStatusDao;
    final wordStatus = await wordStatusDao?.findWordStatusById(entity.id!);
    return wordStatus;
  }

  Future<WordStatus?> getBookmark(TangoEntity entity) async {
    final wordStatusDao = database?.wordStatusDao;
    final wordStatus = await wordStatusDao?.findWordStatusById(entity.id!);
    return wordStatus;
  }

  Widget bookmark(TangoEntity entity) {
    return FutureBuilder(
        future: getBookmark(entity),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            WordStatus? status = snapshot.data as WordStatus?;
            bool isBookmark = status == null ? false : status.isBookmarked;
            return Visibility(
              visible: isBookmark,
              child: Padding(
                padding: const EdgeInsets.only(right: SizeConfig.mediumSmallMargin),
                child: Assets.png.bookmarkOn64.image(height: 24, width: 24),
              ),
            );
          } else {
            return  Padding(
              padding: const EdgeInsets.only(right: SizeConfig.mediumSmallMargin),
              child: ShimmerWidget.rectangular(width: 24, height: 24,),
            );
          }
        });
  }

  Widget wordStatus(TangoEntity entity) {
    return FutureBuilder(
        future: getWordStatus(entity),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final status = snapshot.data as WordStatus?;
            final statusType = status == null ? WordStatusType.notLearned : WordStatusTypeExt.intToWordStatusType(status.status);
            return Row(
              children: [
                statusType.icon,
                SizedBox(width: SizeConfig.smallestMargin),
                TextWidget.titleGraySmallest(statusType.title),
              ],
            );
          } else {
            return Row(
              children: [
                ShimmerWidget.circular(width: 16, height: 16),
                SizedBox(width: SizeConfig.smallestMargin),
                ShimmerWidget.rectangular(height: 12, width: 80),
              ],
            );
          }
        });
  }

  void analytics(DictionaryItem item, {String? others = ''}) {
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
