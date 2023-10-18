import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final bool isLoading;
  const LoadingButton(this.label, this.isLoading, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const FilledButton(
            onPressed: null,
            child: SizedBox.square(
              dimension: 15,
              child: CircularProgressIndicator(color: Colors.grey),
            ),
          )
        : FilledButton(
            onPressed: onPressed,
            child: Text(label),
          );
  }
}
