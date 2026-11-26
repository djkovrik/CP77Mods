module CombatAwareness

public class AwarenessSystem extends ScriptableSystem {
  public persistent let layout: Int32;
  public persistent let spent: Int32;
  public persistent let studied: EntityID;

  private persistent let group: CName;
  private persistent let anchor: Vector4;
  private persistent let anchorSource: EntityID;
  private persistent let hasPost: Bool;
  private persistent let reports: array<EntityID>;
  private persistent let detected: Bool;
  private persistent let reactionEnd: Float;
  private persistent let episode: Int32;

  public let player: wref<PlayerPuppet>;
  public let reportRevision: Int32;
  public let scannerHintRow: wref<inkCompoundWidget>;

  private let pending: ref<ApplyLayout>;
  private let layoutTimer: DelayID;
  private let reactionRequest: ref<CloseReaction>;
  private let reactionTimer: DelayID;
  private let enteringAway: Bool;
  private let lastContact: EntityID;
  private let lastContactAway: Bool;
  private let amplifiedShot: ref<PreparedShot>;
  private let deflectedShot: ref<PreparedShot>;

  public static func Get(gi: GameInstance) -> ref<AwarenessSystem> {
    return GameInstance.GetScriptableSystemsContainer(gi).Get(n"CombatAwareness.AwarenessSystem") as AwarenessSystem;
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.player = request.owner as PlayerPuppet;
    this.Restore();
  }

