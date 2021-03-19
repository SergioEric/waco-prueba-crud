import 'package:flutter/material.dart';

Future<void> showSnackBar({
  required BuildContext context,
  required Widget content,
  Duration duration = const Duration(milliseconds: 2000)
}) async {

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: content,
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: duration,
      ),
    );
}
