module EnhancedCraft.Damage
import EnhancedCraft.Config.ECraftConfig
import EnhancedCraft.Events.*

// -- Setup click listener
@addMethod(ItemTooltipRecipeDataModule)
protected cb func OnInitialize() -> Bool {
  let config: ref<ECraftConfig> = new ECraftConfig();
  this.m_settingsDamageEnabled = config.customizedDamageEnabled;
  if this.m_settingsDamageEnabled {
    this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnPanelItemClicked");
  };
}

// -- Remove click listener
@addMethod(ItemTooltipRecipeDataModule)
protected cb func OnUninitialize() -> Bool {
  if this.m_settingsDamageEnabled {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnPanelItemClicked");
  };
}

// -- Handle damage type item click
@addMethod(ItemTooltipRecipeDataModule)
protected cb func OnPanelItemClicked(e: ref<inkPointerEvent>) -> Bool {
  let evt: ref<EnhancedCraftDamageTypeClicked>;
  let target: ref<ItemTooltipStatController>;
  let targetName: CName;
  if this.m_shouldDisplayHud && e.IsAction(n"click") {
    targetName = e.GetTarget().GetName();
    target = e.GetTarget().GetController() as ItemTooltipStatController;
    if IsDefined(target) {
      this.PlaySound(n"Button", n"OnPress");
      this.m_selectedDamageType = target.m_damageType;
      evt = new EnhancedCraftDamageTypeClicked();
      evt.damageType = target.m_damageType;
      this.QueueEvent(evt);
      this.RefreshDamageTypeItemsState();
    };
  };
}


// -- Setup new HUD
@wrapMethod(ItemTooltipRecipeDataModule)
private final func UpdatemRecipeDamageTypes(data: ref<MinimalItemTooltipData>) -> Void {
  wrappedMethod(data);
  
  // Inject HUD only when all four damage types are visible and feature available
  this.m_shouldDisplayHud = this.m_damageSelectionAvailable && Equals(ArraySize(data.recipeData.damageTypes), 4);
  this.SetInitialSelection();
  if this.m_shouldDisplayHud {
    this.InitializeAdditionalHUD(data);
    this.RefreshDamageTypeItemsState();
  };
}

// -- Capture title and damage types references
@addMethod(ItemTooltipRecipeDataModule)
private func InitializeAdditionalHUD(data: ref<MinimalItemTooltipData>) -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  this.m_damagesTitle = root.GetWidget(n"recipeDamageContainer/title") as inkText;
  this.m_damagesTitle.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  this.m_damagesTitle.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
  this.m_damagesTitle.SetText(GetLocalizedTextByKey(n"Mod-Craft-UI-Select-Title"));
  let damagesTypesSize: Int32 = ArraySize(data.recipeData.damageTypes);
  let stat: InventoryTooltipData_StatData;
  let controller: ref<ItemTooltipStatController>;
  let i: Int32 = 0;
  inkWidgetRef.SetInteractive(this.m_damageTypesContainer, true);
  while i < damagesTypesSize {
    stat = data.recipeData.damageTypes[i];
    controller = inkCompoundRef.GetWidgetByIndex(this.m_damageTypesContainer, i).GetController() as ItemTooltipStatController;
    controller.GetRootCompoundWidget().SetInteractive(true);
    switch stat.statType {
      case gamedataStatType.ChemicalDamage:
        this.m_chemicalDamageItem = controller;
        this.m_chemicalDamageItem.m_damageType = gamedataStatType.ChemicalDamage;
        break;
      case gamedataStatType.ElectricDamage:
        this.m_electricalDamageItem = controller;
        this.m_electricalDamageItem.m_damageType = gamedataStatType.ElectricDamage;
        break;
      case gamedataStatType.PhysicalDamage:
        this.m_physicalDamageItem = controller;
        this.m_physicalDamageItem.m_damageType = gamedataStatType.PhysicalDamage;
        break;
      case gamedataStatType.ThermalDamage:
        this.m_thermalDamageItem = controller;
        this.m_thermalDamageItem.m_damageType = gamedataStatType.ThermalDamage;
        break;
    };
    i += 1;
  };
}

// -- Setup initial selection state after recipe preview load
@addMethod(ItemTooltipRecipeDataModule)
private func SetInitialSelection() -> Void {
  let evt: ref<EnhancedCraftDamageTypeClicked>;  
  evt = new EnhancedCraftDamageTypeClicked();
  if this.m_shouldDisplayHud {
    this.m_selectedDamageType = gamedataStatType.ChemicalDamage;
  } else {
    this.m_selectedDamageType = gamedataStatType.Invalid;
  };
  evt.damageType = this.m_selectedDamageType;
  // Fire initial damage type event
  this.QueueEvent(evt);
}

// -- Handles damage type items highlight
@addMethod(ItemTooltipStatController)
public func HighlightItem(highlight: Bool) -> Void {
  let name: ref<inkText> = inkWidgetRef.Get(this.m_statName) as inkText;
  let value: ref<inkText> = inkWidgetRef.Get(this.m_statValue) as inkText;
  name.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  name.UnbindProperty(n"tintColor");
  value.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
  value.UnbindProperty(n"tintColor");

  if highlight {
    value.SetOpacity(1.0);
    value.SetFontSize(38);
    value.BindProperty(n"tintColor", n"MainColors.Red");

    name.SetOpacity(1.0);
    name.SetFontSize(38);
    name.BindProperty(n"tintColor", n"MainColors.Red");
  } else {
    value.SetOpacity(0.4);
    value.SetFontSize(36);
    value.BindProperty(n"tintColor", n"MainColors.Blue");

    name.SetOpacity(0.4);
    name.SetFontSize(36);
    name.BindProperty(n"tintColor", n"MainColors.Blue");
  };
}

// -- Refresh selected items state after loading and on click
@addMethod(ItemTooltipRecipeDataModule)
private func RefreshDamageTypeItemsState() -> Void {
  this.m_chemicalDamageItem.HighlightItem(false);
  this.m_electricalDamageItem.HighlightItem(false);
  this.m_physicalDamageItem.HighlightItem(false);
  this.m_thermalDamageItem.HighlightItem(false);

  switch this.m_selectedDamageType {
      case gamedataStatType.ChemicalDamage:
        this.m_chemicalDamageItem.HighlightItem(true);
        break;
      case gamedataStatType.ElectricDamage:
        this.m_electricalDamageItem.HighlightItem(true);
        break;
      case gamedataStatType.PhysicalDamage:
        this.m_physicalDamageItem.HighlightItem(true);
        break;
      case gamedataStatType.ThermalDamage:
        this.m_thermalDamageItem.HighlightItem(true);
        break;
  };
}
