module EnhancedCraft.Core
import EnhancedCraft.Events.*
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

@wrapMethod(CraftingLogicController)
protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
  this.weaponIndex = 0;
  this.alternateSkinSelected = false;
  ArrayClear(this.weaponVariants);
  ArrayClear(this.weaponVariantsNoIconic);
  L("--- Arrays cleared");
  wrappedMethod(craftableController);
  L(s"UpdateRecipePreviewPanel for \(this.m_selectedRecipe.label) \(TDBID.ToStringDEBUG(this.m_selectedRecipe.id.GetID()))");
  this.currentItemRecord = this.m_selectedRecipe.id;
}

@wrapMethod(CraftingLogicController)
private final func UpdateRecipePreviewPanel(selectedRecipe: ref<RecipeData>) -> Void {
  let shouldRefresh: Bool = this.m_selectedRecipe.id != selectedRecipe.id;
  wrappedMethod(selectedRecipe);
  // New logic
  let isWeaponSelected: Bool = InventoryItemData.IsWeapon(this.m_selectedItemData);
  let detectedVariants: array<TweakDBID>;
  let weaponsVariant: Variant;
  let qualityVariant: Variant;
  let tdbid: TweakDBID;
  if IsDefined(selectedRecipe) { 
    L(s"UpdateRecipePreviewPanel for \(selectedRecipe.label) \(TDBID.ToStringDEBUG(selectedRecipe.id.GetID()))");
    if isWeaponSelected && shouldRefresh {
      tdbid = selectedRecipe.id.GetID();
      weaponsVariant = TweakDBInterface.GetFlat(tdbid + t".weaponVariants");
      qualityVariant = TweakDBInterface.GetFlat(tdbid + t".quality");
      detectedVariants = FromVariant<array<TweakDBID>>(weaponsVariant);
      this.originalRecipe = this.m_selectedRecipe;
      this.originalRecipeQuality = StringToName(TweakDBInterface.GetQualityRecord(FromVariant<TweakDBID>(qualityVariant)).Name());
      this.originalItemData = this.m_selectedItemGameData;
      this.weaponVariants = this.RebuildAccordingToPerks(detectedVariants, tdbid, this.originalRecipeQuality, false);
      this.weaponVariantsNoIconic = this.RebuildAccordingToPerks(detectedVariants, tdbid, this.originalRecipeQuality, true);
      this.RefreshPanelWidgets();
      L(s"--- Array populated (full): \(ArraySize(this.weaponVariants))");
      L(s"--- Array populated (no Iconics): \(ArraySize(this.weaponVariantsNoIconic))");
    };
  };
}


@addMethod(CraftingLogicController)
private final func UpdateRecipePreviewPanelEnhanced() -> Void {
  if ArraySize(this.weaponVariants) < 1 {
    return ;
  }; 

  let player: wref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let inventorySystem: ref<InventoryManager> = GameInstance.GetInventoryManager(this.m_craftingGameController.GetPlayer().GetGame());

  // Preview
  let previewEvent: ref<CraftingItemPreviewEvent>;
  previewEvent = new CraftingItemPreviewEvent();
  previewEvent.itemID = ItemID.FromTDBID(this.currentItemRecord.GetID());
  previewEvent.isGarment = false;
  this.QueueEvent(previewEvent);
  this.RefreshPanelWidgets();

  // Setup ingredients
  let ingredients: array<IngredientData> = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
  if IsPresetIconic(this.currentItemRecord.GetID()) {
    this.SetupIngredients(ingredients, Config.IconicIngredientsMultiplier());
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
  
  L(s"UpdateRecipePreviewPanelEnhanced for index \(this.weaponIndex)");
}

@wrapMethod(CraftingLogicController)
private final func SetupIngredients(ingredient: array<IngredientData>, itemAmount: Int32) -> Void {
  let ingredients: array<IngredientData> = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
  if IsPresetIconic(this.currentItemRecord.GetID()) {
    wrappedMethod(ingredients, Config.IconicIngredientsMultiplier());
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
        multiplier = Config.IconicIngredientsMultiplier();
      } else {
        multiplier = 1;
      }
      craftItemRequest.custom = true;
      craftItemRequest.originalQuality = this.originalRecipeQuality;
      craftItemRequest.itemRecord = this.currentItemRecord;
      craftItemRequest.originalIngredients = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
      craftItemRequest.quantityMultiplier = multiplier;
    } else {
      if Config.RandomizerEnabled() {
      craftItemRequest.custom = true;
      craftItemRequest.originalQuality = this.originalRecipeQuality;
      craftItemRequest.itemRecord = this.GetRandomVariant();
      craftItemRequest.originalIngredients = this.m_craftingSystem.GetItemCraftingCost(this.originalItemData);
      craftItemRequest.quantityMultiplier = 1;
      };
    }
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
