import ImprovedMinimapMain.ZoomConfig

@addField(JournalNotificationQueue)
public let m_UIBlackboard_Compat: wref<IBlackboard>;

public class RefreshZoomConfigsEvent extends Event {}

@wrapMethod(PauseMenuBackgroundGameController)
protected cb func OnUninitialize() -> Bool {
  GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(new RefreshZoomConfigsEvent());
  wrappedMethod();
}
