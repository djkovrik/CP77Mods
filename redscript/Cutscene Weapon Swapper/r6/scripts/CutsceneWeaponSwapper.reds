module CutsceneWeaponSwap

public class CutsceneWeaponDrawContext extends IScriptable {
  public let path: ResRef;
  public let weapon: TweakDBID;
}

public class CutsceneWeaponSwapper extends ScriptableService {

  private let singleDrawPlayer: wref<PlayerPuppet>;
  private let singleDrawContexts: array<ref<CutsceneWeaponDrawContext>>;

  public static func Get() -> ref<CutsceneWeaponSwapper> {
    return GameInstance.GetScriptableServiceContainer().GetService(n"CutsceneWeaponSwap.CutsceneWeaponSwapper") as CutsceneWeaponSwapper;
  }

  private cb func OnSessionEnd(event: ref<GameSessionEvent>) {
    this.singleDrawPlayer = null;
    ArrayClear(this.singleDrawContexts);
  }

  public func FindSingleDrawContext(owner: ref<GameObject>, record: TweakDBID) -> ref<CutsceneWeaponDrawContext> {
    if !IsDefined(this.singleDrawPlayer) || this.singleDrawPlayer != owner { return null; };
    if GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerMainGameObject() != owner { return null; };
    let index: Int32 = ArraySize(this.singleDrawContexts) - 1;
    while index >= 0 {
      if Equals(this.singleDrawContexts[index].weapon, record) { return this.singleDrawContexts[index]; };
      index -= 1;
    };
    return null;
  }

  private func RemoveSingleDrawContext(path: ResRef) -> Void {
    let index: Int32 = ArraySize(this.singleDrawContexts) - 1;
    while index >= 0 {
      if Equals(this.singleDrawContexts[index].path, path) { ArrayErase(this.singleDrawContexts, index); };
      index -= 1;
    };
  }

  private cb func OnLoad() {
    GameInstance.GetCallbackSystem().RegisterCallback(n"Session/End", this, n"OnSessionEnd");
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/PostLoad", this, n"OnSceneLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q103\\scenes\\q103_14_maelstrom.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_05_av_debris.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_07b_haru_found.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_08_courier_talks.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q110\\scenes\\q110_16b_closing_funeral.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q112\\scenes\\q112_11_shotgun.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q001\\scenes\\q001_04_ripperdoc.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q003\\scenes\\q003_03_deal.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q005\\scenes\\q005_02_cab_ride.scene"))
      .AddTarget(ResourceTarget.Path(r"ep1\\quest\\main_quests\\q302\\scenes\\q302_02_spider.scene"))
      .AddTarget(ResourceTarget.Path(r"ep1\\quest\\main_quests\\q306\\scenes\\q306_10_finale.scene"))
      .AddTarget(ResourceTarget.Path(r"ep1\\openworld\\street_stories\\sts_ep1_03\\scenes\\sts_ep1_03_wagner_standoff.scene"));
  }

