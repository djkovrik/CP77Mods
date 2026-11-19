module AttachmentCompatibility

// fields
@addField(UIInventoryItemTooltipWrapper)
public let attachmentCompatibilitySelected: Bool;

@addField(ItemTooltipCommonController)
public let attachmentCompatibilityView: ref<TooltipView>;


// Base
public class Candidate {
  public let id: ItemID;
  public let quality: gamedataQuality;
  public let qualityKnown: Bool;
  public let iconic: Bool;
  public let consequencesKnown: Bool;
  public let available: Bool;
  public let removable: Bool;
  public let record: wref<Item_Record>;
  public let gameData: wref<gameItemData>;
  public let internal: Bool;
  public let placements: array<TweakDBID>;

  public static func Create(id: ItemID, quality: gamedataQuality, qualityKnown: Bool, data: wref<gameItemData>) -> ref<Candidate> {
    let candidate: ref<Candidate>;
    let slots: array<wref<AttachmentSlot_Record>>;
    let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(id));
    if !IsDefined(record) || !IsDefined(record.ItemType()) { 
      return null; 
    };

    let type = record.ItemType().Type();
    if !Rules.IsSupported(type) || record.TagsContains(n"Recipe") { return null; }
    candidate = new Candidate();
    candidate.id = id;
    candidate.record = record;
    candidate.gameData = data;
    candidate.quality = quality;
    candidate.qualityKnown = qualityKnown && NotEquals(quality, gamedataQuality.Invalid);
    candidate.internal = RPGManager.IsWeaponMod(type);
    candidate.consequencesKnown = IsDefined(data);

    if IsDefined(data) {
      candidate.iconic = RPGManager.IsItemIconic(data);
      candidate.available = record.IsPart() && !InventoryDataManagerV2.IsItemBlacklisted(data);
    };

    record.PlacementSlots(slots);

    for slot in slots {
      if IsDefined(slot) { ArrayPush(candidate.placements, slot.GetID()); }
    };

    if ArraySize(candidate.placements) > 0 {
      let part: InventoryItemData;
      part.ID = id;
      part.IsIconic = candidate.iconic;
      candidate.removable = RPGManager.CanPartBeUnequipped(part, candidate.placements[0]);
    }

    return candidate;
  }
}

public class Texts {
  public static func Get(key: String) -> String {
    return GetLocalizedTextByKey(StringToName("AttachmentsCompat-" + key));
  }

  public static func Count(key: String, count: Int32) -> String {
    return StrReplace(Texts.Get(key), "{count}", ToString(count));
  }
}

public enum Operation {
  Replace = 0,
  RemoveFirst = 1
}

public class SlotOption {
  public let slot: TweakDBID;
  public let operation: Operation;
  public let installedName: String;
  public let installedQuality: gamedataQuality;
  public let qualityKnown: Bool;
  public let destroysPrevious: Bool;
}


public class WeaponResult {
  public let id: ItemID;
  public let setIndex: Int32;
  public let hand: Int32;
  public let name: String;
  public let freeSlots: Int32;
  public let options: array<ref<SlotOption>>;
  public let alreadyInstalled: Int32;
  public let incomplete: Bool;
  public let directReplacement: Bool;
  public let blocked: Bool;

  public func HasOptions() -> Bool {
    return this.freeSlots > 0 || ArraySize(this.options) > 0;
  }
}

public class TooltipTick extends DelayCallback {
  public let view: wref<TooltipView>;
  public let generation: Uint32;

  public func Call() -> Void {
    if IsDefined(this.view) { this.view.Tick(this.generation); }
  }
}

public class Evaluation {
  public let weapons: array<ref<WeaponResult>>;
  public let equippedCount: Int32;
  public let hasOptions: Bool;
  public let incomplete: Bool;
  public let candidate: ref<Candidate>;
}

public class Rules {
  public static func IsSupported(type: gamedataItemType) -> Bool {
    return RPGManager.IsWeaponMod(type) || Equals(type, gamedataItemType.Prt_ShortScope)
      || Equals(type, gamedataItemType.Prt_LongScope) 
      || Equals(type, gamedataItemType.Prt_TechSniperScope)
      || Equals(type, gamedataItemType.Prt_PowerSniperScope) 
      || Equals(type, gamedataItemType.Prt_Muzzle)
      || Equals(type, gamedataItemType.Prt_HandgunMuzzle) 
      || Equals(type, gamedataItemType.Prt_RifleMuzzle);
  }

