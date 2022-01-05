// -- Determines what equipment slots should have hidden gear

// -- To hide gear for chosen slot just uncomment slot line
//    (by removing that doubled slash symbol from the start of the line)
public static func ShouldHideItem_HG(itemId: ItemID) -> Bool {
  let equipArea: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemId);

  return
    Equals(equipArea, gamedataEquipmentArea.Head) || 
    // Equals(equipArea, gamedataEquipmentArea.Face) ||
    // Equals(equipArea, gamedataEquipmentArea.Feet) || 
    // Equals(equipArea, gamedataEquipmentArea.Legs) || 
    // Equals(equipArea, gamedataEquipmentArea.InnerChest) || 
    // Equals(equipArea, gamedataEquipmentArea.OuterChest) || 
  false;
}

// -- Do not edit anything below


// --- CUSTOM EVENTS

public class ClearHeadGearSlotEvent extends Event {}

public class ReequipHeadGearSlotEvent extends Event {}


// [PlayerPuppet]

@addMethod(PlayerPuppet)
protected cb func OnClearHeadGearSlotEvent(evt: ref<ClearHeadGearSlotEvent>) -> Bool {
  EquipmentSystem.GetData(GetPlayer(this.GetGame())).OnClearHeadSlot(evt);
}

@addMethod(PlayerPuppet)
protected cb func OnReequipHeadSlotEvent(evt: ref<ReequipHeadGearSlotEvent>) -> Bool {
  EquipmentSystem.GetData(GetPlayer(this.GetGame())).OnReequipHeadSlot(evt);
}


// [EquipmentSystemPlayerData]

@addMethod(EquipmentSystemPlayerData)
public func OnClearHeadSlot(evt: ref<ClearHeadGearSlotEvent>) -> Void {
  // Clear head item slot to fix TPP hair displaying
  GameInstance.GetTransactionSystem(this.m_owner.GetGame()).RemoveItemFromSlot(this.m_owner, t"AttachmentSlots.Head");
}

@addMethod(EquipmentSystemPlayerData)
public func OnReequipHeadSlot(evt: ref<ReequipHeadGearSlotEvent>) -> Void {
  let headItem: ItemID = this.GetActiveItem(gamedataEquipmentArea.Head);
  let slotIndex: Int32 = this.GetSlotIndex(headItem);
  let unequipRequest: ref<UnequipRequest>;
  let equipRrequest: ref<EquipRequest>;

  if ShouldHideItem_HG(headItem) {
    unequipRequest = new UnequipRequest();
    unequipRequest.slotIndex = slotIndex;
    unequipRequest.areaType = gamedataEquipmentArea.Head;
    this.OnUnequipRequest(unequipRequest);

    equipRrequest = new EquipRequest();
    equipRrequest.itemID = headItem;
    equipRrequest.slotIndex = slotIndex;
    this.OnEquipRequest(equipRrequest);
  };
}

