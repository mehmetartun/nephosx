class Slot {
  final DateTime from;
  final DateTime to;

  Slot({required this.from, required this.to});

  bool isOverlapping(Slot other) {
    return from.isBefore(other.to) && to.isAfter(other.from);
  }

  Duration duration() {
    return to.difference(from);
  }

  @override
  String toString() {
    return 'Slot(from: $from, to: $to)';
  }
}