  public static func Evaluate(player: wref<PlayerPuppet>, candidate: ref<Candidate>) -> ref<Evaluation> {
    let result: ref<Evaluation> = new Evaluation();
    result.candidate = candidate;

    if !IsDefined(player) || !IsDefined(candidate) {
      result.incomplete = true;
      return result;
    };

    let equipment = EquipmentSystem.GetData(player);
    if !IsDefined(equipment) { result.incomplete = true; return result; }
    result.incomplete = ArraySize(candidate.placements) == 0 || !candidate.consequencesKnown;

    if candidate.available {
      let part: InventoryItemData;
      part.ID = candidate.id;
      part.ItemType = candidate.record.ItemType().Type();
      part.EquipmentArea = IsDefined(candidate.record.EquipArea()) ? candidate.record.EquipArea().Type() : gamedataEquipmentArea.Invalid;
      part.IsRequirementMet = true;
      InventoryItemData.SetGameItemData(part, candidate.gameData);
      candidate.available = InventoryGPRestrictionHelper.CanEquip(part, player);
    };

    let transaction = GameInstance.GetTransactionSystem(player.GetGame());
    let inventorySlots = InventoryDataManagerV2.GetAttachmentSlotsForInventory();
    let slotCount = Min(6, equipment.GetNumberOfSlots(gamedataEquipmentArea.Weapon, true));
    let setIndex = 0;
    
    while setIndex < 3 {
      let right = setIndex < slotCount ? equipment.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, setIndex) : ItemID.None();
      let left = setIndex + 3 < slotCount ? equipment.GetItemInEquipSlot(gamedataEquipmentArea.Weapon, setIndex + 3) : ItemID.None();
      let hand = 0;
      while hand < 2 {
        let id = hand == 0 ? right : left;
        if ItemID.IsValid(id) {
          result.equippedCount += 1;
          let weapon = Rules.EvaluateWeapon(player, transaction.GetItemData(player, id), id, candidate, inventorySlots);
          weapon.setIndex = setIndex + 1;
          weapon.hand = ItemID.IsValid(left) ? hand + 1 : 0;
          result.incomplete = result.incomplete || weapon.incomplete;
          result.hasOptions = result.hasOptions || weapon.HasOptions();
          if weapon.HasOptions() || weapon.alreadyInstalled > 0 {
            ArrayPush(result.weapons, weapon);
          }
        }
        hand += 1;
      }

      setIndex += 1;
    };
 
