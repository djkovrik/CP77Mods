// import LimitedHudConfig.CrouchIndicatorModuleConfig
// import LimitedHudCommon.LHUDEvent

// @addMethod(CrouchIndicatorGameController)
// protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
//   this.ConsumeEvent(evt);
//   this.DetermineCurrentVisibility();
// }

// @addMethod(CrouchIndicatorGameController)
// public func DetermineCurrentVisibility() -> Void {
//   if !CrouchIndicatorModuleConfig.IsEnabled() {
//     return ;
//   };

//   if this.lhud_isBraindanceActive {
//     this.lhud_isVisibleNow = false;
//     this.GetRootWidget().SetVisible(false);
//     return ;
//   };

//   let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && CrouchIndicatorModuleConfig.BindToGlobalHotkey();
//   let showForCombat: Bool = this.lhud_isCombatActive && CrouchIndicatorModuleConfig.ShowInCombat();
//   let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && CrouchIndicatorModuleConfig.ShowOutOfCombat();
//   let showForStealth: Bool =  this.lhud_isStealthActive && CrouchIndicatorModuleConfig.ShowInStealth();
//   let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && CrouchIndicatorModuleConfig.ShowWithWeapon();
//   let showForZoom: Bool =  this.lhud_isZoomActive && CrouchIndicatorModuleConfig.ShowWithZoom();

//   let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForWeapon || showForZoom;
//   if NotEquals(this.lhud_isVisibleNow, isVisible) {
//     if isVisible {
//       this.GetRootWidget().SetOpacity(1.0);
//     } else {
//       this.GetRootWidget().SetOpacity(0.0);
//     };
//   };
// }

// @wrapMethod(CrouchIndicatorGameController)
// protected cb func OnInitialize() -> Bool {
//   wrappedMethod();
//   if CrouchIndicatorModuleConfig.IsEnabled() {
//     this.lhud_isVisibleNow = false;
//     this.GetRootWidget().SetOpacity(0.0);
//     this.DetermineCurrentVisibility();
//   };
// }

// @replaceMethod(CrouchIndicatorGameController)
// protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
//   if CrouchIndicatorModuleConfig.IsEnabled() {
//     return false;
//   };

//   let newState: gamePSMVision = IntEnum(value);
//   switch newState {
//     case gamePSMVision.Default:
//       if ItemID.IsValid(this.m_ActiveWeapon.weaponID) {
//         this.PlayUnfold();
//       };
//       break;
//     case gamePSMVision.Focus:
//       this.PlayFold();
//   };
// }

// @replaceMethod(CrouchIndicatorGameController)
// protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
//   if CrouchIndicatorModuleConfig.IsEnabled() {
//     return false;
//   };

//   let item: ref<gameItemData>;
//   let weaponItemType: gamedataItemType;
//   this.m_BufferedRosterData = FromVariant(value);
//   let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
//   if ItemID.IsValid(currentData.weaponID) {
//     if this.m_ActiveWeapon.weaponID != currentData.weaponID {
//       item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
//       this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
//     };
//     this.m_ActiveWeapon = currentData;
//     weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
//     this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
//     this.PlayUnfold();
//     if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
//       inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
//       inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
//     };
//   } else {
//     this.PlayFold();
//   };
// }