// Called when gameplay actually starts & widgets are loaded
@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.QueueEvent(new HijackSlotsEvent());
  this.QueueEvent(new GameSessionInitializedEvent());
}

@addField(inkGameController) let minimapSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let questTrackerSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let staminaBarSlot: ref<HUDitorCustomSlot>;
@addField(inkGameController) let vehicleSummonSlot: ref<HUDitorCustomSlot>;

@addMethod(inkGameController)
protected cb func OnGameSessionInitialized(event: ref<GameSessionInitializedEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnGameSessionInitialized(event);
    this.questTrackerSlot.OnGameSessionInitialized(event);
    this.staminaBarSlot.OnGameSessionInitialized(event);
    this.vehicleSummonSlot.OnGameSessionInitialized(event);
  }
}

@addMethod(inkGameController)
protected cb func OnEnableHUDEditorWidget(event: ref<SetActiveHUDEditorWidget>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnEnableHUDEditorWidget(event);
    this.questTrackerSlot.OnEnableHUDEditorWidget(event);
    this.staminaBarSlot.OnEnableHUDEditorWidget(event);
    this.vehicleSummonSlot.OnEnableHUDEditorWidget(event);
  }
}

@addMethod(inkGameController)
protected cb func OnDisableHUDEditorWidgets(event: ref<DisableHUDEditor>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnDisableHUDEditorWidgets(event);
    this.questTrackerSlot.OnDisableHUDEditorWidgets(event);
    this.staminaBarSlot.OnDisableHUDEditorWidgets(event);
    this.vehicleSummonSlot.OnDisableHUDEditorWidgets(event);
  }
}

@addMethod(inkGameController)
protected cb func OnResetHUDWidgets(event: ref<ResetAllHUDWidgets>) {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnResetHUDWidgets(event);
    this.questTrackerSlot.OnResetHUDWidgets(event);
    this.staminaBarSlot.OnResetHUDWidgets(event);
    this.vehicleSummonSlot.OnResetHUDWidgets(event);
  }
}

@addMethod(inkGameController)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.minimapSlot.OnAction(action, consumer);
    this.questTrackerSlot.OnAction(action, consumer);
    this.staminaBarSlot.OnAction(action, consumer);
    this.vehicleSummonSlot.OnAction(action, consumer);
  }
}

