enum WeaponType {
  ranged,
  melee,
}

enum WeaponKeyword {
  rapidFire,
  assault,
  heavy,
  pistol,
  melta,
  lance,
  blast,
  twinLinked,
  hazardous,
  devastatingWounds,
  precision,
  lethalHits,
  sustainedHits,
  antiFly,
  antiInfantry,
  antiMonster,
  antiVehicle,
  indirectFire,
  oneShot,
}

class Weapons {
    // Used in database
  final String id;
  final String name;
  final int attacks;
  final int strength;
  final int ap;
  final int range;
  final int damage;
  final int ballisticSkill;
  final WeaponType type;
  final List<WeaponKeyword> keywords;


  Weapons({
    required this.id,
    required this.name,
    required this.attacks,
    required this.strength,
    required this.ap,
    required this.range,
    required this.damage,
    this.ballisticSkill = 3,
    this.type = WeaponType.ranged,
    this.keywords = const [],
  }); 


  // Json helpers - I want to keeps these for future options like exporting units that I might implement after this course
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'attacks': attacks,
        'strength': strength,
        'ap': ap,
        'range': range,
        'damage': damage,
        'ballisticSkill': ballisticSkill,
        'type': type.name,
        'keywords': keywords.map((k) => k.name).toList(),
      };

  factory Weapons.fromJson(Map<String, dynamic> json) {
    return Weapons(
      id: json['id'],
      name: json['name'],
      attacks: json['attacks'],
      strength: json['strength'],
      ap: json['ap'],
      range: json['range'],
      damage: json['damage'],
      ballisticSkill: json['ballisticSkill'] ?? 3,
      type: WeaponType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WeaponType.ranged,
      ),
      keywords: (json['keywords'] as List?)
              ?.map((k) => WeaponKeyword.values.firstWhere(
                    (e) => e.name == k,
                    orElse: () => WeaponKeyword.rapidFire,
                  ))
              .toList() ??
          [],
    );
  }

  // Map converters for database storage
  Map<String, dynamic> toMap(String unitId) {
    return {
      'id': id,
      'unitId': unitId,
      'name': name,
      'attacks': attacks,
      'strength': strength,
      'ap': ap,
      'range': range,
      'damage': damage,
      'ballisticSkill': ballisticSkill,
      'type': type.name,
      'keywords': keywords.map((k) => k.name).join(','),
    };
  }

  factory Weapons.fromMap(Map<String, dynamic> map) {
    final keywordString = map['keywords'] as String?;
    final keywords = keywordString?.isNotEmpty == true
        ? keywordString!.split(',').map((k) {
            try {
              return WeaponKeyword.values.firstWhere((e) => e.name == k);
            } catch (e) {
              return null;
            }
          }).whereType<WeaponKeyword>().toList()
        : <WeaponKeyword>[];

    return Weapons(
      id: map['id'],
      name: map['name'],
      attacks: map['attacks'],
      strength: map['strength'],
      ap: map['ap'],
      range: map['range'],
      damage: map['damage'],
      ballisticSkill: map['ballisticSkill'] ?? 3,
      type: WeaponType.values.firstWhere(
        (e) => e.name == (map['type'] ?? 'ranged'),
        orElse: () => WeaponType.ranged,
      ),
      keywords: keywords,
    );
  }

  bool hasKeyword(WeaponKeyword keyword) => keywords.contains(keyword);
}