// Additional hack to force items hidden state
@replaceMethod(EquipmentSystemPlayerData)
public final func IsItemHidden(id: ItemID) -> Bool {
  return ArrayContains(this.m_hiddenItems, id) || ShouldHide_HG(id);
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipProcessVisualTags(itemID: ItemID) -> Void {
  wrappedMethod(itemID);

  // Check and clear
  let areaType_HG: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  if ShouldHide_HG(itemID) {
    this.ClearItemAppearanceEvent(areaType_HG);
  };
}

// Hack EquipItem calls to prevent inventory preview item disappearing
@replaceMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt addToInventory: Bool, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  let audioEventFoley: ref<AudioEvent>;
  let audioEventFootwear: ref<AudioEvent>;
  let currentItem: ItemID;
  let currentItemData: wref<gameItemData>;
  let cyberwareType: CName;
  let equipArea: SEquipArea;
  let equipAreaIndex: Int32;
  let i: Int32;
  let paperdollEquipData: SPaperdollEquipData;
  let placementSlot: TweakDBID;
  let transactionSystem: ref<TransactionSystem>;
  let weaponRecord: ref<WeaponItem_Record>;
  let itemData: wref<gameItemData> = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, itemID);
  if !this.IsEquippable(itemData) {
    return;
  };
  if Equals(RPGManager.GetItemRecord(itemID).ItemType().Type(), gamedataItemType.Cyb_StrongArms) {
    this.HandleStrongArmsEquip(itemID);
  };
  equipAreaIndex = this.GetEquipAreaIndex(EquipmentSystem.GetEquipAreaType(itemID));
  equipArea = this.m_equipment.equipAreas[equipAreaIndex];
  currentItem = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;
  currentItemData = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, currentItem);
  if IsDefined(currentItemData) && currentItemData.HasTag(n"UnequipBlocked") {
    return;
  };
  if this.IsItemOfCategory(itemID, gamedataItemCategory.Weapon) && equipArea.activeIndex == slotIndex && this.CheckWeaponAgainstGameplayRestrictions(itemID) && !blockActiveSlotsUpdate {
    this.SetSlotActiveItem(EquipmentManipulationRequestSlot.Right, itemID);
    this.SetLastUsedItem(itemID);
  } else {
    if this.IsItemOfCategory(itemID, gamedataItemCategory.Weapon) && forceEquipWeapon && this.CheckWeaponAgainstGameplayRestrictions(itemID) {
      this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = itemID;
      this.SetSlotActiveItem(EquipmentManipulationRequestSlot.Right, itemID);
      this.UpdateEquipAreaActiveIndex(itemID);
      this.SetLastUsedItem(itemID);
    } else {
      this.UnequipItem(equipAreaIndex, slotIndex);
      cyberwareType = TweakDBInterface.GetCName(ItemID.GetTDBID(itemID) + t".cyberwareType", n"");
      i = 0;
      while i < ArraySize(this.m_equipment.equipAreas[equipAreaIndex].equipSlots) {
        if Equals(cyberwareType, TweakDBInterface.GetCName(ItemID.GetTDBID(this.m_equipment.equipAreas[equipAreaIndex].equipSlots[i].itemID) + t".cyberwareType", n"type")) {
          this.UnequipItem(equipAreaIndex, i);
        };
        i += 1;
      };
    };
  };
  if Equals(equipArea.areaType, gamedataEquipmentArea.ArmsCW) {
    this.UnequipItem(equipAreaIndex, slotIndex);
  };
  this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID = itemID;
  transactionSystem = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  placementSlot = this.GetPlacementSlot(equipAreaIndex, slotIndex);
  if placementSlot == t"AttachmentSlots.WeaponRight" || placementSlot == t"AttachmentSlots.WeaponLeft" {
    weaponRecord = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(itemID));
    if IsDefined(weaponRecord) && IsDefined(weaponRecord.HolsteredItem()) {
      EquipmentSystemPlayerData.UpdateArmSlot(this.m_owner as PlayerPuppet, itemID, true);
    };
  };
  if placementSlot != t"AttachmentSlots.WeaponRight" && placementSlot != t"AttachmentSlots.WeaponLeft" && placementSlot != t"AttachmentSlots.Consumable" {
    if !transactionSystem.HasItemInSlot(this.m_owner, placementSlot, itemID) {
      transactionSystem.RemoveItemFromSlot(this.m_owner, placementSlot);
      transactionSystem.AddItemToSlot(this.m_owner, placementSlot, itemID);
    };
  };
  if Equals(RPGManager.GetItemRecord(itemID).ItemType().Type(), gamedataItemType.Clo_Feet) {
    audioEventFootwear = new AudioEvent();
    audioEventFootwear.eventName = n"equipFootwear";
    audioEventFootwear.nameData = RPGManager.GetItemRecord(itemID).MovementSound().AudioMovementName();
    this.m_owner.QueueEvent(audioEventFootwear);
  };
  audioEventFoley = new AudioEvent();
  audioEventFoley.eventName = n"equipItem";
  audioEventFoley.nameData = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).AppearanceName();
  this.m_owner.QueueEvent(audioEventFoley);
  paperdollEquipData.equipArea = this.m_equipment.equipAreas[equipAreaIndex];
  paperdollEquipData.equipped = ShouldDisplay_HG(itemID); // <- tweaks visibility here
  paperdollEquipData.placementSlot = placementSlot;
  paperdollEquipData.slotIndex = slotIndex;
  this.ApplyEquipGLPs(itemID);
  this.UpdateWeaponWheel();
  this.UpdateQuickWheel();
  this.UpdateEquipmentUIBB(paperdollEquipData);
  i = 0;
  while i < ArraySize(this.m_hotkeys) {
    if this.m_hotkeys[i].IsCompatible(itemData.GetItemType()) {
      this.AssignItemToHotkey(itemData.GetID(), this.m_hotkeys[i].GetHotkey());
    };
    i += 1;
  };
  EquipmentSystem.GetInstance(this.m_owner).Debug_FillESSlotData(slotIndex, this.m_equipment.equipAreas[equipAreaIndex].areaType, itemID, this.m_owner);
  if ItemID.IsValid(currentItem) && currentItem != itemID {
    transactionSystem.OnItemRemovedFromEquipmentSlot(this.m_owner, currentItem);
  };
  transactionSystem.OnItemAddedToEquipmentSlot(this.m_owner, itemID);
  if this.IsItemOfCategory(itemID, gamedataItemCategory.Cyberware) || Equals(equipArea.areaType, gamedataEquipmentArea.ArmsCW) {
    this.CheckCyberjunkieAchievement();
  };
  if EquipmentSystem.IsItemCyberdeck(itemID) {
    PlayerPuppet.ChacheQuickHackListCleanup(this.m_owner);
  };
}