  private func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
    this.Interrupt();
    this.CancelReactionTimer();
    this.player = null;
  }

  public func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.Restore();
  }

  private func StudiedNPC() -> ref<NPCPuppet> {
    if !EntityID.IsDefined(this.studied) { return null; };
    return GameInstance.FindEntityByID(this.GetGameInstance(), this.studied) as NPCPuppet;
  }

  public func ToggleStudy(target: ref<NPCPuppet>) -> Void {
    if this.studied == target.GetEntityID() {
      target.CAHideStudyMarker();
      this.studied = EntityID();
      return;
    };

    let old: ref<NPCPuppet> = this.StudiedNPC();
    if IsDefined(old) { 
      old.CAHideStudyMarker(); 
    };

    this.Contact(target);
    this.studied = target.GetEntityID();
    target.CAShowStudyMarker();
  }

  private func Restore() -> Void {
    this.Interrupt();
    this.CancelReactionTimer();

    this.reportRevision += 1;

    let empty: EntityID;
    this.lastContact = empty;
    this.enteringAway = false;

    this.amplifiedShot = null;
    this.deflectedShot = null;

    if !IsDefined(this.player) { 
      return; 
    };
    let target = this.StudiedNPC();

    if IsDefined(target) { 
      target.CAShowStudyMarker(); 
    };

    if Training.Total(this.layout) > Training.Budget() { 
      this.layout = 0; 
    };

    if this.reactionEnd > 0.0 {
      let remaining = this.reactionEnd - this.Now();
      if remaining > 0.0 {
        this.ScheduleReaction(MinF(remaining, Training.ReactionSeconds()));
      } else {
        this.reactionEnd = 0.0;
        this.Spend(1);
      };
    };

    this.Sync();
  }

  private func Now() -> Float {
    return EngineTime.ToFloat(GameInstance.GetTimeSystem(this.GetGameInstance()).GetSimTime());
  }

  public func Confirm(mask: Int32) -> Void {
    if mask < 0 || mask > 127 || Training.Total(mask) > Training.Budget() { 
      return; 
    }

    this.Interrupt();
    
    if mask == this.layout { 
      return; 
    }
    
    if this.player.IsInCombat() {
      let request: ref<ApplyLayout> = new ApplyLayout();
      request.layout = mask;
      this.pending = request;
      this.layoutTimer = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(this.GetClassName(), request, 2.0, true);
    } else {
      this.layout = mask;
      this.Sync();
    };
  }

  public func Interrupt() -> Void {
    if IsDefined(this.pending) {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.layoutTimer);
      this.pending = null;
    }
  }

  private func OnApplyLayout(request: ref<ApplyLayout>) -> Void {
    if this.pending == request {
      this.pending = null;
      this.layout = request.layout;
      this.Sync();
    }
  }

  private func Available(slot: Int32) -> Bool {
    let bit: Int32 = Training.Bit(slot);

    return (this.layout & bit) != 0 
      && (this.spent & bit) == 0 
      && IsDefined(this.player);
  }

  public func Ready(slot: Int32) -> Bool {
    if !this.Available(slot) { 
      return false ; 
    };

    if slot == 1 && this.reactionEnd > 0.0 { 
      return this.Now() < this.reactionEnd; 
    };

    return StatusEffectSystem.ObjectHasStatusEffect(this.player, Training.Record(slot));
  }

  // sync with V real state
  public func Spend(slot: Int32) -> Void {
    let bit = Training.Bit(slot);

    if (this.spent & bit) == 0 {
      this.spent = this.spent | bit;
      this.SyncSlot(slot);
    };
  }

  private func SetEffect(id: TweakDBID, wanted: Bool) -> Bool {
    if Equals(wanted, StatusEffectSystem.ObjectHasStatusEffect(this.player, id)) { 
      return false; 
    }

    if wanted { 
      return StatusEffectHelper.ApplyStatusEffect(this.player, id); 
    }

    return StatusEffectHelper.RemoveStatusEffect(this.player, id);
  }

  private func SyncSlot(slot: Int32) -> Void {
    if !IsDefined(this.player) { 
      return; 
    }

    let id: TweakDBID = Training.Record(slot);
    let wanted: Bool = this.Available(slot);

    if slot == 1 {
      let window = Training.ReactionWindow();
      if this.reactionEnd > 0.0 {
        this.SetEffect(id, false);
        let remaining = this.reactionEnd - this.Now();
        let showWindow = wanted && remaining > 0.0;
        this.SetEffect(window, showWindow);
        if showWindow {
          GameInstance.GetStatusEffectSystem(this.GetGameInstance()).SetStatusEffectRemainingDuration(this.player.GetEntityID(), window,remaining);
        };
        return;
      };
      this.SetEffect(window, false);
    };

    this.SetEffect(id, wanted);
  }

  private func Sync() -> Void {
    let i = 0;
    while i < 7 { this.SyncSlot(i); i += 1; };
  }

  public func EnterCombat() -> Void {
    this.enteringAway = this.hasPost 
      && IsDefined(this.player) 
      && Vector4.Distance(this.player.GetWorldPosition(), this.anchor) > 18.0; // hardcoded for now
  }

  public func HasReport(source: EntityID) -> Bool {
    return ArrayContains(this.reports, source);
  }

  public func RecordReport(source: EntityID) -> Bool {
    if this.HasReport(source) { 
      return false; 
    }

    ArrayPush(this.reports, source);
    this.reportRevision += 1;

    return true;
  }

  public func Contact(source: ref<GameObject>) -> Void {
    if !IsDefined(source) || !IsDefined(this.player) { 
      return; 
    };

    let mayStart: Bool = this.enteringAway || !this.player.IsInCombat();
    this.enteringAway = false;

    let away: Bool = mayStart 
      && this.hasPost 
      && Vector4.DistanceSquared(this.player.GetWorldPosition(), this.anchor) > 324.0;

    if this.lastContact == source.GetEntityID() && Equals(this.lastContactAway, away) {
       return ; 
    };

    this.lastContact = source.GetEntityID();
    this.lastContactAway = away;

    let pos = source.GetWorldPosition();
    let squad: CName;

    if IsDefined(source as NPCPuppet) { 
      squad = AISquadHelper.GetSquadName(source); 
    };

    let sourceDistance = Vector4.Distance(pos, this.anchor);
    let knownSquads = IsNameValid(squad) && IsNameValid(this.group);

    if away 
      && source.GetEntityID() != this.anchorSource
      && (knownSquads ? NotEquals(squad, this.group) 
      && sourceDistance > 18.0 : sourceDistance > 90.0) {
        if this.player.IsBeingRevealed() || PreventionSystem.IsChasingPlayer(this.GetGameInstance()) {
          this.lastContactAway = false;
          return;
        }

        this.spent = 0;
        this.detected = false;
        this.reactionEnd = 0.0;
        this.CancelReactionTimer();
        this.episode += 1;
        this.hasPost = false;
        this.amplifiedShot =null;
        this.deflectedShot = null;
        this.Sync();
    };

    if !this.hasPost {
      this.hasPost = true;
      this.anchor = pos;
      this.anchorSource = source.GetEntityID();
      this.group = squad;
    } else {
      if !IsNameValid(this.group) && IsNameValid(squad) { 
        this.group = squad; 
      };
    };
  }

  public func Detect(source: ref<GameObject>) -> Void {
    if !IsDefined(this.player) { 
      return; 
    }

    this.Contact(source);

    if this.detected { 
      return; 
    }

    this.detected = true;

    if this.Ready(1) {
      this.ScheduleReaction(Training.ReactionSeconds());
      this.SyncSlot(1);
    } else {
      this.Spend(1);
    };
  }

  private func ScheduleReaction(seconds: Float) -> Void {
    let request: ref<CloseReaction> = new CloseReaction();
    request.episode = this.episode;
    this.reactionRequest = request;
    this.reactionEnd = this.Now() + seconds;
    this.reactionTimer = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(this.GetClassName(), request, seconds, true);
  }

  private func CancelReactionTimer() -> Void {
    if IsDefined(this.reactionRequest) {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.reactionTimer);
      this.reactionRequest = null;
    };
  }

  private func OnCloseReaction(request: ref<CloseReaction>) -> Void {
    if this.reactionRequest == request && request.episode == this.episode {
      this.reactionRequest = null;
      this.reactionEnd = 0.0;
      this.Spend(1);
    };
  }

  public func Maneuver() -> Bool {
    if this.reactionEnd <= 0.0 || !this.Ready(1) { return false; };
    this.reactionEnd = 0.0;
    this.CancelReactionTimer();
    this.Spend(1);
    return true;
  }

  public func Amplify(hit: ref<gameHitEvent>) -> Bool {
    if IsDefined(this.amplifiedShot) { 
      return this.amplifiedShot.Matches(hit); 
    };

    if hit.target.GetEntityID() != this.studied || !this.Ready(3) { 
      return false; 
    };

    this.amplifiedShot = PreparedShot.FromHit(hit);
    this.Spend(3);

    return true;
  }

  public func Deflect(hit: ref<gameHitEvent>) -> Bool {
    if IsDefined(this.deflectedShot) { 
      return this.deflectedShot.Matches(hit); 
    }

    if (this.spent & Training.Bit(4)) != 0 { 
      return false;
    }

    let ready = this.Ready(4);
    this.Spend(4);

    if ready {
      this.deflectedShot = PreparedShot.FromHit(hit);
    };

    return ready;
  }
}
