module ReducedLoot

@addField(gameLootContainerBase)
private let reducedLootChanceSuppressed: Bool;

@addField(gameLootContainerBase)
private let reducedLootOriginalChance: Float;

@wrapMethod(gameLootContainerBase)
protected cb func OnGameAttached() -> Bool {
  let slot: ref<gameLootSlot> = this as gameLootSlot;
  let system: ref<ReducedLootSession>;
  let category: Int32;
  let source: EntityID;
  if IsDefined(slot) {
    if slot.reducedLootChanceSuppressed {
      if slot.dropChance == 0.00 { slot.dropChance = slot.reducedLootOriginalChance; };
      slot.reducedLootChanceSuppressed = false;
    };
    system = ReducedLootSession.Get(this.GetGame());
    if IsDefined(system) && system.Active() && !this.m_markAsQuest {
      source = slot.GetEntityID();
      category = ReducedLootPolicy.SlotCategory(slot);
      if category >= 0 && system.SuppressPlacement(source.hash, category) {
        slot.reducedLootOriginalChance = slot.dropChance;
        slot.reducedLootChanceSuppressed = true;
        slot.dropChance = 0.00;
      };
    };
  };
  return wrappedMethod();
}

@addMethod(gameLootContainerBase)
public final func ReducedLootOrdinaryCase() -> Bool {
  let ps: ref<gameLootContainerBasePS> = this.GetPS();
  let path: ResRef;
  if NotEquals(this.GetClassName(), n"LootContainerObjectAnimatedByTransform") || !this.IsLogicReady() || this.IsDisabled() || this.m_markAsQuest || (IsDefined(ps) && ps.IsMarkedAsQuest()) || !this.useAreaLoot || TDBID.IsValid(this.contentAssignment) || ArraySize(this.lootTables) != 0 { return false; };
  path = this.GetTemplatePath();
  switch this.containerType {
    case gamedataContainerType.AmmoCase:
      return Equals(path, r"base\\gameplay\\loot\\containers\\ammo_cases\\ammo_case_small.ent");
    case gamedataContainerType.ClothingContainer:
      return Equals(path, r"base\\gameplay\\loot\\containers\\common_suitcases\\common_suitcase_small.ent") || Equals(path, r"base\\gameplay\\loot\\containers\\equipment_cases\\equipment_case_small.ent");
    case gamedataContainerType.ConsumableContainer:
      return Equals(path, r"base\\gameplay\\loot\\containers\\consumables_kits\\consumable_kit_small.ent") || Equals(path, r"base\\gameplay\\loot\\containers\\first_aid_kits\\first_aid_kit_small.ent");
    case gamedataContainerType.ComponentContainer:
      return Equals(path, r"base\\gameplay\\loot\\containers\\crates\\crate_small.ent") || Equals(path, r"base\\gameplay\\loot\\containers\\toolboxes\\medium_toolbox.ent");
    case gamedataContainerType.Safe:
      return Equals(path, r"base\\gameplay\\loot\\containers\\safes\\safe_medium.ent");
    case gamedataContainerType.GadgetCase:
      return Equals(path, r"base\\gameplay\\loot\\containers\\gadgets_cases\\gadgets_case_small.ent");
    case gamedataContainerType.WeaponContainer:
      return Equals(path, r"base\\gameplay\\loot\\containers\\weapon_cases\\weapon_case_small.ent");
    case gamedataContainerType.Misc:
      return Equals(path, r"base\\gameplay\\loot\\containers\\ow_containers\\laptop_bag.ent");
  };
  return false;
}

@wrapMethod(gameLootContainerBase)
protected cb func OnInventoryFilledEvent(evt: ref<ContainerFilledEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  let system: ref<ReducedLootSession>;
  let source: EntityID;
  let epoch: Uint32;
  let items: array<wref<gameItemData>>;
  let stacks: array<ReducedLootStack>;
  let candidate: ReducedLootStack;
  let chances: array<Uint8>;
  if !this.ReducedLootOrdinaryCase() { return result; };
  source = this.GetEntityID();
  system = ReducedLootSession.Get(this.GetGame());
  if !IsDefined(system) || system.SeenContainer(source.hash) { return result; };
  epoch = system.epoch;
  if source.hash == 0ul || NotEquals(GameInstance.FindEntityByID(this.GetGame(), source), this) { return result; };
  if !GameInstance.GetTransactionSystem(this.GetGame()).GetItemList(this, items) { return result; };
  for item in items {
    if ReducedLootPolicy.Snapshot(item, candidate) { ArrayPush(stacks, candidate); };
  };
  if ArraySize(stacks) > 0 && system.ClaimContainer(source.hash, epoch) {
    chances = system.settings.Profile();
    for stack in stacks {
      if ReducedLootSession.Roll(chances[stack.category]) {
        ReducedLootPolicy.Remove(system, epoch, this, source, stack);
      };
    };
  };
  return result;
}
