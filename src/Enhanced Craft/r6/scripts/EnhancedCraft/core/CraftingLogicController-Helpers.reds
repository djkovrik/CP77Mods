module EnhancedCraft.Core
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

// -- Switch weapon variant to previous one
@addMethod(CraftingLogicController)
public func LoadPrevWeaponVariant() -> Void {
  let tdbid: TweakDBID; 
  if ArraySize(this.weaponVariants) > 1 {
    this.weaponIndex = this.weaponIndex - 1;
    if this.weaponIndex < 0 {
      this.weaponIndex = ArraySize(this.weaponVariants) - 1;
    };
    this.alternateSkinSelected = NotEquals(this.weaponIndex, 0) && ArraySize(this.weaponVariants) > 1;
    this.iconicSelected = this.alternateSkinSelected && IsPresetIconic(this.weaponVariants[this.weaponIndex]);
    this.currentItemRecord = TweakDBInterface.GetItemRecord(this.weaponVariants[this.weaponIndex]);
    tdbid = this.weaponVariants[this.weaponIndex];
    this.UpdateRecipePreviewPanelEnhanced();
    L(s"LoadPrevWeaponVariant for index \(this.weaponIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(this.currentItemRecord.Quality().Type())");
  };
}

// -- Switch weapon variant to next one
@addMethod(CraftingLogicController)
public func LoadNextWeaponVariant() -> Void {
  let tdbid: TweakDBID; 
  if ArraySize(this.weaponVariants) > 1 {
    this.weaponIndex = this.weaponIndex + 1;
    if this.weaponIndex > ArraySize(this.weaponVariants) - 1 {
      this.weaponIndex = 0;
    };
    this.alternateSkinSelected = NotEquals(this.weaponIndex, 0) && ArraySize(this.weaponVariants) > 1;
    this.iconicSelected = this.alternateSkinSelected && IsPresetIconic(this.weaponVariants[this.weaponIndex]);
    this.currentItemRecord = TweakDBInterface.GetItemRecord(this.weaponVariants[this.weaponIndex]);
    tdbid = this.weaponVariants[this.weaponIndex];
    this.UpdateRecipePreviewPanelEnhanced();
    L(s"LoadNextWeaponVariant for index \(this.weaponIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(this.currentItemRecord.Quality().Type())");
  };
}

// -- Returns random item record (Iconics excluded)
@addMethod(CraftingLogicController)
public func GetRandomWeaponVariant() -> ref<Item_Record> {
  let record: ref<Item_Record>;
  let index: Int32 = RandRange(0, ArraySize(this.weaponVariantsNoIconic));
  let tdbid: TweakDBID = this.weaponVariantsNoIconic[index];
  record = TweakDBInterface.GetItemRecord(this.weaponVariantsNoIconic[index]);
  L(s"GetRandomWeaponVariant for index \(index) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(record.Quality().Type())");
  return record;
}

// -- Switch clothes variant to previous one
@addMethod(CraftingLogicController)
public func LoadPrevClothesVariant() -> Void {
  let tdbid: TweakDBID; 
  if ArraySize(this.clothesVariants) > 1 {
    this.clothesIndex = this.clothesIndex - 1;
    if this.clothesIndex < 0 {
      this.clothesIndex = ArraySize(this.clothesVariants) - 1;
    };
    this.alternateSkinSelected = NotEquals(this.clothesIndex, 0) && ArraySize(this.clothesVariants) > 1;
    this.iconicSelected = this.alternateSkinSelected && IsPresetIconic(this.clothesVariants[this.clothesIndex]);
    this.currentItemRecord = TweakDBInterface.GetItemRecord(this.clothesVariants[this.clothesIndex]);
    tdbid = this.clothesVariants[this.clothesIndex];
    this.UpdateRecipePreviewPanelEnhanced();
    L(s"LoadPrevClothesVariant for index \(this.clothesIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(this.currentItemRecord.Quality().Type())");
  };
}

// -- Switch clothes variant to next one
@addMethod(CraftingLogicController)
public func LoadNextClothesVariant() -> Void {
  let tdbid: TweakDBID; 
  if ArraySize(this.clothesVariants) > 1 {
    this.clothesIndex = this.clothesIndex + 1;
    if this.clothesIndex > ArraySize(this.clothesVariants) - 1 {
      this.clothesIndex = 0;
    };
    this.alternateSkinSelected = NotEquals(this.clothesIndex, 0) && ArraySize(this.clothesVariants) > 1;
    this.iconicSelected = this.alternateSkinSelected && IsPresetIconic(this.clothesVariants[this.clothesIndex]);
    this.currentItemRecord = TweakDBInterface.GetItemRecord(this.clothesVariants[this.clothesIndex]);
    tdbid = this.clothesVariants[this.clothesIndex];
    this.UpdateRecipePreviewPanelEnhanced();
    L(s"LoadNextClothesVariant for index \(this.clothesIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(this.currentItemRecord.Quality().Type())");
  };
}


// -- Refresh custom crafting panel HUD
@addMethod(CraftingLogicController)
private final func RefreshPanelWidgets() -> Void {  
  if ArraySize(this.weaponVariants) > 1 || ArraySize(this.clothesVariants) > 1 {
    L(s"RefreshPanelWidgets - show controls");
    this.ShowButtonHints();
  } else {
    L(s"RefreshPanelWidgets - hide controls");
    this.HideButtonHints();
  };
  this.RefreshSkinsCounter();
  this.RefreshClothesCounter();
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

// -- Calculate clothes variants list based on configs and player perks
@addMethod(CraftingLogicController)
private func RebuildClothesAccordingToPerks(otherIds: array<TweakDBID>, baseId: TweakDBID) -> array<TweakDBID> {
  let player: ref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let canCraftRare: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftRareItems) > 0.0;
  let canCraftEpic: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftEpicItems) > 0.0;
  let canCraftLegendary: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftLegendaryItems) > 0.0;

  let hasDLCItems: Bool = HasDLCItems(baseId);
  let shouldSkip: Bool = hasDLCItems && !Config.IncludeJacketsFromDLC();
  let newArray: array<TweakDBID>;
  let currentId: TweakDBID;
  let perkUnlockValue: Int32;
  let i: Int32 = 0;
  ArrayPush(newArray, baseId);
  if !shouldSkip {
    while i < ArraySize(otherIds) {
      currentId = otherIds[i];
      perkUnlockValue = Config.PerkToUnlockClothes();
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
      i += 1;
    };
  };

  return newArray;
}
