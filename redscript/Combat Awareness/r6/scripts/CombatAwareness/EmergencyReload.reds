module CombatAwareness

@addField(ReloadEvents)
private let caFastReload: Bool;

@addField(ReloadEvents)
private let caReloadStat: gamedataStatType;

@wrapMethod(NoAmmoDecisions)
protected final const func ToReload(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let wrapped: Bool = wrappedMethod(stateContext, scriptInterface);
  if wrapped && scriptInterface.IsActionJustPressed(n"RangedAttack") {
    let last = stateContext.GetPermanentIntParameter(this.GetLastChargePressCount());
    if !last.valid || last.value != Cast<Int32>(scriptInterface.GetActionPressCount(n"RangedAttack")) {
      stateContext.SetTemporaryBoolParameter(this.IsRightWeaponLogic() ? n"CADryRight" : n"CADryLeft", true, true);
    };
  };

  return wrapped;
}

@addMethod(ReloadEvents)
private final func CASetReloadDuration(value: Float) -> Void {
  if Equals(this.caReloadStat, gamedataStatType.EmptyReloadTime) {
    this.m_animReloadData.emptyDuration = value;
    this.m_animReloadSpeed.emptyReloadSpeed = this.GetReloadAnimSpeed(this.caReloadStat, this.m_weaponRecord);
  } else {
    this.m_animReloadData.loopDuration = value;
    this.m_animReloadSpeed.reloadSpeed = this.GetReloadAnimSpeed(this.caReloadStat, this.m_weaponRecord);
  };

  this.m_animReloadDataDirty = true;
  this.m_animReloadSpeedDirty = true;
}

@addMethod(ReloadEvents)
private final func CAEndFastReload(si: ref<StateGameScriptInterface>) -> Void {
  if !this.caFastReload { 
    return; 
  }

  this.caFastReload = false;
  this.CASetReloadDuration(si.GetStatsSystem().GetStatValue(Cast<StatsObjectID>(si.ownerEntityID), this.caReloadStat));
}

@wrapMethod(ReloadEvents)
public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, value: Float) -> Void {
  if this.caFastReload && Equals(statType, this.caReloadStat) { 
    value /= Training.EmergencyReloadRate(); 
  };

  wrappedMethod(ownerID, statType, diff, value);
}

// restore vanilla duration (todo: test)
@wrapMethod(ReloadEvents)
private final func OnExitCleanup(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.CAEndFastReload(scriptInterface);
}

@wrapMethod(ReloadEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let system = AwarenessSystem.Get(scriptInterface.GetGame());
  this.CAEndFastReload(scriptInterface);
  let press = stateContext.GetTemporaryBoolParameter(this.IsRightWeaponLogic() ? n"CADryRight" : n"CADryLeft");
  if press.valid && press.value && system.Ready(5) {
    let weapon = this.GetWeaponObject(scriptInterface);
    let duration = this.m_weaponHasAutoLoader ? this.m_animReloadData.loopDuration : this.m_animReloadData.emptyDuration;
    if duration > 0.0 && weapon.IsMagazineEmpty() && WeaponObject.HasAvailableAmmoInInventory(weapon) {
      this.caReloadStat = this.m_weaponHasAutoLoader ? gamedataStatType.ReloadTime : gamedataStatType.EmptyReloadTime;
      this.caFastReload = true;
      this.CASetReloadDuration(duration / Training.EmergencyReloadRate());
    };
  };

  wrappedMethod(stateContext, scriptInterface);

  if this.caFastReload { 
    system.Spend(5); 
  };
}
