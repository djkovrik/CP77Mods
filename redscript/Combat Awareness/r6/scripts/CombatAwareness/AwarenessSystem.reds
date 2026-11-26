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

  public let player: wref<PlayerPuppet>;
  public let reportRevision: Int32;
  public let scannerHintRow: wref<inkCompoundWidget>;
  private let pending: ref<ApplyLayout>;
  private let layoutTimer: DelayID;
  private let enteringAway: Bool;
  private let lastContact: EntityID;
  private let lastContactAway: Bool;

  public static func Get(gi: GameInstance) -> ref<AwarenessSystem> {
    return GameInstance.GetScriptableSystemsContainer(gi).Get(n"CombatAwareness.AwarenessSystem") as AwarenessSystem;
  }

  private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.player = request.owner as PlayerPuppet;
    this.Restore();
  }

  private func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
    this.Interrupt();
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

    this.reportRevision += 1;

    let empty: EntityID;
    this.lastContact = empty;
    this.enteringAway = false;

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

    this.Sync();
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
        this.hasPost = false;
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
}
