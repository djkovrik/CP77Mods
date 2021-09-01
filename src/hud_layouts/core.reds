public static func EnableLoggingCET() -> Bool = true

// -- Custom event to inject root hud widget
public class InjectRootHudGameControllerEvent extends Event {}

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
@addField(inkGameController) let playerHealthBarRef: ref<inkWidget>;            // healthbarWidgetGameController
@addField(inkGameController) let cooldownRef: ref<inkWidget>;                   // inkCooldownGameController
@addField(inkGameController) let phoneRef: ref<inkWidget>;                      // ?
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
@addField(inkGameController) let phoneCallRef: ref<inkWidget>;                  // IncomingCallGameController
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
    this.PrintCapturedSlotsAndWidgets();
    this.AdjustWidgetsPositions();
  };
}

public static func CHL(str: String) -> Void {
  if EnableLoggingCET() {
    LogChannel(n"DEBUG", "CHL: " + str);
  };
}
