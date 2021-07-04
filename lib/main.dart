import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/screens/FeedScreen.dart';
import 'package:twitter_clone/screens/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //

  Widget getScreenId() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user == null) {
            return WelcomeScreen();
          }
          return FeedScreen(
            currentUserId: user.uid,
          );
        } else {
          return WelcomeScreen();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
            child: getScreenId(), type: PageTransitionType.bottomToTop),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KTweeterColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120.0),
          child: Image.asset('assets/splash.png'),
        ),
      ),
    );
  }
}
