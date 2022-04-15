module EnhancedCraft.Preview
import EnhancedCraft.Common.*
import EnhancedCraft.Config.*

@addField(Item_Record)
public let m_originalQuality: CName;

@addField(Item_Record)
public let m_isCustomVariant: Bool;

@addField(CraftingLogicController)
private let m_variantsPopulated: Bool;

@addField(CraftingLogicController)
private let m_weaponVariants: array<TweakDBID>;

@addField(CraftingLogicController)
private let m_recipeQuality: CName;

@addField(CraftingLogicController)
private let m_weaponIndex: Int32;

@addMethod(CraftingLogicController)
private final func RefreshPanelWidgets() -> Void {  
  if ArraySize(this.m_weaponVariants) > 1 {
    L(s"RefreshPanelWidgets: array size = \(ArraySize(this.m_weaponVariants)) so show controls");
    this.ShowButtonHints();
  } else {
    L(s"RefreshPanelWidgets: array size = \(ArraySize(this.m_weaponVariants)) so hide controls");
    this.HideButtonHints();
  };
  this.RefreshSkinsCounter();
  this.RefreshRandomizerLabel();
}

@addMethod(CraftingLogicController)
public func GetRandomVariant() -> ref<Item_Record> {
  let record: ref<Item_Record>;
  let index: Int32 = RandRange(0, ArraySize(this.m_weaponVariants));
  let tdbid: TweakDBID = this.m_weaponVariants[index];
  record = TweakDBInterface.GetItemRecord(this.m_weaponVariants[index]);
  record.m_isCustomVariant = NotEquals(index, 0);
  record.m_originalQuality = this.m_recipeQuality;
  L(s"GetRandomVariant for index \(index) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(record.Quality().Type())");
  return record;
}

@addMethod(CraftingLogicController)
public func LoadPrevVariant() -> Void {
  let previewEvent: ref<CraftingItemPreviewEvent>;
  let record: ref<Item_Record>;
  let tdbid: TweakDBID; 
  if ArraySize(this.m_weaponVariants) > 1 {
    this.m_weaponIndex = this.m_weaponIndex - 1;
    if this.m_weaponIndex < 0 {
      this.m_weaponIndex = ArraySize(this.m_weaponVariants) - 1;
    };
    record = TweakDBInterface.GetItemRecord(this.m_weaponVariants[this.m_weaponIndex]);
    record.m_isCustomVariant = NotEquals(this.m_weaponIndex, 0);
    record.m_originalQuality = this.m_recipeQuality;
    tdbid = this.m_weaponVariants[this.m_weaponIndex];
    this.m_selectedRecipe.id = record;
    this.RefreshItemPreview(this.m_selectedRecipe);
    previewEvent = new CraftingItemPreviewEvent();
    previewEvent.itemID = ItemID.FromTDBID(this.m_selectedRecipe.id.GetID());
    previewEvent.isGarment = false;
    this.QueueEvent(previewEvent);
    L(s"LoadPrevVariant for index \(this.m_weaponIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(record.Quality().Type())");
  };
}

@addMethod(CraftingLogicController)
public func LoadNextVariant() -> Void {
  let previewEvent: ref<CraftingItemPreviewEvent>;
  let record: ref<Item_Record>;
  let tdbid: TweakDBID; 
  if ArraySize(this.m_weaponVariants) > 1 {
    this.m_weaponIndex = this.m_weaponIndex + 1;
    if this.m_weaponIndex > ArraySize(this.m_weaponVariants) - 1 {
      this.m_weaponIndex = 0;
    };
    record = TweakDBInterface.GetItemRecord(this.m_weaponVariants[this.m_weaponIndex]);
    record.m_isCustomVariant = NotEquals(this.m_weaponIndex, 0);
    record.m_originalQuality = this.m_recipeQuality;
    tdbid = this.m_weaponVariants[this.m_weaponIndex];
    this.m_selectedRecipe.id = record;
    this.RefreshItemPreview(this.m_selectedRecipe);
    previewEvent = new CraftingItemPreviewEvent();
    previewEvent.itemID = ItemID.FromTDBID(this.m_selectedRecipe.id.GetID());
    previewEvent.isGarment = false;
    this.QueueEvent(previewEvent);
    L(s"LoadNextVariant for index \(this.m_weaponIndex) and id \(TDBID.ToStringDEBUG(tdbid)) with quality \(record.Quality().Type())");
  };
}

@wrapMethod(CraftingLogicController)
protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
  this.m_variantsPopulated = false;
  ArrayClear(this.m_weaponVariants);
  L("--- Array cleared");
  wrappedMethod(craftableController);
}