  private cb func OnSceneLoaded(event: ref<ResourceEvent>) {
    let scenePath: ResRef = event.GetPath();
    this.RemoveSingleDrawContext(scenePath);
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(player) {
      return ;
    };

    if this.singleDrawPlayer != player {
      ArrayClear(this.singleDrawContexts);
      this.singleDrawPlayer = player;
    };

    let pistols: array<gamedataItemType> = [ gamedataItemType.Wea_Handgun, gamedataItemType.Wea_Revolver ];
    let shotgun: array<gamedataItemType> = [ gamedataItemType.Wea_Shotgun ];
    let weaponToDisplay: TweakDBID;
    if Equals(scenePath, r"base\\quest\\main_quests\\part1\\q112\\scenes\\q112_11_shotgun.scene") {
      weaponToDisplay = this.GetWeaponToDisplay(player, shotgun);
    } else {
      weaponToDisplay = this.GetWeaponToDisplayRightFirst(player, pistols);
    };

    this.HandleCompat(player);

    let path: ResRef = event.GetPath();

    let q001: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q001\\scenes\\q001_04_ripperdoc.scene");
    let q003: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q003\\scenes\\q003_03_deal.scene");
    let q005: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q005\\scenes\\q005_02_cab_ride.scene");
    let q103: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q103\\scenes\\q103_14_maelstrom.scene");
    let q104_05: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_05_av_debris.scene");
    let q104_07: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_07b_haru_found.scene");
    let q104_08: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_08_courier_talks.scene");
    let q110: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q110\\scenes\\q110_16b_closing_funeral.scene");
    let q112: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q112\\scenes\\q112_11_shotgun.scene");
    let q302: Bool = Equals(path, r"ep1\\quest\\main_quests\\q302\\scenes\\q302_02_spider.scene");
    let q306: Bool = Equals(path, r"ep1\\quest\\main_quests\\q306\\scenes\\q306_10_finale.scene");
    let sts03: Bool = Equals(path, r"ep1\\openworld\\street_stories\\sts_ep1_03\\scenes\\sts_ep1_03_wagner_standoff.scene");

    if Equals(weaponToDisplay, t"") {
      return ;
    };

    let scene: ref<scnSceneResource> = event.GetResource() as scnSceneResource;
    if !IsDefined(scene) || !IsDefined(scene.sceneGraph) { return; };

    // Patch props (replace scene.props item with a new one)
    let patchingIndexes: array<Int32>;
    let patchedProps: array<scnPropDef>;
    let propIndex: Int32 = 0;

    for prop in scene.props {

      // The Ripperdoc - ammo counter implant testing
      if q001 && (prop.propId.id == 3u || prop.propId.id == 16u) && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1281u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // The Pickup - Royce conversation
      if q003 && prop.propId.id == 6u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // The Heist - Delamain ride to Konpeki
      if q005 && prop.propId.id == 5u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Ghost Town - Panam negotiations with 6th Street
      if q103 && prop.propId.id == 2u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 2561u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - negotiating with KangTao pilot
      if q104_05 && prop.propId.id == 0u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1537u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - Hellman first meet
      if q104_07 && prop.propId.id == 0u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        let weaponProp: TweakDBID = this.CreateWeaponProp(player, weaponToDisplay);
        weaponToDisplay = weaponProp;
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1281u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - Hellman interrogation
      if q104_08 && prop.propId.id == 3u && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 769u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Search and Destroy - hotel talk
      if q112 && prop.propId.id == 4u && Equals(prop.specPropRecordId, t"Items.Preset_Tactician_Default") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Spider and the Fly (Phantom Liberty) - boss fight
      if q302 && prop.propId.id == 15u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Gig: The Man Who Killed Jason Foreman (Phantom Liberty) 
      if sts03 && prop.propId.id == 2u && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      propIndex += 1;
    };

    let patchedPropsCount: Int32 = ArraySize(patchedProps);
    let patchingIndexesCount: Int32 = ArraySize(patchingIndexes);
    if NotEquals(patchedPropsCount, 0) && Equals(patchedPropsCount, patchingIndexesCount) {
      let index: Int32 = 0;
      while index < patchingIndexesCount {
        let newProp: scnPropDef = patchedProps[index];
        let indexToPatch: Int32 = patchingIndexes[index];
        scene.props[indexToPatch] = newProp;
        index += 1;
      };
    };

    let equipIds: array<Int32>;
    let unequipIds: array<Int32>;
    let hasEquip: Bool = false;
    if q001 {
      equipIds = [2493];
      unequipIds = [2497];
    };
    if q003 {
      equipIds = [7521, 8704, 10191];
      unequipIds = [10186];
    };
    if q005 {
      equipIds = [1899];
      unequipIds = [1901];
    };
    if q104_05 {
      equipIds = [4739];
    };
    if q110 {
      equipIds = [141];
    };
    if q112 {
      equipIds = [1139];
      unequipIds = [2509];
    };
    if q302 {
      equipIds = [4690, 10573];
      unequipIds = [630];
    };
    if q306 {
      equipIds = [5429];
    };
    if sts03 {
      equipIds = [2290];
    };
    let questNode: ref<scnQuestNode>;
    let nodeDefinition: ref<questEquipItemNodeDefinition>;
    for node in scene.sceneGraph.graph {
      questNode = node as scnQuestNode;
      if IsDefined(questNode) {
        nodeDefinition = questNode.questNode as questEquipItemNodeDefinition;
        if this.PatchQuestEquipItemNodeDefinition(nodeDefinition, weaponToDisplay, equipIds, unequipIds, q005, q112, q306, q110) {
          hasEquip = true;
        };
      };
    };
    if hasEquip && !q112 {
      let context: ref<CutsceneWeaponDrawContext> = new CutsceneWeaponDrawContext();
      context.path = path;
      context.weapon = weaponToDisplay;
      ArrayPush(this.singleDrawContexts, context);
    };
  }

