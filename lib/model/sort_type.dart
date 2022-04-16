enum SortType {
  indonesian,
  indonesianReverse,
  level,
  levelReverse,
}

extension SortTypeExt on SortType {
  String get title {
    switch (this) {
      case SortType.indonesian:
        return 'A→Z urutan naik';
      case SortType.indonesianReverse:
        return 'Z→A urutan menurun';
      case SortType.level:
        return 'level urutan naik';
      case SortType.levelReverse:
        return 'level urutan menurun';
    }
  }
}