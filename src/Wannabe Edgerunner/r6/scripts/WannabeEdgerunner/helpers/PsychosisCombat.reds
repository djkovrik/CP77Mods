import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E
import Edgerunning.Common.EdgerunnerLogs

public class WEPsychosisCombatDrawRequest extends ScriptableSystemRequest {
  public let psychosisCombat: wref<WEPsychosisCombat>;
}

@addMethod(EquipmentSystem)
private func OnWEPsychosisCombatDrawRequest(request: ref<WEPsychosisCombatDrawRequest>) -> Void {
  if IsDefined(request.psychosisCombat) { request.psychosisCombat.DispatchDraw(); };
}

public class WEPsychosisCombatHighlight {
  public let id: EntityID;
  public let npc: wref<NPCPuppet>;
  public let data: ref<FocusForcedHighlightData>;
}

public class WEPsychosisCombatTick extends DelayCallback {
  public let owner: wref<WEPsychosisCombat>;
  public func Call() -> Void {
    if IsDefined(this.owner) { this.owner.Tick(); };
  }
}

public class WEPsychosisCombat {
  private let player: wref<PlayerPuppet>;
  private let system: wref<EdgerunningSystem>;
  private let generation: Uint32;
  private let delays: ref<DelaySystem>;
  private let pending: DelayID;
  private let targeting: ref<TargetingSystem>;
  private let menu: ref<IBlackboard>;
  private let photo: ref<IBlackboard>;
  private let menuListener: ref<CallbackHandle>;
  private let photoListener: ref<CallbackHandle>;
  private let stopped: Bool;
  private let paused: Bool;
  private let shoot: Bool;
  private let outline: Bool;
  private let excludeCivilians: Bool;
  private let highlights: array<ref<WEPsychosisCombatHighlight>>;
  private let target: wref<NPCPuppet>;
  private let weapon: wref<WeaponObject>;
  private let aiming: Bool;
  private let aimStarted: Float;
  private let nextReadyAimCheck: Float;
  private let aimPoint: Vector4;
  private let aimRefreshes: Int32;
  private let nextAimRefresh: Float;
  private let nextSearch: Float;
  private let nextAttempt: Float;
  private let attempts: Int32;
  private let shots: Int32;
  private let partsCount: Int32;
  private let outlineAfter: Float;
  private let preparationTried: Bool;
  private let preparingWeapon: Bool;
  private let drawIssued: Bool;
  private let drawDeadline: Float;
  private let requestedItem: ItemID;
  private let result: CName;
  private let aimTargetID: EntityID;
  private let debugBeforeValid: Bool;
  private let debugBeforeCosine: Float;
  private let debugBeforeForward: Vector4;
  private let debugWeaponNext: Float;
  private let debugWeaponSnapshot: String;
  private let debugWeaponFlow: CName;
  private let debugSearchNext: Float;
  private let crowdTraceShot: Int32;
  private let crowdRoster: array<EntityID>;

  public func AllowsCrowdHeatException(npc: ref<NPCPuppet>) -> Bool {
    if this.stopped || this.paused || !this.shoot || !IsDefined(this.player) || !IsDefined(this.system) { return false; };
    if this.player.wePsychosisCombat != this || !this.system.IsCrowdPsychosisCurrent(this.generation, this.player) { return false; };
    if this.menu.GetBool(GetAllBlackboardDefs().UI_System.IsInMenu) || this.photo.GetBool(GetAllBlackboardDefs().PhotoMode.IsActive) { return false; };
    if GameInstance.GetTimeSystem(this.player.GetGame()).IsTimeDilationActive() { return false; };
    return IsDefined(npc) && npc.IsCharacterCivilian() && this.FireCandidate(npc);
  }


