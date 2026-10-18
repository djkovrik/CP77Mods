@if(ModuleExists("AlwaysFirstEquip"))
import AlwaysFirstEquip.*

@addField(PlayerPuppet)
public let wePsychosisCombatEquipmentContext: wref<StateContext>;

@addField(PlayerPuppet)
public let wePsychosisDrawOwner: wref<WEPsychosisCombat>;

@addField(PlayerPuppet)
public let wePsychosisCombat: wref<WEPsychosisCombat>;

@addField(WeaponObject)
public let wePsychosisCombatWeaponContext: wref<StateContext>;

@addField(WeaponObject)
public let wePsychosisCombatWeaponInterface: wref<StateGameScriptInterface>;

@addField(WeaponObject)
public let wePsychosisCombatWeaponMachine: CName;

@addField(WeaponEventsTransition)
public const let stateMachineInstanceData: StateMachineInstanceData;

@addField(WeaponObject)
public let wePsychosisCombatWeaponReference: CName;

@wrapMethod(WeaponEventsTransition)
protected func OnAttach(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let weapon: ref<WeaponObject> = scriptInterface.owner as WeaponObject;
  if IsDefined(weapon) && IsDefined(scriptInterface.executionOwner as PlayerPuppet) {
    weapon.wePsychosisCombatWeaponContext = stateContext;
    weapon.wePsychosisCombatWeaponInterface = scriptInterface;
    weapon.wePsychosisCombatWeaponMachine = this.GetStateMachineName();
    weapon.wePsychosisCombatWeaponReference = this.stateMachineInstanceData.referenceName;
  };
}

@addMethod(WeaponObject)
public func WEPsychosisCombatCanStopFire(player: ref<PlayerPuppet>) -> Bool {
  return this.IsAttached() && IsDefined(this.wePsychosisCombatWeaponInterface)
    && this.wePsychosisCombatWeaponInterface.owner == this
    && this.wePsychosisCombatWeaponInterface.executionOwner == player;
}

@wrapMethod(ReadyEvents)
protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let weapon: ref<WeaponObject> = scriptInterface.owner as WeaponObject;
  if IsDefined(player) && IsDefined(weapon) && IsDefined(player.wePsychosisCombat) {
    player.wePsychosisCombat.OnReadyAimUpdate(player, weapon, scriptInterface);
  };
}

@wrapMethod(ReadyEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let weapon: ref<WeaponObject> = scriptInterface.owner as WeaponObject;
  if IsDefined(weapon) && IsDefined(scriptInterface.executionOwner as PlayerPuppet) { weapon.wePsychosisCombatWeaponInterface = scriptInterface; };
}

@wrapMethod(PublicSafeEvents)
protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let weapon: ref<WeaponObject> = scriptInterface.owner as WeaponObject;
  if IsDefined(weapon) && IsDefined(scriptInterface.executionOwner as PlayerPuppet) { weapon.wePsychosisCombatWeaponInterface = scriptInterface; };
}

@addMethod(WeaponObject)
public func WEPsychosisCombatStopDiagnostic(player: ref<PlayerPuppet>) -> String {
  let bridge: ref<StateGameScriptInterface> = this.wePsychosisCombatWeaponInterface;
  if !IsDefined(bridge) { return "stopInterface=missing"; };
  return s"stopInterface=present stopOwnerMatch=\(bridge.owner == this) stopPlayerMatch=\(bridge.executionOwner == player)";
}

@addMethod(WeaponObject)
public func WEPsychosisCombatStopFire(player: ref<PlayerPuppet>) -> Bool {
  if !this.WEPsychosisCombatCanStopFire(player) { return false; };
  return this.wePsychosisCombatWeaponInterface.TEMP_WeaponStopFiring();
}

@addMethod(WeaponObject)
public func WEPsychosisCombatState() -> CName {
  if !IsDefined(this.wePsychosisCombatWeaponContext) || !IsNameValid(this.wePsychosisCombatWeaponMachine) { return n"unavailable"; };
  if !IsNameValid(this.wePsychosisCombatWeaponReference) { return n"instance_unavailable"; };
  let identifier: StateMachineIdentifier;
  identifier.definitionName = this.wePsychosisCombatWeaponMachine;
  identifier.referenceName = this.wePsychosisCombatWeaponReference;
  return this.wePsychosisCombatWeaponContext.GetStateMachineCurrentStateWithIdentifier(identifier);
}

