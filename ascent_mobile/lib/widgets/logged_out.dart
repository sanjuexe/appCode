import 'package:ascent_pms/pages/intro.dart';
import 'package:flutter/material.dart';

class TakeToLoginPageButton extends StatelessWidget {
  final String text;
  const TakeToLoginPageButton({
    Key? key,
    this.text = 'Sign Up or Login',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const IntroPage()),
        );
      },
      child: Text(text),
    );
  }
}
