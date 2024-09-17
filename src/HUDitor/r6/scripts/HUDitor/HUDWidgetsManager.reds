module HUDrag.HUDWidgetsManager
import HUDrag.HUDitorConfig

@addField(PlayerPuppet)
public let hudWidgetsManager: ref<HUDWidgetsManager>;

@addField(AllBlackboardDefinitions)
public let hudWidgetsManager: wref<HUDWidgetsManager>;

public class HUDWidgetsManager {
  public let gameInstance: GameInstance;
  public let puppetId: EntityID;
  public let isActive: Bool;
  public let activeWidget: CName;
  public let currentIndex: Int32;
  public let maxIndex: Int32;
  public let slots: array<CName>;

  private func Initialize(gameInstance: GameInstance, puppetId: EntityID, hudGameController: ref<inkGameController>) {
    let config: ref<HUDitorConfig> = new HUDitorConfig();
    this.gameInstance = gameInstance;
    this.puppetId = puppetId;
    this.SetHUDEditorListener(hudGameController);
    this.currentIndex = 0;
    if config.questTrackerEnabled { ArrayPush(this.slots, n"NewTracker"); }
    if config.minimapEnabled && !config.compatE3CompassEnabled { ArrayPush(this.slots, n"NewMinimap"); }
    if config.wantedBarEnabled { ArrayPush(this.slots, n"NewWanted"); }
    if config.incomingCallAvatarEnabled { ArrayPush(this.slots, n"NewPhoneAvatar"); }
    if config.incomingCallButtonEnabled { ArrayPush(this.slots, n"NewPhoneControl"); }
    if config.questNotificationsEnabled { ArrayPush(this.slots, n"NewQuestNotifications"); }
    if config.itemNotificationsEnabled { ArrayPush(this.slots, n"NewItemNotifications"); }
    if config.vehicleSummonEnabled { ArrayPush(this.slots, n"NewVehicleSummon"); }
    if config.weaponRosterEnabled { ArrayPush(this.slots, n"NewWeaponRoster"); }
    if config.crouchIndicatorEnabled { ArrayPush(this.slots, n"NewCrouchIndicator"); }
    if config.dpadEnabled { ArrayPush(this.slots, n"NewDpad"); }
    if config.phoneHotkeyEnabled { ArrayPush(this.slots, n"NewPhoneHotkey"); }
    if config.playerHealthbarEnabled { ArrayPush(this.slots, n"NewHealthBar"); }
    if config.playerStaminabarEnabled { ArrayPush(this.slots, n"NewStaminaBar"); }
    if config.inputHintsEnabled { ArrayPush(this.slots, n"NewInputHint"); }
    if config.speedometerEnabled { ArrayPush(this.slots, n"NewCarHud"); }
    if config.bossHealthbarEnabled { ArrayPush(this.slots, n"NewBossHealthbar"); }
    if config.dialogChoicesEnabled { ArrayPush(this.slots, n"NewDialogChoices"); }
    if config.dialogSubtitlesEnabled { ArrayPush(this.slots, n"NewDialogSubtitles"); }
    if config.progressWidgetEnabled { ArrayPush(this.slots, n"NewProgressBar"); }
    if config.compatE3CompassEnabled { ArrayPush(this.slots, n"NewCompass"); }
    if config.fpsCounterEnabled { ArrayPush(this.slots, n"NewFpsCounter"); }
    this.maxIndex = ArraySize(this.slots) - 1;
  }

  public static func CreateInstance(puppet: ref<gamePuppet>, hudGameController: ref<inkGameController>) {
    let instance: ref<HUDWidgetsManager> = new HUDWidgetsManager();
    let gameInstance: GameInstance = puppet.GetGame();
    let puppetEntityId: EntityID = puppet.GetEntityID();
    instance.Initialize(gameInstance, puppetEntityId, hudGameController);

    let player: wref<PlayerPuppet> = GetPlayer(gameInstance);
    player.hudWidgetsManager = instance;
    GetAllBlackboardDefs().hudWidgetsManager = instance;
  }

  public static func GetInstance() -> wref<HUDWidgetsManager> {
    return GetAllBlackboardDefs().hudWidgetsManager;
  }

  public func GetPlayerPuppet() -> wref<PlayerPuppet> {
    return GameInstance.FindEntityByID(this.gameInstance, this.puppetId) as PlayerPuppet;
  }

  public func IsActive() -> Bool {
    return this.isActive;
  }

  public func SwitchToNextWidget() -> Void {
    this.currentIndex = this.currentIndex + 1;
    if this.currentIndex > this.maxIndex { this.currentIndex = 0; };
  }

  public func SwitchToPrevWidget() -> Void {
    this.currentIndex = this.currentIndex - 1;
    if this.currentIndex < 0 { this.currentIndex = this.maxIndex; };
  }

  public func GetActiveWidget() -> CName {
    if ArraySize(this.slots) > 0 && this.currentIndex >= 0 && this.currentIndex < ArraySize(this.slots) {
      return this.slots[this.currentIndex];
    };

    return n"";
  }

  public func GetSlots() -> array<CName> {
    return this.slots;
  }

  public func SetHUDEditorListener(hudGameController: ref<inkGameController>) -> Void {
    let player: wref<PlayerPuppet> = this.GetPlayerPuppet();
    player.RegisterInputListener(hudGameController, n"ToggleSprint");
    player.RegisterInputListener(hudGameController, n"UI_Unequip");
    player.RegisterInputListener(hudGameController, n"HUDitor_Editor");
    player.RegisterInputListener(hudGameController, n"world_map_filter_navigation_down");
    player.RegisterInputListener(hudGameController, n"back");
    player.RegisterInputListener(hudGameController, n"cancel");
    player.RegisterInputListener(hudGameController, n"right_button");
    player.RegisterInputListener(hudGameController, n"left_button");
    player.RegisterInputListener(hudGameController, n"CameraMouseX");
    player.RegisterInputListener(hudGameController, n"CameraMouseY");
    player.RegisterInputListener(hudGameController, n"click");
  }

  public func AssignHUDWidgetListeners(customSlot: ref<HUDitorCustomSlot>) {
    let player: wref<PlayerPuppet> = this.GetPlayerPuppet();
    player.RegisterInputListener(customSlot, n"mouse_wheel");
    player.RegisterInputListener(customSlot, n"CameraMouseX");
    player.RegisterInputListener(customSlot, n"CameraMouseY");
    player.RegisterInputListener(customSlot, n"click");
    player.RegisterInputListener(customSlot, n"Forward");
    player.RegisterInputListener(customSlot, n"Right");
    player.RegisterInputListener(customSlot, n"Back");
    player.RegisterInputListener(customSlot, n"Left");
  }

   public func RemoveHUDWidgetListeners(customSlot: ref<HUDitorCustomSlot>) {
    let player: wref<PlayerPuppet> = this.GetPlayerPuppet();
    player.UnregisterInputListener(customSlot, n"CameraMouseX");
    player.UnregisterInputListener(customSlot, n"CameraMouseY");
    player.UnregisterInputListener(customSlot, n"mouse_wheel");
    player.UnregisterInputListener(customSlot, n"click");
    player.UnregisterInputListener(customSlot, n"Forward");
    player.UnregisterInputListener(customSlot, n"Right");
    player.UnregisterInputListener(customSlot, n"Back");
    player.UnregisterInputListener(customSlot, n"Left");
  }
}
