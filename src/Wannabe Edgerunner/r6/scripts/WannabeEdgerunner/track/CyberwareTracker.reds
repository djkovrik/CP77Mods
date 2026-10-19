import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@addField(PlayerPuppet)
private let neuroblockersFactListener: Uint32;

@wrapMethod(PlayerPuppet)
private final func RegisterInterestingFactsListeners() -> Void {
  wrappedMethod();
  this.neuroblockersFactListener = GameInstance.GetQuestsSystem(this.GetGame()).RegisterListener(n"q001_hide_ammo_counter", this, n"OnNeuroblockersFactChanged");
}

@wrapMethod(PlayerPuppet)
private final func UnregisterInterestingFactsListeners() -> Void {
  GameInstance.GetQuestsSystem(this.GetGame()).UnregisterListener(n"q001_hide_ammo_counter", this.neuroblockersFactListener);
  wrappedMethod();
}

@addMethod(PlayerPuppet)
public final func OnNeuroblockersFactChanged(val: Int32) -> Void {
  let transactionSystem: ref<TransactionSystem>;
  let questsSystem: ref<QuestsSystem>;
  if val == 0 {
    transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
    questsSystem = GameInstance.GetQuestsSystem(this.GetGame());
    transactionSystem.GiveItemByTDBID(this, t"Items.ripperdoc_med_common", 1);
    questsSystem.SetFact(n"vik_neuroblockers_added", 1);
  };
}

@wrapMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  wrappedMethod(evt);

  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
  let transactionSystem: ref<TransactionSystem>;
  let tutorialFact: Int32 = questsSystem.GetFact(n"q001_hide_ammo_counter");
  let neuroblockersFact: Int32 = questsSystem.GetFact(n"vik_neuroblockers_added");

  if Equals(tutorialFact, 0) && Equals(neuroblockersFact, 0) {
    transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
    transactionSystem.GiveItemByTDBID(this, t"Items.ripperdoc_med_common", 1);
    questsSystem.SetFact(n"vik_neuroblockers_added", 1);
  };
}

@wrapMethod(PlayerPuppet)
  protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
    let gameplayTags: array<CName> = evt.staticData.GameplayTags();
    if ArrayContains(gameplayTags, n"Overclock") {
      let itemRecord: ref<Item_Record>;
      if IsDefined(this) && EquipmentSystem.IsCyberdeckEquipped(this) {
        let systemReplacementID: ItemID = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
        itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(systemReplacementID));
        EdgerunningSystem.GetInstance(this.GetGame()).OnOverClockActivation(itemRecord);
      };
  };
  wrappedMethod(evt);
}

@wrapMethod(UseBerserkAction)
public func StartAction(gameInstance: GameInstance) -> Void {
  wrappedMethod(gameInstance);

  let playerPuppet: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
  let item: ItemID;
  if IsDefined(playerPuppet) {
    item = playerPuppet.GetCurrentBerserk();
    EdgerunningSystem.GetInstance(gameInstance).OnBerserkActivation(item);
  };
}

@wrapMethod(UseSandevistanAction)
public func StartAction(gameInstance: GameInstance) -> Void {
  wrappedMethod(gameInstance);
  let playerPuppet: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
  let item: ItemID;
  if IsDefined(playerPuppet) {
    item = playerPuppet.GetCurrentSandevistan();
    EdgerunningSystem.GetInstance(gameInstance).OnSandevistanActivation(item);
  };
}

@wrapMethod(KerenzikovEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  EdgerunningSystem.GetInstance(scriptInterface.GetGame()).OnKerenzikovActivation();
}

@wrapMethod(UseAction)
public func StartAction(gameInstance: GameInstance) -> Void {
  wrappedMethod(gameInstance);
  let data: ref<gameItemData> = this.GetItemData();
  if !IsDefined(data) || !this.m_executor.IsPlayer() {
    return;
  };
  
  let id: TweakDBID = ItemID.GetTDBID(data.GetID());

  if CyberwareHelper.IsOpticalCamo(id) {
    EdgerunningSystem.GetInstance(gameInstance).OnOpticalCamoActivation();
  };

  if CyberwareHelper.IsBloodPump(id) {
    EdgerunningSystem.GetInstance(gameInstance).OnBloodPumpActivation();
  };
}

@wrapMethod(InventoryDataManagerV2)
public final static func IsEquipmentAreaCyberware(areaType: gamedataEquipmentArea) -> Bool {
  let original: Bool = wrappedMethod(areaType);
  return original || Equals(areaType, gamedataEquipmentArea.FrontalCortexCW);
}

