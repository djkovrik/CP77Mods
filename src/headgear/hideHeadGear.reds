// -- Determines what equipment slots should have hidden gear

// -- To hide gear for chosen slot just uncomment slot line
//    (by removing that doubled slash symbol from the start of the line)
public static func ShouldHideSlot_HG(itemId: ItemID) -> Bool {
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


// -- EquipmentSystemPlayerData

@wrapMethod(EquipmentSystemPlayerData)
public final func OnEquipProcessVisualTags(itemID: ItemID) -> Void {
  wrappedMethod(itemID);

  // Forced ClearItemAppearanceEvent if hidden
  let equipArea_HG: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);
  if ShouldBeHidden_HG(itemID) {
    this.ClearItemAppearanceEvent(equipArea_HG);
  };
}

@replaceMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt addToInventory: Bool, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  let audioEventFoley: ref<AudioEvent>;
  let audioEventFootwear: ref<AudioEvent>;
  let currentItem: ItemID;
  let currentItemData: wref<gameItemData>;
  let cyberwareType: CName;
  let equipArea: SEquipArea;
  let equipAreaIndex: Int32;
  let holsterItemID: ItemID;
  let i: Int32;
  let itemEntity: wref<ItemObject>;
  let packages: array<wref<GameplayLogicPackage_Record>>;
  let paperdollEquipData: SPaperdollEquipData;
  let placementSlot: TweakDBID;
  let transactionSystem: ref<TransactionSystem>;
  let weaponRecord: ref<WeaponItem_Record>;
  let itemData: wref<gameItemData> = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, itemID);
  if !this.IsEquippable(itemData) {
    return ;
  };
  if Equals(RPGManager.GetItemRecord(itemID).ItemType().Type(), gamedataItemType.Cyb_StrongArms) {
    this.HandleStrongArmsEquip(itemID);
  };
  equipAreaIndex = this.GetEquipAreaIndex(EquipmentSystem.GetEquipAreaType(itemID));
  equipArea = this.m_equipment.equipAreas[equipAreaIndex];
  currentItem = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;
  currentItemData = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, currentItem);
  if IsDefined(currentItemData) && currentItemData.HasTag(n"UnequipBlocked") {
    return ;
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
  paperdollEquipData.equipped = ShouldBeDisplayed_HG(itemID); // <- tweaks visibility here
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
  if this.IsItemOfCategory(itemID, gamedataItemCategory.Cyberware) {
    this.CheckCyberjunkieAchievement();
  };
}

// Tweak IsItemHidden to check headgear
@replaceMethod(EquipmentSystemPlayerData)
public final func IsItemHidden(id: ItemID) -> Bool {
  return ArrayContains(this.m_hiddenItems, id) || ShouldBeHidden_HG(id);
}


// -- GameObject

// Clear head item slot to fix TPP hair displaying
@addMethod(GameObject)
public func ClearHeadGearSlot_HG() -> Void {
  let transactionSystem: ref<TransactionSystem>;
  transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
  transactionSystem.RemoveItemFromSlot(this, t"AttachmentSlots.Head");
}

// Reequip headgear item
@addMethod(GameObject)
public func ReequipGear_HG(area: gamedataEquipmentArea) -> Void {
  let equipmentSystem: ref<EquipmentSystemPlayerData>;
  let activeItemId: ItemID;
  let slotIndex: Int32;
  let unequipRequest: ref<UnequipRequest>;
  let equipRequest: ref<EquipRequest>;

  equipmentSystem = EquipmentSystem.GetData(GetPlayer(this.GetGame()));
  activeItemId = equipmentSystem.GetActiveItem(area);
  slotIndex = equipmentSystem.GetSlotIndex(activeItemId, area);

  if NotEquals(equipmentSystem, null) && NotEquals(activeItemId, null) {    
    unequipRequest = new UnequipRequest();
    unequipRequest.slotIndex = slotIndex;
    unequipRequest.areaType = area;
    equipmentSystem.OnUnequipRequest(unequipRequest);

    equipRequest = new EquipRequest();
    equipRequest.slotIndex = slotIndex;
    equipRequest.itemID = activeItemId;
    equipmentSystem.OnEquipRequest(equipRequest);
  };
}


// -- EquipmentSystem

@replaceMethod(EquipmentSystem)
private final const func GetHairSuffix(itemId: ItemID, owner: wref<GameObject>, suffixRecord: ref<ItemsFactoryAppearanceSuffixBase_Record>) -> String {
  let customizationState: ref<gameuiICharacterCustomizationState>;
  let characterCustomizationSystem: ref<gameuiICharacterCustomizationSystem> = GameInstance.GetCharacterCustomizationSystem(owner.GetGame());
  // Dirty hack: break hair suffux for vehicle TPP view to fix hair displaying on save loading
  let playerPuppet_HG: ref<PlayerPuppet> = owner as PlayerPuppet;
  if IsDefined(playerPuppet_HG) && playerPuppet_HG.GetIsMounted_HG() {
    return "";
  };
  if (owner as PlayerPuppet) == null && !characterCustomizationSystem.HasCharacterCustomizationComponent(owner) {
    return "Bald";
  };
  customizationState = characterCustomizationSystem.GetState();
  if customizationState != null {
    if customizationState.HasTag(n"Short") {
      return "Short";
    };
    if customizationState.HasTag(n"Long") {
      return "Long";
    };
    if customizationState.HasTag(n"Dreads") {
      return "Dreads";
    };
    if customizationState.HasTag(n"Buzz") {
      return "Buzz";
    };
    return "Bald";
  };
  return "Error";
}


