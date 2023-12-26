import MetroPocketGuide.Config.MetroPocketGuideConfig

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.InjectMetroPocketGuide();
}

@addMethod(healthbarWidgetGameController)
private final func InjectMetroPocketGuide() -> Void {
  let config: ref<MetroPocketGuideConfig> = new MetroPocketGuideConfig();
  let system: ref<inkSystem> = GameInstance.GetInkSystem();
  let slotName: CName = n"metroPocketGuide";
  let root: ref<inkCompoundWidget> = system.GetLayer(n"inkHUDLayer").GetVirtualWindow();
  let slot: ref<inkCompoundWidget> = root.GetWidgetByPathName(slotName) as inkCompoundWidget;
  if !IsDefined(slot) {
    slot = new inkCanvas();
    slot.SetName(slotName);
    slot.SetFitToContent(true);
    slot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        inkEHorizontalAlign.Left,
        inkEVerticalAlign.Top,
        inkEAnchor.TopLeft,
        new Vector2(0.0, 0.0)
      )
    );
    slot.Reparent(root);
  };

  let scale: Float = config.scale;
  slot.SetScale(new Vector2(scale, scale));

  let translationX: Float = Cast<Float>(config.offsetFromLeft);
  let translationY: Float = Cast<Float>(config.offsetFromTop);
  slot.SetTranslation(translationX, translationY);

  let opacity: Float = config.opacity;
  slot.SetOpacity(opacity);

  slot.RemoveAllChildren();

  let spawned: ref<inkWidget> = this.SpawnFromExternal(
    slot, 
    r"base\\gameplay\\gui\\metro_pocket_guide_route.inkwidget", 
    n"Root:MetroPocketGuide.UI.TrackedRouteListController"
  );

  MetroLog(s"Widget spawned: \(IsDefined(spawned))");
}