  private final func PatchSpawnInEntityProp(baseProp: scnPropDef, weaponId: TweakDBID) -> scnPropDef {
    if NotEquals(ToString(baseProp.entityAcquisitionPlan), "findInEntity") {
      return baseProp;
    };
    let patchedProp: scnPropDef = baseProp;
    patchedProp.findEntityInEntityParams.itemID = weaponId;
    patchedProp.specPropRecordId = weaponId;
    return patchedProp;
  }

  private final func PatchSpawnDespawnProp(baseProp: scnPropDef, performer: Uint32, weaponId: TweakDBID) -> scnPropDef {
    if NotEquals(ToString(baseProp.entityAcquisitionPlan), "spawnDespawn") {
      return baseProp;
    };
    let performerId: scnPerformerId;
    performerId.id = performer;
    let patchedProp: scnPropDef = baseProp;
    patchedProp.spawnDespawnParams.findInWorld = true;
    patchedProp.spawnDespawnParams.forceMaxVisibility = true;
    patchedProp.spawnDespawnParams.itemOwnerId = performerId;
    patchedProp.spawnDespawnParams.specRecordId = weaponId;
    patchedProp.specPropRecordId = weaponId;
    return patchedProp;
  }

  private final func PatchQuestEquipItemNodeDefinition(nodeDefinition: ref<questEquipItemNodeDefinition>, weaponId: TweakDBID, equipIds: array<Int32>, unequipIds: array<Int32>, isQ005: Bool, isQ112: Bool, isQ306: Bool, isQ110: Bool) -> Bool {
    if !IsDefined(nodeDefinition) || !IsDefined(nodeDefinition.params) || !nodeDefinition.params.isPlayer { return false; };
    let expected: TweakDBID = t"Items.Preset_V_Unity_Cutscene";
    if isQ005 { expected = t"Items.Preset_V_Unity"; };
    if isQ112 { expected = t"Items.Preset_Tactician_Default"; };
    if isQ306 { expected = t"Items.Preset_Overture_Default"; };
    if NotEquals(nodeDefinition.params.itemId, expected) && NotEquals(nodeDefinition.params.itemId, weaponId) { return false; };
    let id: Int32 = Cast<Int32>(nodeDefinition.id);
    if Equals(nodeDefinition.params.type, questNodeType.Equip) && ArrayContains(equipIds, id) {
      if !nodeDefinition.params.byItem {
        if !isQ110 || NotEquals(ToString(nodeDefinition.params.equipTypes), "LastUsedRangedWeapon") { return false; };
        nodeDefinition.params.byItem = true;
      };
      nodeDefinition.params.itemId = weaponId;
      return true;
    };
    if Equals(nodeDefinition.params.type, questNodeType.Unequip) && nodeDefinition.params.byItem && ArrayContains(unequipIds, id) {
      nodeDefinition.params.itemId = weaponId;
    };
    return false;
  }

  private final func GetWeaponToDisplayRightFirst(player: ref<PlayerPuppet>, types: array<gamedataItemType>) -> TweakDBID {
    let slot: Int32;
    let item: ItemID = EquipmentSystem.GetData(player).CutsceneWeaponGetActiveRightItem(slot);
    let data: wref<gameItemData>;
    let selected: TweakDBID = t"";
    let accepted: Bool = false;
    let manager: ref<InventoryDataManagerV2>;
    if ItemID.IsValid(item) {
      data = RPGManager.GetItemData(player.GetGame(), player, item);
      if IsDefined(data) {
        accepted = ArrayContains(types, data.GetItemType());
      };
    };
    if accepted {
      selected = ItemID.GetTDBID(item);
    } else {
      selected = this.GetPlayerWeaponLastUsed(player, types);
      if Equals(selected, t"") {
        manager = new InventoryDataManagerV2();
        manager.Initialize(player);
        selected = this.GetPlayerWeaponInventory(player, manager, types);
        manager.UnInitialize();
      };
    };
    return selected;
  }

