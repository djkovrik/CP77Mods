module EnhancedCraft.Core
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*
import EnhancedCraft.Events.*
import EnhancedCraft.System.*

@addMethod(CraftingSystem)
private func IsWeaponAvailableBasedOnPerks(variantId: TweakDBID, quality: CName, isIconic: Bool) -> Bool {
  let player: wref<PlayerPuppet> = this.m_playerPuppet;
  let config: ref<ECraftConfig> = EnhancedCraftSystem.GetConfig(player.GetGame());
  let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let canCraftRare: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftRareItems) > 0.0;
  let canCraftEpic: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftEpicItems) > 0.0;
  let canCraftLegendary: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftLegendaryItems) > 0.0;
  let recipeQualityValue: Int32 = ECraftUtils.GetBaseQualityValue(quality);
  let configQualityValue: Int32 = EnumInt(config.iconicRecipeCondition);
  let shouldSkip: Bool;
  let perkUnlockValue: Int32;

  if isIconic {
    perkUnlockValue = EnumInt(config.perkToUnlockIconics);
    shouldSkip = Equals(perkUnlockValue, 2) || recipeQualityValue < configQualityValue;
    if !shouldSkip {
      switch perkUnlockValue {
        case 1: return true;
        case 2: return false;
        case 3: return canCraftRare;
        case 4: return canCraftEpic;
        case 5: return canCraftLegendary;
        default: return false;
      };
    };
  } else {
    perkUnlockValue = EnumInt(config.perkToUnlockStandard);
    switch perkUnlockValue {
      case 1: return true;
      case 2: return canCraftRare;
      case 3: return canCraftEpic;
      case 4: return canCraftLegendary;
    };
  };

  return false;
}

@addMethod(CraftingSystem)
private func IsClothesAvailableBasedOnPerks(variantId: TweakDBID, quality: CName, isIconic: Bool) -> Bool {
  let player: wref<PlayerPuppet> = this.m_playerPuppet;
  let config: ref<ECraftConfig> = EnhancedCraftSystem.GetConfig(player.GetGame());
  let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let canCraftRare: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftRareItems) > 0.0;
  let canCraftEpic: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftEpicItems) > 0.0;
  let canCraftLegendary: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftLegendaryItems) > 0.0;
  let hasDLCItems: Bool = ECraftUtils.HasDLCItems(variantId);
  let shouldSkip: Bool = hasDLCItems && !config.includeJacketsFromDLC;
  let perkUnlockValue: Int32 = EnumInt(config.perkToUnlockClothes);

  if !shouldSkip {
    switch perkUnlockValue {
      case 1: return true;
      case 2: return canCraftRare;
      case 3: return canCraftEpic;
      case 4: return canCraftLegendary;
    };
  };

  return false;
}

@addMethod(CraftingSystem)
public final const func GetRecipesData(itemRecord: ref<Item_Record>, iconicsMultiplier: Int32, skipIconics: Bool) -> array<ref<RecipeData>> {
  let isWeapon: Bool = ECraftUtils.IsWeapon(itemRecord.ItemType().Type());
  let isClothes: Bool = ECraftUtils.IsClothes(itemRecord.ItemType().Type());
  let quality: CName = StringToName(itemRecord.Quality().Name());
  let result: array<ref<RecipeData>>;
  let originalRecipe: ref<RecipeData> = this.GetRecipeData(itemRecord);

  let listOfIngredients: array<IngredientData>;
  let tempListOfIngredients: array<wref<RecipeElement_Record>>;
  let tempRecipeData: ItemRecipe;
  let tempItemCategory: ref<ItemCategory_Record>;
  let newRecipeData: ref<RecipeData>;

  L(s"GetRecipesData for \(GetLocalizedTextByKey(itemRecord.DisplayName())): quality \(quality), is weapon: \(isWeapon), is clothes: \(isClothes)");
  let tdbid: TweakDBID = itemRecord.GetID();
  let itemsVariant: Variant = TweakDBInterface.GetFlat(tdbid + t".ecraftVariants");
  let variantsArray: array<TweakDBID> = FromVariant<array<TweakDBID>>(itemsVariant);
  let currentItemId: TweakDBID;
  let currentItemRecord: ref<Item_Record>;
  let isPresetIconic: Bool;
  let i: Int32 = 0;
  let j: Int32;

  while i < ArraySize(variantsArray) {
    currentItemId = variantsArray[i];
    currentItemRecord = TweakDBInterface.GetItemRecord(currentItemId);
    isPresetIconic = ECraftUtils.IsPresetIconic(currentItemId) && !skipIconics;
    L(s" -> detected variant: \(TDBID.ToStringDEBUG(currentItemId)) \(currentItemRecord.Quality().Name()), is iconic: \(isPresetIconic)");
    if isWeapon {
      if this.IsWeaponAvailableBasedOnPerks(currentItemId, quality, isPresetIconic) {
        tempRecipeData = this.m_playerCraftBook.GetRecipeData(itemRecord.GetID());
        tempItemCategory = currentItemRecord.ItemCategory();
        newRecipeData = new RecipeData();
        newRecipeData.label = GetLocalizedItemNameByCName(itemRecord.DisplayName());
        newRecipeData.icon = currentItemRecord.IconPath();
        newRecipeData.iconGender = this.m_itemIconGender;
        newRecipeData.description = GetLocalizedItemNameByCName(itemRecord.LocalizedDescription());
        newRecipeData.type = LocKeyToString(tempItemCategory.LocalizedCategory());
        newRecipeData.id = currentItemRecord;
        newRecipeData.amount = tempRecipeData.amount;
        itemRecord.CraftingData().CraftingRecipe(tempListOfIngredients);
        j = 0;
        while j < ArraySize(tempListOfIngredients) {
          ArrayPush(listOfIngredients, this.CreateIngredientData(tempListOfIngredients[j]));
          j += 1;
        };
        newRecipeData.ingredients = listOfIngredients;
        ArrayPush(result, newRecipeData);
        L(s" --> \(TDBID.ToStringDEBUG(currentItemId)) added to weapons");
      } else {
        L(s" --> \(TDBID.ToStringDEBUG(currentItemId)) skipped");
      };
    };

    if isClothes {
      if this.IsClothesAvailableBasedOnPerks(currentItemId, quality, isPresetIconic) {
        tempRecipeData = this.m_playerCraftBook.GetRecipeData(itemRecord.GetID());
        tempItemCategory = currentItemRecord.ItemCategory();
        newRecipeData = new RecipeData();
        newRecipeData.label = GetLocalizedItemNameByCName(currentItemRecord.DisplayName());
        newRecipeData.icon = currentItemRecord.IconPath();
        newRecipeData.iconGender = this.m_itemIconGender;
        newRecipeData.description = GetLocalizedItemNameByCName(itemRecord.LocalizedDescription());
        newRecipeData.type = LocKeyToString(tempItemCategory.LocalizedCategory());
        newRecipeData.id = currentItemRecord;
        newRecipeData.amount = tempRecipeData.amount;
        itemRecord.CraftingData().CraftingRecipe(tempListOfIngredients);
        j = 0;
        while j < ArraySize(tempListOfIngredients) {
          ArrayPush(listOfIngredients, this.CreateIngredientData(tempListOfIngredients[j]));
          j += 1;
        };
        newRecipeData.ingredients = listOfIngredients;
        ArrayPush(result, newRecipeData);
        L(s" --> \(TDBID.ToStringDEBUG(currentItemId)) added to clothes");
      } else {
        L(s" --> \(TDBID.ToStringDEBUG(currentItemId)) skipped");
      };
    };

    i += 1;
  };

  if Equals(ArraySize(variantsArray), 0) {
    ArrayPush(result, originalRecipe);
  };

  return result;
}

