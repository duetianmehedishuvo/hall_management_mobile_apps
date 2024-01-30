import 'package:duetstahall/data/model/response/event_model.dart';
import 'package:duetstahall/dining/widgets/custom_app_bar.dart';
import 'package:duetstahall/dining/widgets/custom_loader.dart';
import 'package:duetstahall/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CheckStudentMealScreen extends StatefulWidget {
  final String studentID;

  const CheckStudentMealScreen({this.studentID = '', super.key});

  @override
  State<CheckStudentMealScreen> createState() => _CheckStudentMealScreenState();
}

class _CheckStudentMealScreenState extends State<CheckStudentMealScreen> {
  late final ValueNotifier<List<EventModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;


  @override
  void initState() {
    super.initState();
    Provider.of<StudentProvider>(context, listen: false).getAllDate(studentID: widget.studentID);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(Provider.of<StudentProvider>(context, listen: false).getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventModel> _getEventsForRange(DateTime start, DateTime end) {
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
      appBar: const CustomAppBar(title: 'My Meal'),
      body: Consumer<StudentProvider>(builder: (context, studentProvider, child) {
        return !studentProvider.isLoadingMeal
            ? Column(
                children: [
                  TableCalendar<EventModel>(
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

                ],
              )
            : const CustomLoader();
      }),
    );
  }
}
