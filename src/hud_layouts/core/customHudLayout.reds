public class InjectRootHudGameControllerEvent extends Event {}

@wrapMethod(MinimapContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);
  GameInstance.GetUISystem(playerGameObject.GetGame()).QueueEvent(new InjectRootHudGameControllerEvent());
}

@addMethod(inkGameController)
protected cb func OnInjectRootHudGameController(evt: ref<InjectRootHudGameControllerEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.CaptureSlotsAndWidgets();
    this.PrintCapturedSlotsAndWidgets();
    this.AdjustWidgetsPositions();
  };
}

// -- Slots
@addField(inkGameController) let TopLeftMainSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopLeftSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopLeftSecondarySlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopLeftPhoneSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopLeftRecordingSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopRightMainSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopRightSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopRightWantedSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopRightSummonSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let BottomCenterSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let BottomLeftSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let BottomLeftTopSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let BottomRightMainSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let InputHintSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let BottomRightSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let BottomRightHorizontalSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let TopCenterSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let LeftCenterSlot: ref<inkCompoundWidget>;
@addField(inkGameController) let InputHintJohnnySlot: ref<inkCompoundWidget>;

// -- Widgets
@addField(inkGameController) let playerHealthBarRef: ref<inkWidget>;
@addField(inkGameController) let cooldownRef: ref<inkWidget>;
@addField(inkGameController) let phoneRef: ref<inkWidget>;
@addField(inkGameController) let minimapRef: ref<inkWidget>;
@addField(inkGameController) let questListRef: ref<inkWidget>;
@addField(inkGameController) let wantedBarRef: ref<inkWidget>;
@addField(inkGameController) let vehicleSummonNotificationRef: ref<inkWidget>;
@addField(inkGameController) let dpadHintRef: ref<inkWidget>;
@addField(inkGameController) let inputHintRef: ref<inkWidget>;
@addField(inkGameController) let ammoCounterRef: ref<inkWidget>;
@addField(inkGameController) let crouchIndicatorRef: ref<inkWidget>;
@addField(inkGameController) let activityLogRef: ref<inkWidget>;
@addField(inkGameController) let warningRef: ref<inkWidget>;
@addField(inkGameController) let cursorDeviceRef: ref<inkWidget>;
@addField(inkGameController) let bossHealthbarRef: ref<inkWidget>;
@addField(inkGameController) let hudProgressBarRef: ref<inkWidget>;
@addField(inkGameController) let oxygenbarRef: ref<inkWidget>;
@addField(inkGameController) let vehicleScanWidgetRef: ref<inkWidget>;
@addField(inkGameController) let carHudRef: ref<inkWidget>;
@addField(inkGameController) let zoneAlertNotificationRef: ref<inkWidget>;
@addField(inkGameController) let staminabarRef: ref<inkWidget>;

@addMethod(inkGameController)
func CaptureSlotsAndWidgets() -> Void {
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  // Slots
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
  this.phoneRef = root.GetWidgetByPath(inkWidgetPath.Build(n"TopLeftMain", n"TopLeftPhone", n"phone")) as inkWidget;
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
  this.cursorDeviceRef = root.GetWidgetByPath(inkWidgetPath.Build(n"cursor_device")) as inkWidget;
  this.bossHealthbarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"boss_healthbar")) as inkWidget;
  this.hudProgressBarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"hud_progress_bar")) as inkWidget;
  this.oxygenbarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"oxygenbar")) as inkWidget;
  this.vehicleScanWidgetRef = root.GetWidgetByPath(inkWidgetPath.Build(n"vehicle scan widget")) as inkWidget;
  this.carHudRef = root.GetWidgetByPath(inkWidgetPath.Build(n"car hud")) as inkWidget;
  this.zoneAlertNotificationRef = root.GetWidgetByPath(inkWidgetPath.Build(n"zone alert notification")) as inkWidget;
  this.staminabarRef = root.GetWidgetByPath(inkWidgetPath.Build(n"staminabar")) as inkWidget;

  CHLog("Slots and widgets captured");
}

@addMethod(inkGameController)
func AdjustWidgetsPositions() -> Void {
  // Minimap
  // Wanted Bar
  // Quest List
  // Healthbar
  // Cooldowns
  // Phone
  // Vehicle Summon
  // DPad Hint
  // Input Hint
  // Ammo Counter
  // Crouch Indicator
  // Activity Log
  // Warning
  // Cursor device (wtf is this?)
  // Boss Healthbar
  // HUD Progress Bar
  // Oxygenbar
  // Staminabar
  // Vehicle Scan
  // Car Hud
  // Zone Alert Notification
}

@addMethod(inkGameController)
func PrintCapturedSlotsAndWidgets() -> Void {
  CHLog("Slots");
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
  CHLog("Widgets");
  ToStr(this.playerHealthBarRef);
  ToStr(this.cooldownRef);
  ToStr(this.phoneRef);
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
  ToStr(this.cursorDeviceRef);
  ToStr(this.bossHealthbarRef);
  ToStr(this.hudProgressBarRef);
  ToStr(this.oxygenbarRef);
  ToStr(this.vehicleScanWidgetRef);
  ToStr(this.carHudRef);
  ToStr(this.zoneAlertNotificationRef);
  ToStr(this.staminabarRef);
}

public static func ToStr(widget: ref<inkWidget>) -> Void {
  CHLog(" - " + NameToString(widget.GetName()) + " / " + NameToString(widget.GetClassName()));
}

public static func CHLog(str: String) -> Void {
  Log("[Custom HUD Layouts]: " + str);
}
