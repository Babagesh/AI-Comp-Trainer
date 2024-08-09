import 'package:flutter/material.dart';
import 'package:mathtrainer/lessonplan.dart';
import 'package:provider/provider.dart';
import 'signin.dart';
void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
      title: 'CompTrainer Signin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    ),
    );
  }
}
