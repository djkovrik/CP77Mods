module EnhancedCraft.Core
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*
import EnhancedCraft.Events.*
import EnhancedCraft.System.*

@addMethod(CraftingSystem)
private func IsWeaponVariantAvailable(variantId: TweakDBID, quality: CName, isIconic: Bool) -> Bool {
  let player: wref<PlayerPuppet> = this.playerPuppet;
  let config: ref<ECraftConfig> = EnhancedCraftSystem.GetConfig(player.GetGame());
  let recipeQualityValue: Int32 = ECraftUtils.GetBaseQualityValue(quality);
  let configQualityValue: Int32 = EnumInt(config.iconicRecipeCondition);

  if isIconic {
    return recipeQualityValue >= configQualityValue;
  };

  return true;
}

@addMethod(CraftingSystem)
public final const func GetRecipesData(itemRecord: ref<Item_Record>, iconicsMultiplier: Int32, skipIconics: Bool) -> array<ref<RecipeData>> {
  let isWeapon: Bool = ECraftUtils.IsWeapon(itemRecord.ItemType().Type());
  let quality: CName = StringToName(itemRecord.Quality().Name());
  let result: array<ref<RecipeData>>;
  let originalRecipe: ref<RecipeData> = this.GetRecipeData(itemRecord);

  let listOfIngredients: array<IngredientData>;
  let tempListOfIngredients: array<wref<RecipeElement_Record>>;
  let tempRecipeData: ItemRecipe;
  let tempItemCategory: ref<ItemCategory_Record>;
  let newRecipeData: ref<RecipeData>;

  L(s"GetRecipesData for \(TDBID.ToStringDEBUG(itemRecord.GetID())) \(GetLocalizedTextByKey(itemRecord.DisplayName())): quality \(quality), is weapon: \(isWeapon)");
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
      if this.IsWeaponVariantAvailable(currentItemId, quality, isPresetIconic) {
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
  let config: ref<ECraftConfig> = EnhancedCraftSystem.GetConfig(this.playerPuppet.GetGame());
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
  this.playerPuppet = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
}

@wrapMethod(CraftingSystem)
private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
  this.playerPuppet = null;
  wrappedMethod(request);
}

// -- Log crafting result for normal requests and launch crafting completion event
@wrapMethod(CraftingSystem)
private final func CraftItem(target: wref<GameObject>, itemRecord: ref<Item_Record>, amount: Int32, opt ammoBulletAmount: Int32) -> wref<gameItemData> {
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.playerPuppet.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  let craftedItem: wref<gameItemData> = wrappedMethod(target, itemRecord, amount, ammoBulletAmount);
  L(s"CRAFTED: \(craftedItem.GetID()) \(TDBID.ToStringDEBUG(ItemID.GetTDBID(craftedItem.GetID()))) \(RPGManager.GetItemDataQuality(craftedItem))");
  
  // Notify that weapon was crafted
  let event: ref<EnhancedCraftRecipeCrafted> = new EnhancedCraftRecipeCrafted();
  if ECraftUtils.IsWeapon(craftedItem.GetItemType()) {
    event.isWeapon = true;
    event.itemId = craftedItem.GetID();
    GameInstance.GetUISystem(player.GetGame()).QueueEvent(event);
  };
  return craftedItem;
}
