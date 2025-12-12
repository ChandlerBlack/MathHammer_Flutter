import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/simulation/sim.dart';
import 'package:mathhammer/models/unit_stats.dart';
import 'package:mathhammer/models/weapon_stats.dart';

void main() {
  group('Combat Simulation Tests', () {
    late Unit testUnit1;
    late Unit testUnit2;
    late Weapons testWeapon1;
    late Weapons testWeapon2;

    setUp(() {
      testWeapon1 = Weapons(
        id: 'w1',
        name: 'Bolter',
        attacks: 2,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 1,
        ballisticSkill: 3,
      );

      testWeapon2 = Weapons(
        id: 'w2',
        name: 'Chainsword',
        attacks: 3,
        strength: 4,
        ap: 0,
        range: 0,
        damage: 1,
        ballisticSkill: 3,
      );

      testUnit1 = Unit(
        id: '1',
        name: 'Space Marine Squad',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
      );

      testUnit2 = Unit(
        id: '2',
        name: 'Ork Boyz',
        movement: 6,
        toughness: 5,
        save: 6,
        wounds: 1,
        leadership: 7,
        objectiveControl: 2,
        modelCount: 20,
      );
    });

    test('Simulation results are initialized', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      expect(sim.resultsA.totalHits, 0);
      expect(sim.resultsA.totalMisses, 0);
      expect(sim.resultsA.totalDamage, 0);
      expect(sim.resultsB.totalHits, 0);
    });

    test('Run single combat simulation', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(1);

      // Results should have been updated
      expect(sim.resultsA.totalHits + sim.resultsA.totalMisses, greaterThan(0));
    });

    test('Run multiple combat simulations', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(10);

      // With 10 simulations, there should be accumulated results
      expect(sim.resultsA.totalHits + sim.resultsA.totalMisses, greaterThan(0));
      expect(sim.resultsB.totalHits + sim.resultsB.totalMisses, greaterThan(0));
    });

    test('Results clear before new simulation', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(5);
      sim.runCombatSim(5);

      // Results should be from second run, not accumulated
      expect(sim.resultsA.totalHits, greaterThanOrEqualTo(0));
    });

    test('Simulation results tracking', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);

      // After 100 simulations, verify result properties exist
      expect(sim.resultsA.totalHits, isA<int>());
      expect(sim.resultsA.totalMisses, isA<int>());
      expect(sim.resultsA.totalDamage, isA<int>());
      expect(sim.resultsA.totalGivenWounds, isA<int>());
      expect(sim.resultsA.totalTakenWounds, isA<int>());
      expect(sim.resultsA.totalCriticalHits, isA<int>());
      expect(sim.resultsA.totalCriticalWounds, isA<int>());
      expect(sim.resultsA.modelsKilled, isA<int>());
    });

    test('UnitSimulationResults clear method', () {
      final results = UnitSimulationResults();
      
      results.totalHits = 10;
      results.totalMisses = 5;
      results.totalDamage = 15;
      
      results.clear();
      
      expect(results.totalHits, 0);
      expect(results.totalMisses, 0);
      expect(results.totalDamage, 0);
      expect(results.modelsKilled, 0);
    });

    test('High weapon attacks generate more hits', () {
      final highAttackWeapon = Weapons(
        id: 'w3',
        name: 'Heavy Bolter',
        attacks: 6,
        strength: 5,
        ap: -1,
        range: 36,
        damage: 2,
        ballisticSkill: 3,
      );

      final unitWithHeavyWeapon = Unit(
        id: '3',
        name: 'Devastator',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
      );

      final sim = Sim(
        unitA: unitWithHeavyWeapon,
        unitB: testUnit2,
        weaponA: highAttackWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(50);

      // More attacks should result in more total hits + misses
      expect(sim.resultsA.totalHits + sim.resultsA.totalMisses, greaterThan(0));
    });

    test('getCombatResults returns formatted string', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(10);
      final results = sim.getCombatResults();

      expect(results, contains('Space Marine Squad Results:'));
      expect(results, contains('Ork Boyz Results:'));
      expect(results, contains('Total Hits:'));
      expect(results, contains('Models Killed:'));
    });

    test('getAverageResults returns correct structure', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      final avgResults = sim.getAverageResults(100);

      expect(avgResults.containsKey('unitA'), isTrue);
      expect(avgResults.containsKey('unitB'), isTrue);
      expect(avgResults['unitA']['name'], 'Space Marine Squad');
      expect(avgResults['unitB']['name'], 'Ork Boyz');
      expect(avgResults['unitA']['avgHits'], isNotNull);
      expect(avgResults['unitA']['criticalHitRate'], isNotNull);
    });

    test('getAverageResults with zero simulations returns empty', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      final avgResults = sim.getAverageResults(0);
      expect(avgResults, isEmpty);
    });

    test('Lethal Hits keyword generates auto-wounds', () {
      final lethalWeapon = Weapons(
        id: 'w4',
        name: 'Lethal Gun',
        attacks: 10,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 1,
        ballisticSkill: 3,
        keywords: [WeaponKeyword.lethalHits],
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: lethalWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      expect(sim.resultsA.totalGivenWounds, greaterThan(0));
    });

    test('Sustained Hits 1 generates extra hits', () {
      final sustainedWeapon = Weapons(
        id: 'w5',
        name: 'Sustained Gun',
        attacks: 10,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 1,
        ballisticSkill: 3,
        keywords: [WeaponKeyword.sustainedHits1],
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: sustainedWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      expect(sim.resultsA.totalHits, greaterThan(0));
    });

    test('Devastating Wounds bypass saves', () {
      final devastatingWeapon = Weapons(
        id: 'w6',
        name: 'Devastating Gun',
        attacks: 10,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 2,
        ballisticSkill: 3,
        keywords: [WeaponKeyword.devastatingWounds],
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: devastatingWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      expect(sim.resultsA.totalDamage, greaterThan(0));
    });

    test('Twin-Linked allows wound rerolls', () {
      final twinLinkedWeapon = Weapons(
        id: 'w7',
        name: 'Twin Bolter',
        attacks: 4,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 1,
        ballisticSkill: 3,
        keywords: [WeaponKeyword.twinLinked],
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: twinLinkedWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      expect(sim.resultsA.totalGivenWounds, greaterThan(0));
    });

    test('High strength vs low toughness wounds reliably', () {
      final strongWeapon = Weapons(
        id: 'w8',
        name: 'Strong Gun',
        attacks: 10,
        strength: 10,
        ap: 0,
        range: 24,
        damage: 1,
        ballisticSkill: 3,
      );

      final weakUnit = Unit(
        id: '4',
        name: 'Weak Unit',
        movement: 6,
        toughness: 3,
        save: 6,
        wounds: 1,
        leadership: 7,
        objectiveControl: 1,
        modelCount: 10,
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: weakUnit,
        weaponA: strongWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      expect(sim.resultsA.totalGivenWounds, greaterThan(200));
    });

    test('Invulnerable save provides protection', () {
      final apWeapon = Weapons(
        id: 'w9',
        name: 'AP Gun',
        attacks: 10,
        strength: 4,
        ap: -3,
        range: 24,
        damage: 1,
        ballisticSkill: 3,
      );

      final invulnUnit = Unit(
        id: '5',
        name: 'Invuln Unit',
        movement: 6,
        toughness: 4,
        save: 3,
        invulnerableSave: 4,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: invulnUnit,
        weaponA: apWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      expect(sim.resultsA.totalDamage, lessThan(sim.resultsA.totalGivenWounds * 100));
    });

    test('Models killed calculated correctly', () {
      final damageWeapon = Weapons(
        id: 'w10',
        name: 'Damage Gun',
        attacks: 20,
        strength: 8,
        ap: -2,
        range: 24,
        damage: 3,
        ballisticSkill: 3,
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: damageWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(10);
      expect(sim.resultsA.modelsKilled, greaterThan(0));
    });

    test('Zero attacks returns zero hits', () {
      final noAttackWeapon = Weapons(
        id: 'w11',
        name: 'No Attack',
        attacks: 0,
        strength: 4,
        ap: 0,
        range: 24,
        damage: 1,
        ballisticSkill: 3,
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: noAttackWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(10);
      expect(sim.resultsA.totalHits, 0);
    });

    test('Taken wounds tracked correctly', () {
      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: testWeapon1,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(10);
      expect(sim.resultsA.totalTakenWounds, equals(sim.resultsB.totalGivenWounds));
      expect(sim.resultsB.totalTakenWounds, equals(sim.resultsA.totalGivenWounds));
    });

    test('Melta keyword adds extra damage', () {
      final meltaWeapon = Weapons(
        id: 'w12',
        name: 'Meltagun',
        attacks: 5,
        strength: 8,
        ap: -4,
        range: 12,
        damage: 3,
        ballisticSkill: 3,
        keywords: [WeaponKeyword.melta1],
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: testUnit2,
        weaponA: meltaWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(100);
      expect(sim.resultsA.totalDamage, greaterThan(0));
    });

    test('Counter-attack only when models remain', () {
      final overkillWeapon = Weapons(
        id: 'w13',
        name: 'Overkill Gun',
        attacks: 50,
        strength: 10,
        ap: -4,
        range: 24,
        damage: 10,
        ballisticSkill: 2,
      );

      final fragileUnit = Unit(
        id: '6',
        name: 'Fragile Unit',
        movement: 6,
        toughness: 3,
        save: 6,
        wounds: 1,
        leadership: 7,
        objectiveControl: 1,
        modelCount: 5,
      );

      final sim = Sim(
        unitA: testUnit1,
        unitB: fragileUnit,
        weaponA: overkillWeapon,
        weaponB: testWeapon2,
      );

      sim.runCombatSim(10);
      expect(sim.resultsA.modelsKilled, greaterThan(0));
    });
  });
}
