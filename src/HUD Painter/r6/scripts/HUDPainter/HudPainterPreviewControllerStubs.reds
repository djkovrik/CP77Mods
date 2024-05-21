// --- HEALTHBAR: Red, Blue, PanelBlue, ActiveBlue, DarkBlue, Overshield, Grey

@addField(healthbarWidgetGameController)
private let dynamicColorPreviewInfo: ref<inkHashMap>;

@addField(healthbarWidgetGameController)
private let previewPopulated: Bool;

@wrapMethod(healthbarWidgetGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo = new inkHashMap();

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Red"), 
    HudPainterPreviewInfo.Create([
      n"buffsHolder/healthNumberContainer/hpTextVert/hp_number_holder/percentText",
      n"buffsHolder/barsLayout/health/health_bar_holder/wrapper/bar/full",
      n"buffsHolder/barsLayout/health/health_bar_holder/wrapper/bg",
      n"buffsHolder/barsLayout/quickhacks/barsContainer/bar4/empty/rect",
      n"buffsHolder/barsLayout/quickhacks/barsContainer/bar5/empty/rect",
      n"buffsHolder/barsLayout/quickhacks/barsContainer/bar6/empty/rect"
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
      n"buffsHolder/barsLayout/quickhacks/barsContainer/bar1/full",
      n"buffsHolder/barsLayout/quickhacks/barsContainer/bar2/full",
      n"buffsHolder/barsLayout/quickhacks/barsContainer/bar3/full"
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
  if IsDefined(root) && Equals(root.GetName(), StringToName(s"\(PreviewTabType.Healthbar)")) && !this.previewPopulated {
    this.previewPopulated = true;

    // Exp
    this.OnCharacterLevelCurrentXPUpdated(1000);
    // HP + Overshield
    inkWidgetRef.SetWidth(this.m_fullBar, 400.0);
    inkWidgetRef.SetVisible(this.m_overshieldBarRef, true);
    root.GetWidgetByPathName(n"buffsHolder/barsLayout/health/overshield_bar_holder/wrapper/bar/full").SetWidth(200.0);
    // Memory bar
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_quickhacksContainer) as inkCompoundWidget;
    container.RemoveAllChildren();
    container.SetVisible(true);
    this.SpawnPreviewQuickBar(container, 1, 1.0);
    this.SpawnPreviewQuickBar(container, 2, 1.0);
    this.SpawnPreviewQuickBar(container, 3, 1.0);
    this.SpawnPreviewQuickBar(container, 4, 0.0);
    this.SpawnPreviewQuickBar(container, 5, 0.0);
    this.SpawnPreviewQuickBar(container, 6, 0.0);
    // Buffs
    this.m_buffWidget.SetVisible(true);
  };
}

@addMethod(healthbarWidgetGameController)
private final func SpawnPreviewQuickBar(container: ref<inkWidget>, index: Int32, value: Float) -> Void {
  let widget: ref<inkWidget> = this.SpawnFromLocal(container, n"quickhackBar");
  widget.SetName(StringToName(s"bar\(index)"));
  let controller: ref<QuickhackBarController> = widget.GetController() as QuickhackBarController;
  controller.SetStatus(value);
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

@addMethod(healthbarWidgetGameController)
protected cb func OnHudPainterInkStyleRefreshed(evt: ref<HudPainterInkStyleRefreshed>) -> Bool {
  this.previewPopulated = false;
}

@addField(buffListGameController)
private let previewPopulated: Bool;

@addMethod(buffListGameController)
protected cb func OnHudPainterPreviewModeEnabled(evt: ref<HudPainterPreviewModeEnabled>) -> Bool {
  if !this.previewPopulated {
    this.ShowDummyBuff();
  };
}

@addMethod(buffListGameController)
protected cb func OnHudPainterInkStyleRefreshed(evt: ref<HudPainterInkStyleRefreshed>) -> Bool {
  this.previewPopulated = false;
}

@addMethod(buffListGameController)
public final func ShowDummyBuff() -> Void {
  let buff: BuffInfo;
  buff.buffID = t"BaseStatusEffect.CarryCapacityBooster";
  buff.timeRemaining = 950.0;
  buff.timeTotal = 1800.0;
  buff.stackCount = Cast<Uint32>(1);
  let data: ref<StatusEffect_Record> = TweakDBInterface.GetStatusEffectRecord(buff.buffID);
  let newItem: ref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_buffsList), n"Buff");
  let controller: ref<buffListItemLogicController> = newItem.GetController() as buffListItemLogicController;
  controller.SetData(StringToName(data.UiData().IconPath()), buff.timeRemaining, buff.timeTotal, Cast<Int32>(buff.stackCount));
  controller.SetStatusEffectRecord(data);
  newItem.SetVisible(true);
  inkWidgetRef.SetVisible(this.m_buffsList, true);
  this.previewPopulated = true;
}


