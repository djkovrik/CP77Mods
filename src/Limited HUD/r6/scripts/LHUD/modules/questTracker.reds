import LimitedHudConfig.QuestTrackerModuleConfig
import LimitedHudCommon.LHUDEventType
import LimitedHudCommon.LHUDEvent

@addMethod(QuestTrackerGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  this.ConsumeLHUDEvent(evt);
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func DetermineCurrentVisibility() -> Void {
  if !this.lhudConfig.IsEnabled {
    return ;
  };

  if this.lhud_isBraindanceActive {
    this.lhud_isVisibleNow = true;
    this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool =  this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForVehicle: Bool =  this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
  let showForScanner: Bool =  this.lhud_isScannerActive && this.lhudConfig.ShowWithScanner;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool =  this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForScanner || showForWeapon || showForZoom;
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
    } else {
      this.AnimateAlphaLHUD(this.GetRootWidget(), 0.0, 0.3);
    };
  };
}

@addField(QuestTrackerGameController)
private let lhudConfig: ref<QuestTrackerModuleConfig>;

@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.lhudConfig = new QuestTrackerModuleConfig();
  if this.lhudConfig.IsEnabled {
    this.lhud_isVisibleNow = false;
    this.GetRootWidget().SetOpacity(0.0);
    this.OnInitializeFinished();
  };
}

// -- Temporarily show tracker and then schedule hiding
@wrapMethod(QuestTrackerGameController)
protected cb func OnTrackedEntryChanges(hash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType) -> Bool {
  wrappedMethod(hash, className, notifyOption, changeType);

  let callback: ref<LHUDHideQuestTrackerCallback>;
  if this.lhudConfig.IsEnabled && this.lhudConfig.DisplayForQuestUpdates {
    // Show tracker
    this.lhud_isVisibleNow = true;
    this.AnimateAlphaLHUD(this.GetRootWidget(), 1.0, 0.3);
    // Schedule hiding
    callback = new LHUDHideQuestTrackerCallback();
    callback.uiSystem = GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame());
    GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame()).DelayCallback(callback, this.lhudConfig.QuestUpdateDisplayingTime);
  };
}

public class LHUDHideQuestTrackerCallback extends DelayCallback {
  public let uiSystem: wref<UISystem>;
  public func Call() -> Void {
    let evt: ref<LHUDEvent> = new LHUDEvent();
    evt.type = LHUDEventType.Refresh;
    evt.isActive = false;
    this.uiSystem.QueueEvent(evt);
  }
}
