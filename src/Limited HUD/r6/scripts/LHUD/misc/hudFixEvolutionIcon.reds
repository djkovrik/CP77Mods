import LimitedHudConfig.LHUDAddonsConfig

// Swaps misplaced Power and Tech icons for weapon tooltips
@replaceMethod(ItemTooltipEvolutionModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  switch data.itemEvolution {
    case gamedataWeaponEvolution.Power:
      if config.FixEvolutionIcons {
        // "ico_power" replaced with "ico_tech"
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_tech"); 
      } else {
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_power");
      };
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54118");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54117");
      return;
    case gamedataWeaponEvolution.Smart:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_smart");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54119");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54120");
      return;
    case gamedataWeaponEvolution.Tech:
      if config.FixEvolutionIcons {
        // "ico_tech" replaced with "ico_power"
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_power");
      } else {
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_tech");
      };
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54121");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54122");
      return;
    case gamedataWeaponEvolution.Blunt:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_blunt");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#77968");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#77969 ");
      return;
    case gamedataWeaponEvolution.Blade:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_blades");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#77957");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#77960");
      return;
  };
}

@replaceMethod(ItemTooltipController)
protected final func UpdateEvolutionDescription() -> Void {
  let config: ref<LHUDAddonsConfig> = new LHUDAddonsConfig();
  let evolution: gamedataWeaponEvolution;
  evolution = gamedataWeaponEvolution.Invalid;
  if Equals(InventoryItemData.GetEquipmentArea(this.m_data.inventoryItemData), gamedataEquipmentArea.Weapon) {
    evolution = RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_data.inventoryItemData));
  };
  inkWidgetRef.SetVisible(this.m_nonLethalText, Equals(evolution, gamedataWeaponEvolution.Blunt));
  inkWidgetRef.SetVisible(this.m_weaponEvolutionWrapper, NotEquals(evolution, gamedataWeaponEvolution.Invalid));

  switch evolution {
    case gamedataWeaponEvolution.Power:
      if config.FixEvolutionIcons {
        // "ico_power" replaced with "ico_tech"
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_tech"); 
      } else {
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_power");
      };
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54118");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54117");
      return;
    case gamedataWeaponEvolution.Smart:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_smart");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54119");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54120");
      return;
    case gamedataWeaponEvolution.Tech:
      if config.FixEvolutionIcons {
        // "ico_tech" replaced with "ico_power"
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_power");
      } else {
        inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_tech");
      };
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54121");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54122");
      return;
    case gamedataWeaponEvolution.Blunt:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_blunt");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#77968");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#77969 ");
      return;
    case gamedataWeaponEvolution.Blade:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_blades");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#77957");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#77960");
      return;
  };
}
