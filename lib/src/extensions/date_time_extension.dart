///
extension DateTimeX on DateTime {
  ///
  DateTime get now => DateTime.now();

  ///
  bool get isToday => day == now.day && year == now.year && month == now.month;
}
