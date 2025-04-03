module CutsceneWeaponSwap

public class CutsceneWeaponSwapper extends ScriptableService {

  private cb func OnLoad() {
    GameInstance.GetCallbackSystem()
      .RegisterCallback(n"Resource/PostLoad", this, n"OnSceneLoaded")
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q104\\scenes\\q104_05_av_debris.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\part1\\q110\\scenes\\q110_16b_closing_funeral.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q001\\scenes\\q001_04_ripperdoc.scene"))
      .AddTarget(ResourceTarget.Path(r"base\\quest\\main_quests\\prologue\\q003\\scenes\\q003_03_deal.scene"))
      .AddTarget(ResourceTarget.Path(r"ep1\\quest\\main_quests\\q302\\scenes\\q302_02_spider.scene"));
  }

  private cb func OnSceneLoaded(event: ref<ResourceEvent>) {
    let path: ResRef = event.GetPath();

     this.Log(s"OnSceneLoaded: \(ResRef.ToString(path))");

    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(player) {
      return ;
    };

    this.HandleCompat(player);
    
    let pistolLastUsed: TweakDBID = this.GetPlayerPistolLastUsed(player);
    let pistolEquipped: TweakDBID = this.GetPlayerPistolEquipped(player);
    let pistolFromInventory: TweakDBID = this.GetPlayerPistolFromInventory(player);
    let weaponToDisplay: TweakDBID = t"";
    this.Log(s"Detected weapons: \(TDBID.ToStringDEBUG(pistolEquipped)), \(TDBID.ToStringDEBUG(pistolLastUsed)), \(TDBID.ToStringDEBUG(pistolFromInventory))");

    if NotEquals(pistolLastUsed, t"") {
      weaponToDisplay = pistolLastUsed;
    } else if NotEquals(pistolEquipped, t"") {
      weaponToDisplay = pistolEquipped;
    } else if NotEquals(pistolFromInventory, t"") {
      weaponToDisplay = pistolFromInventory;
    };

    if Equals(weaponToDisplay, t"") {
      return ;
    };

    this.Log(s"> Swap Preset_V_Unity_Cutscene to \(TDBID.ToStringDEBUG(weaponToDisplay))");

    let scene: ref<scnSceneResource> = event.GetResource() as scnSceneResource;
    for prop in scene.props {
      if Equals(prop.specPropRecordId, t"Items.Preset_V_Unity") {
        prop.specPropRecordId = weaponToDisplay;
      };
    };

    let questNode: ref<scnQuestNode>;
    let nodeDefinition: ref<questEquipItemNodeDefinition>;
    for node in scene.sceneGraph.graph {
      questNode = node as scnQuestNode;
      if IsDefined(questNode) {
        nodeDefinition = questNode.questNode as questEquipItemNodeDefinition;
        if IsDefined(nodeDefinition) {
          if Equals(nodeDefinition.params.itemId, t"Items.Preset_V_Unity_Cutscene") {
            nodeDefinition.params.itemId = weaponToDisplay;
          };
        };
      };
    };
  }

  private final func GetPlayerPistolEquipped(player: ref<PlayerPuppet>) -> TweakDBID {
    let manager: ref<InventoryDataManagerV2> = new InventoryDataManagerV2();
    manager.Initialize(player);
    let weapons: array<InventoryItemData> = manager.GetEquippedWeapons();
    for weapon in weapons {
      if this.CanBeUsedForCutscene(InventoryItemData.GetItemType(weapon)) {
        return ItemID.GetTDBID(InventoryItemData.GetID(weapon));
      };
    };
    
    return t"";
  }

  private final func GetPlayerPistolLastUsed(player: ref<PlayerPuppet>) -> TweakDBID {
    let lastUsedItemID: ItemID = EquipmentSystem.GetData(player).GetLastUsedWeaponItemID();
    let itemData: ref<gameItemData> = RPGManager.GetItemData(player.GetGame(), player, lastUsedItemID);
    if this.CanBeUsedForCutscene(itemData.GetItemType()) {
      return ItemID.GetTDBID(lastUsedItemID);
    };

    return t"";
  }

  private final func GetPlayerPistolFromInventory(player: ref<PlayerPuppet>) -> TweakDBID {
    let manager: ref<InventoryDataManagerV2> = new InventoryDataManagerV2();
    manager.Initialize(player);
    let weapons: array<InventoryItemData> = manager.GetPlayerEquipmentAreaInventoryData(gamedataEquipmentArea.Weapon);
    for weapon in weapons {
      let id: TweakDBID = ItemID.GetTDBID(InventoryItemData.GetID(weapon));
      if this.CanBeUsedForCutscene(InventoryItemData.GetItemType(weapon)) && NotEquals(t"Items.Preset_V_Unity", id) && NotEquals(t"Items.Preset_V_Unity_Cutscene", id) {
        return id;
      };
    };
    
    return t"";
  }

  private final func CanBeUsedForCutscene(type: gamedataItemType) -> Bool {
    return Equals(type, gamedataItemType.Wea_Handgun) || Equals(type, gamedataItemType.Wea_Revolver);
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
