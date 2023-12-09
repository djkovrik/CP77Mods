module LimitedHudCommon

// --- FIELDS AND TYPES

// Visibility condition event types
enum LHUDEventType {
  GlobalHotkey = 1,
  MinimapHotkey = 2,
  Braindance = 3,
  Combat = 4,
  OutOfCombat = 5,
  Stealth = 6,
  Scanner = 7,
  InVehicle = 8,
  Weapon = 9,
  Zoom = 10,
  Refresh = 11,
  ForceVisibility = 12,
  Metro = 13,
}

enum LHUDFillColors {
  Transparent = 0,
  LightYellow = 1,
  LightBlue = 2,
  White = 3,
  LightGreen = 4,
  Blue = 5,
  Orange = 6,
  Red = 7,
}

enum LHUDOutlineColors {
  Transparent = 0,
  LightGreen = 1,
  Red = 2,
  LightBlue = 3,
  LightRed = 4,
  LightYellow = 5,
  Blue = 6,
  White = 7,
}

enum LHUDRicochetColors {
  Transparent = 0,
  Green = 1,
  Red = 2,
}

enum LHUDArrowAndHpAppearance {
  Red = 0,
  Orange = 1,
  Green = 2,
  Blue = 3,
  White = 4,
  Transparent = 5,
}

enum LHUDDamagePreviewColors {
  Red = 0,
  Orange = 1,
  Green = 2,
  Blue = 3,
  Black = 4,
  White = 5,
}

// Basic visibility condition event
public class LHUDEvent extends Event {
  public let isActive: Bool;
  public let type: LHUDEventType;
}

// Basic event for delayed startup logic triggering 
public class LHUDInitLaunchEvent extends Event {}

public class LHUDConfigUpdatedEvent extends Event {}

public class LHUDStealthRunnerRefreshed extends Event {}

// Blackboard flags for global and minimap toggles
@addField(UI_SystemDef) public let IsGlobalFlagToggled_LHUD: BlackboardID_Bool;
@addField(UI_SystemDef) public let IsMinimapToggled_LHUD: BlackboardID_Bool;
@addField(UI_SystemDef) public let IsInMetro_LHUD: BlackboardID_Bool;

// Visibility condition flags for inkGameController instances
@addField(inkGameController) public let lhud_isVisibilityForced: Bool;
@addField(inkGameController) public let lhud_isGlobalFlagToggled: Bool;
@addField(inkGameController) public let lhud_isMinimapFlagToggled: Bool;
@addField(inkGameController) public let lhud_isBraindanceActive: Bool;
@addField(inkGameController) public let lhud_isCombatActive: Bool;
@addField(inkGameController) public let lhud_isOutOfCombatActive: Bool;
@addField(inkGameController) public let lhud_isStealthActive: Bool;
@addField(inkGameController) public let lhud_isScannerActive: Bool;
@addField(inkGameController) public let lhud_isInVehicle: Bool;
@addField(inkGameController) public let lhud_isWeaponUnsheathed: Bool;
@addField(inkGameController) public let lhud_isZoomActive: Bool;
@addField(inkGameController) public let lhud_isInMetro: Bool;
@addField(inkGameController) public let lhud_isVisibleNow: Bool;

// Visibility condition flags for inkLogicController instances
@addField(inkLogicController) public let lhud_isVisibilityForced: Bool;
@addField(inkLogicController) public let lhud_isGlobalFlagToggled: Bool;
@addField(inkLogicController) public let lhud_isBraindanceActive: Bool;
@addField(inkLogicController) public let lhud_isCombatActive: Bool;
@addField(inkLogicController) public let lhud_isOutOfCombatActive: Bool;
@addField(inkLogicController) public let lhud_isStealthActive: Bool;
@addField(inkLogicController) public let lhud_isScannerActive: Bool;
@addField(inkLogicController) public let lhud_isInVehicle: Bool;
@addField(inkLogicController) public let lhud_isWeaponUnsheathed: Bool;
@addField(inkLogicController) public let lhud_isZoomActive: Bool;
@addField(inkLogicController) public let lhud_isVisibleNow: Bool;

// Store actual flags in AllBlackboardDefinitions
@addField(AllBlackboardDefinitions) public let lhud_isVisibilityForced: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isGlobalFlagToggled: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isBraindanceActive: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isCombatActive: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isOutOfCombatActive: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isStealthActive: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isScannerActive: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isInVehicle: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isWeaponUnsheathed: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isZoomActive: Bool;
@addField(AllBlackboardDefinitions) public let lhud_isVisibleNow: Bool;