    return result;
  }

  private static func EvaluateWeapon(player: wref<PlayerPuppet>, data: wref<gameItemData>, id: ItemID, candidate: ref<Candidate>, inventorySlots: array<TweakDBID>) -> ref<WeaponResult> {
    let result = new WeaponResult();
    result.id = id;
    result.incomplete = !candidate.consequencesKnown;
    let record = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(id));
    if !IsDefined(data) || !IsDefined(record) { result.incomplete = true; return result; }
    result.name = GetLocalizedItemNameByCName(record.DisplayName());
    result.directReplacement = !candidate.internal || data.HasTag(n"IconicWeapon");
    result.blocked = data.HasTag(n"UnequipBlocked");

    let slots = ItemModificationSystem.GetAllSlotsFromItemData(data);
    let externalAllowed = candidate.internal || Rules.ExternalAllowed(record, ItemID.GetTDBID(candidate.id));
    let weaponQualityKnown = data.HasStatData(gamedataStatType.Quality);
    let weaponQuality = RPGManager.GetItemDataQuality(data);
    let chimera = Equals(TweakDBInterface.GetCName(ItemID.GetTDBID(candidate.id) + t".modType", n"None"), n"chimera_mod");
    for slot in slots {
      if ArrayContains(candidate.placements, slot.slotID) && ArrayContains(inventorySlots, slot.slotID)
        && slot.slotID != t"AttachmentSlots.IconicMeleeWeaponMod1" && slot.slotID != t"AttachmentSlots.IconicWeaponModLegendary" {
        Rules.EvaluateSlot(player, data, candidate, slot, externalAllowed, weaponQualityKnown, weaponQuality, chimera, result);
      }
    }
    return result;
  }

  private static func ExternalAllowed(weapon: wref<WeaponItem_Record>, candidate: TweakDBID) -> Bool {
    let lists: array<wref<SlotItemPartListElement_Record>>;
    let parts: array<wref<ItemPartListElement_Record>>;
    weapon.SlotPartList(lists);
    for list in lists {
      if IsDefined(list) && IsDefined(list.Slot()) {
        let slot = list.Slot().GetID();
        if slot == t"AttachmentSlots.Scope" || slot == t"AttachmentSlots.PowerModule" {
          ArrayClear(parts);
          list.ItemPartList(parts);
          for part in parts {
            if IsDefined(part) && IsDefined(part.Item()) && part.Item().GetID() == candidate { return true; }
          }
        }
      }
    }
    return false;
  }

  private static func EvaluateSlot(player: wref<PlayerPuppet>, data: wref<gameItemData>, candidate: ref<Candidate>, slot: SPartSlots, externalAllowed: Bool, weaponQualityKnown: Bool, weaponQuality: gamedataQuality, chimera: Bool, result: ref<WeaponResult>) {
    let installed: InventoryItemData;
    let installedRecord: wref<Item_Record>;
    let qualityKnown: Bool;
    let quality: gamedataQuality;
    let taken: Bool = Equals(slot.status, ESlotState.Taken);

    if taken {
      installedRecord = InnerItemData.GetStaticData(slot.innerItemData);
      if !ItemID.IsValid(slot.installedPart) || !IsDefined(installedRecord) { result.incomplete = true; return; }
      if installedRecord.TagsContains(n"DummyPart") { return; }
      qualityKnown = InnerItemData.HasStatData(slot.innerItemData, gamedataStatType.Quality);
      if qualityKnown { quality = RPGManager.GetInnerItemDataQuality(slot.innerItemData); }
      if ItemID.GetTDBID(slot.installedPart) == ItemID.GetTDBID(candidate.id) {
        if qualityKnown && candidate.qualityKnown {
          if Equals(quality, candidate.quality) { result.alreadyInstalled += 1; }
        } else { 
          result.incomplete = true; 
        }
      };
    };

    if result.blocked || !candidate.available { return; }
    let slotRecord = TweakDBInterface.GetAttachmentSlotRecord(slot.slotID);
    if !IsDefined(slotRecord) { result.incomplete = true; return; }
    if !(RPGManager.ShouldSlotBeAvailable(player, result.id, slotRecord) || RPGManager.IsSlotAvailable(data, slotRecord)) || !externalAllowed { return; }
    
    if !chimera {
      if !weaponQualityKnown || !candidate.qualityKnown { result.incomplete = true; return; }
      if candidate.quality > weaponQuality { return; }
    };

    if !taken {
      result.freeSlots += 1;
      return ;
    };
 
    installed.ID = slot.installedPart;
    installed.IsIconic = InnerItemData.HasStatData(slot.innerItemData, gamedataStatType.IsItemIconic)
      && InnerItemData.GetStatValueByType(slot.innerItemData, gamedataStatType.IsItemIconic) > 0.0;

    let direct = result.directReplacement;
    if !direct && !RPGManager.CanPartBeUnequipped(installed, slot.slotID) { 
      return; 
    }

    let option: ref<SlotOption> = new SlotOption();
    option.slot = slot.slotID;
    option.operation = direct ? Operation.Replace : Operation.RemoveFirst;
    option.installedName = GetLocalizedItemNameByCName(installedRecord.DisplayName());
    option.qualityKnown = qualityKnown;
    option.installedQuality = quality;
    option.destroysPrevious = direct && RPGManager.IsWeaponMod(slot.installedPart);

    if !qualityKnown { 
      result.incomplete = true; 
    };

    ArrayPush(result.options, option);
  }
}

@wrapMethod(FullscreenVendorGameController)
private final func ShowTooltipForUIInventoryItem(widget: wref<inkWidget>, inspectedItem: wref<UIInventoryItem>, equippedItem: wref<UIInventoryItem>, isBuybackStack: Bool) -> Void {
  let eligible = IsDefined(inspectedItem) 
    && !IsDefined(this.m_storageUserData)
    && IsDefined(inspectedItem.GetOwner()) 
    && inspectedItem.GetOwner().GetEntityID() != this.m_player.GetEntityID();

  if eligible { 
    this.m_vendorItemDisplayContext.AddTag(n"AttachmentCompatibilityOffer"); 
  };

  wrappedMethod(widget, inspectedItem, equippedItem, isBuybackStack);

  if eligible { 
    this.m_vendorItemDisplayContext.RemoveTag(n"AttachmentCompatibilityOffer"); 
  };
}

