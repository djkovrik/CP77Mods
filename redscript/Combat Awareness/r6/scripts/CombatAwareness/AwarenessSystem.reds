module CombatAwareness

public class AwarenessSystem extends ScriptableSystem {
  public persistent let layout: Int32;
  public persistent let spent: Int32;

  public let player: wref<PlayerPuppet>;
  private let pending: ref<ApplyLayout>;
  private let layoutTimer: DelayID;

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

  private func Restore() -> Void {
    if !IsDefined(this.player) { 
      return; 
    }

    this.Interrupt();

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
}
