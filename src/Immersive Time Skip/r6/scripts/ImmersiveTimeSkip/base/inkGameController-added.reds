import ImmersiveTimeSkip.Utils.ITSUtils
import ImmersiveTimeSkip.Events.*

@addMethod(inkGameController)
protected cb func ShowTimeSkipPopup() -> Void {
  let player: ref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  let evt: ref<TimeSkipMenuVisibilityEvent> = new TimeSkipMenuVisibilityEvent();
  evt.visible = true;
  GameInstance.GetUISystem(player.GetGame()).QueueEvent(evt);
  let data: ref<TimeSkipPopupData> = new TimeSkipPopupData();
  data.notificationName = n"base\\gameplay\\gui\\widgets\\time_skip\\time_skip.inkwidget";
  data.isBlocking = true;
  data.useCursor = true;
  data.queueName = n"modal_popup";
  player.itsTimeSkipActive = true;
  player.itsTimeSkipPopupToken = this.ShowGameNotification(data);
  this.PlaySound(n"Button", n"OnPress");
}

@addMethod(inkGameController)
public func ShowTimeSkipNotAvailableNotification() -> Void {
  let notification: ref<UIInGameNotificationEvent> = new UIInGameNotificationEvent();
  notification.m_notificationType = UIInGameNotificationType.CombatRestriction;
  GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(notification);
}

@addMethod(inkGameController)
protected cb func OnOpenTimeSkipMenuEvent(evt: ref<OpenTimeSkipMenuEvent>) -> Bool {
  let player: ref<PlayerPuppet>;
  if this.IsA(n"gameuiRootHudGameController") {
    player = this.GetPlayerControlledObject() as PlayerPuppet;
    if ITSUtils.IsTimeskipAvailable(player) {
      this.ShowTimeSkipPopup();
    } else {
      this.ShowTimeSkipNotAvailableNotification();
    };
  };
}

// Hides base HUD widgets on custom timeskip popup appearance
@addMethod(inkGameController)
protected cb func OnTimeSkipMenuVisibilityEvent(evt: ref<TimeSkipMenuVisibilityEvent>) -> Bool {
  let hideableWidgets: array<CName> = [
    n"HotkeysWidgetController",
    n"CrouchIndicatorGameController",
    n"gameuiInputHintManagerGameController",
    n"gameuiMinimapContainerController",
    n"healthbarWidgetGameController",
    n"QuestTrackerGameController",
    n"weaponRosterGameController"
  ];

  if ArrayContains(hideableWidgets, this.GetClassName()) {
    if evt.visible {
      this.itsDefaultOpacity = this.GetRootCompoundWidget().GetOpacity();
      ITSUtils.AnimateAlpha(this.GetRootCompoundWidget(), 0.0, 0.3);
    } else {
      if this.itsDefaultOpacity != 0.0 {
        ITSUtils.AnimateAlpha(this.GetRootCompoundWidget(), this.itsDefaultOpacity, 0.3);
      };
    };
  };
}
