module ReducedLootUtils

import ReducedLootMain.Config
import ReducedLootTypes.*

public class RL_Checker {

  public static func CanLootThis(data: ref<gameItemData>, source: RL_LootSource) -> Bool {
    let quality: RL_LootQuality = RL_Converters.QualityToQuality(RPGManager.GetItemDataQuality(data));
    let type: RL_LootType = RL_Converters.ItemDataToLootType(data);

    // Iconics check
    if RPGManager.IsItemDataIconic(data) || Equals(RPGManager.GetItemDataQuality(data), gamedataQuality.Iconic) {
      return true;
    };
    // Quest and cyberdeck check
    if data.HasTag(n"Quest") || data.HasTag(n"Cyberdeck") { 
      return true; 
    };
    // Weapons check
    if Equals(RL_LootType.Weapon, type) {
      return RL_Utils.ProbabilityCheck(Config.Weapon(source, quality));
    }
    // Clothes check
    if Equals(RL_LootType.Clothes, type) {
      return RL_Utils.ProbabilityCheck(Config.Clothes(source, quality));
    }
    // Other checks
    return RL_Utils.ProbabilityCheck(Config.Misc(source, type));
  }

  public static func CanDropAmmo(source: RL_LootSource) -> Bool {
    return RL_Utils.ProbabilityCheck(Config.Misc(source, RL_LootType.Ammo));
  }
}

public class RL_Converters {

  public static func QualityToInt(quality: RL_LootQuality) -> Int32 {
    switch quality {
      case RL_LootQuality.Common: return 0;
      case RL_LootQuality.Uncommon: return 1;
      case RL_LootQuality.Rare: return 2;
      case RL_LootQuality.Epic: return 3;
      case RL_LootQuality.Legendary: return 4;
      default: return 0;
    };
  }

  public static func QualityToQuality(quality: gamedataQuality) -> RL_LootQuality {
    switch quality {
      case gamedataQuality.Common: return RL_LootQuality.Common;
      case gamedataQuality.Uncommon: return RL_LootQuality.Uncommon;
      case gamedataQuality.Rare: return RL_LootQuality.Rare;
      case gamedataQuality.Epic: return RL_LootQuality.Epic;
      case gamedataQuality.Legendary: return RL_LootQuality.Legendary;
      default: return RL_LootQuality.Common;
    };
  }

  public static func SourceToInt(source: RL_LootSource) -> Int32 {
    switch source {
      case RL_LootSource.Container: return 0;
      case RL_LootSource.World: return 1;
      case RL_LootSource.Puppet: return 2;
      case RL_LootSource.Held: return 3;
      default: return 0;
    };
  }

  public static func ItemDataToLootType(data: ref<gameItemData>) -> RL_LootType {
    if RL_Utils.IsWeapon(data) { return RL_LootType.Weapon; }
    if RL_Utils.IsClothes(data) { return RL_LootType.Clothes; }
    if RL_Utils.IsAmmo(data) { return RL_LootType.Ammo; }
    if RL_Utils.IsCraftingMats(data) { return RL_LootType.CraftingMaterials; }
    if RL_Utils.IsCyberware(data) { return RL_LootType.Cyberware; }
    if RL_Utils.IsEdible(data) { return RL_LootType.Edibles; }
    if RL_Utils.IsGrenade(data) { return RL_LootType.Grenades; }
    if RL_Utils.IsHealing(data) { return RL_LootType.Healings; }
    if RL_Utils.IsJunk(data) { return RL_LootType.Junk; }
    if RL_Utils.IsMod(data) { return RL_LootType.Mods; }
    if RL_Utils.IsMoney(data) { return RL_LootType.Money; }
    if RL_Utils.IsQuickhack(data) { return RL_LootType.Quickhacks; }
    if RL_Utils.IsSchematics(data) { return RL_LootType.Schematics; }
    if RL_Utils.IsShard(data) { return RL_LootType.Shards; }
    if RL_Utils.IsSkillBook(data) { return RL_LootType.SkillBooks; }

    return RL_LootType.Junk;
  }
}

public class RL_Utils {

  public static func ProbabilityCheck(chosen: Int32) -> Bool {
    let random: Int32 = RandRange(1, 100);
    RLog("~ check "  + IntToString(chosen) + " against " + IntToString(random));
    return chosen >= random;
  }

  public static func IsWeapon(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue >= 43 && typeValue <= 62;
  }

  public static func IsClothes(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue >= 0 && typeValue <= 6;
  }

  public static func IsAmmo(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 7;
  }

  public static func IsCraftingMats(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 23;
  }

  public static func IsCyberware(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue >= 13 && typeValue <= 17;
  }

  public static func IsEdible(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 8 || typeValue == 11;
  }

  public static func IsGrenade(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 22;
  }

  public static func IsHealing(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 9 || typeValue == 10;
  }

