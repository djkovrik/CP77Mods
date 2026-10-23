module ReducedLootTypes

enum RL_LootSource {
  Container = 0,
  World = 1,
  Puppet = 2,
  Held = 3,
}

enum RL_LootQuality {
  Common = 0,
  Uncommon = 1,
  Rare = 2,
  Epic = 3,
  Legendary = 4,
}

enum RL_LootType {
  Weapon = 0,
  Clothes = 1,
  Ammo = 2,
  CraftingMaterials = 3,
  Cyberware = 4,
  Edibles = 5,
  Grenades = 6,
  Healings = 7,
  Junk = 8,
  Mods = 9,
  Money = 10,
  Quickhacks = 11,
  Schematics = 12,
  SkillBooks = 13,
}
