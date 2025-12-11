import '../models/unit_stats.dart';
import '../models/weapon_stats.dart';
import 'dice.dart';




// The logic of this is based on a version of this sim app that I made as a Java app a year ago, 
class UnitSimulationResults {
  int totalHits = 0;
  int totalMisses = 0;
  int totalGivenWounds = 0;
  int totalTakenWounds = 0;
  int totalDamage = 0;
  int totalCriticalHits = 0;
  int totalCriticalWounds = 0;
  int modelsKilled = 0;

  void clear() {
    totalHits = 0;
    totalMisses = 0;
    totalGivenWounds = 0;
    totalTakenWounds = 0;
    totalDamage = 0;
    totalCriticalHits = 0;
    totalCriticalWounds = 0;
    modelsKilled = 0;
  }
}

class Sim {
  final Unit unitA;
  final Unit unitB;
  final Weapons weaponA;
  final Weapons weaponB;

  final UnitSimulationResults resultsA = UnitSimulationResults();
  final UnitSimulationResults resultsB = UnitSimulationResults();

  Sim({required this.unitA, required this.unitB, required this.weaponA, required this.weaponB});

  void runCombatSim(int numSimulations) {
    resultsA.clear();
    resultsB.clear();

    for (int sim = 0; sim < numSimulations; sim++) {
      int modelsRemainingA = unitA.modelCount;
      int modelsRemainingB = unitB.modelCount;
      int woundsRemainingA = unitA.wounds * unitA.modelCount;
      int woundsRemainingB = unitB.wounds * unitB.modelCount;
      final attackResultA = _performAttack(
        attackingUnit: unitA,
        defendingUnit: unitB,
        weapon: weaponA,
        attackingModels: modelsRemainingA,
      );

      resultsA.totalHits += attackResultA['hits'] as int;
      resultsA.totalMisses += attackResultA['misses'] as int;
      resultsA.totalGivenWounds += attackResultA['wounds'] as int;
      resultsA.totalDamage += attackResultA['damage'] as int;
      resultsA.totalCriticalHits += attackResultA['criticalHits'] as int;
      resultsA.totalCriticalWounds += attackResultA['criticalWounds'] as int;

      woundsRemainingB -= attackResultA['damage'] as int;
      final modelsKilledByA = (unitB.modelCount - (woundsRemainingB / unitB.wounds).ceil()).clamp(0, unitB.modelCount);
      resultsA.modelsKilled += modelsKilledByA;
      modelsRemainingB = (woundsRemainingB / unitB.wounds).ceil().clamp(0, unitB.modelCount);

      if (modelsRemainingB > 0) {
        final attackResultB = _performAttack(
          attackingUnit: unitB,
          defendingUnit: unitA,
          weapon: weaponB,
          attackingModels: modelsRemainingB,
        );

        resultsB.totalHits += attackResultB['hits'] as int;
        resultsB.totalMisses += attackResultB['misses'] as int;
        resultsB.totalGivenWounds += attackResultB['wounds'] as int;
        resultsB.totalDamage += attackResultB['damage'] as int;
        resultsB.totalCriticalHits += attackResultB['criticalHits'] as int;
        resultsB.totalCriticalWounds += attackResultB['criticalWounds'] as int;

        woundsRemainingA -= attackResultB['damage'] as int;
        final modelsKilledByB = (unitA.modelCount - (woundsRemainingA / unitA.wounds).ceil()).clamp(0, unitA.modelCount);
        resultsB.modelsKilled += modelsKilledByB;
      }

      resultsA.totalTakenWounds += resultsB.totalGivenWounds;
      resultsB.totalTakenWounds += resultsA.totalGivenWounds;
    }
  }

