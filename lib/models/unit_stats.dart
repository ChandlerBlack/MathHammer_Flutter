import 'weapon_stats.dart';

class Unit {
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
  final int invulnerableSave;

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
    this.invulnerableSave = 7,
  }); 


  // Json helpers - I want to keeps these for future options like exporting units that I might implement after this course

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
        'invulnerableSave': invulnerableSave,
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
      invulnerableSave: json['invulnerableSave'] ?? 7,
    );
  } 


  // Map converters for database storage

  // weapons are stored in a separate table
  Map<String, dynamic> toMap() {
    return {
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
      'invulnerableSave': invulnerableSave,
    };
  }

  factory Unit.fromMap(
    Map<String, dynamic> map,
  ) {
    return Unit(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
      movement: map['movement'],
      toughness: map['toughness'],
      save: map['save'],
      wounds: map['wounds'],
      leadership: map['leadership'],
      objectiveControl: map['objectiveControl'],
      modelCount: map['modelCount'],
      invulnerableSave: map['invulnerableSave'] ?? 7,
    );
  }


}