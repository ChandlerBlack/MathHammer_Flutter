enum WeaponType {
  ranged,
  melee,
}

enum WeaponKeyword {
  rapidFire1,
  rapidFire2,
  rapidFire3,
  assault,
  heavy,
  pistol,
  melta1,
  melta2,
  melta3,
  lance,
  blast,
  twinLinked,
  hazardous,
  devastatingWounds,
  precision,
  lethalHits,
  sustainedHits1,
  sustainedHits2,
  sustainedHits3,
  antiFly2,
  antiFly3,
  antiFly4,
  antiInfantry2,
  antiInfantry3,
  antiInfantry4,
  antiMonster2,
  antiMonster3,
  antiMonster4,
  antiVehicle2,
  antiVehicle3,
  antiVehicle4,
  indirectFire,
  oneShot,
}

// this class could be expanded when the ability to add custom weapons to units is added
class Weapons {
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

  bool hasKeyword(WeaponKeyword keyword) => keywords.contains(keyword);
}