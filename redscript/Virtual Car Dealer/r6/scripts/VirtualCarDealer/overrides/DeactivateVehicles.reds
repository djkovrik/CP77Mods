import CarDealer.System.PurchasableVehicleSystem

@wrapMethod(VehiclesManagerDataHelper)
public final static func GetVehicles(player: ref<GameObject>) -> array<ref<IScriptable>> {
  PurchasableVehicleSystem.GetInstance(player.GetGame()).DeactivateSoldVehicles();
  return wrappedMethod(player);
}

@wrapMethod(QuickSlotsTransition)
protected final const func HasAnyVehiclesUnlocked(const scriptInterface: ref<StateGameScriptInterface>) -> Int32 {
  PurchasableVehicleSystem.GetInstance(scriptInterface.GetGame()).DeactivateSoldVehicles();
  return wrappedMethod(scriptInterface);
}

@wrapMethod(PlayerPuppet)
private final func GetUnlockedVehiclesSize() -> Int32 {
  PurchasableVehicleSystem.GetInstance(this.GetGame()).DeactivateSoldVehicles();
  return wrappedMethod();
}

@wrapMethod(QuickSlotsManager)
public final const func GetVehicleWheel(vehicleWheel: script_ref<array<QuickSlotCommand>>) -> Void {
  PurchasableVehicleSystem.GetInstance(this.m_Player.GetGame()).DeactivateSoldVehicles();
  wrappedMethod(vehicleWheel);
}
