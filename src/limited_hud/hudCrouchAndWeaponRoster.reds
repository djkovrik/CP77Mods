/////////////////////////////////////////////////////////////////////
// Show weapon roster and crouch indicator when weapon unsheathed  //
/////////////////////////////////////////////////////////////////////

import LimitedHudCommon.*

// ---------- CrouchIndicatorGameController

@addMethod(CrouchIndicatorGameController)
public func ShowWidget(show: Bool) -> Void {
  if show {
    this.GetRootWidget().SetOpacity(1.0);
  } else {
    this.GetRootWidget().SetOpacity(0.0);
  };
}

@addMethod(CrouchIndicatorGameController)
public func OnFoldFinished(proxy: ref<inkAnimProxy>) -> Bool {
  this.ShowWidget(false);
}

@addMethod(CrouchIndicatorGameController)
public func OnUnfoldStarted(proxy: ref<inkAnimProxy>) -> Bool {
  this.ShowWidget(true);
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnInitialize() -> Bool {
  // this.PlayInitFoldingAnim();
  inkWidgetRef.SetVisible(this.m_warningMessageWraper, false);
  this.m_damageTypeIndicator = inkWidgetRef.GetController(this.m_damageTypeRef) as DamageTypeIndicator;
  this.m_bbDefinition = GetAllBlackboardDefs().UIInteractions;
  this.m_blackboard = this.GetBlackboardSystem().Get(this.m_bbDefinition);
  this.m_UIBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);
  this.m_hackingBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Hacking);
  this.m_weaponBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveWeaponData);
  inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
  inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_Player = playerPuppet as PlayerPuppet;
  this.m_InventoryManager = new InventoryDataManagerV2();
  this.m_InventoryManager.Initialize(this.m_Player);
  this.m_genderName = this.m_Player.GetResolvedGenderName();
  this.m_WeaponAreas = InventoryDataManagerV2.GetInventoryWeaponTypes();
  this.RegisterBB();
  this.ShowWidget(this.m_Player.HasAnyWeaponEquipped_LHUD());
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_ActiveWeapon.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
        this.PlayUnfold();
      };
      break;
    case gamePSMVision.Focus:
      this.PlayFold();
  };
}

@replaceMethod(CrouchIndicatorGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  this.m_BufferedRosterData = FromVariant(value);
  let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
  let item: ref<gameItemData>;
  let weaponItemType: gamedataItemType;
  if ItemID.IsValid(currentData.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
    if this.m_ActiveWeapon.weaponID != currentData.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
    };
    this.m_ActiveWeapon = currentData;
    weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
    this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
    this.PlayUnfold();
    if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
    };
  } else {
    this.PlayFold();
  };
}

@replaceMethod(CrouchIndicatorGameController)
private final func PlayFold() -> Void {
  if this.m_folded {
    return ;
  };
  this.m_folded = true;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"fold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnFoldFinished");
}

@replaceMethod(CrouchIndicatorGameController)
private final func PlayUnfold() -> Void {
  if !this.m_folded || !this.m_Player.HasAnyWeaponEquipped_LHUD() {
    return ;
  };
  this.m_folded = false;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"unfold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnUnfoldStarted");
}


// ---------- weaponRosterGameController

@addMethod(weaponRosterGameController)
public func ShowWidget(show: Bool) -> Void {
  inkImageRef.SetVisible(this.m_container, show);
}

@addMethod(weaponRosterGameController)
public func OnFoldFinished(proxy: ref<inkAnimProxy>) -> Bool {
  this.ShowWidget(false);
}

@addMethod(weaponRosterGameController)
public func OnUnfoldStarted(proxy: ref<inkAnimProxy>) -> Bool {
  this.ShowWidget(true);
}

@replaceMethod(weaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  // this.PlayInitFoldingAnim();
  inkWidgetRef.SetVisible(this.m_warningMessageWraper, false);
  this.m_damageTypeIndicator = inkWidgetRef.GetController(this.m_damageTypeRef) as DamageTypeIndicator;
  this.m_bbDefinition = GetAllBlackboardDefs().UIInteractions;
  this.m_blackboard = this.GetBlackboardSystem().Get(this.m_bbDefinition);
  this.m_UIBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_EquipmentData);
  this.m_hackingBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Hacking);
  this.m_weaponBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveWeaponData);
  inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
  inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
}

@replaceMethod(weaponRosterGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  this.m_Player = playerPuppet as PlayerPuppet;
  this.m_InventoryManager = new InventoryDataManagerV2();
  this.m_InventoryManager.Initialize(this.m_Player);
  this.m_genderName = this.m_Player.GetResolvedGenderName();
  this.m_WeaponAreas = InventoryDataManagerV2.GetInventoryWeaponTypes();
  this.RegisterBB();
  this.ShowWidget(this.m_Player.HasAnyWeaponEquipped_LHUD());
}


@replaceMethod(weaponRosterGameController)
protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
  let newState: gamePSMVision = IntEnum(value);
  switch newState {
    case gamePSMVision.Default:
      if ItemID.IsValid(this.m_ActiveWeapon.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
        this.PlayUnfold();
      };
      break;
    case gamePSMVision.Focus:
      this.PlayFold();
  };
}

@replaceMethod(weaponRosterGameController)
protected cb func OnWeaponDataChanged(value: Variant) -> Bool {
  this.m_BufferedRosterData = FromVariant(value);
  let currentData: SlotWeaponData = this.m_BufferedRosterData.weapon;
  let item: ref<gameItemData>;
  let weaponItemType: gamedataItemType;
  if ItemID.IsValid(currentData.weaponID) && this.m_Player.HasAnyWeaponEquipped_LHUD() {
    if this.m_ActiveWeapon.weaponID != currentData.weaponID {
      item = this.m_InventoryManager.GetPlayerItemData(currentData.weaponID);
      this.m_weaponItemData = this.m_InventoryManager.GetInventoryItemData(item);
    };
    this.m_ActiveWeapon = currentData;
    weaponItemType = InventoryItemData.GetItemType(this.m_weaponItemData);
    this.SetRosterSlotData(Equals(weaponItemType, gamedataItemType.Wea_Melee) || Equals(weaponItemType, gamedataItemType.Wea_Fists) || Equals(weaponItemType, gamedataItemType.Wea_Hammer) || Equals(weaponItemType, gamedataItemType.Wea_Katana) || Equals(weaponItemType, gamedataItemType.Wea_Knife) || Equals(weaponItemType, gamedataItemType.Wea_OneHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_ShortBlade) || Equals(weaponItemType, gamedataItemType.Wea_TwoHandedClub) || Equals(weaponItemType, gamedataItemType.Wea_LongBlade));
    this.PlayUnfold();
    if NotEquals(RPGManager.GetWeaponEvolution(InventoryItemData.GetID(this.m_weaponItemData)), gamedataWeaponEvolution.Smart) {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
    };
  } else {
    this.PlayFold();
  };
}

@replaceMethod(weaponRosterGameController)
private final func PlayFold() -> Void {
  if this.m_folded {
    return ;
  };
  this.m_folded = true;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"fold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnFoldFinished");
}

@replaceMethod(weaponRosterGameController)
private final func PlayUnfold() -> Void {
  if !this.m_folded || !this.m_Player.HasAnyWeaponEquipped_LHUD() {
    return ;
  };
  this.m_folded = false;
  if IsDefined(this.m_transitionAnimProxy) {
    this.m_transitionAnimProxy.Stop();
    this.m_transitionAnimProxy = null;
  };
  this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"unfold");
  this.m_transitionAnimProxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnUnfoldStarted");
}
