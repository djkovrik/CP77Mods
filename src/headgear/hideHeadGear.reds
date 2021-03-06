// -- UTILS
public static func L(str: String) -> Void {
  // Log("> " + str);
}

public static func I(str: String) -> Void {
  Log("! " + str);
}

public static func ToStr(itemId: ItemID) -> String {
  return TDBID.ToStringDEBUG(ItemID.GetTDBID(itemId));
}

public static func ItemDump(itemId: ItemID) -> String {
  return "IsHeadGear: " +  IsHeadGear(itemId) + ", IsTppHead: " + IsTppHead(itemId) + ", id: " + ToStr(itemId);
}

public static func IsTppHead(itemId: ItemID) -> Bool {
  return Equals(ItemID.GetTDBID(itemId), t"Items.PlayerMaTppHead") || Equals(ItemID.GetTDBID(itemId), t"Items.PlayerWaTppHead");
}

public static func IsHeadGear(itemId: ItemID) -> Bool {
  return Equals(EquipmentSystem.GetEquipAreaType(itemId), gamedataEquipmentArea.Head);
}

public static func ShouldBeDisplayed(itemId: ItemID) -> Bool {
  return !IsHeadGear(itemId) || IsTppHead(itemId);
}

public static func ShouldBeHidden(itemId: ItemID) -> Bool {
  return IsHeadGear(itemId) && !IsTppHead(itemId);
}

public static func PrintPlayerStats(where: String, object: ref<GameObject>) -> Void {
  let statsSystem: ref<StatsSystem>;
  let armorValue: Float;
  let critChance: Float;
  let critDamage: Float;
  statsSystem = GameInstance.GetStatsSystem(object.GetGame());
  armorValue = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.Armor);
  critChance = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritChance);
  critDamage = statsSystem.GetStatValue(Cast(object.GetEntityID()), gamedataStatType.CritDamage);
  I("Stats at " + where + " - armor: " + FloatToString(armorValue) + ", crit chance: " + FloatToString(critChance)+ ", crit damage: " + FloatToString(critDamage));
}


// -- EquipmentSystemPlayerData

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
    };
  };

  // Forced ClearItemAppearanceEvent for head slot
  if ShouldBeHidden(itemID) {
    this.ClearItemAppearanceEvent(gamedataEquipmentArea.Head);
  };
}

@replaceMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt addToInventory: Bool, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
  L("EquipItem - " + ItemDump(itemID));
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
  paperdollEquipData.equipped = ShouldBeDisplayed(itemID); // <- tweaks visibility here
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

// Tweak IsItemHidden to check headgear
@replaceMethod(EquipmentSystemPlayerData)
public final func IsItemHidden(id: ItemID) -> Bool {
  return ArrayContains(this.m_hiddenItems, id) || ShouldBeHidden(id);
}


// -- GameObject

// Clear head item slot to fix TPP hair displaying
@addMethod(GameObject)
public func ClearHeadGearSlot() -> Void {
  let transactionSystem: ref<TransactionSystem>;
  transactionSystem = GameInstance.GetTransactionSystem(this.GetGame());
  transactionSystem.RemoveItemFromSlot(this, t"AttachmentSlots.Head");
}

// Reequip headgear item
@addMethod(GameObject)
public func ReequipHeadGear() -> Void {
  let equipmentSystem: ref<EquipmentSystemPlayerData>;
  let activeItemId: ItemID;
  let unequipRequest: ref<UnequipRequest>;
  let equipRequest: ref<EquipRequest>;

  equipmentSystem = EquipmentSystem.GetData(GetPlayer(this.GetGame()));
  activeItemId = equipmentSystem.GetActiveItem(gamedataEquipmentArea.Head);

  if NotEquals(activeItemId, null) {    
    L("Detected head item: " + ToStr(activeItemId));
    
    unequipRequest = new UnequipRequest();
    unequipRequest.slotIndex = 0;
    unequipRequest.areaType = gamedataEquipmentArea.Head;
    equipmentSystem.OnUnequipRequest(unequipRequest);

    equipRequest = new EquipRequest();
    equipRequest.slotIndex = 0;
    equipRequest.itemID = activeItemId;
    equipmentSystem.OnEquipRequest(equipRequest);
  };
}


// -- PlayerPuppet

// Tweak visibility
@replaceMethod(PlayerPuppet)
protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
  L("OnItemAddedToSlot - " + ItemDump(evt.GetItemID()));
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
      paperdollEquipData.equipped = ShouldBeDisplayed(itemID); // <- tweaks visibility here
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

// Reequip headgear to make sure that all stats and mods applied
@replaceMethod(PlayerPuppet)
protected cb func OnMakePlayerVisibleAfterSpawn(evt: ref<EndGracePeriodAfterSpawn>) -> Bool {
  this.SetInvisible(false);
  GameInstance.GetGodModeSystem(this.GetGame()).RemoveGodMode(this.GetEntityID(), gameGodModeType.Invulnerable, n"GracePeriodAfterSpawn");
  this.ReequipHeadGear();
  PrintPlayerStats("OnMakePlayerVisibleAfterSpawn", this);
}

