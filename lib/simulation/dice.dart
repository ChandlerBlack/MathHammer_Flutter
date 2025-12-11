import 'dart:math';

// Dice roller for the simulation
class Dice {
  final int numDice;
  static const int sides = 6;

  List<int> rolls = [];
  int rollTotal = 0;

  Dice(this.numDice);

  void roll() {
    final random = Random();
    rolls = List.generate(numDice, (_) => random.nextInt(sides) + 1);
    rollTotal = rolls.fold(0, (sum, value) => sum + value);
  }

  double get averageRoll => numDice > 0 ? rollTotal / numDice : 0.0;

  String get rollsString => rolls.toString();

}