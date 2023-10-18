import 'package:flutter/material.dart';

class FaintText extends StatelessWidget {
  final String text;
  final bool italic;
  const FaintText(this.text, {Key? key, this.italic = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: Colors.grey,
      ),
    );
  }
}
