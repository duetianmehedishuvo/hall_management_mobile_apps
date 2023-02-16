import 'package:duetstahall/data/model/response/meal_date_utils.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_button.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/helper/date_converter.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:duetstahall/util/theme/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MyMealScreen extends StatefulWidget {
  const MyMealScreen({Key? key}) : super(key: key);

  @override
  State<MyMealScreen> createState() => _MyMealScreenState();
}

class _MyMealScreenState extends State<MyMealScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 1)),
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<StudentProvider>(context, listen: false).getAllDate();
    // Provider.of<StudentProvider>(context, listen: false).initializeCurrentTime();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(Provider.of<StudentProvider>(context, listen: false).getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = Provider.of<StudentProvider>(context, listen: false).daysInRange(start, end);
    _selectedEvents = ValueNotifier(Provider.of<StudentProvider>(context, listen: false).getEventsForDay(_selectedDay!));
    return [
      for (final d in days) ...Provider.of<StudentProvider>(context, listen: false).getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = Provider.of<StudentProvider>(context, listen: false).getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = Provider.of<StudentProvider>(context, listen: false).getEventsForDay(start);
      // _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      // _selectedEvents.value = _getEventsForDay(end);
      _selectedEvents.value = Provider.of<StudentProvider>(context, listen: false).getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Meal',
        isRefreshEnable2: true,
        onRefreshPressed: () {
          Provider.of<StudentProvider>(context, listen: false).getAllDate();
          _selectedDay = _focusedDay;
        },
      ),
      body: Consumer<StudentProvider>(builder: (context, studentProvider, child) {
        return !studentProvider.isLoadingMeal
            ? Column(
                children: [
                  TableCalendar<Event>(
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonDecoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20.0)),
                        formatButtonTextStyle: const TextStyle(color: Colors.white),
                        formatButtonShowsNext: false),
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    eventLoader: studentProvider.getEventsForDay,
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                      todayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    startingDayOfWeek: StartingDayOfWeek.saturday,
                    calendarStyle: const CalendarStyle(
                        canMarkersOverflow: true,
                        selectedDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                        // todayColor: Colors.orange,
                        // selectedColor: Theme.of(context).primaryColor,
                        todayTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white)),
                    onDaySelected: _onDaySelected,
                    onRangeSelected: _onRangeSelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return value.isNotEmpty
                            ? _selectedDay!.isBefore(studentProvider.currentDateTime) ||
                                    (_selectedDay!.year == studentProvider.currentDateTime.year &&
                                        _selectedDay!.month == studentProvider.currentDateTime.month &&
                                        _selectedDay!.day == studentProvider.currentDateTime.day)
                                ? Text('Can\'t change meal Status', style: headline2.copyWith(color: Colors.red, fontSize: 15))
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 20,
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(right: 15),
                                    child: SizedBox(
                                        width: 180,
                                        child: CustomButton(
                                            btnTxt: '${value.length == 1 ? "Add" : "Cancel"} Guest Meal',
                                            isShowRightIcon: true,
                                            iconData: value.length == 1 ? Icons.set_meal : Icons.no_meals,
                                            onTap: () {
                                              studentProvider.addDateToServer(
                                                  DateConverter.isoStringToDatePushServer(_selectedDay!.toIso8601String()), context,
                                                  isGuestMeal: value.length == 1, isGuestMessage: true);

                                              Provider.of<StudentProvider>(context, listen: false).getAllDate();
                                              _selectedDay = DateTime.now();

                                              //_selectedEvents = ValueNotifier(Provider.of<StudentProvider>(context, listen: false).getEventsForDay(_selectedDay!));
                                            },
                                            backgroundColor: value.length == 1 ? Colors.teal : Colors.red,
                                            height: 45,
                                            radius: 10)),
                                  )
                            : _selectedDay!.isBefore(studentProvider.currentDateTime) ||
                                    (_selectedDay!.year == studentProvider.currentDateTime.year &&
                                        _selectedDay!.month == studentProvider.currentDateTime.month &&
                                        _selectedDay!.day == studentProvider.currentDateTime.day)
                                ? Text('You Haven\'t Any Meal Status on this day!', style: headline2.copyWith(color: Colors.orange, fontSize: 15))
                                : const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              )
            : const CustomLoader();
      }),
    );
  }

  Widget addGuestMeal(BuildContext context, StudentProvider studentProvider) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 20,
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(right: 15),
      child: SizedBox(
          width: 180,
          child: CustomButton(
              btnTxt: 'Add Guest Meal',
              isShowRightIcon: true,
              iconData: Icons.set_meal,
              onTap: () {
                studentProvider.addDateToServer(DateConverter.isoStringToDatePushServer(_selectedDay!.toIso8601String()), context, isGuestMeal: true);

                // studentProvider.addDate(_selectedDay!.add(Duration(days: 1)));
                // studentProvider.removeDate(_selectedDay!);
              },
              height: 45,
              radius: 10)),
    );
  }
}
