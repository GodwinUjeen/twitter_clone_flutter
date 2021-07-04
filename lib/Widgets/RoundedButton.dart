import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';

class RoundedButton extends StatelessWidget {
  final String? btnText;
  final VoidCallback? onBtnPressed;

  const RoundedButton({Key? key, this.btnText, this.onBtnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: KTweeterColor,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: onBtnPressed,
        minWidth: 250,
        height: 50,
        child: Text(
          btnText!,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