// --- QUEST TRACKER: ActiveYellow, ActiveGreen, CombatRed, StreetCred

@addField(QuestTrackerGameController)
private let dynamicColorPreviewInfo: ref<inkHashMap>;

@addField(QuestTrackerGameController)
private let previewPopulated: Bool;

@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo = new inkHashMap();

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.ActiveYellow"), 
    HudPainterPreviewInfo.Create([
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/Title/QuestName",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry2/list/title",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry2/list/iconLayer/frame",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry2/list/iconLayer/fill/fillTexture"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.ActiveGreen"), 
    HudPainterPreviewInfo.Create([
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry4/list/title",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry4/list/iconLayer/frame",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry4/list/iconLayer/fill/fillTexture"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.CombatRed"), 
    HudPainterPreviewInfo.Create([
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry3/list/title",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry3/list/iconLayer/frame",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry3/list/iconLayer/fill/fillTexture"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.StreetCred"), 
    HudPainterPreviewInfo.Create([
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry1/list/title",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry1/list/iconLayer/frame",
      n"inkVerticalPanelWidget2/QuestTracker/Fluff/ObjectiveList/entry1/list/iconLayer/fill/fillTexture"
    ])
  );
}

@wrapMethod(QuestTrackerGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo.Clear();
  this.dynamicColorPreviewInfo = null;
}

@addMethod(QuestTrackerGameController)
protected cb func OnHudPainterPreviewModeEnabled(evt: ref<HudPainterPreviewModeEnabled>) -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  if IsDefined(root) && Equals(root.GetName(), StringToName(s"\(PreviewTabType.QuestTracker)")) && !this.previewPopulated {
    this.previewPopulated = true;

    inkWidgetRef.SetVisible(this.m_questTrackerContainer, true);
    inkTextRef.SetText(this.m_QuestTitle, "Some cool quest name");
    inkWidgetRef.SetState(this.m_QuestTitle, n"Quest");
    inkCompoundRef.RemoveAllChildren(this.m_ObjectiveContainer);

    let entryWidget1: ref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_ObjectiveContainer), n"Objective");
    entryWidget1.SetName(n"entry1");
    let controller1: ref<QuestTrackerObjectiveLogicController> = entryWidget1.GetController() as QuestTrackerObjectiveLogicController;
    controller1.SetData("Don't meet Hanako at Embers.", true, false, 0, 0, null, false);
    
    let entryWidget4: ref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_ObjectiveContainer), n"Objective");
    entryWidget4.SetName(n"entry4");
    let controller4: ref<QuestTrackerObjectiveLogicController> = entryWidget4.GetController() as QuestTrackerObjectiveLogicController;
    controller4.SetData("Met Hanako at Embers", true, false, 0, 0, null, true);
    controller4.SetObjectiveState(n"succeeded");

    let entryWidget3: ref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_ObjectiveContainer), n"Objective");
    entryWidget3.SetName(n"entry3");
    let controller3: ref<QuestTrackerObjectiveLogicController> = entryWidget3.GetController() as QuestTrackerObjectiveLogicController;
    controller3.SetData("Failed to Meet Hanako", true, false, 0, 0, null, true);
    controller3.SetObjectiveState(n"failed");

    let entryWidget2: ref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_ObjectiveContainer), n"Objective");
    entryWidget2.SetName(n"entry2");
    let controller2: ref<QuestTrackerObjectiveLogicController> = entryWidget2.GetController() as QuestTrackerObjectiveLogicController;
    controller2.SetData("Meet Hanako maybe?", true, false, 0, 0, null, true);
  };
}

