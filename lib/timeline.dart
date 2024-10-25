import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';




class TimeLineTileUI extends StatelessWidget
{
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventChild;

  const TimeLineTileUI(
    {super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.eventChild});

@override

Widget build (BuildContext context)
{
  return SizedBox(
    height: 200,
    child: TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isPast ? const Color(0xFF6495ED): const Color(0xFF6495ED),
    ),
    indicatorStyle: IndicatorStyle(
      width: 40,
      color: isPast ? const Color(0xFF0000FF): const Color(0xFF0000FF),
      iconStyle: IconStyle(
        // if wrong change icon as well
        iconData: Icons.check_circle,
        // Make the second or first color red if the user gets the question wrong
      color: isPast ? Colors.greenAccent:const Color(0xFFB0A695),
    ),
    ),
    endChild: EventPath(
      isPast: isPast,
      childWidget: eventChild,
    ),
  ),
    );
}
}
class EventPath extends StatelessWidget{
  final bool  isPast;
  final childWidget;
  const EventPath({super.key, required this.isPast, required this.childWidget});


  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: BoxDecoration(
        color: isPast? const Color(0xFF6495ED): const Color(0xFF6495ED),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(20),
      child: childWidget,
    ); 
  }
}