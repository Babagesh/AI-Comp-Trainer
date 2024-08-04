import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget
{
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
            title: Text('AI recommended')
          ),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: CalendarWidget()
          ),
        ),
      ],
    ),
    );
    
  }
}

class CalendarWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return SfCalendar(
      view: CalendarView.week,
      initialSelectedDate: DateTime.now(),
    );
  }
}