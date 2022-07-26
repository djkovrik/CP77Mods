module EnhancedCraft.Core
import EnhancedCraft.Events.*
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

@wrapMethod(CraftingLogicController)
protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
  this.weaponIndex = 0;
  this.clothesIndex = 0;
  this.iconicSelected = false;
  this.alternateSkinSelected = false;
  ArrayClear(this.clothesVariants);
  ArrayClear(this.weaponVariants);
  ArrayClear(this.weaponVariantsNoIconic);
  L("--- Arrays cleared");
  wrappedMethod(craftableController);
  L(s"UpdateItemPreview for \(this.m_selectedRecipe.label) \(TDBID.ToStringDEBUG(this.m_selectedRecipe.id.GetID()))");
  this.currentItemRecord = this.m_selectedRecipe.id;
}

@wrapMethod(CraftingLogicController)
private final func UpdateRecipePreviewPanel(selectedRecipe: ref<RecipeData>) -> Void {
  let shouldRefresh: Bool = this.m_selectedRecipe.id != selectedRecipe.id;
  wrappedMethod(selectedRecipe);
  // New logic
  let isWeaponSelected: Bool = InventoryItemData.IsWeapon(this.m_selectedItemData);
  let isGarmentSelected: Bool = InventoryItemData.IsGarment(this.m_selectedItemData);
  let detectedWeaponsVariants: array<TweakDBID>;
  let detectedClothesVariants: array<TweakDBID>;
  let weaponsVariant: Variant;
  let clothesVariant: Variant;
  let qualityVariant: Variant;
  let tdbid: TweakDBID;
  // Initialize variant arrays
  if IsDefined(selectedRecipe) {
    L(s"UpdateRecipePreviewPanel for \(selectedRecipe.label) \(TDBID.ToStringDEBUG(selectedRecipe.id.GetID()))");
    if isWeaponSelected && shouldRefresh {
      tdbid = selectedRecipe.id.GetID();
      weaponsVariant = TweakDBInterface.GetFlat(tdbid + t".weaponVariants");
      qualityVariant = TweakDBInterface.GetFlat(tdbid + t".quality");
      detectedWeaponsVariants = FromVariant<array<TweakDBID>>(weaponsVariant);
      this.originalRecipe = this.m_selectedRecipe;
      this.originalRecipeQuality = StringToName(TweakDBInterface.GetQualityRecord(FromVariant<TweakDBID>(qualityVariant)).Name());
      this.originalItemData = this.m_selectedItemGameData;
      this.weaponVariants = this.RebuildAccordingToPerks(detectedWeaponsVariants, tdbid, this.originalRecipeQuality, false);
      this.weaponVariantsNoIconic = this.RebuildAccordingToPerks(detectedWeaponsVariants, tdbid, this.originalRecipeQuality, true);
      this.RefreshPanelWidgets();
      L(s"--- Array populated (full): \(ArraySize(this.weaponVariants))");
      L(s"--- Array populated (no Iconics): \(ArraySize(this.weaponVariantsNoIconic))");
    };

    if isGarmentSelected && shouldRefresh {
      tdbid = selectedRecipe.id.GetID();
      clothesVariant = TweakDBInterface.GetFlat(tdbid + t".clothesVariants");
      qualityVariant = TweakDBInterface.GetFlat(tdbid + t".quality");
      detectedClothesVariants = FromVariant<array<TweakDBID>>(clothesVariant);
      this.originalRecipe = this.m_selectedRecipe;
      this.originalRecipeQuality = StringToName(TweakDBInterface.GetQualityRecord(FromVariant<TweakDBID>(qualityVariant)).Name());
      this.originalItemData = this.m_selectedItemGameData;
      this.clothesVariants = this.RebuildClothesAccordingToPerks(detectedClothesVariants, tdbid);
      this.RefreshPanelWidgets();
      L(s"--- Array populated: \(ArraySize(this.clothesVariants))");
    };
  };
  // If crafted iconic then switch preview to the first item
  if this.alternateSkinSelected && this.iconicSelected && ArraySize(this.weaponVariants) > 1 {
    this.weaponIndex = 0;
    this.clothesIndex = 0;
    this.iconicSelected = false;
    this.alternateSkinSelected = false;
    this.currentItemRecord = this.m_selectedRecipe.id;
    this.UpdateRecipePreviewPanelEnhanced();
  };
  // If crafted clothes and alternate selected then refresh preview
  if this.alternateSkinSelected && ArraySize(this.clothesVariants) > 1 {
    this.UpdateRecipePreviewPanelEnhanced();
  };
}

