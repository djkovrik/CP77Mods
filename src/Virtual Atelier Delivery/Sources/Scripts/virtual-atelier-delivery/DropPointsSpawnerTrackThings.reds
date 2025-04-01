module AtelierDelivery

// Track live fact updates
@addField(PlayerPuppet)
private let vaFactListenerWatson: Uint32;

@addField(PlayerPuppet)
private let vaFactListenerDogtown: Uint32;

@wrapMethod(PlayerPuppet)
private final func PlayerAttachedCallback(playerPuppet: ref<GameObject>) -> Void {
  wrappedMethod(playerPuppet);
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  this.vaFactListenerWatson = questsSystem.RegisterListener(n"watson_prolog_lock", this, n"OnFactChangedWatson");
  this.vaFactListenerDogtown = questsSystem.RegisterListener(n"q302_done", this, n"OnFactChangedDogtown");
}

@wrapMethod(PlayerPuppet)
private final func PlayerDetachedCallback(playerPuppet: ref<GameObject>) -> Void {
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  questsSystem.UnregisterListener(n"watson_prolog_lock", this.vaFactListenerWatson);
  questsSystem.UnregisterListener(n"q302_done", this.vaFactListenerDogtown);
  wrappedMethod(playerPuppet);
}

@addMethod(PlayerPuppet)
public final func OnFactChangedWatson(val: Int32) -> Void {
  if Equals(val, 0) {
    AtelierDropPointsSpawner.Get(this.GetGame()).HandleSpawning();
  };
}

@addMethod(PlayerPuppet)
public final func OnFactChangedDogtown(val: Int32) -> Void {
  if Equals(val, 1) {
    AtelierDropPointsSpawner.Get(this.GetGame()).HandleSpawning();
  };
}

// Run checks post ft
@wrapMethod(FastTravelSystem)
protected cb func OnLoadingScreenFinished(value: Bool) -> Bool {
  if value {
    AtelierDropPointsSpawner.Get(this.GetGameInstance()).CheckAndHandleSpawning();
  };
  wrappedMethod(value);
}
