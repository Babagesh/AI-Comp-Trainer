import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';




class TimeLineTileUI extends StatelessWidget
{
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventChild;

  const TimeLineTileUI(
    {Key? key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.eventChild})
     : super(key: key);

@override

Widget build (BuildContext context)
{
  return SizedBox(
    height: 200,
    child: TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isPast ? Color(0xFF6495ED): Color(0xFFADD8E6),
    ),
    indicatorStyle: IndicatorStyle(
      width: 40,
      color: isPast ? Color(0xFF0000FF): Color(0xFF00FFFF),
      iconStyle: IconStyle(
        iconData: Icons.check_circle,
      color: isPast ? Colors.greenAccent:Color(0xFFB0A695),
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
  const EventPath({Key? key, required this.isPast, required this.childWidget}) : super(key : key);


  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: BoxDecoration(
        color: isPast? Color(0xFF6495ED): Color(0xFFADD8E6),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.all(20),
      child: childWidget,
    ); 
  }
}