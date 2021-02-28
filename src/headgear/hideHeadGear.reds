@replaceMethod(EquipmentSystemPlayerData)
public final func OnEquipProcessVisualTags(itemID: ItemID) -> Void {
  let itemEntity: wref<GameObject>;
  let transactionSystem: ref<TransactionSystem>;
  let areaType: gamedataEquipmentArea;
  let i: Int32;
  let tag: CName;
  transactionSystem = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  itemEntity = transactionSystem.GetItemInSlotByItemID(this.m_owner, itemID);
  areaType = EquipmentSystem.GetEquipAreaType(itemID);

  tag = this.GetVisualTagByAreaType(areaType);
  if NotEquals(tag, n"") && this.IsVisualTagActive(tag) {
    this.ClearItemAppearanceEvent(areaType);
  } else {
    if NotEquals(itemEntity, null) {
      i = 0;
      while i < ArraySize(this.m_clothingSlotsInfo) {
        if transactionSystem.MatchVisualTag(itemEntity, this.m_clothingSlotsInfo[i].visualTag, true) && !transactionSystem.IsSlotEmpty(this.m_owner, this.m_clothingSlotsInfo[i].equipSlot) {
          this.ClearItemAppearanceEvent(this.m_clothingSlotsInfo[i].areaType);
        };
        i += 1;
      };
      if Equals(areaType, gamedataEquipmentArea.OuterChest) && this.IsPartialVisualTagActive(itemID, transactionSystem) {
        this.m_isPartialVisualTagActive = true;
        this.UpdateInnerChest(transactionSystem);
      };
      if !this.IsUnderwearHidden() || Equals(areaType, gamedataEquipmentArea.UnderwearBottom) && ItemID.IsValid(this.GetActiveItem(gamedataEquipmentArea.Legs)) || this.IsVisualTagActive(n"hide_L1") {
        this.ClearItemAppearanceEvent(gamedataEquipmentArea.UnderwearBottom);
      };
      if this.IsBuildCensored() && !this.IsUnderwearTopHidden() || Equals(areaType, gamedataEquipmentArea.UnderwearTop) && ItemID.IsValid(this.GetActiveItem(gamedataEquipmentArea.InnerChest)) || this.IsVisualTagActive(n"hide_T1") {
        this.ClearItemAppearanceEvent(gamedataEquipmentArea.UnderwearTop);
      };
      // Clear if equipped to head slot
      if Equals(areaType, gamedataEquipmentArea.Head) {
         this.ClearItemAppearanceEvent(gamedataEquipmentArea.Head);
      };
    };
  };
}

@replaceMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt addToInventory: Bool, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  let i: Int32;
  let equipAreaIndex: Int32;
  let equipArea: SEquipArea;
  let transactionSystem: ref<TransactionSystem>;
  let placementSlot: TweakDBID;
  let packages: array<wref<GameplayLogicPackage_Record>>;
  let holsterItemID: ItemID;
  let weaponRecord: ref<WeaponItem_Record>;
  let itemEntity: wref<ItemObject>;
  let paperdollEquipData: SPaperdollEquipData;
  let audioEventFootwear: ref<AudioEvent>;
  let audioEventFoley: ref<AudioEvent>;
  let itemData: wref<gameItemData>;
  let cyberwareType: CName;
  let currentItem: ItemID;
  let currentItemData: wref<gameItemData>;
  itemData = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, itemID);
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
  if NotEquals(currentItemData, null) && currentItemData.HasTag(n"UnequipBlocked") {
    return ;
  };
  if this.IsItemOfCategory(itemID, gamedataItemCategory.Weapon) && equipArea.activeIndex == slotIndex && this.CheckWeaponAgainstGameplayRestrictions(itemID) && !blockActiveSlotsUpdate {
    this.SetSlotActiveItem(EquipmentManipulationRequestSlot.Right, itemID);
    this.SetLastUsedItem(itemID);
  } else {
    if this.IsItemOfCategory(itemID, gamedataItemCategory.Weapon) && forceEquipWeapon && this.CheckWeaponAgainstGameplayRestrictions(itemID) {
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
    if NotEquals(weaponRecord, null) && NotEquals(weaponRecord.HolsteredItem(), null) {
      EquipmentSystemPlayerData.UpdateArmSlot((this.m_owner as PlayerPuppet), itemID, true);
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
  paperdollEquipData.equipped = NotEquals(this.m_equipment.equipAreas[equipAreaIndex].areaType, gamedataEquipmentArea.Head) ; // handle visibility
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
  transactionSystem.OnItemAddedToEquipmentSlot(this.m_owner, itemID);
  if this.IsItemOfCategory(itemID, gamedataItemCategory.Cyberware) {
    this.CheckCyberjunkieAchievement();
  };
}

@replaceMethod(PlayerPuppet)
protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
  let newApp: CName;
  let itemTDBID: TweakDBID;
  let paperdollEquipData: SPaperdollEquipData;
  let equipmentData: ref<EquipmentSystemPlayerData>;
  let equipmentBB: ref<IBlackboard>;
  let equipSlot: SEquipSlot;
  let itemType: gamedataItemCategory;
  let itemRecord: ref<Item_Record>;
  let itemID: ItemID;
  let slotID: TweakDBID;
  itemID = evt.GetItemID();
  itemTDBID = ItemID.GetTDBID(itemID);
  itemRecord = TweakDBInterface.GetItemRecord(itemTDBID);
  slotID = evt.GetSlotID();
  if NotEquals(itemRecord, null) && NotEquals(itemRecord.ItemCategory(), null) {
    itemType = itemRecord.ItemCategory().Type();
  };
  if Equals(itemType, gamedataItemCategory.Weapon) {
    newApp = TweakDBInterface.GetCName(itemTDBID + t".specific_player_appearance", n"");
    if NotEquals(newApp, n"") {
      GameInstance.GetTransactionSystem(this.GetGame()).ChangeItemAppearance(this, itemID, newApp);
    };
    if slotID == t"AttachmentSlots.WeaponRight" {
      paperdollEquipData.equipArea.areaType = TweakDBInterface.GetItemRecord(itemTDBID).EquipArea().Type();
      paperdollEquipData.equipArea.activeIndex = 0;
      equipSlot.itemID = itemID;
      ArrayPush(paperdollEquipData.equipArea.equipSlots, equipSlot);
      paperdollEquipData.equipped = NotEquals(paperdollEquipData.equipArea.areaType, gamedataEquipmentArea.Head); // handle visibility
      paperdollEquipData.placementSlot = EquipmentSystem.GetPlacementSlot(itemID);
      equipmentBB = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_Equipment);
      if NotEquals(equipmentBB, null) {
        equipmentBB.SetVariant(GetAllBlackboardDefs().UI_Equipment.lastModifiedArea, ToVariant(paperdollEquipData));
      };
    };
  } else {
    if Equals(itemType, gamedataItemCategory.Clothing) {
      equipmentData = EquipmentSystem.GetData(GetPlayer(this.GetGame()));
      if NotEquals(equipmentData, null) {
        equipmentData.OnEquipProcessVisualTags(itemID);
      };
    };
  };
  if slotID == t"AttachmentSlots.WeaponRight" || slotID == t"AttachmentSlots.WeaponLeft" {
    EquipmentSystemPlayerData.UpdateArmSlot(this, evt.GetItemID(), false);
  };
  super.OnItemAddedToSlot(evt);
}

@replaceMethod(EquipmentSystemPlayerData)
private final func ResetItemAppearance(transactionSystem: ref<TransactionSystem>, area: gamedataEquipmentArea) -> Void {
  let paperdollEquipData: SPaperdollEquipData;
  let equipAreaIndex: Int32;
  let slotIndex: Int32;
  let resetItemID: ItemID;
  resetItemID = this.GetActiveItem(area);
  equipAreaIndex = this.GetEquipAreaIndex(area);
  slotIndex = this.GetSlotIndex(resetItemID);
  paperdollEquipData.equipArea = this.m_equipment.equipAreas[equipAreaIndex];
  paperdollEquipData.equipped = NotEquals(this.m_equipment.equipAreas[equipAreaIndex].areaType, gamedataEquipmentArea.Head); // handle visibility
  paperdollEquipData.placementSlot = this.GetPlacementSlot(equipAreaIndex, slotIndex);
  paperdollEquipData.slotIndex = slotIndex;
  this.UpdateEquipmentUIBB(paperdollEquipData);
  transactionSystem.ResetItemAppearance(this.m_owner, resetItemID);
}

