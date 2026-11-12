module ReducedLoot

public class ReducedLootSettings extends IScriptable {
  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Active")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Session-Desc")
  public let enabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-DisableAmmoHelp")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-AmmoHelp-Desc")
  public let disableAmmoHelp: Bool = false;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Money")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let money: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Junk")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let junk: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Clothing")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let clothing: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Food")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let food: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Healing")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let healing: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Boosters")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let boosters: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Grenades")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let grenades: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Ammo")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let ammo: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Materials")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let materials: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Attachments")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let attachments: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Quickhacks")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let quickhacks: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Recipes")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Stack-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let recipes: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Weapon1")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Weapon-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let weapon1: Int32 = 80;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Weapon2")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Weapon-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let weapon2: Int32 = 65;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Weapon3")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Weapon-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let weapon3: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Weapon4")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Weapon-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let weapon4: Int32 = 35;

  @runtimeProperty("ModSettings.mod", "Reduced Loot")
  @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Categories-General")
  @runtimeProperty("ModSettings.displayName", "Mod-RL-v1-Weapon5")
  @runtimeProperty("ModSettings.description", "Mod-RL-v1-Weapon-Desc")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  public let weapon5: Int32 = 20;

  public final func Profile() -> array<Uint8> {
    let values: array<Uint8>;
    ArrayPush(values, Cast<Uint8>(Clamp(this.money, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.junk, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.clothing, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.food, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.healing, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.boosters, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.grenades, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.ammo, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.materials, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.attachments, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.quickhacks, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.recipes, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.weapon1, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.weapon2, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.weapon3, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.weapon4, 0, 100)));
    ArrayPush(values, Cast<Uint8>(Clamp(this.weapon5, 0, 100)));
    return values;
  }
}