@replaceMethod(CraftingLogicController)
private final func UpdateRecipePreviewPanel(selectedRecipe: ref<RecipeData>) -> Void {
  let isGarment: Bool;
  let isQuickHack: Bool;
  let isWeapon: Bool;
  let previewEvent: ref<CraftingItemPreviewEvent>;
  this.m_selectedRecipe.isSelected = false;
  if selectedRecipe == null {
    inkWidgetRef.SetVisible(this.m_itemDetailsContainer, false);
    return;
  };
  inkWidgetRef.SetVisible(this.m_itemDetailsContainer, true);
  this.DryMakeItem(selectedRecipe);
  isWeapon = InventoryItemData.IsWeapon(this.m_selectedItemData);
  isGarment = InventoryItemData.IsGarment(this.m_selectedItemData);
  inkWidgetRef.SetVisible(this.m_weaponPreviewContainer, isWeapon);
  inkWidgetRef.SetVisible(this.m_garmentPreviewContainer, isGarment);
  inkWidgetRef.SetVisible(this.m_itemPreviewContainer, !isWeapon && !isGarment);
  if isGarment && this.m_selectedRecipe.id != selectedRecipe.id {
    previewEvent = new CraftingItemPreviewEvent();
    previewEvent.itemID = this.m_selectedItemGameData.GetID();
    previewEvent.isGarment = isGarment;
    this.QueueEvent(previewEvent);
  };
  // New logic
  let weaponsVariant: Variant;
  let qualityVariant: Variant;
  let detectedVariants: array<TweakDBID>;
  let tdbid: TweakDBID;
  if isWeapon && this.m_selectedRecipe.id != selectedRecipe.id {
    if !this.m_variantsPopulated {
      this.m_variantsPopulated = true;
      tdbid = selectedRecipe.id.GetID();
      weaponsVariant = TweakDBInterface.GetFlat(tdbid + t".weaponVariants");
      qualityVariant = TweakDBInterface.GetFlat(tdbid + t".quality");
      this.m_recipeQuality = StringToName(TweakDBInterface.GetQualityRecord(FromVariant<TweakDBID>(qualityVariant)).Name());
      detectedVariants = FromVariant<array<TweakDBID>>(weaponsVariant);
      this.m_weaponVariants = this.RebuildBasedOnPerks(tdbid, detectedVariants);
      this.m_weaponIndex = 0;
      L(s"--- Array populated: \(ArraySize(this.m_weaponVariants))");
    }
    previewEvent = new CraftingItemPreviewEvent();
    previewEvent.itemID = this.m_selectedItemGameData.GetID();
    previewEvent.isGarment = isGarment;
    this.QueueEvent(previewEvent);
    this.RefreshPanelWidgets();
    L(s"UpdateRecipePreviewPanel for \(selectedRecipe.label) \(TDBID.ToStringDEBUG(selectedRecipe.id.GetID())), total variants \(ArraySize(this.m_weaponVariants))");
  };
  // -
  this.m_selectedRecipe = selectedRecipe;
  this.m_selectedRecipe.isSelected = true;
  this.SetupIngredients(this.m_craftingSystem.GetItemCraftingCost(this.m_selectedItemGameData), 1);
  this.SetPerkNotification();
  this.UpdateTooltipData();
  this.SetQualityHeader();
  this.m_playerCraftBook.SetRecipeInspected(this.m_selectedRecipe.id.GetID());
  isQuickHack = this.IsProgramInInventory(this.m_selectedRecipe.id);
  this.m_isCraftable = this.m_craftingSystem.CanItemBeCrafted(this.m_selectedItemGameData) && !isQuickHack;
  inkWidgetRef.SetVisible(this.m_blockedText, !this.m_isCraftable);
  this.m_progressButtonController.SetAvaibility(this.m_isCraftable);
  if !this.m_isCraftable {
    if isQuickHack {
      inkTextRef.SetText(this.m_blockedText, "LocKey#78498");
      this.m_notificationType = UIMenuNotificationType.CraftingQuickhack;
    } else {
      if !this.m_craftingSystem.EnoughIngredientsForCrafting(InventoryItemData.GetGameItemData(this.m_selectedItemData)) {
        inkTextRef.SetText(this.m_blockedText, "LocKey#42797");
        this.m_notificationType = UIMenuNotificationType.CraftingNotEnoughMaterial;
      };
    };
  };
}

@addMethod(CraftingLogicController)
private func RebuildBasedOnPerks(baseId: TweakDBID, otherIds: array<TweakDBID>) -> array<TweakDBID> {
  let player: ref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
  let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
  let canCraftRare: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftRareItems) > 0.0;
  let canCraftEpic: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftEpicItems) > 0.0;
  let canCraftLegendary: Bool = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanCraftLegendaryItems) > 0.0;
  let newArray: array<TweakDBID>;
  let currentId: TweakDBID;
  let configValue: Int32;
  let i: Int32 = 0;
  ArrayInsert(newArray, 0, baseId);

  while i < ArraySize(otherIds) {
    currentId = otherIds[i];

    if IsPresetIconic(currentId) {
      configValue = Config.PerkToUnlockIconics();
    } else {
      configValue = Config.PerkToUnlockStandard();
    };

    switch configValue {
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

  return newArray;
}

@addMethod(CraftingLogicController)
private final func RefreshItemPreview(selectedRecipe: ref<RecipeData>) -> Void {
  this.DryMakeItem(selectedRecipe);
  this.UpdateTooltipData();
}

@wrapMethod(CraftingLogicController)
private final func SetupIngredients(ingredient: array<IngredientData>, itemAmount: Int32) -> Void {
  if NotEquals(this.m_weaponIndex, 0) {
    return ;
  };

  wrappedMethod(ingredient, itemAmount);
}
