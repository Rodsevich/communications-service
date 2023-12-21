/// Contains new features for [DateTime] class.
extension DateTimeX on DateTime {
  /// Current date
  DateTime get now => DateTime.now();

  /// Whether or not the date is the current date
  bool get isToday => day == now.day && year == now.year && month == now.month;
}
