import 'package:ascent_pms/main.dart';
import 'package:ascent_pms/pages/login.dart';
import 'package:ascent_pms/pages/signup.dart';
import 'package:ascent_pms/widgets/gradiented.dart';
import 'package:flutter/material.dart';

import 'package:ascent_pms/widgets/logo.dart';

const introButtonColor = darkGold;

Future<void> gotoIntroPage(BuildContext context) {
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const IntroPage()),
    (route) => false,
  );
}

const introText = 'Allow Ascent PMS to handle your property'
    ' with complete ease to reduce risk and stress'
    ' while you are away.';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);
  static const _edgePaddingValue = 20.0;

  @override
  Widget build(BuildContext context) {
    final loginButton = FilledButton(
      onPressed: makeRoute(context, const LoginPage()),
      child: const Text('Login'),
    );
    final signupButton = FilledButton(
      onPressed: makeRoute(context, const SignupPage()),
      child: const Text('Sign Up'),
    );
    final skipLoginButton = OutlinedButton(
      onPressed: makeRoute(context, const MainTabbedUI()),
      child: const Text('Skip Login'),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(flex: 3, child: AscentLogo()),
            Expanded(
              flex: 2,
              child: Gradiented(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [lightBlue, lightBlue],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _edgePaddingValue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(introText, textAlign: TextAlign.center),
                      Row(children: [
                        Expanded(child: loginButton),
                        const SizedBox(width: _edgePaddingValue),
                        Expanded(child: signupButton),
                      ]),
                      skipLoginButton,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Function() makeRoute(BuildContext context, Widget content) {
    return () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => content,
        ));
  }
}
