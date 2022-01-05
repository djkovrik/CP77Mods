// Swaps misplaced Power and Tech icons for weapon tooltips
@replaceMethod(ItemTooltipEvolutionModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
  switch data.itemEvolution {
    case gamedataWeaponEvolution.Power:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_tech");    // "ico_power" replaced with "ico_tech"
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54118");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54117");
      return;
    case gamedataWeaponEvolution.Smart:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_smart");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54119");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54120");
      return;
    case gamedataWeaponEvolution.Tech:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_power");   // "ico_tech" replaced with "ico_power"
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
  let evolution: gamedataWeaponEvolution;
  evolution = gamedataWeaponEvolution.Invalid;
  if Equals(InventoryItemData.GetEquipmentArea(this.m_data.inventoryItemData), gamedataEquipmentArea.Weapon) {
    evolution = RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_data.inventoryItemData));
  };
  inkWidgetRef.SetVisible(this.m_nonLethalText, Equals(evolution, gamedataWeaponEvolution.Blunt));
  inkWidgetRef.SetVisible(this.m_weaponEvolutionWrapper, NotEquals(evolution, gamedataWeaponEvolution.Invalid));

  switch evolution {
    case gamedataWeaponEvolution.Power:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_tech");    // "ico_power" replaced with "ico_tech"
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54118");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54117");
      return;
    case gamedataWeaponEvolution.Smart:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_smart");
      inkTextRef.SetText(this.m_weaponEvolutionName, "LocKey#54119");
      inkTextRef.SetText(this.m_weaponEvolutionDescription, "LocKey#54120");
      return;
    case gamedataWeaponEvolution.Tech:
      inkImageRef.SetTexturePart(this.m_weaponEvolutionIcon, n"ico_power");   // "ico_tech" replaced with "ico_power"
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
