import LimitedHudConfig.QuestTrackerModuleConfig
import LimitedHudCommon.LHUDEventType
import LimitedHudCommon.LHUDStealthRunnerRefreshed
import LimitedHudCommon.LHUDConfigUpdatedEvent
import LimitedHudCommon.LHUDEvent

@if(ModuleExists("StealthRunner")) 
import StealthRunner.StealthrunnerObjectiveTextUpdatedEvt

@if(ModuleExists("StealthRunner")) 
@addMethod(PlayerPuppet)
protected cb func OnStealthrunnerCompatEvent(evt: ref<StealthrunnerObjectiveTextUpdatedEvt>) -> Bool {
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(new LHUDStealthRunnerRefreshed());
}

@addMethod(QuestTrackerGameController)
protected cb func OnLHUDStealthRunnerRefreshed(evt: ref<LHUDStealthRunnerRefreshed>) -> Void {
  this.ShowForJournalUpdate();
}

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
    this.AnimateAlphaLHUD(this.GetRootWidget(), this.lhudConfig.Opacity, 0.3);
    return ;
  };

  let showForGlobalHotkey: Bool = this.lhud_isGlobalFlagToggled && this.lhudConfig.BindToGlobalHotkey;
  let showForCombat: Bool = this.lhud_isCombatActive && this.lhudConfig.ShowInCombat;
  let showForOutOfCombat: Bool = this.lhud_isOutOfCombatActive && this.lhudConfig.ShowOutOfCombat;
  let showForStealth: Bool = this.lhud_isStealthActive && this.lhudConfig.ShowInStealth;
  let showForVehicle: Bool = this.lhud_isInVehicle && this.lhudConfig.ShowInVehicle;
  let showForAutoDrive: Bool = this.lhud_inAutoDrive && this.lhudConfig.ShowWithAutoDrive;
  let showForScanner: Bool = this.lhud_isScannerActive && this.lhudConfig.ShowWithScanner;
  let showForWeapon: Bool = this.lhud_isWeaponUnsheathed && this.lhudConfig.ShowWithWeapon;
  let showForZoom: Bool = this.lhud_isZoomActive && this.lhudConfig.ShowWithZoom;
  let trackerForced: Bool = this.lhud_isTrackerForced;
  let showForArea: Bool = this.lhud_isInDangerZone && this.lhudConfig.ShowInDangerArea;
  let scannerDetailsVisible: Bool = this.lhud_isScannerDetailsActive;

  let isVisible: Bool = showForGlobalHotkey || showForCombat || showForOutOfCombat || showForStealth || showForVehicle || showForAutoDrive || showForScanner || showForWeapon || showForZoom || trackerForced || showForArea;
  if scannerDetailsVisible { isVisible = false; };
  if NotEquals(this.lhud_isVisibleNow, isVisible) {
    this.lhud_isVisibleNow = isVisible;
    if isVisible {
      this.AnimateAlphaLHUD(this.GetRootWidget(), this.lhudConfig.Opacity, 0.3);
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

@addMethod(QuestTrackerGameController)
protected cb func OnLHUDConfigUpdatedEvent(evt: ref<LHUDConfigUpdatedEvent>) -> Void {
  this.lhudConfig = new QuestTrackerModuleConfig();
}

// -- Temporarily show tracker and then schedule hiding
@addField(QuestTrackerGameController)
private let lhudDelayId: DelayID;

@wrapMethod(QuestTrackerGameController)
protected cb func OnStateChanges(hash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType) -> Bool {
  wrappedMethod(hash, className, notifyOption, changeType);

  let isCurrentQuestUpdated: Bool = Equals(this.m_journalManager.GetTrackedEntry().GetId(), this.m_journalManager.GetEntry(hash).GetId()) && Equals(notifyOption, JournalNotifyOption.Notify);
  let isDirect: Bool = Equals(notifyOption, JournalNotifyOption.Notify) && Equals(changeType, JournalChangeType.Direct);
  if isCurrentQuestUpdated || isDirect {
    this.ShowForJournalUpdate();
  };
}

@addMethod(QuestTrackerGameController)
private func ShowForJournalUpdate() -> Void {
  let callback: ref<LHUDHideQuestTrackerCallback>;
  let delaySystem: ref<DelaySystem>;
  let player: ref<PlayerPuppet>;
  if this.lhudConfig.IsEnabled && this.lhudConfig.DisplayForQuestUpdates {
    player = this.m_player as PlayerPuppet;
    if !IsDefined(player) {
      return ;
    };
    // Show tracker
    player.QueueLHUDEvent(LHUDEventType.QuestTracker, true);
    // Schedule hiding
    delaySystem = GameInstance.GetDelaySystem(player.GetGame());
    delaySystem.CancelCallback(this.lhudDelayId);
    callback = new LHUDHideQuestTrackerCallback();
    callback.player = player;
    this.lhudDelayId = delaySystem.DelayCallback(callback, this.lhudConfig.QuestUpdateDisplayingTime);
  };
}

public class LHUDHideQuestTrackerCallback extends DelayCallback {
  public let player: wref<PlayerPuppet>;
  public func Call() -> Void {
    this.player.QueueLHUDEvent(LHUDEventType.QuestTracker, false);
  }
}
