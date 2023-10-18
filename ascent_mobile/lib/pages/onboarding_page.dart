import 'package:ascent_pms/widgets/gradiented.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.form,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final Widget form;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );

    return Gradiented(
      child: Scaffold(
        // Empty appbar inorder to leave adequate padding
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                if (subtitle != null) Text(subtitle!),
                const SizedBox(height: 16),
                form,
                const SizedBox(height: 72),
                Center(child: footer)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CallToAction extends StatelessWidget {
  const CallToAction({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final text = Text.rich(
      TextSpan(text: "$question ", children: [
        TextSpan(
          text: action,
          style: const TextStyle(fontWeight: FontWeight.w600),
        )
      ]),
    );

    return GestureDetector(onTap: onTap, child: text);
  }
}
