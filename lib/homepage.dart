import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_widget.dart';
import 'lessonplan.dart';
import 'ui/chat.dart';

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
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Test App',
        theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home:const MainPage(),
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
        page = ChatPage();
        break;
      case 1:
      // Will be historypage()
        page = CalendarPage();
        break;
      case 2:
        page = CalendarPage();
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
            title: const Text('Welcome to your Lesson Plan!'),
            centerTitle: true,
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
            title: const Text('Ask any question!'),
            centerTitle: true,
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
            title: const Text('Review your past responses!'),
            centerTitle: true,
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
