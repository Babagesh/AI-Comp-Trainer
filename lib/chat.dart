import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  static const routeName  = '/chat';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatHistory = [];

  String curText = "";
  String username = "";
  bool user = false;
  final completer = new Completer<void>();
  late var nextButtonCompleter = completer;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    initializeChat();
  }

  void initializeChat() async {
    getUsername();
    await completer.future;
    completed = true;
    populateNewUser();
    firstQ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text("Chat", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: _chatHistory.length,
              shrinkWrap: false,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index){
                return Container(
                  padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (_chatHistory[index]["isSender"]?Alignment.topRight:Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: (_chatHistory[index]["isSender"]?const Color(0xFFF69170):Colors.white),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(_chatHistory[index]["message"], style: TextStyle(fontSize: 15, color: _chatHistory[index]["isSender"]?Colors.white:Colors.black)),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: GradientBoxBorder(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFF69170),
                                  Color(0xFF7D96E6),
                                ]
                            ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          controller: _chatController,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0,),
                  MaterialButton(
                    onPressed: (){
                      if(!completed) {
                        nextButtonCompleter.complete();
                      }
                      setState(() {
                        if(_chatController.text.isNotEmpty){
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": _chatController.text,
                            "isSender": true,
                          });
                          curText = _chatController.text;
                          getAnswer();
                          _chatController.clear();
                        }
                      });
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF69170),
                              Color(0xFF7D96E6),
                            ]
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: const Icon(Icons.send, color: Colors.white,)
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void getUsername() {
    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": "Please enter a key.",
        "isSender": false,
      });
    });
  }

  void getAnswer() {
    switch (curText) {
      case "1": 
        generateQuestion(1);
      default:
        if(user) {
          setState(() {
            _chatHistory.add({
              "time": DateTime.now(),
              "message": "That is not a valid option, please try again.",
              "isSender": false,
            });
          });
        }
        else {
          username = _chatController.text;
          user = true;
          setState(() {
            _chatHistory.add({
              "time": DateTime.now(),
              "message": "Thanks for entering a key!",
              "isSender": false,
            });
          });
        }
    } 
  }

  void firstQ() {
    setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": "What would you like to do:\n1. Practice Putnam",
          "isSender": false,
        });
    });
  }

  void populateNewUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isNewUser = user.metadata.creationTime?.isAfter(DateTime.now().subtract(Duration(minutes: 5))) ?? false;
      if(isNewUser) {
        CollectionReference examples = FirebaseFirestore.instance.collection('examples');
        examples.doc(username).set(<String, dynamic>{
          'type': "Putnam",
          'question': "A grasshopper starts at the origin in the coordinate plane and makes a sequence of hops. Each hop has length 5, and after each hop the grasshopper is at a point whose coordinates are both integers; thus, there are 12 possible locations for the grasshopper after the first hop. What is the smallest number of hops needed for the grasshopper to reach the point (2021,2021)?",
          'topic': "Optimization",
          'timestamp': DateTime.now(),
        });
      }
    }
  }

  void generateQuestion(int option) async {
  const apiKey = "AIzaSyB_VtqbTpHFjMZCgeC8UmG8Xn-yM2qTWEo";
  final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);

  List<Content> content;

  if (option == 1) {
    final docId = username;
    final topic = await retrieveField(docId, 'topic');
    final question = await retrieveField(docId, 'question');
    
    content = [Content.text("Give me a Putnam question about $topic similar to $question")];

    try {
      final response = await model.generateContent(content);

      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": response.text,
          "isSender": false,
        });
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": "Error generating content: $e",
          "isSender": false,
        });
      });
    }
  } else {
    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": "The option you selected was not valid, please try again.",
        "isSender": false,
      });
    });
  }
}

  Future<String> retrieveField(String documentId, String fieldName) async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('examples').doc(documentId).get();
    return (document.data() as Map<String, dynamic>)[fieldName] ?? 'Field not found';
  }
}