// --- HEALTHBAR

@addField(healthbarWidgetGameController)
private let dynamicColorPreviewInfo: ref<inkHashMap>;

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo = new inkHashMap();

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Red"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/healthNumberContainer/hpTextVert/hp_number_holder/percentText",
      n"buffsHolder/barsLayout/health/health_bar_holder/wrapper/bar/full"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Blue"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/timer",
      n"buffsHolder/icon_holder/level_numer_increase",
      n"buffsHolder/icon_holder/frame",
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/fg/glow",
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/fg/icon"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.ActiveBlue"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/fg/frame"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.PanelBlue"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/icon_holder/level_numer",
      n"buffsHolder/icon_holder/level_numer_increase",
      n"buffsHolder/icon_holder/frame"
    ])
  );
}

@wrapMethod(healthbarWidgetGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo.Clear();
  this.dynamicColorPreviewInfo = null;
}

@addMethod(healthbarWidgetGameController)
protected cb func OnHudPainterPreviewModeEnabled(evt: ref<HudPainterPreviewModeEnabled>) -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  if IsDefined(root) && Equals(root.GetName(), StringToName(s"\(PreviewTabType.Healthbar)")) {
    this.OnCharacterLevelCurrentXPUpdated(1000);
    inkTextRef.SetText(this.m_levelTextPath, IntToString(12));
    inkTextRef.SetText(this.m_nextLevelTextPath, IntToString(12));
    inkTextRef.SetText(this.m_healthTextPath, IntToString(345));
  };
}

@addMethod(healthbarWidgetGameController)
protected cb func OnHudPainterColorPreviewAvailable(evt: ref<HudPainterColorPreviewAvailable>) -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let key: Uint64;
  let info: ref<HudPainterPreviewInfo>;
  let colorName: CName;
  let widget: ref<inkWidget>;

  if IsDefined(root) {
    key = NameToHash(StringToName(evt.color.name));
    if this.dynamicColorPreviewInfo.KeyExist(key) {
      info = this.dynamicColorPreviewInfo.Get(key) as HudPainterPreviewInfo;
      colorName = StringToName(evt.color.name);
      for path in info.paths {
        widget = root.GetWidgetByPathName(path);
        if IsDefined(widget) {
          widget.SetTintColor(evt.color.customColor);
        };
      };
    };
  };
}
