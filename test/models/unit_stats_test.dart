import 'package:flutter_test/flutter_test.dart';
import 'package:mathhammer/models/unit_stats.dart';

void main() {
  group('Unit Model Tests', () {
    late Unit testUnit;
    
    setUp(() {
      testUnit = Unit(
        id: '1',
        name: 'Space Marine',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 10,
        invulnerableSave: 7,
      );
    });

    test('Unit creation with required fields', () {
      expect(testUnit.id, '1');
      expect(testUnit.name, 'Space Marine');
      expect(testUnit.movement, 6);
      expect(testUnit.toughness, 4);
      expect(testUnit.save, 3);
      expect(testUnit.wounds, 2);
      expect(testUnit.leadership, 6);
      expect(testUnit.objectiveControl, 2);
      expect(testUnit.modelCount, 10);
    });

    test('Unit with default invulnerable save', () {
      expect(testUnit.invulnerableSave, 7);
    });

    test('Unit with custom invulnerable save', () {
      final unitWithInvuln = Unit(
        id: '2',
        name: 'Terminator',
        movement: 5,
        toughness: 5,
        save: 2,
        wounds: 3,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
        invulnerableSave: 4,
      );
      expect(unitWithInvuln.invulnerableSave, 4);
    });

    test('Unit toMap conversion', () {
      final map = testUnit.toMap();
      expect(map['id'], '1');
      expect(map['name'], 'Space Marine');
      expect(map['movement'], 6);
      expect(map['toughness'], 4);
      expect(map['save'], 3);
      expect(map['wounds'], 2);
      expect(map['leadership'], 6);
      expect(map['objectiveControl'], 2);
      expect(map['modelCount'], 10);
      expect(map['invulnerableSave'], 7);
    });

    test('Unit fromMap conversion', () {
      final map = {
        'id': '3',
        'name': 'Tactical Squad',
        'imagePath': '/path/to/image.png',
        'movement': 6,
        'toughness': 4,
        'save': 3,
        'wounds': 2,
        'leadership': 6,
        'objectiveControl': 2,
        'modelCount': 10,
        'invulnerableSave': 7,
      };
      
      final unit = Unit.fromMap(map);
      expect(unit.id, '3');
      expect(unit.name, 'Tactical Squad');
      expect(unit.imagePath, '/path/to/image.png');
      expect(unit.movement, 6);
    });

    test('Unit toJson and fromJson', () {
      final unitForJson = Unit(
        id: '4',
        name: 'Intercessor',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 2,
        leadership: 6,
        objectiveControl: 2,
        modelCount: 5,
      );

      final json = unitForJson.toJson();
      expect(json['id'], '4');
      expect(json['name'], 'Intercessor');

      final reconstructedUnit = Unit.fromJson(json);
      expect(reconstructedUnit.id, unitForJson.id);
      expect(reconstructedUnit.name, unitForJson.name);
    });

    test('Unit with null imagePath', () {
      expect(testUnit.imagePath, isNull);
    });

    test('Unit with imagePath', () {
      final unitWithImage = Unit(
        id: '5',
        name: 'Captain',
        imagePath: '/images/captain.png',
        movement: 6,
        toughness: 4,
        save: 3,
        wounds: 5,
        leadership: 6,
        objectiveControl: 1,
        modelCount: 1,
      );
      expect(unitWithImage.imagePath, '/images/captain.png');
    });
  });
}
