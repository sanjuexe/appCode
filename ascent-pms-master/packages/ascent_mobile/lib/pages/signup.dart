import 'package:ascent_pms/main.dart';
import 'package:ascent_pms/pages/loading_button.dart';
import 'package:ascent_pms/pages/login.dart';
import 'package:ascent_pms/pages/onboarding_page.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/validation.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:ascent_pms/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      title: 'Create Account',
      subtitle: 'Welcome onboard!',
      form: const SignupForm(),
      footer: buildLoginText(context),
    );
  }

  Widget buildLoginText(BuildContext context) {
    return CallToAction(
      question: "Already have an account?",
      action: "Login",
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
      },
    );
  }
}

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<SignupForm> {
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      userServiceProvider,
      (prev, next) {
        if (next case AsyncData(value: Some())) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainTabbedUI()),
            (route) => false,
          );
        }
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginTextField.username(_usernameController),
        const SizedBox(height: 15),
        LoginTextField.email(_emailController),
        const SizedBox(height: 15),
        LoginTextField.phoneNumber(_phoneNumberController),
        const SizedBox(height: 15),
        LoginTextField.password(_passwordController),
        const SizedBox(height: 15),
        LoadingButton(
          'Sign Up',
          ref.watch(userServiceProvider).isLoading,
          () => onSignUp(context),
        ),
      ],
    );
  }

  void onSignUp(BuildContext context) async {
    var phone = _phoneNumberController.text;
    // TODO: better phone number handling (use dedicated package?)
    if (!phone.startsWith('+') && phone.isNotEmpty) {
      phone = '+91$phone'; // auto-prefix India country code if absent
    }

    final validationErr = newUsernameValidator(_usernameController.text) ??
        emailValidator(_emailController.text) ??
        phoneValidator(phone) ??
        newPasswordValidator(_passwordController.text);

    if (validationErr != null) {
      await showOkPopup(context, validationErr);
      return;
    }

    final result = await ref.watch(userServiceProvider.notifier).signup(
          phone: phone,
          password: _passwordController.text,
          name: _usernameController.text,
          email: _emailController.text,
        );

    if (result case Err(:final error)) {
      if (mounted) {
        await showOkPopup(context, error);
      }
    }
  }
}