@wrapMethod(UIInventoryItemTooltipWrapper)
public final static func Make(data: wref<UIInventoryItem>, displayContext: ref<ItemDisplayContextData>) -> ref<UIInventoryItemTooltipWrapper> {
  let result = wrappedMethod(data, displayContext);
  result.attachmentCompatibilitySelected = IsDefined(displayContext)
    && (displayContext.HasTag(n"AttachmentCompatibilityOffer")
    || Equals(displayContext.GetDisplayContext(), ItemDisplayContext.Backpack) 
    && displayContext.GetDisplayComparison());

  return result;
}

@wrapMethod(InventoryDataManagerV2)
public final func PushIdentifiedComparisonTooltipsData(tooltipsData: script_ref<array<ref<ATooltipData>>>, name1: CName, name2: CName, inspectedItem: wref<UIInventoryItem>, equippedItem: wref<UIInventoryItem>, equippedDisplayContext: wref<ItemDisplayContextData>, inspectedDisplayContext: wref<ItemDisplayContextData>, opt iconErrorInfo: ref<DEBUG_IconErrorInfo>, opt overrideRarity: Bool) -> Void {
  let start: Int32 = ArraySize(Deref(tooltipsData));
  
  wrappedMethod(tooltipsData, name1, name2, inspectedItem, equippedItem, equippedDisplayContext, inspectedDisplayContext, iconErrorInfo, overrideRarity);
  
  if !IsDefined(equippedDisplayContext) || NotEquals(equippedDisplayContext.GetDisplayContext(), ItemDisplayContext.Backpack) { 
    return; 
  };

  let index: Int32 = start;
  while index < ArraySize(Deref(tooltipsData)) {
    let identified = Deref(tooltipsData)[index] as IdentifiedWrappedTooltipData;
    if IsDefined(identified) {
      let wrapper = identified.m_data as UIInventoryItemTooltipWrapper;
      if IsDefined(wrapper) { wrapper.attachmentCompatibilitySelected = wrapper.m_data == inspectedItem; }
    }

    index += 1;
  };
}

public class Sources {

  public static func FromTooltip(data: ref<ATooltipData>, out player: wref<PlayerPuppet>) -> ref<Candidate> {
    let wrapper = data as UIInventoryItemTooltipWrapper;
    if IsDefined(wrapper) 
      && IsDefined(wrapper.m_data) 
      && IsDefined(wrapper.m_displayContext) {
        let context = wrapper.m_displayContext;
        let backpack = Equals(context.GetDisplayContext(), ItemDisplayContext.Backpack);
        if !wrapper.attachmentCompatibilitySelected { 
          return null; 
        };

        player = context.GetPlayerAsPuppet();

        let item = wrapper.m_data;
        let real = item.GetRealItemData();
        if !IsDefined(real) { 
          return Candidate.Create(item.GetID(), item.GetQuality(), false, null); 
        };

        if backpack && (item.IsEquipped() 
          || !IsDefined(player)
          || GameInstance.GetTransactionSystem(player.GetGame()).GetItemQuantity(player, item.GetID()) <= 0) { 
            return null; 
        };

        return Candidate.Create(item.GetID(), RPGManager.GetItemDataQuality(real), real.HasStatData(gamedataStatType.Quality), real);
    }

    return Sources.FromAtelier(data, player);
  }

  @if(!ModuleExists("VirtualAtelier.UI"))
  private static func FromAtelier(data: ref<ATooltipData>, out player: wref<PlayerPuppet>) -> ref<Candidate> {
    return null;
  }

  @if(ModuleExists("VirtualAtelier.UI"))
  private static func FromAtelier(data: ref<ATooltipData>, out player: wref<PlayerPuppet>) -> ref<Candidate> {
    let tooltip = data as InventoryTooltipData;
    if !IsDefined(tooltip) || !tooltip.isVirtualItem || NotEquals(tooltip.displayContext, InventoryTooltipDisplayContext.Vendor) { 
      return null; 
    };

    player = GetPlayer(GetGameInstance());

    let item = tooltip.virtualInventoryItemData;

    return Candidate.Create(
      InventoryItemData.GetID(item), 
      UIItemsHelper.QualityNameToEnum(InventoryItemData.GetQuality(item)),
      NotEquals(InventoryItemData.GetQuality(item), n""), 
      InventoryItemData.GetGameItemData(item)
    );
  }
}