// Catch LHUDEvent inside inkGameController instances
@addMethod(inkGameController)
protected func ConsumeLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  LHUDLogDebug(s" <- \(this.GetClassName()) consume event: " + ToString(evt.type) + " " + ToString(evt.isActive));
  switch(evt.type) {
    case LHUDEventType.GlobalHotkey: 
      this.lhud_isGlobalFlagToggled = evt.isActive;
      break;
    case LHUDEventType.MinimapHotkey: 
      this.lhud_isMinimapFlagToggled = evt.isActive;
      break;
    case LHUDEventType.Braindance: 
      this.lhud_isBraindanceActive = evt.isActive;
      break;
    case LHUDEventType.Combat: 
      this.lhud_isCombatActive = evt.isActive;
      // this.lhud_isOutOfCombatActive = false;
      // this.lhud_isStealthActive = false;
      break;
    case LHUDEventType.OutOfCombat: 
      this.lhud_isOutOfCombatActive = evt.isActive;
      // this.lhud_isCombatActive = false;
      // this.lhud_isStealthActive = false;
      break;
    case LHUDEventType.Stealth: 
      this.lhud_isStealthActive = evt.isActive;
      // this.lhud_isCombatActive = false;
      // this.lhud_isOutOfCombatActive = false;
      break; 
    case LHUDEventType.Scanner: 
      this.lhud_isScannerActive = evt.isActive;
      break;
    case LHUDEventType.InVehicle: 
      this.lhud_isInVehicle = evt.isActive;
      break;
    case LHUDEventType.Weapon: 
      this.lhud_isWeaponUnsheathed = evt.isActive;
      break;
    case LHUDEventType.Zoom: 
      this.lhud_isZoomActive = evt.isActive;
      break;
    case LHUDEventType.Metro:
      this.lhud_isInMetro = evt.isActive;
      break;
    case LHUDEventType.ForceVisibility:
      this.lhud_isVisibilityForced = evt.isActive;
      break;
    default:
      break;
  };
}

// Catch LHUDEvent inside inkLogicController instances
@addMethod(inkLogicController)
protected func ConsumeLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  LHUDLogDebug(s" <- \(this.GetClassName()) consume event: " + ToString(evt.type) + " " + ToString(evt.isActive));
  switch(evt.type) {
    case LHUDEventType.GlobalHotkey: 
      this.lhud_isGlobalFlagToggled = evt.isActive;
      break;
    case LHUDEventType.Braindance: 
      this.lhud_isBraindanceActive = evt.isActive;
      break;
    case LHUDEventType.Combat: 
      this.lhud_isCombatActive = evt.isActive;
      // this.lhud_isOutOfCombatActive = false;
      // this.lhud_isStealthActive = false;
      break;
    case LHUDEventType.OutOfCombat: 
      this.lhud_isOutOfCombatActive = evt.isActive;
      // this.lhud_isCombatActive = false;
      // this.lhud_isStealthActive = false;
      break;
    case LHUDEventType.Stealth:
      this.lhud_isStealthActive = evt.isActive;
      // this.lhud_isCombatActive = false;
      // this.lhud_isOutOfCombatActive = false;
      break; 
    case LHUDEventType.Scanner: 
      this.lhud_isScannerActive = evt.isActive;
      break;
    case LHUDEventType.InVehicle: 
      this.lhud_isInVehicle = evt.isActive;
      break;
    case LHUDEventType.Weapon: 
      this.lhud_isWeaponUnsheathed = evt.isActive;
      break;
    case LHUDEventType.Zoom: 
      this.lhud_isZoomActive = evt.isActive;
      break;
    case LHUDEventType.ForceVisibility:
      this.lhud_isVisibilityForced = evt.isActive;
      break;
    default:
      break;
  };
  GetAllBlackboardDefs().ConsumeLHUDEvent(evt);
}


// Pass LHUDEvent to AllBlackboardDefinitions
@addMethod(AllBlackboardDefinitions)
protected func ConsumeLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  LHUDLogDebug(s" <- \(this.GetClassName()) consume event: " + ToString(evt.type) + " " + ToString(evt.isActive));
  switch(evt.type) {
    case LHUDEventType.GlobalHotkey: 
      this.lhud_isGlobalFlagToggled = evt.isActive;
      break;
    case LHUDEventType.Braindance: 
      this.lhud_isBraindanceActive = evt.isActive;
      break;
    case LHUDEventType.Combat: 
      this.lhud_isCombatActive = evt.isActive;
      // this.lhud_isOutOfCombatActive = false;
      // this.lhud_isStealthActive = false;
      break;
    case LHUDEventType.OutOfCombat: 
      this.lhud_isOutOfCombatActive = evt.isActive;
      // this.lhud_isCombatActive = false;
      // this.lhud_isStealthActive = false;
      break;
    case LHUDEventType.Stealth: 
      this.lhud_isStealthActive = evt.isActive;
      // this.lhud_isCombatActive = false;
      // this.lhud_isOutOfCombatActive = false;
      break; 
    case LHUDEventType.Scanner: 
      this.lhud_isScannerActive = evt.isActive;
      break;
    case LHUDEventType.InVehicle: 
      this.lhud_isInVehicle = evt.isActive;
      break;
    case LHUDEventType.Weapon: 
      this.lhud_isWeaponUnsheathed = evt.isActive;
      break;
    case LHUDEventType.Zoom: 
      this.lhud_isZoomActive = evt.isActive;
      break;
    case LHUDEventType.ForceVisibility:
      this.lhud_isVisibilityForced = evt.isActive;
      break;
    default:
      break;
  };
}

