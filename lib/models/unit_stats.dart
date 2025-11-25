import 'weapon_stats.dart';

class Unit {
  // Used in database
  final String id;
  final String name;
  final String? imagePath;

   final int movement;
  final int toughness;
  final int save;
  final int wounds;
  final int leadership;
  final int objectiveControl;
  final int modelCount;

  final List<Weapons> rangedWeapons;
  final List<Weapons> meleeWeapons;

  Unit({
    required this.id,
    required this.name,
    this.imagePath,
    required this.movement,
    required this.toughness,
    required this.save,
    required this.wounds,
    required this.leadership,
    required this.objectiveControl,
    required this.modelCount,
    required this.rangedWeapons,
    required this.meleeWeapons,
  }); 


  // Json helpers

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'movement': movement,
        'toughness': toughness,
        'save': save,
        'wounds': wounds,
        'leadership': leadership,
        'objectiveControl': objectiveControl,
        'modelCount': modelCount,
        'rangedWeapons':
            rangedWeapons.map((weapon) => weapon.toJson()).toList(),
        'meleeWeapons': meleeWeapons.map((weapon) => weapon.toJson()).toList(),
  };

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      movement: json['movement'],
      toughness: json['toughness'],
      save: json['save'],
      wounds: json['wounds'],
      leadership: json['leadership'],
      objectiveControl: json['objectiveControl'],
      modelCount: json['modelCount'],
      rangedWeapons: (json['rangedWeapons'] as List)
          .map((weaponJson) => Weapons.fromJson(weaponJson))
          .toList(),
      meleeWeapons: (json['meleeWeapons'] as List)
          .map((weaponJson) => Weapons.fromJson(weaponJson))
          .toList(),
    );
  } 

}