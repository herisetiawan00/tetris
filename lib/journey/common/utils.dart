
void printBlock(List<List<int>> block) {
  print('');
  block.forEach((row) {
    print(row.map((e) => e == 0 ? ' ' : '█').join());
  });
  print('');
}