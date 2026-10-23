module LimitedHudCommon

public class LhudCooldownTracker extends ScriptableSystem {

  private let items: array<ItemID>;

  public static func Get(gi: GameInstance) -> ref<LhudCooldownTracker> {
    let system: ref<LhudCooldownTracker> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"LimitedHudCommon.LhudCooldownTracker") as LhudCooldownTracker;
    return system;
  }

  public final func SwapIds(oldItemId: ItemID, newItemId: ItemID) -> Void {
    let changed: Bool = this.Remove(oldItemId);
    if changed {
      changed = this.Add(newItemId) || changed;
      this.Notify();
    };
  }

  public final func ClearItem(itemId: ItemID) -> Void {
    if this.Remove(itemId) {
      this.Notify();
    };
  }

  public final func Add(itemId: ItemID) -> Bool {
    if !this.Exists(itemId) && ItemID.IsValid(itemId) {
      ArrayPush(this.items, itemId);
      return true;
    };

    return false;
  }

  public final func Remove(itemId: ItemID) -> Bool {
   if this.Exists(itemId) {
      ArrayRemove(this.items, itemId);
      return true;
    };

    return false;
  }

  public final func Exists(itemId: ItemID) -> Bool {
    return ArrayContains(this.items, itemId);
  }

  public final func IsNotEmpty() -> Bool {
    return NotEquals(ArraySize(this.items), 0);
  }

  public final func Notify() -> Void {
    GetPlayer(this.GetGameInstance()).QueueLHUDEvent(LHUDEventType.Cooldown, this.IsNotEmpty());
  }
}
