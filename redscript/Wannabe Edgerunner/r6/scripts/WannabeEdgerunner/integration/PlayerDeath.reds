import Edgerunning.System.EdgerunningSystem

// Cancel scheduled teleport on player death
@wrapMethod(ScriptedPuppet)
protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
  wrappedMethod(evt);
  if this.IsPlayer() {
    EdgerunningSystem.GetInstance(this.GetGame()).StopEverythingNew();
  };
}
