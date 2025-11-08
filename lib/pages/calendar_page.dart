import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
          child: TableCalendar(
            locale: 'en_US',
            headerStyle: HeaderStyle(titleCentered: true),
            availableGestures: AvailableGestures.all,
            focusedDay: today, 
            selectedDayPredicate: (day)=>isSameDay(day, today),
            firstDay: DateTime.utc(2024,1,1), 
            lastDay: DateTime.utc(2034,1,1),
            onDaySelected: _onDaySelected,
            )
        )
      ],      
    );
  }
}