public class TooltipView {
  public let owner: wref<ItemTooltipCommonController>;
  private let player: wref<PlayerPuppet>;
  private let source: ref<ATooltipData>;
  private let panel: ref<inkVerticalPanel>;
  private let viewport: ref<inkScrollArea>;
  private let content: wref<inkWidget>;
  private let parent: wref<inkCompoundWidget>;
  private let hint: ref<inkText>;
  private let active: Bool;
  private let dirty: Bool;
  private let generation: Uint32;
  private let delay: DelayID;
  private let width: Float;
  private let fontSize: Int32;
  private let offset: Float;
  private let extent: Float;

  private let inventory: wref<IBlackboard>;
  private let equipment: wref<IBlackboard>;
  private let modifications: wref<IBlackboard>;
  private let added: ref<CallbackHandle>;
  private let removed: ref<CallbackHandle>;
  private let quantity: ref<CallbackHandle>;
  private let equipped: ref<CallbackHandle>;
  private let modified: ref<CallbackHandle>;

  public static func Create(
    owner: ref<ItemTooltipCommonController>, 
    content: wref<inkWidget>, 
    categories: wref<inkCompoundWidget>
  ) -> ref<TooltipView> {
    if !IsDefined(content) || !IsDefined(categories) || !IsDefined(content.GetParentWidget()) { 
      return null; 
    };

    let view: ref<TooltipView> = new TooltipView();
    view.owner = owner;
    view.content = content;
    view.parent = content.GetParentWidget() as inkCompoundWidget;
    view.viewport = new inkScrollArea();
    view.viewport.SetName(n"attachmentCompatibilityViewport");
    // fill to prevent collapsing to zero
    view.viewport.SetHAlign(inkEHorizontalAlign.Left);
    view.viewport.SetVAlign(inkEVerticalAlign.Top);
    view.viewport.SetFitToContent(false);
    view.viewport.SetFitToContentDirection(inkFitToContentDirection.Horizontal);
    view.viewport.SetUseInternalMask(true);
    view.viewport.SetConstrainContentPosition(true);
    view.viewport.SetVisible(false);
    view.viewport.SetAffectsLayoutWhenHidden(false);
    view.viewport.Reparent(view.parent, 1);

    view.panel = new inkVerticalPanel();
    view.panel.SetName(n"attachmentCompatibility");
    view.panel.SetFitToContent(true);
    view.panel.SetHAlign(inkEHorizontalAlign.Fill);
    view.panel.SetMargin(inkMargin(24.0, 24.0, 24.0,12.0));
    view.panel.SetVisible(false);
    view.panel.SetAffectsLayoutWhenHidden(false);
    view.panel.Reparent(categories, Max(0, categories.GetNumChildren() - 1));

    return view;
  }

  public func SetSource(source: ref<ATooltipData>, bigFont: Bool) {
    this.Stop();
    this.source = source;
    this.width = bigFont ? 750.0 : 650.0;
    this.fontSize = bigFont ? 40 : 32;
    this.offset = 0.0;
    this.viewport.ScrollVertical(0.0);
    this.Render();
  }

