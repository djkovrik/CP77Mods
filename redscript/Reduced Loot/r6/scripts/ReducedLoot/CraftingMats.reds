module ReducedLoot

public class ReducedLootGeneration extends IScriptable {
  public let system: wref<ReducedLootSession>;
  public let epoch: Uint32;
  public let source: EntityID;
  public let before: array<ItemID>;
  public let captured: Bool;
  public let ready: Bool;
  public let candidate: ReducedLootStack;

  public final static func Begin(body: ref<NPCPuppet>) -> ref<ReducedLootGeneration> {
    let context: ref<ReducedLootGeneration>;
    let system: ref<ReducedLootSession>;
    if !IsDefined(body) || body.IsQuest() || body.IsCrowd() || body.WasLootGenerated() { return null; };
    system = ReducedLootSession.Get(body.GetGame());
    if !IsDefined(system) || !system.Active() { return null; };
    context = new ReducedLootGeneration();
    context.system = system;
    context.epoch = system.epoch;
    context.source = body.GetEntityID();
    return context;
  }

  public final func Before(body: ref<NPCPuppet>, emptyOnly: Bool) -> Void {
    let items: array<wref<gameItemData>>;
    this.captured = false;
    if body.WasLootGenerated() || !GameInstance.GetTransactionSystem(body.GetGame()).GetItemList(body, items) || (emptyOnly && ArraySize(items) > 0) { return; };
    ArrayClear(this.before);
    for item in items {
      if !IsDefined(item) || !ItemID.IsValid(item.GetID()) { return; };
      ArrayPush(this.before, item.GetID());
    };
    this.captured = true;
  }

  public final func After(body: ref<NPCPuppet>, record: TweakDBID) -> Void {
    let items: array<wref<gameItemData>>;
    let stack: ReducedLootStack;
    let old: Bool;
    if !this.captured { return; };
    this.captured = false;
    if !body.WasLootGenerated() || body.IsQuest() || body.IsCrowd() || !GameInstance.GetTransactionSystem(body.GetGame()).GetItemList(body, items) { return; };
    for item in items {
      if IsDefined(item) && Equals(ItemID.GetTDBID(item.GetID()), record) && ReducedLootPolicy.Snapshot(item, stack) && stack.category == 8 {
        old = false;
        for id in this.before {
          if ReducedLootSession.Exact(stack.id, id) { old = true; break; };
        };
        if !old {
          if this.ready { this.ready = false; return; };
          this.candidate = stack;
          this.ready = true;
        };
      };
    };
  }

  public final func Apply(body: ref<NPCPuppet>) -> Void {
    let system: ref<ReducedLootSession> = this.system;
    if !this.ready || !IsDefined(system) || !system.Active() || system.epoch != this.epoch || body.IsQuest() || body.IsCrowd() || !body.WasLootGenerated() { return; };
    this.ready = false;
    if Equals(this.source, body.GetEntityID()) && system.ClaimBody(this.source.hash, this.epoch, this.candidate.id) {
      ReducedLootPolicy.Remove(system, this.epoch, body, this.source, this.candidate);
    };
  }
}

@addField(NPCPuppet)
public let reducedLootWindow: ref<ReducedLootGeneration>;

@addField(DisposalDevice)
public let reducedLootLethal: Bool;

@addField(DisposalDevice)
public let reducedLootTarget: wref<NPCPuppet>;

@addField(NPCPuppet)
public let reducedLootDisposal: ref<ReducedLootGeneration>;

@wrapMethod(NPCPuppet)
protected func OnIncapacitated() -> Void {
  let context: ref<ReducedLootGeneration>;
  if !this.IsIncapacitated() && !IsDefined(this.reducedLootWindow) {
    context = ReducedLootGeneration.Begin(this);
    this.reducedLootWindow = context;
  };
  wrappedMethod();
  if IsDefined(context) {
    this.reducedLootWindow = null;
    if this.IsIncapacitated() && IsDefined(this.GetPuppetPS()) && this.GetPuppetPS().GetIsDead() { context.Apply(this); };
  };
}

@wrapMethod(ScriptedPuppet)
protected func OnIncapacitated() -> Void {
  let body: ref<NPCPuppet> = this as NPCPuppet;
  wrappedMethod();
  if IsDefined(body) && IsDefined(body.reducedLootWindow) { body.reducedLootWindow.Before(body, false); };
}

@wrapMethod(AIActionHelper)
public final static func CombatQueriesInit(ownerPuppet: wref<ScriptedPuppet>) -> Void {
  let body: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
  if IsDefined(body) && IsDefined(body.reducedLootWindow) { body.reducedLootWindow.After(body, t"Items.UncommonMaterial1"); };
  wrappedMethod(ownerPuppet);
}

@wrapMethod(DisposalDevice)
private final func TakedownAndDispose(isNonlethal: Bool) -> Void {
  let previous: Bool = this.reducedLootLethal;
  let previousTarget: wref<NPCPuppet> = this.reducedLootTarget;
  this.reducedLootLethal = !isNonlethal;
  this.reducedLootTarget = null;
  wrappedMethod(isNonlethal);
  if IsDefined(this.reducedLootTarget) { this.reducedLootTarget.reducedLootDisposal = null; };
  this.reducedLootTarget = previousTarget;
  this.reducedLootLethal = previous;
}

@wrapMethod(DisposalDevice)
private final func SetNpcIsDisposedBlackboard() -> Void {
  let body: ref<NPCPuppet>;
  let context: ref<ReducedLootGeneration>;
  wrappedMethod();
  if this.reducedLootLethal {
    this.reducedLootLethal = false;
    body = this.m_npcBody as NPCPuppet;
    context = ReducedLootGeneration.Begin(body);
    if IsDefined(context) && !IsDefined(body.reducedLootDisposal) {
      context.Before(body, true);
      if context.captured {
        this.reducedLootTarget = body;
        body.reducedLootDisposal = context;
      };
    };
  };
}

@wrapMethod(RPGManager)
public final static func IsInventoryEmpty(object: wref<GameObject>) -> Bool {
  let body: ref<NPCPuppet> = object as NPCPuppet;
  let context: ref<ReducedLootGeneration>;
  if IsDefined(body) && IsDefined(body.reducedLootDisposal) {
    context = body.reducedLootDisposal;
    body.reducedLootDisposal = null;
    context.After(body, t"Items.CommonMaterial1");
    context.Apply(body);
  };
  return wrappedMethod(object);
}
