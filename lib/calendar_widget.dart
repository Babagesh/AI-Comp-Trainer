import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lessonplan.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';


class EventDataSource extends CalendarDataSource{
    EventDataSource(List<Event> appointments)
    {
      this.appointments = appointments;
    }
    Event getEvent(int index) => appointments![index] as Event;

    @override
    DateTime getStartTime(int index) => getEvent(index).from;
    @override
    DateTime getEndTime(int index) => getEvent(index).to;
    @override
    String getSubject(int index) => getEvent(index).title;
    
  }
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

class TasksWidget extends StatefulWidget{
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}
class _TasksWidgetState extends State<TasksWidget>
{
  @override
  Widget build(BuildContext context)
  {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if(selectedEvents.isEmpty)
    {
      return Center(
        child: Text(
        'No Events Found!',
        style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }
    return SfCalendarTheme(
      data: SfCalendarThemeData(
      timeTextStyle: TextStyle(fontSize: 16, color: Colors.black)
      ),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialDisplayDate: provider.SelectedDate,
        appointmentBuilder: appointmentBuilder,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        onTap: (details) {},
      ),
    );
  }
  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ){
      final event = details.appointments.first;

      return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
          color: event.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),
      );
    }
}
class CalendarWidget extends StatelessWidget{

  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context)
  {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.week,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context,listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context, 
          builder: (context) => TasksWidget(),
          );
      },
    );
    
  }
}