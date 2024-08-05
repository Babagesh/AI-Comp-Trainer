import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_widget.dart';
import 'lessonplan.dart';

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
        page = const CalendarPage();
        break;
      case 1:
      // Will be historypage()
        page = const CalendarPage();
        break;
      case 2:
        page = const CalendarPage();
        break;
      default:
      throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints)
      {
        return Scaffold
        (
          appBar: AppBar(
            title: const Text('Lesson Plan'),
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
    
  }
}