  public static func IsJunk(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue >= 24 && typeValue <= 27 && !RL_Utils.IsMoney(data);
  }

  public static func IsMod(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue >= 29 && typeValue <= 42 && typeValue != 37;
  }

  public static func IsMoney(data: ref<gameItemData>) -> Bool {
    return Equals(data.GetID(), ItemID.FromTDBID(t"Items.money"));
  }

  public static func IsQuickhack(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 37;
  }

  public static func IsSchematics(data: ref<gameItemData>) -> Bool {
    return data.HasTag(n"Recipe");
  }

  public static func IsShard(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 28;
  }

  public static func IsSkillBook(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeValue: Int32 = RL_Utils.GetItemTypeValue(type);
    return typeValue == 12;
  }

  public static func GetItemTypeValue(itemType: gamedataItemType) -> Int32 {
    switch itemType {
      case gamedataItemType.Clo_Face: return 0;
      case gamedataItemType.Clo_Feet: return 1;
      case gamedataItemType.Clo_Head: return 2;
      case gamedataItemType.Clo_InnerChest: return 3;
      case gamedataItemType.Clo_Legs: return 4;
      case gamedataItemType.Clo_OuterChest: return 5;
      case gamedataItemType.Clo_Outfit: return 6;
      case gamedataItemType.Con_Ammo: return 7;
      case gamedataItemType.Con_Edible: return 8;
      case gamedataItemType.Con_Inhaler: return 9;
      case gamedataItemType.Con_Injector: return 10;
      case gamedataItemType.Con_LongLasting: return 11;
      case gamedataItemType.Con_Skillbook: return 12;
      case gamedataItemType.Cyb_Ability: return 13;
      case gamedataItemType.Cyb_Launcher: return 14;
      case gamedataItemType.Cyb_MantisBlades: return 15;
      case gamedataItemType.Cyb_NanoWires: return 16;
      case gamedataItemType.Cyb_StrongArms: return 17;
      case gamedataItemType.Fla_Launcher: return 18;
      case gamedataItemType.Fla_Rifle: return 19;
      case gamedataItemType.Fla_Shock: return 20;
      case gamedataItemType.Fla_Support: return 21;
      case gamedataItemType.Gad_Grenade: return 22;
      case gamedataItemType.Gen_CraftingMaterial: return 23;
      case gamedataItemType.Gen_DataBank: return 24;
      case gamedataItemType.Gen_Junk: return 25;
      case gamedataItemType.Gen_Keycard: return 26;
      case gamedataItemType.Gen_Misc: return 27;
      case gamedataItemType.Gen_Readable: return 28;
      case gamedataItemType.GrenadeDelivery: return 29;
      case gamedataItemType.Grenade_Core: return 30;
      case gamedataItemType.Prt_Capacitor: return 31;
      case gamedataItemType.Prt_FabricEnhancer: return 32;
      case gamedataItemType.Prt_Fragment: return 33;
      case gamedataItemType.Prt_Magazine: return 34;
      case gamedataItemType.Prt_Mod: return 35;
      case gamedataItemType.Prt_Muzzle: return 36;
      case gamedataItemType.Prt_Program: return 37;
      case gamedataItemType.Prt_Receiver: return 38;
      case gamedataItemType.Prt_Scope: return 39;
      case gamedataItemType.Prt_ScopeRail: return 40;
      case gamedataItemType.Prt_Stock: return 41;
      case gamedataItemType.Prt_TargetingSystem: return 42;
      case gamedataItemType.Wea_AssaultRifle: return 43;
      case gamedataItemType.Wea_Fists: return 44;
      case gamedataItemType.Wea_Hammer: return 45;
      case gamedataItemType.Wea_Handgun: return 46;
      case gamedataItemType.Wea_HeavyMachineGun: return 47;
      case gamedataItemType.Wea_Katana: return 48;
      case gamedataItemType.Wea_Knife: return 49;
      case gamedataItemType.Wea_LightMachineGun: return 50;
      case gamedataItemType.Wea_LongBlade: return 51;
      case gamedataItemType.Wea_Melee: return 52;
      case gamedataItemType.Wea_OneHandedClub: return 53;
      case gamedataItemType.Wea_PrecisionRifle: return 54;
      case gamedataItemType.Wea_Revolver: return 55;
      case gamedataItemType.Wea_Rifle: return 56;
      case gamedataItemType.Wea_ShortBlade: return 57;
      case gamedataItemType.Wea_Shotgun: return 58;
      case gamedataItemType.Wea_ShotgunDual: return 59;
      case gamedataItemType.Wea_SniperRifle: return 60;
      case gamedataItemType.Wea_SubmachineGun: return 61;
      case gamedataItemType.Wea_TwoHandedClub: return 62;
      case gamedataItemType.Count: return 63;
      case gamedataItemType.Invalid: return 64;
    };
    return 0;
  }
}

public static func RLog(str: String) -> Void {
  Log(str);
}
