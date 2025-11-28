class Weapons {
    // Used in database
  final String id;
  final String name;
  final int attacks;
  final int strength;
  final int ap;
  final int range;
  final int damage;



  Weapons({
    required this.id,
    required this.name,
    required this.attacks,
    required this.strength,
    required this.ap,
    required this.range,
    required this.damage,
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
    };
  }

  factory Weapons.fromMap(Map<String, dynamic> map) {
    return Weapons(
      id: map['id'],
      name: map['name'],
      attacks: map['attacks'],
      strength: map['strength'],
      ap: map['ap'],
      range: map['range'],
      damage: map['damage'],
    );
  }

}