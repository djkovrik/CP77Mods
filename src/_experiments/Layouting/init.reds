// -- Set names for easier search

@addMethod(ItemsNotificationQueue)
protected cb func OnInitialize() -> Bool {
  this.GetRootWidget().SetName(n"item notifications");
}

@addMethod(JournalNotificationQueue)
protected cb func OnInitialize() -> Bool {
  this.GetRootWidget().SetName(n"journal notifications");
}

@addMethod(LevelUpNotificationQueue)
protected cb func OnInitialize() -> Bool {
  this.GetRootWidget().SetName(n"level up notifications");
}


// -- Find widgets from gameuiRootHudGameController root

@addMethod(inkGameController)
func CaptureSlotsAndWidgets() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  // Slots
  this.RootSlot = root;
  this.TopLeftMainSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain")) as inkCompoundWidget;
  this.TopLeftSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeft")) as inkCompoundWidget;
  this.TopLeftSecondarySlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftSecondary")) as inkCompoundWidget;
  this.TopLeftPhoneSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftPhone")) as inkCompoundWidget;
  this.TopLeftRecordingSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftRecording")) as inkCompoundWidget;
  this.TopRightMainSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain")) as inkCompoundWidget;
  this.TopRightSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight")) as inkCompoundWidget;
  this.TopRightWantedSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRightWanted")) as inkCompoundWidget;
  this.TopRightSummonSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRightSummon")) as inkCompoundWidget;
  this.BottomCenterSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomCenter")) as inkCompoundWidget;
  this.BottomLeftSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomLeft")) as inkCompoundWidget;
  this.BottomLeftTopSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomLeftTop")) as inkCompoundWidget;
  this.BottomRightMainSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain")) as inkCompoundWidget;
  this.InputHintSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"InputHint")) as inkCompoundWidget;
  this.BottomRightSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight")) as inkCompoundWidget;
  this.BottomRightHorizontalSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal")) as inkCompoundWidget;
  this.TopCenterSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"TopCenter")) as inkCompoundWidget;
  this.LeftCenterSlot = root.GetWidgetByPath(inkWidgetPath.Build(n"LeftCenter")) as inkCompoundWidget;
  this.InputHintJohnnySlot = root.GetWidgetByPath(inkWidgetPath.Build(n"InputHintJohnny")) as inkCompoundWidget;
  // Widgets
  this.playerHealthBarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeft", n"player_health_bar")) as inkWidget;
  this.cooldownRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftSecondary", n"cooldown")) as inkWidget;
  this.phoneAvatarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftPhone", n"phone")) as inkWidget;
  this.phoneControlRef = this.SearchForWidget(root, n"HUDMiddleWidget", n"PhoneCall") as inkWidget;
  this.minimapRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"minimap")) as inkWidget;
  this.questListRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight", n"quest_list")) as inkWidget;
  this.wantedBarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRightWanted", n"wanted_bar")) as inkWidget;
  this.vehicleSummonNotificationRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRightSummon", n"vehicle_summon_notification")) as inkWidget;
  this.dpadHintRef = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomLeft", n"dpad_hint")) as inkWidget;
  this.inputHintRef = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"InputHint", n"input_hint")) as inkWidget;
  this.ammoCounterRef = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal", n"ammo_counter")) as inkWidget;
  this.crouchIndicatorRef = root.GetWidgetByPath(inkWidgetPath.Build(n"BottomRightMain", n"BottomRight", n"BottomRightHorizontal", n"crouch_indicator")) as inkWidget;
  this.activityLogRef = root.GetWidgetByPath(inkWidgetPath.Build(n"activity_log")) as inkWidget;
  this.warningRef = root.GetWidgetByPath(inkWidgetPath.Build(n"warning")) as inkWidget;
  this.bossHealthbarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"boss_healthbar")) as inkWidget;
  this.hudProgressBarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"hud_progress_bar")) as inkWidget;
  this.oxygenbarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"oxygenbar")) as inkWidget;
  this.carHudRef = root.GetWidgetByPath(inkWidgetPath.Build(n"car hud")) as inkWidget;
  this.zoneAlertNotificationRef = root.GetWidgetByPath(inkWidgetPath.Build(n"zone alert notification")) as inkWidget;
  this.staminabarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"staminabar")) as inkWidget;
  this.itemsNotificationsRef = this.SearchForWidget(root, n"LeftCenter", n"HUDSlotMiddleWidget", n"item notifications") as inkWidget;
  this.journalNotificationsRef = this.SearchForWidget(root, n"LeftCenter",n"HUDSlotMiddleWidget", n"journal notifications") as inkWidget;
  this.levelUpNotificationRef = this.SearchForWidget(root, n"HUDMiddleWidget", n"level up notifications") as inkWidget;
  this.militechWarningRef = root.GetWidgetByPath(inkWidgetPath.Build(n"militech warning")) as inkWidget;
}

