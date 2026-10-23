import Edgerunning.System.EdgerunningSystem

public class WEPassiveRecoveryTick extends DelayCallback {
  public let owner: wref<WEPassiveRecovery>;
  public func Call() -> Void {
    if IsDefined(this.owner) { this.owner.Tick(); };
  }
}

public class WEPassiveRecovery {
  private let system: wref<EdgerunningSystem>;
  private let player: wref<PlayerPuppet>;
  private let delays: ref<DelaySystem>;
  private let time: ref<TimeSystem>;
  private let pending: DelayID;
  private let stopped: Bool;
  private let settling: Bool;
  private let allowed: Bool;
  private let lastTime: Double;
  private let loading: Bool;
  private let inCombat: Bool;
  private let menu: ref<IBlackboard>;
  private let photo: ref<IBlackboard>;
  private let braindance: ref<IBlackboard>;
  private let travel: ref<IBlackboard>;
  private let psm: ref<IBlackboard>;
  private let menuListener: ref<CallbackHandle>;
  private let photoListener: ref<CallbackHandle>;
  private let braindanceListener: ref<CallbackHandle>;
  private let travelStartListener: ref<CallbackHandle>;
  private let loadingStartListener: ref<CallbackHandle>;
  private let loadingEndListener: ref<CallbackHandle>;
  private let combatListener: ref<CallbackHandle>;
  private let sceneListener: ref<CallbackHandle>;
  private let vitalsListener: ref<CallbackHandle>;

  public func Start(system: ref<EdgerunningSystem>, player: ref<PlayerPuppet>) -> Void {
    this.system = system;
    this.player = player;
    this.delays = GameInstance.GetDelaySystem(player.GetGame());
    this.time = GameInstance.GetTimeSystem(player.GetGame());
    let boards: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(player.GetGame());
    this.menu = boards.Get(GetAllBlackboardDefs().UI_System);
    this.photo = boards.Get(GetAllBlackboardDefs().PhotoMode);
    this.braindance = boards.Get(GetAllBlackboardDefs().Braindance);
    this.travel = boards.Get(GetAllBlackboardDefs().FastTRavelSystem);
    this.psm = player.GetPlayerStateMachineBlackboard();
    this.menuListener = this.menu.RegisterListenerBool(GetAllBlackboardDefs().UI_System.IsInMenu, this, n"OnContextBool");
    this.photoListener = this.photo.RegisterListenerBool(GetAllBlackboardDefs().PhotoMode.IsActive, this, n"OnContextBool");
    this.braindanceListener = this.braindance.RegisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this, n"OnContextBool");
    this.travelStartListener = this.travel.RegisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelStarted, this, n"OnLoadingStarted");
    this.loadingStartListener = this.travel.RegisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelLoadingScreenStarted, this, n"OnLoadingStarted");
    this.loadingEndListener = this.travel.RegisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelLoadingScreenFinished, this, n"OnLoadingFinished");
    this.combatListener = this.psm.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombat");
    this.sceneListener = this.psm.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel, this, n"OnContextInt");
    this.vitalsListener = this.psm.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Vitals, this, n"OnContextInt");
    this.RefreshContext();
    this.inCombat = this.psm.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == 1;
    if this.inCombat { system.ResetPassiveRecoveryDelay(); };
    this.Schedule();
  }

  private func Now() -> Double {
    return EngineTime.ToDouble(GameInstance.GetEngineTime(this.player.GetGame()));
  }

  private func CanAdvance() -> Bool {
    if this.stopped || !IsDefined(this.system) || !IsDefined(this.player) || this.system.GetPlayer() != this.player { return false; };
    if this.loading || this.time.IsPausedState() || !this.system.IsPassiveRecoveryContextSafe() { return false; };
    let tier: Int32 = this.psm.GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    return !this.menu.GetBool(GetAllBlackboardDefs().UI_System.IsInMenu)
      && !this.photo.GetBool(GetAllBlackboardDefs().PhotoMode.IsActive)
      && !this.braindance.GetBool(GetAllBlackboardDefs().Braindance.IsActive)
      && this.psm.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) != 1
      && !(tier >= 3 && tier <= 5);
  }

  public func RefreshContext() -> Void {
    if this.stopped || !IsDefined(this.player) { return; };
    this.lastTime = this.Now();
    this.allowed = this.CanAdvance();
  }

  private func Accrue() -> Void {
    if this.stopped || this.settling || !IsDefined(this.player) || !IsDefined(this.system) { return; };
    let now: Double = this.Now();
    let elapsed: Float = Cast<Float>(now - this.lastTime);
    this.lastTime = now;
    // A suspended runtime has no trustworthy active-time interval to award on resume.
    if this.allowed && elapsed > 0.0 && elapsed <= 5.0 {
      this.settling = true;
      this.system.AdvancePassiveRecovery(elapsed);
      this.settling = false;
    };
  }

  protected cb func OnContextBool(value: Bool) -> Bool {
    this.Accrue();
    this.RefreshContext();
  }

  protected cb func OnContextInt(value: Int32) -> Bool {
    this.Accrue();
    this.RefreshContext();
  }

  protected cb func OnCombat(value: Int32) -> Bool {
    if this.stopped { return false; };
    this.Accrue();
    let inCombat: Bool = value == 1;
    if NotEquals(inCombat, this.inCombat) { this.system.ResetPassiveRecoveryDelay(); };
    this.inCombat = inCombat;
    this.RefreshContext();
  }

  protected cb func OnLoadingStarted(value: Bool) -> Bool {
    if value {
      this.Accrue();
      this.loading = true;
      this.RefreshContext();
    };
  }

  protected cb func OnLoadingFinished(value: Bool) -> Bool {
    if value {
      this.loading = false;
      this.RefreshContext();
    };
  }

  private func Schedule() -> Void {
    if this.stopped { return; };
    let callback: ref<WEPassiveRecoveryTick> = new WEPassiveRecoveryTick();
    callback.owner = this;
    this.pending = this.delays.DelayCallback(callback, 1.0, false);
  }

  public func Tick() -> Void {
    this.pending = GetInvalidDelayID();
    if this.stopped { return; };
    let allowed: Bool = this.CanAdvance();
    if !allowed { this.allowed = false; };
    this.Accrue();
    this.allowed = allowed;
    this.Schedule();
  }

  public func Stop() -> Void {
    if this.stopped { return; };
    this.stopped = true;
    this.delays.CancelCallback(this.pending);
    this.pending = GetInvalidDelayID();
    this.menu.UnregisterListenerBool(GetAllBlackboardDefs().UI_System.IsInMenu, this.menuListener);
    this.photo.UnregisterListenerBool(GetAllBlackboardDefs().PhotoMode.IsActive, this.photoListener);
    this.braindance.UnregisterListenerBool(GetAllBlackboardDefs().Braindance.IsActive, this.braindanceListener);
    this.travel.UnregisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelStarted, this.travelStartListener);
    this.travel.UnregisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelLoadingScreenStarted, this.loadingStartListener);
    this.travel.UnregisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelLoadingScreenFinished, this.loadingEndListener);
    this.psm.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.combatListener);
    this.psm.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel, this.sceneListener);
    this.psm.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Vitals, this.vitalsListener);
  }
}