@addMethod(WeaponObject)
public func WEPsychosisCombatStateDiagnostic() -> String {
  if !IsDefined(this.wePsychosisCombatWeaponContext) { return "context=unavailable"; };
  let identifier: StateMachineIdentifier;
  identifier.definitionName = this.wePsychosisCombatWeaponMachine;
  identifier.referenceName = this.wePsychosisCombatWeaponReference;
  return s"reference=\(identifier.referenceName) byName=\(this.wePsychosisCombatWeaponContext.GetStateMachineCurrentState(identifier.definitionName)) instanceActive=\(this.wePsychosisCombatWeaponContext.IsStateMachineActiveWithIdentifier(identifier)) byIdentifier=\(this.wePsychosisCombatWeaponContext.GetStateMachineCurrentStateWithIdentifier(identifier))";
}

@wrapMethod(PublicSafeDecisions)
protected final const func ToPublicSafeToReady(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
  let original: Bool = wrappedMethod(stateContext, scriptInterface);
  if original { return true; };
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if !IsDefined(player) || !IsDefined(player.wePsychosisCombat) { return false; };
  let weapon: ref<WeaponObject> = scriptInterface.owner as WeaponObject;
  if !player.wePsychosisCombat.HasPublicSafeRequest(weapon) { return false; };
  if this.IsSafeStateForced(stateContext, scriptInterface) || !this.IsWeaponReadyToShoot(stateContext, scriptInterface) { return false; };
  return player.wePsychosisCombat.AcceptPublicSafeRequest(player, weapon);
}

@wrapMethod(EquippedEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  if IsDefined(player) && Equals(this.stateMachineInstanceData.referenceName, n"RightHand") {
    player.wePsychosisCombatEquipmentContext = stateContext;
  };
}

public class WEPsychosisCombatEquipCompatibility {
  @if(ModuleExists("AlwaysFirstEquip"))
  public static func Begin(player: ref<PlayerPuppet>, bb: ref<IBlackboard>) -> Bool {
    let previous: Bool = player.ShouldSkipFirstEquipEQ();
    player.SetSkipFirstEquipEQ(true);
    return previous;
  }

  @if(ModuleExists("AlwaysFirstEquip"))
  public static func End(player: ref<PlayerPuppet>, bb: ref<IBlackboard>, previous: Bool) -> Void {
    player.SetSkipFirstEquipEQ(previous);
  }

  @if(!ModuleExists("AlwaysFirstEquip"))
  public static func Begin(player: ref<PlayerPuppet>, bb: ref<IBlackboard>) -> Bool {
    let previous: Bool = bb.GetBool(GetAllBlackboardDefs().PlayerStateMachine.ScenePreventFirstEquip);
    bb.SetBool(GetAllBlackboardDefs().PlayerStateMachine.ScenePreventFirstEquip, true);
    return previous;
  }

  @if(!ModuleExists("AlwaysFirstEquip"))
  public static func End(player: ref<PlayerPuppet>, bb: ref<IBlackboard>, previous: Bool) -> Void {
    bb.SetBool(GetAllBlackboardDefs().PlayerStateMachine.ScenePreventFirstEquip, previous);
  }
}

@wrapMethod(EquipmentBaseTransition)
protected final const func HandleWeaponEquip(scriptInterface: ref<StateGameScriptInterface>, stateContext: ref<StateContext>, stateMachineInstanceData: StateMachineInstanceData, item: ItemID) -> Void {
  let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
  let skip: Bool = IsDefined(player) && Equals(stateMachineInstanceData.referenceName, n"RightHand")
    && IsDefined(player.wePsychosisDrawOwner) && player.wePsychosisDrawOwner.ClaimFirstEquipSkip(player, item);
  let previous: Bool;
  if skip {
    player.wePsychosisDrawOwner = null;
    previous = WEPsychosisCombatEquipCompatibility.Begin(player, scriptInterface.localBlackboard);
  };
  wrappedMethod(scriptInterface, stateContext, stateMachineInstanceData, item);
  if skip { WEPsychosisCombatEquipCompatibility.End(player, scriptInterface.localBlackboard, previous); };
}
