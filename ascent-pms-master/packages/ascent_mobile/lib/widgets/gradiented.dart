import 'package:ascent_pms/widgets/logo.dart';
import 'package:flutter/material.dart';

class Gradiented extends StatelessWidget {
  const Gradiented({
    super.key,
    required this.child,
    this.colors = const [darkBlue, lightBlue],
    this.begin = Alignment.topRight,
    this.end = Alignment.bottomLeft,
  });

  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  @override
  Widget build(BuildContext context) {
    const white = Color(0xd9ffffff); // White with 85% opacity
    const textStyle = TextStyle(color: white);
    const whiteBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: white),
    );
    const roundedBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    );

    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: begin, end: end, colors: colors),
      ),
      child: DefaultTextStyle.merge(
        style: textStyle,
        child: Theme(
          data: theme.copyWith(
            textTheme: theme.textTheme.apply(bodyColor: white),
            hintColor: white,
            dialogTheme: const DialogTheme(backgroundColor: lightBlue),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(lightGold),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: theme.filledButtonTheme.style?.copyWith(
                shape: MaterialStateProperty.all(roundedBorder),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(white),
                overlayColor: MaterialStateProperty.all(Colors.white10),
                shape: MaterialStateProperty.all(roundedBorder),
                side: MaterialStateProperty.all(
                  const BorderSide(color: white),
                ),
              ),
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: white,
              selectionColor: Colors.white10,
              selectionHandleColor: Colors.white70,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: whiteBorder,
              focusedBorder: whiteBorder,
              labelStyle: textStyle,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