@addMethod(EquipmentSystemPlayerData)
public final func GetCyberwareFromSlots() -> array<ref<Item_Record>> {
  let result: array<ref<Item_Record>>;
  let record: ref<Item_Record>;
  let equipSlots: array<SEquipSlot>;
  let equipAreaIndex: Int32;
  let i: Int32;

  for slot in [
      gamedataEquipmentArea.FrontalCortexCW,
      gamedataEquipmentArea.SystemReplacementCW,
      gamedataEquipmentArea.EyesCW,
      gamedataEquipmentArea.MusculoskeletalSystemCW,
      gamedataEquipmentArea.NervousSystemCW,
      gamedataEquipmentArea.CardiovascularSystemCW,
      gamedataEquipmentArea.ImmuneSystemCW,
      gamedataEquipmentArea.IntegumentarySystemCW,
      gamedataEquipmentArea.HandsCW,
      gamedataEquipmentArea.ArmsCW,
      gamedataEquipmentArea.LegsCW
    ] {
      equipAreaIndex = this.GetEquipAreaIndex(slot);
      ArrayClear(equipSlots);
      if equipAreaIndex < 0 || equipAreaIndex >= ArraySize(this.m_equipment.equipAreas) {
        E(s"Skip cyberware slot \(slot): equip area index \(equipAreaIndex) is not valid");
      } else {
        equipSlots = this.m_equipment.equipAreas[equipAreaIndex].equipSlots;
      };
      i = 0;
      while i < ArraySize(equipSlots) {
        if ItemID.IsValid(equipSlots[i].itemID) {
          record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(equipSlots[i].itemID));
          if IsDefined(record) {
            ArrayPush(result, record);
          };
        };
        i += 1;
      };
    };

  E(s"Detected cyberware: \(ArraySize(result))");
  return result;
}


@if(ModuleExists("CyberwareEx"))
@addMethod(PlayerPuppet)
public func GetCurrentBerserk() -> ItemID {
  let cyberware: array<ref<Item_Record>> = EquipmentSystem.GetData(this).GetCyberwareFromSlots();
  let tags: array<CName> = [ n"Berserk" ];
  let result: ItemID;
  let id: ItemID;
  for record in cyberware {
    id = ItemID.FromTDBID(record.GetID());
    if EquipmentSystem.GetData(this).CheckTagsInItem(id, tags) {
      result = id;
    };
  };

  return result;
}

@if(ModuleExists("CyberwareEx"))
@addMethod(PlayerPuppet)
public func GetCurrentSandevistan() -> ItemID {
  let cyberware: array<ref<Item_Record>> = EquipmentSystem.GetData(this).GetCyberwareFromSlots();
  let tags: array<CName> = [ n"Sandevistan" ];
  let result: ItemID;
  let id: ItemID;
  for record in cyberware {
    id = ItemID.FromTDBID(record.GetID());
    if EquipmentSystem.GetData(this).CheckTagsInItem(id, tags) {
      result = id;
    };
  };

  return result;
}

@if(!ModuleExists("CyberwareEx"))
@addMethod(PlayerPuppet)
public func GetCurrentBerserk() -> ItemID {
  return EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
}

@if(!ModuleExists("CyberwareEx"))
@addMethod(PlayerPuppet)
public func GetCurrentSandevistan() -> ItemID {
  return EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
}

// Damage/XP callbacks fan out over targets and must never be the billing unit.
@wrapMethod(MeleeAttackGenericEvents)
protected final func SpawnAttackGameEffect(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, startPosition: Vector4, middlePosition: Vector4, endPosition: Vector4, time: Float, colliderBox: Vector4, attackData: ref<MeleeAttackData>) -> Bool {
  let success: Bool = wrappedMethod(stateContext, scriptInterface, startPosition, middlePosition, endPosition, time, colliderBox, attackData);
  if !success || !IsDefined(scriptInterface.executionOwner as PlayerPuppet) { return success; };
  let weapon: ref<WeaponObject> = scriptInterface.owner as WeaponObject;
  if !IsDefined(weapon) { return success; };
  let record: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(weapon.GetItemID()));
  if !IsDefined(record) { return success; };
  let type: gamedataItemType = record.ItemType().Type();
  if Equals(type, gamedataItemType.Cyb_NanoWires) || Equals(type, gamedataItemType.Cyb_MantisBlades) {
    EdgerunningSystem.GetInstance(scriptInterface.GetGame()).OnArmsCyberwareAttack(type, record);
  };
  return success;
}


@wrapMethod(LeftHandCyberwareTransition)
public final func DetachProjectile(scriptInterface: ref<StateGameScriptInterface>, opt angleOffset: Float) -> Void {
  wrappedMethod(scriptInterface, angleOffset);
  EdgerunningSystem.GetInstance(scriptInterface.executionOwner.GetGame()).OnArmsCyberwareActivation(gamedataItemType.Cyb_Launcher);
}
