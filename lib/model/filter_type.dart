enum FilterType {
  wordStatus,
  levelGroup,
  category
}

extension FilterTypeExt on FilterType {
  String get title {
    switch (this) {
      case FilterType.wordStatus:
        return 'status kata';
      case FilterType.levelGroup:
        return 'level';
      case FilterType.category:
        return 'category';
    }
  }
}