@addMethod(inkLogicController)
public func FetchInitialStateFlags() -> Void {
  this.lhud_isVisibilityForced = GetAllBlackboardDefs().lhud_isVisibilityForced;
  this.lhud_isGlobalFlagToggled = GetAllBlackboardDefs().lhud_isGlobalFlagToggled;
  this.lhud_isBraindanceActive = GetAllBlackboardDefs().lhud_isBraindanceActive;
  this.lhud_isCombatActive = GetAllBlackboardDefs().lhud_isCombatActive;
  this.lhud_isOutOfCombatActive = GetAllBlackboardDefs().lhud_isOutOfCombatActive;
  this.lhud_isStealthActive = GetAllBlackboardDefs().lhud_isStealthActive;
  this.lhud_isScannerActive = GetAllBlackboardDefs().lhud_isScannerActive;
  this.lhud_isInVehicle = GetAllBlackboardDefs().lhud_isInVehicle;
  this.lhud_isWeaponUnsheathed = GetAllBlackboardDefs().lhud_isWeaponUnsheathed;
  this.lhud_isZoomActive = GetAllBlackboardDefs().lhud_isZoomActive;
  this.lhud_isVisibleNow = GetAllBlackboardDefs().lhud_isVisibleNow;
}

// Swap top right slot child order for braindance mode
@if(ModuleExists("HUDrag.HUDWidgetsManager"))
func SwapChildrenLHUD(evt: ref<LHUDEvent>, slot: ref<inkCompoundWidget>) -> Void {
    // do nothing
}

@if(!ModuleExists("HUDrag.HUDWidgetsManager"))
func SwapChildrenLHUD(evt: ref<LHUDEvent>, root: ref<inkCompoundWidget>) -> Void {
  let slot: ref<inkCompoundWidget> = root.GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight")) as inkCompoundWidget;
  if evt.isActive {
    slot.SetChildOrder(inkEChildOrder.Backward);
  } else {
    slot.SetChildOrder(inkEChildOrder.Forward);
  };
}

@addMethod(inkGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  if this.IsA(n"gameuiRootHudGameController") && Equals(evt.type, LHUDEventType.Braindance) {
    SwapChildrenLHUD(evt, this.GetRootCompoundWidget());
  };
}

// Restore HUD on camera control disable
@wrapMethod(TakeOverControlSystem)
private final const func EnablePlayerTPPRepresenation(enable: Bool) -> Void {
  wrappedMethod(enable);
  let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  if !enable && IsDefined(playerPuppet) {
    GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayEvent(playerPuppet, new LHUDInitLaunchEvent(), 2.0);
  };
}

// --- UTILITY FUNCTIONS

// Broadcast LHUD event
@addMethod(PlayerPuppet)
public func QueueLHUDEvent(type: LHUDEventType, active: Bool) -> Void {
  let evt: ref<LHUDEvent> = new LHUDEvent();
  evt.type = type;
  evt.isActive = active;
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(evt);
  LHUDLogDebug(" -> Queue event: " + ToString(type) + " " + ToString(active));
}

// Check if player has any weapon equipped
@addMethod(PlayerPuppet)
public func HasAnyWeaponEquipped_LHUD() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  let weaponId: ItemID;
  if IsDefined(weapon) {
    weaponId = weapon.GetItemID();
    if transactionSystem.HasTag(this, WeaponObject.GetMeleeWeaponTag(), weaponId) 
      || transactionSystem.HasTag(this, WeaponObject.GetOneHandedRangedWeaponTag(), weaponId)
      || transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weaponId)
      || WeaponObject.IsFists(weaponId) 
      || WeaponObject.IsCyberwareWeapon(weaponId) {
        return true;
    };
  };
  return false;
}

// Send config refreshing event
@wrapMethod(PauseMenuBackgroundGameController)
protected cb func OnUninitialize() -> Bool {
  GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(new LHUDConfigUpdatedEvent());
  wrappedMethod();
}

public static func LHUDLogMarker(str: String) -> Void {
  // LogChannel(n"DEBUG", "LHUD: " + str);
}

public static func LHUDLogDebug(str: String) -> Void {
  // LogChannel(n"DEBUG", "LHUD: " + str);
}
