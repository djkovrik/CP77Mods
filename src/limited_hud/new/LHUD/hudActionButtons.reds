import LimitedHudConfig.ActionButtonsModuleConfig
import LimitedHudCommon.LHUDEvent
import LimitedHudCommon.LHUDLog

@addMethod(HotkeysWidgetController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(HotkeysWidgetController)
public func DetermineCurrentVisibility() -> Void {
  if !ActionButtonsModuleConfig.IsEnabled() {
    return ;
  };

  if this.lhud_isBraindanceActive {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetVisible(false);
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && ActionButtonsModuleConfig.BindToGlobalHotkey();
  let showForCombat: Bool = this.lhud_isCombatActive && ActionButtonsModuleConfig.ShowInCombat();
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && ActionButtonsModuleConfig.ShowOutOfCombat();
  let showForStealth: Bool =  this.lhud_isStealthActive && ActionButtonsModuleConfig.ShowInStealth();
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && ActionButtonsModuleConfig.ShowWithWeapon();
  let showForZoom: Bool =  this.lhud_isZoomActive && ActionButtonsModuleConfig.ShowWithZoom();

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom;
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.AnimateAlpha(this.GetRootWidget(), 1.0, 0.5);
    } else {
      this.AnimateAlpha(this.GetRootWidget(), 0.0, 0.5);
    };
  };
}

@wrapMethod(HotkeysWidgetController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  if ActionButtonsModuleConfig.IsEnabled() {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipmentSystemWeaponManipulationRequest(request: ref<EquipmentSystemWeaponManipulationRequest>) -> Void {
  let targetItem: ItemID = this.GetItemIDfromEquipmentManipulationAction(request.requestType);
  let isTargetRequestUnequip: Bool = this.IsEquipmentManipulationAnUnequipRequest(request.requestType);
  let equipmentDataDef: ref<UI_EquipmentDataDef> = GetAllBlackboardDefs().UI_EquipmentData;
  if !isTargetRequestUnequip {
    GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, true);
  } else {
    if ItemID.IsValid(targetItem) {
      GameInstance.GetBlackboardSystem(this.m_owner.GetGame()).Get(equipmentDataDef).SetBool(equipmentDataDef.HasWeaponEquipped, false);
    };
  };

  wrappedMethod(request);
}