// -- Bump ingredients count for iconics
@wrapMethod(CraftingSystem)
public final const func GetItemCraftingCost(itemData: wref<gameItemData>) -> array<IngredientData> {
  let isIconic: Bool = ECraftUtils.IsPresetIconic(ItemID.GetTDBID(itemData.GetID()));
  if !isIconic {
    return wrappedMethod(itemData);
  };
  let config: ref<ECraftConfig> = EnhancedCraftSystem.GetConfig(this.m_playerPuppet.GetGame());
  let multiplier: Int32 = config.iconicIngredientsMultiplier;
  let record: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.GetID()));
  let ingredients: array<IngredientData> = this.GetItemCraftingCost(record);
  let newIngredients: array<IngredientData>;
  let newIngredient: IngredientData;
  let i: Int32 = 0;
  while i < ArraySize(ingredients) {
    newIngredient = ingredients[i];
    newIngredient.quantity = ingredients[i].quantity * multiplier;
    newIngredient.baseQuantity = ingredients[i].baseQuantity * multiplier;
    ArrayPush(newIngredients, newIngredient);
    i += 1;
  };
  return newIngredients;
}

@wrapMethod(CraftingSystem)
private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
  wrappedMethod(request);
  this.m_playerPuppet = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
}

@wrapMethod(CraftingSystem)
private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
  this.m_playerPuppet = null;
  wrappedMethod(request);
}

@wrapMethod(CraftingSystem)
private final func OnCraftItemRequest(request: ref<CraftItemRequest>) -> Void {
  this.m_requestedDamageType = request.selectedDamageType;
  wrappedMethod(request);
}

// -- Log crafting result for normal requests and launch crafting completion event
@wrapMethod(CraftingSystem)
private final func CraftItem(target: wref<GameObject>, itemRecord: ref<Item_Record>, amount: Int32, opt ammoBulletAmount: Int32) -> wref<gameItemData> {
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.m_playerPuppet.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let craftedItem: wref<gameItemData> = wrappedMethod(target, itemRecord, amount, ammoBulletAmount);
  L(s"CRAFTED: \(craftedItem.GetID()) \(TDBID.ToStringDEBUG(ItemID.GetTDBID(craftedItem.GetID()))) \(RPGManager.GetItemDataQuality(craftedItem)) - \(this.m_requestedDamageType)");
  
  // Notify that weapon was crafted
  let event: ref<EnhancedCraftRecipeCrafted>;
  if ECraftUtils.IsWeapon(craftedItem.GetItemType()) && NotEquals(this.m_requestedDamageType, gamedataStatType.Invalid) {
    event = new EnhancedCraftRecipeCrafted();
    event.isWeapon = true;
    event.itemId = craftedItem.GetID();
    this.SwitchCraftedWeaponType(craftedItem);
    GameInstance.GetUISystem(player.GetGame()).QueueEvent(event);
  };
  return craftedItem;
}

// -- Switch damage type
@addMethod(CraftingSystem)
private func SwitchCraftedWeaponType(craftedItem: ref<gameItemData>) -> Void {
  if NotEquals(this.m_requestedDamageType, gamedataStatType.Invalid) {
    let stats: ref<DamageTypeStats> = this.m_playerPuppet.GetCraftedWeaponDamageStats(craftedItem, this.m_requestedDamageType);
    EnhancedCraftSystem.GetInstance(this.m_playerPuppet.GetGame()).AddCustomDamageType(craftedItem.GetID(), stats);
    this.m_playerPuppet.SwitchDamageTypeToChosen(craftedItem, this.m_requestedDamageType);
  };
}
