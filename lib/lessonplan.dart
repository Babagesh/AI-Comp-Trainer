import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_widget.dart';
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

class MainPage extends StatelessWidget
{
  MainPage({super.key});
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context)
  {
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
                    destinations:[
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
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: CalendarPage(),
                  ),
                ),     
              ],
            ),
          );
      }
    ); 
  }
}