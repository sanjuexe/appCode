import 'dart:ui';

Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  final p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}