  public func Start() {
    if this.active || !this.panel.IsVisible() || !IsDefined(this.player) { 
      return; 
    };

    this.active = true;
    this.owner.RegisterToGlobalInputCallback(n"OnPreOnRelative", this.owner, n"OnAttachmentCompatibilityScroll");
    this.owner.RegisterToGlobalInputCallback(n"OnPreOnAxis", this.owner, n"OnAttachmentCompatibilityScroll");

    let bb = GameInstance.GetBlackboardSystem(this.player.GetGame());
    this.inventory = bb.Get(GetAllBlackboardDefs().UI_Inventory);
    this.equipment = bb.Get(GetAllBlackboardDefs().UI_Equipment);
    this.modifications = bb.Get(GetAllBlackboardDefs().UI_ItemModSystem);
    this.added = this.inventory.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemAdded, this, n"OnChanged");
    this.removed = this.inventory.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemRemoved, this, n"OnChanged");
    this.quantity = this.inventory.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemQuantityChanged, this, n"OnChanged");
    this.equipped = this.equipment.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_Equipment.itemEquipped, this, n"OnChanged");
    this.modified = this.modifications.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_ItemModSystem.ItemModSystemUpdated, this, n"OnChanged");

    this.Schedule();
  }

  public func Stop() {
    this.generation += 1u;
    this.dirty = true;
    if !this.active { return; }
    this.active = false;

    if IsDefined(this.owner) {
      this.owner.UnregisterFromGlobalInputCallback(n"OnPreOnRelative", this.owner, n"OnAttachmentCompatibilityScroll");
      this.owner.UnregisterFromGlobalInputCallback(n"OnPreOnAxis", this.owner, n"OnAttachmentCompatibilityScroll");
    };

    if IsDefined(this.player) { 
      GameInstance.GetDelaySystem(this.player.GetGame()).CancelCallback(this.delay); 
    };

    this.delay = GetInvalidDelayID();
    this.inventory.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Inventory.itemAdded, this.added);
    this.inventory.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Inventory.itemRemoved, this.removed);
    this.inventory.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Inventory.itemQuantityChanged, this.quantity);
    this.equipment.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Equipment.itemEquipped, this.equipped);
    this.modifications.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ItemModSystem.ItemModSystemUpdated, this.modified);
  }

  protected cb func OnChanged(value: Variant) -> Bool {
    this.dirty = true;
  }

  private func Schedule() {
    let callback: ref<TooltipTick> = new TooltipTick();
    callback.view = this;
    callback.generation = this.generation;
    this.delay = GameInstance.GetDelaySystem(this.player.GetGame()).DelayCallback(callback, 0.05, false);
  }

  public func Tick(generation: Uint32) {
    if !this.active || generation != this.generation { return; }
    this.delay = GetInvalidDelayID();

    if !IsDefined(this.owner) { 
      this.Stop(); 
      return; 
    };

    if this.dirty { 
      this.Render(); 
    };

    if !this.panel.IsVisible() { 
      this.Stop(); 
      return; 
    }

    let size = this.viewport.GetContentSize();

    if size.Y > 0.0 {
      let height = MinF(1400.0, size.Y);
      this.viewport.SetSize(MaxF(this.width + 60.0, size.X), height);
      this.extent = MaxF(0.0, size.Y - height);
      this.hint.SetVisible(this.extent > 0.0);
      this.ScrollPixels(0.0);
    };

    this.Schedule();
  }

  public func OnInput(event: ref<inkPointerEvent>) -> Bool {
    if !this.active || this.extent <= 0.0 || !this.owner.GetRootWidget().IsVisible() { 
      return false; 
    }

    if event.IsAction(n"mouse_wheel") {
      this.ScrollPixels(-event.GetAxisData() * 100.0);
      event.Handle();
      event.Consume();
      return true;
    };

    if event.IsAction(n"right_stick_y") || event.IsAction(n"right_stick_y_scroll") {
      let value = event.GetAxisData();
      if AbsF(value) > 0.15 { this.ScrollPixels(-value * 20.0); }
      event.Handle();
      event.Consume();
      return true;
    };

    return false;
  }

  private func ScrollPixels(delta: Float) {
    this.offset = ClampF(this.offset + delta, 0.0, this.extent);
    this.viewport.ScrollVertical(this.extent > 0.0 ? this.offset / this.extent : 0.0);
  }

  private func Line(value: String, opt heading: Bool) -> ref<inkText> {
    let text: ref<inkText> = new inkText();
    text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily", n"Medium");
    text.SetFontSize(heading ? this.fontSize + 4 : this.fontSize);
    text.SetFitToContent(true);
    text.SetAffectsLayoutWhenHidden(false);
    text.SetHAlign(inkEHorizontalAlign.Left);
    text.SetVAlign(inkEVerticalAlign.Top);
    text.SetWrapping(true, this.width - 12.0);
    text.SetMargin(inkMargin(0.0, heading ? 12.0 : 3.0, 0.0, 0.0));
    text.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    text.BindProperty(n"tintColor", heading ? n"MainColors.Blue" : n"MainColors.Grey");
    text.SetText(value);
    text.Reparent(this.panel);
    return text;
  }

  private func Render() {
    this.dirty = false;
    let candidate = Sources.FromTooltip(this.source, this.player);
    this.panel.RemoveAllChildren();

    if !IsDefined(candidate) {
      this.panel.SetVisible(false);
      this.content.Reparent(this.parent, 1);
      this.viewport.SetVisible(false);
      return ;
    };

    this.content.Reparent(this.viewport);
    this.viewport.SetSize(this.width + 60.0, 1000.0);
    this.viewport.SetVisible(true);
    this.panel.SetVisible(true);

    let heading = Texts.Get("Heading");
    this.Line(heading, true);
    this.hint = this.Line(Texts.Get("Scroll"));

    let result = Rules.Evaluate(this.player, candidate);
    if result.equippedCount == 0 && !result.incomplete { this.Line(Texts.Get("NoWeapons")); }
    if result.equippedCount > 0 && !result.hasOptions && !result.incomplete { this.Line(Texts.Get("NoOptions")); }
    
    for weapon in result.weapons {
      let name = StrReplace(Texts.Count("Weapon", weapon.setIndex), "{name}", weapon.name);
      if weapon.hand == 1 { name += " - " + Texts.Get("Right"); }
      if weapon.hand == 2 { name += " - " + Texts.Get("Left"); }
      this.Line(name, true);

      if weapon.alreadyInstalled > 0 {
        this.Line(Texts.Count("Installed", weapon.alreadyInstalled));
        if !weapon.HasOptions() && !weapon.incomplete { this.Line(Texts.Get("NoAdditional")); }
      };

      if weapon.freeSlots > 0 { 
        this.Line(Texts.Count("Free", weapon.freeSlots)); 
      };

      for option in weapon.options {
        let quality = option.qualityKnown ? GetLocalizedText(UIItemsHelper.QualityToDefaultString(option.installedQuality)) : Texts.Get("UnknownQuality");
        let text = Texts.Get(Equals(option.operation, Operation.Replace) ? "Replace" : "RemoveFirst");
        text = StrReplace(StrReplace(text, "{name}", option.installedName), "{quality}", quality);
        if option.destroysPrevious { text += " " + Texts.Get("Lost"); }
        this.Line(text);
      };

      if weapon.HasOptions() {
        if candidate.consequencesKnown {
          if !candidate.removable { this.Line(Texts.Get("Permanent")); }
        } else { this.Line(Texts.Get("UnknownConsequences")); }
      };

      if weapon.incomplete { 
        this.Line(Texts.Get("IncompleteWeapon")); 
      };
    };

    if result.incomplete { 
      this.Line(Texts.Get("Incomplete")); 
    };
  }
}

