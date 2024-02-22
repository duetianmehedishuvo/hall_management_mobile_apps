import 'package:flutter/material.dart';

Future<DateTime?> showDateTimePicker({required BuildContext context, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate;
  lastDate ??= firstDate.add(const Duration(days: 3));

  final DateTime? selectedDate = await showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate);

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(selectedDate));

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}
