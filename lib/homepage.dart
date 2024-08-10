import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_widget.dart';
import 'lessonplan.dart';
import 'chat.dart';
import 'signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'history.dart';
void main()
  {
    runApp(const MyApp());
  }

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        title: 'Competition App',
        theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home:MainPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier
{
  @override
  notifyListeners();
}

class MainPage extends StatefulWidget
{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var selectedIndex = 0;
  @override
  Widget build(BuildContext context)
  {
    Widget page;
    switch(selectedIndex)
    {
      case 0:
      // Will be the chatpage()
        page = const ChatPage();
        break;
      case 1:
      // Will be historypage()
        page = const HistoryPage();
        break;
      case 2:
        page = const CalendarPage();
        break;
      default:
      throw UnimplementedError('no widget for $selectedIndex');
    }
    Widget lessonBuild () => LayoutBuilder(
      builder: (context, constraints)
      {
        return Scaffold
        (
            appBar: AppBar(
            title: Row(
              children: <Widget>[
                SizedBox(width: 1150),
                const Text('Welcome to your Lesson Plan!'),
                SizedBox(
                        width: 900,
                      ),
                ElevatedButton(
                      child: Text('Logout'),
                      onPressed: (){
                        FirebaseAuth.instance.signOut().then((value)
                        {
                          print("Signed Out");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                        });
                    },
                ),
            ],
          ),
            ),
            body: Row(
              children: 
              [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations:const [
                      NavigationRailDestination(
                        icon: Icon(Icons.chat_bubble_outline),
                        label: Text('Chatbox'),
                        ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history),
                        label: Text('History'),
                        ),
                      NavigationRailDestination(
                        icon: Icon(Icons.book_online_outlined),
                        label: Text('Lesson Plan')
                      ),
                    ],
                    selectedIndex : selectedIndex,
                    onDestinationSelected: (value)
                    {
                      setState(()
                        {
                          selectedIndex = value;
                        });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                    
                  ),
                ),     
              ],
            ),
          floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const EventEditingPage())
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
            ),
          );
      }
    );
    Widget chatBuild () => LayoutBuilder(
      builder: (context, constraints)
      {
        return Scaffold
        (
            appBar: AppBar(
            title: Row(
              children: <Widget>[
                SizedBox(width: 1150),
                const Text('Welcome to your Lesson Plan!'),
                SizedBox(
                        width: 900,
                      ),
                ElevatedButton(
                      child: Text('Logout'),
                      onPressed: (){
                        FirebaseAuth.instance.signOut().then((value)
                        {
                          print("Signed Out");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                        });
                    },
                ),
            ],
          ),
          ),
            body: Row(
              children: 
              [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations:const [
                      NavigationRailDestination(
                        icon: Icon(Icons.chat_bubble_outline),
                        label: Text('Chatbox'),
                        ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history),
                        label: Text('History'),
                        ),
                      NavigationRailDestination(
                        icon: Icon(Icons.book_online_outlined),
                        label: Text('Lesson Plan')
                      ),
                    ],
                    selectedIndex : selectedIndex,
                    onDestinationSelected: (value)
                    {
                      setState(()
                        {
                          selectedIndex = value;
                        });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),     
              ],
            ),
          );
      }
    );
    Widget historyBuild () => LayoutBuilder(
      builder: (context, constraints)
      {
        return Scaffold
        (
            appBar: AppBar(
            title: Row(
              children: <Widget>[
                SizedBox(width: 1150),
                const Text('Welcome to your Chat History!'),
                SizedBox(
                        width: 900,
                      ),
                ElevatedButton(
                      child: Text('Logout'),
                      onPressed: (){
                        FirebaseAuth.instance.signOut().then((value)
                        {
                          print("Signed Out");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                        });
                    },
                ),
            ],
          ),
          ),
            body: Row(
              children: 
              [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations:const [
                      NavigationRailDestination(
                        icon: Icon(Icons.chat_bubble_outline),
                        label: Text('Chatbox'),
                        ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history),
                        label: Text('History'),
                        ),
                      NavigationRailDestination(
                        icon: Icon(Icons.book_online_outlined),
                        label: Text('Lesson Plan')
                      ),
                    ],
                    selectedIndex : selectedIndex,
                    onDestinationSelected: (value)
                    {
                      setState(()
                        {
                          selectedIndex = value;
                        });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                    
                  ),
                ),     
              ],
            ),
          );
      }
    );

    if(selectedIndex == 0)
    {
      return chatBuild();
    }
    else if(selectedIndex == 1) {
      return historyBuild();
    }
    else if(selectedIndex == 2)
    {
      return lessonBuild();
    }
    else
    {
      return chatBuild();
    }
    
  }

}