@addMethod(QuestTrackerGameController)
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

@addMethod(QuestTrackerGameController)
protected cb func OnHudPainterInkStyleRefreshed(evt: ref<HudPainterInkStyleRefreshed>) -> Bool {
  this.previewPopulated = false;
}


// --- WEAPON ROSTER: Red, ActiveRed, Blue

@addField(WeaponRosterGameController)
private let dynamicColorPreviewInfo: ref<inkHashMap>;

@addField(WeaponRosterGameController)
private let previewPopulated: Bool;

@wrapMethod(WeaponRosterGameController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo = new inkHashMap();

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Red"), 
    HudPainterPreviewInfo.Create([
      n"weapon_on_foot/ammo_counter/additional_info/weapon_name",
      n"weapon_on_foot/ammo_counter/weapon_wrapper/ammo_wrapper/AmmoAll"
    ])
  );
  
  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.ActiveRed"), 
    HudPainterPreviewInfo.Create([
      n"weapon_on_foot/ammo_counter/weapon_wrapper/weapon_holder/weapon_icon"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Blue"), 
    HudPainterPreviewInfo.Create([
      n"weapon_on_foot/ammo_counter/weapon_wrapper/ammo_wrapper/AmmoCurrent"
    ])
  );
}

@wrapMethod(WeaponRosterGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo.Clear();
  this.dynamicColorPreviewInfo = null;
}

@addField(WeaponRosterGameController)
private let m_unfoldAnimTest: ref<inkAnimProxy>;

@addMethod(WeaponRosterGameController)
protected cb func OnHudPainterPreviewModeEnabled(evt: ref<HudPainterPreviewModeEnabled>) -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  if IsDefined(root) && Equals(root.GetName(), StringToName(s"\(PreviewTabType.AmmoCounter)")) && !this.previewPopulated {
    this.previewPopulated = true;
    this.m_weaponRecord = TweakDBInterface.GetWeaponItemRecord(t"Items.Craftable_Legendary_Kyubi");
    this.LoadWeaponIcon();
    inkTextRef.SetText(this.m_weaponName, "Kyubi");
    inkTextRef.SetText(this.m_weaponCurrentAmmo, "12");
    inkTextRef.SetText(this.m_weaponTotalAmmo, "345");
    inkWidgetRef.SetVisible(this.m_weaponCurrentAmmo, true);
    inkWidgetRef.SetVisible(this.m_weaponTotalAmmo, true);

    if IsDefined(this.m_unfoldAnimTest) {
      this.m_unfoldAnimTest.GotoEndAndStop();
    };
    this.m_unfoldAnimTest = this.PlayLibraryAnimation(n"unfold");
    this.m_unfoldAnimTest.GotoEndAndStop(true);
    this.GetRootWidget().SetVisible(false);
  };
}

@addMethod(WeaponRosterGameController)
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

@addMethod(WeaponRosterGameController)
protected cb func OnHudPainterInkStyleRefreshed(evt: ref<HudPainterInkStyleRefreshed>) -> Bool {
  this.previewPopulated = false;
}


// --- SAFE AREA NOTIFICATION: Green

@addField(GenericNotificationController)
private let dynamicColorPreviewInfo: ref<inkHashMap>;

