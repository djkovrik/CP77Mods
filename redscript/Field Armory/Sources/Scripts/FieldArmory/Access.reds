module FieldArmory

import Codeware.UI.*

public class OpenFieldArmory extends ActionBool {
  public let access: ref<StashAccess>;

  public static func Create(ps: ref<ScriptableDeviceComponentPS>, stock: ref<ScriptableDeviceAction>, access: ref<StashAccess>) -> ref<OpenFieldArmory> {
    let action: ref<OpenFieldArmory> = new OpenFieldArmory();
    action.clearanceLevel = stock.clearanceLevel;
    action.SetUp(ps);
    action.actionName = stock.GetActionID();
    action.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(action.actionName, true, n"FieldArmory-Loadouts", n"FieldArmory-Loadouts");
    action.SetIllegal(stock.IsIllegal());
    action.CreateInteraction([], "", t"Interactions.FieldArmoryLoadouts");
    action.access = access;
    return action;
  }
}

public class StashAccess {
  public let apartment: wref<StashControllerPS>;
  public let trunk: wref<VehicleComponentPS>;
  public let context: GetActionsContext;
  public let vehicleContext: VehicleActionsContext;
  public let storage: wref<GameObject>;
  public let player: wref<PlayerPuppet>;

  public func Available() -> Bool {
    if !IsDefined(this.storage) || !IsDefined(this.player) || !this.storage.IsAttached() { return false; }

    if IsDefined(this.apartment) {
      if !this.apartment.HasActiveContext(gamedeviceRequestType.Direct) { return false; }
      let actions: array<ref<DeviceAction>>;
      if !this.apartment.GetActions(actions, this.context) { return false; }
      return this.apartment.FieldArmoryStockActive(actions, true);
    };

    return IsDefined(this.trunk) && this.trunk.FieldArmoryTrunkActive(this.vehicleContext);
  }

  public func Open(owner: ref<GameObject>) {
    if !IsDefined(owner) { return; }
    this.storage = owner;
    this.player = GetPlayer(owner.GetGame());
    if !this.Available() { return; }

    let system = ArmorySystem.Get(owner.GetGame());
    if IsDefined(system.screen) { return; }
    Stash.ProcessStashRetroFixes(owner);
    MarketSystem.OnVendorMenuOpen(owner);

    let popup: ref<ArmoryScreen> = new ArmoryScreen();
    popup.access = this;
    system.screen = popup;
    GameInstance.GetUISystem(owner.GetGame()).QueueEvent(ShowCustomPopupEvent.Create(popup));
  }
}


@addMethod(ScriptableDeviceComponentPS)
public final func FieldArmoryStockActive(out actions: array<ref<DeviceAction>>, apartment: Bool) -> Bool {
  this.FinalizeGetActions(actions);
  for action in actions {
    if (apartment && IsDefined(action as OpenStash)) || (!apartment && IsDefined(action as VehiclePlayerTrunk)) {
      return !(action as ScriptableDeviceAction).IsInactive();
    };
  };
  return false;
}

@addMethod(VehicleComponentPS)
public final func FieldArmoryTrunkActive(context: VehicleActionsContext) -> Bool {
  let player = GetPlayer(this.GetGameInstance());
  let bb = player.GetPlayerStateMachineBlackboard();
  if !this.GetOwnerEntity().GetVehicleComponent().FieldArmoryAtTrunk(player) 
    || this.GetIsDestroyed() 
    || player.GetTakeOverControlSystem().IsDeviceControlled()
    || EntityID.IsDefined(bb.GetEntityID(GetAllBlackboardDefs().PlayerStateMachine.EntityIDVehicleRemoteControlled)) {
       return false; 
  };

  let hacks = FromVariant<array<TweakDBID>>(bb.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.UploadingQuickHackIDs));
  if ArrayContains(hacks, t"DeviceAction.TakeControlVehicleClassHack") 
    || ArrayContains(hacks, t"DeviceAction.TakeControlClassHack")
    || ArrayContains(hacks, t"DeviceAction.TakeControlCameraClassHack") 
    || ArrayContains(hacks, t"DeviceAction.VehicleExplodeClassHack") { 
      return false; 
  };

  let actions: array<ref<DeviceAction>>;
  this.GetTrunkActions(actions, context);
  return this.FieldArmoryStockActive(actions, false);
}

@addMethod(VehicleComponent)
public final func FieldArmoryAtTrunk(player: ref<PlayerPuppet>) -> Bool {
  let layers: array<gameinteractionsActiveLayerData>;
  this.m_interaction.GetActivatorsForLayer(n"trunk", layers);
  for layer in layers { if layer.activator == player { return true; } }
  return false;
}

@wrapMethod(StashControllerPS)
public func GetActions(out outActions: array<ref<DeviceAction>>, context: GetActionsContext) -> Bool {
  let ok: Bool = wrappedMethod(outActions, context);
  if ok {
    for action in outActions {
      let stock = action as OpenStash;
      if IsDefined(stock) && !stock.IsInactive() {
        let access = new StashAccess();
        access.apartment = this;
        access.context = context;
        ArrayPush(outActions, OpenFieldArmory.Create(this, stock, access));
        break;
      };
    };
  };

  return ok;
}

@wrapMethod(VehicleComponentPS)
public final func GetTrunkActions(actions: script_ref<array<ref<DeviceAction>>>, const context: script_ref<VehicleActionsContext>) {
  wrappedMethod(actions, context);

  for action in Deref(actions) {
    let stock = action as VehiclePlayerTrunk;
    if IsDefined(stock) && !stock.IsInactive() {
      let access = new StashAccess();
      access.trunk = this;
      access.vehicleContext = Deref(context);
      ArrayPush(Deref(actions), OpenFieldArmory.Create(this, stock, access));
      break;
    };
  };
}

@addMethod(StashControllerPS)
private final func OnOpenFieldArmory(evt: ref<OpenFieldArmory>) -> EntityNotificationType {
  return EntityNotificationType.SendThisEventToEntity;
}

@addMethod(Stash)
protected cb func OnOpenFieldArmory(evt: ref<OpenFieldArmory>) -> Bool {
  evt.access.Open(this);
}

@addMethod(VehicleComponentPS)
private final func OnOpenFieldArmory(evt: ref<OpenFieldArmory>) -> EntityNotificationType {
  evt.access.Open(this.GetOwnerEntity());
  return EntityNotificationType.DoNotNotifyEntity;
}
