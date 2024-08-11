import 'package:flutter/material.dart';
import 'signin.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
       apiKey: "AIzaSyC3kayiXpsr62G0cI9PwZOzGokyPJAOM6A",
      authDomain: "comp-trainer-c58b7.firebaseapp.com",
      projectId: "comp-trainer-c58b7",
     storageBucket: "comp-trainer-c58b7.appspot.com",
      messagingSenderId: "746406856725",
      appId: "1:746406856725:web:793c1fc7daad12153a261c",
      measurementId: "G-RY9K9W57RS",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      
      title: 'CompTrainer Signin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    );
  }
}
