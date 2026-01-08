@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);

  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  let eggFact: Int32 = questsSystem.GetFact(n"mws_wat_02_egg_placed");
  let hatchFact: Int32 = questsSystem.GetFact(n"mws_wat_02_iguana_hatched");

  if Equals(eggFact, 1) && Equals(hatchFact, 0) {
    questsSystem.SetFact(n"mws_wat_02_iguana_hatched", 1);
    this.ShowIguanaNotification();
  };
}

@addMethod(GameObject)
public func ShowIguanaNotification() -> Void {
  let onScreenMessage: SimpleScreenMessage;
  let blackboardDef = GetAllBlackboardDefs().UI_Notifications;
  let blackboard = GameInstance.GetBlackboardSystem(this.GetGame()).Get(blackboardDef);
  onScreenMessage.isShown = true;
  onScreenMessage.message = "Iguana egg was hatched!";
  onScreenMessage.duration = 5.0;
  blackboard.SetVariant(blackboardDef.OnscreenMessage, ToVariant(onScreenMessage), true);
}
