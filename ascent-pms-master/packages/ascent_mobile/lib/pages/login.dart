import 'package:ascent_pms/main.dart';
import 'package:ascent_pms/pages/loading_button.dart';
import 'package:ascent_pms/pages/onboarding_page.dart';
import 'package:ascent_pms/pages/signup.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/validation.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:ascent_pms/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      title: 'Login',
      subtitle: 'Welcome back!',
      form: const LoginForm(),
      footer: buildSignupText(context),
    );
  }

  Widget buildSignupText(BuildContext context) {
    return CallToAction(
      question: "Don't have an account?",
      action: "Signup",
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SignupPage(),
        ));
      },
    );
  }
}

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      userServiceProvider,
      (prev, next) {
        if (next is AsyncData && next.unwrapPrevious().valueOrNull!.isSome()) {
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
        LoginTextField.email(_emailController),
        const SizedBox(height: 15),
        LoginTextField.password(_passwordController),
        const SizedBox(height: 15),
        LoadingButton(
          'Login',
          ref.watch(userServiceProvider).isLoading,
          () => onLogin(context),
        ),
      ],
    );
  }

  void onLogin(BuildContext context) async {
    final validationErr = emailValidator(_emailController.text) ??
        newPasswordValidator(_passwordController.text);

    if (validationErr != null) {
      await showOkPopup(context, validationErr);
      return;
    }

    final result = await ref
        .watch(userServiceProvider.notifier)
        .login(_emailController.text, _passwordController.text);

    if (result case Err(:final error)) {
      if (mounted) {
        await showOkPopup(context, error);
      }
    }
  }
}
