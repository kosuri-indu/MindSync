import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({super.key});

  @override
  _MoodCalendarState createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, String> _moodImages = {
    DateTime.utc(2025, 2, 1): 'assets/images/happy_face.png',
    DateTime.utc(2025, 2, 2): 'assets/images/sad_face.png',
    DateTime.utc(2025, 2, 3): 'assets/images/angry_face.png',
    DateTime.utc(2025, 2, 4): 'assets/images/med_face.png',
    DateTime.utc(2025, 2, 5): 'assets/images/laugh_face.png',
    DateTime.utc(2025, 2, 6): 'assets/images/happy_face.png',
    DateTime.utc(2025, 2, 7): 'assets/images/sad_face.png',
    DateTime.utc(2025, 2, 8): 'assets/images/angry_face.png',
    DateTime.utc(2025, 2, 9): 'assets/images/med_face.png',
    DateTime.utc(2025, 2, 10): 'assets/images/laugh_face.png',
    DateTime.utc(2025, 2, 11): 'assets/images/happy_face.png',
    DateTime.utc(2025, 2, 12): 'assets/images/sad_face.png',
    DateTime.utc(2025, 2, 13): 'assets/images/angry_face.png',
    DateTime.utc(2025, 2, 14): 'assets/images/med_face.png',
    DateTime.utc(2025, 2, 15): 'assets/images/laugh_face.png',
    DateTime.utc(2025, 2, 16): 'assets/images/laugh_face.png',
    DateTime.utc(2025, 2, 17): 'assets/images/happy_face.png',
    DateTime.utc(2025, 2, 18): 'assets/images/sad_face.png',
    DateTime.utc(2025, 2, 19): 'assets/images/angry_face.png',
    DateTime.utc(2025, 2, 20): 'assets/images/med_face.png',
    DateTime.utc(2025, 2, 21): 'assets/images/laugh_face.png',
    // Add more dates and corresponding images as needed
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mood Calendar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
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
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (_moodImages.containsKey(day)) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _moodImages[day]!,
                            height: 23,
                            width: 23,
                          ),
                          Text(
                            '${day.day}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
