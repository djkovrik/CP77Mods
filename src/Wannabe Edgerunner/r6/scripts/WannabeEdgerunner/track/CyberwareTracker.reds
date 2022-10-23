import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  wrappedMethod(itemID, slotIndex, blockActiveSlotsUpdate, forceEquipWeapon);
  let area: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  let isCyberware: Bool = InventoryDataManagerV2.IsEquipmentAreaCyberware(area);
  if isCyberware {
    EdgerunningSystem.GetInstance(this.m_owner.GetGame()).OnCyberwareInstalled(itemID);
    this.AddNeuroblockersIfVik();
  };
}

@addMethod(EquipmentSystemPlayerData)
private func AddNeuroblockersIfVik() -> Void {
  let journalManager: wref<JournalManager> = GameInstance.GetJournalManager(this.m_owner.GetGame());
  let trackedObjective: wref<JournalQuestObjective> = journalManager.GetTrackedEntry() as JournalQuestObjective;
  let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.m_owner.GetGame());
  let transactionSystem: ref<TransactionSystem>;
  let neuroblockersFact: Int32 = questsSystem.GetFact(n"neuroblockers_added");
  let id: String = trackedObjective.GetId();
  if Equals(id, "install_cyberware") && Equals(neuroblockersFact, 0) {
    transactionSystem = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
    transactionSystem.GiveItemByTDBID(this.m_owner, t"Items.ripperdoc_med_common", 1);
    questsSystem.SetFact(n"neuroblockers_added", 1);
  };
}

@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(itemID: ItemID) -> Void {
  let area: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  let isCyberware: Bool = InventoryDataManagerV2.IsEquipmentAreaCyberware(area);
  wrappedMethod(itemID);
  if isCyberware {
    EdgerunningSystem.GetInstance(this.m_owner.GetGame()).OnCyberwareUninstalled(itemID);
  };
}

@wrapMethod(EquipmentSystemPlayerData)
private final func UnequipItem(equipAreaIndex: Int32, opt slotIndex: Int32) -> Void {
  let itemID: ItemID = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;
  let area: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  let isCyberware: Bool = InventoryDataManagerV2.IsEquipmentAreaCyberware(area);
  wrappedMethod(equipAreaIndex, slotIndex);
  if isCyberware {
    EdgerunningSystem.GetInstance(this.m_owner.GetGame()).OnCyberwareUninstalled(itemID);
  };
}

@wrapMethod(RipperDocGameController)
private final func EquipCyberware(itemData: wref<gameItemData>) -> Void {
  wrappedMethod(itemData);
  EdgerunningSystem.GetInstance(this.m_player.GetGame()).OnCyberwareInstalled(itemData.GetID());
}

@wrapMethod(PlayerPuppet)
private final func ActivateIconicCyberware() -> Void {
  wrappedMethod();

  let item: ItemID;
  if GameInstance.GetStatsSystem(this.GetGame()).GetStatBoolValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.HasBerserk) {
    if !StatusEffectSystem.ObjectHasStatusEffect(this, t"BaseStatusEffect.BerserkPlayerBuff") {
      item = this.GetCurrentBerserk();
      if !ItemID.IsValid(item) {
        return ;
      };
      EdgerunningSystem.GetInstance(this.GetGame()).OnBerserkActivation(item);
    };
  } else {
    if GameInstance.GetStatsSystem(this.GetGame()).GetStatBoolValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.HasSandevistan) {
      if !StatusEffectSystem.ObjectHasStatusEffect(this, t"BaseStatusEffect.SandevistanPlayerBuff") {
        item = this.GetCurrentSandevistan();
        if !ItemID.IsValid(item) {
          return ;
        };
        EdgerunningSystem.GetInstance(this.GetGame()).OnSandevistanActivation(item);
      };
    };
  };
}

@wrapMethod(KerenzikovEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  EdgerunningSystem.GetInstance(scriptInterface.GetGame()).OnKerenzikovActivation();
}

@replaceMethod(InventoryDataManagerV2)
public final static func IsEquipmentAreaCyberware(areaType: gamedataEquipmentArea) -> Bool {
  switch areaType {
    case gamedataEquipmentArea.AbilityCW:
    case gamedataEquipmentArea.NervousSystemCW:
    case gamedataEquipmentArea.MusculoskeletalSystemCW:
    case gamedataEquipmentArea.IntegumentarySystemCW:
    case gamedataEquipmentArea.ImmuneSystemCW:
    case gamedataEquipmentArea.LegsCW:
    case gamedataEquipmentArea.EyesCW:
    case gamedataEquipmentArea.CardiovascularSystemCW:
    case gamedataEquipmentArea.HandsCW:
    case gamedataEquipmentArea.ArmsCW:
    case gamedataEquipmentArea.SystemReplacementCW:
    // added this one
    case gamedataEquipmentArea.FrontalCortexCW:
      return true;
  };
  return false;
}


// Get installed cyberware
@addMethod(EquipmentSystemPlayerData)
public final const func GetCyberwareFromSlots() -> array<ref<Item_Record>> {
  let result: array<ref<Item_Record>>;
  let record: ref<Item_Record>;
  let equipSlots: array<SEquipSlot>;
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
      equipSlots = this.m_equipment.equipAreas[this.GetEquipAreaIndex(slot)].equipSlots;
      i = 0;
      while i < ArraySize(equipSlots) {
        if ItemID.IsValid(equipSlots[i].itemID) {
          record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(equipSlots[i].itemID));
          ArrayPush(result, record);
        };
        i += 1;
      };
    };

  E(s"Detected cyberware: \(ArraySize(result))");
  return result;
}

// -- System-Ex compat

@if(ModuleExists("SystemEx"))
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

@if(ModuleExists("SystemEx"))
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

@if(!ModuleExists("SystemEx"))
@addMethod(PlayerPuppet)
public func GetCurrentBerserk() -> ItemID {
  return EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
}

@if(!ModuleExists("SystemEx"))
@addMethod(PlayerPuppet)
public func GetCurrentSandevistan() -> ItemID {
  return EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
}