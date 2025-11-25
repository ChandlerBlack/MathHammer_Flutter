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


  // Json helpers
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
}