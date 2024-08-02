import 'package:english_words/english_words.dart';
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

class MainPage extends StatelessWidget
{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return LayoutBuilder(
      builder: (context, constraints)
      {
        return Scaffold
        (
          appBar: AppBar(
            title: const Text('Test'),
            centerTitle: true,
          ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: CalendarWidget(),
                  ),
                ),
              ],
            ),
          );
      }
    ); 
  }
}