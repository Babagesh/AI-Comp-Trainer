import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return SfCalendar(
      view: CalendarView.week,
    );
  }
}