@addMethod(inkGameController)
protected cb func OnHijackSlotsEvent(evt: ref<HijackSlotsEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let topRightMainSlot: ref<inkCompoundWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain")) as inkCompoundWidget;
    let topRightSlot: ref<inkCompoundWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight")) as inkCompoundWidget;
    let bottomCenterSlot: ref<inkCompoundWidget>  = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomCenter")) as inkCompoundWidget;
    let bottomLeftSlot: ref<inkCompoundWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomLeftTop")) as inkCompoundWidget;
    let topCenterSlot: ref<inkCompoundWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"TopCenter")) as inkCompoundWidget;
    
    let minimap: ref<inkWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"minimap")) as inkWidget;
    let questList: ref<inkWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"quest_list")) as inkWidget;
    let staminabar: ref<inkWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"staminabar")) as inkWidget;
    let vehicleSummon: ref<inkWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"vehicle_summon_notification")) as inkWidget;

    this.minimapSlot = new HUDitorCustomSlot();
    this.minimapSlot.SetName(n"NewMinimap");
    this.minimapSlot.SetFitToContent(topRightSlot.GetFitToContent());
    this.minimapSlot.SetInteractive(false);
    this.minimapSlot.SetAffectsLayoutWhenHidden(false);
    this.minimapSlot.SetMargin(topRightSlot.GetMargin());
    this.minimapSlot.SetHAlign(topRightSlot.GetHAlign());
    this.minimapSlot.SetVAlign(topRightSlot.GetVAlign());
    this.minimapSlot.SetAnchor(topRightSlot.GetAnchor());
    this.minimapSlot.SetAnchorPoint(topRightSlot.GetAnchorPoint());
    this.minimapSlot.SetLayout(
      new inkWidgetLayout(
        topRightSlot.GetPadding(),
        topRightSlot.GetMargin(),
        topRightSlot.GetHAlign(),
        topRightSlot.GetVAlign(),
        topRightSlot.GetAnchor(),
        topRightSlot.GetAnchorPoint()
      )
    );

    minimap.Reparent(this.minimapSlot);
    this.minimapSlot.Reparent(topRightSlot);

    this.questTrackerSlot = new HUDitorCustomSlot();
    this.questTrackerSlot.SetName(n"NewTracker");
    this.questTrackerSlot.SetFitToContent(topRightSlot.GetFitToContent());
    this.questTrackerSlot.SetInteractive(false);
    this.questTrackerSlot.SetAffectsLayoutWhenHidden(false);
    this.questTrackerSlot.SetMargin(topRightSlot.GetMargin());
    this.questTrackerSlot.SetHAlign(topRightSlot.GetHAlign());
    this.questTrackerSlot.SetVAlign(topRightSlot.GetVAlign());
    this.questTrackerSlot.SetAnchor(topRightSlot.GetAnchor());
    this.questTrackerSlot.SetAnchorPoint(topRightSlot.GetAnchorPoint());
    this.questTrackerSlot.SetLayout(
      new inkWidgetLayout(
        topRightSlot.GetPadding(),
        topRightSlot.GetMargin(),
        topRightSlot.GetHAlign(),
        topRightSlot.GetVAlign(),
        topRightSlot.GetAnchor(),
        topRightSlot.GetAnchorPoint()
      )
    );

    questList.Reparent(this.questTrackerSlot);
    this.questTrackerSlot.Reparent(topRightSlot);

    this.staminaBarSlot = new HUDitorCustomSlot();
    this.staminaBarSlot.SetName(n"NewStaminaBar");
    this.staminaBarSlot.SetFitToContent(true);
    this.staminaBarSlot.SetInteractive(false);
    this.staminaBarSlot.SetAffectsLayoutWhenHidden(false);
    this.staminaBarSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 0.0));
    this.staminaBarSlot.SetHAlign(inkEHorizontalAlign.Center);
    this.staminaBarSlot.SetVAlign(inkEVerticalAlign.Top);
    this.staminaBarSlot.SetAnchor(inkEAnchor.TopCenter);
    this.staminaBarSlot.SetAnchorPoint(new Vector2(0.5, 0.5));
    this.staminaBarSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        inkEHorizontalAlign.Center,
        inkEVerticalAlign.Top,
        inkEAnchor.TopCenter,
        new Vector2(0.5, 0.5)
      )
    );

    staminabar.Reparent(this.staminaBarSlot);
    this.staminaBarSlot.Reparent(root);

    this.vehicleSummonSlot = new HUDitorCustomSlot();
    this.vehicleSummonSlot.SetName(n"NewVehicleSummon");
    this.vehicleSummonSlot.SetFitToContent(true);
    this.vehicleSummonSlot.SetInteractive(false);
    this.vehicleSummonSlot.SetAffectsLayoutWhenHidden(false);
    this.vehicleSummonSlot.SetMargin(new inkMargin(0.0, 0.0, 0.0, 80.0));
    this.vehicleSummonSlot.SetHAlign(inkEHorizontalAlign.Center);
    this.vehicleSummonSlot.SetVAlign(inkEVerticalAlign.Bottom);
    this.vehicleSummonSlot.SetAnchor(inkEAnchor.BottomCenter);
    this.vehicleSummonSlot.SetAnchorPoint(new Vector2(0.5, 1.0));
    this.vehicleSummonSlot.SetLayout(
      new inkWidgetLayout(
        new inkMargin(0.0, 0.0, 0.0, 0.0),
        new inkMargin(0.0, 0.0, 0.0, 80.0),
        inkEHorizontalAlign.Center,
        inkEVerticalAlign.Bottom,
        inkEAnchor.BottomCenter,
        new Vector2(0.5, 1.0)
      )
    );

    vehicleSummon.Reparent(this.vehicleSummonSlot);
    this.vehicleSummonSlot.Reparent(root);
  };
}
