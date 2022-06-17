// -- Add vehicle dismiss option

private class VehicleSummonDismissConfig {
  public static func Label() -> String = "Dismiss"
  public static func Action() -> CName = n"Choice2"
  public static func Delay() -> Float = 20.0
}

@wrapMethod(interactionWidgetGameController)
protected cb func OnUpdateInteraction(argValue: Variant) -> Bool {
  let player: ref<PlayerPuppet> = this.GetPlayerControlledObject() as PlayerPuppet;
  let interactionData: InteractionChoiceHubData = FromVariant<InteractionChoiceHubData>(argValue);
  let interactionChoices: array<InteractionChoiceData> = interactionData.choices;
  let choicesCount: Int32 = ArraySize(interactionChoices);
  let firstChoice: InteractionChoiceData;
  let newChoice: InteractionChoiceData;

  if choicesCount > 0 && player.IsLookingAtOwnedVehicle() {
    firstChoice = interactionChoices[0];
    newChoice.inputAction = VehicleSummonDismissConfig.Action();
    newChoice.rawInputKey = EInputKey.IK_R;
    newChoice.isHoldAction = false;
    newChoice.localizedName = VehicleSummonDismissConfig.Label();
    newChoice.type = firstChoice.type;
    newChoice.data = firstChoice.data;
    newChoice.captionParts = firstChoice.captionParts;
    ArrayPush(interactionChoices, newChoice);
    interactionData.choices = interactionChoices;
    wrappedMethod(ToVariant(interactionData));
  } else {
    wrappedMethod(argValue);
  };
}

@addMethod(PlayerPuppet)
public func IsLookingAtOwnedVehicle() -> Bool {
  let currentTarget: ref<VehicleObject> = GameInstance.GetTargetingSystem(this.GetGame()).GetLookAtObject(this) as VehicleObject;
  let isLookingAtOwnedVehicle: Bool = false;
  let vehicleId: TweakDBID;
  if IsDefined(currentTarget) {
    vehicleId = currentTarget.GetRecord().GetID();
    isLookingAtOwnedVehicle = this.IsThisVehicleOwned(vehicleId);
  };

  return isLookingAtOwnedVehicle;
}

@addMethod(PlayerPuppet)
private func IsThisVehicleOwned(id: TweakDBID) -> Bool {
  let system: ref<VehicleSystem> = GameInstance.GetVehicleSystem(this.GetGame());
  let unlockedVehicles: array<PlayerVehicle>;
  system.GetPlayerUnlockedVehicles(unlockedVehicles);
  for vehicle in unlockedVehicles {
    if Equals(vehicle.recordID, id) {
      return true;
    };
  };
  return false;
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  wrappedMethod(action, consumer);
  let currentTarget: ref<VehicleObject>;
  if Equals(ListenerAction.GetName(action), VehicleSummonDismissConfig.Action()) && this.IsLookingAtOwnedVehicle() {
    currentTarget = GameInstance.GetTargetingSystem(this.GetGame()).GetLookAtObject(this) as VehicleObject;
    GameInstance.GetPreventionSpawnSystem(this.GetGame()).JoinTraffic(currentTarget);
    let callback: ref<VehicleSummonDismissCallback> = new VehicleSummonDismissCallback();
    callback.vehicleSystem = GameInstance.GetVehicleSystem(this.GetGame());
    callback.vehicleId = Cast<GarageVehicleID>(currentTarget.GetRecord().GetID());
    GameInstance.GetDelaySystem(this.GetGame()).DelayCallback(callback, VehicleSummonDismissConfig.Delay());
  };
}

public class VehicleSummonDismissCallback extends DelayCallback {
  public let vehicleSystem: wref<VehicleSystem>;
  public let vehicleId: GarageVehicleID;

  public func Call() -> Void {
    this.vehicleSystem.DespawnPlayerVehicle(this.vehicleId);
  }
}
