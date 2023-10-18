import 'package:flutter/material.dart';

Future<void> showPopup(
  BuildContext context, {
  String? title,
  required String content,
  required Map<String, void Function()> actions,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title != null ? Text(title) : null,
      content: Text(content),
      actions: [
        for (MapEntry entry in actions.entries)
          TextButton(
            onPressed: entry.value,
            child: Text(entry.key),
          )
      ],
    ),
  );
}

Future<void> showOkPopup(BuildContext context, String title) {
  return showPopup(
    context,
    content: title,
    actions: {
      'OK': () => Navigator.of(context).pop(),
    },
  );
}

Future<void> showOkCancelPopup(
  BuildContext context,
  String title, {
  required void Function() onOk,
  required void Function() onCancel,
}) {
  return showPopup(
    context,
    content: title,
    actions: {
      'Cancel': onCancel,
      'OK': onOk,
    },
  );
}
