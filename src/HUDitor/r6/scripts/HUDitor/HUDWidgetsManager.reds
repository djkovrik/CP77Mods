module HUDrag.HUDWidgetsManager

// Widgets and order:
// - NewTracker - Quest tracker
// - NewMinimap - Minimap
// - NewWanted - Wanted bar
// - NewQuestNotifications - Quest notifications area
// - NewItemNotifications - Items notifications area
// - NewVehicleSummon - Vehicle summon
// - NewWeaponRoster - Ammo counter
// - NewCrouchIndicator - Crouch indicator
// - NewDpad - Dpad hint
// - NewHealthBar - Player healthbar
// - NewStaminaBar - Stamina
// - NewPhoneAvatar - Phone call avatar
// - NewPhoneControl - Phone call input control
// - NewInputHint - Input hints
// - NewCarHud - Speedometer
// - NewBossHealthbar - Boss healthbar
// - NewDialogChoices - Dialog choices
// - NewDialogSubtitles - Dialog subtitles

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
    this.gameInstance = gameInstance;
    this.puppetId = puppetId;
    this.SetHUDEditorListener(hudGameController);
    this.currentIndex = 0;
    this.slots = [
      n"NewTracker",
      n"NewMinimap",
      n"NewWanted",
      n"NewQuestNotifications",
      n"NewItemNotifications",
      n"NewVehicleSummon",
      n"NewWeaponRoster",
      n"NewCrouchIndicator",
      n"NewDpad",
      n"NewHealthBar",
      n"NewStaminaBar",
      n"NewPhoneAvatar",
      n"NewPhoneControl",
      n"NewInputHint",
      n"NewCarHud",
      n"NewBossHealthbar",
      n"NewDialogChoices",
      n"NewDialogSubtitles"
    ];
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