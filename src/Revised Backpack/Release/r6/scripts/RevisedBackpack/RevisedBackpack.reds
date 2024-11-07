// RevisedBackpack v0.9.0
module RevisedBackpack

import Codeware.UI.HubTextInput
import Codeware.UI.SimpleButton
import Codeware.UI.inkCustomController

enum revisedSorting {
  None = 0,
  Name = 1,
  Type = 2,
  Tier = 3,
  Price = 4,
  Weight = 5,
  Dps = 6,
  Range = 7,
  Quest = 8,
  CustomJunk = 9,
}
enum revisedSortingMode {
  None = 0,
  Asc = 1,
  Desc = 2,
}
enum revisedFiltersAction { 
  None = 0,
  Select = 1,
  Junk = 2,
  Disassemble = 3,
}
public class RevisedItemWrapper {
  public let id: TweakDBID;
  public let data: wref<gameItemData>;
  public let inventoryItem: wref<UIInventoryItem>;
  public let equipArea: gamedataEquipmentArea;
  public let type: gamedataItemType;
  public let typeLabel: String;
  public let typeValue: Int32;
  public let tier: gamedataQuality;
  public let tierLabel: String;
  public let tierValue: Int32;
  public let evolution: gamedataWeaponEvolution;
  public let nameLabel: String;
  public let price: Float;
  public let priceLabel: String;
  public let weight: Float;
  public let weightLabel: String;
  public let dps: Float;
  public let dpsLabel: String;
  public let range: Int32;
  public let rangeLabel: String;
  public let isQuest: Bool;
  public let isNew: Bool;
  public let isFavorite: Bool;
  public let isDlcAddedItem: Bool;
  public let isWeapon: Bool;
  public let selected: Bool;
  public let customJunk: Bool;
  public let questTagToggleable: Bool;
  public let customJunkToggleable: Bool;
  public final func GetEquippedFlag() -> Bool {
    return this.inventoryItem.IsEquipped();
  }
  public final func GetNewFlag() -> Bool {
    return this.isNew;
  }
  public final func SetNewFlag(flag: Bool) -> Void {
    this.isNew = flag;
  }
  public final func GetFavoriteFlag() -> Bool {
    return this.isFavorite;
  }
  public final func SetFavoriteFlag(flag: Bool) -> Void {
    this.isFavorite = flag;
  }
  public final func GetQuestFlag() -> Bool {
    return this.isQuest;
  }
  public final func SetQuestFlag(flag: Bool) -> Void {
    this.isQuest = flag;
  }
  public final func GetSelectedFlag() -> Bool {
    return this.selected;
  }
  public final func SetSelectedFlag(selected: Bool) -> Void {
    this.selected = selected;
  }
  public final func GetCustomJunkFlag() -> Bool {
    return this.customJunk;
  }
  public final func SetCustomJunkFlag(customJunk: Bool) -> Void {
    this.customJunk = customJunk;
  }
}
public abstract class RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool;
}
public class RevisedBackpackCategory {
  public let id: Int32;
  public let titleLocKey: CName;
  public let texturePart: CName;
  public let atlasResource: ResRef;
  public let predicate: ref<RevisedCategoryPredicate>;
  public static func Create(id: Int32, title: CName, texture: CName, atlas: ResRef, predicate: ref<RevisedCategoryPredicate>) -> ref<RevisedBackpackCategory> {
    let instance: ref<RevisedBackpackCategory> = new RevisedBackpackCategory();
    instance.id = id;
    instance.titleLocKey = title;
    instance.texturePart = texture;
    instance.atlasResource = atlas;
    instance.predicate = predicate;
    return instance;
  }
  public static func Sort(out source: array<ref<RevisedBackpackCategory>>) -> Void {
    let size: Int32 = ArraySize(source);
    let i: Int32;
    let j: Int32;
    let swapped: Bool = false;
    i = 0;
    while i < size - 1 {
      swapped = false;
      j = 0;
      while j < size - i - 1 {
        if (source[j].id > source[j + 1].id) {
          RevisedBackpackCategory.Swap(source, j, j + 1);
          swapped = true;
        };
        j += 1;
      };
      if !swapped { return; }
      i += 1;
    };
  }
  private static func Swap(out source: array<ref<RevisedBackpackCategory>>, left: Int32, right: Int32) -> Void {
    let temp: ref<RevisedBackpackCategory> = source[left];
    source[left] = source[right];
    source[right] = temp;
  }
}
public class RevisedBackpackItemTooltipWrapper extends ATooltipData {
  public let m_data: wref<RevisedItemWrapper>;
  public let m_displayContext: ref<ItemDisplayContextData>;
  public let m_overridePrice: Int32;
  public final static func Make(data: wref<RevisedItemWrapper>, displayContext: ref<ItemDisplayContextData>) -> ref<RevisedBackpackItemTooltipWrapper> {
    let instance: ref<RevisedBackpackItemTooltipWrapper> = new RevisedBackpackItemTooltipWrapper();
    instance.m_overridePrice = -1;
    instance.m_data = data;
    instance.m_displayContext = displayContext;
    return instance;
  }
}
public class RevisedCategorySelectedEvent extends Event {
  public let category: ref<RevisedBackpackCategory>;
  public final static func Create(category: ref<RevisedBackpackCategory>) -> ref<RevisedCategorySelectedEvent> {
    let evt: ref<RevisedCategorySelectedEvent> = new RevisedCategorySelectedEvent();
    evt.category = category;
    return evt;
  }
}
public class RevisedBackpackSortingChanged extends Event {
  public let sorting: revisedSorting;
  public let mode: revisedSortingMode;
  public final static func Create(sorting: revisedSorting, mode: revisedSortingMode) -> ref<RevisedBackpackSortingChanged> {
    let evt: ref<RevisedBackpackSortingChanged> = new RevisedBackpackSortingChanged();
    evt.sorting = sorting;
    evt.mode = mode;
    return evt;
  }
}
public class RevisedBackpackColumnHoverOverEvent extends Event {
  public let target: wref<inkWidget>;
  public let type: revisedSorting;
  public final static func Create(target: wref<inkWidget>, type: revisedSorting) -> ref<RevisedBackpackColumnHoverOverEvent> {
    let evt: ref<RevisedBackpackColumnHoverOverEvent> = new RevisedBackpackColumnHoverOverEvent();
    evt.target = target;
    evt.type = type;
    return evt;
  }
}
public class RevisedBackpackColumnHoverOutEvent extends Event {
  public final static func Create() -> ref<RevisedBackpackColumnHoverOutEvent> {
    let evt: ref<RevisedBackpackColumnHoverOutEvent> = new RevisedBackpackColumnHoverOutEvent();
    return evt;
  }
}
public class RevisedBackpackItemHoverOverEvent extends Event {
  public let item: wref<RevisedItemWrapper>;
  public let isOverName: Bool;
  public let widget: wref<inkWidget>;
  public final static func Create(item: ref<RevisedItemWrapper>, isName: Bool, widget: wref<inkWidget>) -> ref<RevisedBackpackItemHoverOverEvent> {
    let evt: ref<RevisedBackpackItemHoverOverEvent> = new RevisedBackpackItemHoverOverEvent();
    evt.item = item;
    evt.isOverName = isName;
    evt.widget = widget;
    return evt;
  }
}
public class RevisedBackpackItemHoverOutEvent extends Event {
  public let item: wref<RevisedItemWrapper>;
  public final static func Create(item: ref<RevisedItemWrapper>) -> ref<RevisedBackpackItemHoverOutEvent> {
    let evt: ref<RevisedBackpackItemHoverOutEvent> = new RevisedBackpackItemHoverOutEvent();
    evt.item = item;
    return evt;
  }
}
public class RevisedBackpackItemSelectEvent extends Event {
  public let item: wref<RevisedItemWrapper>;
  public final static func Create(item: ref<RevisedItemWrapper>) -> ref<RevisedBackpackItemSelectEvent> {
    let evt: ref<RevisedBackpackItemSelectEvent> = new RevisedBackpackItemSelectEvent();
    evt.item = item;
    return evt;
  }
}
public class RevisedBackpackItemHighlightEvent extends Event {
  public let itemId: ItemID;
  public let highlight: Bool;
  public final static func Create(itemId: ItemID, highlight: Bool) -> ref<RevisedBackpackItemHighlightEvent> {
    let evt: ref<RevisedBackpackItemHighlightEvent> = new RevisedBackpackItemHighlightEvent();
    evt.itemId = itemId;
    evt.highlight = highlight;
    return evt;
  }
}
public class RevisedBackpackItemWasHighlightedEvent extends Event {
  public let display: wref<RevisedBackpackItemController>;
  public final static func Create(display: wref<RevisedBackpackItemController>) -> ref<RevisedBackpackItemWasHighlightedEvent> {
    let evt: ref<RevisedBackpackItemWasHighlightedEvent> = new RevisedBackpackItemWasHighlightedEvent();
    evt.display = display;
    return evt;
  }
}
public class RevisedBackpackSelectedItemsCountChangedEvent extends Event {
  public let count: Int32;
  public final static func Create(count: Int32) -> ref<RevisedBackpackSelectedItemsCountChangedEvent> {
    let evt: ref<RevisedBackpackSelectedItemsCountChangedEvent> = new RevisedBackpackSelectedItemsCountChangedEvent();
    evt.count = count;
    return evt;
  }
}
public class RevisedItemPreviewEvent extends Event {
  public let itemId: ItemID;
  public let isGarment: Bool;
  public final static func Create(itemId: ItemID, isGarment: Bool) -> ref<RevisedItemPreviewEvent> {
    let evt: ref<RevisedItemPreviewEvent> = new RevisedItemPreviewEvent();
    evt.itemId = itemId;
    evt.isGarment = isGarment;
    return evt;
  }
}
public class RevisedFilteringEvent extends Event {
  public let nameQuery: String;
  public let typeQuery: String;
  public let tiers: array<gamedataQuality>;
  public let filtersReset: Bool;
  public final static func Create(name: String, type: String, tiers: array<gamedataQuality>, reset: Bool) -> ref<RevisedFilteringEvent> {
    let evt: ref<RevisedFilteringEvent> = new RevisedFilteringEvent();
    evt.nameQuery = name;
    evt.typeQuery = type;
    evt.tiers = tiers;
    evt.filtersReset = reset;
    return evt;
  }
}
public class RevisedFiltersActionEvent extends Event {
  public let type: revisedFiltersAction;
  public final static func Create(type: revisedFiltersAction) -> ref<RevisedFiltersActionEvent> {
    let evt: ref<RevisedFiltersActionEvent> = new RevisedFiltersActionEvent();
    evt.type = type;
    return evt;
  }
}
public class RevisedItemDisplayClickEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
  public let uiInventoryItem: ref<UIInventoryItem>;
  public let actionName: ref<inkActionName>;
}
public class RevisedItemDisplayHoldEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
  public let uiInventoryItem: ref<UIInventoryItem>;
  public let actionName: ref<inkActionName>;
}
public class RevisedItemDisplayPressEvent extends Event {
  public let display: wref<RevisedBackpackItemController>;
  public let actionName: ref<inkActionName>;
}
public class RevisedToggleCustomJunkEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
}
public class RevisedToggleQuestTagEvent extends Event {
  public let itemData: ref<gameItemData>;
  public let display: wref<RevisedBackpackItemController>;
}
public class RevisedBackpackInventoryListenerCallback extends InventoryScriptCallback {
  private let m_backpackInstance: wref<RevisedBackpackController>;
  public final func Setup(backpackInstance: wref<RevisedBackpackController>) -> Void {
    this.m_backpackInstance = backpackInstance;
  }
}
public class RevisedBakcpackImmediateNotificationListener extends ImmediateNotificationListener {
  private let m_backpackInstance: wref<RevisedBackpackController>;
  public final func SetBackpackInstance(instance: wref<RevisedBackpackController>) -> Void {
    this.m_backpackInstance = instance;
  }
  public func Notify(message: Int32, id: Uint64, opt data: wref<IScriptable>) -> Void {
    this.m_backpackInstance.OnBakcpackItemDisplayNotification(IntEnum<ItemDisplayNotificationMessage>(message), id, data);
  }
}
public class RevisedBackpackOutfitCooldownResetCallback extends DelayCallback {
  public let m_controller: wref<RevisedBackpackController>;
  public func Call() -> Void {
    this.m_controller.SetOutfitCooldown(false);
  }
}
public class RevisedBackpackFilterDebounceCallback extends DelayCallback {
  public let m_controller: wref<RevisedBackpackFiltersController>;
  public func Call() -> Void {
    this.m_controller.ApplyFilters();
  }
}
public class RevisedBackpackTemplateClassifier extends inkVirtualItemTemplateClassifier {}
public class RevisedBackpackCustomFontSize extends ScriptableService {
  private let backpackFontSize: Int32 = 36;
  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Loaded", this, n"OnStyleLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\common\\main_colors.inkstyle"));
  }
  private cb func OnStyleLoaded(event: ref<ResourceEvent>) -> Void {
    let resource: ref<inkStyleResource> = event.GetResource() as inkStyleResource;
    let newStyle: inkStyle = resource.styles[0];
    let newProperties: array<inkStyleProperty> = newStyle.properties;
    let newProperty: inkStyleProperty;
    newProperty.propertyPath = n"MainColors.BackpackRevisedFontSize";
    newProperty.value = ToVariant(this.backpackFontSize);
    ArrayPush(newProperties, newProperty);
    newStyle.properties = newProperties;
    resource.styles[0] = newStyle;
  }
}
public abstract class RevisedBackpackDefaultConfig {
  public static final func Categories() -> array<ref<RevisedBackpackCategory>> {
    let newCategories: array<ref<RevisedBackpackCategory>>;
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        10,
        n"UI-Filters-AllItems",
        n"resource",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateAll()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        20,
        n"UI-Filters-RangedWeapons",
        n"gun",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateRangedWeapons()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        30,
        n"UI-Filters-MeleeWeapons",
        n"melee",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateMeleeWeapons()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        40,
        n"UI-Filters-Clothes",
        n"clothes",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateClothes()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        50,
        n"UI-Filters-Consumables",
        n"medicine",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateConsumables()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        60,
        n"UI-Filters-Grenades",
        n"grenade",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateGrenades()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        70,
        n"UI-Filters-Attachments",
        n"scope",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateAttachments()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        80,
        n"UI-Filters-Hacks",
        n"hacks",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicatePrograms()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        90,
        n"UI-Filters-Cyberware",
        n"ripperdoc",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateCyberware()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        100,
        n"Mod-Revised-Quest-Items",
        n"minor_quest",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateQuest()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        110,
        n"UI-Filters-Junk",
        n"junk",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateJunk()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        120,
        n"Mod-Revised-New-Items",
        n"asterix",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateNew()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        130,
        n"Story-base-gameplay-gui-widgets-vehicle_control-vehicles_manager-Favorite",
        n"fav_star",
        r"base\\gameplay\\gui\\fullscreen\\ripperdoc\\assets\\cw_bars_assets.inkatlas",
        new RevisedCategoryPredicateFavorite()
      )
    );
    ArrayPush(
      newCategories,
      RevisedBackpackCategory.Create(
        140,
        n"Mod-Revised-Column-Junk",
        n"tech",
        r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas",
        new RevisedCategoryPredicateCustomJunk()
      )
    );
    return newCategories;
  }
}
// AllItems
private class RevisedCategoryPredicateAll extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return true;
  }
}
// RangedWeapons
private class RevisedCategoryPredicateRangedWeapons extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"RangedWeapon");
  }
}
// MeleeWeapons
private class RevisedCategoryPredicateMeleeWeapons extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"MeleeWeapon") && !data.HasTag(n"Cyberware") ;
  }
}
// Clothes
private class RevisedCategoryPredicateClothes extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Clothing");
  }
}
// Consumables
private class RevisedCategoryPredicateConsumables extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Consumable");
  }
}
// Grenades
private class RevisedCategoryPredicateGrenades extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Grenade");
  }
}
// Attachments
private class RevisedCategoryPredicateAttachments extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"itemPart") && !data.HasTag(n"Fragment") && !data.HasTag(n"SoftwareShard");
  }
}
// Programs
private class RevisedCategoryPredicatePrograms extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"SoftwareShard") || data.HasTag(n"QuickhackCraftingPart");
  }
}
// Cyberware
private class RevisedCategoryPredicateCyberware extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Cyberware") || data.HasTag(n"Fragment");
  }
}
// Quest
private class RevisedCategoryPredicateQuest extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Quest") || data.HasTag(n"UnequipBlocked");
  }
}
// Junk
private class RevisedCategoryPredicateJunk extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    let data: ref<gameItemData> = item.data;
    return data.HasTag(n"Junk");
  }
}
// New
private class RevisedCategoryPredicateNew extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return item.inventoryItem.IsNew();
  }
}
// Favorite
private class RevisedCategoryPredicateFavorite extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return item.inventoryItem.IsPlayerFavourite();
  }
}
// Custom junk
private class RevisedCategoryPredicateCustomJunk extends RevisedCategoryPredicate {
  public func Check(item: ref<RevisedItemWrapper>) -> Bool {
    return item.customJunk;
  }
}
@addField(UIInventoryItemsManager)
public let revisedBackpackSystem: wref<RevisedBackpackSystem>;
@wrapMethod(UIInventoryItemsManager)
public final func AttachPlayer(player: wref<PlayerPuppet>) -> Void {
  wrappedMethod(player);
  this.revisedBackpackSystem = RevisedBackpackSystem.GetInstance(player.GetGame());
}
@addMethod(UIInventoryItemsManager)
public final func IsCustomJunk(itemId: ItemID) -> Bool {
  return this.revisedBackpackSystem.IsAddedToJunk(itemId);
}
@wrapMethod(UIInventoryItem)
public final func IsJunk() -> Bool {
  let wrapped: Bool = wrappedMethod();
  let isCustomJunk: Bool = this.m_manager.IsCustomJunk(this.ID);
  return wrapped || isCustomJunk;
}
@wrapMethod(FullscreenVendorGameController)
private final func PopulatePlayerInventory() -> Void {
  wrappedMethod();
  if RevisedBackpackSystem.GetInstance(this.m_player.GetGame()).HasCustomJunk() {
    this.m_buttonHintsController.AddButtonHint(n"sell_junk", GetLocalizedText("UI-UserActions-SellJunk"));
  };
}
@addMethod(InventoryDataManagerV2)
public final func GetItemsWithExistingPrice(out items: array<wref<gameItemData>>) -> Void {
  let unfilteredItems: array<wref<gameItemData>> = this.GetPlayerInventoryItems();
  let data: ref<gameItemData>;
  let itemId: ItemID;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  let price: Int32;
  while i < limit {
    data = unfilteredItems[i];
    itemId = data.GetID();
    price = RPGManager.CalculateSellPrice(this.m_Player.GetGame(), this.m_Player, data.GetID());
    if price > 0 {
      ArrayPush(items, data);
    };
    i += 1;
  };
}
@addMethod(InventoryDataManagerV2)
public final func GetPlayerItemsCustomJunk(out items: array<wref<gameItemData>>) -> Void {
  let system: ref<RevisedBackpackSystem> = RevisedBackpackSystem.GetInstance(this.m_Player.GetGame());
  let unfilteredItems: array<wref<gameItemData>>;
  this.GetItemsWithExistingPrice(unfilteredItems);
  let data: ref<gameItemData>;
  let limit: Int32 = ArraySize(unfilteredItems);
  let i: Int32 = 0;
  while i < limit {
    data = unfilteredItems[i];
    if system.IsAddedToJunk(data.GetID()) {
      ArrayPush(items, data);
    };
    i += 1;
  };
}
@wrapMethod(FullscreenVendorGameController)
private final func GetSellableJunk() -> array<wref<gameItemData>> {
  let result: array<wref<gameItemData>> = wrappedMethod();
  let additionalJunk: array<wref<gameItemData>>;
  this.m_InventoryManager.GetPlayerItemsCustomJunk(additionalJunk);
  for additionalItem in additionalJunk {
    ArrayPush(result, additionalItem);
  };
  return result;
}
@addMethod(InventoryDataManagerV2)
public final func GetItemSlotIndexRev(owner: ref<GameObject>, itemId: ItemID) -> Int32 {
  return this.m_EquipmentSystem.GetItemSlotIndex(owner, itemId);
}
class InsertBetterBackpackMenuItem extends ScriptableService {
  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/Ready", this, n"OnMenuResourceReady")
      .AddTarget(ResourceTarget.Path(r"base\\gameplay\\gui\\fullscreen\\menu.inkmenu"));
  }
  private cb func OnMenuResourceReady(event: ref<ResourceEvent>) {
    let resource: ref<inkMenuResource> = event.GetResource() as inkMenuResource;
    let newMenuEntry: inkMenuEntry;
    newMenuEntry.depth = 0u;
    newMenuEntry.spawnMode = inkSpawnMode.SingleAndMultiplayer;
    newMenuEntry.isAffectedByFadeout = true;
    newMenuEntry.menuWidget *= r"base\\gameplay\\gui\\fullscreen\\inventory\\revised_backpack.inkwidget";
    newMenuEntry.name = n"revised_backpack";
    ArrayPush(resource.menusEntries, newMenuEntry);
  }
}
@wrapMethod(MenuHubLogicController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  this.AddRevisedBackpackMenuItem();
}
@addMethod(MenuHubLogicController)
private final func AddRevisedBackpackMenuItem() -> Void {
  let isInComaQuest: Bool = HubMenuUtility.IsPlayerHardwareDisabled(GetPlayer(GetGameInstance()));
  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let container: ref<inkCompoundWidget> = root.GetWidgetByPathName(n"mainMenu/buttonsContainer/panel_inventory") as inkCompoundWidget;
  let improvedBackpackItem: ref<inkWidget> = this.SpawnFromLocal(container, n"menu_button");
  improvedBackpackItem.SetMargin(new inkMargin(0.0, 510.0, 0.0, 0.0));
  let data: MenuData;
  data.disabled = isInComaQuest;
  data.fullscreenName = n"revised_backpack";
  data.identifier = 42;
  data.parentIdentifier = 3;
  data.label = GetLocalizedTextByKey(n"Mod-Revised-Mod-Name");
  data.icon = n"ico_backpack";
  let controller: ref<MenuItemController> = improvedBackpackItem.GetController() as MenuItemController;
  controller.Init(data);
}
public class RevisedBackpackConfirmationPopup {
  public static func Show(controller: ref<worlduiIGameController>, message: String, type: GenericMessageNotificationType) -> ref<inkGameNotificationToken> {
    return GenericMessageNotification.Show(
      controller, 
      GetLocalizedText("LocKey#11447"), 
      message,
      type
    );
  }
}
public class RevisedBackpackController extends gameuiMenuGameController {
  private let m_player: wref<PlayerPuppet>;
  private let m_system: wref<RevisedBackpackSystem>;
  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;
  private let m_itemDisplayContext: ref<ItemDisplayContextData>;
  private let m_junkItems: array<ref<UIInventoryItem>>;
  private let m_customJunkItems: array<ref<RevisedItemWrapper>>;
  private let m_selectedItems: array<ref<RevisedItemWrapper>>;
  private let m_itemDropQueueItems: array<ItemID>;
  private let m_itemDropQueue: array<ItemModParams>;
  private let m_isRefreshUIScheduled: Bool;
  private let m_EquippedCallback: ref<UI_EquipmentDef>;
  private let m_EquippedBlackboard: wref<IBlackboard>;
  private let m_EquippedBBID: ref<CallbackHandle>;
  private let m_InventoryCallback: ref<UI_InventoryDef>;
  private let m_InventoryBlackboard: wref<IBlackboard>;
  private let m_InventoryItemAddedBBID: ref<CallbackHandle>;
  private let m_InventoryItemRemvoedBBID: ref<CallbackHandle>;
  private let m_InventoryItemQuantityChangedBBID: ref<CallbackHandle>;
  private let m_comparisonResolver: ref<InventoryItemPreferredComparisonResolver>;
  private let m_comparedItemDisplayContext: ref<ItemDisplayContextData>;
  private let m_isComparisonDisabled: Bool;
  private let m_backpackInventoryListenerCallback: ref<RevisedBackpackInventoryListenerCallback>;
  private let m_immediateNotificationListener: ref<RevisedBakcpackImmediateNotificationListener>;
  private let m_backpackInventoryListener: ref<InventoryScriptListener>;
  private let m_equipSlotChooserPopupToken: ref<inkGameNotificationToken>;
  private let m_quantityPickerPopupToken: ref<inkGameNotificationToken>;
  private let m_disassembleJunkPopupToken: ref<inkGameNotificationToken>;
  private let m_confirmationPopupToken: ref<inkGameNotificationToken>;
  private let m_massActionPopupToken: ref<inkGameNotificationToken>;
  private let m_equipRequested: Bool;
  private let m_psmBlackboard: wref<IBlackboard>;
  private let playerState: gamePSMVehicle;
  private let itemsListController: wref<inkVirtualListController>;
  private let itemsListScrollController: wref<inkScrollController>;
  private let itemsListDataSource: ref<ScriptableDataSource>;
  private let itemsListDataView: ref<RevisedBackpackDataView>;
  private let itemsListTemplateClassifier: ref<RevisedBackpackTemplateClassifier>;
  private let m_virtualList: inkVirtualCompoundRef;
  private let m_scrollAreaContainer: inkWidgetRef;
  private let m_categoriesContainer: inkHorizontalPanelRef;
  private let m_categoryName: inkTextRef;
  private let m_categoryIndicator: inkWidgetRef;
  private let m_previewGarmentContainer: inkWidgetRef;
  private let m_previewItemContainer: inkWidgetRef;
  private let m_selectedItemsCount: inkTextRef;
  private let m_animTargetCategories: inkWidgetRef;
  private let m_animTargetFilters: inkWidgetRef;
  private let m_animTargetHeader: inkWidgetRef;
  private let m_animTargetList: inkWidgetRef;
  private let m_animProxyCategories: ref<inkAnimProxy>;
  private let m_animProxyFilters: ref<inkAnimProxy>;
  private let m_animProxyHeader: ref<inkAnimProxy>;
  private let m_animProxyList: ref<inkAnimProxy>;
  private let m_uiInventorySystem: wref<UIInventoryScriptableSystem>;
  private let m_inventoryManager: ref<InventoryDataManagerV2>;
  private let m_uiScriptableSystem: wref<UIScriptableSystem>;
  private let m_buttonHintsManagerRef: inkWidgetRef;
  private let m_buttonHintsController: wref<ButtonHints>;
  private let m_TooltipsManagerRef: inkWidgetRef;
  private let m_TooltipsManager: wref<gameuiTooltipsManager>;
  private let m_itemNotificationRoot: inkWidgetRef;
  private let m_afterCloseRequest: Bool;
  private let m_lastItemHoverOverEvent: ref<RevisedBackpackItemHoverOverEvent>;
  private let m_pressedItemDisplay: wref<RevisedBackpackItemController>;
  private let m_availableCategories: array<ref<RevisedBackpackCategory>>;
  private let m_cursorData: ref<MenuCursorUserData>;
  private let m_customJunkInvalidated: Bool;
  private let m_delayedOutfitCooldownResetCallbackId: DelayID;
  private let m_outfitInCooldown: Bool;
  private let m_outfitCooldownPeroid: Float;
  private let m_virtualWidgets: ref<inkWeakHashMap>;
  private let m_allWidgets: ref<inkWeakHashMap>;
  private let m_lastHighlightedItem: wref<RevisedBackpackItemController>;
  protected cb func OnInitialize() -> Bool {
    let playerPuppet: wref<GameObject>;
    this.m_backpackInventoryListenerCallback = new RevisedBackpackInventoryListenerCallback();
    this.m_backpackInventoryListenerCallback.Setup(this);
    this.m_buttonHintsController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.m_buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
    this.m_TooltipsManager = inkWidgetRef.GetControllerByType(this.m_TooltipsManagerRef, n"gameuiTooltipsManager") as gameuiTooltipsManager;
    this.m_TooltipsManager.Setup(ETooltipsStyle.Menus);
    this.RegisterToBB();
    this.AsyncSpawnFromExternal(inkWidgetRef.Get(this.m_itemNotificationRoot), r"base\\gameplay\\gui\\widgets\\activity_log\\activity_log_panels.inkwidget", n"RootVert");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnPostOnRelease");
    playerPuppet = this.GetOwnerEntity() as PlayerPuppet;
    this.m_psmBlackboard = this.GetPSMBlackboard(playerPuppet);
    this.playerState = IntEnum<gamePSMVehicle>(this.m_psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle));
    this.m_outfitCooldownPeroid = 0.4;
    this.m_customJunkInvalidated = false;
    this.itemsListController = inkWidgetRef.GetController(this.m_virtualList) as inkVirtualListController;
    this.itemsListScrollController = inkWidgetRef.GetControllerByType(this.m_scrollAreaContainer, n"inkScrollController") as inkScrollController;
    this.SpawnPreviews();
    super.OnInitialize();
  }
  protected cb func OnUninitialize() -> Bool {
    GameInstance.GetDelaySystem(this.m_player.GetGame()).CancelCallback(this.m_delayedOutfitCooldownResetCallbackId);
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnCloseMenu", this, n"OnCloseMenu");
    this.m_inventoryManager.UnInitialize();
    this.m_uiInventorySystem.FlushFullscreenCache();
    this.UnregisterFromBB();
    GameInstance.GetTransactionSystem(this.m_player.GetGame()).UnregisterInventoryListener(this.m_player, this.m_backpackInventoryListener);
    this.m_backpackInventoryListener = null;
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnPostOnRelease");
    super.OnUninitialize();
  }
  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    if this.m_player != null {
      GameInstance.GetTransactionSystem(this.m_player.GetGame()).UnregisterInventoryListener(this.m_player, this.m_backpackInventoryListener);
    };
    this.m_player = playerPuppet as PlayerPuppet;
    this.m_system = RevisedBackpackSystem.GetInstance(this.m_player.GetGame());
    this.m_availableCategories = this.m_system.GetCategories();
    this.m_uiScriptableSystem = UIScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_uiInventorySystem = UIInventoryScriptableSystem.GetInstance(this.m_player.GetGame());
    this.m_itemDisplayContext = ItemDisplayContextData.Make(this.m_player, ItemDisplayContext.Backpack, true);
    this.m_comparedItemDisplayContext = this.m_itemDisplayContext.Copy().SetDisplayComparison(false);
    this.m_inventoryManager = new InventoryDataManagerV2();
    this.m_inventoryManager.Initialize(this.m_player);
    this.m_comparisonResolver = InventoryItemPreferredComparisonResolver.Make(this.m_uiInventorySystem);
    this.m_backpackInventoryListener = GameInstance.GetTransactionSystem(this.m_player.GetGame()).RegisterInventoryListener(this.m_player, this.m_backpackInventoryListenerCallback);
    this.m_isComparisonDisabled = this.m_uiScriptableSystem.IsComparisionTooltipDisabled();
    if this.m_player.PlayerLastUsedKBM() {
      this.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText(this.m_isComparisonDisabled ? "UI-UserActions-EnableComparison" : "UI-UserActions-DisableComparison"));
    };
    this.UpdateSelectedItemsCounter();
    this.SetupVirtualList();
    this.PopulateCategories();
    this.PopulateInventory();
    this.PlayIntroAnimation();
    this.Log(s"OnPlayerAttach: service \(IsDefined(this.m_system)), categories: \(ArraySize(this.m_availableCategories))");
  }
  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    this.ResetVirtualList();
    this.StopAnimations();
  }
  protected cb func OnPostOnRelease(evt: ref<inkPointerEvent>) -> Bool {
    let setComparisionDisabledRequest: ref<UIScriptableSystemSetComparisionTooltipDisabled>;
    if evt.IsAction(n"toggle_comparison_tooltip") && this.m_player.PlayerLastUsedKBM() {
      this.m_isComparisonDisabled = !this.m_isComparisonDisabled;
      this.m_buttonHintsController.AddButtonHint(n"toggle_comparison_tooltip", GetLocalizedText(this.m_isComparisonDisabled ? "UI-UserActions-EnableComparison" : "UI-UserActions-DisableComparison"));
      setComparisionDisabledRequest = new UIScriptableSystemSetComparisionTooltipDisabled();
      setComparisionDisabledRequest.value = this.m_isComparisonDisabled;
      this.m_uiScriptableSystem.QueueRequest(setComparisionDisabledRequest);
      this.InvalidateItemTooltipEvent();
    };
    if evt.IsAction(n"mouse_left") {
      if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
        this.RequestSetFocus(null);
      };
    };
    // down_button called first, UI_MoveDown called second, then revised_nav_down
    // UI_MoveUp called first, up_button called second, then revised_nav_up
    if evt.IsAction(n"revised_nav_up") { 
      this.TryToSelectPreviousItem();
    };
    if evt.IsAction(n"revised_nav_down") { 
      this.TryToSelectNextItem();
    };
  }
  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    this.Log("OnSetMenuEventDispatcher");
    super.OnSetMenuEventDispatcher(menuEventDispatcher);
    this.m_menuEventDispatcher = menuEventDispatcher;
    this.m_menuEventDispatcher.RegisterToEvent(n"OnBack", this, n"OnBack");
    this.m_menuEventDispatcher.RegisterToEvent(n"OnCloseMenu", this, n"OnCloseMenu");
  }
  protected cb func OnCloseMenu(userData: ref<IScriptable>) -> Bool {
    if ArraySize(this.m_itemDropQueue) == 1 && this.m_itemDropQueue[0].quantity == 1 {
      ItemActionsHelper.DropItem(this.m_player, this.m_itemDropQueue[0].itemID);
      ArrayClear(this.m_itemDropQueue);
    } else {
      if ArraySize(this.m_itemDropQueue) > 0 {
        RPGManager.DropManyItems(this.m_player.GetGame(), this.m_player, this.m_itemDropQueue);
        ArrayClear(this.m_itemDropQueue);
      };
    };
  }
  protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    if !this.m_afterCloseRequest {
      super.OnBack(userData);
    } else {
      this.m_afterCloseRequest = false;
    };
  }
  private final func RegisterToBB() -> Void {
    this.m_EquippedCallback = GetAllBlackboardDefs().UI_Equipment;
    this.m_InventoryCallback = GetAllBlackboardDefs().UI_Inventory;
    this.m_EquippedBlackboard = this.GetBlackboardSystem().Get(this.m_EquippedCallback);
    this.m_InventoryBlackboard = this.GetBlackboardSystem().Get(this.m_InventoryCallback);
    if IsDefined(this.m_EquippedBlackboard) {
      this.m_EquippedBBID = this.m_EquippedBlackboard.RegisterDelayedListenerVariant(this.m_EquippedCallback.itemEquipped, this, n"OnItemEquipped", true);
    };
    if IsDefined(this.m_InventoryBlackboard) {
      this.m_InventoryItemAddedBBID = this.m_InventoryBlackboard.RegisterDelayedListenerVariant(this.m_InventoryCallback.itemRemoved, this, n"OnInventoryItemRemoved", false);
      this.m_InventoryItemRemvoedBBID = this.m_InventoryBlackboard.RegisterDelayedListenerVariant(this.m_InventoryCallback.itemAdded, this, n"OnInventoryItemAdded", false);
      this.m_InventoryItemQuantityChangedBBID = this.m_InventoryBlackboard.RegisterDelayedListenerVariant(this.m_InventoryCallback.itemQuantityChanged, this, n"OnInventoryItemQuantityChanged", false);
    };
  }
  private final func UnregisterFromBB() -> Void {
    if IsDefined(this.m_EquippedBlackboard) {
      this.m_EquippedBlackboard.UnregisterDelayedListener(this.m_EquippedCallback.itemEquipped, this.m_EquippedBBID);
    };
    if IsDefined(this.m_InventoryBlackboard) {
      this.m_InventoryBlackboard.UnregisterDelayedListener(this.m_InventoryCallback.itemRemoved, this.m_InventoryItemAddedBBID);
      this.m_InventoryBlackboard.UnregisterDelayedListener(this.m_InventoryCallback.itemAdded, this.m_InventoryItemRemvoedBBID);
      this.m_InventoryBlackboard.UnregisterDelayedListener(this.m_InventoryCallback.itemQuantityChanged, this.m_InventoryItemQuantityChangedBBID);
    };
  }
  private final func SetupVirtualList() -> Void {
    this.itemsListDataSource = new ScriptableDataSource();
    this.itemsListDataView = new RevisedBackpackDataView();
    this.itemsListDataView.Init();
    this.itemsListDataView.BindUIScriptableSystem(this.m_uiScriptableSystem);
    this.itemsListDataView.SetSource(this.itemsListDataSource);
    this.itemsListDataView.EnableSorting();
    this.itemsListTemplateClassifier = new RevisedBackpackTemplateClassifier();
    this.itemsListController.SetClassifier(this.itemsListTemplateClassifier);
    this.itemsListController.SetSource(this.itemsListDataView);
    this.Log(s"InitializeVirtualList: \(IsDefined(this.itemsListController)) \(IsDefined(this.itemsListScrollController))");
  }
  private final func ResetVirtualList() -> Void {
    this.itemsListController.SetSource(null);
    this.itemsListController.SetClassifier(null);
    this.itemsListDataView.SetSource(null);
    this.itemsListDataView = null;
    this.itemsListDataSource = null;
    this.itemsListTemplateClassifier = null;
  }
  private final func PlayIntroAnimation() -> Void {
    let duration: Float = 0.2;
    let categories: ref<inkAnimDef> = this.AnimateTranslationAndOpacity(new Vector2(0.0, -200.0), new Vector2(0.0, 0.0), duration, 0.0);
    let header: ref<inkAnimDef> = this.AnimateTranslationAndOpacity(new Vector2(0.0, -100.0), new Vector2(0.0, 0.0), duration, 0.0);
    let filters: ref<inkAnimDef> = this.AnimateTranslationAndOpacity(new Vector2(0.0, 100.0), new Vector2(0.0, 0.0), duration, 0.0);
    let list: ref<inkAnimDef> = this.AnimateOpacity(duration, duration);
    this.m_animProxyCategories = inkWidgetRef.PlayAnimation(this.m_animTargetCategories, categories);
    this.m_animProxyHeader = inkWidgetRef.PlayAnimation(this.m_animTargetHeader, header);
    this.m_animProxyFilters = inkWidgetRef.PlayAnimation(this.m_animTargetFilters, filters);
    this.m_animProxyList = inkWidgetRef.PlayAnimation(this.m_animTargetList, list);
  }
  private final func StopAnimations() -> Void {
    if IsDefined(this.m_animProxyCategories) {
      if this.m_animProxyCategories.IsPlaying() {
        this.m_animProxyCategories.Stop();
        this.m_animProxyCategories = null;
      };
    }
    if IsDefined(this.m_animProxyFilters) {
      if this.m_animProxyFilters.IsPlaying() {
        this.m_animProxyFilters.Stop();
        this.m_animProxyFilters = null;
      };
    }
    if IsDefined(this.m_animProxyHeader) {
      if this.m_animProxyHeader.IsPlaying() {
        this.m_animProxyHeader.Stop();
        this.m_animProxyHeader = null;
      };
    }
    if IsDefined(this.m_animProxyList) {
      if this.m_animProxyList.IsPlaying() {
        this.m_animProxyList.Stop();
        this.m_animProxyList = null;
      };
    }
  }
  public final func OnBakcpackItemDisplayNotification(message: ItemDisplayNotificationMessage, id: Uint64, opt data: wref<IScriptable>) -> Void {
    if Equals(message, ItemDisplayNotificationMessage.AddRef) {
      this.m_virtualWidgets.Remove(id);
      this.m_virtualWidgets.Insert(id, data);
    } else {
      if Equals(message, ItemDisplayNotificationMessage.RemoveRef) {
        this.m_virtualWidgets.Remove(id);
      };
    };
  }
  protected cb func OnItemEquipped(value: Variant) -> Bool {
    if this.m_equipRequested {
      this.RefreshUINextFrame();
      this.m_equipRequested = false;
      this.m_comparisonResolver.FlushCache();
    };
  }
  protected cb func OnInventoryItemRemoved(value: Variant) -> Bool {
    let itemAddedData: ItemAddedData = FromVariant<ItemAddedData>(value);
    this.HandleItemQuantityModified(itemAddedData.itemID, itemAddedData.isBackpackItem);
  }
  protected cb func OnInventoryItemAdded(value: Variant) -> Bool {
    let itemRemovedData: ItemRemovedData = FromVariant<ItemRemovedData>(value);
    this.HandleItemQuantityModified(itemRemovedData.itemID, itemRemovedData.isBackpackItem);
  }
  protected cb func OnInventoryItemQuantityChanged(value: Variant) -> Bool {
    let itemQuantityChangedData: ItemQuantityChangedData = FromVariant<ItemQuantityChangedData>(value);
    this.HandleItemQuantityModified(itemQuantityChangedData.itemID, itemQuantityChangedData.isBackpackItem);
  }
  private final func HandleItemQuantityModified(itemID: ItemID, backpackItem: Bool) -> Void {
    if backpackItem {
      if !this.m_uiInventorySystem.GetPlayerItem(itemID).GetItemData().HasTag(n"CraftingPart") {
        this.RefreshUINextFrame();
      };
    };
  }
  private final func TryToSelectNextItem() -> Void {
    this.Log("TryToSelectNextItem");
    let selectedItems: Int32 = ArraySize(this.m_selectedItems);
    if selectedItems > 1 {
      return ;
    };
    let dataViewItemCount: Int32 = Cast<Int32>(this.itemsListDataView.Size());
    let selectedItemIndex: Int32 = this.TryToFindSelectedItemIndex();
    let targetItemIndex: Int32;
    if selectedItemIndex <= -1 || selectedItemIndex >= dataViewItemCount - 1 {
      targetItemIndex = 0;
    } else {
      targetItemIndex = selectedItemIndex + 1;
    };
    this.Log(s"Selected index \(selectedItemIndex), next index \(targetItemIndex)");
    let nextItem: ref<RevisedItemWrapper> = this.itemsListDataView.GetItem(Cast<Uint32>(targetItemIndex)) as RevisedItemWrapper;
    if IsDefined(nextItem) {
      this.QueueEvent(RevisedBackpackItemSelectEvent.Create(nextItem));
    };
  }
  private final func TryToSelectPreviousItem() -> Void {
    this.Log("TryToSelectPreviousItem");
    let selectedItems: Int32 = ArraySize(this.m_selectedItems);
    if selectedItems > 1 {
      return ;
    };
    let dataViewItemCount: Int32 = Cast<Int32>(this.itemsListDataView.Size());
    let selectedItemIndex: Int32 = this.TryToFindSelectedItemIndex();
    let targetItemIndex: Int32;
    if Equals(selectedItemIndex, -1) || Equals(selectedItemIndex, 0) {
      targetItemIndex = dataViewItemCount - 1;
    } else {
      targetItemIndex = selectedItemIndex - 1;
    };
    this.Log(s"Selected index \(selectedItemIndex), next index \(targetItemIndex)");
    let nextItem: ref<RevisedItemWrapper> = this.itemsListDataView.GetItem(Cast<Uint32>(targetItemIndex)) as RevisedItemWrapper;
    if IsDefined(nextItem) {
      this.QueueEvent(RevisedBackpackItemSelectEvent.Create(nextItem));
    };
  }
  private final func TryToFindSelectedItemIndex() -> Int32 {
    let count: Uint32 = this.itemsListDataView.Size();
    let index: Uint32 = 0u;
    let wrapper: ref<RevisedItemWrapper>;
    while index < count {
      wrapper = this.itemsListDataView.GetItem(index) as RevisedItemWrapper;
      if IsDefined(wrapper) {
        if wrapper.GetSelectedFlag() {
          return Cast<Int32>(index);
        };
      };
      index += 1u;
    };
    return -1;
  }
  private final func RefreshUI() -> Void {
    this.PopulateInventory();
  }
  private final func RefreshUINextFrame() -> Void {
    if this.m_isRefreshUIScheduled {
      return;
    };
    this.m_isRefreshUIScheduled = true;
    this.QueueEvent(new BackpackUpdateNextFrameEvent());
  }
  protected cb func OnRefreshUINextFrame(e: ref<BackpackUpdateNextFrameEvent>) -> Bool {
    this.m_isRefreshUIScheduled = false;
    this.RefreshUI();
  }
  protected final func AddToDropQueue(item: ItemModParams) -> Void {
    let evt: ref<DropQueueUpdatedEvent>;
    let merged: Bool;
    let i: Int32 = 0;
    while i < ArraySize(this.m_itemDropQueue) {
      if this.m_itemDropQueue[i].itemID == item.itemID {
        this.m_itemDropQueue[i].quantity += item.quantity;
        merged = true;
        break;
      };
      i += 1;
    };
    if !merged {
      ArrayPush(this.m_itemDropQueue, item);
      ArrayPush(this.m_itemDropQueueItems, item.itemID);
    };
    evt = new DropQueueUpdatedEvent();
    evt.m_dropQueue = this.m_itemDropQueue;
    this.QueueEvent(evt);
  }
  private final func GetDropQueueItem(itemID: ItemID) -> ItemModParams {
    let dummy: ItemModParams;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_itemDropQueue);
    while i < limit {
      if this.m_itemDropQueue[i].itemID == itemID {
        return this.m_itemDropQueue[i];
      };
      i += 1;
    };
    return dummy;
  }
  private final func PopulateInventory() -> Void {
    let i: Int32;
    let limit: Int32;
    let quantity: Int32;
    let playerItems: ref<inkHashMap>;
    let tagsToFilterOut: array<CName>;
    let uiInventoryItem: ref<UIInventoryItem>;
    let values: array<wref<IScriptable>>;
    let wrappedItem: ref<RevisedItemWrapper>;
    let wrappedItems: array<ref<IScriptable>>;
    let dropItem: ItemModParams;
    // ArrayPush(tagsToFilterOut, n"HideInBackpackUI");
    // ArrayPush(tagsToFilterOut, n"SoftwareShard");
    ArrayPush(tagsToFilterOut, n"Recipe");
    ArrayPush(tagsToFilterOut, n"CraftingPart");
    this.m_uiInventorySystem.FlushTempData();
    playerItems = this.m_uiInventorySystem.GetPlayerItemsMap();
    playerItems.GetValues(values);
    ArrayClear(this.m_junkItems);
    ArrayClear(this.m_customJunkItems);
    i = 0;
    limit = ArraySize(values);
    while i < limit {
      let shouldSkipItem: Bool = false;
      uiInventoryItem = values[i] as UIInventoryItem;
      if ItemID.HasFlag(uiInventoryItem.GetID(), gameEItemIDFlag.Preview) || uiInventoryItem.HasAnyTag(tagsToFilterOut)  {
        shouldSkipItem = true;
      };
      if ArrayContains(this.m_itemDropQueueItems, uiInventoryItem.ID) {
        quantity = uiInventoryItem.GetQuantity(true);
        dropItem = this.GetDropQueueItem(uiInventoryItem.ID);
        if dropItem.quantity >= quantity {
          shouldSkipItem = true;
        } else {
          uiInventoryItem.SetQuantity(quantity - dropItem.quantity);
        };
      };
      if uiInventoryItem.IsJunk() {
        ArrayPush(this.m_junkItems, uiInventoryItem);
      };
      if !shouldSkipItem {
        wrappedItem = this.BuildWrappedItem(uiInventoryItem);
        ArrayPush(wrappedItems, wrappedItem);
      };
      if wrappedItem.GetCustomJunkFlag() {
        ArrayPush(this.m_customJunkItems, wrappedItem);
      };
      i += 1;
    };
    this.itemsListDataSource.Reset(wrappedItems);
    this.itemsListDataView.UpdateView();
    this.Log(s"PopulateInventory \(ArraySize(wrappedItems))");
    if !this.m_customJunkInvalidated {
      this.m_customJunkInvalidated = true;
      this.m_system.InvalidateCustomJunk(wrappedItems);
    };
  }
  private final func RequestItemInspected(itemID: ItemID) -> Void {
    let request: ref<UIScriptableSystemInventoryInspectItem> = new UIScriptableSystemInventoryInspectItem();
    request.itemID = itemID;
    this.m_uiScriptableSystem.QueueRequest(request);
  }
  private final func GetBackpackItemQuantity(inventoryItem: wref<UIInventoryItem>) -> Int32 {
    let dropItem: ItemModParams;
    let result: Int32 = inventoryItem.GetQuantity(true);
    if ArrayContains(this.m_itemDropQueueItems, inventoryItem.GetID()) {
      dropItem = this.GetDropQueueItem(inventoryItem.GetID());
      if dropItem.quantity >= result {
        return 0;
      };
      result -= dropItem.quantity;
    };
    return result;
  }
  protected cb func OnRevisedFiltersActionEvent(evt: ref<RevisedFiltersActionEvent>) -> Bool {
    this.Log(s"Run mass action \(evt.type)");
    switch evt.type {
      case revisedFiltersAction.Select:
        this.SelectFilteredItems();
        break;
      case revisedFiltersAction.Junk:
        this.JunkCurrentSelection();
        break;
      case revisedFiltersAction.Disassemble:
        this.DisassembleCurrentSelection();
        break;
    }
  }
  private final func SelectFilteredItems() -> Void {
    this.DeselectLastHighlightedItem();
    this.UpdateSelectionForDataViewWrappers(true);
    this.UpdateSelectionForVirtualListControllers(true);
    let selectedItems: array<ref<RevisedItemWrapper>>;
    let dataViewItemCount: Uint32 = this.itemsListDataView.Size();
    let index: Uint32 = 0u;
    let wrapper: ref<RevisedItemWrapper>;
    while index < dataViewItemCount {
      wrapper = this.itemsListDataView.GetItem(index) as RevisedItemWrapper;
      if IsDefined(wrapper) {
        if wrapper.GetSelectedFlag() {
          ArrayPush(selectedItems, wrapper);
        };
      };
      index += 1u;
    };
    this.Log(s"SelectFilteredItems selects \(dataViewItemCount)");
    this.StoreSelection(selectedItems);
  }
  private final func JunkCurrentSelection() -> Void {
    if Equals(ArraySize(this.m_selectedItems), 0) {
      return;
    };
    this.m_massActionPopupToken = RevisedBackpackConfirmationPopup.Show(this, GetLocalizedTextByKey(n"Mod-Revised-Filter-Junk-Confirm"), GenericMessageNotificationType.YesNo);
    this.m_massActionPopupToken.RegisterListener(this, n"OnJunkConfirmationClosed");
  }
  protected cb func OnJunkConfirmationClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Yes)  {
      this.ConfirmSelectionCustomJunk();
    };
    this.m_massActionPopupToken = null;
  }
  private final func ConfirmSelectionCustomJunk() -> Void {
    let wasAddedToJunk: Bool;
    for selectedItem in this.m_selectedItems {
      if selectedItem.customJunkToggleable {
        wasAddedToJunk = this.m_system.AddToJunk(selectedItem.data.GetID());
        selectedItem.SetCustomJunkFlag(wasAddedToJunk);
      };
    };
    this.PlaySound(n"ui_menu_item_disassemble");
    let customJunkCategoryIndex: Int32 = ArraySize(this.m_availableCategories) - 1;
    let customJunkCategory: ref<RevisedBackpackCategory> = this.m_availableCategories[customJunkCategoryIndex];
    this.OnRevisedCategorySelectedEvent(RevisedCategorySelectedEvent.Create(customJunkCategory));
    this.RefreshUINextFrame();
  }
  private final func DisassembleCurrentSelection() -> Void {
    if Equals(ArraySize(this.m_selectedItems), 0) {
      return;
    };
    this.m_massActionPopupToken = RevisedBackpackConfirmationPopup.Show(this, GetLocalizedTextByKey(n"Mod-Revised-Filter-Disassemble-Confirm"), GenericMessageNotificationType.YesNo);
    this.m_massActionPopupToken.RegisterListener(this, n"OnDisassembleConfirmationClosed");
  }
  protected cb func OnDisassembleConfirmationClosed(data: ref<inkGameNotificationData>) {
    let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
    if Equals(resultData.result, GenericMessageNotificationResult.Yes)  {
      this.ConfirmSelectionDisassemble();
    };
    this.m_massActionPopupToken = null;
  }
  private final func ConfirmSelectionDisassemble() -> Void {
    let item: ref<UIInventoryItem>;
    for selectedItem in this.m_selectedItems {
      item = selectedItem.inventoryItem;
      if RevisedBackpackUtils.CanDisassemble(this.m_player.GetGame(), item) {
        ItemActionsHelper.DisassembleItem(this.m_player, item.GetID(), item.GetQuantity());
      };
    };
    this.PlaySound(n"ui_menu_item_disassemble");
    this.DeselectLastHighlightedItem();
    this.UpdateSelectionForAllWrappers(false);
    this.UpdateSelectionForVirtualListControllers(false);
    this.ClearStoredSelection();
    this.RefreshUINextFrame();
  }
  protected cb func OnRevisedFilteringEvent(evt: ref<RevisedFilteringEvent>) -> Bool {
    this.itemsListDataView.SetFilters(evt);
  }
  protected cb func OnRevisedCategorySelectedEvent(evt: ref<RevisedCategorySelectedEvent>) -> Bool {
    let selectedIndex: Int32 = -1;
    let i: Int32 = 0;
    let count: Int32 = ArraySize(this.m_availableCategories);
    let category: ref<RevisedBackpackCategory>;
    let shouldBreak: Bool = false;
    while i < count && !shouldBreak {
      category = this.m_availableCategories[i];
      if Equals(category.id, evt.category.id) {
        shouldBreak = true;
        selectedIndex = i;
      };
      i += 1;
    };
    this.DeselectLastHighlightedItem();
    this.UpdateSelectionForAllWrappers(false);
    this.UpdateSelectionForVirtualListControllers(false);
    this.ClearStoredSelection();
    let category: ref<RevisedBackpackCategory>;
    if NotEquals(selectedIndex, -1) {
      this.AnimateIndicatorTranslation(selectedIndex);
      category = this.m_availableCategories[selectedIndex];
      inkTextRef.SetText(this.m_categoryName, GetLocalizedTextByKey(category.titleLocKey));
      this.itemsListDataView.SetCategory(category);
      this.itemsListDataView.RefreshList();
      this.m_TooltipsManager.HideTooltips();
      inkWidgetRef.SetVisible(this.m_previewGarmentContainer, false);
      inkWidgetRef.SetVisible(this.m_previewItemContainer, false);
    };
  }
  protected cb func OnRevisedBackpackSortingChanged(evt: ref<RevisedBackpackSortingChanged>) -> Bool {
    this.Log(s"Request sorting: \(evt.sorting) + \(evt.mode)");
    this.itemsListDataView.SetSortMode(evt.sorting, evt.mode);
    this.m_TooltipsManager.HideTooltips();
  }
  protected cb func OnRevisedBackpackColumnHoverOverEvent(evt: ref<RevisedBackpackColumnHoverOverEvent>) -> Bool {
    let label: String = "";
    switch evt.type {
      case revisedSorting.Name:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Name");
        break;
      case revisedSorting.Type:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Type");
        break;
      case revisedSorting.Tier:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Tier");
        break;
      case revisedSorting.Price:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Price");
        break;
      case revisedSorting.Weight:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Weight");
        break;
      case revisedSorting.Dps:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Dps");
        break;
      case revisedSorting.Range:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Range");
        break;
      case revisedSorting.Quest:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Quest");
        break;
      case revisedSorting.CustomJunk:
        label = GetLocalizedTextByKey(n"Mod-Revised-Column-Junk");
        break;
    };
    if NotEquals(label, "") {
      this.ShowColumnNameTooltip(evt.target, label);
    }
  }
  protected cb func OnRevisedBackpackColumnHoverOutEvent(evt: ref<RevisedBackpackColumnHoverOutEvent>) -> Bool {
    this.m_TooltipsManager.HideTooltips();
  }
  protected cb func OnRevisedBackpackItemHoverOverEvent(evt: ref<RevisedBackpackItemHoverOverEvent>) -> Bool {
    let itemID: ItemID = evt.item.data.GetID();
    if ItemID.IsValid(itemID) {
      this.RequestItemInspected(itemID);
    };
    this.ShowButtonHints(evt.item);
    this.m_lastItemHoverOverEvent = evt;
    this.m_pressedItemDisplay = null;
    this.PlaySound(n"ui_menu_hover");
    if evt.isOverName {
      this.OnInventoryRequestTooltip(evt.item.inventoryItem, evt.widget);
    };
  }
  protected cb func OnRevisedBackpackItemHoverOutEvent(evt: ref<RevisedBackpackItemHoverOutEvent>) -> Bool {
    this.m_lastItemHoverOverEvent = null;
    this.m_pressedItemDisplay = null;
    this.HiteButtonHints();
    this.m_TooltipsManager.HideTooltips();
  }
  protected cb func OnRevisedBackpackItemSelectEvent(evt: ref<RevisedBackpackItemSelectEvent>) -> Bool {
    this.Log(s"Selected \(TDBID.ToStringDEBUG(evt.item.id))");
    this.PlaySound(n"ui_menu_onpress");
    this.m_TooltipsManager.HideTooltips();
    this.DeselectLastHighlightedItem();
    this.UpdateSelectionForDataViewWrappers(false);
    this.UpdateSelectionForVirtualListControllers(false);
    this.HighlightSelectedItem(evt.item);
    this.ShowItemPreview(evt.item);
    this.StoreSelection(evt.item);
  }
  protected cb func OnRevisedItemDisplayClickEvent(evt: ref<RevisedItemDisplayClickEvent>) -> Bool {
    let isUsable: Bool;
    let isHealing: Bool;
    let item: ItemModParams;
    if evt.actionName.IsAction(n"drop_item") {
      if Equals(this.playerState, gamePSMVehicle.Default) && RPGManager.CanItemBeDropped(this.m_player, evt.uiInventoryItem.GetItemData()) && InventoryGPRestrictionHelper.CanDrop(evt.uiInventoryItem, this.m_player) {
        if evt.display.GetIsPlayerFavourite() {
          this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
          return false;
        };
        if this.GetBackpackItemQuantity(evt.uiInventoryItem) > 1 {
          this.OpenQuantityPicker(evt.uiInventoryItem, QuantityPickerActionType.Drop);
        } else {
          this.PlaySound(n"ui_menu_item_droped");
          this.PlayRumble(RumbleStrength.Light, RumbleType.Pulse, RumblePosition.Right);
          item.itemID = evt.uiInventoryItem.ID;
          item.quantity = 1;
          this.AddToDropQueue(item);
          this.RefreshUINextFrame();
        };
      } else {
        this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
      };
    } else {
      if evt.actionName.IsAction(n"revised_use_equip") {
        isUsable = IsDefined(ItemActionsHelper.GetConsumeAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetEatAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetDrinkAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetLearnAction(evt.uiInventoryItem.GetID())) || IsDefined(ItemActionsHelper.GetDownloadFunds(evt.uiInventoryItem.GetID()));
        isHealing = Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_Inhaler) || Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_Injector);
        if isUsable && !isHealing {
          if !InventoryGPRestrictionHelper.CanUse(evt.uiInventoryItem, this.m_player) {
            this.ShowNotification(this.m_player.GetGame(), this.DetermineUIMenuNotificationType());
            return false;
          };
          GameInstance.GetAudioSystem(this.m_player.GetGame()).Play(n"ui_loot_eat_ui");
          this.PlayRumble(RumbleStrength.Light, RumbleType.Pulse, RumblePosition.Right);
          if Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_Skillbook) {
            this.SetWarningMessage(GetLocalizedText("LocKey#46534") + "\\n" + GetLocalizedText(evt.uiInventoryItem.GetDescription()));
          };
          ItemActionsHelper.PerformItemAction(this.m_player, evt.uiInventoryItem.GetID());
          this.m_inventoryManager.MarkToRebuild();
        };
        if Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Con_LongLasting) {
          return false;
        };
        if Equals(evt.uiInventoryItem.GetItemType(), gamedataItemType.Clo_Outfit) {
          if this.m_outfitInCooldown {
            return false;
          };
          if this.ScheduleOutfitCooldownReset() {
            this.SetOutfitCooldown(true);
          };
        };
        if evt.uiInventoryItem.IsEquipped() {
          this.UnequipItem(evt.uiInventoryItem);
        } else {
          this.EquipItem(evt.uiInventoryItem);
        };
      };
    };
  }
  protected cb func OnRevisedItemDisplayPressEvent(evt: ref<RevisedItemDisplayPressEvent>) -> Bool {
    this.m_pressedItemDisplay = evt.display;
  }
  protected cb func OnRevisedItemDisplayHoldEvent(evt: ref<RevisedItemDisplayHoldEvent>) -> Bool {
    let setPlayerFavouriteRequest: ref<UIScriptableSystemSetItemPlayerFavourite>;
    if evt.actionName.IsAction(n"disassemble_item") {
      if RPGManager.CanItemBeDisassembled(this.m_player.GetGame(), evt.uiInventoryItem.GetItemData()) {
        if evt.display.GetIsPlayerFavourite() {
          this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
          return false;
        };
        if this.GetBackpackItemQuantity(evt.uiInventoryItem) > 1 {
          this.OpenQuantityPicker(evt.uiInventoryItem, QuantityPickerActionType.Disassembly);
        } else {
          if evt.uiInventoryItem.IsIconic() && !evt.uiInventoryItem.IsEquipped() {
            this.OpenConfirmationPopup(evt.uiInventoryItem);
          } else {
            ItemActionsHelper.DisassembleItem(this.m_player, evt.uiInventoryItem.GetID());
            this.PlaySound(n"ui_menu_item_disassemble");
            this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
            this.m_TooltipsManager.HideTooltips();
          };
        };
      };
    } else {
      if evt.actionName.IsAction(n"favourite_item") && evt.uiInventoryItem.IsWeapon() && this.m_pressedItemDisplay != null {
        setPlayerFavouriteRequest = new UIScriptableSystemSetItemPlayerFavourite();
        setPlayerFavouriteRequest.itemID = evt.uiInventoryItem.ID;
        setPlayerFavouriteRequest.favourite = !evt.display.GetIsPlayerFavourite();
        this.m_uiScriptableSystem.QueueRequest(setPlayerFavouriteRequest);
        evt.display.SetIsPlayerFavourite(setPlayerFavouriteRequest.favourite);
        this.UpdateFavouriteHint(setPlayerFavouriteRequest.favourite);
        this.m_pressedItemDisplay = null;
        this.PlaySound(n"ui_menu_map_pin_on");
        this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
      };
    };
  }
  protected cb func OnRevisedToggleCustomJunkEvent(evt: ref<RevisedToggleCustomJunkEvent>) -> Bool {
    this.Log("RevisedToggleCustomJunkEvent");
    let data: ref<gameItemData> = evt.itemData;
    let itemId: ItemID = data.GetID();
    let newFlag: Bool = !evt.display.GetIsCustomJunkItem();
    let success: Bool;
    if this.m_system.IsAddedToJunk(itemId) {
      success = this.m_system.RemoveFromJunk(itemId);
    } else {
      success = this.m_system.AddToJunk(itemId);
    };
    if success {
      evt.display.SetIsCustomJunkItem(newFlag);
      this.PlaySound(n"ui_menu_onpress");
    };
  }
  protected cb func OnRevisedToggleQuestTagEvent(evt: ref<RevisedToggleQuestTagEvent>) -> Bool {
    this.Log("OnRevisedToggleQuestTagEvent");
    let data: ref<gameItemData> = evt.itemData;
    let newFlag: Bool = !evt.display.GetIsQuestItem();
    let success: Bool;
    if data.HasTag(n"Quest") {
      success = data.RemoveDynamicTag(n"Quest");
    } else {
      success = data.SetDynamicTag(n"Quest");
    };
    if success {
      evt.display.SetIsQuestItem(newFlag);
      this.PlaySound(n"ui_menu_onpress");
    };
  }
  protected cb func OnRevisedBackpackItemWasHighlightedEvent(evt: ref<RevisedBackpackItemWasHighlightedEvent>) -> Bool {
    this.m_lastHighlightedItem = evt.display;
  }
  private final func ShowItemPreview(item: ref<RevisedItemWrapper>) -> Void {
    let isGarment: Bool = item.inventoryItem.IsClothing();
    inkWidgetRef.SetVisible(this.m_previewGarmentContainer, isGarment);
    inkWidgetRef.SetVisible(this.m_previewItemContainer, !isGarment);
    this.QueueEvent(RevisedItemPreviewEvent.Create(item.data.GetID(), isGarment));
  }
  private final func InvalidateItemTooltipEvent() -> Void {
    if this.m_lastItemHoverOverEvent != null {
      this.OnRevisedBackpackItemHoverOverEvent(this.m_lastItemHoverOverEvent);
    };
  }
  private final func DetermineUIMenuNotificationType() -> UIMenuNotificationType {
    let inCombat: Bool = false;
    let psmBlackboard: ref<IBlackboard> = this.m_player.GetPlayerStateMachineBlackboard();
    inCombat = psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == 1;
    if inCombat {
      return UIMenuNotificationType.InCombat;
    };
    return UIMenuNotificationType.InventoryActionBlocked;
  }
  private final func OpenConfirmationPopup(inventoryItem: wref<UIInventoryItem>) -> Void {
    let data: ref<VendorConfirmationPopupData> = new VendorConfirmationPopupData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\vendor_confirmation.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.inventoryItem = inventoryItem;
    data.quantity = inventoryItem.GetQuantity();
    data.type = VendorConfirmationPopupType.DisassembeIconic;
    this.m_confirmationPopupToken = this.ShowGameNotification(data);
    this.m_confirmationPopupToken.RegisterListener(this, n"OnConfirmationPopupClosed");
    this.m_buttonHintsController.Hide();
  }
  protected cb func OnConfirmationPopupClosed(data: ref<inkGameNotificationData>) -> Bool {
    let itemID: ItemID;
    this.m_confirmationPopupToken = null;
    let resultData: ref<VendorConfirmationPopupCloseData> = data as VendorConfirmationPopupCloseData;
    if resultData.confirm {
      if IsDefined(resultData.inventoryItem) {
        itemID = resultData.inventoryItem.GetID();
      } else {
        itemID = InventoryItemData.GetID(resultData.itemData);
      };
      ItemActionsHelper.DisassembleItem(this.m_player, itemID);
      this.PlaySound(n"ui_menu_item_disassemble");
    };
    this.m_buttonHintsController.Show();
  }
  private final func OpenQuantityPicker(itemData: wref<UIInventoryItem>, actionType: QuantityPickerActionType) -> Void {
    let dropItem: ItemModParams = this.GetDropQueueItem(itemData.GetID());
    let data: ref<QuantityPickerPopupData> = new QuantityPickerPopupData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\item_quantity_picker.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.maxValue = itemData.GetQuantity(true);
    if ItemID.IsValid(dropItem.itemID) {
      data.maxValue -= dropItem.quantity;
    };
    data.inventoryItem = itemData;
    data.actionType = actionType;
    this.m_quantityPickerPopupToken = this.ShowGameNotification(data);
    this.m_quantityPickerPopupToken.RegisterListener(this, n"OnQuantityPickerPopupClosed");
    this.m_buttonHintsController.Hide();
  }
  protected cb func OnQuantityPickerPopupClosed(data: ref<inkGameNotificationData>) -> Bool {
    this.m_quantityPickerPopupToken = null;
    let quantityData: ref<QuantityPickerPopupCloseData> = data as QuantityPickerPopupCloseData;
    if quantityData.choosenQuantity != -1 {
      switch quantityData.actionType {
        case QuantityPickerActionType.Drop:
          this.OnQuantityPickerDrop(quantityData);
          break;
        case QuantityPickerActionType.Disassembly:
          this.OnQuantityPickerDisassembly(quantityData);
      };
    };
    this.m_buttonHintsController.Show();
  }
  public final func OnQuantityPickerDrop(data: ref<QuantityPickerPopupCloseData>) -> Void {
    let item: ItemModParams;
    this.PlaySound(n"ui_menu_item_droped");
    this.PlayRumble(RumbleStrength.Light, RumbleType.Pulse, RumblePosition.Right);
    if IsDefined(data.inventoryItem) {
      item.itemID = data.inventoryItem.GetID();
    } else {
      item.itemID = InventoryItemData.GetID(data.itemData);
    };
    item.quantity = data.choosenQuantity;
    this.AddToDropQueue(item);
    this.RefreshUINextFrame();
  }
  public final func OnQuantityPickerDisassembly(data: ref<QuantityPickerPopupCloseData>) -> Void {
    let itemID: ItemID = IsDefined(data.inventoryItem) ? data.inventoryItem.GetID() : InventoryItemData.GetID(data.itemData);
    ItemActionsHelper.DisassembleItem(this.m_player, itemID, data.choosenQuantity);
    this.PlaySound(n"ui_menu_item_disassemble");
    this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
    this.m_TooltipsManager.HideTooltips();
  }
  public final func IsEquippable(itemData: ref<gameItemData>) -> Bool {
    return EquipmentSystem.GetInstance(this.m_player).GetPlayerData(this.m_player).IsEquippable(itemData);
  }
  private final func ScheduleOutfitCooldownReset() -> Bool {
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.m_player.GetGame());
    let callback: ref<RevisedBackpackOutfitCooldownResetCallback> = new RevisedBackpackOutfitCooldownResetCallback();
    callback.m_controller = this;
    if IsDefined(delaySystem) && !this.m_outfitInCooldown {
      delaySystem.CancelCallback(this.m_delayedOutfitCooldownResetCallbackId);
      this.m_delayedOutfitCooldownResetCallbackId = delaySystem.DelayCallback(callback, this.m_outfitCooldownPeroid, false);
      return GetInvalidDelayID() != this.m_delayedOutfitCooldownResetCallbackId;
    };
    return false;
  }
  public final func SetOutfitCooldown(inCooldown: Bool) -> Void {
    this.m_outfitInCooldown = inCooldown;
  }
  public final func EquipItem(itemData: wref<UIInventoryItem>) -> Void {
    let data: ref<gameItemData> = itemData.GetItemData();
    if this.IsEquippable(data) && !data.HasTag(n"Cyberware") {
      if !InventoryGPRestrictionHelper.CanUse(itemData, this.m_player) {
        this.ShowNotification(this.m_player.GetGame(), UIMenuNotificationType.InventoryActionBlocked);
        return;
      };
      if Equals(itemData.GetEquipmentArea(), gamedataEquipmentArea.Weapon) {
        this.OpenBackpackEquipSlotChooser(itemData);
        return;
      };
      this.m_equipRequested = true;
      this.m_inventoryManager.EquipItem(itemData.ID, 0);
    };
    this.RefreshUINextFrame();
  }
  public final func UnequipItem(itemData: wref<UIInventoryItem>) -> Void {
    let data: ref<gameItemData> = itemData.GetItemData();
    let unequipBlocked: Bool = data.HasTag(n"UnequipBlocked");
    if unequipBlocked || data.HasTag(n"Cyberware") {
      return ;
    };
    let area: gamedataEquipmentArea = itemData.GetEquipmentArea();
    let slotIndex: Int32 = this.m_inventoryManager.GetItemSlotIndexRev(this.m_player, data.GetID());
    this.m_inventoryManager.UnequipItem(area, slotIndex);
    this.RefreshUINextFrame();
  }
  private final func ShowNotification(gameInstance: GameInstance, type: UIMenuNotificationType) -> Void {
    let inventoryNotification: ref<UIMenuNotificationEvent> = new UIMenuNotificationEvent();
    inventoryNotification.m_notificationType = type;
    GameInstance.GetUISystem(gameInstance).QueueEvent(inventoryNotification);
  }
  public final func OpenBackpackEquipSlotChooser(itemData: wref<UIInventoryItem>) -> Void {
    let data: ref<BackpackEquipSlotChooserData> = new BackpackEquipSlotChooserData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\backpack_equip_notification.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.item = itemData;
    data.inventoryScriptableSystem = this.m_uiInventorySystem;
    this.m_equipSlotChooserPopupToken = this.ShowGameNotification(data);
    this.m_equipSlotChooserPopupToken.RegisterListener(this, n"OnBackpacEquipSlotChooserClosed");
    this.m_buttonHintsController.Hide();
  }
  protected cb func OnBackpacEquipSlotChooserClosed(data: ref<inkGameNotificationData>) -> Bool {
    let i: Int32;
    this.m_equipSlotChooserPopupToken = null;
    let slotChooserData: ref<BackpackEquipSlotChooserCloseData> = data as BackpackEquipSlotChooserCloseData;
    if slotChooserData.confirm {
      this.m_equipRequested = true;
      if Equals(slotChooserData.itemData.GetEquipmentArea(), gamedataEquipmentArea.Weapon) {
        i = 0;
        while i < 3 {
          if slotChooserData.itemData.ID == this.m_inventoryManager.GetEquippedItemIdInArea(gamedataEquipmentArea.Weapon, i) {
            this.m_inventoryManager.UnequipItem(gamedataEquipmentArea.Weapon, i, true);
          };
          i += 1;
        };
      };
      this.m_inventoryManager.EquipItem(slotChooserData.itemData.ID, slotChooserData.slotIndex);
      this.PlaySound(n"ui_menu_onpress");
    };
    this.m_buttonHintsController.Show();
  }
  private final func OnInventoryRequestTooltip(itemData: wref<UIInventoryItem>, widget: wref<inkWidget>) -> Void {
    let placement: gameuiETooltipPlacement = gameuiETooltipPlacement.RightTop;
    let margin: inkMargin = new inkMargin(0.0, 0.0, 0.0, 0.0);
    let itemToCompare: wref<UIInventoryItem>;
    let itemTooltipData: ref<UIInventoryItemTooltipWrapper>;
    let itemTooltips: [CName; 2];
    let tooltipsData: array<ref<ATooltipData>>;
    if itemData.IsWeapon() {
      itemTooltips[0] = n"newItemTooltip";
      itemTooltips[1] = n"newItemTooltipComparision";
    } else {
      itemTooltips[0] = n"itemTooltip";
      itemTooltips[1] = n"itemTooltipComparision";
    };
    if IsDefined(itemData) {
      if Equals(itemData.GetItemType(), gamedataItemType.Prt_Program) {
        itemTooltipData = UIInventoryItemTooltipWrapper.Make(itemData, this.m_itemDisplayContext);
        this.m_TooltipsManager.ShowTooltipAtWidget(n"programTooltip", widget, itemTooltipData, placement, true, margin);
        return;
      };
      if !itemData.IsEquipped() && !this.m_isComparisonDisabled {
        itemToCompare = this.m_comparisonResolver.GetPreferredComparisonItem(itemData);
      };
      if !this.m_isComparisonDisabled && itemToCompare != null {
        this.m_inventoryManager.PushIdentifiedComparisonTooltipsData(tooltipsData, itemTooltips[0], itemTooltips[1], itemData, itemToCompare, this.m_itemDisplayContext, this.m_comparedItemDisplayContext);
        this.m_TooltipsManager.ShowTooltipsAtWidget(tooltipsData, widget);
      } else {
        itemData.GetStatsManager().FlushComparedBars();
        itemTooltipData = UIInventoryItemTooltipWrapper.Make(itemData, this.m_itemDisplayContext);
        this.m_TooltipsManager.ShowTooltipAtWidget(itemTooltips[0], widget, itemTooltipData, placement, true, margin);
      };
    };
  }
  private final func SetWarningMessage(const message: script_ref<String>) -> Void {
    let warningMsg: SimpleScreenMessage;
    warningMsg.isShown = true;
    warningMsg.duration = 5.0;
    warningMsg.message = Deref(message);
    GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.WarningMessage, ToVariant(warningMsg), true);
  }
  private final func ShowButtonHints(item: ref<RevisedItemWrapper>) -> Void {
    let data: ref<gameItemData> = item.data;
    let unequipBlocked: Bool = data.HasTag(n"UnequipBlocked");
    let itemID: ItemID = data.GetID();
    let isLearnble: Bool = IsDefined(ItemActionsHelper.GetLearnAction(itemID));
    let isUsable: Bool = IsDefined(ItemActionsHelper.GetConsumeAction(itemID)) || IsDefined(ItemActionsHelper.GetEatAction(itemID)) || IsDefined(ItemActionsHelper.GetDrinkAction(itemID));
    let isGrenade: Bool = Equals(item.type, gamedataItemType.Gad_Grenade);
    let isHealing: Bool = Equals(item.type, gamedataItemType.Con_Inhaler) || Equals(item.type, gamedataItemType.Con_Injector);
    let isEquipable: Bool = RevisedBackpackUtils.IsEquippable(item, this.m_player);
    this.m_cursorData = new MenuCursorUserData();
    this.m_cursorData.SetAnimationOverride(n"hoverOnHoldToComplete");
    // Select
    this.m_buttonHintsController.AddButtonHint(n"select", GetLocalizedText("UI-UserActions-ItemPreview"));
    // use - equip - consume - learn
    if isUsable {
      this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Use"));
    } else {
      if isLearnble {
        this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("Gameplay-Devices-Interactions-Learn"));
      } else {
        if RPGManager.HasDownloadFundsAction(itemID) && RPGManager.CanDownloadFunds(this.m_player.GetGame(), itemID) {
          this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("LocKey#23401"));
        } else {
          if isEquipable || isGrenade {
            if item.inventoryItem.IsEquipped() && !item.inventoryItem.IsQuestItem() {
              if !unequipBlocked && !isGrenade && !isHealing {
                this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Unequip"));
              };
            } else {
              this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Equip"));
            };
          } else {
            this.m_buttonHintsController.RemoveButtonHint(n"revised_use_equip");
          };
        };
      };
    };
    if Equals(item.type, gamedataItemType.Con_Inhaler) || Equals(item.type, gamedataItemType.Con_Injector) {
      this.m_buttonHintsController.AddButtonHint(n"revised_use_equip", GetLocalizedText("UI-UserActions-Equip"));
    };
    // Disassemble
    if RPGManager.CanItemBeDisassembled(this.m_player.GetGame(), data.GetID()) && !item.inventoryItem.IsEquipped() && !data.HasTag(n"UnequipBlocked") {
      this.m_buttonHintsController.AddButtonHint(n"disassemble_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("Gameplay-Devices-DisplayNames-DisassemblableItem"));
      this.m_cursorData.AddAction(n"disassemble_item");
    } else {
      this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
    };
    // Drop
    if !item.inventoryItem.IsEquipped() && RPGManager.CanItemBeDropped(this.m_player, data) && IsDefined(ItemActionsHelper.GetDropAction(data.GetID())) && !data.HasTag(n"UnequipBlocked") && !data.HasTag(n"Quest") {
      if Equals(this.playerState, gamePSMVehicle.Default) {
        this.m_buttonHintsController.AddButtonHint(n"drop_item", GetLocalizedText("UI-ScriptExports-Drop0"));
      } else {
        this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
      };
    };
    // Favorite
    if item.inventoryItem.IsWeapon() {
      this.UpdateFavouriteHint(this.m_uiScriptableSystem.IsItemPlayerFavourite(data.GetID()));
    };
    if this.m_cursorData.GetActionsListSize() >= 0 {
      this.SetCursorContext(n"Hover", this.m_cursorData);
    } else {
      this.SetCursorContext(n"Hover");
    };
  }
  private final func UpdateFavouriteHint(state: Bool) -> Void {
    if state {
      this.m_buttonHintsController.AddButtonHint(n"favourite_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("UI-UserActions-ItemRemoveFavourite"));
      this.m_cursorData.AddUniqueAction(n"favourite_item");
    } else {
      this.m_buttonHintsController.AddButtonHint(n"favourite_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("UI-UserActions-ItemAddFavourite"));
      this.m_cursorData.AddUniqueAction(n"favourite_item");
    };
    if this.m_cursorData.GetActionsListSize() >= 0 {
      this.SetCursorContext(n"Hover", this.m_cursorData);
    } else {
      this.SetCursorContext(n"Hover");
    };
  }
  private final func HiteButtonHints() -> Void {
    this.m_buttonHintsController.RemoveButtonHint(n"select");
    this.m_buttonHintsController.RemoveButtonHint(n"revised_use_equip");
    this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
    this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
    this.m_buttonHintsController.RemoveButtonHint(n"favourite_item");
    this.SetCursorContext(n"Default");
  }
  private final func SpawnPreviews() -> Void {
    this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_previewGarmentContainer), 
      r"base\\gameplay\\gui\\fullscreen\\previews\\revised_garment_item_preview.inkwidget", 
      n"Root:RevisedBackpack.RevisedPreviewGarmentController"
    );
    this.SpawnFromExternal(
      inkWidgetRef.Get(this.m_previewItemContainer), 
      r"base\\gameplay\\gui\\fullscreen\\previews\\revised_item_preview.inkwidget", 
      n"Root:RevisedBackpack.RevisedPreviewItemController"
    );
    this.Log(s"SpawnPreviews");
  }
  private final func PopulateCategories() -> Void {
    let container: ref<inkCompoundWidget> = inkWidgetRef.Get(this.m_categoriesContainer) as inkCompoundWidget;
    this.Log(s"Categories container defined: \(IsDefined(container)), categories: \(ArraySize(this.m_availableCategories))");
    for category in this.m_availableCategories {
      let component: ref<RevisedCategoryComponent> = new RevisedCategoryComponent();
      component.Reparent(container);
      component.SetData(category);
    };
    if NotEquals(ArraySize(this.m_availableCategories), 0) {
      this.QueueEvent(RevisedCategorySelectedEvent.Create(this.m_availableCategories[0]));
    };
  }
  private final func BuildWrappedItem(uiInventoryItem: ref<UIInventoryItem>) -> ref<RevisedItemWrapper> {
    let statsManager: ref<UIInventoryItemStatsManager> = uiInventoryItem.GetStatsManager();
    let data: ref<gameItemData> = uiInventoryItem.GetRealItemData();
    let equipArea: gamedataEquipmentArea = uiInventoryItem.GetEquipmentArea();
    let itemRecord: ref<Item_Record> = uiInventoryItem.GetItemRecord();
    let itemType: gamedataItemType = itemRecord.ItemType().Type();
    let itemEvolution: gamedataWeaponEvolution = gamedataWeaponEvolution.Invalid;
    if uiInventoryItem.IsWeapon() {
      itemEvolution = uiInventoryItem.GetWeaponEvolution();
    };
    let dps: Float = 0.0;
    let stat: wref<UIInventoryItemStat> = uiInventoryItem.GetPrimaryStat();
    if uiInventoryItem.IsWeapon() && Equals(stat.Type, gamedataStatType.EffectiveDPS) {
      dps = stat.Value;
    };
    let effectiveRangeStat: ref<UIInventoryItemStat>;
    let effectiveRange: Int32 = 0;
    if uiInventoryItem.IsWeapon() {
      effectiveRangeStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveRange);
      effectiveRange = Cast<Int32>(effectiveRangeStat.Value);
    };
    let itemId: ItemID = data.GetID();
    let itemTdbid: TweakDBID = itemRecord.GetID();
    let tier: gamedataQuality = uiInventoryItem.GetQuality();
    let price: Float = uiInventoryItem.GetSellPrice();
    let weight: Float = uiInventoryItem.GetWeight();
    let wrappedItem: ref<RevisedItemWrapper> = new RevisedItemWrapper();
    wrappedItem.id = itemTdbid;
    wrappedItem.data = data;
    wrappedItem.inventoryItem = uiInventoryItem;
    wrappedItem.equipArea = equipArea;
    wrappedItem.type = itemType;
    wrappedItem.typeLabel = this.BuildTypeLabel(data, equipArea, itemTdbid, itemType, itemEvolution);
    wrappedItem.typeValue = ItemCompareBuilder.GetItemTypeOrder(data, equipArea, itemType);
    wrappedItem.tier = tier;
    wrappedItem.tierLabel = this.BuildTierLabel(uiInventoryItem);
    wrappedItem.tierValue = this.BuildTierValue(uiInventoryItem);
    wrappedItem.evolution = itemEvolution;
    wrappedItem.nameLabel = GetLocalizedTextByKey(itemRecord.DisplayName());
    wrappedItem.price = price;
    wrappedItem.priceLabel = IntToString(RoundF(price));
    wrappedItem.weight = weight;
    wrappedItem.weightLabel = FloatToStringPrec(weight, 1);
    wrappedItem.dps = dps;
    wrappedItem.dpsLabel = FloatToStringPrec(dps, 1);
    wrappedItem.range = effectiveRange;
    wrappedItem.rangeLabel = IntToString(effectiveRange);
    wrappedItem.isQuest = uiInventoryItem.IsQuestItem() || data.HasTag(n"Quest");
    wrappedItem.isNew = uiInventoryItem.IsNew();
    wrappedItem.isFavorite = uiInventoryItem.IsPlayerFavourite();
    wrappedItem.isDlcAddedItem = data.HasTag(n"DLCAdded") && this.m_uiScriptableSystem.IsDLCAddedActiveItem(itemTdbid);
    wrappedItem.isWeapon = uiInventoryItem.IsWeapon();
    wrappedItem.selected = false;
    wrappedItem.customJunk = this.m_system.IsAddedToJunk(itemId);
    wrappedItem.questTagToggleable = RevisedBackpackUtils.CanToggleQuestTag(data);
    wrappedItem.customJunkToggleable = RevisedBackpackUtils.CanToggleCustomJunk(uiInventoryItem);
    return wrappedItem;
  }
  private final func BuildTypeLabel(data: ref<gameItemData>, equipArea: gamedataEquipmentArea, id: TweakDBID, type: gamedataItemType, evolution: gamedataWeaponEvolution) -> String {
    let typeLabel: String = GetLocalizedText(UIItemsHelper.GetItemTypeKey(data, equipArea, id, type, evolution));
    let currentLength: Int32 = StrLen(typeLabel);
    let maxLength: Int32 = 22;
    if currentLength <= maxLength {
      return typeLabel;
    }
    let shortened: String = UTF8StrLeft(typeLabel, maxLength);
    let suffix: String = "(...)";
    return s"\(shortened)\(suffix)";
  }
  private final func BuildTierLabel(inventoryItem: ref<UIInventoryItem>) -> String {
    let quality: gamedataQuality = inventoryItem.GetQuality();
    let qualityText: String;
    switch quality {
      case gamedataQuality.Common:
      case gamedataQuality.CommonPlus:
        qualityText = "1";
        break;
      case gamedataQuality.Uncommon:
      case gamedataQuality.UncommonPlus:
        qualityText = "2";
        break;
      case gamedataQuality.Rare:
      case gamedataQuality.RarePlus:
        qualityText = "3";
        break;
      case gamedataQuality.Epic:
      case gamedataQuality.EpicPlus:
        qualityText = "4";
        break;
      case gamedataQuality.Legendary:
      case gamedataQuality.LegendaryPlus:
      case gamedataQuality.LegendaryPlusPlus:
        qualityText = "5";
        break;
    };
    let plus: Int32 = Cast<Int32>(inventoryItem.GetItemPlus());
    if !inventoryItem.IsProgram() {
      if plus >= 2 {
        qualityText += "++";
      } else {
        if plus >= 1 {
          qualityText += "+";
        };
      };
    };
    return qualityText;
  }
  private final func BuildTierValue(inventoryItem: ref<UIInventoryItem>) -> Int32 {
    let quality: gamedataQuality = inventoryItem.GetQuality();
    let qualityValue: Int32;
    switch quality {
      case gamedataQuality.Common:
      case gamedataQuality.CommonPlus:
        qualityValue = 10;
        break;
      case gamedataQuality.Uncommon:
      case gamedataQuality.UncommonPlus:
        qualityValue = 20;
        break;
      case gamedataQuality.Rare:
      case gamedataQuality.RarePlus:
        qualityValue = 30;
        break;
      case gamedataQuality.Epic:
      case gamedataQuality.EpicPlus:
        qualityValue = 40;
        break;
      case gamedataQuality.Legendary:
      case gamedataQuality.LegendaryPlus:
      case gamedataQuality.LegendaryPlusPlus:
        qualityValue = 50;
        break;
    };
    let plus: Int32 = Cast<Int32>(inventoryItem.GetItemPlus());
    if !inventoryItem.IsProgram() {
      if plus >= 2 {
        qualityValue += 2;
      } else {
        if plus >= 1 {
          qualityValue += 1;
        };
      };
    };
    return qualityValue;
  }
  private final func AnimateIndicatorTranslation(index: Int32) -> Void {
    let newTranslation: Float = Cast<Float>(index) * 100.0;
    let translationsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(0.25);
    translationInterpolator.SetStartDelay(0.0);
    translationInterpolator.SetType(inkanimInterpolationType.Quartic);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(inkWidgetRef.GetTranslation(this.m_categoryIndicator));
    translationInterpolator.SetEndTranslation(new Vector2(newTranslation, 0.0));
    translationsAnimDef.AddInterpolator(translationInterpolator);
    inkWidgetRef.PlayAnimation(this.m_categoryIndicator, translationsAnimDef);
  }
  private final func ShowColumnNameTooltip(target: ref<inkWidget>, message: String) -> Void {
    let tooltipData: ref<MessageTooltipData> = new MessageTooltipData();
    tooltipData.Title = message;
    this.m_TooltipsManager.ShowTooltipAtWidget(0, target, tooltipData, gameuiETooltipPlacement.LeftTop, true, new inkMargin(64.0, -80.0, 0.0, 0.0));
  }
  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(this.m_player, evt);
  }
  private final func UpdateSelectionForAllWrappers(selected: Bool) -> Void {
    let allItems: array<ref<IScriptable>> = this.itemsListDataSource.GetArray();
    let wrapper: ref<RevisedItemWrapper>;
    for item in allItems {
      wrapper = item as RevisedItemWrapper;
      wrapper.SetSelectedFlag(selected);
    };
  }
  private final func UpdateSelectionForDataViewWrappers(selected: Bool) -> Void {
    let dataViewItemsCount: Uint32 = this.itemsListDataView.Size();
    let index: Uint32 = 0u;
    let wrapper: ref<RevisedItemWrapper>; 
    while index < dataViewItemsCount {
      wrapper = this.itemsListDataView.GetItem(index) as RevisedItemWrapper;
      wrapper.SetSelectedFlag(selected);
      index += 1u;
    };
    this.Log(s"UpdateSelectionForDataViewWrappers for \(dataViewItemsCount) items: \(selected)");
  }
  private final func UpdateSelectionForVirtualListControllers(selected: Bool) -> Void {
    let listRoot: ref<inkCompoundWidget> = this.itemsListController.GetRootCompoundWidget();
    let itemsCount: Int32 = listRoot.GetNumChildren();
    let controller: ref<RevisedBackpackItemController>;
    let childIndex: Int32 = 0;
    while childIndex < itemsCount {
      controller = listRoot.GetWidgetByIndex(childIndex).GetController() as RevisedBackpackItemController;
      if IsDefined(controller) {
        controller.SetSelection(selected);
      };
      childIndex += 1;
    };
    this.Log(s"UpdateSelectionForVirtualListControllers for \(itemsCount) controllers: \(selected)");
  }
  private final func DeselectLastHighlightedItem() -> Void {
    if IsDefined(this.m_lastHighlightedItem) {
      this.m_lastHighlightedItem.SetSelection(false);
      this.m_lastHighlightedItem = null;
    };
  }
  private final func HighlightSelectedItem(item: ref<RevisedItemWrapper>) -> Void {
    let itemId: ItemID = item.data.GetID();
    this.QueueEvent(RevisedBackpackItemHighlightEvent.Create(itemId, true));
  }
  private final func StoreSelection(item: ref<RevisedItemWrapper>) -> Void {
    ArrayClear(this.m_selectedItems);
    ArrayPush(this.m_selectedItems, item);
    this.UpdateSelectedItemsCounter();
  }
  private final func StoreSelection(items: array<ref<RevisedItemWrapper>>) -> Void {
    ArrayClear(this.m_selectedItems);
    this.m_selectedItems = items;
    this.UpdateSelectedItemsCounter();
  }
  private final func ClearStoredSelection() -> Void {
    ArrayClear(this.m_selectedItems);
    this.UpdateSelectedItemsCounter();
  }
  private final func UpdateSelectedItemsCounter() -> Void {
    let count: Int32 = ArraySize(this.m_selectedItems);
    inkTextRef.SetText(this.m_selectedItemsCount, s"\(GetLocalizedTextByKey(n"Mod-Revised-Select-Label")) \(count)");
    this.QueueEvent(RevisedBackpackSelectedItemsCountChangedEvent.Create(count));
  }
  private final func AnimateTranslationAndOpacity(start: Vector2, end: Vector2, duration: Float, delay: Float) -> ref<inkAnimDef> {
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Quintic);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(0.0);
    transparencyInterpolator.SetEndTransparency(1.0);
    let translationInterpolator: ref<inkAnimTranslation> = new inkAnimTranslation();
    translationInterpolator.SetDuration(duration);
    translationInterpolator.SetStartDelay(delay);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(start);
    translationInterpolator.SetEndTranslation(end);
    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    moveElementsAnimDef.AddInterpolator(translationInterpolator);
    return moveElementsAnimDef;
  }
  private final func AnimateOpacity(duration: Float, delay: Float) -> ref<inkAnimDef> {
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(delay);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(0.0);
    transparencyInterpolator.SetEndTransparency(1.0);
    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    return moveElementsAnimDef;
  }
  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedController", str);
    };
  }
}
public class RevisedBackpackDataView extends ScriptableDataView {
  private let m_uiScriptableSystem: wref<UIScriptableSystem>;
  private let m_selectedCategory: ref<RevisedBackpackCategory>;
  private let m_sorting: revisedSorting;
  private let m_sortingMode: revisedSortingMode;
  private let m_filtering: ref<RevisedFilteringEvent>;
  private let m_newItemsOnTop: Bool;
  private let m_favoriteItemsOnTop: Bool;
  private let m_skipCustomFilters: Bool;
  public final func Init() -> Void {
    let settings: ref<RevisedBackpackSettings> = new RevisedBackpackSettings();
    this.m_newItemsOnTop = settings.newOnTop;
    this.m_favoriteItemsOnTop = settings.favoriteOnTop;
    this.m_skipCustomFilters = true;
  }
  public final func BindUIScriptableSystem(uiScriptableSystem: wref<UIScriptableSystem>) -> Void {
    this.m_uiScriptableSystem = uiScriptableSystem;
    this.m_sorting = revisedSorting.None;
    this.m_sortingMode = revisedSortingMode.None;
  }
  public final func UpdateView() {
    this.EnableSorting();
    this.Sort();
    this.DisableSorting();
  }
  public final func SetSortMode(sorting: revisedSorting, mode: revisedSortingMode) -> Void {
    this.m_sorting = sorting;
    this.m_sortingMode = mode;
    this.RefreshList();
  }
  protected func PreSortingInjection(builder: ref<RevisedCompareBuilder>) -> ref<RevisedCompareBuilder> {
    return builder;
  }
  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftItem: ref<RevisedItemWrapper> = left as RevisedItemWrapper;
    let rightItem: ref<RevisedItemWrapper> = right as RevisedItemWrapper;
    switch this.m_sorting {
      case revisedSorting.Name:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().NameDesc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NameDesc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().NameDesc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NameDesc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.Type:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().TypeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().TypeAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().TypeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).TypeAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().TypeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().TypeDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().TypeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).TypeDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.Tier:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QualityAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QualityAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QualityAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QualityAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QualityDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QualityDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QualityDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QualityDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.Price:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().PriceAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().PriceAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().PriceAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).PriceAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().PriceDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().PriceDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().PriceDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).PriceDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.Weight:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().WeightAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().WeightAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().WeightAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).WeightAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().WeightDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().WeightDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().WeightDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).WeightDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.Dps:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().DpsAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().DpsAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().DpsAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).DpsAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().DpsDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().DpsDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().DpsDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).DpsDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.Range:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().RangeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().RangeAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().RangeAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).RangeAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().RangeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().RangeDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().RangeDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).RangeDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.Quest:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QuestAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QuestAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QuestAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QuestAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QuestDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QuestDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QuestDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QuestDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
      case revisedSorting.CustomJunk:
        if Equals(this.m_sortingMode, revisedSortingMode.Asc) {           // Asc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).CustomJunkAsc().NameAsc().QualityDesc().GetBool();
          };
        } else if Equals(this.m_sortingMode, revisedSortingMode.Desc) {   // Desc
          if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          } else if !this.m_newItemsOnTop && !this.m_favoriteItemsOnTop { // Nothing on top
            return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).CustomJunkDesc().NameAsc().QualityDesc().GetBool();
          };
        };
        break;
    };
    // By default
    if this.m_newItemsOnTop && !this.m_favoriteItemsOnTop {         // New on top
      return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).NewItem().QualityDesc().TypeAsc().NameAsc().GetBool();
    } else if !this.m_newItemsOnTop && this.m_favoriteItemsOnTop {  // Favorite on top
      return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().QualityDesc().TypeAsc().NameAsc().GetBool();
    } else if this.m_newItemsOnTop && this.m_favoriteItemsOnTop {   // New and favorite on top
      return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).FavouriteItem().NewItem().QualityDesc().TypeAsc().NameAsc().GetBool();
    };
    // Nothing on top
    return this.PreSortingInjection(RevisedCompareBuilder.Make(leftItem, rightItem)).QualityDesc().TypeAsc().NameAsc().GetBool();
  }
  public final func SetCategory(category: ref<RevisedBackpackCategory>) -> Void {
    if NotEquals(this.m_selectedCategory, category) {
      this.m_selectedCategory = category;
      this.Filter();
    };
  }
  public final func SetFilters(event: ref<RevisedFilteringEvent>) -> Void {
    this.m_skipCustomFilters = event.filtersReset;
    this.m_filtering = event;
    this.Log(s"SetFilters with [\(event.nameQuery)] and [\(event.typeQuery)]");
    this.Filter();
  }
  public func FilterItem(data: ref<IScriptable>) -> Bool {
    let itemWrapper: ref<RevisedItemWrapper> = data as RevisedItemWrapper;
    let name: String = itemWrapper.nameLabel;
    let nameNotEmpty: Bool = NotEquals(name, "");
    let predicate: Bool = this.m_selectedCategory.predicate.Check(itemWrapper);
    if this.m_skipCustomFilters {
      return nameNotEmpty && predicate;
    };
    let nameSearchMatched: Bool = true;
    if NotEquals(this.m_filtering.nameQuery, "") {
      nameSearchMatched = this.ItemTextsContainQuery(itemWrapper, this.m_filtering.nameQuery);
    };
    let typeSearchMatched: Bool = true;
    if NotEquals(this.m_filtering.typeQuery, "") {
      typeSearchMatched = this.ItemTypeContainsQuery(itemWrapper, this.m_filtering.typeQuery);
    };
    let tierMatched: Bool = ArrayContains(this.m_filtering.tiers, itemWrapper.tier);
    return nameNotEmpty && predicate && nameSearchMatched && typeSearchMatched && tierMatched;
  }
  private final func RefreshList() -> Void {
    let wasSortingEnabled: Bool = this.IsSortingEnabled();
    if !wasSortingEnabled {
      this.UpdateView();
    } else {
      this.Sort();
    };
  }
  private final func ItemTextsContainQuery(item: ref<RevisedItemWrapper>, query: String) -> Bool {
    let combined: String = "";
    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(item.id);
    let weaponRecord: ref<WeaponItem_Record>;
    // Name
    let itemName: String = UTF8StrLower(GetLocalizedTextByKey(itemRecord.DisplayName()));
    combined += itemName;
    // Weapon evolution
    let evolution: String;
    if CraftingMainLogicController.IsWeapon(itemRecord.EquipArea().Type()) {
      weaponRecord = itemRecord as WeaponItem_Record;
      if IsDefined(weaponRecord) {
        evolution = UIItemsHelper.GetItemTypeKey(weaponRecord.ItemType().Type(), weaponRecord.Evolution().Type());
        combined += UTF8StrLower(GetLocalizedText(evolution));
      };
    };
    // Description
    let description: String = UTF8StrLower(GetLocalizedTextByKey(itemRecord.LocalizedDescription()));
    combined += description;
    return StrContains(combined, UTF8StrLower(query));
  }
  private final func ItemTypeContainsQuery(item: ref<RevisedItemWrapper>, query: String) -> Bool {
    let itemTypeString: String = UTF8StrLower(item.typeLabel);
    let substring: String = UTF8StrLower(query);
    this.Log(s"ItemTypeContainsQuery search \(substring) inside \(itemTypeString)");
    return StrContains(itemTypeString, substring);
  }
  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedView", str);
    };
  }
}
public class RevisedBackpackFiltersController extends inkLogicController {
  private let m_player: wref<PlayerPuppet>;
  private let m_delaySystem: wref<DelaySystem>;
  private let m_debounceCalbackId: DelayID;
  private let nameFilterInput: wref<HubTextInput>;
  private let typeFilterInput: wref<HubTextInput>;
  private let checkboxTier1Frame: wref<inkWidget>;
  private let checkboxTier2Frame: wref<inkWidget>;
  private let checkboxTier3Frame: wref<inkWidget>;
  private let checkboxTier4Frame: wref<inkWidget>;
  private let checkboxTier5Frame: wref<inkWidget>;
  private let checkboxTier1Thumb: wref<inkWidget>;
  private let checkboxTier2Thumb: wref<inkWidget>;
  private let checkboxTier3Thumb: wref<inkWidget>;
  private let checkboxTier4Thumb: wref<inkWidget>;
  private let checkboxTier5Thumb: wref<inkWidget>;
  private let buttonsContainer: wref<inkWidget>;
  private let buttonSelect: wref<RevisedFiltersButton>;
  private let buttonJunk: wref<RevisedFiltersButton>;
  private let buttonDisassemble: wref<RevisedFiltersButton>;
  private let buttonReset: wref<RevisedFiltersButton>;
  private let m_animProxy: ref<inkAnimProxy>;
  private let nameInput: String = "";
  private let typeInput: String = "";
  private let tier1Enabled: Bool = true;
  private let tier2Enabled: Bool = true;
  private let tier3Enabled: Bool = true;
  private let tier4Enabled: Bool = true;
  private let tier5Enabled: Bool = true;
  private let resetAvailable: Bool = false;
  private let selectionAvailable: Bool = false;
  private let massActionsAvailable: Bool = false;
  protected cb func OnInitialize() -> Bool {
    this.BuildWidgetsLayout();
    this.RegisterListeners();
    this.m_player = GetPlayer(GetGameInstance());
    this.m_delaySystem = GameInstance.GetDelaySystem(this.m_player.GetGame());
  }
  protected cb func OnUninitialize() -> Bool {
    this.UnregisterListeners();
    this.m_delaySystem.CancelCallback(this.m_debounceCalbackId);
    if IsDefined(this.m_animProxy) {
      if this.m_animProxy.IsPlaying() {
        this.m_animProxy.Stop();
        this.m_animProxy = null;
      };
    }
  }
  private final func RegisterListeners() -> Void {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
  }
  private final func UnregisterListeners() -> Void {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
  }
  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let targetName: CName = target.GetName();
    this.HandleWidgetHoverOver(targetName);
  }
  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    let targetName: CName = target.GetName();
    this.HandleWidgetHoverOut(targetName);
  }
  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget>;
    let targetName: CName;
    if evt.IsAction(n"click") {
      target = evt.GetTarget();
      targetName = target.GetName();
      this.HandleWidgetClick(targetName);
    };
  }
  protected cb func OnNameFilterInput(widget: wref<inkWidget>) {
    this.nameInput = this.nameFilterInput.GetText();
    if StrLen(this.nameInput) > 0 {
      this.ApplyFiltersDelayed();
    } else {
      this.ApplyFilters();
    };
  }
  protected cb func OnTypeFilterInput(widget: wref<inkWidget>) {
    this.typeInput = this.typeFilterInput.GetText();
    if StrLen(this.typeInput) > 0 {
      this.ApplyFiltersDelayed();
    } else {
      this.ApplyFilters();
    };
  }
  protected cb func OnRevisedCategorySelectedEvent(evt: ref<RevisedCategorySelectedEvent>) -> Bool {
    this.selectionAvailable = NotEquals(evt.category.id, 10);
    this.InvalidateMassActionsButtons();
  }
  protected cb func OnRevisedBackpackSelectedItemsCountChangedEvent(evt: ref<RevisedBackpackSelectedItemsCountChangedEvent>) -> Bool {
    this.massActionsAvailable = this.selectionAvailable && evt.count > 0;
    this.InvalidateMassActionsButtons();
  }
  public final func ApplyFiltersDelayed() -> Void {
    let callback: ref<RevisedBackpackFilterDebounceCallback> = new RevisedBackpackFilterDebounceCallback();
    callback.m_controller = this;
    this.m_delaySystem.CancelCallback(this.m_debounceCalbackId);
    this.m_debounceCalbackId = this.m_delaySystem.DelayCallback(callback, 0.2, false);
  }
  public final func ApplyFilters() -> Void {
    this.Log("ApplyFilters");
    this.InvalidateResetButtonState();
    this.BroadcastFiltersState();
  }
  private final func ResetFilters() -> Void {
    this.Log("ResetFilters");
    this.PlaySound(n"ui_menu_onpress");
    this.nameInput = "";
    this.typeInput = "";
    this.tier1Enabled = true;
    this.tier2Enabled = true;
    this.tier3Enabled = true;
    this.tier4Enabled = true;
    this.tier5Enabled = true;
    this.nameFilterInput.SetText(this.nameInput);
    this.typeFilterInput.SetText(this.typeInput);
    this.InvalidateCheckboxes();
    this.InvalidateResetButtonState();
    this.BroadcastFiltersState();
  }
  private final func RunSelectAction() -> Void {
    this.PlaySound(n"ui_menu_onpress");
    this.QueueEvent(RevisedFiltersActionEvent.Create(revisedFiltersAction.Select));
  }
  private final func RunJunkAction() -> Void {
    this.PlaySound(n"ui_menu_onpress");
    this.QueueEvent(RevisedFiltersActionEvent.Create(revisedFiltersAction.Junk));
  }
  private final func RunDisassembleAction() -> Void {
    this.PlaySound(n"ui_menu_onpress");
    this.QueueEvent(RevisedFiltersActionEvent.Create(revisedFiltersAction.Disassemble));
  }
  private final func HandleWidgetClick(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.PlaySound(n"ui_menu_onpress");
        this.tier1Enabled = !this.tier1Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier2":
        this.PlaySound(n"ui_menu_onpress");
        this.tier2Enabled = !this.tier2Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier3":
        this.PlaySound(n"ui_menu_onpress");
        this.tier3Enabled = !this.tier3Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier4":
        this.PlaySound(n"ui_menu_onpress");
        this.tier4Enabled = !this.tier4Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"tier5":
        this.PlaySound(n"ui_menu_onpress");
        this.tier5Enabled = !this.tier5Enabled;
        this.InvalidateCheckboxes();
        this.ApplyFilters();
        break;
      case n"buttonReset":
        if this.resetAvailable {
          this.ResetFilters();
        };
        break;
      case n"buttonSelect":
        if this.selectionAvailable {
          this.RunSelectAction();
        };
        break;
      case n"buttonJunk":
        if this.massActionsAvailable {
          this.RunJunkAction();
        };
        break;
      case n"buttonDisassemble":
        if this.massActionsAvailable {
          this.RunDisassembleAction();
        };
        break;
    };
  };
  private final func HandleWidgetHoverOver(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.checkboxTier1Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier2":
        this.checkboxTier2Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier3":
        this.checkboxTier3Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier4":
        this.checkboxTier4Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
      case n"tier5":
        this.checkboxTier5Frame.BindProperty(n"tintColor", n"MainColors.Red");
        break;
    };
  }
  private final func HandleWidgetHoverOut(name: CName) -> Void {
    switch name {
      case n"tier1":
        this.checkboxTier1Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier2":
        this.checkboxTier2Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier3":
        this.checkboxTier3Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier4":
        this.checkboxTier4Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
      case n"tier5":
        this.checkboxTier5Frame.BindProperty(n"tintColor", n"MainColors.MildRed");
        break;
    };
  }
  private final func InvalidateResetButtonState() -> Void {
    let hasUncheckedCheckboxes: Bool = !this.tier1Enabled || !this.tier2Enabled || !this.tier3Enabled || !this.tier4Enabled || !this.tier5Enabled;
    let inputHasText: Bool = StrLen(this.nameInput) > 0 || StrLen(this.typeInput) > 0;
    this.resetAvailable = hasUncheckedCheckboxes || inputHasText;
    this.buttonReset.SetDisabled(!this.resetAvailable);
  }
  private final func InvalidateMassActionsButtons() -> Void {
    this.UpdateButtonsContainerVisibility();
    this.buttonJunk.SetDisabled(!this.massActionsAvailable);
    this.buttonDisassemble.SetDisabled(!this.massActionsAvailable);
  }
  private final func UpdateButtonsContainerVisibility() -> Void {
    if Equals(this.selectionAvailable, this.buttonsContainer.IsVisible()) {
      return;
    };
    let start: Float;
    let end: Float;
    if this.selectionAvailable {
      start = 0.0;
      end = 1.0;
    } else {
      start = 1.0;
      end = 0.0;
    };
    this.buttonsContainer.SetOpacity(start);
    let container: ref<inkAnimDef> = this.AnimateOpacity(0.2, start, end);
    this.m_animProxy = this.buttonsContainer.PlayAnimation(container);
  }
  private final func InvalidateCheckboxes() -> Void {
    if NotEquals(this.checkboxTier1Thumb.IsVisible(), this.tier1Enabled) {
      this.checkboxTier1Thumb.SetVisible(this.tier1Enabled);
    };
    if NotEquals(this.checkboxTier2Thumb.IsVisible(), this.tier2Enabled) {
      this.checkboxTier2Thumb.SetVisible(this.tier2Enabled);
    };
    if NotEquals(this.checkboxTier3Thumb.IsVisible(), this.tier3Enabled) {
      this.checkboxTier3Thumb.SetVisible(this.tier3Enabled);
    };
    if NotEquals(this.checkboxTier4Thumb.IsVisible(), this.tier4Enabled) {
      this.checkboxTier4Thumb.SetVisible(this.tier4Enabled);
    };
    if NotEquals(this.checkboxTier5Thumb.IsVisible(), this.tier5Enabled) {
      this.checkboxTier5Thumb.SetVisible(this.tier5Enabled);
    };
  }
  private final func BroadcastFiltersState() -> Void {
    let filtersReset: Bool = this.buttonReset.IsDisabled();
    let tiers: array<gamedataQuality>;
    if this.tier5Enabled {
      ArrayPush(tiers, gamedataQuality.LegendaryPlusPlus);
      ArrayPush(tiers, gamedataQuality.LegendaryPlus);
      ArrayPush(tiers, gamedataQuality.Legendary);
    };
    if this.tier4Enabled {
      ArrayPush(tiers, gamedataQuality.EpicPlus);
      ArrayPush(tiers, gamedataQuality.Epic);
    };
    if this.tier3Enabled {
      ArrayPush(tiers, gamedataQuality.RarePlus);
      ArrayPush(tiers, gamedataQuality.Rare);
    };
    if this.tier2Enabled {
      ArrayPush(tiers, gamedataQuality.UncommonPlus);
      ArrayPush(tiers, gamedataQuality.Uncommon);
    };
    if this.tier1Enabled {
      ArrayPush(tiers, gamedataQuality.CommonPlus);
      ArrayPush(tiers, gamedataQuality.Common);
    };
    let event: ref<RevisedFilteringEvent> = RevisedFilteringEvent.Create(this.nameInput, this.typeInput, tiers, filtersReset);
    this.Log(s"BroadcastFiltersState with [\(this.nameInput)] and [\(this.typeInput)]");
    this.QueueEvent(event);
  }
  private final func BuildWidgetsLayout() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let outerContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    outerContainer.SetName(n"outerContainer");
    outerContainer.Reparent(root);
    let leftColumn: ref<inkVerticalPanel> = new inkVerticalPanel();
    leftColumn.SetName(n"leftColumn");
    leftColumn.SetMargin(new inkMargin(0.0, 0.0, 96.0, 0.0));
    leftColumn.Reparent(outerContainer);
    let inputRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    inputRow.SetName(n"inputRow");
    inputRow.SetMargin(new inkMargin(0.0, 0.0, 0.0, 32.0));
    inputRow.SetChildMargin(new inkMargin(0.0, 0.0, 16.0, 0.0));
    inputRow.Reparent(leftColumn);
    let nameFilterInput: ref<HubTextInput> = HubTextInput.Create();
    nameFilterInput.SetName(n"nameFilterInput");
    nameFilterInput.SetLetterCase(textLetterCase.UpperCase);
    nameFilterInput.SetDefaultText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Input-Name"));
    nameFilterInput.SetWidth(756.0);
    nameFilterInput.RegisterToCallback(n"OnInput", this, n"OnNameFilterInput");
    nameFilterInput.Reparent(inputRow);
    this.nameFilterInput = nameFilterInput;
    let typeFilterInput: ref<HubTextInput> = HubTextInput.Create();
    typeFilterInput.SetName(n"typeFilterInput");
    typeFilterInput.SetLetterCase(textLetterCase.UpperCase);
    typeFilterInput.SetDefaultText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Input-Type"));
    typeFilterInput.SetWidth(402.0);
    typeFilterInput.RegisterToCallback(n"OnInput", this, n"OnTypeFilterInput");
    typeFilterInput.Reparent(inputRow);
    this.typeFilterInput = typeFilterInput;
    let checkboxesRow: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    checkboxesRow.SetName(n"checkboxesRow");
    checkboxesRow.SetMargin(new inkMargin(0.0, 0.0, 0.0, 32.0));
    checkboxesRow.SetChildMargin(new inkMargin(0.0, 0.0, 24.0, 0.0));
    checkboxesRow.Reparent(leftColumn);
    let tier1: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier1", n"Gameplay-RPG-Stats-Tiers-Tier1", this.tier1Enabled);
    let tier2: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier2", n"Gameplay-RPG-Stats-Tiers-Tier2", this.tier2Enabled);
    let tier3: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier3", n"Gameplay-RPG-Stats-Tiers-Tier3", this.tier3Enabled);
    let tier4: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier4", n"Gameplay-RPG-Stats-Tiers-Tier4", this.tier4Enabled);
    let tier5: ref<inkCompoundWidget> = this.BuildCheckbox(n"tier5", n"Gameplay-RPG-Stats-Tiers-Tier5", this.tier5Enabled);
    this.checkboxTier1Frame = tier1.GetWidgetByPathName(n"tier1/frame");
    this.checkboxTier2Frame = tier2.GetWidgetByPathName(n"tier2/frame");
    this.checkboxTier3Frame = tier3.GetWidgetByPathName(n"tier3/frame");
    this.checkboxTier4Frame = tier4.GetWidgetByPathName(n"tier4/frame");
    this.checkboxTier5Frame = tier5.GetWidgetByPathName(n"tier5/frame");
    this.checkboxTier1Thumb = tier1.GetWidgetByPathName(n"tier1/thumb");
    this.checkboxTier2Thumb = tier2.GetWidgetByPathName(n"tier2/thumb");
    this.checkboxTier3Thumb = tier3.GetWidgetByPathName(n"tier3/thumb");
    this.checkboxTier4Thumb = tier4.GetWidgetByPathName(n"tier4/thumb");
    this.checkboxTier5Thumb = tier5.GetWidgetByPathName(n"tier5/thumb");
    tier1.Reparent(checkboxesRow);
    tier2.Reparent(checkboxesRow);
    tier3.Reparent(checkboxesRow);
    tier4.Reparent(checkboxesRow);
    tier5.Reparent(checkboxesRow);
    let buttonReset: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonReset.SetName(n"buttonReset");
    buttonReset.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Reset"));
    buttonReset.SetDisabled(true);
    buttonReset.Reparent(leftColumn);
    this.buttonReset = buttonReset;
    let rightColumn: ref<inkVerticalPanel> = new inkVerticalPanel();
    rightColumn.SetName(n"rightColumn");
    rightColumn.SetOpacity(0.0);
    rightColumn.SetAffectsLayoutWhenHidden(true);
    rightColumn.SetChildMargin(new inkMargin(0.0, 0.0, 0.0, 24.0));
    rightColumn.Reparent(outerContainer);
    this.buttonsContainer = rightColumn;
    let buttonSelect: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonSelect.SetName(n"buttonSelect");
    buttonSelect.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Select"));
    buttonSelect.Reparent(rightColumn);
    this.buttonSelect = buttonSelect;
    let buttonJunk: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonJunk.SetName(n"buttonJunk");
    buttonJunk.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Junk"));
    buttonJunk.SetDisabled(true);
    buttonJunk.Reparent(rightColumn);
    this.buttonJunk = buttonJunk;
    let buttonDisassemble: ref<RevisedFiltersButton> = RevisedFiltersButton.Create();
    buttonDisassemble.SetName(n"buttonDisassemble");
    buttonDisassemble.SetText(GetLocalizedTextByKey(n"Mod-Revised-Filter-Disassemble"));
    buttonDisassemble.SetDisabled(true);
    buttonDisassemble.SetAsDangerous();
    buttonDisassemble.Reparent(rightColumn);
    this.buttonDisassemble = buttonDisassemble;
  }
  private final func BuildCheckbox(name: CName, displayNameKey: CName, initial: Bool) -> ref<inkCompoundWidget> {
    // Common container
    let checkboxContainer: ref<inkHorizontalPanel> = new inkHorizontalPanel();
    checkboxContainer.SetName(name);
    // Checkbox container
    let internalContainer: ref<inkCanvas> = new inkCanvas();
    internalContainer.SetName(name);
    internalContainer.SetSize(64.0, 64.0);
    internalContainer.SetFitToContent(false);
    internalContainer.SetInteractive(true);
    internalContainer.SetChildOrder(inkEChildOrder.Backward);
    internalContainer.SetAnchor(inkEAnchor.CenterLeft);
    internalContainer.SetHAlign(inkEHorizontalAlign.Left);
    internalContainer.SetVAlign(inkEVerticalAlign.Center);
    internalContainer.Reparent(checkboxContainer);
    // Checkbox selector
    let checkbox: ref<inkImage> = new inkImage();
    checkbox.SetName(n"thumb");
    checkbox.SetAnchor(inkEAnchor.Centered);
    checkbox.SetAnchorPoint(0.5, 0.5);
    checkbox.SetMargin(1.0, 1.0, 0.0, 0.0);
    checkbox.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    checkbox.BindProperty(n"tintColor", n"MainColors.Red");
    checkbox.SetSize(38.0, 38.0);
    checkbox.SetOpacity(0.5);
    checkbox.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    checkbox.SetTexturePart(n"color_bg");
    checkbox.SetVisible(initial);
    checkbox.SetNineSliceScale(true);
    checkbox.Reparent(internalContainer);
    // Checkbox frame
    let frame: ref<inkImage> = new inkImage();
    frame.SetName(n"frame");
    frame.SetAnchor(inkEAnchor.Fill);
    frame.SetAnchorPoint(0.5, 0.5);
    frame.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    frame.BindProperty(n"tintColor", n"MainColors.MildRed");
    frame.SetSize(64.0, 64.0);
    frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    frame.SetTexturePart(n"color_fg");
    frame.SetNineSliceScale(true);
    frame.Reparent(internalContainer);
    // Checkbox bg
    let bg: ref<inkImage> = new inkImage();
    bg.SetName(n"background");
    bg.SetAnchor(inkEAnchor.Fill);
    bg.SetAnchorPoint(0.5, 0.5);
    bg.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    bg.BindProperty(n"tintColor", n"MainColors.FaintRed");
    bg.SetSize(64.0, 64.0);
    bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
    bg.SetTexturePart(n"color_bg");
    bg.SetNineSliceScale(true);
    bg.Reparent(internalContainer);
    // Checkbox label
    let label: ref<inkText> = new inkText();
    label.SetName(n"label");
    label.SetText(GetLocalizedTextByKey(displayNameKey));
    label.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));
    label.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    label.SetFontSize(42);
    label.SetFitToContent(true);
    label.SetVAlign(inkEVerticalAlign.Center);
    label.SetLetterCase(textLetterCase.OriginalCase);
    label.SetAnchor(inkEAnchor.TopLeft);
    label.SetHAlign(inkEHorizontalAlign.Left);
    label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    label.BindProperty(n"tintColor", n"MainColors.Red");
    label.Reparent(checkboxContainer);
    return checkboxContainer;
  }
  private final func AnimateOpacity(duration: Float, start: Float, end: Float) -> ref<inkAnimDef> {
    let moveElementsAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(duration);
    transparencyInterpolator.SetStartDelay(0.0);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetStartTransparency(start);
    transparencyInterpolator.SetEndTransparency(end);
    moveElementsAnimDef.AddInterpolator(transparencyInterpolator);
    return moveElementsAnimDef;
  }
  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(this.m_player, evt);
  }
  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedFilters", str);
    };
  }
}
public class RevisedBackpackItemController extends inkVirtualCompoundItemController {
  private let m_item: ref<RevisedItemWrapper>;
  private let m_shadow: wref<inkWidget>;
  private let m_selection: wref<inkWidget>;
  private let m_itemName: wref<inkText>;
  private let m_itemIcon: wref<inkImage>;
  private let m_itemEquipped: wref<inkWidget>;
  private let m_itemNew: wref<inkWidget>;
  private let m_itemFavorite: wref<inkWidget>;
  private let m_itemType: wref<inkText>;
  private let m_itemTier: wref<inkText>;
  private let m_itemPrice: wref<inkText>;
  private let m_itemWeight: wref<inkText>;
  private let m_itemDps: wref<inkText>;
  private let m_itemRange: wref<inkText>;
  private let m_itemQuest: wref<inkWidget>;
  private let m_questContainer: wref<inkWidget>; 
  private let m_itemCustomJunk: wref<inkWidget>;
  private let m_customJunkContainer: wref<inkWidget>; 
  protected cb func OnInitialize() -> Bool {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    this.m_shadow = root.GetWidgetByPathName(n"shadow");
    this.m_selection = root.GetWidgetByPathName(n"selection");
    this.m_itemName = root.GetWidgetByPathName(n"item/nameContainer/name") as inkText;
    this.m_itemIcon = root.GetWidgetByPathName(n"item/nameContainer/icon") as inkImage;
    this.m_itemEquipped = root.GetWidgetByPathName(n"item/nameContainer/equipped");
    this.m_itemNew = root.GetWidgetByPathName(n"item/nameContainer/new");
    this.m_itemFavorite = root.GetWidgetByPathName(n"item/nameContainer/favorite");
    this.m_itemType = root.GetWidgetByPathName(n"item/type") as inkText;
    this.m_itemTier = root.GetWidgetByPathName(n"item/tier") as inkText;
    this.m_itemPrice = root.GetWidgetByPathName(n"item/price") as inkText;
    this.m_itemWeight = root.GetWidgetByPathName(n"item/weight") as inkText;
    this.m_itemDps = root.GetWidgetByPathName(n"item/dps") as inkText;
    this.m_itemRange = root.GetWidgetByPathName(n"item/range") as inkText;
    this.m_itemQuest = root.GetWidgetByPathName(n"item/quest/checkbox");
    this.m_questContainer = root.GetWidgetByPathName(n"item/quest");
    this.m_itemCustomJunk = root.GetWidgetByPathName(n"item/customJunk/checkbox");
    this.m_customJunkContainer = root.GetWidgetByPathName(n"item/customJunk");
    this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");    
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease"); 
    this.RegisterToCallback(n"OnHold", this, n"OnHold");
    this.RegisterToCallback(n"OnPress", this, n"OnPressed");
  }
  protected cb func OnUninitialize() -> Bool {
    let evt: ref<inkPointerEvent>;
    this.OnHoverOut(evt);
  }
  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.m_shadow.SetVisible(true);
    let target: ref<inkWidget> = evt.GetTarget();
    let isName: Bool = Equals(target.GetName(), n"nameContainer");
    if IsDefined(this.m_item) {
      this.QueueEvent(RevisedBackpackItemHoverOverEvent.Create(this.m_item, isName, target));
      this.SetIsNew(false);
    };
  }
  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.m_shadow.SetVisible(false);
    if IsDefined(this.m_item) {
      this.QueueEvent(RevisedBackpackItemHoverOutEvent.Create(this.m_item));
    };
  }
  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    let displayClickEvent: ref<RevisedItemDisplayClickEvent>;
    let toggleQuestTagEvent: ref<RevisedToggleQuestTagEvent>;
    let toggleCustomJunkEvent: ref<RevisedToggleCustomJunkEvent>;
    let targetName: CName = evt.GetTarget().GetName();
    if evt.IsAction(n"click") && Equals(targetName, n"quest") && this.CanToggleQuestTag() {
      toggleQuestTagEvent = new RevisedToggleQuestTagEvent();
      toggleQuestTagEvent.itemData = this.m_item.data;
      toggleQuestTagEvent.display = this;
      this.QueueEvent(toggleQuestTagEvent);
    } else if evt.IsAction(n"click") && Equals(targetName, n"customJunk") && this.CanToggleCustomJunk() {
      toggleCustomJunkEvent = new RevisedToggleCustomJunkEvent();
      toggleCustomJunkEvent.itemData = this.m_item.data;
      toggleCustomJunkEvent.display = this;
      this.QueueEvent(toggleCustomJunkEvent);
    } else if evt.IsAction(n"select") && NotEquals(targetName, n"quest") && NotEquals(targetName, n"customJunk") {
      this.QueueEvent(RevisedBackpackItemSelectEvent.Create(this.m_item));
    } else {
      displayClickEvent = new RevisedItemDisplayClickEvent();
      displayClickEvent.itemData = this.m_item.data;
      displayClickEvent.display = this;
      displayClickEvent.uiInventoryItem = this.m_item.inventoryItem;
      displayClickEvent.actionName = evt.GetActionName();
      this.QueueEvent(displayClickEvent);
    };
  }
  protected cb func OnHold(evt: ref<inkPointerEvent>) -> Bool {
    let displayHoldEvent: ref<RevisedItemDisplayHoldEvent>;
    if evt.GetHoldProgress() >= 1.0 {
      displayHoldEvent = new RevisedItemDisplayHoldEvent();
      displayHoldEvent.itemData = this.m_item.data;
      displayHoldEvent.display = this;
      displayHoldEvent.uiInventoryItem = this.m_item.inventoryItem;
      displayHoldEvent.actionName = evt.GetActionName();
      this.QueueEvent(displayHoldEvent);
    };
  }
  protected cb func OnPressed(evt: ref<inkPointerEvent>) -> Bool {
    let pressEvent: ref<RevisedItemDisplayPressEvent> = new RevisedItemDisplayPressEvent();
    pressEvent.display = this;
    pressEvent.actionName = evt.GetActionName();
    this.QueueEvent(pressEvent);
  }
  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_item = FromVariant<ref<IScriptable>>(value) as RevisedItemWrapper;
    if IsDefined(this.m_item) {
      this.RefreshView();
    };
  }
  protected cb func OnRevisedBackpackItemHighlightEvent(evt: ref<RevisedBackpackItemHighlightEvent>) -> Bool {
    if Equals(evt.itemId, this.m_item.data.GetID()) && NotEquals(this.m_item.GetSelectedFlag(), evt.highlight) {
      this.m_item.SetSelectedFlag(evt.highlight);
      this.m_selection.SetVisible(this.m_item.GetSelectedFlag());
      this.QueueEvent(RevisedBackpackItemWasHighlightedEvent.Create(this));
    };
  }
  public final func SetSelection(selected: Bool) -> Void {
    this.m_item.SetSelectedFlag(selected);
    this.m_selection.SetVisible(this.m_item.GetSelectedFlag());
  }
  public final func GetIsNew() -> Bool {
    return this.m_item.GetNewFlag();
  }
  public final func SetIsNew(flag: Bool) -> Void {
    this.m_item.SetNewFlag(flag);
    this.m_itemNew.SetVisible(this.GetIsNew());
  }
  public final func GetIsPlayerFavourite() -> Bool {
    return this.m_item.GetFavoriteFlag();
  }
  public final func SetIsPlayerFavourite(flag: Bool) -> Void {
    this.Log(s"Switch quest tag for \(this.m_item.nameLabel) to \(flag)");
    this.m_item.SetFavoriteFlag(flag);
    this.m_itemFavorite.SetVisible(this.GetIsPlayerFavourite());
  }
  public final func GetIsQuestItem() -> Bool {
    return this.m_item.GetQuestFlag();
  }
  public final func SetIsQuestItem(flag: Bool) -> Void {
    this.m_item.SetQuestFlag(flag);
    this.m_itemName.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemLabelColor(this.GetIsQuestItem()));
    this.m_itemQuest.SetVisible(this.GetIsQuestItem());
  }
  public final func CanToggleQuestTag() -> Bool {
    return this.m_item.questTagToggleable;
  }
  public final func GetIsCustomJunkItem() -> Bool {
    return this.m_item.GetCustomJunkFlag();
  }
  public final func SetIsCustomJunkItem(flag: Bool) -> Void {
    this.m_item.SetCustomJunkFlag(flag);
    this.m_itemCustomJunk.SetVisible(this.GetIsCustomJunkItem());
  }
  public final func CanToggleCustomJunk() -> Bool {
    return this.m_item.customJunkToggleable;
  }
  private final func RefreshView() -> Void {
    let label: String = this.m_item.nameLabel;
    let quantity: Int32 = this.m_item.inventoryItem.GetQuantity();
    if quantity > 1 { label += s" (\(quantity))"; }
    this.m_itemName.SetText(label);
    this.m_itemName.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemLabelColor(this.GetIsQuestItem()));
    this.m_itemIcon.SetTexturePart(RevisedBackpackUtils.GetItemIcon(this.m_item.data));
    this.m_itemIcon.BindProperty(n"tintColor", RevisedBackpackUtils.GetItemIconColor(this.m_item.data));
    this.m_itemEquipped.SetVisible(this.m_item.GetEquippedFlag());
    this.m_itemNew.SetVisible(this.m_item.GetNewFlag());
    this.m_itemFavorite.SetVisible(this.m_item.GetFavoriteFlag());
    this.m_itemType.SetText(this.m_item.typeLabel);
    this.m_itemTier.SetText(this.m_item.tierLabel);
    this.m_itemPrice.SetText(this.m_item.priceLabel);
    this.m_itemWeight.SetText(this.m_item.weightLabel);
    this.m_itemDps.SetText(this.m_item.dpsLabel);
    this.m_itemRange.SetText(this.m_item.rangeLabel);
    this.m_itemQuest.SetVisible(this.m_item.GetQuestFlag());
    this.m_itemCustomJunk.SetVisible(this.m_item.GetCustomJunkFlag());
    this.m_selection.SetVisible(this.m_item.GetSelectedFlag());
    if this.CanToggleQuestTag() {
      this.m_questContainer.SetOpacity(1.0);
    } else {
      this.m_questContainer.SetOpacity(0.1);
    };
    if this.CanToggleCustomJunk() {
      this.m_customJunkContainer.SetOpacity(1.0);
    } else {
      this.m_customJunkContainer.SetOpacity(0.1);
    };
    this.Log(s"RefreshView for \(this.m_item.nameLabel), selected \(this.m_item.GetSelectedFlag()), custom junk \(this.m_item.GetCustomJunkFlag())))");
  }
  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedItemController", str);
    };
  }
}
public class RevisedBackpackSettings {
  @runtimeProperty("ModSettings.mod", "Revised Backpack")
  @runtimeProperty("ModSettings.category", "Mod-Revised-Additional-Options")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Revised-Settings-Favorite")
  @runtimeProperty("ModSettings.description", "Mod-Revised-Settings-Favorite-Desc")
  let favoriteOnTop: Bool = true;
  @runtimeProperty("ModSettings.mod", "Revised Backpack")
  @runtimeProperty("ModSettings.category", "Mod-Revised-Additional-Options")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Mod-Revised-Settings-New")
  @runtimeProperty("ModSettings.description", "Mod-Revised-Settings-New-Desc")
  let newOnTop: Bool = false;
}
public class RevisedBackpackSortController extends inkLogicController {
  private let m_player: wref<PlayerPuppet>;
  private let m_borderName: inkWidgetRef;
  private let m_borderType: inkWidgetRef;
  private let m_borderTier: inkWidgetRef;
  private let m_borderPrice: inkWidgetRef;
  private let m_borderWeight: inkWidgetRef;
  private let m_borderDps: inkWidgetRef;
  private let m_borderRange: inkWidgetRef;
  private let m_borderQuest: inkWidgetRef;
  private let m_borderCustomJunk: inkWidgetRef;
  private let m_arrowName: inkWidgetRef;
  private let m_arrowType: inkWidgetRef;
  private let m_arrowTier: inkWidgetRef;
  private let m_arrowPrice: inkWidgetRef;
  private let m_arrowWeight: inkWidgetRef;
  private let m_arrowDps: inkWidgetRef;
  private let m_arrowRange: inkWidgetRef;
  private let m_arrowQuest: inkWidgetRef;
  private let m_arrowCustomJunk: inkWidgetRef;
  private let previousSelectedWidget: ref<inkWidget>;
  private let currentSelectedWidget: ref<inkWidget>;
  private let currentSorting: revisedSorting;
  private let currentSortingMode: revisedSortingMode;
  private let rotationAnimationProxy: ref<inkAnimProxy>;
  private let rotationAnimation: ref<inkAnimDef>;
  protected cb func OnInitialize() -> Bool {
    this.currentSorting = revisedSorting.None;
    this.currentSortingMode = revisedSortingMode.None;
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
    this.m_player = GetPlayer(GetGameInstance());
  }
  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
    this.rotationAnimationProxy.Stop();
    this.rotationAnimationProxy = null;
  }
  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    this.SetHoveredOnState(target);
    let userData: ref<LabeledCursorData> = target.GetUserData(n"LabeledCursorData") as LabeledCursorData;
    if IsDefined(userData) {
      this.QueueEvent(RevisedBackpackColumnHoverOverEvent.Create(target, this.SortingFromUserData(userData.m_text)));
    };
  }
  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let target: ref<inkWidget> = evt.GetTarget();
    this.SetHoveredOutState(target);
    this.QueueEvent(RevisedBackpackColumnHoverOutEvent.Create());
  }
  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.PlaySound(n"ui_menu_onpress");
      let target: ref<inkWidget> = evt.GetTarget();
      let userData: ref<LabeledCursorData> = target.GetUserData(n"LabeledCursorData") as LabeledCursorData;
      if IsDefined(userData) {
        this.previousSelectedWidget = this.currentSelectedWidget;
        this.currentSelectedWidget = target;
        this.OnSortingHeaderClick(this.SortingFromUserData(userData.m_text));
      };
    };
  }
  private final func SetHoveredOnState(target: ref<inkWidget>) -> Void {
    if IsDefined(target) {
      if NotEquals(this.currentSelectedWidget, target) {
        target.BindProperty(n"tintColor", n"MainColors.Blue");
        target.SetOpacity(0.5);
      };
    };
  }
  private final func SetSelectedState(target: ref<inkWidget>) -> Void {
    if IsDefined(target) {
      target.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
      target.SetOpacity(0.5);
    };
  }
  private final func SetHoveredOutState(target: ref<inkWidget>) -> Void {
    if IsDefined(target) {
      if NotEquals(this.currentSelectedWidget, target) {
        target.BindProperty(n"tintColor", n"MainColors.Red");
        target.SetOpacity(0.1);
      } else {
        target.BindProperty(n"tintColor", n"MainColors.ActiveBlue");
        target.SetOpacity(0.5);
      };
    };
  }
  private final func OnSortingHeaderClick(type: revisedSorting) -> Void {
    if NotEquals(this.currentSorting, type) {
      this.currentSorting = type;
      this.currentSortingMode = revisedSortingMode.Asc;
    } else {
      if Equals(this.currentSortingMode, revisedSortingMode.Asc) {
        this.currentSortingMode = revisedSortingMode.Desc;
      } else {
        this.currentSortingMode = revisedSortingMode.Asc;
      };
    };
    this.UpdateSortingControls();
    this.QueueEvent(RevisedBackpackSortingChanged.Create(this.currentSorting, this.currentSortingMode));
  }
  private final func UpdateSortingControls() -> Void {
    this.Log(s"UpdateSortingControls \(this.currentSorting) + \(this.currentSortingMode)");
    if NotEquals(this.previousSelectedWidget, this.currentSelectedWidget) {
      this.SetHoveredOutState(this.previousSelectedWidget);
      this.SetSelectedState(this.currentSelectedWidget);
    };
    switch this.currentSorting {
      case revisedSorting.Name:
        this.UpdateArrow(this.m_arrowName, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Type:
        this.UpdateArrow(this.m_arrowType, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Tier:
        this.UpdateArrow(this.m_arrowTier, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Price:
        this.UpdateArrow(this.m_arrowPrice, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Weight:
        this.UpdateArrow(this.m_arrowWeight, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Dps:
        this.UpdateArrow(this.m_arrowDps, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Range:
        this.UpdateArrow(this.m_arrowRange, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.Quest:
        this.UpdateArrow(this.m_arrowQuest, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
      case revisedSorting.CustomJunk:
        this.UpdateArrow(this.m_arrowCustomJunk, Equals(this.currentSortingMode, revisedSortingMode.Asc));
        break;
    };
  }
  private final func HideArrows() -> Void {
    inkWidgetRef.SetVisible(this.m_arrowName, false);
    inkWidgetRef.SetVisible(this.m_arrowType, false);
    inkWidgetRef.SetVisible(this.m_arrowTier, false);
    inkWidgetRef.SetVisible(this.m_arrowPrice, false);
    inkWidgetRef.SetVisible(this.m_arrowWeight, false);
    inkWidgetRef.SetVisible(this.m_arrowDps, false);
    inkWidgetRef.SetVisible(this.m_arrowRange, false);
    inkWidgetRef.SetVisible(this.m_arrowQuest, false);
    inkWidgetRef.SetVisible(this.m_arrowCustomJunk, false);
  }
  private final func UpdateArrow(target: inkWidgetRef, asc: Bool) -> Void {
    if NotEquals(this.previousSelectedWidget, this.currentSelectedWidget) {
      this.HideArrows();
    };
    inkWidgetRef.SetVisible(target, true);
    let currentRotation: Float = inkWidgetRef.GetRotation(target);
    let targetRotation: Float;
    if asc {
      targetRotation = 0.0;
    } else {
      targetRotation = 180.0;
    };
    this.rotationAnimation = new inkAnimDef();
    let rotationInterpolator: ref<inkAnimRotation> = new inkAnimRotation();
    rotationInterpolator.SetDuration(0.15);
    rotationInterpolator.SetDirection(inkanimInterpolationDirection.To);
    rotationInterpolator.SetType(inkanimInterpolationType.Linear);
    rotationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    rotationInterpolator.SetStartRotation(currentRotation);
    rotationInterpolator.SetEndRotation(targetRotation);
    this.rotationAnimation.AddInterpolator(rotationInterpolator);
    this.rotationAnimationProxy.Stop();
    this.rotationAnimationProxy = null;
    this.rotationAnimationProxy = inkWidgetRef.PlayAnimation(target, this.rotationAnimation);
  }
  private final func SortingFromUserData(from: String) -> revisedSorting {
    switch from {
      case "Name": return revisedSorting.Name;
      case "Type": return revisedSorting.Type;
      case "Tier": return revisedSorting.Tier;
      case "Price": return revisedSorting.Price;
      case "Weight": return revisedSorting.Weight;
      case "Dps": return revisedSorting.Dps;
      case "Range": return revisedSorting.Range;
      case "Quest": return revisedSorting.Quest;
      case "CustomJunk": return revisedSorting.CustomJunk;
    };
    return revisedSorting.Name;
  }
  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(this.m_player, evt);
  }
  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedSorter", str);
    };
  }
}
public class RevisedBackpackSystem extends ScriptableSystem {
  private persistent let customJunk: array<ItemID>;
  private let categories: array<ref<RevisedBackpackCategory>>;
  public static func GetInstance(gi: GameInstance) -> ref<RevisedBackpackSystem> {
    return GameInstance.GetScriptableSystemsContainer(gi).Get(n"RevisedBackpack.RevisedBackpackSystem") as RevisedBackpackSystem;
  }
  public final func AddNewCategory(category: ref<RevisedBackpackCategory>) -> Void {
    let newCategories: array<ref<RevisedBackpackCategory>> = this.categories;
    ArrayPush(newCategories, category);
    RevisedBackpackCategory.Sort(newCategories);
    this.categories = newCategories;
    this.Log(s"Category added, total: \(ArraySize(this.categories))");
  }
  public final func AddNewCategories(categories: array<ref<RevisedBackpackCategory>>) -> Void {
    let newCategories: array<ref<RevisedBackpackCategory>> = this.categories;
    for category in categories {
      ArrayPush(newCategories, category);
    };
    RevisedBackpackCategory.Sort(newCategories);
    this.categories = newCategories;
    this.Log(s"Categories added, total: \(ArraySize(this.categories))");
  }
  public final func GetCategories() -> array<ref<RevisedBackpackCategory>> {
    this.Log(s"GetCategorues returns categories: \(ArraySize(this.categories))");
    return this.categories;
  }
  public final func IsAddedToJunk(itemId: ItemID) -> Bool {
    return ArrayContains(this.customJunk, itemId);
  }
  public final func AddToJunk(itemId: ItemID) -> Bool {
    if this.IsAddedToJunk(itemId) {
      return false;
    };
    ArrayPush(this.customJunk, itemId);
    return true;
  }
  public final func RemoveFromJunk(itemId: ItemID) -> Bool {
    if !this.IsAddedToJunk(itemId)  {
      return false;
    };
    ArrayRemove(this.customJunk, itemId);
    return true;
  }
  public final func HasCustomJunk() -> Bool {
    return ArraySize(this.customJunk) > 0;
  }
  public final func InvalidateCustomJunk(inventory: array<ref<IScriptable>>) -> Void {
    let updated: array<ItemID>;
    let itemId: ItemID;
    let wrapper: ref<RevisedItemWrapper>;
    for item in inventory {
      wrapper = item as RevisedItemWrapper;
      if IsDefined(wrapper) {
        itemId = wrapper.data.GetID();
        if this.IsAddedToJunk(itemId) {
          ArrayPush(updated, itemId);
        };
      }
    };
    this.customJunk = updated;
  }
  public final func ClearCustomJunk() -> Void {
    ArrayClear(this.customJunk);
  }
  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.Log("OnInitialize, can access game systems");
    this.FillDefaultCategories();
  }
  private final func FillDefaultCategories() -> Void {
    let newCategories: array<ref<RevisedBackpackCategory>> = RevisedBackpackDefaultConfig.Categories();
    this.AddNewCategories(newCategories);
    this.Log(s"Default categories created: \(ArraySize(this.categories))");
    for category in this.categories {
      this.Log(s"- \(category.id): \(GetLocalizedTextByKey(category.titleLocKey))");
    };
  }
  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedService", str);
    };
  }
}
public class RevisedCategoryComponent extends inkComponent {
  private let data: ref<RevisedBackpackCategory>;
  private let hovered: Bool;
  private let selected: Bool;
  protected cb func OnCreate() -> ref<inkWidget> {
    let root: ref<inkCanvas> = new inkCanvas();
    root.SetName(n"Root");
    root.SetSize(76.0, 76.0);
    root.SetMargin(12.0, 0.0, 12.0, 0.0);
    root.SetInteractive(true);
    let icon: ref<inkImage> = new inkImage();
    icon.SetName(n"icon");
    icon.SetAtlasResource(r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
    icon.SetTexturePart(n"resource");
    icon.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    icon.BindProperty(n"tintColor", n"MainColors.Red");
    icon.SetContentHAlign(inkEHorizontalAlign.Fill);
    icon.SetContentVAlign(inkEVerticalAlign.Fill);
    icon.SetTileHAlign(inkEHorizontalAlign.Fill);
    icon.SetTileVAlign(inkEVerticalAlign.Fill);
    icon.SetAnchor(inkEAnchor.Centered);
    icon.SetAnchorPoint(new Vector2(0.5, 0.5));
    icon.SetSize(64.0, 64.0);
    icon.Reparent(root);
    return root;
  }
  protected cb func OnInitialize() {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
  }
  protected cb func OnUninitialize() {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
  }
  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.PlaySound(n"ui_menu_hover");
    this.hovered = true;
    this.RefreshItemState();
  }
  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.hovered = false;
    this.RefreshItemState();
  }
  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
      this.PlaySound(n"ui_menu_onpress");
      this.QueueEvent(RevisedCategorySelectedEvent.Create(this.data));
    };
  }
  protected cb func OnRevisedCategorySelectedEvent(evt: ref<RevisedCategorySelectedEvent>) -> Bool {
    let selected: Bool = Equals(this.data.id, evt.category.id);
    this.selected = selected;
    this.RefreshItemState();
  }
  public final func SetData(data: ref<RevisedBackpackCategory>) -> Void {
    this.data = data;
    this.RefreshItemData();
    this.RefreshItemState();
  }
  public final func RefreshItemData() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let icon: ref<inkImage> = root.GetWidgetByPathName(n"icon") as inkImage;
    icon.SetAtlasResource(this.data.atlasResource);
    icon.SetTexturePart(this.data.texturePart);
  }
  private final func RefreshItemState() -> Void {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let icon: ref<inkWidget> = root.GetWidgetByPathName(n"icon");
    let iconColor: CName;
    if this.hovered || this.selected {
      iconColor = n"MainColors.Blue";
    } else {
      iconColor = n"MainColors.MildRed";
    };
    let scale: Float;
    if this.hovered {
      scale = 1.1;
    } else {
      scale = 1.0;
    };
    icon.BindProperty(n"tintColor", iconColor);
    this.AnimateScale(icon, scale);
  }
  private final func AnimateScale(target: ref<inkWidget>, endScale: Float) -> Void {
    let scaleAnimDef: ref<inkAnimDef> = new inkAnimDef();
    let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
    scaleInterpolator.SetType(inkanimInterpolationType.Linear);
    scaleInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    scaleInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    scaleInterpolator.SetStartScale(target.GetScale());
    scaleInterpolator.SetEndScale(new Vector2(endScale, endScale));
    scaleInterpolator.SetDuration(0.1);
    scaleAnimDef.AddInterpolator(scaleInterpolator);
    target.PlayAnimation(scaleAnimDef);
  }
  private final func PlaySound(evt: CName) -> Void {
    GameObject.PlaySoundEvent(GetPlayer(GetGameInstance()), evt);
  }
  private final func Log(str: String) -> Void {
    if RevisedBackpackUtils.ShowRevisedBackpackLogs() {
      ModLog(n"RevisedCategory", str);
    };
  }
}
public class RevisedCompareBuilder extends IScriptable {
  private let m_sortData1: ref<RevisedItemWrapper>;
  private let m_sortData2: ref<RevisedItemWrapper>;
  private let m_compareBuilder: ref<CompareBuilder>;
  public final static func Make(sortData1: ref<RevisedItemWrapper>, sortData2: ref<RevisedItemWrapper>) -> ref<RevisedCompareBuilder> {
    let builder: ref<RevisedCompareBuilder> = new RevisedCompareBuilder();
    builder.m_compareBuilder = CompareBuilder.Make();
    builder.m_sortData1 = sortData1;
    builder.m_sortData2 = sortData2;
    return builder;
  }
  public final func Get() -> Int32 {
    return this.m_compareBuilder.Get();
  }
  public final func GetBool() -> Bool {
    return this.m_compareBuilder.GetBool();
  }
  public final func NameAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.StringAsc(this.m_sortData1.nameLabel, this.m_sortData2.nameLabel);
    return this;
  }
  public final func NameDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.StringDesc(this.m_sortData1.nameLabel, this.m_sortData2.nameLabel);
    return this;
  }
  public final func TypeAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.typeValue, this.m_sortData2.typeValue);
    return this;
  }
  public final func TypeDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.typeValue, this.m_sortData2.typeValue);
    return this;
  }
  public final func QualityAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.tierValue, this.m_sortData2.tierValue);
    return this;
  }
  public final func QualityDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.tierValue, this.m_sortData2.tierValue);
    return this;
  }
  public final func PriceAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatAsc(this.m_sortData1.price, this.m_sortData2.price);
    return this;
  }
  public final func PriceDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatDesc(this.m_sortData1.price, this.m_sortData2.price);
    return this;
  }
  public final func WeightAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatAsc(this.m_sortData1.weight, this.m_sortData2.weight);
    return this;
  }
  public final func WeightDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.FloatDesc(this.m_sortData1.weight, this.m_sortData2.weight);
    return this;
  }
  public final func DpsAsc() -> ref<RevisedCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.dps;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.dps;
    };
    this.m_compareBuilder.FloatAsc(leftValue, rightValue);
    return this;
  }
  public final func DpsDesc() -> ref<RevisedCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.dps;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.dps;
    };
    this.m_compareBuilder.FloatDesc(leftValue, rightValue);
    return this;
  }
  public final func RangeAsc() -> ref<RevisedCompareBuilder> {
    let leftValue: Int32;
    let rightValue: Int32;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.range;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.range;
    };
    this.m_compareBuilder.IntAsc(leftValue, rightValue);
    return this;
  }
  public final func RangeDesc() -> ref<RevisedCompareBuilder> {
    let leftValue: Int32;
    let rightValue: Int32;
    if this.m_sortData1.isWeapon {
      leftValue = this.m_sortData1.range;
    };
    if this.m_sortData2.isWeapon {
      rightValue = this.m_sortData2.range;
    };
    this.m_compareBuilder.IntDesc(leftValue, rightValue);
    return this;
  }
  public final func QuestAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isQuest, this.m_sortData2.isQuest);
    return this;
  }
  public final func QuestDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolFalse(this.m_sortData1.isQuest, this.m_sortData2.isQuest);
    return this;
  }
  public final func CustomJunkAsc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.customJunk, this.m_sortData2.customJunk);
    return this;
  }
  public final func CustomJunkDesc() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolFalse(this.m_sortData1.customJunk, this.m_sortData2.customJunk);
    return this;
  }
  public final func NewItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isNew, this.m_sortData2.isNew);
    return this;
  }
  public final func FavouriteItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isFavorite, this.m_sortData2.isFavorite);
    return this;
  }
  public final func DLCAddedItem() -> ref<RevisedCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.isDlcAddedItem, this.m_sortData2.isDlcAddedItem);
    return this;
  }
}
public class RevisedFiltersButton extends SimpleButton {
    protected cb func OnInitialize() {
      super.OnInitialize();
      this.m_label.SetFontSize(40);
      this.m_rootWidget.SetSize(340.0, 80.0);
    }
    public final func SetAsDangerous() -> Void {
      this.m_label.BindProperty(n"tintColor", n"MainColors.Red");
    }
    public static func Create() -> ref<RevisedFiltersButton> {
      let self: ref<RevisedFiltersButton> = new RevisedFiltersButton();
      self.CreateInstance();
      return self;
    }
}
public class RevisedPreviewGarmentController extends WardrobeSetPreviewGameController {
  protected cb func OnPreviewInitialized() -> Bool {
    super.OnPreviewInitialized();
    this.PreviewUnequipFromSlot(t"AttachmentSlots.WeaponLeft");
    this.PreviewUnequipFromSlot(t"AttachmentSlots.WeaponRight");
  }
  protected cb func OnUninitialize() -> Bool {
    this.CleanUpPuppet();
    super.OnUninitialize();
  }
  protected cb func OnRevisedItemPreviewEvent(evt: ref<RevisedItemPreviewEvent>) -> Bool {
    if evt.isGarment {
      this.ResetPuppetState();
      this.PreviewEquipAndForceShowItem(evt.itemId);
      this.ZoomToItem(evt.itemId);
    };
  }
  private final func ZoomToItem(itemId: ItemID) -> Void {
    let zoomArea: InventoryPaperdollZoomArea = this.GetZoomArea(itemId);
    let setCameraSetupEvent: ref<gameuiPuppetPreview_SetCameraSetupEvent> = new gameuiPuppetPreview_SetCameraSetupEvent();
    setCameraSetupEvent.setupIndex = Cast<Uint32>(EnumInt(zoomArea));
    this.QueueEvent(setCameraSetupEvent);
  }
  private final func ResetPuppetState() -> Void {
    this.ClearPuppet();
    if this.TryRestoreActiveWardrobeSet() {
      this.SyncUnderwearToEquipmentSystem();
    } else {
      this.RestorePuppetEquipment();
    };
    this.DelayedResetItemAppearanceInSlot(t"AttachmentSlots.Chest");
  }
  private final func GetZoomArea(itemId: ItemID) -> InventoryPaperdollZoomArea {
    let itemRecord: ref<Item_Record> = RPGManager.GetItemRecord(itemId);
    let equipmentArea: gamedataEquipmentArea = itemRecord.EquipArea().Type();
    if Equals(equipmentArea, gamedataEquipmentArea.Head) || Equals(equipmentArea, gamedataEquipmentArea.Face) {
      return InventoryPaperdollZoomArea.Head;
    };
    return InventoryPaperdollZoomArea.Default;
  }
}
public class RevisedPreviewItemController extends ItemPreviewGameController {
  protected cb func OnRevisedItemPreviewEvent(evt: ref<RevisedItemPreviewEvent>) -> Bool {
    if !evt.isGarment {
      this.PreviewItem(evt.itemId);
    };
  }
}
public abstract class RevisedBackpackUtils {
  public final static func ShowRevisedBackpackLogs() -> Bool = false
  public final static func GetItemIcon(data: ref<gameItemData>) -> CName {
    let type: gamedataItemType = data.GetItemType();
    switch type {
      case gamedataItemType.Clo_Face: return n"loot_face";
      case gamedataItemType.Clo_Feet: return n"loot_shoes";
      case gamedataItemType.Clo_Head: return n"loot_head";
      case gamedataItemType.Clo_InnerChest: return n"loot_chest";
      case gamedataItemType.Clo_Legs: return n"loot_pants";
      case gamedataItemType.Clo_OuterChest: return n"loot_jacket";
      case gamedataItemType.Clo_Outfit: return n"loot_outfit";
      case gamedataItemType.Con_Ammo: return n"loot_ammo";
      case gamedataItemType.Con_Edible: return n"loot_consumable";
      case gamedataItemType.Con_Inhaler: return n"loot_inhaler";
      case gamedataItemType.Con_Injector: return n"loot_inhaler";
      case gamedataItemType.Con_LongLasting: return n"medicine";
      case gamedataItemType.Con_Skillbook: return n"codex_character";
      case gamedataItemType.Cyb_Ability: return n"codex_character";
      case gamedataItemType.Cyb_HealingAbility: return n"codex_character";
      case gamedataItemType.Cyb_Launcher: return n"loot_cyberware";
      case gamedataItemType.Cyb_MantisBlades: return n"loot_cyberware";
      case gamedataItemType.Cyb_NanoWires: return n"loot_cyberware";
      case gamedataItemType.Cyb_StrongArms: return n"loot_cyberware";
      case gamedataItemType.Cyberware: return n"loot_cyberware";
      case gamedataItemType.CyberwareStatsShard: return n"codex_character";
      case gamedataItemType.CyberwareUpgradeShard: return n"codex_character";
      case gamedataItemType.Gad_Grenade: return n"loot_grenade";
      case gamedataItemType.Gen_CraftingMaterial: return n"loot_material";
      case gamedataItemType.Gen_DataBank: return n"retrieving";
      case gamedataItemType.Gen_Jewellery: return n"junk";
      case gamedataItemType.Gen_Junk: return n"junk";
      case gamedataItemType.Gen_Keycard: return n"skillcheck_token";
      case gamedataItemType.Gen_Misc: return n"resource";
      case gamedataItemType.Gen_MoneyShard: return n"OpenVendor";
      case gamedataItemType.Gen_Readable: return n"shard";
      case gamedataItemType.Gen_Tarot: return n"tarot_card";
      case gamedataItemType.GrenadeDelivery: return n"grenade";
      case gamedataItemType.Grenade_Core: return n"grenade";
      case gamedataItemType.Prt_AR_SMG_LMGMod: return n"mod";
      case gamedataItemType.Prt_BladeMod: return n"mod";
      case gamedataItemType.Prt_BluntMod: return n"mod";
      case gamedataItemType.Prt_BootsFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_Capacitor: return n"mod";
      case gamedataItemType.Prt_FabricEnhancer: return n"armor";
      case gamedataItemType.Prt_FaceFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_Fragment: return n"loot_fragment";
      case gamedataItemType.Prt_HandgunMod: return n"mod";
      case gamedataItemType.Prt_HandgunMuzzle: return n"loot_muzzle";
      case gamedataItemType.Prt_HeadFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_LongScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_Magazine: return n"loot_magazine";
      case gamedataItemType.Prt_MeleeMod: return n"mod";
      case gamedataItemType.Prt_Mod: return n"mod";
      case gamedataItemType.Prt_Muzzle: return n"loot_muzzle";
      case gamedataItemType.Prt_OuterTorsoFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_PantsFabricEnhancer: return n"armor";
      case gamedataItemType.Prt_PowerMod: return n"mod";
      case gamedataItemType.Prt_PowerSniperScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_Precision_Sniper_RifleMod: return n"mod";
      case gamedataItemType.Prt_Program: return n"loot_program";
      case gamedataItemType.Prt_RangedMod: return n"mod";
      case gamedataItemType.Prt_Receiver: return n"loot_receiver";
      case gamedataItemType.Prt_RifleMuzzle: return n"loot_muzzle";
      case gamedataItemType.Prt_Scope: return n"loot_targetting_system";
      case gamedataItemType.Prt_ScopeRail: return n"loot_scope_rail";
      case gamedataItemType.Prt_ShortScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_ShotgunMod: return n"mod";
      case gamedataItemType.Prt_SmartMod: return n"mod";
      case gamedataItemType.Prt_Stock: return n"loot_stock";
      case gamedataItemType.Prt_TargetingSystem: return n"loot_targetting_system";
      case gamedataItemType.Prt_TechMod: return n"mod";
      case gamedataItemType.Prt_TechSniperScope: return n"loot_targetting_system";
      case gamedataItemType.Prt_ThrowableMod: return n"mod";
      case gamedataItemType.Prt_TorsoFabricEnhancer: return n"armor";
      case gamedataItemType.Wea_AssaultRifle: return n"gun";
      case gamedataItemType.Wea_Axe: return n"melee";
      case gamedataItemType.Wea_Chainsword: return n"melee";
      case gamedataItemType.Wea_Fists: return n"Solo";
      case gamedataItemType.Wea_GrenadeLauncher: return n"gun";
      case gamedataItemType.Wea_Hammer: return n"melee";
      case gamedataItemType.Wea_Handgun: return n"gun";
      case gamedataItemType.Wea_HeavyMachineGun: return n"gun_heavy";
      case gamedataItemType.Wea_Katana: return n"melee";
      case gamedataItemType.Wea_Knife: return n"melee";
      case gamedataItemType.Wea_LightMachineGun: return n"gun";
      case gamedataItemType.Wea_LongBlade: return n"melee";
      case gamedataItemType.Wea_Machete: return n"melee";
      case gamedataItemType.Wea_Melee: return n"melee";
      case gamedataItemType.Wea_OneHandedClub: return n"melee";
      case gamedataItemType.Wea_PrecisionRifle: return n"gun";
      case gamedataItemType.Wea_Revolver: return n"gun";
      case gamedataItemType.Wea_Rifle: return n"gun";
      case gamedataItemType.Wea_ShortBlade: return n"melee";
      case gamedataItemType.Wea_Shotgun: return n"gun";
      case gamedataItemType.Wea_ShotgunDual: return n"gun";
      case gamedataItemType.Wea_SniperRifle: return n"gun";
      case gamedataItemType.Wea_SubmachineGun: return n"gun";
      case gamedataItemType.Wea_Sword: return n"melee";
      case gamedataItemType.Wea_TwoHandedClub: return n"melee";
    };
    return n"loot";
  }
  public final static func GetItemIconColor(data: ref<gameItemData>) -> CName {
    if data.HasTag(n"RangedWeapon") { return n"MainColors.MildBlue"; }
    if data.HasTag(n"MeleeWeapon") { return n"MainColors.MediumBlue"; }
    if data.HasTag(n"Clothing") { return n"MainColors.MildGreen"; }
    if data.HasTag(n"Consumable") { return n"MainColors.DarkGold"; }
    if data.HasTag(n"Grenade") { return n"MainColors.Green"; }
    if data.HasTag(n"itemPart") && !data.HasTag(n"Fragment") && !data.HasTag(n"SoftwareShard") { return n"MainColors.StreetCred"; }
    if data.HasTag(n"SoftwareShard") || data.HasTag(n"QuickhackCraftingPart") { return n"MainColors.FastTravel"; }
    if data.HasTag(n"Cyberware") || data.HasTag(n"Fragment") { return n"MainColors.MildOrange"; }
    if data.HasTag(n"Junk") { return n"MainColors.Grey"; }
    return n"MainColors.White";
  }
  public final static func GetItemLabelColor(isQuestItem: Bool) -> CName {
    if isQuestItem { 
      return n"MainColors.Yellow"; 
    };
    return n"MainColors.Red";
  }
  public final static func IsEquippable(item: ref<RevisedItemWrapper>, playerPuppet: wref<PlayerPuppet>) -> Bool {
    let data: ref<gameItemData> = item.data;
    let itemID: ItemID = data.GetID();
    let canEquip: Bool = false;
    let equipmentSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(playerPuppet.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    let area: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
    if RevisedBackpackUtils.IsWeapon(area) {
      canEquip = !(StatusEffectSystem.ObjectHasStatusEffectWithTag(playerPuppet, n"VehicleScene") || StatusEffectSystem.ObjectHasStatusEffectWithTag(playerPuppet, n"FirearmsNoSwitch") || InventoryGPRestrictionHelper.BlockedBySceneTier(playerPuppet) || !equipmentSystem.GetPlayerData(playerPuppet).IsEquippable(data));
    } else if RevisedBackpackUtils.IsClothes(area) {
      canEquip = true;
    };
    return canEquip;
  }
  public final static func CanToggleQuestTag(data: ref<gameItemData>) -> Bool {
    let type: gamedataItemType = data.GetItemType();
    return 
      NotEquals(type, gamedataItemType.Gad_Grenade) &&
      NotEquals(type, gamedataItemType.Con_Ammo) &&
      NotEquals(type, gamedataItemType.Con_Edible) &&
      NotEquals(type, gamedataItemType.Con_Inhaler) &&
      NotEquals(type, gamedataItemType.Con_Injector) &&
      NotEquals(type, gamedataItemType.Con_LongLasting) &&
      NotEquals(type, gamedataItemType.Con_Skillbook) &&
      NotEquals(type, gamedataItemType.Gen_MoneyShard) &&
      NotEquals(type, gamedataItemType.Gen_CraftingMaterial) &&
      !InventoryDataManagerV2.IsAttachmentType(type) &&
    true;
  }
  public final static func CanToggleCustomJunk(uiInventoryItem: ref<UIInventoryItem>) -> Bool {
    let data: ref<gameItemData> = uiInventoryItem.GetRealItemData();
    return RevisedBackpackUtils.CanToggleQuestTag(data) 
      && !data.HasTag(n"Junk") 
      && !uiInventoryItem.IsPlayerFavourite() 
      && !uiInventoryItem.IsEquipped() 
      && !uiInventoryItem.IsIconic();
  }
  public final static func CanDisassemble(gi: GameInstance, uiInventoryItem: ref<UIInventoryItem>) -> Bool {
    let canItemBeDisassembled: Bool = RPGManager.CanItemBeDisassembled(gi, uiInventoryItem.GetRealItemData());
    return canItemBeDisassembled
      && !uiInventoryItem.IsPlayerFavourite() 
      && !uiInventoryItem.IsEquipped() 
      && !uiInventoryItem.IsIconic();
  }
  private final static func IsWeapon(type: gamedataEquipmentArea) -> Bool {
    return 
         Equals(type, gamedataEquipmentArea.Weapon) 
      || Equals(type, gamedataEquipmentArea.WeaponHeavy) 
      || Equals(type, gamedataEquipmentArea.WeaponWheel) 
      || Equals(type, gamedataEquipmentArea.WeaponLeft);
  }
  private final static func IsClothes(type: gamedataEquipmentArea) -> Bool {
    return 
       Equals(type, gamedataEquipmentArea.Outfit) 
    || Equals(type, gamedataEquipmentArea.OuterChest) 
    || Equals(type, gamedataEquipmentArea.InnerChest) 
    || Equals(type, gamedataEquipmentArea.Legs) 
    || Equals(type, gamedataEquipmentArea.Feet) 
    || Equals(type, gamedataEquipmentArea.Head) 
    || Equals(type, gamedataEquipmentArea.Face) 
    || Equals(type, gamedataEquipmentArea.UnderwearTop) 
    || Equals(type, gamedataEquipmentArea.UnderwearBottom);
  }
}
