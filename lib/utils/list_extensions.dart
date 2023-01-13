extension NullToEmptyList<T> on List<T> {
  /// converting null list into []
  convertIntoEmptyListIfNull<T>() {
    if (this == null) {
      return <T>[];
    }
    return this;
  }
}
