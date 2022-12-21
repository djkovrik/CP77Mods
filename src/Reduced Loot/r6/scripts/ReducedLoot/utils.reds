module ReducedLootUtils

import ReducedLootMain.Config
import ReducedLootTypes.*

public class RL_Checker {

  public static func CanLootThis(data: ref<gameItemData>, source: RL_LootSource) -> Bool {
    let quality: RL_LootQuality = RL_Converters.QualityToQuality(RPGManager.GetItemDataQuality(data));
    let type: RL_LootType = RL_Converters.ItemDataToLootType(data);

    // Iconics check
    if RPGManager.IsItemDataIconic(data) || Equals(RPGManager.GetItemDataQuality(data), gamedataQuality.Iconic) {
      RLog(">>> Iconic item detected: " + ToStr(data));
      return true;
    };
    // Quest check
    if data.HasTag(n"Quest") { 
      RLog(">>> Quest item detected: " + ToStr(data));
      return true; 
    };
    // Сyberdeck check
    if data.HasTag(n"Cyberdeck") { 
      RLog(">>> Cyberdeck detected: " + ToStr(data));
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

  public static func CanDropMods() -> Bool {
    return RL_Utils.ProbabilityCheck(Config.Misc(RL_LootSource.Puppet, RL_LootType.Mods));
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
    return RL_Utils.HasTypePrefix(data, "Wea_");
  }

  public static func IsClothes(data: ref<gameItemData>) -> Bool {
    return RL_Utils.HasTypePrefix(data, "Clo_");
  }

  public static func IsAmmo(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Con_Ammo);
  }

  public static func IsCraftingMats(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Gen_CraftingMaterial);
  }

  public static func IsCyberware(data: ref<gameItemData>) -> Bool {
    return RL_Utils.HasTypePrefix(data, "Cyb_");
  }

  public static func IsEdible(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Con_Edible) || Equals(type, gamedataItemType.Con_LongLasting);
  }

  public static func IsGrenade(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Gad_Grenade);
  }

  public static func IsHealing(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Con_Inhaler) || Equals(type, gamedataItemType.Con_Injector);
  }

  public static func IsJunk(data: ref<gameItemData>) -> Bool {
    return RL_Utils.HasTypePrefix(data, "Gen_") && !RL_Utils.IsMoney(data) && !RL_Utils.IsCraftingMats(data) && !RL_Utils.IsSchematics(data);
  }

  public static func IsMoney(data: ref<gameItemData>) -> Bool {
    return Equals(data.GetID(), ItemID.FromTDBID(t"Items.money"));
  }

  public static func IsMod(data: ref<gameItemData>) -> Bool {
    return RL_Utils.HasTypePrefix(data, "Prt_") && !RL_Utils.IsQuickhack(data);
  }

  public static func IsQuickhack(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Prt_Program);
  }

  public static func IsSchematics(data: ref<gameItemData>) -> Bool {
    return data.HasTag(n"Recipe");
  }

  public static func IsShard(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Gen_Readable);
  }

  public static func IsSkillBook(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return Equals(type, gamedataItemType.Con_Skillbook);
  }

  public static func HasTypePrefix(data: ref<gameItemData>, prefix: String) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    let typeStr: String = ToString(type);
    return StrBeginsWith(typeStr, prefix);
  }
}

public static func ToStr(data: ref<gameItemData>) -> String {
  let itemType: String = UIItemsHelper.GetItemTypeKey(data.GetItemType());
  let quantity: Int32 = data.GetQuantity();
  let quality: String = UIItemsHelper.QualityEnumToString(RPGManager.GetItemDataQuality(data));
  return itemType + " [" + quantity + "]: " + quality;
}

public static func RLog(const str: script_ref<String>) -> Void {
  // LogChannel(n"DEBUG", "RL: " + str);
}
