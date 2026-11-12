module ReducedLoot

public struct ReducedLootPersonalItem {
  public let item: ItemID;
  public let previous: Int32;
}

public struct ReducedLootBodyDecision {
  public let item: ItemID;
  public let profile: Int32;
  public let remove: Bool;
  public let applied: Bool;
}

public class ReducedLootSession extends ScriptableSystem {
  public let settings: ref<ReducedLootSettings>;
  public let epoch: Uint32;
  private let lock: RWLock;
  private let placements: ref<inkIntHashMap>;
  private let containers: ref<inkIntHashMap>;
  private let bodies: ref<inkIntHashMap>;
  private let decisions: array<ReducedLootBodyDecision>;
  private let personalHeads: ref<inkIntHashMap>;
  private let personal: array<ReducedLootPersonalItem>;
  private let profiles: array<Uint8>;

  public final static func Get(game: GameInstance) -> ref<ReducedLootSession> {
    return GameInstance.GetScriptableSystemsContainer(game).Get(n"ReducedLoot.ReducedLootSession") as ReducedLootSession;
  }

  public func OnAttach() -> Void {
    this.settings = new ReducedLootSettings();
    ModSettings.RegisterListenerToClass(this.settings);
    this.Reset(true);
  }

  public func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.Reset(true);
  }

  public func OnDetach() -> Void {
    this.Reset(false);
    ModSettings.UnregisterListenerToClass(this.settings);
    this.settings = null;
  }

  private final func Reset(open: Bool) -> Void {
    RWLock.Acquire(this.lock);
    this.epoch += 1u;
    ArrayClear(this.decisions);
    ArrayClear(this.personal);
    ArrayClear(this.profiles);
    this.containers = null;
    this.placements = null;
    this.bodies = null;
    this.personalHeads = null;
    if open {
      this.containers = new inkIntHashMap();
      this.placements = new inkIntHashMap();
      this.bodies = new inkIntHashMap();
      this.personalHeads = new inkIntHashMap();
    };
    RWLock.Release(this.lock);
  }

  public final func Active() -> Bool {
    return IsDefined(this.settings) && this.settings.enabled && IsDefined(this.placements);
  }

  private final func Intern(values: script_ref<array<Uint8>>) -> Int32 {
    let offset: Int32 = 0;
    let i: Int32;
    while offset < ArraySize(this.profiles) {
      i = 0;
      while i < 17 && this.profiles[offset + i] == Deref(values)[i] { i += 1; };
      if i == 17 { return offset / 17; };
      offset += 17;
    };
    for value in Deref(values) { ArrayPush(this.profiles, value); };
    return offset / 17;
  }

  public final static func Roll(chance: Uint8) -> Bool {
    return Cast<Int32>(chance) >= 100 || (Cast<Int32>(chance) > 0 && RandRange(0, 100) < Cast<Int32>(chance));
  }

  public final func SuppressPlacement(source: Uint64, category: Int32) -> Bool {
    let values: array<Uint8>;
    let packed: Int32;
    let remove: Bool;
    RWLock.Acquire(this.lock);
    if this.Active() && source != 0ul {
      if this.placements.KeyExist(source) {
        remove = this.placements.Get(source) % 2 == 1;
      } else {
        values = this.settings.Profile();
        remove = ReducedLootSession.Roll(values[category]);
        packed = 2 * this.Intern(values);
        this.placements.Insert(source, packed + (remove ? 1 : 0));
      };
    };
    RWLock.Release(this.lock);
    return remove;
  }

  public final func SeenContainer(source: Uint64) -> Bool {
    let seen: Bool;
    RWLock.Acquire(this.lock);
    seen = !this.Active() || this.containers.KeyExist(source);
    RWLock.Release(this.lock);
    return seen;
  }

  public final func ClaimContainer(source: Uint64, epoch: Uint32) -> Bool {
    let claim: Bool;
    RWLock.Acquire(this.lock);
    claim = this.Active() && this.epoch == epoch && source != 0ul && !this.containers.KeyExist(source);
    if claim { this.containers.Insert(source, 1); };
    RWLock.Release(this.lock);
    return claim;
  }

  // Both body adapters establish the first false-to-true loot generation. A failed removal consumes it too.
  public final func ClaimBody(source: Uint64, epoch: Uint32, item: ItemID) -> Bool {
    let row: ReducedLootBodyDecision;
    let values: array<Uint8>;
    RWLock.Acquire(this.lock);
    if this.Active() && this.epoch == epoch && source != 0ul && !this.bodies.KeyExist(source) {
      values = this.settings.Profile();
      row.profile = this.Intern(values);
      row.item = item;
      row.remove = ReducedLootSession.Roll(values[8]);
      this.bodies.Insert(source, ArraySize(this.decisions));
      ArrayPush(this.decisions, row);
    };
    RWLock.Release(this.lock);
    return row.remove;
  }

  public final func ConfirmBodyRemoval(source: Uint64, epoch: Uint32, item: ItemID) -> Void {
    let index: Int32;
    RWLock.Acquire(this.lock);
    if this.epoch == epoch && IsDefined(this.bodies) && this.bodies.KeyExist(source) {
      index = this.bodies.Get(source);
      if ReducedLootSession.Exact(this.decisions[index].item, item) {
        this.decisions[index].applied = true;
      };
    };
    RWLock.Release(this.lock);
  }

  public final static func Exact(a: ItemID, b: ItemID) -> Bool {
    return Equals(a.id, b.id) && a.rngSeed == b.rngSeed && a.uniqueCounter == b.uniqueCounter && a.flags == b.flags;
  }

  public final func PersonalWeapon(id: ItemID, remember: Bool) -> Bool {
    let mark: ReducedLootPersonalItem;
    let bucket: Uint64 = TDBID.ToNumber(id.id) ^ Cast<Uint64>(id.rngSeed);
    let i: Int32 = -1;
    RWLock.Acquire(this.lock);
    if IsDefined(this.personalHeads) {
      if this.personalHeads.KeyExist(bucket) { i = this.personalHeads.Get(bucket); };
      mark.previous = i;
      while i >= 0 && !ReducedLootSession.Exact(this.personal[i].item, id) { i = this.personal[i].previous; };
      if remember && i < 0 {
        mark.item = id;
        i = ArraySize(this.personal);
        if mark.previous < 0 { this.personalHeads.Insert(bucket, i); } else { this.personalHeads.Set(bucket, i); };
        ArrayPush(this.personal, mark);
      };
    };
    RWLock.Release(this.lock);
    return i >= 0;
  }
}

