import Edgerunning.Common.E
import Edgerunning.Common.EdgerunnerLogs

@addField(ReactionManagerComponent)
private let weCrowdBudgetOwner: wref<WEPsychosisCombat>;

@addField(ReactionManagerComponent)
private let weCrowdTraceCount: Int32;

@addMethod(ReactionManagerComponent)
private func WECrowdResetBudget(owner: ref<WEPsychosisCombat>) -> Void {
  if this.weCrowdBudgetOwner != owner {
    this.weCrowdBudgetOwner = owner;

    this.weCrowdTraceCount = 0;
  };
}

@addField(ReactionManagerComponent)
private let weCrowdTraceEvent: Int32;

@addField(ReactionManagerComponent)
private let weCrowdTraceFailures: Int32;

@wrapMethod(ReactionManagerComponent)
protected final func HandleStimEvent(stimData: ref<StimEventTaskData>) -> Void {
  let previous: Int32 = this.weCrowdTraceEvent;
  let previousFailures: Int32 = this.weCrowdTraceFailures;
  let player: ref<PlayerPuppet>;
  let npc: ref<NPCPuppet>;
  let evt: ref<StimuliEvent>;
  this.weCrowdTraceEvent = 0;
  this.weCrowdTraceFailures = 0;
  if EdgerunnerLogs.IsEnabled() && IsDefined(stimData) && IsDefined(stimData.cachedEvt) {
    evt = stimData.cachedEvt;
    if Equals(evt.GetStimType(), gamedataStimType.Bullet)
      || Equals(evt.GetStimType(), gamedataStimType.ProjectileDistraction)
      || Equals(evt.GetStimType(), gamedataStimType.WeaponDisplayed)
      || Equals(evt.GetStimType(), gamedataStimType.Gunshot)
      || Equals(evt.GetStimType(), gamedataStimType.SilencedGunshot)
      || Equals(evt.GetStimType(), gamedataStimType.AimingAt)
      || Equals(evt.GetStimType(), gamedataStimType.CombatHit)
      || Equals(evt.GetStimType(), gamedataStimType.IllegalAction) {
      player = evt.sourceObject as PlayerPuppet;
      if !IsDefined(player) && IsDefined(evt.sourceObject as WeaponObject) {
        player = (evt.sourceObject as WeaponObject).GetOwner() as PlayerPuppet;
      };
      if !IsDefined(player) {
        player = GameInstance.GetPlayerSystem(this.GetOwner().GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
      };
      npc = this.GetOwner() as NPCPuppet;
      if IsDefined(player) && IsDefined(player.wePsychosisCombat) && IsDefined(npc) {
        this.WECrowdResetBudget(player.wePsychosisCombat);
        if this.weCrowdTraceCount < 8 { this.weCrowdTraceEvent = player.wePsychosisCombat.BeginCrowdTrace(npc); };
        if this.weCrowdTraceEvent > 0 { this.weCrowdTraceCount += 1; };
      };
    };
  };
  wrappedMethod(stimData);
  this.weCrowdTraceEvent = previous;
  this.weCrowdTraceFailures = previousFailures;
}

@wrapMethod(ReactionManagerComponent)
public final const func LogFailure(message: String) -> Void {
  wrappedMethod(message);
  if this.weCrowdTraceEvent > 0 && this.weCrowdTraceFailures < 1 {
    this.weCrowdTraceFailures += 1;
    E(s"WE CROWD rejected npc=\(this.GetOwner().GetEntityID()) reason=\(message)");
  };
}

@wrapMethod(ReactionManagerComponent)
private final func ShouldTriggerAggressiveCrowdNPCCombat(stimEvent: ref<StimuliEvent>) -> Bool {
  let result: Bool = wrappedMethod(stimEvent);
  let player: ref<PlayerPuppet> = stimEvent.sourceObject as PlayerPuppet;
  let heatReason: CName;
  if !result && IsDefined(player) && IsDefined(player.wePsychosisCombat)
    && EnumInt(player.GetPreventionSystem().GetHeatStage()) > 0 {
    heatReason = this.WECrowdWithoutHeat(stimEvent, player);
    result = Equals(heatReason, n"allowed");
    if this.weCrowdTraceEvent > 0 { E(s"WE CROWD heat_exception npc=\(this.GetOwner().GetEntityID()) vanilla=false effective=\(result) reason=\(heatReason) heatUnchanged=true"); };
  };
  if this.weCrowdTraceEvent > 0 && !result && Equals(heatReason, n"") {
    E(s"WE CROWD rejected npc=\(this.GetOwner().GetEntityID()) reason=vanilla_eligibility");
  };
  return result;
}

@addMethod(ReactionManagerComponent)
private func WECrowdWithoutHeat(evt: ref<StimuliEvent>, player: ref<PlayerPuppet>) -> CName {
  let npc: ref<NPCPuppet> = this.GetOwner() as NPCPuppet;
  let nav: ref<AINavigationSystem>;
  let limit: Float;
  if !Equals(evt.GetStimType(), gamedataStimType.Bullet) && !Equals(evt.GetStimType(), gamedataStimType.ProjectileDistraction)
    && !Equals(evt.GetStimType(), gamedataStimType.Gunshot) && !Equals(evt.GetStimType(), gamedataStimType.SilencedGunshot) { return n"stim_type"; };
  if !player.wePsychosisCombat.AllowsCrowdHeatException(npc) { return n"feature_context_or_target"; };
  if VehicleComponent.IsMountedToVehicle(npc.GetGame(), npc) { return n"mounted"; };
  if player.IsInCombat() { return n"combat"; };
  if StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"NoCombat") { return n"no_combat"; };
  if player.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.Zones) == 2 { return n"safe_zone"; };
  if GameInstance.GetSafeAreaManager(npc.GetGame()).IsPointInSafeArea(player.GetWorldPosition()) { return n"safe_area"; };
  if evt.IsTagInStimuli(n"NonAggressiveCrowd") { return n"non_aggressive_tag"; };
  if !this.IsTargetInFront(player, 120.0) { return n"npc_facing"; };
  if !this.IsTargetInFront(player, 100.0, true) { return n"player_facing"; };
  let weapon: ref<WeaponObject> = GameObject.GetActiveWeapon(player);
  if !IsDefined(weapon) { return n"no_weapon"; };
  limit = WeaponObject.IsRanged(weapon.GetItemID())
    ? TweakDBInterface.GetFloat(t"AIGeneralSettings.distanceToTriggerAggressiveCrowdRanged", 15.0)
    : TweakDBInterface.GetFloat(t"AIGeneralSettings.distanceToTriggerAggressiveCrowdMelee", 5.0);
  if Vector4.DistanceSquared(npc.GetWorldPosition(), player.GetWorldPosition()) >= limit * limit { return n"distance"; };
  nav = GameInstance.GetAINavigationSystem(npc.GetGame());
  if IsDefined(nav) && !nav.IsPointOnNavmesh(npc, npc.GetWorldPosition(), 0.10) { return n"navmesh"; };
  return n"allowed";
}

@wrapMethod(ReactionManagerComponent)
private final func HandleCrowdReaction(stimEvent: ref<StimuliEvent>) -> Void {
  let reaction: ref<ReactionSystem>;
  let before: Bool;
  if this.weCrowdTraceEvent > 0 {
    reaction = GameInstance.GetReactionSystem(this.GetOwner().GetGame());
    before = reaction.IsRegisteredAsAggressive(this.GetOwner().GetEntityID());
  };
  wrappedMethod(stimEvent);
  if this.weCrowdTraceEvent > 0 {
    E(s"WE CROWD registration npc=\(this.GetOwner().GetEntityID()) before=\(before) after=\(reaction.IsRegisteredAsAggressive(this.GetOwner().GetEntityID())) wasAggressiveCrowd=\((this.GetOwner() as NPCPuppet).GetWasAggressiveCrowd()) nativeReturnNotObserved=true");
  };
}






