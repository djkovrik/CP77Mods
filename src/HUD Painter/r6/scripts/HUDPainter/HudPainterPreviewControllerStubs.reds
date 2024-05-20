// --- HEALTHBAR: Red, Blue, PanelBlue, ActiveBlue, DarkBlue, Overshield, Grey

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
      n"buffsHolder/barsLayout/health/health_bar_holder/wrapper/bar/full",
      n"buffsHolder/barsLayout/health/health_bar_holder/wrapper/bg"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Blue"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/icon_holder/level_numer_increase",
      n"buffsHolder/icon_holder/frame",
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/timer",
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/fg/glow",
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/fg/icon",
      n"buffsHolder/barsLayout/quickhacks/barsContainer/bar/full"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.PanelBlue"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/icon_holder/level_numer",
      n"buffsHolder/icon_holder/level_numer_increase",
      n"buffsHolder/icon_holder/frame",
      n"buffsHolder/icon_holder/full_frame"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.ActiveBlue"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/fg/frame"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.DarkBlue"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/bg/frame"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Overshield"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/barsLayout/health/overshield_bar_holder/wrapper/bar/full"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Grey"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/inkVerticalPanelWidget2/buffs/Buff/buffCanvas/bg/icon"
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
    // Exp
    this.OnCharacterLevelCurrentXPUpdated(1000);
    // HP + Overshield
    inkWidgetRef.SetWidth(this.m_fullBar, 400.0);
    inkWidgetRef.SetVisible(this.m_overshieldBarRef, true);
    root.GetWidgetByPathName(n"buffsHolder/barsLayout/health/overshield_bar_holder/wrapper/bar/full").SetWidth(200.0);
    // Memory bar
    inkCompoundRef.RemoveAllChildren(this.m_quickhacksContainer);
    inkWidgetRef.SetVisible(this.m_quickhacksContainer, true);
    let bar1: ref<QuickhackBarController> = this.SpawnFromLocal(
      inkWidgetRef.Get(this.m_quickhacksContainer), 
      n"quickhackBar"
    ).GetController() as QuickhackBarController;
    bar1.SetStatus(1.0);
    // Buffs
    this.m_buffWidget.SetVisible(true);
  };
}

@addMethod(healthbarWidgetGameController)
protected cb func OnHudPainterColorPreviewAvailable(evt: ref<HudPainterColorPreviewAvailable>) -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let key: Uint64;
  let info: ref<HudPainterPreviewInfo>;
  let widget: ref<inkWidget>;

  if IsDefined(root) {
    key = NameToHash(StringToName(evt.color.name));
    if this.dynamicColorPreviewInfo.KeyExist(key) {
      info = this.dynamicColorPreviewInfo.Get(key) as HudPainterPreviewInfo;
      for path in info.paths {
        widget = root.GetWidgetByPathName(path);
        if IsDefined(widget) {
          widget.SetTintColor(evt.color.customColor);
        };
      };
    };
  };
}

@addMethod(buffListGameController)
public final func ShowDummyBuff() -> Void {
  let buff: BuffInfo;
  let buffs: array<BuffInfo>;
  buff.buffID = t"BaseStatusEffect.CarryCapacityBooster";
  buff.timeRemaining = 950.0;
  buff.timeTotal = 1800.0;
  buff.stackCount = Cast<Uint32>(1);
  ArrayPush(buffs, buff);
  let buffsVariant: Variant = ToVariant(buffs);
  this.OnBuffDataChanged(buffsVariant);
}

@addMethod(buffListGameController)
protected cb func OnHudPainterPreviewModeEnabled(evt: ref<HudPainterPreviewModeEnabled>) -> Bool {
  this.ShowDummyBuff();
}
