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
}

// Basic visibility condition event
public class LHUDEvent extends Event {
  public let isActive: Bool;
  public let type: LHUDEventType;
}

// Blackboard flags for global and minimap toggles
@addField(UI_SystemDef) public let IsGlobalFlagToggled_LHUD: BlackboardID_Bool;
@addField(UI_SystemDef) public let IsMinimapToggled_LHUD: BlackboardID_Bool;

// Visibility condition flags for inkGameController instances
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
@addField(inkGameController) public let lhud_isVisibleNow: Bool;

// Visibility condition flags for inkLogicController instances
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

// Catch LHUDEvent inside inkGameController instances
@addMethod(inkGameController)
protected func ConsumeLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  LHUDLog(" <- inkGameController consume event: " + ToString(evt.type) + " " + ToString(evt.isActive));
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
    default:
      break;
  };
}

// Catch LHUDEvent inside inkLogicController instances
@addMethod(inkLogicController)
protected func ConsumeLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  LHUDLog(" <- inkLogicController consume event: " + ToString(evt.type) + " " + ToString(evt.isActive));
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
    default:
      break;
  };
}

// Swap top right slot child order for braindance mode
@addMethod(inkGameController)
protected cb func OnLHUDEvent(evt: ref<LHUDEvent>) -> Void {
  if this.IsA(n"gameuiRootHudGameController") && Equals(evt.type, LHUDEventType.Braindance) {
    let slot: ref<inkCompoundWidget> = this.GetRootCompoundWidget().GetWidgetByPath(inkWidgetPath.Build(n"TopRightMain", n"TopRight")) as inkCompoundWidget;
    if evt.isActive {
      slot.SetChildOrder(inkEChildOrder.Backward);
    } else {
      slot.SetChildOrder(inkEChildOrder.Forward);
    };
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
  LHUDLog(" -> Queue event: " + ToString(type) + " " + ToString(active));
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

// Print string to CET console
public static func LHUDLog(str: String) -> Void {
  // LogChannel(n"DEBUG", "LHUD: " + str);
}
