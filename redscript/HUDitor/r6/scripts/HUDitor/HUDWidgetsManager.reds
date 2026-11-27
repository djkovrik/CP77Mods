module HUDrag.HUDWidgetsManager
import HUDrag.HUDitorConfig

@addField(PlayerPuppet)
public let hudWidgetsManager: ref<HUDWidgetsManager>;

@addField(AllBlackboardDefinitions)
public let hudWidgetsManager: wref<HUDWidgetsManager>;

public class HUDWidgetsManager {
  public let gameInstance: GameInstance;
  public let player: wref<PlayerPuppet>;
  public let listener: wref<HUDitorInputListener>;
  public let host: wref<inkGameController>;
  public let window: wref<inkCompoundWidget>;
  public let uiController: wref<inkGameController>;
  public let isActive: Bool;
  public let disposed: Bool;
  public let ready: Bool;
  public let generation: Uint32;
  public let activeWidget: CName;
  public let currentIndex: Int32;
  public let slots: array<CName>;
  public let available: array<ref<HUDitorCustomSlot>>;
  public let controllers: array<ref<HUDitorCustomSlot>>;
  public let overlay: ref<HUDitorOverlay>;
  public let surfaces: ref<HUDitorSurfaces>;
  public let presentations: array<wref<inkWidget>>;
  public let sceneTier: Int32;
  public let visionState: Int32;
  public let scannerBlocked: Bool;
  private let unlockListener: Uint32;
  private let delayId: DelayID;
  private let bindPending: Bool;
  private let phoneGeometryChanged: Bool;
  private let bindRequestId: Uint32;
  private let initialAttempts: Int32;

  private func Initialize(player: ref<PlayerPuppet>) -> Void {
    let config: ref<HUDitorConfig> = new HUDitorConfig();
    this.player = player;
    this.gameInstance = player.GetGame();
    this.currentIndex = -1;
    this.delayId = GetInvalidDelayID();
    if config.questTrackerEnabled { ArrayPush(this.slots, n"NewTracker"); }
    if config.minimapEnabled { ArrayPush(this.slots, n"NewMinimap"); }
    if config.wantedBarEnabled { ArrayPush(this.slots, n"NewWanted"); }
    if config.questNotificationsEnabled { ArrayPush(this.slots, n"NewQuestNotifications"); }
    if config.itemNotificationsEnabled { ArrayPush(this.slots, n"NewItemNotifications"); }
    if config.vehicleSummonEnabled { ArrayPush(this.slots, n"NewVehicleSummon"); }
    if config.weaponRosterEnabled { ArrayPush(this.slots, n"NewWeaponRoster"); }
    if config.crouchIndicatorEnabled { ArrayPush(this.slots, n"NewCrouchIndicator"); }
    if config.dpadEnabled { ArrayPush(this.slots, n"NewDpad"); }
    if config.playerHealthbarEnabled { ArrayPush(this.slots, n"NewHealthBar"); }
    if config.playerStaminabarEnabled { ArrayPush(this.slots, n"NewStaminaBar"); }
    if config.inputHintsEnabled { ArrayPush(this.slots, n"NewInputHint"); }
    if config.speedometerEnabled { ArrayPush(this.slots, n"NewCarHud"); }
    if config.autoDriveEnabled { ArrayPush(this.slots, n"NewAutoDrive"); }
    if config.crystalCoatEnabled { ArrayPush(this.slots, n"NewCrystalCoat"); }
    if config.vehicleRadioEnabled { ArrayPush(this.slots, n"NewVehicleRadio"); }
    if config.vehicleHotkeyEnabled { ArrayPush(this.slots, n"NewVehicleHotkey"); }
    if config.phoneHotkeyEnabled { ArrayPush(this.slots, n"NewPhoneHotkey"); }
    if config.incomingCallAvatarEnabled { ArrayPush(this.slots, n"NewPhoneAvatar"); }
    if config.incomingCallButtonEnabled { ArrayPush(this.slots, n"NewPhoneControl"); }
    if config.bossHealthbarEnabled { ArrayPush(this.slots, n"NewBossHealthbar"); }
    if config.dialogChoicesEnabled { ArrayPush(this.slots, n"NewDialogChoices"); }
    if config.dialogSubtitlesEnabled { ArrayPush(this.slots, n"NewDialogSubtitles"); }
    if config.progressWidgetEnabled { ArrayPush(this.slots, n"NewProgressBar"); }
    this.InitializeFpsCounter();
    this.unlockListener = GameInstance.GetQuestsSystem(this.gameInstance).RegisterListener(n"unlock_car_hud_dpad", this, n"OnHUDitorUnlock");
    this.RequestBind();
  }

