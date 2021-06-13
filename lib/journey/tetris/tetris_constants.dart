import 'package:tetr/journey/common/constants.dart';

class TetrisBlock {
  static Block orangeRicky = [
    [0, 0, 1],
    [1, 1, 1],
  ];
  static Block blueRicky = [
    [1, 0, 0],
    [1, 1, 1],
  ];
  static Block cleveLandZ = [
    [1, 1, 0],
    [0, 1, 1],
  ];
  static Block rodheIslandZ = [
    [0, 1, 1],
    [1, 1, 0],
  ];
  static Block hero = [
    [1, 1, 1, 1],
    [0, 0, 0, 0],
  ];
  static Block teewee = [
    [0, 1, 0],
    [1, 1, 1],
  ];
  static Block smashBoy = [
    [1, 1],
    [1, 1],
  ];

  static List<Block> getAll = [
    orangeRicky,
    blueRicky,
    cleveLandZ,
    rodheIslandZ,
    hero,
    teewee,
    smashBoy,
  ];
}
