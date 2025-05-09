module CutsceneWeaponSwap

public class CutsceneWeaponSwapper extends ScriptableService {

  private cb func OnLoad() {
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
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(player) {
      return ;
    };

    let pistols: array<gamedataItemType> = [ gamedataItemType.Wea_Handgun, gamedataItemType.Wea_Revolver ];
    let shotgun: array<gamedataItemType> = [ gamedataItemType.Wea_Shotgun ];
    let weaponToDisplay: TweakDBID = this.GetWeaponToDisplay(player, pistols);

    this.HandleCompat(player);

    let path: ResRef = event.GetPath();

    let q001: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q001\\scenes\\q001_04_ripperdoc.scene");
    let q003: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q003\\scenes\\q003_03_deal.scene");
    let q005: Bool = Equals(path, r"base\\quest\\main_quests\\prologue\\q005\\scenes\\q005_02_cab_ride.scene");
    let q103: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q103\\scenes\\q103_14_maelstrom.scene");
    let q104_05: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_05_av_debris.scene");
    let q104_07: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_07b_haru_found.scene");
    let q104_08: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_08_courier_talks.scene");
    let q112: Bool = Equals(path, r"base\\quest\\main_quests\\part1\\q112\\scenes\\q112_11_shotgun.scene");
    let q302: Bool = Equals(path, r"ep1\\quest\\main_quests\\q302\\scenes\\q302_02_spider.scene");
    let q306: Bool = Equals(path, r"ep1\\quest\\main_quests\\q306\\scenes\\q306_10_finale.scene");
    let sts03: Bool = Equals(path, r"ep1\\openworld\\street_stories\\sts_ep1_03\\scenes\\sts_ep1_03_wagner_standoff.scene");

    this.Log(s"> Patching \(ResRef.ToString(path))...");

    if q112 {
      weaponToDisplay = this.GetWeaponToDisplay(player, shotgun);
    };

    if Equals(weaponToDisplay, t"") {
      this.Log(s"No matching weapon found, skip!");
      return ;
    };

    let scene: ref<scnSceneResource> = event.GetResource() as scnSceneResource;

    // Patch props (replace scene.props item with a new one)
    let patchingIndexes: array<Int32>;
    let patchedProps: array<scnPropDef>;
    let propIndex: Int32 = 0;

    for prop in scene.props {

      // The Ripperdoc - ammo counter implant testing
      if q001 && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1281u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // The Pickup - Royce conversation
      if q003 && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // The Heist - Delamain ride to Konpeki
      if q005 && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Ghost Town - Panam negotiations with 6th Street
      if q103 && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 2561u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - negotiating with KangTao pilot
      if q104_05 && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1537u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - Hellman first meet
      if q104_07 && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        let weaponProp: TweakDBID = this.CreateWeaponProp(player, weaponToDisplay);
        weaponToDisplay = weaponProp;
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 1281u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Life During Wartime - Hellman interrogation
      if q104_08 && Equals(prop.specPropRecordId, t"Props.q103_player_gun") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnDespawnProp(prop, 769u, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Search and Destroy - hotel talk
      if q112 && Equals(prop.specPropRecordId, t"Items.Preset_Tactician_Default") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Spider and the Fly (Phantom Liberty) - boss fight
      if q302 && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
        ArrayPush(patchingIndexes, propIndex);
        let patchedProp: scnPropDef = this.PatchSpawnInEntityProp(prop, weaponToDisplay);
        ArrayPush(patchedProps, patchedProp);
      };

      // Gig: The Man Who Killed Jason Foreman (Phantom Liberty) 
      if sts03 && Equals(prop.specPropRecordId, t"Items.Preset_V_Unity_Cutscene") {
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
        this.Log(s"-> patched prop \(indexToPatch): \(TDBID.ToStringDEBUG(scene.props[indexToPatch].specPropRecordId)) -> \(TDBID.ToStringDEBUG(weaponToDisplay))");
        scene.props[indexToPatch] = newProp;
        index += 1;
      };
    };

    // Patch Preset_V_Unity_Cutscene equip nodes
    let questNode: ref<scnQuestNode>;
    let nodeDefinition: ref<questEquipItemNodeDefinition>;
    for node in scene.sceneGraph.graph {
      questNode = node as scnQuestNode;
      if IsDefined(questNode) {
        nodeDefinition = questNode.questNode as questEquipItemNodeDefinition;
        this.PatchQuestEquipItemNodeDefinition(nodeDefinition, weaponToDisplay, q005, q112, q306);
      };
    };
  }

  private final func PatchSpawnInEntityProp(baseProp: scnPropDef, weaponId: TweakDBID) -> scnPropDef {
    let patchedProp: scnPropDef = baseProp;
    patchedProp.findEntityInEntityParams.itemID = weaponId;
    patchedProp.specPropRecordId = weaponId;
    return patchedProp;
  }

  private final func PatchSpawnDespawnProp(baseProp: scnPropDef, performer: Uint32, weaponId: TweakDBID) -> scnPropDef {
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

  private final func PatchQuestEquipItemNodeDefinition(nodeDefinition: ref<questEquipItemNodeDefinition>, weaponId: TweakDBID, isQ005: Bool, isQ112: Bool, isQ306: Bool) -> Void {
    let weaponToCheck: TweakDBID;

    if isQ005 {
      weaponToCheck = t"Items.Preset_V_Unity";
    } else if isQ112 {
      weaponToCheck = t"Items.Preset_Tactician_Default";
    } else if isQ306 {
      weaponToCheck = t"Items.Preset_Overture_Default";
    } else {
      weaponToCheck = t"Items.Preset_V_Unity_Cutscene";
    };

    if IsDefined(nodeDefinition) {
      if Equals(nodeDefinition.params.itemId, weaponToCheck) && Equals(nodeDefinition.params.type, questNodeType.Equip) {
        this.Log(s"-> patched questEquipItemNodeDefinition with \(TDBID.ToStringDEBUG(weaponId))");
        nodeDefinition.params.itemId = weaponId;
      };
    };
  }

  private final func GetWeaponToDisplay(player: ref<PlayerPuppet>, types: array<gamedataItemType>) -> TweakDBID {
    let manager: ref<InventoryDataManagerV2> = new InventoryDataManagerV2();
    manager.Initialize(player);
    
    let pistolLastUsed: TweakDBID = this.GetPlayerWeaponLastUsed(player, types);
    let pistolEquipped: TweakDBID = this.GetPlayerWeaponEquipped(player, manager, types);
    let pistolFromInventory: TweakDBID = this.GetPlayerWeaponInventory(player, manager, types);

    let weaponToDisplay: TweakDBID = t"";
    this.Log(s"Detected weapons: \(TDBID.ToStringDEBUG(pistolEquipped)), \(TDBID.ToStringDEBUG(pistolLastUsed)), \(TDBID.ToStringDEBUG(pistolFromInventory))");

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
    this.Log(s"! Created weapon prop record \(TDBID.ToStringDEBUG(newRecordId)): \(cloned)");
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

  private final func Log(str: String) -> Void {
    // ModLog(n"Swapper", str);
  }
}
