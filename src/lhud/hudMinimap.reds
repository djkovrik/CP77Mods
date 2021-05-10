/////////////////////////////////////////////////
// Show minimap when player mounted to vehicle //
/////////////////////////////////////////////////

public class MinimapConfig {
  public static func Opacity() -> Float = 0.75 // You can tweak this in range from 0.0 to 1.0
}

@addField(MinimapContainerController)
public let m_mountedTrackBlackboard: ref<IBlackboard>;

@addField(MinimapContainerController)
public let m_mountedTrackCallback: Uint32;

@addMethod(MinimapContainerController)
public func OnMountedStateChanged(value: Bool) -> Void {
  this.m_rootWidget.SetVisible(value);
}

@addMethod(MinimapContainerController)
public func DetermineCurrentVisibility() -> Void {
  let isMounted: Bool = this.m_mountedTrackBlackboard.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
  this.m_rootWidget.SetVisible(isMounted);
}

@replaceMethod(MinimapContainerController)
protected cb func OnInitialize() -> Bool {
  this.m_rootWidget = this.GetRootWidget();
  let alphaInterpolator: ref<inkAnimTransparency>;
  inkWidgetRef.SetOpacity(this.m_securityAreaVignetteWidget, 0.00);
  this.m_mapDefinition = GetAllBlackboardDefs().UI_Map;
  this.m_mapBlackboard = this.GetBlackboardSystem().Get(this.m_mapDefinition);
  this.m_locationDataCallback = this.m_mapBlackboard.RegisterListenerString(this.m_mapDefinition.currentLocation, this, n"OnLocationUpdated");
  this.m_mountedTrackBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  this.m_mountedTrackCallback = this.m_mountedTrackBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnMountedStateChanged");
  this.OnLocationUpdated(this.m_mapBlackboard.GetString(this.m_mapDefinition.currentLocation));
  this.m_messageCounterController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_messageCounter), r"base\\gameplay\\gui\\widgets\\phone\\message_counter.inkwidget", n"messages") as inkCompoundWidget;
  this.m_rootWidget.SetOpacity(MinimapConfig.Opacity());
  this.DetermineCurrentVisibility();
}

@replaceMethod(MinimapContainerController)
protected cb func OnUnitialize() -> Bool {
  this.m_mapBlackboard.UnregisterListenerString(this.m_mapDefinition.currentLocation, this.m_locationDataCallback);
  this.m_mountedTrackBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_mountedTrackCallback);
}
