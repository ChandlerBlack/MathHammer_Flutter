import '../models/weapon_stats.dart';

// This is a set of default weapons for this version of the app. In later versions, the user will be able to create custom weapons.
class WeaponProfiles {
  
  static Weapons get boltRifle => Weapons(
    id: 'bolt_rifle',
    name: 'Bolt Rifle',
    attacks: 2,
    strength: 4,
    ap: 1,
    range: 24,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.assault, WeaponKeyword.heavy],
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
    keywords: [WeaponKeyword.heavy, WeaponKeyword.sustainedHits1, WeaponKeyword.devastatingWounds],
  );

  static Weapons get stormBolter => Weapons(
    id: 'storm_bolter',
    name: 'Storm Bolter',
    attacks: 2,
    strength: 4,
    ap: 0,
    range: 24,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.rapidFire2],
  );

  static Weapons get boltSniperRifle => Weapons(
    id: 'bolt_sniper_rifle',
    name: 'Bolt Sniper Rifle',
    attacks: 1,
    strength: 5,
    ap: 2,
    range: 36,
    damage: 3,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.heavy, WeaponKeyword.precision],
  );

  static Weapons get assaultCannon => Weapons(
    id: 'assault_cannon',
    name: 'Assault Cannon',
    attacks: 6,
    strength: 6,
    ap: 0,
    range: 24,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.devastatingWounds],
  );

  static Weapons get meltaRifle => Weapons(
    id: 'melta_rifle',
    name: 'Melta Rifle',
    attacks: 1,
    strength: 9,
    ap: 4,
    range: 12,
    damage: 6,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.melta2, WeaponKeyword.heavy],
  );

  static Weapons get plasmaIncinerator => Weapons(
    id: 'plasma_incinerator',
    name: 'Plasma Incinerator',
    attacks: 2,
    strength: 7,
    ap: 2,
    range: 24,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.assault, WeaponKeyword.heavy],
  );

  static Weapons get lasFusil => Weapons(
    id: 'las_fusil',
    name: 'Las Fusil',
    attacks: 1,
    strength: 9,
    ap: 3,
    range: 36,
    damage: 6,
    ballisticSkill: 3,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.heavy],
  );

  static Weapons get Perdition => Weapons(
    id: 'perdition',
    name: 'Perdition',
    attacks: 1,
    strength: 9,
    ap: 4,
    range: 6,
    damage: 6,
    ballisticSkill: 2,
    type: WeaponType.ranged,
    keywords: [WeaponKeyword.sustainedHits3, WeaponKeyword.pistol, WeaponKeyword.melta2],
  );

  // Melee weapon profiles
  
  static Weapons get cCWeapon => Weapons(
    id: 'cc_weapon',
    name: 'Close Combat Weapon',
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
    attacks: 4,
    strength: 5,
    ap: 2,
    range: 0,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.melee,
    keywords: [],
  );

  static Weapons get thunderHammer => Weapons(
    id: 'thunder_hammer',
    name: 'Thunder Hammer',
    attacks: 3,
    strength: 8,
    ap: 2,
    range: 0,
    damage: 2,
    ballisticSkill: 4,
    type: WeaponType.melee,
    keywords: [WeaponKeyword.devastatingWounds],
  );

  static Weapons get chainsword => Weapons(
    id: 'chainsword',
    name: 'Chainsword',
    attacks: 5,
    strength: 4,
    ap: 1,
    range: 0,
    damage: 1,
    ballisticSkill: 3,
    type: WeaponType.melee,
    keywords: [],
  );

  static Weapons get theAxeMortalis => Weapons(
    id: 'the_axe_mortalis',
    name: 'The Axe Mortalis',
    attacks: 8,
    strength: 8,
    ap: 3,
    range: 0,
    damage: 2,
    ballisticSkill: 2,
    type: WeaponType.melee,
    keywords: [WeaponKeyword.lethalHits],
  );

  // Get all available ranged profiles
  static List<Weapons> get allRangedProfiles => [
    boltRifle,
    heavyBolter,
    stormBolter,
    boltSniperRifle,
    assaultCannon,
    meltaRifle,
    plasmaIncinerator,
    lasFusil,
    Perdition,
  ];

  // Get all available melee profiles
  static List<Weapons> get allMeleeProfiles => [
    cCWeapon,
    powerWeapon,
    thunderHammer,
    chainsword,
    theAxeMortalis,
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