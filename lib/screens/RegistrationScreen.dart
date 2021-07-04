import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Services/AuthServices.dart';
import 'package:twitter_clone/Widgets/RoundedButton.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _email;
  String? _password;
  String? _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KTweeterColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Create account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Username',
              ),
              onChanged: (value) {
                _name = value;
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'E-mail',
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              onChanged: (value) {
                _password = value;
              },
            ),
            SizedBox(
              height: 40.0,
            ),
            RoundedButton(
              btnText: 'Create account',
              onBtnPressed: () async {
                bool isValid =
                    await AuthService.signUp(_name!, _email!, _password!);
                if (isValid) {
                  Navigator.pop(context);
                } else {
                  print("Something Went Wrong");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
