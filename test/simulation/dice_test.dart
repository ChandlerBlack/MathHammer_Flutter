import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/simulation/dice.dart';

void main() {
  group('Dice Tests', () {
    test('Dice initialization', () {
      final dice = Dice(5);
      expect(dice.numDice, 5);
      expect(dice.rolls, isEmpty);
      expect(dice.rollTotal, 0);
    });

    test('Dice roll generates correct number of results', () {
      final dice = Dice(10);
      dice.roll();
      expect(dice.rolls, hasLength(10));
    });

    test('Dice rolls are within valid range (1-6)', () {
      final dice = Dice(100);
      dice.roll();
      
      for (final roll in dice.rolls) {
        expect(roll, greaterThanOrEqualTo(1));
        expect(roll, lessThanOrEqualTo(6));
      }
    });

    test('Roll total is sum of all rolls', () {
      final dice = Dice(5);
      dice.roll();
      
      final expectedTotal = dice.rolls.fold(0, (sum, value) => sum + value);
      expect(dice.rollTotal, expectedTotal);
    });

    test('Average roll calculation', () {
      final dice = Dice(4);
      dice.rolls = [1, 2, 3, 4]; // Manually set for deterministic test
      dice.rollTotal = 10;
      
      expect(dice.averageRoll, 2.5);
    });

    test('Average roll with zero dice', () {
      final dice = Dice(0);
      expect(dice.averageRoll, 0.0);
    });

    test('Rolls string representation', () {
      final dice = Dice(3);
      dice.rolls = [1, 4, 6];
      
      expect(dice.rollsString, '[1, 4, 6]');
    });

    test('Multiple rolls generate different results', () {
      final dice = Dice(20);
      dice.roll();
      final firstRolls = List.from(dice.rolls);
      
      dice.roll();
      final secondRolls = dice.rolls;
      
      // It's statistically very unlikely that 20 dice rolls would be identical twice
      expect(firstRolls, isNot(equals(secondRolls)));
    });

    test('Roll total updates after re-rolling', () {
      final dice = Dice(5);
      dice.roll();
      final firstTotal = dice.rollTotal;
      
      dice.roll();
      final secondTotal = dice.rollTotal;
      
      // Verify both totals are valid sums
      expect(firstTotal, greaterThanOrEqualTo(5)); // Minimum 5 ones
      expect(firstTotal, lessThanOrEqualTo(30)); // Maximum 5 sixes
      expect(secondTotal, greaterThanOrEqualTo(5));
      expect(secondTotal, lessThanOrEqualTo(30));
    });

    test('Single die roll', () {
      final dice = Dice(1);
      dice.roll();
      
      expect(dice.rolls, hasLength(1));
      expect(dice.rolls.first, greaterThanOrEqualTo(1));
      expect(dice.rolls.first, lessThanOrEqualTo(6));
      expect(dice.rollTotal, dice.rolls.first);
    });

    test('Large number of dice', () {
      final dice = Dice(1000);
      dice.roll();
      
      expect(dice.rolls, hasLength(1000));
      
      // Statistical test: average should be close to 3.5
      final average = dice.averageRoll;
      expect(average, greaterThan(3.0));
      expect(average, lessThan(4.0));
    });
  });
}
