import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_size/firestore_size.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

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
            for(int i = 0; i < 5; i++)
              TimeLineTileUI(
                isFirst: false, 
                isLast: false, 
                isPast: true, 
                eventChild: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Row(children: [
                    const Icon(Icons.book_online, color: Colors.white),
                    const SizedBox(width: 15,),
                    const Text(
                      'answer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text('    |   Date: {$DateTime.day}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
                ),
                const Text('Question: ', style: TextStyle(color: Colors.white),),
                const Text('Answer: ', style: TextStyle(color: Colors.white),),
              ],
              ),
            ), 
          ],
        )
      ),
    );

  }
    Future<String> retrieveField(String cName, String documentId, String fieldName) async 
    {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection(cName).doc(documentId).get();
    return (document.data() as Map<String, dynamic>)[fieldName] ?? 'Field not found';
  }
}