@wrapMethod(GenericNotificationController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo = new inkHashMap();

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Green"), 
    HudPainterPreviewInfo.Create([
      n"LimitedAccesArea/ICON_ProtocolC/sq1",
      n"LimitedAccesArea/ICON_ProtocolC/sq2",
      n"LimitedAccesArea/ICON_ProtocolC/sq3",
      n"LimitedAccesArea/ICON_ProtocolC/sq4",
      n"LimitedAccesArea/ICON_ProtocolC/PROTOCOL_circle",
      n"LimitedAccesArea/ICON_ProtocolC/PROTOCOL_circleGhost",
      n"LimitedAccesArea/ICON_ProtocolC/ATTENTION_ExclamationIci",
      n"LimitedAccesArea/fluff3lines/Fluff_3linesTEX",
      n"LimitedAccesArea/L_R/Bracket/Bracket_MainBG",
      n"LimitedAccesArea/L_R/T_bar_R/Plate_main",
      n"LimitedAccesArea/L_R/T_bar_R/BrackedR_sm"
    ])
  );
}

@wrapMethod(GenericNotificationController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();
  this.dynamicColorPreviewInfo.Clear();
  this.dynamicColorPreviewInfo = null;
}

@addMethod(GenericNotificationController)
protected cb func OnHudPainterColorPreviewAvailable(evt: ref<HudPainterColorPreviewAvailable>) -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let key: Uint64;
  let info: ref<HudPainterPreviewInfo>;
  let widget: ref<inkWidget>;

  if NotEquals(root.GetName(), StringToName(s"\(PreviewTabType.NotificationSafe)")) {
    return false;
  };

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


// --- JOURNAL NOTIFICATION: Yellow, White

@addField(JournalNotification)
private let previewPopulated: Bool;

@wrapMethod(JournalNotification)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.Yellow"), 
    HudPainterPreviewInfo.Create([
      n"New_QuestCompleted_canvas/quest_default/Side_edges",
      n"New_QuestCompleted_canvas/quest_default/Front/Front_Outline",
      n"New_QuestCompleted_canvas/quest_default/Front/Front",
      n"New_QuestCompleted_canvas/quest_default/Middle_Bottom_small/Middle_Bottom_small_top",
      n"New_QuestCompleted_canvas/quest_default/Middle_Bottom_small/Middle_Bottom_small_edge",
      n"New_QuestCompleted_canvas/quest_default/Middle_Bottom_Big/Middle_Bottom_big_detail",
      n"New_QuestCompleted_canvas/quest_default/Middle_Bottom_Big/Middle_Bottom_big_outline",
      n"New_QuestCompleted_canvas/quest_default/Middle_Bottom_Big/Middle_Bottom_big",
      n"New_QuestCompleted_canvas/quest_default/Middle_Top/Middle_Top_Outline",
      n"New_QuestCompleted_canvas/quest_default/Middle_Top/Middle_Top",
      n"New_QuestCompleted_canvas/quest_default/back/Back_Outline",
      n"New_QuestCompleted_canvas/SQ_quest_canvas/SQ_quest_outline",
      n"New_QuestCompleted_canvas/SQ_quest_canvas/Cross_canvas/arrow_quest_inside",
      n"New_QuestCompleted_canvas/SQ_quest_canvas/Cross_canvas_ghost/SQ_quest_inside",
      n"New_QuestCompleted_canvas/Quest_Completed/QuestUpdated_txt"
    ])
  );

  this.dynamicColorPreviewInfo.Insert(
    NameToHash(n"MainColors.White"), 
    HudPainterPreviewInfo.Create([
      n"New_QuestCompleted_canvas/inkVerticalPanelWidget11/QuestTxt"
    ])
  );
}

@addMethod(JournalNotification)
protected cb func OnHudPainterPreviewModeEnabled(evt: ref<HudPainterPreviewModeEnabled>) -> Bool {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  if IsDefined(root) && Equals(root.GetName(), StringToName(s"\(PreviewTabType.UpdateMessage)")) && !this.previewPopulated {
    this.previewPopulated = true;
    inkTextRef.SetText(this.m_titleRef, "Message title");
    inkTextRef.SetText(this.m_textRef, "Manually enhanced message text");
  };
}

@addMethod(JournalNotification)
protected cb func OnHudPainterInkStyleRefreshed(evt: ref<HudPainterInkStyleRefreshed>) -> Bool {
  this.previewPopulated = false;
}

@addMethod(JournalNotification)
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
