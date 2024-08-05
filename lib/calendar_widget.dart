import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget
{
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Center(
    child: Column
    (
      children: [
        for(int i = 1; i < 6; i++)
          ListTile(
            leading: Text(i.toString()),
            title: const Text('AI recommended')
          ),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const CalendarWidget()
          ),
        ),
        
      ],
    ),
    );
    
  }
}

class CalendarWidget extends StatelessWidget{
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context)
  {
    return SfCalendar(
      view: CalendarView.week,
      initialSelectedDate: DateTime.now(),
    );
    
  }
}