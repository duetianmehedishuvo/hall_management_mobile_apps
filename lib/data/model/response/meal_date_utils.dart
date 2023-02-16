// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}


final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