  Map<String, dynamic> _performAttack({required Unit attackingUnit, required Unit defendingUnit, required Weapons weapon, required int attackingModels}) {
    int hits = 0;
    int misses = 0;
    int wounds = 0;
    int damage = 0;
    int criticalHits = 0;
    int criticalWounds = 0;

    int numAttacks = weapon.attacks * attackingModels;

    final twinLinked = weapon.hasKeyword(WeaponKeyword.twinLinked);

    final hitRolls = _rollHits(numAttacks, weapon.ballisticSkill);
    hits = hitRolls['hits'] as int;
    misses = hitRolls['misses'] as int;
    criticalHits = hitRolls['criticals'] as int;

    int autoWounds = 0;
    if (weapon.hasKeyword(WeaponKeyword.lethalHits)) {
      autoWounds = criticalHits;
      hits -= criticalHits;
    }
    if (weapon.hasKeyword(WeaponKeyword.sustainedHits1)) {
      hits += criticalHits; 
    }
    if (weapon.hasKeyword(WeaponKeyword.sustainedHits2)) {
      hits += criticalHits; 
      hits += criticalHits; 
    }
    if (weapon.hasKeyword(WeaponKeyword.sustainedHits3)) {
      hits += criticalHits;
      hits += criticalHits;
      hits += criticalHits; 
    }

    // Wound rolls
    if (hits > 0) {
      final woundRolls = _rollWounds(hits, weapon.strength, defendingUnit.toughness, weapon, twinLinked);
      wounds = woundRolls['wounds'] as int;
      criticalWounds = woundRolls['criticals'] as int;
    }

    wounds += autoWounds;

    int devastatingDamage = 0;
    if (weapon.hasKeyword(WeaponKeyword.devastatingWounds)) {
      devastatingDamage = criticalWounds * weapon.damage;
      wounds -= criticalWounds;
    }

    int unsavedWounds = 0;
    if (wounds > 0) {
      unsavedWounds = _rollSaves(wounds, defendingUnit.save, weapon.ap, defendingUnit.invulnerableSave);
    }

    damage = (unsavedWounds * weapon.damage) + devastatingDamage;

    if (weapon.hasKeyword(WeaponKeyword.melta1) && unsavedWounds > 0) {
      damage += unsavedWounds;
    }
    if (weapon.hasKeyword(WeaponKeyword.melta2) && unsavedWounds > 0) {
      damage += unsavedWounds; 
      damage += unsavedWounds;
    }
    if (weapon.hasKeyword(WeaponKeyword.melta3) && unsavedWounds > 0) {
      damage += unsavedWounds;
      damage += unsavedWounds;
      damage += unsavedWounds;
    }

    return {
      'hits': hits + autoWounds,
      'misses': misses,
      'wounds': wounds + autoWounds,
      'damage': damage,
      'criticalHits': criticalHits,
      'criticalWounds': criticalWounds,
    };
  }

  Map<String, int> _rollHits(int numAttacks, int ballisticSkill) {
    if (numAttacks <= 0) return {'hits': 0, 'misses': 0, 'criticals': 0};

    final dice = Dice(numAttacks);
    dice.roll();

    int hits = 0;
    int criticals = 0;
    List<int> misses = [];

    for (var roll in dice.rolls) {
      if (roll == 6) {
        criticals++;
        hits++;
      } else if (roll >= ballisticSkill) {
        hits++;
      } else {
        misses.add(roll);
      }
    }

    if (misses.isNotEmpty) {
      final rerollDice = Dice(misses.length);
      rerollDice.roll();

      for (var roll in rerollDice.rolls) {
        if (roll == 6) {
          criticals++;
          hits++;
          misses.remove(roll);
        } else if (roll >= ballisticSkill) {
          hits++;
          misses.remove(roll);
        }
      }
    }

    return {
      'hits': hits,
      'misses': numAttacks - hits,
      'criticals': criticals,
    };
  }

  Map<String, int> _rollWounds(int numHits, int strength, int toughness, Weapons weapon, bool twinLinked) {
    if (numHits <= 0) return {'wounds': 0, 'criticals': 0};

    List<int> failedRolls = [];

    // Calculate wound roll needed
    int woundRollNeeded;
    if (strength >= toughness * 2) {
      woundRollNeeded = 2;
    } else if (strength > toughness) {
      woundRollNeeded = 3;
    } else if (strength == toughness) {
      woundRollNeeded = 4;
    } else if (strength * 2 <= toughness) {
      woundRollNeeded = 6;
    } else {
      woundRollNeeded = 5;
    }

    final dice = Dice(numHits);
    dice.roll();

    int wounds = 0;
    int criticals = 0;

    for (var roll in dice.rolls) {
      if (roll == 6) {
        criticals++;
        wounds++;
      } else if (roll >= woundRollNeeded) {
        wounds++;
      }
      else {
        failedRolls.add(roll);
      }
    }
    if (twinLinked) {
      wounds += _twinLinkedRerolls(failedRolls.length, woundRollNeeded);
    }

    return {
      'wounds': wounds,
      'criticals': criticals,
    };
  }

