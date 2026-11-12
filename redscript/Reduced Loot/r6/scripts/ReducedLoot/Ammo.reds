module ReducedLoot

@wrapMethod(PlayerHandicapSystem)
public final const func CanDropAmmo() -> Bool {
  let allowed: Bool = wrappedMethod();
  let system: ref<ReducedLootSession> = ReducedLootSession.Get(this.GetGameInstance());
  return allowed && !(IsDefined(system) && system.Active() && system.settings.disableAmmoHelp);
}
