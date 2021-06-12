class Constants {
  static List<List<int>> dot = [
    [1]
  ];
  static List<List<int>> orangeRicky = [
    [0, 0, 1],
    [1, 1, 1],
  ];
  static List<List<int>> blueRicky = [
    [1, 0, 0],
    [1, 1, 1],
  ];
  static List<List<int>> cleveLandZ = [
    [1, 1, 0],
    [0, 1, 1],
  ];
  static List<List<int>> rodheIslandZ = [
    [0, 1, 1],
    [1, 1, 0],
  ];
  static List<List<int>> hero = [
    [1, 1, 1, 1],
    [0, 0, 0, 0],
  ];
  static List<List<int>> teewee = [
    [0, 1, 0],
    [1, 1, 1],
  ];
  static List<List<int>> smashBoy = [
    [1, 1],
    [1, 1],
  ];
  static List<List<List<int>>> blockList = [
    orangeRicky,
    blueRicky,
    cleveLandZ,
    rodheIslandZ,
    hero,
    teewee,
    smashBoy,
  ];
}

void printBlock(List<List<int>> block) {
  print('');
  block.forEach((row) {
    print(row.map((e) => e == 0 ? ' ' : '█').join());
  });
  print('');
}

extension IntExtension on int {
  String? get alphabet {
    switch (this) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      case 4:
        return 'E';
      case 5:
        return 'F';
      case 6:
        return 'G';
      case 7:
        return 'H';
      case 8:
        return 'I';
      case 9:
        return 'J';
      case 10:
        return 'K';
      case 11:
        return 'L';
      case 12:
        return 'M';
      case 13:
        return 'N';
      case 14:
        return 'O';
      case 15:
        return 'P';
    }
  }
}
