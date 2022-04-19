module EnhancedCraft.Core
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

// -- Switch weapon variant to previous one
@addMethod(CraftingLogicController)
public func LoadPrevVariant() -> Void {
  let tdbid: TweakDBID; 
  if ArraySize(this.weaponVariants) > 1 {
    this.weaponIndex = this.weaponIndex - 1;
    if this.weaponIndex < 0 {
      this.weaponIndex = ArraySize(this.weaponVariants) - 1;
    };
    this.alternateSkinSelected = NotEquals(this.weaponIndex, 0);
    this.iconicSelected = IsPresetIconic(this.weaponVariants[this.weaponIndex]);
    this.currentItemRecord = TweakDBInterface.GetItemRecord(this.weaponVariants[this.weaponIndex]);
    tdbid = this.weaponVariants[this.weaponIndex];
    this.UpdateRecipePreviewPanelEnhanced();
    L(s"LoadPrevVariant for index \(this.weaponIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(this.currentItemRecord.Quality().Type())");
  };
}

// -- Switch weapon variant to next one
@addMethod(CraftingLogicController)
public func LoadNextVariant() -> Void {
  let tdbid: TweakDBID; 
  if ArraySize(this.weaponVariants) > 1 {
    this.weaponIndex = this.weaponIndex + 1;
    if this.weaponIndex > ArraySize(this.weaponVariants) - 1 {
      this.weaponIndex = 0;
    };
    this.alternateSkinSelected = NotEquals(this.weaponIndex, 0);
    this.iconicSelected = IsPresetIconic(this.weaponVariants[this.weaponIndex]);
    this.currentItemRecord = TweakDBInterface.GetItemRecord(this.weaponVariants[this.weaponIndex]);
    tdbid = this.weaponVariants[this.weaponIndex];
    this.UpdateRecipePreviewPanelEnhanced();
    L(s"LoadNextVariant for index \(this.weaponIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(this.currentItemRecord.Quality().Type())");
  };
}

// -- Returns random item record (Iconics excluded)
@addMethod(CraftingLogicController)
public func GetRandomVariant() -> ref<Item_Record> {
  let record: ref<Item_Record>;
  let index: Int32 = RandRange(0, ArraySize(this.weaponVariantsNoIconic));
  let tdbid: TweakDBID = this.weaponVariantsNoIconic[index];
  record = TweakDBInterface.GetItemRecord(this.weaponVariantsNoIconic[index]);
  L(s"GetRandomVariant for index \(index) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(record.Quality().Type())");
  return record;
}

// -- Refresh custom crafting panel HUD
@addMethod(CraftingLogicController)
private final func RefreshPanelWidgets() -> Void {  
  if ArraySize(this.weaponVariants) > 1 {
    L(s"RefreshPanelWidgets: array size = \(ArraySize(this.weaponVariants)) so show controls");
    this.ShowButtonHints();
  } else {
    L(s"RefreshPanelWidgets: array size = \(ArraySize(this.weaponVariants)) so hide controls");
    this.HideButtonHints();
  };
  this.RefreshSkinsCounter();
  this.RefreshRandomizerLabel();
}

// -- Calculate variants list based on configs and player perks
@addMethod(CraftingLogicController)
private func RebuildAccordingToPerks(otherIds: array<TweakDBID>, baseId: TweakDBID, quality: CName, skipIconic: Bool) -> array<TweakDBID> {
  let player: ref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let canCraftRare: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftRareItems) > 0.0;
  let canCraftEpic: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftEpicItems) > 0.0;
  let canCraftLegendary: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftLegendaryItems) > 0.0;
  let recipeQualityValue: Int32 = GetBaseQualityValue(quality);
  let configQualityValue: Int32 = Config.IconicRecipeCondition();
  let shouldSkip: Bool;
  let isIconic: Bool;
  let newArray: array<TweakDBID>;
  let currentId: TweakDBID;
  let perkUnlockValue: Int32;
  let i: Int32 = 0;

  ArrayPush(newArray, baseId);
  while i < ArraySize(otherIds) {
    currentId = otherIds[i];
    isIconic = IsPresetIconic(currentId);

    if isIconic {
      perkUnlockValue = Config.PerkToUnlockIconics();
      shouldSkip = skipIconic || Equals(perkUnlockValue, 2) || recipeQualityValue < configQualityValue;
      if !shouldSkip {
        switch perkUnlockValue {
          case 1:
            ArrayPush(newArray, currentId);
            break;
          case 3:
            if canCraftRare { ArrayPush(newArray, currentId); };
            break;
          case 4:
            if canCraftEpic { ArrayPush(newArray, currentId); };
            break;
          case 5:
            if canCraftLegendary { ArrayPush(newArray, currentId); };
            break;
        };
      };
      L(s"----- \(TDBID.ToStringDEBUG(currentId)) is iconic: \(isIconic), skipIconic: \(skipIconic), recipe value: \(recipeQualityValue), config value: \(configQualityValue), shouldSkip: \(shouldSkip), equals: \(Equals(perkUnlockValue, 2))");
    } else {
      perkUnlockValue = Config.PerkToUnlockStandard();
      shouldSkip = false;
      switch perkUnlockValue {
        case 1:
          ArrayPush(newArray, currentId);
          break;
        case 2:
          if canCraftRare { ArrayPush(newArray, currentId); };
          break;
        case 3:
          if canCraftEpic { ArrayPush(newArray, currentId); };
          break;
        case 4:
          if canCraftLegendary { ArrayPush(newArray, currentId); };
          break;
      };
      L(s"----- \(TDBID.ToStringDEBUG(currentId)) is iconic: \(isIconic)");
    };
    
    i += 1;
  };

  return newArray;
}
