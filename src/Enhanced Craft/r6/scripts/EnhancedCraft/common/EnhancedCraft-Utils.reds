module EnhancedCraft.Common

public class ECraftUtils {
  // -- Checks if item has iconic flag defined in TweakXL
  public static func IsPresetIconic(id: TweakDBID) -> Bool {
    let isIconic: Bool = TweakDBInterface.GetBool(id + t".isPresetIconic", false);
    return isIconic;
  }

  // -- Checks if item has DLC jackets variations
  public static func HasDLCItems(id: TweakDBID) -> Bool {
    let hasItems: Bool = TweakDBInterface.GetBool(id + t".hasDLCItems", false);
    return hasItems;
  }

  // -- Get quality representation as int value to bind with the one defined in IconicRecipeCondition
  public static func GetBaseQualityValue(quality: CName) -> Int32  {
    switch (quality) {
      case n"Rare": return 0;
      case n"Epic": return 1;
      case n"Legendary": return 2;
    };

    return 0;
  }

  public static func IsWeapon(type: gamedataItemType) -> Bool {
    let typeStr: String = ToString(type);
    return StrBeginsWith(typeStr, "Wea_");
  }

  public static func IsClothes(type: gamedataItemType) -> Bool {
    let typeStr: String = ToString(type);
    return StrBeginsWith(typeStr, "Clo_");
  }

  public static func IsWeapon(equipmentArea: gamedataEquipmentArea) -> Bool {
    return Equals(equipmentArea, gamedataEquipmentArea.Weapon);
  }

  public static func IsClothes(equipmentArea: gamedataEquipmentArea) -> Bool {
    return Equals(equipmentArea, gamedataEquipmentArea.Head) || Equals(equipmentArea, gamedataEquipmentArea.Face) || Equals(equipmentArea, gamedataEquipmentArea.OuterChest) || Equals(equipmentArea, gamedataEquipmentArea.InnerChest) || Equals(equipmentArea, gamedataEquipmentArea.Legs) || Equals(equipmentArea, gamedataEquipmentArea.Feet);
  }

}

// -- Basic logging function
public static func L(str: String) -> Void {
  // LogChannel(n"DEBUG", s"Craft: \(str)");
}
