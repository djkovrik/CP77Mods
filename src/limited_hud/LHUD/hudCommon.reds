module LimitedHudCommon

// --- Common fields declarations
@addField(inkHUDGameController)
public let m_playerPuppet_LHUD: wref<PlayerPuppet>;

// --- Common blackboard declarations
@addField(inkHUDGameController)
public let m_playerStateMachineBlackboard_LHUD: wref<IBlackboard>;

@addField(inkHUDGameController)
public let m_scannerBlackboard_LHUD: wref<IBlackboard>;

@addField(inkHUDGameController)
public let m_vehicleBlackboard_LHUD: wref<IBlackboard>;

@addField(inkHUDGameController)
public let m_weaponBlackboard_LHUD: wref<IBlackboard>;


// --- Common callback declarations
@addField(inkHUDGameController)
public let m_combatTrackingCallback_LHUD: Uint32;

@addField(inkHUDGameController)
public let m_scannerTrackingCallback_LHUD: Uint32;

@addField(inkHUDGameController)
public let m_vehicleTrackingCallback_LHUD: Uint32;

@addField(inkHUDGameController)
public let m_weaponTrackingCallback_LHUD: Uint32;

@addField(inkHUDGameController)
public let m_zoomTrackingCallback_LHUD: Uint32;


// --- Common funcs
@addMethod(PlayerPuppet)
public func HasAnyWeaponEquipped_LHUD() -> Bool {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this, t"AttachmentSlots.WeaponRight") as WeaponObject;
  if IsDefined(weapon) {
    if transactionSystem.HasTag(this, WeaponObject.GetMeleeWeaponTag(), weapon.GetItemID()) 
      || transactionSystem.HasTag(this, WeaponObject.GetRangedWeaponTag(), weapon.GetItemID()) {
        return true;
    };
  };
  return false;
}


// -- UTILS
public static func LHUDLog(str: String) -> Void {
  Log("LHUD: " + str);
}