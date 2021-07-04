import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Widgets/RoundedButton.dart';
import 'package:twitter_clone/screens/LoginScreen.dart';
import 'package:twitter_clone/screens/RegistrationScreen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    "See what's happening in the world right now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  RoundedButton(
                    btnText: 'Create account',
                    onBtnPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: RegistrationScreen(),
                          type: PageTransitionType.leftToRight,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: TextStyle(fontSize: 15),
                      ),
                      MaterialButton(
                        // color: Colors.red,
                        elevation: 0,
                        padding: EdgeInsets.all(5),
                        minWidth: 7.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: LoginScreen(),
                              type: PageTransitionType.leftToRight,
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: KTweeterColor, fontSize: 15),
                        ),
                      ),
                      // RoundedButton(
                      //   btnText: 'Login',
                      //   onBtnPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       PageTransition(
                      //         child: LoginScreen(),
                      //         type: PageTransitionType.leftToRight,
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