@addMethod(inkGameController)
private func SearchForWidget(node: ref<inkCompoundWidget>, first: CName, second: CName) -> ref<inkWidget> {
  for compound in this.GetCompounds(node, first) {
    let widget: ref<inkWidget> = compound.GetWidget(second);
    if IsDefined(widget) {
      return widget;
    };
  };
  return null;
}

@addMethod(inkGameController)
private func SearchForWidget(node: ref<inkCompoundWidget>, first: CName, second: CName, third: CName) -> ref<inkWidget> {
  for compound1 in this.GetCompounds(node, first) {
    for compound2 in this.GetCompounds(compound1, second) {
      let widget: ref<inkWidget> = compound2.GetWidget(third);
      if IsDefined(widget) {
        return widget;
      };
    };
  };
  return null;
}

@addMethod(inkGameController)
private func GetCompounds(root: ref<inkCompoundWidget>, first: CName) -> array<ref<inkCompoundWidget>> {
  let result: array<ref<inkCompoundWidget>>;
  let numChild: Int32 = root.GetNumChildren();
  let compound: ref<inkCompoundWidget>;
  let i: Int32 = 0;
  while i < numChild {
    compound = root.GetWidgetByIndex(i) as inkCompoundWidget;
    if IsDefined(compound) && Equals(compound.GetName(), first) {
      ArrayPush(result, compound);
    };
    i += 1;
  };
  return result;
}


// -- Print initialized widgets

@addMethod(inkGameController)
func PrintCapturedSlotsAndWidgets() -> Void {
  CHL("=== Slots ===");
  ToStr(this.TopLeftMainSlot);
  ToStr(this.TopLeftSlot);
  ToStr(this.TopLeftSecondarySlot);
  ToStr(this.TopLeftPhoneSlot);
  ToStr(this.TopLeftRecordingSlot);
  ToStr(this.TopRightMainSlot);
  ToStr(this.TopRightSlot);
  ToStr(this.TopRightWantedSlot);
  ToStr(this.TopRightSummonSlot);
  ToStr(this.BottomCenterSlot);
  ToStr(this.BottomLeftSlot);
  ToStr(this.BottomLeftTopSlot);
  ToStr(this.BottomRightMainSlot);
  ToStr(this.InputHintSlot);
  ToStr(this.BottomRightSlot);
  ToStr(this.BottomRightHorizontalSlot);
  ToStr(this.TopCenterSlot);
  ToStr(this.LeftCenterSlot);
  ToStr(this.InputHintJohnnySlot);
  CHL("=== Widgets ===");
  ToStr(this.playerHealthBarRef);
  ToStr(this.cooldownRef);
  ToStr(this.phoneAvatarRef);
  ToStr(this.phoneControlRef);
  ToStr(this.minimapRef);
  ToStr(this.questListRef);
  ToStr(this.wantedBarRef);
  ToStr(this.vehicleSummonNotificationRef);
  ToStr(this.dpadHintRef);
  ToStr(this.inputHintRef);
  ToStr(this.ammoCounterRef);
  ToStr(this.crouchIndicatorRef);
  ToStr(this.activityLogRef);
  ToStr(this.warningRef);
  ToStr(this.bossHealthbarRef);
  ToStr(this.hudProgressBarRef);
  ToStr(this.oxygenbarRef);
  ToStr(this.carHudRef);
  ToStr(this.zoneAlertNotificationRef);
  ToStr(this.staminabarRef);
  ToStr(this.itemsNotificationsRef);
  ToStr(this.journalNotificationsRef);
  ToStr(this.levelUpNotificationRef);
  ToStr(this.militechWarningRef);
}

public static func ToStr(widget: ref<inkWidget>) -> Void {
  CHL(NameToString(widget.GetName()) + " / " + NameToString(widget.GetClassName()));
}
