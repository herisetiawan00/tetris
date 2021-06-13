class GlobalIndexEntity {
  int indexX;
  int indexY;

  GlobalIndexEntity(this.indexX, this.indexY);

  @override
  String toString() => 'GlobalIndex(x: $indexX, y: $indexY)';

  @override
  bool operator ==(Object other) {
    if (other is GlobalIndexEntity) {
      return other.indexX == indexX && other.indexY == indexY;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}
