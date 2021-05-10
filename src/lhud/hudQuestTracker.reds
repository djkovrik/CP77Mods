////////////////////////////////////////////////////////////////////////////
// Show quest tracker when scanner is active or player mounted to vehicle //
////////////////////////////////////////////////////////////////////////////

@addField(QuestTrackerGameController)
public let m_scannerTrackingBlackboard: ref<IBlackboard>;

@addField(QuestTrackerGameController)
public let m_mountedTrackBlackboard: ref<IBlackboard>;

@addField(QuestTrackerGameController)
public let m_scannerTrackingCallback: Uint32;

@addField(QuestTrackerGameController)
public let m_mountedTrackCallback: Uint32;

@addMethod(QuestTrackerGameController)
public func ShowWidget(show: Bool) -> Void {
  if show {
    this.GetRootWidget().SetOpacity(1.0);
  } else {
    this.GetRootWidget().SetOpacity(0.0);
  };
}

@addMethod(QuestTrackerGameController)
public func OnVisibilityConditionsChanged(value: Bool) -> Void {
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
public func DetermineCurrentVisibility() -> Void {
  let isMounted: Bool = this.m_mountedTrackBlackboard.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  let isScannerEnabled: Bool = this.m_scannerTrackingBlackboard.GetBool(GetAllBlackboardDefs().UI_Scanner.UIVisible);
  let shouldShow: Bool = isMounted || isScannerEnabled;
  this.ShowWidget(shouldShow);
}

@replaceMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  this.m_root = this.GetRootWidget();
  this.m_player = this.GetPlayerControlledObject();
  let gameInstance: GameInstance = this.m_player.GetGame();
  this.m_player.RegisterInputListener(this, n"VisionPush");
  this.m_player.RegisterInputListener(this, n"UI_DPadDown");
  this.m_journalManager = GameInstance.GetJournalManager(this.m_player.GetGame());
  inkCompoundRef.RemoveAllChildren(this.m_ObjectiveContainer);
  this.UpdateTrackerData();
  this.m_journalManager.RegisterScriptCallback(this, n"OnStateChanges", gameJournalListenerType.State);
  this.m_journalManager.RegisterScriptCallback(this, n"OnTrackedEntryChanges", gameJournalListenerType.Tracked);
  this.m_journalManager.RegisterScriptCallback(this, n"OnCounterChanged", gameJournalListenerType.Counter);
  this.blackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
  this.uiSystemBB = GetAllBlackboardDefs().UI_System;
  this.uiSystemId = this.blackboard.RegisterListenerBool(this.uiSystemBB.IsInMenu, this, n"OnMenuUpdate");
  this.trackedMappinId = this.blackboard.RegisterListenerVariant(this.uiSystemBB.TrackedMappin, this, n"OnTrackedMappinUpdated");
  this.blackboard.SignalBool(this.uiSystemBB.IsInMenu);
  this.blackboard.SignalVariant(this.uiSystemBB.TrackedMappin);
  this.m_scannerTrackingBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
  this.m_mountedTrackBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  this.m_scannerTrackingCallback = this.m_scannerTrackingBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this, n"OnVisibilityConditionsChanged");
  this.m_mountedTrackCallback = this.m_mountedTrackBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnVisibilityConditionsChanged");
  this.DetermineCurrentVisibility();
}

@addMethod(QuestTrackerGameController)
protected cb func OnUnitialize() -> Bool {
  this.m_scannerTrackingBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_Scanner.UIVisible, this.m_scannerTrackingCallback);
  this.m_mountedTrackBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_mountedTrackCallback);
}
