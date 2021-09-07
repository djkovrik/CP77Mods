// -- Enable or disable CET logs
public static func EnableLoggingCET() -> Bool = true

// -- Custom event to inject root hud widget
public class InjectRootHudGameControllerEvent extends Event {}

// -- Slots
@addField(inkGameController) let RootSlot: ref<inkCompoundWidget>;
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
@addField(inkGameController) let playerHealthBarRef: ref<inkWidget>;            // healthbarWidgetGameController
@addField(inkGameController) let cooldownRef: ref<inkWidget>;                   // inkCooldownGameController
@addField(inkGameController) let phoneAvatarRef: ref<inkWidget>;                // HudPhoneGameController
@addField(inkGameController) let phoneControlRef: ref<inkWidget>;               // IncomingCallGameController
@addField(inkGameController) let minimapRef: ref<inkWidget>;                    // MinimapContainerController
@addField(inkGameController) let questListRef: ref<inkWidget>;                  // QuestTrackerGameController
@addField(inkGameController) let wantedBarRef: ref<inkWidget>;                  // WantedBarGameController
@addField(inkGameController) let vehicleSummonNotificationRef: ref<inkWidget>;  // VehicleSummonWidgetGameController
@addField(inkGameController) let dpadHintRef: ref<inkWidget>;                   // HotkeysWidgetController
@addField(inkGameController) let inputHintRef: ref<inkWidget>;                  // InputHintManagerGameController
@addField(inkGameController) let ammoCounterRef: ref<inkWidget>;                // weaponRosterGameController
@addField(inkGameController) let crouchIndicatorRef: ref<inkWidget>;            // CrouchIndicatorGameController
@addField(inkGameController) let activityLogRef: ref<inkWidget>;                // activityLogGameController
@addField(inkGameController) let warningRef: ref<inkWidget>;                    // WarningMessageGameController
@addField(inkGameController) let bossHealthbarRef: ref<inkWidget>;              // BossHealthBarGameController
@addField(inkGameController) let hudProgressBarRef: ref<inkWidget>;             // HUDProgressBarController
@addField(inkGameController) let oxygenbarRef: ref<inkWidget>;                  // OxygenbarWidgetGameController
@addField(inkGameController) let carHudRef: ref<inkWidget>;                     // hudCarController
@addField(inkGameController) let zoneAlertNotificationRef: ref<inkWidget>;      // ZoneAlertNotificationQueue
@addField(inkGameController) let staminabarRef: ref<inkWidget>;                 // StaminabarWidgetGameController
@addField(inkGameController) let itemsNotificationsRef: ref<inkWidget>;         // ItemsNotificationQueue
@addField(inkGameController) let journalNotificationsRef: ref<inkWidget>;       // JournalNotificationQueue
@addField(inkGameController) let levelUpNotificationRef: ref<inkWidget>;        // LevelUpNotificationQueue
@addField(inkGameController) let militechWarningRef: ref<inkWidget>;            // hudMilitechWarningGameController

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(new InjectRootHudGameControllerEvent());
}

@addMethod(inkGameController)
protected cb func OnInjectRootHudGameControllerEvent(evt: ref<InjectRootHudGameControllerEvent>) -> Bool {
  if this.IsA(n"gameuiRootHudGameController") {
    this.CaptureSlotsAndWidgets();
    // this.PrintCapturedSlotdsAndWidgets();
    this.CreateCustomSlots();
    this.AdjustWidgetsPositions();
  };
}

@addMethod(inkGameController)
public func MakeHorizontalSlot(n: CName, m: inkMargin, h: inkEHorizontalAlign, v: inkEVerticalAlign, a: inkEAnchor, pnt: Vector2, pvt: Vector2) -> ref<inkHorizontalPanel> {
  let slot: ref<inkHorizontalPanel> = new inkHorizontalPanel();
  slot.SetName(n);
  slot.SetFitToContent(true);
  slot.SetInteractive(false);
  slot.SetAffectsLayoutWhenHidden(false);
  slot.SetMargin(m);
  slot.SetHAlign(h);
  slot.SetVAlign(v);
  slot.SetAnchor(a);
  slot.SetAnchorPoint(pnt);
  slot.SetSizeRule(inkESizeRule.Fixed);
  slot.SetSizeCoefficient(1.0);
  slot.SetRenderTransformPivot(pvt);
  slot.SetLayout(new inkWidgetLayout(m, m, h, v, a, pnt));
  return slot;
}

@addMethod(inkGameController)
public func MakeVerticalSlot(n: CName, m: inkMargin, h: inkEHorizontalAlign, v: inkEVerticalAlign, a: inkEAnchor, pnt: Vector2, pvt: Vector2) -> ref<inkVerticalPanel> {
  let slot: ref<inkVerticalPanel> = new inkVerticalPanel();
  slot.SetName(n);
  slot.SetFitToContent(true);
  slot.SetInteractive(false);
  slot.SetAffectsLayoutWhenHidden(false);
  slot.SetMargin(m);
  slot.SetHAlign(h);
  slot.SetVAlign(v);
  slot.SetAnchor(a);
  slot.SetAnchorPoint(pnt);
  slot.SetSizeRule(inkESizeRule.Fixed);
  slot.SetSizeCoefficient(1.0);
  slot.SetRenderTransformPivot(pvt);
  slot.SetLayout(new inkWidgetLayout(m, m, h, v, a, pnt));
  return slot;
}

@addMethod(inkGameController)
public func SetWidgetParams(widget: ref<inkWidget>, m: inkMargin, h: inkEHorizontalAlign, v: inkEVerticalAlign, a: inkEAnchor, pnt: Vector2, pvt: Vector2) -> Void {
  widget.SetMargin(m);
  widget.SetHAlign(h);
  widget.SetVAlign(v);
  widget.SetAnchor(a);
  widget.SetAnchorPoint(pnt);
  widget.SetRenderTransformPivot(pvt);
  widget.SetLayout(new inkWidgetLayout(m, m, h, v, a, pnt));
}

@addMethod(inkGameController)
protected func GetCurrentResolution() -> Vector2 {
  let settings: ref<UserSettings> = GameInstance.GetSettingsSystem(this.GetPlayerControlledObject().GetGame());
  let configVar: ref<ConfigVarListString> = settings.GetVar(n"/video/display", n"Resolution") as ConfigVarListString;
  let resolution: String = configVar.GetValue();
  let dimensions: array<String> = StrSplit(resolution, "x");
  return new Vector2(StringToFloat(dimensions[0]), StringToFloat(dimensions[1]));
}

public static func CHL(str: String) -> Void {
  if EnableLoggingCET() {
    LogChannel(n"DEBUG", "CHL: " + str);
  };
}