  private final func GetWeaponToDisplay(player: ref<PlayerPuppet>, types: array<gamedataItemType>) -> TweakDBID {
    let manager: ref<InventoryDataManagerV2> = new InventoryDataManagerV2();
    manager.Initialize(player);
    
    let pistolLastUsed: TweakDBID = this.GetPlayerWeaponLastUsed(player, types);
    let pistolEquipped: TweakDBID = this.GetPlayerWeaponEquipped(player, manager, types);
    let pistolFromInventory: TweakDBID = this.GetPlayerWeaponInventory(player, manager, types);

    let weaponToDisplay: TweakDBID = t"";

    if NotEquals(pistolLastUsed, t"") {
      weaponToDisplay = pistolLastUsed;
    } else if NotEquals(pistolEquipped, t"") {
      weaponToDisplay = pistolEquipped;
    } else if NotEquals(pistolFromInventory, t"") {
      weaponToDisplay = pistolFromInventory;
    };

    manager.UnInitialize();
    return weaponToDisplay;
  }

  private final func GetPlayerWeaponEquipped(player: ref<PlayerPuppet>, manager: ref<InventoryDataManagerV2>, types: array<gamedataItemType>) -> TweakDBID {
    let weapons: array<InventoryItemData> = manager.GetEquippedWeapons();
    let type: gamedataItemType;
    for weapon in weapons {
      type = InventoryItemData.GetItemType(weapon);
      if ArrayContains(types, type) {
        return ItemID.GetTDBID(InventoryItemData.GetID(weapon));
      };
    };
    
    return t"";
  }

  private final func GetPlayerWeaponLastUsed(player: ref<PlayerPuppet>, types: array<gamedataItemType>) -> TweakDBID {
    let lastUsedItemID: ItemID = EquipmentSystem.GetData(player).GetLastUsedWeaponItemID();
    let itemData: ref<gameItemData> = RPGManager.GetItemData(player.GetGame(), player, lastUsedItemID);
    if !IsDefined(itemData) { return t""; };
    let type: gamedataItemType = itemData.GetItemType();
    if ArrayContains(types, type) {
      return ItemID.GetTDBID(lastUsedItemID);
    };

    return t"";
  }

  private final func GetPlayerWeaponInventory(player: ref<PlayerPuppet>, manager: ref<InventoryDataManagerV2>, types: array<gamedataItemType>) -> TweakDBID {
    let weapons: array<InventoryItemData> = manager.GetPlayerEquipmentAreaInventoryData(gamedataEquipmentArea.Weapon);
    let type: gamedataItemType;
    for weapon in weapons {
      let id: TweakDBID = ItemID.GetTDBID(InventoryItemData.GetID(weapon));
      type = InventoryItemData.GetItemType(weapon);
      if ArrayContains(types, type) && NotEquals(t"Items.Preset_V_Unity", id) && NotEquals(t"Items.Preset_V_Unity_Cutscene", id) {
        return id;
      };
    };
    
    return t"";
  }

  private final func CreateWeaponProp(player: ref<PlayerPuppet>, base: TweakDBID) -> TweakDBID {
    let newRecordId: TweakDBID = base + t"_Prop";
    let cloned: Bool = TweakDBManager.CloneRecord(newRecordId, base);
    let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(newRecordId);
    let tags: array<CName> = record.Tags();
    ArrayPush(tags, n"HideInUI");
    ArrayPush(tags, n"SkipActivityLog");
    TweakDBManager.SetFlat(newRecordId + t".tags", ToVariant(tags));
    TweakDBManager.UpdateRecord(newRecordId);
    let ts: ref<TransactionSystem>;
    if cloned {
      ts = GameInstance.GetTransactionSystem(player.GetGame());
      ts.GiveItemByTDBID(player, newRecordId, 1);
    };
    return newRecordId;
  }

  @if(!ModuleExists("AlwaysFirstEquip"))
  private final func HandleCompat(player: ref<PlayerPuppet>) -> Void {
    // do nothing
  }

  @if(ModuleExists("AlwaysFirstEquip"))
  private final func HandleCompat(player: ref<PlayerPuppet>) -> Void {
    player.SetSkipFirstEquipEQ(true);
  }

}

@addField(EquipmentSystemPlayerData)
private let cutsceneWeaponSingleDraw: Bool;

@addField(EquipmentSystemPlayerData)
private let cutsceneWeaponDrawItem: ItemID;