  public func BeginCrowdTrace(npc: ref<NPCPuppet>) -> Int32 {
    if !EdgerunnerLogs.IsEnabled() || this.stopped || !IsDefined(npc) || !IsDefined(this.player) { return 0; };
    if this.crowdTraceShot == 0 || this.player.IsDead() || !this.player.IsAttached() { return 0; };
    if !IsDefined(this.system) || this.system.GetGeneration() != this.generation || this.player.wePsychosisCombat != this { return 0; };
    if GameInstance.GetPlayerSystem(this.player.GetGame()).GetLocalPlayerControlledGameObject() != this.player { return 0; };
    if this.menu.GetBool(GetAllBlackboardDefs().UI_System.IsInMenu) || this.photo.GetBool(GetAllBlackboardDefs().PhotoMode.IsActive) { return 0; };
    let bb: ref<IBlackboard> = this.player.GetPlayerStateMachineBlackboard();
    if bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel) != 1 || bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vitals) != 0 { return 0; };
    if Vector4.DistanceSquared(npc.GetWorldPosition(), this.player.GetWorldPosition()) > 900.0 { return 0; };
    let i: Int32 = 0;
    while i < ArraySize(this.crowdRoster) {
      if this.crowdRoster[i] == npc.GetEntityID() { return i + 1; };
      i += 1;
    };
    return 0;
  }
  private let raiseWeapon: wref<WeaponObject>;
  private let raiseUntil: Float;
  private let nextRaise: Float;
  private let raiseCount: Int32;

  public func Start(system: ref<EdgerunningSystem>, shoot: Bool, outline: Bool, excludeCivilians: Bool, outlineDelay: Float) -> Void {
    this.system = system;
    this.player = system.GetPlayer();
    this.player.wePsychosisCombat = this;
    this.generation = system.GetGeneration();
    this.shoot = shoot;
    this.outline = outline;
    this.excludeCivilians = excludeCivilians;
    this.delays = GameInstance.GetDelaySystem(this.player.GetGame());
    this.targeting = GameInstance.GetTargetingSystem(this.player.GetGame());
    this.menu = GameInstance.GetBlackboardSystem(this.player.GetGame()).Get(GetAllBlackboardDefs().UI_System);
    this.photo = GameInstance.GetBlackboardSystem(this.player.GetGame()).Get(GetAllBlackboardDefs().PhotoMode);
    this.menuListener = this.menu.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsInMenu, this, n"OnBlockedUI");
    this.photoListener = this.photo.RegisterListenerBool(GetAllBlackboardDefs().PhotoMode.IsActive, this, n"OnBlockedUI");
    this.nextAttempt = this.Now() + 4.5;
    this.outlineAfter = this.Now() + outlineDelay;
    this.result = n"intro";
    this.Tick();
  }

  private func Now() -> Float { return EngineTime.ToFloat(GameInstance.GetSimTime(this.player.GetGame())); }

  protected cb func OnBlockedUI(value: Bool) -> Bool {
    if value && !this.stopped { this.Pause(); };
  }

  public func EmergencyStop() -> Void {
    if !this.stopped && IsDefined(this.player) {
      let weapon: ref<WeaponObject> = GameObject.GetActiveWeapon(this.player);
      if IsDefined(weapon) {
        let stoppedFire: Bool = weapon.WEPsychosisCombatStopFire(this.player);
        FTLog(s"EdgerunnerClear: native weapon stop accepted=\(stoppedFire)");
      };
    };
    this.Stop();
  }

  public func Stop() -> Void {
    if this.stopped { return; };
    if IsDefined(this.player) && this.player.wePsychosisCombat == this { this.player.wePsychosisCombat = null; };
    this.raiseWeapon = null;
    if IsDefined(this.player) && this.player.wePsychosisDrawOwner == this { this.player.wePsychosisDrawOwner = null; };
    if this.preparingWeapon && IsDefined(this.player) && this.player.IsAttached() {
      this.TraceWeaponWait(GameObject.GetActiveWeapon(this.player), this.Now(), n"cancel", true, false, false);
    };
    this.stopped = true;
    this.preparingWeapon = false;
    if IsDefined(this.delays) { this.delays.CancelCallback(this.pending); };
    this.pending = GetInvalidDelayID();
    if this.aiming && EdgerunnerLogs.IsEnabled() {
      E(s"WE AIM cancel gen=\(this.generation) attempt=\(this.attempts) npc=\(this.aimTargetID) reason=stop/context/lifecycle result=\(this.result)");
    };
    this.ReleaseAim();
    let i: Int32 = 0;
    while i < ArraySize(this.highlights) {
      this.SendHighlight(this.highlights[i], false);
      i += 1;
    };
    ArrayClear(this.highlights);
    if IsDefined(this.menuListener) { this.menu.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsInMenu, this.menuListener); };
    if IsDefined(this.photoListener) { this.photo.UnregisterListenerBool(GetAllBlackboardDefs().PhotoMode.IsActive, this.photoListener); };
    this.menuListener = null;
    this.photoListener = null;
    E("Psychosis combat stopped; owned aim and highlights released");
  }

  private func ReleaseAim() -> Void {
    if this.aiming && IsDefined(this.player) { this.targeting.BreakLookAt(this.player); };
    this.aiming = false;
    this.target = null;
    this.weapon = null;
  }

  private func ContextSafe(opt allowTransient: Bool) -> Bool {
    if !IsDefined(this.system) || !this.system.IsCallbackCurrent(this.generation, this.player) { return false; };
    if !this.system.CanForceWeaponAction(this.preparingWeapon && this.Now() <= this.drawDeadline, allowTransient) { return false; };
    let bb: ref<IBlackboard> = this.player.GetPlayerStateMachineBlackboard();
    let vision: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vision);
    return (allowTransient || (!this.menu.GetBool(GetAllBlackboardDefs().UI_System.IsInMenu)
      && !this.photo.GetBool(GetAllBlackboardDefs().PhotoMode.IsActive)
      && !GameInstance.GetTimeSystem(this.player.GetGame()).IsTimeDilationActive()))
      && !GameInstance.GetWorkspotSystem(this.player.GetGame()).IsActorInWorkspot(this.player)
      && bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel) == 1
      && bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vitals) == 0
      && (vision == EnumInt(gamePSMVision.Default) || (allowTransient && vision == EnumInt(gamePSMVision.Focus)))
      && !bb.GetBool(GetAllBlackboardDefs().PlayerStateMachine.SceneAimForced)
      && !bb.GetBool(GetAllBlackboardDefs().PlayerStateMachine.SceneSafeForced);
  }

  private func Pause() -> Void {
    if this.stopped || this.paused { return; };
    this.paused = true;
    // Keep episode budgets; queued draw requests must lose their ownership.
    this.preparingWeapon = false;
    this.raiseWeapon = null;
    if IsDefined(this.player) && this.player.wePsychosisDrawOwner == this { this.player.wePsychosisDrawOwner = null; };
    this.ReleaseAim();
    let i: Int32 = 0;
    while i < ArraySize(this.highlights) {
      this.SendHighlight(this.highlights[i], false);
      i += 1;
    };
    ArrayClear(this.highlights);
    this.result = n"paused";
  }

  private func CheckContext() -> Bool {
    if this.ContextSafe() { return true; };
    if this.stopped { return false; };
    if !this.ContextSafe(true) { this.result = n"context_blocked"; this.Stop(); return false; };
    this.Pause();
    return false;
  }

  private func ScheduleTick() -> Void {
    if this.stopped { return; };
    let callback: ref<WEPsychosisCombatTick> = new WEPsychosisCombatTick();
    callback.owner = this;
    this.pending = this.delays.DelayCallback(callback, 0.1, false);
  }

  public func Tick() -> Void {
    this.pending = GetInvalidDelayID();
    if this.stopped { return; };
    if !this.CheckContext() { this.ScheduleTick(); return; };
    let now: Float = this.Now();
    if this.paused {
      this.paused = false;
      this.nextAttempt = MaxF(this.nextAttempt, now + 1.5);
      this.nextSearch = now;
      this.result = n"resumed";
    };
    this.UpdatePublicSafeRequest(now);
    if this.preparingWeapon {
      let active: wref<WeaponObject> = GameObject.GetActiveWeapon(this.player);
      let weaponPassed: Bool = this.drawIssued && IsDefined(active) && active.GetItemID() == this.requestedItem && this.SupportedWeapon(active);
      let strictAllowed: Bool = weaponPassed && this.system.CanForceWeaponAction();
      this.TraceWeaponWait(active, now, strictAllowed ? n"ready" : n"wait", strictAllowed || now >= this.drawDeadline, weaponPassed, strictAllowed);
      if strictAllowed {
        this.preparingWeapon = false;
        this.result = n"weapon_ready";
        E("Psychosis combat requested weapon ready");
      } else {
        if now >= this.drawDeadline {
          this.preparingWeapon = false;
          this.result = n"draw_timeout_or_empty";
          E("Psychosis combat draw timed out; no retry this episode");
          if !this.CheckContext() { this.ScheduleTick(); return; };
        };
      };
    };
    if this.aiming {
      if now - this.aimStarted > 0.45 { this.RejectAim(now, n"deadline_exceeded"); };
    } else {
      if now >= this.nextSearch {
        this.Search(now);
        this.nextSearch = now + 0.5;
      };
    };
    this.ScheduleTick();
  }

  private func VisualCandidate(npc: wref<NPCPuppet>) -> Bool {
    return IsDefined(npc) && npc.IsAttached() && npc.IsActive()
      && Vector4.Distance(npc.GetWorldPosition(), this.player.GetWorldPosition()) <= 15.0;
  }

  private func FireCandidate(npc: wref<NPCPuppet>) -> Bool {
    let immortality: gameGodModeType;
    if !this.VisualCandidate(npc) || npc.IsQuest() { return false; };
    let ai: ref<AIHumanComponent> = npc.GetAIControllerComponent();
    if !IsDefined(ai) || ai.IsPlayerCompanion() || GetImmortality(npc, immortality) { return false; };
    if GameInstance.GetStatsSystem(this.player.GetGame()).GetStatValue(Cast<StatsObjectID>(npc.GetEntityID()), gamedataStatType.IsInvulnerable) > 0.0 { return false; };
    if !IsDefined(npc.GetAttitudeAgent()) || !IsDefined(this.player.GetAttitudeAgent()) { return false; };
    let attitude: EAIAttitude = npc.GetAttitudeTowards(this.player);
    if Equals(attitude, EAIAttitude.AIA_Friendly) { return false; };
    if npc.IsCivilian() { return !this.excludeCivilians; };
    return Equals(attitude, EAIAttitude.AIA_Hostile);
  }

  private func Chest(npc: wref<NPCPuppet>, out position: Vector4) -> Bool {
    let transform: WorldTransform;
    if !IsDefined(npc) || !IsDefined(npc.GetSlotComponent()) || !npc.GetSlotComponent().GetSlotTransform(n"Chest", transform) { return false; };
    position = WorldPosition.ToVector4(WorldTransform.GetWorldPosition(transform));
    return true;
  }

  private func CameraAligned(position: Vector4, cosine: Float) -> Bool {
    let measured: Float;
    let forward: Vector4;
    return this.ReadAimCamera(position, measured, forward) && measured >= cosine;
  }

  private func ReadAimCamera(position: Vector4, out cosine: Float, out forward: Vector4) -> Bool {
    let camera: Transform;
    if !GameInstance.GetCameraSystem(this.player.GetGame()).GetActiveCameraWorldTransform(camera) { return false; };
    forward = Transform.GetForward(camera);
    cosine = Vector4.Dot(Vector4.Normalize(position - Transform.GetPosition(camera)), forward);
    return true;
  }

  private func TraceAimSample(stage: CName, now: Float, position: Vector4, valid: Bool, cosine: Float, forward: Vector4) -> Void {
    if !EdgerunnerLogs.IsEnabled() { return; };
    let angle: Float = valid ? Rad2Deg(AcosF(ClampF(cosine, -1.0, 1.0))) : -1.0;
    let before: Float = this.debugBeforeValid ? Rad2Deg(AcosF(ClampF(this.debugBeforeCosine, -1.0, 1.0))) : -1.0;
    let turn: Float = -1.0;
    if valid && this.debugBeforeValid {
      turn = Rad2Deg(AcosF(ClampF(Vector4.Dot(Vector4.Normalize(this.debugBeforeForward), Vector4.Normalize(forward)), -1.0, 1.0)));
    };
    E(s"WE AIM sample gen=\(this.generation) attempt=\(this.attempts) npc=\(this.aimTargetID) stage=\(stage) elapsed=\(now - this.aimStarted) cameraValid=\(valid) beforeDeg=\(before) targetAngleDeg=\(angle) cameraTurnDeg=\(turn) chest=\(position) requestedPoint=\(this.aimPoint) pointDrift=\(Vector4.Distance(position, this.aimPoint)) toleranceDeg=0.5 cameraForward=\(forward)");
  }

  private func RejectAim(now: Float, reason: CName) -> Void {
    if EdgerunnerLogs.IsEnabled() {
      E(s"WE AIM reject gen=\(this.generation) attempt=\(this.attempts) npc=\(this.aimTargetID) elapsed=\(now - this.aimStarted) reason=\(reason)");
    };
    this.ReleaseAim();
    this.nextAttempt = now + 1.5;
    this.result = n"aim_rejected";
  }

  private func SupportedWeapon(weapon: wref<WeaponObject>, opt allowPublicSafe: Bool) -> Bool {
    if !IsDefined(weapon) || !weapon.IsAttached() || WeaponObject.GetMagazineAmmoCount(weapon) == 0u { return false; };
    if NotEquals(this.WeaponReadinessFailure(weapon, allowPublicSafe), n"none") { return false; };
    if !IsDefined(weapon.GetCurrentTriggerMode()) || !this.SupportedTrigger(weapon.GetCurrentTriggerMode().Type()) { return false; };
    if !IsDefined(weapon.GetCurrentRangedAttack()) || !IsDefined(weapon.GetCurrentRangedAttack().DefaultFire()) { return false; };
    if !IsDefined(weapon.GetCurrentRangedAttack().DefaultFire().PlayerAttack()) { return false; };
    if WeaponObject.GetWeaponChargeNormalized(weapon) > 0.0 { return false; };
    if weapon.GetAIBlackboard().GetFloat(GetAllBlackboardDefs().AIShooting.maxChargedTimeStamp) > 0.0 { return false; };
    let ammoCost: Float = GameInstance.GetStatsSystem(this.player.GetGame()).GetStatValue(Cast<StatsObjectID>(weapon.GetEntityID()), gamedataStatType.NumShotsToFire);
    if Cast<Float>(WeaponObject.GetMagazineAmmoCount(weapon)) < ammoCost { return false; };
    return this.SupportedWeaponKind(weapon);
  }

  private func SupportedTrigger(mode: gamedataTriggerMode) -> Bool {
    return Equals(mode, gamedataTriggerMode.SemiAuto) || Equals(mode, gamedataTriggerMode.FullAuto) || Equals(mode, gamedataTriggerMode.Burst);
  }

  private func SupportedRecord(record: ref<WeaponItem_Record>) -> Bool {
    if !IsDefined(record) || !IsDefined(record.ItemType()) || !IsDefined(record.Evolution()) || !IsDefined(record.PrimaryTriggerMode()) { return false; };
    let kind: gamedataItemType = record.ItemType().Type();
    let evolution: gamedataWeaponEvolution = record.Evolution().Type();
    let firearm: Bool = Equals(kind, gamedataItemType.Wea_Handgun) || Equals(kind, gamedataItemType.Wea_Revolver)
      || Equals(kind, gamedataItemType.Wea_AssaultRifle) || Equals(kind, gamedataItemType.Wea_Rifle)
      || Equals(kind, gamedataItemType.Wea_SubmachineGun) || Equals(kind, gamedataItemType.Wea_LightMachineGun)
      || Equals(kind, gamedataItemType.Wea_PrecisionRifle) || Equals(kind, gamedataItemType.Wea_SniperRifle)
      || Equals(kind, gamedataItemType.Wea_Shotgun) || Equals(kind, gamedataItemType.Wea_ShotgunDual);
    return firearm && (Equals(evolution, gamedataWeaponEvolution.Power) || Equals(evolution, gamedataWeaponEvolution.Smart) || Equals(evolution, gamedataWeaponEvolution.Tech))
      && this.SupportedTrigger(record.PrimaryTriggerMode().Type());
  }

  private func SupportedShotStats(ammo: Float, projectiles: Float, cycle: Float) -> Bool {
    return ammo >= 1.0 && ammo <= 8.0 && ammo == Cast<Float>(Cast<Int32>(ammo))
      && projectiles >= 1.0 && projectiles <= 32.0 && projectiles == Cast<Float>(Cast<Int32>(projectiles))
      && cycle > 0.0 && cycle <= 5.0;
  }

  private func SupportedWeaponKind(weapon: wref<WeaponObject>) -> Bool {
    if !IsDefined(weapon) || !weapon.IsAttached() { return false; };
    let record: ref<WeaponItem_Record> = weapon.GetWeaponRecord();
    if !this.SupportedRecord(record) || AIWeapon.CanWeaponOverheat(weapon) { return false; };
    let stats: ref<StatsSystem> = GameInstance.GetStatsSystem(this.player.GetGame());
    let id: StatsObjectID = Cast<StatsObjectID>(weapon.GetEntityID());
    return this.SupportedShotStats(stats.GetStatValue(id, gamedataStatType.NumShotsToFire), stats.GetStatValue(id, gamedataStatType.ProjectilesPerShot), stats.GetStatValue(id, gamedataStatType.CycleTime));
  }

  private func WeaponReadinessFailure(weapon: wref<WeaponObject>, opt allowPublicSafe: Bool) -> CName {
    if !IsDefined(weapon) || !weapon.IsAttached() { return n"no_active_attached_weapon"; };
    let context: wref<StateContext> = this.player.wePsychosisCombatEquipmentContext;
    if !IsDefined(context) { return n"equipment_context_unavailable"; };
    let hand: StateMachineIdentifier;
    hand.definitionName = n"Equipment";
    hand.referenceName = n"RightHand";
    if NotEquals(context.GetStateMachineCurrentStateWithIdentifier(hand), n"equipped") { return n"right_hand_not_equipped"; };
    if GameInstance.GetTransactionSystem(this.player.GetGame()).GetItemInSlot(this.player, t"AttachmentSlots.WeaponRight") != weapon { return n"right_slot_mismatch"; };
    let weaponState: CName = weapon.WEPsychosisCombatState();
    if Equals(weaponState, n"unavailable") { return n"weapon_context_unavailable"; };
    if Equals(weaponState, n"instance_unavailable") { return n"weapon_instance_unavailable"; };
    if Equals(weaponState, n"None") { return n"weapon_instance_state_missing"; };
    if NotEquals(weaponState, n"ready") && !(allowPublicSafe && Equals(weaponState, n"publicSafe")) { return n"weapon_state_not_ready"; };
    if context.IsStateMachineActive(n"Consumable") { return n"consumable_active"; };
    if this.player.GetPlayerStateMachineBlackboard().GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsWeaponFirstEquip) { return n"first_equip_active"; };
    return n"none";
  }

  private func UpdatePublicSafeRequest(now: Float) -> Void {
    if IsDefined(this.raiseWeapon) {
      if now >= this.raiseUntil || NotEquals(this.raiseWeapon.WEPsychosisCombatState(), n"publicSafe") {
        if EdgerunnerLogs.IsEnabled() { E(s"WE RAISE ended gen=\(this.generation) state=\(this.raiseWeapon.WEPsychosisCombatState()) expired=\(now >= this.raiseUntil)"); };
        this.raiseWeapon = null;
      };
      return;
    };
    if !this.shoot || this.aiming || this.shots >= 3 || this.attempts >= 6 || this.raiseCount >= 6 || now < this.nextAttempt || now < this.nextRaise { return; };
    let active: wref<WeaponObject> = GameObject.GetActiveWeapon(this.player);
    if !IsDefined(active) || NotEquals(active.WEPsychosisCombatState(), n"publicSafe") { return; };
    if !this.system.CanForceWeaponAction() || !this.SupportedWeapon(active, true) { return; };
    this.raiseWeapon = active;
    this.raiseUntil = now + 1.0;
    this.nextRaise = now + 1.5;
    this.raiseCount += 1;
    if EdgerunnerLogs.IsEnabled() { E(s"WE RAISE requested gen=\(this.generation) count=\(this.raiseCount)/6 weapon=\(active.GetEntityID()) machine=\(active.wePsychosisCombatWeaponMachine) state=\(active.WEPsychosisCombatState())"); };
  }

  public func HasPublicSafeRequest(weapon: ref<WeaponObject>) -> Bool {
    return !this.stopped && !this.paused && IsDefined(weapon) && weapon == this.raiseWeapon;
  }

  public func AcceptPublicSafeRequest(player: ref<PlayerPuppet>, weapon: ref<WeaponObject>) -> Bool {
    if !this.HasPublicSafeRequest(weapon) || player != this.player || this.Now() >= this.raiseUntil { return false; };
    if !this.ContextSafe() || !this.system.CanForceWeaponAction() || !this.SupportedWeapon(weapon, true) { return false; };
    this.raiseWeapon = null;
    E("WE RAISE accepted: vanilla PublicSafeToReady transition; forced-safe and vanilla readiness guards passed");
    return true;
  }

  private func TraceWeaponWait(active: wref<WeaponObject>, now: Float, stage: CName, force: Bool, strictChecked: Bool, strictAllowed: Bool) -> Void {
    if !EdgerunnerLogs.IsEnabled() { return; };
    if !force && now < this.debugWeaponNext { return; };
    this.debugWeaponNext = now + 0.25;
    if !IsDefined(this.player) || !this.player.IsAttached() { return; };
    let bb: ref<IBlackboard> = this.player.GetPlayerStateMachineBlackboard();
    if !IsDefined(bb) { return; };
    let activeID: ItemID;
    let entityID: EntityID;
    let ammo: Int32 = -1;
    let attached: Bool;
    let itemType: Int32 = -1;
    let evolution: Int32 = -1;
    let primary: Int32 = -1;
    let current: Int32 = -1;
    let attack: Bool;
    let overheat: Bool;
    let numShots: Float = -1.0;
    let projectiles: Float = -1.0;
    let cycle: Float = -1.0;
    let record: ref<WeaponItem_Record>;
    if IsDefined(active) {
      activeID = active.GetItemID();
      entityID = active.GetEntityID();
      attached = active.IsAttached();
      if attached {
        ammo = Cast<Int32>(WeaponObject.GetMagazineAmmoCount(active));
        record = active.GetWeaponRecord();
        if IsDefined(record) {
          if IsDefined(record.ItemType()) { itemType = EnumInt(record.ItemType().Type()); };
          if IsDefined(record.Evolution()) { evolution = EnumInt(record.Evolution().Type()); };
          if IsDefined(record.PrimaryTriggerMode()) { primary = EnumInt(record.PrimaryTriggerMode().Type()); };
        };
        if IsDefined(active.GetCurrentTriggerMode()) { current = EnumInt(active.GetCurrentTriggerMode().Type()); };
        attack = IsDefined(active.GetCurrentRangedAttack()) && IsDefined(active.GetCurrentRangedAttack().DefaultFire());
        overheat = AIWeapon.CanWeaponOverheat(active);
        let stats: ref<StatsSystem> = GameInstance.GetStatsSystem(this.player.GetGame());
        let id: StatsObjectID = Cast<StatsObjectID>(entityID);
        numShots = stats.GetStatValue(id, gamedataStatType.NumShotsToFire);
        projectiles = stats.GetStatValue(id, gamedataStatType.ProjectilesPerShot);
        cycle = stats.GetStatValue(id, gamedataStatType.CycleTime);
      };
    };
    let psmWeapon: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Weapon);
    let upper: Int32 = bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody);
    let reasons: String = "";
    if !this.drawIssued { reasons += "draw_not_dispatched;"; };
    if !IsDefined(active) { reasons += "no_active_weapon;"; } else {
      if this.preparingWeapon && activeID != this.requestedItem { reasons += "item_id_mismatch;"; };
      if !attached { reasons += "not_attached;"; };
      if ammo <= 0 { reasons += "empty_or_unknown_magazine;"; };
      if !IsDefined(record) { reasons += "missing_weapon_record;"; };
      if !this.SupportedRecord(record) { reasons += "unsupported_record_or_primary_mode;"; };
      if !this.SupportedTrigger(IntEnum<gamedataTriggerMode>(current)) { reasons += "unsupported_current_mode;"; };
      if !attack { reasons += "missing_default_attack;"; };
      if overheat { reasons += "overheat_pool_present;"; };
      if !this.SupportedShotStats(numShots, projectiles, cycle) { reasons += "shot_stats_out_of_bounds;"; };
      if Cast<Float>(ammo) < numShots { reasons += "insufficient_ammo_for_shot;"; };
      if WeaponObject.GetWeaponChargeNormalized(active) > 0.0 || active.GetAIBlackboard().GetFloat(GetAllBlackboardDefs().AIShooting.maxChargedTimeStamp) > 0.0 { reasons += "charge_active;"; };
      if attack && !IsDefined(active.GetCurrentRangedAttack().DefaultFire().PlayerAttack()) { reasons += "missing_player_attack;"; };
    };
    let readiness: CName = this.WeaponReadinessFailure(active);
    let handState: CName = n"unavailable";
    let weaponState: CName = n"unavailable";
    if IsDefined(this.player.wePsychosisCombatEquipmentContext) {
      let hand: StateMachineIdentifier;
      hand.definitionName = n"Equipment";
      hand.referenceName = n"RightHand";
      handState = this.player.wePsychosisCombatEquipmentContext.GetStateMachineCurrentStateWithIdentifier(hand);
    };
    let weaponMachine: CName = n"unavailable";
    if IsDefined(active) { weaponState = active.WEPsychosisCombatState(); weaponMachine = active.wePsychosisCombatWeaponMachine; };
    if NotEquals(readiness, n"none") { reasons += NameToString(readiness) + ";"; };
    if strictChecked && !strictAllowed { reasons += "strict_context_denied;"; };
    let snapshot: String = s"requested=\(this.requestedItem) active=\(activeID) entity=\(entityID) drawIssued=\(this.drawIssued) attached=\(attached) ammo=\(ammo) weaponBBRaw=\(psmWeapon) upperBody=\(IntEnum<gamePSMUpperBodyStates>(upper)) type=\(itemType) evolution=\(evolution) primary=\(primary) current=\(current) defaultAttack=\(attack) overheatPool=\(overheat) NumShotsToFire=\(numShots) ProjectilesPerShot=\(projectiles) CycleTime=\(cycle) strictChecked=\(strictChecked) strictAllowed=\(strictAllowed) failures=[\(reasons)]";
    snapshot += s" rightHand=\(handState) weaponMachine=\(weaponMachine) weaponState=\(weaponState) readiness=\(readiness)";
    if IsDefined(active) { snapshot += s" \(active.WEPsychosisCombatStateDiagnostic()) \(active.WEPsychosisCombatStopDiagnostic(this.player))"; };
    if force || NotEquals(snapshot, this.debugWeaponSnapshot) {
      E(s"WE WEAPON gen=\(this.generation) stage=\(stage) remaining=\(this.drawDeadline - now) deadlineReached=\(now >= this.drawDeadline) result=\(this.result) rightHand=\(handState) weaponState=\(weaponState) readiness=\(readiness) weaponBBRaw=\(psmWeapon) \(snapshot)");
      this.debugWeaponSnapshot = snapshot;
    };
  }

  private func CanPrepareItem(item: wref<gameItemData>, equipment: ref<EquipmentSystemPlayerData>) -> Bool {
    if !IsDefined(item) { return false; };
    let record: ref<WeaponItem_Record> = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(item.GetID()));
    if !this.SupportedRecord(record) { return false; };
    return this.SupportedShotStats(item.GetStatValueByType(gamedataStatType.NumShotsToFire), item.GetStatValueByType(gamedataStatType.ProjectilesPerShot), item.GetStatValueByType(gamedataStatType.CycleTime))
      && equipment.IsEquippable(item);
  }

  private func WeaponSelectionPriority(item: wref<gameItemData>) -> Int32 {
    if !IsDefined(item) { return 99; };
    let record: ref<WeaponItem_Record> = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(item.GetID()));
    if !IsDefined(record) || !IsDefined(record.ItemType()) { return 99; };
    let kind: gamedataItemType = record.ItemType().Type();
    if Equals(kind, gamedataItemType.Wea_Handgun) || Equals(kind, gamedataItemType.Wea_Revolver) { return 0; };
    if Equals(kind, gamedataItemType.Wea_AssaultRifle) || Equals(kind, gamedataItemType.Wea_SubmachineGun) || Equals(kind, gamedataItemType.Wea_LightMachineGun) { return 1; };
    if Equals(kind, gamedataItemType.Wea_Rifle) || Equals(kind, gamedataItemType.Wea_PrecisionRifle) || Equals(kind, gamedataItemType.Wea_SniperRifle) { return 2; };
    if Equals(kind, gamedataItemType.Wea_Shotgun) || Equals(kind, gamedataItemType.Wea_ShotgunDual) { return 3; };
    return 99;
  }

  private func PrepareWeapon(now: Float) -> Void {
    if this.preparationTried { return; };
    this.preparationTried = true;
    let equipment: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(this.player);
    if !IsDefined(equipment) { this.result = n"equipment_unavailable"; return; };
    let transaction: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.player.GetGame());
    let items: array<wref<gameItemData>>;
    let item: wref<gameItemData>;
    let selected: ItemID;
    let bestPriority: Int32 = 99;
    let priority: Int32;
    let source: CName = n"equipment_slot";
    let active: wref<WeaponObject> = GameObject.GetActiveWeapon(this.player);
    let excluded: ItemID;
    if IsDefined(active) { excluded = active.GetItemID(); };
    let i: Int32 = 0;
    let slots: Int32 = equipment.GetNumberOfSlots(gamedataEquipmentArea.Weapon, true);
    while i < slots && bestPriority > 0 {
      item = transaction.GetItemData(this.player, equipment.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, i));
      priority = this.WeaponSelectionPriority(item);
      if priority < bestPriority && IsDefined(item) && item.GetID() != excluded && this.CanPrepareItem(item, equipment) {
        selected = item.GetID();
        bestPriority = priority;
      };
      i += 1;
    };
    if bestPriority > 0 {
      transaction.GetItemList(this.player, items);
      i = 0;
      while i < ArraySize(items) && bestPriority > 0 {
        priority = this.WeaponSelectionPriority(items[i]);
        if priority < bestPriority && IsDefined(items[i]) && items[i].GetID() != excluded && this.CanPrepareItem(items[i], equipment) {
          selected = items[i].GetID();
          bestPriority = priority;
          source = n"inventory";
        };
        i += 1;
      };
    };
    if !ItemID.IsValid(selected) {
      this.result = n"no_supported_firearm";
      E("Psychosis combat found no equippable supported firearm");
      return;
    };
    this.requestedItem = selected;
    if EdgerunnerLogs.IsEnabled() { E(s"WE WEAPON selection gen=\(this.generation) source=\(source) priority=\(bestPriority) previous=\(excluded) requested=\(selected)"); };
    this.drawDeadline = now + 3.0;
    this.preparingWeapon = true;
    this.result = n"draw_queued";
    let request: ref<WEPsychosisCombatDrawRequest> = new WEPsychosisCombatDrawRequest();
    request.psychosisCombat = this;
    EquipmentSystem.GetInstance(this.player).QueueRequest(request);
  }

  public func DispatchDraw() -> Void {
    if this.stopped || this.paused || !this.preparingWeapon || this.drawIssued { return; };
    if !this.CheckContext() { return; };
    if this.Now() >= this.drawDeadline { this.Stop(); return; };
    let equipment: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(this.player);
    if !IsDefined(equipment) { this.Stop(); return; };
    let item: wref<gameItemData> = GameInstance.GetTransactionSystem(this.player.GetGame()).GetItemData(this.player, this.requestedItem);
    if !this.CanPrepareItem(item, equipment) || !equipment.CheckWeaponAgainstGameplayRestrictions(this.requestedItem, true) {
      this.preparingWeapon = false;
      this.result = n"draw_rejected";
      return;
    };
    let request: ref<DrawItemRequest> = new DrawItemRequest();
    request.owner = this.player;
    request.itemID = this.requestedItem;
    request.equipAnimationType = gameEquipAnimationType.Default;
    this.drawIssued = true;
    this.result = n"waiting_for_weapon";
    this.player.wePsychosisDrawOwner = this;
    equipment.OnDrawItemRequest(request);
    E("Psychosis combat DrawItemRequest dispatched; waiting for matching Ready weapon");
  }

  public func ClaimFirstEquipSkip(player: ref<PlayerPuppet>, item: ItemID) -> Bool {
    if this.stopped || this.paused || !this.preparingWeapon || !this.drawIssued || player != this.player || item != this.requestedItem { return false; };
    if this.Now() >= this.drawDeadline || !this.ContextSafe() { return false; };
    E("Psychosis combat first-equip suppressed for matching draw request");
    return true;
  }

  private func Search(now: Float) -> Void {
    let query: TargetSearchQuery;
    let parts: array<TS_TargetPartInfo>;
    let candidates: array<wref<NPCPuppet>>;
    let ids: array<EntityID>;
    let component: wref<TargetingComponent>;
    let npc: wref<NPCPuppet>;
    let best: wref<NPCPuppet>;
    let position: Vector4;
    let bestDistance: Float = 16.0;
    let distance: Float;
    let i: Int32 = 0;
    let weapon: wref<WeaponObject>;
    let showOutline: Bool = this.outline && now >= this.outlineAfter;
    let traceSearch: Bool = EdgerunnerLogs.IsEnabled() && now >= this.debugSearchNext;
    if traceSearch { this.debugSearchNext = now + 1.0; };
    let canAttempt: Bool = this.shoot && !this.preparingWeapon && this.shots < 3 && this.attempts < 6 && now >= this.nextAttempt;
    if canAttempt {
      weapon = GameObject.GetActiveWeapon(this.player);
      let supportedKind: Bool = this.SupportedWeaponKind(weapon);
      canAttempt = supportedKind && this.SupportedWeapon(weapon);
      let flow: CName = !IsDefined(weapon) ? n"draw_missing" : (!supportedKind ? n"replace_unsupported" : (canAttempt ? n"use_equipped" : n"wait_equipped"));
      if EdgerunnerLogs.IsEnabled() && NotEquals(flow, this.debugWeaponFlow) {
        E(s"WE WEAPON flow gen=\(this.generation) action=\(flow) preparationTried=\(this.preparationTried)");
        this.debugWeaponFlow = flow;
        if IsDefined(weapon) { this.TraceWeaponWait(weapon, now, n"equipped_check", true, canAttempt, canAttempt); };
      };
      if !supportedKind && !this.preparationTried { this.PrepareWeapon(now); };
    };
    if EdgerunnerLogs.IsEnabled() && canAttempt { traceSearch = true; };
    if traceSearch {
      E(s"WE SEARCH gate gen=\(this.generation) shoot=\(this.shoot) preparing=\(this.preparingWeapon) shots=\(this.shots)/3 attempts=\(this.attempts)/6 cooldownRemaining=\(MaxF(0.0, this.nextAttempt - now)) canAttempt=\(canAttempt) result=\(this.result)");
    };
    if !showOutline && !canAttempt { return; };
    query.testedSet = TargetingSet.Visible;
    query.searchFilter = TSF_NPC();
    query.maxDistance = 15.0;
    query.filterObjectByDistance = true;
    query.ignoreInstigator = true;
    TargetSearchQuery.SetComponentFilter(query, TargetComponentFilterType.Shooting);
    this.targeting.GetTargetParts(this.player, query, parts);
    this.partsCount = ArraySize(parts);
    while i < Min(ArraySize(parts), 64) && ArraySize(ids) < 12 {
      component = TS_TargetPartInfo.GetComponent(parts[i]);
      if IsDefined(component) {
        npc = component.GetEntity() as NPCPuppet;
        if IsDefined(npc) && !ArrayContains(ids, npc.GetEntityID()) && this.VisualCandidate(npc) {
          ArrayPush(ids, npc.GetEntityID());
          ArrayPush(candidates, npc);
        };
      };
      i += 1;
    };
    if EdgerunnerLogs.IsEnabled() && this.crowdTraceShot == 0 { this.crowdRoster = ids; };
    if showOutline { this.ReconcileHighlights(candidates, ids); };
    if traceSearch { E(s"WE SEARCH collection gen=\(this.generation) nativeParts=\(ArraySize(parts)) inspectedParts=\(i) uniqueVisual=\(ArraySize(candidates)) partLimitReached=\(i >= 64 && ArraySize(parts) > i) candidateLimitReached=\(ArraySize(candidates) >= 12) radius=15 coneDeg=30"); };
    if !canAttempt { return; };
    let invalid: Int32 = 0;
    let noChest: Int32 = 0;
    let outsideCone: Int32 = 0;
    let noLOS: Int32 = 0;
    let eligible: Int32 = 0;
    let reason: CName;
    i = 0;
    while i < ArraySize(candidates) {
      npc = candidates[i];
      reason = n"eligible";
      if !this.FireCandidate(npc) {
        invalid += 1;
        reason = n"fire_candidate_rejected";
      } else { if !this.Chest(npc, position) {
        noChest += 1;
        reason = n"chest_unavailable";
      } else { if !this.CameraAligned(position, 0.8660254) {
        outsideCone += 1;
        reason = n"camera_unavailable_or_outside_cone";
      } else { if !this.targeting.IsVisibleTarget(this.player, npc) {
        noLOS += 1;
        reason = n"los_failed";
      } else {
        eligible += 1;
        distance = Vector4.Distance(npc.GetWorldPosition(), this.player.GetWorldPosition());
        if distance < bestDistance { best = npc; bestDistance = distance; };
      }; }; }; };
      if traceSearch { E(s"WE SEARCH candidate gen=\(this.generation) npc=\(npc.GetEntityID()) reason=\(reason)"); };
      i += 1;
    };
    if traceSearch { E(s"WE SEARCH result gen=\(this.generation) invalid=\(invalid) noChest=\(noChest) outsideCone=\(outsideCone) noLOS=\(noLOS) eligible=\(eligible) selected=\(IsDefined(best))"); };
    if IsDefined(best) && this.Chest(best, position) {
      let request: AimRequest;
      request.lookAtTarget = position;
      request.duration = 0.20;
      request.maxDuration = 0.45;
      request.precision = 0.01;
      request.adjustPitch = true;
      request.adjustYaw = true;
      request.endOnCameraInputApplied = true;
      request.endOnTimeExceeded = true;
      request.processAsInput = true;
      this.target = best;
      this.weapon = weapon;
      this.aiming = true;
      this.aimStarted = now;
      this.nextReadyAimCheck = now + 0.10;
      this.aimPoint = position;
      this.aimRefreshes = 0;
      this.nextAimRefresh = now + 0.10;
      this.nextAttempt = now + 1.5;
      this.attempts += 1;
      this.result = n"aim_requested";
      this.aimTargetID = best.GetEntityID();
      if EdgerunnerLogs.IsEnabled() {
        this.debugBeforeValid = this.ReadAimCamera(position, this.debugBeforeCosine, this.debugBeforeForward);
        E(s"WE AIM selected gen=\(this.generation) attempt=\(this.attempts) npc=\(this.aimTargetID) record=\(best.GetRecordID()) distance=\(bestDistance) weapon=\(weapon.GetItemID())");
        this.TraceAimSample(n"before_LookAt", now, position, this.debugBeforeValid, this.debugBeforeCosine, this.debugBeforeForward);
      };
      this.targeting.LookAt(this.player, request);
      if EdgerunnerLogs.IsEnabled() {
        let afterCosine: Float;
        let afterForward: Vector4;
        let afterValid: Bool = this.ReadAimCamera(position, afterCosine, afterForward);
        this.TraceAimSample(n"immediately_after_LookAt", this.Now(), position, afterValid, afterCosine, afterForward);
      };
      E("Psychosis combat aim requested");
    } else {
      this.result = n"no_valid_target";
    };
  }

  public func OnReadyAimUpdate(player: ref<PlayerPuppet>, weapon: ref<WeaponObject>, bridge: ref<StateGameScriptInterface>) -> Void {
    if this.stopped || this.paused || !this.aiming || player != this.player || weapon != this.weapon { return; };
    if !IsDefined(bridge) || bridge.owner != weapon || bridge.executionOwner != player { return; };
    let now: Float = this.Now();
    if now < this.nextReadyAimCheck { return; };
    this.nextReadyAimCheck = now + 0.10;
    if !this.CheckContext() { return; };
    weapon.wePsychosisCombatWeaponInterface = bridge;
    this.CheckAim(now);
  }

  private func CheckAim(now: Float) -> Void {
    let position: Vector4;
    if now - this.aimStarted > 0.45 { this.RejectAim(now, n"deadline_exceeded"); return; };
    if !this.FireCandidate(this.target) { this.RejectAim(now, n"target_invalid"); return; };
    if GameObject.GetActiveWeapon(this.player) != this.weapon { this.RejectAim(now, n"weapon_changed"); return; };
    if !this.SupportedWeapon(this.weapon) { this.RejectAim(now, n"weapon_not_supported_ready_or_loaded"); return; };
    let cosine: Float;
    let forward: Vector4;
    let chestValid: Bool = this.Chest(this.target, position);
    let cameraValid: Bool = chestValid && this.ReadAimCamera(position, cosine, forward);
    this.TraceAimSample(n"tick_after_LookAt", now, position, cameraValid, cosine, forward);
    if now - this.aimStarted < 0.20 {
      if cameraValid && cosine < 0.9999619 { this.RefreshMovingAim(now, position, cosine, false, false); };
      return;
    };
    let angleOK: Bool = cameraValid && cosine >= 0.9999619;
    let finishWindow: Bool = now - this.aimStarted >= 0.35;
    let directionalOK: Bool = cameraValid && cosine >= 0.8660254;
    let queryAllowed: Bool = angleOK || (finishWindow && directionalOK);
    let los: Bool;
    let lookedAt: ref<GameObject>;
    let lookedAtID: EntityID;
    if queryAllowed { los = this.targeting.IsVisibleTarget(this.player, this.target); };
    if queryAllowed && los {
      lookedAt = this.targeting.GetLookAtObject(this.player, true, true);
      if IsDefined(lookedAt) { lookedAtID = lookedAt.GetEntityID(); };
    };
    let targetMatch: Bool = IsDefined(lookedAt) && lookedAt == this.target;
    let crosshairNPC: ref<NPCPuppet> = lookedAt as NPCPuppet;
    let crosshairAllowed: Bool = !IsDefined(lookedAt) || targetMatch || (IsDefined(crosshairNPC) && this.FireCandidate(crosshairNPC));
    let fireAllowed: Bool = los && crosshairAllowed && ((angleOK && targetMatch) || (finishWindow && directionalOK));
    if EdgerunnerLogs.IsEnabled() {
      E(s"WE AIM decision gen=\(this.generation) attempt=\(this.attempts) npc=\(this.aimTargetID) fireAllowed=\(fireAllowed) contextPhaseWeaponTargetPassed=true elapsed=\(now - this.aimStarted) chestValid=\(chestValid) angleOK=\(angleOK) finishWindow=\(finishWindow) directionalOK=\(directionalOK) losChecked=\(queryAllowed) los=\(los) crosshairChecked=\(queryAllowed && los) crosshairID=\(lookedAtID) targetMatch=\(targetMatch) crosshairAllowed=\(crosshairAllowed)");
      if fireAllowed {
        let reason: CName = angleOK && targetMatch ? n"precise_alignment" : (targetMatch ? n"finish_on_selected_npc" : (IsDefined(crosshairNPC) ? n"finish_on_other_valid_npc" : n"finish_imprecise"));
        E(s"WE AIM FIRE gen=\(this.generation) attempt=\(this.attempts) npc=\(this.aimTargetID) reason=\(reason) crosshairID=\(lookedAtID); LOS + valid context/weapon/target; deliberate misses allowed in final window");
      };
    };
    if fireAllowed {
      if !this.weapon.WEPsychosisCombatCanStopFire(this.player) { this.RejectAim(now, n"stop_interface_owner_mismatch"); return; };
      let stats: ref<StatsSystem> = GameInstance.GetStatsSystem(this.player.GetGame());
      let weaponID: StatsObjectID = Cast<StatsObjectID>(this.weapon.GetEntityID());
      let cooldown: Float = MaxF(1.5, stats.GetStatValue(weaponID, gamedataStatType.CycleTime));
      let mode: gamedataTriggerMode = this.weapon.GetCurrentTriggerMode().Type();
      if EdgerunnerLogs.IsEnabled() { E(s"WE AIM fire_profile mode=\(mode) ammoCost=\(stats.GetStatValue(weaponID, gamedataStatType.NumShotsToFire)) projectiles=\(stats.GetStatValue(weaponID, gamedataStatType.ProjectilesPerShot)) cooldown=\(cooldown) smartLockRequested=false chargeRequested=false"); };
      if EdgerunnerLogs.IsEnabled() {
        this.crowdTraceShot = this.shots + 1;
      };
      AIWeapon.Fire(this.player, this.weapon, now, 1.0, mode);
      let nativeStop: Bool = this.weapon.WEPsychosisCombatStopFire(this.player);
      WeaponObject.TriggerWeaponEffects(this.weapon, gamedataFxAction.ExitShoot);
      if EdgerunnerLogs.IsEnabled() { E(s"WE AIM shot_end gen=\(this.generation) attempt=\(this.attempts) weapon=\(this.weapon.GetEntityID()) nativeStop=\(nativeStop) action=ExitShoot"); };
      this.shots += 1;
      this.result = n"fire_called";
      this.ReleaseAim();
      if !nativeStop { this.result = n"native_stop_failed"; this.Stop(); return; };
      this.nextAttempt = now + cooldown;
      E("Psychosis combat Fire called after directional and LOS checks");
    } else {
      if cameraValid { this.RefreshMovingAim(now, position, cosine, queryAllowed, los); };
    };
  }

  private func RefreshMovingAim(now: Float, position: Vector4, cosine: Float, losChecked: Bool, los: Bool) -> Void {
    let remaining: Float = 0.45 - (now - this.aimStarted);
    if this.aimRefreshes >= 2 || now < this.nextAimRefresh || remaining < 0.10 { return; };
    let moved: Float = Vector4.Distance(position, this.aimPoint);
    if moved < 0.075 { return; };
    if cosine < 0.8660254 { this.RejectAim(now, n"tracking_outside_cone"); return; };
    if !losChecked { los = this.targeting.IsVisibleTarget(this.player, this.target); };
    if !los { this.RejectAim(now, n"tracking_los_lost"); return; };
    let request: AimRequest;
    request.lookAtTarget = position;
    request.duration = 0.10;
    request.maxDuration = remaining;
    request.precision = 0.01;
    request.adjustPitch = true;
    request.adjustYaw = true;
    request.endOnCameraInputApplied = true;
    request.endOnTimeExceeded = true;
    request.processAsInput = true;
    this.targeting.BreakLookAt(this.player);
    this.targeting.LookAt(this.player, request);
    this.aimPoint = position;
    this.aimRefreshes += 1;
    this.nextAimRefresh = this.aimRefreshes == 1 ? MaxF(now + 0.10, this.aimStarted + 0.25) : now + 0.10;
    if EdgerunnerLogs.IsEnabled() {
      E(s"WE AIM tracking gen=\(this.generation) attempt=\(this.attempts) npc=\(this.aimTargetID) refresh=\(this.aimRefreshes)/2 elapsed=\(now - this.aimStarted) remaining=\(remaining) moved=\(moved) point=\(position) los=true");
    };
  }

  private func SendHighlight(entry: ref<WEPsychosisCombatHighlight>, apply: Bool) -> Void {
    let event: ref<ForceVisionApperanceEvent> = new ForceVisionApperanceEvent();
    event.forcedHighlight = entry.data;
    event.apply = apply;
    if IsDefined(entry.npc) {
      entry.npc.QueueEvent(event);
    } else {
      if IsDefined(this.player) { this.player.QueueEventForEntityID(entry.id, event); };
    };
  }

  private func ReconcileHighlights(candidates: array<wref<NPCPuppet>>, ids: array<EntityID>) -> Void {
    let i: Int32 = ArraySize(this.highlights) - 1;
    let j: Int32;
    let found: Bool;
    let entry: ref<WEPsychosisCombatHighlight>;
    while i >= 0 {
      if !ArrayContains(ids, this.highlights[i].id) || !IsDefined(this.highlights[i].npc) {
        this.SendHighlight(this.highlights[i], false);
        ArrayErase(this.highlights, i);
      };
      i -= 1;
    };
    i = 0;
    while i < ArraySize(ids) {
      found = false;
      j = 0;
      while j < ArraySize(this.highlights) {
        if this.highlights[j].id == ids[i] { found = true; break; };
        j += 1;
      };
      if !found {
        entry = new WEPsychosisCombatHighlight();
        entry.id = ids[i];
        entry.npc = candidates[i];
        entry.data = new FocusForcedHighlightData();
        entry.data.sourceID = this.player.GetEntityID();
        entry.data.sourceName = n"WannabeEdgerunner.PsychosisCombat";
        entry.data.highlightType = EFocusForcedHighlightType.INVALID;
        entry.data.outlineType = EFocusOutlineType.HOSTILE;
        entry.data.priority = EPriority.VeryLow;
        entry.data.inTransitionTime = 0.1;
        entry.data.outTransitionTime = 0.1;
        entry.data.isSavable = false;
        entry.data.isRevealed = false;
        ArrayPush(this.highlights, entry);
        this.SendHighlight(entry, true);
      };
      i += 1;
    };
  }

  public func PrintStatus() -> Void {
    FTLog(s"WE preparationTried=\(this.preparationTried) preparing=\(this.preparingWeapon) drawIssued=\(this.drawIssued) requestedItem=\(this.requestedItem) result=\(this.result)");
    FTLog(s"WE psychosisCombat stopped=\(this.stopped) paused=\(this.paused) generation=\(this.generation) aiming=\(this.aiming) attempts=\(this.attempts)/6 FireCalls=\(this.shots)/3 outlines=\(ArraySize(this.highlights)) nativeParts=\(this.partsCount)");
  }
}




