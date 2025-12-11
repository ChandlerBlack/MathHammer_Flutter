import '../models/weapon_stats.dart';

// This is a set of default weapons for this version of the app. In later versions, the user will be able to create custom weapons.
class WeaponProfiles {
  
  static Weapons get standardRanged => Weapons(
    id: 'standard_ranged',
    name: 'Standard Ranged',
    attacks: 2,
    strength: 4,
    ap: 0,
    range: 24,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [],
  );

  static Weapons get heavyRanged => Weapons(
    id: 'heavy_ranged',
    name: 'Heavy Ranged',
    attacks: 1,
    strength: 8,
    ap: 2,
    range: 36,
    damage: 2,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.heavy],
  );

  static Weapons get rapidRanged => Weapons(
    id: 'rapid_ranged',
    name: 'Rapid Fire',
    attacks: 3,
    strength: 4,
    ap: 1,
    range: 24,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.rapidFire],
  );

  static Weapons get eliteRanged => Weapons(
    id: 'elite_ranged',
    name: 'Elite Ranged',
    attacks: 2,
    strength: 5,
    ap: 2,
    range: 30,
    damage: 2,
    ballisticSkill: 2,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.lethalHits],
  );

  static Weapons get assaultRanged => Weapons(
    id: 'assault_ranged',
    name: 'Assault',
    attacks: 3,
    strength: 3,
    ap: 0,
    range: 18,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.assault, WeaponKeyword.sustainedHits],
  );

  static Weapons get meltaWeapon => Weapons(
    id: 'melta_weapon',
    name: 'Melta Weapon',
    attacks: 1,
    strength: 9,
    ap: 4,
    range: 12,
    damage: 3,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.melta],
  );

  static Weapons get plasmaWeapon => Weapons(
    id: 'plasma_weapon',
    name: 'Plasma Weapon',
    attacks: 1,
    strength: 7,
    ap: 3,
    range: 24,
    damage: 2,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.hazardous],
  );

  static Weapons get sniperRifle => Weapons(
    id: 'sniper_rifle',
    name: 'Sniper Rifle',
    attacks: 1,
    strength: 5,
    ap: 2,
    range: 36,
    damage: 2,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.precision, WeaponKeyword.lethalHits],
  );

  static Weapons get heavyBolter => Weapons(
    id: 'heavy_bolter',
    name: 'Heavy Bolter',
    attacks: 3,
    strength: 5,
    ap: 1,
    range: 36,
    damage: 2,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.sustainedHits, WeaponKeyword.heavy],
  );

  // Melee weapon profiles
  
  static Weapons get standardMelee => Weapons(
    id: 'standard_melee',
    name: 'Standard Melee',
    attacks: 3,
    strength: 4,
    ap: 0,
    range: 0,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.melee,
    keywords: [],
  );

  static Weapons get powerWeapon => Weapons(
    id: 'power_weapon',
    name: 'Power Weapon',
    attacks: 3,
    strength: 5,
    ap: 2,
    range: 0,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.melee,
    keywords: [],
  );

  static Weapons get heavyMelee => Weapons(
    id: 'heavy_melee',
    name: 'Heavy Melee',
    attacks: 2,
    strength: 8,
    ap: 3,
    range: 0,
    damage: 3,
    ballisticSkill: 4,
    type: WeaponType.melee,
    keywords: [],
  );

  static Weapons get bruteMelee => Weapons(
    id: 'brute_melee',
    name: 'Brute Melee',
    attacks: 4,
    strength: 5,
    ap: 1,
    range: 0,
    damage: 2,
    ballisticSkill: 3,
    type: WeaponType.melee,
    keywords: [WeaponKeyword.sustainedHits],
  );

  static Weapons get eliteMelee => Weapons(
    id: 'elite_melee',
    name: 'Elite Melee',
    attacks: 4,
    strength: 6,
    ap: 2,
    range: 0,
    damage: 2,
    ballisticSkill: 2,
    type: WeaponType.melee,
    keywords: [WeaponKeyword.lethalHits, WeaponKeyword.devastatingWounds],
  );

  // Get all available ranged profiles
  static List<Weapons> get allRangedProfiles => [
    standardRanged,
    rapidRanged,
    assaultRanged,
    eliteRanged,
    heavyRanged,
    heavyBolter,
    plasmaWeapon,
    meltaWeapon,
    sniperRifle,
  ];

  // Get all available melee profiles
  static List<Weapons> get allMeleeProfiles => [
    standardMelee,
    powerWeapon,
    bruteMelee,
    heavyMelee,
    eliteMelee,
  ];

  // Get all profiles
  static List<Weapons> get allProfiles => [
    ...allRangedProfiles,
    ...allMeleeProfiles,
  ];

  // Get a profile by ID
  static Weapons? getProfileById(String id) {
    try {
      return allProfiles.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get a profile by name
  static Weapons? getProfileByName(String name) {
    try {
      return allProfiles.firstWhere((w) => w.name == name);
    } catch (e) {
      return null;
    }
  }
}