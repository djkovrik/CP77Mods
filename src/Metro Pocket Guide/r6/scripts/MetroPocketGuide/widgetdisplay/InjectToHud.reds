import MetroPocketGuide.Config.MetroPocketGuideConfig

@addField(healthbarWidgetGameController)
private let inkSystem: ref<inkSystem>;

@addField(healthbarWidgetGameController)
private let pocketGuideSlotName: CName = n"metroPocketGuideSlot";

@addField(healthbarWidgetGameController)
private let pocketGuideWidgetName: CName = n"metroPocketGuideWidget";

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.inkSystem = GameInstance.GetInkSystem();
  this.InjectMetroPocketGuideSlot();
}

@addMethod(healthbarWidgetGameController)
private final func InjectMetroPocketGuideSlot() -> Void {
  let config: ref<MetroPocketGuideConfig> = new MetroPocketGuideConfig();
  let root: ref<inkCompoundWidget> = this.inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  let slot: ref<inkCompoundWidget> = root.GetWidgetByPathName(this.pocketGuideSlotName) as inkCompoundWidget;
  if !IsDefined(slot) {
    slot = new inkCanvas();
    slot.SetName(this.pocketGuideSlotName);
    slot.SetFitToContent(true);
    let layout: inkWidgetLayout;
    layout.HAlign = inkEHorizontalAlign.Left;
    layout.VAlign = inkEVerticalAlign.Top;
    layout.anchor = inkEAnchor.TopLeft;
    layout.anchorPoint = new Vector2(0.0, 0.0); 
    slot.SetLayout(layout);
    slot.Reparent(root);
  };

  let scale: Float = config.scale;
  slot.SetScale(new Vector2(scale, scale));

  let translationX: Float = Cast<Float>(config.offsetFromLeft);
  let translationY: Float = Cast<Float>(config.offsetFromTop);
  slot.SetTranslation(translationX, translationY);

  let opacity: Float = config.opacity;
  slot.SetOpacity(opacity);
}

@addMethod(healthbarWidgetGameController)
protected cb func OnInjectPocketGuideToHudEvent(evt: ref<InjectPocketGuideToHudEvent>) -> Bool {
  let root: ref<inkCompoundWidget> = this.inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  let slot: ref<inkCompoundWidget> = root.GetWidgetByPathName(this.pocketGuideSlotName) as inkCompoundWidget;
  
  slot.RemoveAllChildren();

  let spawned: ref<inkWidget> = this.SpawnFromExternal(
    slot, 
    r"base\\gameplay\\gui\\metro_pocket_guide_route.inkwidget", 
    n"Root:MetroPocketGuide.UI.TrackedRouteListController"
  );

  spawned.SetName(this.pocketGuideWidgetName);

  MetroLog(s"Widget added to HUD: \(IsDefined(spawned)) - \(spawned.GetName())");
}

@addMethod(healthbarWidgetGameController)
protected cb func OnRemovePocketGuideFromHudEvent(evt: ref<RemovePocketGuideFromHudEvent>) -> Bool {
  let root: ref<inkCompoundWidget> = this.inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  let slot: ref<inkCompoundWidget> = root.GetWidgetByPathName(this.pocketGuideSlotName) as inkCompoundWidget;
  slot.RemoveChildByName(this.pocketGuideWidgetName);
  MetroLog("Widget removed from HUD");
}