@addMethod(CraftingLogicController)
private final func UpdateRecipePreviewPanelEnhanced() -> Void {
  if ArraySize(this.weaponVariants) < 1 && InventoryItemData.IsWeapon(this.m_selectedItemData) {
    return ;
  }; 

  if ArraySize(this.clothesVariants) < 1 && InventoryItemData.IsGarment(this.m_selectedItemData) {
    return ;
  }; 

  let player: wref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let inventorySystem: ref<InventoryManager> = GameInstance.GetInventoryManager(this.m_craftingGameController.GetPlayer().GetGame());
  let isGarment: Bool = InventoryItemData.IsGarment(this.m_selectedItemData);

  // Preview
  let previewEvent: ref<CraftingItemPreviewEvent>;
  previewEvent = new CraftingItemPreviewEvent();
  previewEvent.itemID = ItemID.FromTDBID(this.currentItemRecord.GetID());
  previewEvent.isGarment = isGarment;
  this.QueueEvent(previewEvent);
  this.RefreshPanelWidgets();

  // Setup ingredients
  let ingredients: array<IngredientData> = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
  if IsPresetIconic(this.currentItemRecord.GetID()) {
    this.SetupIngredients(ingredients, this.ecraftConfig.iconicIngredientsMultiplier);
  } else {
    this.SetupIngredients(ingredients, 1);
  };

  // Tooltip data and scaling
  let item: InventoryItemData;
  let craftedItemID: ItemID = ItemID.FromTDBID(this.currentItemRecord.GetID());
  let itemData: ref<gameItemData> = inventorySystem.CreateBasicItemData(craftedItemID, player);
  CraftingSystem.SetItemLevel(player, itemData);
  CraftingSystem.MarkItemAsCrafted(player, itemData);
  itemData.SetDynamicTag(n"SkipActivityLog");
  player.ScaleCraftedItemData(itemData, this.originalRecipeQuality);
  item = this.m_craftingGameController.GetInventoryManager().GetInventoryItemDataForDryItem(itemData);
  this.m_tooltipData = this.GetRecipeOutcomeTooltip(this.originalRecipe, item, itemData);
  this.m_itemTooltipController.GetRootWidget().SetVisible(true);
  this.m_itemTooltipController.SetData(this.m_tooltipData);
  // If selecting clothes then also change name
  if ArraySize(this.clothesVariants) > 0 {
    inkTextRef.SetText(this.m_itemName, LocKeyToString(this.currentItemRecord.DisplayName()));
  };
  // Block controls
  this.m_isCraftable = this.m_craftingSystem.CanItemBeCrafted(this.m_selectedItemGameData);
  inkWidgetRef.SetVisible(this.m_blockedText, !this.m_isCraftable);
  this.m_progressButtonController.SetAvaibility(this.m_isCraftable);
  if !this.m_isCraftable {
    if !this.m_craftingSystem.EnoughIngredientsForCrafting(InventoryItemData.GetGameItemData(this.m_selectedItemData)) {
      inkTextRef.SetText(this.m_blockedText, "LocKey#42797");
      this.m_notificationType = UIMenuNotificationType.CraftingNotEnoughMaterial;
    };
  };
  
  L(s"UpdateRecipePreviewPanelEnhanced called.");
}

@wrapMethod(CraftingLogicController)
private final func SetupIngredients(ingredient: array<IngredientData>, itemAmount: Int32) -> Void {
  let ingredients: array<IngredientData> = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
  if this.iconicSelected {
    wrappedMethod(ingredients, this.ecraftConfig.iconicIngredientsMultiplier);
  } else {
    if this.alternateSkinSelected {
      wrappedMethod(ingredients, 1);
    } else {
      wrappedMethod(ingredient, itemAmount);
    };
  };
}

// -- Inject with custom and random crafts
@replaceMethod(CraftingLogicController)
private final func CraftItem(selectedRecipe: ref<RecipeData>, amount: Int32) -> Void {
  let craftItemRequest: ref<CraftItemRequest>;
  let multiplier: Int32;
  let hasVariantsToRandomize: Bool;
  if NotEquals(selectedRecipe.label, "") {
    craftItemRequest = new CraftItemRequest();
    craftItemRequest.target = this.m_craftingGameController.GetPlayer();
    craftItemRequest.itemRecord = selectedRecipe.id;
    craftItemRequest.amount = amount;
    craftItemRequest.selectedDamageType = this.currentDamageType;
    if selectedRecipe.id.TagsContains(n"Ammo") {
      craftItemRequest.bulletAmount = selectedRecipe.amount;
    };
    if this.alternateSkinSelected {
      if this.iconicSelected {
        multiplier = this.ecraftConfig.iconicIngredientsMultiplier;
      } else {
        multiplier = 1;
      }
      craftItemRequest.custom = true;
      craftItemRequest.originalQuality = this.originalRecipeQuality;
      craftItemRequest.itemRecord = this.currentItemRecord;
      craftItemRequest.originalIngredients = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
      craftItemRequest.quantityMultiplier = multiplier;
    } else {
      hasVariantsToRandomize = ArraySize(this.weaponVariantsNoIconic) > 1;
      if this.ecraftConfig.randomizerEnabled && CraftingMainLogicController.IsWeapon(selectedRecipe.inventoryItem.EquipmentArea) && hasVariantsToRandomize {
        craftItemRequest.custom = true;
        craftItemRequest.originalQuality = this.originalRecipeQuality;
        craftItemRequest.itemRecord = this.GetRandomWeaponVariant();
        craftItemRequest.originalIngredients = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
        craftItemRequest.quantityMultiplier = 1;
      };
    };
    this.m_craftingSystem.QueueRequest(craftItemRequest);
  };
}

// -- Hide hints on tab changed
@addMethod(CraftingLogicController)
protected cb func OnFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
  super.OnFilterChange(controller, selectedIndex);
  this.HideButtonHints();
}

// -- Catch damage type selection events
@addMethod(CraftingLogicController)
protected cb func OnEnhancedCraftDamageTypeClickedEvent(event: ref<EnhancedCraftDamageTypeClicked>) -> Bool {
  L(s"--- Damage type selected: \(event.damageType)");
  this.currentDamageType = event.damageType;
}