  @if(ModuleExists("FpsCounter"))
  private func InitializeFpsCounter() -> Void {
    ArrayPush(this.slots, n"NewFpsCounter");
  }

  @if(!ModuleExists("FpsCounter"))
  private func InitializeFpsCounter() -> Void {}

  public static func CreateInstance(player: ref<PlayerPuppet>, hudGameController: ref<inkGameController>) -> ref<HUDWidgetsManager> {
    let previous: ref<HUDWidgetsManager> = HUDWidgetsManager.GetInstance();
    if IsDefined(previous) { previous.Dispose(); };
    let instance: ref<HUDWidgetsManager> = new HUDWidgetsManager();
    instance.uiController = hudGameController;
    player.hudWidgetsManager = instance;
    GetAllBlackboardDefs().hudWidgetsManager = instance;
    instance.Initialize(player);
    return instance;
  }

  public static func GetInstance() -> wref<HUDWidgetsManager> {
    return GetAllBlackboardDefs().hudWidgetsManager;
  }

  public func GetPlayerPuppet() -> wref<PlayerPuppet> { return this.player; }
  public func IsActive() -> Bool { return this.isActive && !this.disposed; }
  public func IsEnabled(name: CName) -> Bool { return !this.disposed && ArrayContains(this.slots, name); }

  public func FindSlot(name: CName) -> ref<HUDitorCustomSlot> {
    for slot in this.controllers {
      if Equals(slot.GetName(), name) { return slot; };
    };
    return null;
  }

  public func RegisterSlot(slot: ref<HUDitorCustomSlot>) -> Void {
    if !IsDefined(this.FindSlot(slot.GetName())) { ArrayPush(this.controllers, slot); };
  }

  public func RefreshAvailable() -> Void {
    if this.isActive { return; };
    let driving: Bool = VehicleComponent.IsDriver(this.gameInstance, this.player);
    ArrayClear(this.available);
    for name in this.slots {
      if !driving || NotEquals(name, n"NewVehicleHotkey") {
        let slot: ref<HUDitorCustomSlot> = this.FindSlot(name);
        if IsDefined(slot) && slot.IsReady() { ArrayPush(this.available, slot); };
      };
    };
    this.ready = ArraySize(this.available) > 0;
  }

  public func Select(index: Int32) -> Void {
    let count: Int32 = ArraySize(this.available);
    if !this.IsActive() || count == 0 { return; };
    if this.currentIndex >= 0 && this.currentIndex < count { this.available[this.currentIndex].SetSelected(false); };
    if index < 0 { index = count - 1; };
    if index >= count { index = 0; };
    this.currentIndex = index;
    this.activeWidget = this.available[index].GetName();
    this.available[index].SetSelected(true);
    this.overlay.Select(this.available[index]);
    if IsDefined(this.listener) { this.listener.ResetCursor(); };
  }

  public func SwitchToNextWidget() -> Void { this.Select(this.currentIndex + 1); }
  public func SwitchToPrevWidget() -> Void { this.Select(this.currentIndex - 1); }
  public func GetActiveWidget() -> CName { return this.activeWidget; }

  public func Begin() -> Bool {
    if this.disposed || this.isActive || ArraySize(this.slots) == 0 { return false; };
    this.Bind();
    this.RefreshAvailable();
    if !this.ready || !IsDefined(this.overlay) { this.RequestBind(); return false; };
    this.generation += 1u;
    this.isActive = true;
    for slot in this.available {
      slot.BeginPreview(this.generation);
    };
    this.currentIndex = -1;
    this.overlay.Show(true);
    this.Select(0);
    return true;
  }

  public func End() -> Void {
    if !this.isActive { return; };
    this.isActive = false;
    this.generation += 1u;
    this.RefreshPhoneLayout();
    for slot in this.controllers { slot.EndPreview(); };
    if IsDefined(this.overlay) { this.overlay.Show(false); };
    this.currentIndex = -1;
    this.activeWidget = n"";
    this.RequestBind();
  }

  public func UpdateContext() -> Void {
    for slot in this.controllers { slot.RefreshContext(); };
  }

  public func Reset() -> Void {
    for slot in this.controllers { slot.Reset(); };
    this.RefreshPhoneLayout();
  }

