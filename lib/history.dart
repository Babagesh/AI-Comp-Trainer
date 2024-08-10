import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'timeline.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({Key? key}) : super(key : key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
{
  // Get the size of the database in 
  // Make the first 
  // Make a for loop and make a new TimeLineUi each time, traversing through the database and getting each chat event from it
  // End the loop one index before
  // Make the final TimeLineTileUI object with isLast as true and isPast false. 
  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right:  30),
        child: ListView(
          children: [
            TimeLineTileUI(
              isFirst: true,
              isLast: false,
              isPast: true,
              eventChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(children: [
                    Icon(Icons.book_online, color: Colors.white),
                    SizedBox(width: 15,),
                    Text(
                      'Most recent chat',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text('    |   Date: {$DateTime.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                  ),
                  Text('Question: ', style: TextStyle(color: Colors.white),),
                  Text('Answer: ', style: TextStyle(color:Colors.white)),
                ],
              ),
            ),
            for(int i = 1; i < 5; i++)
              TimeLineTileUI(
                isFirst: false, 
                isLast: false, 
                isPast: true, 
                eventChild: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Row(children: [
                    Icon(Icons.book_online, color: Colors.white),
                    SizedBox(width: 15,),
                    Text(
                      'Every chat item after index 0',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text('    |   Date: {$DateTime.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
                ),
                Text('Question: ', style: TextStyle(color: Colors.white),),
                Text('Answer: ', style: TextStyle(color: Colors.white),),
              ],
              ),
            ), 
            TimeLineTileUI(
              isFirst: false, 
              isLast: true, 
              isPast: false, 
              eventChild: Column
              (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(children: [
                    Icon(Icons.book, color: Colors.white),
                    SizedBox(width: 15),
                    Text(
                      'Last chat item in database - First question asked(index length - 1)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      
                    ),
                    Text('    |   Date: {$DateTime.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                  ),
                  Text('Question: ', style: TextStyle(color: Colors.white),),
                  Text('Answer: ', style: TextStyle(color: Colors.white),),
                ],
                ),
              ),
          ],
        )
      ),
    );
  }
}