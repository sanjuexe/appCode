import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String title;
  final String? subtitle;
  const Heading(this.title, {Key? key, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0).copyWith(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.labelMedium,
            )
          ]
        ],
      ),
    );
  }
}
