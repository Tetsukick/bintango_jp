import 'package:bintango_jp/gen/assets.gen.dart';

enum TangoCategory {
  number,
  occupation,
  country,
  language,
  places,
  season,
  people,
  animals,
  clothing,
  nature,
  bodyParts,
  food,
  beverage,
  fruits,
  vehicles,
  sports,
  stationery,
  home,
  dayOfTheWeek,
  dateTime,
  musicAndInstrument,
  verb1,
  verb2,
  verb3,
  adverbs,
  iAdjective,
  naAdjective,
  interrogative,
  directions,
  color,
  illnessAndAccident,
  hobbies,
  events
}

extension TangoCategoryExt on TangoCategory {
  int get id => index + 1;

  String get title {
    switch (this) {
      case TangoCategory.number:
        return 'Number';
      case TangoCategory.occupation:
        return 'Occupation';
      case TangoCategory.country:
        return 'Country';
      case TangoCategory.language:
        return 'Language';
      case TangoCategory.places:
        return 'Place';
      case TangoCategory.season:
        return 'Season';
      case TangoCategory.people:
        return 'People';
      case TangoCategory.animals:
        return 'Animal';
      case TangoCategory.clothing:
        return 'Clothing';
      case TangoCategory.nature:
        return 'Nature';
      case TangoCategory.bodyParts:
        return 'Body Parts';
      case TangoCategory.food:
        return 'Food';
      case TangoCategory.beverage:
        return 'Beverage';
      case TangoCategory.fruits:
        return 'Fruits';
      case TangoCategory.vehicles:
        return 'Vehicles';
      case TangoCategory.sports:
        return 'Sports';
      case TangoCategory.stationery:
        return 'Stationery';
      case TangoCategory.home:
        return 'Home';
      case TangoCategory.dayOfTheWeek:
        return 'Day of the week';
      case TangoCategory.dateTime:
        return 'Date/Time';
      case TangoCategory.musicAndInstrument:
        return 'Music/Instrument';
      case TangoCategory.verb1:
        return 'Verb1 (U-verbs)';
      case TangoCategory.verb2:
        return 'Verb2 (Ru-verbs)';
      case TangoCategory.verb3:
        return 'Verb3 (Irregular verbs)';
      case TangoCategory.adverbs:
        return 'Adverbs';
      case TangoCategory.iAdjective:
        return 'i - Adverbs';
      case TangoCategory.naAdjective:
        return 'na - Adverbs';
      case TangoCategory.interrogative:
        return 'Interrogative';
      case TangoCategory.directions:
        return 'Directions';
      case TangoCategory.color:
        return 'Color';
      case TangoCategory.illnessAndAccident:
        return 'Illness/Accident';
      case TangoCategory.hobbies:
        return 'Hobby';
      case TangoCategory.events:
        return 'Event';
    }
  }

  SvgGenImage get svg {
    switch (this) {
      case TangoCategory.number:
        return Assets.svg.money;
      case TangoCategory.occupation:
        return Assets.svg.work;
      case TangoCategory.country:
        return Assets.svg.world2;
      case TangoCategory.language:
        return Assets.svg.world2;
      case TangoCategory.places:
        return Assets.svg.building2;
      case TangoCategory.season:
        return Assets.svg.event;
      case TangoCategory.people:
        return Assets.svg.shodou;
      case TangoCategory.animals:
        return Assets.svg.bear;
      case TangoCategory.clothing:
        return Assets.svg.fashion4;
      case TangoCategory.nature:
        return Assets.svg.world;
      case TangoCategory.bodyParts:
        return Assets.svg.sport2;
      case TangoCategory.food:
        return Assets.svg.food2;
      case TangoCategory.beverage:
        return Assets.svg.drink;
      case TangoCategory.fruits:
        return Assets.svg.food2;
      case TangoCategory.vehicles:
        return Assets.svg.vehicle3;
      case TangoCategory.sports:
        return Assets.svg.sports1;
      case TangoCategory.stationery:
        return Assets.svg.tool2;
      case TangoCategory.home:
        return Assets.svg.buildings;
      case TangoCategory.dayOfTheWeek:
        return Assets.svg.shodou;
      case TangoCategory.dateTime:
        return Assets.svg.day;
      case TangoCategory.musicAndInstrument:
        return Assets.svg.music;
      case TangoCategory.verb1:
        return Assets.svg.superhero;
      case TangoCategory.verb2:
        return Assets.svg.summerVacation;
      case TangoCategory.verb3:
        return Assets.svg.difficult2;
      case TangoCategory.adverbs:
        return Assets.svg.shodou;
      case TangoCategory.iAdjective:
        return Assets.svg.difficult;
      case TangoCategory.naAdjective:
        return Assets.svg.cat;
      case TangoCategory.interrogative:
        return Assets.svg.event2;
      case TangoCategory.directions:
        return Assets.svg.ufo;
      case TangoCategory.color:
        return Assets.svg.shodou;
      case TangoCategory.illnessAndAccident:
        return Assets.svg.rainy;
      case TangoCategory.hobbies:
        return Assets.svg.sport2;
      case TangoCategory.events:
        return Assets.svg.event2;
    }
  }

  static TangoCategory intToCategory({required int value}) {
    switch (value) {
      case 1:
        return TangoCategory.number;
      case 2:
        return TangoCategory.occupation;
      case 3:
        return TangoCategory.country;
      case 4:
        return TangoCategory.language;
      case 5:
        return TangoCategory.places;
      case 6:
        return TangoCategory.season;
      case 7:
        return TangoCategory.people;
      case 8:
        return TangoCategory.animals;
      case 9:
        return TangoCategory.clothing;
      case 10:
        return TangoCategory.nature;
      case 11:
        return TangoCategory.bodyParts;
      case 12:
        return TangoCategory.food;
      case 13:
        return TangoCategory.beverage;
      case 14:
        return TangoCategory.fruits;
      case 15:
        return TangoCategory.vehicles;
      case 16:
        return TangoCategory.sports;
      case 17:
        return TangoCategory.stationery;
      case 18:
        return TangoCategory.home;
      case 19:
        return TangoCategory.dayOfTheWeek;
      case 20:
        return TangoCategory.dateTime;
      case 21:
        return TangoCategory.musicAndInstrument;
      case 22:
        return TangoCategory.verb1;
      case 23:
        return TangoCategory.verb2;
      case 24:
        return TangoCategory.verb3;
      case 25:
        return TangoCategory.adverbs;
      case 26:
        return TangoCategory.iAdjective;
      case 27:
        return TangoCategory.naAdjective;
      case 28:
        return TangoCategory.interrogative;
      case 29:
        return TangoCategory.directions;
      case 30:
        return TangoCategory.color;
      case 31:
        return TangoCategory.illnessAndAccident;
      case 32:
        return TangoCategory.hobbies;
      case 33:
        return TangoCategory.events;
      default:
        return TangoCategory.language;
    }
  }
}