// -- inkMotorcycleHUDGameController

// Clears head slot when mounted to vehicle, should fix TPP bald head
@replaceMethod(inkMotorcycleHUDGameController)
protected cb func OnVehicleMounted() -> Bool {
  let playerPuppet: wref<PlayerPuppet>;
  let vehicle: wref<VehicleObject>;
  let shouldConnect: Bool;
  let bbSys: ref<BlackboardSystem>;
  this.m_fluffBlinking = new inkAnimController();
  this.m_fluffBlinking.Select(this.m_lowerfluff_L).Select(this.m_lowerfluff_R).Interpolate(n"transparency", ToVariant(0.25), ToVariant(1.00)).Duration(0.50).Interpolate(n"transparency", ToVariant(1.00), ToVariant(0.25)).Delay(0.55).Duration(0.50).Type(inkanimInterpolationType.Linear).Mode(inkanimInterpolationMode.EasyIn);
  playerPuppet = this.GetOwnerEntity() as PlayerPuppet;
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

  playerPuppet.ClearHeadGearSlot();
}

// Reequips headgear when unmounted
@replaceMethod(inkMotorcycleHUDGameController)
protected cb func OnVehicleUnmounted() -> Bool {
  let playerPuppet: wref<PlayerPuppet>;
  playerPuppet = this.GetOwnerEntity() as PlayerPuppet;
  if NotEquals(this.m_vehicleBlackboard, null) {
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.VehicleState, this.m_vehicleBBStateConectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this.m_speedBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.GearValue, this.m_gearBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.RPMValue, this.m_rpmValueBBConnectionId);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.BikeTilt, this.m_leanAngleBBConnectionId);
    this.m_activeVehicleUIBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.m_tppBBConnectionId);
    this.m_activeVehicleUIBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.VehPlayerStateData, this.m_playerStateBBConnectionId);
  };

  playerPuppet.ReequipHeadGear();
}


// -- TakeOverControlSystem

// Test fix bald head for hacked camera TPP view
@replaceMethod(TakeOverControlSystem)
private final const func EnablePlayerTPPRepresenation(enable: Bool) -> Void {
  let player: ref<PlayerPuppet>;
  player = (GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet);
  if NotEquals(player, null) {
    if enable {
      player.QueueEvent(new ActivateTPPRepresentationEvent());
      player.ClearHeadGearSlot();
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(true);
      GameObject.StartEffectEvent(player, n"camera_mask");
    } else {
      player.QueueEvent(new DeactivateTPPRepresentationEvent());
      player.ReequipHeadGear();
      GameInstance.GetAudioSystem(this.GetGameInstance()).SetBDCameraListenerOverride(false);
      GameObject.StopEffectEvent(player, n"camera_mask");
    };
  };
}

// Test fix bald head for mirror TPP view
@replaceMethod(InteractiveDevice)
protected cb func OnPerformedAction(evt: ref<PerformedAction>) -> Bool {
  let playerPuppet: ref<PlayerPuppet>;
  let actionName: CName;
  let currentContext: GetActionsContext;
  let sDeviceAction: ref<ScriptableDeviceAction>;
  super.OnPerformedAction(evt);
  sDeviceAction = (evt.m_action as ScriptableDeviceAction);
  if NotEquals(sDeviceAction, null) && this.GetDevicePS().HasActiveContext(gamedeviceRequestType.Direct) || this.GetDevicePS().HasActiveContext(gamedeviceRequestType.Remote) {
    currentContext = this.GetDevicePS().GenerateContext(sDeviceAction.GetRequestType(), Device.GetInteractionClearance(), sDeviceAction.GetExecutor());
    this.DetermineInteractionState(currentContext);
  };

  playerPuppet = (GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet);
  actionName = evt.m_action.actionName;

  if NotEquals(playerPuppet, null) && Equals(actionName, n"ForceON") {
    L("Device activated ");
    playerPuppet.ClearHeadGearSlot();
  } else {
    if NotEquals(playerPuppet, null) && Equals(actionName, n"ForceOFF") {
      L("Device deactivated");
      playerPuppet.ReequipHeadGear();
    };
  };
}


// HARDCORE STATS TESTING: constantly prints player stats to the game log

// @replaceMethod(PlayerPuppet)
// protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
//   if GameInstance.GetRuntimeInfo(this.GetGame()).IsMultiplayer() || GameInstance.GetPlayerSystem(this.GetGame()).IsCPOControlSchemeForced() {
//     this.OnActionMultiplayer(action, consumer);
//   };
//   if Equals(ListenerAction.GetName(action), n"IconicCyberware") && Equals(ListenerAction.GetType(action), this.DeductGameInputActionType()) && !this.CanCycleLootData() {
//     this.ActivateIconicCyberware();
//   } else {
//     if !GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_PlayerStats).GetBool(GetAllBlackboardDefs().UI_PlayerStats.isReplacer) && Equals(ListenerAction.GetName(action), n"CallVehicle") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
//       this.ProcessCallVehicleAction(ListenerAction.GetType(action));
//     };
//   };

//   PrintPlayerStats("NOW", this);
// }
