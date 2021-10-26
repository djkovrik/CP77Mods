module LimitedHudCommon

// --- FIELDS AND TYPES

// Event type for visibility condition events
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
  public let m_isActive: Bool;
  public let m_type: LHUDEventType;
}

// Visibility condition flags for inkGameController instances
@addField(inkGameController) public let l_isGlobalFlagToggled: Bool;
@addField(inkGameController) public let l_isMinimapFlagToggled: Bool;
@addField(inkGameController) public let l_isBraindanceActive: Bool;
@addField(inkGameController) public let l_isCombatActive: Bool;
@addField(inkGameController) public let l_isOutOfCombatActive: Bool;
@addField(inkGameController) public let l_isStealthActive: Bool;
@addField(inkGameController) public let l_isScannerActive: Bool;
@addField(inkGameController) public let l_isInVehicle: Bool;
@addField(inkGameController) public let l_isWeaponUnsheathed: Bool;
@addField(inkGameController) public let l_isZoomActive: Bool;
@addField(inkGameController) public let l_isVisibleNow: Bool;

// Visibility condition flags for inkLogicController instances
@addField(inkLogicController) public let l_isGlobalFlagToggled: Bool;
@addField(inkLogicController) public let l_isMinimapFlagToggled: Bool;
@addField(inkLogicController) public let l_isBraindanceActive: Bool;
@addField(inkLogicController) public let l_isCombatActive: Bool;
@addField(inkLogicController) public let l_isOutOfCombatActive: Bool;
@addField(inkLogicController) public let l_isStealthActive: Bool;
@addField(inkLogicController) public let l_isScannerActive: Bool;
@addField(inkLogicController) public let l_isInVehicle: Bool;
@addField(inkLogicController) public let l_isWeaponUnsheathed: Bool;
@addField(inkLogicController) public let l_isZoomActive: Bool;
@addField(inkLogicController) public let l_isVisibleNow: Bool;

// Catch LHUDEvent inside inkGameController instances
@addMethod(inkGameController)
protected func ConsumeEvent(evt: ref<LHUDEvent>) -> Void {
  // LHUDLog("ConsumeEvent " + ToString(evt.m_type) + " " + ToString(evt.m_isActive));
  switch(evt.m_type) {
    case LHUDEventType.GlobalHotkey: 
      this.l_isGlobalFlagToggled = !this.l_isGlobalFlagToggled;
      break;
    case LHUDEventType.MinimapHotkey: 
      this.l_isMinimapFlagToggled = !this.l_isMinimapFlagToggled;
      break;
    case LHUDEventType.Braindance: 
      this.l_isBraindanceActive = evt.m_isActive;
      break;
    case LHUDEventType.Combat: 
      this.l_isCombatActive = evt.m_isActive;
      this.l_isOutOfCombatActive = false;
      this.l_isStealthActive = false;
      break;
    case LHUDEventType.OutOfCombat: 
      this.l_isCombatActive = false;
      this.l_isOutOfCombatActive = evt.m_isActive;
      this.l_isStealthActive = false;
      break;
    case LHUDEventType.Stealth: 
      this.l_isCombatActive = false;
      this.l_isOutOfCombatActive = false;
      this.l_isStealthActive = evt.m_isActive;
      break; 
    case LHUDEventType.Scanner: 
      this.l_isScannerActive = evt.m_isActive;
      break;
    case LHUDEventType.InVehicle: 
      this.l_isInVehicle = evt.m_isActive;
      break;
    case LHUDEventType.Weapon: 
      this.l_isWeaponUnsheathed = evt.m_isActive;
      break;
    case LHUDEventType.Zoom: 
      this.l_isZoomActive = evt.m_isActive;
      break;
    default:
      break;
  };
}

// Catch LHUDEvent inside inkLogicController instances
@addMethod(inkLogicController)
protected func ConsumeEvent(evt: ref<LHUDEvent>) -> Void {
  // LHUDLog("ConsumeEvent " + ToString(evt.m_type) + " " + ToString(evt.m_isActive));
  switch(evt.m_type) {
    case LHUDEventType.GlobalHotkey: 
      this.l_isGlobalFlagToggled = !this.l_isGlobalFlagToggled;
      break;
    case LHUDEventType.MinimapHotkey: 
      this.l_isMinimapFlagToggled = !this.l_isMinimapFlagToggled;
      break;
    case LHUDEventType.Braindance: 
      this.l_isBraindanceActive = evt.m_isActive;
      break;
    case LHUDEventType.Combat: 
      this.l_isCombatActive = evt.m_isActive;
      this.l_isOutOfCombatActive = false;
      this.l_isStealthActive = false;
      break;
    case LHUDEventType.OutOfCombat: 
      this.l_isCombatActive = false;
      this.l_isOutOfCombatActive = evt.m_isActive;
      this.l_isStealthActive = false;
      break;
    case LHUDEventType.Stealth: 
      this.l_isCombatActive = false;
      this.l_isOutOfCombatActive = false;
      this.l_isStealthActive = evt.m_isActive;
      break; 
    case LHUDEventType.Scanner: 
      this.l_isScannerActive = evt.m_isActive;
      break;
    case LHUDEventType.InVehicle: 
      this.l_isInVehicle = evt.m_isActive;
      break;
    case LHUDEventType.Weapon: 
      this.l_isWeaponUnsheathed = evt.m_isActive;
      break;
    case LHUDEventType.Zoom: 
      this.l_isZoomActive = evt.m_isActive;
      break;
    default:
      break;
  };
}

// --- UTILITY FUNCTIONS

// Send LHUD event with player instance
@addMethod(PlayerPuppet)
public func QueueEvent(type: LHUDEventType, active: Bool) -> Void {
  let evt: ref<LHUDEvent> = new LHUDEvent();
  evt.m_type = type;
  evt.m_isActive = active;
  GameInstance.GetUISystem(this.GetGame()).QueueEvent(evt);
  // LHUDLog("Queue event " + ToString(type) + " " + ToString(active));
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
      || transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weaponId) {
        return true;
    };
  };
  return false;
}

// Print debug str to CET console
public static func LHUDLog(str: String) -> Void {
  LogChannel(n"DEBUG", "LHUD: " + str);
}
