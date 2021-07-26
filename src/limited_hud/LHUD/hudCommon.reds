module LimitedHudCommon

// --- Common field declarations
@addField(UI_SystemDef)
public let IsGlobalFlagToggled_LHUD: BlackboardID_Bool;

@addField(UI_SystemDef)
public let IsMinimapToggled_LHUD: BlackboardID_Bool;

@addField(inkGameController)
public let m_isGlobalFlagToggled_LHUD: Bool;

@addField(inkGameController)
public let m_isMinimapToggled_LHUD: Bool;

@addField(inkGameController)
public let m_playerPuppet_LHUD: wref<PlayerPuppet>;

// --- Common blackboard declarations
@addField(inkGameController)
public let m_braindanceBlackboard_LHUD: wref<IBlackboard>;

@addField(inkGameController)
public let m_playerStateMachineBlackboard_LHUD: wref<IBlackboard>;

@addField(inkGameController)
public let m_scannerBlackboard_LHUD: wref<IBlackboard>;

@addField(inkGameController)
public let m_systemBlackboard_LHUD: wref<IBlackboard>;

@addField(inkGameController)
public let m_vehicleBlackboard_LHUD: wref<IBlackboard>;

@addField(inkGameController)
public let m_weaponBlackboard_LHUD: wref<IBlackboard>;


// --- Common callback declarations
@addField(inkGameController)
public let m_braindanceTrackingCallback_LHUD: Uint32;

@addField(inkGameController)
public let m_combatTrackingCallback_LHUD: Uint32;

@addField(inkGameController)
public let m_globalFlagCallback_LHUD: Uint32;

@addField(inkGameController)
public let m_minimapToggleCallback_LHUD: Uint32;

@addField(inkGameController)
public let m_scannerTrackingCallback_LHUD: Uint32;

@addField(inkGameController)
public let m_vehicleTrackingCallback_LHUD: Uint32;

@addField(inkGameController)
public let m_weaponTrackingCallback_LHUD: Uint32;

@addField(inkGameController)
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


// --- Common overrides

// Register for hokey actions
@wrapMethod(HUDManager)
protected final func RegisterToInput() -> Void {
  wrappedMethod();
  this.GetPlayer().RegisterInputListener(this, n"ToggleGlobal");
  this.GetPlayer().RegisterInputListener(this, n"ToggleMinimap");
}

// Fire toggle events here
@wrapMethod(HUDManager)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  wrappedMethod(action, consumer);

  let actionName: CName = ListenerAction.GetName(action);
  let isToggled: Bool;
  if Equals(actionName, n"ToggleGlobal") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
    LHUDLog("Toggle global hotkey pressed");
    isToggled = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD);
    GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsGlobalFlagToggled_LHUD, !isToggled, true);
  };

  if Equals(actionName, n"ToggleMinimap") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
    LHUDLog("Toggle minimap hotkey pressed");
    isToggled = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).GetBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD);
    GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_System).SetBool(GetAllBlackboardDefs().UI_System.IsMinimapToggled_LHUD, !isToggled, true);
  };
}

// -- UTILS
public static func LHUDLog(str: String) -> Void {
  Log("LHUD: " + str);
}