@addMethod(EquipmentSystemPlayerData)
public final func CutsceneWeaponGetActiveRightItem(out slot: Int32) -> ItemID {
  let area: Int32 = this.GetEquipAreaIndex(gamedataEquipmentArea.Weapon);
  slot = -1;
  if area < 0 || area >= ArraySize(this.m_equipment.equipAreas) { return ItemID.None(); };
  slot = this.m_equipment.equipAreas[area].activeIndex;

  if slot < 0 || slot > 2 || slot >= ArraySize(this.m_equipment.equipAreas[area].equipSlots) { return ItemID.None(); };
  return this.m_equipment.equipAreas[area].equipSlots[slot].itemID;
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnDrawItemRequest(request: ref<DrawItemRequest>) -> Void {
  let service: ref<CutsceneWeaponSwapper> = CutsceneWeaponSwapper.Get();
  let selectedRecord: TweakDBID;
  let context: ref<CutsceneWeaponDrawContext>;
  if IsDefined(service) && IsDefined(request) {
    context = service.FindSingleDrawContext(this.m_owner, ItemID.GetTDBID(request.itemID));
    if IsDefined(context) {
      selectedRecord = context.weapon;
    };
  };
  let previousSingleDraw: Bool = this.cutsceneWeaponSingleDraw;
  let previousDrawItem: ItemID = this.cutsceneWeaponDrawItem;
  let originalItem: ItemID;
  let resolvedItem: ItemID;
  let normalizationItem: ItemID;
  let rightItem: ItemID;
  let rightSlot: Int32;
  let itemData: wref<gameItemData>;
  let normalized: Bool = false;
  let tier: Int32;
  let query: Bool;
  let selected: Bool;

  this.cutsceneWeaponSingleDraw = false;
  this.cutsceneWeaponDrawItem = ItemID.None();
  if IsDefined(request) && NotEquals(selectedRecord, t"") {
    tier = PlayerPuppet.GetSceneTier(this.m_owner as PlayerPuppet);
    query = ItemID.IsQuery(request.itemID);
    selected = ItemID.IsValid(request.itemID) && Equals(ItemID.GetTDBID(request.itemID), selectedRecord);
    if tier >= 3 && query && selected {
      originalItem = request.itemID;
      normalizationItem = originalItem;
      rightItem = this.CutsceneWeaponGetActiveRightItem(rightSlot);
      if ItemID.IsValid(rightItem) && !ItemID.IsQuery(rightItem) && Equals(ItemID.GetTDBID(rightItem), selectedRecord) {
        normalizationItem = rightItem;
      };
      itemData = GameInstance.GetTransactionSystem(this.m_owner.GetGame()).GetItemData(this.m_owner, normalizationItem);
      if IsDefined(itemData) {
        resolvedItem = itemData.GetID();
        normalized = ItemID.IsValid(resolvedItem) && !ItemID.IsQuery(resolvedItem) && Equals(ItemID.GetTDBID(resolvedItem), selectedRecord);
        if !ItemID.IsQuery(normalizationItem) {
          normalized = normalized && resolvedItem == normalizationItem;
        };
      };
      if normalized {
        request.itemID = resolvedItem;
        this.cutsceneWeaponDrawItem = resolvedItem;
        this.cutsceneWeaponSingleDraw = true;
      };
    };
  };
  wrappedMethod(request);
  if normalized {
    request.itemID = originalItem;
  };
  this.cutsceneWeaponSingleDraw = previousSingleDraw;
  this.cutsceneWeaponDrawItem = previousDrawItem;
}

@wrapMethod(EquipmentSystemPlayerData)
public final func GetItemIDfromEquipmentManipulationAction(eqManipulationAction: EquipmentManipulationAction, currentState: SSlotActiveItems) -> SSlotActiveItems {
  let result: SSlotActiveItems = wrappedMethod(eqManipulationAction, currentState);
  let leftRecord: ref<Item_Record>;
  if this.cutsceneWeaponSingleDraw && Equals(eqManipulationAction, EquipmentManipulationAction.RequestSlotActiveWeapon) {
    if ItemID.IsValid(result.rightHandItem) && !ItemID.IsQuery(result.rightHandItem) && result.rightHandItem == this.cutsceneWeaponDrawItem && ItemID.IsValid(result.leftHandItem) {
      leftRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(result.leftHandItem));
      if IsDefined(leftRecord) && IsDefined(leftRecord.ItemCategory()) && Equals(leftRecord.ItemCategory().Type(), gamedataItemCategory.Weapon) && !WeaponObject.IsCyberwareWeapon(result.leftHandItem) {
        result.leftHandItem = ItemID.None();
      };
    };
  };
  return result;
}