  public func RefreshPhoneLayout() -> Void {
    let indicator: ref<HUDitorCustomSlot> = this.FindSlot(n"NewPhoneHotkey");
    if !IsDefined(indicator) { return; };
    let vehicle: ref<HUDitorCustomSlot> = this.FindSlot(n"NewVehicleHotkey");
    let avatar: ref<HUDitorCustomSlot> = this.FindSlot(n"NewPhoneAvatar");
    let vehicleBinding: ref<HUDitorBinding>;
    if IsDefined(vehicle) { vehicleBinding = vehicle.FindBinding(); };
    let surface: ref<HUDitorSurface>;
    if IsDefined(vehicleBinding) && IsDefined(this.surfaces) { surface = this.surfaces.FindSurface(vehicleBinding); };
    for binding in indicator.GetBindings() {
      let layout: ref<HUDitorPhoneLayout> = binding.phoneLayout;
      if IsDefined(layout) && IsDefined(layout.phone) && IsDefined(layout.source) {
        layout.vehicle = vehicleBinding;
        layout.vehicleSurface = surface;
        if IsDefined(avatar) { layout.avatar = avatar.FindBinding(binding.owner); } else { layout.avatar = null; };
        layout.Refresh(this.phoneGeometryChanged);
      };
    };
    this.phoneGeometryChanged = false;
  }

  public func RequestPhoneGeometryRefresh() -> Void {
    this.phoneGeometryChanged = true;
    this.RequestBind();
  }

  protected cb func OnHUDitorUnlock(value: Int32) -> Bool {
    if value > 0 { this.RequestBind(); };
  }

  public func RequestBind() -> Void {
    if this.disposed || this.bindPending || ArraySize(this.slots) == 0 { return; };
    if GameInstance.GetQuestsSystem(this.gameInstance).GetFact(n"unlock_car_hud_dpad") <= 0 { return; };
    let callback: ref<HUDitorDelayedInitCallback> = new HUDitorDelayedInitCallback();
    callback.manager = this;
    this.bindRequestId += 1u;
    callback.requestId = this.bindRequestId;
    this.bindPending = true;
    this.delayId = GameInstance.GetDelaySystem(this.gameInstance).DelayCallback(callback, 0.1, false);
  }

  public func QueueBind(requestId: Uint32) -> Void {
    if this.disposed || !this.bindPending || requestId != this.bindRequestId || !IsDefined(this.uiController) { return; };
    let evt: ref<HUDitorBindEvent> = new HUDitorBindEvent();
    evt.manager = this;
    evt.requestId = requestId;
    this.uiController.QueueEvent(evt);
  }

  public func ApplyBind(requestId: Uint32) -> Void {
    if this.disposed || !this.bindPending || requestId != this.bindRequestId { return; };
    this.Bind();
  }

  public func Bind() -> Void {
    GameInstance.GetDelaySystem(this.gameInstance).CancelCallback(this.delayId);
    this.bindPending = false;
    this.bindRequestId += 1u;
    this.delayId = GetInvalidDelayID();
    if this.disposed || this.isActive { return; };
    HUDitorBindings.Discover(this);
    this.RefreshAvailable();
    this.initialAttempts += 1;
    if !this.ready && this.initialAttempts < 20 { this.RequestBind(); };
  }

  public func Dispose() -> Void {
    if this.disposed { return; };
    if IsDefined(this.listener) { this.listener.Close(); } else { this.End(); };
    if IsDefined(this.player) && IsDefined(this.listener) { this.player.UnregisterInputListener(this.listener); };
    this.disposed = true;
    this.generation += 1u;
    GameInstance.GetDelaySystem(this.gameInstance).CancelCallback(this.delayId);
    this.delayId = GetInvalidDelayID();
    this.bindPending = false;
    GameInstance.GetQuestsSystem(this.gameInstance).UnregisterListener(n"unlock_car_hud_dpad", this.unlockListener);
    for slot in this.controllers { slot.Dispose(); };
    ArrayClear(this.controllers);
    ArrayClear(this.available);
    if IsDefined(this.surfaces) { this.surfaces.Dispose(); };
    this.surfaces = null;
    if IsDefined(this.overlay) { this.overlay.Dispose(); };
    this.overlay = null;
    this.ready = false;
    if IsDefined(this.player) && this.player.hudWidgetsManager == this { this.player.hudWidgetsManager = null; };
    if GetAllBlackboardDefs().hudWidgetsManager == this { GetAllBlackboardDefs().hudWidgetsManager = null; };
  }
}