@wrapMethod(DropAction)
public func CompleteAction(gameInstance: GameInstance) -> Void {
  let data: wref<gameItemData> = this.GetItemData();
  if IsDefined(this.GetExecutor() as PlayerPuppet) && IsDefined(data) && data.GetQuantity() > 0 && !data.HasTag(n"Quest") && !data.HasTag(n"UnequipBlocked") {
    ReducedLootRememberWeapon(gameInstance, data.GetID());
  };
  wrappedMethod(gameInstance);
}

public func ReducedLootRememberWeapon(game: GameInstance, id: ItemID) -> Void {
  let system: ref<ReducedLootSession>;
  if ItemID.IsValid(id) && Equals(RPGManager.GetItemCategory(id), gamedataItemCategory.Weapon) {
    system = ReducedLootSession.Get(game);
    if IsDefined(system) { system.PersonalWeapon(id, true); };
  };
}

@wrapMethod(RPGManager)
public final static func DropManyItems(gameInstance: GameInstance, obj: wref<GameObject>, const items: script_ref<[ItemModParams]>) -> Void {
  if IsDefined(obj as PlayerPuppet) {
    for entry in Deref(items) {
      if entry.quantity > 0 { ReducedLootRememberWeapon(gameInstance, entry.itemID); };
    };
  };
  wrappedMethod(gameInstance, obj, items);
}
