import 'package:flutter/material.dart';
import 'signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: dotenv.get('API_KEY') ?? '',
    authDomain: "comp-trainer-c58b7.firebaseapp.com",
    projectId: "comp-trainer-c58b7",
    storageBucket: "comp-trainer-c58b7.appspot.com",
    messagingSenderId: "746406856725",
    appId: "1:746406856725:web:793c1fc7daad12153a261c",
    measurementId: "G-RY9K9W57RS",
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      
      title: 'CompTrainer Signin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}
