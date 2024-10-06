import Edgerunning.System.EdgerunningSystem
import Edgerunning.Common.E

// Add Neuroblockers on Vik scene
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

// Check if Vik scene completed and neuroblockers not added
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

// Track overclock
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

// Track berserk
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

// Track Sandevistan
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

// Track Kerenzikov
@wrapMethod(KerenzikovEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  EdgerunningSystem.GetInstance(scriptInterface.GetGame()).OnKerenzikovActivation();
}

// Track Camo
@wrapMethod(UseAction)
public func StartAction(gameInstance: GameInstance) -> Void {
  wrappedMethod(gameInstance);
  let data: ref<gameItemData> = this.GetItemData();
  if !IsDefined(data) || !this.m_executor.IsPlayer() {
    return;
  };
  
  let id: TweakDBID = ItemID.GetTDBID(data.GetID());

  // Optical cammo
  if CyberwareHelper.IsOpticalCamo(id) {
    EdgerunningSystem.GetInstance(gameInstance).OnOpticalCamoActivation();
  };
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

// -- CyberwareEx compat

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

// -- Arms cyberware usage
@wrapMethod(RPGManager)
public final static func AwardExperienceFromDamage(hitEvent: ref<gameHitEvent>, damagePercentage: Float) -> Void {
  wrappedMethod(hitEvent, damagePercentage);

  let record: wref<Item_Record>;
  let data: ref<AttackData> = hitEvent.attackData;
  let type: gamedataItemType;
  if data.GetInstigator().IsPlayer() && !hitEvent.target.IsPlayer() {
    record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(data.GetWeapon().GetItemID()));
    type = record.ItemType().Type();
    switch type {
      case gamedataItemType.Cyb_NanoWires:
      case gamedataItemType.Cyb_MantisBlades:
      // case gamedataItemType.Cyb_Launcher:
        EdgerunningSystem.GetInstance(data.GetInstigator().GetGame()).OnArmsCyberwareActivation(type);
        break;
    };
  };
}


// -- Projectile launcher usage
@wrapMethod(LeftHandCyberwareTransition)
public final func DetachProjectile(scriptInterface: ref<StateGameScriptInterface>, opt angleOffset: Float) -> Void {
  wrappedMethod(scriptInterface, angleOffset);
  EdgerunningSystem.GetInstance(scriptInterface.executionOwner.GetGame()).OnArmsCyberwareActivation(gamedataItemType.Cyb_Launcher);
}