// [VehicleComponent]

// Unequip head item on mount
@wrapMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  wrappedMethod(evt);

  let mounted_HG: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  if IsDefined(mounted_HG) {
    mounted_HG.QueueEvent(new ClearHeadGearSlotEvent());
  };
}

// Reequip head item on unmount
@wrapMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  wrappedMethod(evt);

  let mounted_HG: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  if IsDefined(mounted_HG) {
    mounted_HG.QueueEvent(new ReequipHeadGearSlotEvent());
  };
}


// [TakeOverControlSystem]

// Test bald head fix for hacked camera TPP view
@replaceMethod(TakeOverControlSystem)
private final const func EnablePlayerTPPRepresenation(enable: Bool) -> Void {
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  if IsDefined(player) {
    if enable {
      player.QueueEvent(new ActivateTPPRepresentationEvent());
      player.QueueEvent(new ClearHeadGearSlotEvent());
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(true);
      GameObjectEffectHelper.StartEffectEvent(player, n"camera_mask");
    } else {
      player.QueueEvent(new DeactivateTPPRepresentationEvent());
      player.QueueEvent(new ReequipHeadGearSlotEvent());
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(false);
      GameObjectEffectHelper.StopEffectEvent(player, n"camera_mask");
    };
  };
}


// [InteractiveDevice]

// Test bald head fix for mirror TPP view
@wrapMethod(InteractiveDevice)
protected cb func OnPerformedAction(evt: ref<PerformedAction>) -> Bool {
  wrappedMethod(evt);

  let playerPuppet_HG: ref<PlayerPuppet>;
  let actionName_HG: CName;
  playerPuppet_HG = (GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet);
  actionName_HG = evt.m_action.actionName;

  if IsDefined(playerPuppet_HG) && Equals(actionName_HG, n"ForceON") {
    playerPuppet_HG.QueueEvent(new ClearHeadGearSlotEvent());
  } else {
    if IsDefined(playerPuppet_HG) && Equals(actionName_HG, n"ForceOFF") {
      playerPuppet_HG.QueueEvent(new ReequipHeadGearSlotEvent());
    };
  };
}

// --- UTILS

public static func IsTppHead_HG(itemId: ItemID) -> Bool {
  return Equals(ItemID.GetTDBID(itemId), t"Items.PlayerMaTppHead") || Equals(ItemID.GetTDBID(itemId), t"Items.PlayerWaTppHead");
}

public static func ShouldDisplay_HG(itemId: ItemID) -> Bool {
  return !ShouldHideItem_HG(itemId) || IsTppHead_HG(itemId);
}

public static func ShouldHide_HG(itemId: ItemID) -> Bool {
  return ShouldHideItem_HG(itemId) && !IsTppHead_HG(itemId);
}


// --- TESTING

// public static func PrintPlayerStats(where: String, object: ref<GameObject>) -> Void {
//   let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(object.GetGame());
//   let armorValue: Float = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.Armor);
//   let critChance: Float = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritChance);
//   let critDamage: Float = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritDamage);
//   LogChannel(n"DEBUG", "Stats from " + where + " - armor: " + FloatToString(armorValue) + ", crit chance: " + FloatToString(critChance) + ", crit damage: " + FloatToString(critDamage));
// }

// @wrapMethod(PlayerPuppet)
// protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
//   wrappedMethod(action, consumer);
//   PrintPlayerStats("NOW", this);
// }