@replaceMethod(EquipmentSystem)
private final const func GetHairSuffix(itemId: ItemID, owner: wref<GameObject>, suffixRecord: ref<ItemsFactoryAppearanceSuffixBase_Record>) -> String {
  Log("--- GetHairSuffix");
  let customizationState: ref<gameuiICharacterCustomizationState>;
  let characterCustomizationSystem: ref<gameuiICharacterCustomizationSystem>;
  let isMountedToVehicle: Bool;
  characterCustomizationSystem = GameInstance.GetCharacterCustomizationSystem(owner.GetGame());
  isMountedToVehicle = VehicleComponent.IsMountedToVehicle(owner.GetGame(), owner.GetEntityID());
  
  // Dirty hack #1: break hair suffux for vehicle TPP view to fix hair displaying, armor stats not working if mounted
  if isMountedToVehicle {
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

// Dirty hack #2: equip/unequip head item on mount/dismount to fix hair displaying
@addField(PlayerPuppet)
let m_shouldTrackHeadItem: Bool;

@addField(PlayerPuppet)
let m_trackedHeadItemId: ItemID;

@addMethod(PlayerPuppet)
public func UnequipHeadItem() -> Void {
  let equipmentSystem: ref<EquipmentSystemPlayerData>;
  let activeItemId: ItemID;

  if EquipmentSystem.HasItemInArea(this, gamedataEquipmentArea.Head) {
    equipmentSystem = EquipmentSystem.GetData(GetPlayer(this.GetGame()));
    activeItemId = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Head);
    equipmentSystem.UnequipItem(activeItemId);
    this.m_trackedHeadItemId = activeItemId;
    this.m_shouldTrackHeadItem = true;
  };
}

@addMethod(PlayerPuppet)
public func EquipHeadItem() -> Void {
  let equipmentSystem: ref<EquipmentSystemPlayerData>;

  if NotEquals(this.m_trackedHeadItemId, null) && this.m_shouldTrackHeadItem {
    equipmentSystem = EquipmentSystem.GetData(GetPlayer(this.GetGame()));
    equipmentSystem.EquipItem(this.m_trackedHeadItemId);
    this.m_shouldTrackHeadItem = false;
  };
}

@replaceMethod(inkMotorcycleHUDGameController)
protected cb func OnVehicleMounted() -> Bool {
  Log("-- OnVehicleMounted");
  let playerPuppet: wref<PlayerPuppet>;
  let vehicle: wref<VehicleObject>;
  let shouldConnect: Bool;
  let bbSys: ref<BlackboardSystem>;
  this.m_fluffBlinking = new inkAnimController();
  this.m_fluffBlinking.Select(this.m_lowerfluff_L).Select(this.m_lowerfluff_R).Interpolate(n"transparency", ToVariant(0.25), ToVariant(1.00)).Duration(0.50).Interpolate(n"transparency", ToVariant(1.00), ToVariant(0.25)).Delay(0.55).Duration(0.50).Type(inkanimInterpolationType.Linear).Mode(inkanimInterpolationMode.EasyIn);
  playerPuppet = (this.GetOwnerEntity() as PlayerPuppet);
  vehicle = GetMountedVehicle(playerPuppet);
  bbSys = GameInstance.GetBlackboardSystem(playerPuppet.GetGame());
  if shouldConnect {
    this.m_vehicleBlackboard = vehicle.GetBlackboard();
    this.m_activeVehicleUIBlackboard = bbSys.Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
  };
  if NotEquals(this.m_vehicleBlackboard, null) {
    this.m_vehicleBBStateConectionId = this.m_vehicleBlackboard.RegisterListenerInt(GetAllBlackboardDefs().Vehicle.VehicleState, this, n"OnVehicleStateChanged");
    this.m_speedBBConnectionId = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnSpeedValueChanged");
    this.m_gearBBConnectionId = this.m_vehicleBlackboard.RegisterListenerInt(GetAllBlackboardDefs().Vehicle.GearValue, this, n"OnGearValueChanged");
    this.m_rpmValueBBConnectionId = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.RPMValue, this, n"OnRpmValueChanged");
    this.m_leanAngleBBConnectionId = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.BikeTilt, this, n"OnLeanAngleChanged");
    this.m_tppBBConnectionId = this.m_activeVehicleUIBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this, n"OnCameraModeChanged");
    this.m_playerStateBBConnectionId = this.m_activeVehicleUIBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.VehPlayerStateData, this, n"OnPlayerStateChanged");
  };

  playerPuppet.UnequipHeadItem();
}

@replaceMethod(inkMotorcycleHUDGameController)
protected cb func OnVehicleUnmounted() -> Bool {
  Log("-- OnVehicleUnmounted");
  let playerPuppet: wref<PlayerPuppet>;
  playerPuppet = (this.GetOwnerEntity() as PlayerPuppet);
  if NotEquals(this.m_vehicleBlackboard, null) {
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.VehicleState, this.m_vehicleBBStateConectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this.m_speedBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.GearValue, this.m_gearBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.RPMValue, this.m_rpmValueBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.BikeTilt, this.m_leanAngleBBConnectionId);
    this.m_activeVehicleUIBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.m_tppBBConnectionId);
    this.m_activeVehicleUIBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.VehPlayerStateData, this.m_playerStateBBConnectionId);
  };

  playerPuppet.EquipHeadItem();
}
