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

  var usernameCompleter = Completer<void>();
  late var uCompleter = usernameCompleter;

  var answerCompleter = Completer<void>();
  late var aCompleter = answerCompleter;

  String curQuestion = "";
  String userAnswer = "";
  String currentType = "";
  String currentTopic = "";
  String aiAnswer = "";

  late CollectionReference putnam;
  late CollectionReference scibowl;
  late CollectionReference usercustom;

  // Controls the document ID of questions put into database
  int putnamqcount = 0;
  int scibowlqcount = 0;
  int usercustomqcount = 0;

  // Controls the current question the user is practicing
  int putnampcount = 0;
  int scibowlpcount = 0;
  int usercustompcount = 0;

  String currentCollection = "";

  @override
  void initState() {
    super.initState();
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
                      setState(() {
                        if(curText == "4") {
                          uCompleter.complete();
                        }
                        if(curText == "7") {
                          aCompleter.complete();
                        }
                        if(_chatController.text.isNotEmpty){
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": _chatController.text,
                            "isSender": true,
                          });
                          curText = _chatController.text;
                          if(curText.substring(0, 1) == "/") {
                            userAnswer = curText;
                          }
                          else if(curText.substring(0, 1) == ".") {
                            customQuestion(curText);
                          }
                          else {
                            getAnswer();
                          }
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
        currentCollection = "putnam";
        generateQuestion(1);
        break;
      case "2":
        currentCollection = "scibowl";
        generateQuestion(2);
        break;
      case "3":
        currentCollection = "usercustom";
        generateQuestion(3);
      case "4":
        addQuestion();
        break;
      case "5":
        firstQ();
        break;
      case "6":
        generateHint();
         break;
      case "7":
        checkAnswer();
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
          "message": "What would you like to do:\n1. Practice Putnam\n2. Practice Science Bowl\n3. Practice Custom Question\n4. Add my own question\n5. See full list of options again",
          "isSender": false,
        });
    });
  }

  void secondQ() {
    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": "6. Get a hint\n7. Answer the question",
        "isSender": false,
      });
    });
  }

  void addQuestion() async {
    getUsername();
    usernameCompleter = Completer<void>();
    uCompleter = usernameCompleter;
    await uCompleter.future;
    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": "Enter the question you would like to add, prepended by a period. Also include the type (ex. Putnam), topic (ex. Optimization), and a hint, all separated by a period.",
        "isSender": false,
      });
    });
  }

  void populateNewUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isNewUser = user.metadata.creationTime?.isAfter(DateTime.now().subtract(Duration(minutes: 5))) ?? false;
      if(isNewUser) {
        putnam = FirebaseFirestore.instance.collection('putnam');
        scibowl = FirebaseFirestore.instance.collection('scibowl');
        usercustom = FirebaseFirestore.instance.collection('usercustom');
        putnam.doc("$putnamqcount").set(<String, dynamic>{
          'type': "Putnam",
          'question': "A grasshopper starts at the origin in the coordinate plane and makes a sequence of hops. Each hop has length 5, and after each hop the grasshopper is at a point whose coordinates are both integers; thus, there are 12 possible locations for the grasshopper after the first hop. What is the smallest number of hops needed for the grasshopper to reach the point (2021,2021)?",
          'topic': "Optimization",
          'hint': "Use the distance formula.",
          'timestamp': DateTime.now(),
        });
        putnamqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "How many sigma and pi bonds, respectively, are there in a  molecule with the following formula: [read slowly] CH3CHCHCH2CH3",
          'topic': "Chemistry",
          'hint': "No hint provided, come up with new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "What is the most common term used in genetics to describe the observable physical characteristics of an organism caused by the expression of a gene or set of genes?",
          'topic': "Biology",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "What is the biological term most often used for the act of a cell engulfing a particle by extending its pseudopodia (read as: SU-doe-POH-dee-ah) around the particle?",
          'topic': "Biology",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "What is the MOST common term for the type of energy that is most directly related to the energy of atoms, molecules and other small particles that are in random motion within a system?",
          'topic': "Physics",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "Factor the following expression completely:  81x2 + 180xy + 100y2",
          'topic': "Math",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "What is the name for the common ocean waves that are not driven by the wind but sustained by the energy they obtained by the sea?",
          'topic': "Earth Science",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': " A hexadecimal number is a numeral system with a radix or a base of what?",
          'topic': "General Science",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "The local group is generally referred to as a collection of what celestial objects?",
          'topic': "Astronomy",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
        scibowl.doc("$scibowlqcount").set(<String, dynamic>{
          'type': "Science Bowl",
          'question': "What is the molarity of a sodium hydroxide solution made by dissolving 4 grams NaOH in 250 milliliters of water?",
          'topic': "Chemistry",
          'hint': "No hint provided, come up with a new hint.",
          'timestamp': DateTime.now(),
        });
        scibowlqcount++;
      }
    }
  }

  void customQuestion(String pre) {
    List<String> fields = pre.substring(1).split(".");
    usercustom.doc("$usercustomqcount").set(<String, dynamic>{
      'type': fields[1],
      'question': fields[0],
      'topic': fields[2],
      'hint': fields[3],
      'timestamp': DateTime.now(),
    });
    usercustomqcount++;
    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": "Successfully added your question!",
        "isSender": false,
      });
    });
    firstQ();
  }

  void chatLog(String question, String response, String answer, String topic, String subject)
  {
    User? username = FirebaseAuth.instance.currentUser;
    CollectionReference user = FirebaseFirestore.instance.collection('user');
    user.doc(question).set(<String, dynamic>{
      'question': question,
      'subject' : subject,
      'topic' : topic,
      'response': response,
      'answer' : answer,
      'time': DateTime.now(),
    });
  }

  void generateQuestion(int option) async {
    const apiKey = "AIzaSyBUhqtUPV2MbAKPLtHZhxXZaKdgDG8TwCQ";
    final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);

    List<Content> content;

    if (option == 1) {
      final topic = await retrieveField(currentCollection, "$putnampcount", 'topic');
      final question = await retrieveField(currentCollection, "$putnampcount", 'question');

      currentType = "Putnam";
      currentTopic = topic;
      
      content = [Content.text("Give me a Putnam question about $topic similar to $question")];

      try {
        final response = await model.generateContent(content);

        setState(() {
          _chatHistory.add({
            "time": DateTime.now(),
            "message": response.text,
            "isSender": false,
          });
          curQuestion = response.text!;
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
    }
    else if (option == 2) {
      final topic = await retrieveField(currentCollection, "$scibowlpcount", 'topic');
      final question = await retrieveField(currentCollection, "$scibowlpcount", 'question');

      currentType = "Science Bowl";
      currentTopic = topic;
      
      content = [Content.text("Give me a Science Bowl question about $topic similar to $question")];

      try {
        final response = await model.generateContent(content);

        setState(() {
          _chatHistory.add({
            "time": DateTime.now(),
            "message": response.text,
            "isSender": false,
          });
          curQuestion = response.text!;
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
    }
    else if (option == 3) {
      final topic = await retrieveField(currentCollection, "$usercustompcount", 'topic');
      final question = await retrieveField(currentCollection, "$usercustompcount", 'question');

      currentType = "User Custom";
      currentTopic = topic;
      
      content = [Content.text("Give me a question about $topic similar to $question")];

      try {
        final response = await model.generateContent(content);

        setState(() {
          _chatHistory.add({
            "time": DateTime.now(),
            "message": response.text,
            "isSender": false,
          });
          curQuestion = response.text!;
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
    }
    else {
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": "The option you selected was not valid, please try again.",
          "isSender": false,
        });
      });
    }
    secondQ();
  }

  Future<String> retrieveField(String cName, String documentId, String fieldName) async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection(cName).doc(documentId).get();
    return (document.data() as Map<String, dynamic>)[fieldName] ?? 'Field not found';
  }

  int getDocId(String collection) {
    if(collection == "putnam") {
      return putnampcount;
    }
    else if(collection == "scibowl") {
      return scibowlpcount;
    }
    else {
      return usercustompcount;
    }
  }

  void generateHint() async {
    const apiKey = "AIzaSyBUhqtUPV2MbAKPLtHZhxXZaKdgDG8TwCQ";
    final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);

    final hint = await retrieveField(currentCollection, "$getDocId(currentCollection)", "hint");

    var content = [Content.text("Give me a hint for the question, $curQuestion, similar to $hint")];

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
    secondQ();
  }

  void checkAnswer() async {

    answerCompleter = Completer<void>();
    aCompleter = answerCompleter;

    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": "Please prepend your response with a '/'. Awaiting your answer...",
        "isSender": false,
      });
    });

    await aCompleter.future;

    const apiKey = "AIzaSyBUhqtUPV2MbAKPLtHZhxXZaKdgDG8TwCQ";
    final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);

    var content = [Content.text("Compare the answer for $curQuestion to the users answer, $curText. Ignore the '/' at the beginning of the user answer.")];

    try {
      final response = await model.generateContent(content);

      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": response.text,
          "isSender": false,
        });
      });
      aiAnswer = response.text!;
    } catch (e) {
      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": "Error generating content: $e",
          "isSender": false,
        });
      });
    }

    firstQ();
    if(currentCollection == "putnam") {
      putnampcount++;
    }
    else if(currentCollection == "scibowl") {
      scibowlpcount++;
    }
    else {
      usercustompcount++;
    }
    
    chatLog(curQuestion, userAnswer, aiAnswer, currentTopic, currentType);

  }
}