  int _twinLinkedRerolls(int missedRolls, int neededRoll) {
    if (missedRolls <= 0) return 0;

    final dice = Dice(missedRolls);
    dice.roll();
    int additionalHits = 0;
    for (var roll in dice.rolls) {
      if (roll >= neededRoll) {
        additionalHits++;
      }
    }
    return additionalHits;
  }

  int _rollSaves(int numWounds, int save, int armorPen, int invulnSave) {
    if (numWounds <= 0) return 0;

    // Determine which save to use
    final modifiedSave = save - armorPen;
    final saveNeeded = invulnSave < modifiedSave ? invulnSave : modifiedSave;

    final dice = Dice(numWounds);
    dice.roll();

    // Return unsaved wounds
    return dice.rolls.where((roll) => roll < saveNeeded).length;
  }

  String getCombatResults() {
    return '''
${unitA.name} Results:
  Total Hits: ${resultsA.totalHits}
  Total Misses: ${resultsA.totalMisses}
  Critical Hits: ${resultsA.totalCriticalHits}
  Wounds Inflicted: ${resultsA.totalGivenWounds}
  Critical Wounds: ${resultsA.totalCriticalWounds}
  Damage Dealt: ${resultsA.totalDamage}
  Models Killed: ${resultsA.modelsKilled}
  Damage Received: ${resultsB.totalDamage}

${unitB.name} Results:
  Total Hits: ${resultsB.totalHits}
  Total Misses: ${resultsB.totalMisses}
  Critical Hits: ${resultsB.totalCriticalHits}
  Wounds Inflicted: ${resultsB.totalGivenWounds}
  Critical Wounds: ${resultsB.totalCriticalWounds}
  Damage Dealt: ${resultsB.totalDamage}
  Models Killed: ${resultsB.modelsKilled}
  Damage Received: ${resultsA.totalDamage}
''';
  }

  Map<String, dynamic> getAverageResults(int numSimulations) {
    if (numSimulations <= 0) return {};

    return {
      'unitA': {
        'name': unitA.name,
        'avgHits': (resultsA.totalHits / numSimulations).toStringAsFixed(2),
        'avgWoundsInflicted': (resultsA.totalGivenWounds / numSimulations).toStringAsFixed(2),
        'avgDamageDealt': (resultsA.totalDamage / numSimulations).toStringAsFixed(2),
        'avgDamageReceived': (resultsB.totalDamage / numSimulations).toStringAsFixed(2),
        'avgModelsKilled': (resultsA.modelsKilled / numSimulations).toStringAsFixed(2),
        'criticalHitRate': resultsA.totalHits > 0 
            ? (resultsA.totalCriticalHits / resultsA.totalHits * 100).toStringAsFixed(1)
            : '0.0',
      },
      'unitB': {
        'name': unitB.name,
        'avgHits': (resultsB.totalHits / numSimulations).toStringAsFixed(2),
        'avgWoundsInflicted': (resultsB.totalGivenWounds / numSimulations).toStringAsFixed(2),
        'avgDamageDealt': (resultsB.totalDamage / numSimulations).toStringAsFixed(2),
        'avgDamageReceived': (resultsA.totalDamage / numSimulations).toStringAsFixed(2),
        'avgModelsKilled': (resultsB.modelsKilled / numSimulations).toStringAsFixed(2),
        'criticalHitRate': resultsB.totalHits > 0
            ? (resultsB.totalCriticalHits / resultsB.totalHits * 100).toStringAsFixed(1)
            : '0.0',
      },
    };
  }
}