@wrapMethod(ItemTooltipCommonController)
public func SetData(tooltipData: ref<ATooltipData>) -> Void {
  wrappedMethod(tooltipData);

  let player: wref<PlayerPuppet>;
  
  if !IsDefined(this.attachmentCompatibilityView) && IsDefined(Sources.FromTooltip(tooltipData, player)) {
    this.attachmentCompatibilityView = TooltipView.Create(this, inkWidgetRef.Get(this.m_contentWrapper), inkWidgetRef.Get(this.m_categoriesWrapper) as inkCompoundWidget);
  };

  if IsDefined(this.attachmentCompatibilityView) {
    this.attachmentCompatibilityView.SetSource(tooltipData, this.m_bigFontEnabled);
    this.attachmentCompatibilityView.Start();
  };
}

@addMethod(ItemTooltipCommonController)
protected cb func OnAttachmentCompatibilityScroll(event: ref<inkPointerEvent>) -> Bool {
  return IsDefined(this.attachmentCompatibilityView) && this.attachmentCompatibilityView.OnInput(event);
}

@wrapMethod(AGenericTooltipController)
public func Show() -> Void {
  wrappedMethod();

  let item = this as ItemTooltipCommonController;
  if IsDefined(item) && IsDefined(item.attachmentCompatibilityView) { item.attachmentCompatibilityView.Start(); }
}

@wrapMethod(AGenericTooltipController)
public func Hide() -> Void {
  let item = this as ItemTooltipCommonController;
  if IsDefined(item) && IsDefined(item.attachmentCompatibilityView) {
    item.attachmentCompatibilityView.Stop();
  };

  wrappedMethod();
}

@wrapMethod(AGenericTooltipControllerWithDebug)
protected cb func OnUninitialize() -> Bool {
  let item = this as ItemTooltipCommonController;
  if IsDefined(item) && IsDefined(item.attachmentCompatibilityView) { 
    item.attachmentCompatibilityView.Stop(); 
  }

  wrappedMethod();
}