// -- PlayerPuppet

@addField(PlayerPuppet)
public let m_isMounted_HG: Bool;

@addMethod(PlayerPuppet)
public func SetIsMounted_HG(mounted: Bool) -> Void {
  this.m_isMounted_HG = mounted;
}

@addMethod(PlayerPuppet)
public func GetIsMounted_HG() -> Bool {
  return this.m_isMounted_HG;
}

// -- VehicleComponent

@wrapMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  wrappedMethod(evt);

  let mounted_HG: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  let player_HG: ref<PlayerPuppet>;
  if mounted_HG.IsPlayer() {
    player_HG = mounted_HG as PlayerPuppet;
    player_HG.ClearHeadGearSlot_HG();
    player_HG.SetIsMounted_HG(true);
  }
}

@wrapMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  wrappedMethod(evt);

  let mounted_HG: ref<GameObject> = GameInstance.FindEntityByID(this.GetVehicle().GetGame(), evt.request.lowLevelMountingInfo.childId) as GameObject;
  let player_HG: ref<PlayerPuppet>;
  if mounted_HG.IsPlayer() {
    player_HG = mounted_HG as PlayerPuppet;
    player_HG.ReequipGear_HG(gamedataEquipmentArea.Head);
    player_HG.SetIsMounted_HG(false);
  }
}

// -- TakeOverControlSystem

// Test fix bald head for hacked camera TPP view
@replaceMethod(TakeOverControlSystem)
private final const func EnablePlayerTPPRepresenation(enable: Bool) -> Void {
  let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  if IsDefined(player) {
    if enable {
      player.QueueEvent(new ActivateTPPRepresentationEvent());
      player.ClearHeadGearSlot_HG();
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(true);
      GameObject.StartEffectEvent(player, n"camera_mask");
    } else {
      player.QueueEvent(new DeactivateTPPRepresentationEvent());
      player.ReequipGear_HG(gamedataEquipmentArea.Head);
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(false);
      GameObject.StopEffectEvent(player, n"camera_mask");
    };
  };
}

// Test fix bald head for mirror TPP view
@wrapMethod(InteractiveDevice)
protected cb func OnPerformedAction(evt: ref<PerformedAction>) -> Bool {
  wrappedMethod(evt);

  let playerPuppet_HG: ref<PlayerPuppet>;
  let actionName_HG: CName;
  playerPuppet_HG = (GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet);
  actionName_HG = evt.m_action.actionName;

  if IsDefined(playerPuppet_HG) && Equals(actionName_HG, n"ForceON") {
    playerPuppet_HG.ClearHeadGearSlot_HG();
  } else {
    if IsDefined(playerPuppet_HG) && Equals(actionName_HG, n"ForceOFF") {
      playerPuppet_HG.ReequipGear_HG(gamedataEquipmentArea.Head);
    };
  };
}



// Utils
public static func IsTppHead_HG(itemId: ItemID) -> Bool {
  return Equals(ItemID.GetTDBID(itemId), t"Items.PlayerMaTppHead") || Equals(ItemID.GetTDBID(itemId), t"Items.PlayerWaTppHead");
}

public static func ShouldBeDisplayed_HG(itemId: ItemID) -> Bool {
  return !ShouldHideSlot_HG(itemId) || IsTppHead_HG(itemId);
}

public static func ShouldBeHidden_HG(itemId: ItemID) -> Bool {
  return ShouldHideSlot_HG(itemId) && !IsTppHead_HG(itemId);
}


// // TESTING
// @wrapMethod(PlayerPuppet)
// protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
//   wrappedMethod(action, consumer);
//   PrintPlayerStats("NOW", this);
// }

// public static func PrintPlayerStats(where: String, object: ref<GameObject>) -> Void {
//   let statsSystem: ref<StatsSystem>;
//   let armorValue: Float;
//   let critChance: Float;
//   let critDamage: Float;
//   statsSystem = GameInstance.GetStatsSystem(object.GetGame());
//   armorValue = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.Armor);
//   critChance = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritChance);
//   critDamage = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritDamage);
//   Log("Stats from " + where + " - armor: " + FloatToString(armorValue) + ", crit chance: " + FloatToString(critChance)+ ", crit damage: " + FloatToString(critDamage));
// }
