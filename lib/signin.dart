import 'package:flutter/material.dart';
import 'package:mathtrainer/homepage.dart';
import 'reusable_widgets.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignInScreen extends StatefulWidget{
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
{
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override 
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.lightBlue, Color.fromARGB(255, 0, 140, 255)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter
          ),
          ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children:<Widget> [
                  Image.asset("assets/images/Compete.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Enter UserName", Icons.person_outline, false, _emailTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  signUpButton(context, true, () {
                    FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((value)
                    {
                      print("Signed in!");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
                    }).onError((error, stackTrace)
                    {
                      print("Error ${error.toString()}");
                    });
                  }),
                  signUpOption()
              ],
              ),
              ),
              ),
      ),
    );
  }

  Row signUpOption()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account?", 
        style: TextStyle(color: Colors.white70)),
      GestureDetector(
        onTap: () {
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => const SignUpScreen())
          );
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
      ]
    );
  }
}