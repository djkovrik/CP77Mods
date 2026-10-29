@wrapMethod(GlamDocGameController)
protected cb func OnInitialize() -> Bool {
  let system: ref<SleevesStateSystem> = SleevesStateSystem.Get(GetGameInstance());
  if IsDefined(system) {
    system.BeginSleevesGlamdoc();
  };
  return wrappedMethod();
}

@wrapMethod(GlamDocGameController)
protected cb func OnUninitialize() -> Bool {
  let result: Bool = wrappedMethod();
  let system: ref<SleevesStateSystem> = SleevesStateSystem.Get(GetGameInstance());
  if IsDefined(system) {
    system.EndSleevesGlamdoc();
  };
  return result;
}
